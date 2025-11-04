page 50063 ItemBrand
{
    ApplicationArea = All;
    Caption = 'Item Brands';
    PageType = List;
    SourceTable = "Item Brand";
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
