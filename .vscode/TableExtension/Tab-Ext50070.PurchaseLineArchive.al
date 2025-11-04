tableextension 50070 "Purchase Line Archive" extends "Purchase Line Archive"
{
    fields
    {
        field(50001; DoNotShipBeforeDate; Date)
        {
            Caption = 'Do Not Ship Before Date';
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header Archive"."DoNotShipBeforeDate" WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(50002; RequestedCargoReadyDate; Date)
        {
            Caption = 'Requested Cargo Ready Date';
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header Archive"."RequestedCargoReadyDate" WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(50003; RequestedInWhseDate; Date)
        {
            Caption = 'Requested In Whse Date';
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header Archive"."RequestedInWhseDate" WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(50005; "Port Of Loading"; Code[20])
        {
            Caption = 'Port of Loading';
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header Archive"."Port of Loading" WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
            TableRelation = "Port of Loading".Port;


        }
        field(50006; "Assigned User ID"; Code[50])
        {
            Caption = 'Owner';
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header Archive"."Assigned User ID" WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
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

            CalcFormula = lookup("Purchase Header Archive"."Buy-from Vendor No." WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
            TableRelation = Vendor."No.";

        }
        field(50018; "Port Of Discharge"; Code[20])
        {
            Caption = 'Port of Discharge';
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header Archive"."Port of Discharge" WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
            TableRelation = "Port of Loading".Port;

        }
        field(50019; "Forwarder"; Code[10])
        {
            Caption = 'Forwarder';
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header Archive".Forwarder WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
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
            Editable = false;
        }
        field(50024; Status; Enum "Purchase Document Status")
        {
            Caption = 'Status';
            Editable = false;
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header Archive".Status WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));

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

            CalcFormula = lookup("Purchase Header Archive".CreatedUserID WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(50032; CreatedDate; Date)
        {
            Caption = 'Created Date';
            Editable = false;
            FieldClass = FlowField;

            CalcFormula = lookup("Purchase Header Archive".CreatedDate WHERE("No." = field("Document No."), "Document Type" = field("Document Type")));
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
    }
}
