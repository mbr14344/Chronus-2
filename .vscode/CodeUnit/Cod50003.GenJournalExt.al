codeunit 50003 GenJournalExt
{
    EventSubscriberInstance = Manual;
    TableNo = "Gen. Journal Line";

    Procedure PostGenJournal(GenJnlLine: Record "Gen. Journal Line")

    begin
        Code(GenJnlLine);
    end;

    local procedure "Code"(var GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        FALedgEntry: Record "FA Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJnlPostviaJobQueue: Codeunit "Gen. Jnl.-Post via Job Queue";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        ConfirmManagement: Codeunit "Confirm Management";
        TempJnlBatchName: Code[10];
        HideDialog: Boolean;
        IsHandled: Boolean;
    begin
        HideDialog := false;


        GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
        if GenJnlTemplate.Type = GenJnlTemplate.Type::Jobs then begin
            SourceCodeSetup.Get();
            if GenJnlTemplate."Source Code" = SourceCodeSetup."Job G/L WIP" then
                Error(Text006, GenJnlTemplate.FieldCaption("Source Code"), GenJnlTemplate.TableCaption(),
                  SourceCodeSetup.FieldCaption("Job G/L WIP"), SourceCodeSetup.TableCaption());
        end;
        GenJnlTemplate.TestField("Force Posting Report", false);
        if GenJnlTemplate.Recurring and (GenJnlLine.GetFilter(GenJnlLine."Posting Date") <> '') then
            GenJnlLine.FieldError("Posting Date", Text000);


        IsHandled := false;
        if bSuppress = false then begin
            HideDialog := true;
            if not IsHandled then
                if not (PreviewMode or HideDialog) then
                    if not ConfirmManagement.GetResponseOrDefault(Text001, true) then
                        exit;
        end;


        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset" then begin
            FALedgEntry.SetRange("FA No.", GenJnlLine."Account No.");
            FALedgEntry.SetRange("FA Posting Type", FALedgEntry."FA Posting Type"::Depreciation);
            if FALedgEntry.FindFirst() and GenJnlLine."Depr. Acquisition Cost" and not HideDialog then
                if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text005, GenJnlLine.FieldCaption("Depr. Acquisition Cost")), true) then
                    exit;
        end;

        if not HideDialog then
            if not GenJnlPostBatch.ConfirmPostingUnvoidableChecks(GenJnlLine."Journal Batch Name", GenJnlLine."Journal Template Name") then
                exit;

        TempJnlBatchName := GenJnlLine."Journal Batch Name";

        GeneralLedgerSetup.Get();
        GenJnlPostBatch.SetPreviewMode(PreviewMode);
        if GeneralLedgerSetup."Post with Job Queue" and not PreviewMode then begin
            // Add job queue entry for each document no.
            GenJnlLine.SetCurrentKey("Document No.");
            while GenJnlLine.FindFirst() do begin
                GenJnlsScheduled := true;
                GenJnlPostviaJobQueue.EnqueueGenJrnlLineWithUI(GenJnlLine, false);
                GenJnlLine.SetFilter("Document No.", '>%1', GenJnlLine."Document No.");
            end;

            if GenJnlsScheduled then
                Message(JournalsScheduledMsg);
        end else begin
            IsHandled := false;

            if IsHandled then
                exit;

            GenJnlPostBatch.Run(GenJnlLine);

            if PreviewMode then
                exit;
            if bSuppress = false then
                ShowPostResultMessage(GenJnlLine, TempJnlBatchName);
        end;

        if not GenJnlLine.Find('=><') or (TempJnlBatchName <> GenJnlLine."Journal Batch Name") or GeneralLedgerSetup."Post with Job Queue" then begin
            GenJnlLine.Reset();
            GenJnlLine.FilterGroup(2);
            GenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
            GenJnlLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
            GenJnlLine.FilterGroup(0);
            GenJnlLine."Line No." := 1;
        end;
    end;

    local procedure ShowPostResultMessage(var GenJnlLine: Record "Gen. Journal Line"; TempJnlBatchName: Code[10])
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        if GenJnlLine."Line No." = 0 then
            Message(JournalErrorsMgt.GetNothingToPostErrorMsg())
        else
            if TempJnlBatchName = GenJnlLine."Journal Batch Name" then
                Message(Text003)
            else
                Message(
                Text004,
                GenJnlLine."Journal Batch Name");
    end;

    procedure SetSuppress(bValue: Boolean)
    begin
        bSuppress := bValue;
    end;

    procedure ApplyVendorEntries(InDocNo: Code[20]; VendorNo: Code[20]; PmtAppliesToID: Code[20])
    begin
        DocNo := InDocNo;
        GetVLE.RESET;
        GetVLE.SetRange("Document No.", InDocNo);
        IF NOT GetVLE.FindSet() then
            ERROR(STRSUBSTNO('No posted Early Payment Discounts found for %1', VendorNo))
        ELSE
            REPEAT
                ApplyVendEntryFormEntry(GetVLE, PmtAppliesToID);
            until GetVLE.NEXT = 0;
    end;

    procedure ApplyVendEntryFormEntry(var ApplyingVendLedgEntry: Record "Vendor Ledger Entry"; PmtAppliesToID: Code[20])
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        VendEntryApplID: Code[50];
        IsHandled: Boolean;
        Position: Integer;
        GetDocNo: Code[20];
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        if not ApplyingVendLedgEntry.Open then
            Error(CannotApplyClosedEntriesErr);


        VendEntryApplID := UserId;
        if VendEntryApplID = '' then
            VendEntryApplID := '***';
        if ApplyingVendLedgEntry."Remaining Amount" = 0 then
            ApplyingVendLedgEntry.CalcFields("Remaining Amount");

        ApplyingVendLedgEntry."Applying Entry" := true;
        if ApplyingVendLedgEntry."Applies-to ID" = '' then
            ApplyingVendLedgEntry."Applies-to ID" := VendEntryApplID;
        ApplyingVendLedgEntry."Amount to Apply" := ApplyingVendLedgEntry."Remaining Amount";
        CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit", ApplyingVendLedgEntry);
        Commit();

        //let's get the document no. to apply against
        Position := StrPos(ApplyingVendLedgEntry."External Document No.", '/');
        GetDocNo := CopyStr(ApplyingVendLedgEntry."External Document No.", Position + 1, StrLen(ApplyingVendLedgEntry."External Document No.") - Position);
        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
        VendLedgEntry.SetRange("Vendor No.", ApplyingVendLedgEntry."Vendor No.");
        VendLedgEntry.SetRange(Open, true);
        VendLedgEntry.SetRange("Document No.", GetDocNo);

        SetApplId(VendLedgEntry, ApplyingVendLedgEntry, UserId);
        SetApplId(VendLedgEntry, ApplyingVendLedgEntry, UserId);
        RunApplyVendEntries(VendLedgEntry, ApplyingVendLedgEntry, VendEntryApplID);
    end;


    procedure PostDirectApplication(PreviewMode: Boolean; var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        RecBeforeRunPostApplicationVendorLedgerEntry: Record "Vendor Ledger Entry";
        ApplyUnapplyParameters: Record "Apply Unapply Parameters";
        NewApplyUnapplyParameters: Record "Apply Unapply Parameters";
        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
        PostApplication: Page "Post Application";
        Applied: Boolean;
        ApplicationDate: Date;
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;
        GLSetup.Get();

        VendLedgEntry.CalcFields(Amount);


        if CalcType = CalcType::Direct then begin
            if VendLedgEntry."Entry No." <> 0 then begin
                ApplicationDate := VendEntryApplyPostedEntries.GetApplicationDate(VendLedgEntry);

                Clear(ApplyUnapplyParameters);

                ApplyUnapplyParameters.CopyFromVendLedgEntry(GetVLE);
                GLSetup.GetRecordOnce();
                ApplyUnapplyParameters."Posting Date" := ApplicationDate;
                if GLSetup."Journal Templ. Name Mandatory" then begin
                    GLSetup.TestField("Apply Jnl. Template Name");
                    GLSetup.TestField("Apply Jnl. Batch Name");
                    ApplyUnapplyParameters."Journal Template Name" := GLSetup."Apply Jnl. Template Name";
                    ApplyUnapplyParameters."Journal Batch Name" := GLSetup."Apply Jnl. Batch Name";
                end;
                PostApplication.SetParameters(ApplyUnapplyParameters);
                RecBeforeRunPostApplicationVendorLedgerEntry := GetVLE;

                NewApplyUnapplyParameters.Init();
                NewApplyUnapplyParameters := ApplyUnapplyParameters;
                NewApplyUnapplyParameters.Insert();


                if NewApplyUnapplyParameters."Posting Date" < ApplicationDate then
                    Error(ApplicationDateErr, GetVLE.FieldCaption("Posting Date"), GetVLE.TableCaption());

                NewApplyUnapplyParameters."Posting Date" := Today;
                NewApplyUnapplyParameters.Modify();
                if PreviewMode then
                    VendEntryApplyPostedEntries.PreviewApply(GetVLE, NewApplyUnapplyParameters)
                else
                    Applied := VendEntryApplyPostedEntries.Apply(GetVLE, NewApplyUnapplyParameters);

                if (not PreviewMode) and Applied then begin
                    PostingDone := true;
                end;
            end else
                Error(MustSelectEntryErr);
        end else
            Error(PostingInWrongContextErr);
    end;

    procedure SetApplId(var VendLedgEntry: Record "Vendor Ledger Entry"; ApplyingVendLedgEntry: Record "Vendor Ledger Entry"; AppliesToID: Code[50])
    var
        TempVendLedgEntry: Record "Vendor Ledger Entry" temporary;

    begin
        VendLedgEntry.LockTable();
        if VendLedgEntry.FindSet() then begin
            // Make Applies-to ID
            if VendLedgEntry."Applies-to ID" <> '' then
                VendEntryApplID := ''
            else begin
                VendEntryApplID := AppliesToID;
                if VendEntryApplID = '' then begin
                    VendEntryApplID := UserId;
                    if VendEntryApplID = '' then
                        VendEntryApplID := '***';
                end;
            end;
            repeat
                TempVendLedgEntry := VendLedgEntry;
                TempVendLedgEntry.Insert();
            until VendLedgEntry.Next() = 0;
        end;

        if TempVendLedgEntry.FindSet() then
            repeat
                UpdateVendLedgerEntry(TempVendLedgEntry, ApplyingVendLedgEntry, AppliesToID);
            until TempVendLedgEntry.Next() = 0;
    end;

    local procedure UpdateVendLedgerEntry(var TempVendLedgEntry: Record "Vendor Ledger Entry" temporary; ApplyingVendLedgEntry: Record "Vendor Ledger Entry"; AppliesToID: Code[50])
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        VendorLedgerEntry.Copy(TempVendLedgEntry);
        VendorLedgerEntry.TestField(Open, true);
        VendorLedgerEntry."Applies-to ID" := VendEntryApplID;
        if VendorLedgerEntry."Applies-to ID" = '' then begin
            VendorLedgerEntry."Accepted Pmt. Disc. Tolerance" := false;
            VendorLedgerEntry."Accepted Payment Tolerance" := 0;
        end;


        VendorLedgerEntry.CalcFields("Remaining Amount");
        if VendorLedgerEntry."Remaining Amount" <> 0 then
            VendorLedgerEntry."Amount to Apply" := ApplyingVendLedgEntry.Amount * -1;

        if VendorLedgerEntry."Entry No." = ApplyingVendLedgEntry."Entry No." then
            VendorLedgerEntry."Applying Entry" := ApplyingVendLedgEntry."Applying Entry";
        VendorLedgerEntry.Modify();

    end;


    var
        JournalErrorsMgt: Codeunit "Journal Errors Mgt.";
        JournalsScheduledMsg: Label 'Journal lines have been scheduled for posting.';
        Text000: Label 'cannot be filtered when posting recurring journals';
        Text001: Label 'Do you want to post the journal lines?';
        Text003: Label 'The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted. You are now in the %1 journal.';
        Text005: Label 'Using %1 for Declining Balance can result in misleading numbers for subsequent years. You should manually check the postings and correct them if necessary. Do you want to continue?';
        Text006: Label '%1 in %2 must not be equal to %3 in %4.', Comment = 'Source Code in Genenral Journal Template must not be equal to Job G/L WIP in Source Code Setup.';
        GenJnlsScheduled: Boolean;
        PreviewMode: Boolean;
        bSuppress: Boolean;
        GetVLE: Record "Vendor Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        ApplicationDateErr: Label 'The %1 entered must not be before the %1 on the %2.';
        ApplicationPostedMsg: Label 'The application was successfully posted.';
        MustSelectEntryErr: Label 'You must select an applying entry before you can post the application.';
        PostingDone: Boolean;
        PostingInWrongContextErr: Label 'You must post the application from the window where you entered the applying entry.';
        CalcType: Enum "Vendor Apply Calculation Type";

        VendEntryApplyPostEntries: Codeunit "VendEntry-Apply Posted Entries";
        CannotApplyClosedEntriesErr: Label 'One or more of the entries that you selected is closed. You cannot apply closed entries.';
        TempApplyingVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        DocNo: Code[20];
        VendEntryApplID: Code[20];

    local procedure RunApplyVendEntries(var VendLedgEntry: Record "Vendor Ledger Entry"; var ApplyingVendLedgEntry: Record "Vendor Ledger Entry"; VendEntryApplID: Code[50])
    var
        ApplyVendEntries: Page "Apply Vendor Entries";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if VendLedgEntry.FindFirst() then begin
            PostDirectApplication(false, VendLedgEntry);
        end;
    end;

}
