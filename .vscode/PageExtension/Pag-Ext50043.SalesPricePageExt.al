pageextension 50043 SalesPricePageExt extends "Sales Prices"
{
    layout
    {
        addafter("Item No.")
        {
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = All;
            }
            field("Customer-Buyer"; Rec."Customer-Buyer")
            {
                ApplicationArea = All;
            }
            field("Customer-Buyer Name"; Rec."Customer-Buyer Name")
            {
                ApplicationArea = All;
            }
            field("Item Reference"; Rec."Item Reference")
            {
                ApplicationArea = All;
            }
        }
        addafter("Ending Date")
        {
            field("Retail Price"; Rec."Retail Price")
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
        addafter("Unit Price")
        {
            field(Notes; Rec.Notes)
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Item Reference", "Customer Name");
    end;

}
