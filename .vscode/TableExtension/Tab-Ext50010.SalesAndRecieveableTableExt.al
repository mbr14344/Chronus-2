tableextension 50010 SalesAndRecieveableTableExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Single BOL Nos."; Code[20])
        {
            Caption = 'BOL Nos.';
            TableRelation = "No. Series";
        }
        field(50001; "Master BOL Nos."; Code[20])
        {
            Caption = 'BOL Nos.';
            TableRelation = "No. Series";
        }
        field(50002; "Commodity Description"; Text[250])
        {
            Caption = 'Commodity Description';
        }
        field(50003; "NMFC No."; Code[20])
        {
            Caption = 'NMFC No.';
        }
        field(50004; "InvoiceEarliestDate"; Date)
        {
            Caption = 'Invoice Earliest Actual Reporting Date';
        }
        field(50005; FTPUploadURL; text[500])
        {
            Caption = 'FTP Upload URL';
        }
        field(50006; FTPServername; Text[100])
        {
            Caption = 'FTP Destination Server';
        }
        field(50007; SODCBreakdownBody; Text[500])
        {
            Caption = 'SO DC Breakdown Email Body';
        }
        field(50008; SODCBreakdownSubject; Text[200])
        {
            Caption = 'SO DC Breakdown Email Subject';
        }
        field(50009; SODCBreakdownClosing; Text[500])
        {
            Caption = 'SO DC Breakdown Email Closing';
        }

        field(50010; EDILineDiscountCAP; Decimal)
        {
            Caption = 'EDI Line Discount Cap';
            DecimalPlaces = 0 : 5;
        }
        field(50011; "Payment Discount % Cap"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(50012; "SalesByItemSummaryStartDate"; Date)
        {
            Caption = 'Sales by Item Summary Start Date';
        }

    }
}
