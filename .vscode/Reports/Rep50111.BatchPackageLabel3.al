report 50111 BatchPackageLabel3
{
    Caption = 'Batch Package Label 3';
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/BatchPackageLabel3.rdl';

    dataset
    {
        dataitem(TmpTable; TmpTable)
        {

            PrintOnlyIfDetail = true;
            column(Entry_No_; "Entry No.")
            {

            }
            dataitem(CustomSalesLine; CartonInformation)
            {
                DataItemLink = "Document No." = field(DocumentNo);
                DataItemLinkReference = "TmpTable";
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
                column(BarcodeString; BarcodeString)
                {

                }
                column(shiptoPrefix; Cust.PostalCodePrefix)
                {

                }
                column(SCAC; SCAC)
                {

                }
                column(BOL; BOL)
                {

                }
                column(ProNo; ProNo)
                {

                }
                column(ShiptToCode; ShiptToCode)
                {

                }
                column(UPCCode; UPCCode)
                {

                }

                trigger OnAfterGetRecord()
                var
                    SalesHeader_LRec: Record "Sales Header";
                    Location_LRec: Record Location;
                    ItemUnitOfMeasure_LRec: Record "Item Unit of Measure";
                    Item_LRec: Record Item;
                    SalesLine: Record "Sales Line";
                    Shipping_LRec: Record "Shipping Agent";
                    BarcodeSymbology: Enum "Barcode Symbology";
                    BarcodeSymbologyPC: Enum "Barcode Symbology";
                    BarcodeFontProvider: Interface "Barcode Font Provider";
                    BarcodeFontProviderPC: Interface "Barcode Font Provider";


                begin
                    UPCCode := '';
                    BarcodeString2 := '';
                    Encoded_SSCCODE := '';
                    BarcodeString := '';
                    Type := '';
                    Dept := '';
                    SpecRefValue := '';

                    IF Item_LRec.GET(CustomSalesLine."Item No.") then
                        UPCCode := Item_LRec.GTIN;

                    gtCartonInfo.RESET;
                    gtCartonInfo.SetRange("Document Type", CustomSalesLine."Document Type");
                    gtCartonInfo.setrange("Document No.", CustomSalesLine."Document No.");
                    gtCartonInfo.SetCurrentKey("Document No.", "DocumentLine No.", LineCount);


                    if gtCartonInfo.FindSet() then
                        TOtalcount := gtCartonInfo.Count;

                    SalesHeader_LRec.SetRange("No.", CustomSalesLine."Document No.");
                    if SalesHeader_LRec.FindFirst() then begin
                        ShiptToCode := SalesHeader_LRec."Ship-to Code";
                        If Cust.get(SalesHeader_LRec."Sell-to Customer No.") then;
                        SCAC := SalesHeader_LRec."Shipping Agent Code";
                        ProNo := SalesHeader_LRec."Package Tracking No.";
                        BOL := SalesHeader_LRec."Single BOL No.";
                        SpecRefCap := Cust.SpecialReferenceCaption;
                        Type := SalesHeader_LRec.type;
                        Dept := SalesHeader_LRec.Dept;

                        ShipTo_Add[1] := SalesHeader_LRec."Ship-to Name";
                        ShipTo_Add[2] := SalesHeader_LRec."Ship-to Address";
                        ShipTo_Add[3] := SalesHeader_LRec."Ship-to Address 2";
                        ShipTo_Add[4] := SalesHeader_LRec."Ship-to City" + ', ' + SalesHeader_LRec."Ship-to County" + '  ' + SalesHeader_LRec."Ship-to Post Code";
                        External_Document_No_ := SalesHeader_LRec."External Document No.";
                        CompressArray(ShipTo_Add);
                        ItemReference.SetRange("Item No.", CustomSalesLine."Item No.");
                        ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Customer);
                        ItemReference.SetRange("Reference Type No.", SalesHeader_LRec."Sell-to Customer No.");
                        IF ItemReference.FindFirst() then begin

                            SpecRefValue := ItemReference."Reference No.";
                        end;
                    end;

                    SalesHeader_LRec.Reset();
                    SalesHeader_LRec.SetRange("No.", "Document No.");
                    if SalesHeader_LRec.FindFirst() then begin
                        Location_LRec.SetRange(Code, SalesHeader_LRec."Location Code");
                        if Location_LRec.FindFirst() then begin
                            ShipFrm_LocAdd[1] := Location_LRec.Name;
                            ShipFrm_LocAdd[2] := Location_LRec.Address;
                            ShipFrm_LocAdd[3] := Location_LRec."Address 2";
                            ShipFrm_LocAdd[4] := Location_LRec.City + ', ' + Location_LRec.County + '  ' + Location_LRec."Post Code";

                        end;
                    end;
                    ShipToPostCode := SalesHeader_LRec."Ship-to Post Code";
                    BarcodeFontProviderPC := Enum::"Barcode Font Provider"::IDAutomation1D;
                    BarcodeSymbologyPC := Enum::"Barcode Symbology"::Code128;


                    BarcodeString := '(' + Cust.PostalCodePrefix + ') ' + copystr(SalesHeader_LRec."Ship-to Post Code", 1, 5);
                    BarcodeFontProviderPC.ValidateInput(BarcodeString, BarcodeSymbologyPC);
                    Encoded_Postcode := BarcodeFontProviderPC.EncodeFont(BarcodeString, BarcodeSymbologyPC);

                    ////////////////////////////////////SSC Code///////////////////////////////////////////////
                    BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                    BarcodeSymbology := Enum::"Barcode Symbology"::Code128;

                    BarcodeString2 := '(00) ' + COPYSTR(CustomSalesLine."Serial No.", 1, 1) + ' ' + COPYSTR(CustomSalesLine."Serial No.", 2, 7) + ' ' + COPYSTR(CustomSalesLine."Serial No.", 9, 9) + ' ' + COPYSTR(CustomSalesLine."Serial No.", 18, 1);

                    Encoded_SSCCODE := '~202' + '00' + CustomSalesLine."Serial No.";
                    //No need to encode this field.  We will use the function from RDL instead to convert to barcode.
                    //BarcodeFontProvider.ValidateInput(BarcodeString2Txt, BarcodeSymbology);
                    //Encoded_SSCCODE := BarcodeFontProvider.EncodeFont(BarcodeString2Txt, BarcodeSymbology);


                    CasePackQty := 0;
                    //  Item_LRec.SetRange("No.", "Sales Line"."No.");
                    ItemUnitOfMeasure_LRec.SetRange("Item No.", CustomSalesLine."Item No.");
                    ItemUnitOfMeasure_LRec.SetRange(Code, 'M-PACK');
                    if ItemUnitOfMeasure_LRec.FindFirst() then begin
                        CasePackQty := ItemUnitOfMeasure_LRec."Qty. per Unit of Measure";
                    end;
                    SalesLine.SetRange("Document Type", CustomSalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.", CustomSalesLine."Document No.");
                    SalesLine.SetRange("Line No.", CustomSalesLine."DocumentLine No.");
                    SalesLine.SetRange("No.", CustomSalesLine."Item No.");
                    if SalesLine.FindFirst() then begin
                        SalesLine.CalcFields("Reserved Quantity");
                        ItemDesc := SalesLine.Description;
                        Carton := SalesLine."Reserved Quantity" / CasePackQty;
                    end;


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

    }

    var
        ShipFrm_LocAdd: array[8] of Text[100];
        ShipTo_Add: array[8] of Text[100];
        Encoded_Postcode: Text;
        Encoded_SSCCODE: Text;
        Ship_Agent_Desc: Text[50];
        ShipAgeCode: Code[30];

        ItemReference: Record "Item Reference";
        CasePackQty: Decimal;
        Carton: Decimal;

        SpecRefCap: Text[30];
        SpecRefValue: Text[30];

        External_Document_No_: Code[35];
        SSCCode: Text[30];
        ItemDesc: Text;

        ShipToPostCode: Text[30];
        TOtalcount: Integer;
        BarcodeString2: Text;
        BarcodeString: Code[20];
        gtCartonInfo: record CartonInformation;

        Cust: Record Customer;
        SCAC: Text;
        BOL: text;
        ProNo: Text;
        ShiptToCode: Code[20];
        Type: Text;
        Dept: Text;
        UPCCode: Text;
        init: Boolean;

    procedure LoadCartonInfo(SalesHeader: Record "Sales Header")
    var
        i: Integer;
    begin
        if init = false then begin
            TmpTable.DeleteAll();
            init := true;
        end;

        TmpTable.RESET;
        TmpTable.SetRange(DocumentNo, SalesHeader."No.");
        IF NOT TmpTable.FindSet() then begin

            TmpTable.RESET;
            if TmpTable.FindLast() then
                i := TmpTable."Entry No." + 1
            else
                i := 1;
            TmpTable.Init();
            TmpTable.DocumentNo := SalesHeader."No.";
            TmpTable."Entry No." := i;
            TmpTable.INSERT;

        end;

    end;

}
