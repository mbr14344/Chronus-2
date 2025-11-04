table 50037 TmpCommissionSum
{
    Caption = 'TmpCommissionSum';
    DataClassification = ToBeClassified;


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
        }
        field(11; "Type"; Text[100])
        {
            Caption = 'Type';
        }
        field(12; CashPaidAmount; Decimal)
        {
            Caption = 'CashPaidAmount';
        }
        field(13; UserID; Code[50])
        {
            Caption = 'User ID';
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
        field(22; CMAmount; Decimal)
        {

        }
        field(23; AppliedDocNo; Code[20])
        {
            Caption = 'Applied Doc No.';
        }
    }
    keys
    {
        key(PK; UserID, CustNo, "Type", "DatePaid", InvoiceNo, ItemNo)
        {
            Clustered = true;
        }
        key(InvoiceDatepaid; UserID, CustNo, InvoiceNo, PaidAmount)
        {

        }
        key(UserIDKey; UserID, "Type")
        {

        }
        key(TypeInv; UserID, Type, InvoiceNo, CustNo)
        {

        }
    }
}
