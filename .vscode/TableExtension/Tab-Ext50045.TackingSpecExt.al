tableextension 50045 TackingSpecExt extends "Tracking Specification"
{
    fields
    {
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            var
                PurchLine: Record "Purchase Line";
            begin
                PurchLine.Reset();
                PurchLine.SetRange("No.", rec."Item No.");
                PurchLine.SetRange("Document No.", rec."Source ID");
                PurchLine.SetRange("Line No.", rec."Source Ref. No.");
                PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                PurchLine.SetFilter("Expected Expiration Date", '>%1', 0D);
                if (PurchLine.FindSet()) then begin
                    rec."Expiration Date" := PurchLine."Expected Expiration Date";
                end;
            end;
        }
    }
}
