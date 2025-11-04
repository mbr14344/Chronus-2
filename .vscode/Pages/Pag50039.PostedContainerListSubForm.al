page 50039 "Posted Container List SubForm"
{
    // pr 6/4/24 created posted container list subform page
    ApplicationArea = All;
    Caption = 'Posted Container List SubForm';
    PageType = ListPart;
    SourceTable = "Posted Container Line";
    // DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field("Quantity Base"; Rec."Quantity Base")
                {
                    ToolTip = 'Specifies the value of the Quantity Base field.';
                }
                field("Port of Loading"; Rec."Port of Loading")
                {
                    ApplicationArea = All;
                }
                field("Port of Discharge"; Rec."Port of Discharge")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Buy-From Vendor No."; Rec."Buy-From Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Requested In Whse Date"; Rec."Requested In Whse Date")
                {
                    ApplicationArea = All;
                }
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
                field("Transfer Receipt No."; Rec."Transfer Receipt No.")
                {
                    ApplicationArea = All;
                }
                field("Fully Received"; Rec."Fully Received")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Port of Loading", "Port of Discharge", "Location Code");
    end;
}
