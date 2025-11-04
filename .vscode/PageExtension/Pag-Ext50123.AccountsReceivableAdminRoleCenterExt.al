pageextension 50123 AccountsRecRoleCenterExt extends "Account Receivables"
{
    layout
    {
        addbefore(SelfService)
        {
            part("Ashtel Calender"; "Calendar Page Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ashtel Calendar';
            }
        }
    }
}