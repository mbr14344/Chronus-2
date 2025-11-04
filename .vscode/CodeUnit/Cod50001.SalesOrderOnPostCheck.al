codeunit 50001 SalesOrderOnPostCheck
{
    TableNo = "Sales Header";

    trigger OnRun()
    begin


    end;
    // pr 1/12/24 runs the "Sales-Post_OnBeforePostSalesDoc" fucntion before a post is made with a sales order
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', true, true)]
    /* checks if Code is blank, and says 'Shipping Agent Code is Mandatory' if it is. If not it chekcs if 
     * the code is 'CUSTDIR' if not it then checks if the "Shipping Agent Code" nis blank or not.
     * if not then is errors out with the message Carrier is Mandatory for <code>.
     */
    //mbr 2/1/24 - mod to mark Sales Order no as posted in the Master BOL table on Post
    //mbr 5/9/24 - mod to error out if customer is set up with cust invoice discount the Invoice Discount Amount Excl Tax is not filled in
    //7/3/25 - MOD to update earlist start Ship date in Purchase lines and 
    local procedure "Sales-Post_OnBeforePostSalesDoc"
     (
         var SalesHeader: Record "Sales Header";
         CommitIsSuppressed: Boolean;
         PreviewMode: Boolean;
         HideProgressWindow: Boolean;
         IsHandled: Boolean
     )
    var
        bupdate: Boolean;
        bZeroUnitPrice: Boolean;
        UserSetup: Record "User Setup";
        bValid: Boolean;
        TxtZeroUnitPriceErr: Label 'Sales Line %1 has 0 Unit Price.';
        txtOverrideNoPriceItems: Label 'One or more items do not have a unit price set for the sales order %1.  Do you want to override this business rule?';
        txtTaskAborted: Label 'Sales Order Post Aborted!';
    begin

        //mbr 6/6/25 - update Unit Price if applicable - start
        //mbr 6/13/25 - only be strict for Sales Orders
        If SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            //mbr 6/6/25 - update Unit Price if applicable - start
            salesline.SetRange("Document Type", SalesHeader."Document Type");
            salesline.SetRange("Document No.", SalesHeader."No.");
            salesline.SetRange(Type, salesline.Type::Item);
            salesline.SetRange(UnitPriceChecked, false);
            if salesline.FindSet() then
                repeat
                    salesline.UpdateUnitPriceByReqDelDt(salesline);
                    salesline.Modify();
                until salesline.Next() = 0;
            //mbr 6/6/25 - update Unit Price if applicable - end
            //PR 1/21/25 - check if there are any sales lines wit unit price <=0 and if so it errors out - start
            salesline.Reset();
            salesline.SetRange("Document No.", SalesHeader."No.");
            salesline.SetRange("Document Type", SalesHeader."Document Type");
            bZeroUnitPrice := false;
            bValid := true;
            if salesline.FindSet() then
                repeat
                    if salesline."Unit Price" = 0 then begin
                        bZeroUnitPrice := true;
                    end;
                until salesline.Next() = 0;

            if (bZeroUnitPrice) then begin
                bValid := false;
                // allow finace admin to post anyways
                UserSetup.Reset();
                UserSetup.SetRange("User ID", UserId);
                UserSetup.SetRange(FinanceAdmin, true);
                if (UserSetup.FindFirst()) then begin
                    if Dialog.Confirm(StrSubstNo(txtOverrideNoPriceItems, SalesLine."Document No.")) = false then
                        Error(txtTaskAborted)
                    else
                        bValid := true;
                end
                else
                    Error(TxtZeroUnitPriceErr, salesline."No.");
            end;

            //PR 1/21/25 - check if there are any sales lines wit unit price <=0 and if so it errors out - end
            if (bValid) then begin
                // pr 12/16/24

                //mbr 2/7/24 - error proof shipment method code only if Sales Order
                if ((StrLen(SalesHeader."Shipment Method Code") <= 0)) then begin
                    ERROR('Shipping Method Code is Mandatory');
                end
                else begin
                    if (Format(SalesHeader."Shipment Method Code") <> 'CUSTDIR') then begin
                        if ((StrLen(SalesHeader."Shipping Agent Code") <= 0)) then begin
                            ERROR('Carrier is Mandatory for ' + Format(SalesHeader."Shipment Method Code"));
                        end;
                    end
                end;

                //mbr 5/15/24 - Payment Terms code is mandatory
                if StrLen(SalesHeader."Payment Terms Code") = 0 then
                    Error(TxtPaymentTerms);
                //mbr 5/14/24 - end
                //mbr 5/9/24 - also check if cust with set invoice discount has the Invoice Discount Amount filled in
                CustomerInvDisc.Reset();
                CustomerInvDisc.SetRange(Code, SalesHeader."Sell-to Customer No.");
                CustomerInvDisc.SetFilter("Discount %", '>%1', 0);
                if CustomerInvDisc.FindFirst() then begin
                    SalesHeader.CalcFields("Invoice Discount Amount");
                    if SalesHeader."Invoice Discount Amount" = 0 then
                        Error(StrSubstNo(ErrInvoiceDiscount, SalesHeader."Sell-to Customer Name", CustomerInvDisc."Discount %", SalesHeader."No."));
                end;
                //mbr 5/15/24 - if customer is an EDI ASN Customer, then Single BOL No. and Carton Information are MANDATORY
                Cust.Reset;
                IF Cust.Get(SalesHeader."Sell-to Customer No.") then begin
                    IF Cust."EDI ASN Customer" = true then begin
                        IF strlen(SalesHeader."Single BOL No.") = 0 then
                            ERROR(TxtBOLMandatory, Cust."No.");
                        bCont := false;
                        // PR 12/19/24 dont check CI if no items are found -start
                        SalesLine.Reset();
                        SalesLine.SetRange("Document No.", SalesHeader."No.");
                        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                        SalesLine.SetRange(Type, SalesLine.Type::Item);
                        salesLine.SetFilter("Outstanding Quantity", '<>%1', 0);
                        if SalesLine.Findset() then
                            repeat
                                Item.Reset;
                                Item.SetRange("No.", SalesLine."No.");
                                Item.SetRange(Type, Item.Type::Inventory);
                                if (Item.FindSet()) then
                                    bCont := true;
                            until (SalesLine.Next() = 0) or (bCont = true);
                        if (bCont = true) then begin
                            CI.Reset;
                            CI.SetRange("Document No.", SalesHeader."No.");
                            IF NOT CI.FindSet() then
                                ERROR(TxtPackageMandatory, SalesHeader."No.");
                        end;
                        // PR 12/19/24 dont check CI if no items are found - end
                        // pr 8/14/24 - if customer is an  EDI ASN Customer, check Shipment Date in the 
                        //              sales order and if Shipment Date <> Posting Date, error out and remind user shipment Date <> Posting Date;
                        // if (SalesHeader."Shipment Date" <> SalesHeader."Posting Date") then
                        //     ERROR(TxtShipDateNotMatch);

                        // pr 11/18/24 If SalesHeader."EDI Ship To Mandatory", then Ship-to Code is MANDATORY - start
                        if ((StrLen(SalesHeader."Ship-to Code") <= 0) and Cust."EDI Ship To Mandatory") then
                            ERROR(TxtShipToCodeErr);
                        // pr 11/18/24 If SalesHeader."EDI Ship To Mandatory", then Ship-to Code is MANDATORY - end

                        // pr 11/18/24 If SalesHeader."EDI Buyer Part Number Mandory", thenReference Item No is MANDATORY - start
                        if (Cust."EDI Buyer Part Number Mandory") then begin
                            SalesLine.Reset();
                            SalesLine.SetRange("Document No.", SalesHeader."No.");
                            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                            SalesLine.SetRange(Type, SalesLine.Type::Item);
                            if (SalesLine.FindSet()) then
                                repeat
                                    if (StrLen(SalesLine."Item Reference No.") <= 0) then
                                        ERROR(TxtItemRefNoErr, SalesLine."No.");
                                until SalesLine.Next() = 0;
                        end;
                        // pr 11/18/24 If SalesHeader."EDI Buyer Part Number Mandory", thenReference Item No is MANDATORY - end
                    end;
                end;
                //mbr 5/15/24 - end
                //mbr 2/1/24 - mark Record as posted in Master BOL given sales order no.
                MasterBOL.reset;
                MasterBOL.SetRange("Sales Order No.", SalesHeader."No.");
                IF MasterBOl.FindSet() then
                    repeat
                        MasterBOL.Posted := true;
                        MasterBOL.Modify();
                    until MasterBOL.Next = 0;
                //mbr 2/1/24  - end of mark Record
                //mbr 5/14/24 -- store SO No. for later use
                SO_No := SalesHeader."No.";
                //mbr 5/14/24 - end

                //mbr 12/10/24 - start
                //Run the Recalc of Allowance/Discount if EDI specific
                //GenCU.ReCalcEDI(SalesHeader, true);
                SalesHeader.ReCalcEDI(true);

                //PR 1/2/24 - check if there are other types of sales line records <> item if invoiced from Whse Shipment - start
                IF (SalesHeader.Invoice = true) and (SalesHeader.IncludeNonItemWhsePost = true) then begin
                    salesline.Reset();
                    salesline.SetRange("Document No.", SalesHeader."No.");
                    salesline.SetRange("Document Type", SalesHeader."Document Type");
                    salesline.SetFilter(Type, '<>%1', salesline.Type::Item);
                    if salesline.findset then
                        repeat
                            bupdate := false;
                            if salesline."Quantity Shipped" < salesline.Quantity then begin
                                salesline.Validate("Qty. to Ship", salesline.Quantity - salesline."Quantity Shipped");
                                bupdate := true;
                            end;

                            if salesline."Quantity Invoiced" < salesline.Quantity then begin
                                salesline.Validate("Qty. to Invoice", salesline.Quantity - salesline."Quantity Invoiced");
                                bupdate := true;
                            end;
                            if bupdate = true then
                                salesline.Modify();
                        until salesline.Next() = 0;
                end;
                //PR 1/2/24 - check if there are other types of sales line records <> item if invoiced from Whse Shipment - end
            end



        end;



    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', true, true)]
    local procedure "Sales-Post_OnAfterPostSalesDoc"
     (
         var SalesHeader: Record "Sales Header";
         var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
         SalesShptHdrNo: code[20];
         RetRcpHdrNo: Code[20];
         SalesInvHdrNo: Code[20];
         SalesCrMemoHdrNo: Code[20];
         CommitIsSuppressed: Boolean;
         InvtPickPutaway: Boolean;
         var CustLedgerEntry: Record "Cust. Ledger Entry";
         WhseShip: Boolean;
         WhseReceiv: Boolean;
         PReviewMode: Boolean
    )
    var
        GenCU: Codeunit GeneralCU;
    begin
        //MBr 5/14/24 - Update pertinent information in CartonINformation following the post
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            PSS.RESET;
            PSS.SetRange("No.", SalesShptHdrNo);
            IF PSS.FindFirst() then begin

                CI.RESET;
                CI.SetRange("Document No.", PSS."Order No.");
                IF CI.FindSet() then
                    repeat
                        GetILELot := '';
                        CI.PSSNo := PSS."No.";
                        CI."Sell-to Customer No." := PSS."Sell-to Customer No.";
                        CI."External Document No." := PSS."External Document No.";
                        CI.Posted := true;
                        ILE.Reset;
                        ILE.SetRange("Item No.", CI."Item No.");
                        ILE.Setrange("Entry Type", ILE."Entry Type"::Sale);
                        ILE.SetRange("Document Type", ILE."Document Type"::"Sales Shipment");
                        ILE.SetRange("Document No.", PSS."No.");
                        ILE.SetRange("Document Line No.", CI."DocumentLine No.");
                        IF ILE.FindSet() then
                            repeat
                                IF STRLEN(GetILELot) = 0 then
                                    GetILELot := ILE."Lot No.";

                                IF GetILELot <> ILE."Lot No." then
                                    IF STRLEN(GetILELot) < STRLEN(ILE."Lot No.") then
                                        GetILELot := ILE."Lot No.";
                            until ILE.Next() = 0;
                        IF StrLen(GetILELot) > 0 then
                            CI."Lot No." := ILE."Lot No.";

                        CI.Modify();
                    until CI.Next = 0;

            end;
            //Auto send email if applicable

            //7/3/25 - Update Earliest Start Ship Date
            GenCU.PostSO_UpdEarliestStartDt(SalesShptHdrNo);

        end;


    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", OnAfterConfirmPost, '', false, false)]

    local procedure OnAfterConfirmPost(var SalesHeader: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
        txtNotInRangeErr: Label 'Posting Date %1 is outside your allowable posting date range.  Please correct';
        txtConfrimMessage: Label 'Posting Date of %1 needs to be %2.  Do you want to override by forcing posting date of %3?';
        txtTaskAborted: Label 'Task Aborted!';
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            Cust.Reset;
            IF Cust.Get(SalesHeader."Sell-to Customer No.") then begin
                IF Cust."EDI ASN Customer" = true then begin

                    // pr 8/14/24 - if customer is an  EDI ASN Customer, check Shipment Date in the 
                    //              sales order and if Shipment Date <> Posting Date, error out and remind user shipment Date <> Posting Date;
                    if (SalesHeader."Shipment Date" <> SalesHeader."Posting Date") then
                        ERROR(TxtShipDateNotMatch);
                end;
            end;
        end;
        //PR 4/15/25 - check if posting date equals today - start 
        if (SalesHeader."Posting Date" <> Today) then begin
            UserSetup.Reset();
            UserSetup.SetRange("User ID", UserId);
            if (UserSetup.FindSet()) then begin
                // check if the posting date is within rage of ther user's posting date range
                if (SalesHeader."Posting Date" <= UserSetup."Allow Posting To") and (SalesHeader."Posting Date" >= UserSetup."Allow Posting From") then begin
                    //give Confirmation Dialog
                    if Dialog.Confirm(StrSubstNo(txtConfrimMessage, SalesHeader."Posting Date", Today, SalesHeader."Posting Date"), true) = false then begin
                        Error(txtTaskAborted);
                    end
                end
                else
                    Error(txtNotInRangeErr, SalesHeader."Posting Date");

            end
            else
                Error(txtNotInRangeErr, SalesHeader."Posting Date");
        end;
        //PR 4/15/25 - check if posting date equals today - end 
    end;

    //pr 5/30/25 - start

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Batch", OnAfterCopyRegNos, '', false, false)]
    local procedure OnAfterCopyRegNos(var ItemJournalLine: Record "Item Journal Line"; var ItemRegNo: Integer; var WhseRegNo: Integer)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        documentAttachment: Record "Document Attachment";
        documentAttachmentNew: Record "Document Attachment";
        lienNo: Integer;
    begin

        //pr 5/30/25 - if Item Journal Line is not of type Item, then do not copy attachments;
        //on post of item Journal, all attachments should follow to item ledger entries
        ItemJournalLine.FindSet();
        repeat
            if (ItemJournalLine."Line No." = 10000) then
                lienNo := 0
            else
                lienNo := ItemJournalLine."Line No.";
            ItemLedgerEntry.Reset();
            ItemLedgerEntry.SetRange("Item No.", ItemJournalLine."Item No.");
            ItemLedgerEntry.SetRange("Document No.", ItemJournalLine."Document No.");
            ItemLedgerEntry.SetRange(Quantity, ItemJournalLine.Quantity);
            ItemLedgerEntry.SetRange("Entry Type", ItemJournalLine."Entry Type");
            if (ItemLedgerEntry.FindSet()) then
                repeat

                    documentAttachment.Reset();
                    documentAttachment.SetRange("Table ID", Database::"Item Journal Line");
                    documentAttachment.SetFilter("Line No.", '%1|%2', lienNo, ItemJournalLine."Line No.");
                    if (documentAttachment.FindSet()) then
                        repeat
                            //copy attachments to item ledger entry
                            documentAttachmentNew.Init();
                            documentAttachmentNew.Copy(documentAttachment);
                            documentAttachmentNew."Table ID" := Database::"Item Ledger Entry";
                            documentAttachmentNew."Line No." := ItemLedgerEntry."Entry No.";
                            documentAttachmentNew.Insert(true);
                        until documentAttachment.Next() = 0;
                    documentAttachment.Reset();
                    documentAttachment.SetRange("Table ID", Database::"Item Journal Line");
                    documentAttachment.SetFilter("Line No.", '%1|%2', lienNo, ItemJournalLine."Line No.");
                    if (documentAttachment.FindSet()) then
                        repeat
                            documentAttachment.Delete();
                        until documentAttachment.Next() = 0;
                until ItemLedgerEntry.Next() = 0;
        until ItemJournalLine.Next() = 0;
    end;
    //pr 5/30/25 - end

    //PR 1/21/25 - check if loc code <> '' when posting AssemblyOrder - start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", OnBeforePost, '', false, false)]
    local procedure OnBeforeAssemblyOrderPost(var AssemblyHeader: Record "Assembly Header")
    var
        TxtAssemblyOrderLocCodeErr: Label 'Assembly Order %1 CANNOT have Blank Location Code.';
        AssemblyLine: Record "Assembly Line";
        Item: Record Item;
        ItemSub: Record "Item Substitution";
        BOMComments: Record "BOM Component";
        // BOMCommentsCheck: Record "BOM Component";
        assemblyLineCount: Integer;
        assemblyBOMCount: Integer;
        tmpItems: Record POItemSummary temporary;
        i: Integer;
        txtAssbmlyNotInBOM: Label 'Assembly lines %1 not found in Assembly BOM';
        txtAssbmlyNotInBOMDup: Label 'Assembly lines %1 found multiple times';
        txtAssbmlyQtyErr: Label 'Item %1 qty to consume %2 <> expected Qty to consume %3.';
        txtIncompleteBOM: Label 'Assembly BOM for %1 is missing item %2 or its substitute.';
        ChkAssemblyLine: Record "Assembly Line";
        bFound: Boolean;
    begin
        if (StrLen(AssemblyHeader."Location Code") <= 0) then
            ERROR(TxtAssemblyOrderLocCodeErr, AssemblyHeader."No.");
        //PR 4/1/25 - users CANNOT post if AssemblyHdr.Quantity to Assemble * qty Per <> quantity to consume for each line - start
        tmpItems.DeleteAll();
        tmpItems.Reset();
        AssemblyLine.Reset();
        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
        AssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
        AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
        if (AssemblyLine.FindSet()) then
            repeat
                i += 1;
                bFound := false;
                // check if lines exist in Assembly BOM
                BOMComments.Reset();
                BOMComments.SetRange("Parent Item No.", AssemblyHeader."Item No.");
                BOMComments.SetRange("No.", AssemblyLine."No.");
                // if not in Assembly BOM
                if (not BOMComments.FindSet()) then begin
                    // check if Assembly BOM contains an item that is substituted by assmebly line's item
                    BOMComments.Reset();
                    BOMComments.SetRange("Parent Item No.", AssemblyHeader."Item No.");
                    if (BOMComments.FindSet()) then
                        repeat
                            // checks is assemply line's item is being used as a subsitute for Assembly BOM
                            ItemSub.reset;
                            ItemSub.SetRange("No.", BOMComments."No.");
                            ItemSub.SetRange(Type, ItemSub.Type::Item);
                            ItemSub.SetRange("Substitute No.", AssemblyLine."No.");
                            if (ItemSub.FindFirst()) then begin
                                // checks for duplicates of the item assmebly line's item is subbing for
                                tmpItems.Reset();
                                tmpItems.SetRange("No.", BOMComments."No.");
                                // if found duplicate of the item assmebly line's item is subbing for
                                if (tmpItems.FindSet()) then begin
                                    tmpItems.Quantity += AssemblyLine."Quantity to Consume";
                                    tmpItems.Modify();
                                    bFound := true;
                                end
                                // if duplicate not found saves data under the item assemply line's item is being used as a subsitute for.
                                // So its data can be combined with other assembly lines containing 
                                // the item the current assemply line's item is being used as a subsitute for
                                else begin
                                    tmpItems.Init();
                                    tmpItems."Line No." := i;
                                    tmpItems.Quantity := AssemblyLine."Quantity to Consume";
                                    tmpItems."No." := BOMComments."No.";
                                    tmpItems."Quantity per" := BOMComments."Quantity per";
                                    tmpItems.Insert();
                                    bFound := true;
                                end;
                            end
                        until BOMComments.next() = 0;
                    // if assemlby line not in Assemlby BOM and it is not being used as a subsitution for an item in the Assembly BOM 
                    // look for and check the assembly line's subsitutiuon item
                    if (bFound = false) then begin
                        // check subsitutuion item if not found in BOM
                        ItemSub.reset;
                        ItemSub.SetRange("No.", AssemblyLine."No.");
                        ItemSub.SetRange(Type, ItemSub.Type::Item);
                        if (ItemSub.FindFirst()) then begin

                            // if found check assembly bom for sub item
                            BOMComments.Reset();
                            BOMComments.SetRange("Parent Item No.", AssemblyHeader."Item No.");
                            BOMComments.SetRange("No.", ItemSub."Substitute No.");
                            if (not BOMComments.FindSet()) then begin
                                // assembly line item and has sub but subsituion not found in assembly bom
                                Error(txtAssbmlyNotInBOM, ItemSub."Substitute No.");
                            end;
                            // add assembly lines data to be checked later
                            // checks if items sub was found before
                            tmpItems.Reset();
                            tmpItems.SetRange("No.", AssemblyLine."No.");
                            // if found duplicate items sub before combines them
                            if (tmpItems.FindSet()) then begin
                                tmpItems.Quantity += AssemblyLine."Quantity to Consume";
                                tmpItems.Modify();
                            end
                            else begin
                                tmpItems.Init();
                                tmpItems."Line No." := i;
                                tmpItems.Quantity := AssemblyLine."Quantity to Consume";
                                tmpItems."Quantity per" := BOMComments."Quantity per";
                                tmpItems."No." := AssemblyLine."No.";
                                tmpItems.Insert();
                            end;
                        end
                        // item not found in assembly bom and has no sub
                        else
                            Error(txtAssbmlyNotInBOM, AssemblyLine."No.");
                    end;

                end
                // if in Assembly BOM
                else begin
                    // checks for duplicates or items sub was found before
                    tmpItems.Reset();
                    tmpItems.SetRange("No.", AssemblyLine."No.");
                    // if found duplicate item or items sub combines them
                    if (tmpItems.FindSet()) then begin
                        tmpItems.Quantity += AssemblyLine."Quantity to Consume";
                        tmpItems.Modify();
                    end
                    else begin
                        tmpItems.Init();
                        tmpItems."Line No." := i;
                        tmpItems.Quantity := AssemblyLine."Quantity to Consume";
                        tmpItems."No." := AssemblyLine."No.";
                        tmpItems."Quantity per" := BOMComments."Quantity per";
                        tmpItems.Insert();
                    end;
                end;

            until AssemblyLine.Next() = 0;
        // check if Quantity to Consume = Quantity to Assemble*Quantity per for each line
        tmpItems.Reset();
        if (tmpItems.FindFirst()) then
            repeat
                if (tmpItems."Quantity" <> (AssemblyHeader."Quantity to Assemble" * tmpItems."Quantity per")) then begin
                    // if assemlby BOM has asselbly lines item/items sub or assembly lines item is being used as a sub but Quantity to Consume <> Quantity to Assemble*Quantity 
                    Error(txtAssbmlyQtyErr, tmpItems."No.", tmpItems."Quantity", (AssemblyHeader."Quantity to Assemble" * tmpItems."Quantity per"));
                end;
            until tmpItems.Next() = 0;
        //PR 4/1/25 - users CANNOT post if AssemblyHdr.Quantity to Assemble * qty Per <> quantity to consume for each line - end
        //MBR 4/1/25 - lastly, let's make sure we have every assembly item present in assembly lines as dicated by the Assembly BOM
        BOMComments.Reset();
        BOMComments.SetRange("Parent Item No.", AssemblyHeader."Item No.");
        BOMComments.SetRange(Type, BOMComments.Type::Item);
        if BOMComments.FindSet() then
            repeat
                AssemblyLine.Reset();
                AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
                AssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
                AssemblyLine.SetRange("Type", AssemblyLine.Type::Item);
                AssemblyLine.SetRange("No.", BOMComments."No.");
                if Not AssemblyLine.FindFirst() then begin
                    bFound := false;
                    //let's find a substitution if any
                    ItemSub.reset;
                    ItemSub.SetRange("No.", BOMComments."No.");
                    ItemSub.SetRange(Type, ItemSub.Type::Item);
                    if ItemSub.FindSet() then
                        repeat
                            ChkAssemblyLine.Reset();
                            ChkAssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
                            ChkAssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
                            ChkAssemblyLine.SetRange("Type", ChkAssemblyLine.Type::Item);
                            ChkAssemblyLine.SetRange("No.", ItemSub."Substitute No.");
                            if ChkAssemblyLine.FindFirst() then
                                bFound := true;
                        until ItemSub.Next() = 0;
                    if bFound = false then
                        Error(txtIncompleteBOM, AssemblyHeader."Item No.", BOMComments."No.");
                end;
            until BOMComments.Next() = 0;
        //mbr 04/1/25 - end
    end;

    //PR 1/21/25 - check if loc code <> '' when posting AssemblyOrder - end
    var
        MasterBOL: Record "Master BOL";
        CustomerInvDisc: Record "Cust. Invoice Disc.";
        ErrInvoiceDiscount: Label 'Customer %1 is set up with Invoice Discount %2% but the Invoice Discount Amount for SO %3 = 0.  Please review.';
        SO_No: Code[20];
        PSS: Record "Sales Shipment Header";
        CI: Record CartonInformation;
        ILE: Record "Item Ledger Entry";
        Cust: Record Customer;
        TxtBOLMandatory: Label 'Customer %1 is an EDI ASN Customer.  BOL No. is Mandatory.  Please review.';
        TxtPackageMandatory: Label 'Customer %1 is an EDI ASN Customer.  Package Information is Mandatory.  Please review.';
        TxtShipDateNotMatch: Label 'Shipment Date MUST BE EQUAL to the Posting Date for EDI ASN Customers';
        TxtPaymentTerms: Label 'Payment Terms Code is Mandatory.  Please review.';
        TxtShipToCodeErr: Label 'Ship-to Code is MANDATORY';
        TxtItemRefNoErr: Label 'Reference Item No. for %1 is MANDATORY';
        TxtZeroUnitPriceErr: Label 'Sales Line %1 has 0 Unit Price.';

        TxtOvrideZeroUnitPriceErr: Label 'SO %1 have 1 ore more items with 0 Unit Price. Override?';
        GetILELot: Text;
        Email: Codeunit Email;
        GenCU: Codeunit GeneralCU;
        Item: Record Item;
        SalesLine: Record "Sales Line";
        bCont: Boolean;

}
