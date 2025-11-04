pageextension 50022 "Ship-toAddressListExt" extends "Ship-to Address List"
{
    layout
    {
        addafter("Code")
        {
            field(CustomerShipToCode; Rec.CustomerShipToCode)
            {
                ApplicationArea = All;
            }
            field(TransitDays; Rec.TransitDays)
            {
                ApplicationArea = All;
            }
        }


    }
}
