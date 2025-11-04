page 50058 AutoAssignLotErr
{
    ApplicationArea = All;
    Caption = 'Auto Assign Lot - Errors Encountered';
    PageType = List;
    SourceTable = TmpAutoAssignLotErr;
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the Sales Order No. field.', Comment = '%';
                }
                field(LineNo; Rec.LineNo)
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field(ItemNo; Rec.ItemNo)
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field(UOM; Rec.UOM)
                {
                    ToolTip = 'Specifies the value of the UOM field.', Comment = '%';
                }
                field(ErrorDescription; Rec.ErrorDescription)
                {
                    ToolTip = 'Specifies the value of the Error Description field.', Comment = '%';
                }
            }
        }
    }
}
