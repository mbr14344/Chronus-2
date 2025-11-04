pageextension 50101 "BOM Structure Ext" extends "BOM Structure"
{
    layout
    {

        // addafter()
        addafter("Replenishment System")
        {
            field("Purchase Price"; PurchPrice)
            {

                Visible = true;
                ApplicationArea = All;
                Editable = false;
                DecimalPlaces = 0 : 5;
            }

        }
        modify(ItemFilter)
        {
            trigger OnAfterValidate()
            begin
                CalcPurchasePrice();
                UpdatePurchasePrice();
            end;
        }
    }
    trigger OnOpenPage()
    begin
        CalcPurchasePrice();
    end;

    trigger OnAfterGetRecord()
    begin

        UpdatePurchasePrice();
    end;

    var
        totalDirectCost: Decimal;
        PurchPrice: Decimal;

    procedure GetTotalDirectCost() ReturnVal: Decimal
    begin
        exit(totalDirectCost);
    end;

    local procedure UpdatePurchasePrice()
    begin
        rec.CalcFields("Last Purchase Start Date", "Direct Unit Cost");
        if (rec."Replenishment System" <> rec."Replenishment System"::Assembly) then
            PurchPrice := rec."Direct Unit Cost"
        else
            PurchPrice := totalDirectCost;
    end;

    local procedure CalcPurchasePrice()
    begin
        totalDirectCost := 0;
        rec.Reset();
        if (rec.FindSet()) then
            repeat
                if (rec."Replenishment System" <> rec."Replenishment System"::Assembly) then begin
                    rec.CalcFields("Direct Unit Cost");
                    totalDirectCost += rec."Direct Unit Cost" * rec."Qty. per Parent";
                end;
            until rec.Next() = 0;
    end;

}
