pageextension 50089 PostedSalesShipsExt extends "Posted Sales Shipments"
{
    layout
    {
        addafter("Location Code")
        {
            field("Order Notes"; Rec."Order Notes")
            {
                ApplicationArea = all;
            }

        }
        addafter("Sell-to Customer Name")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
            }
            field("Single BOL No."; Rec."Single BOL No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("No. Printed")
        {

            field(SystemCreatedBy; genCU.GetUserNameFromSecurityId(Rec.SystemCreatedBy))
            {
                ApplicationArea = All;
                Caption = 'System Created By';
                Editable = false;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'System Created At';
                Editable = false;
            }
        }
    }
    actions
    {
        addafter("Outstanding Sales Order Status")
        {
            action("Pick Instruction")
            {
                ApplicationArea = Warehouse;
                Caption = 'Pick Instruction';
                Image = Print;
                ToolTip = 'Print a picking list that shows which items to pick and ship for the sales order. If an item is assembled to order, then the report includes rows for the assembly components that must be picked. Use this report as a pick instruction to employees in charge of picking sales items or assembly components for the sales order.';
                Promoted = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    SalesShipHdr: Record "Sales Shipment Header";

                    PickingInstruct: Report PostedPickingListbyOrderCust;
                begin
                    //Clear(PickingInstruct);
                    //PickingInstruct.SetTableView(rec);
                    // PickingInstruct.Run();
                    SalesShipHdr.Reset;
                    SalesShipHdr.SetRange("No.", rec."No.");
                    if (SalesShipHdr.FindSet()) then
                        Report.Run(Report::PostedPickingListbyOrderCust, true, true, SalesShipHdr);
                    //      DocPrint.PrintSalesOrder(Rec, Usage::"Pick Instruction");
                end;
            }
        }
    }
    var
        genCU: Codeunit GeneralCU;

}
