pageextension 50010 PurchaseOrderExt extends "Purchase Order"
{
    layout
    {
        addafter("Due Date")
        {
            field("Do Not Ship Before Date"; Rec.DoNotShipBeforeDate)
            {
                ApplicationArea = All;
            }
            field("Requested Cargo Ready Date"; Rec.RequestedCargoReadyDate)
            {
                ApplicationArea = All;
            }
            field("Requested In Whse Date"; Rec.RequestedInWhseDate)
            {
                ApplicationArea = All;
            }
            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
            }
            field("Applies-to ID"; Rec."Applies-to ID")
            {
                ApplicationArea = All;
            }
            field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
            {
                ApplicationArea = All;
            }
        }
        addafter("Assigned User ID")
        {
            field(Incoterm; Rec.Incoterm)
            {
                ApplicationArea = All;
            }

            field("Port of Loading"; Rec."Port Of Loading")
            {
                ApplicationArea = All;
            }
            field(Forwarder; Rec.Forwarder)
            {
                ApplicationArea = All;
            }
            field("Port Of Discharge"; Rec."Port Of Discharge")
            {
                ApplicationArea = All;
            }
            field(Internal; Rec.Internal)
            {
                ApplicationArea = All;
            }
            field(CreatedUserID; Rec.CreatedUserID)
            {
                ApplicationArea = All;
            }
            field(CreatedDate; Rec.CreatedDate)
            {
                ApplicationArea = All;
            }
        }
        //pr 3/26/25 - add a PO Line Subtotal that will total up each Unique Item in a PO - start
        addbefore(Control1904651607)
        {
            part("PO Item Summary"; POItemSummaryFactbox)
            {
                ApplicationArea = All;
                //   SubPageLink = "Document No." = field("No."), "Buy-from Vendor No." = field("Buy-from Vendor No."), "Document Type" = field("Document Type");
            }
        }
        //pr 3/26/25 - add a PO Line Subtotal that will total up each Unique Item in a PO - end


    }
    trigger OnOpenPage()
    begin
        //MBR 9/26/24 - On open of Purchase ORder, change Posting Date to today's date
        PurchaseHeader.Reset();
        PurchaseHeader.SetCurrentKey("No.", "Document Type");
        PurchaseHeader.SetRange("No.", Rec."No.");
        PurchaseHeader.SetRange("Document Type", Rec."Document Type");
        If PurchaseHeader.FindFirst() then begin
            PurchaseHeader.Validate("Posting Date", Today);
            PurchaseHeader.Modify(false);
        end;

        //9/26/24 - end
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage."PO Item Summary".Page.SetPONo(Rec."No.");
    end;

    var
        POItemSummaryFactboxPage: Page POItemSummaryFactbox;
        isQtyToAssgn: Boolean;
        purchLinesSubForm: Page "Purchase Order Subform";
        PurchaseHeader: Record "Purchase Header";

    procedure SetIsQtyToAssgn(isActive: Boolean)
    begin
        isQtyToAssgn := isActive;
        purchLinesSubForm.SetIsQtyToAssgn(isActive);

    end;



}

