page 50134 PurchaseQuoteType
{
    ApplicationArea = All;
    Caption = 'Container Type';
    PageType = List;
    SourceTable = PurchQuoteType;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Type"; Rec."Type")
                {
                }
            }
        }
    }
}
