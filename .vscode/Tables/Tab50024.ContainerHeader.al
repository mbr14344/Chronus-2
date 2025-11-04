table 50024 "Container Header"
{
    Caption = 'Container Header';
    DataClassification = CustomerContent;
    LookupPageId = "Container Orders";


    fields
    {
        field(1; "Container No."; Code[50])
        {
            Caption = 'Container No.';
            trigger OnValidate()
            var
                PostedTransShip: Record "Transfer Shipment Header";
                PostedTransRcpt: Record "Transfer Receipt Header";
                txtTransferShipErr: Label 'Container No. %1 is connected to Posted Transfer Shipment %2 and cannot be changed.';
                txtTransferRcptErr: Label 'Container No. %1 is connected to Posted Transfer Receipt %2 and cannot be changed.';
                txtTransferRcptAndShipErr: Label 'Container No. %1 is connected to Posted Transfer Shipment %2 and Posted Transfer Receipt %3 and cannot be changed.';
                bShip: Boolean;
                bRcpt: Boolean;
                shipNo: code[20];
                rcptNo: code[20];
            begin
                bShip := false;
                bRcpt := false;
                if (StrLen(xRec."Container No.") > 0) then begin
                    PostedTransShip.Reset();
                    PostedTransShip.SetRange("Container No.", xRec."Container No.");
                    if (PostedTransShip.FindSet()) then begin
                        bShip := true;
                        shipNo := PostedTransShip."No.";
                    end;
                    PostedTransRcpt.Reset();
                    PostedTransRcpt.SetRange("Container No.", xRec."Container No.");
                    if (PostedTransRcpt.FindSet()) then begin
                        bRcpt := true;
                        rcptNo := PostedTransShip."No.";
                    end;
                    if (bShip = true) and (bRcpt = true) then
                        error(txtTransferRcptAndShipErr, xRec."Container No.", PostedTransShip."No.", PostedTransRcpt."No.")
                    else if (bShip = true) and (bRcpt = false) then
                        error(txtTransferShipErr, xRec."Container No.", PostedTransShip."No.")
                    else if (bShip = false) and (bRcpt = true) then
                        error(txtTransferRcptErr, xRec."Container No.", PostedTransRcpt."No.")
                end;
            end;

        }
        field(2; "Freight Cost"; Decimal)
        {
            Caption = 'Freight Cost';
        }
        field(3; "ETD"; Date)
        {
            Caption = 'Initial Departure';
        }
        field(4; "ETA"; Date)
        {
            Caption = 'Initial Arrival';
        }
        field(5; Forwarder; Code[10])
        {
            TableRelation = "Shipping Agent".code;
        }
        field(7; "Container Size"; Code[20])
        {
            TableRelation = "Container Size".Code;
        }
        field(8; CreatedBy; Code[50])
        {
            TableRelation = User."User Name";
            Caption = 'Created By';
            Editable = false;
        }
        field(9; CreatedDate; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(10; ModifiedBy; Code[50])
        {
            Caption = 'Modified By';
            TableRelation = User."User Name";
            Editable = false;
        }
        field(11; ModifiedDate; Date)
        {
            Caption = 'Modified Date';
            Editable = false;
        }
        field(12; "Port of Discharge"; Code[20])
        {
            TableRelation = "Port of Loading".Port;
        }
        field(13; "Port of Loading"; Code[20])
        {
            TableRelation = "Port of Loading".Port;
        }
        field(14; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(15; "Transfer Order No."; Code[20])
        {
            Editable = false;

        }
        field(16; "Posting Date"; Date)
        {

        }
        field(17; "Status"; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Assigned,Completed';
            OptionMembers = "Open","Assigned","Completed";
            Editable = false;
        }
        field(18; "Container Return Date"; Date)
        {

        }
        field(19; "Freight Bill Amount"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(20; "Freight Bill No."; Code[30])
        {

        }
        field(21; "PO No."; code[20])
        {
            Caption = 'PO No.';
            FieldClass = FlowField;
            CalcFormula = lookup(ContainerLine."Document No." where("Container No." = field("Container No.")));
        }
        field(22; "Empty Notification Date"; Date)
        {

        }
        // PR 12/11/24 - START
        field(23; ActualETD; Date)
        {
            Caption = 'Actual Departure';
        }
        field(24; ActualETA; Date)
        {
            Caption = 'Actual Arrival';
        }
        field(25; "Actual Pull Date"; Date)
        {

        }

        field(26; Carrier; Code[10])
        {
            TableRelation = "TO Carrier".Code;
        }
        field(27; Terminal; Code[50])
        {
            TableRelation = Terminal;
        }
        field(28; Drayage; Code[50])
        {
            TableRelation = Drayage;
        }
        field(29; "Container Status Notes"; Text[300])
        {
            Editable = true;
        }
        field(30; "Actual Pull Time"; Time)
        {
            Editable = true;
        }
        field(31; LFD; Date)
        {
            Editable = true;
        }
        field(32; "Actual Delivery Date"; Date)
        {
            Editable = true;
        }
        // PR 12/11/24 - END
        field(33; "Receiving Status"; code[50])
        {
            Editable = true;
            TableRelation = ReceivingStatus;
        }
        field(34; "Telex Released"; Boolean)
        {
            Editable = false;

        }
        // PR 12/27/24
        field(35; "Transfer-to Code"; Code[10])
        {
            Editable = false;
        }
        //PR 2/17/25 - start

        field(37; "Container CBM"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Size".CBM where(Code = field("Container Size")));
        }
        field(38; "Percentage Threshold"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Size"."Percentage Threshold" where(Code = field("Container Size")));
        }
        //PR 2/17/25 - end
        //PR 2/19/25 - start
        field(39; "Filling Notes"; code[30])
        {
            TableRelation = FillingNotes.code;
        }
        //PR 2/19/25 - end
        //pr 6/20/25 - start
        field(40; "FDA Hold"; Boolean)
        {
            Editable = False;
            trigger OnValidate()
            var
                TransferHeader: Record "Transfer Header";
                TransferLine: Record "Transfer Line";
                InventorySetup: Record "Inventory Setup";
                GenCU: Codeunit GeneralCU;
                bShipped: Boolean;
            begin
                if (rec."FDA Hold" = true) then begin

                    TransferHeader.Reset();
                    TransferHeader.SetRange("No.", rec."Transfer Order No.");
                    if (TransferHeader.FindFirst()) then begin
                        if InventorySetup.Get() then begin
                            GenCU.UpdateTransferToCode(TransferHeader."No.", InventorySetup."FDA Hold Location Code");
                        end;
                    end;
                end
                else if (rec."FDA Hold" = false) then begin
                    TransferHeader.Reset();
                    TransferHeader.SetRange("No.", rec."Transfer Order No.");
                    if (TransferHeader.FindFirst()) then begin
                        // 9/16/25 - take InventorySetup."FDA Hold Location Code" if theres no physical transfer to code - start
                        if (StrLen(TransferHeader."Physical Transfer To Code") = 0) then begin
                            if InventorySetup.Get() then begin
                                GenCU.UpdateTransferToCode(TransferHeader."No.", InventorySetup."FDA Hold Location Code");
                            end;
                        end
                        else begin
                            GenCU.UpdateTransferToCode(TransferHeader."No.", TransferHeader."Physical Transfer To Code");
                        end;
                        // 9/16/25 - take InventorySetup."FDA Hold Location Code" if theres no physical transfer to code - end

                    end;
                end;
            end;
        }
        //pr 6/20/25 - end

    }
    keys
    {
        key(PK; "Container No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Rec.CreatedBy := UserId;
        Rec.CreatedDate := Today;
    end;

    trigger OnModify()
    begin
        Rec.ModifiedBy := UserId;
        Rec.ModifiedDate := Today;
    end;

    trigger OnDelete()
    begin
        if (Rec.Status = Rec.Status::Assigned) or (Rec.Status = Rec.Status::Completed) then
            Error(txtDeleteNotAllowed);
        ContainerLine.reset;
        ContainerLine.SetRange("Container No.", "Container No.");
        If ContainerLine.FindSet() then
            ContainerLine.DeleteAll(true);
    end;

    trigger OnRename()
    var
        ContainerLn: Record ContainerLine;
        ContainerLn2: Record ContainerLine;
        to: page "Transfer Order";
        totbl: Record "Transfer Header";
    begin
        if Rec."Container No." <> xRec."Container No." then begin
            ContainerLn.Reset();
            ContainerLn.SetRange("Container No.", xRec."Container No.");
            if ContainerLn.FindSet() then
                repeat
                    /* IF ContainerLn2.get(xRec."Container No.", ContainerLn."Document No.", ContainerLn."Item No.", ContainerLn.Quantity, ContainerLn."Unit of Measure Code", ContainerLn."Buy-From Vendor No.") then
                         ContainerLn2.RENAME(Rec."Container No.", ContainerLn."Document No.", ContainerLn."Item No.", ContainerLn.Quantity, ContainerLn."Unit of Measure Code", ContainerLn."Buy-From Vendor No.");*/
                    // pr 10/8/24 allow changing container order 
                    ContainerLn.RENAME(Rec."Container No.", ContainerLn.SourceNo, ContainerLn."Document No.", ContainerLn."Document Line No.", ContainerLn."Item No.", ContainerLn."Unit of Measure Code", ContainerLn."Buy-From Vendor No.");
                until ContainerLn.Next() = 0;
        end;
    end;

    var

        ContainerLine: Record ContainerLine;
        txtRcptLineErr: Label 'Corresponding Purchase Receipt %1 has item %2 Qty %3 Greater Than Container Qty %4';
        txtNoRcptFound: Label 'Container Order No. %1 contains Item %2 that has NOT been received yet.  Please review.';
        txtRcptNotFullyReceived: Label 'Container Order No. %1 contains Item %2 that has NOT been FULLY received yet.  Please review.';
        txtDeleteNotAllowed: Label 'Deletion NOT allowed when Status is Assigned or Completed.';
        reservationEntry: record "Reservation Entry";

    procedure GetReceiptLines(InTransferOrderNo: Code[20])
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        TempPurchRcptHeader: Record "Purch. Rcpt. Header" temporary;
        TempPurchRcptLine: Record "Purch. Rcpt. Line" temporary;
        PostedPurchaseReceipts: Page "Posted Purchase Receipts";
        purchHeader: Record "Purchase Header";
        TransferHdr: Record "Transfer Header";
        TransferLine: record "Transfer Line";
        ContainerLine: Record ContainerLine;
        ContainerLine2: Record ContainerLine;
        PurchRcptLin: Record "Purch. Rcpt. Line";
        ContainerLineUpd: Record ContainerLine;
        ContainerHeader: Record "Container Header";
        bPassed: boolean;
        bUpdate: Boolean;
        Accumqty: Decimal;
        DocumentAttachment: Record "Document Attachment";
        DocumentAttachmentFileInsert: Record "Document Attachment";
        purchheaderarch: Record "Purchase Header Archive";
        getPurArchHeader: Record "Purchase Header Archive";
        getPurArchLine: Record "Purchase Line Archive";
        transferHeader: Record "Transfer Header";
        GetPOLine: Record "Purchase Line";
    begin
        If TransferHdr.Get(InTransferOrderNo) then begin
            bPassed := false;
            bUpdate := false;
            //PR 1/21/25 add tranfer lines manually added after creation to contianer - start
            TransferLine.Reset;
            TransferLine.SetRange("Document No.", TransferHdr."No.");
            if (TransferLine.FindFirst()) then
                repeat
                    ContainerLine2.Reset();
                    ContainerLine2.SetRange("Container No.", Rec."Container No.");
                    ContainerLine2.setrange("Location Code", Rec."Location Code");
                    ContainerLine2.SetRange("Item No.", TransferLine."Item No.");
                    ContainerLine2.SetRange("Document No.", TransferLine."Source Document No.");
                    ContainerLine2.SetRange("Document Line No.", TransferLine."Line No.");
                    if (not ContainerLine2.FindFirst()) then begin
                        ContainerLine2.INIT;
                        // adds fieds direclty from transfer line to container line
                        ContainerLine2."Container No." := Rec."Container No.";
                        ContainerLine2."Document No." := TransferLine."Document No.";
                        ContainerLine2."Document Line No." := TransferLine."Line No.";
                        ContainerLine2."Item No." := TransferLine."Item No.";
                        ContainerLine2.Quantity := TransferLine.Quantity;
                        ContainerLine2."Unit of Measure Code" := TransferLine."Unit of Measure Code";
                        ContainerLine2."Quantity Base" := TransferLine."Quantity (Base)";
                        ContainerLine2."Document Line No." := TransferLine."Line No.";
                        ContainerLine2."Location Code" := TransferLine."Transfer-from Code";
                        ContainerLine2."Port of Discharge" := TransferHdr."Port of Discharge";
                        ContainerLine2."Port of Loading" := TransferHdr."Port of Loading";
                        ContainerLine2.SourceNo := Database::"Transfer Line";
                        //7/23/25 - add item description snapshot
                        GetPOLine.Reset();
                        GetPOLine.SetRange("Document Type", GetPOLine."Document Type"::Order);
                        GetPOLine.SetRange("Document No.", TransferLine."PO No.");
                        GetPOLine.SetRange(Type, GetPOLine.Type::Item);
                        GetPOLine.SetRange("No.", TransferLine."Item No.");
                        IF GetPOLine.FindFirst() THEN BEGIN
                            ContainerLine2."Item Description Snapshot" := GetPOLine.Description;
                        END
                        else begin
                            getPurArchHeader.Reset();
                            getPurArchHeader.SetRange("Document Type", getPurArchHeader."Document Type"::Order);
                            getPurArchHeader.SetRange("No.", TransferLine."PO No.");
                            getPurArchHeader.SetCurrentKey("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
                            getPurArchHeader.Ascending(false);
                            if getPurArchHeader.FindFirst() then begin
                                getPurArchLine.Reset();
                                getPurArchLine.SetRange("Document Type", getPurArchLine."Document Type"::Order);
                                getPurArchLine.SetRange("Document No.", TransferLine."PO No.");
                                getPurArchLine.SetRange(Type, getPurArchLine.Type::Item);
                                getPurArchLine.SetRange("No.", TransferLine."Item No.");
                                getPurArchLine.SetRange("Doc. No. Occurrence", getPurArchHeader."Doc. No. Occurrence");
                                getPurArchLine.SetRange("Version No.", getPurArchHeader."Version No.");
                                if getPurArchLine.FindFirst() then begin
                                    ContainerLine2."Item Description Snapshot" := getPurArchLine.Description;
                                end;

                            end;

                        end;
                        //7/23/25 - end of - add item description snapshot
                        ContainerLine2.Insert();
                    end;
                until TransferLine.next() = 0;

            //PR 1/21/25 add tranfer lines manually added after creation to contianer - end
            ContainerLine.Reset();
            ContainerLine.SetRange("Container No.", Rec."Container No.");
            ContainerLine.setrange("Location Code", Rec."Location Code");
            ContainerLine.SetRange(SourceNo, Database::"Purchase Line");

            If ContainerLine.findset then
                repeat
                    bPassed := true;
                    Accumqty := 0;
                    PurchRcptLin.Reset();
                    PurchRcptLin.SetRange("Order No.", ContainerLine."Document No.");
                    PurchRcptLin.SetRange("Order Line No.", ContainerLine."Document Line No.");
                    PurchRcptLin.SetRange(Type, PurchRcptLin.Type::Item);
                    PurchRcptLin.Setrange("No.", ContainerLine."Item No.");
                    PurchRcptLin.SetFilter(Quantity, '<>%1', 0);
                    If Not PurchRcptLin.FindSet() then
                        Error(txtNoRcptFound, ContainerLine."Container No.", ContainerLine."Item No.")
                    else
                        repeat
                            //else, we continue    
                            Accumqty += PurchRcptLin.Quantity;


                        until PurchRcptLin.Next = 0;

                    if Accumqty < ContainerLine.Quantity then
                        Error(STRSUBSTNO(txtRcptNotFullyReceived, PurchRcptLin."Document No.", PurchRcptLin."No.", PurchRcptLin.Quantity, ContainerLine.Quantity));

                    if bPassed = true then begin
                        //now we process receipt found
                        PurchRcptHeader.Reset();
                        PurchRcptHeader.SetRange("No.", PurchRcptLin."Document No.");
                        if PurchRcptHeader.FindFirst() then;
                        TempPurchRcptHeader := PurchRcptHeader;
                        TempPurchRcptLine := PurchRcptLin;

                        CreateTransferLinesFromSelectedReceiptLines(TempPurchRcptLine, TransferHdr, ContainerLine."Document Line No.");

                        Commit();
                        TransferLine.Reset;
                        TransferLine.SetRange("Document No.", TransferHdr."No.");
                        TransferLine.SetRange("Item No.", ContainerLine."Item No.");
                        TransferLine.SetRange("Source Document No.", ContainerLine."Document No.");
                        TransferLine.SetRange("Container Line No.", ContainerLine."Document Line No.");

                        if (TransferLine.FindFirst()) then begin

                            reservationEntry.Reset;
                            reservationEntry.SetRange("Item No.", ContainerLine."Item No.");
                            reservationEntry.SetRange("Source Type", Database::"Transfer Line");
                            reservationEntry.SetRange("Source ID", InTransferOrderNo);
                            reservationEntry.SetRange("Source Ref. No.", TransferLine."Line No.");
                            if (reservationEntry.FindSet()) then begin
                                repeat
                                    if (reservationEntry.Quantity < 0) then
                                        reservationEntry.Validate("Quantity (Base)", ContainerLine."Quantity Base" * -1)
                                    else
                                        reservationEntry.Validate("Quantity (Base)", ContainerLine."Quantity Base");
                                    reservationEntry.Modify();

                                until reservationEntry.next = 0;

                            end;
                            Commit();
                            TransferLine.Validate(Quantity, ContainerLine.Quantity);
                            //pr 11/8/24 - add PO No., PO Owner, Buy From Vendor - start

                            TransferLine."PO No." := ContainerLine."Document No.";
                            TransferLine."PO Vendor" := ContainerLine."Buy-From Vendor No.";
                            purchHeader.Reset();
                            purchHeader.SetRange("No.", PurchRcptHeader."Order No.");
                            purchHeader.SetRange("Document Type", purchHeader."Document Type"::Order);
                            if (purchHeader.FindSet()) then
                                TransferLine."PO Owner" := purchHeader.CreatedUserID
                            else begin
                                purchheaderarch.reset;
                                purchheaderarch.SetCurrentKey("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
                                purchheaderarch.SetRange("No.", PurchRcptHeader."Order No.");
                                purchheaderarch.SetRange("Document Type", purchheaderarch."Document Type"::Order);
                                purchheaderarch.Ascending := FALSE;
                                if purchheaderarch.FindFirst() then
                                    TransferLine."PO Owner" := purchheaderarch.CreatedUserID;
                            end;

                            //pr 11/8/24 - add PO No., PO Owner, Buy From Vendor - end
                            TransferLine.Modify();

                        end;
                        bUpdate := true;
                    end;


                until ContainerLine.Next() = 0

            else begin
                //if no container lines, then just copy container header
                bUpdate := true;
            end;
            if bUpdate = true then begin
                //now copy all information from Container header into Transfer Header
                TransferHdr."Container No." := Rec."Container No.";
                TransferHdr.ContainerSize := Rec."Container Size";
                TransferHdr.ETD := Rec.ETD;
                TransferHdr.ETA := Rec.ETA;
                TransferHdr.Forwarder := Rec.Forwarder;
                TransferHdr."Port of Loading" := Rec."Port of Loading";
                TransferHdr."Port of Discharge" := Rec."Port of Discharge";
                TransferHdr.Modify();



                //if any documents attach, attach to transfer order as well
                //attach documents to new table
                DocumentAttachment.SetRange("No.", Rec."Container No.");
                DocumentAttachment.SetRange("Table ID", Database::"Container Header");
                if DocumentAttachment.FindSet() then
                    repeat
                        //clean up if need be
                        DocumentAttachmentFileInsert.Reset();
                        DocumentAttachmentFileInsert.SetRange("Table ID", Database::"Transfer Header");
                        DocumentAttachmentFileInsert.SetRange("No.", TransferHdr."No.");
                        DocumentAttachmentFileInsert.SetRange("File Name", DocumentAttachment."File Name");
                        if DocumentAttachmentFileInsert.FindFirst() then
                            DocumentAttachmentFileInsert.Delete();

                        DocumentAttachmentFileInsert := DocumentAttachment;
                        DocumentAttachmentFileInsert."Table ID" := Database::"Transfer Header";
                        DocumentAttachmentFileInsert."No." := TransferHdr."No.";
                        DocumentAttachmentFileInsert.Insert();
                    until DocumentAttachment.Next() = 0;

                Rec."Transfer Order No." := TransferHdr."No.";
                Rec.Status := Rec.Status::Assigned;
                Rec.Modify();
            end;




        end;



    end;


    local procedure CreateTransferLinesFromSelectedPurchReceipts(var TempPurchRcptHeader: Record "Purch. Rcpt. Header" temporary; TransferHeader: Record "Transfer Header")
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TempPurchRcptLine: Record "Purch. Rcpt. Line" temporary;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        PostedPurchaseReceiptLines: Page "Posted Purchase Receipt Lines";
        RecRef: RecordRef;
    begin
        Error('You are attempting to call a procedure that has been marked for deletion.  Please contact technical support.');
        RecRef.GetTable(TempPurchRcptHeader);
        PurchRcptLine.SetFilter(
          "Document No.",
          SelectionFilterManagement.GetSelectionFilter(RecRef, TempPurchRcptHeader.FieldNo("No.")));
        PurchRcptLine.SetRange(Type, PurchRcptLine.Type::Item);
        PurchRcptLine.SetRange("Location Code", TransferHeader."Transfer-from Code");
        PostedPurchaseReceiptLines.SetTableView(PurchRcptLine);
        PostedPurchaseReceiptLines.LookupMode := true;
        if PostedPurchaseReceiptLines.RunModal() = ACTION::LookupOK then begin
            PostedPurchaseReceiptLines.GetSelectedRecords(TempPurchRcptLine);
            //CreateTransferLinesFromSelectedReceiptLines(TempPurchRcptLine, TransferHeader);  //mbr 2/19/25- this should include the container Line No as last parameter
            //this will be deleted after further testing
        end;
    end;

    local procedure CreateTransferLinesFromSelectedReceiptLines(var PurchRcptLine: Record "Purch. Rcpt. Line"; TransferHeader: Record "Transfer Header"; ContainerLineNo: Integer)
    var
        TransferLine: Record "Transfer Line";
        LineNo: Integer;
    begin
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        if TransferLine.FindLast() then;
        LineNo := TransferLine."Line No.";
        LineNo := LineNo + 10000;
        AddTransferLineFromReceiptLine(PurchRcptLine, LineNo, TransferHeader, ContainerLineNo);
    end;

    local procedure AddTransferLineFromReceiptLine(PurchRcptLine: Record "Purch. Rcpt. Line"; LineNo: Integer; TransferHeader: Record "Transfer Header"; ContainerLineNo: Integer)
    var
        TransferLine: Record "Transfer Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        TransferLine."Document No." := TransferHeader."No.";
        TransferLine."Line No." := LineNo;
        TransferLine.Validate("Item No.", PurchRcptLine."No.");
        TransferLine.Validate("Variant Code", PurchRcptLine."Variant Code");
        TransferLine.Validate(Quantity, PurchRcptLine.Quantity);
        TransferLine.Validate("Unit of Measure Code", PurchRcptLine."Unit of Measure Code");
        TransferLine."Shortcut Dimension 1 Code" := PurchRcptLine."Shortcut Dimension 1 Code";
        TransferLine."Shortcut Dimension 2 Code" := PurchRcptLine."Shortcut Dimension 2 Code";
        TransferLine."Dimension Set ID" := PurchRcptLine."Dimension Set ID";
        TransferLine."Source Document No." := PurchRcptLine."Order No.";
        TransferLine."Container Line No." := ContainerLineNo;

        TransferLine.Insert(true);

        PurchRcptLine.FilterPstdDocLnItemLedgEntries(ItemLedgerEntry);
        ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempItemLedgerEntry, ItemLedgerEntry);
        ItemTrackingMgt.CopyItemLedgEntryTrkgToTransferLine(TempItemLedgerEntry, TransferLine);


    end;
    //PR 2/17/24 - calc total CBM - start
    procedure GetTotalCBM() ReturnValue: Decimal
    var
        ContainerLn: Record ContainerLine;
        totalCBM: Decimal;
    begin
        totalCBM := 0;
        ContainerLn.reset;
        ContainerLn.SetRange("Container No.", Rec."Container No.");
        If ContainerLn.FindSet() then
            repeat
                totalCBM += (ContainerLn.GetPackageCount() * ContainerLn.GetDimensionM());
            until ContainerLn.next() = 0;
        ReturnValue := totalCBM;

    end;
    //PR 2/17/24 - calc total CBM - end

    //PR 2/24/25 - cacl total weight - start
    procedure GetTotalWeight() ReturnValue: Decimal
    var
        ContainerLn: Record ContainerLine;
        totlaWeight: Decimal;
    begin
        totlaWeight := 0;
        ContainerLn.reset;
        ContainerLn.SetRange("Container No.", Rec."Container No.");
        If ContainerLn.FindSet() then
            repeat
                ContainerLn.CalcFields("M-Pack Weight kg");
                totlaWeight += (ContainerLn.GetPackageCount() * ContainerLn."M-Pack Weight kg");

            until ContainerLn.next() = 0;
        ReturnValue := totlaWeight;

    end;
    //PR 2/24/25 - cacl total weight - end
    procedure GetUserNameFromSecurityId(UserSecurityID: Guid): Code[50]
    var
        User: Record User;
    begin
        IF User.Get(UserSecurityID) then
            exit(User."User Name");
    end;
    //pr 6/20/25 - get FDA Hold status - start
    procedure UpdateFDAHoldStatus()
    var
        ContainerLn: Record ContainerLine;
        TransferHeader: Record "Transfer Header";
    begin
        Rec."FDA Hold" := false;
        ContainerLn.reset;
        ContainerLn.SetRange("Container No.", Rec."Container No.");
        If ContainerLn.FindSet() then
            repeat
                if (ContainerLn."FDA Hold" = true) then begin
                    Rec.Validate("FDA Hold", true);
                end;
            until ContainerLn.next() = 0;
        Rec.Modify();
    end;
    //PR 6/20/25 - get FDA Hold status - end

}
