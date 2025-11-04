pageextension 50026 PurchasePricesPageExt extends "Purchase Prices"
{
    layout
    {
        addafter("Ending Date")
        {
            field("Reason For Change"; Rec."Reason For Change")
            {
                ApplicationArea = All;
            }
            field("Rebate Unit Cost"; Rec."Rebate Unit Cost")
            {
                ApplicationArea = All;
            }
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
            }
            field("Last Date Modified"; Rec."Last Date Modified")
            {
                ApplicationArea = All;
            }
        }
    }
}
