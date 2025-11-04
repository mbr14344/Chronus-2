pageextension 50030 PostedPurchaseInvoicesPageExt extends "Posted Purchase Invoices"
{

    layout
    {
        modify("Pay-to Vendor No.")
        {
            Caption = 'Pay-to Vendor No.';
            Visible = true;
        }
        modify("Buy-from Vendor No.")
        {
            Caption = 'Buy-from Vendor No.';
        }
        addlast(Control1)
        {

            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = ALL;
            }
            field(CreatedUserID; Rec.CreatedUserID)
            {
                ApplicationArea = All;
            }
            field(CreatedDate; Rec.CreatedDate)
            {
                ApplicationArea = All;
            }
            field(VerifiedBy; Rec.VerifiedBy)
            {
                ApplicationArea = All;
            }
            field(VerifiedDate; Rec.VerifiedDate)
            {
                ApplicationArea = All;
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
