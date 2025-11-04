table 50055 TmpQtyAssgnToContainerDetails
{
    Caption = 'TmpQtyAssgnToContainerDetails';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Container No."; Code[50])
        {
            Caption = 'Container No.';
            //TableRelation = "Container Header";
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';

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
            TableRelation = "Unit of Measure".Code;
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
            TableRelation = "Port of Loading".Port;
        }
        field(11; "Port of Loading"; Code[20])
        {
            TableRelation = "Port of Loading".Port;
        }

        field(12; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
            //Editable = false;
        }
        field(13; "Item Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(14; "Order Date"; Date)
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Purchase Header"."Order Date" where("No." = field("Document No.")));
        }
        field(15; "Requested Cargo Ready Date"; Date)
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Purchase Header".RequestedCargoReadyDate where("No." = field("Document No.")));
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
            //FieldClass = flowfield;
            //CalcFormula = lookup("Purchase Header"."Assigned User ID" where("No." = field("Document No.")));
            //Editable = false;
        }
        field(19; "M-Pack Qty"; Decimal)
        {
            Caption = 'M-Pack Qty';
            FieldClass = FlowField;
            DecimalPlaces = 0;
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
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header".Forwarder WHERE("Container No." = field("Container No.")));
        }
        field(24; "Freight Cost"; Decimal)
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header"."Freight Cost" WHERE("Container No." = field("Container No.")));
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
            //Editable = false;
        }
        field(29; "Transfer Order No."; Code[20])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header"."Transfer Order No." WHERE("Container No." = field("Container No.")));
            //TableRelation = "Transfer Header";
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
            OptionCaption = ' ,Waiting for factory to send print confirmation,Waiting for license approval,Waiting for design team approval,Deposit pending approval,Balance payment pending approval,Waiting for test report (DO NOT USE),Waiting for new mold ready ,Waiting for factory to confirm CRD,Finalizing product spec,Pre-production sample pending approval  ,Post-production sample pending approval,Approved for production,Waiting for factory to book shipment,Shipment booked,Waiting for forwarder to release vessel info,Shipped,Waiting for Artwork,PO on Hold,Waiting for component from US,Shipped - waiting for payment to release FCR,Waiting for factory provide pre-production samples,Waiting for pre-production test report,Waiting for post-production test report';
            OptionMembers = " ","Waiting for factory to send print confirmation","Waiting for license approval","Waiting for design team approval","Deposit pending approval","Balance payment pending approval","Waiting for test report (DO NOT USE)","Waiting for new mold ready ","Waiting for factory to confirm CRD","Finalizing product spec","Pre-production sample pending approval  ","Post-production sample pending approval","Approved for production","Waiting for factory to book shipment","Shipment booked","Waiting for forwarder to release vessel info","Shipped","Waiting for Artwork","PO on Hold","Waiting for component from US","Shipped - waiting for payment to release FCR","Waiting for factory provide pre-production samples","Waiting for pre-production test report","Waiting for post-production test report";
            //Editable = false;
        }
        field(33; "ActualETD"; Date)
        {
            Caption = 'Actual Departure';
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header".ActualETD WHERE("Container No." = field("Container No.")));
            //Editable = false;
        }
        field(34; "ActualETA"; Date)
        {
            Caption = 'Actual Arrival';
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header".ActualETA WHERE("Container No." = field("Container No.")));
            //Editable = false;
        }
        field(35; "TelexReleased"; boolean)
        {
            Caption = 'TO Telex Released';
            //Editable = false;
        }
        field(36; "PierPass"; boolean)
        {
            Caption = 'Pier Pass';
            //FieldClass = FlowField;
            //CalcFormula = lookup("Transfer Header"."Pier Pass" WHERE("No." = field("Transfer Order No.")));
        }
        field(37; "Transfer-to Code"; Code[10])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Transfer Header"."Transfer-to Code" WHERE("No." = field("Transfer Order No.")));
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(38; "TO Notes"; Text[250])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Transfer Header".Notes WHERE("No." = field("Transfer Order No.")));
        }
        field(39; Carrier; Code[10])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header".Carrier WHERE("Container No." = field("Container No.")));
            TableRelation = "TO Carrier".Code;
        }
        field(40; "Actual Pull Date"; Date)
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header"."Actual Pull Date" WHERE("Container No." = field("Container No.")));

        }
        field(41; ContainerSize; Code[20])
        {
            Caption = 'Container Size';
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header"."Container Size" WHERE("Container No." = field("Container No.")));
            TableRelation = "Container Size".Code;
        }
        field(42; "Transfer Receipt No."; Code[20])
        {
            //Editable = false;
        }
        field(43; "Freight Bill Amount"; Decimal)
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header"."Freight Bill Amount" WHERE("Container No." = field("Container No.")));
        }
        field(44; "Freight Bill No."; Code[30])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header"."Freight Bill No." WHERE("Container No." = field("Container No.")));
        }
        field(45; "Container Return Date"; Date)
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header"."Container Return Date" WHERE("Container No." = field("Container No.")));
        }
        field(46; SourceNo; Integer)
        {
            //Editable = false;
        }
        field(47; ETD; Date)
        {
            Caption = 'Initial Departure';
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header".ETD WHERE("Container No." = field("Container No.")));

        }
        field(48; ETA; Date)
        {
            Caption = 'Initial Arrival';
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header".ETA WHERE("Container No." = field("Container No.")));
        }
        field(49; CreatedBy; code[50])
        {
            Caption = 'Created By';
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header".CreatedBy WHERE("Container No." = field("Container No.")));
        }
        field(50; "Actual Delivery Date"; Date)
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header"."Actual Delivery Date" WHERE("Container No." = field("Container No.")));
        }
        field(51; "Actual Pull Time"; Time)
        {

            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header"."Actual Pull Time" WHERE("Container No." = field("Container No.")));
        }
        field(52; "POUserID"; code[20])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Purchase Header".CreatedUserID WHERE("No." = field("Document No.")));
        }
        field(53; EmptyNotificationDate; Date)
        {
            Caption = 'Empty Notification Date';
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header"."Empty Notification Date" WHERE("Container No." = field("Container No.")));
        }
        field(54; PONoFromTO; Code[20])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Transfer Line"."PO No." WHERE("Document No." = field("Document No."), "Item No." = field("Item No."), "Line No." = field("Document Line No.")));
        }
        field(55; PONo; Code[20])
        {
            //Editable = false;
            //TableRelation = "Purchase Header"."No.";
        }
        Field(56; "PO Owner"; Code[20])
        {
            //Editable = False;
        }
        field(57; Terminal; code[50])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Transfer Header".Terminal where("No." = field("Transfer Order No.")));
        }
        field(58; "Container Status Notes"; Text[300])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header"."Container Status Notes" where("Container No." = field("Container No.")));
        }
        field(59; Drayage; code[50])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header".Drayage where("Container No." = field("Container No.")));
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
            //Editable = false;
        }
        field(63; POOwnerFromTO; Code[50])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Transfer Line"."PO Owner" WHERE("Document No." = field("Document No."), "Item No." = field("Item No.")));
        }
        // pr 12/10/24
        field(64; LFD; Date)
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header".LFD where("Container No." = field("Container No.")));
        }
        field(65; "Lot No."; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Reservation Entry"."Lot No." where("Source ID" = field("Transfer Order No."),
                                                               "Source Type" = const(Database::"Transfer Line"),
                                                                "Item No." = field("Item No.")));
        }
        field(66; "Exp Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Reservation Entry"."Expiration Date" where("Source ID" = field("Transfer Order No."),
                                                                "Source Type" = const(Database::"Transfer Line"),
                                                              "Item No." = field("Item No.")));
        }

        field(67; Status; Option)
        {
            Caption = 'Container Status';
            OptionCaption = 'Open,Assigned,Completed';
            OptionMembers = "Open","Assigned","Completed";
            //FieldClass = FlowField;
            //CalcFormula = lookup("Container Header".Status WHERE("Container No." = field("Container No.")));
            //Editable = false;
        }
        field(69; Urgent; Boolean)
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Transfer Header".Urgent Where("No." = field("Transfer Order No.")));
            // //Editable = false;
        }
        field(70; "Purchasing Code"; code[10])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Purchasing Code" where("No." = field("Item No.")));
        }
        field(71; TOOpen; boolean)
        {
            Caption = 'TO Open';
            //Editable = false;
        }
        field(72; "Recieving Status"; code[50])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Transfer Header"."Receiving Status" Where("No." = field("Transfer Order No.")));
            //  //Editable = false;
        }
        field(73; "Actual Pull Date Ref"; Date)
        {

            //Editable = false;
        }
        field(75; "LineTelexReleased"; boolean)
        {
            Caption = 'Line Telex Released';
            //Editable = false;
        }
        field(76; "Customer Responsibility Center"; Code[10])
        {
            Caption = 'Customer Responsibility Center';
            TableRelation = "Responsibility Center";

        }
        field(77; POCustCode; Code[20])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Purchase Line"."Shortcut Dimension 1 Code" WHERE("Document No." = field(PONo)));
        }
        field(78; PRCustCode; Code[20])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup("Purch. Rcpt. Line"."Shortcut Dimension 1 Code" WHERE("Document No." = field(PONo)));
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
            //Editable = false;
        }
        field(82; "Manufacturer Code"; code[20])
        {
            Caption = 'Preferred 3PL Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Manufacturer Code" where("No." = field("Item No.")));

        }
        field(83; "Transfer Line Quantity"; Decimal)
        {
            //Editable = false;
        }
        //PR 2/13/25 - start
        field(84; Hazard; Boolean)
        {
            //Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Hazard where("No." = field("Item No.")));
        }
        //PR 2/13/25 - end
        //PR 2/14/25 - start
        Field(85; "PO Vendor"; Code[20])
        {
            //Editable = False;
        }
        Field(86; "Posted"; Boolean)
        {
            //Editable = False;
        }
        //PR 2/14/25 - end


    }
    keys
    {
        key(PK; "Container No.", SourceNo, "Document No.", "Document Line No.", "Item No.", "Unit of Measure Code", "Buy-From Vendor No.")
        {
            Clustered = true;
        }
        key(NK; "Container No.", "Document No.", "Item No.", Quantity, "Unit of Measure Code", "Buy-From Vendor No.")
        {
            Clustered = false;
        }

        key(NK1; "Container No.", SourceNo, "Document No.", "Document Line No.", "Item No.")
        {
            Clustered = false;
        }


    }
    procedure CopyFromContainerLine(inContLine: Record ContainerLine)
    begin
        //  rec.Init();
        inContLine.CalcFields("M-Pack Height", "M-Pack Length", "M-Pack Width", "M-Pack Qty", "M-Pack Weight kg",
        "Order Date", "Actual Pull Date", "Actual Delivery Date", "Container Return Date",
        POUserId, "Actual Pull Time", POUserID, PONoFromTO, POOwnerFromTO, Urgent, "M-Pack Qty", "Container Status Notes", "Transfer Order No.", POCustCode,
        PRCustCode, POCustRespCtr, PRCustRespCtr, "Manufacturer Code", ETA, ETD);
        rec.Posted := false;
        rec."Item No." := inContLine."Item No.";
        rec."Container No." := inContLine."Container No.";
        rec."Document No." := inContLine."Document No.";
        rec.Quantity := inContLine.Quantity;
        rec."Unit of Measure Code" := inContLine."Unit of Measure Code";
        rec."Quantity Base" := inContLine."Quantity Base";
        rec."Buy-From Vendor No." := inContLine."Buy-From Vendor No.";
        rec."Document Line No." := inContLine."Document Line No.";
        rec."Port of Discharge" := inContLine."Port of Discharge";
        rec."Port of Loading" := inContLine."Port of Loading";
        rec."Your Reference" := inContLine."Your Reference";
        rec."Item Description" := inContLine."Item Description";
        rec."Order Date" := inContLine."Order Date";
        rec."Requested Cargo Ready Date" := inContLine."Requested Cargo Ready Date";
        rec."Requested In Whse Date" := inContLine."Requested In Whse Date";
        rec.DeliveryNotes := inContLine.DeliveryNotes;
        rec.AssignedUserID := inContLine.AssignedUserID;
        rec."M-Pack Qty" := inContLine."M-Pack Qty";
        rec."M-Pack Height" := inContLine."M-Pack Height";
        rec."M-Pack Weight kg" := inContLine."M-Pack Weight kg";
        rec."M-Pack Width" := inContLine."M-Pack Width";
        rec."M-Pack Length" := inContLine."M-Pack Length";
        rec.Forwarder := inContLine.Forwarder;
        rec."Freight Cost" := inContLine."Freight Cost";
        rec."UPC Code" := inContLine."UPC Code";
        rec."Location Code" := inContLine."Location Code";
        rec."Transfer Order No." := inContLine."Transfer Order No.";
        rec.ActualCargoReadyDate := inContLine.ActualCargoReadyDate;
        rec.EmptyNotificationDate := inContLine.EmptyNotificationDate;
        rec."Production Status" := inContLine."Production Status";
        rec.ActualETD := inContLine.ActualETD;
        rec.ActualETA := inContLine.ActualETA;
        rec.TelexReleased := inContLine.TelexReleased;
        rec.PierPass := inContLine.PierPass;
        rec."Transfer-to Code" := inContLine."Transfer-to Code";
        rec."TO Notes" := inContLine."TO Notes";
        rec.Carrier := inContLine.Carrier;
        rec."Actual Pull Date" := inContLine."Actual Pull Date";
        rec.ContainerSize := inContLine.ContainerSize;
        rec."Transfer Receipt No." := inContLine."Transfer Receipt No.";
        rec."Freight Bill Amount" := inContLine."Freight Bill Amount";
        rec."Freight Bill No." := inContLine."Freight Bill No.";
        rec."Container Return Date" := inContLine."Container Return Date";
        rec.SourceNo := inContLine.SourceNo;
        rec.ETD := inContLine.etd;
        rec.ETA := inContLine.ETA;
        rec.CreatedBy := inContLine.CreatedBy;
        rec."Actual Delivery Date" := inContLine."Actual Delivery Date";
        rec."Actual Pull Time" := inContLine."Actual Pull Time";
        rec.POUserID := inContLine.POUserID;
        rec.EmptyNotificationDate := inContLine.EmptyNotificationDate;
        rec.PONoFromTO := inContLine.PONoFromTO;
        rec.PONo := inContLine.PONo;
        rec."PO Owner" := inContLine."PO Owner";
        rec.Terminal := inContLine.Terminal;
        rec."Container Status Notes" := inContLine."Container Status Notes";
        rec.Drayage := inContLine.Drayage;
        rec.Ti := inContLine.Ti;
        rec.Hi := inContLine.Hi;
        rec.POClosed := inContLine.POClosed;
        rec.POOwnerFromTO := inContLine.POOwnerFromTO;
        rec.LFD := inContLine.LFD;
        rec."Lot No." := inContLine."Lot No.";
        rec."Exp Date" := inContLine."Exp Date";
        rec.Status := inContLine.Status;
        rec.Urgent := inContLine.Urgent;
        rec."Purchasing Code" := inContLine."Purchasing Code";
        rec.TOOpen := inContLine.TOOpen;
        rec."Recieving Status" := inContLine."Recieving Status";
        rec."Actual Pull Date Ref" := inContLine."Actual Pull Date Ref";
        rec.LineTelexReleased := inContLine.LineTelexReleased;
        rec."Customer Responsibility Center" := inContLine."Customer Responsibility Center";
        rec.POCustCode := inContLine.POCustCode;
        rec.PRCustCode := PRCustCode;
        rec.POCustRespCtr := inContLine.POCustRespCtr;
        rec.PRCustRespCtr := inContLine.PRCustRespCtr;
        rec.CustCode := inContLine.CustCode;
        rec."Manufacturer Code" := inContLine."Manufacturer Code";
        rec."Transfer Line Quantity" := inContLine."Transfer Line Quantity";
        rec.Hazard := inContLine.Hazard;
        rec."PO Vendor" := inContLine."PO Vendor";
        // rec.Insert();

    end;

    procedure CopyFromPostedContainerLine(inContLine: Record "Posted Container Line")
    begin
        // rec.Init();
        inContLine.CalcFields("M-Pack Height", "M-Pack Length", "M-Pack Width", "M-Pack Qty", "M-Pack Weight kg",
        "Order Date", "Actual Pull Date", "Actual Delivery Date", "Container Return Date",
        POUserId, "Actual Pull Time", POUserID, PONoFromTO, POOwnerFromTO, Urgent, "M-Pack Qty", "Container Status Notes", "Transfer Order No.", POCustCode,
        PRCustCode, POCustRespCtr, PRCustRespCtr, "Manufacturer Code", ETA, ETD);
        rec.Posted := true;
        rec."Item No." := inContLine."Item No.";
        rec."Container No." := inContLine."Container No.";
        rec."Document No." := inContLine."Document No.";
        rec.Quantity := inContLine.Quantity;
        rec."Unit of Measure Code" := inContLine."Unit of Measure Code";
        rec."Quantity Base" := inContLine."Quantity Base";
        rec."Buy-From Vendor No." := inContLine."Buy-From Vendor No.";
        rec."Document Line No." := inContLine."Document Line No.";
        rec."Port of Discharge" := inContLine."Port of Discharge";
        rec."Port of Loading" := inContLine."Port of Loading";
        rec."Your Reference" := inContLine."Your Reference";
        rec."Item Description" := inContLine."Item Description";
        rec."Order Date" := inContLine."Order Date";
        rec."Requested Cargo Ready Date" := inContLine."Requested Cargo Ready Date";
        rec."Requested In Whse Date" := inContLine."Requested In Whse Date";
        rec.DeliveryNotes := inContLine.DeliveryNotes;
        rec.AssignedUserID := inContLine.AssignedUserID;
        rec."M-Pack Qty" := inContLine."M-Pack Qty";
        rec."M-Pack Height" := inContLine."M-Pack Height";
        rec."M-Pack Weight kg" := inContLine."M-Pack Weight kg";
        rec."M-Pack Width" := inContLine."M-Pack Width";
        rec."M-Pack Length" := inContLine."M-Pack Length";
        rec.Forwarder := inContLine.Forwarder;
        rec."Freight Cost" := inContLine."Freight Cost";
        rec."UPC Code" := inContLine."UPC Code";
        rec."Location Code" := inContLine."Location Code";
        rec."Transfer Order No." := inContLine."Transfer Order No.";
        rec.ActualCargoReadyDate := inContLine.ActualCargoReadyDate;
        rec.EmptyNotificationDate := inContLine.EmptyNotificationDate;
        rec."Production Status" := inContLine."Production Status";
        rec.ActualETD := inContLine.ActualETD;
        rec.ActualETA := inContLine.ActualETA;
        rec.TelexReleased := inContLine.TelexReleased;
        rec.PierPass := inContLine.PierPass;
        rec."Transfer-to Code" := inContLine."Transfer-to Code";
        rec."TO Notes" := inContLine."TO Notes";
        rec.Carrier := inContLine.Carrier;
        rec."Actual Pull Date" := inContLine."Actual Pull Date";
        rec.ContainerSize := inContLine.ContainerSize;
        rec."Transfer Receipt No." := inContLine."Transfer Receipt No.";
        rec."Freight Bill Amount" := inContLine."Freight Bill Amount";
        rec."Freight Bill No." := inContLine."Freight Bill No.";
        rec."Container Return Date" := inContLine."Container Return Date";
        rec.SourceNo := inContLine.SourceNo;
        rec.ETD := inContLine.etd;
        rec.ETA := inContLine.ETA;
        rec.CreatedBy := inContLine.CreatedBy;
        rec."Actual Delivery Date" := inContLine."Actual Delivery Date";
        rec."Actual Pull Time" := inContLine."Actual Pull Time";
        rec.POUserID := inContLine.POUserID;
        rec.EmptyNotificationDate := inContLine.EmptyNotificationDate;
        rec.PONoFromTO := inContLine.PONoFromTO;
        rec.PONo := inContLine.PONo;
        rec."PO Owner" := inContLine."PO Owner";
        rec.Terminal := inContLine.Terminal;
        rec."Container Status Notes" := inContLine."Container Status Notes";
        rec.Drayage := inContLine.Drayage;
        rec.Ti := inContLine.Ti;
        rec.Hi := inContLine.Hi;
        rec.POClosed := inContLine.POClosed;
        rec.POOwnerFromTO := inContLine.POOwnerFromTO;
        rec.LFD := inContLine.LFD;
        rec."Lot No." := inContLine."Lot No.";
        rec."Exp Date" := inContLine."Exp Date";
        rec.Status := inContLine.Status::Completed;
        rec.Urgent := inContLine.Urgent;
        rec."Purchasing Code" := inContLine."Purchasing Code";
        rec.TOOpen := inContLine.TOOpen;
        rec."Recieving Status" := inContLine."Recieving Status";
        rec."Actual Pull Date Ref" := inContLine."Actual Pull Date Ref";
        rec.LineTelexReleased := inContLine.LineTelexReleased;
        rec."Customer Responsibility Center" := inContLine."Customer Responsibility Center";
        rec.POCustCode := inContLine.POCustCode;
        rec.PRCustCode := PRCustCode;
        rec.POCustRespCtr := inContLine.POCustRespCtr;
        rec.PRCustRespCtr := inContLine.PRCustRespCtr;
        rec.CustCode := inContLine.CustCode;
        rec."Manufacturer Code" := inContLine."Manufacturer Code";
        rec."Transfer Line Quantity" := inContLine."Transfer Line Quantity";
        rec.Hazard := inContLine.Hazard;
        rec."PO Vendor" := inContLine."PO Vendor";

        //   rec.Insert();

    end;

}
