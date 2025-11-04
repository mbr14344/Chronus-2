pageextension 50086 PostedTransferShipmentSubform extends "Posted Transfer Shpt. Subform"
{
    layout
    {
        addafter("Custom Transit Number")
        {
            field("Purchasing Code"; Rec."Purchasing Code")
            {
                ApplicationArea = all;
            }
            field("Telex Released"; Rec."Telex Released")
            {
                ApplicationArea = All;
            }
        }
    }
}
