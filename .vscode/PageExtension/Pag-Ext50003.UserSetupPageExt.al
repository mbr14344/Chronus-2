pageextension 50003 UserSetupPageExt extends "User Setup"
{
    // pr 12/1/23 added extension for user setup from Nutraza to make job queue work
    layout
    {
        // Add changes to page layout here
        addafter("Allow Posting To")
        {

            field(AutoUpdate; Rec.AutoUpdate)
            {
                ApplicationArea = All;
            }
            field("Auto Update Posting To"; Rec."Auto Update Posting To")
            {
                ApplicationArea = All;
            }
            field(inventoryPlanRecipient; Rec.inventoryPlanRecipient)
            {
                ApplicationArea = All;
            }
            field(InventoryPlanRecipientExcl; Rec.InventoryPlanRecipientExcl)
            {
                ApplicationArea = All;
            }
            field(APRecipient; Rec.APRecipient)
            {
                ApplicationArea = All;
            }
            field(SOAdmin; Rec.SOAdmin)
            {
                ApplicationArea = All;
            }
            field(POAdmin; Rec.POAdmin)
            {
                ApplicationArea = All;
            }
            field(SODCBreakdownRecipient; Rec.SODCBreakdownRecipient)
            {
                ApplicationArea = All;
            }
            field(FinanceAdmin; Rec.FinanceAdmin)
            {
                ApplicationArea = All;
            }
            field("Item Admin"; Rec."Item Admin")
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

