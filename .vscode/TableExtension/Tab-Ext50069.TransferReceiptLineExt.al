tableextension 50069 TransferReceiptLineExt extends "Transfer Receipt Line"
{
    fields
    {

        field(50000; "Telex Released"; Boolean)
        {
            Caption = 'Telex Released';
            DataClassification = ToBeClassified;
        }
        field(50002; "Posting Date"; date)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header"."Posting Date" where("No." = field("Document No.")));
        }
        field(50003; "Container No."; code[50])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header"."Container No." where("No." = field("Document No.")));
        }
        field(50004; "Actual ETD"; Date)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header".ActualETD where("No." = field("Document No.")));
        }
        field(50005; "Actual ETA"; Date)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header".ActualETA where("No." = field("Document No.")));
        }
        field(50006; "Purchasing Code"; code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Purchasing Code" where("No." = field("Item No.")));
        }
        field(50007; "Telex Updated By"; Code[50])
        {
            Editable = false;
        }
        field(50008; "Telex Updated Date"; Date)
        {
            Editable = false;
        }
        //PR 3/6/25 - start
        field(50009; "PO No."; code[20])
        {
            Editable = false;
        }
        field(50010; "PO Owner"; code[20])
        {
            Editable = false;
        }
        //PR 3/6/25 - end
        //mbr 3/11/25 - start
        field(50051; "CustCode"; code[20])
        {
            Caption = 'Cust Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
        //mbr 3/11/25 - end
        //mbr 03/25/25 - start
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
            CalcFormula = lookup("Transfer Receipt Header"."944 Receipt No." WHERE("No." = FIELD("Document No.")));
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
        //mbr 03/25/25 - end
        //pr 6/20/25 - start
        field(50069; "Lot No."; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."Lot No." where("Entry Type" = const("Item Ledger Entry Type"::"Transfer"),
                                                                 "Document Type" = const("Item Ledger Document Type"::"Transfer Receipt"),
                                                                 "Document No." = FIELD("Document No."),
                                                                 "Item No." = FIELD("Item No.")));



            Editable = false;
        }
        field(50070; "Expiration Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."Expiration Date" where("Entry Type" = const("Item Ledger Entry Type"::"Transfer"),
                                                                 "Document Type" = const("Item Ledger Document Type"::"Transfer Receipt"),
                                                                 "Document No." = FIELD("Document No."),
                                                                 "Item No." = FIELD("Item No.")));



            Editable = false;
        }
        field(50071; Urgent; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header".Urgent Where("No." = field("Document No.")));
            Editable = false;
        }
        // pr 6/20/25 - end
        //10/3/25 - start
        field(50072; "M-Pack Qty"; Decimal)
        {
            Caption = 'M-Pack Qty';
            FieldClass = FlowField;
            DecimalPlaces = 0;
            CalcFormula = lookup("Item Unit of Measure"."Qty. per Unit of Measure" WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(50073; "M-Pack Weight"; Decimal)
        {
            Caption = 'M-Pack Weight (lbs)';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure"."Weight" WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(50074; "M-Pack Weight kg"; Decimal)
        {
            Caption = 'M-Pack Weight (kg)';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure"."Weight kgs" WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(50075; "M-Pack Height"; Decimal)
        {
            Caption = 'M-Pack Height';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Height WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(50076; "M-Pack Length"; Decimal)
        {
            Caption = 'M-Pack Length';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Length WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        field(50077; "M-Pack Width"; Decimal)
        {
            Caption = 'M-Pack width';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure".Width WHERE("Item No." = field("Item No."), Code = CONST('M-PACK')));
        }
        //10/3/25 - end
    }
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
