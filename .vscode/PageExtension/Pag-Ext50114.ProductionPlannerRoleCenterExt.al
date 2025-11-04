pageextension 50114 ProductionPlannerRoleCenterExt extends "Production Planner Role Center"
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