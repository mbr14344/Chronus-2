pageextension 50015 SalesQuoteSubformExt extends "Sales Quote Subform"
{
    layout
    {
        modify(Description)
        {
            Visible = false;
        }
        addafter("Item Reference No.")
        {
            field("Real Time Item Description"; Rec."Real Time Item Description")
            {
                ApplicationArea = all;
            }
        }
    }
}
