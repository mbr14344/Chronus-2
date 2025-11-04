report 50123 "Item Inventory With Images"
{
    Caption = 'Item Inventory With Images';
    RDLCLayout = './.vscode/ReportLayout/ItemInventoryWithImages.rdl';
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Item; "Item")
        {
            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Picture; ItemTenantMedia.Content)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {

            }

            trigger OnAfterGetRecord()
            begin


                if Item.Picture.Count > 0 then begin
                    ItemTenantMedia.Get(Item.Picture.Item(1));
                    ItemTenantMedia.CalcFields(Content);
                end;

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnInitReport()
    begin
        CompanyInfo.get();

    end;



    var
        CompanyInfo: Record "Company Information";
        ItemTenantMedia: Record "Tenant Media";

}
