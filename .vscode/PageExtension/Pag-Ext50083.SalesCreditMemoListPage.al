pageextension 50083 SalesCreditMemoListPage extends "Sales Credit Memos"
{
    layout
    {
        addafter(Amount)
        {
            field(CreatedUserID; Rec.CreatedUserID)
            {
                ApplicationArea = All;
            }
            field(CreatedDate; Rec.CreatedDate)
            {
                ApplicationArea = All;
            }
        }
    }

}
