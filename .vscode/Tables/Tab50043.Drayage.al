table 50043 Drayage
{
    Caption = 'Drayage';
    DataClassification = ToBeClassified;
    LookupPageId = Drayage;
    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
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
