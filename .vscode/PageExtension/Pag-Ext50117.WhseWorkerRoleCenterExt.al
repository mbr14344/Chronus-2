pageextension 50117 WhseWorkerRoleCenterExt extends "Whse. Worker WMS Role Center"
{
    layout
    {
        addbefore(Control1905989608)
        {
            part("Ashtel Calender"; "Calendar Page Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ashtel Calendar';
            }
        }
    }
}