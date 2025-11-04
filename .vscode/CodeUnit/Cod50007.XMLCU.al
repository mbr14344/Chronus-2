codeunit 50007 XMLCU
{
    procedure ReadXMLIntoPackingInfo(InStr: InStream; InEntryNo: Integer)  //InTxt: text)
    var
        tmpXMLBuffer: Record "XML Buffer" temporary;
        OrderNo: Code[20];
        PackageTrackingNo: Code[30];
        PackageLabelStyle: Code[20];
        SalesHder: Record "Sales Header";
        CartonInfo: Record CartonInformation;
        SalesLine: Record "Sales Line";
        FTPStoreFile: Record FTPStoreFile;
        bOrderFound: Boolean;
        j: Integer;
        checkQty: Decimal;
        ErrTxt: Text;
        CartonInfoImport: record CartonInformationImport;
        Customer: Record Customer;
    begin
        bOrderFound := false;
        j := 0;
        chr13 := 13;
        chr10 := 10;
        FTPStoreFile.Reset();
        FTPStoreFile.SetRange("Entry No.", InEntryNo);
        if FTPStoreFile.FindFirst() then begin
            tmpXMLBuffer.LoadFromStream(InStr);
            tmpXMLBuffer.SetRange(tmpXMLBuffer.Type, tmpXMLBuffer.Type::Element);
            if tmpXMLBuffer.FindSet() then
                repeat
                    case tmpXMLBuffer.Name of
                        'OrderNo':
                            begin
                                OrderNo := tmpXMLBuffer.Value;
                                SalesHder.Reset;
                                SalesHder.SetRange("No.", OrderNo);
                                SalesHder.SetRange("Document Type", SalesHder."Document Type"::Order);
                                If NOT SalesHder.FindFirst() then begin
                                    FTPStoreFile.Status := FTPStoreFile.Status::Error;
                                    FTPStoreFile.Comments := StrSubstNo(lblErrSONonexistent, OrderNo);
                                    FTPStoreFile."Document Type" := FTPStoreFile."Document Type"::Order;
                                    FTPStoreFile.Modify();
                                end

                                else begin
                                    If Customer.get(SalesHder."Sell-to Customer No.") then;
                                    if Customer."Enable 945-Package Import" = false then begin
                                        FTPStoreFile.Status := FTPStoreFile.Status::Error;
                                        FTPStoreFile.Comments := StrSubstNo(lblErrCustNotEnabled, Customer."No.");
                                        FTPStoreFile."Document Type" := FTPStoreFile."Document Type"::Order;
                                        FTPStoreFile.Modify();
                                    end
                                    else begin
                                        //now check if we have any carton information for this order
                                        CartonInfo.Reset();
                                        CartonInfo.SetRange("Document No.", OrderNo);
                                        CartonInfo.SetRange("Document Type", CartonInfo."Document Type"::Order);
                                        If CartonInfo.FindSet() then
                                            CartonInfo.DeleteAll();
                                        bOrderFound := true;
                                    end;


                                end;

                            end;


                    end;
                until (tmpXMLBuffer.Next() = 0) or (bOrderFound = true);
            if bOrderFound = true then begin

                FTPStoreFile."Document No." := SalesHder."No.";
                FTPStoreFile."Document Type" := FTPStoreFile."Document Type"::Order;
                FTPStoreFile.CustomerNo := SalesHder."Sell-to Customer No.";
                FTPStoreFile.ExternalDocumentNo := SalesHder."External Document No.";
                //pr 6/2/25 - start
                FTPStoreFile."Location Code" := SalesHder."Location Code";
                //pr 6/2/25 - end
                FTPStoreFile.Modify();

                tmpXMLBuffer.Reset();
                if tmpXMLBuffer.FindSet() then
                    repeat

                        if (tmpXMLBuffer.Type = tmpXMLBuffer.Type::Element) AND (tmpXMLBuffer.Name = 'PackingLineInfo') then begin
                            CartonInfo.Init();
                            CartonInfo."Document No." := OrderNo;
                            CartonInfo."Document Type" := CartonInfo."Document Type"::Order;
                            //pr 4/23/25 - start
                            CartonInfo.Validate(ShippingLabelStyle, PackageLabelStyle);
                            //pr 4/23/25 - end
                            CartonInfoImport.Init();
                            CartonInfoImport."Document No." := OrderNo;
                            CartonInfoImport."Document Type" := CartonInfoImport."Document Type"::Order;
                            CartonInfoImport."From Entry No." := InEntryNo;
                            //pr 4/23/25 - start
                            CartonInfoImport.Validate(ShippingLabelStyle, PackageLabelStyle);
                            //pr 4/23/25 - end


                        end;

                        case tmpXMLBuffer.Name of
                            //mbr 4/25/25 - let's retrieve teh PackageLabelStyle - start
                            'PackageLabelStyle':
                                begin
                                    PackageLabelStyle := tmpXMLBuffer.Value;
                                end;
                            //mbr 4/25/5

                            //PR 2/7/25 - to receive back the Carrier Tracking Number - start
                            'PackageTrackingNo':
                                begin
                                    if (StrLen(OrderNo) > 0) then begin
                                        PackageTrackingNo := tmpXMLBuffer.Value;
                                        SalesHder.Reset;
                                        SalesHder.SetRange("No.", OrderNo);
                                        SalesHder.SetRange("Document Type", SalesHder."Document Type"::Order);
                                        If SalesHder.FindFirst() then begin
                                            SalesHder."Package Tracking No." := PackageTrackingNo;
                                            SalesHder.Modify();
                                        end;

                                    end;

                                end;
                            //PR 2/7/25 - to receive back the Carrier Tracking Number - end
                            'ItemNo':
                                CartonInfo."Item No." := tmpXMLBuffer.Value;
                            'SSCC':
                                CartonInfo."Serial No." := tmpXMLBuffer.Value;
                            'LineNo':
                                Evaluate(CartonInfo."DocumentLine No.", tmpXMLBuffer.Value);
                            'UOM':
                                CartonInfo."Unit of Measure Code" := tmpXMLBuffer.value;
                            'CaseQty':
                                begin
                                    SalesLine.Reset();
                                    SalesLine.SetRange("Document No.", OrderNo);
                                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                                    SalesLine.SetRange("No.", CartonInfo."Item No.");
                                    SalesLine.SetRange("Line No.", CartonInfo."DocumentLine No.");
                                    IF SalesLine.FindFirst() then begin
                                        SalesLine.CalcFields("M-Pack Qty", "M-Pack Weight");
                                        CartonInfo."Package Quantity" := SalesLine."M-Pack Qty";
                                        CartonInfo."Item Reserved Quantity" := SalesLine."Quantity (Base)";
                                        // CartonInfo.Weight := SalesLine."M-Pack Weight";  -- we are receiving this from Sender

                                    end;
                                    Evaluate(CartonInfo.ImportedPackagedQuantity, tmpXMLBuffer.Value);
                                    CartonInfo.Imported := true;
                                    CartonInfo."Reserved Quantity" := 1;
                                    j += 1;
                                    CartonInfo.LineCount := j;
                                    If not CartonInfo.Insert() then
                                        CartonInfo.Modify();
                                    CartonInfoImport."Item No." := CartonInfo."Item No.";
                                    CartonInfoImport."Serial No." := CartonInfo."Serial No.";
                                    CartonInfoImport."DocumentLine No." := CartonInfo."DocumentLine No.";
                                    CartonInfoImport."Unit of Measure Code" := CartonInfo."Unit of Measure Code";
                                    CartonInfoImport.ImportedPackagedQuantity := CartonInfo.ImportedPackagedQuantity;
                                    CartonInfoImport.Validate(ShippingLabelStyle, CartonInfo.ShippingLabelStyle);
                                    If not CartonInfoImport.Insert() then
                                        CartonInfoImport.Modify();
                                end;
                            'CaseWeight':
                                begin
                                    Evaluate(CartonInfo.Weight, tmpXMLBuffer.Value);
                                    CartonInfo.LineCount := j;
                                    If not CartonInfo.Insert() then
                                        CartonInfo.Modify();

                                    CartonInfoImport.Weight := CartonInfo.Weight;
                                    If not CartonInfoImport.Insert() then
                                        CartonInfoImport.Modify();
                                end;




                        end;
                    until tmpXMLBuffer.Next() = 0;
                //now, let's run our busines rules
                //Make sure each item in the Sales Line Table has corresponding Reserved Quantity base from Carton Information (summed up in Carton Information per item)
                ErrTxt := '';
                SalesLine.Reset();
                SalesLine.SetRange("Document No.", OrderNo);
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                if SalesLine.FindSet() then
                    repeat
                        CartonInfo.Reset();
                        CartonInfo.SetRange("Document No.", OrderNo);
                        CartonInfo.SetRange("Document Type", CartonInfo."Document Type"::Order);
                        CartonInfo.SetRange("DocumentLine No.", SalesLine."Line No.");
                        CartonInfo.SetRange("Item No.", SalesLine."No.");
                        checkQty := 0;
                        IF CartonInfo.FindSet() then begin
                            repeat
                                checkQty += CartonInfo.ImportedPackagedQuantity;
                            until CartonInfo.Next() = 0;
                            IF checkQty <> SalesLine."Quantity (Base)" then
                                ErrTxt += StrSubstNo(lblItemReservedQtyDiff, CartonInfo."Item No.", Format(SalesLine."Quantity (Base)"), Format(checkQty)) + FORMAT(chr13) + FORMAT(chr10);


                        end
                        else
                            ErrTxt += StrSubstNo(lblItemNoImpQty, SalesLine."No.", Format(SalesLine."Quantity (Base)")) + FORMAT(chr13) + FORMAT(chr10);


                    until SalesLine.Next() = 0;


                if strlen(ErrTxt) > 0 then begin
                    if strlen(ErrTxt) > 2048 then
                        FTPStoreFile.Comments := CopyStr(ErrTxt, 1, 2048)
                    else
                        FTPStoreFile.Comments := ErrTxt;
                end

                else
                    FTPStoreFile.Comments := 'Import Data Completed.';

                FTPStoreFile.Modify();

            end
            else begin
                FTPStoreFile.Status := FTPStoreFile.Status::Error;
                FTPStoreFile.Comments := StrSubstNo(lblOrderNotFound);
                FTPStoreFile."Document Type" := FTPStoreFile."Document Type"::Order;
                FTPStoreFile.Modify();
            end;
        end;


    end;

    procedure ReadXMLInto944(InStr: InStream; InEntryNo: Integer)  //InTxt: text)
    var
        tmpXMLBuffer: Record "XML Buffer" temporary;
        OrderNo: Code[20];
        ContainerOrderNo: Code[20];
        RecievedDate: Date;
        ReceiptNo: Code[20];
        LoadNo: code[30];
        PackageTrackingNo: Code[30];
        TransferHdr: Record "Transfer Header";
        TransLine: Record "Transfer Line";
        TransRecptHdr: Record "Transfer Receipt Header";
        TransRecptLine: Record "Transfer Receipt Line";
        FTPStoreFile: Record FTPStoreFile;
        bOrderFound: Boolean;
        transLineItemNo: code[30];
        bTransLineFound: Boolean;
        bTransItemNoFound: Boolean;
        j: Integer;
        checkQty: Decimal;
        ErrTxt: Text;
        linesFound: integer;
        bFromReceipt: Boolean;
    begin
        bOrderFound := false;
        j := 0;
        chr13 := 13;
        chr10 := 10;
        FTPStoreFile.Reset();
        FTPStoreFile.SetRange("Entry No.", InEntryNo);
        if FTPStoreFile.FindFirst() then begin
            tmpXMLBuffer.LoadFromStream(InStr);
            tmpXMLBuffer.SetRange(tmpXMLBuffer.Type, tmpXMLBuffer.Type::Element);
            if tmpXMLBuffer.FindSet() then
                repeat
                    case tmpXMLBuffer.Name of
                        'TransferOrderNo':
                            begin
                                OrderNo := tmpXMLBuffer.Value;
                            end;
                    end;
                    case tmpXMLBuffer.Name of
                        'ContainerNo':
                            begin
                                ContainerOrderNo := tmpXMLBuffer.Value;
                            end;
                    end;
                    case tmpXMLBuffer.Name of
                        'ReceivedDate':
                            begin
                                Evaluate(RecievedDate, tmpXMLBuffer.Value);
                            end;
                    end;
                    case tmpXMLBuffer.Name of
                        'ReceiptNo':
                            begin
                                ReceiptNo := tmpXMLBuffer.Value;
                            end;
                    end;
                    case tmpXMLBuffer.Name of
                        'LoadNo':
                            begin
                                LoadNo := tmpXMLBuffer.Value;
                            end;
                    end;
                until (tmpXMLBuffer.Next() = 0) or (bOrderFound = true);
            bFromReceipt := false;
            TransferHdr.Reset();
            TransferHdr.SetRange("No.", OrderNo);
            TransRecptHdr.Reset();
            TransRecptHdr.SetRange("Transfer Order No.", OrderNo);
            IF STRLEN(ContainerOrderNo) > 0 then BEGIN
                if ContainerOrderNo <> OrderNo then
                    TransferHdr.SetRange("Container No.", ContainerOrderNo);
            END;

            if (TransferHdr.FindSet()) then begin
                TransferHdr."944 Load No." := LoadNo;
                TransferHdr."944 Received Date" := Today;  //10/3/25 - DO NOT rely on ReceivedDate from sender - use today's date instead;
                TransferHdr."944 Receipt No." := ReceiptNo;
                TransferHdr.Modify();
                bOrderFound := true;
            end
            //8/25/25 - if no Transfer Order is found, then look at the transfer receipts given transfer order no - start
            else if (TransRecptHdr.FindSet()) then begin
                TransRecptHdr."944 Load No." := LoadNo;
                TransRecptHdr."944 Received Date" := RecievedDate;
                TransRecptHdr."944 Receipt No." := ReceiptNo;
                TransRecptHdr.Modify();
                bOrderFound := true;
                bFromReceipt := true;
            end
            //8/25/25 - if no Transfer Order is found, then look at the transfer receipts given transfer order no - end
            else begin
                FTPStoreFile.Status := FTPStoreFile.Status::Error;
                FTPStoreFile.Comments := 'Transfer Order No. ' + OrderNo + ' not found.';
                FTPStoreFile.Modify();
            end;
            if bOrderFound = true then begin
                ErrTxt := '';
                FTPStoreFile."Document No." := TransferHdr."No.";
                //pr 6/2/25 - start
                FTPStoreFile."Location Code" := TransferHdr."Transfer-to Code";
                //pr 6/2/25 - end
                FTPStoreFile."Document Type" := FTPStoreFile."Document Type"::"Transfer Order";
                //  FTPStoreFile.CustomerNo := TransferHdr."Sell-to Customer No.";<>VA038 & <>T00012 & <>T00013& <>VA037
                FTPStoreFile.ExternalDocumentNo := TransferHdr."External Document No.";
                tmpXMLBuffer.Reset();
                if tmpXMLBuffer.FindSet() then
                    repeat
                        if (tmpXMLBuffer.Type = tmpXMLBuffer.Type::Element) AND (tmpXMLBuffer.Name = 'TransferLineInfo') then begin
                            transLineItemNo := '';
                            linesFound := 0;
                        end;

                        case tmpXMLBuffer.Name of
                            'TransferLineNo':
                                begin
                                    Evaluate(linesFound, tmpXMLBuffer.Value);
                                    if (bFromReceipt = true) then begin
                                        TransRecptLine.Reset();
                                        TransRecptLine.SetRange("Item No.", tmpXMLBuffer.Value);
                                        TransRecptLine.SetRange("Transfer Order No.", OrderNo);
                                        TransRecptLine.SetRange("Line No.", linesFound);
                                        if (TransRecptLine.FindSet()) then begin
                                            linesFound := TransRecptLine."Line No."
                                        end;
                                    end
                                    else begin
                                        TransLine.reset;
                                        TransLine.SetRange("Item No.", tmpXMLBuffer.Value);
                                        TransLine.SetRange("Document No.", OrderNo);
                                        TransLine.SetRange("Line No.", linesFound);
                                        if (TransLine.FindSet()) then begin
                                            linesFound := TransLine."Line No."
                                        end;
                                    end;
                                end;
                            'ItemNo':
                                begin
                                    transLineItemNo := tmpXMLBuffer.Value;
                                    if (bFromReceipt = true) then begin
                                        TransRecptLine.Reset();
                                        TransRecptLine.SetRange("Item No.", tmpXMLBuffer.Value);
                                        TransRecptLine.SetRange("Transfer Order No.", OrderNo);
                                        TransRecptLine.SetRange("Line No.", linesFound);
                                        if (TransRecptLine.FindSet()) then begin
                                            bTransLineFound := true
                                        end
                                        else begin
                                            bTransLineFound := false;
                                            ErrTxt += 'Tranfer Line with item No. ' + tmpXMLBuffer.Value + ' was not found. ';
                                        end;
                                    end
                                    else begin
                                        TransLine.reset;
                                        TransLine.SetRange("Item No.", tmpXMLBuffer.Value);
                                        TransLine.SetRange("Document No.", OrderNo);
                                        TransLine.SetRange("Line No.", linesFound);
                                        if (TransLine.FindSet()) then begin
                                            bTransLineFound := true
                                        end
                                        else begin
                                            bTransLineFound := false;
                                            ErrTxt += 'Tranfer Line with item No. ' + tmpXMLBuffer.Value + ' was not found. ';
                                        end;
                                    end;
                                end;


                            'ExpectedQuantity':
                                begin
                                    if (bTransLineFound) then begin
                                        if (bFromReceipt = true) then begin
                                            TransRecptLine.Reset();
                                            TransRecptLine.SetRange("Item No.", transLineItemNo);
                                            TransRecptLine.SetRange("Transfer Order No.", OrderNo);
                                            TransRecptLine.SetRange("Line No.", linesFound);
                                            if (TransRecptLine.FindSet()) then begin
                                                Evaluate(TransRecptLine."Expected Quantity", tmpXMLBuffer.Value);
                                                TransRecptLine.Modify();

                                            end;
                                        end
                                        else begin
                                            TransLine.reset;
                                            TransLine.SetRange("Item No.", transLineItemNo);
                                            TransLine.SetRange("Document No.", OrderNo);
                                            TransLine.SetRange("Line No.", linesFound);
                                            if (TransLine.FindSet()) then begin
                                                Evaluate(TransLine."Expected Quantity", tmpXMLBuffer.Value);
                                                TransLine.Modify();

                                            end;
                                        end;
                                    end;
                                end;


                            'UOM':
                                begin
                                    if (bTransLineFound) then begin
                                        if (bFromReceipt = true) then begin
                                            TransRecptLine.Reset();
                                            TransRecptLine.SetRange("Item No.", transLineItemNo);
                                            TransRecptLine.SetRange("Transfer Order No.", OrderNo);
                                            TransRecptLine.SetRange("Line No.", linesFound);
                                            if (TransRecptLine.FindSet()) then begin
                                                TransRecptLine."Expected UOM" := tmpXMLBuffer.value;
                                                TransRecptLine.Modify();

                                            end;
                                        end
                                        else begin
                                            TransLine.reset;
                                            TransLine.SetRange("Item No.", transLineItemNo);
                                            TransLine.SetRange("Document No.", OrderNo);
                                            TransLine.SetRange("Line No.", linesFound);
                                            if (TransLine.FindSet()) then begin
                                                TransLine."Expected UOM" := tmpXMLBuffer.value;
                                                TransLine.Modify();

                                            end;
                                        end;
                                    end;
                                end;
                            'ReceivedGood':
                                begin
                                    if (bTransLineFound) then begin
                                        if (bFromReceipt = true) then begin
                                            TransRecptLine.Reset();
                                            TransRecptLine.SetRange("Item No.", transLineItemNo);
                                            TransRecptLine.SetRange("Transfer Order No.", OrderNo);
                                            TransRecptLine.SetRange("Line No.", linesFound);
                                            if (TransRecptLine.FindSet()) then begin
                                                Evaluate(TransRecptLine."Received Good", tmpXMLBuffer.Value);
                                                TransRecptLine.Modify();
                                            end;
                                        end
                                        else begin
                                            TransLine.reset;
                                            TransLine.SetRange("Item No.", transLineItemNo);
                                            TransLine.SetRange("Document No.", OrderNo);
                                            TransLine.SetRange("Line No.", linesFound);
                                            if (TransLine.FindSet()) then begin
                                                Evaluate(TransLine."Received Good", tmpXMLBuffer.Value);
                                                TransLine.Modify();

                                            end;
                                        end;
                                    end;
                                end;
                            'ReceivedCase':
                                begin
                                    if (bTransLineFound) then begin
                                        if (bFromReceipt = true) then begin
                                            TransRecptLine.Reset();
                                            TransRecptLine.SetRange("Item No.", transLineItemNo);
                                            TransRecptLine.SetRange("Transfer Order No.", OrderNo);
                                            TransRecptLine.SetRange("Line No.", linesFound);
                                            if (TransRecptLine.FindSet()) then begin
                                                Evaluate(TransRecptLine."Received Case", tmpXMLBuffer.Value);
                                                TransRecptLine.Modify();
                                            end;
                                        end
                                        else begin
                                            TransLine.reset;
                                            TransLine.SetRange("Item No.", transLineItemNo);
                                            TransLine.SetRange("Document No.", OrderNo);
                                            TransLine.SetRange("Line No.", linesFound);
                                            if (TransLine.FindSet()) then begin
                                                Evaluate(TransLine."Received Case", tmpXMLBuffer.Value);
                                                TransLine.Modify();

                                            end;
                                        end;
                                    end;
                                end;
                            'ReceivedPallet':
                                begin
                                    if (bTransLineFound) then begin
                                        if (bFromReceipt = true) then begin
                                            TransRecptLine.Reset();
                                            TransRecptLine.SetRange("Item No.", transLineItemNo);
                                            TransRecptLine.SetRange("Transfer Order No.", OrderNo);
                                            TransRecptLine.SetRange("Line No.", linesFound);
                                            if (TransRecptLine.FindSet()) then begin
                                                Evaluate(TransRecptLine."Received Pallet", tmpXMLBuffer.Value);
                                                TransRecptLine.Modify();
                                            end;
                                        end
                                        else begin
                                            TransLine.reset;
                                            TransLine.SetRange("Item No.", transLineItemNo);
                                            TransLine.SetRange("Document No.", OrderNo);
                                            TransLine.SetRange("Line No.", linesFound);
                                            if (TransLine.FindSet()) then begin
                                                Evaluate(TransLine."Received Pallet", tmpXMLBuffer.Value);
                                                TransLine.Modify();

                                            end;
                                        end;
                                    end;
                                end;
                            'ReceivedDamage':
                                begin
                                    if (bTransLineFound) then begin
                                        if (bFromReceipt = true) then begin
                                            TransRecptLine.Reset();
                                            TransRecptLine.SetRange("Item No.", transLineItemNo);
                                            TransRecptLine.SetRange("Transfer Order No.", OrderNo);
                                            TransRecptLine.SetRange("Line No.", linesFound);
                                            if (TransRecptLine.FindSet()) then begin
                                                Evaluate(TransRecptLine."Received Damage", tmpXMLBuffer.Value);
                                                TransRecptLine.Modify();
                                            end;
                                        end
                                        else begin
                                            TransLine.reset;
                                            TransLine.SetRange("Item No.", transLineItemNo);
                                            TransLine.SetRange("Document No.", OrderNo);
                                            TransLine.SetRange("Line No.", linesFound);
                                            if (TransLine.FindSet()) then begin
                                                Evaluate(TransLine."Received Damage", tmpXMLBuffer.Value);
                                                TransLine.Modify();

                                            end;
                                        end;
                                    end;
                                end;
                            'ReceivedOver':
                                begin
                                    if (bTransLineFound) then begin
                                        if (bFromReceipt = true) then begin
                                            TransRecptLine.Reset();
                                            TransRecptLine.SetRange("Item No.", transLineItemNo);
                                            TransRecptLine.SetRange("Transfer Order No.", OrderNo);
                                            TransRecptLine.SetRange("Line No.", linesFound);
                                            if (TransRecptLine.FindSet()) then begin
                                                Evaluate(TransRecptLine."Received Over", tmpXMLBuffer.Value);
                                                TransRecptLine.Modify();
                                            end;
                                        end
                                        else begin
                                            TransLine.reset;
                                            TransLine.SetRange("Item No.", transLineItemNo);
                                            TransLine.SetRange("Document No.", OrderNo);
                                            TransLine.SetRange("Line No.", linesFound);
                                            if (TransLine.FindSet()) then begin
                                                Evaluate(TransLine."Received Over", tmpXMLBuffer.Value);
                                                TransLine.Modify();

                                            end;
                                        end;
                                    end;
                                end;
                            'ReceivedShort':
                                begin
                                    if (bTransLineFound) then begin
                                        if (bFromReceipt = true) then begin
                                            TransRecptLine.Reset();
                                            TransRecptLine.SetRange("Item No.", transLineItemNo);
                                            TransRecptLine.SetRange("Transfer Order No.", OrderNo);
                                            TransRecptLine.SetRange("Line No.", linesFound);
                                            if (TransRecptLine.FindSet()) then begin
                                                Evaluate(TransRecptLine."Received Short", tmpXMLBuffer.Value);
                                                TransRecptLine.Modify();
                                            end;
                                        end
                                        else begin
                                            TransLine.reset;
                                            TransLine.SetRange("Item No.", transLineItemNo);
                                            TransLine.SetRange("Document No.", OrderNo);
                                            TransLine.SetRange("Line No.", linesFound);
                                            if (TransLine.FindSet()) then begin
                                                Evaluate(TransLine."Received Short", tmpXMLBuffer.Value);
                                                TransLine.Modify();

                                            end;
                                        end;
                                    end;
                                end;
                            'Weight':
                                begin
                                    if (bTransLineFound) then begin
                                        if (bFromReceipt = true) then begin
                                            TransRecptLine.Reset();
                                            TransRecptLine.SetRange("Item No.", transLineItemNo);
                                            TransRecptLine.SetRange("Transfer Order No.", OrderNo);
                                            TransRecptLine.SetRange("Line No.", linesFound);
                                            if (TransRecptLine.FindSet()) then begin
                                                Evaluate(TransRecptLine."Received Weight", tmpXMLBuffer.Value);
                                                TransRecptLine.Modify();
                                            end;
                                        end
                                        else begin
                                            TransLine.reset;
                                            TransLine.SetRange("Item No.", transLineItemNo);
                                            TransLine.SetRange("Document No.", OrderNo);
                                            TransLine.SetRange("Line No.", linesFound);
                                            if (TransLine.FindSet()) then begin

                                                Evaluate(TransLine."Received Weight", tmpXMLBuffer.Value);
                                                TransLine.Modify();


                                            end;
                                        end;
                                    end;
                                end;

                        end;
                    until tmpXMLBuffer.Next() = 0;
                //now, let's run our busines rules
                //Make sure each item in the Sales Line Table has corresponding Reserved Quantity base from Carton Information (summed up in Carton Information per item)

                if strlen(ErrTxt) > 0 then begin
                    if strlen(ErrTxt) > 2048 then
                        FTPStoreFile.Comments := CopyStr(ErrTxt, 1, 2048)
                    else
                        FTPStoreFile.Comments := ErrTxt;

                end

                else
                    FTPStoreFile.Comments := 'Import Data Completed.';

                FTPStoreFile.Modify();

            end;
        end;


    end;

    local procedure Insertfile(var jOrder: JsonObject; ftpServer: Record FTPServer)
    var
        FTPStoredFile: Record FTPStoreFile;
        OutStream: OutStream;
        Instr: InStream;

    begin
        FTPStoredFile.Init();
        FTPStoredFile."Entry No." := 0;
        FTPStoredFile."File Name" := GetJsonTextProp(jOrder, 'Name');
        FTPStoredFile.CreatedDate := Today;
        FTPStoredFile.CreatedBy := UserId;
        FTPStoredFile.FileType := FTPStoredFile.FileType::XML;
        FTPStoredFile.Direction := FTPStoredFile.Direction::Import;
        FTPStoredFile.RecordedDateTime := CurrentDateTime;
        FTPStoredFile.Status := FTPStoredFile.Status::Imported;
        FTPStoredFile."File Content".CreateOutStream(OutStream, TextEncoding::UTF8);

        OutStream.WriteText(GetJsonTextProp(jOrder, 'Content'));

        FTPStoredFile.Insert(true);

        FTPStoredFile.CalcFields("File Content");
        FTPStoredFile."File Content".CreateInStream(InStr);
        //PR 2/7/25 - receive 944  - start
        if (StrPos(FTPStoredFile."File Name", ftpServer."945 Package Info Prefix") = 1) then
            ReadXMLIntoPackingInfo(Instr, FTPStoredFile."Entry No.")
        else if (StrPos(FTPStoredFile."File Name", ftpServer."944 Receipt Advice Prefix") = 1) then
            ReadXMLInto944(Instr, FTPStoredFile."Entry No.")
        //else
        // ReadXMLIntoPackingInfo(Instr, FTPStoredFile."Entry No.")
        //PR 2/7/25 - receive 944  - end
    end;

    procedure GetJsonTextProp(var O: JsonObject; Prop: Text): Text
    var
        Result: JsonValue;
    begin
        Result := GetJsonValueProp(O, prop);
        if not Result.IsUndefined and not Result.IsNull then
            exit(Result.AsText());
    end;

    procedure GetJsonValueProp(var O: JsonObject; Prop: Text): JsonValue
    var
        Result: JsonToken;
    begin
        if O.Get(Prop, Result) then
            exit(Result.AsValue());
    end;


    procedure ImportFromFTP()
    var
        HttpRequest: HttpRequestMessage;
        ContentHeaders: HttpHeaders;  // Content-level headers (Content-Type, Content-Length)
        RequestContent: HttpContent;
        RequestHTTPClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        ResponseText: Text;
        ResponseJson: JsonToken;
        JsonArr: JsonArray;
        JsonObj: JsonObject;
        TempTok: JsonToken;
        ftpserver: Record FTPServer;

        i: Integer;
        TempText: Text;
        //mbr 8/18/25 - added delay before import task
        Err: Text;
        RequestHeaders: HttpHeaders;  // Request-level headers (Accept, Authorization, custom)
        SendTinyBody: Boolean; // true: send "{}" with Content-Type: application/json; false: keep empty body
                               //mbr 8/18/25 - added delay before import task
    begin
        SendTinyBody := true;  //mbr 8/18/25 - added delay before import task - set to false if you want to mimic your previous "empty body" POST exactly
        Sleep(8000); // Delay to allow PowerBI import

        ftpserver.Reset();
        ftpserver.SetRange(Mode, ftpserver.Mode::IMPORT);
        ftpserver.SetFilter(URL, '<>%1', '');
        if ftpserver.FindSet() then
            repeat

                if StrLen(ftpserver.URL) = 0 then
                    Error(lblNoURL, ftpserver."Server Name", Format(ftpserver.Mode));
                // Start: Loop for 1-file-per-call pattern ---
                repeat

                    // Prepare HTTP request
                    Clear(HttpRequest);
                    Clear(ContentHeaders);
                    Clear(RequestContent);
                    Clear(RequestHTTPClient);
                    Clear(HttpResponse);
                    Clear(ResponseJson);
                    Clear(RequestHeaders);  //mbr 8/18/25 - added delay before import task
                                            //mbr test - start
                                            // if GuiAllowed then
                                            //     Message('Calling location %1 -> %2',
                                            //         ftpserver."Server Name",
                                            //         CopyStr(ftpserver.URL, 1, 120));
                                            //mbr test - end

                    // Build HTTP Request
                    HttpRequest.SetRequestUri(ftpserver.URL);
                    HttpRequest.Method('POST');

                    // Request-level headers (only)
                    HttpRequest.GetHeaders(RequestHeaders);
                    // Add/replace Accept at the request level
                    if RequestHeaders.Contains('Accept') then
                        RequestHeaders.Remove('Accept');
                    RequestHeaders.Add('Accept', '*/*');


                    // Mark MANUAL runs as synchronous (Job Queue has no GUI, so it won't add this)
                    if GuiAllowed then begin
                        if RequestHeaders.Contains('x-sync') then
                            RequestHeaders.Remove('x-sync');
                        RequestHeaders.Add('x-sync', 'true');
                    end;


                    // Content/body + content-level headers
                    // -----------------------------------
                    if SendTinyBody then
                        RequestContent.WriteFrom('{}'); // harmless tiny body most APIs accept


                    // Set Content-Type only on the content
                    RequestContent.GetHeaders(ContentHeaders);
                    if ContentHeaders.Contains('Content-Type') then
                        ContentHeaders.Remove('Content-Type');
                    ContentHeaders.Add('Content-Type', 'application/json');

                    // Bind content to the request
                    HttpRequest.Content(RequestContent);

                    // Timeouts / TLS
                    RequestHTTPClient.Timeout(300000); // 5 minutes


                    // Send HTTP request
                    if not RequestHTTPClient.Send(HttpRequest, HttpResponse) then
                        Error('Pre-response failure calling %1. Details: %2', ftpserver.URL, GetLastErrorText());

                    // Handle Power Automate flow responses
                    //202 = Accepted (request is being processed asynchronously, no result yet)
                    if HttpResponse.HttpStatusCode() = 202 then
                        break;  //async/early, skip this ftp server

                    HttpResponse.Content().ReadAs(ResponseText);

                    //if 204 or empty, all files are downloaded
                    //204 = No Content (no file to download-FTP is empty)
                    if (HttpResponse.HttpStatusCode() = 204) or (StrLen(ResponseText) = 0) then
                        break; //done with this ftp server  
                               // Read body (only after 204 check)
                    HttpResponse.Content().ReadAs(ResponseText);

                    // If body isn't JSON (only whitespace or empty), break
                    //if (StrPos(ResponseText, '{') = 0) and (StrPos(ResponseText, '[') = 0) then
                    //    break;


                    if not HttpResponse.IsSuccessStatusCode() then
                        Error(
                                'HTTP %1 %2 calling %3.\nBody: %4',
                                Format(HttpResponse.HttpStatusCode()),
                                HttpResponse.ReasonPhrase(),
                                CopyStr(ftpserver.URL, 1, 500),
                                CopyStr(ResponseText, 1, 2048)
                                );


                    // If the body is empty, stop cleanly (no Trim available)
                    if ResponseText = '' then
                        break;

                    // Parse successful JSON
                    ResponseJson.ReadFrom(ResponseText);

                    if ResponseJson.IsArray() then begin
                        JsonArr := ResponseJson.AsArray();
                        for i := 0 to JsonArr.Count() - 1 do begin
                            JsonArr.Get(i, TempTok);
                            if TempTok.IsObject() then begin
                                JsonObj := TempTok.AsObject();
                                Insertfile(JsonObj, ftpserver);
                            end else begin
                                TempTok.WriteTo(TempText);
                                Error('Unexpected JSON token in array: %1', TempText);
                            end;
                        end;
                    end else if ResponseJson.IsObject() then begin
                        JsonObj := ResponseJson.AsObject();
                        Insertfile(JsonObj, ftpserver);
                    end else begin
                        ResponseJson.WriteTo(TempText);
                        Error('Unsupported JSON root type: %1', TempText);
                    end;

                // Loop will repeat for next file, until 204/empty response

                until false;

            until ftpserver.Next() = 0;

        if GuiAllowed then
            Message(lblTaskDone);
    end;

    procedure ImportFromFTP_Async()
    var
        //Client: HttpClient;
        Resp: HttpResponseMessage;
        Body: Text;
        Tok: JsonToken;
        Arr: JsonArray;
        Obj: JsonObject;
        AckPathTok: JsonToken;
        AckPath: Text;
        MaxPolls: Integer;
        DelayMs: Integer;
        Poll: Integer;
        ftpserver: Record FTPServer;
        FlowAUrl: Text;
        FlowBUrl: Text;
        AckDeleteUrl: Text;
        MaxRetries: Integer;
        Retry: Integer;
        i: integer;
        Delay: Integer;
        EmptyStreak: Integer;
        MaxEmptyStreak: Integer;
    begin
        ftpserver.Reset();
        ftpserver.SetRange(Mode, ftpserver.Mode::IMPORT);
        ftpserver.SetFilter(URL, '<>%1', '');
        if ftpserver.FindSet() then
            repeat
                if StrLen(ftpserver.FlowAURL) = 0 then
                    Error(lblNoFlowURL, ftpserver."Server Name", Format(ftpserver.Mode), ftpserver.FieldCaption("FlowAURL"));
                if StrLen(ftpserver.FlowBURL) = 0 then
                    Error(lblNoFlowURL, ftpserver."Server Name", Format(ftpserver.Mode), ftpserver.FieldCaption("FlowBURL"));
                if StrLen(ftpserver.AckDeleteURL) = 0 then
                    Error(lblNoFlowURL, ftpserver."Server Name", Format(ftpserver.Mode), ftpserver.FieldCaption("AckDeleteURL"));
                FlowAUrl := ftpserver.FlowAURL;
                FlowBUrl := ftpserver.FlowBURL;
                AckDeleteUrl := ftpserver.AckDeleteURL;




                // How aggressively we want to poll Flow A
                DelayMs := 1000;        // 1s between successful 202 calls
                MaxRetries := 6;        // for transient (429/5xx) cases – ~exponential backoff below
                Retry := 0;

                Clear(Resp);
                Clear(Body);
                // 1) FLOW A — move one file /out -> /out/Hold (expect 202)
                // Call Flow A once; it returns 204 when directory is empty.
                // 202 when it accepted a file to move
                // 204 when the folder is empty

                if not PostJson(FlowAUrl, '{}', 300000, Resp) then
                    Error('Failed calling Flow A. %1', GetLastErrorText());

                // Optional: log the first response (will be 202 for async patterns)
                //if GuiAllowed then
                //    Message('Flow A initial response: %1 %2', Resp.HttpStatusCode(), Resp.ReasonPhrase());


                // 2) Poll FLOW B until file ready (200) or empty (204)
                MaxEmptyStreak := 4;    // e.g., ~1.5s, 3s, 6s, 6s... then stop
                MaxRetries := 6;        // transient 429/5xx cap
                EmptyStreak := 0;
                Retry := 0;

                while EmptyStreak < MaxEmptyStreak do begin
                    Clear(Resp);
                    Clear(Body);

                    if not PostJson(FlowBUrl, '{}', 300000, Resp) then
                        Error('Failed calling Flow B. %1', GetLastErrorText());

                    case Resp.HttpStatusCode() of
                        200:
                            begin
                                // if we are here, we are getting an array whoe first item is another array
                                // Reset both counters
                                EmptyStreak := 0;
                                Retry := 0;

                                Resp.Content().ReadAs(Body);

                                //Parse the top-level token
                                Tok.ReadFrom(Body);

                                if not Tok.IsArray() then
                                    Error('Flow B returned non-array. Body: %1', CopyStr(Body, 1, 2048));

                                // Get first element - Expecting one item in the array
                                Arr := Tok.AsArray();
                                if Arr.Count() <> 1 then
                                    Error('Flow B returned %1 items; expected 1.', Arr.Count());

                                Arr.Get(0, Tok);

                                //if the first element is a string, it maby be a JSON string -> parse it
                                if Tok.IsValue() then begin
                                    Body := Tok.AsValue().AsText();
                                    // Guard: only re-parse when the text starts with '{' or '['
                                    if (StrLen(Body) > 0) and ((Body[1] = '{') or (Body[1] = '[')) then
                                        Tok.ReadFrom(Body);

                                end;

                                //if the first element is an array (i.e., [[{,,,,}]]), unwrap once
                                if Tok.IsArray() then begin
                                    Arr := Tok.AsArray();
                                    if Arr.Count() <> 1 then
                                        Error('Flow B returned nested array with %1 items; expected 1.', Arr.Count());
                                    Arr.Get(0, Tok);
                                end;

                                if not Tok.IsObject() then
                                    Error('Flow B item is not an object. Body: %1', CopyStr(Body, 1, 2048));

                                Obj := Tok.AsObject();

                                // Import your file (Name/Content/ContentType/Length in Obj)
                                Insertfile(Obj, ftpserver); // your existing routine

                                // Acknowledge delete via Flow C
                                if not Obj.Get('AckPath', AckPathTok) then
                                    Error('AckPath missing in Flow B response.');
                                AckPath := AckPathTok.AsValue().AsText();

                                if not PostJson(AckDeleteUrl, StrSubstNo('{ "path": "%1" }', AckPath), 300000, Resp) then
                                    Error('Failed calling AckDelete. %1', GetLastErrorText());

                                if not Resp.IsSuccessStatusCode() then begin
                                    Resp.Content().ReadAs(Body);
                                    Error('AckDelete returned %1 %2. Body: %3',
                                          Resp.HttpStatusCode(), Resp.ReasonPhrase(), CopyStr(Body, 1, 2048));
                                end;
                            end;

                        204:
                            begin
                                // Nothing ready right now; brief backoff and try again
                                EmptyStreak += 1;
                                Delay := 1500;
                                for i := 2 to EmptyStreak do begin
                                    if (Delay * 2) > 10000 then
                                        Delay := 10000
                                    else
                                        Delay := Delay * 2;
                                end;
                                Sleep(Delay);
                            end;

                        429, 500, 502, 503, 504:
                            begin
                                // Transient — exponential backoff with cap
                                Retry += 1;
                                if Retry > MaxRetries then begin
                                    Resp.Content().ReadAs(Body);
                                    Error('Flow B transient error did not recover after %1 attempts. %2 %3. Body: %4',
                                          Retry, Resp.HttpStatusCode(), Resp.ReasonPhrase(), CopyStr(Body, 1, 2048));
                                end;
                                Delay := 1500;
                                for i := 2 to Retry do begin
                                    // double, but cap at 15000 ms
                                    if (Delay * 2) > 15000 then
                                        Delay := 15000
                                    else
                                        Delay := Delay * 2;
                                end;
                                Sleep(Delay);
                            end;

                        else begin
                            Resp.Content().ReadAs(Body);
                            Error('Flow B unexpected %1 %2. Body: %3',
                                  Resp.HttpStatusCode(), Resp.ReasonPhrase(), CopyStr(Body, 1, 2048));
                        end;
                    end;
                end;





            until ftpserver.Next() = 0;


        if GuiAllowed then
            Message(lblTaskDone);




    end;


    local procedure PostJson(Url: Text;
Payload: Text;
TimeoutMs: Integer; var
                    OutResp: HttpResponseMessage): Boolean
    var
        Req: HttpRequestMessage;
        Cnt: HttpContent;
        H: HttpHeaders;
        Client: HttpClient;   //local client per call

    begin
        Clear(OutResp);

        Clear(Req);
        Req.SetRequestUri(Url);
        Req.Method('POST');

        Clear(Cnt);
        if Payload = '' then
            Cnt.WriteFrom('{}')
        else
            Cnt.WriteFrom(Payload);

        Cnt.GetHeaders(H);
        if H.Contains('Content-Type') then H.Remove('Content-Type');
        H.Add('Content-Type', 'application/json');
        Req.Content(Cnt);

        Client.Timeout(TimeoutMs);
        exit(Client.Send(Req, OutResp));
    end;




    procedure ExportXML(SalesHdr: Record "Sales Header"; FtpServer: Record FTPServer)
    var
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        FTPStoreFile: Record FTPStoreFile;
        XmlExportPickInstruction: XmlPort PickInstructionXMLPort;
        InStr: InStream;
        OutStr: OutStream;
        FileName: Text;
        Content: text;
        HttpRequest: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        RequestText: Text;
        RequestJObject: JsonObject;
        RequestContent: HttpContent;
        RequestHTTPClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        OutStrem: OutStream;
        Base64: Codeunit "Base64 Convert";
        Base64String: Text;
        instrem: InStream;
        ResponseText: Text;
        popupConfirm: Page "Confirmation Dialog";
        txtReminder: Label 'Picking Instruction for Sales Order %1 has already been transmitted %2 to Location %3 by %4.  If you want to continue, you need to inform %5 of the resend intention.  Do you want to continue?';
    begin
        //pr 6/2/25 - look if already transmitted - start
        FTPStoreFile.Reset();
        FTPStoreFile.SetRange("Document No.", SalesHdr."No.");
        FTPStoreFile.SetRange("Document Type", FTPStoreFile."Document Type"::Order);
        FTPStoreFile.SetRange(Status, FTPStoreFile.Status::Transmitted);
        FTPStoreFile.SetRange(Direction, FTPStoreFile.Direction::Export);
        FTPStoreFile.SetCurrentKey(CreatedDate);
        FTPStoreFile.Ascending(false);
        if FTPStoreFile.FindFirst() then begin
            if (Dialog.Confirm(StrSubstNo(txtReminder, SalesHdr."No.", FTPStoreFile.CreatedDate, FTPStoreFile."Location Code", FTPStoreFile.CreatedBy, SalesHdr."Location Code"), false) = false) then
                Error('Task Aborted');
        end;
        //pr 6/2/25 - end

        FileName := 'PickingInstruction' + '_' + SalesHdr."No." + '.xml';
        FTPStoreFile.Reset();
        FTPStoreFile.Init();
        FTPStoreFile."Entry No." := 0;
        FTPStoreFile."File Name" := FileName;
        FTPStoreFile."Document No." := SalesHdr."No.";
        FTPStoreFile."Document Type" := FTPStoreFile."Document Type"::Order;
        //pr 6/2/25 - start
        FTPStoreFile."Location Code" := SalesHdr."Location Code";
        //pr 6/2/25 - end
        FTPStoreFile.CreatedDate := Today;
        FTPStoreFile.CreatedBy := UserId;
        FTPStoreFile.FileType := FTPStoreFile.FileType::XML;
        FTPStoreFile.Direction := FTPStoreFile.Direction::Export;
        FTPStoreFile.Insert();
        FTPStoreFile."File Content".CreateOutStream(OutStr);
        CLEAR(XmlExportPickInstruction);
        XmlExportPickInstruction.SetGetNo(SalesHdr."No.");
        XmlExportPickInstruction.SetDestination(OutStr);
        XmlExportPickInstruction.Export();
        FTPStoreFile.RecordedDateTime := CurrentDateTime;
        FTPStoreFile.CustomerNo := SalesHdr."Sell-to Customer No.";
        FTPStoreFile.ExternalDocumentNo := SalesHdr."External Document No.";
        FTPStoreFile.Modify();

        //now let's upload onto the ftp server
        //we will be using the MS Power Automate to do this whereby the connection is established there including ftp credentials and destination folder.
        //we just need to supply the HTTP URL which is stored in Sales & Receivable Setup
        //this URL will determine the power automate flow that will be used
        //Update 9/29/25 - The HTTP URL is now stored in the FTP Server Setup for each 3PL (location code)

        FTPStoreFile.Reset();
        FTPStoreFile.SetRange("Document No.", SalesHdr."No.");
        FTPStoreFile.SetRange("Document Type", FTPStoreFile."Document Type"::Order);
        If FTPStoreFile.FindLast() then;
        if FTPStoreFile."File Content".HasValue() then begin
            FTPStoreFile.CalcFields("File Content");
            IF FTPStoreFile."File Content".HasValue then begin
                FTPStoreFile."File Content".CreateInStream(instrem, TextEncoding::Windows);
                Base64String := Base64.ToBase64(instrem);

                HttpRequest.SetRequestUri(FtpServer.URL);
                HttpRequest.Method('Post');
                RequestJObject.Add('Base64String', Base64String);
                RequestJObject.Add('FileName', FTPStoreFile."File Name");
                RequestJObject.WriteTo(RequestText);
                RequestContent.WriteFrom(RequestText);

                RequestContent.GetHeaders(ContentHeaders);
                if ContentHeaders.Contains('Content-Type') then
                    ContentHeaders.Remove('Content-Type');
                ContentHeaders.Add('Content-Type', 'application/json');

                HttpRequest.Content(RequestContent);
                RequestHTTPClient.Send(HttpRequest, HttpResponse);
                FTPStoreFile.RecordedDateTime := CurrentDateTime;
                FTPStoreFile.Status := FTPStoreFile.Status::Transmitted;

                FTPStoreFile.Modify();
            end;
        end;
    end;



    procedure ExportTransferOrderXML(TransferHdr: Record "Transfer Header"; FtpServer: Record FTPServer)
    var
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        FTPStoreFile: Record FTPStoreFile;
        XmlExportPickInstruction: XmlPort TOPickInstructionXMLPort;
        InStr: InStream;
        OutStr: OutStream;
        FileName: Text;
        Content: text;
        HttpRequest: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        RequestText: Text;
        RequestJObject: JsonObject;
        RequestContent: HttpContent;
        RequestHTTPClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        OutStrem: OutStream;
        Base64: Codeunit "Base64 Convert";
        Base64String: Text;
        instrem: InStream;
        ResponseText: Text;
        popupConfirm: Page "Confirmation Dialog";
        txtReminder: Label 'Picking Instruction for Transfer Order %1 has already been transmitted today.  If you want to continue, you need to inform WhiteHorse of the resend intention';
    begin
        //pr 6/2/25 - look if already transmitted - start
        FTPStoreFile.Reset();
        FTPStoreFile.SetRange("Document No.", TransferHdr."No.");
        FTPStoreFile.SetRange("Document Type", FTPStoreFile."Document Type"::Order);
        FTPStoreFile.SetRange("Location Code", TransferHdr."Transfer-from Code");
        FTPStoreFile.SetRange(createdDate, Today);
        FTPStoreFile.SetRange(Status, FTPStoreFile.Status::Transmitted);
        if FTPStoreFile.FindFirst() then begin

            if (Dialog.Confirm(StrSubstNo(txtReminder, TransferHdr."No."), false) = false) then
                Error('Task Aborted');
        end;
        //pr 6/2/25 - end
        FileName := 'TOPickingInstruction' + '_' + TransferHdr."No." + '.xml';
        FTPStoreFile.Reset();
        FTPStoreFile.Init();
        FTPStoreFile."Entry No." := 0;
        FTPStoreFile."File Name" := FileName;
        FTPStoreFile."Document No." := TransferHdr."No.";
        //pr 6/2/25 - start
        FTPStoreFile."Location Code" := TransferHdr."Transfer-to Code";
        //pr 6/2/25 - end
        FTPStoreFile."Document Type" := FTPStoreFile."Document Type"::"Transfer Order";
        FTPStoreFile.CreatedDate := Today;
        FTPStoreFile.CreatedBy := UserId;
        FTPStoreFile.FileType := FTPStoreFile.FileType::XML;
        FTPStoreFile.Direction := FTPStoreFile.Direction::Export;
        FTPStoreFile.Insert();
        FTPStoreFile."File Content".CreateOutStream(OutStr);
        CLEAR(XmlExportPickInstruction);
        XmlExportPickInstruction.SetGetNo(TransferHdr."No.");
        XmlExportPickInstruction.SetDestination(OutStr);
        XmlExportPickInstruction.Export();
        FTPStoreFile.RecordedDateTime := CurrentDateTime;
        //FTPStoreFile.CustomerNo := TransferHdr."Sell-to Customer No.";
        FTPStoreFile.ExternalDocumentNo := TransferHdr."External Document No.";
        FTPStoreFile.Modify();

        //now let's upload onto the ftp server
        //we will be using the MS Power Automate to do this whereby the connection is established there including ftp credentials and destination folder.
        //we just need to supply the HTTP URL which is stored in Sales & Receivable Setup
        //this URL will determine the power automate flow that will be used

        FTPStoreFile.Reset();
        FTPStoreFile.SetRange("Document No.", TransferHdr."No.");
        FTPStoreFile.SetRange("Document Type", FTPStoreFile."Document Type"::Order);
        If FTPStoreFile.FindLast() then;
        if FTPStoreFile."File Content".HasValue() then begin
            FTPStoreFile.CalcFields("File Content");
            IF FTPStoreFile."File Content".HasValue then begin
                FTPStoreFile."File Content".CreateInStream(instrem, TextEncoding::Windows);
                Base64String := Base64.ToBase64(instrem);

                HttpRequest.SetRequestUri(FtpServer.URL);
                HttpRequest.Method('Post');
                RequestJObject.Add('Base64String', Base64String);
                RequestJObject.Add('FileName', FTPStoreFile."File Name");
                RequestJObject.WriteTo(RequestText);
                RequestContent.WriteFrom(RequestText);

                RequestContent.GetHeaders(ContentHeaders);
                if ContentHeaders.Contains('Content-Type') then
                    ContentHeaders.Remove('Content-Type');
                ContentHeaders.Add('Content-Type', 'application/json');

                HttpRequest.Content(RequestContent);
                RequestHTTPClient.Send(HttpRequest, HttpResponse);
                FTPStoreFile.RecordedDateTime := CurrentDateTime;
                FTPStoreFile.Status := FTPStoreFile.Status::Transmitted;

                FTPStoreFile.Modify();
            end;
        end;
    end;

    procedure Export943NoticeReceiver(TransferOrder: Record "Transfer Header"; FtpServer: Record FTPServer)
    var
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        FTPStoreFile: Record FTPStoreFile;
        XmlExport943NoticeInstruction: XmlPort Notice943XMLPort;
        InStr: InStream;
        OutStr: OutStream;
        FileName: Text;
        Content: text;
        HttpRequest: HttpRequestMessage;
        XMLRequest: XmlDocument;
        ContentHeaders: HttpHeaders;
        RequestText: Text;
        RequestJObject: JsonObject;
        RequestContent: HttpContent;
        RequestHTTPClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        OutStrem: OutStream;
        Base64: Codeunit "Base64 Convert";
        Base64String: Text;
        instrem: InStream;
        //test
        ResponseText: Text;
        reportToSend: Report "Reconcile AP to GL";
        email: Codeunit Email;
        emailMessage: Codeunit "Email Message";
        TempBlob2: Codeunit "Temp Blob";
        OutStr2: OutStream;
        InStr2: InStream;
        userSetup: Record "User Setup";
        bSend: boolean;
        Company: Record "Company Information";
        salesReportParams: Text;
        count: Integer;
    begin

        FileName := '943_RECEIVER' + '_' + format(TransferOrder."No.") + '.xml';
        FTPStoreFile.Reset();
        FTPStoreFile.Init();
        FTPStoreFile."Entry No." := 0;
        FTPStoreFile."File Name" := FileName;
        FTPStoreFile."Document No." := TransferOrder."No.";
        //8/18/25 - start
        if (TransferOrder."Physical Transfer To Code" <> '') then begin
            FTPStoreFile."Location Code" := TransferOrder."Physical Transfer To Code";
        end
        else begin
            //pr 6/2/25 - start
            FTPStoreFile."Location Code" := TransferOrder."Transfer-to Code";
            //pr 6/2/25 - end
        end;
        //8/18/25 -end
        FTPStoreFile."Document Type" := FTPStoreFile."Document Type"::"Transfer Order";
        FTPStoreFile.CreatedDate := Today;
        FTPStoreFile.CreatedBy := UserId;
        FTPStoreFile.FileType := FTPStoreFile.FileType::XML;
        FTPStoreFile.Direction := FTPStoreFile.Direction::Export;
        FTPStoreFile.Insert();
        FTPStoreFile."File Content".CreateOutStream(OutStr);
        CLEAR(XmlExport943NoticeInstruction);
        XmlExport943NoticeInstruction.SetGetNo(TransferOrder."No.");
        XmlExport943NoticeInstruction.SetDestination(OutStr);
        XmlExport943NoticeInstruction.Export();
        FTPStoreFile.RecordedDateTime := CurrentDateTime;
        FTPStoreFile.Modify();



        //now let's upload onto the ftp server
        //we will be using the MS Power Automate to do this whereby the connection is established there including ftp credentials and destination folder.
        //we just need to supply the HTTP URL which is stored in Sales & Receivable Setup
        //this URL will determine the power automate flow that will be used

        FTPStoreFile.Reset();
        FTPStoreFile.SetRange("Document No.", TransferOrder."No.");
        FTPStoreFile.SetRange("Document Type", FTPStoreFile."Document Type"::"Transfer Order");
        If FTPStoreFile.FindLast() then;
        if FTPStoreFile."File Content".HasValue() then begin
            FTPStoreFile.CalcFields("File Content");
            IF FTPStoreFile."File Content".HasValue then begin
                FTPStoreFile."File Content".CreateInStream(instrem, TextEncoding::Windows);
                Base64String := Base64.ToBase64(instrem);

                // Upload the file via HTTP
                HttpRequest.SetRequestUri(FtpServer.URL);
                HttpRequest.Method('Post');
                RequestJObject.Add('Base64String', Base64String);
                RequestJObject.Add('FileName', FTPStoreFile."File Name");
                RequestJObject.WriteTo(RequestText);
                RequestContent.WriteFrom(RequestText);

                RequestContent.GetHeaders(ContentHeaders);
                if ContentHeaders.Contains('Content-Type') then
                    ContentHeaders.Remove('Content-Type');
                ContentHeaders.Add('Content-Type', 'application/json');

                HttpRequest.Content(RequestContent);
                RequestHTTPClient.Send(HttpRequest, HttpResponse);
                FTPStoreFile.RecordedDateTime := CurrentDateTime;
                FTPStoreFile.Status := FTPStoreFile.Status::Transmitted;

                FTPStoreFile.Modify();
            end;
        end;

    end;

    local procedure GetHeaderValue(H: HttpHeaders; Name: Text): Text
    var
        Values: List of [Text];
    begin
        if H.GetValues(Name, Values) then
            exit(Values.Get(1));
        exit('');
    end;

    procedure Export832ItemMasterReceiver(Item: Record Item; FtpServer: Record FTPServer; selectedItems: Text)
    var
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        FTPStoreFile: Record FTPStoreFile;
        XmlExport832ItemMaster: XmlPort ItemMaster832XMLPort;
        InStr: InStream;
        OutStr: OutStream;
        FileName: Text;
        Content: text;
        HttpRequest: HttpRequestMessage;
        XMLRequest: XmlDocument;
        ContentHeaders: HttpHeaders;
        RequestText: Text;
        RequestJObject: JsonObject;
        RequestContent: HttpContent;
        RequestHTTPClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        OutStrem: OutStream;
        Base64: Codeunit "Base64 Convert";
        Base64String: Text;
        instrem: InStream;

    begin
        //10/3/25 - Make sure to now add EntryNo as Suffix to the filename to ensure uniqueness - start
        FTPStoreFile.Reset();
        FTPStoreFile.Init();
        FTPStoreFile."Entry No." := 0;
        FTPStoreFile."Document No." := Item."No.";
        FTPStoreFile.CreatedDate := Today;
        FTPStoreFile.CreatedBy := UserId;
        FTPStoreFile.FileType := FTPStoreFile.FileType::XML;
        FTPStoreFile.Direction := FTPStoreFile.Direction::Export;
        FTPStoreFile."Location Code" := FtpServer."Server Name";
        FTPStoreFile."Document Type" := FTPStoreFile."Document Type"::"Item";
        FTPStoreFile.Insert();
        FileName := '832_ITEM_MASTER' + '_' + format(TODAY, 0, '<Month,2><Day,2><Year,2>') + '_' + Format(FTPStoreFile."Entry No.") + '.xml';
        FTPStoreFile."File Name" := FileName;
        FTPStoreFile."File Content".CreateOutStream(OutStr);
        CLEAR(XmlExport832ItemMaster);
        XmlExport832ItemMaster.SetGetNo(Item."No.");
        XmlExport832ItemMaster.SetServerName(FtpServer."Server Name");
        XmlExport832ItemMaster.SetDestination(OutStr);
        XmlExport832ItemMaster.SetSelectedItems(selectedItems);
        XmlExport832ItemMaster.Export();
        FTPStoreFile.RecordedDateTime := CurrentDateTime;
        FTPStoreFile.ExternalDocumentNo := Item."No.";
        FTPStoreFile.Modify();
        //10/3/25 - end


        //now let's upload onto the ftp server
        //we will be using the MS Power Automate to do this whereby the connection is established there including ftp credentials and destination folder.
        //we just need to supply the HTTP URL which is stored in Sales & Receivable Setup
        //this URL will determine the power automate flow that will be used

        FTPStoreFile.Reset();
        FTPStoreFile.SetRange("Document No.", Item."No.");
        FTPStoreFile.SetRange("Document Type", FTPStoreFile."Document Type"::"Transfer Order");
        If FTPStoreFile.FindLast() then;
        if FTPStoreFile."File Content".HasValue() then begin
            FTPStoreFile.CalcFields("File Content");
            IF FTPStoreFile."File Content".HasValue then begin
                FTPStoreFile."File Content".CreateInStream(instrem, TextEncoding::Windows);
                Base64String := Base64.ToBase64(instrem);

                // Upload the file via HTTP
                HttpRequest.SetRequestUri(FtpServer.URL);
                HttpRequest.Method('Post');
                RequestJObject.Add('Base64String', Base64String);
                RequestJObject.Add('FileName', FTPStoreFile."File Name");
                RequestJObject.WriteTo(RequestText);
                RequestContent.WriteFrom(RequestText);

                RequestContent.GetHeaders(ContentHeaders);
                if ContentHeaders.Contains('Content-Type') then
                    ContentHeaders.Remove('Content-Type');
                ContentHeaders.Add('Content-Type', 'application/json');

                HttpRequest.Content(RequestContent);
                RequestHTTPClient.Send(HttpRequest, HttpResponse);
                FTPStoreFile.RecordedDateTime := CurrentDateTime;
                FTPStoreFile.Status := FTPStoreFile.Status::Transmitted;

                FTPStoreFile.Modify();
            end;
        end;

    end;





    procedure Export832ItemMasterReceiverCustom(Item: Record Item; FtpServer: Record FTPServer)
    var
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        FTPStoreFile: Record FTPStoreFile;
        XmlExport832ItemMaster: XmlPort ItemMaster832XMLPort;
        InStr: InStream;
        OutStr: OutStream;
        FileName: Text;
        Content: text;
        HttpRequest: HttpRequestMessage;
        XMLRequest: XmlDocument;
        ContentHeaders: HttpHeaders;
        RequestText: Text;
        RequestJObject: JsonObject;
        RequestContent: HttpContent;
        RequestHTTPClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        OutStrem: OutStream;
        Base64: Codeunit "Base64 Convert";
        Base64String: Text;
        instrem: InStream;
    begin
        //10/3/25 - Make sure to now add EntryNo as Suffix to the filename to ensure uniqueness - start
        //FileName := '832_ITEM_MASTER' + '_' + format(TODAY, 0, '<Month,2><Day,2><Year,2>') + '.xml';
        FTPStoreFile.Reset();
        FTPStoreFile.Init();
        FTPStoreFile."Entry No." := 0;
        FTPStoreFile."File Name" := FileName;
        FTPStoreFile."Document No." := Item."No.";
        FTPStoreFile.CreatedDate := Today;
        FTPStoreFile.CreatedBy := UserId;
        FTPStoreFile.FileType := FTPStoreFile.FileType::XML;
        FTPStoreFile.Direction := FTPStoreFile.Direction::Export;
        FTPStoreFile."Location Code" := FtpServer."Server Name";
        FTPStoreFile."Document Type" := FTPStoreFile."Document Type"::"Item";
        FTPStoreFile.Insert();
        FileName := '832_ITEM_MASTER' + '_' + format(TODAY, 0, '<Month,2><Day,2><Year,2>') + '_' + Format(FTPStoreFile."Entry No.") + '.xml';
        //10/3/25 - end

        FTPStoreFile."File Content".CreateOutStream(OutStr);
        CLEAR(XmlExport832ItemMaster);
        XmlExport832ItemMaster.SetGetNo(Item."No.");
        XmlExport832ItemMaster.SetServerName(FtpServer."Server Name");
        XmlExport832ItemMaster.SetDestination(OutStr);
        XmlExport832ItemMaster.SetCustomFilter(true);
        XmlExport832ItemMaster.Export();
        FTPStoreFile.RecordedDateTime := CurrentDateTime;
        FTPStoreFile.ExternalDocumentNo := Item."No.";
        FTPStoreFile.Modify();



        //now let's upload onto the ftp server
        //we will be using the MS Power Automate to do this whereby the connection is established there including ftp credentials and destination folder.
        //we just need to supply the HTTP URL which is stored in Sales & Receivable Setup
        //this URL will determine the power automate flow that will be used

        FTPStoreFile.Reset();
        FTPStoreFile.SetRange("Document No.", Item."No.");
        FTPStoreFile.SetRange("Document Type", FTPStoreFile."Document Type"::"Transfer Order");
        If FTPStoreFile.FindLast() then;
        if FTPStoreFile."File Content".HasValue() then begin
            FTPStoreFile.CalcFields("File Content");
            IF FTPStoreFile."File Content".HasValue then begin
                FTPStoreFile."File Content".CreateInStream(instrem, TextEncoding::Windows);
                Base64String := Base64.ToBase64(instrem);

                // Upload the file via HTTP
                HttpRequest.SetRequestUri(FtpServer.URL);
                HttpRequest.Method('Post');
                RequestJObject.Add('Base64String', Base64String);
                RequestJObject.Add('FileName', FTPStoreFile."File Name");
                RequestJObject.WriteTo(RequestText);
                RequestContent.WriteFrom(RequestText);

                RequestContent.GetHeaders(ContentHeaders);
                if ContentHeaders.Contains('Content-Type') then
                    ContentHeaders.Remove('Content-Type');
                ContentHeaders.Add('Content-Type', 'application/json');

                HttpRequest.Content(RequestContent);
                RequestHTTPClient.Send(HttpRequest, HttpResponse);
                FTPStoreFile.RecordedDateTime := CurrentDateTime;
                FTPStoreFile.Status := FTPStoreFile.Status::Transmitted;

                FTPStoreFile.Modify();
            end;
        end;

    end;

    //10/6/25 - start
    procedure UpdateMondayFromPurchLinePONo(var PurchLine: Record "Purchase Line")
    var
        Token: Text;
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpResponse: HttpResponseMessage;
        Headers: HttpHeaders;

        InventorySetup: Record "Inventory Setup";
        Item: Record Item;

        BoardIDTxt: Text;
        ItemIDTxt: Text;
        ColumnID: Text;
        ActualCargoDateTxt: Text;

        //BoardIDInt: Integer;
        //ItemIDInt: Integer;

        // Build JSON safely
        BodyObj: JsonObject;
        VarsObj: JsonObject;
        ValueJsonStr: Text;
        QueryStr: Text;
        BodyTxt: Text;
        ValueTxt: Text;

        // Response parsing
        StatusCode: Integer;
        Response: Text;
        Root: JsonObject;
        Tok: JsonToken;
        DataObj: JsonObject;
        ChangeTok: JsonToken;
        ChangeObj: JsonObject;
        PoTxt: Text;

    begin
        if (purchLine."New Item" = false) then
            Error(noCheckNewItem, PurchLine."No.");
        // --- Validate setup & inputs ---
        if not InventorySetup.Get() then
            Error('Inventory Setup not found.');
        //  InventorySetup.TestField(MondayColumnName);
        // InventorySetup.TestField("MondayAPI");

        // ColumnID := InventorySetup.RefreshMondayCRD;
        //Token := InventorySetup.MondayAPI.Trim();
        Item.Reset();
        Item.SetRange("No.", PurchLine."No.");
        //Item.SetFilter("Monday.com PO ItemID", '<>%1', ''); // only items that have been setup for Monday.com
        if not Item.FindFirst() then
            Error(noItemErrTxt, PurchLine."No.");
        Item.TestField("Monday.com URL");
        Item.ReadMondayURL(); // fills BoardID & ItemID on Item
        Item.TestField("Monday.com BoardID");
        Item.TestField("Monday.com ItemID");
        Item.TestField("Monday.com PO ItemID");
        ItemIDTxt := Item."Monday.com PO ItemID";
        if (ItemIDTxt = '') then
            Error(noPONoIDErr, Item."No.");
        BoardIDTxt := Item."Monday.com BoardID";
        PoTxt := PurchLine."Document No.";
        ValueJsonStr := StrSubstNo('%1', StrSubstNo('PO No. = %1 By: %2 %3', PoTxt, UserId, Today));
        if (UpdateMonday(PurchLine, BoardIDTxt, ItemIDTxt, ValueJsonStr)) then
            Message('Monday.com updated successfully: Item No. %1 PO No. %2', Item."No.", PurchLine."Document No.");
    end;

    procedure AddToPOMondayAudit(var PurchLine: Record "Purchase Line"; BoardIDTxt: Text; var ItemIDTxt: Text; var ValueJsonStr: Text; UserId: Text; UseDate: Date; Result: Boolean)
    var
        PurchLineMondayAudit: Record "PurchLine Monday Update Audit";

        InventorySetup: Record "Inventory Setup";
    begin


        PurchLineMondayAudit.Init();
        PurchLineMondayAudit."Entry No." := 0;
        PurchLineMondayAudit."No." := PurchLine."No.";
        PurchLineMondayAudit."Line No." := PurchLine."Line No.";
        PurchLineMondayAudit."Document No." := PurchLine."Document No.";
        PurchLineMondayAudit."Monday.com BoardID" := BoardIDTxt;
        PurchLineMondayAudit."Monday.com ItemID" := ItemIDTxt;
        PurchLineMondayAudit.ValueJsonStr := ValueJsonStr;
        PurchLineMondayAudit."Changed By User ID" := UserId;
        PurchLineMondayAudit."Changed On" := UseDate;
        if (InventorySetup.Get()) then
            PurchLineMondayAudit.ColumnID := InventorySetup.MondayColumnName;
        PurchLineMondayAudit.Result := Result;
        PurchLineMondayAudit.Insert();
    end;

    procedure UpdateMondayFromPurchLineCRD(var PurchLine: Record "Purchase Line")
    var
        Token: Text;
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpResponse: HttpResponseMessage;
        Headers: HttpHeaders;
        InventorySetup: Record "Inventory Setup";
        Item: Record Item;
        BoardIDTxt: Text;
        ItemIDTxt: Text;
        ColumnID: Text;
        ActualCargoDateTxt: Text;
        // Build JSON safely
        BodyObj: JsonObject;
        VarsObj: JsonObject;
        ValueJsonStr: Text;
        QueryStr: Text;
        BodyTxt: Text;
        ValueTxt: Text;
        // Response parsing
        StatusCode: Integer;
        Response: Text;
        Root: JsonObject;
        Tok: JsonToken;
        DataObj: JsonObject;
        ChangeTok: JsonToken;
        ChangeObj: JsonObject;

        PoTxt: Text;
        ColumnTitle: Text;
    begin
        if (purchLine."New Item" = false) then
            Error(noCheckNewItem, PurchLine."No.");

        // --- Validate setup & inputs ---
        if not InventorySetup.Get() then
            Error('Inventory Setup not found.');
        InventorySetup.TestField(MondayColumnName);
        InventorySetup.TestField("MondayAPI");


        Token := InventorySetup.MondayAPI.Trim();
        Item.Reset();
        Item.SetRange("No.", PurchLine."No.");
        if not Item.FindFirst() then
            Error(noItemErrTxt, PurchLine."No.");
        Item.TestField("Monday.com URL");
        Item.ReadMondayURL(); // fills BoardID & ItemID on Item
        Item.TestField("Monday.com BoardID");
        Item.TestField("Monday.com ItemID");
        Item.TestField("Monday.com PO ItemID");
        ItemIDTxt := Item."Monday.com PO ItemID";
        if (ItemIDTxt = '') then
            Error(noPONoIDErr, Item."No.");
        BoardIDTxt := Item."Monday.com BoardID";

        //assign Column ID given the Column Name stored in Inventory Setup
        ColumnID := '';
        ColumnTitle := InventorySetup.MondayColumnName;
        GetColumnIdByTitle(BoardIDTxt, ItemIDTxt, ColumnID, ColumnTitle);
        if ColumnID = '' then
            Error('Column with title "%1" not found on board %2.', ColumnTitle, BoardIDTxt);


        // checks if po no is in notes 
        PoTxt := GetMondayColumnDisplayText(BoardIDTxt, ItemIDTxt, ColumnID);
        if (StrPos(PoTxt, PurchLine."Document No.") = 0) then
            Error('PO No. %1 not found in Monday.com set up of Item %2. Monday.com UPDATE Aborted! "%3" was found instead.', PurchLine."Document No.", Item."No.", PoTxt)
        else if (PoTxt = '') then
            Error('PO No. %1 not found in Monday.com set up of Item %2. Monday.com UPDATE Aborted!', PurchLine."Document No.", Item."No.");
        Item.ReadMondayURL(); // fills BoardID & ItemID on Item
        Item.TestField("Monday.com BoardID");
        Item.TestField("Monday.com ItemID");
        ItemIDTxt := Item."Monday.com ItemID";
        BoardIDTxt := Item."Monday.com BoardID";
        PurchLine.TestField(ActualCargoReadyDate);
        ActualCargoDateTxt := Format(PurchLine.ActualCargoReadyDate, 0, '<Month,2>/<Day,2>/<Year,2>');
        ValueJsonStr := StrSubstNo('%1', StrSubstNo('Actual CRD = %1 By: %2 %3', ActualCargoDateTxt, UserId, Today));
        if (UpdateMonday(PurchLine, BoardIDTxt, ItemIDTxt, ValueJsonStr)) then
            Message('Monday.com updated Actual CRD %1 successfully.', ActualCargoDateTxt);
    end;

    procedure UpdateMonday(var PurchLine: Record "Purchase Line"; var BoardIDTxt: Text; var ItemIDTxt: Text; var ValueJsonStr: Text): Boolean
    var
        Token: Text;
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpResponse: HttpResponseMessage;
        Headers: HttpHeaders;
        InventorySetup: Record "Inventory Setup";
        ColumnID: Text;
        ActualCargoDateTxt: Text;
        // Build JSON safely
        BodyObj: JsonObject;
        VarsObj: JsonObject;
        //  ValueJsonStr: Text;
        QueryStr: Text;
        BodyTxt: Text;
        ValueTxt: Text;
        // Response parsing
        StatusCode: Integer;
        Response: Text;
        Root: JsonObject;
        Tok: JsonToken;
        DataObj: JsonObject;
        ChangeTok: JsonToken;
        ChangeObj: JsonObject;
        ColumnTitle: Text;
    begin
        // --- Validate setup & inputs ---
        if not InventorySetup.Get() then begin
            Error('Inventory Setup not found.');
            exit(false);
        end;
        InventorySetup.TestField(MondayColumnName);
        InventorySetup.TestField("MondayAPI");
        // --- Resolve the column id by title ("notes") on this board ---
        ColumnTitle := InventorySetup.MondayColumnName;
        GetColumnIdByTitle(BoardIDTxt, ItemIDTxt, ColumnID, ColumnTitle);
        if ColumnID = '' then
            Error('Column with title "%1" not found on board %2.', ColumnTitle, BoardIDTxt);

        // --- Build variables for a TEXT column update ---
        // ColumnID := InventorySetup.RefreshMondayCRD;
        Token := InventorySetup.MondayAPI.Trim();

        //  PurchLine.TestField("No.");
        //  PurchLine.TestField("Line No.");
        //  PurchLine.TestField(ActualCargoReadyDate);
        //
        // YYYY-MM-DD for Monday Date columns
        //   ActualCargoDateTxt := Format(PurchLine.ActualCargoReadyDate, 0, '<Month,2>/<Day,2>/<Year,2>');
        // --- Build GraphQL with variables (no escaping headaches) ---
        // value for a DATE column must be a JSON string: {"date":"YYYY-MM-DD"}
        QueryStr :=
   'mutation($board_id: ID!, $item_id: ID!, $column_id: String!, $value: String!) ' +
   '{ change_simple_column_value(board_id: $board_id, item_id: $item_id, column_id: $column_id, value: $value) { id } }';
        VarsObj.Add('board_id', BoardIDTxt);   // pass as string for ID
        VarsObj.Add('item_id', ItemIDTxt);     // pass as string for ID
        VarsObj.Add('column_id', ColumnID);
        VarsObj.Add('value', ValueJsonStr); // IMPORTANT: pass as string; Monday JSON scalar expects a JSON string
        BodyObj.Add('query', QueryStr);
        BodyObj.Add('variables', VarsObj);
        BodyTxt := JsonToText(BodyObj); // serialize safely

        // --- HTTP call ---
        HttpContent.WriteFrom(BodyTxt);
        HttpContent.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');

        HttpClient.DefaultRequestHeaders.Clear();
        SetMondayAuth(HttpClient, Token);                   // personal vs OAuth
        HttpClient.DefaultRequestHeaders.Add('Accept', 'application/json');
        // Optional version pin:
        if not HttpClient.Post('https://api.monday.com/v2', HttpContent, HttpResponse) then begin
            Error('HTTP request did not start.');
            exit(false);
        end;

        StatusCode := HttpResponse.HttpStatusCode();
        HttpResponse.Content.ReadAs(Response);

        if (StatusCode < 200) or (StatusCode >= 300) then begin
            AddToPOMondayAudit(PurchLine, BoardIDTxt, ItemIDTxt, ValueJsonStr, UserId, Today, false);
            Error('HTTP %1 from Monday. Body (first 500): %2', StatusCode, CopyStr(Response, 1, 500));
            exit(false);
        end;
        if not Root.ReadFrom(Response) then begin
            AddToPOMondayAudit(PurchLine, BoardIDTxt, ItemIDTxt, ValueJsonStr, UserId, Today, false);
            Error('Invalid JSON from Monday. Body (first 500): %1', CopyStr(Response, 1, 500));
            exit(false);
        end;
        if Root.Get('errors', Tok) then begin
            AddToPOMondayAudit(PurchLine, BoardIDTxt, ItemIDTxt, ValueJsonStr, UserId, Today, false);
            Error('Monday API error. Body (first 500): %1', CopyStr(Response, 1, 500));
            exit(false);
        end;
        if not Root.Get('data', Tok) or not Tok.IsObject() then begin
            AddToPOMondayAudit(PurchLine, BoardIDTxt, ItemIDTxt, ValueJsonStr, UserId, Today, false);
            Error('Unexpected response: missing "data". Body (first 500): %1', CopyStr(Response, 1, 500));
            exit(false);
        end;
        DataObj := Tok.AsObject();

        // Prefer simple mutation result, but support both
        if DataObj.Get('change_simple_column_value', ChangeTok) and ChangeTok.IsObject() then
            ChangeObj := ChangeTok.AsObject()
        else if DataObj.Get('change_column_value', ChangeTok) and ChangeTok.IsObject() then
            ChangeObj := ChangeTok.AsObject()
        else begin
            AddToPOMondayAudit(PurchLine, BoardIDTxt, ItemIDTxt, ValueJsonStr, UserId, Today, false);
            Error('Unexpected response: missing result node. Body (first 500): %1', CopyStr(Response, 1, 500));
            exit(false);
        end;

        // Message('Monday column updated.');
        AddToPOMondayAudit(PurchLine, BoardIDTxt, ItemIDTxt, ValueJsonStr, UserId, Today, true);
        exit(true);
    end;
    // Personal token (often "v2_…") => Authorization: <token>
    // OAuth access token (JWT-like)   => Authorization: Bearer <token>
    local procedure SetMondayAuth(var Cli: HttpClient; Token: Text)
    var
        HeaderVal: Text;
    begin
        Token := Token.Trim();
        if Token = '' then Error('Monday token is blank.');
        if (CopyStr(Token, 1, 3) = 'v2_') or (StrPos(Token, '.') = 0) then
            HeaderVal := Token
        else
            HeaderVal := 'Bearer ' + Token;
        Cli.DefaultRequestHeaders.Remove('Authorization');
        Cli.DefaultRequestHeaders.Add('Authorization', HeaderVal);
    end;

    local procedure GetJsonField(J: JsonObject; Name: Text): Text
    var
        T: JsonToken;
    begin
        if J.Get(Name, T) then exit(T.AsValue().AsText());
        exit('');
    end;

    local procedure TryStrToInt(InTxt: Text; var OutInt: Integer): Boolean
    begin
        exit(Evaluate(OutInt, InTxt));
    end;

    local procedure JsonToText(var Obj: JsonObject): Text
    var
        TempBlob: Codeunit "Temp Blob";
        OutS: OutStream;
        InS: InStream;
        S: Text;
    begin
        TempBlob.CreateOutStream(OutS, TEXTENCODING::UTF8);
        Obj.WriteTo(OutS);
        TempBlob.CreateInStream(InS, TEXTENCODING::UTF8);
        InS.ReadText(S);
        exit(S);
    end;

    procedure GetMondayColumnDisplayText(BoardIDTxt: Text; ItemIDTxt: Text; ColumnIdTxt: Text): Text
    var
        InvSetup: Record "Inventory Setup";
        Token: Text;

        // HTTP
        Cli: HttpClient;
        Cnt: HttpContent;
        Res: HttpResponseMessage;
        H: HttpHeaders;

        // GQL
        QueryStr: Text;
        VarsObj: JsonObject;
        BodyObj: JsonObject;
        BodyTxt: Text;

        // Response
        Status: Integer;
        Resp: Text;
        Root: JsonObject;
        Tok: JsonToken;

        DataObj: JsonObject;
        ItemsTok: JsonToken;
        ItemsArr: JsonArray;
        ItemTok: JsonToken;
        ItemObj: JsonObject;

        ColTok: JsonToken;
        ColArr: JsonArray;
        OneColTok: JsonToken;
        OneColObj: JsonObject;

        DisplayText: Text;
    begin
        if not InvSetup.Get() then
            Error('Inventory Setup not found.');
        InvSetup.TestField(MondayAPI);
        Token := InvSetup.MondayAPI.Trim();

        if (BoardIDTxt = '') or (ItemIDTxt = '') or (ColumnIdTxt = '') then
            Error('Board ID, Item ID, and Column ID are required.');

        // Query just the item and the one column
        QueryStr :=
          'query($item_id: ID!, $column_id: String!) {' +
          '  items(ids: [$item_id]) {' +
          '    id' +
          '    column_values(ids: [$column_id]) { id text value type }' +
          '  }' +
          '}';

        VarsObj.Add('item_id', ItemIDTxt);
        VarsObj.Add('column_id', ColumnIdTxt);

        BodyObj.Add('query', QueryStr);
        BodyObj.Add('variables', VarsObj);
        BodyTxt := JsonToText(BodyObj);

        // POST
        Cnt.WriteFrom(BodyTxt);
        Cnt.GetHeaders(H);
        H.Clear();
        H.Add('Content-Type', 'application/json');

        Cli.DefaultRequestHeaders.Clear();
        SetMondayAuth(Cli, Token);
        Cli.DefaultRequestHeaders.Add('Accept', 'application/json');

        if not Cli.Post('https://api.monday.com/v2', Cnt, Res) then
            Error('HTTP request did not start.');

        Status := Res.HttpStatusCode();
        Res.Content.ReadAs(Resp);
        if (Status < 200) or (Status >= 300) then
            Error('HTTP %1 from Monday. Body (first 500): %2', Status, CopyStr(Resp, 1, 500));

        if not Root.ReadFrom(Resp) then
            Error('Invalid JSON from Monday. Body (first 500): %1', CopyStr(Resp, 1, 500));

        if Root.Get('errors', Tok) then
            Error('Monday API error. Body (first 500): %1', CopyStr(Resp, 1, 500));

        if not Root.Get('data', Tok) or not Tok.IsObject() then
            Error('Unexpected response: missing "data". Body (first 500): %1', CopyStr(Resp, 1, 500));
        DataObj := Tok.AsObject();

        if not DataObj.Get('items', ItemsTok) or not ItemsTok.IsArray() then
            Error('Unexpected response: missing "items". Body (first 500): %1', CopyStr(Resp, 1, 500));
        ItemsArr := ItemsTok.AsArray();
        if ItemsArr.Count() = 0 then
            Error('Item %1 not found.', ItemIDTxt);

        ItemsArr.Get(0, ItemTok);
        if not ItemTok.IsObject() then
            Error('"items[0]" is not an object. Body (first 500): %1', CopyStr(Resp, 1, 500));
        ItemObj := ItemTok.AsObject();

        if not ItemObj.Get('column_values', ColTok) or not ColTok.IsArray() then
            Error('No "column_values" array in response. Body (first 500): %1', CopyStr(Resp, 1, 500));
        ColArr := ColTok.AsArray();
        if ColArr.Count() = 0 then
            Error('Column %1 not found on the item.', ColumnIdTxt);

        ColArr.Get(0, OneColTok);
        if not OneColTok.IsObject() then
            Error('"column_values[0]" is not an object. Body (first 500): %1', CopyStr(Resp, 1, 500));
        OneColObj := OneColTok.AsObject();

        DisplayText := GetJsonField(OneColObj, 'text'); // what Monday shows in UI
        exit(DisplayText); // may be '' when empty
    end;

    local procedure GetColumnIdByTitle(BoardIDTxt: Text; ItemIDTxt: Text; var ColumnId: Text; var ColumnType: Text)
    var
        Token: Text;
        InvSetup: Record "Inventory Setup";
        Cli: HttpClient;
        Cnt: HttpContent;
        Res: HttpResponseMessage;
        H: HttpHeaders;
        Q: Text;
        Vars: JsonObject;
        Body: JsonObject;
        BodyTxt: Text;
        Status: Integer;
        RespTxt: Text;
        Root: JsonObject;
        Tok: JsonToken;
        DataObj: JsonObject;

        // item board check
        ItemsTok: JsonToken;
        ItemsArr: JsonArray;
        ItemTok: JsonToken;
        ItemObj: JsonObject;
        BoardTok: JsonToken;
        BoardObj: JsonObject;
        ActualBoard: Text;

        // columns
        BoardsTok: JsonToken;
        BoardsArr: JsonArray;
        Board2Tok: JsonToken;
        Board2Obj: JsonObject;
        ColTok: JsonToken;
        ColArr: JsonArray;
        OneColTok: JsonToken;
        OneColObj: JsonObject;
        WantedTitleLower: Text;
        i: Integer;
    begin
        ColumnId := '';
        ColumnType := '';
        if not InvSetup.Get() then Error('Inventory Setup not found.');
        Token := InvSetup.MondayAPI.Trim();

        // 1) Verify the item actually belongs to the provided board
        Q :=
          'query($item_id: ID!, $board_id: ID!) {' +
          '  items(ids: [$item_id]) { id board { id name } } ' +
          '  boards(ids: [$board_id]) { id name columns { id title type } }' +
          '}';
        Vars.Add('item_id', ItemIDTxt);
        Vars.Add('board_id', BoardIDTxt);

        Body.Add('query', Q);
        Body.Add('variables', Vars);
        BodyTxt := JsonToText(Body);

        Cnt.WriteFrom(BodyTxt);
        Cnt.GetHeaders(H);
        H.Clear();
        H.Add('Content-Type', 'application/json');
        Cli.DefaultRequestHeaders.Clear();
        SetMondayAuth(Cli, Token);
        Cli.DefaultRequestHeaders.Add('Accept', 'application/json');

        if not Cli.Post('https://api.monday.com/v2', Cnt, Res) then
            Error('HTTP request did not start.');
        Status := Res.HttpStatusCode();
        Res.Content.ReadAs(RespTxt);
        if (Status < 200) or (Status >= 300) then
            Error('HTTP %1. Body: %2', Status, CopyStr(RespTxt, 1, 500));
        if not Root.ReadFrom(RespTxt) then
            Error('Invalid JSON: %1', CopyStr(RespTxt, 1, 500));
        if Root.Get('errors', Tok) then
            Error('Monday API error: %1', CopyStr(RespTxt, 1, 500));
        if not Root.Get('data', Tok) or not Tok.IsObject() then
            Error('No data: %1', CopyStr(RespTxt, 1, 500));
        DataObj := Tok.AsObject();

        // Check item.board.id
        if not DataObj.Get('items', ItemsTok) or not ItemsTok.IsArray() then
            Error('Missing items.');
        ItemsArr := ItemsTok.AsArray();
        if ItemsArr.Count() = 0 then Error('Item %1 not found.', ItemIDTxt);
        ItemsArr.Get(0, ItemTok);
        ItemObj := ItemTok.AsObject();
        if ItemObj.Get('board', BoardTok) and BoardTok.IsObject() then begin
            BoardObj := BoardTok.AsObject();
            ActualBoard := GetJsonField(BoardObj, 'id');
            if ActualBoard <> BoardIDTxt then
                Error('Item %1 is on board %2 (not %3). Use that board id or pass the subitem id if updating subitems.',
                      ItemIDTxt, ActualBoard, BoardIDTxt);
        end;

        // 2) Find column titled “Notes” (case-insensitive)
        if not DataObj.Get('boards', BoardsTok) or not BoardsTok.IsArray() then
            Error('Missing boards.');
        BoardsArr := BoardsTok.AsArray();
        if BoardsArr.Count() = 0 then Error('Board %1 not found.', BoardIDTxt);
        BoardsArr.Get(0, Board2Tok);
        Board2Obj := Board2Tok.AsObject();

        if not Board2Obj.Get('columns', ColTok) or not ColTok.IsArray() then
            Error('Board %1 has no columns.', BoardIDTxt);
        ColArr := ColTok.AsArray();

        WantedTitleLower := LowerCase('Notes');

        for i := 0 to ColArr.Count() - 1 do begin
            ColArr.Get(i, OneColTok);
            if not OneColTok.IsObject() then
                continue;
            OneColObj := OneColTok.AsObject();
            if LowerCase(GetJsonField(OneColObj, 'title').Trim()) = WantedTitleLower then begin
                ColumnId := GetJsonField(OneColObj, 'id');
                ColumnType := LowerCase(GetJsonField(OneColObj, 'type')); // text / long_text / subtasks / ...
                exit;
            end;
        end;

        Error('Column with title "Notes" not found on board %1.', BoardIDTxt);
    end;

    local procedure GetColumnIdByTitle2(BoardIDTxt: Text; ColumnTitle: Text): Text
    var
        Cli: HttpClient;
        Cnt: HttpContent;
        Res: HttpResponseMessage;
        H: HttpHeaders;

        InvSetup: Record "Inventory Setup";
        Token: Text;

        Q: Text;
        Vars: JsonObject;
        Body: JsonObject;
        BodyTxt: Text;

        Status: Integer;
        RespTxt: Text;

        Root: JsonObject;
        Tok: JsonToken;

        DataObj: JsonObject;
        BoardsTok: JsonToken;
        BoardsArr: JsonArray;
        BoardTok: JsonToken;
        BoardObj: JsonObject;

        ColTok: JsonToken;
        ColArr: JsonArray;
        OneColTok: JsonToken;
        OneColObj: JsonObject;

        WantedLower: Text;
        BestId: Text;
        BestType: Text;
        i: Integer;
    begin
        if not InvSetup.Get() then
            Error('Inventory Setup not found.');
        Token := InvSetup.MondayAPI.Trim();

        WantedLower := LowerCase(GetJsonField(OneColObj, 'title').Trim());
        BestId := '';
        BestType := '';

        // Query all columns for this board
        Q :=
          'query($board_id: ID!) { ' +
          '  boards(ids: [$board_id]) { id name columns { id title type } } ' +
          '}';
        Vars.Add('board_id', BoardIDTxt);

        Body.Add('query', Q);
        Body.Add('variables', Vars);
        BodyTxt := JsonToText(Body);

        Cnt.WriteFrom(BodyTxt);
        Cnt.GetHeaders(H);
        H.Clear();
        H.Add('Content-Type', 'application/json');

        Cli.DefaultRequestHeaders.Clear();
        SetMondayAuth(Cli, Token);
        Cli.DefaultRequestHeaders.Add('Accept', 'application/json');

        if not Cli.Post('https://api.monday.com/v2', Cnt, Res) then
            Error('HTTP request did not start.');

        Status := Res.HttpStatusCode();
        Res.Content.ReadAs(RespTxt);
        if (Status < 200) or (Status >= 300) then
            Error('HTTP %1 from Monday. Body (first 500): %2', Status, CopyStr(RespTxt, 1, 500));

        if not Root.ReadFrom(RespTxt) then
            Error('Invalid JSON from Monday. Body (first 500): %1', CopyStr(RespTxt, 1, 500));

        if Root.Get('errors', Tok) then
            Error('Monday API error. Body (first 500): %1', CopyStr(RespTxt, 1, 500));

        if not Root.Get('data', Tok) or not Tok.IsObject() then
            Error('Unexpected response: missing data. Body (first 500): %1', CopyStr(RespTxt, 1, 500));
        DataObj := Tok.AsObject();

        if not DataObj.Get('boards', BoardsTok) or not BoardsTok.IsArray() then
            Error('Unexpected response: missing boards. Body (first 500): %1', CopyStr(RespTxt, 1, 500));
        BoardsArr := BoardsTok.AsArray();
        if BoardsArr.Count() = 0 then
            exit('');

        BoardsArr.Get(0, BoardTok);
        if not BoardTok.IsObject() then
            Error('"boards[0]" is not an object. Body (first 500): %1', CopyStr(RespTxt, 1, 500));
        BoardObj := BoardTok.AsObject();

        if not BoardObj.Get('columns', ColTok) or not ColTok.IsArray() then
            exit('');

        ColArr := ColTok.AsArray();

        for i := 0 to ColArr.Count() - 1 do begin
            ColArr.Get(i, OneColTok);
            if not OneColTok.IsObject() then
                continue;

            OneColObj := OneColTok.AsObject();

            // case-insensitive title match
            if LowerCase(GetJsonField(OneColObj, 'title').Trim()) = WantedLower then begin
                // Prefer 'text' type if multiple
                if (BestId = '') or (LowerCase(GetJsonField(OneColObj, 'type')) = 'text') then begin
                    BestId := GetJsonField(OneColObj, 'id');
                    BestType := GetJsonField(OneColObj, 'type');
                    // if it's text, it's our best match—keep it
                    if LowerCase(BestType) = 'text' then
                        exit(BestId);
                end;
            end;
        end;

        exit(BestId); // may be '' if not found
    end;




    Var
        lblErrSONonexistent: label 'Sales Order %1 DOES NOT EXIST! Package Information Import Aborted!';
        lblItemReservedQtyDiff: Label '%1 qty=%2 and imported qty=%3.';
        lblItemNoImpQty: Label '%1 qty=%2 and imported qty=0.';
        chr13: Char;
        chr10: Char;
        lblTaskDone: Label 'Import of Packaging Information Done!';
        lblNoURL: Label 'No FTP URL is setup for %1 %2';
        lblNoFlowURL: Label 'No %3 is setup for %1 %2';
        lblErrCustNotEnabled: label 'Cust. %1 is not ENABLED to receive 945-Pckg. Info.';
        lblOrderNotFound: label 'Order NOT FOUND.';
        noPONoIDErr: Label 'Item %1 is not setup with Monday.com parameters. Update Task aborted.';
        noItemErrTxt: Label 'Item %1 is not setup with Monday.com parameters. Update Task aborted.';
        noCheckNewItem: Label 'Item %1 is not MARKED as New Item.  Update of Monday.Com NOT ALLOWED.';
}
