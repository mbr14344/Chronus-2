tableextension 50021 SalesLineTableExt extends "Sales Line"
{

    //pr 1/12/24 added fields for sales line
    fields
    {

        field(50000; "Document Date"; Date)
        {
            Caption = 'Document Date';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."Document Date" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));

        }
        field(50001; "Order Reference"; Text[20])
        {
            Caption = 'Order Reference';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."Order Reference" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50002; "ZDEL APT Date"; Date)  //mbr 3/8/24 - transferred to Sales Header
        {
            Caption = 'APT Date';

        }
        field(50003; "ZDEL APT Time"; Text[20]) //mbr 3/8/24 - transferred to Sales Header
        {
            Caption = 'APT Time';

        }
        field(50004; "Split"; Boolean)
        {
            Caption = 'Split';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."Split" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50005; "Flag"; Option)
        {
            Caption = 'Flag';
            FieldClass = FlowField;
            OptionMembers = " ","0","Allocated","China Drop Ship","Extension Pending","Issue with PO","Master PO","PO SPLIT","Portal Routed","Pre-Scheduled","Ready for Billing","Routed and Waiting for Product","Scheduled","Scheduled and Waiting for Product","Transfer Pending","Waiting Product","Waiting Sales","Warehouse Processing","Order Canceled","Tendered to BC","Reschedule Pending","Need to schedule","Future Ship Date";
            OptionCaption = ' ,0,Allocated,China Drop Ship,Extension Pending,Issue with PO,Master PO,PO SPLIT,Portal Routed,Pre-Scheduled,Ready for Billing,Routed and Waiting for Product,Scheduled,Scheduled and Waiting for Product,Transfer Pending,Waiting Product,Waiting Sales,Warehouse Processing,Order Canceled,Tendered to BC,Reschedule Pending,Need to schedule,Future Ship Date';
            CalcFormula = Lookup("Sales Header".Flag WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50006; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."Ship-to City" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50007; "Ship-to State"; Text[30])
        {
            Caption = 'Ship-to State';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."Ship-to County" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50008; "Cancel Date"; Date)
        {
            Caption = 'Cancel Date';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."Cancel Date" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50009; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."External Document No." WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50010; "Customer Name"; Code[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."Sell-to Customer Name" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }

        field(50012; "M-Pack Weight"; Decimal)
        {
            Caption = 'M-Pack Weight';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure"."Weight" WHERE("Item No." = field("No."), Code = CONST('M-PACK')));
        }
        field(50011; "M-Pack Qty"; Decimal)
        {
            Caption = 'M-Pack Qty';
            FieldClass = FlowField;

            CalcFormula = lookup("Item Unit of Measure"."Qty. per Unit of Measure" WHERE("Item No." = field("No."), Code = CONST('M-PACK')));
        }
        field(50013; "EDI Sequence Line No."; Integer)
        {
            Caption = 'EDI Sequence Line No.';
        }
        field(50014; "Request Ship Date"; Date)
        {
            Caption = 'Request Ship Date';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."Request Ship Date" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50015; "Start Ship Date"; Date)
        {
            Caption = 'Start Ship Date';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."Start Ship Date" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50016; "APT Date"; Date)  //mbr 3/8/24 - lookup field from Sales Header
        {
            Caption = 'APT Date';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."APT Date" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));

        }
        field(50017; "APT Time"; Text[20]) //mbr 3/8/24 - Lookup field from Sales Header
        {
            Caption = 'APT Time';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."APT Time" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));

        }
        field(50018; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."Your Reference" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));

        }
        field(50019; "Modified By"; code[50])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Modified By" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50020; "Modified Date"; date)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Modified Date" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50021; "Created By"; code[50])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header".CreatedUserID WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50022; "Created Date"; date)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header".CreatedDate WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50023; ItemNotes; text[255])
        {
            Caption = 'Item Notes';
        }
        field(50024; Master; boolean)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header".Master WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50025; "EDI Inv Line Discount"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 2 : 5;
        }
        field(50026; "SPS EDI Unit Price"; Decimal)
        {
            Editable = false;
            Caption = 'SPS Allowance/Disc. EDI Unit Price';
        }
        field(50027; "Item Purchasing Code"; code[10])
        {
            FieldClass = FlowField;

            CalcFormula = lookup(Item."Purchasing Code" WHERE("No." = field("No.")));
        }
        field(50028; "Customer Responsibility Center"; code[10])
        {
            FieldClass = FlowField;

            CalcFormula = lookup(Customer."Responsibility Center" where("No." = field("Sell-to Customer No.")));
        }
        field(50029; "Customer Salesperson Code"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Salesperson Code" where("No." = field("Sell-to Customer No.")));
        }
        //PR 3/19/25 - start
        field(50030; "CubagMPack"; Decimal)
        {
            Caption = 'Cubage per M-Pack';
            FieldClass = FlowField;

            CalcFormula = lookup("Item Unit of Measure".Cubage WHERE("Item No." = field("No."), Code = CONST('M-PACK')));
            DecimalPlaces = 2 : 5;
        }
        //PR 3/19/25 - end
        field(50031; ShippingLabelStyle; code[30])
        {
            Caption = 'Shipping Label Style Report';
            FieldClass = FlowField;
            TableRelation = ReportLabelStyle;
            CalcFormula = lookup("Sales Header".ShippingLabelStyle WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50032; UnitPriceChecked; Boolean)
        {
            Caption = 'Unit Price Checked';
            Editable = false;
        }
        field(50033; ItemType; Enum "Item Type")
        {
            Caption = 'Item Type';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Type where("No." = field("No.")));
        }
        field(50034; "Real Time Item Description"; Text[100])
        {
            Caption = 'Real Time Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description WHERE("No." = field("No.")));
        }
        field(50035; "In the Month"; text[20])
        {
            Caption = 'In the Month';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."In the Month" WHERE("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                Rec.UnitPriceChecked := false;
            end;
        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                Rec.UnitPriceChecked := false;
            end;
        }

        modify("Unit of Measure Code")
        {
            trigger OnAfterValidate()
            begin
                Rec.UnitPriceChecked := false;
            end;
        }

        modify("Unit Price")
        {
            Trigger OnAfterValidate()
            begin
                // If you want to prevent future auto-calculation after user override,
                // you could set UnitPriceChecked := true; (optional)
                IF Rec.Type = Rec.Type::Item then begin
                    CalcFields(ItemType);
                    if Rec.ItemType = Rec.ItemType::Inventory then
                        Rec.UnitPriceChecked := true;
                end;

            end;
        }





    }


    trigger OnModify()
    Var
        GenCU: Codeunit GeneralCU;
    begin
        if rec."Document Type" = rec."Document Type"::Order then begin
            //7/3/25 - Update Earliest Start Ship Date - start
            if Rec.Type = Rec.Type::Item then
                GenCU.UpdSO_UpdEarliestStartDtItemNo(Rec."No.");
            //7/3/25 - Update Earliest Start Ship Date - end
            RunModTrigger();
        end;

    end;

    //mbr 3/11/25 - On delete of Sale Line record, run RecalcEDI
    trigger OnAfterDelete()
    begin
        if rec."Document Type" = rec."Document Type"::Order then
            RunDelTrigger();
    end;
    //mbr 3/11/25 - end

    trigger OnAfterInsert()
    Var
        GenCU: Codeunit GeneralCU;
        SalesHeader: Record "Sales Header";
    begin
        UpdateUnitPriceByReqDelDt(Rec);
        if rec."Document Type" = rec."Document Type"::Order then begin
            SalesHeader.Reset();
            SalesHeader.SetRange("No.", rec."Document No.");
            SalesHeader.SetRange("Document Type", Rec."Document Type");
            if SalesHeader.FindFirst() Then
                GenCU.UpdateEarliestStartShipDate(SalesHeader);
            RunModTrigger();
        end;

    end;

    trigger OnAfterModify()
    begin
        UpdateUnitPriceByReqDelDt(Rec);
    end;

    //PR 3/19/25 - start
    procedure GetPackageCount() ReturnValue: decimal
    var
        Item: Record Item;
        PackageCount: Decimal;
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
        ReturnValue := PackageCount;
    end;

    procedure RunEDIDiscountCalc()
    var
        getSO_NO: Code[20];
        SalesHeader: Record "Sales Header";
        GenCU: Codeunit GeneralCU;
    begin
        if rec."Document Type" = rec."Document Type"::Order then begin
            SalesHeader.Reset();
            SalesHeader.SetCurrentKey("No.", "Document Type");
            SalesHeader.SetRange("No.", Rec."No.");
            SalesHeader.SetRange("Document Type", Rec."Document Type");
            If SalesHeader.FindFirst() then begin
                if getSO_NO <> Rec."No." then begin
                    getSO_NO := Rec."No.";
                    //GenCU.CalcEDI(SalesHeader, true);
                    SalesHeader.CalcEDI(true);
                end;

            end;
        end;

    end;

    procedure GetCBF() ReturnValue: decimal
    var
        UOM: Record "Unit of Measure";
        inToFtDivisor: Decimal;
        CBF: Decimal;
    begin
        rec.CalcFields(rec.CubagMPack);

        UOM.Reset();
        UOM.SetRange(Code, 'FT');
        if (UOM.FindFirst()) then
            inToFtDivisor := uom."Convert Down Unit" * uom."Convert Down Unit" * uom."Convert Down Unit";
        if inToFtDivisor = 0 Then
            Error(txtInToFtDivisorZero);

        CBF := ((rec.CubagMPack / inToFtDivisor) * rec.GetPackageCount);
        ReturnValue := CBF;
    end;

    procedure GetGW() ReturnValue: decimal
    begin
        rec.CalcFields("M-Pack Weight");
        ReturnValue := rec."M-Pack Weight" * rec.GetPackageCount;
    end;
    //PR 3/19/25 - end
    local procedure BlanketOrderIsRelated(var BlanketOrderSalesLine: Record "Sales Line"): Boolean
    var
        IsHandled, Result : Boolean;
    begin
        IsHandled := false;
        Result := false;
        if IsHandled then
            exit(Result);

        if "Blanket Order Line No." = 0 then exit;
        BlanketOrderSalesLine.SetLoadFields("Unit Price", "Line Discount %");
        if BlanketOrderSalesLine.Get("Document Type"::"Blanket Order", "Blanket Order No.", "Blanket Order Line No.") then
            exit(true);
    end;

    procedure CheckForSalesPrice()
    var
        SalesLine: Record "Sales Line" temporary;
        oldUnitPrice: Decimal;
        item: Record Item;
        salesPrice: Record "Sales Price";
        UserSetup: Record "User Setup";
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        nullDate: Date;
    begin
        Customer.reset;
        Customer.SetRange("No.", rec."Sell-to Customer No.");
        Customer.SetRange("Exempt from Sales Price Check", false);
        if (Customer.FindSet()) then begin
            if ("Document Type" = "Document Type"::Order) and (type = type::Item) then begin
                item.Reset();
                item.Get(rec."No.");
                // check for sales price
                if (item.Type = item.Type::Inventory) then begin
                    SalesHeader.Reset;
                    SalesHeader.SetRange("No.", rec."Document No.");
                    SalesHeader.SetRange("Document Type", rec."Document Type");
                    SalesHeader.SetRange("Sell-to Customer No.", rec."Sell-to Customer No.");
                    if (SalesHeader.FindFirst()) then begin
                        nullDate := 0D;
                        salesPrice.Reset();
                        salesPrice.SetRange("Item No.", item."No.");
                        salesPrice.SetRange("Sales Type", salesPrice."Sales Type"::Customer);
                        salesPrice.SetRange("Sales Code", rec."Sell-to Customer No.");
                        salesPrice.SetFilter("Minimum Quantity", '<=%1', rec.Quantity);
                        salesPrice.SetFilter("Starting Date", '<=%1|%2', SalesHeader."Order Date", 0D);
                        salesPrice.SetFilter("Ending Date", '>=%1|%2', SalesHeader."Order Date", 0D);
                        salesPrice.SetRange("Unit of Measure Code", rec."Unit of Measure Code");
                        // if no sales prrice then check unit price
                        if (not salesPrice.FindSet()) then begin

                            UserSetup.Reset();
                            UserSetup.SetRange("User ID", UserId);
                            UserSetup.SetRange(FinanceAdmin, true);
                            if (UserSetup.FindFirst()) then begin
                                if (Confirm(StrSubstNo(txtOverrideNoPrice, item."No.", rec."Sell-to Customer No.", rec."Unit Price")) = false) then
                                    Error(txtTaskAborted);
                            end
                            else
                                Error(txtNoUnitPrice, item."No.", rec."Sell-to Customer No.");

                        end
                    end;
                end;
            end;
        end;


    end;

    //PR 4/15/25 - start
    procedure GetEdiUnitPriceSPS() returnVal: Decimal
    var
        SalesLineRef: RecordRef;
        EDIUnitPriceRef: FieldRef;
        SalesLineQtyRef: FieldRef;
    begin
        SalesLineRef.Open(Database::"Sales Line");
        SalesLineRef.GetTable(rec);
        SalesLineRef.SetRecFilter();
        if (SalesLineRef.FindSet()) then begin
            EDIUnitPriceRef := SalesLineRef.Field(70043);
            returnVal := EDIUnitPriceRef.Value();
            //  rec.ediUnitPriceSPS := EDIUnitPrice;
        end;
        SalesLineRef.Close();

    end;
    //PR 4/15/25 - end



    //mbr 6/9/25 - start
    //UpdateUnitPriceUsingReqDelDt
    //this procedure updates the unit price of the sales line based on the requested delivery dates from Sales Header
    procedure UpdateUnitPriceByReqDelDt(var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        SalesPrice: Record "Sales Price";
        UseDate: Date;
    begin
        // Only update if not already checked or user-overridden
        if SalesLine.UnitPriceChecked then
            exit;
        //Only update if Sales Order and Type Item
        if (SalesLine."Document Type" <> SalesLine."Document Type"::Order) or (SalesLine.Type <> SalesLine.Type::Item) then
            exit;
        //Only update if Type item = Inventory
        SalesLine.Calcfields(ItemType);
        if SalesLine.ItemType <> SalesLine.ItemType::Inventory then
            exit;

        if not SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
            exit;
        if not Customer.Get(SalesLine."Sell-to Customer No.") then
            exit;
        if not Customer.SalesPriceByReqDelDt then
            exit;
        UseDate := SalesHeader."Requested Delivery Date";
        SalesPrice.Reset();
        SalesPrice.SetRange("Item No.", SalesLine."No.");
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::Customer);
        SalesPrice.SetRange("Sales Code", SalesLine."Sell-to Customer No.");
        SalesPrice.SetFilter("Starting Date", '<=%1|%2', UseDate, 0D);
        SalesPrice.SetFilter("Ending Date", '>=%1|%2', UseDate, 0D);
        SalesPrice.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
        if SalesPrice.FindFirst() then begin
            SalesLine.VALIDATE("Unit Price", SalesPrice."Unit Price");
            SalesLine.UnitPriceChecked := true;
        end;
    end;

    procedure RunModTrigger()
    var
        CartonInfo: Record CartonInformation;
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        GetPackageCnt: Decimal;
        GetWeight: Decimal;
        txtPkgInfo: Label 'There is an existing package information for Sale Order %1.  This should be deleted and refreshed since you modified the quantity of Item %2.  Do you want to keep this package information instead?';
        txtPkgRefresh: Label 'Package information is currently Not in line with your Item quantities. It is recommended to refresh package.';
    begin
        if rec."Quantity" <> xrec."Quantity" then begin
            CartonInfo.Reset;
            CartonInfo.SetRange("Document Type", Rec."Document Type");
            CartonInfo.SetRange("Document No.", rec."Document No.");
            if CartonInfo.findset then begin
                //8/21/25 - start
                if (Dialog.Confirm(StrSubstNo(txtPkgInfo, Rec."Document No.", rec."No.")) = false) then begin
                    // if said no
                    CartonInfo.DeleteAll();
                end
                else begin
                    Message(txtPkgRefresh);
                end;
                //8/21/25 - end

            end;



            //now, let's update the Sales Header Total Package Count, Weight
            GetPackageCnt := 0;
            GetWeight := 0;
            SalesLine.RESET;
            SalesLine.SetRange("Document No.", rec."Document No.");
            SalesLine.SetRange("Document Type", rec."Document Type");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            IF SalesLine.FindSet() then
                repeat
                    SalesLine.CalcFields("M-Pack Qty", "M-Pack Weight");
                    IF SalesLine."M-Pack Qty" > 0 then begin
                        GetPackageCnt := GetPackageCnt + (SalesLine."Quantity (Base)" / SalesLine."M-Pack Qty");
                        GetWeight := GetWeight + ((SalesLine."Quantity (Base)" / SalesLine."M-Pack Qty") * SalesLine."M-Pack Weight");
                    end;

                until SalesLine.Next = 0;
            SalesHeader.Reset();
            SalesHeader.SetRange("No.", rec."Document No.");
            SalesHeader.SetRange("Document Type", rec."Document Type");
            IF SalesHeader.FindFirst() then begin
                SalesHeader."Total Package Count" := GetPackageCnt;
                SalesHeader."Total Weight" := GetWeight;
                SalesHeader.Modify();
            end;
        end;
    end;

    procedure RunDelTrigger()
    var
        SalesHeader: Record "Sales Header";
        genCU: Codeunit GeneralCU;
    begin
        IF rec."Document Type" = rec."Document Type"::Order then begin
            SalesHeader.Reset();
            SalesHeader.SetRange("No.", rec."Document No.");
            SalesHeader.SetRange("Document Type", Rec."Document Type");
            if (SalesHeader.FindSet()) then begin
                SalesHeader.ReCalcEDI(false);

            end;
        end;
        //7/3/25 - Given Item no. - update PurchaseLine and Container Line update earliest Start Ship Date - start
        If (rec.Type = rec.Type::Item) and (rec."Document Type" = rec."Document Type"::Order) then
            genCU.UpdSO_UpdEarliestStartDtItemNo(Rec."No.");
        //7/3/25 - Given Item no. - update PurchaseLine and Container Line update earliest Start Ship Date - end
    end;

    var
        txtNoUnitPrice: Label 'Item %1 has NO sales price set up for customer %2';
        txtTaskAborted: Label 'Task Aborted';
        txtOverrideNoPrice: Label 'Item %1 has NO sales price set up for customer %2.  Do you want to use the Item Unit Price of %3?';
        txtInToFtDivisorZero: Label 'Conversion from Inch to Feet not found.  Please review.';

}
