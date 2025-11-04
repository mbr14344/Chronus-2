page 50065 PostedContainerDeliveryPlan
{
    ApplicationArea = All;
    Caption = 'Posted Container Delivery Planning';
    PageType = List;
    SourceTable = "Posted Container Line";
    UsageCategory = Lists;
    Editable = false;
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
                    TableRelation = "Posted Container Header"."Container No.";
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        PostedContPg: Page "Posted Container Order";
                        ContHdr: Record "Posted Container Header";
                    begin

                        ContHdr.Reset();
                        ContHdr.SetRange("Container No.", Rec."Container No.");
                        if ContHdr.FindFirst() then begin
                            Clear(PostedContPg);
                            PostedContPg.SetTableView(ContHdr);
                            PostedContPg.Run();
                        end;

                    end;
                }
                field(Urgent; Rec.Urgent)
                {
                    ApplicationArea = All;
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
                //pr 5/5/25 - end
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
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                    Editable = false;
                }
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
                field("Actual ETA vs Initial ETA"; Rec."Actual ETA vs Initial ETA")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Actual Time of Arrival – Initial ETA.';
                }
                field("Actual ETD vs Actual CRD"; Rec."Actual ETD vs Actual CRD")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Actual Time of Departure – Actual Cargo Ready Date.';
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
            action("Posted Container Orders")
            {
                Caption = 'Posted Container Orders';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Delivery;

                trigger OnAction()
                var
                    ContPg: page "Posted Container Orders";
                begin
                    Clear(ContPg);
                    ContPg.Run();
                end;

            }

            action("Posted Transfer Receipts")
            {
                Caption = 'Posted Transfer Receipts';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = TransferOrder;

                trigger OnAction()
                var
                    TOPage: page "Posted Transfer Receipts";
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
                    SelectedContainerLine: Record "Posted Container Line";

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

    trigger OnOpenPage()
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
        Rec.PONo := '';  //Initialize;
        Rec."PO Owner" := ''; //Initialize
        Rec."PO Vendor" := ''; //Initialize
        rec.POClosed := false;  //Initialize
        rec.TOOpen := false; //Initialize
        Rec.TelexReleased := false; //initialize
        Rec.LineTelexReleased := false; //initalize
        Rec."Customer Responsibility Center" := '';
        Rec.CustCode := '';
        Rec."Production Status" := 0;
        Rec."Your Reference" := '';
        Rec.CalcFields("M-Pack Height", "M-Pack Length", "M-Pack Width", "M-Pack Qty", "M-Pack Weight kg",
            Rec."Order Date", rec."Actual Pull Date", rec."Actual Delivery Date", rec."Container Return Date",
            rec.POUserId, rec."Actual Pull Time", Rec.POUserID, Rec.PONoFromTO, Rec.POOwnerFromTO, rec.Urgent, rec."M-Pack Qty", rec."Container Status Notes", "Transfer Order No.", rec.POCustCode,
            rec.PRCustCode, rec.POCustRespCtr, rec.PRCustRespCtr, rec."Manufacturer Code",
            PierPass, "Recieving Status", "Purchasing Code", ContainerSize, Ti, Hi,
            "UPC Code", Terminal, Drayage, Forwarder, Carrier, "M-Pack Weight kg",
            "Freight Cost", "Freight Bill No.", "Freight Bill Amount", "TO Notes", "Order Date", "Your Reference", "Location Code", "Port of Discharge", "Port of Loading");
        // pr 12/16/24 makes pull date sortable
        rec."Actual Pull Date Ref" := rec."Actual Pull Date";
        // pr 12/16/24 checks if TO is open - start 
        TransferOrder.Reset();
        TransferOrder.SetRange("No.", rec."Transfer Order No.");
        if (TransferOrder.FindFirst()) then begin
            rec.TOOpen := true;
            rec.TelexReleased := TransferOrder."Telex Released";
        end
        else begin
            PostedTransferRec.Reset();
            PostedTransferRec.SetRange("Transfer Order No.", rec."Transfer Order No.");
            if PostedTransferRec.FindFirst() then
                rec.TelexReleased := PostedTransferRec."Telex Released";

        end;

        //mbr 12/18/24 - start - check if transfer line is closed, else get value from Transfer Receipt line
        TransferLine.Reset();
        TransferLine.SetRange("Document No.", rec."Transfer Order No.");
        TransferLine.SetRange("Item No.", rec."Item No.");
        bFound := false;
        if (TransferLine.FindSet()) then begin
            repeat

                if TransferLine."Source Document No." = Rec."Document No." then begin
                    rec."Transfer Line Quantity" := TransferLine.Quantity;
                    rec.LineTelexReleased := TransferLine."Telex Released";
                    rec.CustCode := TransferLine."Shortcut Dimension 1 Code";
                    bFound := true;
                end

                else if TransferLine."PO No." = Rec."Document No." then begin
                    rec."Transfer Line Quantity" := TransferLine.Quantity;
                    rec.LineTelexReleased := TransferLine."Telex Released";
                    rec.CustCode := TransferLine."Shortcut Dimension 1 Code";
                    bFound := true;
                end
                else if TransferLine."Document No." = Rec."Document No." then begin
                    if rec."Document Line No." = TransferLine."Line No." then begin
                        rec."Transfer Line Quantity" := TransferLine.Quantity;
                        rec.LineTelexReleased := TransferLine."Telex Released";
                        rec.CustCode := TransferLine."Shortcut Dimension 1 Code";
                        bFound := true;
                    end;

                end;
            Until (TransferLine.Next() = 0) or (bFound = true);
            if bFound = false then begin
                rec."Transfer Line Quantity" := 0;
                rec.LineTelexReleased := false;
            end;
        end

        else begin
            PostedTransferLn.Reset();
            PostedTransferLn.SetRange("Transfer Order No.", rec."Transfer Order No.");
            PostedTransferLn.SetRange("Item No.", rec."Item No.");
            if PostedTransferLn.FindFirst() then begin
                rec.LineTelexReleased := PostedTransferLn."Telex Released";
                rec."Transfer Line Quantity" := 0;
                rec.CustCode := PostedTransferLn."Shortcut Dimension 1 Code";
            end;


        end;
        //mbr 12/18/24 - end

        // pr 12/16/24 checks if TO is open - end 
        if (StrLen(rec.POUserID) <= 0) then
            Rec.PONo := Rec.PONoFromTO
        else
            Rec.PONo := Rec."Document No.";

        If StrPos(Rec."Document No.", 'T') = 1 then begin
            Rec.PONo := Rec.PONoFromTO;
            Rec."PO Owner" := Rec.POOwnerFromTO;

            //check if PO is closed
            POHdr.Reset();
            POHdr.SetRange("Document Type", POHdr."Document Type");
            POHdr.SetRange("No.", Rec.PONo);
            if not POHdr.FindFirst() then
                Rec.POClosed := true;
        end;

        Rec.CalcFields(POUserID);

        if StrLen(Rec.POUserID) = 0 then begin
            if strlen(Rec.PONo) = 0 then
                Rec.PONo := Rec."Document No.";


            //mbr 12/11/24 - update PO owner
            If StrPos(Rec."Document No.", 'T') = 0 then begin
                IF Rec."PONo" <> '' then begin
                    if Rec.POClosed = false then begin
                        POHdr.Reset();
                        POHdr.SetRange("Document Type", POHdr."Document Type");
                        POHdr.SetRange("No.", Rec.PONo);
                        if POHdr.FindFirst() then begin
                            Rec."PO Owner" := POHdr.CreatedUserID;
                            rec."PO Vendor" := pohdr."Buy-from Vendor No.";

                        end
                        else begin
                            PostedPurchRcpt.Reset();
                            PostedPurchRcpt.SetRange("Order No.", Rec."PONo");
                            if PostedPurchRcpt.FindFirst() then begin
                                Rec."PO Owner" := PostedPurchRcpt.CreatedUserID;
                                rec."PO Vendor" := PostedPurchRcpt."Buy-from Vendor No.";
                                Rec.POClosed := true;

                            end
                            else begin
                                ArchPurchaseHeader.Reset();
                                ArchPurchaseHeader.SetCurrentKey("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
                                ArchPurchaseHeader.SetRange("Document Type", ArchPurchaseHeader."Document Type"::Order);
                                ArchPurchaseHeader.SetRange("No.", Rec."PONo");
                                ArchPurchaseHeader.Ascending(false);
                                if ArchPurchaseHeader.FindFirst() then begin
                                    Rec."PO Owner" := ArchPurchaseHeader.CreatedUserID;
                                    rec."PO Vendor" := ArchPurchaseHeader."Buy-from Vendor No.";
                                    Rec.POClosed := true;

                                end;
                            end;

                        end;
                    end;



                end;

            end;
        end
        //mbr 12/11/24 - update PO Owner


        else begin
            Rec."PO Owner" := Rec.POUserID;
        end;

        if (rec.Urgent) then
            ContainerNoStyle := 'Unfavorable'
        else begin
            ContainerNoStyle := '';
        end;
        //update Customer Responsibility Center
        PurLin.Reset();
        PurLin.SetRange("Document No.", Rec.PONo);
        PurLin.SetRange(Type, PurLin.Type::Item);
        PurLin.SetRange("No.", Rec."Item No.");
        If PurLin.FindFirst() then begin
            Rec.CalcFields(POCustRespCtr);
            Rec."Customer Responsibility Center" := Rec.POCustRespCtr;
            //PR 3/6/25 
            Rec."Production Status" := PurLin."Production Status";
        end

        else begin
            PRLine.Reset();
            PRLine.SetRange("Order No.", Rec.PONo);
            PRLine.SetRange(Type, PRLine.Type::Item);
            PRLine.SetRange("No.", Rec."Item No.");
            IF PRLine.FindFirst() then begin
                Rec.CalcFields(PRCustRespCtr);
                Rec."Customer Responsibility Center" := Rec.PRCustRespCtr;
                //PR 3/6/25 
                Rec."Production Status" := PRLine."Production Status";
            end;

        end;
        Rec.Modify();
        //PR 2/14/235 - update PO Vendor - start
        POHdr.Reset();
        POHdr.SetRange("Document Type", POHdr."Document Type");
        POHdr.SetRange("No.", Rec."PONo");
        if POHdr.FindSet() then begin
            Rec."PO Vendor" := pohdr."Buy-from Vendor No.";
            Rec."Production Status" := pohdr."Production Status";
            Rec."Your Reference" := POHdr."Your Reference";
        end
        else begin
            PostedPurchRcpt.Reset();
            PostedPurchRcpt.SetRange("Order No.", Rec."PONo");
            if PostedPurchRcpt.FindFirst() then begin
                rec."PO Vendor" := PostedPurchRcpt."Buy-from Vendor No.";
                Rec."Production Status" := PostedPurchRcpt."Production Status";
                Rec."Your Reference" := PostedPurchRcpt."Your Reference";
            end
            else begin
                ArchPurchaseHeader.Reset();
                ArchPurchaseHeader.SetCurrentKey("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
                ArchPurchaseHeader.SetRange("Document Type", ArchPurchaseHeader."Document Type"::Order);
                ArchPurchaseHeader.SetRange("No.", Rec."PONo");
                ArchPurchaseHeader.Ascending(false);
                if ArchPurchaseHeader.FindFirst() then begin
                    rec."PO Vendor" := ArchPurchaseHeader."Buy-from Vendor No.";
                    //PR 3/6/25 
                    Rec."Production Status" := ArchPurchaseHeader."Production Status";
                    Rec."Your Reference" := ArchPurchaseHeader."Your Reference";
                end;
            end;
        end;
        rec.CalcFields(Salesperson);
        rec.UpdateActualETDvsCRD();
        rec.UpdateActualETAvsETA();
        rec.GetLotNo();
        Rec.Modify();
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


}
