table 50028 "TO Carrier"
{
    Caption = 'TO Carrier';
    DataClassification = ToBeClassified;
    LookupPageId = "TO Carrier";

    fields
    {
        field(1; Code; Code[50])
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
