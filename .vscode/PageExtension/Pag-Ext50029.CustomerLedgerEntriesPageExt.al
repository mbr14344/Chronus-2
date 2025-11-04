pageextension 50029 CustomerLedgerEntriesPageExt extends "Customer Ledger Entries"
{
    layout
    {
        modify("User ID")
        {
            Visible = false;
            Enabled = false;

        }
        modify("Original Amount")
        {
            ToolTip = 'Specifies the amount of the original entry. If Document Type = Payment, Original Amount is the actual amount posted onto the Bank Account or G/L Account.';
        }
        addafter("Original Pmt. Disc. Possible")
        {
            field("Pmt. Disc. Given (LCY)"; Rec."Pmt. Disc. Given (LCY)")
            {
                ApplicationArea = All;
            }
        }

        addlast(Control1)
        {
            field(Comment; Rec.Comment)
            {
                ApplicationArea = ALL;
            }
            field(Internal; Rec.Internal)
            {
                ApplicationArea = ALL;
            }
        }
        //pr 4/28/25 - start
        addbefore("Original Amount")
        {
            field("TotalAmount"; rec.CalculateGrossTotals())
            {
                ApplicationArea = All;
                Caption = 'Amount Before Discount';
            }
        }
        //pr 4/28/25 - end
        //10/17/25 - start
        addafter("Shortcut Dimension 8 Code")
        {
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        //10/17/25 - end

    }

    actions
    {

    }

    var
        myInt: Integer;
}
