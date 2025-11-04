table 60105 "Purchase Line Audit"
{
    Caption = 'Purchase Line Audit';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Type"; Enum "Purchase Document Type")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(5; Type; Enum "Purchase Line Type")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(22; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost';
            AutoFormatType = 2;
            DataClassification = CustomerContent;
        }
        field(27; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            AutoFormatType = 1;
            DataClassification = CustomerContent;
        }
        field(54; "Qty. to Receive"; Decimal)
        {
            Caption = 'Qty. to Receive';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(55; "Quantity Received"; Decimal)
        {
            Caption = 'Quantity Received';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(56; "Qty. to Invoice"; Decimal)
        {
            Caption = 'Qty. to Invoice';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(57; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Quantity Invoiced';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(5460; "Qty. Received (Base)"; Decimal)
        {
            Caption = 'Qty. Received (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5461; "Qty. Invoiced (Base)"; Decimal)
        {
            Caption = 'Qty. Invoiced (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(58; "Orig Quantity Received"; Decimal)
        {
            Caption = 'Orig Quantity Received';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(59; "Orig Quantity Invoiced"; Decimal)
        {
            Caption = 'Orig Quantity Invoiced';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(60; "Orig Qty. Received (Base)"; Decimal)
        {
            Caption = 'Orig Qty. Received (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(61; "Orig Qty. Invoiced (Base)"; Decimal)
        {
            Caption = 'Orig Qty. Invoiced (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(62; "Orig Qty. to Receive"; Decimal)
        {
            Caption = 'Orig Qty. to Receive';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(63; "Orig Qty. to Invoice"; Decimal)
        {
            Caption = 'Orig Qty. to Invoice';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }

        field(64; "Orig Qty. to Receive (Base)"; Decimal)
        {
            Caption = 'Orig Qty. to Receive (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(65; "Orig Qty. to Invoice (Base)"; Decimal)
        {
            Caption = 'Orig Qty. to Invoice (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(66; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(67; "Orig Quantity (Base)"; Decimal)
        {
            Caption = 'Orig Quantity (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(68; "Qty. to Receive (Base)"; Decimal)
        {
            Caption = 'Qty. to Receive (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(69; "Qty. to Invoice (Base)"; Decimal)
        {
            Caption = 'Qty. to Invoice (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(1001; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(1700; "Deferral Code"; Code[10])
        {
            Caption = 'Deferral Code';
            DataClassification = CustomerContent;
        }
        field(60100; "Audit Date"; DateTime)
        {
            Caption = 'Audit Date';
            DataClassification = CustomerContent;
        }
        field(60101; "Audit User ID"; Code[50])
        {
            Caption = 'Audit User ID';
            DataClassification = CustomerContent;
        }
        field(60102; "Audit Action"; Text[250])
        {
            Caption = 'Audit Action';
            DataClassification = CustomerContent;
        }
        field(60103; "Orig Entry No."; Guid)
        {
            Caption = 'Orig Entry No.';
            DataClassification = CustomerContent;
        }
        field(60104; "Audit Entry No."; Integer)
        {
            Caption = 'Audit Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
    }

    keys
    {
        key(PK; "Audit Entry No.")
        {
            Clustered = true;
        }
        key(SK1; "Document Type", "Document No.", "Line No.", "Audit Date")
        {
        }
        key(SK2; "Buy-from Vendor No.", "Document No.")
        {
        }
        key(SK3; "No.", Type)
        {
        }
        key(SK4; "Audit Date")
        {
        }
        key(SK5; "Audit User ID")
        {
        }
    }
}