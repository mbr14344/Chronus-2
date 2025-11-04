page 50055 ReceivingStatus
{
    ApplicationArea = All;
    Caption = 'ReceivingStatus';
    PageType = List;
    SourceTable = ReceivingStatus;
    UsageCategory = Lists;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
            }
        }
    }

}
