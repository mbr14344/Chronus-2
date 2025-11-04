tableextension 50043 "Assembly Lines Ext Table" extends "Assembly Line"
{
    fields
    {


        field(50000; "Parent Item No."; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Assembly Header"."Item No." WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }

        field(50001; "Parent Item Description"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Assembly Header".Description WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }

        field(50002; "Posting Date"; Date)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Assembly Header"."Posting Date" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }


        field(50004; ParentItemQuantity; Decimal)
        {
            Caption = 'Item Quantity';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
            CalcFormula = lookup("Assembly Header".Quantity WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }



        field(50005; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
            FieldClass = FlowField;
            CalcFormula = lookup("Assembly Header".Status WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50006; "Parent Item Description 2"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Assembly Header"."Description 2" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
    }
    trigger OnInsert()

    begin
        CALCFIELDS("Parent Item No.");
        "Description 2" := 'For ' + "Parent Item No.";
    end;
}