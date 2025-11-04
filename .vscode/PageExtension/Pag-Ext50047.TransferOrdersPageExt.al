pageextension 50047 TransferOrdersPageExt extends "Transfer Orders"
{
    Editable = true;
    layout
    {
        Modify("No.")
        {
            ApplicationArea = All;
            StyleExpr = TxtNoCustomStyle;
        }
        addafter("Status")
        {
            field("Container No."; Rec."Container No.")
            {
                ApplicationArea = All;
                StyleExpr = TxtStyleExpr;
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
            field("Filling Notes"; Rec."Filling Notes")
            {
                ApplicationArea = all;

            }
            //PR 2/17/25 - end
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
            }
            field(Urgent; Rec.Urgent)
            {
                ApplicationArea = All;
            }
            field("Telex Released"; Rec."Telex Released")
            {
                ApplicationArea = All;
            }
            field("Receiving Status"; Rec."Receiving Status")
            {
                ApplicationArea = All;
                ToolTip = 'Receiving Status.  This is maintained in the Container Order Card.';
            }
            field(ETD; Rec.ETD)
            {
                ApplicationArea = All;
                ToolTip = 'ETD = Estimate Time of Departure.  This is maintained in the Container Order Card.';
            }
            field(ETA; Rec.ETA)
            {
                ApplicationArea = All;
                ToolTip = 'ETA = Estimate Time of Arrival.  This is maintained in the Container Order Card.';
            }
            field(ActualTD; Rec.ActualETDFF)
            {
                ApplicationArea = All;
                ToolTip = 'Actual Departure.  This is maintained in the Container Order Card.';
            }
            field(ActualTA; Rec.ActualETAFF)
            {
                ApplicationArea = All;
                ToolTip = 'Actual Arrival.  This is maintained in the Container Order Card.';
            }
            // pr 11/15/24 - start
            field("Actual Pull Date"; Rec."Actual Pull DateFF")
            {
                ApplicationArea = all;
                ToolTip = 'Actual Pull Date.  This is maintained in the Container Order Card.';
            }
            field("Actual Pull Time"; Rec."Actual Pull TimeFF")
            {
                ApplicationArea = All;
                ToolTip = 'Actual Pull Time.  This is maintained in the Container Order Card.';
            }
            field(LFD; Rec.LFDFF)
            {
                ApplicationArea = all;
                ToolTip = 'LDF.  This is maintained in the Container Order Card.';
            }
            // pr 11/15/24 - end

            field("Actual Delivery Date"; Rec.ActualDeliveryDate)
            {
                ApplicationArea = All;
                ToolTip = 'Actcual Delivery Date.  This is maintained in the Container Order Card.';
            }
            field(Drayage; Rec.DrayageFF)
            {
                ApplicationArea = all;
                ToolTip = 'Drayage.  This is maintained in the Container Order Card.';
            }
            field(Terminal; Rec.TerminalFF)
            {
                ApplicationArea = all;
                ToolTip = 'Terminal.  This is maintained in the Container Order Card.';
            }
            field("Port of Discharge"; Rec."Port of DischargeFF")
            {
                ApplicationArea = all;
            }
            field("Port of Loading"; Rec."Port of LoadingFF")
            {
                ApplicationArea = all;
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
                ToolTip = 'Container Status Notes.  This is maintained in the Container Order Card.';
            }



        }

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
    }
    actions
    {
        addafter("Get Bin Content")
        {
            action("Update Transfer-To")
            {
                ApplicationArea = all;
                Image = UpdateShipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
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

                    TransferHdr: Record "Transfer Header";
                    ftpserver: Record FTPServer;
                    Loc: Record Location;
                    XMLCU: Codeunit XMLCU;
                begin
                    if Confirm(txtConfirmationPI) = true then begin



                        CurrPage.SetSelectionFilter(TransferHdr);
                        if TransferHdr.FindSet() then
                            repeat
                                If Loc.Get(TransferHdr."Transfer-from Code") then;
                                ftpserver.Reset();
                                ftpserver.SetRange("Server Name", Loc."FTP Server Name");
                                ftpserver.SetRange(Mode, ftpserver.Mode::EXPORT);

                                if NOT ftpserver.FindFirst() then
                                    Error(txtNoFTPServerFound, TransferHdr."Transfer-from Code", TransferHdr."No.");

                                if strlen(ftpserver.URL) = 0 then
                                    Error(lblNoURL, ftpserver."Server Name", FORMAT(ftpserver.Mode), TransferHdr."No.");

                                IF TransferHdr."Transfer-from Code" <> Loc."FTP Server Name" then
                                    ERROR(StrSubstNo(txtErrDestination, TransferHdr."Transfer-from Code", loc."FTP Server Name"));

                                XMLCU.ExportTransferOrderXML(TransferHdr, ftpserver);
                            until TransferHdr.Next() = 0;



                        Message(txtExportDonePI, ftpserver."Server Name", Rec."No.");
                    end;


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
                    TransHdr: Record "Transfer Header";
                    ftpserver: Record FTPServer;
                    Loc: Record Location;
                    XMLCU: Codeunit XMLCU;
                begin
                    if Confirm(txt943Confirmation) = true then begin
                        CurrPage.SetSelectionFilter(TransHdr);
                        if TransHdr.FindSet then
                            repeat
                                If Loc.Get(TransHdr."Transfer-to Code") then;
                                ftpserver.Reset();
                                ftpserver.SetRange("Server Name", Loc."FTP Server Name");
                                ftpserver.SetRange(Mode, ftpserver.Mode::EXPORT);

                                if NOT ftpserver.FindFirst() then
                                    Error(txtNoFTPServerFound, TransHdr."Transfer-to Code", TransHdr."No.");


                                if strlen(ftpserver.URL) = 0 then
                                    Error(lblNoURL, ftpserver."Server Name", FORMAT(ftpserver.Mode), TransHdr."No.");

                                IF TransHdr."Transfer-to Code" <> Loc."FTP Server Name" then
                                    ERROR(StrSubstNo(txtErrDestination, TransHdr."Transfer-to Code", loc."FTP Server Name"));
                                XMLCU.Export943NoticeReceiver(TransHdr, ftpserver);
                            until TransHdr.Next() = 0;

                        Message(txtExportDone, ftpserver."Server Name");
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
            action(ExportedImportedFiles)
            {
                ApplicationArea = All;
                Caption = 'View Exported/Imported Files';
                ToolTip = 'View Exported/Imported Files';
                Promoted = true;
                PromotedCategory = Process;
                Image = ViewPage;
                RunObject = page "FTP Exported/Imported Files";
            }
            action(TmpFDANotice)
            {

                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Image = Email;
                Caption = 'Send FDA Hold Notice';
                trigger OnAction()
                var
                    MyJobQueue: Codeunit MyJobQueue;
                begin
                    MyJobQueue.SendFDANotice();
                end;
            }
            action(TmpFDARel)
            {

                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Image = Email;
                Caption = 'Send FDA Release Notice';
                trigger OnAction()
                var
                    MyJobQueue: Codeunit MyJobQueue;
                begin
                    MyJobQueue.SendFDAReleaseNotice();
                end;
            }



        }







    }
    var
        TxtStyleExpr: Text;
        txtChangeTransferToAbort: Label 'Transfer Order %1 has no transfer lines shipped yet.  Please use the Transfer-to Drop Down List to change the Destination Location.';
        txtExportDone: Label 'Selected 943 - Receiver notice for Transfer Order(s) successfully exported to %1.';
        txt943Confirmation: Label 'Are you sure you want to export 943 - Receiver Notices for selected Transfer Order(s)?';

        lblNoURL: Label 'No FTP URL is setup for %1 %2 Trabsfer Order No. %3';
        txtNoFTPServerFound: Label 'No FTP Server Name found for location %1 Transfer Order No. %2.';
        txtOnDelete: Label 'Transfer Order %1 is assigned to Container %2. DELETE NOT allowed. Please unassign Container %2.';

        txtConfirmationPI: Label 'Are you sure you want to export Picking Instructions for the selected Transfer Orders?';
        txtExportDonePI: Label 'Selected picking instruction(s) successfully exported to %1.';

        txtErrDestination: Label 'Transfer-to Code %1 NOT EQUAL to ftp Server %2. Task Aborted.';

        txtErrSource: Label 'Transfer-from Code %1 NOT EQUAL to ftp Server %2. Task Aborted.';
        constFav: Label 'Favorable';
        constStd: Label 'Standard';
        TxtNoCustomStyle: Text;
        TxtCBMStyle: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec.Urgent = true then
            TxtStyleExpr := 'Unfavorable'   //BOLD RED
        ELSE
            TxtStyleExpr := 'Standard';  //Default
        rec.CalcFields("M-Pack UPC", CarrierFF, DrayageFF, ForwarderFF,
        TerminalFF, ContainerSizeFF, "Port of LoadingFF",
        "Actual Pull DateFF", "Actual Pull TimeFF", "Port of DischargeFF",
        "Container Status NotesFF", "Container Status NotesFF", ActualETAFF,
        ActualETDFF, "Filling Notes", "FDA Hold");

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
