report 50050 "ZDELMaster Bill of Lading"
{
    //pr 1/24/24 made report for master bol
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/MasterBOL_Report.rdl';
    Caption = 'Master Bill of Lading';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Master BOL"; "Master BOL")
        {

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
            column(SCAC_Code; "SCAC Code")
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
            column(Ship_From_Code; loc.code)
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
            column(Ship_To_Address; "Ship To Address")
            {
            }
            column(Ship_To_Address2; "Ship To Address2")
            {

            }

            column(Ship_To_City; "Ship To City")
            {

            }
            column(Ship_to_Code; "Ship to Code")
            {
            }
            column(Ship_To_Contact; "Ship To Contact")
            {
            }
            column(Ship_To_Name; "Ship To Name")
            {
            }
            column(Ship_To_Postal_Code; "Ship To Postal Code")
            {
            }
            column(Ship_To_State_County; "Ship To State/County")
            {
            }
            column(Customer_Ship_to_City; "Customer Ship to City")
            {
            }
            column(Freight_Charge_Term; "Freight Charge Term")
            {
            }
            column(Bill_To_Adress; "Bill To Adress")
            {
            }
            column(Bill_To_City; "Bill To City")
            {
            }
            column(Bill_To_Contact; "Bill To Contact")
            {
            }
            column(Bill_To_Name; "Bill To Name")
            {
            }
            column(Bill_To_Postal_Code; "Bill To Postal Code")
            {
            }
            column(Bill_To_State_County; "Bill To State/County")
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
            column(Carrier_Name; ShippingAgent.Name)
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
            column(WeightCount; WeightCount)
            {

            }

            column(CommodityDescrip; SRSetup."Commodity Description")
            {

            }
            column(NMFCNo; SRSetup."NMFC No.")
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
                "Master BOL".SetRange(Posted, false);
            end;

            trigger OnAfterGetRecord()
            var
                BarCodeSymbology: Enum "Barcode Symbology";
                BarCodeSymbologyExt: Enum "Barcode Symbology";
                BarCodeFontProvider: Interface "Barcode Font Provider";
                BarCodeFontProviderExtDoc: Interface "Barcode Font Provider";
                BarcodeStr: Code[20];
                BarcodeStrExtDoc: Code[30];
                GetMasterBOL: record "Master BOL";
            begin
                if loc.Get("Master BOL"."Location Code") then;
                BarCodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarCodeFontProviderExtDoc := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarCodeSymbology := Enum::"Barcode Symbology"::Code39;
                BarCodeSymbologyExt := Enum::"Barcode Symbology"::Code39;
                BarcodeStr := '*' + "External Doc No." + '*';
                BarCodeFontProvider.ValidateInput(BarcodeStr, BarCodeSymbology);
                EncodeText := BarCodeFontProvider.EncodeFont(BarcodeStr, BarCodeSymbology);
                formattedSellToAddress += "Master BOL"."Customer Ship to City" + ' ' + "Master BOL"."Ship To State/County" + ', ' + "Master BOL"."Ship To Postal Code";
                formattedSellFromAddress += loc.City + ' ' + loc.County + ', ' + loc."Post Code";
                formattedBillToAddress += "Master BOL"."Bill To City" + ' ' + "Master BOL"."Bill To State/County" + ', ' + "Master BOL"."Bill To Postal Code";
                //get total packages/total weight
                if bInit = false then begin
                    bInit := true;
                    TotalWeightCount := 0;
                    TotalPackageCount := 0;
                    GetMasterBOL.RESET;
                    GetMasterBOL.SetRange("Master BOL No.", "Master BOL"."Master BOL No.");
                    if GetMasterBOL.FindSet() then
                        repeat
                            SalesLine.Reset;
                            SalesLine.SetRange("Document No.", GetMasterBOL."Sales Order No.");
                            SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                            if SalesLine.FindSet() then
                                repeat
                                    "SalesLine".CalcFields("M-Pack Qty", "M-Pack Weight");
                                    LinePckg := 0;
                                    WeightCount := 0;
                                    IF SalesLine."M-Pack Qty" > 0 then begin
                                        IF (SalesLine."Quantity (Base)" MOD SalesLine."M-Pack Qty") > 0 then
                                            LinePckg := (SalesLine."Quantity (Base)" DIV SalesLine."M-Pack Qty") + 1
                                        ELSE
                                            LinePckg := (SalesLine."Quantity (Base)" / SalesLine."M-Pack Qty");
                                        WeightCount += SalesLine."M-Pack Weight" * LinePckg;
                                        TotalPackageCount += linePckg;
                                        TotalWeightCount += WeightCount;
                                    end;
                                Until SalesLine.Next() = 0;
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


                IF STRLEN("Master BOL"."SCAC Code") > 0 then
                    ShippingAgent.GET("Master BOL"."SCAC Code");

                SalesLine.Reset;
                SalesLine.SetRange("Document No.", "Master BOL"."Sales Order No.");
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                if SalesLine.FindSet() then
                    repeat
                        "SalesLine".CalcFields("M-Pack Qty", "M-Pack Weight", "Reserved Qty. (Base)");
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
        Loc: Record Location;
}