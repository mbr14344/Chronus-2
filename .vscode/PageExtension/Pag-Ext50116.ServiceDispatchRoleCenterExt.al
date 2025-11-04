pageextension 50116 ServiceDispatchRoleCenterExt extends "Service Dispatcher Role Center"
{
    layout
    {
        addbefore(PowerBIEmbeddedReportPart)
        {
            part("Ashtel Calender"; "Calendar Page Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ashtel Calendar';
            }
        }
    }
}