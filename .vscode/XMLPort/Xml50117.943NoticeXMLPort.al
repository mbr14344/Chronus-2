xmlport 50117 Notice943XMLPort
{
    Caption = '943 Receiver Notice XML Export';
    Direction = Export;
    Format = Xml;
    UseRequestPage = false;
    DefaultFieldsValidation = true;


    schema
    {
        textelement(PickingList)
        {
            XmlName = 'ReceiverNotice';
            tableelement(TransferHeader; "Transfer Header")
            {
                RequestFilterFields = "No.";
                XmlName = 'TransferOrder';

                fieldelement(TransferOrderNo; TransferHeader."No.")
                {

                }
                textelement(FacilityCode)
                {
                    trigger OnBeforePassVariable()
                    begin
                        //  FacilityCode := ftpSrvr.FacilityCode;  //should come from ftp server Card  (CODE[10])
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
                textelement(ContainerNumber)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if strlen(TransferHeader."Container No.") = 0 then
                            ContainerNumber := TransferHeader."No."
                        else
                            ContainerNumber := TransferHeader."Container No.";
                    end;
                }

                textelement(TransferLines)
                {
                    XmlName = 'TransferLines';

                    tableelement(TransferLine; "Transfer Line")
                    {
                        XmlName = 'TransferLineInfo';
                        LinkTable = TransferHeader;
                        LinkFields = "Document No." = Field("No."), "Derived From Line No." = const(0);
                        SourceTableView = sorting("Line No.");
                        fieldelement(TransferLineNo; TransferLine."Line No.")
                        {

                        }

                        textelement(CustomerPO)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                if strlen(TransferLine."PO No.") = 0 then begin
                                    customerPO := CopyStr(TransferHeader.Notes, 1, 20);
                                end
                                else
                                    CustomerPO := TransferLine."PO No.";
                            end;
                        }

                        fieldelement(ItemIdentifer; TransferLine."Item No.")
                        {

                        }
                        fieldelement(UOM; TransferLine."Unit of Measure Code")
                        {

                        }
                        textelement(QtyExpected)
                        {
                            trigger OnBeforePassVariable()
                            begin
                                QtyExpected := FORMAT(TransferLine.Quantity, 0, '<Precision,0:2><Standard Format,2>');
                            end;

                        }

                        textelement(ItemType)
                        {
                            Trigger OnBeforePassVariable()
                            begin
                                if Item.Get(TransferLine."Item No.") then begin
                                    ItemType := Item."Purchasing Code";

                                    if StrLen(Item."Purchasing Code") <= 0 then
                                        ItemType := PurchNPayablSetup."Purchasing Code Default"
                                    else if (Item."Purchasing Code" <> PurchNPayablSetup."Purchasing Code Check") then
                                        ItemType := PurchNPayablSetup."Purchasing Code Default";
                                end;

                            end;

                        }


                        textelement(TransLinePackageCount)
                        {
                            XmlName = 'PackageCount';
                            trigger OnBeforePassVariable()
                            begin
                                TransLinePackageCount := FORMAT(TransferLine.GetPackageCount(), 0, '<Precision,0:2><Standard Format,2>');
                            end;
                        }
                        trigger OnPreXmlItem()
                        begin
                            TransferLine.SetRange("Derived From Line No.", 0);
                        end;


                    }



                }

                trigger OnAfterGetRecord()
                begin
                    If PurchNPayablSetup.Get() then;
                end;

                trigger OnPreXmlItem()
                begin
                    TransferHeader.SetRange("No.", GetNo);
                    If TransferHeader.FindFirst() then begin
                        loc.Reset();
                        //8/19/25 - start
                        if (TransferHeader."Physical Transfer To Code" <> '') then begin

                            loc.SetRange(Code, TransferHeader."Physical Transfer To Code");
                        end
                        else begin
                            loc.SetRange(Code, TransferHeader."Transfer-to Code");
                        end;
                        //8/19/25 -end
                        //loc.SetRange(Code, TransferHeader."Transfer-to Code");
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
        PurchNPayablSetup: Record "Purchases & Payables Setup";

    procedure SetGetNo(InValue: Code[20])
    begin
        GetNo := InValue;
    end;

    /*procedure GetWorkDescription(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        SalesHeader.CalcFields("Work Description");
        SalesHeader."Work Description".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;*/
}
