pageextension 50011 "Posted Sales Shipment" extends "Posted Sales Shipment"
{
    layout
    {

        addbefore("Requested Delivery Date")
        {
            field("Cancel Date"; Rec."Cancel Date")
            {
                ApplicationArea = All;
            }
            field("Request Ship Date"; Rec."Request Ship Date")
            {
                ApplicationArea = All;
            }
            field("Start Ship Date"; Rec."Start Ship Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Responsibility Center")
        {
            field("Split"; Rec.Split)
            {
                ApplicationArea = All;
            }
            field("FOB"; Rec.FOB)
            {
                ApplicationArea = All;
            }
            field("Flag"; Rec.Flag)
            {
                ApplicationArea = All;
            }
            field("In the Month"; Rec."In the Month")
            {
                ApplicationArea = All;
                ToolTip = 'Indicates if the invoice is in the month.';
            }
            field("Order Notes"; Rec."Order Notes")
            {
                ApplicationArea = All;
            }
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
        addafter("Ship-to Code")
        {

            field(CustomerShipToCode; Rec.CustomerShipToCode)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Single BOL No."; Rec."Single BOL No.")
            {
                ApplicationArea = All;
            }
            field("BOL Comments"; Rec."BOL Comments")
            {
                ApplicationArea = all;
            }
            field("Total Package Count"; Rec."Total Package Count")
            {
                ApplicationArea = All;
            }
            field("Total Weight"; Rec."Total Weight")
            {
                ApplicationArea = All;
            }
            field("Total Pallet Count"; Rec."Total Pallet Count")
            {
                ApplicationArea = All;
            }
            field(FreightChargeTerm; Rec.FreightChargeTerm)
            {
                ApplicationArea = All;
            }
            //pr 6/24/24 - start
            field("Freight Charge Name"; Rec."Freight Charge Name")
            {
                ApplicationArea = All;
            }
            field("Freight Charge Address"; Rec."Freight Charge Address")
            {
                ApplicationArea = All;
            }
            field("Freight Charge City"; Rec."Freight Charge City")
            {
                ApplicationArea = All;
            }
            field("Freight Charge State"; Rec."Freight Charge State")
            {
                ApplicationArea = All;
            }
            field("Freight Charge Zip"; Rec."Freight Charge Zip")
            {
                ApplicationArea = All;
            }
            field("Freight Charge Contact"; Rec."Freight Charge Contact")
            {
                ApplicationArea = All;
            }
            //pr 6/24/24 - end
        }

    }
    actions
    {
        addfirst(processing)
        {
            action(PostedCartonInformation)
            {
                ApplicationArea = All;
                Caption = 'Posted Package Information';
                Promoted = true;
                PromotedCategory = Process;
                Image = PostedVoucherGroup;
                RunObject = page PostedCartonInformation;
                RunPageLink = PSSNo = field("No.");
            }
            action("Posted Bill of Lading")
            {
                ApplicationArea = all;
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()

                var
                    PSS: Record "Sales Shipment Header";
                begin
                    //Message('1');
                    PSS.SetRange("No.", Rec."No.");
                    IF PSS.FindFirst() then begin
                        // Message('2');
                        Clear(myReport);
                        myReport.SetTableView(PSS);
                        myReport.RunModal;
                    end;
                end;
            }
            action("Pick Instruction")
            {
                ApplicationArea = Warehouse;
                Caption = 'Pick Instruction';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Print a picking list that shows which items to pick and ship for the sales order. If an item is assembled to order, then the report includes rows for the assembly components that must be picked. Use this report as a pick instruction to employees in charge of picking sales items or assembly components for the sales order.';

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
        DocPrint: Codeunit "Document-Print";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";
        myReport: Report PostedBOLReport;
        genCU: Codeunit GeneralCU;
}

