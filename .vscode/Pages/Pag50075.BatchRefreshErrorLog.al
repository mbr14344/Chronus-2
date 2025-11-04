page 50075 BatchRefreshErrorLog
{
    ApplicationArea = All;
    Caption = 'BatchRefreshErrorLog';
    PageType = List;
    SourceTable = TmpBatchRefreshErr;
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
                field("Customer No."; Rec.CustNo)
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field(ErrorDescription; Rec.ErrorDescription)
                {
                    ToolTip = 'Specifies the value of the Error Description field.', Comment = '%';
                }
            }
        }
    }
}
