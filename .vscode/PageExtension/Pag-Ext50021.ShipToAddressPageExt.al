pageextension 50021 "Ship-toAddressExt" extends "Ship-to Address"
{
    layout
    {
        addafter("Code")
        {
            field(TransitDays; Rec.TransitDays)
            {
                ApplicationArea = All;
            }
            field(CustomerShipToCode; Rec.CustomerShipToCode)
            {
                ApplicationArea = All;
            }

        }


    }
}
