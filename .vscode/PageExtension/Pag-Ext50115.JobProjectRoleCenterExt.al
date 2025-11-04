pageextension 50115 JobProjectRoleCenterExt extends "Job Project Manager RC"
{
    layout
    {
        addbefore(Control34)
        {
            part("Ashtel Calender"; "Calendar Page Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ashtel Calendar';
            }
        }
    }
}