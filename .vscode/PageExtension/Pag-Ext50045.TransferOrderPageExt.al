pageextension 50045 "TransferOrderPageExt" extends "Transfer Order"
{
    Editable = true;
    layout
    {
        modify("Posting Date")
        {
            style = StrongAccent;
            StyleExpr = true;
        }
        addafter("Posting Date")
        {
            field(Urgent; Rec.Urgent)
            {
                ApplicationArea = All;
            }
            field("Telex Released"; Rec."Telex Released")
            {
                ApplicationArea = All;
            }
            field("Pier Pass"; Rec."Pier Pass")
            {
                ApplicationArea = All;
            }


            field("Receiving Status"; Rec."Receiving Status")
            {
                ApplicationArea = All;
                TableRelation = ReceivingStatus;
            }


            field(Notes; Rec.Notes)
            {
                ApplicationArea = All;
            }

        }
        addafter(Status)
        {
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


        }
        addbefore(TransferLines)
        {
            group(Container)
            {
                field("Container No."; Rec."Container No.")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtStyleExpr;
                    trigger OnValidate()
                    begin
                        if rec."Container No." <> xRec."Container No." then
                            if StrLen(Rec."Container No.") > 0 then
                                Error(TxtErrContainerNoAssign);
                    end;
                }
                // 7/23/25 - start
                field("FDA Hold"; Rec."FDA Hold")
                {
                    ApplicationArea = All;

                }
                // 7/23/25 - end

                field(ContainerSize; Rec.ContainerSizeFF)
                {
                    ApplicationArea = All;
                }
                //PR 2/17/25 - start
                field("Container CBM"; Rec.GetContainerCBM())
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Container Percentage Threshold"; Rec.GetContainerPercentageThresh())
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                //PR 2/17/25 - end
                //PR 2/17/25 - start
                field("Total CBM"; Rec.GetTotalCBM())
                {
                    ApplicationArea = All;
                    StyleExpr = TxtCBMStyle;
                }
                field("Total Weight"; Rec.GetTotalWeight())
                {
                    ApplicationArea = All;
                }
                field("Filling Notes"; Rec."Filling Notes")
                {
                    ApplicationArea = all;

                }
                //PR 2/17/25 - end
                // pr 10/11/24 - remove Container Return Date -start
                /*field("Container Return Date"; Rec."Container Return Date")
                {
                    ApplicationArea = All;
                }*/
                // pr 10/11/24 - remove Container Return Date -end
                field(Forwarder; Rec.ForwarderFF)
                {
                    ApplicationArea = All;
                }
                field(Carrier; Rec.CarrierFF)
                {
                    ApplicationArea = All;
                }
                field("Port of Loading"; Rec."Port of LoadingFF")
                {
                    ApplicationArea = All;
                }
                field("Port of Discharge"; Rec."Port of DischargeFF")
                {
                    ApplicationArea = All;
                }
                field(ETD; Rec.ETD)
                {
                    ApplicationArea = All;
                    Caption = 'Initial Departure';
                }
                field(ETA; Rec.ETA)
                {
                    ApplicationArea = All;
                    Caption = 'Initial Arrival';
                }

                field(ActualTD; Rec.ActualETDFF)
                {
                    ApplicationArea = All;
                }
                field(ActualTA; Rec.ActualETAFF)
                {
                    ApplicationArea = All;
                }

                field(LFD; Rec.LFDFF)
                {
                    ApplicationArea = All;
                }
                field("Actual Pull Date"; Rec."Actual Pull DateFF")
                {
                    ApplicationArea = All;
                }

                field("Actual Pull Time"; Rec."Actual Pull TimeFF")
                {
                    ApplicationArea = All;
                }
                field(ActualDeliveryDateFF; Rec.ActualDeliveryDateFF)
                {
                    ApplicationArea = All;
                }
                field(EmptyNotificationDateFF; Rec.EmptyNotificationDateFF)
                {
                    ApplicationArea = All;
                }
                field(ContainerReturnDateFF; Rec.ContainerReturnDateFF)
                {
                    ApplicationArea = All;
                }

                field(Drayage; Rec.DrayageFF)
                {
                    ApplicationArea = all;

                }
                field(Terminal; Rec.TerminalFF)
                {
                    ApplicationArea = All;
                }
                //PR 2/10/25 - start
                field("944 Received Date"; Rec."944 Received Date")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                field("944 Receipt No."; Rec."944 Receipt No.")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                field("944 Load No."; Rec."944 Load No.")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                //PR 2/10/25 - end

                field("Container Status Notes"; Rec."Container Status NotesFF")
                {
                    ApplicationArea = All;
                }


            }



        }
        //MBR 8/15/24 - add ability for users to attach documents
        //8/15/25 - start
        addafter("Transfer-to Code")
        {
            field("Physical Transfer To Code"; Rec."Physical Transfer To Code")
            {
                ApplicationArea = All;
                Editable = true;
            }
        }
        //8/15/25 - end
        addfirst(factboxes)
        {

            // pr 8/16/24 - added support for attaching documents and keeps track of # of attachments - start
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Transfer Header"),
                            "No." = field("No.");
            }
            // pr 8/16/24 - added support for attaching documents and keeps track of # of attachments - end



        }
        //MBR 8/15/24 - end of ability for users to attach documents

    }

    actions
    {
        modify("Create &Whse. Receipt")
        {
            trigger OnBeforeAction()
            var
                GetCU: Codeunit GeneralCU;
            begin
                GetCU.CreateWhseRequest(Rec);
            end;
        }
        addafter("Create Inventor&y Put-away/Pick")
        {
            action("Assign Container")
            {
                ApplicationArea = all;
                Image = Travel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Rec.GetContainers();
                end;
            }
            action("Update Transfer-To")
            {
                ApplicationArea = all;
                Image = UpdateShipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = bFDAHoldEEnabled;
                trigger OnAction()
                var
                    PgSelectTransferTo: Page "Select Transfer To";
                    TransferLine: Record "Transfer Line";
                begin
                    TransferLine.Reset;
                    TransferLine.SetRange("Document No.", Rec."No.");
                    TransferLine.SetFilter("Quantity Shipped", '>%1', 0);
                    if not TransferLine.FindSet() then
                        Error(txtChangeTransferToAbort, Rec."No.");

                    Clear(PgSelectTransferTo);
                    PgSelectTransferTo.SetTransferTo(Rec."No.");
                    PgSelectTransferTo.RunModal();
                end;
            }
            action(Export943Receiver)
            {
                ApplicationArea = All;
                Caption = 'Export 943 - Receiver Notice';
                ToolTip = 'Export 943 - Receiver Notice';
                Image = ExportAttachment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ftpserver: Record FTPServer;
                    Loc: Record Location;
                    XMLCU: Codeunit XMLCU;
                    LocCode: Code[10];
                begin
                    //8/18/25 - start
                    if (Rec."Physical Transfer To Code" <> '') then begin
                        LocCode := Rec."Physical Transfer To Code";
                    end
                    else begin
                        LocCode := Rec."Transfer-to Code";
                    end;
                    //8/18/25 -end
                    if Confirm(txt943Confirmation) = true then begin

                        If Loc.Get(LocCode) then;
                        ftpserver.Reset();
                        ftpserver.SetRange("Server Name", Loc."FTP Server Name");
                        ftpserver.SetRange(Mode, ftpserver.Mode::EXPORT);
                        if NOT ftpserver.FindFirst() then
                            Error(txtNoFTPServerFound, LocCode, Rec."No.");

                        if strlen(ftpserver.URL) = 0 then
                            Error(lblNoURL, ftpserver."Server Name", FORMAT(ftpserver.Mode), Rec."No.");

                        IF LocCode <> Loc."FTP Server Name" then
                            ERROR(StrSubstNo(txtErrDestination, LocCode, loc."FTP Server Name"));

                        XMLCU.Export943NoticeReceiver(Rec, ftpserver);

                        Message(txtReceiverNoticeExportDone, ftpserver."Server Name");
                    end;


                end;
            }
            action(ExportPickingInstruction)
            {

                ApplicationArea = All;
                Caption = 'Export Picking Instruction';
                ToolTip = 'Export Picking Instruction';
                Image = ExportAttachment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ftpserver: Record FTPServer;
                    Loc: Record Location;
                    XMLCU: Codeunit XMLCU;
                begin
                    if Confirm(StrSubstNo(txtConfirmation, Rec."No.")) = true then begin

                        If Loc.Get(Rec."Transfer-from Code") then;
                        ftpserver.Reset();
                        ftpserver.SetRange("Server Name", Loc."FTP Server Name");
                        ftpserver.SetRange(Mode, ftpserver.Mode::EXPORT);
                        if NOT ftpserver.FindFirst() then
                            Error(txtNoFTPServerFound, Rec."Transfer-from Code");


                        if strlen(ftpserver.URL) = 0 then
                            Error(lblNoURL, ftpserver."Server Name", FORMAT(ftpserver.Mode));

                        IF Rec."Transfer-from Code" <> Loc."FTP Server Name" then
                            ERROR(StrSubstNo(txtErrDestination, Rec."Transfer-from Code", loc."FTP Server Name"));


                        XMLCU.ExportTransferOrderXML(Rec, ftpserver);

                        Message(txtExportDone, ftpserver."Server Name", Rec."No.");
                    end;


                end;

            }
            action(RetrivefromSFTP2)
            {
                caption = 'Import 944 Receipt Information';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Image = MovementWorksheet;
                trigger OnAction()
                var
                    XMLCU: Codeunit XMLCU;
                begin
                    XMLCU.ImportFromFTP();

                end;
            }

        }
    }

    var
        txtChangeTransferToAbort: Label 'Transfer Order %1 has no transfer lines shipped yet.  Please use the Transfer-to Drop Down List to change the Destination Location.';
        TxtErrContainerNoAssign: Label 'Please use the Assign Container button to assign a container number.';
        TxtStyleExpr: Text;
        txtOnDelete: Label 'Transfer Order %1 is assigned to Container %2. DELETE NOT allowed. Please unassign Container %2.';
        txtConfirmation: Label 'Are you sure you want to export picking instructions?';
        txtNoFTPServerFound: Label 'No FTP Server Name found for location %1.';
        txtExportDone: Label 'Picking instructions successfully exported to %1.';
        lblNoURL: Label 'No FTP URL is setup for %1 %2';
        txt943Confirmation: Label 'Are you sure you want to export 943 - Receiver Notice?';
        txtErrDestination: Label 'Transfer-to Code %1 NOT EQUAL to ftp Server %2. Task Aborted.';

        txtErrSource: Label 'Transfer-from Code %1 NOT EQUAL to ftp Server %2. Task Aborted.';
        TxtNoCustomStyle: Text;
        constFav: Label 'Favorable';
        constStd: Label 'Standard';
        TxtCBMStyle: Text;
        txtReceiverNoticeExportDone: Label '943 Receiver Notice successfully exported to %1.';
        bFDAHoldEEnabled: Boolean;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.CreatedBy := UserId;
        Rec.CreatedDate := Today;
    end;

    trigger OnOpenPage()
    var
        TransferOrder: Record "Transfer Header";

    begin
        TransferOrder.Reset();
        TransferOrder.SetCurrentKey("No.", "Transaction Type");
        TransferOrder.SetRange("No.", Rec."No.");
        TransferOrder.SetRange("Transaction Type", Rec."Transaction Type");
        If TransferOrder.FindFirst() then begin
            TransferOrder.Validate("Posting Date", Today);
            TransferOrder.Modify(false);
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec.Urgent = true then
            TxtStyleExpr := 'Unfavorable'   //BOLD RED
        ELSE
            TxtStyleExpr := 'Standard';  //Default
        rec.CalcFields(CarrierFF, DrayageFF, ForwarderFF,
        TerminalFF, ContainerSizeFF, "Port of LoadingFF",
        "Actual Pull DateFF", "Actual Pull TimeFF", "Port of DischargeFF",
        "Container Status NotesFF", "Container Status NotesFF", ActualETAFF, ActualETDFF, "Filling Notes", "FDA Hold");
        if (rec."FDA Hold" = true) then begin
            bFDAHoldEEnabled := false;
        end else begin
            bFDAHoldEEnabled := true;
        end;


        //mbr 2/11/25 - start
        //depending on the valu of 944 fields, change the style of No.

        if strlen(Rec."944 Receipt No.") > 0 then
            TxtNoCustomStyle := constFav
        else
            TxtNoCustomStyle := constStd;
        //mbr 2/11/25 - end
        //PR 2/19/25 - start
        if (rec.GetTotalCBM() < (rec.GetContainerCBM() * 0.75)) then
            TxtCBMStyle := 'Unfavorable'
        else
            TxtCBMStyle := 'Standard';
        //PR 2/19/25 - end

    end;
    //PR 1/27/25 - start 
    trigger OnDeleteRecord(): Boolean
    begin
        if (StrLen(rec."Container No.") > 0) then
            Error(txtOnDelete, rec."No.", rec."Container No.");
    end;
    //PR 1/27/25 - end 
}
