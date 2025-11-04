pageextension 50058 SalesCreditMemoExtPage extends "Sales Credit Memo"
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
