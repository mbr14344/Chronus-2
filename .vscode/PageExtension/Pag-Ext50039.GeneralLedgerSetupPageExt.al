pageextension 50039 GeneralLedgerSetupPageExt extends "General Ledger Setup"
{
    layout
    {
        addafter("Report Output Type")
        {
            field("Auto BC General Template"; Rec."Auto BC General Template")
            {
                ApplicationArea = All;
            }
            field("Auto BC General Batch"; Rec."Auto BC General Batch")
            {
                ApplicationArea = All;
            }
            field("Purchase Discount G/L Account"; Rec."Purchase Discount G/L Account")
            {
                ApplicationArea = All;
            }
            field("Sales Discount G/L Account"; Rec."Sales Discount G/L Account")
            {
                ApplicationArea = All;
            }
        }

    }
}
