page 50070 AssignItemFromCartonInfo
{
    ApplicationArea = All;
    Caption = 'Assign Items Onto Pallet';
    PageType = List;
    SourceTable = "AssignItemsFromCartInfo";
    UsageCategory = None;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTableTemporary = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("SCC No."; Rec."SCC No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("SO No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("M-Pack qty R/O"; Rec."M-Pack qty R/O")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Assigned Qty"; Rec."Assigned Qty")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Assigned Packages"; Rec."Assigned Packages")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Remaining Qty To Assign"; Rec."Remaining Qty To Assign")
                {
                    ApplicationArea = all;
                    Editable = false;
                    StyleExpr = TxtStyleExpr;
                }
                field("Remaining Pkg To Assign"; Rec."Remaining Pkg To Assign")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Qty to Assign"; Rec."Qty to Assign")
                {
                    ApplicationArea = all;
                    StyleExpr = 'Favorable';
                    trigger OnValidate()
                    begin
                        if (rec.Quantity - rec."Assigned Qty" - rec."Qty to Assign" < 0) then
                            Error(txtAssignedTooMuchErr, rec."Qty to Assign", rec."No.", rec."Assigned Qty" + rec."Qty to Assign", rec.Quantity)
                    end;
                }
                field("Package Qty to Assign"; rec."Package Qty to Assign")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("M-Pack Qty"; Rec."M-Pack Qty")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Submit")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Approve;
                trigger OnAction()
                var
                    cartonInfo: Record CartonInformation;
                    itemInfo: Dictionary of [code[20], Decimal];
                    reservedItemInfo: Dictionary of [code[20], Decimal];
                    tmpQty: Decimal;
                    tmpReservedQty: Decimal;
                    tmpKey: code[20];
                    SalesLine: Record "Sales Line";
                    lastLine: Integer;
                    cartonInfoLast: Record CartonInformation;
                    totalPkgCount: Integer;
                begin
                    // adds up the qty assigned for each item 
                    if (rec.FindSet()) then
                        repeat
                            if (rec."Qty to Assign" > 0) then begin
                                if (itemInfo.ContainsKey(rec."No.")) then begin
                                    // saves the qty assigned
                                    tmpQty := itemInfo.Get(rec."No.");
                                    tmpQty += (rec."Qty to Assign");
                                    itemInfo.Set(rec."No.", tmpQty);

                                end
                                else begin
                                    itemInfo.Add(rec."No.", rec."Qty to Assign");
                                    reservedItemInfo.Add(rec."No.", (rec."Qty to Assign" + rec."Assigned Qty"));
                                end;
                            end;
                        until rec.Next() = 0;
                    // finds the LineCount of the newest pkg info
                    cartonInfoLast.Reset();
                    cartonInfoLast.SetCurrentKey(LineCount);
                    cartonInfoLast.SetRange("Document No.", AssignedSalesHdr."No.");
                    cartonInfoLast.SetRange(Posted, false);
                    if (cartonInfoLast.FindLast()) then
                        lastLine := cartonInfoLast.LineCount;
                    // assigns to either exisitng pkg infor or creates a new one  
                    foreach tmpKey in itemInfo.Keys() do begin
                        tmpReservedQty := reservedItemInfo.GET(tmpKey);
                        tmpQty := itemInfo.Get(tmpKey);
                        SalesLine.Reset();
                        SalesLine.SetRange("Document No.", AssignedSalesHdr."No.");
                        SalesLine.SetRange(Type, SalesLine.Type::Item);
                        SalesLine.SetRange("No.", tmpKey);
                        if (SalesLine.FindFirst()) then begin
                            // if assgning to existing pkg info
                            cartonInfo.Reset();
                            cartonInfo.SetRange("Serial No.", newSSCC);
                            cartonInfo.SetRange("Item No.", tmpKey);
                            cartonInfo.SetRange("Document No.", AssignedSalesHdr."No.");
                            cartonInfo.SetRange(Posted, false);
                            if (cartonInfo.FindFirst()) then begin
                                // if assigned too much qty
                                if (tmpReservedQty > SalesLine.Quantity) then
                                    Error(txtAssignedTooMuchErr, tmpQty, tmpKey, tmpReservedQty, SalesLine.Quantity)
                                else begin
                                    CartonInfo."Item Reserved Quantity" += tmpQty;
                                    cartonInfo."Reserved Quantity" := ROUND(CartonInfo."Item Reserved Quantity" / CartonInfo."M-Pack Qty", 1, '<');
                                    CartonInfo.Modify();
                                end;
                            end
                            // if creating new pkg info 
                            else begin

                                lastLine += 1;
                                CartonInfo.Init();
                                CartonInfo."Document Type" := SalesLine."Document Type";
                                CartonInfo."Item No." := SalesLine."No.";
                                CartonInfo."Document No." := SalesLine."Document No.";
                                CartonInfo."DocumentLine No." := SalesLine."Line No.";
                                CartonInfo."Line No." := 0;
                                CartonInfo."Item Reserved Quantity" += tmpQty;

                                CartonInfo.LineCount := lastLine;
                                CartonInfo."Serial No." := newSSCC;
                                CartonInfo."Unit of Measure Code" := SalesLine."Unit of Measure Code";
                                //  CartonInfo."Item Reserved Quantity" := SalesLine."Quantity (Base)";
                                SalesLine.CalcFields("M-Pack Qty", "M-Pack Weight");
                                CartonInfo."M-Pack Qty" := SalesLine."M-Pack Qty";
                                //   CartonInfo."Package Quantity" := SalesLine."M-Pack Qty";
                                CartonInfo.Weight := SalesLine."M-Pack Weight";
                                SalesLine.CalcFields(ShippingLabelStyle);
                                //10/2/25 - start - make sure ShippingLabelStyle is filled in from Sales Order.  If not, then error out
                                if SalesLine.ShippingLabelStyle = '' then
                                    Error('Shipping Label Style is blank on Sales Order %1 for item %2. Please fill it in before assigning items to a pallet.', SalesLine."Document No.", SalesLine."No.");
                                //10/2/25 - end
                                CartonInfo.Validate(ShippingLabelStyle, SalesLine.ShippingLabelStyle);
                                if (CartonInfo."M-Pack Qty" > 0) and (CartonInfo."Item Reserved Quantity" > 0) then
                                    cartonInfo."Reserved Quantity" := ROUND(CartonInfo."Item Reserved Quantity" / CartonInfo."M-Pack Qty", 1, '<')
                                else
                                    cartonInfo."Reserved Quantity" := cartonInfo."Item Reserved Quantity";
                                CartonInfo.Insert();

                            end;
                        end;
                    end;
                    // gets total packages added
                    totalPkgCount := 0;
                    cartonInfo.Reset();
                    cartonInfo.SetRange("Serial No.", newSSCC);
                    cartonInfo.SetRange("Document No.", AssignedSalesHdr."No.");
                    cartonInfo.SetRange(Posted, false);
                    if (cartonInfo.FindSet()) then
                        repeat
                            totalPkgCount += cartonInfo."Reserved Quantity";
                        until cartonInfo.Next() = 0;
                    // assign total pkg count
                    cartonInfo.Reset();
                    cartonInfo.SetRange("Serial No.", newSSCC);
                    cartonInfo.SetRange("Document No.", AssignedSalesHdr."No.");
                    cartonInfo.SetRange(Posted, false);
                    if (cartonInfo.FindSet()) then
                        repeat
                            cartonInfo."Package Quantity" := totalPkgCount;
                            cartonInfo.Modify();
                        until cartonInfo.Next() = 0;
                    CurrPage.Close();
                end;

            }
        }
    }
    procedure Initiate(CartonInfo: Record CartonInformation; SalesHdr: Record "Sales Header"; bNew: Boolean)
    begin
        AssignedSalesHdr := SalesHdr;
        SetCartonInfoToAsiign(CartonInfo);
        GetLineFromSalesOrder(SalesHdr, bNew);
    end;

    procedure SetCartonInfoToAsiign(CartonInfo: Record CartonInformation)
    begin
        cartonInfoToAssign := CartonInfo;
    end;

    procedure GetLineFromSalesOrder(SalesHdr: Record "Sales Header"; bNew: Boolean)
    var
        SalesLine: Record "Sales Line";
        Item: Record Item;
        cartonInfo: Record CartonInformation;
        cartonInfoLast: Record CartonInformation;
        lastLine: Integer;
        totalAssignedQty: Decimal;
    begin

        lastLine := 1;
        // checks if opened from empty carton info 
        if (bNew) then begin
            cartonInfoLast.Reset();
            cartonInfoLast.SetRange("Document No.", SalesHdr."No.");
            cartonInfoLast.SetRange(Posted, false);
            if (cartonInfoLast.FindLast()) then
                lastLine := cartonInfoLast.LineCount;
            SalesLine.Reset();
            SalesLine.SetRange("Document No.", SalesHdr."No.");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            if (SalesLine.FindFirst()) then begin
                //check if Item has type = Inventory;
                if Item.GET(SalesLine."No.") then;

                if item.Type = Item.Type::Inventory then begin
                    // uses the first item in sales line to create sscc
                    newSSCC := GenCU.CreateSSCC(SalesLine."Document No.", SalesLine."No.", SalesHdr."Sell-to Customer No.");
                    cartonInfo.Reset();
                    cartonInfo.SetRange("Serial No.", newSSCC);
                    cartonInfo.SetRange("Document No.", AssignedSalesHdr."No.");
                    cartonInfo.SetRange(Posted, false);
                    if (cartonInfo.FindFirst()) then
                        Error(txtDupSSCCErr, newSSCC, SalesLine."No.");
                end;

            end;

        end
        // updating selected sscc
        else
            newSSCC := cartonInfoToAssign."Serial No.";

        Rec.Reset();
        SalesLine.Reset();
        SalesLine.SetRange("Document No.", SalesHdr."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if (SalesLine.FindSet()) then
            repeat

                Item.Reset();
                item.SetRange("No.", SalesLine."No.");
                item.SetRange(Type, Item.Type::Inventory);
                if (item.FindSet()) then begin
                    SalesLine.CalcFields("M-Pack Qty", "M-Pack Weight");
                    Rec.Init();
                    Rec."No." := SalesLine."No.";
                    Rec.Description := SalesLine.Description;
                    Rec."Document No." := SalesLine."Document No.";
                    Rec."Document Type" := SalesLine."Document Type";
                    Rec.Quantity := SalesLine.Quantity;
                    Rec."M-Pack Qty" := SalesLine."M-Pack Qty";
                    Rec.Type := SalesLine.Type;
                    Rec."Unit of Measure Code" := SalesLine."Unit of Measure Code";
                    Rec."Unit Price" := SalesLine."Unit Price";
                    Rec."Source Line No." := SalesLine."Line No.";
                    rec."Cust No." := SalesHdr."Sell-to Customer No.";

                    rec."SCC No." := newSSCC;
                    cartonInfo.Reset();
                    cartonInfo.SetRange("Item No.", SalesLine."No.");
                    cartonInfo.SetRange("Document No.", AssignedSalesHdr."No.");
                    cartonInfo.SetRange(Posted, false);
                    // finds qty assigned by other sscc's for current item and sums them up to set as currrent assigned qty for that item
                    totalAssignedQty := 0;
                    if (cartonInfo.FindSet()) then
                        repeat
                            totalAssignedQty += cartonInfo."Item Reserved Quantity";
                        until cartonInfo.Next() = 0;
                    rec.Validate("Assigned Qty", totalAssignedQty);
                    rec.Validate("Qty to Assign", 0);

                    Rec.Insert();
                end;
            until SalesLine.Next() = 0;
        CurrPage.Update();
    end;

    trigger OnAfterGetRecord()
    begin
        TxtStyleExpr := 'Standard';
        if (rec."Remaining Qty To Assign" <= 0) then
            TxtStyleExpr := 'Unfavorable';
        rec.CalcFields("M-Pack qty R/O");
    end;

    var
        TxtStyleExpr: Text;
        AssignedSalesHdr: Record "Sales Header";
        cartonInfoToAssign: Record CartonInformation;
        newSSCC: code[20];
        tmpAssignItem: Record AssignItemsFromCartInfo;
        GenCU: Codeunit GeneralCU;

        txtAssignedTooMuchErr: Label 'Trying to Assign %1 to item %2 for a total of %3, which is more than the allowed %4.';
        txtDupSSCCErr: Label 'There already exists a carton info with a sscc of %1 using the item %2';

}
