table 50054 "Cash Basis Item Sales"
{
    Caption = 'Cash Basis Item Sales';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; CustNo; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }


        field(3; ItemNo; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = item."No.";
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(2; DatePaid; Date)
        {
            Caption = 'Date Paid';
        }
        field(5; ExtDocNo; Code[35])
        {
            Caption = 'External Doc No.';
        }
        field(6; CustName; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(7; Qty; Decimal)
        {
            Caption = 'Qty';
        }
        field(8; SalesPrice; Decimal)
        {
            Caption = 'Sales Price';
            DecimalPlaces = 0 : 5;
        }
        field(9; OriginalAmount; Decimal)
        {
            Caption = 'Original Amount';
            DecimalPlaces = 0 : 5;
        }
        field(10; PaidAmount; Decimal)
        {
            Caption = 'Paid Amount';
            DecimalPlaces = 0 : 2;
        }
        field(11; "Type"; Text[100])
        {
            Caption = 'Type';
        }
        field(12; CashPaidAmount; Decimal)
        {
            Caption = 'Cash Paid Amount';
            DecimalPlaces = 0 : 2;
        }
        field(14; InvoiceNo; Code[20])
        {
            Caption = 'Invoice No.';
        }
        field(15; OrderNo; Code[20])
        {
            Caption = 'Order No.';
        }
        field(16; InvDiscExists; Boolean)
        {
            Caption = 'Inv Discount Exists';
        }
        field(17; bCashPaidNotEq; Boolean)
        {

        }
        field(18; ItemSort; Integer)
        {
            Caption = 'Item Sort';
        }
        field(19; License; Code[30])
        {
            Caption = 'License';
            TableRelation = LicenseOwner.License;
        }
        field(20; SubLicense; Code[80])
        {
            Caption = 'SubLicense';
            TableRelation = SubLicenseHeader.SubLicense where(License = field(License));
        }
        field(21; UOM; Code[20])
        {
            Caption = 'UOM';
        }
        field(22; ReturnedAmount; Decimal)
        {
            Caption = 'Returned Amount';
            DecimalPlaces = 0 : 5;
        }
        field(23; TotalInvoiceLnAmount; Decimal)
        {
            Caption = 'Total InvoiceLn Amount';
            DecimalPlaces = 0 : 5;
        }
        field(24; ReturnedQty; Decimal)
        {
            Caption = 'Returned Qty';
        }
        field(25; FinalInvoiceAmount; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(26; FinalQty; Decimal)
        {
            Caption = 'Final Qty';
        }
        field(27; OrigPaidAmount; Decimal)
        {
            Caption = 'Origanl Paid Amount';
            DecimalPlaces = 0 : 5;
        }
        field(28; CreatedDate; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(29; CreatedBy; Code[50])
        {
            Caption = 'Created By';
            TableRelation = User."User Name";
            Editable = false;
        }
    }
    keys
    {
        key(PK; CustNo, "Type", "DatePaid", InvoiceNo, ItemNo, License, SubLicense)
        {
            Clustered = true;
        }
        key(InvoiceDatepaid; CustNo, InvoiceNo, PaidAmount)
        {

        }
        key(IKey; Type, CustNo, InvoiceNo, License, Sublicense, ItemNo)
        {

        }
        key(IKey2; Type, CustNo, InvoiceNo)
        {

        }
        key(IKeyPdAmount; Type, CustNo, InvoiceNo, PaidAmount)
        {

        }
    }

    /*fields
    {
        field(1; "Item No."; code[20])
        {
        }
        field(2; "License"; code[30])
        {
        }
        field(3; "SubLicense"; code[80])
        {
        }
        field(4; "Type"; text[100])
        {
        }
        field(5; "Source No."; code[20])
        {
        }
        field(6; "External Document No."; code[35])
        {
        }
        field(7; "InvoiceNo"; code[20])
        {
        }
        field(8; "OrderNo"; code[20])
        {
        }
        field(9; "InvDiscExists"; Boolean)
        {
        }
        field(10; "Qty"; Decimal)
        {
        }
        field(11; "OriginalAmount"; Decimal)
        {
        }
        field(12; "PaidAmount"; Decimal)
        {
        }
        field(13; "OrigPaidAmount"; Decimal)
        {
        }
        field(14; "DatePaid"; Date)
        {
        }
        field(15; "Description"; text[100])
        {
        }
        field(16; "ItemSort"; Integer)
        {
        }
        field(17; "UOM"; code[20])
        {
        }
        field(18; "CashPaidAmount"; Decimal)
        {
        }
        field(19; "CustName"; text[100])
        {
        }
        field(20; "SalesPrice"; Decimal)
        {
        }
    }
    keys
    {
        key(PK; "Item No.")
        {
            Clustered = true;
        }
    }*/
}
