page 50028 "Container Order Subform"
{
    ApplicationArea = All;
    Caption = 'Container Lines';
    PageType = ListPart;
    SourceTable = ContainerLine;
    DeleteAllowed = true;
    //UsageCategory = Lists;
    //ModifyAllowed = false;
    InsertAllowed = false;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document No. field.';
                    Editable = false;
                    DrillDown = true;


                    trigger OnDrillDown()
                    var
                        transferOrder: Page "Transfer Order";
                        transferHdr: Record "Transfer Header";
                        purchHdr: Record "Purchase Header";
                        purchOrder: Page "Purchase Order";
                        bPageFound: Boolean;
                        PurchRcptOrder: Page "Posted Purchase Receipt";
                        PurchRcptHdr: record "Purch. Rcpt. Header";
                        TransRcptOrder: Page "Posted Transfer Receipt";
                        TransRcptHdr: Record "Transfer Receipt Header";
                    begin

                        purchHdr.Reset();
                        purchHdr.SetRange("No.", rec."Document No.");
                        if (purchHdr.FindFirst()) then begin
                            Clear(purchOrder);
                            purchOrder.SetTableView(purchHdr);
                            purchOrder.Run();
                        end
                        else begin
                            purchHdr.Reset();
                            purchHdr.SetRange("No.", rec.PONo);
                            if (purchHdr.FindFirst()) then begin
                                Clear(purchOrder);
                                purchOrder.SetTableView(purchHdr);
                                purchOrder.Run();
                            end
                            else begin
                                PurchRcptHdr.Reset();
                                PurchRcptHdr.SetRange("Order No.", rec."Document No.");
                                If PurchRcptHdr.FindFirst() then begin
                                    Clear(PurchRcptOrder);
                                    PurchRcptOrder.SetTableView(PurchRcptHdr);
                                    PurchRcptOrder.Run();
                                end
                                else begin
                                    transferHdr.Reset();
                                    transferHdr.SetRange("No.", rec."Transfer Order No.");
                                    if (transferHdr.FindFirst()) then begin
                                        Clear(transferOrder);
                                        transferOrder.SetTableView(transferHdr);
                                        transferOrder.Run();
                                    end
                                    else begin
                                        TransRcptHdr.Reset();
                                        TransRcptHdr.SetRange("Transfer Order No.", rec."Transfer Order No.");
                                        if (TransRcptHdr.FindFirst()) then begin
                                            Clear(TransRcptOrder);
                                            TransRcptOrder.SetTableView(TransRcptHdr);
                                            TransRcptOrder.Run();
                                        end;

                                    end;
                                end;
                            end;
                        end;


                    end;

                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    Editable = false;
                }
                field("Item Description Snapshot"; Rec."Item Description Snapshot")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    Editable = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                    Editable = false;
                }
                field("Quantity Base"; Rec."Quantity Base")
                {
                    ToolTip = 'Specifies the value of the Quantity Base field.';
                    Editable = false;
                }
                field("Port of Loading"; Rec."Port of Loading")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Port of Discharge"; Rec."Port of Discharge")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Buy-From Vendor No."; Rec."Buy-From Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Requested In Whse Date"; Rec."Requested In Whse Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ActualCargoReadyDate; Rec.ActualCargoReadyDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(EstimatedInWarehouseDate; Rec.EstimatedInWarehouseDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DeliveryNotes; Rec.DeliveryNotes)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transfer Receipt No."; Rec."Transfer Receipt No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                // pr 12/2/24 - start
                field("Actual Pull Date"; Rec."Actual Pull Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Actual Pull Date: This is maintained in the Transfer Order Card.';
                    Editable = false;
                }
                field("Actual Pull Time"; Rec."Actual Pull Time")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Actual Pull Time: This is maintained in the Transfer Order Card.';
                }
                // pr 12/4/24
                field(Drayage; Rec.Drayage)
                {
                    ApplicationArea = all;
                    ToolTip = 'Drayage: This is maintained in the Transfer Order Card.';
                    Editable = false;
                }
                field(Terminal; Rec.Terminal)
                {
                    ApplicationArea = all;
                    ToolTip = 'Terminal: This is maintained in the Transfer Order Card.';
                    Editable = false;
                }
                // pr 12/2/24 - end

                //PR 2/12/25 - start 
                field(Hazard; Rec.Hazard)
                {
                    ApplicationArea = all;
                }
                //PR 2/12/25 - end
                //pr 12/4/24
                field("Container Status Notes"; Rec."Container Status Notes")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("FDA Hold"; Rec."FDA Hold")
                {
                    ApplicationArea = All;
                    Editable = bEditable;
                    StyleExpr = FDAHoldStyle;
                }
                // 7/23/25 - start
                field("FDA Hold Date"; Rec."FDA Hold Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("FDA Released Date"; Rec."FDA Released Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(FDAHoldEmailNotifiSentDate; Rec.FDAHoldEmailNotifiSentDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(FDAReleasedEmailNotifiSentDate; Rec.FDAReleasedEmailNotifiSentDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                // 7/23/25 - end

            }
        }
    }
    var
        bEditable: Boolean;
        FDAHoldStyle: Text[50]; // Style for FDA Hold field

    trigger OnOpenPage()
    var
        User: Record User;
        UserPermissions: Codeunit "User Permissions";
        userSetup: Record "User Setup";

    begin
        //pr 6/20/25 - start
        bEditable := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        UserSetup.SetRange(POAdmin, true);
        If UserSetup.FindFirst() then begin
            bEditable := true;
        end
        else begin
            bEditable := false;
        end;
        //pr 6/20/25 - end
    end;

    trigger OnAfterGetRecord()
    var
        POHdr: Record "Purchase Header";
        ArchPurchaseHeader: Record "Purchase Header Archive";
        PostedPurchRcpt: Record "Purch. Rcpt. Header";
        PostedTransferRec: Record "Transfer Receipt Header";
        PostedTransferLn: Record "Transfer Receipt Line";

    begin

        // pr 2/5/25 fills PONo and transfer order No. - start 
        Rec.CalcFields("M-Pack Height", "M-Pack Length", "M-Pack Width", "M-Pack Qty", "M-Pack Weight kg",
        Rec."Order Date", rec."Actual Pull Date", rec."Actual Delivery Date", rec."Container Return Date",
        rec.POUserId, rec."Actual Pull Time", Rec.POUserID, Rec.PONoFromTO, Rec.POOwnerFromTO, rec.Urgent, rec."M-Pack Qty", rec."Container Status Notes", "Transfer Order No.", rec.POCustCode,
        rec.PRCustCode, rec.POCustRespCtr, rec.PRCustRespCtr, rec."Manufacturer Code", rec."Location Code", rec."Port of Discharge", rec."Port of Loading");
        if (StrLen(rec.POUserID) <= 0) then
            Rec.PONo := Rec.PONoFromTO
        else
            Rec.PONo := Rec."Document No.";

        If StrPos(Rec."Document No.", 'T') = 1 then begin
            Rec.PONo := Rec.PONoFromTO;
            Rec."PO Owner" := Rec.POOwnerFromTO;

            //check if PO is closed
            POHdr.Reset();
            POHdr.SetRange("Document Type", POHdr."Document Type");
            POHdr.SetRange("No.", Rec.PONo);
            if not POHdr.FindFirst() then
                Rec.POClosed := true
            else
                rec."PO Vendor" := POHdr."Buy-From Vendor No.";
            // Set FDA Hold style - start
            if Rec."FDA Hold" then
                FDAHoldStyle := 'Unfavorable'
            else
                FDAHoldStyle := 'Standard';

        end;
        Rec.CalcFields(POUserID);

        if StrLen(Rec.POUserID) = 0 then begin
            if strlen(Rec.PONo) = 0 then
                Rec.PONo := Rec."Document No.";

        end;
        // pr 2/5/25 fills PONo and transfer order No. - end

    end;
}
