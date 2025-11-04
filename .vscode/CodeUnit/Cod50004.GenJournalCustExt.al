codeunit 50004 GenJournalCustExt
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

    procedure ApplyCustEntries(InDocNo: Code[20]; CustomerNo: Code[20]; PmtAppliesToID: Code[50]; invoiceDocNO: integer)
    begin
        DocNo := InDocNo;
        GetCLE.RESET;
        GetCLE.SetRange("Document No.", InDocNo);
        IF NOT GetCLE.FindSet() then
            ERROR(STRSUBSTNO('No posted Early Payment Discounts found for %1', CustomerNo))
        ELSE
            REPEAT
                ApplyCustEntryFormEntry(GetCLE, PmtAppliesToID, invoiceDocNO);
            until GetCLE.NEXT = 0;
    end;

    procedure ApplyCustEntryFormEntry(var ApplyingCustLedgEntry: Record "Cust. Ledger Entry"; PmtAppliesToID: Code[50]; invoiceDocNO: Integer)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustEntryApplID: Code[50];
        IsHandled: Boolean;
        Position: Integer;
        GetDocNo: Code[20];
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        if not ApplyingCustLedgEntry.Open then
            Error(CannotApplyClosedEntriesErr);


        CustEntryApplID := UserId;
        if CustEntryApplID = '' then
            CustEntryApplID := '***';
        if ApplyingCustLedgEntry."Remaining Amount" = 0 then
            ApplyingCustLedgEntry.CalcFields("Remaining Amount");

        ApplyingCustLedgEntry."Applying Entry" := true;
        if ApplyingCustLedgEntry."Applies-to ID" = '' then
            ApplyingCustLedgEntry."Applies-to ID" := CustEntryApplID;
        ApplyingCustLedgEntry."Amount to Apply" := ApplyingCustLedgEntry."Remaining Amount";
        CODEUNIT.Run(CODEUNIT::"Cust. Entry-Edit", ApplyingCustLedgEntry);
        Commit();

        //let's get the document no. to apply against
        Position := StrPos(ApplyingCustLedgEntry."External Document No.", '/');
        GetDocNo := CopyStr(ApplyingCustLedgEntry."External Document No.", Position + 1, StrLen(ApplyingCustLedgEntry."External Document No.") - Position);
        //CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
        // pr 7/9/24;
        CustLedgEntry.SetRange("Entry No.", invoiceDocNO);
        if (CustLedgEntry.FindFirst()) then begin
            // pr 7/10/24 - restores entries before being applied
            CustLedgEntry.Open := true;
            CustLedgEntry."Applies-to ID" := PmtAppliesToID;
            CustLedgEntry.Modify();
            SetApplId(CustLedgEntry, ApplyingCustLedgEntry, UserId);  //if Applies to ID exists, clear
            SetApplId(CustLedgEntry, ApplyingCustLedgEntry, UserId);  //now assign USERID as AppliesToID
            RunApplyCustEntries(CustLedgEntry, ApplyingCustLedgEntry, CustEntryApplID);
        end;
    end;


    procedure PostDirectApplication(PreviewMode: Boolean; var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        RecBeforeRunPostApplicationCustomerLedgerEntry: Record "Cust. Ledger Entry";
        ApplyUnapplyParameters: Record "Apply Unapply Parameters";
        NewApplyUnapplyParameters: Record "Apply Unapply Parameters";
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        PostApplication: Page "Post Application";
        Applied: Boolean;
        ApplicationDate: Date;
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;
        GLSetup.Get();

        CustLedgEntry.CalcFields(Amount);


        if CalcType = CalcType::Direct then begin
            if CustLedgEntry."Entry No." <> 0 then begin
                ApplicationDate := CustEntryApplyPostedEntries.GetApplicationDate(CustLedgEntry);

                Clear(ApplyUnapplyParameters);

                ApplyUnapplyParameters.CopyFromCustLedgEntry(GetCLE);
                GLSetup.GetRecordOnce();
                ApplyUnapplyParameters."Posting Date" := ApplicationDate;
                if GLSetup."Journal Templ. Name Mandatory" then begin
                    GLSetup.TestField("Apply Jnl. Template Name");
                    GLSetup.TestField("Apply Jnl. Batch Name");
                    ApplyUnapplyParameters."Journal Template Name" := GLSetup."Apply Jnl. Template Name";
                    ApplyUnapplyParameters."Journal Batch Name" := GLSetup."Apply Jnl. Batch Name";
                end;
                PostApplication.SetParameters(ApplyUnapplyParameters);
                RecBeforeRunPostApplicationCustomerLedgerEntry := GetCLE;

                NewApplyUnapplyParameters.Init();
                NewApplyUnapplyParameters := ApplyUnapplyParameters;
                NewApplyUnapplyParameters.Insert();


                if NewApplyUnapplyParameters."Posting Date" < ApplicationDate then
                    Error(ApplicationDateErr, GetCLE.FieldCaption("Posting Date"), GetCLE.TableCaption());

                NewApplyUnapplyParameters."Posting Date" := Today;
                NewApplyUnapplyParameters.Modify();
                if PreviewMode then
                    CustEntryApplyPostedEntries.PreviewApply(GetCLE, NewApplyUnapplyParameters)
                else
                    Applied := CustEntryApplyPostedEntries.Apply(GetCLE, NewApplyUnapplyParameters);

                if (not PreviewMode) and Applied then begin
                    PostingDone := true;
                end;
            end else
                Error(MustSelectEntryErr);
        end else
            Error(PostingInWrongContextErr);
    end;

    procedure SetApplId(var CustLedgEntry: Record "Cust. Ledger Entry"; ApplyingCustLedgEntry: Record "Cust. Ledger Entry"; AppliesToID: Code[50])
    var
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;

    begin
        CustLedgEntry.LockTable();
        if CustLedgEntry.FindSet() then begin
            // Make Applies-to ID
            if CustLedgEntry."Applies-to ID" <> '' then
                CustEntryApplID := ''
            else begin
                CustEntryApplID := AppliesToID;
                if CustEntryApplID = '' then begin
                    CustEntryApplID := UserId;
                    if CustEntryApplID = '' then
                        CustEntryApplID := '***';
                end;
            end;
            repeat
                TempCustLedgEntry := CustLedgEntry;
                TempCustLedgEntry.Insert();
            until CustLedgEntry.Next() = 0;
        end;

        if TempCustLedgEntry.FindSet() then
            repeat
                UpdateCustLedgerEntry(TempCustLedgEntry, ApplyingCustLedgEntry, AppliesToID);
            until TempCustLedgEntry.Next() = 0;
    end;

    local procedure UpdateCustLedgerEntry(var TempCustLedgEntry: Record "Cust. Ledger Entry" temporary; ApplyingCustLedgEntry: Record "Cust. Ledger Entry"; AppliesToID: Code[50])
    var
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        CustomerLedgerEntry.Copy(TempCustLedgEntry);
        CustomerLedgerEntry.TestField(Open, true);
        CustomerLedgerEntry."Applies-to ID" := CustEntryApplID;
        if CustomerLedgerEntry."Applies-to ID" = '' then begin
            CustomerLedgerEntry."Accepted Pmt. Disc. Tolerance" := false;
            CustomerLedgerEntry."Accepted Payment Tolerance" := 0;
        end;


        CustomerLedgerEntry.CalcFields("Remaining Amount");
        if CustomerLedgerEntry."Remaining Amount" <> 0 then
            CustomerLedgerEntry."Amount to Apply" := Abs(ApplyingCustLedgEntry.Amount);

        if CustomerLedgerEntry."Entry No." = ApplyingCustLedgEntry."Entry No." then
            CustomerLedgerEntry."Applying Entry" := ApplyingCustLedgEntry."Applying Entry";
        CustomerLedgerEntry.Modify();

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
        GetCLE: Record "Cust. Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        ApplicationDateErr: Label 'The %1 entered must not be before the %1 on the %2.';
        ApplicationPostedMsg: Label 'The application was successfully posted.';
        MustSelectEntryErr: Label 'You must select an applying entry before you can post the application.';
        PostingDone: Boolean;
        PostingInWrongContextErr: Label 'You must post the application from the window where you entered the applying entry.';
        CalcType: Enum "Customer Apply Calculation Type";

        CustEntryApplyPostEntries: Codeunit "CustEntry-Apply Posted Entries";
        CannotApplyClosedEntriesErr: Label 'One or more of the entries that you selected is closed. You cannot apply closed entries.';
        TempApplyingCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        DocNo: Code[20];
        CustEntryApplID: Code[20];

    local procedure RunApplyCustEntries(var CustLedgEntry: Record "Cust. Ledger Entry"; var ApplyingCustLedgEntry: Record "Cust. Ledger Entry"; CustEntryApplID: Code[50])
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if CustLedgEntry.FindFirst() then begin
            PostDirectApplication(false, CustLedgEntry);
        end;
    end;

}


