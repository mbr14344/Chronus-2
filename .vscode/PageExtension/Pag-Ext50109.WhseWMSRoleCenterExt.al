pageextension 50109 WhseWMSRoleCenterExt extends "Whse. WMS Role Center"
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