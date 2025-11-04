pageextension 50118 GLAccountCardExt extends "G/L Account Card"
{
    layout
    {
        addafter("Account Category")
        {
            field("Reverse Sign Power BI Custom"; Rec."Reverse Sign Power BI Custom")
            {
                ApplicationArea = All;
                Caption = 'Reverse Sign Power BI Custom';
            }
        }

    }
}
