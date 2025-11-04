xmlport 50116 PickInstructionXMLPort
{
    Caption = 'Pick Instruction XML Export';
    Direction = Export;
    Format = Xml;
    UseRequestPage = false;
    DefaultFieldsValidation = true;


    schema
    {
        textelement(PickingList)
        {
            XmlName = 'PickingList';
            tableelement("SalesHeader"; "Sales Header")
            {
                RequestFilterFields = "No.";
                XmlName = 'SalesOrder';
                textelement(PickDate)
                {
                    trigger OnBeforePassVariable()
                    begin
                        PickDate := Format(GetDt);
                    end;
                }
                textelement(General)
                {

                    fieldelement(OrderNo; SalesHeader."No.")
                    {

                    }
                    fieldelement(OrderDate; SalesHeader."Order Date")
                    { }
                    textelement(FacilityCode)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            //pr 4/28/25 - get value from Location.Facility Code instead of FTP Server Setup - start
                            FacilityCode := loc."Facility Code";
                            //pr 4/28/25 - get value from Location.Facility Code instead of FTP Server Setup - start
                        end;
                    }
                    fieldelement(CustomerPO; SalesHeader."External Document No.")
                    { }
                    fieldelement(CustomerNo; SalesHeader."Sell-to Customer No.")
                    {

                    }
                    textelement(PackageLabelStyle)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            GetPackageLabelStyle := '';
                            GetPackageLabelStyle := Format(SalesHeader.ShippingLabelStyle);
                            PackageLabelStyle := GetPackageLabelStyle;
                        end;
                    }
                    fieldelement(YourReference; SalesHeader."Your Reference")
                    { }
                    fieldelement(RequestedShipDate; SalesHeader."Request Ship Date")
                    {

                    }
                    fieldelement(LocationCode; SalesHeader."Location Code")
                    { }
                    fieldelement(ShipmentMethod; SalesHeader."Shipment Method Code")
                    { }
                    fieldelement(Carrier; SalesHeader."Shipping Agent Code")
                    { }
                    fieldelement(CarrierService; SalesHeader."Shipping Agent Service Code")
                    { }
                    fieldelement(Type; SalesHeader.Type)
                    {

                    }

                    fieldelement(Dept; SalesHeader."Dept")
                    {

                    }

                }
                textelement(ShipTo)
                {
                    XmlName = 'ShipToInfo';
                    fieldelement(ShipToName; SalesHeader."Ship-to Name")
                    {

                    }
                    fieldelement(ShipToDCNo; SalesHeader.CustomerShipToCode)
                    {

                    }

                    fieldelement(ShipToAddress1; SalesHeader."Ship-to Address")
                    { }
                    fieldelement(ShiptToAddress2; SalesHeader."Ship-to Address 2")
                    { }
                    fieldelement(ShipToCity; SalesHeader."Ship-to City")
                    { }
                    fieldelement(ShipToState; SalesHeader."Ship-to County")
                    { }
                    fieldelement(ShipToZip; SalesHeader."Ship-to Post Code")
                    { }
                    fieldelement(ShipToCountry; SalesHeader."Ship-to Country/Region Code")
                    { }
                }
                textelement(ShipFrom)
                {
                    XmlName = 'ShipFromInfo';
                    fieldelement(ShipFromName; SalesHeader.ShipFromName)
                    { }
                    fieldelement(ShipFromAddress1; SalesHeader.ShipFromAdress)
                    { }
                    fieldelement(ShipFromCity; SalesHeader.ShipFromCity)
                    { }
                    fieldelement(ShipFromState; SalesHeader.ShipFromState)
                    { }
                    fieldelement(ShipFromZip; SalesHeader.ShipFromPostalCode)
                    { }
                    fieldelement(ShipFromCountry; SalesHeader.ShipFromCountry)
                    {
                        trigger OnBeforePassField()
                        begin
                            if STRLEN(SalesHeader.ShipFromCountry) = 0 then
                                currXMLport.Skip();
                        end;
                    }



                }
                textelement(ShipmentLines)
                {
                    XmlName = 'ShipmentLines';

                    tableelement(SalesLine; "Sales Line")
                    {
                        XmlName = 'ItemLineInfo';
                        LinkTable = SalesHeader;
                        LinkFields = "Document No." = Field("No."), "Document Type" = filter("Document Type"::Order), Type = filter(type::Item);
                        SourceTableView = sorting("Document Type", "Document No.", "Line No.");


                        fieldelement(LineNo; SalesLine."Line No.")
                        {

                        }
                        fieldelement(ItemNo; SalesLine."No.")
                        { }
                        fieldelement(ItemDescription; SalesLine.Description)
                        {

                        }
                        textelement(ItemCrossRefNo)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                ItemCrossRefNo_Cd := '';
                                ItemCrossRef.Reset();
                                ItemCrossRef.SetRange("Item No.", SalesLine."No.");
                                ItemCrossRef.SetRange("Reference Type", ItemCrossRef."Reference Type"::Customer);
                                ItemCrossRef.SetRange("Reference Type No.", SalesHeader."Sell-to Customer No.");
                                ItemCrossRef.SetRange("Unit of Measure", SalesLine."Unit of Measure");
                                If ItemCrossRef.FindFirst() then
                                    ItemCrossRefNo_Cd := ItemCrossRef."Reference No.";

                                if StrLen(ItemCrossRefNo_Cd) = 0 then
                                    currXMLport.Skip()
                                else
                                    ItemCrossRefNo := ItemCrossRefNo_Cd;
                            end;
                        }
                        textelement(GTIN)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                GTIN_Cd := '';
                                if Item.Get(SalesLine."No.") then
                                    GTIN_Cd := DelChr(Item.GTIN, '=', ' ');

                                if StrLen(GTIN_Cd) = 0 then
                                    currXMLport.Skip()
                                else
                                    GTIN := GTIN_Cd;


                            end;
                        }
                        textelement(UPCCode)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                UPCCode_Cd := '';
                                ItemUnitofMeasure_lRec.RESET;
                                ItemUnitofMeasure_lRec.SetRange("Item No.", SalesLine."No.");
                                ItemUnitofMeasure_lRec.SetRange(Code, 'M-PACK');
                                if ItemUnitofMeasure_lRec.FindFirst() then
                                    UPCCode_Cd := ItemUnitofMeasure_lRec.UPCCode;

                                if StrLen(UPCCode_Cd) = 0 then
                                    currXMLport.Skip()
                                else
                                    UPCCode := UPCCode_Cd;
                            end;
                        }


                        textelement(Quantity)
                        {
                            Trigger OnBeforePassVariable()
                            begin
                                Quantity := FORMAT(SalesLine.Quantity, 0, '<Precision,0:2><Standard Format,2>');
                            end;
                        }
                        fieldelement(UOM; SalesLine."Unit of Measure Code")
                        {

                        }
                        textelement(CaseQty)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                Cases_gDec := 0;
                                ItemUnitofMeasure_lRec.RESET;
                                ItemUnitofMeasure_lRec.SetRange("Item No.", SalesLine."No.");
                                ItemUnitofMeasure_lRec.SetRange(Code, 'M-PACK');
                                if ItemUnitofMeasure_lRec.FindFirst() then
                                    Cases_gDec := ItemUnitofMeasure_lRec."Qty. per Unit of Measure";


                                PackageCount := 0;
                                IF Cases_gDec > 0 then
                                    PackageCount := SalesLine."Quantity (Base)" / Cases_gDec;
                                CaseQty := format(Cases_gDec);
                            end;
                        }
                        textelement(PackageCnt)
                        {
                            XmlName = 'PackageCount';
                            trigger OnBeforePassVariable()
                            begin
                                PackageCnt := FORMAT(PackageCount, 0, '<Precision,0:2><Standard Format,2>');
                            end;
                        }
                        trigger OnPreXmlItem()
                        begin
                            SalesLine.SetFilter("No.", '<>%1', '');
                        end;

                        trigger OnAfterGetRecord()
                        var
                            Item: Record Item;
                        begin
                            IF SalesLine.Type <> SalesLine.Type::Item then
                                currXMLport.Skip()
                            ELSE begin
                                if Item.GET(SalesLine."No.") then;
                                if Item.Type <> Item.Type::Inventory then
                                    currXMLport.Skip();
                            end;

                        end;
                    }



                }
                textelement(WorkDescription)
                {
                    trigger OnBeforePassVariable()
                    begin
                        txtWorkDescription := '';
                        txtWorkDescription := GetWorkDescription();
                        if strlen(txtWorkDescription) = 0 then
                            currXMLport.Skip();
                        WorkDescription := txtWorkDescription;
                    end;
                }


                trigger OnPreXmlItem()
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("No.", GetNo);
                    If SalesHeader.FindFirst() then;
                    GetDt := today;

                    IF Loc.Get(SalesHeader."Location Code") then;

                    //get Type/Dept if need be
                    If (StrPos(Salesheader."Your Reference", 'EDI') = 1) then begin
                        SalesCommentLn.Reset();
                        SalesCommentLn.SetRange("Document Type", Salesheader."Document Type");
                        SalesCommentLn.SetRange("No.", Salesheader."No.");
                        SalesCommentLn.SetFilter(Code, '%1|%2', 'DP', 'MR');
                        IF SalesCommentLn.FindSet() then
                            repeat
                                Case SalesCommentLn.Code of
                                    'DP':
                                        begin
                                            if StrLen(Salesheader.Dept) = 0 then begin
                                                Salesheader.Dept := CopyStr(SalesCommentLn.Comment.TrimEnd(), 4, STRLEN(SalesCommentLn.Comment.TrimEnd()) - 3);
                                                Salesheader.Modify(false);
                                            end;

                                        end;
                                    'MR':
                                        begin
                                            if StrLen(Salesheader.Type) = 0 then begin
                                                Salesheader.Type := CopyStr(SalesCommentLn.Comment.TrimEnd(), 4, STRLEN(SalesCommentLn.Comment.TrimEnd()) - 3);
                                                Salesheader.Modify(false);
                                            end;

                                        end;
                                end;
                            until SalesCommentLn.Next() = 0;
                    end;
                end;



            }

        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        GetNo: Code[20];
        GetDt: date;
        Cases_gDec: Decimal;
        PackageCount: Decimal;
        ItemUnitofMeasure_lRec: Record "Item Unit of Measure";
        txtWorkDescription: Text;
        ItemCrossRefNo_Cd: Code[50];
        UPCCode_Cd: Code[14];
        GTIN_Cd: Code[14];
        ItemCrossRef: Record "Item Reference";
        Item: Record Item;
        Cust: Record Customer;
        GetPackageLabelStyle: Text;
        GetSalesHdr: Record "Sales Header";
        SalesCommentLn: Record "Sales Comment Line";
        GetType: Text[10];
        GetDept: Text[10];
        Loc: Record Location;

    procedure SetGetNo(InValue: Code[20])
    begin
        GetNo := InValue;
    end;

    procedure GetWorkDescription(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        SalesHeader.CalcFields("Work Description");
        SalesHeader."Work Description".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;
}
