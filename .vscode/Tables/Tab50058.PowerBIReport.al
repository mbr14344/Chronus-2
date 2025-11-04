table 50058 PowerBIReport
{
    Caption = 'PowerBIReport';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Name; Code[100])
        {
            Caption = 'Name';
        }
        field(2; URL; Text[200])
        {
            Caption = 'URL';
        }
    }
    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
}
