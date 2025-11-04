pageextension 50091 "Purchase Order Archive Sub Ext" extends "Purchase Order Archive Subform"
{
    layout
    {
        addafter(Quantity)
        {

            field("Qty Assign to Container"; Rec."Qty to Assign to Container")
            {
                Caption = 'Qty Assign to Container';
                ApplicationArea = all;
                //DecimalPlaces = 0 : 5;

            }

            field("Qty Assigned to Container"; Rec."Qty Assigned to Container")
            {
                Caption = 'Qty Assigned to Container';
                ApplicationArea = all;
                //DecimalPlaces = 0 : 5;

            }
        }

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
        }
        addafter("Direct Unit Cost")
        {
            field("M-Pack Qty"; Rec."M-Pack Qty")
            {
                ApplicationArea = All;
            }
            field("Production Status"; Rec."Production Status")
            {
                ApplicationArea = All;
            }
            field("PO Finalized Date"; rec.POFinalizeDate)
            {
                ApplicationArea = all;
            }



        }
    }
}
