table 50064 InTheMonthOptions
{
    Caption = 'InTheMonthOptions';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Text[20])
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
