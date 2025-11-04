pageextension 50113 PurchasingAgentRoleCenterExt extends "Purchasing Agent Role Center"
{
    layout
    {
        addbefore(Control45)
        {
            part("Ashtel Calender"; "Calendar Page Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ashtel Calendar';
            }
        }
    }
}