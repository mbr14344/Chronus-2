page 50054 Drayage
{
    ApplicationArea = All;
    Caption = 'Drayage';
    PageType = List;
    SourceTable = Drayage;
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
