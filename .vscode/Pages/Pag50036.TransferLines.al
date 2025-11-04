page 50036 TransferLinesListPg
{
    // pr 6/4/24 created transfer lines page
    ApplicationArea = All;
    Caption = 'Transfer Lines';
    PageType = List;
    SourceTable = "Transfer Line";
    UsageCategory = Lists;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;

                    StyleExpr = TxtNoCustomStyle;
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                    ApplicationArea = All;
                }
                field("Container No."; Rec."Container No.")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtStyleExpr;
                    TableRelation = "Container Header"."Container No.";
                }
                field(Urgent; Rec.Urgent)
                {
                    ApplicationArea = All;
                }
                field("PO No."; Rec."PO No.")
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        POPg: Page "Purchase Order";
                        POArchPg: Page "Purchase Order Archive";
                        POHdr: Record "Purchase Header";
                        POArchHdr: Record "Purchase Header Archive";
                    begin

                        POHdr.Reset();
                        POHdr.SetRange("No.", Rec."PO No.");
                        if POHdr.FindFirst() then begin
                            Clear(POPg);
                            POPg.SetTableView(POHdr);
                            POPg.Run();
                        end
                        else begin
                            POArchHdr.Reset();
                            POArchHdr.SetRange("No.", Rec."PO No.");
                            POArchHdr.SetCurrentKey("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
                            POArchHdr.Ascending(false);
                            if POArchHdr.FindFirst() then begin
                                Clear(POArchPg);
                                POArchPg.SetTableView(POArchHdr);
                                POArchPg.Run();
                            end
                        end;

                    end;
                }
                field(POClosed; Rec.POClosed)
                {
                    ApplicationArea = All;
                }
                field("PO Owner"; Rec."PO Owner")
                {
                    ApplicationArea = all;
                }

                field("PO Vendor"; Rec."PO Vendor")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Real Time Item Description"; Rec."Real Time Item Description")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; Rec.Description)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Quantity"; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("M-Pack Qty"; Rec."M-Pack Qty")
                {
                    ApplicationArea = All;
                }
                field("Package Count"; Rec.GetPackageCount())
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 1;
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                    ApplicationArea = All;
                }

                field("Qty. in Transit"; Rec."Qty. in Transit")
                {
                    ApplicationArea = all;
                }
                field("Qty. Received"; Rec."Quantity Received")
                {
                    ApplicationArea = All;
                }
                field(ETD; Rec.ETD)
                {
                    Caption = 'Initial Departure';
                    ApplicationArea = All;
                    ToolTip = 'ETD = Estimate Time of Departure.  This is maintained in the Container Order Card.';
                }
                field(ETA; Rec.ETA)
                {
                    Caption = 'Initial Arrival';
                    ApplicationArea = All;
                    ToolTip = 'ETA = Estimate Time of Arrival.  This is maintained in the Container Order Card.';
                }
                field("Actual ETD"; Rec."Actual ETD")
                {
                    ApplicationArea = All;
                    ToolTip = 'Actual Departure = Actual Time of Departure.  This is maintained in the Container Order Card.';
                }
                field("Actual ETA"; Rec."Actual ETA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Actual Arrival = Actual Time of Arrival.  This is maintained in the Container Order Card.';
                }
                field("Container Status Notes"; Rec."Container Status Notes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Container Status Notes. This is maintained in the Transfer Order Card.';
                }

                // PR 1/2/25 - start 

                field(HeadTelexReleased; Rec."Header Telex Released")
                {
                    Caption = 'TO Telex Released';
                    ApplicationArea = All;
                }
                field(TelexReleased; Rec."Telex Released")
                {
                    Caption = 'Line Telex Released';
                    ApplicationArea = All;
                    Editable = false;
                }
                /*field("Telex Released"; Rec."Telex Released")
                {
                    ApplicationArea = All;
                }*/
                // PR 1/2/25 - end 
                field("Pier Pass"; Rec."Pier Pass")
                {
                    ApplicationArea = All;
                    ToolTip = 'Pier Pass. This is maintained in the Transfer Order Card.';
                }
                field(LFD; Rec.LFD)
                {
                    ApplicationArea = All;
                    ToolTip = 'LFD. This is maintained in the Container Order Card.';
                }
                field("Actual Pull Date"; Rec."Actual Pull Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Actual Pull Date. This is maintained in the Container Order Card.';
                }
                field("Actual Pull Time"; Rec."Actual Pull Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Actual Pull Time. This is maintained in the Container Order Card.';
                }
                field("Actual Delivery Date"; Rec."Actual Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Actual Delivery Date. This is maintained in the Container Order Card.';

                }
                field("Empty Notification Date"; Rec."Empty Notification Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Empty Notification Date. This is maintained in the Container Order Card.';
                }
                field("Container Return Date"; Rec."Container Return Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Container Return Date. This is maintained in the Container Order Card.';
                }
                field("Receiving Status"; Rec."Receiving Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Receiving Status. This is maintained in the Transfer Order Card.';
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = All;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = All;
                }
                field("Purchasing Code"; Rec."Purchasing Code")
                {
                    ApplicationArea = All;
                }
                field("Container Size"; Rec."Container Size")
                {
                    ApplicationArea = All;
                }
                field(Ti; Rec.Ti)
                {
                    ApplicationArea = All;
                }

                field(Hi; Rec.Hi)
                {
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {

                    ApplicationArea = all;
                }
                field("exp Date"; Rec."Exp Date")
                {

                    ApplicationArea = all;
                }
                field(UPC; Rec.UPC)
                {
                    ApplicationArea = all;
                }
                field(Drayage; Rec.Drayage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Drayage. This is maintained in the Container Order Card.';
                }
                field(Terminal; Rec.Terminal)
                {
                    ApplicationArea = All;
                    ToolTip = 'Terminal. This is maintained in the Container Order Card.';
                }
                field(CreatedBy; Rec.CreatedBy)
                {
                    Caption = 'Created By';
                    ApplicationArea = All;
                    ToolTip = 'Created By. This is maintained in the Transfer Order Card.';
                }
                field(Forwarder; Rec.Forwarder)
                {
                    ApplicationArea = All;
                    ToolTip = 'Forwarder. This is maintained in the Container Order Card.';
                }
                field(Carrier; Rec.Carrier)
                {
                    ApplicationArea = All;
                    ToolTip = 'Carrier. This is maintained in the Container Order Card.';
                }

                field("Port of Loading"; Rec."Port of Loading")
                {
                    ApplicationArea = all;

                }
                field("Port of Discharge"; Rec."Port of Discharge")
                {
                    ApplicationArea = all;
                }
                field("M-Pack Weight (kg)"; Rec."M-Pack Weight (kg)")
                {
                    ApplicationArea = all;
                    ToolTip = 'M-Pack Weight (kg). This is maintained in the Container Line.';
                }
                //pr 3/25/25 - start
                field("Total Carton Weight"; Rec."M-Pack Weight (kg)" * Rec.GetPackageCount())
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                //pr 3/25/25 - end
                field("Dimension (LxWxH) m"; rec.GetDimensionM())
                {
                    ApplicationArea = all;
                    DecimalPlaces = 5;
                    ToolTip = 'Dimension (LxWxH) m. This is maintained in the Container Line.';
                }
                field(CBM; Rec.GetPackageCount() * Rec.GetDimensionM())   //mbr 10/30/24 - It's ok to call GetPackageCount based on Quantity because we want to base from Container Line Table
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'CBM(m)';
                    ToolTip = 'CBM. This is maintained in the Container Line.';
                }
                field("Freight Cost"; Rec."Freight Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Freight Cost. This is maintained in the Container Order Card.';
                }
                field("Freight Bill Amount"; Rec."Freight Bill Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Freight Bill Amount. This is maintained in the Container Order Card.';
                }
                field("Freight Bill No."; Rec."Freight Bill No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Freight Bill No. This is maintained in the Container Order Card.';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = all;
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {

                }
                //PR 12/27/24
                field("Manufacturer Code"; Rec."Manufacturer Code")
                {
                    ApplicationArea = all;
                }
                //PR 2/10/25 - start
                field("Expected Quantity"; Rec."Expected Quantity")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                field("Expected UOM"; Rec."Expected UOM")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                field("Received Good"; Rec."Received Good")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                field("Received Case"; Rec."Received Case")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                field("Received Pallet"; Rec."Received Pallet")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                field("Received Damage"; Rec."Received Damage")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                field("Received Over"; Rec."Received Over")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtOverStyle;
                }
                field("Received Short"; Rec."Received Short")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtShortStyle;
                }
                field("Received Weight"; Rec."Received Weight")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                //PR 2/10/25 - end
                //PR 2/12/25 - start 
                field(Hazard; Rec.Hazard)
                {
                    ApplicationArea = all;
                }
                //PR 2/12/25 - end 




            }
        }
    }


    actions
    {
        area(Processing)
        {

            action("Show Document")
            {
                ApplicationArea = all;
                Caption = 'Show Document';
                Image = Navigate;
                ShortCutKey = 'Shift+F7';
                ToolTip = 'Open the document that the selected line exists on.';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                begin
                    TransferHeader.Get(Rec."Document No.");
                    PAGE.Run(PAGE::"Transfer Order", TransferHeader);
                end;
            }
            action("Update Transfer-To")
            {
                ApplicationArea = all;
                Image = UpdateShipment;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    PgSelectTransferTo: Page "Select Transfer To";
                    TransferLine: Record "Transfer Line";
                begin
                    TransferLine.Reset;
                    TransferLine := rec;
                    TransferLine.SetFilter("Quantity Shipped", '>%1', 0);
                    if not TransferLine.FindSet() then
                        Error(txtChangeTransferToAbort, Rec."Document No.");

                    Clear(PgSelectTransferTo);
                    PgSelectTransferTo.SetTransferTo(Rec."Document No.");
                    PgSelectTransferTo.RunModal();
                end;
            }


        }
    }
    var
        txtChangeTransferToAbort: Label 'Transfer Order %1 has no transfer lines shipped yet.  Please use the Transfer-to Drop Down List to change the Destination Location.';

        TxtStyleExpr: Text;
        constFav: Label 'Favorable';
        constStd: Label 'Standard';
        TxtNoCustomStyle: Text;
        TxtOverStyle: Text;
        TxtShortStyle: Text;
        constUnfav: Label 'Unfavorable';

    trigger OnOpenPage()

    begin
        Rec.SETRANGE("Derived From Line No.", 0);
    end;

    trigger OnAfterGetRecord()
    var
        ArchPurchaseHeader: Record "Purchase Header Archive";
        POHdr: Record "Purchase Header";
        PostedPurchRcpt: Record "Purch. Rcpt. Header";
        PurLin: record "Purchase Line";
        PRLine: Record "Purch. Rcpt. Line";
    begin
        if Rec.Urgent = true then
            TxtStyleExpr := 'Unfavorable'   //BOLD RED
        ELSE
            TxtStyleExpr := 'Standard';  //Default



        rec.POClosed := false;  //Initialize
        rec.CalcFields("Container No.", "944 Receipt No.");

        //mbr 2/11/25 - start
        //depending on the value of 944 fields, change the style of No.
        //depending on the valu of 944 fields, change the style of No.
        if strlen(Rec."944 Receipt No.") > 0 then begin
            TxtNoCustomStyle := constFav;
            TxtOverStyle := constFav;
            TxtShortStyle := constFav;
            if (Rec."Received Short" > 0) then
                TxtShortStyle := constUnFav;
            if (Rec."Received Over" > 0) then
                TxtOverStyle := constUnfav;
        end
        else begin
            TxtNoCustomStyle := constStd;
            TxtOverStyle := constStd;
            TxtShortStyle := constStd;
        end;
        //mbr 2/11/25 - end


        rec.CalcFields(ETA, ETD, "Actual ETA", "Actual ETD", "UPC", Urgent,
        "Port of Discharge", "Port of Loading", Drayage, Terminal, CreatedBy,
        Forwarder, Carrier, "M-Pack Weight (kg)", "Freight Cost", "Freight Bill Amount",
        "Freight Bill No.", "M-Pack Qty", "M-Pack Weight (kg)", "Container Status Notes",
        "Receiving Status", "Pier Pass", "Container Size", "Exp Date");

        //mbr 12/11/24 - update PO owner
        IF Rec."PO No." <> '' then begin
            POHdr.Reset();
            POHdr.SetRange("Document Type", POHdr."Document Type"::Order);
            POHdr.SetRange("No.", Rec."PO No.");

            if POHdr.FindFirst() then begin
                Rec."PO Owner" := POHdr.CreatedUserID;
                rec."PO Vendor" := POHdr."Buy-from Vendor No.";

                Rec.Modify();
            end
            else begin
                PostedPurchRcpt.Reset();
                PostedPurchRcpt.SetRange("Order No.", Rec."PO No.");
                if PostedPurchRcpt.FindFirst() then begin
                    Rec."PO Owner" := PostedPurchRcpt.CreatedUserID;
                    rec."PO Vendor" := PostedPurchRcpt."Buy-from Vendor No.";
                    Rec.POClosed := true;
                    Rec.Modify();
                end
                else begin
                    ArchPurchaseHeader.Reset();
                    ArchPurchaseHeader.SetCurrentKey("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
                    ArchPurchaseHeader.SetRange("Document Type", ArchPurchaseHeader."Document Type"::Order);
                    ArchPurchaseHeader.SetRange("No.", Rec."PO No.");
                    ArchPurchaseHeader.Ascending(false);
                    if ArchPurchaseHeader.FindFirst() then begin
                        Rec."PO Owner" := ArchPurchaseHeader.CreatedUserID;
                        rec."PO Vendor" := ArchPurchaseHeader."Buy-from Vendor No.";
                        Rec.Modify();
                    end;
                end;


            end;

            //get Custcode
            PurLin.Reset();
            PurLin.SetRange("Document No.", Rec."PO No.");
            PurLin.SetRange(Type, PurLin.Type::Item);
            PurLin.SetRange("No.", Rec."Item No.");
            If PurLin.FindFirst() then begin

                Rec."Shortcut Dimension 1 Code" := PurLin."Shortcut Dimension 1 Code";
                Rec.Modify();
            end

            else begin
                PRLine.Reset();
                PRLine.SetRange("Order No.", Rec."PO No.");
                PRLine.SetRange(Type, PRLine.Type::Item);
                PRLine.SetRange("No.", Rec."Item No.");
                IF PRLine.FindFirst() then begin

                    Rec."Shortcut Dimension 1 Code" := PRLine."Shortcut Dimension 1 Code";
                    Rec.Modify();
                end;

            end;

        end;



    end;


}
