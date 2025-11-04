pageextension 50105 OrderProcessorRoleCenterExt extends "Order Processor Role Center"
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