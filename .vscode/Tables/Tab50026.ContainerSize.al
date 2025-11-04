table 50026 "Container Size"
{
    Caption = 'Container Size';
    DataClassification = ToBeClassified;

    LookupPageId = "Container Size";
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';

        }
        field(2; CBM; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(3; "Percentage Threshold"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
