tableextension 50023 TafiffNumberExt extends "Tariff Number"
{
    fields
    {
        field(50001; "Duty Percent"; Decimal)
        {
            Caption = 'Duty Percent';
            DataClassification = ToBeClassified;
        }
        field(50002; "Tariff Percent"; Decimal)
        {
            Caption = 'Tariff Percent';
            DataClassification = ToBeClassified;
        }
    }
}
