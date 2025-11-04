report 50018 "Vendor Open Payments Report"
{
    Caption = 'Vendor Open Payments Report';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/VendorOpenPaymentsReport.rdl';
    dataset
    {
        dataitem(VendorLedgerEntry; "Vendor Ledger Entry")
        {
            column(Open; Open)
            {
            }
            column(Company; Company.Name)
            {

            }
            column(lblReportTitle; lblReportTitle)
            {

            }

            column(VendorNo; "Vendor No.")
            {
            }
            column(VendorName; "Vendor Name")
            {
            }
            column(Remaining_Amount; "Remaining Amount")
            {

            }
            column(TotalInvAmount; TotalInvAmount)
            {

            }
            column(TotalPOAmount; TotalPOAmount)
            {

            }
            trigger OnPreDataItem()
            begin
                if Company.Get then;
                VendorLedgerEntry.Reset();
                VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Payment);
                VendorLedgerEntry.SetRange(Open, true);
            end;

            trigger OnAfterGetRecord()
            begin
                TotalInvAmount := 0;
                VLE.Reset();
                VLE.SetRange("Document Type", VLE."Document Type"::Invoice);
                VLE.SetRange(Open, true);
                VLE.SetRange("Vendor No.", VendorLedgerEntry."Vendor No.");
                if VLE.FindSet() then
                    repeat
                        VLE.CalcFields("Remaining Amount");
                        TotalInvAmount := TotalInvAmount + (Vle."Remaining Amount" * -1);
                    until VLE.Next() = 0;
                TotalPOAmount := 0;
                POLine.Reset;
                POLine.SetRange("Buy-from Vendor No.", VLE."Vendor No.");
                POLine.SetRange("Document Type", POLine."Document Type"::Order);

                IF POLine.FindSet() then
                    repeat
                        TotalPOAmount += POLine."Outstanding Amount";
                    Until POLine.Next() = 0;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

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
        lblReportTitle: Label 'Vendor Open Payment Report';
        Company: Record "Company Information";
        TotalInvAmount: Decimal;
        TotalPOAmount: Decimal;
        VLE: Record "Vendor Ledger Entry";
        POLine: Record "Purchase Line";
}
