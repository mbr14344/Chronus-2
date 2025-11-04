
pageextension 50040 ApplyCustomerEntriesExtPage extends "Apply Customer Entries"
{

    layout
    {
        addafter("Remaining Pmt. Disc. Possible")
        {
            field(NetAmount; NetAmount)
            {
                Caption = 'Appln. Net Amount';
                ApplicationArea = All;
            }
        }

    }

    actions
    {
        addafter("Show Only Selected Entries to Be Applied")
        {


            action(PostAndApplyDiscount)
            {
                ApplicationArea = All;
                Caption = 'Post And Apply Discount';
                PromotedCategory = Process;
                Promoted = true;
                Visible = not isPostAndApply;
                trigger OnAction();
                var
                    bCont: Boolean;
                    popupConfirm: Page "Confirmation Dialog";
                    CLE: Record "Cust. Ledger Entry";
                    GJL: Record "Gen. Journal Line";
                    VLS: record "General Ledger Setup";
                    LineNo: Decimal;
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    DocNo: Code[20];
                    GenJnlBatch: Record "Gen. Journal Batch";
                    CurrentJnlBatchName: Code[10];
                    GenJournalCU: Codeunit GenJournalCustExt;
                    count: Integer;

                begin
                    IF STRLEN(TempApplyingCustLedgEntry."Customer No.") = 0 then
                        ERROR('Sorry, this action is only applicable to Customers at this time.');
                    //pr 5/1/25 - check if lines are valid before trying to post - start
                    CLE.RESET;
                    CLE.SETRANGE("Customer No.", TempApplyingCustLedgEntry."Customer No.");
                    CLE.SETFILTER("Remaining Pmt. Disc. Possible", '<>%1', 0);
                    if CalcType = CalcType::"Gen. Jnl. Line" then begin
                        CLE.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                    end
                    else begin
                        CustEntryApplID := UserId;
                        if CustEntryApplID = '' then
                            CustEntryApplID := '***';
                        CLE.SetRange("Applies-to ID", CustEntryApplID);
                    end;
                    if CLE.FINDSET then
                        REPEAT
                            if CLE."Pmt. Discount Date" < Today then
                                ERROR(Text002, CLE."Document No.", CLE."Pmt. Discount Date");
                        until CLE.Next = 0;
                    //pr 5/1/25 - check if lines are valid before trying to post - end
                    bCont := true;

                    Clear(popupConfirm);
                    popupConfirm.setMessage('Do you wish to proceed with post and apply of payment discount(s)?');
                    Commit;
                    if popupConfirm.RunModal() = Action::No then
                        bCont := false;
                    if bCont = true then begin
                        If VLS.Get() then;

                        //Now let's Create Gen Journals and apply against the invoice
                        tempCLE.DeleteAll(); //clear temp table
                        tempCLE2.DeleteAll();
                        tempGJL.DeleteAll();


                        GJL.Reset();
                        GJL.SetRange("Journal Template Name", VLS."Auto BC General Template");
                        GJL.SetRange("Journal Batch Name", VLS."Auto BC General Batch");
                        IF GJL.FindSet() then
                            GJl.DeleteAll();

                        CLE.RESET;
                        CLE.SETRANGE("Customer No.", TempApplyingCustLedgEntry."Customer No.");
                        CLE.SETFILTER("Remaining Pmt. Disc. Possible", '<>%1', 0);
                        if CalcType = CalcType::"Gen. Jnl. Line" then begin
                            CLE.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                            tempAppliedID := GenJnlLine."Applies-to ID";
                        end
                        else begin
                            CustEntryApplID := UserId;
                            if CustEntryApplID = '' then
                                CustEntryApplID := '***';
                            CLE.SetRange("Applies-to ID", CustEntryApplID);
                            tempAppliedID := CustEntryApplID;
                        end;
                        if CLE.FINDSET then
                            REPEAT
                                if CLE."Pmt. Discount Date" < Today then
                                    ERROR(Text002, CLE."Document No.", CLE."Pmt. Discount Date");

                                Clear(NoSeriesMgt);
                                GenJnlBatch.Get(VLS."Auto BC General Template", VLS."Auto BC General Batch");
                                DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", Today, true);
                                LineNo += 10000;
                                GJL.Init;
                                GJL.Validate("Document No.", DocNo);
                                GJL.VALIDATE("Journal Template Name", VLS."Auto BC General Template");
                                GJL.VALIDATE("Journal Batch Name", VLS."Auto BC General Batch");
                                GJL.VALIDATE("Posting Date", Today);
                                GJL.VALIDATE("Account Type", GJL."Account Type"::Customer);
                                GJL.VALIDATE("Account No.", CLE."Customer No.");
                                GJL.VALIDATE("Document Type", GJL."Document Type"::"Credit Memo");
                                GJL.VALIDATE(Description, 'Payment Term Discount');
                                GJL.Internal := true;
                                GJL.VALIDATE("External Document No.", CopyStr(CLE."External Document No." + '/' + CLE."Document No.", 1, 35));
                                GJL.Validate(Amount, CLE."Remaining Pmt. Disc. Possible" * -1);
                                GJL.Validate("Bal. Account Type", GJL."Bal. Account Type"::"G/L Account");
                                GJL.Validate("Bal. Account No.", VLS."Sales Discount G/L Account");
                                GJL.Validate("Payment Method Code", 'ACCOUNT');
                                GJL."Line No." := LineNo;

                                GJL.Insert();
                                GenJournalCU.SetSuppress(true);
                                GenJournalCU.PostGenJournal(GJL);
                                tempAppliedID := CLE."Applies-to ID";
                                // pr 7/10/24 - closes all other related entires to avoid other records being applied on accident 
                                CLE.Validate("Applies-to ID", '');
                                CLE.Validate(Open, false);
                                tempCLE.Init();
                                tempCLE.Copy(CLE);
                                tempCLE.Insert();
                                tempGJL.Init();
                                tempGJL.Copy(GJL);
                                tempGJL.Insert();
                                if (dict.ContainsKey(tempCLE."Entry No.")) then begin
                                    dict.Remove(tempCLE."Entry No.");
                                end;
                                dict.Add(tempCLE."Entry No.", GJL."Document No.");

                            until CLE.Next = 0;

                        tempCLE2.Reset();
                        // pr 7/10/24 - closes all other related entries to avoid other records being applied on accident 
                        rec.reset();
                        rec.SetRange(open, true);
                        rec.SetRange("Applies-to ID", tempAppliedID);
                        rec.SetRange("Customer No.", TempApplyingCustLedgEntry."Customer No.");
                        if (rec.FindSet()) then begin
                            repeat
                                tempCLE2.Init();
                                tempCLE2.Copy(rec);
                                tempCLE2.Insert();
                                rec.Open := false;
                                rec."Applies-to ID" := '';
                                rec.Modify();
                            until rec.Next() = 0;
                        end;
                        tempGJL.Reset();
                        foreach dictionaryKey in dict.Keys() do begin
                            tempGJL.Reset();
                            tempGJL.SetRange("Document No.", dict.get(dictionaryKey));
                            if (tempGJL.FindFirst()) then begin
                                GenJournalCU.ApplyCustEntries(tempGJL."Document No.", TempApplyingCustLedgEntry."Customer No.", tempAppliedID, dictionaryKey);
                            end;
                            dict.Remove(dictionaryKey);
                        end;

                        // pr 6/28/24 
                        RefreshAppliedIDs();
                        Message(Text001);
                    end;
                end;
            }

        }


    }
    trigger OnAfterGetRecord()
    begin

        NetAmount := Rec."Amount to Apply" - Rec."Remaining Pmt. Disc. Possible";

    end;

    var
        tempCLE: Record "Cust. Ledger Entry" temporary;
        tempGJL: Record "Gen. Journal Line" temporary;
        tempCLE2: Record "Cust. Ledger Entry" temporary;
        Text001: Label 'Early Payment Discount(s) posted and applied against selected invoices.';
        Text002: Label 'Invoice %1 has Pmt. Discount Date = %2 which is expired.  Please zero out Remaining Discount Amount Possible to exclude or change the Pmt. Discount Date.';
        GenJournalCU: Codeunit GenJournalCustExt;
        dict: Dictionary of [Integer, code[20]];
        dictionaryKey: Integer;
        tempAppliedID: code[50];

        isPostAndApply: Boolean;
        NetAmount: Decimal;

    procedure SetIsPostAndApply(isActive: Boolean)
    begin
        isPostAndApply := isActive;

    end;

    procedure RefreshAppliedIDs()
    var
        entryNoFilterStr: text;
        applyID: text;
        before: decimal;
        after: decimal;
        amountToAplly: Decimal;

    begin
        entryNoFilterStr := '';
        // pr 7/10/24 - restores realted entries after they have been applied
        tempCLE2.Reset();
        if tempCLE2.FindSet() then
            repeat
                rec.get(tempCLE2."Entry No.");
                rec."Applies-to ID" := tempCLE2."Applies-to ID";
                rec.Open := tempCLE2.open;
                rec.Modify();
            until tempCLE2.next = 0;

        //apply entries from CM to invoices
        tempCLE.Reset();
        if tempCLE.FindSet() then
            repeat
                applyID := tempCLE."Applies-to ID";
                rec.Reset();
                rec.Get(tempCLE."Entry No.");
                SetCustApplId(false);
                SetCustApplId(false);
                entryNoFilterStr += Format(tempCLE."Entry No.") + '|';
            until tempCLE.next = 0;

        // pr 7/5/24 - start
        entryNoFilterStr := entryNoFilterStr.TrimEnd('|');
        entryNoFilterStr := entryNoFilterStr.TrimStart('|');
        entryNoFilterStr := entryNoFilterStr.Trim();
        rec.Reset();
        rec.SetFilter("Entry No.", entryNoFilterStr);
        if rec.FindSet() then
            repeat
                //SetCustApplId(false);
                rec.Validate("Remaining Pmt. Disc. Possible", 0);
                //   rec.Validate("Applies-to ID", tempAppliedID);
                rec.Modify();
            until rec.Next() = 0;
        tempCLE.DeleteAll(); //clear temp table
        tempCLE2.DeleteAll();
        tempGJL.DeleteAll();

    end;

}