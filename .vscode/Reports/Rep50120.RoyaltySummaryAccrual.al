report 50120 RoyaltySummaryAccrual
{
    ApplicationArea = All;
    Caption = 'Royalty Summary Report - Accrual';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/RoyalySummaryAccrualReport.rdl';

    dataset
    {

        dataitem("Item License"; ItemLicense)
        {
            RequestFilterFields = License, Sublicense;


            dataitem(TmpRoyalty; TmpRoyalty)
            {
                DataItemLink = ItemNo = field("Item No."), license = field(License), SubLicense = field(SubLicense);
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
                column(License; "Item License".License)
                {

                }
                column(SubLicense; "Item License".Sublicense)
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
                column(SalesPrice; SalesPrice)
                {
                }
                column(OriginalAmount; OriginalAmount)
                {
                }
                column(TotalInvoiceLnAmount; TotalInvoiceLnAmount)
                {

                }
                column(PaidAmount; PaidAmount)
                {
                }
                column(ReturnedAmount; ReturnedAmount)
                {

                }
                column(ReturnedQty; ReturnedQty)
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
                column(FinalInvoiceAmount; FinalInvoiceAmount)
                {

                }
                column(Qty; FinalQty)
                {

                }
                column(WeightedQty; WeightedQty)
                {

                }

                trigger OnAfterGetRecord()
                begin

                end;


            }



        }


    }
    requestpage
    {
        layout
        {
            area(Content)
            {
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


    }

    var


        GrandTotal: Decimal;
        StartDate: Date;
        EndDate: Date;
        GetRoyaltySum: Record TmpRoyaltySum;
        Item: Record Item;
        lblNoItemLicense: Label 'No Items found with the current License Filter of %1';
        lblReportTitle: Label 'Royalty Summary Report - Accrual Sales by Item';
        Company: Record "Company Information";
        txtFilters: Text;

        DateTime: DateTime;

    trigger OnInitReport()
    begin


    end;

    trigger OnPreReport()

    begin

        FillTempRecordSet();


    end;



    procedure FillTempRecordSet()
    var
        ItemLicense: Record ItemLicense;
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLn: Record "Sales Invoice Line";
        GetQtyReturned: Decimal;
        GetReturnedAmt: Decimal;
        Cust: Record Customer;
        SalesCRHdr: Record "Sales Cr.Memo Header";
        SalesCRLn: Record "Sales Cr.Memo Line";
    begin


        DateTime := CurrentDateTime();
        //Message('Start time =' + Format(DateTime));
        if Company.Get then;

        If StartDate <> 0D then
            txtFilters := 'Date Filter: ' + Format(StartDate);
        If EndDate <> 0D then
            txtFilters += ' - ' + Format(EndDate);

        IF STRLEN("Item License".GetFilters) > 0 then
            txtFilters += '   ' + "Item License".GetFilters;


        TmpRoyalty.DeleteAll();

        ItemLicense.COPYFILTERS("Item License");
        If ItemLicense.FindSet() then begin
            repeat
                SalesInvLn.Reset();
                SalesInvLn.SetCurrentKey("Order No.", "Order Line No.", "Posting Date");
                SalesInvLn.SetRange("Posting Date", StartDate, EndDate);
                SalesInvLn.SetRange(Type, SalesInvLn.Type::Item);
                SalesInvLn.SetRange("No.", ItemLicense."Item No.");

                If SalesInvLn.FindSet() then
                    repeat
                        SalesInvLn.CalcFields("External Document No.");
                        TmpRoyalty.RESET;
                        TmpRoyalty.SetCurrentKey(Type, CustNo, InvoiceNo, License, Sublicense, ItemNo);
                        TmpRoyalty.SetRange(Type, 'Invoice');
                        TmpRoyalty.SetRange(CustNo, SalesInvLn."Sell-to Customer No.");
                        TmpRoyalty.SetRange(InvoiceNo, SalesInvLn."Document No.");
                        TmpRoyalty.SetRange(License, ItemLicense.License);
                        TmpRoyalty.SetRange(SubLicense, ItemLicense.Sublicense);
                        TmpRoyalty.SetRange(ItemNo, SalesInvLn."No.");
                        IF TmpRoyalty.FindFirst() then begin

                            TmpRoyalty.Qty += SalesInvLn.Quantity;
                            TmpRoyalty.OriginalAmount += (SalesInvLn."Line Amount" * ItemLicense."License Percentage");
                            if TmpRoyalty.Qty > 0 then
                                TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;
                            TmpRoyalty.PaidAmount += (SalesInvLn.Amount * ItemLicense."License Percentage");  //use Paid Amount to reflect amount after discount
                                                                                                              //check to see if we have any Sales CM for this item
                            GetQtyReturned := 0;
                            GetReturnedAmt := 0;
                            SalesCRHdr.Reset();
                            SalesCRHdr.SetRange("External Document No.", SalesInvLn."External Document No.");
                            SalesCRHdr.SetRange("Posting Date", StartDate, EndDate);
                            IF SalesCRHdr.FindSet() then
                                repeat
                                    SalesCRLn.Reset();
                                    SalesCRLn.SetRange("Posting Date", StartDate, EndDate);
                                    SalesCRLn.SetRange("Document No.", SalesCRHdr."No.");
                                    SalesCRLn.SetRange(Type, SalesCRLn.Type::Item);
                                    SalesCRLn.SetRange("No.", SalesInvLn."No.");
                                    If SalesCRLn.FindSet() then
                                        repeat
                                            GetReturnedAmt += SalesCRLn.Amount;
                                            GetQtyReturned += SalesCRLn.Quantity
                                        until SalesCRLn.Next() = 0;
                                until SalesCRHdr.Next() = 0;
                            TmpRoyalty.ReturnedAmount += (GetReturnedAmt * ItemLicense."License Percentage");
                            TmpRoyalty.ReturnedQty += GetQtyReturned;
                            TmpRoyalty.FinalInvoiceAmount := (TmpRoyalty.PaidAmount - TmpRoyalty.ReturnedAmount);
                            TmpRoyalty.FinalQty := (TmpRoyalty.Qty - TmpRoyalty.ReturnedQty);
                            TmpRoyalty.WeightedQty := TmpRoyalty.Qty * ItemLicense."License Percentage";
                            TmpRoyalty.Modify();
                        end
                        else begin
                            TmpRoyalty.Init();
                            TmpRoyalty.Type := 'Invoice';
                            TmpRoyalty.CustNo := SalesInvLn."Sell-to Customer No.";
                            TmpRoyalty.ExtDocNo := SalesInvLn."External Document No.";
                            TmpRoyalty.InvoiceNo := SalesInvLn."Document No.";
                            TmpRoyalty.ItemNo := SalesInvLn."No.";
                            If Item.get(TmpRoyalty.ItemNo) then
                                TmpRoyalty.Description := Item.Description;
                            TmpRoyalty.Qty := SalesInvLn.Quantity;
                            TmpRoyalty.OriginalAmount := SalesInvLn."Line Amount" * ItemLicense."License Percentage";
                            if TmpRoyalty.Qty > 0 then
                                TmpRoyalty.SalesPrice := TmpRoyalty.OriginalAmount / TmpRoyalty.Qty;
                            TmpRoyalty.PaidAmount := (SalesInvLn.Amount * ItemLicense."License Percentage");  //use Paid Amount to reflect amount after discount
                                                                                                              //check to see if we have any Sales CM for this item
                            GetQtyReturned := 0;
                            GetReturnedAmt := 0;
                            SalesCRHdr.Reset();
                            SalesCRHdr.SetRange("External Document No.", SalesInvLn."External Document No.");
                            SalesCRHdr.SetRange("Posting Date", StartDate, EndDate);
                            IF SalesCRHdr.FindSet() then
                                repeat
                                    SalesCRLn.Reset();
                                    SalesCRLn.SetRange("Posting Date", StartDate, EndDate);
                                    SalesCRLn.SetRange("Document No.", SalesCRHdr."No.");
                                    SalesCRLn.SetRange(Type, SalesCRLn.Type::Item);
                                    SalesCRLn.SetRange("No.", SalesInvLn."No.");
                                    If SalesCRLn.FindSet() then
                                        repeat
                                            GetReturnedAmt += SalesCRLn.Amount;
                                            GetQtyReturned += SalesCRLn.Quantity
                                        until SalesCRLn.Next() = 0;
                                until SalesCRHdr.Next() = 0;
                            TmpRoyalty.ReturnedAmount := GetReturnedAmt * ItemLicense."License Percentage";
                            TmpRoyalty.ReturnedQty := GetQtyReturned;
                            TmpRoyalty.FinalInvoiceAmount := TmpRoyalty.PaidAmount - TmpRoyalty.ReturnedAmount;

                            TmpRoyalty.License := ItemLicense.License;
                            TmpRoyalty.SubLicense := ItemLicense.Sublicense;
                            TmpRoyalty.ItemSort := 0;
                            TmpRoyalty.UOM := SalesInvLn."Unit of Measure Code";
                            If Cust.Get(SalesInvLn."Sell-to Customer No.") then
                                TmpRoyalty.CustName := Cust.Name;
                            TmpRoyalty.FinalQty := TmpRoyalty.Qty - TmpRoyalty.ReturnedQty;
                            TmpRoyalty.WeightedQty := TmpRoyalty.Qty * ItemLicense."License Percentage";
                            TmpRoyalty.Insert();
                        end;
                    until SalesInvLn.Next() = 0;
            until ItemLicense.Next() = 0;

        end;

        //last but not least, let's calculate TmpRoyalty GrandTotal;
        GrandTotal := 0;
        TmpRoyalty.Reset();
        if TmpRoyalty.FindSet() then
            repeat
                GrandTotal += TmpRoyalty.FinalInvoiceAmount;
            until TmpRoyalty.Next() = 0;

        DateTime := CurrentDateTime();
        //Message('End time =' + Format(DateTime));




    end;

}
