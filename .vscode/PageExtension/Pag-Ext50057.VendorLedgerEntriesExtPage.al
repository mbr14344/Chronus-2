pageextension 50057 VendorLedgerEntriesExtPage extends "Vendor Ledger Entries"
{
    layout
    {
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
            field("Closed by Entry No."; Rec."Closed by Entry No.")
            {
                ApplicationArea = All;
            }
            field("On Hold Vis"; Rec."On Hold Vis")
            {
                ApplicationArea = ALL;
                Caption = 'On Hold';
                //Editable = false;
            }
            field("Verified By"; Rec."Verified By")
            {
                ApplicationArea = ALL;
                // Visible = false;
            }
            field("Hold By"; Rec."Hold By")
            {
                Caption = 'Hold By';
                ApplicationArea = ALL;
                // Visible = false;
            }
            field("Hold Date"; Rec."Hold Date")
            {
                ApplicationArea = ALL;
                // Visible = false;
            }
            field("Verified Notes"; Rec."Verified Notes")
            {
                ApplicationArea = ALL;
                // Visible = false;
            }
            field("Responsibility Center"; Rec."Responsibility Center")
            {
                ApplicationArea = ALL;
                // Visible = false;
            }
        }


    }
    actions
    {
        addafter("Detailed &Ledger Entries")
        {
            action(POPaymentDashboard)
            {
                ApplicationArea = all;
                Caption = 'PO Payment Balance Dashboard';
                Image = Balance;
                RunObject = Page "PO Payment Balance Dashboard";
                Promoted = true;
                PromotedCategory = Process;
            }
        }


    }
    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Responsibility Center");
        rec.CalcOnHoldVis();
        // rec.Modify();
    end;

}
