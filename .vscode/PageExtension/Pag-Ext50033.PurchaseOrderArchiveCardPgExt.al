pageextension 50033 PurchaseOrderArchiveCardPgExt extends "Purchase Order Archive"
{
    layout
    {
        addafter(Status)
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = ALL;
            }
            // pr 11/15/24
            field(CreatedUserID; Rec.CreatedUserID)
            {
                ApplicationArea = all;
            }
            field(CreatedDate; Rec.CreatedDate)
            {
                ApplicationArea = all;
            }

        }



    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
