pageextension 50006 SalesOrderSubFromExt extends "Sales Order Subform"
{
    layout
    {
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Planned Shipment Date")
        {

            Visible = false;
        }
        modify(Description)
        {
            Visible = false;
        }

        modify(Quantity)
        {
            StyleExpr = TxtStyleExpr;
            trigger OnAfterValidate()
            var
                SalesHeadr: Record "Sales Header";
                Item: Record Item;
            begin
                if Rec.Type = Rec.Type::Item then begin
                    Item.Get(Rec."No.");
                    If Item.Type = Item.Type::Inventory then begin
                        Commit();
                        UpdateParentPackageCnt();
                        // pr 12/6/24
                        SalesHeadr.Reset();
                        SalesHeadr.SetRange("No.", rec."Document No.");
                        SalesHeadr.SetRange("Document Type", Rec."Document Type");
                        if (SalesHeadr.FindSet()) then begin
                            if rec.Quantity <> xRec.Quantity then
                                SalesHeadr.ReCalcEDI(false);

                        end;

                        //pr 12/6/24
                    end;

                end;

            end;

        }
        modify("Qty. to Ship")
        {
            trigger OnAfterValidate()
            var
                SalesHeadr: Record "Sales Header";
            begin
                if rec."Qty. to Ship" <> xRec."Qty. to Ship" then begin
                    if Rec.Type = Rec.Type::"Item" then begin
                        SalesHeadr.Reset();
                        SalesHeadr.SetRange("No.", rec."Document No.");
                        SalesHeadr.SetRange("Document Type", Rec."Document Type");
                        if (SalesHeadr.FindSet()) then begin
                            if StrPos(SalesHeadr."Your Reference", 'EDI-') > 0 then
                                //ReCalcEDI(SalesHeadr, true);
                                SalesHeadr.ReCalcEDI(false);
                        end;
                    end;
                end;


            end;
        }

        addafter(Quantity)
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
            field("M-Pack Weight"; Rec."M-Pack Weight")
            {
                ApplicationArea = all;
                enabled = false;
            }
            field("EDI Sequence Line No."; Rec."EDI Sequence Line No.")
            {
                ApplicationArea = all;
                Enabled = true;
                Editable = false;
            }
            field(UnitPriceChecked; Rec.UnitPriceChecked)
            {
                ApplicationArea = All;
            }

        }
        addafter("Unit Price")
        {
            // 9/19/25 - start
            field("Cubage per M-Pack"; rec.CubagMPack)
            {
                ToolTip = 'Cubage per M-Pack';
                ApplicationArea = All;
            }
            field(CBF; rec.GetCBF())
            {
                ToolTip = 'CBF = Cubage per M-Pack x package Count (ft)';
                ApplicationArea = All;
                DecimalPlaces = 2 : 5;
            }
            field("GW(lbs)"; rec.GetGW())
            {
                ToolTip = 'GW(lbs) = M-pack weight (lbs) x package count';
                ApplicationArea = All;
                DecimalPlaces = 2 : 5;
            }
            // 9/19/25 - end
            field("EDI Inv Line Discount"; Rec."EDI Inv Line Discount")
            {
                ApplicationArea = all;
                DecimalPlaces = 5;
            }
            field("SPS EDI Unit Price"; Rec."SPS EDI Unit Price")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

        addafter("Shipment Date")
        {
            field("APT Date"; Rec."APT Date")
            {
                ApplicationArea = all;
            }
            field("APT Time"; Rec."APT Time")
            {
                ApplicationArea = all;
            }
            field(ItemNotes; Rec.ItemNotes)
            {
                ApplicationArea = All;
            }
            field("Start Ship Date"; Rec."Start Ship Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Invoice Disc. Pct.")
        {
            field(totalQty; totalQty)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Total Item Inventory Qty.';
                DecimalPlaces = 0 : 5;
            }
        }
        addafter("Total Amount Incl. VAT")
        {
            field(totalReservedQty; totalReservedQty)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Total Item Reserved Qty.';
                DecimalPlaces = 0 : 5;
            }


        }
        addafter("Item Reference No.")
        {
            field("Real Time Item Description"; Rec."Real Time Item Description")
            {
                ApplicationArea = all;
            }
        }


    }


    var
        PackageCount: Decimal;
        TxtStyleExpr: Text;
        Item: Record Item;
        totalQty: Decimal;
        totalReservedQty: Decimal;
        GetSalesLine: Record "Sales Line";
        genCU: Codeunit GeneralCU;
        txtNoUnitPrice: Label 'Item %1 has NO sales price set up for customer %2';
        txtTaskAborted: Label 'Task Aborted';
        txtOverrideNoPrice: Label 'Item %1 has NO sales price set up for customer %2.  Do you want to use the Item Unit Price of %3?';


    trigger OnAfterGetRecord()

    begin
        UpdatePackageCnt();
        UpdateQtyStyle();
        CalculateSubtotals();
        rec.CalcFields("Real Time Item Description", "In the Month", CubagMPack);
    end;





    procedure UpdatePackageCnt()
    begin
        PackageCount := 0;
        If Rec.Type = Rec.Type::Item then begin
            If Item.Get(Rec."No.") then
                if Item.Type = Item.Type::Inventory then begin
                    Rec.CalcFields("M-Pack Qty", "M-Pack Weight");

                    IF Rec."M-Pack Qty" > 0 then
                        PackageCount := Rec."Quantity (Base)" / Rec."M-Pack Qty";

                end;
        end;



    end;

    procedure UpdateQtyStyle()

    begin
        If Rec.Type = Rec.Type::Item then begin
            If Item.Get(Rec."No.") then
                if Item.Type = Item.Type::Inventory then begin
                    Rec.Calcfields("Reserved Qty. (Base)");
                    If (rec."Quantity (Base)" <> Rec."Reserved Qty. (Base)") and (Rec."Quantity (Base)" <> 0) then
                        TxtStyleExpr := 'Unfavorable'
                    else
                        TxtStyleExpr := 'Standard';
                end
                Else
                    TxtStyleExpr := 'Standard';
        end
        Else
            TxtStyleExpr := 'Standard';
    end;


    Procedure UpdateParentPackageCnt()
    var
        GetPackageCnt: Decimal;
        GetWeight: Decimal;
        SalesHdr: Record "Sales Header";
        SalesLine: record "Sales Line";
    begin
        SalesHdr.Reset();
        SalesHdr.SetRange("No.", rec."Document No.");
        SalesHdr.SetRange("Document Type", Rec."Document Type");
        if SalesHdr.FindFirst() then begin
            GetPackageCnt := 0;
            GetWeight := 0;
            SalesLine.RESET;
            SalesLine.SetRange("Document No.", Rec."Document No.");
            SalesLine.SetRange("Document Type", Rec."Document Type");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            IF SalesLine.FindSet() then
                repeat
                    SalesLine.CalcFields("M-Pack Qty", "M-Pack Weight");
                    IF SalesLine."M-Pack Qty" > 0 then begin
                        GetPackageCnt := GetPackageCnt + (SalesLine."Quantity (Base)" / SalesLine."M-Pack Qty");
                        GetWeight := GetWeight + ((SalesLine."Quantity (Base)" / SalesLine."M-Pack Qty") * SalesLine."M-Pack Weight");
                    end;
                until SalesLine.Next = 0;

            SalesHdr."Total Package Count" := GetPackageCnt;
            SalesHdr."Total Weight" := GetWeight;
            SalesHdr.Modify();
            CurrPage.Update();

        end;
    end;

    // procedure SetTotalQty(num: Decimal)
    // begin
    //     totalQty := num;
    // end;

    procedure CalculateSubtotals()
    var

    begin
        totalQty := 0;
        totalReservedQty := 0;
        if Rec."Document Type" = Rec."Document Type"::Order then begin

            GetSalesLine.Reset();

            GetSalesLine.SetRange("Document No.", rec."Document No.");
            GetSalesLine.SetRange(Type, GetSalesLine.Type::Item);

            if (GetSalesLine.FindSet()) then
                repeat
                    IF Item.Get(GetSalesLine."No.") then
                        if Item.Type = Item.Type::Inventory then begin
                            totalQty += GetSalesLine.Quantity;
                            GetSalesLine.CalcFields("Reserved Quantity");
                            totalReservedQty += GetSalesLine."Reserved Quantity";
                        end;

                until GetSalesLine.next = 0;
        end;

    end;

    procedure ReCalcEDI(var recSH: Record "Sales Header"; bInvoice: Boolean)
    var
        RealTotalSalesLineAmt: Decimal;
        EDIUnitPrice: Decimal;
        ItemUOM: Record "Item Unit of Measure";
        Customer: Record Customer;
        TotalSPSInvoiceamount: Decimal;
        TotalSPSInvoiceamountItems: Decimal;
        SalesLineRef: RecordRef;
        EDIUnitPriceRef: FieldRef;
        SalesLineQtyRef: FieldRef;
        SalesLineQty: Decimal;
        EDIGLAccount: Record "EDI G\L Account";
        bReleased: Boolean;
        SalesLine: Record "Sales Line";

    begin
        if (StrPos(recSH."Your Reference", 'EDI-') > 0) and (recSH."EDI discount Calculated" = true) then begin
            if recSH.Status = recSH.Status::Released then
                bReleased := true
            else
                bReleased := false;

            Customer.Reset();
            Customer.SetRange("No.", recSH."Sell-to Customer No.");
            if (Customer.FindFirst()) then begin

                //Calulate Invoice Total less the G/L Accounts from EDI GLAccounts
                TotalSPSInvoiceamountItems := 0;
                Commit;
                SalesLine.Reset();
                SalesLine.SetRange("Document No.", recSH."No.");
                SalesLine.SetRange("Document Type", RecSH."Document Type");
                if (SalesLine.FindSet()) then
                    repeat
                        if NOT EDIGLAccount.GET(SalesLine."No.") then begin
                            if bInvoice = true then begin
                                if SalesLine."Line No." <> Rec."Line No." then
                                    TotalSPSInvoiceamountItems += SalesLine."Qty. to Invoice" * SalesLine."Unit Price"
                                else
                                    TotalSPSInvoiceamountItems += Rec."Qty. to Ship" * Rec."Unit Price";
                            end

                            else
                                TotalSPSInvoiceamountItems += Rec."Line Amount";
                        end;

                    until SalesLine.next = 0;
                // calculate and assigns InvoiceDiscount %
                if bReleased = true then begin
                    recSH.Status := recSH.Status::Open;
                    recSH.Modify();
                end;


                SalesLine.Reset();
                SalesLine.SetRange("Document No.", RecSH."No.");
                SalesLine.SetRange(Type, SalesLine.Type::"G/L Account");
                SalesLine.SetRange("Document Type", RecSH."Document Type");
                if (SalesLine.FindSet()) then
                    repeat
                        if EDIGLAccount.GET(SalesLine."No.") then begin
                            IF SalesLine."EDI Inv Line Discount" <> 0 then begin
                                SalesLine.Validate("Unit Price", Round((SalesLine."EDI Inv Line Discount" * TotalSPSInvoiceamountItems * -1), 0.01, '='));
                                SalesLine.Modify();
                            end;
                        end;


                    until SalesLine.next = 0;
                if bReleased = true then begin
                    RecSH.Status := RecSH.Status::Released;
                    RecSH.Modify();
                end;

            end;

        end;





    end;

}
