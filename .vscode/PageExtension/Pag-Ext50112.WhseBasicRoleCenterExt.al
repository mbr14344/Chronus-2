pageextension 50112 WhseBasicRoleCenterExt extends "Whse. Basic Role Center"
{
    layout
    {
        addbefore(Control1907692008)
        {
            part("Ashtel Calender"; "Calendar Page Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ashtel Calendar';
            }
        }
    }
}