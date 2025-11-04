report 50132 RoyaltySummaryReportRealTime
{
    ApplicationArea = All;
    Caption = 'Royalty Summary Report - Real Time';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/RoyalySummaryReportRealTime.rdl';


    dataset
    {

        //7/14/25 - start
        dataitem("Item License"; ItemLicense)
        {


            RequestFilterFields = License, Sublicense;

            trigger OnAfterGetRecord()
            begin
                CurrReport.Skip();
            end;
        }
        //7/14/25 - end
        /* dataitem(CBIS; "Cash Basis Item Sales")
         {
             RequestFilterFields = License, SubLicense, ItemNo;
             trigger OnAfterGetRecord()
             begin
                 CurrReport.Skip();
             end;


         }*/
        dataitem(TmpRoyalty; TmpRoyalty)
        {
            DataItemTableView = sorting(CustNo, Type, DatePaid, InvoiceNo, ItemNo);


            column(txtFilters; txtFilters)
            {


            }
            column(Company; Company.Name)
            {


            }
            column(lblReportTitle; lblReportTitle)
            {


            }
            column(License; TmpRoyalty.License)
            {


            }
            column(SubLicense; TmpRoyalty.Sublicense)
            {


            }


            column(DatePaid; DatePaid)
            {
            }
            column(InvoiceNo; InvoiceNo)
            {


            }
            column(ItemDescription; Description)
            {


            }
            column(CustNo; CustNo)
            {
            }
            column(CustomerName; CustomerName)
            {
            }

            column(ExtDocNo; ExtDocNo)
            {
            }
            column(Type; "Type")
            {
            }


            column(ItemNo; ItemNo)
            {
            }
            column(Description; Description)
            {
            }
            column(Qty; Qty)
            {
            }
            column(SalesPrice; SalesPrice)
            {
            }
            column(OriginalAmount; OriginalAmount)
            {
            }
            column(PaidAmount; PaidAmount)
            {
            }
            column(CashPaidAmount; CashPaidAmount)
            {
            }
            column(OrderNo; OrderNo)
            {


            }
            column(bCashPaidNotEq; bCashPaidNotEq)
            {


            }
            column(ItemSort; ItemSort)
            {


            }
            column(UserID; UserID)
            {


            }
            column(UOM; UOM)
            {


            }
            column(GrandTotal; GrandTotal)
            {


            }


            trigger OnAfterGetRecord()
            var
                Cust: Record Customer;
            begin
                if Cust.Get(CustNo) then
                    CustomerName := Cust.Name
                else
                    CustomerName := '';
            end;

            trigger OnPreDataItem()
            begin
                If strlen("Item License".GetFilters) > 0 then begin
                    TmpRoyalty.Reset();
                    TmpRoyalty.SetFilter(License, "Item License".GetFilter(License));
                    TmpRoyalty.SetFilter(SubLicense, "Item License".GetFilter(Sublicense));
                end;
            end;




        }











    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(LastUpdated)
                {
                    Caption = 'Last Updated';
                    field(txtLastUpdatedDt; LastUpdatedDt)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = false;
                        Caption = 'Last Updated Date:';
                    }
                }
                group(Criteria)
                {
                    Caption = 'Date Filter';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }


                }


            }
        }
        actions
        {
            area(Processing)
            {
            }
        }


    }


    var
        StartDate: Date;
        EndDate: Date;
        GetRoyaltySum: Record TmpRoyaltySum;
        Item: Record Item;
        ChkItemLicense: Record ItemLicense;
        lblReportTitle: Label 'Royalty Summary Report';
        Company: Record "Company Information";
        txtFilters: Text;
        CashBasisItemSale: Record "Cash Basis Item Sales";

        GrandTotal: Decimal;

        LastUpdatedDt: Date;
        CustomerName: Text[100];


        TmpCashLE: Record TmpCashLE;
        ChkCBGLE: Record TmpCashLE;
        EntryNo: BigInteger;
        DateTime: DateTime;
        ChkItem: Record Item;

    trigger OnInitReport()
    begin
        /* if CBIS.FindFirst() then
             LastUpdatedDt := CBIS.CreatedDate;*/
        LastUpdatedDt := Today;
    end;

    trigger OnPreReport()
    begin
        FillTempRecordSetRealTime();

        If StartDate <> 0D then
            txtFilters := 'Date Filter: ' + Format(StartDate);
        If EndDate <> 0D then
            txtFilters += ' - ' + Format(EndDate);

        /* IF STRLEN(CBIS.GetFilters) > 0 then
             txtFilters += '   ' + CBIS.GetFilters;*/
        // 7/14/25 - start
        IF STRLEN("Item License".GetFilters) > 0 then
            txtFilters += '   ' + "Item License".GetFilters;
        // 7/14/25 - end
    end;

    procedure FillTempRecordSetRealTime()
    var
        ILE: Record "Item Ledger Entry";
        CBGLE: Record "SIMC Cash G/L Entry";
        GetCBGLE: Record "SIMC Cash G/L Entry";
        GetAmount: Decimal;
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLn: Record "Sales Invoice Line";
        InsTmpRoyalty: Record TmpRoyalty;
        CLE: Record "Cust. Ledger Entry";
        GetDescrip: Text;
        ChkTmpRoyalty: Record TmpRoyalty;
        GetTotal: Decimal;
        totalCashPaid: Decimal;
        DetCLE: Record "Detailed Cust. Ledg. Entry";
        GetQty: Decimal;
        ChkQty: Decimal;
        Cust: Record Customer;
        chkItemCount: Integer;
        ValueEntry: Record "Value Entry";
        SalesShipmentLn: Record "Sales Shipment Line";
        bFound: Boolean;
    begin
        DateTime := CurrentDateTime();
        Message('Start time =' + Format(DateTime));
        if Company.Get then;

        If StartDate <> 0D then
            txtFilters := 'Date Filter: ' + Format(StartDate);
        If EndDate <> 0D then
            txtFilters += ' - ' + Format(EndDate);

        IF STRLEN("Item License".GetFilters) > 0 then
            txtFilters += '   ' + "Item License".GetFilters;

        TmpRoyalty.DeleteAll();
        GetRoyaltySum.DeleteAll();
        TmpCashLE.DeleteAll();
        ChkCBGLE.DeleteAll();


        CBGLE.Reset();
        CBGLE.SetCurrentKey("Posting Date");
        CBGLE.SetRange("Posting Date", StartDate, EndDate);
        CBGLE.SetRange("Applied Document Type", CBGLE."Applied Document Type"::Payment);
        CBGLE.SetRange("Document Type", CBGLE."Document Type"::"Sales Invoice");
        CBGLE.SetRange("Source Type", CBGLE."Source Type"::Customer);
        CBGLE.SetRange("G/L Account No.", '40200');
        // CBGLE.SetRange("Document No.", '25101433');  //mbr test   
        //  CBGLE.SetRange("Source No.", 'WAL-MART SAMS-1587'); //mbr test

        IF CBGLE.FindSet() then
            repeat
                EntryNo += 1;
                TmpCashLE.Init();
                TmpCashLE."Entry No." := EntryNo;
                TmpCashLE."Posting Date" := CBGLE."Posting Date";
                TmpCashLE."Applied Document Type" := CBGLE."Applied Document Type";
                TmpCashLE."Source Type" := CBGLE."Source Type";
                TmpCashLE."Source No." := CBGLE."Source No.";
                TmpCashLE."Document Type" := CBGLE."Document Type";
                TmpCashLE."Document No." := CBGLE."Document No.";
                TmpCashLE.Amount := CBGLE.Amount;
                TmpCashLE.Insert();

                ChkCBGLE.Init();
                ChkCBGLE."Entry No." := EntryNo;
                ChkCBGLE."Posting Date" := CBGLE."Posting Date";
                ChkCBGLE."Applied Document Type" := CBGLE."Applied Document Type";
                ChkCBGLE."Source Type" := CBGLE."Source Type";
                ChkCBGLE."Source No." := CBGLE."Source No.";
                ChkCBGLE."Document Type" := CBGLE."Document Type";
                ChkCBGLE."Document No." := CBGLE."Document No.";
                ChkCBGLE.Amount := CBGLE.Amount;
                ChkCBGLE.Insert();

            until CBGLE.Next() = 0;


        TmpCashLE.Reset();
        TmpCashLE.SetCurrentKey("Posting Date", "Applied Document Type", "Source Type", "Document Type");
        TmpCashLE.SetRange("Posting Date", StartDate, EndDate);
        TmpCashLE.SetRange("Applied Document Type", TmpCashLE."Applied Document Type"::Payment);
        TmpCashLE.SetRange("Source Type", TmpCashLE."Source Type"::Customer);
        TmpCashLE.SetRange("Document Type", TmpCashLE."Document Type"::"Sales Invoice");



        IF TmpCashLE.FindSet() then
            repeat
                GetAmount := 0;

                GetCBGLE.Reset();
                GetCBGLE.SetCurrentKey("Posting Date", "Applied Document Type", "Source Type", "Source No.", "Document Type", "Document No.");
                GetCBGLE.SetRange("Posting Date", StartDate, EndDate);
                GetCBGLE.SetRange("Applied Document Type", GetCBGLE."Applied Document Type"::Payment);
                GetCBGLE.SetRange("Source Type", TmpCashLE."Source Type");
                GetCBGLE.SetRange("Source No.", TmpCashLE."Source No.");
                GetCBGLE.SetRange("Document Type", TmpCashLE."Document Type");
                GetCBGLE.SetRange("Document No.", TmpCashLE."Document No.");



                if GetCBGLE.FindSet() then
                    repeat
                        If GetCBGLE."Credit Amount" > 0 then
                            GetAmount := GetAmount + GetCBGLE."Credit Amount"
                        else
                            GetAmount := GetAmount - GetCBGLE."Debit Amount";
                    until GetCBGLE.Next() = 0;



                //now, let's add any early payment discount amounts which is in the CLE.  In Cash Basis LE, this is recorded in the G/L 40300 account
                CLE.Reset();
                CLE.SetRange("Document No.", TmpCashLE."Document No.");
                CLE.SetRange("Document Type", CLE."Document Type"::Invoice);
                CLE.SetRange("Customer No.", TmpCashLE."Source No.");
                CLE.SetFilter("Pmt. Disc. Given (LCY)", '>%1', 0);
                IF CLE.FindFirst() then
                    GetAmount := GetAmount - CLE."Pmt. Disc. Given (LCY)";

                GetRoyaltySum.Reset();
                GetRoyaltySum.SetCurrentKey(Type, CustNo, InvoiceNo);
                GetRoyaltySum.SetRange(Type, 'InvoiceTotal');
                GetRoyaltySum.SetRange(CustNo, TmpCashLE."Source No.");
                GetRoyaltySum.SetRange(InvoiceNo, TmpCashLE."Document No.");


                //Calculate total Invoice Amounts and store for later use
                If NOT GetRoyaltySum.FindFirst() then begin
                    GetRoyaltySum.Init();
                    GetRoyaltySum.CustNo := TmpCashLE."Source No.";
                    GetRoyaltySum.Type := 'InvoiceTotal';
                    GetRoyaltySum.CashPaidAmount := GetAmount;
                    GetRoyaltySum.InvoiceNo := TmpCashLE."Document No.";
                    GetRoyaltySum.DatePaid := TmpCashLE."Posting Date";
                    IF Cust.Get(TmpCashLE."Source No.") then begin
                        GetRoyaltySum.CustName := Cust.Name;
                        SalesInvHdr.Reset();
                        SalesInvHdr.SetCurrentKey("No.", "Sell-to Customer No.", "Order No.");
                        SalesInvHdr.SetRange("No.", GetRoyaltySum.InvoiceNo);
                        SalesInvHdr.SetRange("Sell-to Customer No.", TmpCashLE."Source No.");
                        If SalesInvHdr.FindFirst() then begin
                            GetRoyaltySum.OrderNo := SalesInvHdr."Order No.";
                            //Calculate Total Invoice amount - adjusted or not
                            if GetRoyaltySum.OrderNo <> '' then begin
                                //Now, sum up Item line total by going to Value Entries as some items may have been adjusted
                                SalesInvLn.Reset();
                                SalesInvLn.SetRange("Document No.", SalesInvHdr."No.");
                                SalesInvLn.SetFilter(Type, '=%1', SalesInvLn.Type::Item);
                                SalesInvLn.SetFilter(Quantity, '>%1', 0);
                                If SalesInvLn.FindSet() then
                                    repeat
                                        SalesShipmentLn.Reset();
                                        SalesShipmentLn.SetRange("Order No.", GetRoyaltySum.OrderNo);
                                        SalesShipmentLn.SetRange(Type, SalesShipmentLn.Type::Item);
                                        SalesShipmentLn.SetRange("No.", SalesInvLn."No.");
                                        SalesShipmentLn.SetRange("Order Line No.", SalesInvLn."Order Line No.");
                                        IF SalesShipmentLn.FindSet() then
                                            repeat
                                                ILE.Reset();
                                                ILE.SetCurrentKey("Entry No.", "Source Type", "Source No.");
                                                ILE.SetRange("Entry Type", ILE."Entry Type"::Sale);
                                                ILE.SetRange("Source Type", ILE."Source Type"::Customer);
                                                ILE.SetRange("Source No.", GetRoyaltySum.CustNo);
                                                ILE.SetRange("Sales Shipment Source No.", GetRoyaltySum.OrderNo);
                                                ILE.SetRange("Item No.", SalesShipmentLn."No.");
                                                ILE.SetRange("Document No.", SalesShipmentLn."Document No.");
                                                ILE.SetRange("Document Type", ILE."Document Type"::"Sales Shipment");
                                                ILE.SetRange("Document Line No.", SalesShipmentLn."Line No.");

                                                IF ILE.FindSet() then
                                                    repeat
                                                        ValueEntry.Reset();
                                                        ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
                                                        ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                                                        ValueEntry.SetRange("Item Ledger Entry No.", ILE."Entry No.");

                                                        If ValueEntry.FindSet() then
                                                            repeat
                                                                GetRoyaltySum.PaidAmount += ValueEntry."Sales Amount (Actual)";
                                                            until ValueEntry.Next() = 0;
                                                    until ILE.Next() = 0;
                                            Until SalesShipmentLn.Next() = 0

                                    until SalesInvLn.Next() = 0;


                            end
                            else begin
                                ValueEntry.Reset();
                                ValueEntry.SetRange("Document No.", GetRoyaltySum.InvoiceNo);
                                ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
                                ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
                                ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                                If ValueEntry.FindSet() then
                                    repeat
                                        GetRoyaltySum.PaidAmount += ValueEntry."Sales Amount (Actual)";
                                    until ValueEntry.Next() = 0;
                            end;
                        end;
                    end;

                    GetRoyaltySum.Insert;
                end;
            until TmpCashLE.Next() = 0;


        ChkItem.Reset();
        // ChkItem.CopyFilters(ItemRec);


        ChkItemLicense.RESET;
        ChkItemLicense.CopyFilters("Item License");

        GetRoyaltySum.reset;
        GetRoyaltySum.SetCurrentKey(Type);
        GetRoyaltySum.SetRange(Type, 'InvoiceTotal');
        GetRoyaltySum.SetFilter(OrderNo, '<>%1', '');
        IF GetRoyaltySum.FindSet() then
            repeat
                ILE.Reset();
                ILE.SetCurrentKey("Entry No.", "Source Type", "Source No.");
                ILE.SetRange("Entry Type", ILE."Entry Type"::Sale);
                ILE.SetRange("Source Type", ILE."Source Type"::Customer);
                ILE.SetRange("Source No.", GetRoyaltySum.CustNo);
                ILE.SetRange("Sales Shipment Source No.", GetRoyaltySum.OrderNo);
                //    ILE.SetRange("Item No.", '95312');  //mbr test

                IF ILE.FindSet() then
                    repeat
                        bFound := false;
                        //check if Chkitem filter applies to ILE
                        if chkItem.FindSet then begin
                            chkItem.FindFirst();
                            repeat
                                if ChkItem."No." = ILE."Item No." then
                                    bFound := true;
                            until (chkItem.Next() = 0) or (bFound = true);
                        end
                        else
                            bFound := true;

                        if bFound = true then begin
                            //need to check if corresponding invoice number is in Value Entry.  if not, do not include at all;
                            ValueEntry.Reset();
                            ValueEntry.SetRange("Document No.", GetRoyaltySum.InvoiceNo);
                            ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
                            ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
                            ValueEntry.SetRange("Item No.", ILE."Item No.");
                            ValueEntry.SetRange("Item Ledger Entry No.", ILE."Entry No.");
                            ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                            If ValueEntry.FindFirst() then begin
                                chkItemCount := 0;
                                ChkItemLicense.SetRange("Item No.", ILE."Item No.");
                                IF ChkItemLicense.FindSet() then
                                    repeat
                                        chkItemCount += 1;
                                        ILE.CalcFields("Sales Amount (Actual)", "Sales Shipment Source No.");
                                        TmpRoyalty.Reset();
                                        TmpRoyalty.SetCurrentKey(Type, CustNo, InvoiceNo, License, SubLicense, ItemNo);
                                        TmpRoyalty.SetRange(Type, 'Invoice');
                                        TmpRoyalty.SetRange(CustNo, ILE."Source No.");
                                        TmpRoyalty.SetRange(InvoiceNo, GetRoyaltySum.InvoiceNo);
                                        TmpRoyalty.SetRange(License, ChkItemLicense.License);
                                        TmpRoyalty.SetRange(SubLicense, ChkItemLicense.Sublicense);
                                        TmpRoyalty.SetRange(ItemNo, ILE."Item No.");


                                        If TmpRoyalty.FindFirst() then begin
                                            TmpRoyalty.Qty := TmpRoyalty.Qty + (Abs(ILE."Invoiced Quantity") * ChkItemLicense."License Percentage");
                                            TmpRoyalty.OriginalAmount := TmpRoyalty.OriginalAmount + (ILE."Sales Amount (Actual)" * ChkItemLicense."License Percentage");
                                            TmpRoyalty.PaidAmount := Round(TmpRoyalty.PaidAmount + GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount) * ChkItemLicense."License Percentage", 0.01);
                                            TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                            TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;
                                            TmpRoyalty.Modify(true);
                                        end
                                        else begin
                                            TmpRoyalty.Init();
                                            TmpRoyalty.Type := 'Invoice';
                                            TmpRoyalty.CustNo := ILE."Source No.";
                                            TmpRoyalty.ExtDocNo := ILE."External Document No.";
                                            TmpRoyalty.InvoiceNo := GetRoyaltySum.InvoiceNo;
                                            TmpRoyalty.OrderNo := GetRoyaltySum.OrderNo;
                                            TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                            TmpRoyalty.ItemNo := ILE."Item No.";
                                            If Item.get(TmpRoyalty.ItemNo) then
                                                TmpRoyalty.Description := Item.Description;
                                            TmpRoyalty.Qty := Abs(ILE."Invoiced Quantity") * ChkItemLicense."License Percentage";
                                            TmpRoyalty.OriginalAmount := ILE."Sales Amount (Actual)" * ChkItemLicense."License Percentage";
                                            if TmpRoyalty.Qty > 0 then
                                                TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;

                                            //Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Cash (or Payment) Received Amount]/[Total Invoice Amount]) * ([Item Line Amount]/[Total Invoice Amount]) * License Percentage
                                            //New Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Item Line Amount]/[Total Invoice Amount]) * License Percentage
                                            TmpRoyalty.PaidAmount := Round(GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount) * ChkItemLicense."License Percentage", 0.01);
                                            TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                            TmpRoyalty.DatePaid := GetRoyaltySum.DatePaid;
                                            TmpRoyalty.OrderNo := ILE."Sales Shipment Source No.";
                                            TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                            TmpRoyalty.License := ChkItemLicense.License;
                                            TmpRoyalty.SubLicense := ChkItemLicense.Sublicense;
                                            TmpRoyalty.ItemSort := 0;
                                            TmpRoyalty.UOM := ILE."Unit of Measure Code";
                                            TmpRoyalty.CashPaidAmount := GetRoyaltySum.CashPaidAmount;
                                            TmpRoyalty.CustName := GetRoyaltySum.CustName;
                                            TmpRoyalty.Insert();
                                        end;

                                    until ChkItemLicense.Next() = 0
                                else begin
                                    chkItemCount += 1;
                                    ILE.CalcFields("Sales Amount (Actual)", "Sales Shipment Source No.");
                                    TmpRoyalty.Reset();
                                    TmpRoyalty.SetCurrentKey(Type, CustNo, InvoiceNo, License, SubLicense, ItemNo);
                                    TmpRoyalty.SetRange(Type, 'Invoice');
                                    TmpRoyalty.SetRange(CustNo, ILE."Source No.");
                                    TmpRoyalty.SetRange(InvoiceNo, GetRoyaltySum.InvoiceNo);
                                    TmpRoyalty.SetRange(ItemNo, ILE."Item No.");



                                    If TmpRoyalty.FindFirst() then begin
                                        TmpRoyalty.Qty := TmpRoyalty.Qty + (Abs(ILE."Invoiced Quantity"));
                                        TmpRoyalty.OriginalAmount := TmpRoyalty.OriginalAmount + (ILE."Sales Amount (Actual)");
                                        TmpRoyalty.PaidAmount := Round(TmpRoyalty.PaidAmount + GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount), 0.01);
                                        TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                        TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;
                                        TmpRoyalty.Modify(true);
                                    end
                                    else begin
                                        TmpRoyalty.Init();
                                        TmpRoyalty.Type := 'Invoice';
                                        TmpRoyalty.CustNo := ILE."Source No.";
                                        TmpRoyalty.ExtDocNo := ILE."External Document No.";
                                        TmpRoyalty.InvoiceNo := GetRoyaltySum.InvoiceNo;
                                        TmpRoyalty.OrderNo := GetRoyaltySum.OrderNo;
                                        TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                        TmpRoyalty.ItemNo := ILE."Item No.";
                                        If Item.get(TmpRoyalty.ItemNo) then
                                            TmpRoyalty.Description := Item.Description;
                                        TmpRoyalty.Qty := Abs(ILE."Invoiced Quantity");
                                        TmpRoyalty.OriginalAmount := ILE."Sales Amount (Actual)";
                                        if TmpRoyalty.Qty > 0 then
                                            TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;

                                        //Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Cash (or Payment) Received Amount]/[Total Invoice Amount]) * ([Item Line Amount]/[Total Invoice Amount]) * License Percentage
                                        //New Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Item Line Amount]/[Total Invoice Amount]) 
                                        TmpRoyalty.PaidAmount := Round(GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount), 0.01);
                                        TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                        TmpRoyalty.DatePaid := GetRoyaltySum.DatePaid;
                                        TmpRoyalty.OrderNo := ILE."Sales Shipment Source No.";
                                        TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                        TmpRoyalty.ItemSort := 0;
                                        TmpRoyalty.UOM := ILE."Unit of Measure Code";
                                        TmpRoyalty.CashPaidAmount := GetRoyaltySum.CashPaidAmount;
                                        TmpRoyalty.CustName := GetRoyaltySum.CustName;
                                        TmpRoyalty.License := '';
                                        TmpRoyalty.SubLicense := '';
                                        TmpRoyalty.Insert();
                                    end;

                                    //   end;


                                end;

                            end;

                        end;
                    until ILE.Next() = 0;
            until GetRoyaltySum.Next() = 0;

        //Now, let's go through Invoices where OrderNo = Blank.  This means invoice was posted directly from Sales Invoice
        GetRoyaltySum.reset;
        GetRoyaltySum.SetCurrentKey(Type);
        GetRoyaltySum.SetRange(Type, 'InvoiceTotal');
        GetRoyaltySum.SetFilter(OrderNo, '=%1', '');
        IF GetRoyaltySum.FindSet() then
            repeat
                ValueEntry.Reset();
                ValueEntry.SetRange("Document No.", GetRoyaltySum.InvoiceNo);
                ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
                ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
                ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                ValueEntry.SetRange(Adjustment, false);
                If ValueEntry.FindSet() then
                    repeat
                        ILE.Reset();
                        ILE.SetRange("Entry No.", ValueEntry."Item Ledger Entry No.");
                        IF ILE.FindFirst() then begin
                            bFound := false;
                            //check if Chkitem filter applies to ILE
                            if chkItem.FindSet then begin
                                chkItem.FindFirst();
                                repeat
                                    if ChkItem."No." = ILE."Item No." then
                                        bFound := true;
                                until (chkItem.Next() = 0) or (bFound = true);
                            end
                            else
                                bFound := true;

                            if bFound = true then begin
                                chkItemCount := 0;
                                ChkItemLicense.SetRange("Item No.", ILE."Item No.");
                                IF ChkItemLicense.FindSet() then
                                    repeat
                                        chkItemCount += 1;
                                        ILE.CalcFields("Sales Amount (Actual)", "Sales Shipment Source No.");
                                        TmpRoyalty.Reset();
                                        TmpRoyalty.SetCurrentKey(Type, CustNo, InvoiceNo, License, SubLicense, ItemNo);
                                        TmpRoyalty.SetRange(Type, 'Invoice');
                                        TmpRoyalty.SetRange(CustNo, ILE."Source No.");
                                        TmpRoyalty.SetRange(InvoiceNo, GetRoyaltySum.InvoiceNo);
                                        TmpRoyalty.SetRange(License, ChkItemLicense.License);
                                        TmpRoyalty.SetRange(SubLicense, ChkItemLicense.Sublicense);
                                        TmpRoyalty.SetRange(ItemNo, ILE."Item No.");


                                        If TmpRoyalty.FindFirst() then begin
                                            TmpRoyalty.Qty := TmpRoyalty.Qty + (Abs(ILE."Invoiced Quantity") * ChkItemLicense."License Percentage");
                                            TmpRoyalty.OriginalAmount := TmpRoyalty.OriginalAmount + (ILE."Sales Amount (Actual)" * ChkItemLicense."License Percentage");
                                            TmpRoyalty.PaidAmount := Round(TmpRoyalty.PaidAmount + GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount) * ChkItemLicense."License Percentage", 0.01);
                                            TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                            TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;
                                            TmpRoyalty.Modify(true);
                                        end
                                        else begin
                                            TmpRoyalty.Init();
                                            TmpRoyalty.Type := 'Invoice';
                                            TmpRoyalty.CustNo := ILE."Source No.";
                                            TmpRoyalty.ExtDocNo := ILE."External Document No.";
                                            TmpRoyalty.InvoiceNo := GetRoyaltySum.InvoiceNo;
                                            TmpRoyalty.OrderNo := GetRoyaltySum.OrderNo;
                                            TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                            TmpRoyalty.ItemNo := ILE."Item No.";
                                            If Item.get(TmpRoyalty.ItemNo) then
                                                TmpRoyalty.Description := Item.Description;
                                            TmpRoyalty.Qty := Abs(ILE."Invoiced Quantity") * ChkItemLicense."License Percentage";
                                            TmpRoyalty.OriginalAmount := ILE."Sales Amount (Actual)" * ChkItemLicense."License Percentage";
                                            if TmpRoyalty.Qty > 0 then
                                                TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;

                                            //Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Cash (or Payment) Received Amount]/[Total Invoice Amount]) * ([Item Line Amount]/[Total Invoice Amount]) * License Percentage
                                            //New Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Item Line Amount]/[Total Invoice Amount]) * License Percentage
                                            TmpRoyalty.PaidAmount := Round(GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount) * ChkItemLicense."License Percentage", 0.01);
                                            TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                            TmpRoyalty.DatePaid := GetRoyaltySum.DatePaid;
                                            TmpRoyalty.OrderNo := ILE."Sales Shipment Source No.";
                                            TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                            TmpRoyalty.License := ChkItemLicense.License;
                                            TmpRoyalty.SubLicense := ChkItemLicense.Sublicense;
                                            TmpRoyalty.ItemSort := 0;
                                            TmpRoyalty.UOM := ILE."Unit of Measure Code";
                                            TmpRoyalty.CashPaidAmount := GetRoyaltySum.CashPaidAmount;
                                            TmpRoyalty.CustName := GetRoyaltySum.CustName;
                                            TmpRoyalty.Insert();
                                        end;

                                    until ChkItemLicense.Next() = 0
                                else begin
                                    chkItemCount += 1;
                                    ILE.CalcFields("Sales Amount (Actual)", "Sales Shipment Source No.");
                                    TmpRoyalty.Reset();
                                    TmpRoyalty.SetCurrentKey(Type, CustNo, InvoiceNo, License, SubLicense, ItemNo);
                                    TmpRoyalty.SetRange(Type, 'Invoice');
                                    TmpRoyalty.SetRange(CustNo, ILE."Source No.");
                                    TmpRoyalty.SetRange(InvoiceNo, GetRoyaltySum.InvoiceNo);
                                    TmpRoyalty.SetRange(ItemNo, ILE."Item No.");



                                    If TmpRoyalty.FindFirst() then begin
                                        TmpRoyalty.Qty := TmpRoyalty.Qty + (Abs(ILE."Invoiced Quantity"));
                                        TmpRoyalty.OriginalAmount := TmpRoyalty.OriginalAmount + (ILE."Sales Amount (Actual)");
                                        TmpRoyalty.PaidAmount := Round(TmpRoyalty.PaidAmount + GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount), 0.01);
                                        TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                        TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;
                                        TmpRoyalty.Modify(true);
                                    end
                                    else begin
                                        TmpRoyalty.Init();
                                        TmpRoyalty.Type := 'Invoice';
                                        TmpRoyalty.CustNo := ILE."Source No.";
                                        TmpRoyalty.ExtDocNo := ILE."External Document No.";
                                        TmpRoyalty.InvoiceNo := GetRoyaltySum.InvoiceNo;
                                        TmpRoyalty.OrderNo := GetRoyaltySum.OrderNo;
                                        TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                        TmpRoyalty.ItemNo := ILE."Item No.";
                                        If Item.get(TmpRoyalty.ItemNo) then
                                            TmpRoyalty.Description := Item.Description;
                                        TmpRoyalty.Qty := Abs(ILE."Invoiced Quantity");
                                        TmpRoyalty.OriginalAmount := ILE."Sales Amount (Actual)";
                                        if TmpRoyalty.Qty > 0 then
                                            TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;

                                        //Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Cash (or Payment) Received Amount]/[Total Invoice Amount]) * ([Item Line Amount]/[Total Invoice Amount]) * License Percentage
                                        //New Formula: Paid Amount = ([Cash (or Payment) Received Amount] * ([Item Line Amount]/[Total Invoice Amount]) 
                                        TmpRoyalty.PaidAmount := Round(GetRoyaltySum.CashPaidAmount * (ILE."Sales Amount (Actual)" / GetRoyaltySum.PaidAmount), 0.01);
                                        TmpRoyalty.OrigPaidAmount := TmpRoyalty.PaidAmount;
                                        TmpRoyalty.DatePaid := GetRoyaltySum.DatePaid;
                                        TmpRoyalty.OrderNo := ILE."Sales Shipment Source No.";
                                        TmpRoyalty.InvDiscExists := GetRoyaltySum.InvDiscExists;
                                        TmpRoyalty.ItemSort := 0;
                                        TmpRoyalty.UOM := ILE."Unit of Measure Code";
                                        TmpRoyalty.CashPaidAmount := GetRoyaltySum.CashPaidAmount;
                                        TmpRoyalty.CustName := GetRoyaltySum.CustName;
                                        TmpRoyalty.License := '';
                                        TmpRoyalty.SubLicense := '';
                                        TmpRoyalty.Insert();
                                    end;
                                end;
                            end;
                        end;
                    until ValueEntry.Next() = 0



            until GetRoyaltySum.Next() = 0;



        //GetRoyaltySum CLEANUP
        GetRoyaltySum.Reset();
        GetRoyaltySum.SetCurrentKey(Type);
        GetRoyaltySum.SetRange(Type, 'InvoiceTotal');

        IF GetRoyaltySum.FindSet() then
            repeat
                TmpRoyalty.Reset();
                TmpRoyalty.SetCurrentKey(Type, CustNo, InvoiceNo, License, SubLicense, ItemNo);
                TmpRoyalty.SetRange(Type, 'Invoice');
                TmpRoyalty.SetRange(CustNo, GetRoyaltySum.CustNo);
                TmpRoyalty.SetRange(InvoiceNo, GetRoyaltySum.InvoiceNo);
                IF Not TmpRoyalty.FindFirst() then
                    GetRoyaltySum.Delete();
            until GetRoyaltySum.Next() = 0;


        DateTime := CurrentDateTime();
        Message('End time =' + Format(DateTime));

        TmpRoyalty.Reset();
        //last but not least, let's calculate TmpCommission GrandTotal;
        GrandTotal := 0;
        TmpRoyalty.Reset();
        if TmpRoyalty.FindSet() then
            repeat
                GrandTotal += TmpRoyalty.PaidAmount;
            until TmpRoyalty.Next() = 0;


        TmpRoyalty.Reset();

    end;

    procedure FillTempRecordSet()
    var
        bFound: Boolean;
    begin


        if Company.Get then;

        If StartDate <> 0D then
            txtFilters := 'Date Filter: ' + Format(StartDate);
        If EndDate <> 0D then
            txtFilters += ' - ' + Format(EndDate);

        //   CashBasisItemSale.CopyFilters(CBIS);
        TmpRoyalty.DeleteAll();


        CashBasisItemSale.SetRange(DatePaid, StartDate, EndDate);

        IF CashBasisItemSale.FindSet() then
            repeat

                TmpRoyalty.Reset();
                TmpRoyalty.SetCurrentKey(Type, CustNo, InvoiceNo, License, SubLicense, ItemNo);
                TmpRoyalty.SetRange(Type, 'Invoice');
                TmpRoyalty.SetRange(CustNo, CashBasisItemSale.CustNo);
                TmpRoyalty.SetRange(InvoiceNo, CashBasisItemSale.InvoiceNo);
                TmpRoyalty.SetRange(License, CashBasisItemSale.License);
                TmpRoyalty.SetRange(SubLicense, CashBasisItemSale.SubLicense);
                TmpRoyalty.SetRange(ItemNo, CashBasisItemSale.ItemNo);


                If TmpRoyalty.FindFirst() then begin

                    TmpRoyalty.PaidAmount += CashBasisItemSale.PaidAmount;
                    TmpRoyalty.OrigPaidAmount += CashBasisItemSale.OrigPaidAmount;
                    TmpRoyalty.Modify(true);
                end
                else begin
                    TmpRoyalty.Init();
                    TmpRoyalty.Type := 'Invoice';
                    TmpRoyalty.CustNo := CashBasisItemSale.CustNo;
                    TmpRoyalty.InvoiceNo := CashBasisItemSale.InvoiceNo;
                    TmpRoyalty.ItemNo := CashBasisItemSale.ItemNo;
                    TmpRoyalty.Description := CashBasisItemSale.Description;
                    TmpRoyalty.Qty := CashBasisItemSale.Qty;
                    TmpRoyalty.PaidAmount := CashBasisItemSale.PaidAmount;
                    TmpRoyalty.OrigPaidAmount := CashBasisItemSale.OrigPaidAmount;
                    TmpRoyalty.DatePaid := CashBasisItemSale.DatePaid;
                    TmpRoyalty.License := CashBasisItemSale.License;
                    TmpRoyalty.SubLicense := CashBasisItemSale.Sublicense;
                    TmpRoyalty.ItemSort := 0;
                    TmpRoyalty.UOM := CashBasisItemSale.UOM;
                    TmpRoyalty.CustName := CashBasisItemSale.CustName;
                    TmpRoyalty.Insert();
                end;








            until CashBasisItemSale.Next() = 0;



        TmpRoyalty.Reset();
        //last but not least, let's calculate TmpCommission GrandTotal;
        GrandTotal := 0;
        TmpRoyalty.Reset();
        if TmpRoyalty.FindSet() then
            repeat
                GrandTotal += TmpRoyalty.PaidAmount;
            until TmpRoyalty.Next() = 0;

        TmpRoyalty.Reset();
    end;


}


