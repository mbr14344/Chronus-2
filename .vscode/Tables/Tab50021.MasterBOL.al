table 50021 "Master BOL"
{
    //pr 1/24/24 made master bol table
    Caption = 'Master BOL';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Master BOL No."; code[20])
        {
            Caption = 'Master BOL No.';
        }
        field(2; "Single BOL No."; code[20])
        {
            Caption = 'Single BOL No.';
        }
        field(3; "Sales Order No."; code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(4; "Customer No."; code[20])
        {
            Caption = 'Customer No.';
        }
        field(5; "Ship to Code"; Text[50])
        {
            Caption = 'Customer Ship to Code';
        }
        field(6; "Customer Ship to City"; Text[50])
        {
            Caption = 'Customer Ship to City';
        }
        field(7; "External Doc No."; code[20])
        {
            Caption = 'External Doc No.';
        }
        field(8; "Posted"; boolean)
        {
            Caption = 'Posted';
        }
        field(9; "Main Ship To Name"; Text[100])
        {
            Caption = 'Main Ship To Name';
        }
        field(10; "Main Ship To Address"; Text[100])
        {
            Caption = 'Main Ship To Address';
        }
        field(11; "Main Ship To City"; Text[100])
        {
            Caption = 'Main Ship To City';
        }
        field(12; "Main Ship To State/County"; Text[100])
        {
            Caption = 'Main Ship To State/County';
        }
        field(13; "Main Ship To Postal Code"; Text[50])
        {
            Caption = 'Main Ship To Postal Code';
        }
        field(14; "Main Ship To Contact"; Text[100])
        {
            Caption = 'Main Ship To Contact';
        }
        field(15; "Ship To Contact"; Text[100])
        {
            Caption = 'Ship To Contact';

        }
        field(16; "Ship To Postal Code"; Text[50])
        {
            Caption = 'Ship To Postal Code';
        }
        field(17; "Ship To Name"; Text[50])
        {
            Caption = 'Ship To Name';
        }
        field(18; "Ship To State/County"; Text[50])
        {
            Caption = 'Ship To State/County';
        }
        field(19; "Ship To Address"; Text[50])
        {
            Caption = 'Ship To Address';
        }

        field(31; "Ship To Address2"; Text[50])
        {
            Caption = 'Ship To Address2';
        }
        field(32; "Ship To City"; Text[50])
        {
            Caption = 'Ship To Address2';
        }
        field(33; "Shipment Method Code"; Text[50])
        {
            Caption = 'Shipment Method Code';
        }
        field(20; "Ship From Code"; Text[50])
        {
            Caption = 'Ship From Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Code WHERE(Code = field("Location Code")));
        }
        field(21; "Carrier Name"; Text[50])
        {
            Caption = 'Carrier Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Shipping Agent".Name where(Code = field("SCAC Code")));
        }
        field(22; "SCAC Code"; Text[50])
        {
            Caption = 'SCAC Code';
        }
        field(23; "Freight Charge Term"; Option)
        {
            OptionMembers = " ","Prepaid","Collect","3rd Party";
            Caption = 'Freight Charge Term';

        }
        field(24; "Bill To Name"; Text[100])
        {
            Caption = 'Bill To Name';
        }
        field(25; "Bill To Adress"; Text[100])
        {
            Caption = 'Bill To Adress';
        }
        field(26; "Bill To City"; Text[50])
        {
            Caption = 'Bill To City';
        }
        field(27; "Bill To Postal Code"; Text[50])
        {
            Caption = 'Bill To Postal Code';
        }
        field(28; "Bill To State/County"; Text[50])
        {
            Caption = 'Bill To State';
        }
        field(29; "Bill To Contact"; Text[50])
        {
            Caption = 'Bill To Contact';
        }
        field(30; "Location Code"; code[10])
        {
            Caption = 'Location Code';
        }
        field(34; "Special Instructions"; Text[250])
        {
            Caption = 'Special Instructions';
        }
    }
    keys
    {
        key(PK; "Master BOL No.", "Single BOL No.")
        {
            Clustered = true;
        }
    }
}
