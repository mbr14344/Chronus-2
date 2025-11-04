page 50053 "EDI G/L Account Setup"
{
    ApplicationArea = All;
    Caption = 'EDI G/L Account Setup';
    PageType = List;
    SourceTable = "EDI G\L Account";
    DeleteAllowed = true;
    InsertAllowed = true;
    UsageCategory = Lists;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("EDI G/L Account No."; Rec."EDI G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the EDI G/L Account field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
            }
        }
    }
}
