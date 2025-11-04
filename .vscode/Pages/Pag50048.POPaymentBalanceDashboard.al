page 50048 "PO Payment Balance Dashboard"
{
    ApplicationArea = All;
    Caption = 'PO Payment Balance Dashboard';
    PageType = List;
    SourceTable = "Purchase Header";
    UsageCategory = Lists;
    SourceTableTemporary = true;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = all;
                    LookupPageId = "Vendor Card";
                    trigger OnDrillDown()
                    var
                        VendPge: Page "Vendor Card";
                        Vend: Record Vendor;
                    begin
                        Clear(VendPge);
                        Vend.Reset();
                        Vend.SetRange("No.", Rec."Buy-from Vendor No.");
                        if Vend.FindFirst() then begin
                            VendPge.SetRecord(Vend);
                            VendPge.Run();
                        end;

                    end;

                }
                field("Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = all;
                }
                field("PO No."; Rec."No.")
                {
                    Caption = 'PO No.';
                    ApplicationArea = all;
                    LookupPageId = "Purchase Order";
                    trigger OnDrillDown()
                    var
                        poPage: Page "Purchase Order";
                        purchHeader: Record "Purchase Header";
                        postedPurchInvs: Page "Posted Purchase Invoices";
                        purchInvHeader: Record "Purch. Inv. Header";
                        chkPurchInvHeader: Record "Purch. Inv. Header";
                        invStr: text;
                    begin
                        if rec.Closed = false then begin
                            Clear(poPage);
                            poPage.SetRecord(rec);
                            poPage.Run();
                        end
                        else begin
                            invStr := '--|';
                            purchInvHeader.Reset();
                            purchInvHeader.SetRange("Order No.", Rec."No.");
                            purchInvHeader.SetRange("Buy-from Vendor No.", Rec."Buy-from Vendor No.");
                            if (purchInvHeader.FindSet()) then
                                repeat
                                    invStr += format(purchInvHeader."No.") + '|';
                                until purchInvHeader.Next() = 0;
                            invStr := invStr.TrimEnd('|');
                            chkPurchInvHeader.Reset();
                            chkPurchInvHeader.SetFilter("No.", invStr);
                            if (chkPurchInvHeader.FindFirst()) then begin
                                Clear(postedPurchInvs);
                                postedPurchInvs.SetTableView(chkPurchInvHeader);
                                postedPurchInvs.Run();
                            end;

                        end;

                    end;
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;
                }
                field("PO Total Amount"; Rec.Amount)
                {
                    ApplicationArea = all;
                    LookupPageId = "Purchase Order";
                    Caption = 'Total PO Amount';
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        poPage: Page "Purchase Order";
                        purchHeader: Record "Purchase Header";
                    begin
                        Clear(poPage);
                        poPage.SetRecord(rec);
                        poPage.Run();
                    end;
                }
                field(TotalInvoiceAmounts; Rec.TotalInvoiceAmounts)
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        postedPurchInvs: Page "Posted Purchase Invoices";
                        purchHeader: Record "Purch. Inv. Header";
                        invStr: text;
                    begin
                        invStr := '--|';
                        purchInvHeader.Reset();
                        purchInvHeader.SetRange("Order No.", Rec."No.");
                        purchInvHeader.SetRange("Buy-from Vendor No.", Rec."Buy-from Vendor No.");
                        if (purchInvHeader.FindSet()) then
                            repeat
                                invStr += format(purchInvHeader."No.") + '|';
                            until purchInvHeader.Next() = 0;
                        invStr := invStr.TrimEnd('|');
                        purchHeader.Reset();
                        purchHeader.SetFilter("No.", invStr);
                        if (purchHeader.FindFirst()) then begin
                            Clear(postedPurchInvs);
                            postedPurchInvs.SetTableView(purchHeader);
                            postedPurchInvs.Run();
                        end;

                    end;
                }
                field(TotalPrepaidInvoiceAmounts; Rec.TotalPrepaidInvoiceAmounts)
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        postedPurchInvs: Page "Posted Purchase Invoices";
                        purchHeader: Record "Purch. Inv. Header";
                        invStr: text;
                    begin
                        invStr := '--|';
                        purchInvHeader.Reset();
                        purchInvHeader.SetRange("Buy-from Vendor No.", Rec."Buy-from Vendor No.");
                        purchInvHeader.SetRange("Prepayment Order No.", Rec."No.");
                        if (purchInvHeader.FindSet()) then
                            repeat
                                invStr += format(purchInvHeader."No.") + '|';
                            until purchInvHeader.Next() = 0;
                        invStr := invStr.TrimEnd('|');
                        Clear(postedPurchInvs);

                        purchHeader.Reset();
                        purchHeader.SetFilter("No.", invStr);
                        purchHeader.SetFilter("Buy-from Vendor No.", Rec."Buy-from Vendor No.");
                        if (purchHeader.FindFirst()) then begin
                            postedPurchInvs.SetTableView(purchHeader);
                            postedPurchInvs.Run();
                        end;

                    end;
                }
                field("PO Total Invoices Amount"; TotalInvoicesAmount)
                {
                    ApplicationArea = all;
                    Style = StrongAccent;
                    ToolTip = 'PO Total Invoices Amount = Total Invoice Amounts + Total Prepaid Invoice Amounts for the given PO.';

                }
                field(TotalReceivedAmount; Rec.TotalReceivedAmount)
                {
                    ApplicationArea = all;
                    Style = AttentionAccent;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var

                        postedPurchInvs: Page "Posted Purchase Invoice Lines";
                    begin
                        GetDocStr();
                        purchInvLine.Reset();
                        purchInvLine.SetRange("Vendor No.", Rec."Buy-from Vendor No.");

                        purchInvLine.SetFilter("Document No.", docNosStr);
                        purchInvLine.SetFilter(Description, '<>%1', 'Deposits');
                        if (purchInvLine.FindFirst()) then begin
                            Clear(postedPurchInvs);
                            postedPurchInvs.SetTableView(purchInvLine);
                            postedPurchInvs.Run();
                        end;
                    end;
                }
                field(TotalUnappliedInvoices; Rec.TotalUnappliedInvoices)
                {
                    ApplicationArea = All;
                    DrillDown = true;



                    trigger OnDrillDown()
                    var
                        VLETb: Record "Vendor Ledger Entry";
                        VLE: Page "Vendor Ledger Entries";
                    begin
                        GetDocStr();
                        VLETb.reset;
                        VLETb.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
                        VLETb.SetRange("Document Type", VLETb."Document Type"::Invoice);
                        VLETb.SetFilter("Document No.", docNosStr);
                        VLETb.SetRange("Open", true);
                        if VLETb.FindSet() then begin
                            Clear(VLE);
                            VLE.SetTableView(VLETb);
                            VLE.Run();
                        end;
                    end;
                }
                field(TotalAppliedCreditMemoAmount; Rec.TotalAppliedCreditMemoAmount)
                {
                    ApplicationArea = all;
                    LookupPageId = "Posted Purchase Credit Memos";
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        InvEntryNoStr: text;
                        VLETb: Record "Detailed Vendor Ledg. Entry";
                        VLE: Page "Detailed Vendor Ledg. Entries";
                        DetailedVLE: Record "Detailed Vendor Ledg. Entry";
                        EntryNoStr: text;
                    begin
                        GetDocStr();
                        InvEntryNoStr := '';
                        EntryNoStr := '';
                        vendorLedgerEntry.Reset();
                        vendorLedgerEntry.SetFilter("Document No.", docNosStr);
                        vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::Invoice);
                        vendorLedgerEntry.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
                        if (vendorLedgerEntry.FindSet()) then
                            repeat
                                InvEntryNoStr += format(vendorLedgerEntry."Entry No.") + '|';
                            until vendorLedgerEntry.Next() = 0;




                        InvEntryNoStr := InvEntryNoStr.TrimEnd('|');

                        If StrLen(InvEntryNoStr) > 0 then begin


                            DetailedVLE.Reset();
                            DetailedVLE.SetFilter("Vendor Ledger Entry No.", InvEntryNoStr);
                            DetailedVLE.SetRange("Entry Type", DetailedVLE."Entry Type"::Application);
                            DetailedVLE.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
                            if (DetailedVLE.FindSet()) then
                                repeat

                                    if DetailedVLE."Document Type" = DetailedVLE."Document Type"::"Credit Memo" then
                                        EntryNoStr += Format(DetailedVLE."Vendor Ledger Entry No.")
                                    else begin
                                        VLETb.Reset();
                                        VLETb.SetRange("Entry Type", VLETb."Entry Type"::Application);
                                        VLETb.SetRange("Applied Vend. Ledger Entry No.", DetailedVLE."Vendor Ledger Entry No.");
                                        VLETb.SetFilter("Vendor Ledger Entry No.", '<>%1', DetailedVLE."Vendor Ledger Entry No.");
                                        VLETb.SetRange(Amount, DetailedVLE.Amount * -1);
                                        VLETb.SetRange("Document Type", VLETb."Document Type"::"Credit Memo");
                                        if VLETb.FindFirst() then
                                            EntryNoStr += Format(VLETb."Vendor Ledger Entry No.")
                                    end;

                                until DetailedVLE.Next() = 0;

                            EntryNoStr := EntryNoStr.TrimEnd('|');
                            if StrLen(EntryNoStr) > 0 then begin
                                VLETb.Reset();
                                VLETb.SetFilter("Vendor Ledger Entry No.", EntryNoStr);
                                VLETb.SetRange("Entry Type", VLETb."Entry Type"::Application);
                                VLETB.SetRange("Document Type", VLETb."Document Type"::"Credit Memo");
                                VLETb.SetRange("Vendor No.", Rec."Buy-from Vendor No.");

                                if VLETb.FindSet() then begin
                                    VLE.SetTableView(VLETb);
                                    VLE.Run();
                                end;
                            end;


                        end;




                    end;
                }
                field(TotalUnAppliedCreditMemoAmount; Rec.TotalUnAppliedCreditMemoAmount)
                {
                    ApplicationArea = all;
                    LookupPageId = "Vendor Ledger Entries";
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        VLEPg: Page "Vendor Ledger Entries";
                        vendorLedgerEntry: Record "Vendor Ledger Entry";
                    begin
                        //get Total UnApplied Credit Memos
                        UnappliedCMdocNosStr := '';
                        vendorLedgerEntry.Reset();
                        vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::"Credit Memo");
                        vendorLedgerEntry.SetFilter("External Document No.", '*' + Rec."No." + '*');
                        vendorLedgerEntry.SetRange("Buy-from Vendor No.", rec."Buy-from Vendor No.");
                        vendorLedgerEntry.SetRange(Open, true);
                        if (vendorLedgerEntry.FindSet()) then
                            repeat
                                if StrPos(InvEntryNo, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                    vendorLedgerEntry.CalcFields("Remaining Amount");
                                    if vendorLedgerEntry."Remaining Amount" <> 0 then begin
                                        UnappliedCMdocNosStr += Format(vendorLedgerEntry."Entry No.") + '|';
                                    end;
                                end;
                            until vendorLedgerEntry.Next() = 0;
                        vendorLedgerEntry.Reset();
                        vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::"Credit Memo");
                        vendorLedgerEntry.SetFilter(Description, '*' + Rec."No." + '*');
                        vendorLedgerEntry.SetRange("Buy-from Vendor No.", rec."Buy-from Vendor No.");
                        vendorLedgerEntry.SetRange(Open, true);
                        if (vendorLedgerEntry.FindSet()) then
                            repeat
                                if StrPos(InvEntryNo, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                    if StrPos(UnappliedCMdocNosStr, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                        vendorLedgerEntry.CalcFields("Remaining Amount");
                                        if vendorLedgerEntry."Remaining Amount" <> 0 then
                                            UnappliedCMdocNosStr += Format(vendorLedgerEntry."Entry No.") + '|';
                                    end;

                                end;
                            until vendorLedgerEntry.Next() = 0;
                        UnappliedCMdocNosStr := UnappliedCMdocNosStr.TrimEnd('|');
                        if strlen(UnappliedCMdocNosStr) > 0 then begin
                            vendorLedgerEntry.Reset();
                            vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::"Credit Memo");
                            vendorLedgerEntry.SetFilter("Entry No.", UnappliedCMdocNosStr);
                            vendorLedgerEntry.SetRange("Buy-from Vendor No.", rec."Buy-from Vendor No.");
                            vendorLedgerEntry.SetRange(Open, true);
                            if (vendorLedgerEntry.FindSet()) then begin
                                Clear(VLEPg);
                                VLEPg.SetTableView(vendorLedgerEntry);
                                VLEPg.Run();
                            end;
                        end;




                    end;
                }
                field(TotalCreditMemoAmount; TotalCreditMemoAmount)
                {
                    ApplicationArea = All;
                    Style = Attention;
                    Caption = 'Total Credit Memo Amount';
                }
                field("Total Applied PO Payments"; Rec.TotalAppliedPOPayment)
                {
                    ApplicationArea = all;

                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        VLE: Page "Detailed Vendor Ledg. Entries";
                        VLETb: Record "Detailed Vendor Ledg. Entry";
                        InvEntryNoStr: Text;
                    begin
                        GetDocStr();
                        vendorLedgerEntry.Reset();
                        vendorLedgerEntry.SetFilter("Document No.", docNosStr);
                        vendorLedgerEntry.SetRange("Buy-from Vendor No.", Rec."Buy-from Vendor No.");
                        vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::Invoice);
                        if vendorLedgerEntry.findSet() then
                            repeat
                                InvEntryNoStr += Format(vendorLedgerEntry."Entry No.") + '|';
                            until vendorLedgerEntry.Next() = 0;

                        InvEntryNoStr := InvEntryNoStr.TrimEnd('|');

                        If StrLen(InvEntryNoStr) > 0 then begin

                            VLETb.Reset();
                            VLETb.SetFilter("Vendor Ledger Entry No.", InvEntryNoStr);
                            VLETb.SetRange("Entry Type", VLETb."Entry Type"::Application);
                            VLETB.SetFilter("Document Type", '<>%1', VLETb."Document Type"::"Credit Memo");
                            VLETb.SetRange("Vendor No.", Rec."Buy-from Vendor No.");

                            if VLETb.FindSet() then begin
                                VLE.SetTableView(VLETb);
                                VLE.Run();
                            end;
                        end;
                    end;

                }
                field(TotalUnappliedPOPayment; Rec.TotalUnappliedPOPayment)
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        VLE: Page "Vendor Ledger Entries";
                        VLEtb: Record "Vendor Ledger Entry";
                        InvEntryNoStr: Text;
                    begin
                        UnappliedPaydocNosStr := '';
                        vendorLedgerEntry.Reset();
                        vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::Payment);
                        vendorLedgerEntry.SetFilter("External Document No.", '*' + Rec."No." + '*');
                        vendorLedgerEntry.SetRange("Buy-from Vendor No.", rec."Buy-from Vendor No.");
                        vendorLedgerEntry.SetRange(Open, true);
                        if (vendorLedgerEntry.FindSet()) then
                            repeat
                                if StrPos(InvEntryNo, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                    vendorLedgerEntry.CalcFields("Remaining Amount");
                                    if vendorLedgerEntry."Remaining Amount" <> 0 then begin
                                        UnappliedPaydocNosStr += Format(vendorLedgerEntry."Entry No.") + '|';
                                    end;
                                end;
                            until vendorLedgerEntry.Next() = 0;
                        vendorLedgerEntry.Reset();
                        vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::Payment);
                        vendorLedgerEntry.SetFilter(Description, '*' + Rec."No." + '*');
                        vendorLedgerEntry.SetRange("Buy-from Vendor No.", rec."Buy-from Vendor No.");
                        vendorLedgerEntry.SetRange(Open, true);
                        if (vendorLedgerEntry.FindSet()) then
                            repeat
                                if StrPos(InvEntryNo, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                    if StrPos(UnappliedPaydocNosStr, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                        vendorLedgerEntry.CalcFields("Remaining Amount");
                                        if vendorLedgerEntry."Remaining Amount" <> 0 then
                                            UnappliedPaydocNosStr += Format(vendorLedgerEntry."Entry No.") + '|';
                                    end;

                                end;
                            until vendorLedgerEntry.Next() = 0;
                        UnappliedPaydocNosStr := UnappliedPaydocNosStr.TrimEnd('|');
                        if strlen(UnappliedPaydocNosStr) > 0 then begin
                            vendorLedgerEntry.Reset();
                            vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::Payment);
                            vendorLedgerEntry.SetFilter("Entry No.", UnappliedPaydocNosStr);
                            vendorLedgerEntry.SetRange("Buy-from Vendor No.", rec."Buy-from Vendor No.");
                            vendorLedgerEntry.SetRange(Open, true);
                            if (vendorLedgerEntry.FindSet()) then begin
                                Clear(VLE);
                                VLE.SetTableView(vendorLedgerEntry);
                                VLE.Run();
                            end;
                        end;

                    end;





                }
                field(TotalPaymentsAmount; TotalPaymentsAmount)
                {
                    ApplicationArea = All;
                    Style = StrongAccent;
                    Caption = 'Total PO Payments Amount';
                    ToolTip = 'Total PO Payments Amount = Total Applied PO Payments + Total Unapplied PO Payments for the given PO.';
                }
                field("PO Balance"; Rec.POBalance)
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = IsNeg;
                    ToolTip = 'PO Balance = Total PO Amount - Total  PO Credit Memo Amount - Total PO Payments Amount.';
                }
                field(PaymentStandingBalance; Rec.PaymentStandingBalance)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Standing Balance';
                    ToolTip = 'Payment Standing Balance = Total PO Payments Amount - Total Received Invoiced Amount - Total PO Credit Memo Amount.';
                }
            }
        }
    }



    var

        TotalInvoicesAmount: Decimal;
        purchaseline: record "Purchase Line";
        purchInvHeader: Record "Purch. Inv. Header";
        purchHeader: Record "Purchase Header";
        gLentry: record "G/L Entry";
        purchCreditMemoHeader: Record "Purch. Cr. Memo Hdr.";
        purchInvLine: Record "Purch. Inv. Line";
        vendorLedgerEntry: Record "Vendor Ledger Entry";
        docNosStr: text;
        creditStr: text;
        gLAccountNoStr: text;
        IsNeg: Boolean;
        TotalPaymentsAmount: Decimal;
        TotalCreditMemoAmount: Decimal;
        InvEntryNo: text;
        UnappliedPaydocNosStr: text;
        UnappliedCMdocNosStr: text;




    trigger OnOpenPage()

    begin
        rec.DeleteAll();
        RefreshOpenPO();
        RefreshClosedPO();

        rec.Reset();

        rec.FindFirst();
    end;

    trigger OnAfterGetRecord()
    begin
        TotalInvoicesAmount := rec.TotalInvoiceAmounts + rec.TotalPrepaidInvoiceAmounts;
        TotalPaymentsAmount := rec.TotalAppliedPOPayment + rec.TotalUnappliedPOPayment;
        TotalCreditMemoAmount := rec.TotalAppliedCreditMemoAmount + rec.TotalUnAppliedCreditMemoAmount;
        UpdateStyle();
    end;

    local procedure GetDocStr()
    begin
        docNosStr := '--|';

        // pr 8/12/24 - get all the document nos from Prepayment Invoices
        purchInvHeader.Reset();
        purchInvHeader.SetRange("Prepayment Order No.", rec."No.");
        if (purchInvHeader.FindSet()) then begin
            repeat
                docNosStr += format(purchInvHeader."No.") + '|';

            until purchInvHeader.Next() = 0;
        end;
        // pr 8/12/24 - get all the document nos from regular Invoices
        purchInvHeader.Reset();
        purchInvHeader.SetRange("Order No.", rec."No.");
        if (purchInvHeader.FindSet()) then begin
            repeat
                docNosStr += format(purchInvHeader."No.") + '|';

            until purchInvHeader.Next() = 0;
        end;
        docNosStr := docNosStr.TrimEnd('|');
    end;

    local procedure CalcDocAmounts()
    begin
        docNosStr := '--|';
        rec.TotalInvoiceAmounts := 0;
        rec.TotalPrepaidInvoiceAmounts := 0;
        rec.TotalReceivedAmount := 0;
        rec.TotalUnappliedInvoices := 0;

        // pr 8/12/24 - get all the document nos from Prepayment Invoices and calculate amounts
        purchInvHeader.Reset();
        purchInvHeader.SetRange("Prepayment Order No.", rec."No.");
        if (purchInvHeader.FindSet()) then begin
            repeat
                docNosStr += format(purchInvHeader."No.") + '|';
                purchInvHeader.CalcFields(Amount);
                rec.TotalPrepaidInvoiceAmounts += purchInvHeader.Amount;
            until purchInvHeader.Next() = 0;
        end;
        // pr 8/12/24 - get all the document nos from regular Invoices
        purchInvHeader.Reset();
        purchInvHeader.SetRange("Order No.", rec."No.");
        if (purchInvHeader.FindSet()) then begin
            repeat
                docNosStr += format(purchInvHeader."No.") + '|';
                purchInvHeader.CalcFields(Amount);
                rec.TotalInvoiceAmounts += purchInvHeader.Amount;
            until purchInvHeader.Next() = 0;
        end;
        docNosStr := docNosStr.TrimEnd('|');
        purchInvLine.Reset();
        purchInvLine.SetFilter("Document No.", docNosStr);
        purchInvLine.SetFilter(Description, '<>%1', 'Deposits');
        if purchInvLine.findset() then
            repeat
                rec.TotalReceivedAmount += (purchInvLine."Line Amount" - purchInvLine."Line Discount Amount");
            until purchInvLine.next = 0;

    end;



    local procedure UpdateStyle()
    begin
        if Rec.POBalance < 0 then
            IsNeg := true
        else
            IsNeg := false;
    end;

    local procedure GetUnappliedDocStr()
    begin
        UnappliedPaydocNosStr := '--|';



        vendorLedgerEntry.Reset();
        vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::Payment);
        vendorLedgerEntry.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
        vendorLedgerEntry.SetFilter("External Document No.", '*' + Rec."No." + '*');
        if (vendorLedgerEntry.FindSet()) then
            repeat

                UnappliedPaydocNosStr += format(vendorLedgerEntry."Entry No.") + '|';
            until vendorLedgerEntry.Next() = 0;


        purchInvHeader.Reset();
        purchInvHeader.SetRange("Prepayment Order No.", rec."No.");
        if (purchInvHeader.FindSet()) then begin
            repeat
                UnappliedPaydocNosStr += '*' + format(purchInvHeader."No.") + '*|';

            until purchInvHeader.Next() = 0;
        end;
        // pr 8/12/24 - get all the document nos from regular Invoices
        purchInvHeader.Reset();
        purchInvHeader.SetRange("Order No.", rec."No.");
        if (purchInvHeader.FindSet()) then begin
            repeat
                docNosStr += format(purchInvHeader."No.") + '|';

            until purchInvHeader.Next() = 0;
        end;
        docNosStr := docNosStr.TrimEnd('|');
    end;

    local procedure RefreshOpenPO()
    var
        DetailedVLE: Record "Detailed Vendor Ledg. Entry";
        ChkDetailedVLE: Record "Detailed Vendor Ledg. Entry";
    begin

        purchHeader.Reset();
        purchHeader.SetRange("Document Type", purchHeader."Document Type"::Order);
        // purchHeader.SetRange("No.", 'PO002310');  //mbr test - for testing purposes only
        if (purchHeader.FindSet()) then begin

            repeat
                rec := purchHeader;

                gLAccountNoStr := '';
                InvEntryNo := '';

                CalcDocAmounts();
                //get Total Applied PO Payments
                //from Invoices
                vendorLedgerEntry.Reset();
                vendorLedgerEntry.SetFilter("Document No.", docNosStr);
                vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::Invoice);
                vendorLedgerEntry.SetRange("Vendor No.", purchHeader."Buy-from Vendor No.");
                if (vendorLedgerEntry.FindSet()) then
                    repeat
                        InvEntryNo += format(vendorLedgerEntry."Entry No.") + '|';
                    until vendorLedgerEntry.Next() = 0;

                InvEntryNo := InvEntryNo.TrimEnd('|');
                if StrLen(InvEntryNo) > 0 then begin
                    //get amounts from Detailed Vendor Ledger entries
                    DetailedVLE.Reset();
                    DetailedVLE.SetFilter("Vendor Ledger Entry No.", InvEntryNo);
                    DetailedVLE.SetRange("Entry Type", DetailedVLE."Entry Type"::Application);
                    //    DetailedVLE.SetFilter("Document Type", '%1|%2',DetailedVLE."Document Type"::Payment, DetailedVLE."Document Type"::Invoice);
                    DetailedVLE.SetRange("Vendor No.", purchHeader."Buy-from Vendor No.");
                    if (DetailedVLE.FindSet()) then
                        repeat
                            if DetailedVLE."Document Type" = DetailedVLE."Document Type"::Payment then
                                rec.TotalAppliedPOPayment += DetailedVLE.Amount
                            else begin
                                ChkDetailedVLE.Reset();
                                ChkDetailedVLE.SetRange("Entry Type", ChkDetailedVLE."Entry Type"::Application);
                                // ChkDetailedVLE.SetRange("Applied Vend. Ledger Entry No.", DetailedVLE."Vendor Ledger Entry No.");
                                ChkDetailedVLE.SetFilter("Vendor Ledger Entry No.", '=%1', DetailedVLE."Vendor Ledger Entry No.");
                                ChkDetailedVLE.SetRange(Amount, DetailedVLE.Amount);   // * -1);
                                                                                       //  ChkDetailedVLE.SetRange("Document Type", ChkDetailedVLE."Document Type"::Payment);
                                if ChkDetailedVLE.FindSet() then
                                    repeat
                                        rec.TotalAppliedPOPayment += ChkDetailedVLE.Amount
                                      until ChkDetailedVLE.Next() = 0;
                            end;

                        until DetailedVLE.Next() = 0;



                    //get Total Applied Credit Memos
                    //get amounts from Detailed Vendor Ledger entries
                    DetailedVLE.Reset();
                    DetailedVLE.SetFilter("Vendor Ledger Entry No.", InvEntryNo);
                    DetailedVLE.SetRange("Entry Type", DetailedVLE."Entry Type"::Application);
                    //  DetailedVLE.SetFilter("Document Type", '%1|%2', DetailedVLE."Document Type"::"Credit Memo", DetailedVLE."Document Type"::Invoice);
                    DetailedVLE.SetRange("Vendor No.", purchHeader."Buy-from Vendor No.");
                    if (DetailedVLE.FindSet()) then
                        repeat

                            if DetailedVLE."Document Type" = DetailedVLE."Document Type"::"Credit Memo" then
                                rec.TotalAppliedCreditMemoAmount += DetailedVLE.Amount
                            else begin
                                ChkDetailedVLE.Reset();
                                ChkDetailedVLE.SetRange("Entry Type", ChkDetailedVLE."Entry Type"::Application);
                                ChkDetailedVLE.SetRange("Applied Vend. Ledger Entry No.", DetailedVLE."Vendor Ledger Entry No.");
                                ChkDetailedVLE.SetFilter("Vendor Ledger Entry No.", '<>%1', DetailedVLE."Vendor Ledger Entry No.");
                                ChkDetailedVLE.SetRange(Amount, DetailedVLE.Amount * -1);
                                ChkDetailedVLE.SetRange("Document Type", ChkDetailedVLE."Document Type"::"Credit Memo");
                                if ChkDetailedVLE.FindFirst() then
                                    rec.TotalAppliedCreditMemoAmount += ChkDetailedVLE.Amount;
                            end;

                        until DetailedVLE.Next() = 0;
                end;
                //else begin
                //get Total UnApplied PO Payments

                UnappliedPaydocNosStr := '';
                vendorLedgerEntry.Reset();
                vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::Payment);
                vendorLedgerEntry.SetFilter("External Document No.", '*' + Rec."No." + '*');
                vendorLedgerEntry.SetRange("Buy-from Vendor No.", purchHeader."Buy-from Vendor No.");
                vendorLedgerEntry.SetRange(Open, true);
                if (vendorLedgerEntry.FindSet()) then
                    repeat
                        if StrPos(InvEntryNo, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                            vendorLedgerEntry.CalcFields("Remaining Amount");
                            IF vendorLedgerEntry."Remaining Amount" <> 0 then begin
                                UnappliedPaydocNosStr += Format(vendorLedgerEntry."Entry No.") + '|';
                                rec.TotalUnappliedPOPayment += vendorLedgerEntry."Remaining Amount";
                            end;

                        end;
                    until vendorLedgerEntry.Next() = 0;
                UnappliedPaydocNosStr := UnappliedPaydocNosStr.TrimEnd('|');
                vendorLedgerEntry.Reset();
                vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::Payment);
                vendorLedgerEntry.SetFilter(Description, '*' + Rec."No." + '*');
                vendorLedgerEntry.SetRange("Buy-from Vendor No.", purchHeader."Buy-from Vendor No.");
                vendorLedgerEntry.SetRange(Open, true);
                if (vendorLedgerEntry.FindSet()) then
                    repeat
                        if StrPos(InvEntryNo, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                            if StrPos(UnappliedPaydocNosStr, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                vendorLedgerEntry.CalcFields("Remaining Amount");
                                if vendorLedgerEntry."Remaining Amount" <> 0 then
                                    rec.TotalUnappliedPOPayment += vendorLedgerEntry."Remaining Amount";
                            end;

                        end;
                    until vendorLedgerEntry.Next() = 0;

                //get Total UnApplied Credit Memos
                UnappliedCMdocNosStr := '';

                vendorLedgerEntry.Reset();
                vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::"Credit Memo");
                vendorLedgerEntry.SetFilter("External Document No.", '*' + Rec."No." + '*');
                vendorLedgerEntry.SetRange("Buy-from Vendor No.", purchHeader."Buy-from Vendor No.");
                vendorLedgerEntry.SetRange(Open, true);
                if (vendorLedgerEntry.FindSet()) then
                    repeat
                        if StrPos(InvEntryNo, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                            vendorLedgerEntry.CalcFields("Remaining Amount");
                            if vendorLedgerEntry."Remaining Amount" <> 0 then begin
                                UnappliedCMdocNosStr += Format(vendorLedgerEntry."Entry No.") + '|';
                                rec.TotalUnAppliedCreditMemoAmount += vendorLedgerEntry."Remaining Amount";
                            end;
                        end;
                    until vendorLedgerEntry.Next() = 0;
                vendorLedgerEntry.Reset();
                vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::"Credit Memo");
                vendorLedgerEntry.SetFilter(Description, '*' + Rec."No." + '*');
                vendorLedgerEntry.SetRange("Buy-from Vendor No.", purchHeader."Buy-from Vendor No.");
                vendorLedgerEntry.SetRange(Open, true);
                if (vendorLedgerEntry.FindSet()) then
                    repeat
                        if StrPos(InvEntryNo, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                            if StrPos(UnappliedCMdocNosStr, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                vendorLedgerEntry.CalcFields("Remaining Amount");
                                if vendorLedgerEntry."Remaining Amount" <> 0 then
                                    rec.TotalUnAppliedCreditMemoAmount += vendorLedgerEntry."Remaining Amount";
                            end;

                        end;
                    until vendorLedgerEntry.Next() = 0;


                //Calculate Unapplied Invoices
                vendorLedgerEntry.reset;
                vendorLedgerEntry.SetRange("Vendor No.", purchHeader."Buy-from Vendor No.");
                vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::Invoice);
                vendorLedgerEntry.SetFilter("Document No.", docNosStr);
                vendorLedgerEntry.SetRange(Open, true);
                if vendorLedgerEntry.FindSet() then
                    repeat
                        vendorLedgerEntry.CalcFields("Remaining Amount");
                        if vendorLedgerEntry."Remaining Amount" <> 0 then
                            Rec.TotalUnappliedInvoices += Abs(vendorLedgerEntry."Remaining Amount");
                    until vendorLedgerEntry.Next() = 0;

                //   end;

                rec.CalcFields(Amount);
                rec.POBalance := rec.Amount - rec.TotalAppliedCreditMemoAmount - rec.TotalUnAppliedCreditMemoAmount - rec.TotalAppliedPOPayment - rec.TotalUnappliedPOPayment;
                rec.Closed := false;

                Rec.PaymentStandingBalance := (rec.TotalAppliedPOPayment + rec.TotalUnappliedPOPayment) - rec.TotalReceivedAmount - (rec.TotalAppliedCreditMemoAmount + rec.TotalUnAppliedCreditMemoAmount);




                rec.Insert();
            until purchHeader.Next() = 0;
        end;

    end;

    local procedure RefreshClosedPO()
    var
        DetailedVLE: Record "Detailed Vendor Ledg. Entry";
        ChkDetailedVLE: Record "Detailed Vendor Ledg. Entry";

        GetVendorNo: Code[20];
        GetOrderNo: Code[20];
        bInsert: boolean;
        PurchInvLine: Record "Purch. Inv. Line";
    begin
        GetVendorNo := '';
        GetOrderNo := '';
        purchInvHeader.Reset();
        purchInvHeader.SetCurrentKey("Buy-from Vendor No.", "Order No.", "Vendor Invoice No.");
        purchInvHeader.SetFilter("Order No.", '<>%1', '');

        //purchInvHeader.SetRange("Order No.", 'PO000147'); //mbr - for testing purposes only|
        if (purchInvHeader.FindSet()) then
            repeat
                purchHeader.Reset();
                purchHeader.SetRange("Document Type", purchHeader."Document Type"::Order);
                purchHeader.SetRange("No.", purchInvHeader."Order No.");
                if not purchHeader.FindFirst() then begin
                    bInsert := false;


                    If (GetVendorNo <> purchInvHeader."Buy-from Vendor No.") OR (GetOrderNo <> purchInvHeader."Order No.") then begin
                        GetOrderNo := purchInvHeader."Order No.";
                        GetVendorNo := purchInvHeader."Buy-from Vendor No.";
                        bInsert := true;
                    end;
                    purchInvHeader.CalcFields(Amount, "Remaining Amount");

                    purchInvLine.Reset();
                    purchInvLine.SetFilter("Document No.", purchInvHeader."No.");
                    purchInvLine.SetFilter(Description, '<>%1', 'Deposits');

                    if bInsert = true then begin
                        rec.Init;
                        rec."No." := purchInvHeader."Order No.";
                        rec."Buy-from Vendor No." := purchInvHeader."Buy-from Vendor No.";
                        rec."Buy-from Vendor Name" := purchInvHeader."Buy-from Vendor Name";

                        rec.TotalInvoiceAmounts := purchInvHeader.Amount;
                        rec.TotalUnappliedInvoices := purchInvHeader."Remaining Amount";
                        rec.Closed := true;
                        rec.TotalPrepaidInvoiceAmounts := 0;
                        rec.TotalReceivedAmount := 0;
                        if purchInvLine.findset() then
                            repeat
                                rec.TotalReceivedAmount += (purchInvLine."Line Amount" - purchInvLine."Line Discount Amount");
                            until purchInvLine.next = 0;
                        rec.TotalAppliedPOPayment := 0;
                        rec.TotalUnappliedPOPayment := 0;
                        rec.TotalAppliedCreditMemoAmount := 0;
                        rec.TotalUnAppliedCreditMemoAmount := 0;
                        rec.POBalance := 0;
                        UnappliedPaydocNosStr := '';
                        UnappliedCMdocNosStr := '';
                    end
                    else begin
                        rec.Reset();
                        rec.SetRange("No.", purchInvHeader."Order No.");
                        if rec.findfirst then begin
                            rec.TotalInvoiceAmounts += purchInvHeader.Amount;
                            rec.TotalUnappliedInvoices += purchInvHeader."Remaining Amount";
                            if purchInvLine.findset() then
                                repeat
                                    rec.TotalReceivedAmount += (purchInvLine."Line Amount" - purchInvLine."Line Discount Amount");
                                until purchInvLine.next = 0;
                        end;

                    end;
                    InvEntryNo := '';
                    //get Total Applied PO Payments
                    //from Invoices
                    vendorLedgerEntry.Reset();
                    vendorLedgerEntry.SetFilter("Document No.", purchInvHeader."No.");
                    vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::Invoice);
                    vendorLedgerEntry.SetRange("Vendor No.", purchInvHeader."Buy-from Vendor No.");
                    if vendorLedgerEntry.FindFirst() then begin
                        InvEntryNo := format(vendorLedgerEntry."Entry No.");
                    end;

                    //get amounts from Detailed Vendor Ledger entries
                    DetailedVLE.Reset();
                    DetailedVLE.SetFilter("Vendor Ledger Entry No.", InvEntryNo);
                    DetailedVLE.SetRange("Entry Type", DetailedVLE."Entry Type"::Application);
                    //     DetailedVLE.SetFilter("Document Type", '%1|%2', DetailedVLE."Document Type"::Payment, DetailedVLE."Document Type"::Invoice);
                    DetailedVLE.SetRange("Vendor No.", purchInvHeader."Buy-from Vendor No.");
                    if (DetailedVLE.FindSet()) then
                        repeat
                            if DetailedVLE."Document Type" <> DetailedVLE."Document Type"::"Credit Memo" then
                                rec.TotalAppliedPOPayment += DetailedVLE.Amount;
                        //else begin
                        //    ChkDetailedVLE.Reset();
                        //    ChkDetailedVLE.SetRange("Entry Type", ChkDetailedVLE."Entry Type"::Application);
                        //    ChkDetailedVLE.SetRange("Applied Vend. Ledger Entry No.", DetailedVLE."Vendor Ledger Entry No.");
                        //    ChkDetailedVLE.SetFilter("Vendor Ledger Entry No.", '<>%1', DetailedVLE."Vendor Ledger Entry No.");
                        ///    ChkDetailedVLE.SetRange(Amount, DetailedVLE.Amount * -1);
                        //    ChkDetailedVLE.SetRange("Document Type", ChkDetailedVLE."Document Type"::Payment);
                        //    if ChkDetailedVLE.FindFirst() then
                        //        rec.TotalAppliedPOPayment += ChkDetailedVLE.Amount
                        //    else begin
                        //        //mbr 5/18/25 - start
                        //        //if we are here then we need to find the total applied payments where by Document type = Invoice
                        //        ChkDetailedVLE.Reset();
                        //        ChkDetailedVLE.SetRange("Vendor Ledger Entry No.", DetailedVLE."Vendor Ledger Entry No.");
                        //        ChkDetailedVLE.SetRange("Entry Type", ChkDetailedVLE."Entry Type"::Application);
                        //        ChkDetailedVLE.SetRange("Document No.", purchInvHeader."No.");
                        //        ChkDetailedVLE.SetRange("Document Type", ChkDetailedVLE."Document Type"::Invoice);
                        //        ChkDetailedVLE.SetRange("Vendor No.", purchInvHeader."Buy-from Vendor No.");
                        //        if ChkDetailedVLE.FindSet() then
                        //            repeat
                        //                rec.TotalAppliedPOPayment += ChkDetailedVLE.Amount;
                        //            until ChkDetailedVLE.Next() = 0;
                        //mbr 5/18/25 - end
                        //   end;
                        //end;
                        until DetailedVLE.Next() = 0;

                    //get Total UnApplied PO Payments

                    vendorLedgerEntry.Reset();
                    vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::Payment);
                    vendorLedgerEntry.SetFilter("External Document No.", '*' + Rec."No." + '*');
                    vendorLedgerEntry.SetRange("Buy-from Vendor No.", rec."Buy-from Vendor No.");
                    vendorLedgerEntry.SetRange(Open, true);
                    if (vendorLedgerEntry.FindSet()) then
                        repeat
                            if StrPos(InvEntryNo, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                if StrPos(UnappliedPaydocNosStr, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                    vendorLedgerEntry.CalcFields("Remaining Amount");
                                    if vendorLedgerEntry."Remaining Amount" <> 0 then begin
                                        UnappliedPaydocNosStr += Format(vendorLedgerEntry."Entry No.") + '|';
                                        rec.TotalUnappliedPOPayment += vendorLedgerEntry."Remaining Amount";
                                    end;
                                end;
                            end;
                        until vendorLedgerEntry.Next() = 0;
                    UnappliedPaydocNosStr := UnappliedPaydocNosStr.TrimEnd('|');
                    vendorLedgerEntry.Reset();
                    vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::Payment);
                    vendorLedgerEntry.SetFilter(Description, '*' + Rec."No." + '*');
                    vendorLedgerEntry.SetRange("Buy-from Vendor No.", rec."Buy-from Vendor No.");
                    vendorLedgerEntry.SetRange(Open, true);
                    if (vendorLedgerEntry.FindSet()) then
                        repeat
                            if StrPos(InvEntryNo, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                if StrPos(UnappliedPaydocNosStr, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                    vendorLedgerEntry.CalcFields("Remaining Amount");
                                    if vendorLedgerEntry."Remaining Amount" <> 0 then begin
                                        UnappliedPaydocNosStr += Format(vendorLedgerEntry."Entry No.") + '|';
                                        rec.TotalUnappliedPOPayment += vendorLedgerEntry."Remaining Amount";
                                    end;

                                end;

                            end;
                        until vendorLedgerEntry.Next() = 0;

                    //get Total Applied Credit Memos
                    //get amounts from Detailed Vendor Ledger entries
                    DetailedVLE.Reset();
                    DetailedVLE.SetFilter("Vendor Ledger Entry No.", InvEntryNo);
                    DetailedVLE.SetRange("Entry Type", DetailedVLE."Entry Type"::Application);
                    //   DetailedVLE.SetFilter("Document Type", '%1|%2', DetailedVLE."Document Type"::"Credit Memo", DetailedVLE."Document Type"::Invoice);
                    DetailedVLE.SetRange("Vendor No.", rec."Buy-from Vendor No.");
                    if (DetailedVLE.FindSet()) then
                        repeat


                            if DetailedVLE."Document Type" = DetailedVLE."Document Type"::"Credit Memo" then
                                rec.TotalAppliedCreditMemoAmount += DetailedVLE.Amount
                            else begin
                                ChkDetailedVLE.Reset();
                                ChkDetailedVLE.SetRange("Entry Type", ChkDetailedVLE."Entry Type"::Application);
                                ChkDetailedVLE.SetRange("Applied Vend. Ledger Entry No.", DetailedVLE."Vendor Ledger Entry No.");
                                ChkDetailedVLE.SetFilter("Vendor Ledger Entry No.", '<>%1', DetailedVLE."Vendor Ledger Entry No.");
                                ChkDetailedVLE.SetRange(Amount, DetailedVLE.Amount * -1);
                                ChkDetailedVLE.SetRange("Document Type", ChkDetailedVLE."Document Type"::"Credit Memo");
                                if ChkDetailedVLE.FindFirst() then
                                    rec.TotalAppliedCreditMemoAmount += ChkDetailedVLE.Amount;


                            end;



                        until DetailedVLE.Next() = 0;

                    //get Total UnApplied Credit Memos
                    vendorLedgerEntry.Reset();
                    vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::"Credit Memo");
                    vendorLedgerEntry.SetFilter("External Document No.", '*' + Rec."No." + '*');
                    vendorLedgerEntry.SetRange("Buy-from Vendor No.", rec."Buy-from Vendor No.");
                    vendorLedgerEntry.SetRange(Open, true);
                    if (vendorLedgerEntry.FindSet()) then
                        repeat
                            if StrPos(InvEntryNo, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                if StrPos(UnappliedCMdocNosStr, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                    vendorLedgerEntry.CalcFields("Remaining Amount");
                                    if vendorLedgerEntry."Remaining Amount" <> 0 then begin
                                        UnappliedCMdocNosStr += Format(vendorLedgerEntry."Entry No.") + '|';
                                        rec.TotalUnAppliedCreditMemoAmount += vendorLedgerEntry."Remaining Amount";
                                    end;
                                end;
                            end;
                        until vendorLedgerEntry.Next() = 0;
                    vendorLedgerEntry.Reset();
                    vendorLedgerEntry.SetRange("Document Type", vendorLedgerEntry."Document Type"::"Credit Memo");
                    vendorLedgerEntry.SetFilter(Description, '*' + Rec."No." + '*');
                    vendorLedgerEntry.SetRange("Buy-from Vendor No.", rec."Buy-from Vendor No.");
                    vendorLedgerEntry.SetRange(Open, true);
                    if (vendorLedgerEntry.FindSet()) then
                        repeat
                            if StrPos(InvEntryNo, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                if StrPos(UnappliedCMdocNosStr, format(vendorLedgerEntry."Entry No.")) = 0 then begin
                                    vendorLedgerEntry.CalcFields("Remaining Amount");
                                    if vendorLedgerEntry."Remaining Amount" <> 0 then begin
                                        UnappliedCMdocNosStr += Format(vendorLedgerEntry."Entry No.") + '|';
                                        rec.TotalUnAppliedCreditMemoAmount += vendorLedgerEntry."Remaining Amount";
                                    end;

                                end;

                            end;
                        until vendorLedgerEntry.Next() = 0;

                    Rec.PaymentStandingBalance := (rec.TotalAppliedPOPayment + rec.TotalUnappliedPOPayment) - rec.TotalReceivedAmount - (rec.TotalAppliedCreditMemoAmount + rec.TotalUnAppliedCreditMemoAmount);


                    if bInsert then
                        rec.Insert()
                    else
                        rec.Modify();

                end;  //end of not purchheader.Findfirst



            until purchInvHeader.Next() = 0;



    end;

}
