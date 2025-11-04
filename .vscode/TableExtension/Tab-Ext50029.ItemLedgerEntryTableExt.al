tableextension 50029 ItemLedgerEntryTableExt extends "Item Ledger Entry"
{
    fields
    {
        field(50001; "Sales Shipment Source No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Order No." WHERE("No." = field("Document No.")));
        }
        field(50002; "Purchase Receipt Source No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."Order No." WHERE("No." = field("Document No.")));
        }
        field(50003; "Item Description Cust"; Text[100])
        {
            Caption = 'Real Time Item Description';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(50004; "Purch. Order No."; Code[20])
        {
            Caption = 'Purch. Order No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."Order No." where("No." = field("Document No.")));
        }
        field(50005; "Purch. Inv. No."; Code[20])
        {
            Caption = 'Purch. Inv. No.';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Purch. Inv. Line";
            CalcFormula = lookup("Purch. Inv. Line"."Document No." where("Order No." = field("Purch. Order No."), "No." = field("Item No."), Type = const(2)));
        }
        field(50006; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Purch. Inv. Header";
            CalcFormula = lookup("Purch. Inv. Header"."Your Reference" where("No." = field("Purch. Inv. No.")));
        }
        field(50007; "Shelf No."; Code[10])
        {
            Caption = 'Shelf No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Shelf No." where("No." = field("Item No.")));
        }
        field(50008; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            FieldClass = FlowField;
            CalcFormula = Lookup(User."User Name" where("User Security ID" = FIELD(SystemCreatedBy)));
        }
        //MBR 2/25/25 - start
        field(50023; Brand; Code[30])
        {
            Caption = 'Brand';
            TableRelation = "Item Brand";
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Brand where("No." = field("Item No.")));
        }
        field(50024; "Sub-Brand"; Code[30])
        {
            Caption = 'Sub-Brand';
            TableRelation = "Item Sub Brand";
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Sub-Brand" where("No." = field("Item No.")));
        }
        //mbr 2/25/25 - end

        //mbr 3/5/25 - add Posted Sales Inv No - this will be a calculated field we will run on after get record of the page
        field(50026; "Sales Inv. No."; Code[20])
        {
            Caption = 'Sales. Inv. No.';
            Editable = false;
            TableRelation = "Sales Invoice Line";
        }
        //mbr 3/5/25 - end
        //mbr 3/7/25 - start
        field(50027; "Real Time Item Category Code"; Code[20])
        {
            Caption = 'Real Time Item Category Code';
            TableRelation = "Item Category";
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("Item No.")));
        }

        //mbr 3/7/25 - end
        //pr 5/30/25 - start
        field(50028; "Container No."; Code[50])
        {
            Caption = 'Container No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Shipment Header"."Container No." where("Transfer Order No." = field("Order No.")));
        }
        //pr 5/30/25 - end
        //mbr 6/9/25 - start
        field(50029; "License Exist"; Boolean)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist(ItemLicense WHERE("Item No." = Field("Item No.")));
        }
        //mbr 6/9/25 - end
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                PurchLines: Record "Purchase Line";
                TransLine: Record "Transfer Line";
                ContainerLine: Record ContainerLine;
            begin
                PurchLines.Reset();
                PurchLines.SetRange(Type, PurchLines.Type::Item);
                PurchLines.SetRange("No.", rec."Item No.");
                if (PurchLines.FindSet()) then
                    repeat
                        PurchLines.UpdateNewItem();
                        PurchLines.Modify();
                    until PurchLines.Next() = 0;

                ContainerLine.Reset();
                ContainerLine.SetRange("Item No.", rec."Item No.");
                if (ContainerLine.FindSet()) then
                    repeat
                        ContainerLine.UpdateNewItem();
                        ContainerLine.Modify();
                    until ContainerLine.Next() = 0;
            end;
        }
        // 8/12/25 - start 
        field(50030; "Item Type"; Enum "Item Type")
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Type where("No." = field("Item No.")));
        }
        // 8/12/25 - end

    }
    keys
    {
        key(KeyEntrySource; "Entry No.", "Source Type", "Source No.")
        {
        }
    }
    trigger OnAfterInsert()
    var
        PurchLines: Record "Purchase Line";
        TransLine: Record "Transfer Line";
        ContainerLine: Record ContainerLine;
    begin
        PurchLines.Reset();
        PurchLines.SetRange(Type, PurchLines.Type::Item);
        PurchLines.SetRange("No.", rec."Item No.");
        if (PurchLines.FindSet()) then
            repeat
                PurchLines.UpdateNewItem();
                PurchLines.Modify();
            until PurchLines.Next() = 0;

        ContainerLine.Reset();
        ContainerLine.SetRange("Item No.", rec."Item No.");
        if (ContainerLine.FindSet()) then
            repeat
                ContainerLine.UpdateNewItem();
                ContainerLine.Modify();
            until ContainerLine.Next() = 0;
    end;

    trigger OnAfterDelete()
    var
        PurchLines: Record "Purchase Line";
        TransLine: Record "Transfer Line";
        ContainerLine: Record ContainerLine;
    begin
        PurchLines.Reset();
        PurchLines.SetRange(Type, PurchLines.Type::Item);
        PurchLines.SetRange("No.", rec."Item No.");
        if (PurchLines.FindSet()) then
            repeat
                PurchLines.UpdateNewItem();
                PurchLines.Modify();
            until PurchLines.Next() = 0;

        ContainerLine.Reset();
        ContainerLine.SetRange("Item No.", rec."Item No.");
        if (ContainerLine.FindSet()) then
            repeat
                ContainerLine.UpdateNewItem();
                ContainerLine.Modify();
            until ContainerLine.Next() = 0;
    end;
}
