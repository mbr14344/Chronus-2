page 50047 "License Header"
{
    // pr 6/27/24 added table to support license header page to have sub license and license on one page
    ApplicationArea = All;
    Caption = 'Licenses';
    PageType = List;
    SourceTable = LicenseOwner;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(License; Rec.License)
                {
                    ApplicationArea = all;
                }

            }
            part(SubLicense; SubLicense)
            {
                Editable = true;
                SubPageLink = License = field(License);
            }


        }

    }
    var
        license: Record LicenseOwner;
        subLicense: Record SubLicenseHeader;
}
