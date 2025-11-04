report 50114 PostedBOLReport
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/PostedBOL_Report.rdl';
    Caption = 'Posted Bill of Lading';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {

        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            column(ExternalDocumentNo; "Sales Shipment Header"."External Document No.")
            {
            }
            column(ShiptoAddress; "Sales Shipment Header"."Ship-to Address")
            {
            }
            column(BillToAddress; BillToAddress)
            {
            }
            column(BillToAddress2; BillToAddress2)
            {
            }
            column(BillToContact; BillToContact)
            {
            }
            column(BillToCity; BillToCity)
            {
            }
            column(BillToPostalCode; BillToZip)
            {
            }
            column(BillToName; BillToName)
            {
            }
            column(SCAC; "Sales Shipment Header"."Shipping Agent Code")
            {
            }
            column(ShippingAgent; ShippingAgent.Name)
            {

            }
            column(Ship_to_Code; "Ship-to Code")
            {

            }
            column(CustOrderNo; "Sales Shipment Header"."External Document No.")
            {
            }
            column(ShipMethodCode; "Sales Shipment Header"."Shipment Method Code")
            {
            }
            column(BOLno; "Sales Shipment Header"."Single BOL No.")
            {
            }
            column(PackageNo; totalCalcCountNum)
            {
            }
            column(WeightNo; totalCalcWeightNum)
            {
            }
            column(ShipFromName; ShipFromName)
            {
            }
            column(ShipToName; "Sales Shipment Header"."Ship-to Name")
            {
            }
            column(ShipFromAddress; ShipFromAddress)
            {
            }
            column(ShipFromCity; ShipFromCity)
            {
            }
            column(ShipFromState; ShipFromState)
            {
            }
            column(ShipFromPostalCode; ShipFromPostalCode)
            {
            }
            column(ShipFromCountry; ShipFromCountry)
            {
            }
            column(ShipFromContact; ShipFromContact)
            {
            }
            column(formattedBillToAddress; formattedBillToAddress)
            {
            }
            column(Bill_to_County; BillToState)
            {
            }
            column(formattedSellToAddress; formattedSellToAddress)
            {
            }
            column(formattedSellFromAddress; formattedSellFromAddress)
            {
            }
            column(ShipToLocCode; "Sales Shipment Header"."Ship-to Code")
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
            column(Ship_to_Address_2; "Ship-to Address 2")
            {

            }
            column(Ship_to_City; "Ship-to City")
            {

            }
            column(Ship_to_County; "Ship-to County")
            {

            }
            column(Ship_to_Post_Code; "Ship-to Post Code")
            {

            }
            column(BOL_Comments; "BOL Comments")
            {

            }
            column(Shipment_Method_Code; "Shipment Method Code")
            {

            }
            column(CommodityDescrip; SRSetup."Commodity Description")
            {

            }
            column(NMFCNo; SRSetup."NMFC No.")
            {

            }
            column(Total_Package_Count; "Total Package Count")
            {

            }
            column(Total_Weight; "Total Weight")
            {

            }
            column(Total_Pallet_Count; "Total Pallet Count")
            {

            }

            trigger OnPreDataItem()
            begin
                if SRSetup.findfirst then;
            end;

            trigger OnAfterGetRecord()
            var
                BarCodeSymbology: Enum "Barcode Symbology";
                BarCodeSymbologyExt: Enum "Barcode Symbology";
                BarCodeFontProvider: Interface "Barcode Font Provider";
                BarCodeFontProviderExtDoc: Interface "Barcode Font Provider";
                BarcodeStr: Code[20];
                BarcodeStrExtDoc: Code[30];
            begin
                IF STRLEN("Sales Shipment Header"."Shipping Agent Code") > 0 then
                    ShippingAgent.GET("Sales Shipment Header"."Shipping Agent Code");

                IF Loc.Get("Sales Shipment Header"."Location Code") then begin
                    ShipFromName := Loc.Name;
                    ShipFromAddress := Loc.Address + ' ' + Loc."Address 2";
                    ShipFromAddress := ShipFromAddress.TrimEnd();
                    ShipFromCity := Loc.City;
                    ShipFromState := Loc.County;
                    ShipFromPostalCode := Loc."Post Code";
                    ShipFromCountry := Loc."Country/Region Code";
                end
                else begin
                    If CompInfo.Get then;
                    ShipFromName := CompInfo.Name;
                    ShipFromAddress := CompInfo.Address + ' ' + CompInfo."Address 2";
                    ShipFromAddress := ShipFromAddress.TrimEnd();
                    ShipFromCity := CompInfo.City;
                    ShipFromState := CompInfo.County;
                    ShipFromPostalCode := CompInfo."Post Code";
                    ShipFromCountry := CompInfo."Country/Region Code";
                end;

                //Initialization of BillTo Variables
                BillToAddress := '';
                BillToAddress2 := '';
                BillToContact := '';
                BillToCity := '';
                BillToAddress := '';
                BillToState := '';
                BillToZip := '';
                BillToName := '';
                //pr 6/19/25 - If Freight Charge Terms = 'Third Party', a custom freight charge address should be used - start
                if ("Sales Shipment Header".FreightChargeTerm = "Sales Shipment Header".FreightChargeTerm::"3rd Party") then begin
                    BillToAddress := "Sales Shipment Header"."Freight Charge Address";
                    BillToContact := "Sales Shipment Header"."Freight Charge Contact";
                    BillToCity := "Sales Shipment Header"."Freight Charge City";
                    BillToZip := "Sales Shipment Header"."Freight Charge Zip";
                    BillToName := "Sales Shipment Header"."Freight Charge Name";
                    BillToState := "Sales Shipment Header"."Freight Charge State";
                end
                else begin
                    BillToAddress := "Sales Shipment Header"."Bill-to Address";
                    BillToAddress2 := "Sales Shipment Header"."Bill-to Address 2";
                    BillToContact := "Sales Shipment Header"."Bill-to Contact";
                    BillToCity := "Sales Shipment Header"."Bill-to City";
                    BillToZip := "Sales Shipment Header"."Bill-to Post Code";
                    BillToName := "Sales Shipment Header"."Bill-to Name";
                    BillToState := "Sales Shipment Header"."Bill-to County";
                end;
                //pr 6/19/25 - If Freight Charge Terms = 'Third Party', a custom freight charge address should be used - end

                BarCodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarCodeFontProviderExtDoc := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarCodeSymbology := Enum::"Barcode Symbology"::Code39;
                BarCodeSymbologyExt := Enum::"Barcode Symbology"::Code39;
                BarcodeStr := '*' + "No." + '*';
                formattedSellToAddress += "Sales Shipment Header"."Sell-to City" + ' ' + "Sales Shipment Header"."Sell-to County" + ', ' + "Sales Shipment Header"."Sell-to Post Code";
                formattedSellFromAddress += ShipFromCity + ' ' + ShipFromState + ', ' + ShipFromPostalCode;
                formattedBillToAddress += BillToCity + ' ' + BillToState + ', ' + BillToZip;

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
                freightChargePrePaid := '';
                freightChargeCol := '';
                freightCharge3 := '';
                totalCalcCountNum := 0;
                totalCalcWeightNum := 0;



                if ("Sales Shipment Header".FreightChargeTerm = "Sales Shipment Header".FreightChargeTerm::Prepaid) then begin
                    freightChargePrePaid := 'Pr';
                end
                else
                    if ("Sales Shipment Header".FreightChargeTerm = "Sales Shipment Header".FreightChargeTerm::Collect) then begin
                        freightChargeCol := 'C';
                    end
                    else
                        if ("Sales Shipment Header".FreightChargeTerm = "Sales Shipment Header".FreightChargeTerm::"3rd Party") then begin
                            freightCharge3 := 'rd';
                        end;


                //  WHERE("Document Type" = field("Document Type"), "No." = field("Document No."))
                //bolLine.SetRange("Customer No.".c);
                SalesLine.Reset;
                SalesLine.SetRange("Document No.", "No.");
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
                            totalCalcCountNum += LinePckg;
                            totalCalcWeightNum += SalesLine."M-Pack Weight" * LinePckg;
                        end;


                    Until SalesLine.Next() = 0;

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }

    }
    var
        EncodeText: Text[100];
        EncodeTextExtDoc: Text[100];
        formattedSellToAddress: Text[100];
        formattedSellFromAddress: Text[100];
        formattedBillToAddress: Text[100];
        freightChargePrepaid: Text[100];
        freightChargeCol: Text[100];
        freightCharge3: Text[100];
        Loc: Record location;
        SalesLine: Record "Sales Line";
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
        externalDocNO1: Code[20];
        postedSalesShip: record "Sales Shipment Header";
        WhseSetup: Record "Warehouse Setup";
        ShippingAgent: Record "Shipping Agent";
        LinePckg: Decimal;

        SRSetup: record "Sales & Receivables Setup";
        ShipFromName: Text;
        ShipFromAddress: Text;
        ShipFromCity: Text;
        ShipFromState: Text;
        ShipFromPostalCode: Text;
        ShipFromCountry: Text;
        ShipFromContact: Text;

        BillToContact: Text;
        BillToAddress: Text;
        BillToCity: Text;
        BillToZip: Text;
        BillToName: Text;
        BillToState: Text;
        BillToAddress2: Text;

        CompInfo: Record "Company Information";
}