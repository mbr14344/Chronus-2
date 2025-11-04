pageextension 50024 PurchaseLinesPageExt extends "Purchase Lines"
{

    Editable = true;


    layout
    {
        modify("Document Type")
        {
            Visible = false;
        }
        modify("Outstanding Amount (LCY)")
        {
            Visible = false;
        }
        modify("Reserved Qty. (Base)")
        {
            Visible = false;
        }
        modify("Direct Unit Cost")
        {
            Visible = false;
        }
        modify("Line Amount")
        {
            Visible = false;
        }
        // pr 7/12/24 making all fields not editable execpt qty to assgn to container and qty assigned to container
        modify("Document No.")
        {
            Editable = false;
            // pr 10/8/24 - show purchase order page when clicked on doc no - start
            trigger OnDrillDown()
            var
                purchOrder: Page "Purchase Order";
                purchHeader: Record "Purchase Header";
            begin
                purchHeader.Reset();
                purchHeader.SetRange("No.", rec."Document No.");
                purchHeader.SetRange("Document Type", rec."Document Type");
                if (purchHeader.FindFirst()) then begin
                    Clear(purchOrder);
                    purchOrder.SetRecord(purchHeader);
                    purchOrder.Run();
                end;

            end;
            // pr 10/8/24 - show purchase order page when clicked on doc no - end
        }
        modify("Buy-from Vendor No.")
        {
            Editable = false;
        }
        modify(Type)
        {
            Editable = false;
        }
        modify("No.")
        {
            Editable = false;
        }
        modify(Description)
        {
            Editable = false;
            Visible = false;
        }
        modify("Location Code")
        {
            Editable = true;
        }
        modify("Unit of Measure Code")
        {
            Editable = false;
        }
        modify("Expected Receipt Date")
        {
            Editable = false;
        }
        modify(Quantity)
        {
            Editable = false;


        }
        modify("Outstanding Quantity")
        {
            Visible = false;
        }
        addafter(Description)
        {
            //PR 12/19/24
            field("Item Purchasing Code"; Rec."Item Purchasing Code")
            {
                ApplicationArea = All;
                Caption = 'Purchasing Code';
                ToolTip = 'Purchasing Code: This is maintained in the Item Card.';
            }
            //PR 12/27/24
            field("Manufacturer Code"; Rec."Manufacturer Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Document No.")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Customer Responsibility Center"; Rec."Customer Responsibility Center")
            {
                ApplicationArea = All;
            }

            field(ItemType; Rec.ItemType)
            {
                ApplicationArea = All;
                Editable = false;
            }

            field(CreatedUserID; Rec.CreatedUserID)
            {
                ApplicationArea = All;
            }
            field(CreatedDate; Rec.CreatedDate)
            {
                ApplicationArea = All;
            }

        }


        addafter("Buy-from Vendor No.")
        {
            field("Port Of Loading"; Rec."Port Of Loading")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Port Of Discharge"; Rec."Port Of Discharge")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field("Container No."; Rec."Container No.")
            {
                ApplicationArea = All;
                Visible = false;
                Editable = false;
            }

        }
        addafter(Quantity)
        {
            field("OutstandingQuantity"; Rec."Outstanding Quantity")
            {
                Caption = 'Outstanding Quantity';
                ApplicationArea = all;
                StyleExpr = 'Favorable';
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
            field(AssignedToContainer; Rec.AssignedToContainer)
            {
                ApplicationArea = All;
                Visible = not bSelectContainer;
                Editable = false;

            }
            field("Qty to Assign to Container"; Rec."Qty to Assign to Container")
            {
                Caption = 'Qty to Assign to Container';
                ApplicationArea = all;
                //DecimalPlaces = 0 : 5;
                Visible = isQtyToAssgn;
                Editable = isQtyToAssgn;
                trigger OnValidate()
                begin
                    if (rec."Qty to Assign to Container" > (rec.Quantity - rec."Qty Assigned to Container")) then begin
                        Error(errorNoQtyToAssgnLessThanOutstanding);
                    end
                    else if (rec."Qty to Assign to Container" = 0) then
                        Error(errorNoQtyToAssgn);

                    CurrPage.Update(true);

                end;
            }

            field("Qty Assigned to Container"; Rec."Qty Assigned to Container")
            {
                Caption = 'Qty Assigned to Container';
                ApplicationArea = all;
                //DecimalPlaces = 0 : 5;
                Visible = true;
                Editable = false;
                trigger OnDrillDown()
                var
                    ContainDelivPlanning: Page "Container Delivery Planning";
                    ContainLine: Record ContainerLine;
                    QtyToAssgnDetailPg: Page QtyAssgnToContainerDetailsPg;
                    TmpQtyAssgnDetail: Record TmpQtyAssgnToContainerDetails;
                begin
                    if (rec."Qty Assigned to Container" > 0) then begin
                        TmpQtyAssgnDetail.Reset();
                        TmpQtyAssgnDetail.DeleteAll();
                        Clear(QtyToAssgnDetailPg);
                        QtyToAssgnDetailPg.SetTableView(TmpQtyAssgnDetail);
                        QtyToAssgnDetailPg.GetLines(rec);
                        if (QtyToAssgnDetailPg.GetCount() > 0) then
                            QtyToAssgnDetailPg.Run();
                    end;

                end;
            }

            field("M-Pack Qty"; Rec."M-Pack Qty")
            {
                ApplicationArea = All;
                Caption = 'M-Pack Qty';
                Editable = false;
            }
            Field("M-Pack Weight"; Rec."M-Pack Weight")
            {
                ApplicationArea = All;
                Editable = false;
            }
            Field("M-Pack Weight kg"; Rec."M-Pack Weight kg")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(PackageCount; Rec.GetPackageCount())
            {
                Caption = 'Package Count';
                ApplicationArea = All;
                DecimalPlaces = 0 : 1;
                Editable = false;
            }
            field(GetOutstandingPackageCount; Rec.GetOutstandingPackageCount)
            {
                Caption = 'Outstanding Package Count';
                ApplicationArea = All;
                DecimalPlaces = 0 : 1;
                Editable = false;
            }
            field(DimensionM; Rec.GetDimensionM())
            {
                Caption = 'Dimension (LxWxH) m';
                ApplicationArea = All;
                Editable = false;
                DecimalPlaces = 5;
            }
            field(CBM; Rec.GetOutstandingPackageCount() * Rec.GetDimensionM())
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'CBM(m)';
                ToolTip = 'CBM(m): Outstanding Package Count * Dimension (LxWxH) m';
            }
            field(GW; Rec.GetOutstandingPackageCount() * Rec."M-Pack Weight kg")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'GW(kg)';
                ToolTip = 'GW(kg): Outstanding Package Count * M-Pack Weight (kg)';
            }
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Quantity Received"; Rec."Quantity Received")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Quantity Invoiced"; Rec."Quantity Invoiced")
            {
                ApplicationArea = All;
                Visible = false;
                Editable = false;
            }
        }
        addbefore("Expected Receipt Date")
        {

            field("Production Status"; Rec."Production Status")
            {
                ApplicationArea = All;
            }
            field(POFinalizeDate; Rec.POFinalizeDate)
            {
                ApplicationArea = All;
            }
            field("Expected Expiration Date"; Rec."Expected Expiration Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Expected Receipt Date")
        {
            field(DoNotShipBeforeDate; Rec.DoNotShipBeforeDate)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(RequestedCargoReadyDate; Rec.RequestedCargoReadyDate)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(RequestedInWhseDate; Rec.RequestedInWhseDate)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(EstimatedInWarehouseDate; Rec.EstimatedInWarehouseDate)
            {
                ApplicationArea = All;
                Editable = true;
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
            field("CRD Differences"; Rec."CRD Differences")
            {
                ApplicationArea = All;
                Editable = true;
            }
            field(ActualCargoReadyDate; Rec.ActualCargoReadyDate)
            {
                ApplicationArea = All;
                Editable = true;
            }
            field(DeliveryNotes; Rec.DeliveryNotes)
            {
                ApplicationArea = All;
                Editable = true;
            }
            field("Assigned User ID"; Rec."Assigned User ID")
            {
                Caption = 'Owner';
                ApplicationArea = All;
                Editable = false;
            }

            field(Forwarder; Rec.Forwarder)
            {
                ApplicationArea = All;
                Editable = false;
            }
            //PR 3/31/25 - start
            field(Incoterm; Rec.Incoterm)
            {
                ApplicationArea = All;
            }
            //PR 3/31/25 - end

            //pr 5/5/25 - start
            field(Salesperson; Rec.Salesperson)
            {
                ApplicationArea = All;

            }
            //pr 5/5/25 - end
            field("New Item"; Rec."New Item")
            {
                ApplicationArea = All;
            }




        }
        addafter(Control1)
        {
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
        addafter(Description)
        {
            field("Real Time Item Description"; Rec."Real Time Item Description")
            {
                ApplicationArea = all;
            }
        }


    }
    actions
    {
        modify("RedistributeAccAllocations")
        {
            Visible = not bSelectContainer;
        }
        modify("ReplaceAllocationAccountWithLines")
        {
            Visible = not bSelectContainer;
        }
        modify("Detach Lines")
        {
            Visible = not bSelectContainer;
        }
        addafter("Show Document")
        {
            action("Assign Now")
            {
                ApplicationArea = all;
                Image = Reserve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = bSelectContainer;
                trigger OnAction()
                begin
                    AssignNow();
                end;

            }
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
                    SelectedPurchaseLines: Record "Purchase Line";

                begin
                    SelectedPurchaseLines.Reset();
                    totalCBM := 0;
                    totalWeight := 0;
                    LinesCount := 0;
                    CurrPage.SetSelectionFilter(SelectedPurchaseLines);
                    IF SelectedPurchaseLines.FindSet() then
                        repeat
                            LinesCount += 1;
                            SelectedPurchaseLines.CalcFields(RequestedCargoReadyDate, DoNotShipBeforeDate, RequestedInWhseDate, "Port Of Loading", "M-Pack Height", "M-Pack Length", "M-Pack Width"
                            , "M-Pack Qty", "M-Pack Weight kg");

                            totalCBM += SelectedPurchaseLines.GetOutstandingPackageCount() * SelectedPurchaseLines.GetDimensionM();

                            totalWeight += SelectedPurchaseLines.GetOutstandingPackageCount() * SelectedPurchaseLines."M-Pack Weight kg";

                        until SelectedPurchaseLines.Next() = 0;
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

            // 10/7/25 - start
            action(UpdateMondayPONo)
            {

                ApplicationArea = All;
                Caption = 'Monday.com PO No.';
                ToolTip = 'Update Monday.com PO No.';
                Image = UpdateDescription;
                Promoted = true;
                PromotedIsBig = true;
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
                    noItemErrTxt: Label 'Item %1 not found. Cannot update Monday.com PO No.';
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
                PromotedIsBig = true;
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

            //10/7/25 - end
            action("Container Orders")
            {
                Caption = 'Container Orders';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Delivery;
                Visible = not bContainerVis;

                trigger OnAction()
                var
                    ContPg: page "Container Orders";
                    ContHdr: Record "Container Header";
                begin
                    Clear(ContPg);
                    ContHdr.Reset();
                    If ContHdr.FindSet() then begin
                        ContPg.SetTableView(ContHdr);
                        ContPg.Run();
                    end;

                end;

            }



        }
        modify("Show Document")
        {

            trigger OnAfterAction()
            begin
                Clear(purchOrderCard);
                purchOrderCard.SetIsQtyToAssgn(true);
            end;


        }
    }
    trigger OnClosePage()
    begin
        isQtyToAssgn := false;
    end;




    var
        bSelectContainer: Boolean;
        difDateStyle: text[50];
        ContainerNo: Code[50];
        GetPOL: Code[20];
        GetPOD: Code[20];
        GetLocation: Code[20];
        txtPOLBlank: Label 'Port of Loading is Mandatory.  Please review %1';
        txtPOLMustBeUnique: Label 'POL %1 found.  A container cannot have > 1 POL.  Please review %2.';
        txtPODMustBeUique: Label 'POD %1 found.  A container cannot have > 1 POD.  Please review %2.';

        txtLocationMustBeUnique: Label 'Location %1 found.  A container cannot have > 1 Location.  Please review %2.';
        txtAssignedAlready: Label 'Document No. %1 Item No %2 has already been assigned to a container no.  Task Aborted.';
        txtPOLAlreadyExists: Label 'Container %1 cannot have > 1 POL.  Please review %2.';
        txtPODAlreadyExists: Label 'Container %1 cannot have > 1 POD.  Please review %2.';
        txtTypeError: Label 'Document %1 has type = %2.  Only Item Types can be included.';
        txtLocationBlank: Label 'Location Code is Mandatory.  Please review %1';
        txtPODBlank: Label 'Port of Discharge is Mandatory.  Please review %1';
        txtLocationAlreadyExists: Label 'Container %1 cannot have > 1 Location.  Please review %2.';
        txtErrItemType: Label 'Please unselect Purchase Lines <> Type Item.';
        txtItemService: Label 'Please unselect Purchase Lines that have items with type =  Service.';
        txtLocationCodeMandatory: Label 'Location Code is Mandatory for all selected purchase lines.';
        totalCBM: Decimal;
        totalWeight: Decimal;
        LinesCount: Integer;
        bContainerVis: Boolean;
        lblPageCaption: Label 'Get Purchase Lines';
        txtOutStandingQty: Label 'Outstanding Quantity CANNOT BE Zero! Please review.';
        TxtMustBeReleased: Label 'Purchase Order selected MUST BE Released.';
        isQtyToAssgn: boolean;
        errorNoQtyToAssgn: Label 'Qty To Assign To Container is mandatory';
        errorNoQtyToAssgnLessThanOutstanding: Label 'Make sure Qty to Assign to Container does not exceed Qty minus Qty Assigned to Container.';

        errorNoQtyToAssgnToLarge: Label 'Make sure Qty Assigned to Container does not exceed Qty.';

        purchOrderCard: Page "Purchase Order";
        ErrTxtContLineExists: Label 'Item %1 has already been assigned to Container %2.  Please review.';

    procedure SetIsQtyToAssgn(isActive: Boolean)
    begin
        isQtyToAssgn := isActive;
        CurrPage.Editable := isActive;
        CurrPage.Update();
    end;

    procedure SetContainer(val: Boolean; GetContNo: Code[50])
    begin
        bSelectContainer := val;
        ContainerNo := GetContNo;
    end;

    procedure AssignNow()
    var
        rec1: Record "Purchase Line";
        PurchHdr: Record "Purchase Header";
        SelectInCont: Record SelectIntoContainer;
        i: Integer;
        ContLine: Record ContainerLine;
        item: Record Item;
        itemUOM: record "Item Unit of Measure";
    begin
        if bSelectContainer = true then begin
            CurrPage.SetSelectionFilter(rec1);
            If rec.Count >= 1 then begin
                //Rec.Modify();
                //Commit();
                SelectInCont.Reset();
                SelectInCont.SetRange(UserID, UserId);
                if SelectInCont.FindSet() then begin
                    SelectInCont.DeleteAll();
                    Commit();
                end;

                SelectInCont.Reset;
                if SelectInCont.FindLast() then
                    i := SelectInCont."Entry No."
                else
                    i := 0;

                CurrPage.SetSelectionFilter(rec1);
                if rec1.findset then
                    repeat

                        if rec1."Outstanding Quantity" = 0 then
                            Error(txtOutStandingQty);

                        if rec1.Type <> rec1.Type::Item then
                            Error(txtErrItemType);

                        If item.get(rec1."No.") then
                            if item.Type = item.Type::Service then
                                Error(txtItemService);

                        if StrLen(Rec1."Location Code") = 0 then
                            Error(txtLocationCodeMandatory);

                        PurchHdr.Reset();
                        PurchHdr.SetRange("No.", rec1."Document No.");
                        PurchHdr.SetRange("Document Type", PurchHdr."Document Type"::Order);
                        PurchHdr.SetRange(Status, PurchHdr.Status::Released);
                        If not PurchHdr.FindFirst then
                            Error(TxtMustBeReleased);

                        rec1.CalcFields("Port Of Discharge", "Port Of Loading");
                        // pr 9/5/24 - allow PO to be assigned to multiple containers. No need to error out when AssignedToContainer = true - start
                        //if rec1.AssignedToContainer = true then
                        //Error(txtAssignedAlready, rec1."Document No.", rec1."No.");
                        // pr 9/5/24 - allow PO to be assigned to multiple containers - end
                        if rec1."Port Of Loading" = '' then
                            Error(txtPOLBlank, rec1."Document No.");

                        if rec1."Port Of Discharge" = '' then
                            Error(txtPODBlank, rec1."Document No.");
                        if rec1."Location Code" = '' then
                            Error(txtLocationBlank, rec1."Document No.");

                        if GetLocation = '' then
                            GetLocation := rec1."Location Code";

                        if GetPOL = '' then
                            GetPOL := rec1."Port Of Loading";

                        if GetLocation <> rec1."Location Code" then
                            Error(txtLocationMustBeUnique, GetLocation, rec1."Document No.");

                        if GetPOL <> rec1."Port Of Loading" then
                            Error(txtPOLMustBeUnique, getPOL, rec1."Document No.");

                        if GetPOD = '' then
                            GetPOD := rec1."Port Of Discharge";

                        if (GetPOD <> rec1."Port Of Discharge") then
                            Error(txtPODMustBeUique, GetPOD, rec."Document No.");


                        ContLine.reset;
                        ContLine.SetRange("Container No.", ContainerNo);
                        ContLine.SetFilter("Port of Loading", '<>%1', rec1."Port Of Loading");
                        if ContLine.FindSet() then
                            Error(txtPOLAlreadyExists, ContainerNo, rec1."Document No.");

                        ContLine.reset;
                        ContLine.SetRange("Container No.", ContainerNo);
                        ContLine.SetFilter("Location Code", '<>%1', rec1."Location Code");
                        if ContLine.FindSet() then
                            Error(txtLocationAlreadyExists, ContainerNo, rec1."Document No.");


                        ContLine.reset;
                        ContLine.SetRange("Container No.", ContainerNo);
                        ContLine.SetFilter("Port of Discharge", '<>%1', rec1."Port Of Discharge");

                        if ContLine.FindSet() then
                            Error(txtPODAlreadyExists, ContainerNo, rec."Document No.");

                        //mbr 12/3/24 - make sure container lines do not have the unique key: Document No, document Line, item No yet.
                        ContLine.reset;
                        ContLine.SetRange("Container No.", ContainerNo);
                        ContLine.SetRange("Document No.", rec1."Document No.");
                        ContLine.SetRange("Document Line No.", rec1."Line No.");
                        ContLine.SetRange("Item No.", rec1."No.");
                        if ContLine.FindFirst() then
                            Error(StrSubstNo(ErrTxtContLineExists, rec1."No.", ContLine."Container No."));

                        if rec1.type = rec1.type::item then begin
                            i += 1;
                            SelectInCont."Entry No." := i;
                            SelectInCont.UserID := UserId;
                            SelectInCont.DocumentNo := rec1."Document No.";
                            SelectInCont.ItemNo := rec1."No.";
                            SelectInCont.LocationCode := rec1."Location Code";
                            // pr 7/12/24 - start
                            SelectInCont.Quantity := rec1."Qty to Assign to Container";
                            // pr 7/12/24 - end
                            SelectInCont."Buy-from Vendor No." := rec1."Buy-from Vendor No.";
                            itemUOM.Reset();
                            itemUOM.SetRange("Item No.", rec1."No.");
                            itemUOM.SetRange(Code, rec1."Unit of Measure Code");
                            if itemUOM.FindFirst() then
                                SelectInCont."Quantity Base" := rec1."Qty to Assign to Container" * itemUOM."Qty. per Unit of Measure";

                            SelectInCont."Unit of Measure Code" := rec1."Unit of Measure Code";
                            SelectInCont.DocumentLineNo := rec1."Line No.";
                            SelectInCont."Port of Discharge" := rec1."Port Of Discharge";
                            SelectInCont."Port of Loading" := rec1."Port Of Loading";
                            SelectInCont."Container No." := ContainerNo;
                            SelectInCont."Location Code" := rec1."Location Code";
                            SelectInCont.DeliveryNotes := rec1.DeliveryNotes;
                            SelectInCont.ActualCargoReadyDate := rec1.ActualCargoReadyDate;
                            SelectInCont.EstimatedInWarehouseDate := rec1.EstimatedInWarehouseDate;
                            SelectInCont.RequestedInWhseDate := PurchHdr.RequestedInWhseDate;
                            SelectInCont.Insert();

                            rec1."Qty Assigned to Container" += rec1."Qty to Assign to Container";
                            rec1."Qty to Assign to Container" := 0;
                            // pr 7/12/24 - end
                            rec1.AssignedToContainer := true;
                            rec1."Container No." := ContainerNo;
                            rec1.Modify();
                        end
                        else
                            Error(txtTypeError, rec1."Document No.", format(rec1.type));


                    until rec1.Next() = 0;
                close();

            end;
        end;
    end;

    procedure SetContainerVis(InValue: Boolean)
    begin
        bContainerVis := InValue;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(RequestedCargoReadyDate, DoNotShipBeforeDate,
        RequestedInWhseDate, "Port Of Loading", "M-Pack Height", "M-Pack Length",
         "M-Pack Width", "M-Pack Qty", "M-Pack Weight kg",
         "Item Purchasing Code", "Manufacturer Code", Incoterm, Salesperson, "Real Time Item Description");
        //rec.GetCRDDif(); //7/7/25 - no need to call anymore.  Can be deleted after further testing
        rec.UpdateNewItem();  //7/7/25 -no need to call anymore.  Can be deleted after further testing - Enabled for now until this is fully tested
        // rec.CalcEarliestDifDate();  //7/7/25 - no need to call anymore.  Can be deleted after further testing
        rec.CalcInitETAnETD();
        if (rec."Days differences earliest" >= 0) then
            difDateStyle := 'Standard'
        else
            difDateStyle := 'Unfavorable';

    end;


    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update();
    end;

    trigger OnOpenPage()
    var
        PurLine: Record "Purchase Line";
    begin
        if bSelectContainer = true then begin
            PurLine.Reset();
            PurLine.SetRange("Document Type", PurLine."Document Type"::Order);
            PurLine.SetRange(Type, PurLine.Type::Item);
            if PurLine.FindSet() then
                repeat
                    PurLine."Qty to Assign to Container" := PurLine.Quantity - PurLine."Qty Assigned to Container";  //update the Qty to Assign to Container
                    PurLine.Modify();
                until PurLine.Next() = 0;
            CurrPage.Caption := lblPageCaption;
        end;

    end;


}
