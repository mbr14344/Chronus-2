codeunit 50006 OrderPostCU
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeVendLedgEntryInsert, '', false, false)]
    local procedure OnBeforeVendLedgEntryInsert(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register")
    begin
        //mbr 7/9/2024 - if Purchase Invoice then make sure to carry over the 'Internal' value into Vendor Ledger Entry Table
        if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::Invoice then begin
            If PurchInvHdr.Get(VendorLedgerEntry."Document No.") then begin
                VendorLedgerEntry.Internal := PurchInvHdr.Internal;
            end;
        end
        else if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::"Credit Memo" then begin
            If PurchaseCrMemoHdr.Get(VendorLedgerEntry."Document No.") then begin
                VendorLedgerEntry.Internal := PurchaseCrMemoHdr.Internal;
            end;
        end;
        //mbr 7/9/2024 - end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeCustLedgEntryInsert, '', true, false)]

    local procedure OnBeforeCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register"; var TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var NextEntryNo: Integer)
    begin
        //mbr 7/9/2024 - if Purchase Invoice then make sure to carry over the 'Internal' value into Vendor Ledger Entry Table
        if CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice then begin
            If SalesInvHdr.Get(CustLedgerEntry."Document No.") then begin
                CustLedgerEntry.Internal := SalesInvHdr.Internal;
            end;
        end
        else if CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::"Credit Memo" then begin
            If SalesCrMemoHdr.Get(CustLedgerEntry."Document No.") then begin
                CustLedgerEntry.Internal := SalesCrMemoHdr.Internal;
            end;
        end;
        //mbr 7/9/2024 - end
    end;

    //mbr 12/20/24 - start
    /*// if we are posting from warehouse shipment and corresponding SO have Qty to invoice that has G/L Accounts or Types <> item then DO NOT Allow invoicing
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterHandleSalesLine', '', false, false)]
    local procedure OnAfterHandleSalesLine(var WhseShipmentLine: Record "Warehouse Shipment Line"; SalesHeader: Record "Sales Header"; var Invoice: Boolean; WarehouseShipmentHeader: Record "Warehouse Shipment Header")

    begin

        if Invoice = true then begin
            bInvoice := true;
            IF WhseShipmentLine."Source Type" = Database::"Sales Line" then begin
                SalesLn.Reset();
                SalesLn.SetRange("Document No.", WhseShipmentLine."Source No.");
                SalesLn.SetRange("Document Type", SalesLn."Document Type"::Order);
                SalesLn.SetFilter(SalesLn."Outstanding Quantity", '>%1', 0);
                IF SalesLn.FindSet() then
                    repeat
                        If SalesLn.Type <> SalesLn.Type::Item then
                            bInvoice := false
                        else begin
                            Item.Get(SalesLn."No.");
                            If Item.Type <> Item.Type::Inventory then
                                bInvoice := false;
                        end;
                    until (SalesLn.Next() = 0) or (bInvoice = false);

                if bInvoice = false then begin
                    Invoice := false;
                    Message(txtNoInvoice, WhseShipmentLine."Source No.");
                end;

            end;
        end;
    end;
    //mbr 12/20/24 - end
    */


    // PR 1/2/25 - on ship and invoice from Warehouse Shipment include NON 
    //             inventory items that have qty to invoice when invoicing
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment (Yes/No)", OnAfterConfirmPost, '', false, false)]

    local procedure OnAfterConfirmPostFromWhse(WhseShipmentLine: Record "Warehouse Shipment Line"; Invoice: Boolean)
    var
        GetSalesHeader: record "Sales Header";
        txtOtherTypesFound: Label 'Do you want to include Non-Item charges?';
        txtAbort: Label 'Task Aborted!';
        salesLine: Record "Sales Line";
        UserSetup: Record "User Setup";
        txtNotInRangeErr: Label 'Posting Date %1 is outside your allowable posting date range.  Please correct.';
        txtConfrimMessage: Label 'Posting Date of %1 needs to be %2.  Do you want to override by forcing posting date of %3?';
        Cust: Record Customer;
        TxtShipDateNotMatch: Label 'Shipment Date MUST BE EQUAL to the Posting Date for EDI ASN Customers.';
    begin
        GetSalesHeader.Reset();
        GetSalesHeader.SetRange("No.", WhseShipmentLine."Source No.");
        GetSalesHeader.SetRange("Document Type", GetSalesHeader."Document Type"::Order);
        IF GetSalesHeader.FindFirst() then begin
            if GetSalesHeader."Document Type" = GetSalesHeader."Document Type"::Order then begin
                Cust.Reset;
                IF Cust.Get(GetSalesHeader."Sell-to Customer No.") then begin
                    IF Cust."EDI ASN Customer" = true then begin

                        // pr 8/14/24 - if customer is an  EDI ASN Customer, check Shipment Date in the 
                        //              sales order and if Shipment Date <> Posting Date, error out and remind user shipment Date <> Posting Date;
                        if (GetSalesHeader."Shipment Date" <> GetSalesHeader."Posting Date") then
                            ERROR(TxtShipDateNotMatch);
                    end;
                end;
            end;
            //PR 4/15/25 - check if posting date equals today - start 
            if (GetSalesHeader."Posting Date" <> Today) then begin
                UserSetup.Reset();
                UserSetup.SetRange("User ID", UserId);
                if (UserSetup.FindSet()) then begin
                    // check if the posting date is within rage of ther user's posting date range
                    if (GetSalesHeader."Posting Date" <= UserSetup."Allow Posting To") and (GetSalesHeader."Posting Date" >= UserSetup."Allow Posting From") then begin
                        //give Confirmation Dialog
                        if Dialog.Confirm(StrSubstNo(txtConfrimMessage, GetSalesHeader."Posting Date", Today, GetSalesHeader."Posting Date"), true) = false then begin
                            Error(txtAbort);
                        end
                    end
                    else
                        Error(txtNotInRangeErr, GetSalesHeader."Posting Date");

                end
                else
                    Error(txtNotInRangeErr, GetSalesHeader."Posting Date");
            end;
            //PR 4/15/25 - check if posting date equals today - end 
        end;



        //mbr 5/20/24 - check if there are other types of sales line records <> item
        IF Invoice = true then begin
            if (WhseShipmentLine."Source Type" = Database::"Sales Line") and (WhseShipmentLine."Source Document" = WhseShipmentLine."Source Document"::"Sales Order") then begin
                GetSalesHeader.Reset();
                GetSalesHeader.SetRange("No.", WhseShipmentLine."Source No.");
                GetSalesHeader.SetRange("Document Type", GetSalesHeader."Document Type"::Order);
                IF GetSalesHeader.FindFirst() then begin
                    salesline.Reset();
                    salesline.SetRange("Document No.", GetSalesHeader."No.");
                    salesline.SetRange("Document Type", GetSalesHeader."Document Type");
                    salesline.SetFilter(Type, '<>%1', salesline.Type::Item);
                    if salesline.findset then begin
                        if Dialog.Confirm(StrSubstNo(txtOtherTypesFound, GetSalesHeader."No."), true) = true then begin
                            GetSalesHeader.IncludeNonItemWhsePost := TRUE;
                            GetSalesHeader.Modify();
                        end
                        else
                            Error(txtAbort);
                    end;




                end;



            end;

        end;

    end;
    // PR 1/2/25 - end


    var
        PurchInvHdr: Record "Purch. Inv. Header";
        SalesInvHdr: Record "Sales Invoice Header";
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        PurchaseCrMemoHdr: Record "Purch. Cr. Memo Hdr.";

        SalesLn: Record "Sales Line";
        Item: Record Item;
        bInvoice: boolean;
        txtNoInvoice: Label 'Sales Order %1 contains line items that are NON-INVENTORY.  Invoicing cannot be done in Warehouse Shipment.  Please invoice in SO card.';
}
