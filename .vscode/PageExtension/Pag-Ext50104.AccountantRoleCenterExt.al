pageextension 50104 AccountantRoleCenterExt extends "Accountant Role Center"
{
    layout
    {
        addbefore(Emails)
        {
            part("Ashtel Calender"; "Calendar Page Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ashtel Calendar';
            }
        }
    }
}
