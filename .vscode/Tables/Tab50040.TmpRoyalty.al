table 50040 TmpRoyalty
{
    Caption = 'TmpRoyalty';
    DataClassification = ToBeClassified;
    TableType = Temporary;
    fields
    {
        field(1; CustNo; Code[20])
        {
            Caption = 'Cust No.';
            TableRelation = Customer."No.";
        }
        field(2; DatePaid; Date)
        {
            Caption = 'DatePaid';
        }
        field(3; ItemNo; Code[20])
        {
            Caption = 'ItemNo';
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; ExtDocNo; Code[35])
        {
            Caption = 'ExtDocNo';
        }
        field(6; CustName; Text[100])
        {
            Caption = 'CustName';
        }
        field(7; Qty; Decimal)
        {
            Caption = 'Qty';
        }
        field(8; SalesPrice; Decimal)
        {
            Caption = 'SalesPrice';
            DecimalPlaces = 0 : 5;
        }
        field(9; OriginalAmount; Decimal)
        {
            Caption = 'OriginalAmount';
            DecimalPlaces = 0 : 5;
        }
        field(10; PaidAmount; Decimal)
        {
            Caption = 'PaidAmount';
            DecimalPlaces = 0 : 2;
        }
        field(11; "Type"; Text[100])
        {
            Caption = 'Type';
        }
        field(12; CashPaidAmount; Decimal)
        {
            Caption = 'CashPaidAmount';
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

        }
        field(17; bCashPaidNotEq; Boolean)
        {

        }
        field(18; ItemSort; Integer)
        {

        }
        field(19; License; Code[30])
        {

        }
        field(20; SubLicense; Code[80])
        {

        }
        field(21; UOM; Code[20])
        {

        }
        field(22; ReturnedAmount; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(23; TotalInvoiceLnAmount; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(24; ReturnedQty; Decimal)
        {

        }
        field(25; FinalInvoiceAmount; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(26; FinalQty; Decimal)
        {

        }
        field(27; OrigPaidAmount; Decimal)
        {
            Caption = 'OrigPaidAmount';
            DecimalPlaces = 0 : 5;
        }
        field(28; WeightedQty; Decimal)
        {
            Caption = 'WeightedQty';
            DecimalPlaces = 0 : 5;
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
}
