report 50017 RoyaltySummaryReport
{
    ApplicationArea = All;
    Caption = 'Royalty Summary Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/RoyalySummaryReport.rdl';


    dataset
    {


        dataitem(CBIS; "Cash Basis Item Sales")
        {
            RequestFilterFields = License, SubLicense, ItemNo;
            trigger OnAfterGetRecord()
            begin
                CurrReport.Skip();
            end;


        }
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

        lblReportTitle: Label 'Royalty Summary Report';
        Company: Record "Company Information";
        txtFilters: Text;
        CashBasisItemSale: Record "Cash Basis Item Sales";

        GrandTotal: Decimal;

        LastUpdatedDt: Date;
        CustomerName: Text[100];

    trigger OnInitReport()
    begin
        if CBIS.FindFirst() then
            LastUpdatedDt := CBIS.CreatedDate;
    end;

    trigger OnPreReport()
    begin
        FillTempRecordSet();

        If StartDate <> 0D then
            txtFilters := 'Date Filter: ' + Format(StartDate);
        If EndDate <> 0D then
            txtFilters += ' - ' + Format(EndDate);

        IF STRLEN(CBIS.GetFilters) > 0 then
            txtFilters += '   ' + CBIS.GetFilters;
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

        CashBasisItemSale.CopyFilters(CBIS);
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


