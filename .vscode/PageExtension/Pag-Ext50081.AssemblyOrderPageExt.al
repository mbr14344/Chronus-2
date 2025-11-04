pageextension 50081 AssemblyOrderPageExt extends "Assembly Order"
{
    layout
    {
        modify("Posting Date")
        {
            style = StrongAccent;
            StyleExpr = true;
        }
        //PR 4/1/25 - if item.assembly BOM (from card) = true, it false error - start
        modify("Item No.")
        {
            trigger OnBeforeValidate()
            var
                item: Record Item;
            begin

                IF item.get(rec."Item No.") then begin
                    item.CalcFields("Assembly BOM");
                    if item."Assembly BOM" = false then
                        Error(txtItemAssembly, rec."Item No.");
                end;

            end;
        }
        //PR 4/1/25 - if item.assembly BOM (from card) = true, it false error - end
    }
    var
        txtItemAssembly: Label '%1 cannot pass since it has Assembly BOM = false in item card.';

    trigger OnOpenPage()
    var
        AssemblyHeader: Record "Assembly Header";

    begin
        AssemblyHeader.Reset();
        AssemblyHeader.SetCurrentKey("Document Type", "No.");
        AssemblyHeader.SetRange("No.", Rec."No.");
        AssemblyHeader.SetRange("Document Type", rec."Document Type");
        If AssemblyHeader.FindFirst() then begin
            AssemblyHeader.Validate("Posting Date", Today);
            AssemblyHeader.Modify(false);
        end;
    end;
}
