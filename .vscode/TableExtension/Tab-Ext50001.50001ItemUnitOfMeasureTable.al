tableextension 50001 "50001_ItemUnitOfMeasureTable" extends "Item Unit of Measure"
{
    fields
    {
        modify(Length)
        {
            Caption = 'Length (in)';
        }
        modify(Height)
        {
            Caption = 'Height (in)';
        }
        modify(Width)
        {
            Caption = 'Width (in)';
        }
        field(50001; Ti; Integer)
        {

        }
        field(50002; Hi; Integer)
        {

        }
        field(50003; UPCCode; Code[20])
        {
            Caption = 'UPC Code';
        }
        field(50004; Notes; Text[50])
        {
            Caption = 'Notes';
        }
        field(50005; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        modify(Weight)
        {
            Caption = 'Weight (lbs)';
            trigger OnAfterValidate()
            var
                UOM: Record "Unit of Measure";
            begin
                if rec.Weight <> xrec.Weight then begin
                    UOM.Reset();
                    if UOM.get('LB') then;
                    if UOM."Convert Up Unit" > 0 then begin
                        rec."Weight kgs" := rec.Weight * UOM."Convert Up Unit";
                    end;
                end;

            end;

        }
        field(50006; "Weight kgs"; Decimal)
        {
            Caption = 'Weight (kgs)';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            var
                UOM: Record "Unit of Measure";
            begin
                if rec."Weight kgs" <> xrec."Weight kgs" then begin
                    UOM.Reset();
                    if UOM.get('KG') then;
                    if UOM."Convert Down Unit" > 0 then begin
                        rec."Weight" := rec."Weight kgs" * UOM."Convert Down Unit";
                    end;
                end;
            end;

        }

    }


}