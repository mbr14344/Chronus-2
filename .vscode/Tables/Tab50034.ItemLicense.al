table 50034 ItemLicense
{
    // pr 6/13/24 made item license table
    Caption = 'ItemLicense';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[30])
        {
            Caption = 'Item No.';
            //TableRelation = Item."No.";
            trigger OnValidate()
            var
                item: Record item;
            begin
                item.Reset();
                item.SetRange("No.", Rec."Item No.");
                if (item.FindFirst()) then begin
                    rec."Item Description" := item.Description;
                    rec."Quantity on Hand" := item.Inventory;
                    rec."Qty on Purchase Order" := item."Qty. on Purch. Order";
                    rec."Qty on Transfer Order" := item."Qty on Transfer Orders";
                    rec."Qty on Assembly Order" := item."Qty. on Assembly Order";
                    rec."Qty on Purchase Order" := item."Qty. on Purch. Order";
                end;

            end;


        }
        field(2; License; Code[30])
        {
            Caption = 'License'; //ddlist
            TableRelation = LicenseOwner.License;
        }
        field(3; Sublicense; Code[80])
        {
            Caption = 'Sublicense'; //ddlist
            TableRelation = SubLicenseHeader.SubLicense where(License = field(License));
        }
        field(4; "Expiration Date"; date)
        {
            Caption = 'Exp Date';  //formfield
            FieldClass = FlowField;
            CalcFormula = lookup(SubLicenseHeader."Expiration Date" where("SubLicense" = field("Sublicense"), License = field(License)));
        }
        field(5; "Quantity on Hand"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No.")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(6; "Qty on Purchase Order"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                                    Type = const(Item),
                                                                                    "No." = field("Item No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(7; "Qty on Sales Order"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                              Type = const(Item),
                                                                              "No." = field("Item No.")));
            Caption = 'Qty. on Sales Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(8; "Qty on Transfer Order"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Transfer Line"."Quantity" WHERE("Item No." = FIELD("Item No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(9; "Qty on Assembly Order"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Assembly Header"."Remaining Quantity (Base)" where("Document Type" = const(Order),
                                                                                   "Item No." = field("Item No.")));

            Caption = 'Qty. on Assembly Order';
            DecimalPlaces = 0 : 5;
            Editable = false;



        }
        field(10; "Item Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(11; "License Percentage"; Decimal)
        {
            Caption = 'License Percentage';
            DecimalPlaces = 0 : 5;
        }

    }

    keys
    {

        key(PK;
        "Item No.", License, Sublicense)
        {
            Clustered = true;
        }


    }

    trigger OnInsert()
    begin
        //10/2/25 - only allow insert if user is marked as Item Admin in User Setup
        UserSetup.Get(UserId);
        if UserSetup."Item Admin" = false then
            Error(txtNotAdminMod);

        "License Percentage" := 1;
    end;

    trigger OnModify()
    begin
        //10/2/25 - only allow modify if user is marked as Item Admin in User Setup
        UserSetup.Get(UserId);
        if UserSetup."Item Admin" = false then
            Error(txtNotAdminMod);
    end;

    trigger OnDelete()
    begin
        //10/2/25 - only allow delete if user is marked as Item Admin in User Setup
        UserSetup.Get(UserId);
        if UserSetup."Item Admin" = false then
            Error(txtNotAdminMod);
    end;

    var
        txtNotAdminMod: Label 'You are not allowed to modify Item License as you are not marked as Item Admin in User Setup. Please contact your system administrator.';
        UserSetup: Record "User Setup";

}