/*codeunit 50004 GenJournalCustExt
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

    procedure ApplyCustEntries(InDocNo: Code[20]; CustomerNo: Code[20]; PmtAppliesToID: Code[20])
    begin
        DocNo := InDocNo;
        GetCLE.RESET;
        GetCLE.SetRange("Document No.", InDocNo);
        IF NOT GetCLE.FindSet() then
            ERROR(STRSUBSTNO('No posted Early Payment Discounts found for %1', CustomerNo))
        ELSE
            REPEAT
                ApplyCustEntryFormEntry(GetCLE, PmtAppliesToID);
            until GetCLE.NEXT = 0;
    end;

    procedure ApplyCustEntryFormEntry(var ApplyingCustLedgEntry: Record "Cust. Ledger Entry"; PmtAppliesToID: Code[20])
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustEntryApplID: Code[50];
        IsHandled: Boolean;
        Position: Integer;
        GetDocNo: Code[35];
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        if not ApplyingCustLedgEntry.Open then
            Error(CannotApplyClosedEntriesErr);
        CustEntryApplID := UserId;
        if CustEntryApplID = '' then
            CustEntryApplID := '***';
        if ApplyingCustLedgEntry."Remaining Amount" = 0 then
            ApplyingCustLedgEntry.CalcFields("Remaining Amount");

        ApplyingCustLedgEntry."Applying Entry" := true;
        if ApplyingCustLedgEntry."Applies-to ID" = '' then
            ApplyingCustLedgEntry."Applies-to ID" := CustEntryApplID;
        ApplyingCustLedgEntry."Amount to Apply" := ApplyingCustLedgEntry."Remaining Amount";
        CODEUNIT.Run(CODEUNIT::"Cust. Entry-Edit", ApplyingCustLedgEntry);
        Commit();

        //let's get the document no. to apply against
        Position := StrPos(ApplyingCustLedgEntry."External Document No.", '/');
        GetDocNo := CopyStr(ApplyingCustLedgEntry."External Document No.", Position + 1, StrLen(ApplyingCustLedgEntry."External Document No.") - Position);
        CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
        CustLedgEntry.SetRange("Customer No.", ApplyingCustLedgEntry."Customer No.");
        CustLedgEntry.SetRange(Open, true);
        // CustLedgEntry.SetRange("Document No.", GetDocNo);
        // pr 7/5/24 - start 
        CustLedgEntry.SetRange("Document No.", GetDocNo);
        //SetApplId(CustLedgEntry, ApplyingCustLedgEntry, CustEntryApplID);
        // pr 7/5/24 - end
        SetApplId(CustLedgEntry, ApplyingCustLedgEntry, UserId);
        SetApplId(CustLedgEntry, ApplyingCustLedgEntry, UserId);
        RunApplyCustEntries(CustLedgEntry, ApplyingCustLedgEntry, CustEntryApplID);
    end;


    procedure PostDirectApplication(PreviewMode: Boolean; var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        RecBeforeRunPostApplicationCustomerLedgerEntry: Record "Cust. Ledger Entry";
        ApplyUnapplyParameters: Record "Apply Unapply Parameters";
        NewApplyUnapplyParameters: Record "Apply Unapply Parameters";
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        PostApplication: Page "Post Application";
        Applied: Boolean;
        ApplicationDate: Date;
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;
        GLSetup.Get();

        CustLedgEntry.CalcFields(Amount);


        if CalcType = CalcType::Direct then begin
            if CustLedgEntry."Entry No." <> 0 then begin
                ApplicationDate := CustEntryApplyPostedEntries.GetApplicationDate(CustLedgEntry);

                Clear(ApplyUnapplyParameters);

                ApplyUnapplyParameters.CopyFromCustLedgEntry(GetCLE);
                GLSetup.GetRecordOnce();
                ApplyUnapplyParameters."Posting Date" := ApplicationDate;
                if GLSetup."Journal Templ. Name Mandatory" then begin
                    GLSetup.TestField("Apply Jnl. Template Name");
                    GLSetup.TestField("Apply Jnl. Batch Name");
                    ApplyUnapplyParameters."Journal Template Name" := GLSetup."Apply Jnl. Template Name";
                    ApplyUnapplyParameters."Journal Batch Name" := GLSetup."Apply Jnl. Batch Name";
                end;
                PostApplication.SetParameters(ApplyUnapplyParameters);
                RecBeforeRunPostApplicationCustomerLedgerEntry := GetCLE;

                NewApplyUnapplyParameters.Init();
                NewApplyUnapplyParameters := ApplyUnapplyParameters;
                NewApplyUnapplyParameters.Insert();


                if NewApplyUnapplyParameters."Posting Date" < ApplicationDate then
                    Error(ApplicationDateErr, GetCLE.FieldCaption("Posting Date"), GetCLE.TableCaption());

                NewApplyUnapplyParameters."Posting Date" := Today;
                NewApplyUnapplyParameters.Modify();
                if PreviewMode then
                    CustEntryApplyPostedEntries.PreviewApply(GetCLE, NewApplyUnapplyParameters)
                else
                    Applied := CustEntryApplyPostedEntries.Apply(GetCLE, NewApplyUnapplyParameters);

                if (not PreviewMode) and Applied then begin
                    PostingDone := true;
                end;
            end else
                Error(MustSelectEntryErr);
        end else
            Error(PostingInWrongContextErr);
    end;

    procedure SetApplId(var CustLedgEntry: Record "Cust. Ledger Entry"; ApplyingCustLedgEntry: Record "Cust. Ledger Entry"; AppliesToID: Code[50])
    var
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;

    begin
        CustLedgEntry.LockTable();
        if CustLedgEntry.FindSet() then begin
            // Make Applies-to ID
            if CustLedgEntry."Applies-to ID" <> '' then
                CustEntryApplID := ''
            else begin
                CustEntryApplID := AppliesToID;
                if CustEntryApplID = '' then begin
                    CustEntryApplID := UserId;
                    if CustEntryApplID = '' then
                        CustEntryApplID := '***';
                end;
            end;
            repeat
                TempCustLedgEntry := CustLedgEntry;
                TempCustLedgEntry.Insert();
            until CustLedgEntry.Next() = 0;
        end;

        if TempCustLedgEntry.FindSet() then
            repeat
                UpdateCustLedgerEntry(TempCustLedgEntry, ApplyingCustLedgEntry, AppliesToID);
            until TempCustLedgEntry.Next() = 0;
    end;

    local procedure UpdateCustLedgerEntry(var TempCustLedgEntry: Record "Cust. Ledger Entry" temporary; ApplyingCustLedgEntry: Record "Cust. Ledger Entry"; AppliesToID: Code[50])
    var
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        CustomerLedgerEntry.Copy(TempCustLedgEntry);
        CustomerLedgerEntry.TestField(Open, true);
        CustomerLedgerEntry."Applies-to ID" := CustEntryApplID;
        if CustomerLedgerEntry."Applies-to ID" = '' then begin
            CustomerLedgerEntry."Accepted Pmt. Disc. Tolerance" := false;
            CustomerLedgerEntry."Accepted Payment Tolerance" := 0;
        end;


        CustomerLedgerEntry.CalcFields("Remaining Amount");
        if CustomerLedgerEntry."Remaining Amount" <> 0 then
            CustomerLedgerEntry."Amount to Apply" := Abs(ApplyingCustLedgEntry.Amount);

        if CustomerLedgerEntry."Entry No." = ApplyingCustLedgEntry."Entry No." then
            CustomerLedgerEntry."Applying Entry" := ApplyingCustLedgEntry."Applying Entry";
        CustomerLedgerEntry.Modify();

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
        GetCLE: Record "Cust. Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        ApplicationDateErr: Label 'The %1 entered must not be before the %1 on the %2.';
        ApplicationPostedMsg: Label 'The application was successfully posted.';
        MustSelectEntryErr: Label 'You must select an applying entry before you can post the application.';
        PostingDone: Boolean;
        PostingInWrongContextErr: Label 'You must post the application from the window where you entered the applying entry.';
        CalcType: Enum "Customer Apply Calculation Type";

        CustEntryApplyPostEntries: Codeunit "CustEntry-Apply Posted Entries";
        CannotApplyClosedEntriesErr: Label 'One or more of the entries that you selected is closed. You cannot apply closed entries.';
        TempApplyingCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        DocNo: Code[20];
        CustEntryApplID: Code[20];

    local procedure RunApplyCustEntries(var CustLedgEntry: Record "Cust. Ledger Entry"; var ApplyingCustLedgEntry: Record "Cust. Ledger Entry"; CustEntryApplID: Code[50])
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if CustLedgEntry.FindFirst() then begin
            PostDirectApplication(false, CustLedgEntry);
        end;
    end;

}

*/
