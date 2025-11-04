report 50118 InventoryWithImages
{
    ApplicationArea = All;
    Caption = 'InventoryWithImages';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/InventoryWithImages.rdl';
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

            trigger OnAfterGetRecord()
            begin
                if ((Item."Item Status" <> Item."Item Status"::Discontinued) or (Item.Type = Item.Type::Service)) then begin
                    CurrReport.Skip();
                end;
                curInventory := Item.GetCurrentAvailable();
                Item.CalcFields("Qty. on Sales Order", "Qty on Transfer Orders", Inventory);
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
    var
        curInventory: Decimal;

}
