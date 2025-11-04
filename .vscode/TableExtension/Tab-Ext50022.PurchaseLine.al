tableextension 50022 "Purchase Line" extends "Purchase Line"
{


    fields
    {

        modify("No.")
        {
            trigger OnAfterValidate()
            var
                PurchaseHeader: Record "Purchase Header";
                f: Record "G/L Account";
            begin
                if xRec."No." <> Rec."No." then begin
                    PurchaseHeader.RESET;
                    PurchaseHeader.SetRange("No.", "Document No.");
                    PurchaseHeader.SetRange("Document Type", "Document Type");
                    IF PurchaseHeader.FindFirst() then
                        VALIDATE("Planned Receipt Date", PurchaseHeader.RequestedInWhseDate);
                    GenCU.UpdateEarliestStartShipDatePurch(Rec);
                    UpdateNewItem();
                end;



            end;


        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                PurchasePrice: Record "Purchase Price";
                bPassed: Boolean;
                Item: Record Item;
                popupConfirm: Page "Confirmation Dialog";
                ContainerLine: Record ContainerLine;
                SumContQty: Decimal;
            begin
                if rec."Document Type" = Rec."Document Type"::Order then begin

                    if Rec.Type = Rec.Type::Item then begin
                        if Item.Get(Rec."No.") then
                            if Item.Type = Item.Type::Inventory then begin


                                bPassed := true;
                                if (rec.Quantity <> xRec.Quantity) AND (rec.Quantity > 0) then begin
                                    PurchasePrice.Reset();
                                    PurchasePrice.SetCurrentKey("Vendor No.", "Item No.", "Minimum Quantity");
                                    PurchasePrice.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
                                    PurchasePrice.SetRange("Item No.", Rec."No.");
                                    PurchasePrice.SetFilter("Starting Date", '<=%1|%2', Today, 0D);
                                    PurchasePrice.SetFilter("Ending Date", '>%1|%2', Today, 0D);
                                    PurchasePrice.SetFilter("Direct Unit Cost", '>%1', 0);
                                    PurchasePrice.SetFilter("Unit of Measure Code", Rec."Unit of Measure Code");
                                    PurchasePrice.SetFilter("Minimum Quantity", '<=%1', Rec.Quantity);
                                    if NOT PurchasePrice.findset() then
                                        bPassed := false;
                                end;
                                if bPassed = false then begin
                                    PurchasePrice.Reset();
                                    PurchasePrice.SetCurrentKey("Vendor No.", "Item No.", "Minimum Quantity");
                                    PurchasePrice.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
                                    PurchasePrice.SetRange("Item No.", Rec."No.");
                                    PurchasePrice.SetFilter("Starting Date", '<=%1|%2', Today, 0D);
                                    PurchasePrice.SetFilter("Ending Date", '>%1|%2', Today, 0D);
                                    PurchasePrice.SetFilter("Direct Unit Cost", '>%1', 0);
                                    PurchasePrice.SetFilter("Unit of Measure Code", Rec."Unit of Measure Code");
                                    if not PurchasePrice.findset() then begin
                                        Clear(popupConfirm);
                                        popupConfirm.setMessage(StrSubstNo(TxtVendorNoPrice, Rec."Buy-from Vendor No."));
                                        Commit;
                                        if popupConfirm.RunModal() = Action::no then
                                            Error(TxtTaskAborted)
                                        else begin
                                            Rec."Direct Unit Cost" := 0;
                                            Rec.Validate("Unit Cost", 0);
                                            Rec.Validate("Unit Cost (LCY)", 0);
                                            Rec.UpdateAmounts();
                                        end;
                                    end
                                    else begin
                                        bExit := false;
                                        repeat
                                            if PurchasePrice."Minimum Quantity" > Rec.Quantity then begin
                                                //mbr 9/13/24 - Per Mandy, we don't want to error out anymore.  Just give users option to override.
                                                Clear(popupConfirm);
                                                popupConfirm.setMessage(StrSubstNo(TxtVendorMinQtyErr, Rec."Buy-from Vendor No."));
                                                Commit;
                                                if popupConfirm.RunModal() = Action::no then
                                                    Error(TxtTaskAborted)
                                                else begin
                                                    Rec.Validate("Direct Unit Cost", PurchasePrice."Direct Unit Cost");
                                                    bExit := true;
                                                    //Rec.Validate("Unit Cost", PurchasePrice."Direct Unit Cost");
                                                    //Rec.Validate("Unit Cost (LCY)", PurchasePrice."Direct Unit Cost");
                                                    //Rec.UpdateAmounts();
                                                end;
                                            end;
                                        until (PurchasePrice.Next() = 0) or (bExit = true);
                                    end;




                                end;


                            end;

                        //mbr 2/24/25 - start
                        //when users update a PO line qty, check if this PO line was assigned to any container order.  
                        // so, add up the container line qty and if sum(containerlineqty) > new Quantity, error out
                        If rec.Quantity <> xrec.Quantity then begin
                            SumContQty := 0;
                            containerline.Reset();
                            containerline.SetRange(SourceNo, Database::"Purchase Line");
                            containerline.SetRange("Document No.", Rec."Document No.");
                            containerline.SetRange("Document Line No.", Rec."Line No.");
                            containerline.SetRange("Item No.", Rec."No.");
                            if containerline.FindSet() then
                                repeat
                                    SumContQty += ContainerLine.Quantity;
                                until containerline.Next() = 0;
                            if SumContQty > rec.Quantity then
                                Error(StrSubstNo(txtErrContainerAssignedNoEdit, Rec."No.", Rec."Document No.", Format(SumContQty), Format(Rec.Quantity)));
                        end;

                        //mbr 2/24/25 - end



                    end;
                end;
            end;


        }

        modify("Expected Receipt Date")
        {
            trigger OnBeforeValidate()
            begin
                GetDt := Rec."Planned Receipt Date";
            end;

            trigger OnAfterValidate()
            begin
                If "Planned Receipt Date" <> GetDt then
                    "Planned Receipt Date" := GetDt;
            end;
        }
        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                PurchHeader: Record "Purchase Header";
            begin
                if rec."Location Code" <> xRec."Location Code" then begin
                    PurchHeader.SetRange("No.", rec."Document No.");
                    PurchHeader.SetRange("Document Type", rec."Document Type");
                    if (PurchHeader.FindSet()) then begin
                        PurchHeader."Location Code" := rec."Location Code";
                        PurchHeader.Modify();
                    end;
                end;
            end;

        }

        field(50001; DoNotShipBeforeDate; Date)
        {
            Caption = 'Do Not Ship Before Date';
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header"."DoNotShipBeforeDate" WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(50002; RequestedCargoReadyDate; Date)
        {
            Caption = 'Requested Cargo Ready Date';
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header"."RequestedCargoReadyDate" WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(50003; RequestedInWhseDate; Date)
        {
            Caption = 'Requested In Whse Date';
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header"."RequestedInWhseDate" WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(50005; "Port Of Loading"; Code[20])
        {
            Caption = 'Port of Loading';
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header"."Port of Loading" WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
            TableRelation = "Port of Loading".Port;


        }
        field(50006; "Assigned User ID"; Code[50])
        {
            Caption = 'Owner';
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header"."Assigned User ID" WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
            TableRelation = "User Setup";

        }
        field(50007; DeliveryNotes; text[255])
        {
            Caption = 'Delivery Notes';
        }
        field(50011; "M-Pack Qty"; Decimal)
        {
            Caption = 'M-Pack Qty';
            FieldClass = FlowField;
            DecimalPlaces = 0;
            CalcFormula = lookup("Item Unit of Measure"."Qty. per Unit of Measure" WHERE("Item No." = field("No."), Code = CONST('M-PACK')));
        }
        field(50012; "M-Pack Weight"; Decimal)
        {
            Caption = 'M-Pack Weight (lbs)';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure"."Weight" WHERE("Item No." = field("No."), Code = CONST('M-PACK')));
        }
        field(50013; "M-Pack Weight kg"; Decimal)
        {
            Caption = 'M-Pack Weight (kg)';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure"."Weight kgs" WHERE("Item No." = field("No."), Code = CONST('M-PACK')));
        }
        field(50014; "M-Pack Height"; Decimal)
        {
            Caption = 'M-Pack Height';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Height WHERE("Item No." = field("No."), Code = CONST('M-PACK')));
        }
        field(50015; "M-Pack Length"; Decimal)
        {
            Caption = 'M-Pack Length';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Length WHERE("Item No." = field("No."), Code = CONST('M-PACK')));
        }
        field(50016; "M-Pack Width"; Decimal)
        {
            Caption = 'M-Pack width';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Width WHERE("Item No." = field("No."), Code = CONST('M-PACK')));
        }
        field(50017; "Vendor No."; Code[20])
        {
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header"."Buy-from Vendor No." WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
            TableRelation = Vendor."No.";

        }
        field(50018; "Port Of Discharge"; Code[20])
        {
            Caption = 'Port of Discharge';
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header"."Port of Discharge" WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
            TableRelation = "Port of Loading".Port;

        }
        field(50019; "Forwarder"; Code[10])
        {
            Caption = 'Forwarder';
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header".Forwarder WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
            TableRelation = "Shipping Agent".Code;

        }
        field(50020; "AssignedToContainer"; boolean)
        {
            Caption = 'Assigned to Container';

        }
        field(50021; ActualCargoReadyDate; Date)
        {
            Caption = 'Actual Cargo Ready Date';
            trigger OnValidate()
            var
                item: Record Item;
            begin
                if (Rec.Type = Rec.Type::Item) and (ActualCargoReadyDate <> 0D) then begin
                    if item.get("No.") then begin
                        if FORMAT(item."Lead Time Calculation") <> '' then
                            Validate(EstimatedInWarehouseDate, CalcDate(item."Lead Time Calculation", ActualCargoReadyDate));
                    end;

                end;
                GetCRDDif();  //7/7/25 - update the CRD Diff

            end;

        }
        field(50022; EstimatedInWarehouseDate; Date)
        {
            Caption = 'Estimated In-Warehouse Date';
            trigger OnValidate()
            begin
                //mbr 9/13/24 - update Expected Receipt Date if EstimatedInWarehouseDate <> 0D
                if (rec.EstimatedInWarehouseDate <> xrec.EstimatedInWarehouseDate) and (rec.EstimatedInWarehouseDate <> 0D) then begin
                    "Expected Receipt Date" := rec.EstimatedInWarehouseDate;
                    CalcEarliestDifDate;  //7/7/25 - update the Days Diff
                end;

                //mbr 9/13/24 - end
            end;
        }
        field(50023; "Container No."; Code[50])
        {
            Caption = 'Container No.';
            TableRelation = "Container Header";
            Editable = false;
        }
        field(50024; Status; Enum "Purchase Document Status")
        {
            Caption = 'Status';
            Editable = false;
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header".Status WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));

        }
        field(50025; "Qty to Assign to Container"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Qty to Assign to Container';

        }
        field(50026; "Qty Assigned to Container"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Qty Assigned to Container';
            Editable = false;

        }
        field(50027; POFinalizeDate; Date)
        {
            Caption = 'PO Finalized Date';
            Editable = true;
        }
        field(50028; "Production Status"; Option)
        {
            Caption = 'Production Status';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Waiting for factory to send print confirmation,Waiting for license approval,Waiting for design team approval,Deposit pending approval,Balance payment pending approval,Waiting for test report (DO NOT USE),Waiting for new mold ready ,Waiting for factory to confirm CRD,Finalizing product spec,Pre-production sample pending approval  ,Post-production sample pending approval,Approved for production,Waiting for factory to book shipment,Shipment booked,Waiting for forwarder to release vessel info,Shipped,Waiting for Artwork,PO on Hold,Waiting for component from US,Shipped - waiting for payment to release FCR,Waiting for factory provide pre-production samples,Waiting for pre-production test report,Waiting for post-production test report';
            OptionMembers = " ","Waiting for factory to send print confirmation","Waiting for license approval","Waiting for design team approval","Deposit pending approval","Balance payment pending approval","Waiting for test report (DO NOT USE)","Waiting for new mold ready ","Waiting for factory to confirm CRD","Finalizing product spec","Pre-production sample pending approval  ","Post-production sample pending approval","Approved for production","Waiting for factory to book shipment","Shipment booked","Waiting for forwarder to release vessel info","Shipped","Waiting for Artwork","PO on Hold","Waiting for component from US","Shipped - waiting for payment to release FCR","Waiting for factory provide pre-production samples","Waiting for pre-production test report","Waiting for post-production test report";
        }
        field(50029; ItemType; Enum "Item Type")
        {
            Caption = 'Item Type';
            FieldClass = FlowField;

            CalcFormula = lookup(Item.Type WHERE("No." = field("No.")));

        }
        field(50030; bUpdate; Boolean)
        {

        }
        field(50031; CreatedUserID; Code[20])
        {
            Caption = 'Created By';
            Editable = false;
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header".CreatedUserID WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(50032; CreatedDate; Date)
        {
            Caption = 'Created Date';
            Editable = false;
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header".CreatedDate WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(50033; "Customer Responsibility Center"; Code[10])
        {
            Caption = 'Customer Responsibility Center';
            TableRelation = "Responsibility Center";
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Responsibility Center" WHERE("No." = field("Shortcut Dimension 1 Code")));
        }
        field(50034; "Item Purchasing Code"; code[10])
        {
            FieldClass = FlowField;

            CalcFormula = lookup(Item."Purchasing Code" WHERE("No." = field("No.")));
        }
        field(50035; "Manufacturer Code"; code[20])
        {
            Caption = 'Preferred 3PL Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Manufacturer Code" where("No." = field("No.")));

        }
        //PR 3/31/25 - start
        field(50036; "Incoterm"; Option)
        {
            Caption = 'Incoterm';
            OptionCaption = ' ,CIF,DDP,EXW,FOB';
            OptionMembers = " ","CIF","DDP","EXW","FOB";
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".Incoterm WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
        }

        //PR 3/31/25 - end

        //pr 5/1/25 - start
        field(50037; "Expected Expiration Date"; Date)
        {

        }
        //pr 5/1/25 - end
        //pr 5/5/25 - start
        field(50038; "Salesperson"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Salesperson Code" WHERE("No." = field("Shortcut Dimension 1 Code")));

        }
        //pr 5/5/25 - end

        //pr 6/3/25 - start
        field(50039; "CRD Differences"; Integer)
        {
        }
        //pr 6/3/25 - end
        field(50040; "New Item"; Boolean)
        {
            Editable = false;
        }
        //mbr 6/20/25 - start
        field(50041; "Qty. on Sales Order"; Decimal)
        {
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                            Type = const(Item),
                                                                            "No." = field("No."),
                                                                            "Unit of Measure Code" = field("Unit of Measure Code")));
            Caption = 'Qty. on Sales Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50042; "Earliest Start Ship Date"; Date)
        {
            Caption = 'Earliest Start Ship Date';
            Editable = false;
            trigger OnValidate()
            begin
                CalcEarliestDifDate();
            end;
        }
        //mbr 6/20/25 - end

        //PR 7/1/25 - start
        field(50043; "Days differences earliest"; Integer)
        {
            Caption = 'Shipment Arrival Analysis (Days)';
            ToolTip = 'If there is QTY on Sales Order, Shipment arrival days = Earliest Start Ship Date – Estimated in Whs Date.  If there is no QTY on Sales Order, Shipment arrival days = Request in Whs Date – Estimated in Whs Date';
        }
        field(50044; "Initial ETD"; Date)
        {
            Caption = 'Initial Departure';
            Editable = false;
        }
        field(50045; "Initial ETA"; Date)
        {
            Caption = 'Initial Arrival';
            Editable = false;
        }
        //pr 7/1/25 - end
        field(50046; "Real Time Item Description"; Text[100])
        {
            Caption = 'Real Time Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description WHERE("No." = field("No.")));
        }

    }

    var
        TxtVendorNoPrice: Label 'No Price found for %1. Override?';
        TxtVendorMinQtyErr: Label 'Min. Quantity not met or no Price Found for %1.  Proceed?';
        UOM: Record "Unit of Measure";
        GetDt: Date;
        delFromHeader: Boolean;
        errorNoQtyToAssgnLessThanOutstanding: Label 'Assign to container is less than Outsanding Qty-assigned.';
        errorNoQtyToAssgnToLarge: Label 'Make sure Qty Assigned to Container does not exceed Oustanding Qty.';
        errorDeletionQtyReceivedExists: Label 'You CANNOT delete Purchase Order line when Quantity Received > 0.';
        TxtTaskAborted: Label 'Task Aborted!';
        bExit: Boolean;
        txtNotAllowed: Label 'User %1 is NOT allowed to override %2.';

        txtErrContainerAssigned: Label 'Item No. %1 for PO %2 has been assigned to Container %3.  You cannot DELETE.  Please delete from Container first.';
        txtErrContainerAssignedNoEdit: Label 'Item No. %1 for PO %2 has been assigned to container(s).  Total Qty from Container(s):%3 > PO Line Quantity: %4.  You cannot EDIT quantity.';
        GenCU: Codeunit GeneralCU;

    procedure GetDimensionM() ReturnValue: Decimal
    var
        result: Decimal;
        ItemRef: Record "Item Reference";
    begin
        if Rec.Type = Rec.Type::Item then begin
            ItemRef.Reset();
            ItemRef.SetRange("Reference Type No.", Rec."Buy-from Vendor No.");
            ItemRef.SetRange("Reference Type", ItemRef."Reference Type"::Vendor);
            ItemRef.SetRange("Item No.", Rec."No.");
            if ItemRef.FindFirst() then begin
                UOM.Reset();
                if UOM.get('M') then;
                if UOM."Convert Up Unit" > 0 then begin
                    result := (ItemRef.Cubage) * UOM."Convert Up Unit" * UOM."Convert Up Unit" * UOM."Convert Up Unit";
                end;

            end
            else begin
                UOM.Reset();
                if UOM.get('M') then;
                if UOM."Convert Up Unit" > 0 then begin
                    Rec.CalcFields("M-Pack Height", "M-Pack Length", "M-Pack Width");
                    result := (Rec."M-Pack Length" * Rec."M-Pack Height" * Rec."M-Pack Width") * UOM."Convert Up Unit" * UOM."Convert Up Unit" * UOM."Convert Up Unit";
                end;

            end;
            ReturnValue := result;
            //  ReturnValue := ROUND(result, 0.001, '=');
        end;


    end;

    procedure CheckEarliestShipDate()
    var
        purchHeader: Record "Purchase Header";
    begin
        if (rec."Earliest Start Ship Date" = 0D) then begin
            purchHeader.Reset();
            purchHeader.SetRange("No.", rec."Document No.");
            purchHeader.SetRange("Document Type", rec."Document Type");
            if purchHeader.FindFirst() then begin
                rec.Validate("Earliest Start Ship Date", purchHeader.RequestedInWhseDate);
                rec.Modify();
            end;
        end;
    end;

    procedure CalcEarliestDifDate()
    begin
        rec.CalcFields(RequestedInWhseDate);
        if (rec."Earliest Start Ship Date" <> 0D) and (rec.EstimatedInWarehouseDate <> 0D) then begin
            rec."Days differences earliest" := rec."Earliest Start Ship Date" - rec.EstimatedInWarehouseDate;
        end
        else if (rec."Earliest Start Ship Date" = 0D) and (rec.EstimatedInWarehouseDate <> 0D) and (rec.RequestedInWhseDate <> 0D) then begin
            rec."Days differences earliest" := rec.RequestedInWhseDate - rec.EstimatedInWarehouseDate;
        end
        else
            rec."Days differences earliest" := 0;
        // if (rec.Find('-')) then
        //    rec.Modify();
    end;

    procedure GetPackageCount() ReturnValue: decimal
    var
        result: Decimal;
    begin
        CalcFields("M-Pack Qty");
        If "M-Pack Qty" > 0 then
            result := Quantity / "M-Pack Qty";
        ReturnValue := result;
    end;

    procedure GetOutstandingPackageCount() ReturnValue: decimal
    var
        result: Decimal;
    begin
        CalcFields("M-Pack Qty");
        If "M-Pack Qty" > 0 then
            result := "Outstanding Quantity" / "M-Pack Qty";
        ReturnValue := Round(result, 1, '=');
    end;

    procedure GetCRDDif() ReturnValue: Integer
    begin
        if (rec.ActualCargoReadyDate <> 0D) and (rec.RequestedCargoReadyDate <> 0D) then
            if (rec.RequestedCargoReadyDate < rec.ActualCargoReadyDate) then
                Rec."CRD Differences" := abs(Rec.ActualCargoReadyDate - Rec.RequestedCargoReadyDate)
            else
                Rec."CRD Differences" := abs(Rec.RequestedCargoReadyDate - Rec.ActualCargoReadyDate)
        else
            Rec."CRD Differences" := 0;
        // if (rec.FindSet()) then
        //rec.Modify();
    end;

    procedure SetDelFromHeader(val: Boolean)
    begin
        delFromHeader := val;
    end;

    //mbr 8/2/24 - error proof onBeforedelete => if quantity received > 0, then DO NOT allow deletion of PO Lines
    trigger OnBeforeDelete()
    var
        containerline: Record ContainerLine;
    begin
        if delFromHeader = false then begin
            if (rec."Document Type" = rec."Document Type"::Order) and (rec.Type = rec.Type::Item) then begin
                if Rec."Quantity Received" > 0 then
                    Error(errorDeletionQtyReceivedExists);
            end;
        end;

        //mbr 2/24/25 - start
        //when users delete a PO line, check if this PO line was assigned to any container order.  If so, user would need to delete PO line from container before deleting the PO Line.
        if (rec."Document Type" = rec."Document Type"::Order) and (rec.Type = rec.Type::Item) then begin
            containerline.Reset();
            containerline.SetRange(SourceNo, Database::"Purchase Line");
            containerline.SetRange("Document No.", Rec."Document No.");
            containerline.SetRange("Document Line No.", Rec."Line No.");
            containerline.SetRange("Item No.", Rec."No.");
            if containerline.FindFirst() then
                Error(StrSubstNo(txtErrContainerAssigned, Rec."No.", Rec."Document No.", containerline."Container No."));
        end;
        //mbr 2/24/25 - end


    end;

    procedure UpdateNewItem()
    var
        itemledgerentry: Record "Item Ledger Entry";
        item: Record Item;
    begin

        if rec.Type = rec.Type::Item then begin
            item.Reset();
            item.SetRange("No.", rec."No.");
            item.SetRange(Type, item.Type::Inventory);
            if item.FindFirst() then begin
                itemledgerentry.reset();
                itemledgerentry.SetCurrentKey("Entry Type", "Item No.");
                itemledgerentry.SetFilter("Entry Type", '%1|%2|%3', itemledgerentry."Entry Type"::"Positive Adjmt.", itemledgerentry."Entry Type"::Purchase, itemledgerentry."Entry Type"::"Assembly Output");

                itemledgerentry.setrange("Item No.", rec."No.");

                if itemledgerentry.findset() then
                    rec."New Item" := false
                else
                    rec."New Item" := true;

            end;

        end;

    end;

    //7/3/25 - create CalcInitETAnETD to calculate the Initial ETA/ETD
    procedure CalcInitETAnETD()
    var

        ContainLine: Record ContainerLine;
        ConainerHdr: Record "Container Header";
        PostedContainerHdr: Record "Posted Container Header";
        PostedContainLine: Record "Posted Container Line";
    begin

        // resets rec
        rec."Initial ETA" := 0D;
        rec."Initial ETD" := 0D;
        // finds all the container lines
        ContainLine.Reset();
        ContainLine.SetRange("Item No.", rec."No.");
        ContainLine.SetRange("Document No.", rec."Document No.");
        ContainLine.SetRange("Document Line No.", rec."Line No.");
        if (StrLen(rec."Container No.") > 0) then
            ContainLine.SetRange("Container No.", rec."Container No.");
        if (ContainLine.FindFirst()) then begin
            ConainerHdr.Reset();
            ConainerHdr.SetRange("Container No.", ContainLine."Container No.");
            if (ConainerHdr.FindFirst()) then begin
                rec."Initial ETA" := ConainerHdr.ETA;
                rec."Initial ETD" := ConainerHdr.ETD;

            end
        end
        else begin
            // finds all the posted container lines
            PostedContainLine.Reset();
            PostedContainLine.SetRange("Item No.", rec."No.");
            PostedContainLine.SetRange("Document No.", rec."Document No.");
            PostedContainLine.SetRange("Document Line No.", Rec."Line No.");
            if (StrLen(rec."Container No.") > 0) then
                PostedContainLine.SetRange("Container No.", rec."Container No.");
            if (PostedContainLine.FindFirst()) then begin
                PostedContainerHdr.Reset();
                PostedContainerHdr.SetRange("Container No.", PostedContainLine."Container No.");
                if (PostedContainerHdr.FindFirst()) then begin
                    rec."Initial ETA" := PostedContainerHdr.ETA;
                    rec."Initial ETD" := PostedContainerHdr.ETD;
                end
            end
        end;
        rec.Modify();

    end;



    trigger OnBeforeInsert()
    begin
        delFromHeader := false;
    end;

    trigger OnInsert()
    begin
        GenCU.UpdateEarliestStartShipDatePurch(Rec);
    end;

    trigger OnModify()
    begin
        GenCU.UpdateEarliestStartShipDatePurch(Rec);
    end;



}
