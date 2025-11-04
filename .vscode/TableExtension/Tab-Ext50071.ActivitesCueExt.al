tableextension 50071 ActivitesCueExt extends "Activities Cue"
{
    fields
    {
        field(50001; "G\L Acoount Sum"; Decimal)
        {
            Caption = '';
            FieldClass = FlowField;

            // CalcFormula = sum("G/L Entry".Amount where(acc))
        }
    }
}
