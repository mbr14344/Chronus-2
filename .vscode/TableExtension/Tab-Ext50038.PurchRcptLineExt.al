tableextension 50038 PurchRcptLineExt extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50001; DoNotShipBeforeDate; Date)
        {
            Caption = 'Do Not Ship Before Date';
            FieldClass = FlowField;

            CalcFormula = lookup("Purch. Rcpt. Header"."DoNotShipBeforeDate" WHERE("No." = field("Document No.")));
        }
        field(50002; RequestedCargoReadyDate; Date)
        {
            Caption = 'Requested Cargo Ready Date';
            FieldClass = FlowField;

            CalcFormula = lookup("Purch. Rcpt. Header"."RequestedCargoReadyDate" WHERE("No." = field("Document No.")));
        }
        field(50003; RequestedInWhseDate; Date)
        {
            Caption = 'Requested In Whse Date';
            FieldClass = FlowField;

            CalcFormula = lookup("Purch. Rcpt. Header"."RequestedInWhseDate" WHERE("No." = field("Document No.")));
        }
        field(50005; "Port Of Loading"; Code[20])
        {
            Caption = 'Port of Loading';
            FieldClass = FlowField;

            CalcFormula = lookup("Purch. Rcpt. Header"."Port of Loading" WHERE("No." = field("Document No.")));
            TableRelation = "Port of Loading".Port;


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

            CalcFormula = lookup("Purch. Rcpt. Header"."Buy-from Vendor No." WHERE("No." = field("Document No.")));
            TableRelation = "User Setup";

        }
        field(50018; "Port Of Discharge"; Code[20])
        {
            Caption = 'Port of Discharge';
            FieldClass = FlowField;

            CalcFormula = lookup("Purch. Rcpt. Header"."Port of Discharge" WHERE("No." = field("Document No.")));
            TableRelation = "Port of Loading".Port;

        }
        field(50019; "Forwarder"; Code[10])
        {
            Caption = 'Forwarder';
            FieldClass = FlowField;

            CalcFormula = lookup("Purch. Rcpt. Header".Forwarder WHERE("No." = field("Document No.")));
            TableRelation = "Shipping Agent".Code;

        }
        field(50020; "AssignedToContainer"; boolean)
        {
            Caption = 'Assigned to Container';

        }
        field(50021; ActualCargoReadyDate; Date)
        {
            Caption = 'Actual Cargo Ready Date';


        }
        field(50022; EstimatedInWarehouseDate; Date)
        {
            Caption = 'Estimated In-Warehouse Date';
        }
        field(50023; "Container No."; Code[50])
        {
            Caption = 'Container No.';
            TableRelation = "Container Header";
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
        //9/4/25 - start
        field(50029; "Real Time Item Description"; Text[100])
        {
            Caption = 'Real Time Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description WHERE("No." = field("No.")));
        }
        //9/4/25 - end

    }

    var
        UOM: Record "Unit of Measure";
        GetDt: Date;

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
}
