pageextension 50106 SalesManagerRoleCenterExt extends "Sales Manager Role Center"
{
    layout
    {
        addbefore(Control6)
        {
            part("Ashtel Calender"; "Calendar Page Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ashtel Calendar';
            }
        }
    }
}