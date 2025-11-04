page 50080 IntheMonthOptionsPage
{
    ApplicationArea = All;
    Caption = 'In the Month Options Page';
    PageType = List;
    SourceTable = InTheMonthOptions;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                }
            }
        }
    }
}
