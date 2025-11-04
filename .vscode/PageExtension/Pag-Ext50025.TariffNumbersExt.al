pageextension 50025 TariffNumbersExt extends "Tariff Numbers"
{
    layout
    {
        addafter(Description)
        {
            field("Duty Percent"; Rec."Duty Percent")
            {
                ApplicationArea = All;
            }
            field("Tariff Percent"; Rec."Tariff Percent")
            {
                ApplicationArea = All;
            }
        }


    }
}
