page 50046 itemAttributeList
{
    ApplicationArea = All;
    Caption = 'itemAttributeList';
    PageType = List;
    SourceTable = "Item Attribute Line";
    //SourceTableTemporary = true;
    UsageCategory = lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Attribute ID"; Rec."Attribute ID")
                {
                    ApplicationArea = all;
                }
                field("Attribute Name"; Rec."Attribute Name")
                {
                    ApplicationArea = all;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
