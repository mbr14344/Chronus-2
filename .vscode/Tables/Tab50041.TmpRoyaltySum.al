table 50041 TmpRoyaltySum
{
    Caption = 'TmpRoyaltySum';
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
        }
        field(9; OriginalAmount; Decimal)
        {
            Caption = 'OriginalAmount';
        }
        field(10; PaidAmount; Decimal)
        {
            Caption = 'PaidAmount';
            DecimalPlaces = 0 : 5;
        }
        field(11; "Type"; Text[100])
        {
            Caption = 'Type';
        }
        field(12; CashPaidAmount; Decimal)
        {
            Caption = 'CashPaidAmount';
            DecimalPlaces = 0 : 5;
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
        field(22; ReturnedAmount; Decimal)
        {

        }
        field(23; TotalInvoiceLnAmount; Decimal)
        {

        }
        field(24; ReturnedQty; Decimal)
        {

        }
        field(25; FinalInvoiceAmount; Decimal)
        {

        }
        field(26; FinalQty; Decimal)
        {

        }
    }
    keys
    {
        key(PK; CustNo, "Type", "DatePaid", InvoiceNo, ItemNo)
        {
            Clustered = true;
        }
        key(InvoiceDatepaid; CustNo, InvoiceNo, PaidAmount)
        {

        }

        key(TypeKey; "Type")
        {

        }
        key(TypeOrderKey; "Type", "OrderNo")
        {

        }
        key(TypeInv; Type, CustNo, InvoiceNo)
        {

        }
    }
}
