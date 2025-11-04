pageextension 50052 LocationCardExt extends "Location Card"
{
    layout
    {
        addafter("Use As In-Transit")
        {
            field("Exempt From Current Inv. Calc"; Rec."Exempt From Current Inv. Calc")
            {
                ApplicationArea = All;
            }
            field("FTP Server Name"; Rec."FTP Server Name")
            {
                ApplicationArea = All;
            }
            field("Facility Code"; Rec."Facility Code")
            {
                ApplicationArea = All;
            }
            field("Allow Physical Transfer"; Rec."Allow Physical Transfer")
            {
                ApplicationArea = All;
            }
        }

    }
}
