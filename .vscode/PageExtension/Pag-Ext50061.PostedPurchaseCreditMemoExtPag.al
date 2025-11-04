pageextension 50061 PostedPurchaseCreditMemoExtPag extends "Posted Purchase Credit Memo"
{
    layout
    {
        addafter("Document Date")
        {
            field(Internal; Rec.Internal)
            {
                ApplicationArea = All;
            }

        }
    }
}
