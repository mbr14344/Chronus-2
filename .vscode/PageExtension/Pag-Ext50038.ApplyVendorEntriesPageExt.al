pageextension 50038 ApplyVendorEntriesPageExt extends "Apply Vendor Entries"
{

    actions
    {
        addafter("Show Only Selected Entries to Be Applied")
        {

            /*action(PostAndApplyDiscount)
            {
                ApplicationArea = All;
                Caption = 'Post And Apply Discount';
                PromotedCategory = Process;
                Promoted = true;
                trigger OnAction();
                var
                    bCont: Boolean;
                    popupConfirm: Page "Confirmation Dialog";
                    VLE: Record "Vendor Ledger Entry";
                    GJL: Record "Gen. Journal Line";
                    VLS: record "General Ledger Setup";
                    LineNo: Decimal;
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    DocNo: Code[20];
                    GenJnlBatch: Record "Gen. Journal Batch";
                    CurrentJnlBatchName: Code[10];
                    GenJournalCU: Codeunit GenJournalExt;

                begin
                    IF STRLEN(TempApplyingVendLedgEntry."Vendor No.") = 0 then
                        ERROR('Sorry, this action is only applicable to Vendors at this time.');
                    bCont := true;
                    Clear(popupConfirm);
                    popupConfirm.setMessage('Do you wish to proceed with post and apply of payment discount(s)?');
                    Commit;
                    if popupConfirm.RunModal() = Action::No then
                        bCont := false;
                    if bCont = true then begin
                        If VLS.Get() then;

                        //Now let's Create Gen Journals and apply against the invoice
                        tempVLE.DeleteAll(); //clear temp table

                        GJL.Reset();
                        GJL.SetRange("Journal Template Name", VLS."Auto BC General Template");
                        GJL.SetRange("Journal Batch Name", VLS."Auto BC General Batch");
                        IF GJL.FindSet() then
                            GJl.DeleteAll();

                        Clear(NoSeriesMgt);
                        GenJnlBatch.Get(VLS."Auto BC General Template", VLS."Auto BC General Batch");
                        DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", Today, true);



                        VLE.RESET;
                        VLE.SETRANGE("Vendor No.", TempApplyingVendLedgEntry."Vendor No.");
                        VLE.SETFILTER("Remaining Pmt. Disc. Possible", '<>%1', 0);
                        if CalcType = CalcType::"Gen. Jnl. Line" then
                            VLE.SetRange("Applies-to ID", GenJnlLine."Applies-to ID")
                        else begin
                            VendEntryApplID := UserId;
                            if VendEntryApplID = '' then
                                VendEntryApplID := '***';
                            VLE.SetRange("Applies-to ID", VendEntryApplID);
                        end;
                        if VLE.FINDSET then
                            REPEAT
                                if VLE."Pmt. Discount Date" < Today then
                                    ERROR(Text002, VLE."Document No.", VLE."Pmt. Discount Date");


                                LineNo += 10000;
                                GJL.Init;
                                GJL.Validate("Document No.", DocNo);
                                GJL.VALIDATE("Journal Template Name", VLS."Auto BC General Template");
                                GJL.VALIDATE("Journal Batch Name", VLS."Auto BC General Batch");
                                GJL.VALIDATE("Posting Date", Today);
                                GJL.VALIDATE("Account Type", GJL."Account Type"::Vendor);
                                GJL.VALIDATE("Account No.", VLE."Vendor No.");
                                GJL.VALIDATE("Document Type", GJL."Document Type"::"Credit Memo");
                                GJL.VALIDATE(Description, 'Payment Term Discount');
                                GJL.Internal := true;
                                GJL.VALIDATE("External Document No.", CopyStr(VLE."External Document No." + '/' + VLE."Document No.", 1, 35));
                                GJL.Validate(Amount, VLE."Remaining Pmt. Disc. Possible" * -1);
                                GJL.Validate("Bal. Account Type", GJL."Bal. Account Type"::"G/L Account");
                                GJL.Validate("Bal. Account No.", VLS."Purchase Discount G/L Account");
                                GJL.Validate("Payment Method Code", 'ACCOUNT');
                                GJL."Line No." := LineNo;

                                GJL.Insert();

                                tempVLE.Init();
                                tempVLE.Copy(VLE);
                                tempVLE.Insert();

                            until VLE.Next = 0;

                        //now we are ready to post
                        GJL.Reset();
                        GJL.SetRange("Journal Template Name", VLS."Auto BC General Template");
                        GJL.SetRange("Journal Batch Name", VLS."Auto BC General Batch");
                        IF GJL.FindSet() then begin

                            GenJournalCU.SetSuppress(true);
                            GenJournalCU.PostGenJournal(GJL);
                            GenJournalCU.ApplyVendorEntries(DocNo, TempApplyingVendLedgEntry."Vendor No.", TempApplyingVendLedgEntry."Document No.");

                        end;
                        Commit();
                        RefreshAppliedIDs();

                        Message(Text001);
                    end;
                end;
            }*/

        }


    }
    var
        tempVLE: Record "Vendor Ledger Entry" temporary;


    procedure RefreshAppliedIDs()
    begin
        tempVLE.Reset();
        if tempVLE.FindSet() then
            repeat
                rec.Reset();
                rec.Get(tempVLE."Entry No.");
                SetVendApplId(false);
            until tempVLE.next = 0;
        rec.Reset();
        rec.SetFilter("Applies-to ID", tempVLE."Applies-to ID");
        rec.SetFilter("Vendor No.", tempVLE."Vendor No.");
        if rec.FindSet() then
            repeat
                rec.Validate("Remaining Pmt. Disc. Possible", 0);
                rec.Modify();
            until rec.Next() = 0;
        CurrPage.Update();
    end;

}
