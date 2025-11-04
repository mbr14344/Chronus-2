report 50124 "PostedPickingListbyOrderCust"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/PostedPickingListbyOrderCustom.rdl';
    Caption = 'Picking Instruction';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;


    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            RequestFilterFields = "No.", "Sell-to Customer No.";
            column(Sales_Header_No_; "No.")
            {
            }
            column(Order_No_; "Order No.")
            {

            }
            column(TotalQty; TotalQty)
            {

            }
            column(TotalPackageCount; TotalPackageCount)
            {

            }

            /*dataitem(LocationLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                dataitem(CopyNo; "Integer")
                {
                    DataItemTableView = sorting(Number);
                    dataitem(PageLoop; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));*/
            column(CompanyInfo2_Picture; CompanyInfo2.Picture)
            {
            }
            column(CompanyInfo1_Picture; CompanyInfo1.Picture)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            //jay 18/01/24 ++
            column(CompanyInfoPicture; CompanyInfo_gRec.Picture)
            {

            }
            //jay 18/01/24 --
            column(Sales_Header___No__; "Sales Shipment Header"."No.")
            {
            }
            column(Sales_Header___Order_Date_; "Sales Shipment Header"."Order Date")
            {
            }
            column(Sales_Header___Sell_to_Customer_No__; "Sales Shipment Header"."Sell-to Customer No.")
            {
            }

            //jay 18/01/24 ++
            column(Sales_Header___Sell_to_Customer_Name__; "Sales Shipment Header"."Sell-to Customer Name")
            {

            }
            column(Sales_Header___ExternalDocNo; "Sales Shipment Header"."External Document No.")
            {

            }
            column(Sales_Header___YourReference; "Sales Shipment Header"."Your Reference")
            {

            }
            column(Sales_Header___RequestedShipDate; "Sales Shipment Header"."Request Ship Date")
            {

            }
            column(Sales_Header___LoctionCode; "Sales Shipment Header"."Location Code")
            {

            }
            column(Sales_Header___ShipmentMethodCode; "Sales Shipment Header"."Shipment Method Code")
            {

            }
            column(Sales_Header___AgentShipmentCode; "Sales Shipment Header"."Shipping Agent Code")
            {

            }
            column(Sales_Header___ShippingAgentService; "Sales Shipment Header"."Shipping Agent Service Code")
            {

            }
            column(WorkDescription; WorkDescription)
            {
            }
            //jay 18/01/24 --
            column(SalesPurchPerson_Name; SalesPurchPerson.Name)
            {
            }
            column(ShipToAddress_1_; ShipToAddress[1])
            {
            }
            column(ShipToAddress_2_; ShipToAddress[2])
            {
            }
            column(ShipToAddress_3_; ShipToAddress[3])
            {
            }
            column(ShipToAddress_4_; ShipToAddress[4])
            {
            }
            column(ShipToAddress_5_; ShipToAddress[5])
            {
            }
            column(ShipToAddress_6_; ShipToAddress[6])
            {
            }
            column(ShipToAddress_7_; ShipToAddress[7])
            {
            }
            column(Sales_Header___Shipment_Date_; "Sales Shipment Header"."Shipment Date")
            {
            }
            column(Address_1_; Address[1])
            {
            }
            column(Address_2_; Address[2])
            {
            }
            column(Address_3_; Address[3])
            {
            }
            column(Address_4_; Address[4])
            {
            }
            column(Address_5_; Address[5])
            {
            }
            column(Address_6_; Address[6])
            {
            }
            column(Address_7_; Address[7])
            {
            }
            column(ShipmentMethod_Description; ShipmentMethod.Description)
            {
            }
            column(PaymentTerms_Description; PaymentTerms.Description)
            {
            }
            column(TempLocation_Code; TempLocation.Code)
            {
            }
            /*  column(myCopyNo; CopyNo.Number)
              {
              }
              column(LocationLoop_Number; LocationLoop.Number)
              {
              }
              column(PageLoop_Number; Number)
              {
              }*/
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(Sales_Header___Order_Date_Caption; Sales_Header___Order_Date_CaptionLbl)
            {
            }
            column(Sales_Header___No__Caption; Sales_Header___No__CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Line__Outstanding_Quantity_Caption; Sales_Line__Outstanding_Quantity_CaptionLbl)
            {
            }
            /*column(Sales_Line__Quantity_Shipped_Caption; "Sales Shipment Line".FieldCaption("Quantity Shipped"))
            {
            }*/
            column(Sales_Header___Sell_to_Customer_No__Caption; Sales_Header___Sell_to_Customer_No__CaptionLbl)
            {
            }
            column(Sales_Header___Shipment_Date_Caption; Sales_Header___Shipment_Date_CaptionLbl)
            {
            }
            column(SalesPurchPerson_NameCaption; SalesPurchPerson_NameCaptionLbl)
            {
            }
            column(Sales_Line_QuantityCaption; Sales_Line_QuantityCaptionLbl)
            {
            }
            column(Ship_To_Caption; Ship_To_CaptionLbl)
            {
            }
            column(Picking_List_by_OrderCaption; Picking_List_by_OrderCaptionLbl)
            {
            }
            column(Sales_Line__No__Caption; Sales_Line__No__CaptionLbl)
            {
            }
            column(ShipmentMethod_DescriptionCaption; ShipmentMethod_DescriptionCaptionLbl)
            {
            }
            column(PaymentTerms_DescriptionCaption; PaymentTerms_DescriptionCaptionLbl)
            {
            }
            column(Item__Shelf_No__Caption; Item__Shelf_No__CaptionLbl)
            {
            }
            column(TempLocation_CodeCaption; TempLocation_CodeCaptionLbl)
            {
            }
            column(Sold_To_Caption; Sold_To_CaptionLbl)
            {
            }
            //jay 18/01/2023 ++
            column(CustomerLbl; CustomerLbl)
            {

            }
            column(YourReferenceLbl; YourReferenceLbl)
            {

            }
            column(CustomerPOLbl; CustomerPOLbl)
            {

            }
            column(RequestedShipDateLbl; RequestedShipDateLbl)
            {

            }
            column(ShipFromLbl; ShipFromLbl)
            {

            }
            column(ShipmentMethdoLbl; ShipmentMethdoLbl)
            {

            }
            column(carrierLbl; carrierLbl)
            {

            }
            column(CarrierServiceLbl; CarrierServiceLbl)
            {

            }
            column(DescriptionLbl; DescriptionLbl)
            {

            }
            column(QuantityLbl; QuantityLbl)
            {

            }
            column(CaseLbl; CaseLbl)
            {

            }
            column(CaseCntLbl; CaseCntLbl)
            {

            }
            column(BinLbl; BinLbl)
            {

            }
            column(WorkDescriptionLbl; WorkDescriptionLbl)
            {

            }
            column(UOMLbl; UOMLbl)
            {

            }



            //jay 18/01/2023 --
            dataitem("Sales Shipment Line";
            "Sales Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Shipment Header";
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = const(Item));
                RequestFilterFields = "Shipment Date";
                column(Document_No_; "Document No.")
                {

                }
                column(Item__Shelf_No__; Item."Shelf No.")
                {
                }
                column(Sales_Line__No__; "No.")
                {
                }
                column(Sales_Line__Unit_of_Measure_; "Unit of Measure")
                {
                }
                column(Sales_Line_Quantity; Quantity)
                {
                    DecimalPlaces = 2 : 5;
                }
                /*column(Sales_Line__Quantity_Shipped_; "Quantity Shipped")
                {
                    DecimalPlaces = 2 : 5;
                }
                column(Sales_Line__Outstanding_Quantity_; "Outstanding Quantity")
                {
                    DecimalPlaces = 2 : 5;
                }*/
                column(Sales_Line_Description; Description)
                {
                }
                column(EmptyString; '')
                {
                }
                column(Sales_Line__Variant_Code_; "Variant Code")
                {
                }
                column(myAnySerialNos; AnySerialNos)
                {
                }
                column(Sales_Line_Document_No_; "Document No.")
                {
                }
                column(Sales_Line_Line_No_; "Line No.")
                {
                }
                column(Cases_gDec; Cases_gDec)
                {

                }
                column(BinCode_SalesLine; "Sales Shipment Line"."Bin Code")
                {

                }
                column(PackageCount; PackageCount)
                {

                }
                /*column(Reserved_Qty___Base_; "Reserved Qty. (Base)")
                {

                }
                column(Outstanding_Qty___Base_; "Outstanding Qty. (Base)")
                {

                }*/

                trigger OnAfterGetRecord()
                var
                    ItemUnitofMeasure_lRec: Record "Item Unit of Measure";
                begin
                    Item.Get("No.");
                    if Item."Item Tracking Code" <> '' then begin
                        TrackSpec2.SetCurrentKey(
                          TrackSpec2."Source ID", TrackSpec2."Source Type", TrackSpec2."Source Subtype", TrackSpec2."Source Batch Name", TrackSpec2."Source Prod. Order Line", TrackSpec2."Source Ref. No.");
                        TrackSpec2.SetRange(TrackSpec2."Source Type", DATABASE::"Sales Shipment Line");
                        TrackSpec2.SetRange(TrackSpec2."Source Subtype");
                        TrackSpec2.SetRange(TrackSpec2."Source ID", "Sales Shipment Line"."Document No.");
                        TrackSpec2.SetRange(TrackSpec2."Source Ref. No.", "Sales Shipment Line"."Line No.");
                        AnySerialNos := TrackSpec2.FindFirst();
                    end
                    else
                        AnySerialNos := false;

                    //jay 18/01/2024 added code for cases logic ++
                    Cases_gDec := 0;
                    ItemUnitofMeasure_lRec.RESET;
                    ItemUnitofMeasure_lRec.SetRange("Item No.", "Sales Shipment Line"."No.");
                    ItemUnitofMeasure_lRec.SetRange(Code, 'M-PACK');
                    if ItemUnitofMeasure_lRec.FindFirst() then
                        Cases_gDec := ItemUnitofMeasure_lRec."Qty. per Unit of Measure";
                    //jay 18/01/2024 added code for cases logic --

                    PackageCount := 0;
                    //"Sales Shipment Line".CalcFields("Reserved Qty. (Base)");  mbr 4/12/24 - we will use  Quantity Base instead
                    IF Cases_gDec > 0 then
                        PackageCount := "Sales Shipment Line"."Quantity (Base)" / Cases_gDec;


                end;

                trigger OnPreDataItem()
                begin
                    // SetRange("Location Code", TempLocation.Code);

                end;
            }


            /* dataitem("Reservation Entry"; "Reservation Entry")
             {
                 DataItemLink = "Source ID" = field("Document No."), "Source Ref. No." = field("Line No.");
                 DataItemTableView = sorting("Source ID", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.") where("Source Type" = const(37), "Source Subtype" = const("1"));
                 column(Reservation_Entry__Serial_No__; "Serial No.")
                 {
                 }
                 column(Reservation_Entry_Entry_No_; "Entry No.")
                 {
                 }
                 column(Reservation_Entry_Source_ID; "Source ID")
                 {
                 }
                 column(Reservation_Entry_Source_Ref__No_; "Source Ref. No.")
                 {
                 }
                 column(Reservation_Entry__Serial_No__Caption; FieldCaption("Serial No."))
                 {
                 }


                 trigger OnAfterGetRecord()
                 begin
                     if "Serial No." = '' then
                         "Serial No." := "Lot No.";
                 end;
             }

             

         }
         dataitem("Sales Comment Line"; "Sales Comment Line")
         {
             DataItemLink = "No." = field("No.");
             DataItemLinkReference = "Sales Shipment Header";
             DataItemTableView = sorting("Document Type", "No.", "Document Line No.", "Line No.") where("Document Type" = const(Order), "Print On Pick Ticket" = const(true));
             column(Sales_Comment_Line_Comment; Comment)
             {
             }
             column(Sales_Comment_Line_Document_Type; "Document Type")
             {
             }
             column(Sales_Comment_Line_No_; "No.")
             {
             }
             column(Sales_Comment_Line_Document_Line_No_; "Document Line No.")
             {
             }
             column(Sales_Comment_Line_Line_No_; "Line No.")
             {
             }
         }
         dataitem("<Sales Line Comment>"; "Sales Shipment Line")
         {
             DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
             DataItemLinkReference = "Sales Shipment Header";
             DataItemTableView = sorting("Document Type", "Document No.", "Line No.") where(Type = const(" "), Description = filter(<> ''));
             column(Sales_Line_Comment; Description)
             {
             }
             column(Sales_Line_Document_No_Comment; "Document No.")
             {
             }
             column(Sales_Line_Line_Comment; "Line No.")
             {
             }
         }*/
            /* }

             trigger OnPreDataItem()
             begin
                 SetRange(Number, 1, 1 + Abs(NoCopies));
             end;
         }

         trigger OnAfterGetRecord()
         begin
             if Number = 1 then
                 TempLocation.Find('-')
             else
                 TempLocation.Next();

             if not AnySalesLinesThisLocation(TempLocation.Code) then
                 CurrReport.Skip();
         end;

         trigger OnPreDataItem()
         begin
             SetRange(Number, 1, TempLocation.Count);
         end;
     }*/

            trigger OnAfterGetRecord()
            var
                ItemUnitofMeasure_lRec: Record "Item Unit of Measure";
                SalesShipLine: Record "Sales Shipment Line";
                getPackageCount: Decimal;
            begin
                if "Salesperson Code" = '' then
                    Clear(SalesPurchPerson)
                else
                    SalesPurchPerson.Get("Salesperson Code");

                if "Shipment Method Code" = '' then
                    Clear(ShipmentMethod)
                else
                    ShipmentMethod.Get("Shipment Method Code");

                if "Payment Terms Code" = '' then
                    Clear(PaymentTerms)
                else
                    PaymentTerms.Get("Payment Terms Code");

                //FormatAddress.SalesHeaderBillTo(Address, "Sales Shipment Header");  - we need this to be Ship From
                If "Sales Shipment Header"."Location Code" <> '' then begin
                    GetLocation.RESET;
                    GetLocation.SetRange(Code, "Sales Shipment Header"."Location Code");
                    IF GetLocation.FindFirst() then;
                    Address[1] := GetLocation.Name;
                    Address[2] := GetLocation.Address;
                    IF STRLEN(GetLocation."Address 2") > 0 then
                        Address[2] := Address[2] + ', ' + GetLocation."Address 2";
                    Address[3] := GetLocation.City + ', ' + GetLocation.County + '  ' + GetLocation."Post Code";
                    Address[4] := GetLocation."Country/Region Code";
                end;
                FormatAddress.SalesShptSellTo(ShipToAddress, "Sales Shipment Header");

                WorkDescription := "Sales Shipment Header".GetWorkDescription();

                TotalPackageCount := 0;
                TotalQty := 0;
                getPackageCount := 0;

                //get totals of quantity and package counts
                SalesShipLine.Reset();
                SalesShipLine.SetRange("Document No.", "Sales Shipment Header"."No.");
                SalesShipLine.SetRange(Type, SalesShipLine.Type::Item);
                IF SalesShipLine.FindSet() then
                    repeat
                        getPackageCount := 0;
                        ItemUnitofMeasure_lRec.RESET;
                        ItemUnitofMeasure_lRec.SetRange("Item No.", SalesShipLine."No.");
                        ItemUnitofMeasure_lRec.SetRange(Code, 'M-PACK');
                        if ItemUnitofMeasure_lRec.FindFirst() then begin
                            IF ItemUnitofMeasure_lRec."Qty. per Unit of Measure" > 0 then
                                getPackageCount := SalesShipLine."Quantity (Base)" / ItemUnitofMeasure_lRec."Qty. per Unit of Measure";
                        end;

                        TotalQty := TotalQty + SalesShipLine.Quantity;
                        TotalPackageCount := TotalPackageCount + getPackageCount;

                    until SalesShipLine.Next() = 0;



            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        SalesSetup.Get();

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo.Get();
                    CompanyInfo.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.Get();
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.Get();
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;

        //jay 18/01/2024 ++
        CompanyInfo_gRec.Get();
        CompanyInfo_gRec.CalcFields(Picture);
        //Jay 18/01/2024 --
    end;

    var
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        Item: Record Item;
        SalesPurchPerson: Record "Salesperson/Purchaser";
        TempLocation: Record Location temporary;
        TrackSpec2: Record "Tracking Specification";
        SalesSetup: Record "Sales & Receivables Setup";
        FormatAddress: Codeunit "Format Address";
        Address: array[8] of Text[100];
        ShipToAddress: array[8] of Text[100];
        AnySerialNos: Boolean;
        NoCopies: Integer;
        Text000: Label 'No Location Code';
        EmptyStringCaptionLbl: Label 'Picked';
        Sales_Header___Order_Date_CaptionLbl: Label 'Order Date:';


        Sales_Line__Outstanding_Quantity_CaptionLbl: Label 'Back Ordered';
        Sales_Header___Sell_to_Customer_No__CaptionLbl: Label 'Customer No:';
        Sales_Header___Shipment_Date_CaptionLbl: Label 'Shipment Date:';
        SalesPurchPerson_NameCaptionLbl: Label 'Salesperson:';
        Sales_Line_QuantityCaptionLbl: Label 'Quantity Ordered';
        Picking_List_by_OrderCaptionLbl: Label 'Picking List';

        ShipmentMethod_DescriptionCaptionLbl: Label 'Ship Via:';
        PaymentTerms_DescriptionCaptionLbl: Label 'Terms:';
        Item__Shelf_No__CaptionLbl: Label 'Shelf/Bin No.';
        TempLocation_CodeCaptionLbl: Label 'Location Code';
        Sold_To_CaptionLbl: Label 'Sold To:';
        //jay 18/04/24 ++
        CustomerLbl: Label 'Customer:';
        YourReferenceLbl: Label 'Your Reference:';
        Sales_Header___No__CaptionLbl: Label 'Order#';
        CustomerPOLbl: Label 'Customer PO#';
        RequestedShipDateLbl: Label 'Requested Ship Date';
        ShipFromLbl: Label 'Ship From';
        Ship_To_CaptionLbl: Label 'Ship To';
        ShipmentMethdoLbl: Label 'Shipment Method';
        Sales_Line__No__CaptionLbl: Label 'Item No.';
        CurrReport_PAGENOCaptionLbl: Label 'Page:';
        DescriptionLbl: Label 'Description';
        QuantityLbl: Label 'Quantity';
        UOMLbl: Label 'UOM';
        CaseLbl: Label 'Case Qty';
        CaseCntLbl: Label 'Case Count';
        BinLbl: Label 'Bin';
        WorkDescriptionLbl: Label 'Work Descripton:';
        carrierLbl: Label 'Carrier';
        CarrierServiceLbl: Label 'Carrier Service';
        CompanyInfo_gRec: Record "Company Information";
        Cases_gDec: Decimal;
        sfs: Report "Standard Purchase - Order";
        WorkDescription: Text;
        PackageCount: Decimal;
        GetLocation: Record location;
        TotalQty: Decimal;
        TotalPackageCount: Decimal;

    //jay 18/04/24 --

    protected var
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";

    procedure AnySalesLinesThisLocation(LocationCode: Code[10]): Boolean
    var
        SalesLine2: Record "Sales Shipment Line";
    begin
        SalesLine2.SetCurrentKey(SalesLine2.Type, SalesLine2."No.", SalesLine2."Variant Code", SalesLine2."Drop Shipment", SalesLine2."Location Code");
        SalesLine2.SetRange(SalesLine2."Document No.", "Sales Shipment Header"."No.");
        SalesLine2.SetRange(SalesLine2."Location Code", LocationCode);
        SalesLine2.SetRange(SalesLine2.Type, SalesLine2.Type::Item);
        exit(SalesLine2.FindFirst());
    end;
}
