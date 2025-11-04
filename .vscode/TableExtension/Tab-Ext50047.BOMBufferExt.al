tableextension 50047 "BOM Buffer Ext" extends "BOM Buffer"
{
    fields
    {
        field(50001; "Last Purchase Start Date"; Date)
        {
            Caption = 'Last Purchase Start Date';
            FieldClass = FlowField;
            CalcFormula = Max("Purchase Price"."Starting Date"
                        WHERE(
                            "Item No." = FIELD("No.")
                            )
                        );
        }
        field(50002; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost';
            // 8/11/25 - start
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Price"."Direct Unit Cost"
            WHERE(
                        "Item No." = FIELD("No."),                   // ← no table-prefix here
                            "Starting Date" = FIELD("Last Purchase Start Date")
            )
            );
            // 8/11/25 - end
            DecimalPlaces = 0 : 5;
        }

    }
    // 8/11/25 - start
    /*(procedure CalcDirectUnitCost(totalDirectCost: Decimal)
    var
        PurchasePrice: Record "Purchase Price";
        BomRef: Record "BOM Buffer";
    begin

        if (rec."Replenishment System" = rec."Replenishment System"::Assembly) and (totalDirectCost <> 0) then begin
            rec."Direct Unit Cost" := totalDirectCost;
        end
        else begin
            PurchasePrice.Reset();
            PurchasePrice.SetRange("Item No.", Rec."No.");
            PurchasePrice.SetRange("Starting Date", Rec."Last Purchase Start Date");
            if (PurchasePrice.FindFirst()) then begin
                Rec."Direct Unit Cost" := PurchasePrice."Direct Unit Cost";
            end;
        end;
    end;*/
    // 8/11/25 - end
}
