report 50051 "MasterBOLAndSingleBOL"
{
    //pr 1/24/24 made report for master bol
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/MasterBOLAndSingleBOL.rdl';
    Caption = 'Master Bill of Lading';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Master BOL"; "Master BOL")
        {
            column(Special_Instructions; "Special Instructions")
            {

            }

            column(Ship_From_Address; loc.Address)
            {

            }
            column(Master_BOL_No_; "Master BOL No.")
            {

            }
            column(Sales_Order_No_; "Sales Order No.")
            {
            }
            column(Customer_No_; "Customer No.")
            {
            }
            column(Single_BOL_No_; "Single BOL No.")
            {
            }
            column(SCAC_Code; SCAC_Code)
            {
            }
            column(Posted; Posted)
            {
            }
            column(External_Doc_No_; "External Doc No.")
            {
            }
            column(Ship_From_City; loc.City)
            {
            }
            column(Ship_From_Code; "Ship From Code")
            {
            }
            column(Ship_From_Contact; loc.Contact)
            {
            }
            column(Ship_From_Name; loc.Name)
            {
            }
            column(Ship_From_Postal_Code; loc."Post Code")
            {
            }
            column(Ship_From_State_County; loc.County)
            {
            }
            column(Ship_To_Address; "Master BOL"."Main Ship To Address")
            {
            }

            column(Ship_To_City; "Master BOL"."Main Ship To City")
            {

            }

            column(Ship_To_Contact; "Master BOL"."Main Ship To Contact")
            {
            }
            column(Ship_To_Name; "Master BOL"."Main Ship To Name")
            {
            }
            column(Ship_To_Postal_Code; "Master BOL"."Main Ship To Postal Code")
            {
            }
            column(Ship_To_State_County; "Master BOL"."Main Ship To State/County")
            {
            }
            column(Customer_Ship_to_City; "Customer Ship to City")
            {
            }
            column(Freight_Charge_Term; "Freight Charge Term")
            {
            }
            column(Bill_To_Adress; BillToAddress)
            {
            }
            column(BillToAddress2; BillToAddress2)
            {
            }
            column(Bill_To_City; BillToCity)
            {
            }
            column(Bill_To_Contact; BillToContact)
            {
            }
            column(Bill_To_Name; BillToName)
            {
            }
            column(Bill_To_Postal_Code; BillToZip)
            {
            }
            column(Bill_To_State_County; BillToState)
            {
            }
            column(formattedBillToAddress; formattedBillToAddress)
            {
            }
            column(formattedSellToAddress; formattedSellToAddress)
            {
            }
            column(formattedSellFromAddress; formattedSellFromAddress)
            {
            }
            column(freightChargeCol; freightChargeCol)
            {
            }
            column(freightChargePrepaid; freightChargePrepaid)
            {
            }
            column(freightCharge3; freightCharge3)
            {
            }
            column(EncodeText; EncodeText)
            {
            }
            column(Carrier_Name; Carrier_Name)
            {
            }
            column(Shipment_Method_Code; "Shipment Method Code")
            {

            }
            column(TotalPackageCount; TotalPackageCount)
            {

            }
            column(TotalWeightCount; TotalWeightCount)
            {

            }
            column(Packagecount; Packagecount)
            {

            }

            column(CommodityDescrip; SRSetup."Commodity Description")
            {

            }
            column(NMFCNo; SRSetup."NMFC No.")
            {

            }
            column(SingleExternalDocumentNo; "Sales Header"."External Document No.")
            {
            }
            column(SingleShiptoAddress; "Sales Header"."Ship-to Address")
            {
            }
            column(SingleAttnNO; "Sales Header"."Amt. Ship. Not Inv. (LCY)")
            {
            }
            column(SingleBillToAddress; "Master BOL"."Bill To Adress")
            {
            }
            column(SingleBillToContact; "Master BOL"."Bill To Contact")
            {
            }
            column(SingleBillToCity; "Master BOL"."Bill To City")
            {
            }
            column(SingleBillToPostalCode; "Master BOL"."Bill To Postal Code")
            {
            }
            column(SingleBillToName; "Master BOL"."Bill To Name")
            {

            }
            column(SingleBillToAddress2; '')
            {

            }
            column(SingleSCAC; "Sales Header"."Shipping Agent Code")
            {
            }
            column(SingleShippingAgent; ShippingAgent.Name)
            {

            }
            column(SingleShip_to_Code; "Sales Header"."Ship-to Code")
            {

            }
            column(SingleCustOrderNo; "Sales Header"."External Document No.")
            {
            }
            column(SingleShipMethodCode; "Sales Header"."Shipment Method Code")
            {
            }
            column(SingleBOLno; "Sales Header"."Single BOL No.")
            {
            }
            column(SinglePackageNo; totalCalcCountNum)
            {
            }
            column(SingleWeightNo; totalCalcWeightNum)
            {
            }
            column(SingleShipFromName; loc.Name)
            {
            }
            column(SingleShipToName; "Sales Header"."Ship-to Name")
            {
            }
            column(SingleShipFromAddress; loc.Address)
            {
            }
            column(SingleShipFromCity; loc.City)
            {
            }
            column(SingleShipFromState; loc.County)
            {
            }
            column(SingleShipFromPostalCode; loc."Post Code")
            {
            }
            column(SingleShipFromCountry; loc."Country/Region Code")
            {
            }
            column(SingleShipFromContact; "Sales Header".ShipFromContact)
            {
            }
            column(SingleformattedBillToAddress; SingleformattedBillToAddress)
            {
            }
            column(SingleBill_to_County; "Master BOL"."Bill To State/County")
            {
            }
            column(SingleformattedSellToAddress; SingleformattedSellToAddress)
            {
            }
            column(SingleformattedSellFromAddress; SingleformattedSellFromAddress)
            {
            }
            column(SingleShipToLocCode; "Sales Header"."Ship-to Code")
            {
            }
            column(SinglefreightChargeCol; freightChargeCol)
            {
            }
            column(SinglefreightChargePrepaid; freightChargePrepaid)
            {
            }
            column(SinglefreightCharge3; freightCharge3)
            {
            }
            column(SingleShip_to_Address_2; "Sales Header"."Ship-to Address 2")
            {

            }
            column(SingleShip_to_City; "Sales Header"."Ship-to City")
            {

            }
            column(SingleShip_to_County; "Sales Header"."Ship-to County")
            {

            }
            column(SingleShip_to_Post_Code; "Sales Header"."Ship-to Post Code")
            {

            }
            column(SingleBOL_Comments; "Sales Header"."BOL Comments")
            {

            }
            column(SingleShipment_Method_Code; "Sales Header"."Shipment Method Code")
            {

            }
            column(SingleCommodityDescrip; SingleSRSetup."Commodity Description")
            {

            }
            column(SingleNMFCNo; SingleSRSetup."NMFC No.")
            {

            }
            column(SingleLinePckg; totalCalcCountNum)
            {

            }
            column(SingleLineWeight; totalCalcWeightNum)
            {

            }
            column(WeightCount; WeightCount)
            {

            }
            column(Ship_to_Code; "Ship to Code")
            {

            }
            column(Sales_Header_TotalPackageCount; "Sales Header"."Total Package Count")
            {

            }
            column(SalesHeader_TotalWeight; "Sales Header"."Total Weight")
            {

            }
            column(Sales_Header_TotalPalletCount; "Sales Header"."Total Pallet Count")
            {

            }
            column(TotalPalletCnt; TotalPalletCnt)
            {

            }

            dataitem("Carrier Information"; "Sales Header")
            {
                // DataItemLink = "Sell-to Customer No." = field("Master BOL No.");

                PrintOnlyIfDetail = True;

                column(NMFC_No_; "NMFC No.")
                {

                }
            }
            trigger OnPreDataItem()
            begin
                if SRSetup.findfirst then;
                if SingleSRSetup.FindFirst() then;
                "Master BOL".SetRange(Posted, false);
            end;

            trigger OnAfterGetRecord()
            var
                BarCodeSymbology: Enum "Barcode Symbology";
                BarCodeSymbologyExt: Enum "Barcode Symbology";
                BarCodeFontProvider: Interface "Barcode Font Provider";
                BarCodeFontProviderExtDoc: Interface "Barcode Font Provider";
                BarcodeStr: Code[30];
                BarcodeStrExtDoc: Code[30];
                GetMasterBOL: record "Master BOL";

                SingleBarCodeSymbology: Enum "Barcode Symbology";
                SingleBarCodeSymbologyExt: Enum "Barcode Symbology";
                SingleBarCodeFontProvider: Interface "Barcode Font Provider";
                SingleBarCodeFontProviderExtDoc: Interface "Barcode Font Provider";
                SingleBarcodeStr: Code[30];
                SingleBarcodeStrExtDoc: Code[30];
                InSalesHeader: Record "Sales Header";
            begin
                "Master BOL".CalcFields("Carrier Name");
                BarCodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarCodeFontProviderExtDoc := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarCodeSymbology := Enum::"Barcode Symbology"::Code39;
                BarCodeSymbologyExt := Enum::"Barcode Symbology"::Code39;

                BarcodeStr := '*' + "External Doc No." + '*';
                BarcodeStr := CONVERTSTR(BarcodeStr, '-', ' ');
                BarcodeStr := CONVERTSTR(BarcodeStr, '_', ' ');
                BarcodeStr := DELCHR(BarcodeStr, '<>');
                BarCodeFontProvider.ValidateInput(BarcodeStr, BarCodeSymbology);
                EncodeText := BarCodeFontProvider.EncodeFont(BarcodeStr, BarCodeSymbology);
                loc.reset;
                loc.SetRange(Code, "Master BOL"."Location Code");
                If loc.FindFirst() then;

                formattedSellToAddress := '';
                formattedBillToAddress := '';
                formattedSellFromAddress := '';

                formattedSellToAddress += "Master BOL"."Main Ship To City" + ' ' + "Master BOL"."Main Ship To State/County" + ', ' + "Master BOL"."Main Ship To Postal Code";
                formattedSellFromAddress += loc.City + ' ' + loc.County + ', ' + loc."Post Code";

                //pr 6/19/25 - If Freight Charge Terms = 'Third Party', a custom freight charge address should be used - start
                //Initialization of Billto Variables
                BillToAddress := '';
                BillToAddress2 := '';
                BillToContact := '';
                BillToCity := '';
                BillToAddress := '';
                BillToState := '';
                BillToZip := '';
                BillToName := '';
                if ("Sales Header".FreightChargeTerm = "Sales Header".FreightChargeTerm::"3rd Party") then begin
                    BillToAddress := "Sales Header"."Freight Charge Address";
                    BillToContact := "Sales Header"."Freight Charge Contact";
                    BillToCity := "Sales Header"."Freight Charge City";
                    BillToZip := "Sales Header"."Freight Charge Zip";
                    BillToName := "Sales Header"."Freight Charge Name";
                    BillToState := "Sales Header"."Freight Charge State";
                end
                else begin
                    BillToAddress := "Master BOL"."Bill To Adress";
                    BillToAddress2 := "Master BOL"."Bill To Adress";
                    BillToContact := "Master BOL"."Bill to Contact";
                    BillToCity := "Master BOL"."Bill to City";
                    BillToZip := "Master BOL"."Bill To Postal Code";
                    BillToName := "Master BOL"."Bill to Name";
                    BillToState := "Master BOL"."Bill To State/County"
                end;
                //pr 6/19/25 - If Freight Charge Terms = 'Third Party', a custom freight charge address should be used - end
                formattedBillToAddress += BillToCity + ' ' + BillToState + ', ' + BillToZip;
                //get total packages/total weight
                if bInit = false then begin
                    bInit := true;
                    TotalWeightCount := 0;
                    TotalPackageCount := 0;
                    TotalPalletCnt := 0;
                    GetMasterBOL.RESET;
                    GetMasterBOL.SetRange("Master BOL No.", "Master BOL"."Master BOL No.");
                    if GetMasterBOL.FindSet() then
                        repeat
                            InSalesHeader.Reset;
                            InSalesHeader.SetRange("No.", GetMasterBOL."Sales Order No.");
                            InSalesHeader.SetRange("Document Type", InSalesHeader."Document Type"::Order);
                            if InSalesHeader.FindSet() then
                                repeat
                                    TotalPackageCount += InSalesHeader."Total Package Count";
                                    TotalWeightCount += InSalesHeader."Total Weight";
                                    TotalPalletCnt += InSalesHeader."Total Pallet Count";
                                Until InSalesHeader.Next() = 0;
                        until GetMasterBOL.Next() = 0;
                end;
                Packagecount := 0;
                WeightCount := 0;
                /*   BarcodeStrExtDoc := '*' + "External Tracking No." + '*';
                   BarCodeFontProvider.ValidateInput(BarcodeStr, BarCodeSymbology);
                   BarCodeFontProviderExtDoc.ValidateInput(BarcodeStrExtDoc, BarCodeSymbologyExt);
                   EncodeText := BarCodeFontProvider.EncodeFont(BarcodeStr, BarCodeSymbology);
                   EncodeTextExtDoc := BarCodeFontProviderExtDoc.EncodeFont(BarcodeStrExtDoc, BarCodeSymbologyExt);
                   loc.Reset();
                   if (WhseSetup.get()) then begin
                       loc.code := WhseSetup."Main Warehouse Location";
                   end;
                   loc.SETRANGE(Code, WhseSetup."Main Warehouse Location");*/

                // pr 9/20/23 loops 4 times to fill the report with the first 4 lines or until none are left

                freightChargePrePaid := '';
                freightChargeCol := '';
                freightCharge3 := '';

                if ("Master BOL"."Freight Charge Term" = "Master BOL"."Freight Charge Term"::Prepaid) then begin
                    freightChargePrePaid := 'Pr';
                end
                else
                    if ("Master BOL"."Freight Charge Term" = "Master BOL"."Freight Charge Term"::Collect) then begin
                        freightChargeCol := 'C';
                    end
                    else
                        if ("Master BOL"."Freight Charge Term" = "Master BOL"."Freight Charge Term"::"3rd Party") then begin
                            freightCharge3 := 'rd';
                        end;

                CLEAR(SCAC_Code);
                CLEAR(Carrier_Name);

                IF STRLEN("Master BOL"."SCAC Code") > 0 then begin
                    ShippingAgent.GET("Master BOL"."SCAC Code");
                    Carrier_Name := ShippingAgent.Name;
                    SCAC_Code := "Master BOL"."SCAC Code";
                end
                else begin
                    InSalesHeader.Reset;
                    InSalesHeader.SetRange("No.", GetMasterBOL."Sales Order No.");
                    InSalesHeader.SetRange("Document Type", InSalesHeader."Document Type"::Order);
                    InSalesHeader.SetFilter("Shipping Agent Code", '<>%1', '');
                    if InSalesHeader.FindFirst() then begin
                        ShippingAgent.GET(InSalesHeader."Shipping Agent Code");
                        Carrier_Name := ShippingAgent.Name;
                        SCAC_Code := InSalesHeader."Shipping Agent Code";
                    end;
                end;


                SalesLine.Reset;
                SalesLine.SetRange("Document No.", "Master BOL"."Sales Order No.");
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                if SalesLine.FindSet() then
                    repeat
                        "SalesLine".CalcFields("M-Pack Qty", "M-Pack Weight");
                        LinePckg := 0;
                        IF SalesLine."M-Pack Qty" > 0 then begin
                            IF (SalesLine."Quantity (Base)" MOD SalesLine."M-Pack Qty") > 0 then
                                LinePckg := (SalesLine."Quantity (Base)" DIV SalesLine."M-Pack Qty") + 1
                            ELSE
                                LinePckg := (SalesLine."Quantity (Base)" / SalesLine."M-Pack Qty");
                            Packagecount += LinePckg;
                            WeightCount += SalesLine."M-Pack Weight" * LinePckg;

                        end;


                    Until SalesLine.Next() = 0;

                //Now, populate values necessary for Single BOL
                "Sales Header".reset;
                "Sales Header".SetRange("Document Type", "Sales Header"."Document Type"::Order);
                "Sales Header".SetRange("No.", "Master BOL"."Sales Order No.");
                IF "Sales Header".FindFirst() then begin


                    IF STRLEN("Sales Header"."Shipping Agent Code") > 0 then
                        ShippingAgent.GET("Sales Header"."Shipping Agent Code");

                    SingleBarCodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                    SingleBarCodeFontProviderExtDoc := Enum::"Barcode Font Provider"::IDAutomation1D;
                    SingleBarCodeSymbology := Enum::"Barcode Symbology"::Code39;
                    SingleBarCodeSymbologyExt := Enum::"Barcode Symbology"::Code39;
                    SingleBarcodeStr := '*' + "Sales Header"."No." + '*';
                    SingleformattedSellToAddress := '';
                    SingleformattedBillToAddress := '';
                    SingleformattedSellFromAddress := '';

                    SingleformattedSellToAddress += "Sales Header"."Sell-to City" + ' ' + "Sales Header"."Sell-to County" + ', ' + "Sales Header"."Sell-to Post Code";
                    SingleformattedSellFromAddress += "Sales Header".ShipFromCity + ' ' + "Sales Header".ShipFromState + ', ' + "Sales Header".ShipFromPostalCode;
                    //SingleformattedBillToAddress += "Sales Header"."Bill-to City" + ' ' + "Sales Header"."Bill-to County" + ', ' + "Sales Header"."Ship-to Post Code";
                    SingleformattedBillToAddress += "Master BOL"."Bill to City" + ' ' + "Master BOL"."Bill to State/County" + ', ' + "Master BOL"."Bill To Postal Code";
                    If not loc.FindFirst() then
                        Error('No Main Location Found!');
                    // pr 9/21/23 intilaizes the lists with ''
                    for colCount := 0 to 4 do begin
                        //colCount := colCount + 1;
                        custWeightList.add('');
                        custQtyList.add('');
                        custPoList.add('');
                        generalMerch.add('');
                        nfmcNo.add('');
                        classText.add('');
                    end;
                    // pr 9/20/23 loops 4 times to fill the report with the first 4 lines or until none are left
                    colCount := 0;
                    totalCalcCount := '';
                    totalCalcWeight := '';
                    totalCalcCountNum := 0;
                    totalCalcWeightNum := 0;





                    //  WHERE("Document Type" = field("Document Type"), "No." = field("Document No."))
                    //bolLine.SetRange("Customer No.".c);
                    SingleSalesLine.Reset;
                    SingleSalesLine.SetRange("Document No.", "Sales Header"."No.");
                    SingleSalesLine.SetRange("Document Type", SingleSalesLine."Document Type"::Order);
                    if SingleSalesLine.FindSet() then
                        repeat
                            SingleSalesLine.CalcFields("M-Pack Qty", "M-Pack Weight");
                            LinePckg := 0;
                            IF SingleSalesLine."M-Pack Qty" > 0 then begin
                                IF (SingleSalesLine."Quantity (Base)" MOD SingleSalesLine."M-Pack Qty") > 0 then
                                    LinePckg := (SingleSalesLine."Quantity (Base)" DIV SingleSalesLine."M-Pack Qty") + 1
                                ELSE
                                    LinePckg := (SingleSalesLine."Quantity (Base)" / SingleSalesLine."M-Pack Qty");
                                totalCalcCountNum += LinePckg;
                                totalCalcWeightNum += SingleSalesLine."M-Pack Weight" * LinePckg;


                            end;


                        Until SingleSalesLine.Next() = 0;


                end;


            end;


        }

    }


    var
        MasterBol: Record "Master BOL";
        EncodeText: Text[100];
        EncodeTextExtDoc: Text[100];
        formattedSellToAddress: Text[100];
        formattedSellFromAddress: Text[100];
        formattedBillToAddress: Text[100];
        freightChargePrepaid: Text[100];
        freightChargeCol: Text[100];
        freightCharge3: Text[100];
        "NMFC No.": Text[100];

        ShippingAgent: Record "Shipping Agent";
        SalesLine: record "Sales Line";
        Packagecount: decimal;
        WeightCount: decimal;

        LinePckg: Decimal;
        TotalPackageCount: decimal;
        TotalWeightCount: decimal;
        bInit: boolean;

        SRSetup: record "Sales & Receivables Setup";
        SingleEncodeText: Text[100];
        SingleEncodeTextExtDoc: Text[100];
        SingleformattedSellToAddress: Text[100];
        SingleformattedSellFromAddress: Text[100];
        SingleformattedBillToAddress: Text[100];
        SinglefreightChargePrepaid: Text[100];
        SinglefreightChargeCol: Text[100];
        SinglefreightCharge3: Text[100];
        Loc: Record location;
        SingleSalesLine: Record "Sales Line";
        colCount: Integer;
        custPoList: List of [text];
        custQtyList: List of [text];
        custWeightList: List of [text];
        totalCalcCount: text;
        totalCalcWeight: text;
        generalMerch: List of [text];
        nfmcNo: List of [text];
        classText: List of [text];
        totalCalcCountNum: Decimal;
        totalCalcWeightNum: Decimal;
        externalDocNO1: Code[30];
        postedSalesShip: record "Sales Shipment Header";
        WhseSetup: Record "Warehouse Setup";
        SingleShippingAgent: Record "Shipping Agent";

        SingleSRSetup: record "Sales & Receivables Setup";
        "Sales Header": Record "Sales Header";
        TotalPalletCnt: Decimal;

        SCAC_Code: Text[50];
        Carrier_Name: Text[50];

        BillToAddress: Text[100];
        BillToContact: Text[100];
        BillToCity: Text[100];
        BillToZip: Text[100];
        BillToName: Text[100];
        BillToState: Text[100];
        BillToAddress2: Text[100];
}