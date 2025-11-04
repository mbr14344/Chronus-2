pageextension 50012 SalesAndRecievableSetup extends "Sales & Receivables Setup"
{
    //pr1/24/24 set up BOL fields for master bol
    layout
    {
        addafter("Price List Nos.")
        {
            field("Single BOL Nos."; Rec."Single BOL Nos.")
            {
                Caption = 'Single BOL Nos.';
                ApplicationArea = all;
                ToolTip = 'Specifies the code for the number series that will be used to assign numbers to Single BOL in Sales Order.';
            }
            field("Master BOL Nos."; Rec."Master BOL Nos.")
            {
                Caption = 'Master BOL Nos.';
                ApplicationArea = all;
                ToolTip = 'Specifies the code for the number series that will be used to assign numbers to Master BOL.';
            }


        }
        addafter("Update Document Date When Posting Date Is Modified")
        {
            field(EDILineDiscountCAP; Rec.EDILineDiscountCAP)
            {
                ApplicationArea = all;
            }
            field("Payment Discount % Cap"; Rec."Payment Discount % Cap")
            {
                ApplicationArea = all;
            }
        }
        addafter("Document Default Line Type")
        {
            field("Commodity Description"; Rec."Commodity Description")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the general commodity description to be used in the BOL Report.';
            }
            field("NMFC No."; Rec."NMFC No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the NMFC No. to be used in the BOL Report.';
            }
            field(InvoiceEarliestDate; Rec.InvoiceEarliestDate)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the earliest posting date to consider for all invoices in the cash basis reports.';
            }
            field(FTPUploadURL; Rec.FTPUploadURL)
            {
                ApplicationArea = All;
                MultiLine = true;
            }
            field(FTPServername; Rec.FTPServername)
            {
                ApplicationArea = All;
            }
        }
        addafter(General)
        {
            group(Email)
            {
                Caption = 'E-mail';
                group(APToGL)
                {
                    Caption = 'SO DC Breakdown';
                    field(SODCBreakdownSubject; Rec.SODCBreakdownSubject)
                    {
                        ApplicationArea = All;
                    }
                    field(SODCBreakdownBody; Rec.SODCBreakdownBody)
                    {

                        ApplicationArea = All;
                        MultiLine = true;
                    }
                    field(SODCBreakdownClosing; Rec.SODCBreakdownClosing)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                    }
                }

            }
            group(SummaryTotals)
            {
                Caption = 'Sales by Item Summary Job';
                field(SalesByItemSummaryStartDate; Rec.SalesByItemSummaryStartDate)
                {
                    ApplicationArea = All;
                }

            }
        }

    }

}
