tableextension 50103 ItemReference extends "Item Reference"
{
    fields
    {
        field(50000; Length; Decimal)
        {
            Caption = 'Length';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                CalcCubage();
            end;
        }
        field(50001; Width; Decimal)
        {
            Caption = 'Width';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                CalcCubage();
            end;
        }
        field(50002; Height; Decimal)
        {
            Caption = 'Height';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                CalcCubage();
            end;
        }
        field(50003; Cubage; Decimal)
        {
            Caption = 'Cubage';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
    }
    procedure GetDimensionM() ReturnValue: Decimal
    var
        result: Decimal;
        itemUOM: Record "Item Unit of Measure";
        UOM: Record "Unit of Measure";
    begin
        result := 0;

        UOM.Reset();
        if UOM.get('M') then;
        if UOM."Convert Up Unit" > 0 then begin
            result := Cubage * UOM."Convert Up Unit" * UOM."Convert Up Unit" * UOM."Convert Up Unit";
        end;
        ReturnValue := result;

    end;

    local procedure CalcCubage()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalcCubage(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        Cubage := Length * Width * Height;

        OnAfterCalcCubage(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcCubage(var ItemReference: Record "Item Reference"; var xItemReference: Record "Item Reference"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcCubage(var ItemReference: Record "Item Reference")
    begin
    end;

}