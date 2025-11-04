page 50067 QtyAssgnToContainerDetailsPg
{
    ApplicationArea = All;
    Caption = 'Qty Assigned To Containers';
    PageType = List;
    SourceTable = TmpQtyAssgnToContainerDetails;
    SourceTableTemporary = true;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Container No."; Rec."Container No.")
                {
                    ToolTip = 'Specifies the value of the Container No. field.';
                    Editable = FALSE;
                    StyleExpr = ContainerNoStyle;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        ContainerHdr: Record "Container Header";
                        ContainerHdrPg: Page "Container Order Card";
                        PostedContainerHdr: Record "Posted Container Header";
                        PostedContainerHdrPg: Page "Posted Container Order";
                    begin
                        if (rec.Posted = false) then begin
                            ContainerHdr.Reset();
                            ContainerHdr.SetRange("Container No.", rec."Container No.");
                            if (ContainerHdr.FindSet()) then begin
                                Clear(ContainerHdrPg);
                                ContainerHdrPg.SetTableView(ContainerHdr);
                                ContainerHdrPg.Run();
                            end
                        end
                        else begin
                            PostedContainerHdr.Reset();
                            PostedContainerHdr.SetRange("Container No.", rec."Container No.");
                            if (PostedContainerHdr.FindSet()) then begin
                                Clear(PostedContainerHdrPg);
                                PostedContainerHdrPg.SetTableView(PostedContainerHdr);
                                PostedContainerHdrPg.Run();
                            end
                        end;
                    end;
                    //TableRelation = 'containerNoTableRel;'
                    //TableRelation = "Container Header"."Container No.";
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
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    Editable = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                //PR 2/5/25 - make transfer order qty rec if <> qty - start
                field("Transfer Line Quantity"; Rec."Transfer Line Quantity")
                {


                }
                field("M-Pack Qty"; Rec."M-Pack Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Requested In Whse Date"; Rec."Requested In Whse Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ActualCargoReadyDate; Rec.ActualCargoReadyDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(EstimatedInWarehouseDate; Rec.EstimatedInWarehouseDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Freight Cost.  This is maintained in the Container Order Card.';
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
                field(AssignedUserID; Rec.AssignedUserID)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                //pr 12/4/24


            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if (rec.Posted) then
            ContainerNoStyle := 'Unfavorable'
        else
            ContainerNoStyle := '';

    end;

    var
        ContainerNoStyle: Text[50];
        count: Integer;
        containerNoTableRel: Record "Container Header";


    procedure GetCount() returnVal: Integer
    begin
        returnVal := count;
    end;

    procedure GetLines(inPurchLine: Record "Purchase Line")
    var

        ContainLine: Record ContainerLine;
        PostedContainLine: Record "Posted Container Line";
    begin
        if (inPurchLine."Qty Assigned to Container" > 0) then begin
            // resets rec
            rec.DeleteAll();
            rec.reset;
            count := 0;
            // finds all the container lines
            ContainLine.Reset();
            ContainLine.SetRange("Item No.", inPurchLine."No.");
            ContainLine.SetRange("Document No.", inPurchLine."Document No.");
            ContainLine.SetRange("Document Line No.", inPurchLine."Line No.");
            if (ContainLine.FindSet()) then
                repeat
                    ContainLine.GetData();
                    rec.Init();
                    rec.CopyFromContainerLine(ContainLine);
                    rec.Insert();
                    count += 1;
                until ContainLine.Next() = 0;
            // finds all the posted container lines
            PostedContainLine.Reset();
            PostedContainLine.SetRange("Item No.", inPurchLine."No.");
            PostedContainLine.SetRange("Document No.", inPurchLine."Document No.");
            PostedContainLine.SetRange("Document Line No.", inPurchLine."Line No.");
            if (PostedContainLine.FindSet()) then
                repeat
                    PostedContainLine.GetData();
                    rec.Init();
                    rec.CopyFromPostedContainerLine(PostedContainLine);
                    rec.Insert();
                    count += 1;

                until PostedContainLine.Next() = 0;
        end;
        rec.reset;

        CurrPage.Update(false);
    end;
}
