pageextension 50060 PurchaseCreditMemoExtPage extends "Purchase Credit Memo"
{
    layout
    {
        addafter(Status)
        {
            field(Internal; Rec.Internal)
            {
                ApplicationArea = All;
            }

        }
    }
}
