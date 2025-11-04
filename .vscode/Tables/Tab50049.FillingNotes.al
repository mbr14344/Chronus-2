table 50049 FillingNotes
{
    Caption = 'Filling Notes';
    DrillDownPageID = FillingNotes;
    LookupPageID = FillingNotes;
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Code"; code[30])
        {
            Caption = 'Code';
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
