table 50035 "Item Attribute Line"
{
    Caption = 'Item Attributes Line';
    DataClassification = ToBeClassified;
    //TableType = Temporary;
    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = '';
        }
        field(2; Value; Text[250])
        {

        }
        field(3; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(4; "Attribute ID"; Integer)
        {
            Caption = 'Attribute ID';
            NotBlank = true;
            TableRelation = "Item Attribute".ID where(Blocked = const(false));
        }
        field(5; "Attribute Name"; Text[250])
        {
            CalcFormula = Lookup("Item Attribute".Name where(ID = field("Attribute ID")));
            Caption = 'Attribute Name';
            FieldClass = FlowField;
        }
        field(6; "Numeric Value"; Decimal)
        {
            BlankZero = true;
            Caption = 'Numeric Value';

            trigger OnValidate()
            var
                ItemAttribute: Record "Item Attribute";
            begin
                if xRec."Numeric Value" = "Numeric Value" then
                    exit;

                ItemAttribute.Get("Attribute ID");
                Validate(Value, Format("Numeric Value", 0, 9));
            end;
        }
        field(7; "Date Value"; Date)
        {
            Caption = 'Date Value';

            trigger OnValidate()
            var
                ItemAttribute: Record "Item Attribute";
            begin
                if xRec."Date Value" = "Date Value" then
                    exit;

                ItemAttribute.Get("Attribute ID");
                if ItemAttribute.Type = ItemAttribute.Type::Date then
                    Validate(Value, Format("Date Value"));
            end;
        }
        field(8; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
    }
    keys
    {
        key(PK; "Item No.", "Attribute ID", ID)
        {
            Clustered = true;
        }
    }
}
