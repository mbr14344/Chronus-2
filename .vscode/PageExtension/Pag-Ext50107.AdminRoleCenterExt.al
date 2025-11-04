pageextension 50107 AdminRoleCenterExt extends "Administrator Role Center"
{
    layout
    {
        addbefore(Control52)
        {
            part("Ashtel Calender"; "Calendar Page Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ashtel Calendar';
            }
        }
    }
}