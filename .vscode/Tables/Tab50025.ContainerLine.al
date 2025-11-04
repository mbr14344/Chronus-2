table 50025 ContainerLine
{
    Caption = 'ContainerLine';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Container No."; Code[50])
        {
            Caption = 'Container No.';
            TableRelation = "Container Header";
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';

        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            trigger OnValidate()
            begin
                GenCU.UpdateEarliestStartShipDateContainer(Rec);
                UpdateNewItem();
            end;
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
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Port of Discharge" WHERE("Container No." = field("Container No.")));
        }
        field(11; "Port of Loading"; Code[20])
        {
            TableRelation = "Port of Loading".Port;
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Port of Loading" WHERE("Container No." = field("Container No.")));
        }

        field(12; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
            Editable = false;
        }
        field(13; "Item Description"; Text[100])
        {
            FieldClass = FlowField;
            Caption = 'Real Time Item Desciption';
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(14; "Order Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."Order Date" where("No." = field("Document No.")));
        }
        field(15; "Requested Cargo Ready Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".RequestedCargoReadyDate where("No." = field("Document No.")));
        }
        field(16; "Requested In Whse Date"; Date)
        {
            trigger OnValidate()
            begin
                CalcEarliestDifDate;  //7/7/25
            end;
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
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".Forwarder WHERE("Container No." = field("Container No.")));
        }
        field(24; "Freight Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Freight Cost" WHERE("Container No." = field("Container No.")));
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
            CalcFormula = lookup("Container Header"."Location Code" WHERE("Container No." = field("Container No.")));
        }
        field(29; "Transfer Order No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Transfer Order No." WHERE("Container No." = field("Container No.")));
            TableRelation = "Transfer Header";
        }
        field(30; ActualCargoReadyDate; Date)
        {
            Caption = 'Actual Cargo Ready Date';

        }
        field(31; EstimatedInWarehouseDate; Date)
        {
            Caption = 'Estimated In-Whse Date';
            trigger OnValidate()
            begin
                CalcEarliestDifDate;  //7/7/25 - call CalcEarliestDifDate
            end;

        }
        field(32; "Production Status"; Option)
        {
            Caption = 'Production Status';
            OptionCaption = ' ,Waiting for factory to send print confirmation,Waiting for license approval,Waiting for design team approval,Deposit pending approval,Balance payment pending approval,Waiting for test report (DO NOT USE),Waiting for new mold ready ,Waiting for factory to confirm CRD,Finalizing product spec,Pre-production sample pending approval  ,Post-production sample pending approval,Approved for production,Waiting for factory to book shipment,Shipment booked,Waiting for forwarder to release vessel info,Shipped,Waiting for Artwork,PO on Hold,Waiting for component from US,Shipped - waiting for payment to release FCR,Waiting for factory provide pre-production samples,Waiting for pre-production test report,Waiting for post-production test report';
            OptionMembers = " ","Waiting for factory to send print confirmation","Waiting for license approval","Waiting for design team approval","Deposit pending approval","Balance payment pending approval","Waiting for test report (DO NOT USE)","Waiting for new mold ready ","Waiting for factory to confirm CRD","Finalizing product spec","Pre-production sample pending approval  ","Post-production sample pending approval","Approved for production","Waiting for factory to book shipment","Shipment booked","Waiting for forwarder to release vessel info","Shipped","Waiting for Artwork","PO on Hold","Waiting for component from US","Shipped - waiting for payment to release FCR","Waiting for factory provide pre-production samples","Waiting for pre-production test report","Waiting for post-production test report";
            Editable = false;
        }
        field(33; "ActualETD"; Date)
        {
            Caption = 'Actual Departure';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".ActualETD WHERE("Container No." = field("Container No.")));
            Editable = false;
        }
        field(34; "ActualETA"; Date)
        {
            Caption = 'Actual Arrival';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".ActualETA WHERE("Container No." = field("Container No.")));
            Editable = false;
        }
        field(35; "TelexReleased"; boolean)
        {
            Caption = 'TO Telex Released';
            Editable = false;
        }
        field(36; "PierPass"; boolean)
        {
            Caption = 'Pier Pass';
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Header"."Pier Pass" WHERE("No." = field("Transfer Order No.")));
        }
        field(37; "Transfer-to Code"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Header"."Transfer-to Code" WHERE("No." = field("Transfer Order No.")));
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(38; "TO Notes"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Header".Notes WHERE("No." = field("Transfer Order No.")));
        }
        field(39; Carrier; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".Carrier WHERE("Container No." = field("Container No.")));
            TableRelation = "TO Carrier".Code;
        }
        field(40; "Actual Pull Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Actual Pull Date" WHERE("Container No." = field("Container No.")));

        }
        field(41; ContainerSize; Code[20])
        {
            Caption = 'Container Size';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Container Size" WHERE("Container No." = field("Container No.")));
            TableRelation = "Container Size".Code;
        }
        field(42; "Transfer Receipt No."; Code[20])
        {
            Editable = false;
        }
        field(43; "Freight Bill Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Freight Bill Amount" WHERE("Container No." = field("Container No.")));
        }
        field(44; "Freight Bill No."; Code[30])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Freight Bill No." WHERE("Container No." = field("Container No.")));
        }
        field(45; "Container Return Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Container Return Date" WHERE("Container No." = field("Container No.")));
        }
        field(46; SourceNo; Integer)
        {
            Editable = false;
        }
        field(47; ETD; Date)
        {
            Caption = 'Initial Departure';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".ETD WHERE("Container No." = field("Container No.")));

        }
        field(48; ETA; Date)
        {
            Caption = 'Initial Arrival';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".ETA WHERE("Container No." = field("Container No.")));
        }
        field(49; CreatedBy; code[50])
        {
            Caption = 'Created By';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".CreatedBy WHERE("Container No." = field("Container No.")));
        }
        field(50; "Actual Delivery Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Actual Delivery Date" WHERE("Container No." = field("Container No.")));
        }
        field(51; "Actual Pull Time"; Time)
        {

            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Actual Pull Time" WHERE("Container No." = field("Container No.")));
        }
        field(52; "POUserID"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".CreatedUserID WHERE("No." = field("Document No.")));
        }
        field(53; EmptyNotificationDate; Date)
        {
            Caption = 'Empty Notification Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Empty Notification Date" WHERE("Container No." = field("Container No.")));
        }
        field(54; PONoFromTO; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Line"."PO No." WHERE("Document No." = field("Document No."), "Item No." = field("Item No."), "Line No." = field("Document Line No.")));
        }
        field(55; PONo; Code[20])
        {
            Editable = false;
            TableRelation = "Purchase Header"."No.";
        }
        Field(56; "PO Owner"; Code[20])
        {
            Editable = False;
        }
        field(57; Terminal; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Header".Terminal where("No." = field("Transfer Order No.")));
        }
        field(58; "Container Status Notes"; Text[300])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header"."Container Status Notes" where("Container No." = field("Container No.")));
        }
        field(59; Drayage; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".Drayage where("Container No." = field("Container No.")));
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
            CalcFormula = lookup("Transfer Line"."PO Owner" WHERE("Document No." = field("Document No."), "Item No." = field("Item No.")));
        }
        // pr 12/10/24
        field(64; LFD; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".LFD where("Container No." = field("Container No.")));
        }
        field(65; "Lot No."; code[50])
        {
            Editable = false;

        }
        field(66; "Exp Date"; Date)
        {
            Editable = false;
        }

        field(67; Status; Option)
        {
            Caption = 'Container Status';
            OptionCaption = 'Open,Assigned,Completed';
            OptionMembers = "Open","Assigned","Completed";
            FieldClass = FlowField;
            CalcFormula = lookup("Container Header".Status WHERE("Container No." = field("Container No.")));
            Editable = false;
        }
        field(69; Urgent; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Header".Urgent Where("No." = field("Transfer Order No.")));
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
            CalcFormula = lookup("Transfer Header"."Receiving Status" Where("No." = field("Transfer Order No.")));
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
            CalcFormula = lookup("Purchase Line"."Shortcut Dimension 1 Code" WHERE("Document No." = field(PONo)));
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
            Caption = 'Cust Code';
        }
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
        //PR 2/13/25 - start
        field(84; Hazard; Boolean)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Hazard where("No." = field("Item No.")));
        }
        //PR 2/13/25 - end
        //PR 2/14/25 - start
        Field(85; "PO Vendor"; Code[20])
        {
            Editable = False;
        }
        //PR 2/14/25 - end
        //pr 5/1/25 - start
        field(86; "Expected Expiration Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."Expected Expiration Date" WHERE("Document No." = field(PONo), "No." = field("Item No.")));
        }
        //pr 5/1/25 - end

        //pr 5/5/25 - start
        field(87; "Salesperson"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Salesperson Code" WHERE("No." = field(CustCode)));
        }
        //pr 5/5/25 - end

        // pr 5/30/25 - start
        field(88; "Actual ETD vs Actual CRD"; Integer)
        {
            Editable = false;
            Caption = 'Actual Departure vs Actual CRD';
        }
        field(89; "Actual ETA vs Initial ETA"; Integer)
        {
            Editable = false;
            Caption = 'Actual Arrival vs Initial Arrival';
        }
        // pr 5/30/25 - end
        //mbr 6/7/25 - start
        field(90; "New Item"; Boolean)
        {
            Editable = false;
        }
        //mbr 6/7/25 - end
        //pr 6/20/25 - start
        field(91; "FDA Hold"; Boolean)
        {

            trigger OnValidate()
            var
                ContainerLines: Record ContainerLine;
                bHoldFound: Boolean;
                ContainerHdr: Record "Container Header";
                TransferHdr: Record "Transfer Header";
            begin
                If rec."FDA Hold" <> xrec."FDA Hold" then begin
                    if (rec."FDA Hold" = true) then begin
                        rec."FDA Hold Date" := Today;
                        rec.FDAHoldEmailNotifiSentDate := 0D;

                    end else begin
                        rec."FDA Released Date" := Today;
                        rec.FDAReleasedEmailNotifiSentDate := 0D;
                    end;

                end;
                //check to see if any of the lines in container lines has FDA Hold.
                ContainerLines.Reset();
                ContainerLines.SetRange("Container No.", Rec."Container No.");
                //ContainerLines.SetRange("Location Code", Rec."Location Code");
                ContainerLines.SetFilter("Item No.", '<>%1', Rec."Item No.");
                if (ContainerLines.FindSet()) then begin
                    repeat
                        if (ContainerLines."FDA Hold" = true) and (ContainerLines."Item No." <> rec."Item No.")
                        and (ContainerLines."Document No." <> rec."Document No.") then begin
                            bHoldFound := true;
                        end;
                    until ContainerLines.Next() = 0;
                end;
                if (rec."FDA Hold" = true) or (bHoldFound = true) then begin
                    ContainerHdr.Reset();
                    ContainerHdr.SetRange("Container No.", Rec."Container No.");
                    // ContainerHdr.SetRange("Location Code", rec."Location Code");
                    if (ContainerHdr.FindFirst()) then begin
                        ContainerHdr.Validate("FDA Hold", true);
                        ContainerHdr.Modify();
                    end;
                end
                else if (rec."FDA Hold" = false) and (bHoldFound = false) then begin
                    ContainerHdr.Reset();
                    ContainerHdr.SetRange("Container No.", Rec."Container No.");
                    //ContainerHdr.SetRange("Location Code", rec."Location Code");
                    if (ContainerHdr.FindFirst()) then begin
                        ContainerHdr.Validate("FDA Hold", false);
                        ContainerHdr.Modify();
                    end;


                end;
            end;

        }
        //pr 6/20/25 - end
        //mbr 6/20/25 - start
        field(92; "Qty. on Sales Order"; Decimal)
        {
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                            Type = const(Item),
                                                                            "No." = field("Item No."),
                                                                            "Unit of Measure Code" = field("Unit of Measure Code")));
            Caption = 'Qty. on Sales Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(93; "Earliest Start Ship Date"; Date)
        {
            Caption = 'Earliest Start Ship Date';
            Editable = false;
            trigger OnValidate()
            begin
                CalcEarliestDifDate;  //7/7/25 - call CalcEarliestDifDate
            end;

        }
        //mbr 6/20/25 - end

        field(94; "Days differences earliest"; Integer)
        {
            Caption = 'Shipment Arrival Analysis (Days)';
            ToolTip = 'If there is QTY on Sales Order, Shipment arrival days = Earliest Start Ship Date – Estimated in Whs Date.  If there is no QTY on Sales Order, Shipment arrival days = Request in Whs Date – Estimated in Whs Date';
        }
        field(95; "Item Description Snapshot"; Text[100])
        {
            Caption = 'Item Description Snapshot';
            Editable = false;
        }
        // 7/23/25 - start
        field(96; "FDA Hold Date"; Date)
        {
            Caption = 'FDA Hold Date';
            Editable = false;
        }
        field(97; "FDAHoldEmailNotifiSentDate"; Date)
        {
            Caption = 'FDA Hold Email Notification Sent Date';
            //  Editable = false;
        }
        field(98; "FDAReleasedEmailNotifiSentDate"; Date)
        {
            Caption = 'FDA Released Email Notification Sent Date';
            Editable = false;
        }
        field(99; "FDA Released Date"; Date)
        {
            Caption = 'FDA Released Date';
            Editable = false;
        }
        // 7/23/25 - end
        //10/2/25 - start
        field(100; InterStateTransferNeeded; Boolean)
        {
            Caption = 'InterState Transfer Needed';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.InterStateTransferNeeded where("No." = field("Item No.")));
        }
        //10/2/25 - end

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
    var
        PurchLines: Record "Purchase Line";
        UOM: Record "Unit of Measure";

        purchReceipt: Record "Purch. Rcpt. Line";
        txtErrPurRcpt: Label 'You cannot delete Line no %1 Item %2 because there is a Purch. Rcpt. %3 and Transfer Order No. %4 associated with it.  Please goto Transfer Order and remove the Container No.';
        popupConfirm: Page "Confirmation Dialog";
        txtPurRcptConfirm: Label 'Line no %1 Item %2 has a Purch. Rcpt. %3 associated with it.  Do you still want to delete?';
        txtAbort: Label 'Task Aborted.';
        GenCU: Codeunit GeneralCU;

    trigger OnDelete()
    begin
        // pr 6/4/24
        purchReceipt.Reset();
        purchReceipt.SetRange("Order No.", Rec."Document No.");
        purchReceipt.SetRange("No.", Rec."Item No.");
        purchReceipt.SetRange(Type, purchReceipt.Type::Item);
        purchReceipt.SetRange(Quantity, Rec.Quantity);
        purchReceipt.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
        if (purchReceipt.FindFirst()) then begin
            if strlen(Rec."Transfer Order No.") > 0 then
                Error(StrSubstNo(txtErrPurRcpt, Rec."Document Line No.", Rec."Item No.", purchReceipt."Document No.", Rec."Transfer Order No."))
            else begin
                Clear(popupConfirm);
                popupConfirm.setMessage(strsubstno(txtPurRcptConfirm, Rec."Document Line No.", Rec."Item No.", purchReceipt."Document No."));
                Commit;
                if popupConfirm.RunModal() = Action::No then
                    Error(txtAbort)
            end;
        end;

        PurchLines.reset;
        PurchLines.SetRange("Document No.", Rec."Document No.");
        PurchLines.SetRange("Document Type", PurchLines."Document Type"::Order);
        PurchLines.SetRange("Line No.", Rec."Document Line No.");
        PurchLines.SetRange(Type, PurchLines.Type::Item);
        PurchLines.SetRange("No.", Rec."Item No.");
        IF PurchLines.FindFirst() then begin
            PurchLines.AssignedToContainer := false;
            PurchLines."Container No." := '';
            PurchLines."Qty Assigned to Container" := PurchLines."Qty Assigned to Container" - Rec.Quantity;

            PurchLines.Modify();
        end;

    end;

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

    procedure GetUserNameFromSecurityId(UserSecurityID: Guid): Code[50]
    var
        User: Record User;
    begin
        IF User.Get(UserSecurityID) then
            exit(User."User Name");
    end;

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
        ArchPurchaseLine: Record "Purchase Line Archive";
        bFound: boolean;
        lineNo: code[20];
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
        rec."Transfer Line Quantity" := 0;  //initialize;
        rec.DeliveryNotes := '';
        Rec.CalcFields("M-Pack Height", "M-Pack Length", "M-Pack Width", "M-Pack Qty", "M-Pack Weight kg",
        Rec."Order Date", rec."Actual Pull Date", rec."Actual Delivery Date", rec."Container Return Date",
        rec.POUserId, rec."Actual Pull Time", Rec.POUserID, Rec.PONoFromTO, Rec.POOwnerFromTO, rec.Urgent,
        rec."M-Pack Qty", rec."Container Status Notes", "Transfer Order No.", rec.POCustCode,
        rec.PRCustCode, rec.POCustRespCtr, rec.PRCustRespCtr, rec."Manufacturer Code", rec.InterStateTransferNeeded,
        rec."Location Code", rec."Port of Discharge", rec."Port of Loading");
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
        // PR 4/15/25 - first macth "Container Line No." and rec."Document Line No." if "Container Line No."<>0 if nopt then macth "Line No." and rec."Document Line No." - start
        //PR 3/24/25 - start - Transfer line Quantity is NOT accurate.  It should find by Transfer order NO, Container Line NO and Item No.  
        //TransferLine.SetRange("Container Line No.", rec."Document Line No.");
        //PR 3/24/25 - end
        // PR 4/15/25 - first macth "Container Line No." and rec."Document Line No." if "Container Line No."<>0 if nopt then macth "Line No." and rec."Document Line No." - end
        TransferLine.SetRange("Item No.", rec."Item No.");
        bFound := false;
        if (TransferLine.FindSet()) then begin
            repeat
                if (TransferLine."Container Line No." <> 0) and (TransferLine."Container Line No." = rec."Document Line No.") then begin
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
                end
                // PR 4/15/25 if contaier line no is 0 use line no to macth with doc line no instead - start
                else if (TransferLine."Container Line No." = 0) and (TransferLine."Line No." = rec."Document Line No.") then begin
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
                end
            // PR 4/15/25 if contaier line no is 0 use line no to macth with doc line no instead - end
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
            Rec."Production Status" := PurLin."Production Status";
            // if(StrLen(rec.CustCode)<=0)then 
            // rec.CustCode:=PurLin.code
        end

        else begin
            PRLine.Reset();
            PRLine.SetRange("Order No.", Rec.PONo);
            PRLine.SetRange(Type, PRLine.Type::Item);
            PRLine.SetRange("No.", Rec."Item No.");
            IF PRLine.FindFirst() then begin
                Rec.CalcFields(PRCustRespCtr);
                Rec."Customer Responsibility Center" := Rec.PRCustRespCtr;
                Rec."Production Status" := PRLine."Production Status";
                // if (StrLen(rec.CustCode) <= 0) then
                // rec.CustCode := PRLine.cu
            end;

        end;
        //PR 2/14/235 - update PO Vendor - start
        POHdr.Reset();
        POHdr.SetRange("Document Type", POHdr."Document Type");
        POHdr.SetRange("No.", Rec."PONo");
        if POHdr.FindSet() then begin
            Rec."PO Vendor" := pohdr."Buy-from Vendor No.";
            Rec."Your Reference" := POHdr."Your Reference";
            Rec.Modify();
        end
        else begin
            PostedPurchRcpt.Reset();
            PostedPurchRcpt.SetRange("Order No.", Rec."PONo");
            if PostedPurchRcpt.FindFirst() then begin
                rec."PO Vendor" := PostedPurchRcpt."Buy-from Vendor No.";
                Rec."Your Reference" := PostedPurchRcpt."Your Reference";
            end
            else begin
                ArchPurchaseHeader.Reset();
                ArchPurchaseHeader.SetCurrentKey("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
                ArchPurchaseHeader.SetRange("Document Type", ArchPurchaseHeader."Document Type"::Order);
                ArchPurchaseHeader.SetRange("No.", Rec."PONo");
                ArchPurchaseHeader.Ascending(false);
                if ArchPurchaseHeader.FindFirst() then begin
                    Rec."PO Owner" := ArchPurchaseHeader.CreatedUserID;
                    Rec."Your Reference" := ArchPurchaseHeader."Your Reference";
                end;
            end;
        end;
        if (rec.PONo = 'PO003585') then begin
            //  message('-');
        end;
        // 9/4/25 - updates item description snapshot - start
        if (rec."Item Description Snapshot" = '') then begin
            PurLin.Reset();
            PurLin.SetRange("Document Type", PurLin."Document Type"::Order);
            PurLin.SetRange("Document No.", Rec.PONo);
            PurLin.SetRange(Type, PurLin.Type::Item);
            PurLin.SetRange("No.", Rec."Item No.");
            IF PurLin.FindFirst() THEN BEGIN
                rec."Item Description Snapshot" := PurLin.Description;
            END
            else begin
                PRLine.Reset();
                PRLine.SetRange("Order No.", Rec.PONo);
                PRLine.SetRange(Type, PRLine.Type::Item);
                PRLine.SetRange("No.", Rec."Item No.");
                PRLine.SetRange("Line No.", Rec."Document Line No.");
                IF PRLine.FindFirst() then begin
                    rec."Item Description Snapshot" := PRLine.Description;
                end
                else begin
                    ArchPurchaseHeader.Reset();
                    ArchPurchaseHeader.SetRange("Document Type", ArchPurchaseHeader."Document Type"::Order);
                    ArchPurchaseHeader.SetRange("No.", Rec.PONo);
                    ArchPurchaseHeader.SetCurrentKey("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
                    ArchPurchaseHeader.Ascending(false);
                    if ArchPurchaseHeader.FindFirst() then begin
                        ArchPurchaseLine.Reset();
                        ArchPurchaseLine.SetRange("Document Type", ArchPurchaseLine."Document Type"::Order);
                        ArchPurchaseLine.SetRange("Document No.", Rec.PONo);
                        ArchPurchaseLine.SetRange(Type, ArchPurchaseLine.Type::Item);
                        ArchPurchaseLine.SetRange("No.", Rec."Item No.");
                        ArchPurchaseLine.SetRange("Doc. No. Occurrence", ArchPurchaseHeader."Doc. No. Occurrence");
                        ArchPurchaseLine.SetRange("Version No.", ArchPurchaseHeader."Version No.");
                        if ArchPurchaseLine.FindFirst() then begin
                            rec."Item Description Snapshot" := ArchPurchaseLine.Description;
                        end;

                    end;
                end;

            end;
        end;
        // 9/4/25 - updates item description snapshot - end

        // 9/4/25 - updates delivery notes - start
        if (rec.DeliveryNotes = '') then begin
            PurLin.Reset();
            PurLin.SetRange("Document No.", Rec.PONo);
            PurLin.SetRange(Type, PurLin.Type::Item);
            PurLin.SetRange("No.", Rec."Item No.");
            If PurLin.FindFirst() then begin
                PurLin.CalcFields("Real Time Item Description");
                rec.DeliveryNotes := PurLin.DeliveryNotes;
            end
            else begin
                // Fallback: Try without Line No. filter for Posted Receipts too
                PRLine.Reset();
                PRLine.SetRange("Order No.", Rec.PONo);
                PRLine.SetRange(Type, PRLine.Type::Item);
                PRLine.SetRange("No.", Rec."Item No.");
                IF PRLine.FindFirst() then begin
                    PRLine.CalcFields("Real Time Item Description");
                    rec.DeliveryNotes := PRLine.DeliveryNotes;
                end;
            end;
        end;
        // 9/4/25 - updates delivery notes - end


        rec.UpdateActualETAvsETA();
        rec.UpdateActualETDvsCRD();
        rec.GetLotNo();
        Rec.CalcFields(Salesperson);
        Rec.Modify();
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

    procedure CalcActualETDvsCRD(): Integer
    begin
        if (Rec."ActualETD" <> 0D) and (Rec.ActualCargoReadyDate <> 0D) then
            exit(Rec."ActualETD" - Rec.ActualCargoReadyDate);
        exit(0);
    end;

    procedure CalcActualVersus()
    begin
        // rec."Actual ETD vs Actual CRD":=
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

    procedure UpdateNewItem()
    var
        itemledgerentry: Record "Item Ledger Entry";
    begin
        itemledgerentry.reset();
        itemledgerentry.SetCurrentKey("Entry Type", "Item No.");
        itemledgerentry.SetFilter("Entry Type", '%1|%2|%3', itemledgerentry."Entry Type"::"Positive Adjmt.", itemledgerentry."Entry Type"::Purchase, itemledgerentry."Entry Type"::"Assembly Output");

        itemledgerentry.setrange("Item No.", rec."Item No.");

        if itemledgerentry.findset() then
            rec."New Item" := false
        else
            rec."New Item" := true;
        // rec.Modify();
    end;

    procedure CalcEarliestDifDate()
    begin
        if (rec."Earliest Start Ship Date" <> 0D) and (rec.EstimatedInWarehouseDate <> 0D) then begin
            rec."Days differences earliest" := rec."Earliest Start Ship Date" - rec.EstimatedInWarehouseDate;
        end
        else if (rec."Earliest Start Ship Date" = 0D) and (rec.EstimatedInWarehouseDate <> 0D) and (rec."Requested In Whse Date" <> 0D) then begin
            rec."Days differences earliest" := rec."Requested In Whse Date" - rec.EstimatedInWarehouseDate;
        end
        else
            rec."Days differences earliest" := 0;
        //rec.Modify();
    end;

    trigger OnInsert()
    begin
        GenCU.UpdateEarliestStartShipDateContainer(Rec);
    end;

    trigger OnModify()
    begin
        GenCU.UpdateEarliestStartShipDateContainer(Rec);
    end;

}