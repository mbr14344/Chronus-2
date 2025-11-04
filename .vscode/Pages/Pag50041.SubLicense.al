page 50041 SubLicense
{
    // pr 6/13/24 made sub license page
    Caption = 'Sub-License';
    PageType = ListPart;
    SourceTable = SubLicenseHeader;
    DataCaptionFields = License;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(License; Rec.License)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(SubLicense; Rec.SubLicense)
                {
                    ApplicationArea = All;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = all;
                }

            }
        }
    }
}
