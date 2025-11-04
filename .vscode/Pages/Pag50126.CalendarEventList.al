page 50126 "Calendar Event List"
{
    ApplicationArea = All;
    Caption = 'Calendar Event List';
    PageType = List;
    SourceTable = CalendarEvent;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                }
                field("Line No"; Rec."Line No")
                {
                    ToolTip = 'Specifies the value of the Line No field.', Comment = '%';
                }
                field(UserID; Rec.UserID)
                {
                    ToolTip = 'Specifies the value of the UserID field.', Comment = '%';
                }
                field("Text"; Rec."Text")
                {
                    ToolTip = 'Specifies the value of the Text field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
            }
        }
    }
}
