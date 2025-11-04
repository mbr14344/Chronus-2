tableextension 50020 SalesHeaderTableExt extends "Sales Header"
{

    //pr 1/11/24 added extension for sales order page
    fields
    {
        modify("Sell-to Customer No.")
        {
            // pr 6/13/24 pick up the freight charge terms from Customer if exists
            trigger OnAfterValidate()
            begin
                customer.Reset();
                customer.SetRange("No.", Rec."Sell-to Customer No.");
                if (customer.FindFirst()) then begin
                    FreightChargeTerm := customer.FreightChargeTerm;
                end;
            end;
        }
        modify("Requested Delivery Date")
        {
            trigger OnAfterValidate()
            var
                SalesLine: Record "Sales Line";
                ConfirmUpdate: Boolean;
                Item: Record Item;
            begin
                if (rec."Requested Delivery Date" <> xRec."Requested Delivery Date") AND (xRec."Requested Delivery Date" <> 0D) then begin
                    //prompt user if they want to update unit prices
                    ConfirmUpdate := Confirm('Do you want to update Unit Prices for all sales lines?');
                    if ConfirmUpdate then begin
                        SalesLine.Reset();
                        SalesLine.SetRange("Document Type", Rec."Document Type");
                        SalesLine.SetRange("Document No.", Rec."No.");
                        SalesLine.SetRange(Type, SalesLine.Type::Item);
                        if SalesLine.FindSet() then
                            repeat
                                Item.Reset;
                                Item.SetRange("No.", SalesLine."No.");
                                Item.SetRange(Type, Item.Type::Inventory);
                                if item.FindFirst() then begin
                                    SalesLine.UnitPriceChecked := false;
                                    SalesLine.UpdateUnitPriceByReqDelDt(SalesLine);
                                    SalesLine.Modify();
                                end
                            until SalesLine.Next() = 0;

                    end;
                end;
            end;
        }

        field(50000; "Cancel Date"; Date)
        {
            Caption = 'Cancel Date';
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;


        }
        field(50001; "Request Ship Date"; Date)
        {
            Caption = 'Request Ship Date';
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;


        }
        field(50002; "Split"; Boolean)
        {
            Caption = 'Split';
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;

        }
        field(50003; "Order Reference"; Text[20])
        {
            Caption = 'Order Reference';
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;

        }
        field(50004; "Flag"; Option)
        {
            Caption = 'Flag';
            OptionMembers = " ","0","Allocated","China Drop Ship","Extension Pending","Issue with PO","Master PO","PO SPLIT","Portal Routed","Pre-Scheduled","Ready for Billing","Routed and Waiting for Product","Scheduled","Scheduled and Waiting for Product","Transfer Pending","Waiting Product","Waiting Sales","Warehouse Processing","Order Canceled","Tendered to BC","Reschedule Pending","Need to schedule","Future Ship Date";
            OptionCaption = ' ,0,Allocated,China Drop Ship,Extension Pending,Issue with PO,Master PO,PO SPLIT,Portal Routed,Pre-Scheduled,Ready for Billing,Routed and Waiting for Product,Scheduled,Scheduled and Waiting for Product,Transfer Pending,Waiting Product,Waiting Sales,Warehouse Processing,Order Canceled,Tendered to BC,Reschedule Pending,Need to schedule,Future Ship Date';
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();
            end;

        }
        field(50005; "Start Ship Date"; Date)
        {
            Caption = 'Start Ship Date';
            trigger OnValidate()
            begin
                Rec.TestStatusOpen();

            end;



        }
        //pr 1/24/24 added fields for bol 
        field(50006; "Single BOL No."; Code[20])
        {
            Caption = 'Single BOL No.';
        }
        field(50007; "ShipFromAdress"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Address WHERE(Code = field("Location Code")));
        }
        field(50008; "ShipFromCity"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.City WHERE(Code = field("Location Code")));
        }
        field(50009; "ShipFromState"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("SAT Address"."SAT State Code" WHERE(ID = field(SATAddress1)));
        }
        field(50010; "ShipFromContact"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Contact WHERE(Code = field("Location Code")));
        }
        field(50011; "ShipFromPostalCode"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Post Code" WHERE(Code = field("Location Code")));
        }
        field(50012; "ShipFromCountry"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Country/Region Code" WHERE(Code = field("Location Code")));
        }
        field(50013; "ShipFromName"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name WHERE(Code = field("Location Code")));
        }
        field(50014; "FreightChargeTerm"; Option)
        {
            OptionMembers = " ","Prepaid","Collect","3rd Party";
            Caption = 'Freight Charge Terms';
        }
        field(50015; "BOL Comments"; Text[250])
        {
        }
        field(50016; Type; Text[10])
        {
            Caption = 'Type';
        }
        field(50017; Dept; Text[10])
        {
            Caption = 'Dept';
        }
        field(50018; "CustomerShipToCode"; Code[30])
        {
            Caption = 'Customer Ship-to Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Ship-to Address".CustomerShipToCode WHERE("Code" = field("Ship-to Code"), "Customer No." = field("Sell-to Customer No.")));

        }
        field(50019; "APT Date"; Date)
        {
            Caption = 'APT Date';

        }
        field(50020; "APT Time"; Text[20])
        {
            Caption = 'APT Time';

        }
        field(50021; "Total Package Count"; Decimal)
        {
            Caption = 'Total Package Count';
        }
        field(50022; "Total Weight"; Decimal)
        {
            Caption = 'Total Weight';
        }
        field(50023; "Total Pallet Count"; Decimal)
        {
            Caption = 'Total Pallet Count';
        }
        field(50024; CreatedUserID; Code[20])
        {
            Caption = 'Created By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50025; CreatedDate; Date)
        {
            Caption = 'Created Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50026; Verified; Boolean)
        {
            DataClassification = Customercontent;
            trigger OnValidate()
            begin
                if Rec.Verified <> xRec.Verified then
                    if Rec.Verified = true then begin
                        "Verified By" := UserId;
                        "Verified Date" := Today;
                    end
                    else begin
                        "Verified By" := '';
                        "Verified Date" := 0D;
                    end;
            end;
        }
        field(50027; "Verified By"; code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50028; "Verified Date"; date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50029; "Modified By"; code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50030; "Modified Date"; date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50031; Internal; Boolean)
        {

        }
        field(50032; Master; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50033; "EDI Discount Calculated"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
            begin
                if rec."EDI Discount Calculated" <> xRec."EDI Discount Calculated" then begin
                    UserSetup.RESET;
                    UserSetup.SetRange("User ID", UserId);
                    UserSetup.SetRange(FinanceAdmin, true);
                    IF Not UserSetup.FindFirst() then
                        ERROR(txtErrNoPermission);
                end;
            end;
        }
        field(50034; "Customer Responsibility Center"; code[10])
        {
            FieldClass = FlowField;

            CalcFormula = lookup(Customer."Responsibility Center" where("No." = field("Sell-to Customer No.")));
        }
        field(50035; "Order Notes"; Text[255])
        {
            DataClassification = CustomerContent;
        }
        field(50036; "IncludeNonItemWhsePost"; Boolean)
        {
            Caption = 'Include Non-Item Lines on Whse Post';
            DataClassification = CustomerContent;
        }
        field(50038; ShippingLabelStyle; code[30])
        {
            Caption = 'Shipping Label Style Report';
            // OptionMembers = " ","Default","Pallet","Type 3","Type 4","Type 5","Default Pallet";
            //PR 4/16/25 - convert to user table - start
            TableRelation = ReportLabelStyle;
            //PR 4/16/25 - convert to user table - end
        }
        field(50039; SATAddress1; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."SAT Address ID" where(Code = field("Location Code")));
        }
        //pr 6/19/25 - start
        field(50045; "Freight Charge Name"; Text[100])
        {
        }
        field(50046; "Freight Charge Address"; Text[100])
        {
        }
        field(50047; "Freight Charge City"; Text[30])
        {
            TableRelation = if ("Bill-to Country/Region Code" = const('')) "Post Code".City;

        }
        field(50048; "Freight Charge State"; Text[100])
        {
            TableRelation = "Country/Region";
        }
        field(50049; "Freight Charge Zip"; Text[20])
        {
            TableRelation = if ("Sell-to Country/Region Code" = const('')) "Post Code";

        }
        field(50050; "Freight Charge Contact"; Text[100])
        {

        }
        field(50051; "In the Month"; text[20])
        {
            Caption = 'In the Month';
            TableRelation = "InTheMonthOptions"."Code";

        }
        //pr 6/19/25 - end





    }

    trigger OnAfterInsert()
    begin

    end;

    trigger OnBeforeInsert()
    var
        NewBOLNo: Code[20];
        SalesHdr: Record "Sales Header";
        Customer: Record Customer;
    begin
        if (SalesNRecieveable.FindFirst()) then;
        IF STRLEN(SalesNRecieveable."Single BOL Nos.") = 0 then
            Error('No. Series for Single BOL Nos. is NOT set up.  Please review.');

        // rec."Single BOL No." := NoSeriesMgt.GetNextNo(SalesNRecieveable."Single BOL Nos.", Rec."Posting Date", true);
        //we are replacing the GetNExtNo with DoGetNextNo
        //NewBOLNo := NoSeriesMgt.DoGetNextNo(SalesNRecieveable."Single BOL Nos.", WorkDate(), true, true);  //old code
        NewBOLNo := NoSeries.GetNextNo(SalesNRecieveable."Single BOL Nos.");
        //Check to ensure we have unique BOL for the same customer
        SalesHdr.Reset();
        SalesHdr.SetRange("Document Type", Rec."Document Type");
        SalesHdr.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
        SalesHdr.SetFilter("Single BOL No.", '=%1', NewBOLNo);
        IF SalesHdr.FindFirst() then
            Error('BOL No. %1 has already been assigned to %2.  Please try again or contact Admin.', NewBOLNo, SalesHdr."No.")
        Else
            Rec."Single BOL No." := NewBOLNo;
        //pr 4/24/25 - update the shipping label style from Customer - start
        Customer.Reset();
        Customer.SetRange("No.", rec."Sell-to Customer No.");
        if (Customer.FindFirst()) then
            rec.ShippingLabelStyle := Customer.ShippingLabelStyle;
        //pr 4/24/25 - update the shipping label style from Customer - end


    end;

    trigger OnBeforeDelete()
    var
        SalesLine: Record "Sales Line";
    begin
        //7/3/25 - Create a copy of Sales Line Table for later use - update Earliest Start Ship Date -start
        TmpSalesLine.DeleteAll();

        SalesLine.Reset();
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        IF SalesLine.FindSet() then
            repeat
                TmpSalesLine.Init();
                TmpSalesLine := SalesLine;
                TmpSalesLine.Insert();
            until SalesLine.Next() = 0;
        //7/3/25 - Create a copy of Sales Line Table for later use - update Earliest Start Ship Date -end
    end;

    trigger OnAfterDelete()
    var
        CustomCI: Record CartonInformation;
        txtPkgInfo: Label 'You CANNOT delete the Sales Order %1 since Package Information Exists.  Do you want to override this rule';

    begin
        CustomCI.SetRange("Document No.", Rec."No.");

        if CustomCI.FindSet() then begin
            if (Dialog.Confirm(StrSubstNo(txtPkgInfo, Rec."No.")) = false) then begin
                Error('Task Aborted');
            end
            ELSE begin
                repeat
                    CustomCI.Delete();
                until CustomCI.Next() = 0;
            END;
        end;
        //7/3/25 - update Earliest Start Ship Date - start
        TmpSalesLine.Reset();
        if TmpSalesLine.FindSet() then
            repeat
                GenCU.UpdSO_UpdEarliestStartDtItemNo(TmpSalesLine."No.");
            until TmpSalesLine.Next() = 0;
        //7/3/25 - update Earliest Start Ship Date - end
    end;

    procedure UpdatePackageInfo()
    var
        ItemUnitOfMeasure_LRec: Record "Item Unit of Measure";
        Item: Record Item;
        SalesLine: Record "Sales Line";
        CasePackQty: Decimal;
        Carton: Integer;
        CartonInfo: Record CartonInformation;
        i: Integer;
        j: Integer;
    begin

        Carton := 0;
        j := 0;
        CartonInfo.SetRange("Document No.", Rec."No.");
        CartonInfo.SETRANGE(Posted, False);


        if CartonInfo.FindSet() then
            CartonInfo.DeleteAll();



        SalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("Document No.", Rec."No.");


        if SalesLine.FindSet() then
            repeat
                //pr 3/25/25  do not allow refresh of package for item with type <> Inventory - start
                Item.Reset;
                item.SetRange("No.", SalesLine."No.");
                item.SetRange(Type, item.Type::Inventory);
                if (Item.FindFirst()) then begin
                    //pr 3/25/25  do not allow refresh of package for item with type <> Inventory - end
                    CasePackQty := 0;
                    ItemUnitOfMeasure_LRec.SetRange("Item No.", SalesLine."No.");
                    ItemUnitOfMeasure_LRec.SetRange(Code, 'M-PACK');
                    if ItemUnitOfMeasure_LRec.FindFirst() then begin
                        CasePackQty := ItemUnitOfMeasure_LRec."Qty. per Unit of Measure";
                    end;
                    //MBR 9/22/24 - we will based the calculation of Packaged Info on Quantity and/or Quantity (Based)

                    if (CasePackQty > SalesLine."Quantity (Base)") and (SaleslIne."Quantity (Base)" <> 0) then
                        Carton := 1
                    ELSE begin
                        IF CasePackQty > 0 then begin
                            IF (SalesLine."Quantity (Base)" MOD CasePackQty) > 0 then
                                Carton := (SalesLine."Quantity (Base)" DIV CasePackQty) + 1
                            ELSE
                                Carton := (SalesLine."Quantity (Base)" / CasePackQty);
                        end;
                    end;
                    for i := 1 to Carton do begin
                        j += 1;
                        CartonInfo.Init();
                        CartonInfo."Document Type" := SalesLine."Document Type";
                        CartonInfo."Item No." := SalesLine."No.";
                        CartonInfo."Document No." := SalesLine."Document No.";
                        CartonInfo."DocumentLine No." := SalesLine."Line No.";
                        CartonInfo."Line No." := 0;
                        CartonInfo."Reserved Quantity" := 1;
                        CartonInfo.LineCount := j;
                        CartonInfo."Serial No." := GenCU.CreateSSCC(SalesLine."Document No.", SalesLine."No.", SalesLine."Sell-to Customer No.");
                        CartonInfo."Unit of Measure Code" := SalesLine."Unit of Measure Code";
                        CartonInfo."Item Reserved Quantity" := SalesLine."Quantity (Base)";
                        SalesLine.CalcFields("M-Pack Qty", "M-Pack Weight");
                        CartonInfo."Package Quantity" := SalesLine."M-Pack Qty";
                        CartonInfo.Weight := SalesLine."M-Pack Weight";
                        SalesLine.CalcFields(ShippingLabelStyle);
                        CartonInfo.Validate(ShippingLabelStyle, SalesLine.ShippingLabelStyle);
                        CartonInfo.Insert();
                    end;
                end;
            until SalesLine.Next() = 0;
    end;


    trigger OnModify()   //mbr 2/20/24 - on Modify, check if Req Del dt has been modified, if so, update cancel date as well
    begin
        if (rec."Requested Delivery Date" <> xrec."Requested Delivery Date") then
            rec."Cancel Date" := rec."Requested Delivery Date";

        UpdateStartShipDate();
        rec."Modified By" := UserId;
        rec."Modified Date" := Today;
    end;

    trigger OnInsert()
    begin
        CreatedUserID := UserId;
        CreatedDate := Today;
        UpdateStartShipDate();
        //pr 7/1/25 - for batch refresh button - start
        bRefreshed := false;
        //pr 7/1/25 - for batch refresh button - end

    end;

    local procedure UpdateStartShipDate()

    begin
        If "Start Ship Date" = 0D then begin
            if (Rec."Shipment Date" <> xrec."Shipment Date") then begin
                if (Rec."Shipment Date" <> 0D) then begin
                    if Rec."Shipment Date" = Today then begin
                        if (Rec."Requested Delivery Date" <> xrec."Requested Delivery Date") and (Rec."Requested Delivery Date" <> 0D) then
                            CheckReqDelDate();
                    end
                    else
                        Validate("Start Ship Date", "Shipment Date");
                end
                else
                    CheckReqDelDate();
            end
            else if (Rec."Requested Delivery Date" <> xrec."Requested Delivery Date") and (Rec."Requested Delivery Date" <> 0D) then
                CheckReqDelDate();


        end;

    end;
    //PR 5/15/25 - start
    procedure CalcEDI(isAuto: Boolean)
    var
        Customer: Record Customer;
    begin
        Customer.Reset();
        Customer.SetRange("No.", rec."Sell-to Customer No.");
        if (Customer.FindSet()) then begin
            if (Customer."EDI Discount Calcualtion" = Customer."EDI Discount Calcualtion"::"Calculate from Line Discount") then begin
                GenCU.CalcEDILineDiscount(rec, isAuto)
            end
            else begin
                GenCU.CalcEDI(rec, isAuto);
            end;
        end;
    end;

    procedure ReCalcEDI(isAuto: Boolean)
    var
        Customer: Record Customer;
    begin
        Customer.Reset();
        Customer.SetRange("No.", rec."Sell-to Customer No.");
        if (Customer.FindSet()) then begin
            if (Customer."EDI Discount Calcualtion" = Customer."EDI Discount Calcualtion"::"Calculate from Line Discount") then begin
                GenCU.ReCalcEDILineDiscount(rec, isAuto);
            end
            else begin
                GenCU.ReCalcEDI(rec, isAuto);
            end;
        end;
    end;
    //PR 5/15/25 - end

    local procedure CheckReqDelDate()
    var
        ShipTo: Record "Ship-to Address";
        Cust: Record Customer;
        BlankDateFormula: DateFormula;
        bCheckCust: Boolean;
    begin
        bCheckCust := false;

        Shipto.Reset();
        ShipTo.SetRange("Customer No.", Rec."Sell-to Customer No.");
        ShipTo.SetRange(Code, Rec."Ship-to Code");
        IF ShipTo.FindFirst() then begin
            if ShipTo.TransitDays = BlankDateFormula then
                bCheckCust := true
            else begin
                VALIDATE("Start Ship Date", CalcDate('<-' + FORMAT(ShipTo.TransitDays) + '>', "Requested Delivery Date"));
            end;
        end
        else
            bCheckCust := true;

        if bCheckCust = true then begin
            If Cust.Get("Sell-to Customer No.") then begin
                if Cust."Shipping Time" <> BlankDateFormula then
                    Validate("Start Ship Date", CalcDate('<-' + FORMAT(Cust."Shipping Time") + '>', "Requested Delivery Date"));
            end;
        end;

    end;

    [TryFunction]
    procedure RefreshPkg()

    var
        bCont: Boolean;
        SalesLine: Record "Sales Line";
        Item: Record Item;
        ReportLabel: Record ReportLabelStyle;
    begin
        ReportLabel.Reset();
        ReportLabel.SetRange("Use Pallet", true);
        ReportLabel.SetRange(Code, Rec.ShippingLabelStyle);
        if (ReportLabel.FindSet()) then begin
            Error(txtPalletRefreshErr, Rec.ShippingLabelStyle);
        end;
        SalesLine.reset;
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("M-Pack Qty", '%1', 0);
        //mbr 3/25/25 - we only want to refresh the type item where item = inventory - start
        if (SalesLine.FindSet()) then
            repeat
                Item.Reset;
                item.SetRange("No.", SalesLine."No.");
                item.SetRange(Type, item.Type::Inventory);
                if item.FindFirst() then
                    Error(txtZeroQtyLineFound);
            until SalesLine.Next() = 0;

        bCont := true;
        CartonInfo.Reset;
        CartonInfo.SetRange("Document Type", Rec."Document Type");
        CartonInfo.SetRange("Document No.", Rec."No.");
        IF CartonInfo.FindFirst() then begin
            Clear(popupConfirm);
            if CartonInfo.Imported = false then
                popupConfirm.setMessage(StrSubstNo(txtRefreshPackageReg, Rec."No."))
            else
                popupConfirm.setMessage(StrSubstNo(txtRefreshPackageImp, Rec."No."));

            Commit;
            if popupConfirm.RunModal() = Action::No then
                bCont := false;
        end;
        if bCont = true then begin
            rec.UpdatePackageInfo();

        end;
        bRefreshed := bCont;
    end;

    procedure GetBRefresh(): Boolean
    begin
        exit(bRefreshed);
    end;

    procedure SetBRefresh(bRefresh: Boolean)
    begin
        bRefreshed := bRefresh;
    end;

    var
        bRefreshed: Boolean;
        GetBOLNo: Code[10];
        //NoSeriesMgt: Codeunit NoSeriesManagement; //old code
        NoSeries: Codeunit "No. Series";
        SalesNRecieveable: Record "Sales & Receivables Setup";
        ItemUOM: Record "Item Unit of Measure";
        GenCU: Codeunit GeneralCU;
        customer: Record Customer;
        txtErrNoPermission: Label 'Sorry, you have NO permission to update this field.';
        PostCode: Record "Post Code";
        CartonInfo: Record CartonInformation;
        popupConfirm: Page "Confirmation Dialog";
        txtPalletRefreshErr: Label 'Your Shipping Label Style Report is marked as %1.  You cannot use Refresh Package. Please use Package Information.';
        txtRefreshPackageImp: Label 'IMPORTED Package Label(s) currently exist for %1. Override?';
        txtZeroQtyLineFound: Label ' or more sales line items have M-Pack Qty = 0. Refresh Packages FAILED.';
        txtRefreshPackageReg: Label 'Package Label(s) currently exist for %1. Refresh anyway?';
        TmpSalesLine: Record "Sales Line" temporary;

}
