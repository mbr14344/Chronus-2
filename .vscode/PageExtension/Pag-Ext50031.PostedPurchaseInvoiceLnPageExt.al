
pageextension 50031 PostedPurchaseInvoiceLnPageExt extends "Posted Purchase Invoice Lines"
{
    layout
    {
        modify("Shortcut Dimension 2 Code")
        {
            ApplicationArea = All;
            Visible = true;
        }
        addafter("Buy-from Vendor No.")
        {
            field("Vendor Invoice No."; Rec."Vendor Invoice No.")
            {
                ApplicationArea = All;
            }
            field("Posting Date"; Rec."Posting Date")
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
        addlast(Control1)
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = ALL;
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
