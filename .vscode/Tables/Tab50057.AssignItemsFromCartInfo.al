table 50057 AssignItemsFromCartInfo
{
    Caption = 'AssignItemsFromCartInfo';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Header"."No." where("Document Type" = field("Document Type"));
        }
        field(5; Type; Enum "Sales Line Type")
        {
        }
        field(11; Description; Text[100])
        {
        }

        field(14; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(15; "Unit Price"; Decimal)
        {
        }
        field(16; "Package Qty to Assign"; Decimal)
        {
            Caption = 'Package Cnt to Assign';
        }
        field(17; Quantity; Decimal)
        {
        }
        field(18; "Qty to Assign"; Decimal)
        {
            trigger OnValidate()
            begin
                rec."Remaining Qty To Assign" := rec.Quantity - "Assigned Qty" - rec."Qty to Assign";
                if (rec."M-Pack Qty" > 0) then begin
                    rec."Remaining Pkg To Assign" := ROUND("Remaining Qty To Assign" / rec."M-Pack Qty", 1, '<');
                    //  rec."Remaining Qty To Assign"
                end
                else
                    rec."Remaining Pkg To Assign" := 0;
                if (rec."M-Pack Qty" > 0) then begin
                    rec."Package Qty to Assign" := ROUND("Qty to Assign" / rec."M-Pack Qty", 1, '<')
                end
                else
                    rec."Package Qty to Assign" := 0;
                //  rec.Modify();
            end;
        }
        field(19; "Source Line No."; Integer)
        {
        }
        field(20; "Assigned Qty"; Decimal)
        {

            trigger OnValidate()
            begin
                if (rec."M-Pack Qty" > 0) then
                    rec."Assigned Packages" := ROUND(rec."Assigned Qty" / rec."M-Pack Qty", 1, '<')
                else
                    rec."Assigned Packages" := 0;
                //rec.Modify();
            end;
        }
        field(21; "Assigned Packages"; Integer)
        {

        }
        field(22; "Remaining Pkg To Assign"; Integer)
        {
        }
        field(23; "Remaining Qty To Assign"; Decimal)
        {
        }
        field(24; "SCC No."; code[20])
        {

        }
        field(25; "Cust No."; code[20])
        {

        }
        field(26; "M-Pack Qty"; Decimal)
        {

        }
        field(27; "M-Pack qty R/O"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure"."Qty. per Unit of Measure" where("Item No." = field("No."), Code = const('M-PACK')));
            Caption = 'M-Pack Qty';
        }

    }
    keys
    {
        key(PK; "No.", "Source Line No.", "Document No.")
        {
            Clustered = true;
        }
    }
}
