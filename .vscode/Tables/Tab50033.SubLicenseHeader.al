table 50033 SubLicenseHeader
{
    // pr 6/13/24 made sub license table
    Caption = 'SubLicense';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; License; Code[30])
        {
            Caption = 'License';
            TableRelation = LicenseOwner.License;
        }
        field(2; SubLicense; Code[80])
        {
            Caption = 'SubLicense';
        }
        field(3; "Expiration Date"; date)
        {

        }
    }
    keys
    {
        key(PK; License, SubLicense)
        {
            Clustered = true;
        }
    }
}
