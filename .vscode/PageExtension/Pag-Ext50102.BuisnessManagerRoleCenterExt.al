pageextension 50102 BuisnessManagerRoleCenterExt extends "Business Manager Role Center"
{
    layout
    {
        addbefore(Control55)
        {
            part("Ashtel Calender"; "Calendar Page Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ashtel Calendar';
            }
        }
    }
}
