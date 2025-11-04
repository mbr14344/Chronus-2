table 50045 TmpLicenseSearch
{
    Caption = 'TmpLicenseSearch';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; License; Code[30])
        {
            Caption = 'License'; //ddlist
            TableRelation = LicenseOwner.License;
        }
        field(2; Sublicense; Code[80])
        {
            Caption = 'Sublicense'; //ddlist
            TableRelation = SubLicenseHeader.SubLicense where(License = field(License));
        }
    }
}
