page 50034 Terminal
{
    ApplicationArea = All;
    Caption = 'Terminal';
    PageType = List;
    SourceTable = Terminal;
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
