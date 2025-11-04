tableextension 50067 PurhcaseHeaderArchiveExt extends "Purchase Header Archive"
{
    fields
    {
        field(50001; DoNotShipBeforeDate; Date)
        {
            Caption = 'Do Not Ship Before Date';
            DataClassification = CustomerContent;
        }
        field(50002; RequestedCargoReadyDate; Date)
        {
            Caption = 'Requested Cargo Ready Date';
            DataClassification = CustomerContent;
        }
        field(50003; RequestedInWhseDate; Date)
        {
            Caption = 'Requested In Whse Date';
            DataClassification = CustomerContent;

        }
        field(50004; "Incoterm"; Option)
        {
            Caption = 'Incoterm';
            DataClassification = CustomerContent;
            OptionCaption = ' ,CIF,DDP,EXW,FOB';
            OptionMembers = " ","CIF","DDP","EXW","FOB";
        }

        field(50005; "Port Of Loading"; Code[20])
        {
            Caption = 'Port of Loading';
            TableRelation = "Port of Loading".Port;
        }

        field(50006; CreatedUserID; Code[20])
        {
            Caption = 'Created By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50007; CreatedDate; Date)
        {
            Caption = 'Created Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50008; "Port Of Discharge"; Code[20])
        {
            Caption = 'Port of Discharge';
            TableRelation = "Port of Loading".Port;
        }
        field(50009; Forwarder; Code[10])
        {
            TableRelation = "Shipping Agent".code;
        }

        field(50010; "Production Status"; Option)
        {   //mbt 1/13/25 - this is currently INACTIVE.  We have moved Production Status into Purchase LInes
            Caption = 'Production Status';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Waiting for factory to send print confirmation,Waiting for license approval,Waiting for design team approval,Deposit pending approval,Balance payment pending approval,Waiting for test report (DO NOT USE),Waiting for new mold ready ,Waiting for factory to confirm CRD,Finalizing product spec,Pre-production sample pending approval  ,Post-production sample pending approval,Approved for production,Waiting for factory to book shipment,Shipment booked,Waiting for forwarder to release vessel info,Shipped,Waiting for Artwork,PO on Hold,Waiting for component from US,Shipped - waiting for payment to release FCR,Waiting for factory provide pre-production samples,Waiting for pre-production test report,Waiting for post-production test report';
            OptionMembers = " ","Waiting for factory to send print confirmation","Waiting for license approval","Waiting for design team approval","Deposit pending approval","Balance payment pending approval","Waiting for test report (DO NOT USE)","Waiting for new mold ready ","Waiting for factory to confirm CRD","Finalizing product spec","Pre-production sample pending approval  ","Post-production sample pending approval","Approved for production","Waiting for factory to book shipment","Shipment booked","Waiting for forwarder to release vessel info","Shipped","Waiting for Artwork","PO on Hold","Waiting for component from US","Shipped - waiting for payment to release FCR","Waiting for factory provide pre-production samples","Waiting for pre-production test report","Waiting for post-production test report";
        }
        field(50011; Internal; Boolean)
        {

        }
        field(50012; VerifiedBy; Code[20])
        {
            Caption = 'Verified By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50013; VerifiedDate; Date)
        {
            Caption = 'Verified Date';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(50014; TotalAppliedCreditMemoAmount; Decimal)
        {
            Caption = 'Total Applied Credit Memo Amount';
            Editable = false;
        }
        field(50017; TotalAppliedPayment; Decimal)
        {
            Caption = 'Total Applied Payments';
            Editable = false;
        }
        field(50018; PIBalance; Decimal)
        {
            Caption = 'Purchase Invoice Balance';
            Editable = false;
        }
        field(50019; TotalUnappliedPayment; Decimal)
        {
            Caption = 'Total Unapplied Payments';
            Editable = false;
        }
        field(50020; TotalUnappliedCM; Decimal)
        {
            Caption = 'Total Unapplied Credit Memos';
            Editable = false;
        }
    }
}
