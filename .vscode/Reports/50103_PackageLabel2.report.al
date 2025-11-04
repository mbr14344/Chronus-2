report 50103 PackageLabel2
{
    Caption = 'Package Label 2';
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/PackageLabel2.rdl';

    dataset
    {


        dataitem(CustomSalesLine; CartonInformation)
        {

            column(Serial_No_; "Serial No.")
            {
            }
            column(Document_No_; "Document No.")
            {
            }
            column(DocumentLine_No_; "DocumentLine No.")
            {
            }
            column(Line_No_; "Line No.")
            {
            }
            column(Item_No_; "Item No.")
            {
            }
            column(ItemDesc; ItemDesc)
            {
            }
            column(ShipToPostCode; ShipToPostCode)
            {
            }
            column(ShipTo_Add1; ShipTo_Add[1])
            {
            }
            column(ShipTo_Add2; ShipTo_Add[2])
            {
            }
            column(ShipTo_Add3; ShipTo_Add[3])
            {
            }
            column(ShipTo_Add4; ShipTo_Add[4])
            {
            }
            column(ShipTo_Add5; ShipTo_Add[5])
            {
            }
            column(ShipFrm_LocAdd5; ShipFrm_LocAdd[5])
            {
            }
            column(ShipFrm_LocAdd1; ShipFrm_LocAdd[1])
            {
            }
            column(ShipFrm_LocAdd2; ShipFrm_LocAdd[2])
            {
            }
            column(ShipFrm_LocAdd3; ShipFrm_LocAdd[3])
            {
            }
            column(ShipFrm_LocAdd4; ShipFrm_LocAdd[4])
            {
            }
            column(Encoded_Postcode; Encoded_Postcode)
            {
            }
            column(Encoded_SSCCODE; Encoded_SSCCODE)
            {
            }
            column(Shipping_Agent_Code; ShipAgeCode)
            {
            }
            column(Ship_Agent_Desc; Ship_Agent_Desc)
            {
            }
            column(External_Document_No_; External_Document_No_)
            {
            }
            column(Type; Type)
            {
            }
            column(Dept; Dept)
            {
            }
            column(SpeRefVAlue; SpecRefValue)
            {
            }
            column(SpeRefCap; SpecRefCap)
            {
            }
            column(CasePackQty; CasePackQty)
            {
            }
            column(Carton; Carton)
            {
            }
            column(LineCount; LineCount)
            {
            }
            column(TOtalcount; TOtalcount)
            {
            }
            column(BarcodeString2; BarcodeString2)
            {

            }

            column(ForBarCodeString; ForBarCodeString)
            {
            }
            column(MarketingVendorBarCodeString; MarketingVendorBarCodeString)
            {
            }
            column(Encoded_For; Encoded_For)
            {
            }
            column(Encoded_MarketingVendor; Encoded_MarketingVendor)
            {
            }
            column(TotalWeight; TotalWeight)
            {
            }
            column(Ship_to_Code; Ship_to_Code)
            {
            }
            column(BOLNo; BOLNo)
            {
            }
            column(MarketingVendorNo; MarketingVendorNo)
            {
            }
            column(MarketingVendorPrefix; MarketingVendorPrefix)
            {
            }
            column(APVendorNo; APVendorNo)
            {
            }
            column(APVendorPrefix; APVendorPrefix)
            {
            }
            column(PackageTrackingNo; PackageTrackingNo)
            {
            }

            column(BarcodeString; BarcodeString)
            {

            }


            trigger OnAfterGetRecord()
            var
                SalesHeader_LRec: Record "Sales Header";
                CustomerRec: Record Customer;
                Location_LRec: Record Location;
                ItemUnitOfMeasure_LRec: Record "Item Unit of Measure";
                Item_LRec: Record Item;
                SalesLine: Record "Sales Line";
                Shipping_LRec: Record "Shipping Agent";
                BarcodeSymbology: Enum "Barcode Symbology";
                BarcodeFontProvider: Interface "Barcode Font Provider";
                MarketingVendorBarCodeSymbology: Enum "Barcode Symbology";
                MarketingVendorBarCodeProvider: Interface "Barcode Font Provider";
                ForBarCodeSymbology: Enum "Barcode Symbology";
                ForBarCodeProvider: Interface "Barcode Font Provider";

            begin
                TotalWeight := 0;
                BarcodeString2 := '';
                BarcodeString := '';
                Type := '';
                Dept := '';
                gtCartonInfo.RESET;
                gtCartonInfo.SetRange("Document Type", CustomSalesLine."Document Type");
                gtCartonInfo.setrange("Document No.", CustomSalesLine."Document No.");
                gtCartonInfo.SetCurrentKey("Document No.", "DocumentLine No.", LineCount);
                CasePackWeight := 0;
                if gtCartonInfo.FindSet() then
                    TOtalcount := gtCartonInfo.Count;

                SalesHeader_LRec.SetRange("No.", CustomSalesLine."Document No.");
                if SalesHeader_LRec.FindFirst() then begin

                    ShipTo_Add[1] := SalesHeader_LRec."Ship-to Name";
                    ShipTo_Add[2] := SalesHeader_LRec."Ship-to Address";
                    IF strlen(SalesHeader_LRec."Ship-to Address 2") > 0 then
                        ShipTo_Add[2] += ' ' + SalesHeader_LRec."Ship-to Address 2";
                    ShipTo_Add[3] := SalesHeader_LRec."Ship-to City" + ', ' + SalesHeader_LRec."Ship-to County" + '  ' + SalesHeader_LRec."Ship-to Post Code";
                    External_Document_No_ := SalesHeader_LRec."External Document No.";
                    Type := SalesHeader_LRec.type;
                    Dept := SalesHeader_LRec.Dept;
                    CompressArray(ShipTo_Add);

                    ItemReference.SetRange("Item No.", CustomSalesLine."Item No.");
                    ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Customer);
                    ItemReference.SetRange("Reference Type No.", SalesHeader_LRec."Sell-to Customer No.");
                    IF ItemReference.FindFirst() then begin
                        SpecRefValue := ItemReference."Reference No.";
                    end;
                    BOLNo := SalesHeader_LRec."Single BOL No.";
                    PackageTrackingNo := SalesHeader_LRec."Package Tracking No.";
                    Location_LRec.SetRange(Code, SalesHeader_LRec."Location Code");
                    if Location_LRec.FindFirst() then begin
                        ShipFrm_LocAdd[1] := Location_LRec.Name;
                        ShipFrm_LocAdd[2] := Location_LRec.Address;
                        ShipFrm_LocAdd[3] := Location_LRec."Address 2";
                        ShipFrm_LocAdd[4] := Location_LRec.City + ', ' + Location_LRec.County + '  ' + Location_LRec."Post Code";

                    end;
                    CustomerRec.Reset();
                    CustomerRec.SetRange("No.", SalesHeader_LRec."Sell-to Customer No.");
                    if CustomerRec.FindFirst() then begin
                        MarketingVendorNo := CustomerRec.MarketingVendorNo;
                        MarketingVendorPrefix := CustomerRec.MarketingVendorPrefix;
                        PostalCodePrefix := CustomerRec.PostalCodePrefix;
                        ShipToCodePrefix := CustomerRec.ShipToCodePrefix;
                    end;
                    Ship_to_Code := SalesHeader_LRec."Ship-to Code";
                    ShipToPostCode := SalesHeader_LRec."Ship-to Post Code";
                end;



                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
                BarcodeString := '(' + PostalCodePrefix + ') ' + ShipToPostCode;
                BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
                Encoded_Postcode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);

                ////////////////////////////////////SSC Code///////////////////////////////////////////////
                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
                BarcodeString2 := '(00) ' + CustomSalesLine."Serial No.";
                BarcodeFontProvider.ValidateInput(BarcodeString2, BarcodeSymbology);
                Encoded_SSCCODE := BarcodeFontProvider.EncodeFont(BarcodeString2, BarcodeSymbology);
                // marking vendor
                MarketingVendorBarCodeProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                MarketingVendorBarCodeSymbology := Enum::"Barcode Symbology"::Code128;
                MarketingVendorBarCodeString := '(' + MarketingVendorPrefix + ') ' + MarketingVendorNo;
                MarketingVendorBarCodeProvider.ValidateInput(MarketingVendorBarCodeString, MarketingVendorBarCodeSymbology);
                Encoded_MarketingVendor := MarketingVendorBarCodeProvider.EncodeFont(MarketingVendorBarCodeString, MarketingVendorBarCodeSymbology);
                // for barcode
                ForBarCodeProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                ForBarCodeSymbology := Enum::"Barcode Symbology"::Code128;
                ForBarCodeString := '(' + ShipToCodePrefix + ') ' + Ship_to_Code;
                ForBarCodeProvider.ValidateInput(ForBarCodeString, ForBarCodeSymbology);
                Encoded_For := ForBarCodeProvider.EncodeFont(ForBarCodeString, ForBarCodeSymbology);


                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange("Document No.", CustomSalesLine."Document No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                if SalesLine.FindSet() then
                    repeat
                        CasePackQty := 0;
                        CasePackWeight := 0;
                        ItemUnitOfMeasure_LRec.SetRange("Item No.", SalesLine."No.");
                        ItemUnitOfMeasure_LRec.SetRange(Code, 'M-PACK');
                        if ItemUnitOfMeasure_LRec.FindFirst() then begin
                            CasePackQty := ItemUnitOfMeasure_LRec."Qty. per Unit of Measure";
                            CasePackWeight := ItemUnitOfMeasure_LRec.Weight;
                        end;
                        SalesLine.CalcFields("Reserved Quantity");
                        ItemDesc := SalesLine.Description;
                        Carton := SalesLine."Reserved Quantity" / CasePackQty;
                        TotalWeight := TotalWeight + (Carton * CasePackWeight);
                    until SalesLine.next = 0;


                SalesHeader_LRec.SetRange("No.", CustomSalesLine."Document No.");
                if SalesHeader_LRec.FindFirst() then begin
                    Shipping_LRec.SetRange(Code, SalesHeader_LRec."Shipping Agent Code");
                    if Shipping_LRec.FindFirst() then begin
                        Ship_Agent_Desc := Shipping_LRec.Name;
                        ShipAgeCode := Shipping_LRec.Code;
                    end;
                end;
            end;
        }

    }



    var
        ShipFrm_LocAdd: array[8] of Text[100];
        ShipTo_Add: array[8] of Text[100];
        Encoded_Postcode: Text;
        Encoded_SSCCODE: Text;
        Encoded_For: Text;
        Encoded_MarketingVendor: Text;
        Ship_Agent_Desc: Text[50];
        ShipAgeCode: Code[30];
        BOLNo: code[30];
        PackageTrackingNo: Code[30];

        MarketingVendorPrefix: code[30];
        MarketingVendorNo: code[30];
        ItemReference: Record "Item Reference";
        CasePackQty: Decimal;
        Carton: Decimal;

        SpecRefCap: Text[30];
        SpecRefValue: Text[30];

        External_Document_No_: Code[35];
        SSCCode: Text[30];
        ItemDesc: Text;
        APVendorNo: code[30];
        APVendorPrefix: code[30];
        ShipToCodePrefix: code[30];
        Ship_to_Code: code[30];
        ShipToPostCode: Text[30];
        TOtalcount: Integer;
        BarcodeString: Text;
        BarcodeString2: Text;
        ForBarCodeString: Text;
        MarketingVendorBarCodeString: Text;
        PostalCodePrefix: code[30];

        gtCartonInfo: record CartonInformation;
        TotalWeight: Decimal;
        CasePackWeight: Decimal;

        Type: Text;
        Dept: Text;
}