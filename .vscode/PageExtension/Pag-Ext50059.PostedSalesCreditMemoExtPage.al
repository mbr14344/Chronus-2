pageextension 50059 PostedSalesCreditMemoExtPage extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("External Document No.")
        {
            field(Internal; Rec.Internal)
            {
                ApplicationArea = All;
            }

        }
    }
}
