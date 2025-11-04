report 50010 "Check Detail"
{
    //MBR 001 1/23/2024
    //This report is a supplemental report for the CheckCustom_CheckStubSub and will list all applied entries for the given check
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/CheckDetails.rdl';

    CaptionML = ENU = 'Check Details';

    UseRequestPage = true;

    dataset
    {
        dataitem("Gen Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Posting Date";


            column(GenJnlLine_Journal_Template_Name; "Journal Template Name")
            {
            }
            column(GenJnlLine_Journal_Batch_Name; "Journal Batch Name")
            {
            }
            column(GenJnlLine_Line_No_; "Line No.")
            {
            }
            column(CompanyName; CompanyName)
            {

            }
            column(Description; Description)
            {

            }
            column(Amount; Amount)
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Document_No_; "Document No.")
            {

            }

            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Applies-to ID" = field("Applies-to ID");
                DataItemTableView = SORTING("Document No.");
                column(External_Document_No_; "External Document No.")
                {

                }
                column(Document_Date; "Document Date")
                {

                }
                column(Original_Amount; abs("Original Amount"))
                {

                }
                column(Remaining_Amount; abs("Remaining Amount"))
                {

                }
                column(Amount_to_Apply; LineAmountApplied)
                {

                }
                column(PmtType; PmtType)
                {

                }
                column(bVisible; bVisible)
                {

                }
                column(LineDiscount; ABS("Vendor Ledger Entry"."Remaining Pmt. Disc. Possible"))
                {

                }
                trigger OnPreDataItem()
                begin
                    bVisible := FALSE;
                    "Vendor Ledger Entry".SetRange("Vendor Ledger Entry"."Vendor No.", "Gen Journal Line"."Account No.");
                    "Vendor Ledger Entry".SetRange("Vendor Ledger Entry"."Document Type", "Vendor Ledger Entry"."Document Type"::Invoice);
                    if "Vendor Ledger Entry".Count = 0 then
                        bVisible := TRUE;
                end;

                trigger OnAfterGetRecord()
                begin
                    PmtType := '';
                    bVisible := FALSE;
                    LineAmountApplied := 0;
                    IF STRLEN("Gen Journal Line"."Applies-to Doc. No.") > 0 then BEGIN
                        if "Gen Journal Line"."Applies-to Doc. No." <> "Vendor Ledger Entry"."Document No." then
                            CurrReport.Skip()
                        else
                            if "Gen Journal Line"."Applies-to Doc. No." = "Vendor Ledger Entry"."Document No." then begin
                                IF "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then
                                    PmtType := 'Bill';
                                "Vendor Ledger Entry".CalcFields("Original Amount", "Remaining Amount");
                                LineAmountApplied := "Gen Journal Line".Amount * -1;
                            end;

                    END
                    ELSE BEGIN
                        IF "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."Document Type"::Invoice then
                            PmtType := 'Bill'
                        else
                            PmtType := Format("Vendor Ledger Entry"."Document Type");

                        "Vendor Ledger Entry".CalcFields("Original Amount", "Remaining Amount");
                        LineAmountApplied := "Vendor Ledger Entry"."Amount to Apply";
                    END;
                end;

            }
        }
    }
    var

        CompanyInformation: Record 79;
        CompanyName: Text;
        PmtType: Text;
        bVisible: Boolean;
        LineAmountApplied: Decimal;

    trigger OnPreReport()
    begin
        CompanyInformation.GET;
        CompanyName := CompanyInformation.Name

    end;
}

