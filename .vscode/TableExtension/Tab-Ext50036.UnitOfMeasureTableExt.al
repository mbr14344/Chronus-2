tableextension 50036 UnitOfMeasureTableExt extends "Unit of Measure"
{
    fields
    {
        field(50000; "Convert Down Unit"; Decimal)
        {
            Caption = 'Convert Down Unit';
            DecimalPlaces = 0 : 5;
        }
        field(50001; "Convert Up Unit"; Decimal)
        {
            Caption = 'Convert Up Unit';
            DecimalPlaces = 0 : 5;
        }
    }
}
