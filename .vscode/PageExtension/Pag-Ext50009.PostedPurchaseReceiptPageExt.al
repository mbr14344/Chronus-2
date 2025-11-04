pageextension 50009 PostedPurchaseReceipt extends "Posted Purchase Receipt"
{
    layout
    {
        addafter("Document Date")
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

            field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
            {
                ApplicationArea = All;
            }
        }
        addafter("Purchaser Code")
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

            field(CreatedUserID; Rec.CreatedUserID)
            {
                ApplicationArea = All;
            }
            field(CreatedDate; Rec.CreatedDate)
            {
                ApplicationArea = All;
            }

        }
    }




}

