tableextension 50104 ShipToAddressExt extends "Ship-to Address"
{
    fields
    {
        field(50001; CustomerShipToCode; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Ship-to Code';
        }
        field(50002; TransitDays; DateFormula)
        {
            Caption = 'Transit Days';
            DataClassification = CustomerContent;
        }

    }
}
