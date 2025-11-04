page 50029 "Container Delivery Planning"
{
    ApplicationArea = All;
    Caption = 'Container Delivery Planning';
    PageType = List;
    SourceTable = ContainerLine;
    UsageCategory = Lists;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Container No."; Rec."Container No.")
                {
                    ToolTip = 'Specifies the value of the Container No. field.';
                    Editable = FALSE;
                    StyleExpr = ContainerNoStyle;
                    TableRelation = "Container Header"."Container No.";
                }
                field(Urgent; Rec.Urgent)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Container Status';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(TOOpen; Rec.TOOpen)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Transfer Order No."; Rec."Transfer Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        TOPg: Page "Transfer Order";
                        TOHdr: Record "Transfer Header";
                        PoTRPg: Page "Posted Transfer Receipt";
                        TRHdr: Record "Transfer Receipt Header";
                    begin

                        TOHdr.Reset();
                        TOHdr.SetRange("No.", Rec."Transfer Order No.");
                        if TOHdr.FindFirst() then begin
                            Clear(TOPg);
                            TOPg.SetTableView(TOHdr);
                            TOPg.Run();
                        end
                        else begin
                            TRHdr.Reset();
                            TRHdr.SetRange("Transfer Order No.", Rec."Transfer Order No.");
                            if TRHdr.FindFirst() then begin
                                Clear(PoTRPg);
                                PoTRPg.SetTableView(TRHdr);
                                PoTRPg.Run();
                            end;
                        end;
                    end;
                }
                field(PONo; Rec.PONo)
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        POPg: Page "Purchase Order";
                        POArchPg: Page "Purchase Order Archive";
                        POHdr: Record "Purchase Header";
                        POArchHdr: Record "Purchase Header Archive";
                    begin

                        POHdr.Reset();
                        POHdr.SetRange("No.", Rec.PONo);
                        if POHdr.FindFirst() then begin
                            Clear(POPg);
                            POPg.SetTableView(POHdr);
                            POPg.Run();
                        end
                        else begin
                            POArchHdr.Reset();
                            POArchHdr.SetRange("No.", Rec.PONo);
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
                field("PO Owner"; Rec."PO Owner")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("PO Vendor"; Rec."PO Vendor")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(POClosed; Rec.POClosed)
                {
                    ApplicationArea = All;
                }
                field(CustCode; Rec.CustCode)
                {
                    ApplicationArea = All;
                }
                field("Customer Responsibility Center"; Rec."Customer Responsibility Center")
                {
                    ApplicationArea = All;
                }
                //pr 5/5/25 - start
                field(Salesperson; Rec.Salesperson)
                {
                    ApplicationArea = All;

                }
                //pr 5/5/25 - 
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    Editable = false;
                    StyleExpr = HazardStyle;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item Description Snapshot"; Rec."Item Description Snapshot")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("New Item"; Rec."New Item")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("FDA Hold"; Rec."FDA Hold")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = FDAHoldStyle;
                }
                // 7/23/25 - start
                field("FDA Hold Date"; Rec."FDA Hold Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("FDA Released Date"; Rec."FDA Released Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(FDAHoldEmailNotifiSentDate; Rec.FDAHoldEmailNotifiSentDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(FDAReleasedEmailNotifiSentDate; Rec.FDAReleasedEmailNotifiSentDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                // 7/23/25 - end
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                //mbr 6/20/25 - start
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    ApplicationArea = All;
                }
                field("Earliest Start Ship Date"; Rec."Earliest Start Ship Date")
                {
                    ApplicationArea = All;
                }
                //mbr 6/20/25 - end
                //PR 2/5/25 - make transfer order qty rec if <> qty - start
                field("Transfer Line Quantity"; Rec."Transfer Line Quantity")
                {
                    StyleExpr = TxtStyleExpr;

                }
                field("M-Pack Qty"; Rec."M-Pack Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Package Count"; Rec.GetPackageCount())
                {
                    ApplicationArea = All;
                    Editable = false;
                    DecimalPlaces = 0 : 1;
                }
                field("Requested In Whse Date"; Rec."Requested In Whse Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ActualCargoReadyDate; Rec.ActualCargoReadyDate)
                {
                    ApplicationArea = All;
                    //Editable = false;
                }
                field(EstimatedInWarehouseDate; Rec.EstimatedInWarehouseDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Freight Cost.  This is maintained in the Container Order Card.';
                }
                field("Days differences earliest"; Rec."Days differences earliest")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = difDateStyle;
                }
                field(ETD; Rec.ETD)
                {
                    Caption = 'Initial Departure';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Initial Departure = Estimate Time of Departure.  This is maintained in the Container Order Card.';

                }
                field(ETA; Rec.ETA)
                {
                    Caption = 'Initial Arrival';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Initial Arrival = Estimate Time of Arrival.  This is maintained in the Container Order Card.';

                }
                field(ActualETD; Rec.ActualETD)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Actual Departure = Actual Time of Departure.  This is maintained in the Transfer Order Card.';

                }
                field(ActualETA; Rec.ActualETA)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Actual Arrival = Actual Time of Arrival.  This is maintained in the Transfer Order Card.';
                    StyleExpr = ArrivalDateSyle;

                }
                field(InterStateTransferNeeded; Rec.InterStateTransferNeeded)
                {
                    ApplicationArea = All;
                    ToolTip = 'NOTE: Additional 15 days needed from Actual Arrival Date for being available at final destination warehouse.';
                }

                field("Container Status Notes"; Rec."Container Status Notes")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Container Status Notes: This is maintained in the Transfer Order Card.';
                }
                field(LineTelexReleased; Rec.LineTelexReleased)
                {
                    ApplicationArea = All;
                }
                field(TelexReleased; Rec.TelexReleased)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(PierPass; Rec.PierPass)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(LFD; Rec.LFD)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Actual Pull Date"; Rec."Actual Pull Date Ref")
                {
                    Caption = 'Actual Pull Date';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Actual Pull Date: This is maintained in the Trasnfer Order Card.';
                }
                // pr 12/2/24 - start
                field("Actual Pull Time"; Rec."Actual Pull Time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Actual Pull Time: This is maintained in the Transfer Order Card.';
                    Editable = false;
                }
                field("Actual Delivery Date"; Rec."Actual Delivery Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Actual Delivery Date: This is maintained in the Container Order Card.';
                }
                field(EmptyNotificationDate; Rec.EmptyNotificationDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Empty Notification Date: This is maintained in the Container Order Card.';
                }
                field("Container Return Date"; Rec."Container Return Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Container Return Date: This is maintained in the Container Order Card.';
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Recieving Status"; Rec."Recieving Status")
                {
                    Editable = false;
                    ToolTip = 'Recieving Status: This is maintained in the Transfer Order Card.';
                }
                // pr 12/11/24
                field("Purchasing Code"; Rec."Purchasing Code")
                {
                    ApplicationArea = all;
                }
                field(ContainerSize; Rec.ContainerSize)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Ti; Rec.Ti)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Hi; Rec.Hi)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Exp Date"; Rec."Exp Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("UPC Code"; Rec."UPC Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Drayage; Rec.Drayage)
                {
                    ApplicationArea = all;
                    ToolTip = 'Drayage: This is maintained in the Transfer Order Card.';
                    Editable = false;
                }
                field(Terminal; Rec.Terminal)
                {
                    ApplicationArea = all;
                    ToolTip = 'Terminal: This is maintained in the Transfer Order Card.';
                    Editable = false;
                }

                field("Created By"; Rec.CreatedBy)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Forwarder; Rec.Forwarder)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Carrier; Rec.Carrier)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Buy-From Vendor No."; Rec."Buy-From Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Port of Loading"; Rec."Port of Loading")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                Field("Port of Discharge"; Rec."Port of Discharge")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("M-Pack Weight kg"; Rec."M-Pack Weight kg")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                //pr 3/25/25 - start
                field("Total Carton Weight"; Rec."M-Pack Weight kg" * Rec.GetPackageCount())
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                //pr 3/25/25 - end
                field(DimensionM; Rec.GetDimensionM())
                {
                    Caption = 'Dimension (LxWxH) m';
                    ApplicationArea = All;
                    Editable = false;
                    DecimalPlaces = 5;
                }
                field(CBM; Rec.GetPackageCount() * Rec.GetDimensionM())   //mbr 10/30/24 - It's ok to call GetPackageCount based on Quantity because we want to base from Container Line Table
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'CBM(m)';
                }
                field("Freight Cost"; Rec."Freight Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Freight Bill Amount"; Rec."Freight Bill Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Freight Bill No."; Rec."Freight Bill No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("TO Notes"; Rec."TO Notes")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                    ApplicationArea = All;
                    Editable = false;
                }


                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DeliveryNotes; Rec.DeliveryNotes)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Production Status"; Rec."Production Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                //PR 12/27/24
                field("Manufacturer Code"; Rec."Manufacturer Code")
                {
                    ApplicationArea = all;
                }
                //PR 2/12/25 - start 
                field(Hazard; Rec.Hazard)
                {
                    ApplicationArea = all;

                }
                //PR 2/12/25 - end 
                //pr 5/1/25 - start
                field("Expected Expiration Date"; Rec."Expected Expiration Date")
                {
                    ApplicationArea = all;

                }
                //pr 5/1/25 - end
                //pr 5/30/25 - start
                field("Actual ETA vs Initial ETA"; Rec."Actual ETA vs Initial ETA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Actual Time of Departure – Actual Cargo Ready Date';
                    Editable = false;
                }
                field("Actual ETD vs Actual CRD"; Rec."Actual ETD vs Actual CRD")
                {
                    ToolTip = 'Actual Time of Arrival – Initial ETA';
                    ApplicationArea = All;
                    Editable = false;
                }
                //pr 5/30/25 - end





            }
            group(SummaryTotals)
            {
                ShowCaption = false;
                field(TotalCBM; totalCBM)
                {
                    ApplicationArea = All;
                    Caption = 'Total CBM';
                    Editable = false;
                }
                field(TotalWeight; totalWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Total Weight';
                    Editable = False;
                }
                field(LinesCount; LinesCount)
                {
                    ApplicationArea = All;
                    Caption = 'Total Records Selected';
                    Editable = false;
                }
            }


        }



    }

    actions
    {
        area(Processing)
        {
            action("Container Orders")
            {
                Caption = 'Container Orders';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Delivery;

                trigger OnAction()
                var
                    ContPg: page "Container Orders";
                begin
                    Clear(ContPg);
                    ContPg.Run();
                end;

            }

            action("Transfer Orders")
            {
                Caption = 'Transfer Orders';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = TransferOrder;

                trigger OnAction()
                var
                    TOPage: page "Transfer Orders";
                begin
                    transferOrderClicked := true;
                    Clear(TOPage);
                    TOPage.Run();

                end;

            }
            action("Unit of Measure")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Units of Measure';
                Image = UnitOfMeasure;
                ToolTip = 'View the item''s availability by a unit of measure.';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                //RunObject = Page "Item Availability by UOM";
                trigger OnAction()
                var
                    itemUOM: Record "Item Unit of Measure";
                    uomPage: Page "Item Units of Measure";
                begin
                    itemUOM.Reset();
                    itemUOM.SetRange("Item No.", rec."Item No.");
                    if (itemUOM.FindFirst()) then begin

                        uomPage.SetTableView(itemUOM);
                        uomPage.Run();
                    end;

                end;



            }
            //PR 2/19/25 - calculate the total CBM of all the items in the container lines - start
            action("Calculate Totals")
            {
                Caption = 'Calculate Totals';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Calculate;

                trigger OnAction()
                var
                    SelectedContainerLine: Record ContainerLine;

                begin
                    SelectedContainerLine.Reset();
                    totalCBM := 0;
                    totalWeight := 0;
                    LinesCount := 0;
                    CurrPage.SetSelectionFilter(SelectedContainerLine);
                    IF SelectedContainerLine.FindSet() then
                        repeat
                            LinesCount += 1;
                            SelectedContainerLine.CalcFields("M-Pack Height", "M-Pack Length", "M-Pack Width"
                            , "M-Pack Qty", "M-Pack Weight kg");

                            totalCBM += SelectedContainerLine.GetPackageCount() * SelectedContainerLine.GetDimensionM();

                            totalWeight += SelectedContainerLine.GetPackageCount() * SelectedContainerLine."M-Pack Weight kg";

                        until SelectedContainerLine.Next() = 0;
                    if LinesCount > 0 then begin
                        CurrPage.Update();
                    end;
                end;

            }
            action("Clear Totals")
            {
                Caption = 'Clear Totals';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = ClearLog;

                trigger OnAction()
                begin
                    LinesCount := 0;
                    totalCBM := 0;
                    totalWeight := 0;
                    CurrPage.Update();
                end;
            }
            //PR 2/19/25 - calculate the total CBM of all the items in the container lines - end

        }


    }
    var
        transferOrderClicked: Boolean;
        ContainerNoStyle: Text[50];
        HazardStyle: Text[50];
        TxtStyleExpr: Text;
        totalCBM: Decimal;
        totalWeight: Decimal;
        LinesCount: Integer;
        bEditable: Boolean;
        FDAHoldStyle: Text[50]; // Style for FDA Hold field
        difDateStyle: text[50];
        ArrivalDateSyle: Text[50];

    trigger OnOpenPage()
    var
        User: Record User;
        UserPermissions: Codeunit "User Permissions";
        userSetup: Record "User Setup";

    begin
        transferOrderClicked := false;

    end;

    trigger OnAfterGetRecord()
    var
        TransferLine: Record "Transfer Line";
        TransferOrder: Record "Transfer Header";
        POArchive: Record "Purchase Header Archive";
        POHdr: Record "Purchase Header";
        ArchPurchaseHeader: Record "Purchase Header Archive";
        PostedPurchRcpt: Record "Purch. Rcpt. Header";
        PostedTransferRec: Record "Transfer Receipt Header";
        PostedTransferLn: Record "Transfer Receipt Line";
        PurLin: Record "Purchase Line";
        PRLine: Record "Purch. Rcpt. Line";
        bFound: boolean;
    begin

        rec.GetData();
        //10/2/25 - if InterStateTransferNeeded is true for the item, then make Arrival Date Style to Unfavorable (red) - start
        if Rec.InterStateTransferNeeded then
            ArrivalDateSyle := 'Unfavorable'
        else
            ArrivalDateSyle := 'Standard';
        //10/2/25 - if InterStateTransferNeeded is true for the item, then make Arrival Date Style to Unfavorable (red) - end


        // rec.UpdateNewItem(); 7/7/25 - no need to call anymore.  Can be deleted after further testing
        // rec.CalcEarliestDifDate();  //7/7/25 -  do not call anymore
        if (rec."Days differences earliest" >= 0) then
            difDateStyle := 'Standard'
        else
            difDateStyle := 'Unfavorable';

        // Set FDA Hold style - start
        if Rec."FDA Hold" then
            FDAHoldStyle := 'Unfavorable'
        else
            FDAHoldStyle := 'Standard';
        // Set FDA Hold style - end
        if (rec.Urgent) then
            ContainerNoStyle := 'Unfavorable'
        else begin
            ContainerNoStyle := '';
            //PR 2/14/235 - update PO Vendor - end
            //PR 2/5/25 - make transfer order qty rec if <> qty - start

            TxtStyleExpr := 'Standard';
            if (rec.Status = rec.Status::Open) or (rec.Status = rec.Status::Completed) then
                TxtStyleExpr := 'Standard'//Default

            Else if (Rec.Quantity <> rec."Transfer Line Quantity") then
                TxtStyleExpr := 'Unfavorable';   //BOLD RED

            //PR 2/5/25 - make transfer order qty rec if <> qty - end

            //PR 2/12/25 - If any container line has an item with Hazard = true, change color to Ambiguous (gold) - start
            if (rec.Hazard = true) then
                HazardStyle := 'Unfavorable'
            else
                HazardStyle := 'Standard';
            //PR 2/12/25 - If any container line has an item with Hazard = true, change color to Ambiguous (gold) - end

        end;
    end;


}
