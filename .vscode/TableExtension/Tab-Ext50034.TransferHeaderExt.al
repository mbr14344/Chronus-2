tableextension 50034 "Transfer HeaderExt" extends "Transfer Header"
{
    fields
    {
        field(50000; "Telex Released"; Boolean)
        {
            Caption = 'Telex Released';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if rec."Telex Released" <> xRec."Telex Released" then
                    Error(txtNotAllowed);
            end;
        }
        field(50001; "Container No."; Code[50])
        {
            Caption = 'Container No.';
            DataClassification = ToBeClassified;
            TableRelation = "Container Header"."Container No.";
            trigger OnValidate()
            var
                transferLn: Record "Transfer Line";
                containerhdr: Record "Container Header";
                containerln: Record ContainerLine;
                ResEntry: Record "Reservation Entry";
            begin
                if rec."Container No." <> xrec."Container No." then begin


                    If strlen("Container No.") = 0 then begin
                        transferLn.Reset();
                        transferLn.SetRange("Document No.", "No.");
                        transferLn.SetFilter("Quantity Shipped", '>%1', 0);
                        If transferLn.FindFirst() then
                            ERROR(TxtQtyShippedTO);

                        //if transferline has reservation entries, error out
                        transferLn.Reset();
                        transferLn.SetRange("Document No.", "No.");
                        If transferLn.FindSet() then
                            repeat
                                ResEntry.Reset();
                                ResEntry.SetRange("Item No.", transferLn."Item No.");
                                ResEntry.SetRange("Source Type", Database::"Transfer Line");
                                ResEntry.SetRange("Source ID", Rec."No.");
                                If ResEntry.FindSet() then begin
                                    ResEntry.DeleteAll();
                                    Message(TxtItemTrackingExists, transferLn."Item No.");
                                end;

                            until transferLn.Next() = 0;


                        Clear(popupConfirm);
                        popupConfirm.setMessage(StrSubstNo(txtConfirmContUnassign, "Container No.", "No."));
                        Commit;
                        if popupConfirm.RunModal() = Action::Yes then begin
                            transferLn.Reset();
                            transferLn.SetRange("Document No.", "No.");
                            If transferLn.FindSet() then
                                repeat
                                    transferLn.Delete();
                                until transferLn.Next() = 0;

                            "Port of Discharge" := '';
                            "Port of Loading" := '';

                            // pr 8/8/24 removes transfer order from container order if container no changed for transfer order - START
                            containerhdr.Reset();
                            containerhdr.SetRange("Transfer Order No.", rec."No.");
                            containerhdr.SetRange(Status, containerhdr.Status::Assigned);
                            if (containerhdr.FindSet()) then
                                repeat
                                    containerln.Reset();
                                    containerln.SetRange("Container No.", containerhdr."Container No.");
                                    containerln.SetRange("Document No.", rec."No.");
                                    if (containerln.FindSet()) then
                                        repeat
                                            containerln.Delete();
                                        until containerln.Next() = 0;
                                    containerhdr."Transfer Order No." := '';
                                    containerhdr.Status := containerhdr.Status::Open;
                                    containerhdr.Modify;
                                until containerhdr.Next() = 0
                            // pr 8/8/24 removes transfer order from container order if container no changed for transfer order - END
                        end
                        else
                            Error(txtTaskAborted);
                    end;
                end;
            end;
        }
        field(50002; ETD; Date)
        {
            Caption = 'Initial Departure';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".ETD where("Container No." = field("Container No.")));
        }
        field(50003; ETA; Date)
        {
            Caption = 'Initial Arrival';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".ETA where("Container No." = field("Container No.")));

        }
        field(50004; ContainerSize; Code[20])
        {
            Caption = 'Container Size';
            TableRelation = "Container Size".Code;
        }
        field(50005; CreatedBy; Code[50])
        {
            TableRelation = User."User Name";
            Caption = 'Created By';
            Editable = false;
        }
        field(50006; CreatedDate; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(50007; ModifiedBy; Code[50])
        {
            Caption = 'Modified By';
            TableRelation = User."User Name";
            Editable = false;
        }
        field(50008; ModifiedDate; Date)
        {
            Caption = 'Modified Date';
            Editable = false;
        }
        field(50009; Forwarder; Code[10])
        {
            TableRelation = "Shipping Agent".code;
        }
        field(50010; "Port of Discharge"; Code[20])
        {
            TableRelation = "Port of Loading".Port;
        }
        field(50011; "Port of Loading"; Code[20])
        {
            TableRelation = "Port of Loading".Port;
        }
        field(50012; Carrier; Code[10])
        {
            TableRelation = "TO Carrier".Code;
        }
        field(50014; "Pier Pass"; boolean)
        {

        }
        field(50015; LFD; Date)
        {

        }
        field(50016; "Actual Pull Date"; Date)
        {

        }
        field(50017; "Container Return Date"; Date)
        {

        }
        field(50018; Terminal; Code[50])
        {
            TableRelation = Terminal;
        }
        field(50019; ActualETD; Date)
        {
            Caption = 'Actual Departure';
        }
        field(50020; ActualETA; Date)
        {
            Caption = 'Actual Arrival';
        }
        field(50021; Notes; text[250])
        {
            Caption = 'Transfer Order Notes';

        }
        field(50022; ActualDeliveryDate; Date)
        {
            Caption = 'Actual Delivery Date';
        }
        field(50023; Urgent; Boolean)
        {
            Caption = 'Urgent';

        }


        field(50025; "M-Pack UPC"; code[20])
        {
            Caption = 'M-Pack UPC"';
            FieldClass = FlowField;
            CalcFormula = lookup(ContainerLine."UPC Code" where("Container No." = field("Container No.")));

        }
        field(50026; "PO No."; code[20])
        {
            Caption = 'PO No.';
            // FieldClass = FlowField;
            // CalcFormula = lookup(ContainerLine."Document No." where("Transfer Order No." = field("No.")));
        }
        field(50027; "Actual Pull Time"; Time)
        {

        }
        field(50028; ZDELDrayage; Code[50])
        {
            TableRelation = Drayage;
        }
        field(50029; "Container Status Notes"; Text[300])
        {
            Editable = true;
        }

        // pr 12/11/24 - start
        field(50031; TerminalFF; Code[50])
        {
            Caption = 'Terminal';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".Terminal where("Container No." = field("Container No.")));

        }
        field(50032; ActualETDFF; Date)
        {
            Caption = 'Actual Departure';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".ActualETD where("Container No." = field("Container No.")));
        }
        field(50033; ActualETAFF; Date)
        {
            Caption = 'Actual Arrival';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".ActualETA where("Container No." = field("Container No.")));
        }
        field(50034; "Container Status NotesFF"; Text[300])
        {
            Caption = 'Container Status Notes';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Container Status Notes" where("Container No." = field("Container No.")));
        }
        field(50035; "Actual Pull TimeFF"; Time)
        {
            Caption = 'Actual Pull Time';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Actual Pull Time" where("Container No." = field("Container No.")));
        }
        field(50036; DrayageFF; Code[50])
        {
            Caption = 'Drayage';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".Drayage where("Container No." = field("Container No.")));
        }
        field(50037; LFDFF; Date)
        {
            Caption = 'LFD';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".LFD where("Container No." = field("Container No.")));
        }
        field(50038; "Actual Pull DateFF"; Date)
        {
            Caption = 'Actual Pull Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Actual Pull Date" where("Container No." = field("Container No.")));
        }
        field(50039; ForwarderFF; Code[10])
        {
            Caption = 'Forwarder';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".Forwarder where("Container No." = field("Container No.")));
        }
        field(50040; "Port of DischargeFF"; Code[20])
        {
            Caption = 'Port of Discharge';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Port of Discharge" where("Container No." = field("Container No.")));
        }
        field(50041; "Port of LoadingFF"; Code[20])
        {
            Caption = 'Port of Loading';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Port of Loading" where("Container No." = field("Container No.")));
        }
        field(50042; CarrierFF; Code[10])
        {
            Caption = 'Carrier';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".Carrier where("Container No." = field("Container No.")));
        }
        field(50043; ContainerSizeFF; Code[20])
        {
            Caption = 'Container Size';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Container Size" where("Container No." = field("Container No.")));
        }
        field(50044; ActualDeliveryDateFF; Date)
        {
            Caption = 'Actual Delivery Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Actual Delivery Date" where("Container No." = field("Container No.")));
        }
        field(50045; EmptyNotificationDateFF; Date)
        {
            Caption = 'Empty Notification Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Empty Notification Date" where("Container No." = field("Container No.")));
        }
        field(50046; ContainerReturnDateFF; Date)
        {
            Caption = 'Container Return Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Container Return Date" where("Container No." = field("Container No.")));
        }
        // pr 12/11/24 - end

        field(50047; "Receiving Status"; code[50])
        {
            FieldClass = FlowField;
            TableRelation = ReceivingStatus;
            CalcFormula = lookup("Container Header"."Receiving Status" Where("Container No." = field("Container No.")));

        }
        //PR 2/10/25 - start
        field(50048; "944 Received Date"; Date)
        {
            Editable = false;
        }
        field(50049; "944 Receipt No."; code[20])
        {
            Editable = false;
        }
        field(50050; "944 Load No."; code[20])
        {
            Editable = false;
        }
        //PR 2/10/25 - end

        //PR 2/17/25 - start
        field(50051; "Total CBM"; Decimal)
        {
            Editable = false;
        }
        //PR 2/17/25 - end
        //PR 2/19/25 - start
        field(50052; "Filling Notes"; code[30])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Filling Notes" where("Container No." = field("Container No.")));
        }
        //PR 2/19/25 - end

        // 7/23/25 - start
        field(50053; "FDA Hold"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."FDA Hold" where("Container No." = field("Container No.")));

        }
        // 7/23/25 - end
        // 7/24/25 - start
        modify("Transfer-to Code")
        {
            trigger OnBeforeValidate()
            var
                TransferHeader: Record "Transfer Header";
                Location: Record Location;
                InventorySetup: Record "Inventory Setup";
                LocationRef: Record Location;
            begin
                if (rec."Transfer-to Code" <> xrec."Transfer-to Code") and (rec."FDA Hold" = true) then begin
                    Error(txtTransferToCodeError, Rec."Container No.");
                end;
                //8/16/25 - start 
                Location.Reset();
                Location.SetRange("Code", xrec."Transfer-to Code");
                Location.SetRange("Allow Physical Transfer", true);
                LocationRef.Reset();
                LocationRef.SetRange("Code", rec."Transfer-to Code");
                LocationRef.SetRange("Allow Physical Transfer", false);
                if (Location.FindSet() and LocationRef.FindSet()) then begin
                    rec."Physical Transfer To Code" := '';
                end;
                //8/16/25 - end
                //8/26/25 - check if chaned to FDAHold if so copy old value into "Physical Transfer To Code" - start
                if InventorySetup.Get() then begin
                    if (rec."Transfer-to Code" = InventorySetup."FDA Hold Location Code") then begin
                        rec."Physical Transfer To Code" := xrec."Transfer-to Code";
                    end;
                end;
                //8/26/25 - check if chaned to FDAHold if so copy old value into "Physical Transfer To Code" - end

            end;
        }
        //7/24/25 - end

        //8/15/25 - start
        field(50054; "Physical Transfer To Code"; Code[10])
        {

            TableRelation = Location where("Use As In-Transit" = const(false));
            trigger OnValidate()
            var
                InventorySetup: Record "Inventory Setup";
                Location: Record Location;
            begin
                //8/16/25 - start 
                Location.Reset();
                Location.SetRange("Code", rec."Transfer-to Code");
                Location.SetRange("Allow Physical Transfer", true);
                if (Location.FindSet() = false) then begin
                    Error(txtPhysicalTransferError, rec."Transfer-to Code");

                end;
                //8/16/25 - end

            end;
        }
        field(50055; "Allow Physical Transfer"; Boolean)
        {

        }
        //8/15/25 - end

    }
    var
        txtNotAllowed: Label 'Sorry, this control CANNOT be edited.';
        txtTransferToCodeError: Label 'You cannot change the Transfer to Location since assigned Container no %1 is marked as FDA Hold.';
        popupConfirm: Page "Confirmation Dialog";
        txtConfirmContUnassign: Label 'Do you want to unassign Container No. %1 from Transfer Order No. %2?';
        txtTaskAborted: Label 'Task Aborted!';
        TxtQtyShippedTO: Label 'One or more transfer lines already SHIPPED.  You cannot unassign the container anymore.';
        TxtItemTrackingExists: Label 'Item Tracking Line(s) removed for Item %1.';
        txtPhysicalTransferError: Label 'You cannot assign Physical Transfer Code since Transfer To Code = %1';

    procedure CalcPhysicalTransfer()
    var
        InventorySetup: Record "Inventory Setup";
    begin
        "Allow Physical Transfer" := false;
        if InventorySetup.Get() then begin
            if (rec."Transfer-to Code" = InventorySetup."FDA Release Location Code")
             or (rec."Transfer-to Code" = InventorySetup."FDA Hold Location Code") then
                "Allow Physical Transfer" := true;
        end;
        if (rec."Transfer-to Code" = 'PENDING') then
            "Allow Physical Transfer" := true;
    end;


    procedure GetContainers()
    var
        ContainerHdr: Record "Container Header";
        TempContainerHdr: Record "Container Header" temporary;
        PgContainerOrders: Page "Container Orders";
    begin
        ContainerHdr.setrange("Location Code", Rec."Transfer-from Code");
        ContainerHdr.setfilter("Transfer Order No.", '=%1', '');

        PgContainerOrders.SetTableView(ContainerHdr);
        PgContainerOrders.SetAssignNow(true, Rec."No.");
        if PgContainerOrders.RunModal() = ACTION::OK then begin
            PgContainerOrders.Close();
        end;
    end;

    //PR 2/17/24 - calc total CBM - start
    procedure GetTotalCBM() ReturnValue: Decimal
    var
        TranferLn: Record "Transfer Line";
        totalCBM: Decimal;
    begin
        totalCBM := 0;
        TranferLn.reset;
        TranferLn.SetRange("Document No.", rec."No.");
        TranferLn.SETRANGE("Derived From Line No.", 0);
        If TranferLn.FindSet() then
            repeat
                totalCBM += (TranferLn.GetPackageCount() * TranferLn.GetDimensionM());
            until TranferLn.next() = 0;
        ReturnValue := totalCBM;

    end;
    //PR 2/17/24 - calc total CBM - end6
    //PR 2/24/25 - cacl total weight - start
    procedure GetTotalWeight() ReturnValue: Decimal
    var
        TranferLn: Record "Transfer Line";
        totlaWeight: Decimal;
    begin
        totlaWeight := 0;
        TranferLn.reset;
        TranferLn.SetRange("Document No.", rec."No.");
        TranferLn.SETRANGE("Derived From Line No.", 0);
        If TranferLn.FindSet() then
            repeat
                TranferLn.CalcFields("M-Pack Weight (kg)");
                totlaWeight += (TranferLn.GetPackageCount() * TranferLn."M-Pack Weight (kg)");
            until TranferLn.next() = 0;
        ReturnValue := totlaWeight;

    end;
    //PR 2/24/25 - cacl total weight - end
    //PR 2/19/25 - start
    procedure GetContainerCBM() ReturnValue: Decimal
    var
        ContainerHdr: Record "Container Header";
        cbm: Decimal;
    begin
        ContainerHdr.reset;
        ContainerHdr.SetRange("Container No.", rec."Container No.");
        if (ContainerHdr.FindSet()) then begin
            ContainerHdr.CalcFields("Container CBM");
            cbm := ContainerHdr."Container CBM";
        end;
        ReturnValue := cbm;
    end;

    procedure GetContainerPercentageThresh() ReturnValue: Decimal
    var
        ContainerHdr: Record "Container Header";
        percThresh: Decimal;
    begin
        ContainerHdr.reset;
        ContainerHdr.SetRange("Container No.", rec."Container No.");
        if (ContainerHdr.FindSet()) then begin
            ContainerHdr.CalcFields("Percentage Threshold");
            percThresh := ContainerHdr."Percentage Threshold";
        end;
        ReturnValue := percThresh;
    end;
    //PR 2/19/25 - end

    procedure UpdateTransferToCode(InTransferToCode: Code[10])
    var
        TransferLine: Record "Transfer Line";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        TransferShipmentLine: Record "Transfer Shipment Line";
        Location: Record Location;
        ReservationEntry: Record "Reservation Entry";
        InventorySetup: Record "Inventory Setup";
    begin
        if Location.Get(InTransferToCode) then begin
            //update TransferHeader 
            //8/26/25 - check if chaned to FDAHold if so copy old value into "Physical Transfer To Code" - start
            if InventorySetup.Get() then begin
                if (rec."Transfer-to Code" = InventorySetup."FDA Hold Location Code") then begin
                    rec."Physical Transfer To Code" := rec."Transfer-to Code";
                end;
            end;
            //8/26/25 - check if chaned to FDAHold if so copy old value into "Physical Transfer To Code" - end

            Rec."Transfer-to Code" := InTransferToCode;
            Rec."Transfer-to Name" := Location.Name;
            Rec."Transfer-to Name 2" := Location."Name 2";
            Rec."Transfer-to Address" := Location.Address;
            Rec."Transfer-to Address 2" := Location."Address 2";
            Rec."Transfer-to Post Code" := Location."Post Code";
            Rec."Transfer-to City" := Location.City;
            Rec."Transfer-to County" := Location.County;
            Rec."Trsf.-to Country/Region Code" := Location."Country/Region Code";
            Rec."Transfer-to Contact" := Location.Contact;
            Rec.Modify();

            //Update TransLine
            TransferLine.Reset;
            TransferLine.SetRange("Document No.", Rec."No.");
            if TransferLine.FindSet() then
                repeat
                    TransferLine."Transfer-to Code" := InTransferToCode;
                    TransferLine.Modify();
                until TransferLine.Next() = 0;

            //Update Corresponding Transfer Shipment
            TransferShipmentHeader.Reset();
            TransferShipmentHeader.SetRange("Transfer Order No.", Rec."No.");
            IF TransferShipmentHeader.FindFirst() then begin
                TransferShipmentHeader."Transfer-to Code" := Rec."Transfer-to Code";
                TransferShipmentHeader."Transfer-to Name" := Rec."Transfer-to Name";
                TransferShipmentHeader."Transfer-to Name 2" := Rec."Transfer-to Name 2";
                TransferShipmentHeader."Transfer-to Address" := Rec."Transfer-to Address";
                TransferShipmentHeader."Transfer-to Address 2" := Rec."Transfer-to Address 2";
                TransferShipmentHeader."Transfer-to Post Code" := Rec."Transfer-to Post Code";
                TransferShipmentHeader."Transfer-to City" := Rec."Transfer-to City";
                TransferShipmentHeader."Transfer-to County" := Rec."Transfer-to County";
                TransferShipmentHeader."Trsf.-to Country/Region Code" := Rec."Trsf.-to Country/Region Code";
                TransferShipmentHeader."Transfer-to Contact" := Rec."Transfer-to Contact";
                TransferShipmentHeader.Modify();

                TransferShipmentLine.Reset();
                TransferShipmentLine.SetRange("Document No.", TransferShipmentHeader."No.");
                IF TransferShipmentLine.FindSet() then
                    repeat
                        TransferShipmentLine."Transfer-to Code" := Rec."Transfer-to Code";
                        TransferShipmentLine.Modify();
                    until TransferShipmentLine.Next = 0;
            end;


            //Update Reservation Entry
            ReservationEntry.Reset();
            ReservationEntry.SetRange("Source ID", Rec."No.");
            ReservationEntry.SetRange("Source Type", Database::"Transfer Line");
            if ReservationEntry.FindSet() then
                repeat
                    ReservationEntry."Location Code" := InTransferToCode;
                    ReservationEntry.Modify();
                until ReservationEntry.Next() = 0;

        end;
    end;

    trigger OnAfterInsert()
    begin
        Rec.CreatedBy := UserId;
        Rec.CreatedDate := Today();
    end;

    trigger OnAfterModify()
    begin
        ModifiedBy := UserId;
        ModifiedDate := Today();
    end;


}
