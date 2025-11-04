page 50033 "TO Carrier"
{
    ApplicationArea = All;
    Caption = 'TO Carrier';
    PageType = List;
    SourceTable = "TO Carrier";
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
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
