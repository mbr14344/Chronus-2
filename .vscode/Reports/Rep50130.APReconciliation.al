report 50130 "AP Reconciliation By GLEntry"
{
    Caption = 'AP Reconciliation By G/L Entry';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/APReconciliationByGLEntry.rdl';

    // DataItem: G/L Entry
    dataset
    {
        dataitem(GLE; "G/L Entry")
        {
            DataItemTableView = where("G/L Account No." = const('20100'));
            column(PostingDate; "Posting Date") { }
            column(DocumentNo; "Document No.") { }
            column(VendorNo; GLE."Source No.") { }
            column(Description; Description) { }
            column(Amount; Amount) { }



            column(RemainingAmount; RemAmt) { }
            column(DocumentStatus; Status) { }
            // Calculate status per G/L line
            trigger OnAfterGetRecord()
            begin
                IF GLE."Source Type" = GLE."Source Type"::Vendor then begin
                    VLE.Reset();
                    VLE.SetRange("Document No.", GLE."Document No.");
                    VLE.SetRange("Vendor No.", GLE."Source No.");
                    IF VLE.FindFirst() then begin
                        VLE.CalcFields("Remaining Amount");
                        RemAmt := VLE."Remaining Amount";
                        if RemAmt = 0 then
                            Status := 'Closed'
                        else
                            Status := 'Open';
                    end else
                        Status := 'Manual/System';
                end
                else
                    Status := 'Manual/System';

            end;
        }



    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(FilterGroup)
                {
                    field("Posting Date Filter"; GLE."Posting Date") { ApplicationArea = All; }
                }
            }
        }
    }


    var
        VLE: Record "Vendor Ledger Entry";
        Status: Text[20];
        RemAmt: Decimal;

}
