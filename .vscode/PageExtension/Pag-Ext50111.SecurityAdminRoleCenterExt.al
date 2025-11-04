pageextension 50111 SecurityAdminRoleCenterExt extends "Security Admin Role Center"
{
    layout
    {
        addbefore("Security Group Members Chart")
        {
            part("Ashtel Calender"; "Calendar Page Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ashtel Calendar';
            }
        }
    }
}