page 50064 ItemSubBrand
{
    ApplicationArea = All;
    Caption = 'Item Sub-Brands';
    PageType = List;
    SourceTable = "Item sub Brand";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {

                }
            }
        }
    }
}
