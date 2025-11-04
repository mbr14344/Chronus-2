codeunit 50002 GeneralCU
{
    Permissions = tabledata "Transfer Shipment Header" = RIMD, tabledata "Transfer Shipment Line" = RIMD, tabledata "Reservation Entry" = RIMD;

    procedure CreateSSCC(DocumentNo: Code[20]; InItemNo: Code[20]; InCustNo: Code[20]): Code[20]
    var
        cartonInfo: Record CartonInformation;
        FinCode: Text;
        isUnique: Boolean;
    begin
        isUnique := false;
        while (isUnique = false) DO begin
            //check against Sales Line
            FinCode := CreateGs128SSCC2(InItemNo, InCustNo);
            if (FinCode <> '') then begin

                cartonInfo.Reset();
                cartonInfo.SetRange("Document No.", DocumentNo);
                cartonInfo.SetRange("Document Type", SalesLine."Document Type"::Order);
                cartonInfo.SetRange("Serial No.", FinCode);
                if (not cartonInfo.FindFirst()) then begin
                    isUnique := true;
                    EXIT(FinCode);
                end

            end;

        end;




    end;
    //mbr 07/24/24
    //CreateGs128SSCC2 - this procedure is the replacement for the original CreateGs128SSCC
    //whereby we just removed the inclusion of item numbers when creating SSCC code as sometimes
    //item numbers can be lengthy and there's not enough digits to create random numbers.
    procedure CreateGs128SSCC2(InItemNo: Code[20]; InCustNo: Code[20]): Code[20]
    var
        Item: Record Item;
        GetGS1SCCPrefix: Code[20];
        MidPart: Code[10];
        ItemNoLen: Integer;
        Digits: Integer;
        i: Integer;
        Arr1: array[30] of Integer;
        Arr2: array[30] of Integer;
        bAlt: Boolean;
        FinCode: Text;
        Val: Integer;
        MaxNum: Integer;
        CheckDig: Integer;
        NextMult10: Integer;
        GetItem: text;
        MidPartSize: Integer;
        GetRandomNum: bigInteger;
        totalCount: Integer;
        Customer: Record Customer;
        salesLine: Record "Sales Line";
    begin
        IF NOT Item.GET(InItemNo) THEN
            ERROR('Item %1 Not Found!', InItemNo);

        CLEAR(GetGS1SCCPrefix);
        CLEAR(MidPart);
        CLEAR(Digits);
        CLEAR(FinCode);
        CLEAR(ItemNoLen);
        CLEAR(GetItem);
        CLEAR(MidPartSize);
        CLEAR(GetRandomNum);
        FOR i := 1 TO STRLEN(InItemNo) DO BEGIN
            IF EVALUATE(Val, COPYSTR(InItemNo, i, 1)) THEN BEGIN
                ItemNoLen += 1;
                GetItem := GetItem + COPYSTR(InItemNo, i, 1);
            END;
        END;

        IF Not Customer.Get(InCustNo) then
            ERROR('Customer %1 NOT Found!', InCustNo)
        ELSE
            GetGS1SCCPrefix := Customer.GS1SCCPrefix;

        IF STRLEN(GetGS1SCCPrefix) = 0 THEN
            ERROR('Customer %1 needs to be set up with GS1SCC Prefix.', InCustNo);


        //Now, we are ready to create the GS1-128 SSCC code with check digit
        Digits := 18;

        MidPartSize := Digits - STRLEN(GetGS1SCCPrefix) - 1;
        if MidPartSize <= 0 then  //we cannot have MidPartSize = 0;
            MidPartSize := Digits - STRLEN(GetGS1SCCPrefix) - 1;

        EVALUATE(GetRandomNum, COPYSTR(DELCHR(CREATEGUID(), '=', '{}-ABCDEFGHIJKLMNOPQRSTUVWXYZ'), 1, MidPartSize));
        GetRandomNum := (GetRandomNum MOD 2147483646) + 1;
        MidPart := FORMAT(GetRandomNum);
        MidPart := COPYSTR(MidPart, 1, MidPartSize);



        //Let's calculate check digit.  We will use the Modulo 10 technique: 2 Arrays => Digits and weight
        bAlt := TRUE;
        MaxNum := Digits - 1;
        FOR i := MaxNum DOWNTO 1 DO BEGIN
            IF bAlt = TRUE THEN BEGIN
                Arr1[i] := 3;
                bAlt := FALSE;
            END
            ELSE BEGIN
                Arr1[i] := 1;
                bAlt := TRUE;
            END;
        END;

        //Adjust MidPart
        IF (STRLEN(GetGS1SCCPrefix) + STRLEN(MidPart) + 1) <> Digits THEN BEGIN
            FOR i := 1 TO (Digits - (STRLEN(GetGS1SCCPrefix) + STRLEN(MidPart) + 1)) DO BEGIN
                MidPart := '0' + MidPart;
            END;
        END;

        FinCode := GetGS1SCCPrefix + MidPart;
        //we need to make sure FinCode is 17 digits only
        if strlen(FinCode) > 17 then begin
            FinCode := GetGS1SCCPrefix + MidPart;
            FinCode := COPYSTR(FinCode, 1, 17);
            if StrLen(FinCode) < 17 then
                FinCode := FinCode + CopyStr(GetItem, 1, 17 - StrLen(FinCode));
        end;


        FOR i := 1 TO MaxNum DO BEGIN
            IF EVALUATE(Val, COPYSTR(FinCode, i, 1)) = TRUE THEN
                Arr2[i] := Val;
        END;

        CLEAR(CheckDig);
        FOR i := 1 TO MaxNum DO BEGIN
            CheckDig := CheckDig + (Arr1[i] * Arr2[i]);
        END;

        NextMult10 := CheckDig + (10 - CheckDig MOD 10);
        CheckDig := NextMult10 - CheckDig;
        IF CheckDig = 10 THEN
            CheckDig := 0;



        FinCode := FinCode + FORMAT(CheckDig);

        EXIT(FinCode);
    end;

    procedure CreateGs128SSCC(InItemNo: Code[20]; InCustNo: Code[20]): Code[20]
    var
        Item: Record Item;
        GetGS1SCCPrefix: Code[20];
        MidPart: Code[10];
        ItemNoLen: Integer;
        Digits: Integer;
        i: Integer;
        Arr1: array[30] of Integer;
        Arr2: array[30] of Integer;
        bAlt: Boolean;
        FinCode: Text;
        Val: Integer;
        MaxNum: Integer;
        CheckDig: Integer;
        NextMult10: Integer;
        GetItem: text;
        MidPartSize: Integer;
        GetRandomNum: bigInteger;
        Customer: Record Customer;
    begin
        IF NOT Item.GET(InItemNo) THEN
            ERROR('Item %1 Not Found!', InItemNo);

        CLEAR(GetGS1SCCPrefix);
        CLEAR(MidPart);
        CLEAR(Digits);
        CLEAR(FinCode);
        CLEAR(ItemNoLen);
        CLEAR(GetItem);
        CLEAR(MidPartSize);
        CLEAR(GetRandomNum);
        FOR i := 1 TO STRLEN(InItemNo) DO BEGIN
            IF EVALUATE(Val, COPYSTR(InItemNo, i, 1)) THEN BEGIN
                ItemNoLen += 1;
                GetItem := GetItem + COPYSTR(InItemNo, i, 1);
            END;
        END;

        IF Not Customer.Get(InCustNo) then
            ERROR('Customer %1 NOT Found!', InCustNo)
        ELSE
            GetGS1SCCPrefix := Customer.GS1SCCPrefix;

        IF STRLEN(GetGS1SCCPrefix) = 0 THEN
            ERROR('Customer %1 needs to be set up with GS1SCC Prefix.', InCustNo);


        //Now, we are ready to create the GS1-128 SSCC code with check digit
        Digits := 18;

        MidPartSize := Digits - STRLEN(GetGS1SCCPrefix) - ItemNoLen - 1;
        if MidPartSize <= 0 then  //we cannot have MidPartSize = 0;
            MidPartSize := Digits - STRLEN(GetGS1SCCPrefix) - 1;

        EVALUATE(GetRandomNum, COPYSTR(DELCHR(CREATEGUID(), '=', '{}-ABCDEFGHIJKLMNOPQRSTUVWXYZ'), 1, MidPartSize));
        GetRandomNum := (GetRandomNum MOD 2147483646) + 1;
        MidPart := FORMAT(GetRandomNum);
        MidPart := COPYSTR(MidPart, 1, MidPartSize);



        //Let's calculate check digit.  We will use the Modulo 10 technique: 2 Arrays => Digits and weight
        bAlt := TRUE;
        MaxNum := Digits - 1;
        FOR i := MaxNum DOWNTO 1 DO BEGIN
            IF bAlt = TRUE THEN BEGIN
                Arr1[i] := 3;
                bAlt := FALSE;
            END
            ELSE BEGIN
                Arr1[i] := 1;
                bAlt := TRUE;
            END;
        END;

        //Adjust MidPart
        IF (STRLEN(GetGS1SCCPrefix) + STRLEN(MidPart) + STRLEN(GetItem) + 1) <> Digits THEN BEGIN
            FOR i := 1 TO (Digits - (STRLEN(GetGS1SCCPrefix) + STRLEN(MidPart) + STRLEN(GetItem) + 1)) DO BEGIN
                MidPart := '0' + MidPart;
            END;
        END;


        FinCode := GetGS1SCCPrefix + MidPart + GetItem;
        //we need to make sure FinCode is 17 digits only
        if strlen(FinCode) > 17 then begin
            FinCode := GetGS1SCCPrefix + MidPart;
            if StrLen(FinCode) < 17 then
                FinCode := FinCode + CopyStr(GetItem, 1, 17 - StrLen(FinCode));
        end;


        FOR i := 1 TO MaxNum DO BEGIN
            IF EVALUATE(Val, COPYSTR(FinCode, i, 1)) = TRUE THEN
                Arr2[i] := Val;
        END;

        CLEAR(CheckDig);
        FOR i := 1 TO MaxNum DO BEGIN
            CheckDig := CheckDig + (Arr1[i] * Arr2[i]);
        END;

        NextMult10 := CheckDig + (10 - CheckDig MOD 10);
        CheckDig := NextMult10 - CheckDig;
        IF CheckDig = 10 THEN
            CheckDig := 0;



        FinCode := FinCode + FORMAT(CheckDig);

        EXIT(FinCode);
    end;

    /*  mbr 2/12/24 - below eventsubscriber is not needed at this time.  commented out for now. 
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeGetReservationQty', '', true, true)]
    local procedure OnBeforeGetReservationQty(var IsHandled: Boolean; var QtyReserved: Decimal; var QtyReservedBase: Decimal; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal; var Result: Decimal; var SalesLine: Record "Sales Line")
    begin

        SalesLine.CalcFields("Reserved Qty. (Base)", "Reserved Quantity");

    end;
*/

    /* mbr 2/12/24 - use this eventsubscriber to auto create item line tracking as well as auto remove package information if cancelled */
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterGetReservationQty', '', true, true)]
    local procedure OnAfterGetReservationQty(var SalesLine: Record "Sales Line"; var QtyToReserve: Decimal; var QtyToReserveBase: Decimal; var Result: Decimal)
    var
        ResEntry: Record "Reservation Entry";
        GetResEntry: Record "Reservation Entry";
        Item: Record Item;
        CartonInfo: Record CartonInformation;
        UserSetup: Record "User Setup";

    begin
        SalesLine.CalcFields("Reserved Qty. (Base)");
        IF (SalesLine."Document Type" = SalesLine."Document Type"::Order) and (SalesLine.Type = SalesLine.Type::Item) then begin
            if (SalesLine."Reserved Qty. (Base)" > 0) then begin
                ResEntry.RESET;
                ResEntry.SetRange("Source Type", Database::"Sales Line");
                ResEntry.SetRange("Location Code", SalesLine."Location Code");
                ResEntry.SetRange("Reservation Status", ResEntry."Reservation Status"::Reservation);
                ResEntry.SetRange("Source ID", SalesLine."Document No.");
                ResEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
                ResEntry.SetRange("Item No.", SalesLine."No.");
                IF ResEntry.findset then
                    repeat
                        If Item.Get(ResEntry."Item No.") then;
                        IF Strlen(Item."Item Tracking Code") > 0 then begin
                            GetResEntry.Reset();
                            GetResEntry.SetRange("Entry No.", ResEntry."Entry No.");
                            GetResEntry.SetRange(Positive, true);
                            GetResEntry.SetRange("Location Code", ResEntry."Location Code");
                            GetResEntry.SetRange("Reservation Status", GetResEntry."Reservation Status"::Reservation);
                            GetResEntry.SetRange("Item No.", ResEntry."Item No.");
                            GetResEntry.SetRange("Quantity (Base)", ResEntry."Quantity (Base)" * -1);
                            IF GetResEntry.FindFirst() then begin
                                //3/15/24 - MBR - undo  the check for source type - Allow Users to reserve from PO
                                //IF GetResEntry."Source Type" <> Database::"Item Ledger Entry" then
                                //    Error('At this time, We are not allowing reservations from sources other than Item Ledger Entry.  Please review Reservation Source.');
                                //11/7/24 - MBR - check for source type - transfer lines  - DO NOT Allow Users to reserve from PO and TO, unless they have finance Admin permission
                                //6/2/25 - MBR - reactivated the strict policy of not allowing users to reserve from PO and/or TOs unless Finance Admin.
                                IF GetResEntry."Source Type" = Database::"Transfer Line" then begin
                                    UserSetup.RESET;
                                    UserSetup.SetRange("User ID", UserId);
                                    UserSetup.SetRange(FinanceAdmin, true);
                                    IF Not UserSetup.FindFirst() then
                                        Error('At this time, We are not allowing reservations from Transfer Orders.  Please review Reservation Source.')
                                    else
                                        Message('Usually, we do not allow reservations from Transfer Orders.  However due to your Finance Admin permission, we are overriding this rule.');
                                end
                                else IF GetResEntry."Source Type" = Database::"Purchase Line" then begin
                                    UserSetup.RESET;
                                    UserSetup.SetRange("User ID", UserId);
                                    UserSetup.SetRange(FinanceAdmin, true);
                                    IF Not UserSetup.FindFirst() then
                                        Error('At this time, We are not allowing reservations from Purchase Orders.  Please review Reservation Source.')
                                    else
                                        Message('Usually, we do not allow reservations from Purchase Orders.  However due to your Finance Admin permission, we are overriding this rule.');
                                end;
                                //11/7/24 - MBR  - end


                            end;
                            //mbr 9/6/2024 - when reserving from ILE and item  is not available yet, which means Lot No is blank (cannot be selected), message users that Item Tracking cannot be done
                            IF GetResEntry."Item Tracking" <> GetResEntry."Item Tracking"::"Lot No." then begin
                                IF GetResEntry."Source Type" = Database::"Item Ledger Entry" then
                                    IF GetResEntry.
                                    "Lot No." = '' then
                                        Error('The Item quantity you reserved from Item Ledger Entries does not have an assigned Lot No.  Please contact your Item Ledger Entry Administrator.')
                            end;
                            //mbr 9/6/2024 - end
                            // IF (GetResEntry."Source Type" = Database::"Purchase Line") AND (GetResEntry."Lot No." = '') then
                            //     Message('The Item quantity you reserved from Purchase Order(s) is NOT available for Item Tracking Selection yet.  Item Tracking CANNOT be assigned at this time.')
                            // else begin
                            //     ResEntry."Item Tracking" := GetResEntry."Item Tracking";
                            //     ResEntry."Lot No." := GetResEntry."Lot No.";
                            //     ResEntry."Expiration Date" := GetResEntry."Expiration Date";
                            //    ResEntry.Modify();
                            // end;


                        end;
                    until ResEntry.Next = 0;
            end
        end;
    end;
    /* mbr 2/12/24 - end  */

    procedure PrintCheckNoStub(var NewGenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        ReportSelections: Record "Report Selections";
        IsPrinted: Boolean;
    begin
        IsPrinted := false;
        OnBeforePrintCheckProcedure(NewGenJnlLine, GenJnlLine, IsPrinted);
        if IsPrinted then
            exit;

        GenJnlLine.Copy(NewGenJnlLine);
        // GenJnlLine.OnCheckGenJournalLinePrintCheckRestrictions();
        IsPrinted := false;
        OnBeforePrintCheck(GenJnlLine, IsPrinted);
        if IsPrinted then
            exit;

        ReportSelections.PrintReport(ReportSelections.Usage::"JQ", GenJnlLine);  //mbr 2/16/24 - we will use JQ (Job Quote) to store report ID to use
    end;

    //8/22/25 - start
    procedure PrintFreestyleCheck(var NewGenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        ReportSelections: Record "Report Selections";
        IsPrinted: Boolean;
    begin
        IsPrinted := false;
        OnBeforePrintCheckProcedure(NewGenJnlLine, GenJnlLine, IsPrinted);
        if IsPrinted then
            exit;

        GenJnlLine.Copy(NewGenJnlLine);
        // GenJnlLine.OnCheckGenJournalLinePrintCheckRestrictions();
        IsPrinted := false;
        OnBeforePrintCheck(GenJnlLine, IsPrinted);
        if IsPrinted then
            exit;

        ReportSelections.PrintReport(ReportSelections.Usage::"JQ", GenJnlLine);  //mbr 2/16/24 - we will use JQ (Job Quote) to store report ID to use
    end;
    //8/22/25 - end

    [IntegrationEvent(false, false)]
    local procedure OnBeforePrintCheckProcedure(var NewGenJnlLine: Record "Gen. Journal Line"; var GenJournalLine: Record "Gen. Journal Line"; var IsPrinted: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePrintCheck(var GenJournalLine: Record "Gen. Journal Line"; var IsPrinted: Boolean)
    begin
    end;

    //mbr 3/22/24 - create eventsubscriber that will copy comment from gen. journal line into VLE and/or CLE
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeVendLedgEntryInsert', '', true, true)]
    local procedure "Gen. Jnl.-Post Line_OnBeforeVendLedgEntryInsert"
        (
            var VendorLedgerEntry: Record "Vendor Ledger Entry";
            GenJournalLine: Record "Gen. Journal Line";
            GLRegister: Record "G/L Register"
        )
    begin
        VendorLedgerEntry.Comment := GenJournalLine.Comment;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCustLedgEntryInsert', '', true, true)]
    local procedure "Gen. Jnl.-Post Line_OnBeforeCustLedgEntryInsert"
(
    var CustLedgerEntry: Record "Cust. Ledger Entry";
    GenJournalLine: Record "Gen. Journal Line";
    GLRegister: Record "G/L Register"
)
    begin
        CustLedgerEntry.Comment := GenJournalLine.Comment;
    end;
    //mbr 3/22/24 - create eventsubscriber end







    //mbr 3/28/24 - Create Subscriber onInsert of Purchase Header
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeOnInsert', '', true, true)]
    local procedure OnBeforeOnInsert
(
var
    PurchaseHeader: Record "Purchase Header";
    IsHandled: boolean
)
    begin
        If (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) or (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) then
            PurchaseHeader."Assigned User ID" := UserId;

    end;
    //mbr 3/28/24 - End - Create Subscriber onInsert of Purchase Header


    //mbr 5/30/24 - Procedure to allow update of Transfer-To Code in Transfer Order once shipped;
    procedure UpdateTransferToCode(DocumentNo: Code[20]; InTransferToCode: Code[10])
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        TransferShipmentLine: Record "Transfer Shipment Line";
        Location: Record Location;
        LocationRef: Record Location;
        PhysLocationRef: Record Location;
        ReservationEntry: Record "Reservation Entry";
        oldTransferToCode: Code[10];
        InventorySetup: Record "Inventory Setup";
    begin
        if TransferHeader.Get(DocumentNo) then begin

            if Location.Get(InTransferToCode) and (TransferHeader."Transfer-to Code" <> InTransferToCode) then begin
                //8/19/25 - start 
                oldTransferToCode := TransferHeader."Transfer-to Code";
                PhysLocationRef.Reset();
                PhysLocationRef.SetRange("Code", oldTransferToCode);
                PhysLocationRef.SetRange("Allow Physical Transfer", true);
                LocationRef.Reset();
                LocationRef.SetRange("Code", InTransferToCode);
                LocationRef.SetRange("Allow Physical Transfer", false);
                if (PhysLocationRef.FindSet() and LocationRef.FindSet()) then begin
                    TransferHeader."Physical Transfer To Code" := '';
                end;
                //8/19/25 - end
                //8/26/25 - check if chaned to FDAHold if so copy old value into "Physical Transfer To Code" - start
                if InventorySetup.Get() then begin
                    if (InTransferToCode = InventorySetup."FDA Hold Location Code") then begin
                        TransferHeader."Physical Transfer To Code" := oldTransferToCode;
                    end;
                end;
                //8/26/25 - check if chaned to FDAHold if so copy old value into "Physical Transfer To Code" - end


                TransferHeader."Transfer-to Code" := InTransferToCode;
                TransferHeader."Transfer-to Name" := Location.Name;
                TransferHeader."Transfer-to Name 2" := Location."Name 2";
                TransferHeader."Transfer-to Address" := Location.Address;
                TransferHeader."Transfer-to Address 2" := Location."Address 2";
                TransferHeader."Transfer-to Post Code" := Location."Post Code";
                TransferHeader."Transfer-to City" := Location.City;
                TransferHeader."Transfer-to County" := Location.County;
                TransferHeader."Trsf.-to Country/Region Code" := Location."Country/Region Code";
                TransferHeader."Transfer-to Contact" := Location.Contact;
                TransferHeader.Modify();

                //Update TransLine
                TransferLine.Reset;
                TransferLine.SetRange("Document No.", TransferHeader."No.");
                if TransferLine.FindSet() then
                    repeat
                        TransferLine."Transfer-to Code" := InTransferToCode;
                        TransferLine.Modify();
                    until TransferLine.Next() = 0;

                //Update Corresponding Transfer Shipment
                TransferShipmentHeader.Reset();
                TransferShipmentHeader.SetRange("Transfer Order No.", DocumentNo);
                IF TransferShipmentHeader.FindFirst() then begin
                    TransferShipmentHeader."Transfer-to Code" := TransferHeader."Transfer-to Code";
                    TransferShipmentHeader."Transfer-to Name" := TransferHeader."Transfer-to Name";
                    TransferShipmentHeader."Transfer-to Name 2" := TransferHeader."Transfer-to Name 2";
                    TransferShipmentHeader."Transfer-to Address" := TransferHeader."Transfer-to Address";
                    TransferShipmentHeader."Transfer-to Address 2" := TransferHeader."Transfer-to Address 2";
                    TransferShipmentHeader."Transfer-to Post Code" := TransferHeader."Transfer-to Post Code";
                    TransferShipmentHeader."Transfer-to City" := TransferHeader."Transfer-to City";
                    TransferShipmentHeader."Transfer-to County" := TransferHeader."Transfer-to County";
                    TransferShipmentHeader."Trsf.-to Country/Region Code" := TransferHeader."Trsf.-to Country/Region Code";
                    TransferShipmentHeader."Transfer-to Contact" := TransferHeader."Transfer-to Contact";
                    TransferShipmentHeader.Modify();

                    TransferShipmentLine.Reset();
                    TransferShipmentLine.SetRange("Document No.", TransferShipmentHeader."No.");
                    IF TransferShipmentLine.FindSet() then
                        repeat
                            TransferShipmentLine."Transfer-to Code" := TransferHeader."Transfer-to Code";
                            TransferShipmentLine.Modify();
                        until TransferShipmentLine.Next = 0;
                end;


                //Update Reservation Entry
                ReservationEntry.Reset();
                ReservationEntry.SetRange("Source ID", TransferHeader."No.");
                ReservationEntry.SetRange("Source Type", Database::"Transfer Line");
                if ReservationEntry.FindSet() then
                    repeat
                        ReservationEntry."Location Code" := InTransferToCode;
                        ReservationEntry.Modify();
                    until ReservationEntry.Next() = 0;

            end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post (Yes/No)", 'OnAfterPost', '', false, false)]

    local procedure OnAfterPost(var TransHeader: Record "Transfer Header"; Selection: Option " ",Shipment,Receipt)
    begin
        if Selection = Selection::Receipt then begin
            ContainerHdr.Reset();
            ContainerHdr.SetRange("Transfer Order No.", TransHeader."No.");
            If ContainerHdr.FindFirst() then begin
                PostedTransferRcpt.Reset();
                PostedTransferRcpt.SetRange("Transfer Order No.", TransHeader."No.");
                PostedTransferRcpt.SetRange("Posting Date", TransHeader."Posting Date");
                if PostedTransferRcpt.FindFirst() then begin
                    PostedTransferRcptLn.Reset();
                    PostedTransferRcptLn.SetRange("Document No.", PostedTransferRcpt."No.");
                    PostedTransferRcptLn.SetRange("Transfer Order No.", TransHeader."No.");
                    If PostedTransferRcptLn.FindSet() then
                        repeat
                            ContainerLn.Reset();
                            ContainerLn.SetRange("Container No.", ContainerHdr."Container No.");
                            ContainerLn.SetRange("Item No.", PostedTransferRcptLn."Item No.");
                            If ContainerLn.FindFirst() then begin
                                ContainerLn."Transfer Receipt No." := PostedTransferRcpt."No.";
                                ContainerLn.Modify();
                            end;
                        until PostedTransferRcptLn.Next() = 0;
                    ChkTransferHeader.Reset();
                    ChkTransferHeader.SetRange("No.", TransHeader."No.");
                    If not ChkTransferHeader.FindFirst() then begin
                        ContainerHdr.Status := ContainerHdr.Status::Completed;
                        ContainerHdr.Modify(true);
                    end;
                end;

            end;
        end;
    end;

    //mbr 5/7/25 - start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt (Yes/No)", 'OnBeforeConfirmWhseReceiptPost', '', false, false)]
    local procedure OnBeforeConfirmWhseReceiptPost(var WhseReceiptLine: Record "Warehouse Receipt Line"; var HideDialog: Boolean; var IsPosted: Boolean)
    var
        PurchLines: Record "Purchase Line";
        ItemTrackingLines: Record "Tracking Specification" temporary;
        Item: Record Item;
        txtExpDtMandatory: Label 'Item %1 Lot %2 is set up with valid Expiration Date MANDATORY.  Please goto Item Tracking Lines and enter Expiration Date.';
        ReservationEntry: Record "Reservation Entry";
    begin
        //mbr 5/7/25 - start - Make sure Users enter Expiration Date if applicable
        if WhseReceiptLine."Qty. to Receive" > 0 then begin
            PurchLines.Reset();
            PurchLines.SetRange("Document No.", WhseReceiptLine."Source No.");
            PurchLines.SetRange("Document Type", PurchLines."Document Type"::Order);
            PurchLines.SetRange("Line No.", WhseReceiptLine."Source Line No.");
            PurchLines.SetRange(Type, PurchLines.Type::Item);
            PurchLines.SetRange("No.", WhseReceiptLine."Item No.");
            if (PurchLines.FindSet()) then
                repeat
                    Item.Reset();
                    item.SetRange("No.", PurchLines."No.");
                    item.SetRange("Expiration Date Mandatory", true);
                    if (item.FindSet()) then begin
                        ReservationEntry.Reset();
                        ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
                        ReservationEntry.SetRange("Source ID", PurchLines."Document No.");
                        ReservationEntry.SetRange("Source Ref. No.", PurchLines."Line No.");
                        ReservationEntry.SetRange("Item No.", PurchLines."No.");
                        ReservationEntry.SetRange("Location Code", PurchLines."Location Code");
                        If ReservationEntry.FindSet() then
                            repeat
                                If ReservationEntry."Expiration Date" = 0D then
                                    Error(StrSubstNo(txtExpDtMandatory, ReservationEntry."Item No.", ReservationEntry."Lot No."));
                            until ReservationEntry.Next() = 0;
                    end;
                until PurchLines.Next() = 0;
        end;

        //mbr 5/7/25 - end
    end;
    //mbr 5/7/25 - end
    //pr 4/24/25 - start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt (Yes/No)", 'OnAfterWhsePostReceiptRun', '', false, false)]

    local procedure OnAfterWhsePostReceiptRun(var WhseReceiptLine: Record "Warehouse Receipt Line"; WhsePostReceipt: Codeunit "Whse.-Post Receipt")
    var
        TransHeader: Record "Transfer Header";
        PostedTransferRcptRef: Record "Transfer Receipt Header";
    begin
        PostedTransferRcptRef.Reset();
        PostedTransferRcptRef.SetRange("Transfer Order No.", WhseReceiptLine."Source No.");
        if (PostedTransferRcptRef.FindSet()) then begin
            ContainerHdr.Reset();
            ContainerHdr.SetRange("Transfer Order No.", PostedTransferRcptRef."Transfer Order No.");
            If ContainerHdr.FindFirst() then begin
                PostedTransferRcpt.Reset();
                PostedTransferRcpt.SetRange("Transfer Order No.", PostedTransferRcptRef."Transfer Order No.");
                PostedTransferRcpt.SetRange("Posting Date", PostedTransferRcptRef."Posting Date");
                if PostedTransferRcpt.FindFirst() then begin
                    PostedTransferRcptLn.Reset();
                    PostedTransferRcptLn.SetRange("Document No.", PostedTransferRcpt."No.");
                    PostedTransferRcptLn.SetRange("Transfer Order No.", PostedTransferRcptRef."Transfer Order No.");
                    If PostedTransferRcptLn.FindSet() then
                        repeat
                            ContainerLn.Reset();
                            ContainerLn.SetRange("Container No.", ContainerHdr."Container No.");
                            ContainerLn.SetRange("Item No.", PostedTransferRcptLn."Item No.");
                            If ContainerLn.FindFirst() then begin
                                ContainerLn."Transfer Receipt No." := PostedTransferRcpt."No.";
                                ContainerLn.Modify();
                            end;
                        until PostedTransferRcptLn.Next() = 0;
                    ChkTransferHeader.Reset();
                    ChkTransferHeader.SetRange("No.", PostedTransferRcptRef."Transfer Order No.");
                    If not ChkTransferHeader.FindFirst() then begin
                        ContainerHdr.Status := ContainerHdr.Status::Completed;
                        ContainerHdr.Modify(true);
                    end;
                end;

            end;
        end;
    end;
    //pr 4/24/25 - end

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]

    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry.Internal := GenJournalLine.Internal;   //mbr 6/27/24 - copy Internal boolean value from Gen Journal to Cust. Ledger Entry

    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]

    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry.Internal := GenJournalLine.Internal;   //mbr 6/27/24 - copy Internal boolean value from Gen Journal to Vendor Ledger Entry

    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]

    local procedure OnAfterConfirmPost(var PurchaseHeader: Record "Purchase Header")
    var
        PurchLines: Record "Purchase Line";
        Item: Record Item;
        txtExpDtMandatory: Label 'Item %1 Lot %2 is set up with valid Expiration Date MANDATORY.  Please goto Item Tracking Lines and enter Expiration Date.';
        Location: Record Location;
        ReservationEntry: record "Reservation Entry";
    begin
        //Pr 5/1/25 - if receiving check the item tracking lines for each of the item where item.Mandatory Exp Date is TURNED ON.  
        // If ON, then expiration date has to be entered - start
        if (PurchaseHeader.Receive) then begin
            PurchLines.Reset();
            PurchLines.SetRange("Document No.", PurchaseHeader."No.");
            PurchLines.SetRange("Document Type", PurchaseHeader."Document Type");
            PurchLines.SetRange(Type, PurchLines.Type::Item);
            PurchLines.SetFilter("Qty. to Receive", '>%1', 0);
            if (PurchLines.FindSet()) then
                repeat
                    If Location.Get(PurchLines."Location Code") then;
                    If Location."Require Receive" = false then begin
                        Item.Reset();
                        item.SetRange("No.", PurchLines."No.");
                        item.SetRange("Expiration Date Mandatory", true);
                        if (item.FindSet()) then begin
                            ReservationEntry.Reset();
                            ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
                            ReservationEntry.SetRange("Source ID", PurchLines."Document No.");
                            ReservationEntry.SetRange("Source Ref. No.", PurchLines."Line No.");
                            ReservationEntry.SetRange("Item No.", PurchLines."No.");
                            ReservationEntry.SetRange("Location Code", PurchLines."Location Code");
                            If ReservationEntry.FindSet() then
                                repeat
                                    If ReservationEntry."Expiration Date" = 0D then
                                        Error(StrSubstNo(txtExpDtMandatory, ReservationEntry."Item No.", ReservationEntry."Lot No."));
                                until ReservationEntry.Next() = 0;
                        end;
                    end;

                until PurchLines.Next() = 0;
        end;
        //Pr 5/1/25 - if receiving check the item tracking lines for each of the item where item.Mandatory Exp Date is TURNED ON.  
        // If ON, then expiration date has to be entered - end

        //mbr 8/2/24 - let's populate the verified by and Verified date in Purchase Header so these can be carried over to Purchase Invoice;
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then begin
            PurchaseHeader.VerifiedBy := UserId;
            PurchaseHeader.VerifiedDate := PurchaseHeader."Posting Date";
            PurchaseHeader.Modify();
        end;
    end;

    // pr 8/16/24 - added support for attaching documents and keeps track of # of attachments - start
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        TransferHeader: Record "Transfer Header";
        TransferReceiptHeader: Record "Transfer Receipt Header";
        ContainerHeader: Record "Container Header";
        PostedContainerHeader: Record "Posted Container Header";
        TransShipmentHeader: Record "Transfer Shipment Header";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemJournalLine: Record "Item Journal Line";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Transfer Header":
                begin
                    RecRef.Open(DATABASE::"Transfer Header");
                    if TransferHeader.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(TransferHeader);
                end;
            DATABASE::"Transfer Receipt Header":
                begin
                    RecRef.Open(DATABASE::"Transfer Receipt Header");
                    if TransferReceiptHeader.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(TransferReceiptHeader);
                end;
            DATABASE::"Transfer Shipment Header":
                begin
                    RecRef.Open(DATABASE::"Transfer Shipment Header");
                    if TransShipmentHeader.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(TransShipmentHeader);
                end;
            DATABASE::"Container Header":
                begin
                    RecRef.Open(DATABASE::"Container Header");
                    if ContainerHeader.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(ContainerHeader);
                end;
            DATABASE::"Posted Container Header":
                begin
                    RecRef.Open(DATABASE::"Posted Container Header");
                    if PostedContainerHeader.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(PostedContainerHeader);
                end;
            DATABASE::"Item Ledger Entry":
                begin
                    RecRef.Open(DATABASE::"Item Ledger Entry");
                    //ItemLedgerEntry.Reset();
                    // ItemLedgerEntry.SetRange("Entry No.", DocumentAttachment."Line No.");
                    //  ItemLedgerEntry.SetRange("Line No.", DocumentAttachment."Line No.");
                    // if ItemLedgerEntry.FindFirst() then
                    if ItemLedgerEntry.Get(DocumentAttachment."Line No.") then
                        RecRef.GetTable(ItemLedgerEntry);
                end;
            DATABASE::"Item Journal Line":
                begin
                    RecRef.Open(DATABASE::"Item Journal Line");
                    ItemJournalLine.Reset();
                    // ItemLedgerEntry.SetRange("Entry No.", DocumentAttachment."No.");
                    ItemJournalLine.SetRange("Line No.", DocumentAttachment."Line No.");
                    if ItemJournalLine.FindFirst() then
                        //if ItemJournalLine.Get(DocumentAttachment."Line No.") then
                        RecRef.GetTable(ItemJournalLine);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        RecLineNo: Integer;
    begin
        case RecRef.Number of
            DATABASE::"Transfer Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            DATABASE::"Transfer Receipt Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            DATABASE::"Transfer Shipment Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            DATABASE::"Container Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            DATABASE::"Posted Container Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            DATABASE::"Item Ledger Entry":
                begin
                    FieldRef := RecRef.Field(1);
                    RecLineNo := FieldRef.Value;
                    DocumentAttachment.SetRange("Line No.", RecLineNo);
                end;
            DATABASE::"Item Journal Line":
                begin
                    FieldRef := RecRef.Field(2);
                    RecLineNo := FieldRef.Value;
                    DocumentAttachment.SetRange("Line No.", RecLineNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        RecLineNo: Integer;
    begin
        case RecRef.Number of
            DATABASE::"Transfer Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            DATABASE::"Transfer Receipt Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            DATABASE::"Transfer Shipment Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            DATABASE::"Container Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            DATABASE::"Posted Container Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            DATABASE::"Item Ledger Entry":
                begin
                    FieldRef := RecRef.Field(1);
                    RecLineNo := FieldRef.Value;
                    DocumentAttachment.Validate("Line No.", RecLineNo);
                end;
            DATABASE::"Item Journal Line":
                begin
                    FieldRef := RecRef.Field(2);
                    RecLineNo := FieldRef.Value;
                    DocumentAttachment.Validate("Line No.", RecLineNo);
                end;
        end;
    end;
    // pr 8/16/24 - added support for attaching documents and keeps track of # of attachments - end

    //mbr 8/16/24 - on transfer order post, carry over docs to Transfer Receipt Header
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterTransferOrderPostReceipt', '', true, true)]
    local procedure "TransferOrder-Post Receipt_OnAfterTransferOrderPostReceipt"
       (
           var TransferHeader: Record "Transfer Header";
           CommitIsSuppressed: Boolean;
           var TransferReceiptHeader: Record "Transfer Receipt Header"
       )
    var
        DocumentAttachment: Record "Document Attachment";
        DocumentAttachmentFileInsert: Record "Document Attachment";
    begin
        DocumentAttachment.SetRange("No.", TransferHeader."No.");
        DocumentAttachment.SetRange("Table ID", Database::"Transfer Header");
        if DocumentAttachment.FindSet() then
            repeat
                DocumentAttachmentFileInsert := DocumentAttachment;
                DocumentAttachmentFileInsert."Table ID" := Database::"Transfer Receipt Header";
                DocumentAttachmentFileInsert."No." := TransferReceiptHeader."No.";
                DocumentAttachmentFileInsert.Insert();
            until DocumentAttachment.Next() = 0;
        //Copy over fields from Transfer Header 
        TransferReceiptHeader.ActualDeliveryDate := TransferHeader.ActualDeliveryDate;
        TransferReceiptHeader."Telex Released" := TransferHeader."Telex Released";
        TransferReceiptHeader."Container No." := TransferHeader."Container No.";
        TransferReceiptHeader.ContainerSize := TransferHeader.ContainerSize;
        TransferReceiptHeader.Forwarder := TransferHeader.Forwarder;
        TransferReceiptHeader."Port of Discharge" := TransferHeader."Port of Discharge";
        TransferReceiptHeader."Port of Loading" := TransferHeader."Port of Loading";
        TransferReceiptHeader.Carrier := TransferHeader.Carrier;
        TransferReceiptHeader."Pier Pass" := TransferHeader."Pier Pass";
        TransferReceiptHeader.LFD := TransferHeader.LFD;
        TransferReceiptHeader."Actual Pull Date" := TransferHeader."Actual Pull Date";
        TransferReceiptHeader."Actual Pull Time" := TransferHeader."Actual Pull Time";
        TransferReceiptHeader.Terminal := TransferHeader.Terminal;
        TransferReceiptHeader.ActualETD := TransferHeader.ActualETD;
        TransferReceiptHeader.ActualETA := TransferHeader.ActualETA;
        TransferReceiptHeader.Urgent := TransferHeader.Urgent;
        //PR 3/10/25 - start
        TransferReceiptHeader.Notes := TransferHeader.Notes;
        //PR 3/10/25 - end
        //mbr 3/25/25 - start
        TransferReceiptHeader."944 Receipt No." := TransferHeader."944 Receipt No.";
        TransferReceiptHeader."944 Load No." := TransferHeader."944 Load No.";
        TransferReceiptHeader."944 Received Date" := TransferHeader."944 Received Date";
        //mbr 03/25/25 - end
        //8/26/25 - start
        TransferReceiptHeader."Allow Physical Transfer" := TransferHeader."Allow Physical Transfer";
        TransferReceiptHeader."Physical Transfer To Code" := TransferHeader."Physical Transfer To Code";
        // 8/26/25 - end
        TransferReceiptHeader.Modify();
    end;
    //mbr 8/16/24 - end - on transfer order post, carry over docs to Transfer Receipt Header

    //mbr 8/16/24 - on transfer order post ship, carry over docs to Transfer shipment Header
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterTransferOrderPostShipment', '', false, false)]
    local procedure "TransferOrder-Post Shipment_OnAfterTransferOrderPostShipment"
       (
           var TransferHeader: Record "Transfer Header";
           CommitIsSuppressed: Boolean;
           var TransferShipmentHeader: Record "Transfer Shipment Header"
       )
    var
        DocumentAttachment: Record "Document Attachment";
        DocumentAttachmentFileInsert: Record "Document Attachment";
    begin
        DocumentAttachment.SetRange("No.", TransferHeader."No.");
        DocumentAttachment.SetRange("Table ID", Database::"Transfer Header");
        if DocumentAttachment.FindSet() then
            repeat
                DocumentAttachmentFileInsert := DocumentAttachment;
                DocumentAttachmentFileInsert."Table ID" := Database::"Transfer Shipment Header";
                DocumentAttachmentFileInsert."No." := TransferShipmentHeader."No.";
                DocumentAttachmentFileInsert.Insert();
            until DocumentAttachment.Next() = 0;
        //Copy over fields from Transfer Header 
        TransferShipmentHeader.ActualDeliveryDate := TransferHeader.ActualDeliveryDate;
        TransferShipmentHeader."Telex Released" := TransferHeader."Telex Released";
        TransferShipmentHeader."Container No." := TransferHeader."Container No.";
        TransferShipmentHeader.ContainerSize := TransferHeader.ContainerSize;
        TransferShipmentHeader.Forwarder := TransferHeader.Forwarder;
        TransferShipmentHeader."Port of Discharge" := TransferHeader."Port of Discharge";
        TransferShipmentHeader."Port of Loading" := TransferHeader."Port of Loading";
        TransferShipmentHeader.Carrier := TransferHeader.Carrier;
        TransferShipmentHeader."Pier Pass" := TransferHeader."Pier Pass";
        TransferShipmentHeader.LFD := TransferHeader.LFD;
        TransferShipmentHeader."Actual Pull Date" := TransferHeader."Actual Pull Date";
        TransferShipmentHeader."Actual Pull Time" := TransferHeader."Actual Pull Time";
        TransferShipmentHeader.Terminal := TransferHeader.Terminal;
        TransferShipmentHeader.ActualETD := TransferHeader.ActualETD;
        TransferShipmentHeader.ActualETA := TransferHeader.ActualETA;
        TransferShipmentHeader.Urgent := TransferHeader.Urgent;
        //PR 3/10/25 - start
        TransferShipmentHeader.Notes := TransferHeader.Notes;
        //PR 3/10/25 - end
        //mbr 3/25/25 - start
        TransferShipmentHeader."944 Receipt No." := TransferHeader."944 Receipt No.";
        TransferShipmentHeader."944 Load No." := TransferHeader."944 Load No.";
        TransferShipmentHeader."944 Received Date" := TransferHeader."944 Received Date";
        //mbr 03/25/25 - end
        //8/26/25 - start
        TransferShipmentHeader."Allow Physical Transfer" := TransferHeader."Allow Physical Transfer";
        TransferShipmentHeader."Physical Transfer To Code" := TransferHeader."Physical Transfer To Code";
        // 8/26/25 - end
        TransferShipmentHeader.Modify();
    end;
    //6/20/25 - start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeOnRun', '', false, false)]
    local procedure OnBeforeOnRun(var TransferHeader: Record "Transfer Header"; var HideValidationDialog: Boolean; var SuppressCommit: Boolean; var IsHandled: Boolean)
    var
        ContainerHdr: Record "Container Header";
        Contianerline: Record ContainerLine;
        TransferLine: Record "Transfer Line";
        txtFDAErr: label 'This item/lot Item No: %1, Lot No: %2 is on FDA Hold and cannot be shipped.';
    begin
        TransferLine.Reset();
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        if (TransferLine.FindSet()) then
            repeat
                Contianerline.Reset();
                Contianerline.SetRange("Item No.", TransferLine."Item No.");
                Contianerline.GetLotNo();
                //Contianerline.SetRange("Lot No.", TransferLine."Lot No.");
                if (Contianerline.FindSet()) then
                    repeat
                        if (Contianerline."FDA Hold" = true) and (Contianerline."Lot No." = TransferLine."Lot No.") then
                            error(txtFDAErr, Contianerline."Item No.", Contianerline."Lot No.");
                    until Contianerline.Next() = 0;

            until TransferLine.Next() = 0;

    end;
    //6/20/25 - end


    procedure AutoEmailInventoryPlanReport(var startDate: Date; Mode: integer)
    var
        userSetup: Record "User Setup";
        reportToSend: Report InventoryAvailabilityPlanExt;
        email: Codeunit Email;
        emailMessage: Codeunit "Email Message";
        tempBlob: Codeunit "Temp Blob";
        inStr: InStream;
        outStr: OutStream;
        default: DateFormula;
        periodLength: DateFormula;
        List1: List of [Text];
        HTMLText: Text;
        InventorySetup: Record "Inventory Setup";
        count: Integer;
        salesReportParams: Text;
        bSend: boolean;
        Company: Record "Company Information";
    begin
        count := 0;
        bSend := false;
        //auto-send email if applicable
        Clear(reportToSend);
        Evaluate(periodLength, '<2W>');
        reportToSend.InitializeRequest(startDate, periodLength, false);
        //reportToSend.Run();
        // if report has one or more entry
        // if (reportToSend.GetCounter() > 0) then begin
        Clear(List1);

        //create recipients;
        userSetup.Reset();
        Case Mode of
            1:
                userSetup.SetRange(InventoryPlanRecipient, true);
            2:
                userSetup.SetRange(InventoryPlanRecipientExcl, true);
        End;

        if (userSetup.FindSet()) then
            repeat
                if (List1.Contains(userSetup."E-Mail") = false) then begin
                    List1.add(userSetup."E-Mail");
                    bSend := true;
                end;
            until userSetup.Next() = 0;
        if bSend = true then begin
            if InventorySetup.Get() then;
            if Company.Get() then;
            tempBlob.CreateOutStream(outStr);
            reportToSend.SaveAs(salesReportParams, ReportFormat::Excel, outStr);
            count := reportToSend.GetCounter();
            if count > 0 then begin
                tempBlob.CreateInStream(inStr);
                emailMessage.Create(List1, StrSubstNo(InventorySetup.InventoryPlanEmailSubject, Company.Name), StrSubstNo(InventorySetup.InventoryPlanEmailBody,
                 Format(startDate), Format(periodLength), Company.Name, Format(count)), true);

                emailMessage.AddAttachment('InventoryAvailabilityPlan_From' + ConvertStr(Format(startDate), '/', '_') + '.xlsx', 'XLSX', inStr);

                email.Send(emailMessage, Enum::"Email Scenario"::Default);
            end;


        end;


    end;

    //  end;
    //mbr 8/16/24 - end - on transfer order post, carry over docs to Transfer Shipment Header

    //mbr 9/4/24 - auto send Reconcile AP to GL if there are any values in AP to GL
    procedure AutoEmailAPToGL()
    var
        userSetup: Record "User Setup";
        reportToSend: Report "Reconcile AP to GL";
        email: Codeunit Email;
        emailMessage: Codeunit "Email Message";
        tempBlob: Codeunit "Temp Blob";
        inStr: InStream;
        outStr: OutStream;
        default: DateFormula;
        periodLength: DateFormula;
        List1: List of [Text];
        HTMLText: Text;
        PurchPaySetup: Record "Purchases & Payables Setup";
        count: Integer;
        salesReportParams: Text;
        bSend: boolean;
        Company: Record "Company Information";
    begin
        count := 0;
        bSend := false;
        //auto-send email if applicable
        Clear(reportToSend);



        Clear(List1);

        //create recipients;
        userSetup.Reset();
        userSetup.SetRange(APRecipient, true);
        if (userSetup.FindSet()) then
            repeat
                if (List1.Contains(userSetup."E-Mail") = false) then begin
                    List1.add(userSetup."E-Mail");
                    bSend := true;
                end;
            until userSetup.Next() = 0;
        if bSend = true then begin
            if PurchPaySetup.Get() then;
            if Company.Get() then;
            tempBlob.CreateOutStream(outStr);
            reportToSend.SaveAs(salesReportParams, ReportFormat::Excel, outStr);
            count := reportToSend.ChkNoRecords();
            if count > 0 then begin
                tempBlob.CreateInStream(inStr);
                emailMessage.Create(List1, StrSubstNo(PurchPaySetup.APToGLEmailSubject, Company.Name), StrSubstNo(PurchPaySetup.APToGLEmailBody,
                 Format(Today), Format(count), Company.Name), true);

                emailMessage.AddAttachment('ReconcileAPToGL_' + ConvertStr(Format(Today), '/', '_') + '.xlsx', 'XLSX', inStr);

                email.Send(emailMessage, Enum::"Email Scenario"::Default);
            end;


        end;

    end;
    //mbr 9/4/24 - end

    //7/25/25 - auto send an email to inform PO Admin users of FDA Hold - start
    procedure AutoEmailFDA(type: Boolean)
    var
        userSetup: Record "User Setup";
        reportToSend: Report FDANotice;
        email: Codeunit Email;
        emailMessage: Codeunit "Email Message";
        tempBlob: Codeunit "Temp Blob";
        inStr: InStream;
        outStr: OutStream;
        default: DateFormula;
        periodLength: DateFormula;
        List1: List of [Text];
        HTMLText: Text;
        Subject: Text;
        Body: Text;
        count: Integer;
        salesReportParams: Text;
        bSend: boolean;
        Company: Record "Company Information";
        holdBody: Label 'Attached, please find the FDA Hold Report as of %1. There were %2 Container Lines that were put on FDA Hold.<br><br>';
        releaseBody: Label 'Attached, please find the FDA Release Report as of %1. %2 Container Line(s) <b>FDA RELEASED</b>.<br><br> Please make sure to move inventory out of the FDA Hold Location.</br></br>';
        holdFileName: Label 'FDAHold_';
        releaseFileName: Label 'FDARelease_';
        fileName: Text;
        footer: Label 'Ashtel Studios Inc. Business Central Auto Email<br> NOTE: PLEASE DO NOT REPLY TO THIS MESSAGE. THIS EMAIL IS AN AUTOMATED NOTIFICATION.';
        ContainerLine: Record ContainerLine;
        ContainerHdrRef: Record "Container Header";
        ContainerHdrsTmp: Record TmpTable temporary;
        containerCount: Integer;

    begin
        count := 0;
        bSend := false;
        if (type) then begin
            Subject := holdSubject;
            Body := holdBody;
            fileName := holdFileName;

            ContainerLine.reset();
            ContainerLine.SetRange("FDA Hold", true);
            ContainerLine.SetRange(FDAHoldEmailNotifiSentDate, 0D);
        end else begin
            Subject := releaseSubject;
            Body := releaseBody;
            fileName := releaseFileName;
            ContainerLine.reset();
            ContainerLine.SetRange("FDA Hold", false);
            ContainerLine.SetRange(FDAReleasedEmailNotifiSentDate, 0D);
            ContainerLine.SetFilter("FDA Released Date", '<>%1', 0D);
        end;
        if ContainerLine.findset() then
            Count := ContainerLine.Count();

        if Count > 0 then begin
            //auto-send email if applicable
            Clear(reportToSend);

            reportToSend.InitializeRequest(type);
            Clear(List1);

            userSetup.Reset();
            userSetup.SetRange(POAdmin, true);
            if (userSetup.FindSet()) then
                repeat
                    if (userSetup."E-Mail" <> '') and (List1.Contains(userSetup."E-Mail") = false) then begin
                        List1.add(userSetup."E-Mail");
                        bSend := true;
                    end;
                until userSetup.Next() = 0;

            if bSend = true then begin


                if Company.Get() then;
                tempBlob.CreateOutStream(outStr);
                reportToSend.SaveAs(salesReportParams, ReportFormat::Excel, outStr);


                // makes subject and email
                Subject := GetSubject(type);
                emailMessage.Create(List1, Subject, StrSubstNo(Body, Format(Today), count) + '<br><br>' + footer, true);
                tempBlob.CreateInStream(inStr);
                emailMessage.AddAttachment(fileName + ConvertStr(Format(Today), '/', '_') + '.xlsx', 'XLSX', inStr);
                email.Send(emailMessage, Enum::"Email Scenario"::Default);

                //Now update the Container Line
                ContainerLine.FindFirst();
                repeat
                    if (type = true) and (ContainerLine."FDA Hold" = true) then
                        ContainerLine.FDAHoldEmailNotifiSentDate := Today
                    else if (ContainerLine."FDA Hold" = false) and (type = false) then
                        ContainerLine.FDAReleasedEmailNotifiSentDate := Today;
                    ContainerLine.Modify();
                until ContainerLine.Next() = 0;



            end;
        end;


    end;
    //7/25/25 - auto send an email to inform PO Admin users of FDA Hold - end
    //8/26/25 - start
    procedure GetSubject(Type: Boolean): Text[250]
    var
        seperator: Text[10];
        index: Integer;
        subjectLength: Integer;
        subject: Text[250];
        SubjectTitle: Text;
        ContainerHdrRef: Record "Container Header";
        ContainerHdrsTmp: Record TmpTable temporary;
        containerCount: Integer;
        ContainerLine: Record ContainerLine;
    begin
        // Finds all unique container no
        containerCount := 0;
        if (Type) then begin
            Subject := holdSubject;

            ContainerLine.reset();
            ContainerLine.SetRange("FDA Hold", true);
            ContainerLine.SetRange(FDAHoldEmailNotifiSentDate, 0D);
            SubjectTitle := holdSubjectTitle;

        end else begin
            Subject := releaseSubject;
            SubjectTitle := releaseSubjectTitle;
            ContainerLine.reset();
            ContainerLine.SetRange("FDA Hold", false);
            ContainerLine.SetRange(FDAReleasedEmailNotifiSentDate, 0D);
            ContainerLine.SetFilter("FDA Released Date", '<>%1', 0D);
        end;
        if (ContainerLine.FindSet()) then begin
            repeat
                subject := '';
                ContainerHdrRef.Reset();
                ContainerHdrRef.SetRange("Container No.", ContainerLine."Container No.");
                if (ContainerHdrRef.FindFirst()) then begin
                    ContainerHdrsTmp.Reset();
                    ContainerHdrsTmp.SetRange("Code", ContainerHdrRef."Container No.");
                    if (ContainerHdrsTmp.FindSet() = false) then begin
                        ContainerHdrsTmp.Init();
                        ContainerHdrsTmp."Code" := ContainerHdrRef."Container No.";
                        ContainerHdrsTmp."Entry No." := containerCount;
                        ContainerHdrsTmp.Insert();
                        containerCount += 1;
                    end;
                end;
            until ContainerLine.Next() = 0;
            // combines container no for subject
            subjectLength := 250 - StrLen(SubjectTitle) + 3;
            index := 0;
            ContainerHdrsTmp.Reset();
            if (ContainerHdrsTmp.FindFirst()) then begin

            end;
            if (ContainerHdrsTmp.FindSet()) then
                repeat
                    if (index = 0) then
                        seperator := ''
                    else if (index >= (containerCount - 1)) then
                        seperator := ' and '
                    else
                        seperator := ', ';
                    subject += seperator + ContainerHdrsTmp."Code";
                    index += 1;
                until ContainerHdrsTmp.Next() = 0;
            if (StrLen(subject) <= subjectLength) then
                // restrict subject length
                subject := CopyStr(subject, 1, subjectLength)
            else begin
                subject := CopyStr(subject, 1, subjectLength - 3);
                subject := subject + '...';
            end;
            subject := subject + ' - ' + SubjectTitle;
        end;
        exit(subject);
    end;
    //8/26/25 - end

    //mbr 9/26/24 - Allow users to modify Comment in Customer ledger entry table.  This is our custom field
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Cust. Entry-Edit", 'OnBeforeCustLedgEntryModify', '', false, false)]
    local procedure "Cust. Entry-Edit_OnBeforeCustLedgEntryModify"(var CustLedgEntry: Record "Cust. Ledger Entry"; FromCustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry.Comment := FromCustLedgEntry.Comment;
    end;
    //mbr 9/26/24  - end

    //mbr 9/26/24 - Allow users to modify Comment in Vendor ledger entry table.  This is our custom field
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Templ. Mgt.", 'OnApplyTemplateOnBeforeItemModify', '', false, false)]
    local procedure "Item Templ. Mgt._OnApplyTemplateOnBeforeItemModify"(var Item: Record Item; ItemTempl: Record "Item Templ."; var IsHandled: Boolean; UpdateExistingValues: Boolean)
    begin
        Item.TemplateApplied := true;   //mbr 11/8/24 - set up the TemplateApplied to true;
    end;

    //pr 11/15/24 change default error for create Whse. Receipt
    /*
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnBeforeShowReceiptDialog', '', false, false)]
    local procedure "Get Source Documents-ActivitiesCreated"(var IsHandled: Boolean; ErrorOccured: Boolean; ActivitiesCreated: Integer; LineCreated: Boolean)
    var
        SpecialHandlingMessage: Text[1024];
        ErrorNoLinesToCreate: ErrorInfo;
        "Purchase Header": Record "Purchase Header";
        WhseReceiptLine: Record "Warehouse Receipt Line";

        NoNewReceiptLinesForPurchaseOrderErr: Label 'This usually happens when warehouse receipt lines have already been created for a purchase order. Or if there were no changes to the purchase order quantities since you last created the warehouse receipt lines.';
        NoNewReceiptLinesForPurchaseReturnErr: Label 'This usually happens when warehouse receipt lines have already been created for a purchase return order. Or if there were no changes to the purchase return order quantities since you last created the warehouse receipt lines.';
        Text007Err: Label 'There are no new warehouse receipt lines to create';
        ShowOpenLinesTxt: Label 'Show open lines';
    begin
        //  VendLedgEntry.Comment := 
        if IsHandled then
            exit;

        if not LineCreated then begin
            ErrorNoLinesToCreate.Title := Text007Err;
            "Get Source Documents".GetLastPurchaseHeader("Purchase Header");

            if "Purchase Header"."Document Type" = "Purchase Header"."Document Type"::Order then
                ErrorNoLinesToCreate.Message := NoNewReceiptLinesForPurchaseOrderErr
            else
                ErrorNoLinesToCreate.Message := NoNewReceiptLinesForPurchaseReturnErr;
            // ErrorNoLinesToCreate.PageNo := Page::"Whse. Receipt Lines";
            // ErrorNoLinesToCreate.CustomDimensions.Add('Source Type', Format(Database::"Purchase Line"));
            // ErrorNoLinesToCreate.CustomDimensions.Add('Source Subtype', Format("Purchase Header"."Document Type"));
            //ErrorNoLinesToCreate.CustomDimensions.Add('Source No.', Format("Purchase Header"."No."));
            //ErrorNoLinesToCreate.AddAction(ShowOpenLinesTxt, 5753, 'ReturnListofPurchaseReceipts', ShowOpenReceiptLinesTooltipTxt);
            WhseReceiptLine.Reset();
            WhseReceiptLine.SetRange("Source No.", "Purchase Header"."No.");
            if WhseReceiptLine.FindFirst() then begin
                ErrorNoLinesToCreate.RecordId(WhseReceiptLine.RecordId());
                Error(ErrorNoLinesToCreate);
            end else
                Error('test');

        end;
    end;
    */

    //pr 11/5/24 - Allow users to modify Comment in Vendor ledger entry table.  This is our custom field
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Vend. Entry-Edit", 'OnBeforeVendLedgEntryModify', '', false, false)]
    local procedure "Vend. Entry-Edit_OnBeforeCustLedgEntryModify"(var VendLedgEntry: Record "Vendor Ledger Entry"; FromVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry.Comment := FromVendLedgEntry.Comment;
    end;

    //PR 3/27/35 - Release of Sales Order, go through each sales line to check for sales price=0, error out or allow override if FInance Admin - start
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforePerformManualRelease', '', false, false)]
    local procedure "CheckForSalesPrice_PerformManualRelease"(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        SalesLine: Record "Sales Line";
        txtNoUnitPrice: Label 'Item %1 has NO unit price set up for Sales Order %2.';
        txtTaskAborted: Label 'Task Aborted';
        txtOverrideNoPrice: Label 'Item %1 has NO unit price set up for Sales Order %2.  Do you want to override this business rule?';
        TxtZeroUnitPriceErr: Label 'Sales Line %1 has 0 Unit Price.';
        item: Record Item;
        salesPrice: Record "Sales Price";
        UserSetup: Record "User Setup";
    begin
        //mbr 6/13/25 - only be strict for Sales Orders
        If SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            if (SalesLine.FindSet()) then
                repeat
                    if item.GET(SalesLine."No.") then
                        if item.Type = item.Type::Inventory then begin
                            if SalesLine."Unit Price" = 0 then begin
                                UserSetup.Reset();
                                UserSetup.SetRange("User ID", UserId);
                                UserSetup.SetRange(FinanceAdmin, true);
                                if (UserSetup.FindFirst()) then begin
                                    if Dialog.Confirm(StrSubstNo(txtOverrideNoPrice, item."No.", SalesLine."Document No.")) = false then
                                        Error(TxtZeroUnitPriceErr);
                                end
                                else
                                    Error(txtNoUnitPrice, item."No.", SalesLine."Document No.");
                            end;

                        end;

                until SalesLine.Next() = 0;
        end;
        //mbr 6/13/25 - end
    end;
    //PR 3/27/35 - Release of Sales Order, go through each sales line to check for sales price - end


    //mbr 11/15/24 - run this if we want to make necessary mods before Create Receipt from Transfer Order is run
    procedure CreateWhseRequest(TransferHeader: Record "Transfer Header")
    var
        location: Record Location;
        WhseRequest: record "Warehouse Request";
        NewWhseRequest: Record "Warehouse Request";
    begin
        //Check to see if Destination location requires receipt
        location.Reset();
        location.SetRange(Code, TransferHeader."Transfer-to Code");
        location.SetRange("Require Receive", true);
        if location.FindFirst() then begin
            //if transfer-to code required receipt, make sure we have Warehouse Request.  If not create it.
            WhseRequest.Reset();
            WhseRequest.SetRange("Source Type", Database::"Transfer Line");
            WhseRequest.SetRange("Source No.", TransferHeader."No.");
            WhseRequest.SetRange(Type, WhseRequest.Type::Inbound);
            If Not WhseRequest.FindFirst() then begin
                NewWhseRequest.Init();
                NewWhseRequest.Type := NewWhseRequest.type::Inbound;
                NewWhseRequest."Location Code" := TransferHeader."Transfer-to Code";
                NewWhseRequest."Source Type" := Database::"Transfer Line";
                NewWhseRequest."Source Subtype" := 1;
                NewWhseRequest."Source No." := TransferHeader."No.";
                NewWhseRequest."Source Document" := NewWhseRequest."Source Document"::"Inbound Transfer";
                NewWhseRequest."Document Status" := TransferHeader.Status;
                NewWhseRequest."Shipping Advice" := TransferHeader."Shipping Advice";
                NewWhseRequest."Destination Type" := NewWhseRequest."Destination Type"::Location;
                NewWhseRequest."Destination No." := TransferHeader."Transfer-to Code";
                NewWhseRequest."External Document No." := TransferHeader."External Document No.";
                NewWhseRequest."Expected Receipt Date" := TransferHeader."Receipt Date";
                NewWhseRequest.Insert();
            end;
        end;


    end;

    var
        "Get Source Documents": Report "Get Source Documents";

    // pr 10/15/24 
    /*[EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Reference Management", 'OnAfterSalesItemItemRefNotFound', '', false, false)]
    local procedure "SalesLine-OnValidateSalesReferenceNoOnAfterAssignNo"(var SalesLine: Record "Sales Line"; var ItemReference: Record "Item Reference"; var Found: Boolean)
    begin

    end;*/

    /*//mbr 9/26/24 - Allow users to modify Comment in Vendor ledger entry table.  This is our custom field
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Reference Management", 'OnValidateSalesReferenceNoOnAfterAssignNo', '', false, false)]
    local procedure "SalesLine-OnValidateSalesReferenceNoOnAfterAssignNo"(var SalesLine: Record "Sales Line"; ReturnedItemReference: Record "Item Reference")
    var
        genCU: Codeunit "Item Reference Management";
        returnedItemReference2: Record "Item Reference";
        IsHandled: Boolean;
        salesHeader: Record "Sales Header";
    begin
        IsHandled := false;
        // genCU.OnBeforeValidateSalesReferenceNo(SalesLine, ItemReference, SearchItem, CurrentFieldNo, IsHandled);
        if IsHandled then
            exit;

        ReturnedItemReference.Init();
        if SalesLine."Item Reference No." <> '' then begin
            ReturnedItemReference.Reset();
            ReturnedItemReference.SetRange("Reference No.", SalesLine."Item Reference No.");
            salesHeader := SalesLine.GetSalesHeader();

            ReturnedItemReference.SetFilter("Starting Date", '>=%1', salesHeader.CreatedDate);
            //if true then
            //ReferenceLookupSalesItem(SalesLine, ReturnedItemReference, CurrentFieldNo <> 0);
             else
                 ReturnedItemReference := ItemReference;

            //   OnValidateSalesReferenceNoOnBeforeAssignNo(SalesLine, ReturnedItemReference);
            if SalesLine."No." <> ReturnedItemReference."Item No." then
                SalesLine.Validate("No.", ReturnedItemReference."Item No.");
            if ReturnedItemReference."Variant Code" <> '' then
                SalesLine.Validate("Variant Code", ReturnedItemReference."Variant Code");
            if ReturnedItemReference."Unit of Measure" <> '' then
                SalesLine.Validate("Unit of Measure Code", ReturnedItemReference."Unit of Measure");
            //  OnValidateSalesReferenceNoOnAfterAssignNo(SalesLine, ReturnedItemReference);
        end;

        SalesLine."Item Reference Unit of Measure" := ReturnedItemReference."Unit of Measure";
        SalesLine."Item Reference Type" := ReturnedItemReference."Reference Type";
        SalesLine."Item Reference Type No." := ReturnedItemReference."Reference Type No.";
        SalesLine."Item Reference No." := ReturnedItemReference."Reference No.";

        if (ReturnedItemReference.Description <> '') or (ReturnedItemReference."Description 2" <> '') then begin
            SalesLine.Description := ReturnedItemReference.Description;
            SalesLine."Description 2" := ReturnedItemReference."Description 2";
        end;

        SalesLine.UpdateUnitPrice(SalesLine.FieldNo("Item Reference No."));
        SalesLine.UpdateICPartner();
    end;*/

    //mbr 10/4/24 - auto send email if SO DC Breakdown exists
    procedure AutoEmailSODCBreakdown()
    var
        userSetup: Record "User Setup";
        email: Codeunit Email;
        emailMessage: Codeunit "Email Message";
        tempBlob: Codeunit "Temp Blob";
        inStr: InStream;
        outStr: OutStream;
        default: DateFormula;
        periodLength: DateFormula;
        List1: List of [Text];
        HTMLText: Text;
        SRSetup: Record "Sales & Receivables Setup";
        count: Integer;
        salesReportParams: Text;
        bSend: boolean;
        Company: Record "Company Information";
        SalesHdr: Record "Sales Header";
        CheckSalesHdr: Record "Sales Header";
        ChkExtDoc: Code[35];
    begin
        count := 0;
        bSend := false;
        //auto-send email if applicable
        Clear(List1);

        //create recipients;
        userSetup.Reset();
        userSetup.SetRange(SODCBreakdownRecipient, true);
        if (userSetup.FindSet()) then
            repeat
                if (List1.Contains(userSetup."E-Mail") = false) then begin
                    List1.add(userSetup."E-Mail");
                    bSend := true;
                end;
            until userSetup.Next() = 0;
        if bSend = true then begin
            SalesHdr.Reset();
            SalesHdr.SetRange(Master, true);
            IF SalesHdr.FindSet() then
                repeat
                    ChkExtDoc := '';
                    CheckSalesHdr.Reset();
                    CheckSalesHdr.SetRange(Master, false);
                    CheckSalesHdr.SetRange("Sell-to Customer No.", SalesHdr."Sell-to Customer No.");

                    IF StrPos(SalesHdr."External Document No.", 'MASTER') > 0 then
                        ChkExtDoc := CopyStr(SalesHdr."External Document No.", 1, StrPos(SalesHdr."External Document No.", 'MASTER') - 1) + '*'
                    ELSE
                        ChkExtDoc := SalesHdr."External Document No." + '*';

                    CheckSalesHdr.SetFilter("External Document No.", '%1', ChkExtDoc);

                    IF CheckSalesHdr.FindSet() then
                        count := 1;
                until (SalesHdr.Next() = 0) or (count > 0);

            if count > 0 then begin
                if SRSetup.Get() then;
                if Company.Get() then;

                emailMessage.Create(List1, StrSubstNo(SRSetup.SODCBreakdownSubject, Company.Name), StrSubstNo(SRSetup.SODCBreakdownBody, Format(Today)), true);
                SalesHdr.Reset();
                SalesHdr.SetRange(Master, true);
                IF SalesHdr.FindSet() then
                    repeat
                        ChkExtDoc := '';
                        CheckSalesHdr.Reset();
                        CheckSalesHdr.SetRange(Master, false);
                        CheckSalesHdr.SetRange("Sell-to Customer No.", SalesHdr."Sell-to Customer No.");

                        IF StrPos(SalesHdr."External Document No.", 'MASTER') > 0 then
                            ChkExtDoc := CopyStr(SalesHdr."External Document No.", 1, StrPos(SalesHdr."External Document No.", 'MASTER') - 1) + '*'
                        ELSE
                            ChkExtDoc := SalesHdr."External Document No." + '*';
                        CheckSalesHdr.SetFilter("External Document No.", '%1', ChkExtDoc);

                        IF CheckSalesHdr.FindSet() then
                            emailMessage.AppendToBody('<tr><td>' + SalesHdr."No." + '</td><td>' + SalesHdr."Sell-to Customer No." + '</td><td>' +
                            SalesHdr."Sell-to Customer Name" + '</td><td>' + SalesHdr."External Document No." + '</td><td align=center>' + Format(CheckSalesHdr.Count) + '</td></tr>');

                    until (SalesHdr.Next() = 0);
                emailMessage.AppendToBody(StrSubstNo(SRSetup.SODCBreakdownClosing, Company.Name));
                email.Send(emailMessage, Enum::"Email Scenario"::Default);
            end;



        end;






    end;
    //mbr 10/4/24 - end

    // PR 5/15/25 - Calculate EDI unit price from Line Discount start
    procedure CalcEDILineDiscount(var Rec: Record "Sales Header"; isAuto: Boolean)
    var
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        SalesLineParentItem: Record "Sales Line";
        EDIGLAccount: Record "EDI G\L Account";
        EDICap: Decimal;
        SalesNRecieveable: Record "Sales & Receivables Setup";
        bRunEdiCalc: Boolean;
        item: Record Item;
        lineDiscount: Decimal;
        bRecaled: Boolean;
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then begin
            if (SalesNRecieveable.FindFirst()) then
                EDICap := SalesNRecieveable.EDILineDiscountCAP;
            if ((StrPos(Rec."Your Reference", 'EDI-') > 0) and (EDICap <> 0)) then begin
                if (Rec."EDI discount Calculated" = false) then begin
                    //ONLY PROCESS Edi Discount if there are g/l accounts associated with EDI G/L Account Setup in the sales line grid
                    Customer.Reset();
                    Customer.SetRange("No.", Rec."Sell-to Customer No.");
                    if (Customer.FindFirst()) then begin
                        bRecaled := false;

                        // calculates unit price
                        lineDiscount := 0;
                        SalesLine.Reset();
                        SalesLine.SetCurrentKey("Line No.");
                        salesline.SetAscending("Line No.", true);
                        SalesLine.SetRange("Document No.", Rec."No.");
                        SalesLine.SetRange(Type, SalesLine.Type::"G/L Account");
                        SalesLine.SetRange("Document Type", Rec."Document Type");
                        SalesLine.SetRange("EDI Sequence Line No.", 0);
                        if (SalesLine.FindSet()) then begin
                            repeat
                                // For every EDI Line Sequence Line No = 0,find the line above (parent item) 
                                SalesLineParentItem.Reset();
                                SalesLineParentItem.SetRange("Document No.", Rec."No.");
                                SalesLineParentItem.SetRange("Document Type", Rec."Document Type");
                                SalesLineParentItem.SetRange(Type, SalesLineParentItem.Type::Item);
                                SalesLineParentItem.SetFilter("EDI Sequence Line No.", '<>%1', 0);
                                SalesLineParentItem.SetFilter("Line No.", '<%1', SalesLine."Line No.");
                                SalesLineParentItem.SetCurrentKey("Line No.");
                                SalesLineParentItem.SetAscending("Line No.", false);
                                if (SalesLineParentItem.FindFirst()) then begin
                                    item.Reset();
                                    item.SetRange("No.", SalesLineParentItem."No.");
                                    item.SetRange(Type, item.Type::Inventory);
                                    if (item.FindSet()) then begin
                                        if (SalesLine."Line Discount %" <> 0) then begin
                                            //copy the  line discount into EDI Inv Line Discount
                                            SalesLine.Validate("EDI Inv Line Discount", SalesLine."Line Discount %");
                                            //Remove the value from Line discount from the Current Sales Line
                                            SalesLine.Validate("Line Discount %", 0);
                                            //Calculate discount 
                                            lineDiscount := ROUND((SalesLineParentItem."Line Amount" * (SalesLine."EDI Inv Line Discount" / 100)), 0.01, '=');
                                            //Assign Unit Price Excl Tax for the current Sales Line
                                            SalesLine.Validate("Unit Price", lineDiscount * -1);
                                            SalesLine.Modify();
                                            bRecaled := true;
                                        end
                                        // catches any g/l account lines with no line discount %
                                        else
                                            Message(txtEDINoLineDiscount, SalesLine."Line No.");

                                    end;
                                end;
                            until SalesLine.next = 0;
                            if (bRecaled) then begin
                                Rec."EDI discount Calculated" := true;
                                Rec.Modify();
                                Message(txtDiscountsRecalculated, Rec."No.");
                            end;
                        end;
                    end;
                end
                else if (isAuto = false) then begin
                    ReCalcEDILineDiscount(Rec, False);

                end;

            end
            else if (isAuto = false) then begin
                ReCalcEDILineDiscount(Rec, False);
            end;
        end;
    end;

    procedure ReCalcEDILineDiscount(var Rec: Record "Sales Header"; bInvoice: Boolean)
    var
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        bReleased: Boolean;
        SalesLineParentItem: Record "Sales Line";
        item: Record Item;
        lineDiscount: Decimal;

    begin
        if Rec."Document Type" = Rec."Document Type"::Order then begin
            if (StrPos(Rec."Your Reference", 'EDI-') > 0) and (Rec."EDI discount Calculated" = true) then begin
                if Rec.Status = Rec.Status::Released then
                    bReleased := true
                else
                    bReleased := false;
                Customer.Reset();
                Customer.SetRange("No.", Rec."Sell-to Customer No.");
                if (Customer.FindFirst()) then begin
                    // calculates TotalSPSInvoiceamount from all item sales lines
                    lineDiscount := 0;
                    SalesLine.Reset();
                    SalesLine.SetCurrentKey("Line No.");
                    salesline.SetAscending("Line No.", true);
                    SalesLine.SetRange("Document No.", Rec."No.");
                    SalesLine.SetRange(Type, SalesLine.Type::"G/L Account");
                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    SalesLine.SetRange("EDI Sequence Line No.", 0);
                    if (SalesLine.FindSet()) then
                        repeat
                            // For every EDI Line Sequence Line No = 0,find the line above (parent item) 
                            SalesLineParentItem.Reset();
                            SalesLineParentItem.SetRange("Document No.", Rec."No.");
                            SalesLineParentItem.SetRange("Document Type", Rec."Document Type");
                            SalesLineParentItem.SetRange(Type, SalesLineParentItem.Type::Item);
                            SalesLineParentItem.SetFilter("EDI Sequence Line No.", '<>%1', 0);
                            SalesLineParentItem.SetFilter("Line No.", '<%1', SalesLine."Line No.");
                            SalesLineParentItem.SetCurrentKey("Line No.");
                            SalesLineParentItem.SetAscending("Line No.", false);
                            if (SalesLineParentItem.FindFirst()) then begin
                                item.Reset();
                                item.SetRange("No.", SalesLineParentItem."No.");
                                item.SetRange(Type, item.Type::Inventory);
                                if (item.FindSet()) then begin
                                    //Calculate discount 
                                    lineDiscount := ROUND((SalesLineParentItem."Line Amount" * (SalesLine."EDI Inv Line Discount" / 100)), 0.01, '=');
                                    //Assign Unit Price Excl Tax for the current Sales Line
                                    SalesLine.Validate("Unit Price", lineDiscount * -1);
                                    SalesLine.Modify();
                                end;
                            end;
                        until SalesLine.next = 0;

                end;
            end;
        end;
    end;
    // PR 5/15/25 - end

    //9/3/25 - start
    procedure DisplayPowerBIReport(ReportId: Text[50]; WorkspaceId: Text[50]; ReportName: Text[100])
    var
        PowerBIMgt: Codeunit "Power BI Service Mgt.";
        PowerBIDisplayedElement: Record "Power BI Displayed Element";
        ReportGuid: Guid;
        WorkspaceGuid: Guid;
        Context: Code[50];
        PowerBIARep: Page "Power BI Element Addin Host";
        GuidanceMessage: Text[250];
    begin
        if (ReportId = '') or (WorkspaceId = '') then begin
            GuidanceMessage := 'Report Id or Workspace Id is empty.';
            exit;
        end;

        if not Evaluate(ReportGuid, ReportId) then begin
            GuidanceMessage := StrSubstNo('Report Id "%1" is not a valid GUID.', ReportId);
            exit;
        end;

        if not Evaluate(WorkspaceGuid, WorkspaceId) then begin
            GuidanceMessage := StrSubstNo('Workspace Id "%1" is not a valid GUID.', WorkspaceId);
            exit;
        end;

        // Use a stable context for this page (PAGE<Id>)
        Context := StrSubstNo('PAGE%1', Page::"Financial Report Power BI");

        // 1) Clear any previous selection for this user/context
        PowerBIDisplayedElement.Reset();
        PowerBIDisplayedElement.SetRange(UserSID, UserSecurityId());
        PowerBIDisplayedElement.SetRange(Context, Context);
        if PowerBIDisplayedElement.FindSet() then
            PowerBIDisplayedElement.DeleteAll();

        // 2) Register the new selection for this user/context
        // /   (Workspace + Report + ElementType = Report)
        PowerBIMgt.AddReportForContext(ReportGuid, Context);

        // Try to get the record created by AddReportForContext
        PowerBIDisplayedElement.Reset();
        PowerBIDisplayedElement.SetRange(UserSID, UserSecurityId());
        PowerBIDisplayedElement.SetRange(Context, Context);
        PowerBIDisplayedElement.SetRange(ElementId, ReportGuid);

        if not PowerBIDisplayedElement.FindFirst() then begin
            // If not found, create it manually
            Clear(PowerBIDisplayedElement);
            PowerBIDisplayedElement.Init();
            PowerBIDisplayedElement.UserSID := UserSecurityId();
            PowerBIDisplayedElement.Context := Context;
            PowerBIDisplayedElement.ElementId := ReportGuid;
            PowerBIDisplayedElement.ElementType := PowerBIDisplayedElement.ElementType::Report;
            PowerBIDisplayedElement.ElementName := ReportName;
            PowerBIDisplayedElement.ElementEmbedUrl := ConstructPowerBIEmbedUrl(ReportId, WorkspaceId);
            PowerBIDisplayedElement.ShowPanesInExpandedMode := true;
            if not PowerBIDisplayedElement.Insert() then
                PowerBIDisplayedElement.Modify();
        end else begin
            // If found but no embed URL, construct it
            if PowerBIDisplayedElement.ElementEmbedUrl = '' then begin
                PowerBIDisplayedElement.ElementEmbedUrl := ConstructPowerBIEmbedUrl(ReportId, WorkspaceId);
                PowerBIDisplayedElement.Modify();
            end;
        end;

        // Now set the properly initialized record to the Power BI page
        Clear(PowerBIARep);
        PowerBIARep.SetDisplayedElement(PowerBIDisplayedElement);
        PowerBIARep.Run();
    end;

    local procedure ConstructPowerBIEmbedUrl(ReportId: Text[50]; WorkspaceId: Text[50]): Text
    var
        company: Record Company;
    begin
        if (company.Get()) then begin
            // Construct the standard Power BI embed URL format
            if (ReportId <> '') and (WorkspaceId <> '') then
                exit(StrSubstNo('https://app.powerbi.com/reportEmbed?reportId=%1&groupId=%2', ReportId, WorkspaceId))
            else
                exit('');
        end;
    end;
    //9/3/25 - end

    // PR 12/6/24 - start
    procedure CalcEDI(var Rec: Record "Sales Header"; isAuto: Boolean)
    var
        SalesLine: Record "Sales Line";
        RealTotalSalesLineAmt: Decimal;
        EDIUnitPrice: Decimal;
        ItemUOM: Record "Item Unit of Measure";
        Customer: Record Customer;
        TotalSPSInvoiceamount: Decimal;
        TotalSPSInvoiceamountItems: Decimal;
        SalesLine2: Record "Sales Line";
        SalesLineRef: RecordRef;
        EDIUnitPriceRef: FieldRef;
        SalesLineQtyRef: FieldRef;
        SalesLineQty: Decimal;
        EDIGLAccount: Record "EDI G\L Account";
        bRelease: boolean;
        GetStatus: integer;
        EDICap: Decimal;
        SalesNRecieveable: Record "Sales & Receivables Setup";
        popupConfirm: Page "Confirmation Dialog";
        txtTaskAborted: Label 'Task Aborted!';
        EDICalcedDiscount: Decimal;
        bRunEdiCalc: Boolean;
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then begin
            if (SalesNRecieveable.FindFirst()) then
                EDICap := SalesNRecieveable.EDILineDiscountCAP;
            if ((StrPos(Rec."Your Reference", 'EDI-') > 0) and (EDICap <> 0)) then begin
                if (Rec."EDI discount Calculated" = false) then begin
                    IF Rec.Status = Rec.Status::Released then
                        bRelease := true;
                    //ONLY PROCESS Edi Discount if there are g/l accounts associated with EDI G/L Account Setup in the sales line grid
                    Customer.Reset();
                    Customer.SetRange("No.", Rec."Sell-to Customer No.");
                    if (Customer.FindFirst()) then begin
                        // calculates TotalSPSInvoiceamount from all item sales lines
                        TotalSPSInvoiceamount := 0;
                        SalesLine.SetRange("Document No.", Rec."No.");
                        SalesLine.SetRange(Type, SalesLine.Type::Item);
                        SalesLine.SetRange("Document Type", Rec."Document Type");
                        if (SalesLine.FindSet()) then
                            repeat
                                ItemUOM.Reset();
                                ItemUOM.SetRange(code, Customer."EDI order");
                                ItemUOM.SetRange("Item No.", SalesLine."No.");
                                if (ItemUOM.FindFirst()) then begin
                                    SalesLineRef.Open(Database::"Sales Line");
                                    SalesLineRef.GetTable(SalesLine);
                                    SalesLineRef.SetRecFilter();
                                    if (SalesLineRef.FindSet()) then begin
                                        EDIUnitPriceRef := SalesLineRef.Field(70043);
                                        EDIUnitPrice := EDIUnitPriceRef.Value();
                                    end;
                                    SalesLineRef.Close();
                                    TotalSPSInvoiceamount += ((EDIUnitPrice / ItemUOM."Qty. per Unit of Measure") * SalesLine.Quantity);

                                end;
                            until SalesLine.next = 0;
                    end;

                    //Calulate Invoice Total less the G/L Accounts from EDI GLAccounts
                    bRunEdiCalc := false;
                    SalesLine2.Reset();
                    SalesLine2.SetRange("Document No.", Rec."No.");
                    SalesLine2.SetRange("Document Type", Rec."Document Type");
                    SalesLine2.SetRange(Type, SalesLine2.Type::"G/L Account");
                    IF SalesLine2.FindSet() then
                        repeat
                            if EDIGLAccount.GET(SalesLine2."No.") then
                                bRunEdiCalc := true;
                        until (SalesLine2.Next() = 0) or (bRunEdiCalc = true);

                    if (SalesLine2.FindSet()) then
                        if bRunEdiCalc = true then begin
                            TotalSPSInvoiceamountItems := 0;
                            SalesLine2.Reset();
                            SalesLine2.SetRange("Document No.", Rec."No.");
                            SalesLine2.SetRange("Document Type", Rec."Document Type");
                            if (SalesLine2.FindSet()) then
                                repeat
                                    if NOT EDIGLAccount.GET(SalesLine2."No.") then
                                        TotalSPSInvoiceamountItems += SalesLine2."Line Amount";
                                until SalesLine2.next = 0;
                            // calculate and assigns InvoiceDiscount %
                            SalesLine.Reset();
                            SalesLine.SetRange("Document No.", Rec."No.");
                            SalesLine.SetRange(Type, SalesLine.Type::"G/L Account");
                            SalesLine.SetRange("Document Type", Rec."Document Type");
                            if (SalesLine.FindSet()) then
                                repeat
                                    if EDIGLAccount.GET(SalesLine."No.") then begin
                                        if bRelease = true then
                                            Rec.SetStatus(0);  //set status to Open
                                        if TotalSPSInvoiceamount > 0 then begin

                                            EDICalcedDiscount := Round((ABS(SalesLine."Unit Price") / TotalSPSInvoiceamount), 0.00001, '=');

                                            // PR 1/2/25 - if EDI Line Discount > .02 (CAP), then error out or pop up a message - start
                                            IF ((EDICalcedDiscount > EDICap)) then begin
                                                Clear(popupConfirm);
                                                popupConfirm.setMessage(StrSubstNo(txtEDICapError, EDICap));
                                                Commit;
                                                if popupConfirm.RunModal() = Action::Yes then begin
                                                    salesNRecieveable.EDILineDiscountCAP := EDICalcedDiscount;
                                                    salesNRecieveable.Modify();
                                                    EDICap := EDICalcedDiscount;
                                                end
                                                else begin
                                                    Error(txtTaskAborted);
                                                end;

                                            end;
                                            SalesLine."EDI Inv Line Discount" := EDICalcedDiscount;
                                        end;
                                        // PR 1/2/25 - if EDI Line Discount > .02 (CAP), then error out or pop up a message - end
                                        IF SalesLine."EDI Inv Line Discount" <> 0 then begin
                                            SalesLine."SPS EDI Unit Price" := SalesLine."Unit Price";
                                            SalesLine.Validate("Line Discount %", 0); //reset line discount to 0
                                            SalesLine.Validate("Unit Price", Round((SalesLine."EDI Inv Line Discount" * TotalSPSInvoiceamountItems * -1), 0.01, '='));
                                            SalesLine.Modify();
                                        end;


                                    end;
                                until SalesLine.next = 0;
                            Rec."EDI discount Calculated" := true;
                            Rec.Modify();
                            Message(txtDiscountsRecalculated, Rec."No.");
                        end;

                end
                else if (isAuto = false) then begin
                    ReCalcEDI(Rec, False);

                end;

            end
            else if (isAuto = false) then begin
                ReCalcEDI(Rec, False);
            end;
        end;

    end;
    // PR 12/6/24 - end

    //mbr 12/9/24 - start
    procedure ReCalcEDI(var Rec: Record "Sales Header"; bInvoice: Boolean)
    var
        SalesLine: Record "Sales Line";
        RealTotalSalesLineAmt: Decimal;
        EDIUnitPrice: Decimal;
        ItemUOM: Record "Item Unit of Measure";
        Customer: Record Customer;
        TotalSPSInvoiceamount: Decimal;
        TotalSPSInvoiceamountItems: Decimal;
        SalesLine2: Record "Sales Line";
        SalesLineRef: RecordRef;
        EDIUnitPriceRef: FieldRef;
        SalesLineQtyRef: FieldRef;
        SalesLineQty: Decimal;
        EDIGLAccount: Record "EDI G\L Account";
        bReleased: Boolean;

    begin
        if Rec."Document Type" = Rec."Document Type"::Order then begin
            if (StrPos(Rec."Your Reference", 'EDI-') > 0) and (Rec."EDI discount Calculated" = true) then begin
                if Rec.Status = Rec.Status::Released then
                    bReleased := true
                else
                    bReleased := false;

                Customer.Reset();
                Customer.SetRange("No.", Rec."Sell-to Customer No.");
                if (Customer.FindFirst()) then begin

                    //Calulate Invoice Total less the G/L Accounts from EDI GLAccounts
                    TotalSPSInvoiceamountItems := 0;
                    SalesLine2.Reset();
                    SalesLine2.SetRange("Document No.", Rec."No.");
                    SalesLine2.SetRange("Document Type", Rec."Document Type");
                    SalesLine2.SetRange(Type, SalesLine2.Type::Item);  //we only want to add up line amounts for Type = Item
                    if (SalesLine2.FindSet()) then
                        repeat
                            if NOT EDIGLAccount.GET(SalesLine2."No.") then begin
                                if bInvoice = true then
                                    TotalSPSInvoiceamountItems += SalesLine2."Qty. to Invoice" * SalesLine2."Unit Price"
                                else
                                    TotalSPSInvoiceamountItems += SalesLine2."Line Amount";
                            end;

                        until SalesLine2.next = 0;
                    // calculate and assigns InvoiceDiscount %
                    if bReleased = true then begin
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify();
                    end;


                    SalesLine.Reset();
                    SalesLine.SetRange("Document No.", Rec."No.");
                    SalesLine.SetRange(Type, SalesLine.Type::"G/L Account");
                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    if (SalesLine.FindSet()) then
                        repeat
                            if EDIGLAccount.GET(SalesLine."No.") then begin
                                IF SalesLine."EDI Inv Line Discount" <> 0 then begin
                                    SalesLine.Validate("Unit Price", Round((SalesLine."EDI Inv Line Discount" * TotalSPSInvoiceamountItems * -1), 0.01, '='));
                                    SalesLine.Modify();
                                end;


                            end;


                        until SalesLine.next = 0;
                    if bReleased = true then begin
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify();
                    end;

                end;

            end;
        end;






    end;
    // 10/15/25 - start
    procedure AssignBOLForSO(SalesHeaderRef: Record "Sales Header")
    var
        NewBOLNo: Code[20];
        SalesHdr: Record "Sales Header";
        SalesNRecieveable: Record "Sales & Receivables Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if (SalesNRecieveable.FindFirst()) then;

        IF STRLEN(SalesNRecieveable."Single BOL Nos.") = 0 then
            Error('No. Series for Single BOL Nos. is NOT set up.  Please review.');
        //NewBOLNo := NoSeriesMgt.DoGetNextNo(SalesNRecieveable."Single BOL Nos.", WorkDate(), true, true);  //old code
        NewBOLNo := NoSeries.GetNextNo(SalesNRecieveable."Single BOL Nos.");
        //Check to ensure we have unique BOL for the same customer
        SalesHdr.Reset();
        SalesHdr.SetRange("Document Type", SalesHeaderRef."Document Type");
        SalesHdr.SetRange("Sell-to Customer No.", SalesHeaderRef."Sell-to Customer No.");

        SalesHdr.SetFilter("Single BOL No.", '=%1', NewBOLNo);
        IF SalesHdr.FindFirst() then
            Error('BOL No. %1 has already been assigned to %2.  Please try again or contact Admin.', NewBOLNo, SalesHdr."No.")
        Else begin
            SalesHeaderRef."Single BOL No." := NewBOLNo;
            SalesHeaderRef.Modify();
        end;

    end;
    // 10/15/25 - end




    //mbr 12/9/24 - end

    //mbr 12/18/24 - start: on transfer order post, carry some fields from Transfer line into Transer Receipt Line and Transfer Shipment Line
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterInsertTransRcptLine', '', false, false)]
    local procedure OnAfterInsertTransRcptLine(var TransRcptLine: Record "Transfer Receipt Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean; TransferReceiptHeader: Record "Transfer Receipt Header")
    begin
        TransRcptLine."Telex Released" := TransLine."Telex Released";
        TransRcptLine."Telex Updated By" := TransLine."Telex Updated By";
        TransRcptLine."Telex Updated Date" := TransLine."Telex Updated Date";
        //PR 3/6/25 - start
        TransRcptLine."PO No." := TransLine."PO No.";
        TransRcptLine."PO Owner" := TransLine."PO Owner";
        //PR 3/6/25 - end
        //mbr 3/11/25 - start
        TransRcptLine."Shortcut Dimension 1 Code" := TransLine."Shortcut Dimension 1 Code";
        //mbr 3/11/25 - end
        //mbr 03/25/25 - start
        TransRcptLine.POClosed := TransLine.POClosed;
        TransRcptLine."Expected Quantity" := TransLine."Expected Quantity";
        TransRcptLine."Expected UOM" := TransLine."Expected UOM";
        TransRcptLine."Received Good" := TransLine."Received Good";
        TransRcptLine."Received Case" := TransLine."Received Case";
        TransRcptLine."Received Damage" := TransLine."Received Damage";
        TransRcptLine."Received Good" := TransLine."Received Good";
        TransRcptLine."Received Over" := TransLine."Received Over";
        TransRcptLine."Received Pallet" := TransLine."Received Pallet";
        TransRcptLine."Received Short" := TransLine."Received Short";
        TransRcptLine."Received Weight" := TransLine."Received Weight";
        TransRcptLine."PO Vendor" := TransLine."PO Vendor";
        TransRcptLine."Container Line No." := TransLine."Container Line No.";
        //mbr 03/25/25 - end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterInsertTransShptLine', '', false, false)]
    local procedure OnAfterInsertTransShptLine(var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean; TransShptHeader: Record "Transfer Shipment Header")
    begin
        TransShptLine."Telex Released" := TransLine."Telex Released";
        TransShptLine."Telex Updated By" := TransLine."Telex Updated By";
        TransShptLine."Telex Updated Date" := TransLine."Telex Updated Date";
        //PR 3/6/25 - start
        TransShptLine."PO No." := TransLine."PO No.";
        TransShptLine."PO Owner" := TransLine."PO Owner";
        //PR 3/6/25 - end
        //mbr 3/11/25 - start
        TransShptLine."Shortcut Dimension 1 Code" := TransLine."Shortcut Dimension 1 Code";
        //mbr 3/11/25 - end
        //mbr 03/25/25 - start
        TransShptLine.POClosed := TransLine.POClosed;
        TransShptLine."Expected Quantity" := TransLine."Expected Quantity";
        TransShptLine."Expected UOM" := TransLine."Expected UOM";
        TransShptLine."Received Good" := TransLine."Received Good";
        TransShptLine."Received Case" := TransLine."Received Case";
        TransShptLine."Received Damage" := TransLine."Received Damage";
        TransShptLine."Received Good" := TransLine."Received Good";
        TransShptLine."Received Over" := TransLine."Received Over";
        TransShptLine."Received Pallet" := TransLine."Received Pallet";
        TransShptLine."Received Short" := TransLine."Received Short";
        TransShptLine."Received Weight" := TransLine."Received Weight";
        TransShptLine."PO Vendor" := TransLine."PO Vendor";
        TransShptLine."Container Line No." := TransLine."Container Line No.";
        //mbr 03/25/25 - end
    end;
    //mbr 12/18/24 - End


    //mbr 1/20/25 - make sure we run the event to check received vs invoiced
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnDeleteOnBeforePurchaseLineDelete', '', false, false)]
    local procedure OnDeleteOnBeforePurchaseLineDelete(var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin

        if PurchaseLine."Receipt No." = '' then
            PurchaseLine.TestField("Qty. Rcd. Not Invoiced", 0);
        if PurchaseLine."Return Shipment No." = '' then
            PurchaseLine.TestField("Return Qty. Shipped Not Invd.", 0);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeCheckHeaderPostingType', '', false, false)]
    local procedure OnBeforeCheckHeaderPostingType(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        PurchLines: Record "Purchase Line";
        ItemTrackingLines: Record "Tracking Specification" temporary;
        Item: Record Item;
        txtExpDtMandatory: Label 'Item %1 Lot %2 is set up with valid Expiration Date MANDATORY.  Please goto Item Tracking Lines and enter Expiration Date.';
        ReservationEntry: Record "Reservation Entry";
        Location: Record Location;
    begin
        //Pr 5/1/25 - if receiving check the item tracking lines for each of the item where item.Mandatory Exp Date is TURNED ON.  
        // If ON, then expiration date has to be entered - start
        if (PurchaseHeader.Receive) then begin
            PurchLines.Reset();
            PurchLines.SetRange("Document No.", PurchaseHeader."No.");
            PurchLines.SetRange("Document Type", PurchaseHeader."Document Type");
            PurchLines.SetRange(Type, PurchLines.Type::Item);
            PurchLines.SetFilter("Qty. to Receive", '>%1', 0);
            if (PurchLines.FindSet()) then
                repeat
                    If Location.Get(PurchLines."Location Code") then;
                    If Location."Require Receive" = false then begin
                        Item.Reset();
                        item.SetRange("No.", PurchLines."No.");
                        item.SetRange("Expiration Date Mandatory", true);
                        if (item.FindSet()) then begin
                            ReservationEntry.Reset();
                            ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
                            ReservationEntry.SetRange("Source ID", PurchLines."Document No.");
                            ReservationEntry.SetRange("Source Ref. No.", PurchLines."Line No.");
                            ReservationEntry.SetRange("Item No.", PurchLines."No.");
                            ReservationEntry.SetRange("Location Code", PurchLines."Location Code");
                            If ReservationEntry.FindSet() then
                                repeat
                                    If ReservationEntry."Expiration Date" = 0D then
                                        Error(StrSubstNo(txtExpDtMandatory, ReservationEntry."Item No.", ReservationEntry."Lot No."));
                                until ReservationEntry.Next() = 0;
                        end;
                    end;

                until PurchLines.Next() = 0;
        end;
        //Pr 5/1/25 - if receiving check the item tracking lines for each of the item where item.Mandatory Exp Date is TURNED ON.  
        // If ON, then expiration date has to be entered - end

        //mbr 8/2/24 - let's populate the verified by and Verified date in Purchase Header so these can be carried over to Purchase Invoice;
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then begin
            PurchaseHeader.VerifiedBy := UserId;
            PurchaseHeader.VerifiedDate := PurchaseHeader."Posting Date";
            PurchaseHeader.Modify();
        end;
    end;

    //pr 6/13/25 - start
    [EventSubscriber(ObjectType::Page, Page::"SOReservationEntries", 'OnLookupReserved', '', false, false)]
    local procedure OnLookupReserved(var ReservationEntry: Record "Reservation Entry")
    begin
        if MatchThisTable(ReservationEntry."Source Type") then
            ShowSourceLines(ReservationEntry);
    end;

    local procedure MatchThisTable(TableID: Integer): Boolean
    begin
        exit(TableID = Database::"Assembly Header");
    end;

    local procedure ShowSourceLines(var ReservationEntry: Record "Reservation Entry")
    var
        AssemblyHeader: Record "Assembly Header";
    begin
        AssemblyHeader.SetRange("Document Type", ReservationEntry."Source Subtype");
        AssemblyHeader.SetRange("No.", ReservationEntry."Source ID");
        PAGE.RunModal(Page::"Assembly List", AssemblyHeader);
    end;
    //pr 6/13/25 - end

    //mbr 6/20/25 - start
    procedure UpdateEarliestStartShipDatePurch(var PurchLine: Record "Purchase Line")
    var
        SalesLine: Record "Sales Line";
        EarliestDate: Date;
        IsFirst: Boolean;
        Item: Record Item;
    begin
        EarliestDate := 0D;

        if Item.get(PurchLine."No.") then begin
            Item.CalcFields("Qty. on Sales Order");
            if Item."Qty. on Sales Order" > 0 then begin
                IsFirst := true;
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetRange("No.", PurchLine."No.");  //matches item no.
                SalesLine.SetRange("Unit of Measure Code", PurchLine."Unit of Measure Code");
                SalesLine.SetFilter("Start Ship Date", '<>%1', 0D);


                if SalesLine.FindSet() then
                    repeat
                        SalesLine.CalcFields("Start Ship Date");  //this is a flowfield
                        if IsFirst or (SalesLine."Start Ship Date" < EarliestDate) then begin
                            EarliestDate := SalesLine."Start Ship Date";
                            IsFirst := false;
                        end;


                    until SalesLine.Next() = 0;

            end;
        end;


        PurchLine.VALIDATE("Earliest Start Ship Date", EarliestDate);

    end;
    //EventSubscriber to capture new value of Start Ship Date when modified from Sales Header
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterModifyEvent', '', false, false)]
    local procedure SalesHeaderOnAfterModify(var Rec: Record "Sales Header"; xRec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        if Rec."Start Ship Date" <> xRec."Start Ship Date" then
            UpdateEarliestStartShipDate(Rec);

    end;

    procedure UpdateEarliestStartShipDate(var Rec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        GenCU: Codeunit GeneralCU;
        TempItemUOM: Record TempItemUOMRec; // See below for definition; This is a temp table
        ContainerLine: Record ContainerLine;
    begin
        // 1. Collect unique Item No. + UOM from this Sales Header
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet() then
            repeat
                // Record each Item No. + UOM once (use a temporary record or dictionary if many lines)
                if not TempItemUOM.Get(SalesLine."No.", SalesLine."Unit of Measure Code") then begin
                    TempItemUOM.Init();
                    TempItemUOM."Item No." := SalesLine."No.";
                    TempItemUOM."Unit of Measure Code" := SalesLine."Unit of Measure Code";
                    TempItemUOM.Insert();
                end;
            until SalesLine.Next() = 0;

        // 2. For each unique Item No. + UOM, update all matching Purchase Lines
        if TempItemUOM.FindSet() then
            repeat
                PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                PurchLine.SetRange(Type, PurchLine.Type::Item);
                PurchLine.SetRange("No.", TempItemUOM."Item No.");
                PurchLine.SetRange("Unit of Measure Code", TempItemUOM."Unit of Measure Code");
                if PurchLine.FindSet(true) then
                    repeat
                        UpdateEarliestStartShipDatePurch(PurchLine);
                        PurchLine.Modify();
                    until PurchLine.Next() = 0;

                ContainerLine.SetRange("Item No.", TempItemUOM."Item No.");

                if ContainerLine.FindSet(true) then
                    repeat
                        UpdateEarliestStartShipDateContainer(ContainerLine);
                        ContainerLine.Modify();
                    until ContainerLine.Next() = 0;
            until TempItemUOM.Next() = 0;
    end;

    procedure UpdateEarliestStartShipDateContainer(var ContainerLine: Record ContainerLine)
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        EarliestDate: Date;
        IsFirst: Boolean;
        Item: Record Item;
    begin
        EarliestDate := 0D;
        if Item.get(ContainerLine."Item No.") then begin
            Item.CalcFields("Qty. on Sales Order");
            if Item."Qty. on Sales Order" > 0 then begin
                IsFirst := true;
                // Set filters to find all relevant Sales Lines for this Container Line.
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetRange("No.", ContainerLine."Item No.");  //matches item no.
                SalesLine.SetFilter("Start Ship Date", '<>%1', 0D);


                if SalesLine.FindSet() then
                    repeat
                        if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
                            if IsFirst or (SalesHeader."Start Ship Date" < EarliestDate) then begin
                                EarliestDate := SalesHeader."Start Ship Date";
                                IsFirst := false;
                            end;
                    until SalesLine.Next() = 0;
            end;


            ContainerLine.VALIDATE("Earliest Start Ship Date", EarliestDate);
        end;
    end;
    //mbr 6/20/25 - end

    //7/2/25 - update PurchaseLine and Container Line update earliest Start Ship Date - start
    procedure PostSO_UpdEarliestStartDt(SalesShptHdrNo: Code[20])
    var
        ContainerLine: Record ContainerLine;
        PurchLine: Record "Purchase Line";
        SalesShipmentLine: Record "Sales Shipment Line";
    begin

        SalesShipmentLine.Reset();
        SalesShipmentLine.SetRange("Document No.", SalesShptHdrNo);
        SalesShipmentLine.SetRange(Type, SalesShipmentLine.Type::Item);

        if SalesShipmentLine.FindSet() then
            repeat
                PurchLine.Reset();
                PurchLine.SetRange("No.", SalesShipmentLine."No.");
                PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                PurchLine.SetRange(Type, PurchLine.Type::Item);
                PurchLine.SetRange("Unit of Measure Code", SalesShipmentLine."Unit of Measure Code");
                if (PurchLine.FindSet()) then
                    repeat
                        UpdateEarliestStartShipDatePurch(PurchLine);
                        PurchLine.Modify();
                    until PurchLine.Next() = 0;

                ContainerLine.Reset();
                ContainerLine.SetRange("Item No.", SalesShipmentLine."No.");
                if (ContainerLine.FindSet()) then
                    repeat
                        UpdateEarliestStartShipDateContainer(ContainerLine);
                        ContainerLine.Modify();
                    until ContainerLine.Next() = 0;

            until SalesShipmentLine.Next() = 0;
    end;
    //7/2/25 - update PurchaseLine and Container Line update earliest Start Ship Date - end

    //7/3/25 - Given Item No. - update PurchaseLine and Container Line update earliest Start Ship Date - start
    procedure UpdSO_UpdEarliestStartDtItemNo(ItemNo: Code[20])
    var
        ContainerLine: Record ContainerLine;
        PurchLine: Record "Purchase Line";
    begin

        PurchLine.Reset();
        PurchLine.SetRange("No.", ItemNo);
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        if (PurchLine.FindSet()) then
            repeat
                UpdateEarliestStartShipDatePurch(PurchLine);
                PurchLine.Modify();
            until PurchLine.Next() = 0;

        ContainerLine.Reset();
        ContainerLine.SetRange("Item No.", ItemNo);
        if (ContainerLine.FindSet()) then
            repeat
                UpdateEarliestStartShipDateContainer(ContainerLine);
                ContainerLine.Modify();
            until ContainerLine.Next() = 0;

    end;
    //7/3/25 - Given Item no. - update PurchaseLine and Container Line update earliest Start Ship Date - end

    [EventSubscriber(ObjectType::Page,
                        Page::"Purchase Order Subform",
                        'OnRequestOpenItemTracking', '', false, false)]

    procedure HandleOpenItemTracking(var PurchLine: Record "Purchase Line")
    var
        TrackingSpecification: Record "Tracking Specification";
        ItemTrackingLines: Page "Item Tracking Lines";
        ShouldProcessDropShipment: Boolean;
        IsHandled: Boolean;
        ItemTrackingManagement: Codeunit "Item Tracking Management";
    begin
        IsHandled := false;
        if not IsHandled then begin
            InitFromPurchLine(TrackingSpecification, PurchLine);
            if ((PurchLine."Document Type" = PurchLine."Document Type"::Invoice) and
                (PurchLine."Receipt No." <> '')) or
            ((PurchLine."Document Type" = PurchLine."Document Type"::"Credit Memo") and
                (PurchLine."Return Shipment No." <> ''))
            then
                ItemTrackingLines.SetRunMode(Enum::"Item Tracking Run Mode"::"Combined Ship/Rcpt");
            ShouldProcessDropShipment := PurchLine."Drop Shipment";

            if ShouldProcessDropShipment then begin
                ItemTrackingLines.SetRunMode(Enum::"Item Tracking Run Mode"::"Drop Shipment");
                if PurchLine."Sales Order No." <> '' then
                    ItemTrackingLines.SetSecondSourceRowID(
                        ItemTrackingManagement.ComposeRowID(
                            Database::"Sales Line", 1, PurchLine."Sales Order No.", '', 0, PurchLine."Sales Order Line No."));
            end;
            ItemTrackingLines.SetSourceSpec(TrackingSpecification, PurchLine."Expected Receipt Date");
            ItemTrackingLines.SetInbound(PurchLine.IsInbound());
            ItemTrackingLines.Run();
        end;
    end;

    procedure InitFromPurchLine(var TransactionSpecification: Record "Tracking Specification"; PurchLine: Record "Purchase Line")
    begin
        TransactionSpecification.Init();
        TransactionSpecification.SetItemData(
          PurchLine."No.", PurchLine.Description, PurchLine."Location Code", PurchLine."Variant Code", PurchLine."Bin Code",
          PurchLine."Qty. per Unit of Measure", PurchLine."Qty. Rounding Precision (Base)");
        TransactionSpecification.SetSource(
          Database::"Purchase Line", PurchLine."Document Type".AsInteger(), PurchLine."Document No.", PurchLine."Line No.", '', 0);
        if PurchLine.IsCreditDocType() then
            TransactionSpecification.SetQuantities(
              PurchLine."Quantity (Base)", PurchLine."Return Qty. to Ship", PurchLine."Return Qty. to Ship (Base)",
              PurchLine."Qty. to Invoice", PurchLine."Qty. to Invoice (Base)", PurchLine."Return Qty. Shipped (Base)",
              PurchLine."Qty. Invoiced (Base)")
        else
            TransactionSpecification.SetQuantities(
              PurchLine."Quantity (Base)", PurchLine."Qty. to Receive", PurchLine."Qty. to Receive (Base)",
              PurchLine."Qty. to Invoice", PurchLine."Qty. to Invoice (Base)", PurchLine."Qty. Received (Base)",
              PurchLine."Qty. Invoiced (Base)");


    end;

    /*// 7/7/25 - update new item for purhcaseLine and Container line when new item ledger entry is added - start
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Purch.-Post", 'OnPostUpdateOrderLineOnAfterReceive', '', false, false)]
    local procedure OnPostUpdateOrderLineOnAfterReceive(var PurchHeader: Record "Purchase Header"; var TempPurchLine: Record "Purchase Line" temporary)
    var
        PurchLines: Record "Purchase Line";
        PurchLines2: Record "Purchase Line";
        TransLine: Record "Transfer Line";
        ContainerLine: Record ContainerLine;
    begin
        PurchLines.Reset();
        PurchLines.SetRange(Type, PurchLines.Type::Item);
        PurchLines.SetRange("Document No.", PurchHeader."No.");
        PurchLines.SetRange("Document Type", PurchHeader."Document Type");

        if (PurchLines.FindSet()) then
            repeat
                PurchLines.UpdateNewItem();
                PurchLines.Modify();
                PurchLines2.Reset();
                PurchLines2.SetRange(Type, PurchLines2.Type::Item);
                PurchLines2.SetRange("No.", PurchLines."No.");
                // updates other purch line switht eh same item
                if (PurchLines2.FindSet()) then
                    repeat
                        PurchLines2.UpdateNewItem();
                        PurchLines2.Modify();
                    until PurchLines2.Next() = 0;
            until PurchLines.Next() = 0;
    end;*/

    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Purch.-Post", 'OnPostUpdateOrderLineOnBeforeUpdateBlanketOrderLine', '', false, false)]
    local procedure OnPostUpdateOrderLineOnBeforeUpdateBlanketOrderLine(var PurchaseHeader: Record "Purchase Header"; var TempPurchaseLine: Record "Purchase Line" temporary)
    var
        PurchLines: Record "Purchase Line";
        PurchLines2: Record "Purchase Line";
        TransLine: Record "Transfer Line";
        ContainerLine: Record ContainerLine;
    begin
        PurchLines.Reset();
        PurchLines.SetRange(Type, PurchLines.Type::Item);
        PurchLines.SetRange("Document No.", PurchaseHeader."No.");
        PurchLines.SetRange("Document Type", PurchaseHeader."Document Type");

        if (PurchLines.FindSet()) then
            repeat
                PurchLines.UpdateNewItem();
                PurchLines.Modify();
                PurchLines2.Reset();
                PurchLines2.SetRange(Type, PurchLines2.Type::Item);
                PurchLines2.SetRange("No.", PurchLines."No.");
                // updates other purch line switht eh same item
                if (PurchLines2.FindSet()) then
                    repeat
                        PurchLines2.UpdateNewItem();
                        PurchLines2.Modify();
                    until PurchLines2.Next() = 0;
            until PurchLines.Next() = 0;
        TempPurchaseLine.UpdateNewItem();
        TempPurchaseLine.Modify();
    end;

    //9/19/25 - start
    procedure GetUserNameFromSecurityId(UserSecurityID: Guid): Code[50]
    var
        User: Record User;
    begin
        IF User.Get(UserSecurityID) then
            exit(User."User Name");
    end;
    //9/19/25 - end

    /* [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Item Jnl.-Post Line", 'OnAfterInsertItemLedgEntry', '', false, false)]
     local procedure OnAfterInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer; var ValueEntryNo: Integer; var ItemApplnEntryNo: Integer; GlobalValueEntry: Record "Value Entry"; TransferItem: Boolean; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L"; var OldItemLedgerEntry: Record "Item Ledger Entry")
     var
         PurchLines: Record "Purchase Line";
         TransLine: Record "Transfer Line";
         ContainerLine: Record ContainerLine;
     begin
         PurchLines.Reset();
         PurchLines.SetRange(Type, PurchLines.Type::Item);
         PurchLines.SetRange("No.", ItemLedgerEntry."Item No.");
         if (PurchLines.FindSet()) then
             repeat
                 PurchLines.UpdateNewItem();
                 PurchLines.Modify();
             until PurchLines.Next() = 0;

         ContainerLine.Reset();
         ContainerLine.SetRange("Item No.", ItemLedgerEntry."Item No.");
         if (ContainerLine.FindSet()) then
             repeat
                 ContainerLine.UpdateNewItem();
                 ContainerLine.Modify();
             until ContainerLine.Next() = 0;
     end;*/
    // 7/7/25 - update new item for purhcaseLine and Container line when new item ledger entry is added - end

    // 10/15/25 - Commit pending transactions to allow RunModal to execute
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Line-Reserve", 'OnBeforeRunItemTrackingLinesPage', '', false, false)]
    local procedure OnBeforeRunItemTrackingLinesPage(var ItemTrackingLines: Page "Item Tracking Lines"; var IsHandled: Boolean)
    begin
        // Commit any pending transactions before opening the modal page
        Commit();
    end;

    // 10/30/25 - start
    /*[EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Batch", 'OnCheckWhseJnlLine', '', false, false)]
    local procedure OnCheckWhseJnlLine(var WhseJnlLine: Record "Warehouse Journal Line")
    begin
        if (WhseJnlLine."Lot No." = '') then begin
            WhseJnlLine."Lot No." := 'TEMP_12345';
            WhseJnlLine.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Journal Line", 'OnAfterCheckTrackingIfRequired', '', false, false)]
    local procedure OnAfterCheckTrackingIfRequired(var WhseJnlLine: Record "Warehouse Journal Line"; WhseItemTrackingSetup: Record "Item Tracking Setup")
    begin
        if (WhseJnlLine."Lot No." = 'TEMP_12345') then begin
            WhseJnlLine."Lot No." := '';
            WhseJnlLine.Modify();
        end;
    end;*/
    //10/30/25 - end

    var
        ContainerHdr: Record "Container Header";
        ContainerLn: Record ContainerLine;
        PostedTransferRcpt: Record "Transfer Receipt Header";
        PostedTransferRcptLn: Record "Transfer Receipt Line";
        ChkTransferHeader: Record "Transfer Header";
        CartonInfo: Record CartonInformation;
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        GetPackageCnt: Decimal;
        GetWeight: Decimal;
        txtDiscountsRecalculated: Label 'Sales Order %1 G/L Accounts processed from Integ EDI are recalculated.  Please review and release when ready.';
        txtEDICapError: Label 'EDI Line discount cannot be created since it is more than %1. Do you want to override the EDI Line Discount CAP';
        txtEDINoLineDiscount: Label 'No Line Discount % found for Sales Line Line No. %1';
        holdSubject: Label 'FDA Hold Report: ';
        releaseSubject: Label 'FDA Release Report: ';
        holdSubjectTitle: Label 'FDA Hold Notice';
        releaseSubjectTitle: Label 'FDA Released Notice';



}