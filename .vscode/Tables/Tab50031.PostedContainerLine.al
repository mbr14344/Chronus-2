table 50031 "Posted Container Line"
{
    Caption = 'Posted Container Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Container No."; Code[50])
        {
            Caption = 'Container No.';
            TableRelation = "Posted Container Header";
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Purch. Rcpt. Header"."No.";
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(6; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
        }
        field(7; "Quantity Base"; Decimal)
        {
            Caption = 'Quantity Base';
        }
        field(8; "Buy-From Vendor No."; Code[20])
        {
            Caption = 'Buy-From Vendor No.';
            TableRelation = Vendor;
        }
        field(9; "Document Line No."; Integer)
        {

        }
        field(10; "Port of Discharge"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header"."Port of Discharge" WHERE("Container No." = field("Container No.")));
        }
        field(11; "Port of Loading"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header"."Port of Loading" WHERE("Container No." = field("Container No.")));
        }

        field(12; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."Your Reference" where("Order No." = field("Document No.")));
        }
        field(13; "Item Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(14; "Order Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."Order Date" where("Order No." = field("Document No.")));
        }
        field(15; "Requested Cargo Ready Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header".RequestedCargoReadyDate where("No." = field("Document No.")));
        }
        field(16; "Requested In Whse Date"; Date)
        {

        }
        field(17; DeliveryNotes; text[255])
        {
            Caption = 'Delivery Notes';

        }
        field(18; AssignedUserID; text[50])
        {
            Caption = 'Assigned User ID';
            FieldClass = flowfield;
            CalcFormula = lookup("Purchase Header"."Assigned User ID" where("No." = field("Document No.")));
            Editable = false;
        }
        field(19; "M-Pack Qty"; Decimal)
        {
            Caption = 'M-Pack Qty';
            FieldClass = FlowField;

            CalcFormula = lookup("Item Unit of Measure"."Qty. per Unit of Measure" WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }

        field(20; "M-Pack Weight kg"; Decimal)
        {
            Caption = 'M-Pack Weight (kg)';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure"."Weight kgs" WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(50014; "M-Pack Height"; Decimal)
        {
            Caption = 'M-Pack Height';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Height WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(21; "M-Pack Length"; Decimal)
        {
            Caption = 'M-Pack Length';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Length WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(22; "M-Pack Width"; Decimal)
        {
            Caption = 'M-Pack width';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Width WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(23; Forwarder; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header".Forwarder WHERE("Container No." = field("Container No.")));
        }
        field(24; "Freight Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header"."Freight Cost" WHERE("Container No." = field("Container No.")));
        }

        field(26; "UPC Code"; Text[14])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.GTIN where("No." = field("Item No.")));
        }
        field(27; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header"."Location Code" WHERE("Container No." = field("Container No.")));
        }
        field(28; "Fully Received"; Boolean)
        {
            Editable = false;
        }
        field(29; "Transfer Order No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header"."Transfer Order No." WHERE("Container No." = field("Container No.")));
        }
        field(30; ActualCargoReadyDate; Date)
        {
            Caption = 'Actual Cargo Ready Date';

        }
        field(31; EstimatedInWarehouseDate; Date)
        {
            Caption = 'Estimated In-Whse Date';

        }
        field(32; "Production Status"; Option)
        {
            Caption = 'Production Status';
            FieldClass = FlowField;
            OptionCaption = ' ,Waiting for factory to send print confirmation,Waiting for license approval,Waiting for design team approval,Deposit pending approval,Balance payment pending approval,Waiting for test report (DO NOT USE),Waiting for new mold ready ,Waiting for factory to confirm CRD,Finalizing product spec,Pre-production sample pending approval  ,Post-production sample pending approval,Approved for production,Waiting for factory to book shipment,Shipment booked,Waiting for forwarder to release vessel info,Shipped,Waiting for Artwork,PO on Hold,Waiting for component from US,Shipped - waiting for payment to release FCR,Waiting for factory provide pre-production samples,Waiting for pre-production test report,Waiting for post-production test report';
            OptionMembers = " ","Waiting for factory to send print confirmation","Waiting for license approval","Waiting for design team approval","Deposit pending approval","Balance payment pending approval","Waiting for test report (DO NOT USE)","Waiting for new mold ready ","Waiting for factory to confirm CRD","Finalizing product spec","Pre-production sample pending approval  ","Post-production sample pending approval","Approved for production","Waiting for factory to book shipment","Shipment booked","Waiting for forwarder to release vessel info","Shipped","Waiting for Artwork","PO on Hold","Waiting for component from US","Shipped - waiting for payment to release FCR","Waiting for factory provide pre-production samples","Waiting for pre-production test report","Waiting for post-production test report";
            CalcFormula = lookup("Purch. Rcpt. Header"."Production Status" where("Order No." = field("Document No.")));
        }
        field(33; "ActualETD"; Date)
        {
            Caption = 'Actual Departure';
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header".ActualETD WHERE("Container No." = field("Container No.")));
        }
        field(34; "ActualETA"; Date)
        {
            Caption = 'Actual Arrival';
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header".ActualETA WHERE("Container No." = field("Container No.")));
        }
        field(35; "TelexReleased"; boolean)
        {
            Caption = 'Telex Released';
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header"."Telex Released" WHERE("Transfer Order No." = field("Transfer Order No.")));
            TableRelation = "Transfer Receipt Header"."No.";
        }
        field(36; "PierPass"; boolean)
        {
            Caption = 'Pier Pass';
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header"."Pier Pass" WHERE("Transfer Order No." = field("Transfer Order No.")));
            TableRelation = "Transfer Receipt Header"."No.";
        }
        field(37; "Transfer-to Code"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header"."Transfer-to Code" WHERE("Transfer Order No." = field("Transfer Order No.")));
            TableRelation = "Transfer Receipt Header"."No.";
        }
        field(38; "TO Notes"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header".Notes WHERE("Transfer Order No." = field("Transfer Order No.")));
            TableRelation = "Transfer Receipt Header"."No.";
        }
        field(39; Carrier; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header".Carrier WHERE("Transfer Order No." = field("Transfer Order No.")));
            TableRelation = "Transfer Receipt Header"."No.";
        }
        field(40; "Actual Pull Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header"."Actual Pull Date" WHERE("Transfer Order No." = field("Transfer Order No.")));
            TableRelation = "Transfer Receipt Header"."No.";
        }
        field(41; ContainerSize; Code[20])
        {
            Caption = 'Container Size';
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header".ContainerSize WHERE("Transfer Order No." = field("Transfer Order No.")));
            TableRelation = "Container Size".Code;
        }
        field(42; "Transfer Receipt No."; Code[20])
        {
            Editable = false;
        }
        //PR 3/6/25 - start
        field(43; "Freight Bill Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header"."Freight Bill Amount" WHERE("Container No." = field("Container No.")));
        }
        field(44; "Freight Bill No."; Code[30])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header"."Freight Bill No." WHERE("Container No." = field("Container No.")));
        }
        field(45; "Container Return Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header"."Container Return Date" WHERE("Container No." = field("Container No.")));
        }
        //PR 3/6/25 - end

        field(46; SourceNo; Integer)
        {
            Editable = false;
        }
        //PR 3/6/25 - start
        field(47; ETD; Date)
        {
            Caption = 'Initial Departure';
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header".ETD WHERE("Container No." = field("Container No.")));

        }
        field(48; ETA; Date)
        {
            Caption = 'Initial Arrival';
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header".ETA WHERE("Container No." = field("Container No.")));
        }
        field(49; CreatedBy; code[50])
        {
            Caption = 'Created By';
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header".CreatedBy WHERE("Container No." = field("Container No.")));
        }
        field(50; "Actual Delivery Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header"."Actual Delivery Date" WHERE("Container No." = field("Container No.")));
        }
        field(51; "Actual Pull Time"; Time)
        {

            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header"."Actual Pull Time" WHERE("Container No." = field("Container No.")));
        }
        field(52; "POUserID"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header".CreatedUserID WHERE("No." = field("Document No.")));
        }
        field(53; EmptyNotificationDate; Date)
        {
            Caption = 'Empty Notification Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header"."Empty Notification Date" WHERE("Container No." = field("Container No.")));
        }
        field(54; PONoFromTO; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Line"."PO No." WHERE("Transfer Order No." = field("Transfer Order No."), "Item No." = field("Item No."), "Line No." = field("Document Line No.")));
        }
        //PR 3/6/25 - end
        field(55; PONo; Code[20])
        {
            Editable = false;
            TableRelation = "Purch. Rcpt. Header"."No.";
        }
        //PR 3/6/25 - start
        Field(56; "PO Owner"; Code[20])
        {
            Editable = False;
        }
        Field(85; "PO Vendor"; Code[20])
        {
            Editable = False;
        }
        field(57; Terminal; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header".Terminal WHERE("Transfer Order No." = field("Transfer Order No.")));
        }
        field(58; "Container Status Notes"; Text[300])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header"."Container Status Notes" where("Container No." = field("Container No.")));
        }
        field(59; Drayage; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header".Drayage where("Container No." = field("Container No.")));
        }
        field(60; Ti; Integer)
        {
            Caption = 'Ti';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Ti WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(61; Hi; Integer)
        {
            Caption = 'Hi';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Hi WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(62; POClosed; boolean)
        {
            Caption = 'PO Closed';
            Editable = false;
        }
        field(63; POOwnerFromTO; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Line"."PO Owner" WHERE("Transfer Order No." = field("Transfer Order No."), "Item No." = field("Item No."), "Line No." = field("Document Line No.")));
        }
        field(64; LFD; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header".LFD where("Container No." = field("Container No.")));
        }
        field(65; "Lot No."; code[50])
        {
            // FieldClass = FlowField;
            // CalcFormula = lookup("Reservation Entry"."Lot No." where("Source ID" = field("Transfer Order No."),
            //                                                      "Source Type" = const(Database::"Transfer Receipt Line"),
            //                                                      "Item No." = field("Item No.")));
            Editable = false;
        }
        field(66; "Exp Date"; Date)
        {
            /* FieldClass = FlowField;
             CalcFormula = lookup("Reservation Entry"."Expiration Date" where("Source ID" = field("Transfer Order No."),
                                                                 "Source Type" = const(Database::"Transfer Receipt Line"),
                                                                 "Item No." = field("Item No.")));*/
            Editable = false;
        }

        field(67; Status; Option)
        {
            Caption = 'Container Status';
            OptionCaption = 'Open,Assigned,Completed';
            OptionMembers = "Open","Assigned","Completed";
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header".Status WHERE("Container No." = field("Container No.")));
            Editable = false;
        }
        field(69; Urgent; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header".Urgent WHERE("Transfer Order No." = field("Transfer Order No.")));
            Editable = false;
        }
        field(70; "Purchasing Code"; code[10])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Purchasing Code" where("No." = field("Item No.")));
        }
        field(71; TOOpen; boolean)
        {
            Caption = 'TO Open';
            Editable = false;
        }
        field(72; "Recieving Status"; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header"."Receiving Status" Where("Container No." = field("Container No.")));
            Editable = false;
        }
        field(73; "Actual Pull Date Ref"; Date)
        {

            Editable = false;
        }
        field(75; "LineTelexReleased"; boolean)
        {
            Caption = 'Line Telex Released';
            Editable = false;
        }
        field(76; "Customer Responsibility Center"; Code[10])
        {
            Caption = 'Customer Responsibility Center';
            TableRelation = "Responsibility Center";

        }
        field(77; POCustCode; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Line"."Shortcut Dimension 1 Code" WHERE("Document No." = field(PONo)));
        }
        field(78; PRCustCode; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Line"."Shortcut Dimension 1 Code" WHERE("Document No." = field(PONo)));
        }
        field(79; "POCustRespCtr"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Responsibility Center" WHERE("No." = field(POCustCode)));
        }
        field(80; "PRCustRespCtr"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Responsibility Center" WHERE("No." = field(PRCustCode)));
        }
        field(81; CustCode; Code[20])
        {
            Editable = false;
        }
        //pr 5/5/25 - start
        field(87; "Salesperson"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Salesperson Code" WHERE("No." = field(CustCode)));

        }
        //pr 5/5/25 - end
        field(82; "Manufacturer Code"; code[20])
        {
            Caption = 'Preferred 3PL Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Manufacturer Code" where("No." = field("Item No.")));

        }
        field(83; "Transfer Line Quantity"; Decimal)
        {
            Editable = false;
        }
        field(84; Hazard; Boolean)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Hazard where("No." = field("Item No.")));
        }
        //PR 3/6/25 - end
        field(88; "Actual ETD vs Actual CRD"; Integer)
        {
            Editable = false;
        }
        field(89; "Actual ETA vs Initial ETA"; Integer)
        {
            Editable = false;
        }


    }
    keys
    {
        key(PK; "Container No.", SourceNo, "Document No.", "Document Line No.", "Item No.", "Unit of Measure Code", "Buy-From Vendor No.")
        {
            Clustered = true;
        }
    }
    var
        UOM: Record "Unit of Measure";

    //PR 3/6/25 - start
    procedure GetPackageCountTransferLine() ReturnValue: decimal
    var
        result: Decimal;
        TransferLine: Record "Transfer Line";
    begin

        TransferLine.reset();
        TransferLine.SetRange("Document No.", rec."Transfer Order No.");
        TransferLine.SetRange("Item No.", rec."Item No.");
        TransferLine.SetRange(Quantity, rec.Quantity);

        if (TransferLine.FindSet()) then begin
            TransferLine.CalcFields("M-Pack Qty");
            If TransferLine."M-Pack Qty" > 0 then
                result := TransferLine.Quantity / TransferLine."M-Pack Qty";
            ReturnValue := result;
        end;

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

    procedure GetDimensionM() ReturnValue: Decimal
    var
        result: Decimal;
        ItemRef: Record "Item Reference";
    begin

        ItemRef.Reset();
        ItemRef.SetRange("Reference Type No.", Rec."Buy-from Vendor No.");
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

    //PR 3/6/35 - end
    procedure GetData()
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
            "Freight Cost", "Freight Bill No.", "Freight Bill Amount", "TO Notes", "Order Date", "Your Reference");
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
        Rec.Modify();
    end;

    procedure UpdateActualETDvsCRD()
    begin
        if (Rec."ActualETD" <> 0D) and (Rec.ActualCargoReadyDate <> 0D) then
            if (rec.ActualETD > rec.ActualCargoReadyDate) then
                Rec."Actual ETD vs Actual CRD" := Rec."ActualETD" - Rec.ActualCargoReadyDate
            else
                Rec."Actual ETD vs Actual CRD" := Rec.ActualCargoReadyDate - Rec."ActualETD"
        else
            Rec."Actual ETD vs Actual CRD" := 0;
    end;

    procedure UpdateActualETAvsETA()
    begin
        if (Rec."ActualETA" <> 0D) and (Rec.ETA <> 0D) then
            if (rec."ActualETA" > rec.ETA) then
                Rec."Actual ETA vs Initial ETA" := Rec."ActualETA" - Rec.ETA
            else
                Rec."Actual ETA vs Initial ETA" := Rec.ETA - Rec."ActualETA"
        else
            Rec."Actual ETA vs Initial ETA" := 0;
    end;

    procedure GetLotNo()
    var
        TransferLine: Record "Transfer Line";
        PostedTransferLn: Record "Transfer Receipt Line";
        PostedTransferHdr: Record "Transfer Receipt Header";
        PostedTransferShipmentLine: Record "Transfer Shipment Line";
    begin
        TransferLine.Reset();
        TransferLine.SetRange("Document No.", rec."Transfer Order No.");
        TransferLine.SetRange("Item No.", rec."Item No.");
        TransferLine.setRange(Status, TransferLine.Status::Open);
        if (TransferLine.FindSet()) then begin
            TransferLine.CalcFields("Lot No.", "Exp Date");
            rec."Lot No." := TransferLine."Lot No.";
            rec."Exp Date" := TransferLine."Exp Date";
        end
        else begin
            PostedTransferLn.reset();
            PostedTransferLn.SetRange("Transfer Order No.", rec."Transfer Order No.");
            PostedTransferLn.SetRange("Item No.", rec."Item No.");
            if (PostedTransferLn.FindSet()) then begin
                PostedTransferLn.CalcFields("Lot No.", "Expiration Date");
                rec."Lot No." := PostedTransferLn."Lot No.";
                rec."Exp Date" := PostedTransferLn."Expiration Date";
            end
            else begin
                PostedTransferShipmentLine.reset();
                PostedTransferShipmentLine.SetRange("Transfer Order No.", rec."Transfer Order No.");
                PostedTransferShipmentLine.SetRange("Item No.", rec."Item No.");
                if (PostedTransferShipmentLine.FindSet()) then begin
                    PostedTransferShipmentLine.CalcFields("Lot No.", "Expiration Date");
                    rec."Lot No." := PostedTransferShipmentLine."Lot No.";
                    rec."Exp Date" := PostedTransferShipmentLine."Expiration Date";
                end
                else begin
                    rec."Lot No." := '';
                    rec."Exp Date" := 0D;
                end;
            end;
        end;
    end;
}
