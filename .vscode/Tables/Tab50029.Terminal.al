table 50029 Terminal
{
    Caption = 'Terminal';
    DataClassification = ToBeClassified;
    LookupPageId = Terminal;
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
