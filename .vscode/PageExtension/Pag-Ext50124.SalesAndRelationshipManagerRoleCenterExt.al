pageextension 50124 SalesAndRelManRoleCenterExt extends "Sales & Relationship Mgr. RC"
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