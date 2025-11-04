pageextension 50044 PurchaseOrderLineSubformPage extends "Purchase Order Subform"
{
    layout
    {
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
                UserSetup: Record "User Setup";
            begin

                If Rec."Document Type" = Rec."Document Type"::Order then begin
                    if Rec.Type = Rec.Type::Item then
                        if Item.Get(Rec."No.") then
                            if Item.Type = Item.Type::Inventory then begin
                                if (Rec."Direct Unit Cost" <> xRec."Direct Unit Cost") then begin
                                    UserSetup.Reset();
                                    UserSetup.SetRange("User ID", UserId);
                                    UserSetup.SetRange(POAdmin, true);
                                    if not UserSetup.FindFirst() then
                                        Error(textErrUnitCost);
                                end;

                            end
                end;





            end;
        }
        //7/10/25 - alwasy show and move to after qty invoiced instead of qty - start
        addafter("Quantity Invoiced")
        {

            field("Qty to Assign to Container"; Rec."Qty to Assign to Container")
            {
                Caption = 'Qty to Assign to Container';
                ApplicationArea = all;
                //DecimalPlaces = 0 : 5;
                //Visible = isQtyToAssgn;
                Visible = true;
            }

            field("Qty Assigned to Container"; Rec."Qty Assigned to Container")
            {
                Caption = 'Qty Assigned to Container';
                ApplicationArea = all;
                //DecimalPlaces = 0 : 5;
                //Visible = isQtyToAssgn;
                Visible = true;
            }
            //7/10/25 - alwasy show and move to after qty invoiced - start
        }

        addafter("Expected Receipt Date")
        {
            field("Expected Expiration Date"; Rec."Expected Expiration Date")
            {
                ApplicationArea = All;

            }
            field(ActualCargoReadyDate; Rec.ActualCargoReadyDate)
            {
                ApplicationArea = All;
            }
            field(EstimatedInWarehouseDate; Rec.EstimatedInWarehouseDate)
            {
                ApplicationArea = All;
            }
            field("Days differences earliest"; Rec."Days differences earliest")
            {
                ApplicationArea = All;
                Editable = false;
                StyleExpr = difDateStyle;
            }
            field("Initial ETD"; Rec."Initial ETD")
            {
                ApplicationArea = All;
            }
            field("Initial ETA"; Rec."Initial ETA")
            {
                ApplicationArea = All;
            }

            field(DeliveryNotes; Rec.DeliveryNotes)
            {
                ApplicationArea = All;
            }
        }
        addafter("Direct Unit Cost")
        {
            field("M-Pack Qty"; Rec."M-Pack Qty")
            {
                ApplicationArea = All;
            }
            field(PackageCount; Rec.GetPackageCount())
            {
                Caption = 'Package Count';
                ApplicationArea = All;
            }
            field(DimensionKg; Rec.GetDimensionM())
            {
                Caption = 'Dimension (LxWxH) m';
                ApplicationArea = All;
                DecimalPlaces = 5;

            }
            field(CBM; Rec.GetPackageCount() * Rec.GetDimensionM())  //mbr 10/30/24 - it's okay to call GetPackageCount from Receipt level since this is the qty received
            {
                ApplicationArea = All;
                Caption = 'CBM(m)';
            }
            field(GW; Rec.GetOutstandingPackageCount() * Rec."M-Pack Weight kg")
            {
                ApplicationArea = All;
                Caption = 'GW(kg)';
            }
            field("Production Status"; Rec."Production Status")
            {
                ApplicationArea = All;
            }
            field("PO Finalized Date"; rec.POFinalizeDate)
            {
                ApplicationArea = all;
            }




        }
        addafter(Description)
        {
            field("Real Time Item Description"; Rec."Real Time Item Description")
            {
                ApplicationArea = all;
            }
        }
        modify(Description)
        {
            Visible = false;
        }
        //7/10/25 - start
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Item Charge Qty. to Handle")
        {
            Visible = false;
        }
        //7/10/25 - end
        addlast(Control1)
        {
            // 10/8/25 - start
            field("New Item"; Rec."New Item")
            {
                ApplicationArea = All;
                Visible = false; //set to false for now
            }
            //10/8/25 - end
        }


    }




    actions
    {
        addafter("Item Tracking Lines")
        {
            action("Update Item Lot No.")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    // raise the event from inside the subpage
                    OnRequestOpenItemTracking(Rec);
                end;
            }

        }
        addafter(OrderTracking)
        {
            action(UpdateMondayPONo)
            {

                ApplicationArea = All;
                Caption = 'Monday.com PO No.';
                ToolTip = 'Update Monday.com PO No.';
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var

                    PurchLine: Record "Purchase Line";
                    popupConfirm: Page "Confirmation Dialog";
                    ftpserver: Record FTPServer;
                    Loc: Record Location;
                    XMLCU: Codeunit XMLCU;
                    inventorySetup: Record "Inventory Setup";
                    Item: Record Item;
                    ItemIDTxt: Text;
                    BoardIDTxt: Text;
                    noItemErrTxt: Label 'Item %1 not found. Cannot update Monday.com. PO No.';
                    PoTxt: Text;
                    ValueJsonStr: Text;
                begin

                    CurrPage.SetSelectionFilter(PurchLine);
                    if PurchLine.FindFirst() then begin
                        XMLCU.UpdateMondayFromPurchLinePONo(PurchLine);
                    end;
                end;

            }
            action(UpdateMondayCRD)
            {

                ApplicationArea = All;
                Caption = 'Monday.com CRD';
                ToolTip = 'Update Monday.com CRD';
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var

                    PurchLine: Record "Purchase Line";
                    popupConfirm: Page "Confirmation Dialog";
                    ftpserver: Record FTPServer;
                    Loc: Record Location;
                    XMLCU: Codeunit XMLCU;
                    inventorySetup: Record "Inventory Setup";
                    Item: Record Item;
                    ItemIDTxt: Text;
                    BoardIDTxt: Text;
                    noItemErrTxt: Label 'Item %1 not found. You cannot update Monday.com CRD';
                    ActualCargoDateTxt: Text;
                    ValueJsonStr: Text;
                begin

                    CurrPage.SetSelectionFilter(PurchLine);
                    if PurchLine.FindFirst() then begin
                        XMLCU.UpdateMondayFromPurchLineCRD(PurchLine);
                    end;
                end;

            }
            action(MondayAuditTrail)
            {

                ApplicationArea = All;
                Caption = 'Monday.Com Audit Trail';
                ToolTip = 'View Monday.com Audit Trail';
                Image = ChangeLog;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var

                    PgAuditTrail: Page "Purchase Line Monday Audit";
                begin

                    Clear(PgAuditTrail);
                    PgAuditTrail.Run();
                end;

            }


        }
        modify(OrderTracking)
        {
            trigger OnAfterAction()
            begin
                CurrPage.SaveRecord();
                Commit();
            end;
        }

    }
    [IntegrationEvent(false, false)]
    local procedure OnRequestOpenItemTracking(var PurchLine: Record "Purchase Line")
    begin
    end;

    var
        difDateStyle: text[50];

    trigger OnClosePage()
    begin
        isQtyToAssgn := false;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("M-Pack Height", "M-Pack Length", "M-Pack Width", "M-Pack Qty", "M-Pack Weight kg", "Real Time Item Description");
        //rec.CalcEarliestDifDate();  //7/7/25 - to be deleted after further testing
        if (rec."Days differences earliest" >= 0) then
            difDateStyle := 'Standard'
        else
            difDateStyle := 'Unfavorable';
        rec.CalcInitETAnETD();
    end;

    var
        textErrUnitCost: Label 'Direct Unit Cost CANNOT be manually modified.';
        isQtyToAssgn: boolean;
        txtExportDone: Label 'Selected picking instruction(s) successfully exported to %1.';
        txtConfirmation: Label 'Are you sure you want to export picking instructions for the selected records?';

        lblNoURL: Label 'No FTP URL is setup for %1 %2';
        txtNoFTPServerFound: Label 'No FTP Server Name found for location %1.';
        txtErrCustomerShipToCode: Label 'Customer Ship-to Code is blank for SO %1.  This is Mandatory.  Please update in Customer Card - Ship To Address.';


    procedure SetIsQtyToAssgn(isActive: Boolean)
    begin
        isQtyToAssgn := isActive;
    end;

    //7/7/25 - need to workaround the runmodal restriction from Microsoft when called from PO subform
    [IntegrationEvent(false, false)]
    local procedure OnOpenItemTrackingRequested(var Rec: Record "Purchase Line")
    begin
    end;

    procedure RequestOpenTracking()
    begin
        OnRequestOpenItemTracking(Rec);
    end;

    //7/7/25 - end
}
