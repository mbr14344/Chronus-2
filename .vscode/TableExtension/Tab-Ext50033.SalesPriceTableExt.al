tableextension 50033 SalesPriceTableExt extends "Sales Price"
{
    fields
    {
        field(50000; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        //PR 17/25 - start
        field(50001; "Customer-Buyer"; Code[20])
        {
            TableRelation = Contact."No." where("Company Name" = field("Customer Name"), "Contact Business Relation" = const("Contact Business Relation"::Customer));
        }
        field(50002; "Item Reference"; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Reference"."Reference No." where("Item No." = field("Item No."), "Reference Type" = const("Item Reference Type"::Customer), "Reference Type No." = field("Sales Code")));
        }
        field(50003; "Customer Name"; Text[100])
        {

            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Name" where("No." = field("Sales Code")));


        }
        field(50004; "Customer-Buyer Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Contact.Name where("No." = field("Customer-Buyer"), "Contact Business Relation" = const("Contact Business Relation"::Customer)));
        }
        //PR 3/17/25 
        //MBR 3/19/25
        field(50005; "Retail Price"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 2;
            Caption = 'Retail Price';
            MinValue = 0;
        }
        field(50006; "Notes"; Text[50])
        {
            Caption = 'Notes';
        }
        field(50007; "User ID"; Code[20])
        {
            Editable = false;
        }
        field(50008; "Last Date Modified"; Date)
        {
            Editable = false;
        }

        //MBR 3/19/25
    }

    trigger OnBeforeModify()
    begin
        "User ID" := UserId;
        "Last Date Modified" := Today();
    end;

    trigger OnAfterInsert()

    begin
        "User ID" := UserId;
        "Last Date Modified" := Today();
        Modify();
    end;
}
