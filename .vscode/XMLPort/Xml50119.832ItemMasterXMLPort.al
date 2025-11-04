xmlport 50119 ItemMaster832XMLPort
{
    Caption = '832 Item Master XML Export';
    Direction = Export;
    Format = Xml;
    UseRequestPage = false;
    DefaultFieldsValidation = true;


    schema
    {
        textelement(PickingList)
        {
            XmlName = 'ItemMaster';
            tableelement(Item; Item)
            {
                RequestFilterFields = "No.";
                XmlName = 'Item';



                fieldelement("No."; Item."No.")
                {

                }
                fieldelement(Description; Item.Description)
                {

                }
                textelement("Type")
                {

                    //PR 4/3/25 - start
                    Trigger OnBeforePassVariable()
                    begin
                        "Type" := Item."Purchasing Code";

                        if StrLen(Item."Purchasing Code") <= 0 then
                            "Type" := PurchNPayablSetup."Purchasing Code Default"
                        else if (Item."Purchasing Code" <> PurchNPayablSetup."Purchasing Code Check") then
                            "Type" := PurchNPayablSetup."Purchasing Code Default";
                    end;
                    //PR 4/3/25 - end

                }

                textelement("NMFC")
                {
                    Trigger OnBeforePassVariable()
                    begin
                        "NMFC" := SalesNRecieve."NMFC No.";
                    end;


                }

                fieldelement("GTIN"; Item.GTIN)
                {

                }





                textelement("M-PACK_UPC_Code")
                {
                    Trigger OnBeforePassVariable()
                    begin
                        "M-PACK_UPC_Code" := MPACKItemUnitofMeasure_lRec.UPCCode;
                    end;


                }
                textelement("M-PACK_Qty")
                {
                    Trigger OnBeforePassVariable()
                    begin

                        "M-PACK_Qty" := FORMAT(MPACKItemUnitofMeasure_lRec."Qty. per Unit of Measure", 0, '<Precision,0:2><Standard Format,2>');
                    end;
                }
                textelement("M-PACK_Cube")
                {
                    Trigger OnBeforePassVariable()
                    begin
                        "M-PACK_Cube" := FORMAT(MPACKItemUnitofMeasure_lRec.Cubage, 0, '<Precision,0:2><Standard Format,2>');
                    end;
                }
                textelement("M-PACK_Weight")
                {
                    Trigger OnBeforePassVariable()
                    begin
                        "M-PACK_Weight" := FORMAT(MPACKItemUnitofMeasure_lRec.Weight, 0, '<Precision,0:2><Standard Format,2>');
                    end;
                }
                textelement("M-PACK_Length")
                {
                    Trigger OnBeforePassVariable()
                    begin

                        "M-PACK_Length" := FORMAT(MPACKItemUnitofMeasure_lRec.Length, 0, '<Precision,0:2><Standard Format,2>');
                    end;
                }
                textelement("M-PACK_Height")
                {
                    Trigger OnBeforePassVariable()
                    begin
                        "M-PACK_Height" := FORMAT(MPACKItemUnitofMeasure_lRec.Height, 0, '<Precision,0:2><Standard Format,2>');
                    end;
                }
                textelement("M-PACK_Width")
                {
                    Trigger OnBeforePassVariable()
                    begin
                        "M-PACK_Width" := FORMAT(MPACKItemUnitofMeasure_lRec.Weight, 0, '<Precision,0:2><Standard Format,2>');
                    end;
                }
                //PR 4/2/25 - start
                textelement("M-PACK_Ti")
                {
                    Trigger OnBeforePassVariable()
                    begin
                        "M-PACK_Ti" := FORMAT(MPACKItemUnitofMeasure_lRec.Ti, 0, '<Precision,0:2><Standard Format,2>');
                    end;
                }
                textelement("M-PACK_Hi")
                {
                    Trigger OnBeforePassVariable()
                    begin
                        "M-PACK_Hi" := FORMAT(MPACKItemUnitofMeasure_lRec.Hi, 0, '<Precision,0:2><Standard Format,2>');
                    end;
                }
                //PR 4/2/25 - end
                //EACH UOM
                textelement("EACH_UPC_Code")
                {
                    Trigger OnBeforePassVariable()
                    begin
                        "EACH_UPC_Code" := EACHItemUnitofMeasure_lRec.UPCCode;
                    end;


                }
                textelement("EACH_Qty")
                {
                    Trigger OnBeforePassVariable()
                    begin

                        "EACH_Qty" := FORMAT(EACHItemUnitofMeasure_lRec."Qty. per Unit of Measure", 0, '<Precision,0:2><Standard Format,2>');
                    end;
                }
                textelement("EACH_Cube")
                {
                    Trigger OnBeforePassVariable()
                    begin
                        "EACH_Cube" := FORMAT(EACHItemUnitofMeasure_lRec.Cubage, 0, '<Precision,0:2><Standard Format,2>');
                    end;
                }
                textelement("EACH_Weight")
                {
                    Trigger OnBeforePassVariable()
                    begin
                        "EACH_Weight" := FORMAT(EACHItemUnitofMeasure_lRec.Weight, 0, '<Precision,0:2><Standard Format,2>');
                    end;
                }
                textelement("EACH_Length")
                {
                    Trigger OnBeforePassVariable()
                    begin

                        "EACH_Length" := FORMAT(EACHItemUnitofMeasure_lRec.Length, 0, '<Precision,0:2><Standard Format,2>');
                    end;
                }
                textelement("EACH_Height")
                {
                    Trigger OnBeforePassVariable()
                    begin
                        "EACH_Height" := FORMAT(EACHItemUnitofMeasure_lRec.Height, 0, '<Precision,0:2><Standard Format,2>');
                    end;
                }
                textelement("EACH_Width")
                {
                    Trigger OnBeforePassVariable()
                    begin
                        "EACH_Width" := FORMAT(EACHItemUnitofMeasure_lRec.Weight, 0, '<Precision,0:2><Standard Format,2>');
                    end;
                }



                trigger OnAfterGetRecord()
                begin
                    MPACKItemUnitofMeasure_lRec.Reset();
                    MPACKItemUnitofMeasure_lRec.SetRange("Item No.", Item."No.");
                    MPACKItemUnitofMeasure_lRec.SetRange(Code, 'M-PACK');
                    if (MPACKItemUnitofMeasure_lRec.FindFirst()) then;
                    EACHItemUnitofMeasure_lRec.Reset();
                    EACHItemUnitofMeasure_lRec.SetRange("Item No.", Item."No.");
                    EACHItemUnitofMeasure_lRec.SetRange(Code, 'EACH');
                    if (EACHItemUnitofMeasure_lRec.FindFirst()) then;

                    If SalesNRecieve.Get() then;
                    If PurchNPayablSetup.Get() then;
                end;

                trigger OnPreXmlItem()
                begin
                    if (StrLen(selectedItems) > 0) then begin
                        //Item.SetRange("No.", GetNo);
                        item.SetFilter("No.", selectedItems);

                    end
                    else if bRunCustomFilter = true then begin
                        item.SetFilter(Brand, '<>%1', 'VALUE PROGRAM');
                        item.SetRange("Location Filter", 'WHITEHORSE');
                        item.SetFilter(Inventory, '>0');
                        Item.SetRange(Type, Item.Type::Inventory);

                    end;
                    If Item.FindSet() then begin


                        ftpSrvr.Reset();
                        ftpSrvr.SetRange(Mode, ftpSrvr.Mode::EXPORT);
                        ftpSrvr.SetRange("Server Name", serverName);
                        if ftpSrvr.FindFirst() then;


                    end;
                    GetDt := today;


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
        MPACKItemUnitofMeasure_lRec: Record "Item Unit of Measure";
        EACHItemUnitofMeasure_lRec: Record "Item Unit of Measure";
        txtWorkDescription: Text;
        ItemCrossRefNo_Cd: Code[50];
        UPCCode_Cd: Code[14];
        GTIN_Cd: Code[14];
        ItemCrossRef: Record "Item Reference";
        // Item: Record Item;
        Cust: Record Customer;
        GetPackageLabelStyle: Text;
        selectedItems: Text;
        GetSalesHdr: Record "Sales Header";
        SalesCommentLn: Record "Sales Comment Line";
        GetType: Text[10];
        GetDept: Text[10];
        ftpSrvr: Record FTPServer;
        Loc: Record Location;
        serverName: code[30];
        PurchNPayablSetup: Record "Purchases & Payables Setup";
        SalesNRecieve: Record "Sales & Receivables Setup";
        bRunCustomFilter: Boolean;

    procedure SetGetNo(InValue: Code[20])
    begin
        GetNo := InValue;
    end;

    procedure SetServerName(InValue: Text)
    begin
        serverName := InValue;
    end;

    procedure SetSelectedItems(InValue: Text)
    begin
        selectedItems := InValue;
    end;

    procedure SetCustomFilter(InValue: Boolean)
    begin
        bRunCustomFilter := InValue;
    end;

    /*procedure GetWorkDescription(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        TransferHdr.CalcFields("Work Description");
        TransferHdr."Work Description".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;*/
}
