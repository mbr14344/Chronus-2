table 50061 "AP Reconciliation Ledger"
{
    Caption = 'AP Reconciliation Ledger';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(2; "Document Type"; Enum "Gen. Journal Document Type")
        {

            Caption = 'Document Type';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; GLEAmount; Decimal)
        {
            Caption = 'G/L Amount';
        }
        field(5; AmountApplied; Decimal)
        {
            Caption = 'Amount Applied';
        }
        field(6; ExpectedBalance; Decimal)
        {
            Caption = 'Expected Balance (GLE - Applied)';
        }
        field(7; AgedAPBalanceDue; Decimal)
        {
            Caption = 'Aged AP Balance Due';
        }
        field(8; Delta; Decimal)
        {
            Caption = 'Delta';
        }
        field(9; Status; text[50])
        {
            Caption = 'Status';
        }
        field(10; "As of Date"; Date)
        {
            Caption = 'Reconciliation As of Date';
        }

        field(11; "Run DateTime"; DateTime)
        {
            Caption = 'Run Date/Time';
        }
        field(12; "Run By User ID"; Code[50])
        {
            Caption = 'Run By User';
        }
        field(13; SourceGLEEntryNo; Integer)
        {
            Caption = 'Source GLE Entry No.';
        }
        field(14; StatusDetails; Text[50])
        {
            Caption = 'Status Details';
        }
        field(15; PaymentTolerance; Decimal)
        {
            Caption = 'Payment Tolerance';
        }
        field(16; PaymentDiscount; Decimal)
        {
            Caption = 'Payment Discount';
        }
        field(17; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }


    }
    keys
    {
        key(PK; "Vendor No.", "Document Type", "Document No.", SourceGLEEntryNo, "As of Date")
        {
            Clustered = true;
        }
    }
}
