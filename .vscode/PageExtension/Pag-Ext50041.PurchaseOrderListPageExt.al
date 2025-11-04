pageextension 50041 PurchaseOrderListPageExt extends "Purchase Order List"
{
    layout
    {
        addafter("Amount Including VAT")
        {
            field(CreatedUserID; Rec.CreatedUserID)
            {
                ApplicationArea = All;
            }
            field(Internal; Rec.Internal)
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
        addafter(Status)
        {
            field(RequestedCargoReadyDate; Rec.RequestedCargoReadyDate)
            {
                ApplicationArea = All;
            }
            field(RequestedInWhseDate; Rec.RequestedInWhseDate)
            {
                ApplicationArea = All;
            }
        }
        //pr 3/26/25 - add a PO Line Subtotal that will total up each Unique Item in a PO - start
        addafter(Control1900383207)
        {
            part("PO Item Summary"; POItemSummaryFactbox)
            {
                ApplicationArea = All;
                //  SubPageLink = "Document No." = field("No."), "Buy-from Vendor No." = field("Buy-from Vendor No."), "Document Type" = field("Document Type");
            }
        }

        //pr 3/26/25 - add a PO Line Subtotal that will total up each Unique Item in a PO - end
    }
    trigger OnAfterGetCurrRecord()
    begin
        CurrPage."PO Item Summary".Page.SetPONo(Rec."No.");
    end;



}
