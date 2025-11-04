page 50057 SubLicenseList
{
    ApplicationArea = All;
    Caption = 'SubLicenses';
    PageType = NavigatePage;
    SourceTable = SubLicenseHeader;
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SubLicense; Rec.SubLicense)
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        CurrPage.Close();
                    end;
                }
            }
        }
    }
    actions
    {

        area(Processing)
        {
            action(Search)
            {
                ApplicationArea = all;
                Caption = 'Submit';
                Image = Navigate;
                InFooterBar = true;

                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }

        }
    }
}
