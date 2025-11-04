pageextension 50092 AssemblyOrderSubformExt extends "Assembly Order Subform"
{
    layout
    {
        modify("No.")
        {
            //PR 4/2/25 - -	On insert (validate?) of Item No, check against Assembly BOM Lines to see if this item exist - start
            trigger OnBeforeValidate()
            var
                AssemblyLine: Record "Assembly Line";
                BOMComments: Record "BOM Component";
                AssemblyHeader: Record "Assembly Header";
                Item: Record Item;
                ItemSub: Record "Item Substitution";
                ChkAssemblyLine: Record "Assembly Line";
                bFound: Boolean;
                txtIncompleteBOM: Label 'Assembly BOM for %1 DOES NOT include item %2.  You cannot select this item.';
            begin
                AssemblyHeader.Reset();
                AssemblyHeader.SetRange("No.", rec."Document No.");
                AssemblyHeader.SetRange("Document Type", rec."Document Type");
                if (AssemblyHeader.FindFirst()) then begin
                    bFound := false;
                    BOMComments.Reset();
                    BOMComments.SetRange("Parent Item No.", AssemblyHeader."Item No.");
                    BOMComments.SetRange(Type, BOMComments.Type::Item);
                    BOMComments.SetRange("No.", rec."No.");
                    // checks item's substitute if not in BOM
                    if not BOMComments.FindSet() then begin
                        ItemSub.reset;
                        ItemSub.SetRange("No.", rec."No.");
                        ItemSub.SetRange(Type, ItemSub.Type::Item);
                        // check if substitute is in BOM
                        if ItemSub.FindSet() then
                            repeat
                                BOMComments.Reset();
                                BOMComments.SetRange("Parent Item No.", AssemblyHeader."Item No.");
                                BOMComments.SetRange(Type, BOMComments.Type::Item);
                                BOMComments.SetRange("No.", ItemSub."Substitute No.");
                                // if found sub in BOM
                                if BOMComments.FindSet() then
                                    bFound := true;
                            until (ItemSub.Next() = 0) or (bFound = true)
                        // if not in BOM and has no subs
                        else
                            Error(txtIncompleteBOM, AssemblyHeader."Item No.", rec."No.");
                        // if not in BOM and has no subs in BOM
                        if (bFound = false) then
                            Error(txtIncompleteBOM, AssemblyHeader."Item No.", rec."No.");
                    end;

                end;

            end;

            //PR 4/2/25 - -	On insert (validate?) of Item No, check against Assembly BOM Lines to see if this item exist - end
        }
        modify(Quantity)
        {
            Editable = false;
        }
    }
}
