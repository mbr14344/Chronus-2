table 50032 LicenseOwner
{
    // pr 6/13/24 made license owner table
    Caption = 'LicenseOwner';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; License; Code[30])
        {
            Caption = 'License';
        }
    }
    keys
    {
        key(PK; License)
        {
            Clustered = true;
        }
    }
}
