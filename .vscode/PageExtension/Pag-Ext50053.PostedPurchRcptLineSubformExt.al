pageextension 50053 PostedPurchRcptLineSubformExt extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter("Expected Receipt Date")
        {
            field(ActualCargoReadyDate; Rec.ActualCargoReadyDate)
            {
                ApplicationArea = All;
            }
            field(EstimatedInWarehouseDate; Rec.EstimatedInWarehouseDate)
            {
                ApplicationArea = All;
            }
            field(DeliveryNotes; Rec.DeliveryNotes)
            {
                ApplicationArea = All;
            }
            field(POFinalizeDate; Rec.POFinalizeDate)
            {
                ApplicationArea = All;

            }
            field("Production Status"; Rec."Production Status")
            {
                ApplicationArea = All;
            }
        }
        addafter("Unit of Measure Code")
        {
            field("M-Pack Qty"; Rec."M-Pack Qty")
            {
                ApplicationArea = All;
            }
            field(PackageCount; Rec.GetPackageCount())
            {
                Caption = 'Package Count';
                ApplicationArea = All;
            }
            field(DimensionKg; Rec.GetDimensionM())
            {
                Caption = 'Dimension (LxWxH) m';
                ApplicationArea = All;
                DecimalPlaces = 5;
            }
            field(CBM; Rec.GetPackageCount() * Rec.GetDimensionM())
            {
                ApplicationArea = All;
                Caption = 'CBM(m)';
            }
            field(GW; Rec.GetPackageCount() * Rec."M-Pack Weight kg")
            {
                ApplicationArea = All;
                Caption = 'GW(kg)';
            }

        }
    }

}
