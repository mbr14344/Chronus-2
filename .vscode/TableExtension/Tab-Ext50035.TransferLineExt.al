tableextension 50035 TransferLineExt extends "Transfer Line"
{

    fields
    {
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                TransferHeader: Record "Transfer Header";
            begin
                //mbr 2/19/25 - start
                //If users changes the value of item no in Transfer Line, Check if there’s a container no assigned to header, if yes DO NOT ALLOW changing of item no
                if (rec."Item No." <> xRec."Item No.") and (xRec."Item No." <> '') then begin
                    TransferHeader.Reset();
                    TransferHeader.SetRange("No.", rec."Document No.");
                    TransferHeader.SetFilter("Container No.", '<>%1', '');
                    if TransferHeader.FindFirst() then
                        ERROR(txtErrItemNoChange, xrec."Item No.", TransferHeader."Container No.", rec."Document No.");
                end;
            end;
        }
        modify("Document No.")
        {
            TableRelation = "Transfer Header"."No.";
        }
        modify("Outstanding Qty. (Base)")
        {
            Caption = 'Qty. (Base) to Ship';
        }
        modify("Outstanding Quantity")
        {
            Caption = 'Qty. to Ship';
        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                containerline: Record ContainerLine;
                containerHeader: Record "Container Header";
                transferHeader: Record "Transfer Header";
                purchaseHeader: Record "Purchase Header";
                unitOfMeasure: Record "Item Unit of Measure";
                item: Record Item;
                txtNoContainerFoundErr: Label 'No corresponding container line found for Item %1 qty %2';
                bFound: Boolean;
            begin
                //pr 2/5/25 - start
                //Modify Container Lines if applicable
                if Rec.Quantity <> xRec.Quantity then begin
                    transferHeader.Reset();
                    transferHeader.SetRange("No.", Rec."Document No.");
                    transferHeader.SetFilter("Container No.", '<>%1', '');
                    bFound := false;
                    if (transferHeader.FindFirst()) then begin
                        //  if transfer order is filled without having any cointainer lines
                        containerline.reset;
                        containerline.SetCurrentKey("Container No.", SourceNo, "Document No.", "Document Line No.", "Item No.");
                        containerline.setrange("Container No.", transferHeader."Container No.");
                        containerline.SetRange("Item No.", rec."Item No.");
                        containerline.SetRange(Quantity, xrec.Quantity);

                        if containerline.findset() then
                            repeat
                                if containerline.SourceNo = Database::"Purchase Line" then begin
                                    If containerline."Document No." = rec."Source Document No." then begin
                                        bFound := true;
                                        containerline.Quantity := Rec.Quantity;
                                        containerline."Quantity Base" := Rec."Quantity (Base)";
                                        containerline.Modify(false);
                                    end;

                                end
                                else begin
                                    if containerline.SourceNo = Database::"Transfer Line" then begin
                                        if containerline."Document No." = rec."Document No." then begin
                                            bFound := true;
                                            containerline.Quantity := Rec.Quantity;
                                            containerline."Quantity Base" := Rec."Quantity (Base)";
                                            containerline.Modify(false);
                                        end;
                                    end;
                                end;

                            until (containerline.Next() = 0) or (bFound = true)
                        else begin
                            Error(txtNoContainerFoundErr, rec."Item No.", xRec.Quantity);
                        end;
                    end;
                end;
                //pr 2/5/25 - end

            end;

        }
        field(50000; "Telex Released"; Boolean)
        {
            Caption = 'Telex Released';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                TH: Record "Transfer Header";
                TL: Record "Transfer Line";
                bEnable: Boolean;
            begin
                if "Telex Released" = true then begin
                    bEnable := True;
                    TL.Reset();
                    TL.SetRange("Document No.", "Document No.");
                    TL.SetFilter("Line No.", '<>%1', Rec."Line No.");
                    TL.SETRANGE("Derived From Line No.", 0);
                    TL.SetRange("Telex Released", false);
                    IF TL.FindSet() then
                        bEnable := False;

                    if bEnable = true then begin
                        if TH.GET("Document No.") then begin
                            TH."Telex Released" := true;
                            TH.Modify();
                        end;

                    end;

                end
                else begin
                    if TH.GET("Document No.") then begin
                        TH."Telex Released" := false;
                        TH.Modify();
                    end;
                end;
                "Telex Updated By" := UserId;
                "Telex Updated Date" := Today;

            end;
        }
        field(50001; "Telex Updated By"; Code[50])
        {
            Editable = false;
        }
        field(50002; "Telex Updated Date"; Date)
        {
            Editable = false;
        }
        // pr 6/4/24 added fields to add to transer lines page
        field(50003; "Container No."; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Header"."Container No." Where("No." = field("Document No.")));
            Editable = true;
            //TableRelation = "Container Header";
        }

        field(50005; "Lot No."; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Reservation Entry"."Lot No." where("Source ID" = field("Document No."),
                                                                "Source Type" = const(Database::"Transfer Line"),
                                                                "Item No." = field("Item No.")));
            Editable = false;
        }
        field(50006; "Exp Date"; date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Reservation Entry"."Expiration Date" where("Source ID" = field("Document No."),
                                                                "Source Type" = const(Database::"Transfer Line"),
                                                                "Item No." = field("Item No.")));
            Editable = false;

        }
        field(50007; Ti; Integer)
        {
            Caption = 'Ti';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Ti WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(50008; Hi; Integer)
        {
            Caption = 'Hi';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Hi WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(50009; "M-Pack Qty"; Decimal)
        {
            Caption = 'M-Pack Qty';
            FieldClass = FlowField;
            DecimalPlaces = 0;
            CalcFormula = lookup("Item Unit of Measure"."Qty. per Unit of Measure" WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(50010; "Container Size"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Container Size" WHERE("Container No." = field("Container No.")));
            Editable = false;
        }

        field(50011; ETD; Date)
        {
            Caption = 'Initial Departure';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".ETD WHERE("Container No." = field("Container No.")));
            Editable = false;
        }
        field(50012; ETA; Date)
        {
            Caption = 'Initial Arrival';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".ETA WHERE("Container No." = field("Container No.")));
            Editable = false;
        }

        field(50013; "Actual ETD"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".ActualETD WHERE("Container No." = field("Container No.")));
            Editable = false;

        }
        field(50004; "Actual ETA"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".ActualETA WHERE("Container No." = field("Container No.")));
            Editable = false;
        }
        field(50014; Urgent; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Header".Urgent Where("No." = field("Document No.")));
            Editable = false;
        }
        field(50015; "Source Document No."; Code[20])
        {
            Caption = 'Source Document No.';
            Editable = False;
        }
        field(50016; "Port of Loading"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Port of Loading" WHERE("Container No." = field("Container No.")));
            Editable = false;
        }
        field(50017; "Port of Discharge"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Port of Discharge" WHERE("Container No." = field("Container No.")));
            Editable = false;
        }
        field(50025; "UPC"; code[20])
        {
            Caption = 'UPC';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.GTIN where("No." = field("Item No.")));

        }
        field(50026; "PO No."; code[20])
        {
            Caption = 'PO No.';
            Editable = true;

            trigger OnValidate()
            var
                ArchPurchaseHeader: Record "Purchase Header Archive";
                containerline: Record ContainerLine;
                ArchPurchaseLine: Record "Purchase Line Archive";
                transferHeader: Record "Transfer Header";
            begin
                if StrLen(Rec."PO No.") > 0 then begin
                    ArchPurchaseHeader.Reset();
                    ArchPurchaseHeader.SetCurrentKey("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
                    ArchPurchaseHeader.SetRange("Document Type", ArchPurchaseHeader."Document Type"::Order);
                    ArchPurchaseHeader.SetRange("No.", Rec."PO No.");
                    ArchPurchaseHeader.Ascending(false);
                    if ArchPurchaseHeader.FindFirst() then begin
                        Rec."PO Owner" := ArchPurchaseHeader.CreatedUserID;
                        rec."PO Vendor" := ArchPurchaseHeader."Buy-from Vendor No.";

                        //mbr 7/23/25 - update the corresponding container line Description Snapshot
                        ArchPurchaseLine.Reset();
                        ArchPurchaseLine.SetRange("Document Type", ArchPurchaseLine."Document Type"::Order);
                        ArchPurchaseLine.SetRange("Document No.", Rec."PO No.");
                        ArchPurchaseLine.SetRange(Type, ArchPurchaseLine.Type::Item);
                        ArchPurchaseLine.SetRange("No.", Rec."Item No.");
                        ArchPurchaseLine.SetRange("Doc. No. Occurrence", ArchPurchaseHeader."Doc. No. Occurrence");
                        ArchPurchaseLine.SetRange("Version No.", ArchPurchaseHeader."Version No.");
                        if ArchPurchaseLine.FindFirst() then begin
                            transferHeader.SetRange("No.", "Document No.");
                            if transferHeader.FindFirst() then begin
                                containerline.SetCurrentKey("Container No.", SourceNo, "Document No.", "Document Line No.", "Item No.");
                                containerline.setrange("Container No.", transferHeader."Container No.");
                                containerline.SetRange(SourceNo, Database::"Transfer Line");
                                containerline.SetRange("Document No.", transferHeader."No.");
                                containerline.SetRange("Document Line No.", rec."Line No.");
                                containerline.SetRange("Item No.", rec."Item No.");
                                if containerline.FindFirst() then begin
                                    containerline."Item Description Snapshot" := ArchPurchaseLine.Description;
                                    containerline.modify();
                                end;
                            end;
                        end;
                        //mbr 7/23/25 - end of update - corresponding container line Description Snapshot
                    end;
                end;

            end;

        }
        field(50027; "PO Owner"; code[20])
        {
            Caption = 'PO Owner';
            Editable = false;

        }
        field(50028; "Purchasing Code"; code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Purchasing Code" where("No." = field("Item No.")));
        }
        field(50029; "LFD"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".LFD WHERE("Container No." = field("Container No.")));
            Editable = false;
        }
        field(50030; "Actual Pull Date"; Date)
        {
            FieldClass = FlowField;
            //CalcFormula = lookup("Transfer Header"."Actual Pull Date" Where("No." = field("Document No.")));
            // pr 12/11/24
            CalcFormula = lookup("Container Header"."Actual Pull Date" WHERE("Container No." = field("Container No.")));
            Editable = false;
        }
        field(50031; "Actual Pull Time"; Time)
        {
            FieldClass = FlowField;
            //CalcFormula = lookup("Transfer Header"."Actual Pull Time" Where("No." = field("Document No.")));
            // pr 12/11/24
            CalcFormula = lookup("Container Header"."Actual Pull Time" WHERE("Container No." = field("Container No.")));
            Editable = false;
        }
        field(50032; "Actual Delivery Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Actual Delivery Date" Where("Container No." = field("Container No.")));
            Editable = false;
        }
        field(50033; "Empty Notification Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Empty Notification Date" WHERE("Container No." = field("Container No.")));
            Editable = false;
        }
        field(50034; "Container Return Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Container Return Date" WHERE("Container No." = field("Container No.")));
            Editable = false;
        }
        // pr 12/16/24
        field(50035; "Pier Pass"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Header"."Pier Pass" Where("No." = field("Document No.")));
        }
        field(50036; Drayage; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".Drayage where("Container No." = field("Container No.")));
        }
        field(50037; Carrier; Code[50])
        {
            Caption = 'Carrier';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".Carrier where("Container No." = field("Container No.")));
        }
        field(50038; Terminal; Code[50])
        {
            Caption = 'Terminal';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".Terminal where("Container No." = field("Container No.")));

        }
        field(50039; Forwarder; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".Forwarder where("Container No." = field("Container No.")));

        }
        field(50040; "Freight Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Freight Cost" where("Container No." = field("Container No.")));

        }
        field(50041; "Freight Bill No."; Code[30])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Freight Bill No." where("Container No." = field("Container No.")));

        }
        field(50042; "Freight Bill Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Freight Bill Amount" where("Container No." = field("Container No.")));

        }
        field(50043; CreatedBy; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Header".CreatedBy Where("No." = field("Document No.")));
            Editable = false;
        }
        field(50044; "M-Pack Weight (kg)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure"."Weight kgs" WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
            Editable = false;
        }
        field(50045; "Container Status Notes"; Text[300])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Container Status Notes" Where("Container No." = field("Container No.")));
            Editable = false;
        }
        field(50046; "Receiving Status"; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Receiving Status" Where("Container No." = field("Container No.")));
        }
        field(50048; "M-Pack Height"; Decimal)
        {
            Caption = 'M-Pack Height';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Height WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(50049; "M-Pack Length"; Decimal)
        {
            Caption = 'M-Pack Length';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Length WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(50050; "M-Pack Width"; Decimal)
        {
            Caption = 'M-Pack width';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Width WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(50051; "ZDELCustCode"; code[20])
        {
            Caption = 'For Cust Code (Discontinued)';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
        field(50052; "Manufacturer Code"; code[20])
        {
            Caption = 'Preferred 3PL Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Manufacturer Code" where("No." = field("Item No.")));

        }
        field(50053; "Header Telex Released"; Boolean)
        {

            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Header"."Telex Released" Where("No." = field("Document No.")));
        }
        field(50054; POClosed; boolean)
        {
            Caption = 'PO Closed';
            Editable = false;
        }
        //PR 2/10/25 - start
        field(50055; "Expected Quantity"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 5;

        }
        field(50056; "Expected UOM"; code[20])
        {
            Editable = false;
        }
        field(50057; "Received Good"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
        field(50058; "Received Case"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Editable = false;

        }
        field(50060; "Received Pallet"; Integer)
        {
            Editable = false;
        }
        field(50061; "Received Damage"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
        field(50062; "Received Over"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
        field(50063; "Received Short"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
        field(50064; "Received Weight"; Decimal)
        {
            Editable = false;
        }
        //PR 2/10/25 - end
        //mbr 2/11/25 - start
        field(50065; "944 Receipt No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Header"."944 Receipt No." WHERE("No." = field("Document No.")));
        }
        //PR 2/13/25 - start
        field(50066; Hazard; Boolean)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Hazard where("No." = field("Item No.")));
        }
        //PR 2/13/25 - end
        //PR 2/14/25 - start
        Field(50067; "PO Vendor"; Code[20])
        {
            Editable = False;
        }
        //PR 2/14/25 - end
        field(50068; "Container Line No."; Integer)
        {
            Editable = false;
        }
        field(50069; "Real Time Item Description"; Text[100])
        {
            Caption = 'Real Time Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description WHERE("No." = field("Item No.")));
        }



    }

    // pr 12/26/24 - start 
    procedure GetDimensionM() ReturnValue: Decimal
    var
        result: Decimal;
        ItemRef: Record "Item Reference";
    begin
        // ReturnValue := containerLine.GetDimensionM();
        ItemRef.Reset();
        ItemRef.SetRange("Reference Type No.", Rec."PO Vendor");
        ItemRef.SetRange("Reference Type", ItemRef."Reference Type"::Vendor);
        ItemRef.SetRange("Item No.", Rec."Item No.");
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

    end;

    // pr 12/26/24 - end
    // pr 6/4/24 gives and error when deleting a tranfer line if it is matched with a transfer header with a "Container No." !=""
    trigger OnBeforeDelete()
    var
        transferHeader: Record "Transfer Header";
        containerLine: Record ContainerLine;
    begin

        transferHeader.SetRange("No.", "Document No.");
        if transferHeader.FindFirst() then begin
            if (StrLen(transferHeader."Container No.") > 0) then begin
                // pr 10/7/9 - show pop uo confrim when deleting line if yes it also deletes matching container lines - start
                Clear(popUpConfrim);
                popUpConfrim.setMessage(StrSubstNo(txtCofrimDelete, "Item No.",
                transferHeader."Container No."));
                Commit;
                if popUpConfrim.RunModal() = Action::yes then begin
                    containerLine.Reset();
                    containerLine.SetRange("Document No.", "Document No.");
                    containerLine.SetRange("Item No.", "Item No.");
                    containerLine.SetRange(Quantity, Quantity);
                    containerLine.SetRange("Container No.", transferHeader."Container No.");
                    if (containerLine.FindSet()) then
                        repeat
                            containerLine.Delete();
                        until containerLine.next = 0;
                end
                else begin
                    Error(StrSubstNo(txtErrTransDel, transferHeader."Container No."));
                end;
                // pr 10/7/9 - show pop uo confrim when deleting line if yes it also deletes matching container lines - end    
            end;

        end;

    end;

    var
        UOM: Record "Unit of Measure";
        reservationEntry: record "Reservation Entry";
        refType: code[50];
        txtErrTransDel: Label 'Sorry, you cannot delete transfer lines since the Transfer Order has an existing Container No. %1 assigned to it.';
        txtCofrimDelete: Label 'Item %1 is already associated with Container No. %2.  Do you still want to delete this transfer Line?';
        popUpConfrim: Page "Confirmation Dialog";
        txtErrItemNoChange: Label 'You cannot modify Item %1 since Container No. %2 is assigned to Transfer Order  No. %3';

    procedure GetPackageCount() ReturnValue: decimal
    var
        result: Decimal;
    begin
        CalcFields("M-Pack Qty");
        If "M-Pack Qty" > 0 then
            result := Quantity / "M-Pack Qty";
        ReturnValue := result;
    end;


    trigger OnInsert()
    begin

    end;

    trigger OnAfterInsert()
    var
        containerline: Record ContainerLine;
        containerHeader: Record "Container Header";
        transferHeader: Record "Transfer Header";
        purchaseHeader: Record "Purchase Header";
        unitOfMeasure: Record "Item Unit of Measure";
        item: Record Item;
        getPOLine: Record "Purchase Line";
        getPurArchHeader: Record "Purchase Header Archive";
        getPurArchLine: Record "Purchase Line Archive";

    begin
        //check to see if container no is filled in.  only run below code if there's a container no.
        //Copy Transfer lines into Container Lines
        If Rec."Derived From Line No." = 0 then begin
            transferHeader.Reset();
            transferHeader.SetRange("No.", Rec."Document No.");
            transferHeader.SetFilter("Container No.", '<>%1', '');
            if (transferHeader.FindFirst()) then begin
                //  if transfer order is filled without having any cointainer lines
                containerline.reset;
                containerline.SetCurrentKey("Container No.", SourceNo, "Document No.", "Document Line No.", "Item No.");
                containerline.setrange("Container No.", transferHeader."Container No.");
                containerline.SetRange(SourceNo, Database::"Transfer Line");
                containerline.SetRange("Document No.", transferHeader."No.");
                containerline.SetRange("Document Line No.", rec."Line No.");
                containerline.SetRange("Item No.", rec."Item No.");
                if not containerline.findfirst then begin
                    containerline.Init();
                    // adds fieds direclty from transfer line to container line
                    containerline."Container No." := transferHeader."Container No.";
                    containerline."Document No." := Rec."Document No.";
                    containerline."Document Line No." := Rec."Line No.";
                    containerline.VALIDATE("Item No.", Rec."Item No.");
                    containerline.Quantity := Rec.Quantity;
                    containerline."Unit of Measure Code" := Rec."Unit of Measure Code";
                    containerline."Quantity Base" := Rec."Quantity (Base)";
                    containerline."Document Line No." := Rec."Line No.";
                    containerline."Location Code" := Rec."Transfer-from Code";
                    containerline."Port of Discharge" := transferHeader."Port of Discharge";
                    containerline."Port of Loading" := transferHeader."Port of Loading";
                    containerline.SourceNo := Database::"Transfer Line";

                    GetPOLine.Reset();
                    GetPOLine.SetRange("Document Type", GetPOLine."Document Type"::Order);
                    GetPOLine.SetRange("Document No.", Rec."PO No.");
                    GetPOLine.SetRange(Type, GetPOLine.Type::Item);
                    GetPOLine.SetRange("No.", Rec."Item No.");
                    IF GetPOLine.FindFirst() THEN BEGIN
                        ContainerLine."Item Description Snapshot" := GetPOLine.Description;
                    END
                    else begin
                        getPurArchHeader.Reset();
                        getPurArchHeader.SetRange("Document Type", getPurArchHeader."Document Type"::Order);
                        getPurArchHeader.SetRange("No.", Rec."PO No.");
                        getPurArchHeader.SetCurrentKey("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
                        getPurArchHeader.Ascending(false);
                        if getPurArchHeader.FindFirst() then begin
                            getPurArchLine.Reset();
                            getPurArchLine.SetRange("Document Type", getPurArchLine."Document Type"::Order);
                            getPurArchLine.SetRange("Document No.", Rec."PO No.");
                            getPurArchLine.SetRange(Type, getPurArchLine.Type::Item);
                            getPurArchLine.SetRange("No.", Rec."Item No.");
                            getPurArchLine.SetRange("Doc. No. Occurrence", getPurArchHeader."Doc. No. Occurrence");
                            getPurArchLine.SetRange("Version No.", getPurArchHeader."Version No.");
                            if getPurArchLine.FindFirst() then begin
                                ContainerLine."Item Description Snapshot" := getPurArchLine.Description;
                            end;

                        end;

                    end;
                    containerline.Insert();
                end;

            end;
        end;

        rec.Validate("Telex Released", false);
    end;
    //mbr - 2/19/25 - start
    trigger OnDelete()
    var
        TransferHeader: Record "Transfer Header";
        ContainerLine: Record ContainerLine;
    begin
        //mbr 2/19/25 - start
        //Check if there’s a container no assigned to header, if yes Delete from container line if applicable;
        TransferHeader.Reset();
        TransferHeader.SetRange("No.", rec."Document No.");
        TransferHeader.SetFilter("Container No.", '<>%1', '');
        if TransferHeader.FindFirst() then begin
            if strlen(rec."Source Document No.") > 0 then begin
                ContainerLine.Reset();
                ContainerLine.SetRange("Container No.", Rec."Container No.");
                ContainerLine.SetRange("Document No.", Rec."Source Document No.");
                ContainerLine.SetRange(SourceNo, Database::"Purchase Line");
                ContainerLine.SetRange("Document Line No.", rec."Container Line No.");
                ContainerLine.SetRange("Item No.", rec."Item No.");
                if ContainerLine.FindFirst() then
                    ContainerLine.Delete();

            end
            else begin
                ContainerLine.Reset();
                ContainerLine.SetRange("Container No.", Rec."Container No.");
                ContainerLine.SetRange("Document No.", Rec."Document No.");
                ContainerLine.SetRange(SourceNo, Database::"Transfer Line");
                ContainerLine.SetRange("Document Line No.", rec."Line No.");
                ContainerLine.SetRange("Item No.", rec."Item No.");
                if ContainerLine.FindFirst() then
                    ContainerLine.Delete();
            end;
        end;
    end;
    //mbr 2/19/25 - end
}
