page 50027 "Container Order Card"
{
    ApplicationArea = All;
    Caption = 'Container Order Card';
    PageType = Card;
    SourceTable = "Container Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Container No."; Rec."Container No.")
                {
                    ToolTip = 'Specifies the value of the Container No. field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Enabled = Not bEnabled;
                }

                field("Freight Bill Amount"; Rec."Freight Bill Amount")
                {
                    ApplicationArea = All;
                    Enabled = Not bEnabled;
                }
                field("Freight Bill No."; Rec."Freight Bill No.")
                {
                    ApplicationArea = All;
                    Enabled = Not bEnabled;
                }
                field("Transfer Order No. Assigned"; Rec."Transfer Order No.")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        TOPg: Page "Transfer Order";
                        TOHdr: Record "Transfer Header";
                        PoTRPg: Page "Posted Transfer Receipt";
                        TRHdr: Record "Transfer Receipt Header";
                    begin

                        TOHdr.Reset();
                        TOHdr.SetRange("No.", Rec."Transfer Order No.");
                        if TOHdr.FindFirst() then begin
                            Clear(TOPg);
                            TOPg.SetTableView(TOHdr);
                            TOPg.Run();
                        end
                        else begin
                            TRHdr.Reset();
                            TRHdr.SetRange("Transfer Order No.", Rec."Transfer Order No.");
                            if TRHdr.FindFirst() then begin
                                Clear(PoTRPg);
                                PoTRPg.SetTableView(TRHdr);
                                PoTRPg.Run();
                            end;
                        end;
                    end;
                }
                field("Telex Released"; Rec."Telex Released")
                {
                    ApplicationArea = All;
                }

                field("Freight Cost"; Rec."Freight Cost")
                {
                    ToolTip = 'Specifies the value of the Freight Cost field.';
                    Enabled = true;
                }

                field(Forwarder; Rec.Forwarder)
                {
                    ApplicationArea = All;
                    Enabled = true;
                }
                field("Container Size"; Rec."Container Size")
                {
                    ApplicationArea = All;
                    Enabled = true;
                }
                //PR 2/17/24 - start
                field("Total CBM"; Rec.GetTotalCBM())
                {
                    ApplicationArea = All;
                    StyleExpr = TxtCBMStyle;
                }
                field("Total Weight"; Rec.GetTotalWeight())
                {
                    ApplicationArea = All;
                }
                //PR 2/17/24 - end
                //PR 2/17/25 - start
                field("Container CBM"; Rec."Container CBM")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Container Percentage Threshold"; Rec."Percentage Threshold")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                //PR 2/17/25 - end
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Enabled = bEnabled;
                }
                field("Port of Loading"; Rec."Port of Loading")
                {
                    ApplicationArea = All;
                    Enabled = bEnabled;
                }
                field("Port of Discharge"; Rec."Port of Discharge")
                {
                    ApplicationArea = All;
                    Enabled = bEnabled;
                }
                field(CreatedBy; Rec.CreatedBy)
                {
                    ApplicationArea = All;
                }
                field(CreatedDate; Rec.CreatedDate)
                {
                    ApplicationArea = All;
                }
                field(ModifiedBy; Rec.ModifiedBy)
                {
                    ApplicationArea = All;
                }
                field(ModifiedDate; Rec.ModifiedDate)
                {
                    ApplicationArea = All;
                }


                //PR 2/17/25 - start
                field("Filling Notes"; Rec."Filling Notes")
                {
                    ApplicationArea = all;

                }
                //PR 2/17/25 - end
            }
            group(Container)
            {
                field(ETD; Rec.ETD)
                {
                    ToolTip = 'Specifies the value of the Estimated Time of Departure field.';

                }
                field(ETA; Rec.ETA)
                {
                    ToolTip = 'Specifies the value of the Estimated Time of Arrival field.';

                }
                field(ActualETD; Rec.ActualETD)
                {
                    ApplicationArea = ALL;
                }
                field(ActualETA; Rec.ActualETA)
                {
                    ApplicationArea = ALL;
                }
                field(LFD; Rec.LFD)
                {
                    ApplicationArea = All;
                }

                field("Actual Pull Date"; Rec."Actual Pull Date")
                {
                    ApplicationArea = All;
                }
                field("Actual Pull Time"; Rec."Actual Pull Time")
                {
                    ApplicationArea = All;
                }
                field("Actual Delivery Date"; Rec."Actual Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("Empty Notification Date"; Rec."Empty Notification Date")
                {
                    ApplicationArea = All;
                }
                // pr 12/2/24 - end
                field("Container Return Date"; Rec."Container Return Date")
                {
                    ApplicationArea = All;

                }

                field(Carrier; Rec.Carrier)
                {
                    ApplicationArea = All;
                }
                field(Terminal; Rec.Terminal)
                {
                    ApplicationArea = All;
                }
                field(Drayage; Rec.Drayage)
                {
                    ApplicationArea = All;
                }
                field("FDA Hold"; Rec."FDA Hold")
                {
                    ApplicationArea = All;
                }


                // pr 12/2/24 - start
                field("Container Status Notes"; Rec."Container Status Notes")
                {
                    ApplicationArea = All;
                }
            }
            part(ContainerLines; "Container Order Subform")
            {
                ApplicationArea = Basic, Suite;
                Editable = bEnabled;
                //PR 2/5/25 make doc no drill down to purch order or transfer order - start
                //Enabled = bEnabled;
                Enabled = true;
                //PR 2/5/25 make doc no drill down to purch order or transfer order - end
                SubPageLink = "Container No." = field("Container No.");
                UpdatePropagation = Both;
            }
        }
        area(FactBoxes)
        {

            // pr 8/16/24 - added support for attaching documents and keeps track of # of attachments - start
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Container Header"),
                            "No." = field("Container No.");
            }
            // pr 8/16/24 - added support for attaching documents and keeps track of # of attachments - end
        }


    }
    actions
    {
        area(Processing)
        {
            action("Get Purchase Order Lines")
            {

                ApplicationArea = all;
                Image = Purchase;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = bEnabled;
                trigger OnAction()
                begin
                    if strlen(Rec."Container No.") = 0 then
                        Error(txtContainerNoMandatory)
                    else
                        GetPOLines();
                end;


            }
            action("Post")
            {
                ApplicationArea = all;
                Image = Purchase;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Contianerline: Record "ContainerLine";


                begin
                    //pr 6/20/25 - check for fda hold - start
                    Contianerline.Reset();
                    Contianerline.SetRange("Container No.", Rec."Container No.");
                    if (Contianerline.FindSet()) then
                        repeat
                            if (Contianerline."FDA Hold" = true) then
                                error(txtFDAErr, Contianerline."Item No.", Contianerline."Lot No.");
                        until Contianerline.Next() = 0;
                    //pr 6/20/25 - check for fda hold - end

                    if (Rec.Status = Rec.Status::Completed) then begin
                        Clear(popupConfirm);
                        popupConfirm.setMessage(postComfirmTxt);
                        Commit;
                        if popupConfirm.RunModal() = Action::No then begin
                            Error(errorTxtForPostCanceled)
                        end;
                        // fills posted container header table
                        FillPostedContainerOrder();

                    end
                    else begin
                        Error(errorExtForPostNotComplete);
                    end;
                end;
            }
            // pr 10/8/24 - make button to create new transfer order - start
            action("Create Transfer Order")
            {
                ApplicationArea = all;
                Image = Reserve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;
                RunObject = Page "Transfer Order";
                RunPageMode = Create;

            }
            // pr 10/8/24 - make button to create new transfer order - end
        }

    }
    var
        txtContainerNoMandatory: Label 'Container No. is Mandatory.  Please review.';
        txtFDAErr: label 'This item/lot Item No: %1, Lot No: %2 is on FDA Hold and cannot be posted.';
        errorExtForPostNotComplete: Label 'You cannot post if the status is not Completed';
        errorTxtForPostCanceled: Label 'Task Aborted';
        postComfirmTxt: Label 'Do you want to post?';
        errorNoQtyToAssgn: Label 'Assign Now';
        errorNoQtyToAssgnLessThanOutstanding: Label 'Assgn to container less than outsanding qty-assigned to qty';
        bEnabled: Boolean;
        popupConfirm: Page "Confirmation Dialog";
        TxtCBMStyle: Text;


    procedure GetPOLines()
    var
        PurchLines: Record "Purchase Line";
        PurchLines2: Record "Purchase Line";
        PurchaseOrderLines: Page "Purchase Lines";
        purchOrderSubForm: Page "Purchase Order Subform";
        purchOrderCard: page "Purchase Order";
        SelectInCont: record SelectIntoContainer;
        ContainerLine: record ContainerLine;
        binit: Boolean;
        ChkContainerHdr: record "Container Header";
        items: Record Item;
        bUpdate: boolean;
        GetPOLine: Record "Purchase Line";
    begin
        PurchLines.Reset;
        if (PurchLines.findset) then begin
            repeat
                // PR 7/12/24
                /*if (PurchLines."Qty to Assign to Container" <= 0) then begin
                    PurchLines."Qty to Assign to Container" := PurchLines."Outstanding Quantity" - PurchLines."Qty to Assigned to Container";
                    PurchLines.Modify();

                end;*/
                PurchLines."Qty to Assign to Container" := PurchLines."Outstanding Quantity" - PurchLines."Qty Assigned to Container";
                PurchLines.Modify();

            until PurchLines.Next() = 0;
            Commit();
        end;
        PurchLines.Reset;
        PurchLines.SetFilter(ItemType, '<>%1', PurchLines.ItemType::Service);
        iF PurchLines.findset then begin
            SelectInCont.Reset();
            SelectInCont.SetRange(UserID, UserId);
            SelectInCont.SetRange("Container No.", rec."Container No.");
            If SelectInCont.FindSet() then begin
                SelectInCont.DeleteAll();
                Commit();
            end;

            Clear(PurchaseOrderLines);
            PurchaseOrderLines.Editable := true;
            PurchaseOrderLines.SetContainer(true, rec."Container No.");
            PurchaseOrderLines.SetContainerVis(true);
            PurchaseOrderLines.SetIsQtyToAssgn(true);

            PurchaseOrderLines.SetTableView(PurchLines);
            PurchaseOrderLines.SetRecord(PurchLines);

            PurchaseOrderLines.Editable := true;
            //PurchaseOrderLines.Run();
            if PurchaseOrderLines.RunModal() = ACTION::OK then begin
                SelectInCont.Reset();
                SelectInCont.SetRange(UserID, UserId);
                SelectInCont.SetRange("Container No.", rec."Container No.");
                if SelectInCont.FindSet() then
                    repeat


                        ContainerLine.Init();
                        ContainerLine."Container No." := Rec."Container No.";
                        ContainerLine."Document No." := SelectInCont.DocumentNo;
                        ContainerLine.Validate("Item No.", SelectInCont.ItemNo);
                        ContainerLine.Quantity := SelectInCont.Quantity;
                        ContainerLine."Quantity Base" := SelectInCont."Quantity Base";
                        ContainerLine."Unit of Measure Code" := SelectInCont."Unit of Measure Code";
                        ContainerLine."Buy-From Vendor No." := SelectInCont."Buy-from Vendor No.";
                        ContainerLine."Document Line No." := SelectInCont.DocumentLineNo;
                        ContainerLine."Port of Discharge" := SelectInCont."Port of Discharge";
                        ContainerLine."Port of Loading" := SelectInCont."Port of Loading";
                        ContainerLine."Location Code" := SelectInCont."Location Code";
                        ContainerLine.DeliveryNotes := SelectInCont.DeliveryNotes;
                        ContainerLine.Validate("Requested In Whse Date", SelectInCont.RequestedInWhseDate);
                        ContainerLine.Validate(EstimatedInWarehouseDate, SelectInCont.EstimatedInWarehouseDate);
                        ContainerLine.ActualCargoReadyDate := SelectInCont.ActualCargoReadyDate;
                        ContainerLine.SourceNo := Database::"Purchase Line";
                        GetPOLine.Reset();
                        GetPOLine.SetRange("Document Type", GetPOLine."Document Type"::Order);
                        GetPOLine.SetRange("Document No.", SelectInCont.DocumentNo);
                        GetPOLine.SetRange("Line No.", SelectInCont.DocumentLineNo);
                        GetPOLine.SetRange(Type, GetPOLine.Type::Item);
                        GetPOLine.SetRange("No.", SelectInCont.ItemNo);
                        IF GetPOLine.FindFirst() THEN BEGIN
                            ContainerLine."Item Description Snapshot" := GetPOLine.Description;
                        END;

                        ContainerLine.Insert();
                        if binit = false then begin
                            ChkContainerHdr.Reset();
                            ChkContainerHdr.SetRange("Container No.", rec."Container No.");
                            if ChkContainerHdr.FindFirst() then begin
                                if strlen(SelectInCont."Port of Discharge") > 0 then begin
                                    ChkContainerHdr."Port of Discharge" := SelectInCont."Port of Discharge";
                                    bUpdate := true;
                                end;
                                if strlen(SelectInCont."Port of Loading") > 0 then begin
                                    ChkContainerHdr."Port of Loading" := SelectInCont."Port of Loading";
                                    bUpdate := true;
                                end;
                                if strlen(SelectInCont."Location Code") > 0 then begin
                                    ChkContainerHdr."Location Code" := SelectInCont."Location Code";
                                    bUpdate := true;
                                end;
                                if bUpdate = true then
                                    ChkContainerHdr.Modify();
                            end;
                        end;

                    until SelectInCont.Next() = 0;
                CurrPage.Update(false);
            end;
        end;

    end;

    procedure FillPostedContainerOrder()
    var
        postedContainerOrder: Record "Posted Container Header";
        postedContainerOrderPage: Page "Posted Container Orders";
        postedContainerLn: Record "Posted Container Line";
        ContainerLn: Record ContainerLine;
        DocumentAttachment: Record "Document Attachment";
        DocumentAttachmentFileInsert: Record "Document Attachment";
    begin
        postedContainerOrder.Reset();
        postedContainerOrder.Init();
        postedContainerOrder."Container No." := Rec."Container No.";
        postedContainerOrder."Freight Cost" := Rec."Freight Cost";
        postedContainerOrder.ETD := Rec.ETD;
        postedContainerOrder.ETA := Rec.ETA;
        postedContainerOrder.Forwarder := Rec.Forwarder;
        postedContainerOrder.CreatedBy := Rec.CreatedBy;
        postedContainerOrder.CreatedDate := Rec.CreatedDate;  //We want to capture the original date Container was created
        postedContainerOrder."Container Size" := rec."Container Size";
        postedContainerOrder."Port of Discharge" := Rec."Port of Discharge";
        postedContainerOrder."Port of Loading" := Rec."Port of Loading";
        postedContainerOrder."Location Code" := Rec."Location Code";
        postedContainerOrder."Transfer Order No." := Rec."Transfer Order No.";
        postedContainerOrder."Posting Date" := Rec."Posting Date";
        postedContainerOrder."Container Return Date" := Rec."Container Return Date";
        postedContainerOrder."Freight Bill Amount" := Rec."Freight Bill Amount";
        postedContainerOrder."Freight Bill No." := Rec."Freight Bill No.";
        postedContainerOrder."Empty Notification Date" := Rec."Empty Notification Date";
        postedContainerOrder.ActualETD := Rec.ActualETD;
        postedContainerOrder.ActualETA := Rec.ActualETA;
        postedContainerOrder.Carrier := Rec.Carrier;
        postedContainerOrder.LFD := Rec.LFD;
        postedContainerOrder."Actual Pull Date" := Rec."Actual Pull Date";
        postedContainerOrder."Actual Pull Time" := Rec."Actual Pull Time";
        postedContainerOrder."Actual Delivery Date" := Rec."Actual Delivery Date";
        postedContainerOrder.Drayage := Rec.Drayage;
        postedContainerOrder.Terminal := Rec.Terminal;
        postedContainerOrder."Container Status Notes" := Rec."Container Status Notes";
        postedContainerOrder."Receiving Status" := REc."Receiving Status";
        //PR 3/6/25 - start
        postedContainerOrder.Status := REc.Status;
        //PR 3/6/25 - end
        //MBR 3/25/25 - start
        postedContainerOrder."Transfer-to Code" := Rec."Transfer-to Code";
        postedContainerOrder."Filling Notes" := Rec."Filling Notes";
        //MBR 03/25/25 - end


        postedContainerOrder.Insert();

        ContainerLn.Reset();
        ContainerLn.SetRange("Container No.", Rec."Container No.");
        if ContainerLn.FindSet() then
            repeat
                postedContainerLn.Init();
                postedContainerLn."Container No." := ContainerLn."Container No.";
                postedContainerLn."Document No." := ContainerLn."Document No.";
                postedContainerLn."Item No." := ContainerLn."Item No.";
                postedContainerLn.Quantity := ContainerLn.Quantity;
                postedContainerLn."Quantity Base" := ContainerLn."Quantity Base";
                postedContainerLn."Unit of Measure Code" := ContainerLn."Unit of Measure Code";
                postedContainerLn."Buy-From Vendor No." := ContainerLn."Buy-from Vendor No.";
                postedContainerLn."Document Line No." := ContainerLn."Document Line No.";
                postedContainerLn."Port of Discharge" := ContainerLn."Port of Discharge";
                postedContainerLn."Port of Loading" := ContainerLn."Port of Loading";
                postedContainerLn."Location Code" := ContainerLn."Location Code";
                postedContainerLn.DeliveryNotes := ContainerLn.DeliveryNotes;
                postedContainerLn."Requested In Whse Date" := ContainerLn."Requested In Whse Date";
                postedContainerLn.EstimatedInWarehouseDate := ContainerLn.EstimatedInWarehouseDate;
                postedContainerLn.ActualCargoReadyDate := ContainerLn.ActualCargoReadyDate;
                postedContainerLn.PONo := ContainerLn.PONo;
                postedContainerLn."PO Owner" := ContainerLn."PO Owner";
                postedContainerLn."PO Vendor" := ContainerLn."PO Vendor";
                postedContainerLn.POClosed := ContainerLn.POClosed;
                postedContainerLn."Actual Pull Date" := ContainerLn."Actual Pull Date";
                postedContainerLn.SourceNo := ContainerLn.SourceNo;
                postedContainerLn.Insert();
            until ContainerLn.Next() = 0;


        //attach documents to new table
        DocumentAttachment.SetRange("No.", Rec."Container No.");
        DocumentAttachment.SetRange("Table ID", Database::"Container Header");
        if DocumentAttachment.FindSet() then
            repeat
                DocumentAttachmentFileInsert := DocumentAttachment;
                DocumentAttachmentFileInsert."Table ID" := Database::"Posted Container Header";
                DocumentAttachmentFileInsert."No." := postedContainerOrder."Container No.";
                DocumentAttachmentFileInsert.Insert();
            until DocumentAttachment.Next() = 0;



        //now, let's delete the Container lines, then container 
        ContainerLn.reset;
        ContainerLn.SetRange("Container No.", Rec."Container No.");
        If ContainerLn.FindSet() then
            ContainerLn.DeleteAll(false);
        Rec.Delete();
        CurrPage.Update(false);
        postedContainerOrderPage.Update();
    end;

    trigger OnAfterGetRecord()
    var
        TransferOrder: Record "Transfer Header";
        PostedTransferRec: Record "Transfer Receipt Header";
        ContainerLn: Record ContainerLine;
        UserSetup: Record "User Setup";
    begin
        Rec."Posting Date" := Today;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        UserSetup.SetRange(POAdmin, true);
        If UserSetup.FindFirst() then begin
            bEnabled := true;
        end
        else If (Rec.Status = Rec.Status::Assigned) or (Rec.Status = Rec.Status::Completed) then
            bEnabled := false
        else
            bEnabled := true;

        Rec."Telex Released" := false; //initialize

        TransferOrder.Reset();
        TransferOrder.SetRange("No.", rec."Transfer Order No.");
        if (TransferOrder.FindFirst()) then
            rec."Telex Released" := TransferOrder."Telex Released"
        else begin
            PostedTransferRec.Reset();
            PostedTransferRec.SetRange("Transfer Order No.", rec."Transfer Order No.");
            if PostedTransferRec.FindFirst() then
                rec."Telex Released" := PostedTransferRec."Telex Released";

        end;

        rec.CalcFields("Container CBM", "Percentage Threshold");
        rec.UpdateFDAHoldStatus();
        Rec.Modify();
        //PR 2/19/25 - start
        if (rec.GetTotalCBM() < (rec."Container CBM" * 0.75)) then
            TxtCBMStyle := 'Unfavorable'
        else
            TxtCBMStyle := 'Standard';
        //PR 2/19/25 - end
    end;



    trigger OnInit()
    begin
        bEnabled := true;
    end;

    var
        purchaseOrderLines: Page "Purchase Lines";


}
