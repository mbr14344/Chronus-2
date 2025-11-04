pageextension 50049 PostedSalesShipmentLinesExt extends "Posted Sales Shipment Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }


        }
        addafter("Unit of Measure Code")
        {
            field("M-Pack Qty"; Rec."M-Pack Qty")
            {
                ApplicationArea = all;
                Enabled = false;
                DecimalPlaces = 0;
            }
            field("Package Count"; PackageCount)
            {
                ApplicationArea = all;
                Enabled = false;
                DecimalPlaces = 1;

            }
        }



    }

    trigger OnAfterGetRecord()
    begin
        UpdatePackageCnt();
    end;


    var
        PackageCount: Decimal;
        Item: Record Item;
        genGU: Codeunit GeneralCU;

    procedure UpdatePackageCnt()
    begin
        If Rec.Type = Rec.Type::Item then begin
            If Item.Get(Rec."No.") then
                if Item.Type = Item.Type::Inventory then begin
                    Rec.CalcFields("M-Pack Qty");
                    PackageCount := 0;
                    IF Rec."M-Pack Qty" > 0 then
                        PackageCount := Rec."Quantity (Base)" / Rec."M-Pack Qty";

                end;
        end;



    end;
}
