report 50128 PowerBIReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'TEST Sales Dashboard (Power BI)';
    RDLCLayout = './.vscode/ReportLayout/InventoryWithImages.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(Item; Item)
        {
            column(UnitPrice; "Unit Price")
            {
            }
            column(Inventory; Inventory)
            {

            }
            column(Qty__on_Sales_Order; "Qty. on Sales Order")
            {

            }
            column(Qty_on_Transfer_Orders; "Qty on Transfer Orders")
            {

            }
            column(CurrentInventory; curInventory)
            {

            }
            column(Last_Direct_Cost; "Last Direct Cost")
            {

            }
            column(Expiration_Calculation; "Expiration Calculation")
            {

            }
            column(No_; "No.")
            {

            }
            column(Description; Description)
            {

            }
            column(Picture; Picture)
            {

            }


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

    trigger OnPostReport()
    var
        ReportURL: Text;
    begin
        // Replace with the actual Power BI report URL
        ReportURL := 'https://app.powerbi.com/reportEmbed?reportId=7470a730-6ca1-498c-97ce-40015a18b87d&autoAuth=true&ctid=30fa3d93-b513-4bd0-8420-0e9d08cddb92';
        Message('Opening Power BI report...');
        Hyperlink(ReportURL);

        // Prevent BC from trying to generate an actual printable report
        //  Error('This report only opens the Power BI dashboard.');
    end;

    var
        curInventory: Decimal;
}