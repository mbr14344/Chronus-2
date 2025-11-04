xmlport 50118 TOPickInstructionXMLPort
{
    Caption = 'Transfer Order Pick Instruction XML Export';
    Direction = Export;
    Format = Xml;
    UseRequestPage = false;
    DefaultFieldsValidation = true;


    schema
    {
        textelement(PickingList)
        {
            XmlName = 'TOPickingList';
            tableelement("TransferHdr"; "Transfer Header")
            {
                RequestFilterFields = "No.";
                XmlName = 'TransferOrder';
                textelement(PickDate)
                {
                    trigger OnBeforePassVariable()
                    begin
                        PickDate := Format(GetDt);
                    end;
                }

                textelement(General)
                {

                    fieldelement(OrderNo; TransferHdr."No.")
                    {

                    }
                    fieldelement(OrderDate; TransferHdr."Posting Date")
                    {

                    }
                    textelement(FacilityCode)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            // FacilityCode := ftpSrvr.FacilityCode;  //should come from ftp server Card  (CODE[10])
                            //pr 4/28/25 - get value from Location.Facility Code instead of FTP Server Setup - start
                            FacilityCode := loc."Facility Code";
                            //pr 4/28/25 - get value from Location.Facility Code instead of FTP Server Setup - start
                        end;
                    }
                    textelement(CustomerID)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            CustomerID := ftpSrvr.CustomerID;  //should come from FTP Server Setup.Customer ID  (CODE[10])
                        end;
                    }

                }
                textelement(TransferToInfo)
                {
                    XmlName = 'TransferToInfo';
                    fieldelement(TransferToName; TransferHdr."Transfer-to Name")
                    {

                    }

                    fieldelement(TransferToAddress1; TransferHdr."Transfer-to Address")
                    { }
                    fieldelement(TransfertToAddress2; TransferHdr."Transfer-to Address 2")
                    { }
                    fieldelement(TransferToCity; TransferHdr."Transfer-to City")
                    { }
                    fieldelement(TransferToState; TransferHdr."Transfer-to County")
                    { }
                    fieldelement(TransferToZip; TransferHdr."Transfer-to Post Code")
                    { }
                    fieldelement(TransferToCountry; TransferHdr."Trsf.-to Country/Region Code")
                    {

                    }

                }
                textelement(TransferFrom)
                {
                    XmlName = 'TransferFromInfo';
                    fieldelement(TransferFromName; TransferHdr."Transfer-from Name")
                    { }
                    fieldelement(TransferFromAddress1; TransferHdr."Transfer-from Address")
                    { }
                    fieldelement(TransferFromAddress2; TransferHdr."Transfer-from Address 2")
                    { }
                    fieldelement(TransferFromCity; TransferHdr."Transfer-from City")
                    { }
                    fieldelement(TransferFromState; TransferHdr."Transfer-from County")
                    { }
                    fieldelement(TransferFromZip; TransferHdr."Transfer-from Post Code")
                    { }
                    fieldelement(TransferFromCountry; TransferHdr."Trsf.-from Country/Region Code")
                    {

                    }



                }
                textelement(TransfermentLines)
                {
                    XmlName = 'TransferLines';

                    tableelement(TransferLine; "Transfer Line")
                    {
                        XmlName = 'ItemLineInfo';
                        LinkTable = TransferHdr;
                        LinkFields = "Document No." = Field("No.");
                        SourceTableView = sorting("Document No.", "Line No.");


                        fieldelement(LineNo; TransferLine."Line No.")
                        {

                        }
                        fieldelement(ItemNo; TransferLine."Item No.")
                        { }
                        fieldelement(ItemDescription; TransferLine.Description)
                        {

                        }



                        textelement(Quantity)
                        {
                            Trigger OnBeforePassVariable()
                            begin
                                Quantity := FORMAT(TransferLine.Quantity, 0, '<Precision,0:2><Standard Format,2>');
                            end;
                        }
                        fieldelement(UOM; TransferLine."Unit of Measure Code")
                        {

                        }
                        textelement(CaseQty)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                Cases_gDec := 0;
                                ItemUnitofMeasure_lRec.RESET;
                                ItemUnitofMeasure_lRec.SetRange("Item No.", TransferLine."Item No.");
                                ItemUnitofMeasure_lRec.SetRange(Code, 'M-PACK');
                                if ItemUnitofMeasure_lRec.FindFirst() then
                                    Cases_gDec := ItemUnitofMeasure_lRec."Qty. per Unit of Measure";


                                PackageCount := 0;
                                IF Cases_gDec > 0 then
                                    PackageCount := TransferLine."Quantity (Base)" / Cases_gDec;
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
                            TransferLine.SetRange("Derived From Line No.", 0);
                        end;
                    }
                    fieldelement(TransferOrderNotes; TransferHdr.Notes)
                    {

                    }



                }



                trigger OnPreXmlItem()
                begin
                    TransferHdr.SetRange("No.", GetNo);
                    If TransferHdr.FindFirst() then begin
                        loc.Reset();
                        loc.SetRange(Code, TransferHdr."Transfer-from Code");
                        if loc.FindFirst() then begin
                            ftpSrvr.Reset();
                            ftpSrvr.SetRange(Mode, ftpSrvr.Mode::EXPORT);
                            ftpSrvr.SetRange("Server Name", loc."FTP Server Name");
                            if ftpSrvr.FindFirst() then;
                        end;

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
        ftpSrvr: Record FTPServer;
        Loc: Record Location;

    procedure SetGetNo(InValue: Code[20])
    begin
        GetNo := InValue;
    end;


}
