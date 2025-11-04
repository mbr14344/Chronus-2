pageextension 50108 TeamMemberRoleCenterExt extends "Team Member Role Center"
{
    layout
    {
        addbefore(ApprovalsActivities)
        {
            part("Ashtel Calender"; "Calendar Page Part")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ashtel Calendar';
            }
        }
    }
}