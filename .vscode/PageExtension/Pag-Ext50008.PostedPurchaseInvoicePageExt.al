pageextension 50008 "Posted Purchase Invoice" extends "Posted Purchase Invoice"
{
    //mbr 1/12/24 - add new fields
    layout
    {
        modify("Due Date")
        {
            Caption = 'Payment Due Date';


        }
        

        addafter("Vendor Order No.")
        {

            field(Incoterm; Rec.Incoterm)
            {
                ApplicationArea = All;
            }
            field("Port of Loading"; Rec."Port Of Loading")
            {
                ApplicationArea = All;
            }
            field("Your Reference"; Rec."Your Reference")
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
            field(VerifiedBy; Rec.VerifiedBy)
            {
                ApplicationArea = All;
            }
            field(VerifiedDate; Rec.VerifiedDate)
            {
                ApplicationArea = All;
            }
            field(RequestedCargoReadyDate; Rec.RequestedCargoReadyDate)
            {
                ApplicationArea = All;
            }

        }

        addbefore("Pay-to Name")
        {
            field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
            {
                ApplicationArea = All;
            }
        }

    }


}
