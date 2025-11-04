report 50121 "Salesperson Commission - Cash"
{
    ApplicationArea = All;
    Caption = 'Salesperson Commission Report - Cash';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/SalesPersonCommissionCashReport.rdl';

    dataset
    {
        dataitem(SalesPersonCommission; SalesPersonCommission)
        {
            column(txtFilters; txtFilters)
            {

            }
            column(Company; Company.Name)
            {

            }
            column(lblReportTitle; lblReportTitle)
            {

            }
            column(SalesPersonCode; SalesPersonCode)
            {

            }
            column(CustNo; CustNo)
            {

            }
            column(CustName; CustName)
            {

            }
            column(PaidAmount; PaidAmount * -1)
            {

            }
            column(OriginalInvoiceAmount; OriginalInvoiceAmount)
            {

            }
            column(InvoiceAmountPaidByCM; InvoiceAmountPaidByCM)
            {

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
                    field(SalesPersonCode; SalesPersonCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Salesperson Code';
                        TableRelation = "Salesperson/Purchaser" where(Blocked = const(false));
                    }

                }
            }
        }

    }
    trigger OnPreReport()

    begin
        FillTempRecordSet();
    end;

    var
        StartDate: Date;
        EndDate: Date;
        txtFilters: Text;
        Company: Record "Company Information";
        lblReportTitle: Label 'Salesperson Commission Report - Cash';
        TmpCommissionGet: Record SalesPersonCommission;
        TmpCommissionCMGet: Record SalesPersonCommission;
        SalesPersonCode: Code[20];
        SRSetup: Record "Sales & Receivables Setup";

    procedure FillTempRecordSet()
    var
        CBGLE: Record "SIMC Cash G/L Entry";
        Customer: Record Customer;
        GetSalesPersonCode: Code[20];
        CLE: Record "Cust. Ledger Entry";
        bCont: Boolean;
    begin
        if Company.Get then;
        if SRSetup.Find() then;

        If StartDate <> 0D then
            txtFilters := 'Date Filter: ' + Format(StartDate);
        If EndDate <> 0D then
            txtFilters += ' - ' + Format(EndDate);

        IF STRLEN(SalesPersonCode) > 0 then
            txtFilters += '   Salesperson Filter: ' + SalesPersonCode;

        SalesPersonCommission.DeleteAll();




        CBGLE.Reset();
        CBGLE.SetCurrentKey("Posting Date");
        CBGLE.SetRange("Posting Date", StartDate, EndDate);
        CBGLE.SetRange("Applied Document Type", CBGLE."Applied Document Type"::Payment);
        CBGLE.SetRange("Document Type", CBGLE."Document Type"::"Sales Invoice");
        CBGLE.SetRange("Source Type", CBGLE."Source Type"::Customer);
        CBGLE.SetFilter("Document Posting Date", '>=%1', SRSetup.InvoiceEarliestDate);
        CBGLE.SetRange("G/L Account No.", '40200');
        // CBGLE.SetRange("Document No.", 'PS-INV1002054');  //mbr test   



        IF CBGLE.FindSet() then
            repeat
                If Customer.GET(CBGLE."Source No.") then;
                IF STRLEN(Customer."Salesperson Code") = 0 then
                    GetSalesPersonCode := 'Unassigned'
                else
                    GetSalesPersonCode := Customer."Salesperson Code";

                bCont := false;

                IF STRLEN(SalesPersonCode) > 0 then begin
                    IF strpos(SalesPersonCode, Customer."Salesperson Code") > 0 then
                        bCont := true;
                end
                else
                    bCont := true;

                if bCont = true then begin
                    SalesPersonCommission.Reset();
                    SalesPersonCommission.SetRange(SalesPersonCode, GetSalesPersonCode);
                    SalesPersonCommission.SetRange(CustNo, CBGLE."Source No.");
                    IF SalesPersonCommission.FindFirst() then begin
                        SalesPersonCommission.PaidAmount += (CBGLE.Amount);
                        SalesPersonCommission.Modify();
                    end
                    else begin
                        SalesPersonCommission.Init();
                        SalesPersonCommission.SalesPersonCode := GetSalesPersonCode;
                        SalesPersonCommission.CustNo := CBGLE."Source No.";
                        SalesPersonCommission.PaidAmount := (CBGLE.Amount);
                        SalesPersonCommission.Insert();
                    end;
                end;
            until CBGLE.Next() = 0;
        //now, let's get the Sales Invoice Original Amounts 

        SalesPersonCommission.Reset();
        IF SalesPersonCommission.FindSet() then
            repeat
                TmpCommissionGet.DeleteAll();
                TmpCommissionCMGet.DeleteAll();
                CBGLE.Reset();
                CBGLE.SetCurrentKey("Posting Date");
                CBGLE.SetRange("Posting Date", StartDate, EndDate);
                CBGLE.SetRange("Applied Document Type", CBGLE."Applied Document Type"::Payment);
                CBGLE.SetRange("Document Type", CBGLE."Document Type"::"Sales Invoice");
                CBGLE.SetRange("Source Type", CBGLE."Source Type"::Customer);
                CBGLE.SetRange("Source No.", SalesPersonCommission.CustNo);
                CBGLE.SetFilter("Document Posting Date", '>=%1', SRSetup.InvoiceEarliestDate);
                IF CBGLE.FindSet() then
                    repeat
                        TmpCommissionGet.Reset();
                        TmpCommissionGet.SetRange(CustNo, CBGLE."Source No.");
                        TmpCommissionGet.SetRange(DocumentNo, CBGLE."Document No.");
                        if NOT TmpCommissionGet.FindFirst() then begin
                            TmpCommissionGet.CustNo := CBGLE."Source No.";
                            TmpCommissionGet.DocumentNo := CBGLE."Document No.";
                            TmpCommissionGet.Insert;
                        end;

                    until CBGLE.Next() = 0;

                TmpCommissionGet.Reset;
                TmpCommissionGet.SetRange(CustNo, SalesPersonCommission.CustNo);
                IF TmpCommissionGet.findset then
                    repeat
                        CLE.Reset;
                        CLE.SetRange("Document No.", TmpCommissionGet.DocumentNo);
                        CLE.Setrange("Document Type", CLE."Document Type"::Invoice);
                        CLE.SetRange("Customer No.", TmpCommissionGet.CustNo);
                        IF CLE.FindFirst() then begin
                            CLE.CalcFields(Amount);
                            SalesPersonCommission.OriginalInvoiceAmount += ABS(CLE.Amount);
                            SalesPersonCommission.Modify();
                        end;
                    until TmpCommissionGet.Next() = 0;
                //now, let's calculate total invoices Paid by sales CM
                CBGLE.Reset();
                CBGLE.SetCurrentKey("Posting Date");
                CBGLE.SetRange("Posting Date", StartDate, EndDate);
                CBGLE.SetRange("Applied Document Type", CBGLE."Applied Document Type"::"Sales Cr. Memo");
                CBGLE.SetRange("Document Type", CBGLE."Document Type"::"Sales Invoice");
                CBGLE.SetRange("Source Type", CBGLE."Source Type"::Customer);
                CBGLE.SetRange("Source No.", SalesPersonCommission.CustNo);
                CBGLE.SetFilter("Document Posting Date", '>=%1', SRSetup.InvoiceEarliestDate);
                IF CBGLE.FindSet() then
                    repeat
                        TmpCommissionCMGet.Reset();
                        TmpCommissionCMGet.SetRange(CustNo, CBGLE."Source No.");
                        TmpCommissionCMGet.SetRange(DocumentNo, CBGLE."Document No.");
                        if NOT TmpCommissionCMGet.FindFirst() then begin
                            TmpCommissionCMGet.CustNo := CBGLE."Source No.";
                            TmpCommissionCMGet.DocumentNo := CBGLE."Document No.";
                            TmpCommissionCMGet.Insert;
                        end;
                    until CBGLE.Next() = 0;

                TmpCommissionCMGet.Reset;
                TmpCommissionCMGet.SetRange(CustNo, SalesPersonCommission.CustNo);
                IF TmpCommissionCMGet.findset then
                    repeat
                        TmpCommissionGet.Reset();
                        TmpCommissionGet.SetRange(CustNo, TmpCommissionCMGet.CustNo);
                        TmpCommissionGet.SetRange(DocumentNo, TmpCommissionCMGet.DocumentNo);
                        IF not TmpCommissionGet.FindFirst() then begin
                            CLE.Reset;
                            CLE.SetRange("Document No.", TmpCommissionCMGet.DocumentNo);
                            CLE.Setrange("Document Type", CLE."Document Type"::Invoice);
                            CLE.SetRange("Customer No.", TmpCommissionCMGet.CustNo);
                            IF CLE.FindFirst() then begin
                                CLE.CalcFields(Amount);
                                SalesPersonCommission.InvoiceAmountPaidByCM += ABS(CLE.Amount);
                                SalesPersonCommission.Modify();
                            end;
                        end;

                    until TmpCommissionCMGet.Next() = 0;

            until SalesPersonCommission.Next() = 0;



    end;
}
