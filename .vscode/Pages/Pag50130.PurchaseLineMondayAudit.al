page 50130 "Purchase Line Monday Audit"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Monday.com Audit Trail';
    Editable = false;
    SourceTable = "PurchLine Monday Update Audit";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; rec."No.")
                {
                }
                field("Document No."; rec."Document No.")
                {
                }
                field("Line No."; rec."Line No.")
                {
                }
                field("Monday.com BoardID"; rec."Monday.com BoardID")
                {
                }
                field("Monday.com ItemID"; rec."Monday.com ItemID")
                {
                }
                field(ColumnID; rec.ColumnID)
                {
                    Visible = false;
                }
                field(ValueJsonStr; rec.ValueJsonStr)
                {
                }
                field("Changed By User ID"; rec."Changed By User ID")
                {
                }
                field("Changed On"; rec."Changed On")
                {
                }
                field("Entry No."; rec."Entry No.")
                {
                }

                field(Result; rec.Result)
                {

                }
            }
        }
    }
}
