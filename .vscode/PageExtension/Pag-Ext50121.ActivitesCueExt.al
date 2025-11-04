pageextension 50121 RoleCenterActivitesExt extends "O365 Activities"
{

    layout
    {

        // addafter()
        addafter("Overdue Purch. Invoice Amount")
        {
            field(glAcoountSum; glAcoountSum)
            {
                Caption = 'MTD Gross Sales';
                ApplicationArea = Basic, Suite;
                AutoFormatExpression = GetAmountFormat();
                AutoFormatType = 11;
                DecimalPlaces = 0 : 0;

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        glAcoountSum := 0;
        startDate := CalcDate('<-CM>', Today);
        glEntry.Reset;
        glEntry.SetFilter("G/L Account No.", '%1', '4*');
        glEntry.SetFilter("Posting Date", '%1..%2', startDate, Today());
        if (glEntry.FindSet()) then
            repeat
                glAcoountSum += glEntry.Amount;
            until glEntry.next() = 0;
        glAcoountSum := abs(glAcoountSum);
    end;

    var
        glAcoountSum: Decimal;
        glEntry: Record "G/L Entry";
        startDate: date;

    local procedure GetAmountFormat(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        AmountFormat: Text;
    begin
        AmountFormat := TypeHelper.GetAmountFormatLCYWithUserLocale().Trim();
        if AmountFormat = GetDefaultAmountFormat() then
            exit('$' + GetDefaultAmountFormat());

        exit(AmountFormat);
    end;

    internal procedure GetDefaultAmountFormat(): Text
    begin
        exit('<Precision,0:0><Standard Format,0>');
    end;
}
