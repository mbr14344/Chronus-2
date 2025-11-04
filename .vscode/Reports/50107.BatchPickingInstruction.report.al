report 50107 BatchPickingInstruction
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/BatchPickingInstruction.rdl';
    Caption = 'Picking Instruction';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {

        dataitem(TmpTable; TmpTable)
        {

            PrintOnlyIfDetail = true;
            column(Picking_List_by_OrderCaption; Picking_List_by_OrderCaptionLbl)
            {
            }
            column(CompanyInfoPicture; CompanyInfo_gRec.Picture)
            {

            }

            dataitem("Sales Header"; "Sales Header")
            {
                DataItemLink = "No." = field(Code);
                DataItemLinkReference = "TmpTable";

                column(WorkDescription; WorkDescription)
                {
                }
                column(WorkDescriptionLbl; WorkDescriptionLbl)
                {

                }
                column(Sales_Header_Document_Type; "Document Type")
                {
                }
                column(Sales_Header_No_; "No.")
                {
                }
                column(Sell_to_Customer_Name; "Sell-to Customer Name")
                {

                }
                column(Your_Reference; "Your Reference")
                {

                }
                column(External_Document_No_; "External Document No.")
                {

                }
                column(Request_Ship_Date; "Request Ship Date")
                {

                }
                column(Location_Code; "Location Code")
                {

                }
                column(Ship_to_Name; "Ship-to Name")
                {

                }
                column(Ship_to_Address; "Ship-to Address")
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
                column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code")
                {

                }
                column(LocationName; GetLocation.Name)
                {

                }
                column(LocationAddress; GetLocation.Address)
                {

                }
                column(LocationAddress2; GetLocation."Address 2")
                {

                }
                column(LocationCity; GetLocation.City)
                {

                }
                column(LocationState; GetLocation.County)
                {

                }
                column(LocationPostCode; GetLocation."Post Code")
                {

                }
                column(LocationCountry; GetLocation."Country/Region Code")
                {

                }
                column(Shipment_Method_Code; "Shipment Method Code")
                {

                }
                column(Shipping_Agent_Code; "Shipping Agent Code")
                {

                }
                column(Shipping_Agent_Service_Code; "Shipping Agent Service Code")
                {

                }

                dataitem("Sales Line";
                "Sales Line")
                {
                    DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                    DataItemLinkReference = "Sales Header";
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.") where(Type = const(Item), "Outstanding Quantity" = filter(<> 0));

                    column(No_; "No.")
                    {

                    }
                    column(Description; Description)
                    {

                    }
                    column(Quantity; Quantity)
                    {

                    }
                    column(Unit_of_Measure_Code; "Unit of Measure Code")
                    {

                    }
                    column(Cases_gDec; Cases_gDec)
                    {

                    }
                    column(PackageCount; PackageCount)
                    {

                    }
                    trigger OnAfterGetRecord()
                    var
                        ItemUnitofMeasure_lRec: Record "Item Unit of Measure";
                    begin

                        Cases_gDec := 0;
                        ItemUnitofMeasure_lRec.RESET;
                        ItemUnitofMeasure_lRec.SetRange("Item No.", "Sales Line"."No.");
                        ItemUnitofMeasure_lRec.SetRange(Code, 'M-PACK');
                        if ItemUnitofMeasure_lRec.FindFirst() then
                            Cases_gDec := ItemUnitofMeasure_lRec."Qty. per Unit of Measure";


                        PackageCount := 0;
                        //"Sales Line".CalcFields("Reserved Qty. (Base)");  //mbr 4/12/24 - we will now use  qty base to calculate package count
                        IF Cases_gDec > 0 then
                            PackageCount := "Sales Line"."Quantity (Base)" / Cases_gDec;

                        WorkDescription := '';
                        WorkDescription := "Sales Header".GetWorkDescription();

                    end;

                }
                trigger OnAfterGetRecord()
                begin
                    GetLocation.Reset();
                    GetLocation.SetRange(Code, "Sales Header"."Location Code");
                    If GetLocation.FindFirst() then;
                end;
            }
        }
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


        CompanyInfo_gRec.Get();
        CompanyInfo_gRec.CalcFields(Picture);

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
        Init: Boolean;

    //jay 18/04/24 --

    protected var
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";

    procedure AnySalesLinesThisLocation(LocationCode: Code[10]): Boolean
    var
        SalesLine2: Record "Sales Line";
    begin
        SalesLine2.SetCurrentKey(SalesLine2.Type, SalesLine2."No.", SalesLine2."Variant Code", SalesLine2."Drop Shipment", SalesLine2."Location Code", SalesLine2."Document Type");
        SalesLine2.SetRange(SalesLine2."Document Type", "Sales Header"."Document Type");
        SalesLine2.SetRange(SalesLine2."Document No.", "Sales Header"."No.");
        SalesLine2.SetRange(SalesLine2."Location Code", LocationCode);
        SalesLine2.SetRange(SalesLine2.Type, SalesLine2.Type::Item);
        exit(SalesLine2.FindFirst());
    end;

    procedure LoadSalesHeader(GetSalesHeader: Record "Sales Header")
    var
        i: Integer;
    begin
        if init = false then begin
            TmpTable.DeleteAll();
            init := true;
        end;
        TmpTable.RESET;
        if TmpTable.FindLast() then
            i := TmpTable."Entry No." + 1
        else
            i := 1;
        TmpTable.RESET;
        TmpTable.SetRange(Code, GetSalesHeader."No.");
        IF NOT TmpTable.FindSet() then begin
            TmpTable.Init();
            TmpTable."Code" := GetSalesHeader."No.";
            TmpTable."Entry No." := i;
            TmpTable.INSERT;
        end;

    end;
}