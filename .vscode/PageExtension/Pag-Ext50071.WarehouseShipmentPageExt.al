pageextension 50071 WarehouseShipmentPageExt extends "Warehouse Shipment"
{
    actions
    {
        modify("P&ost Shipment")
        {
            trigger OnBeforeAction()
            begin
                ChkReservQty();
            end;
        }

    }
    local procedure ChkReservQty()
    var
        txtErrSalesLineQtyToShip: Label 'Item %1 Qty. To Ship <> Reserved Qty.';
        txtErrSalesLineQtyToShipConfirm: Label 'Item %1 with Qty. To Ship <> Reserved Qty. Override?';
        UserSetup: Record "User Setup";
        bAdmin: Boolean;
        popupConfirm: Page "Confirmation Dialog";
        txtTaskAborted: Label 'Task Aborted!';
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        WhseShipmentLine: Record "Warehouse Shipment Line";
        Item: Record Item;
    begin
        //mbr 9/23/24 - start
        //Before posting sales order, check each Sales Line Item.  If Qty to ship base <> Reserved qty base, then error out
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        UserSetup.SetRange(SOAdmin, true);
        if UserSetup.FindFirst() then
            bAdmin := true
        else
            bAdmin := false;
        WhseShipmentLine.Reset();
        WhseShipmentLine.SetRange("No.", Rec."No.");
        WhseShipmentLine.SetRange("Source Document", WhseShipmentLine."Source Document"::"Sales Order");
        IF WhseShipmentLine.FindSet() then
            repeat

                SalesLine.Reset();
                SalesLine.SetRange("Document No.", WhseShipmentLine."Source No.");
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetRange("Line No.", WhseShipmentLine."Source Line No.");
                IF SalesLine.FindFirst() then begin
                    Item.Reset;
                    Item.SETRANGE("No.", SalesLine."No.");
                    Item.SETRANGE(Type, Item.Type::Inventory);
                    IF Item.FindFirst() then begin
                        SalesLine.CalcFields("Reserved Qty. (Base)");
                        IF WhseShipmentLine."Qty. to Ship (Base)" <> SalesLine."Reserved Qty. (Base)" then begin

                            if bAdmin = true then begin
                                Clear(popupConfirm);
                                popupConfirm.setMessage(StrSubstNo(txtErrSalesLineQtyToShipConfirm, SalesLine."No."));
                                Commit;
                                if popupConfirm.RunModal() = Action::No then
                                    Error(txtTaskAborted);
                            end
                            else
                                Error(txtErrSalesLineQtyToShip, SalesLine."No.");
                        end;





                    end;
                end;
            until WhseShipmentLine.Next() = 0;


        //mbr 9/23/24 - end
    end;
}
