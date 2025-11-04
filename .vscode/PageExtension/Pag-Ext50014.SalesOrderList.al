pageextension 50014 SalesOrderList extends "Sales Order List"
{
    Editable = true;
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Customer Responsibility Center"; Rec."Customer Responsibility Center")
            {
                ApplicationArea = All;
                ToolTip = 'Customer Responsibility Center: This is maintained in the Customer Card.';
            }
        }
        addafter(Amount)
        {
            field("Outstanding Amount ($)"; Rec."Outstanding Amount ($)")
            {
                ApplicationArea = All;
            }
        }
        addafter("Status")
        {
            field("Total Pallet Count"; Rec."Total Pallet Count")
            {
                ApplicationArea = All;
            }

            field(Verified; Rec.Verified)
            {
                ApplicationArea = All;
            }
            field("Verified By"; Rec."Verified By")
            {
                ApplicationArea = All;
            }
            field("Verified Date"; Rec."Verified Date")
            {
                ApplicationArea = All;
            }
            field("Order Reference"; Rec."Order Reference")
            {
                ApplicationArea = All;
            }
            field("Work Description"; workDescripTxt)
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    rec.SetWorkDescription(workDescripTxt);
                end;
            }
            /*field("Work Description"; Rec."Work Description")
            {
                ApplicationArea = All;
            }*/
            field("Start Ship Date"; Rec."Start Ship Date")
            {
                ApplicationArea = all;
            }
            field("Request Ship Date"; Rec."Request Ship Date")
            {
                ApplicationArea = all;
            }
            field("Cancel Date"; Rec."Cancel Date")
            {
                ApplicationArea = all;
            }
            field("APT Date"; Rec."APT Date")
            {
                ApplicationArea = All;
            }
            field("APT Time"; Rec."APT Time")
            {
                ApplicationArea = All;
            }
            field("Flag"; Rec."Flag")
            {
                ApplicationArea = all;
                Caption = 'Flag';
            }
            //8/4/25 - start
            field("In the Month"; Rec."In the Month")
            {
                ApplicationArea = All;
            }
            // 8/4/25 - end
            field("Order Notes"; Rec."Order Notes")
            {
                ApplicationArea = All;
            }
            field("Split"; Rec."Split")
            {
                ApplicationArea = all;
                // is split
                Caption = 'Split ';
            }
            field(Internal; Rec.Internal)
            {
                ApplicationArea = All;
            }
            field(Master; Rec.Master)
            {
                ApplicationArea = All;
            }
            field(CreatedUserID; Rec.CreatedUserID)
            {
                ApplicationArea = All;
            }
            field(CreatedDate; Rec.CreatedDate)
            {
                ApplicationArea = All;
            }
            field("Modified By"; Rec."Modified By")
            {
                ApplicationArea = All;
            }
            field("Modified Date"; Rec."Modified Date")
            {
                ApplicationArea = All;
            }
            field(Type; Rec.Type)
            {
                ApplicationArea = All;
            }
            field(Dept; Rec.Dept)
            {
                ApplicationArea = All;
            }
            //PR 2/14/25 - start
            field("Single BOL No."; Rec."Single BOL No.")
            {
                ApplicationArea = All;
            }
            //PR 2/14/25 - end
            //PR 4/15/25 - start
            field(ShippingLabeltype; rec.ShippingLabelStyle)
            {
                ApplicationArea = All;
            }
            //PR 4/15/25 - end

        }


    }


    //pr 1/24/24 page extension for adding 'assign Master BOL' button
    actions
    {

        addfirst(processing)
        {
            action(Verify)
            {
                ApplicationArea = All;
                Caption = 'Verify Sales Order(s)';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    rec1: Record "Sales Header";
                begin
                    If rec.Count >= 1 then begin
                        CurrPage.SetSelectionFilter(rec1);
                        if rec1.findset then
                            repeat
                                rec1.Validate(Verified, true);
                                rec1.Modify();
                            until rec1.Next() = 0;

                    end;
                end;
            }
            action(UnVerify)
            {
                ApplicationArea = All;
                Caption = 'Unverify Sales Order(s)';
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    rec1: Record "Sales Header";
                begin
                    If rec.Count >= 1 then begin
                        CurrPage.SetSelectionFilter(rec1);
                        if rec1.findset then
                            repeat
                                rec1.Validate(Verified, false);
                                rec1.Modify();
                            until rec1.Next() = 0;

                    end;
                end;
            }
            action("Assign Master BOL")
            {
                ApplicationArea = all;
                Image = Task;

                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                    SalesOrderLine: Record "Sales Header"; // this is the page source table
                    MasterBOL: Record "Master BOL";
                    SalesNRecieveable: Record "Sales & Receivables Setup";
                    text: text[255];
                    compareNo: code[50];
                    compareShipCode: code[50];
                    compareShipToAddress: text;
                    compareShipToCity: text;
                    compareShipToState: text;
                    compareFreightTerm: text[50];
                    compareLocationCode: code[50];
                    compareSCAC_Code: text;
                    count: Integer;
                    //NoSeriesMgt: Codeunit NoSeriesManagement;  //mbr 2/14/25 - this will be obsolete soon
                    NoSeries: Codeunit "No. Series";
                    masterBolVal: code[50];
                    MasterBOLpopUpDialog: Page "Master BOL Create Card";
                    tblMasterBOL: record "Master BOL";
                    NewBOLNo: Code[20];
                    SalesHdr: Record "Sales Header";
                    ChkSalesOrder: record "Sales Header";
                    bFound: boolean;
                    maxI: integer;
                    SalesOrderLineCompareBOL: Record "Sales Header" temporary;

                begin
                    //pr 5/8/25 - check for duplicate single BOL - start
                    SalesOrderLine.Reset();
                    CurrPage.SetSelectionFilter(SalesOrderLine);
                    count := 0;
                    if SalesOrderLine.FindSet() then begin
                        repeat
                            COUNT += 1;

                            SalesOrderLineCompareBOL.Reset();
                            SalesOrderLineCompareBOL.SetRange("Single BOL No.", SalesOrderLine."Single BOL No.");
                            if not (SalesOrderLineCompareBOL.FindSet()) then begin
                                SalesOrderLineCompareBOL.Init();
                                SalesOrderLineCompareBOL := SalesOrderLine;
                                SalesOrderLineCompareBOL.Insert();
                            end;
                        until SalesOrderLine.Next() = 0;

                        // --- Compare Single BOL No. in SalesOrderLineCompareBOL against SalesOrderLine ---
                        SalesOrderLineCompareBOL.Reset();
                        if SalesOrderLineCompareBOL.FindSet() then
                            repeat
                                SalesOrderLine.SetRange("Single BOL No.", SalesOrderLineCompareBOL."Single BOL No.");
                                if SalesOrderLine.Count > 1 then
                                    Error(txtErrDuplicateSingleBOL, SalesOrderLineCompareBOL."Single BOL No.", SalesOrderLine.Count);
                            until SalesOrderLineCompareBOL.Next() = 0;
                        // --- End of Compare Single BOL ---


                    end;
                    //pr 5/8/25 - check for duplicate single BOL - end

                    count := 0;
                    text := '';
                    SalesOrderLine.Reset();
                    // Line.Copy(Rec, true);
                    CurrPage.SetSelectionFilter(SalesOrderLine);

                    SalesNRecieveable.Get();
                    SalesNRecieveable.TestField("Single BOL Nos.");
                    //masterBolVal := NoSeriesMgt.GetNextNo(SalesNRecieveable."Master BOL Nos.", WorkDate(), true);  //old version
                    masterBolVal := NoSeries.GetNextNo(SalesNRecieveable."Master BOL Nos.");
                    // pr 11/15/24

                    if SalesOrderLine.FindSet() then begin
                        repeat
                            // pr 1/24/24 makes sure the sales order lines are valid
                            if (count = 0) then begin
                                compareNo := SalesOrderLine."Sell-to Customer No.";
                                compareShipCode := SalesOrderLine."Ship-to Code";
                                compareShipToAddress := SalesOrderLine."Ship-to Address";
                                compareShipToCity := SalesOrderLine."Ship-to City";
                                compareShipToState := SalesOrderLine."Ship-to County";
                                compareFreightTerm := Format((SalesOrderLine.FreightChargeTerm));
                                compareLocationCode := SalesOrderLine."Location Code";
                                compareSCAC_Code := SalesOrderLine."Shipping Agent Code";
                            end;
                            if (SalesOrderLine."Sell-to Customer No." = compareNo) then begin
                                if (SalesOrderLine."Location Code" <> compareLocationCode) then
                                    Error('You can only have 1 Source Ship location code for sales order(s) selected.');
                                if (Format(SalesOrderLine.FreightChargeTerm) <> compareFreightTerm) then
                                    Error('You can only have 1 unique Freight Term for sales order(s) selected.');
                                if StrLen(SalesOrderLine."Shipping Agent Code") = 0 then
                                    Error('SCAC Code is Mandatory for sales order(s) selected.');
                                if (SalesOrderLine."Shipping Agent Code" <> compareSCAC_Code) then
                                    Error('You can have only 1 unique SCAC Code for sales order(s) selected.');

                            end
                            else begin
                                Error('Only one customer No. can be selected when assigning Master BOL');
                            end;

                            count += 1;


                        until SalesOrderLine.Next() = 0;
                    end;
                    //mbr 1/24/24 - check to see if MasterBOL already has at least one of the sales orders in the list, if so, error out. Users need to remove that
                    //sales order for Master BOL List before including in the list
                    SalesOrderLine.Reset();
                    CurrPage.SetSelectionFilter(SalesOrderLine);
                    if SalesOrderLine.FindSet() then
                        repeat
                            MasterBOL.Reset();
                            MasterBOL.SetRange("Sales Order No.", SalesOrderLine."No.");
                            if MasterBOL.FindFirst then
                                Error('Sales Order %1 is already attached to MasterBOL %2.  Please review.', SalesOrderLine."No.", MasterBOL."Master BOL No.");
                        until SalesOrderLine.Next = 0;


                    // pr 1/24/24 creates Master Bol records to match each line

                    SalesOrderLine.Reset();
                    CurrPage.SetSelectionFilter(SalesOrderLine);
                    if SalesOrderLine.FindSet() then begin
                        repeat
                            If SalesOrderLine."Single BOL No." = '' then begin
                                //NewBOLNo := NoSeriesMgt.DoGetNextNo(SalesNRecieveable."Single BOL Nos.", WorkDate(), true, true);  //old code
                                //ensure we have unique BOL for the same customer
                                bFound := false;
                                maxI := 0;
                                while (bFound = false) OR (maxI < 100) do begin
                                    NewBOLNo := NoSeries.GetNextNo(SalesNRecieveable."Single BOL Nos.");
                                    SalesHdr.Reset();
                                    SalesHdr.SetRange("Document Type", SalesOrderLine."Document Type");
                                    SalesHdr.SetRange("Sell-to Customer No.", SalesOrderLine."Sell-to Customer No.");
                                    SalesHdr.SetRange("Single BOL No.", NewBOLNo);
                                    IF not SalesHdr.FindFirst() then
                                        bFound := true;
                                    maxI += 1;

                                end;
                                if bFound = true then begin
                                    SalesOrderLine."Single BOL No." := NewBOLNo;
                                    SalesOrderLine.Modify(true);
                                end
                                else if maxI = 100 then
                                    ERROR('Creation of Single BOL ran into issues retrieving unique No. series.  Please contact Tech Support.');

                            end;

                            MasterBOL.Init();
                            MasterBOL."Master BOL No." := masterBolVal;
                            MasterBOL."Single BOL No." := SalesOrderLine."Single BOL No.";
                            MasterBOL."Customer No." := SalesOrderLine."Sell-to Customer No.";
                            MasterBOL."External Doc No." := SalesOrderLine."External Document No.";
                            MasterBOL."Freight Charge Term" := SalesOrderLine.FreightChargeTerm;
                            MasterBOL."Sales Order No." := SalesOrderLine."No.";
                            MasterBOL.Posted := false;
                            MasterBOL."Ship to Code" := SalesOrderLine."Ship-to Code";
                            MasterBOL."Ship To Address" := SalesOrderLine."Ship-to Address";
                            MasterBOL."Ship To Address2" := SalesOrderLine."Ship-to Address 2";
                            MasterBOL."Ship To City" := SalesOrderLine."Ship-to City";
                            MasterBOL."Ship To Contact" := SalesOrderLine."Ship-to Contact";
                            MasterBOL."Ship To Name" := SalesOrderLine."Ship-to Name";
                            MasterBOL."Ship To Postal Code" := SalesOrderLine."Ship-to Post Code";
                            MasterBOL."Ship To State/County" := SalesOrderLine."Ship-to County";
                            MasterBOL."Location Code" := SalesOrderLine."Location Code";
                            MasterBOL."Bill To Adress" := SalesOrderLine."Bill-to Address";
                            MasterBOL."Bill To City" := SalesOrderLine."Bill-to City";
                            MasterBOL."Bill To Contact" := SalesOrderLine."Bill-to Contact";
                            MasterBOL."Bill To Name" := SalesOrderLine."Bill-to Name";
                            MasterBOL."Bill To Postal Code" := SalesOrderLine."Bill-to Post Code";
                            MasterBOL."Bill To State/County" := SalesOrderLine."Bill-to County";
                            MasterBOL."SCAC Code" := SalesOrderLine."Shipping Agent Code";
                            Masterbol."Shipment Method Code" := SalesOrderLine."Shipment Method Code";
                            MasterBOL."Location Code" := SalesOrderLine."Location Code";
                            MasterBOL.Insert(true);
                        until SalesOrderLine.Next() = 0;
                        //if we are here then the assignment of Master BOL was successful; let's ask for ship from address
                        Clear(MasterBOLpopUpDialog);
                        tblMasterBOL.RESET;
                        tblMasterBOL.SETRANGE("Master BOL No.", MasterBOL."Master BOL No.");
                        if tblMasterBOL.findfirst() then begin
                            MasterBOLpopUpDialog.SetRecord := tblMasterBOL;
                            MasterBOLpopUpDialog.SetTableView := tblMasterBOL;
                            MasterBOLpopUpDialog.Run();
                        end
                        else
                            Error('There was a problem finding new Master BOL %1', MasterBOL."Master BOL No.");


                    end;


                end;
            }

            action(MasterBOL)
            {
                ApplicationArea = All;
                Caption = 'Master Bill of Ladings';
                Image = ViewPage;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Master BOL List";
            }

            action(AutoAssignLotNo)
            {
                ApplicationArea = All;
                Caption = 'Auto Assign Lot No.(s)';
                Image = Task;
                Promoted = true;
                PromotedCategory = Process;

                trigger onAction()
                var
                    ResEntry: Record "Reservation Entry";
                    GetResEntry: Record "Reservation Entry";
                    Item: Record Item;
                    CartonInfo: Record CartonInformation;
                    SalesLine: Record "Sales Line";
                    SalesHdr: Record "Sales Header";
                    bMod: boolean;
                    bSalesMod: boolean;
                begin
                    if Confirm(txtLotNoConfirmation) = true then begin
                        TmpAutoAssignLotErr.DeleteAll();
                        CurrPage.SetSelectionFilter(SalesHdr);
                        if SalesHdr.FindSet then
                            repeat
                                bSalesMod := true;
                                SalesLine.Reset();
                                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                                SalesLine.SetRange("Document No.", SalesHdr."No.");
                                SalesLine.SetRange(Type, SalesLine.Type::Item);
                                if SalesLine.FindSet() then
                                    repeat
                                        SalesLine.CalcFields("Reserved Qty. (Base)");
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
                                                    bMod := true;
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
                                                            IF GetResEntry."Source Type" <> Database::"Item Ledger Entry" then begin
                                                                UpdateErrAutoAssignLot(TmpAutoAssignLotErr, SalesLine, STRSUBSTNO(txtErrReservationILE, SalesLine."Document No.", SalesLine."No."));
                                                                bMod := false;
                                                                bSalesMod := false;
                                                            end;
                                                            IF GetResEntry."Item Tracking" <> GetResEntry."Item Tracking"::"Lot No." then begin
                                                                IF GetResEntry."Lot No." = '' then begin
                                                                    UpdateErrAutoAssignLot(TmpAutoAssignLotErr, SalesLine, STRSUBSTNO(txtErrReservationLot, SalesLine."Document No.", SalesLine."No."));
                                                                    bMod := false;
                                                                    bSalesMod := false;
                                                                end;
                                                            end;
                                                            if bMod = true then begin
                                                                if StrLen(ResEntry."Lot No.") = 0 then begin
                                                                    ResEntry."Item Tracking" := GetResEntry."Item Tracking";
                                                                    ResEntry."Lot No." := GetResEntry."Lot No.";
                                                                    ResEntry."Expiration Date" := GetResEntry."Expiration Date";
                                                                    ResEntry.Modify();
                                                                end;

                                                            end;

                                                        end;
                                                    end;
                                                until ResEntry.Next = 0;
                                        end
                                        else
                                            //this means there are no reservations for this line item so we have to error out
                                            UpdateErrAutoAssignLot(TmpAutoAssignLotErr, SalesLine, txtNoReservation);
                                    until SalesLine.Next() = 0;
                                if bSalesMod = true then
                                    UpdateParentPackageCnt(SalesHdr."No.");

                            until SalesHdr.Next() = 0;
                        TmpAutoAssignLotErr.Reset();
                        IF TmpAutoAssignLotErr.FindSet() then begin
                            PAGE.RUN(PAGE::AutoAssignLotErr, TmpAutoAssignLotErr);
                        end
                        else
                            Message(txtAutoAssignDone);
                    end




                end;
            }

            action(BatchPrintInstruction)
            {
                ApplicationArea = All;
                Caption = 'Batch - Pick Instruction';
                Image = PrintChecklistReport;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    myInt: Integer;
                    rec1: record "Sales Header";
                    rpt: Report BatchPickingInstruction;
                begin
                    If rec.Count >= 1 then begin
                        CLEAR(rpt);
                        CurrPage.SetSelectionFilter(rec1);
                        if rec1.findset then
                            repeat
                                rpt.LoadSalesHeader(rec1);
                            until rec1.Next() = 0;
                        rpt.Run();


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
                    SalesHdr: Record "Sales Header";
                    popupConfirm: Page "Confirmation Dialog";
                    ftpserver: Record FTPServer;
                    Loc: Record Location;
                    XMLCU: Codeunit XMLCU;
                    serverName: Text;
                begin
                    Clear(popupConfirm);
                    popupConfirm.setMessage(txtConfirmation);
                    Commit;
                    if popupConfirm.RunModal() = Action::yes then begin
                        serverName := '';
                        //9/23/25 - make sure to always take the location code for each sales order as we can't guarantee users will select sales orders for one location only
                        /* this section to be deleted after further testing
                        If Loc.Get(Rec."Location Code") then;
                         ftpserver.Reset();
                         ftpserver.SetRange("Server Name", Loc."FTP Server Name");
                         ftpserver.SetRange(Mode, ftpserver.Mode::EXPORT);
                         if NOT ftpserver.FindFirst() then
                             Error(txtNoFTPServerFound, Rec."Location Code");


                         if strlen(ftpserver.URL) = 0 then
                             Error(lblNoURL, ftpserver."Server Name", FORMAT(ftpserver.Mode));
                        end of Section to be deleted*/
                        CurrPage.SetSelectionFilter(SalesHdr);
                        if SalesHdr.FindSet then
                            repeat
                                // finds ftpServer for sales order location code
                                If Loc.Get(SalesHdr."Location Code") then;
                                ftpserver.Reset();
                                ftpserver.SetRange("Server Name", Loc."FTP Server Name");
                                ftpserver.SetRange(Mode, ftpserver.Mode::EXPORT);
                                if NOT ftpserver.FindFirst() then
                                    Error(txtNoFTPServerFound, SalesHdr."Location Code");
                                if strlen(ftpserver.URL) = 0 then
                                    Error(lblNoURL, ftpserver."Server Name", FORMAT(ftpserver.Mode));
                                //make sure CustomerShiptoCode is populated
                                SalesHdr.CalcFields(CustomerShipToCode);
                                if SalesHdr.CustomerShipToCode = '' then
                                    Error(txtErrCustomerShipToCode, SalesHdr."No.");
                                if ((serverName.IndexOf(ftpserver."Server Name" + ', ') = 0) or (serverName = '')) then
                                    serverName += ftpserver."Server Name" + ', ';
                                XMLCU.ExportXML(SalesHdr, ftpserver);
                            until SalesHdr.Next() = 0;
                        serverName := serverName.TrimEnd(', ');
                        serverName := serverName.TrimStart(', ');
                        serverName := serverName.Trim();
                        Message(txtExportDone, serverName);
                    end;


                end;
            }


            action(RetrivefromSFTP2)
            {
                caption = 'Import Packaging Information - Orig';
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

            action(RetrivefromSFTP_New)
            {
                caption = 'Import Packaging Information - Updated';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Image = MovementWorksheet;
                trigger OnAction()
                var
                    XMLCU: Codeunit XMLCU;
                begin
                    XMLCU.ImportFromFTP_Async();

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


            action(PackageLabels)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Report;
                Caption = 'Package Label(s)';

                trigger OnAction()
                var
                    CustomSalesLine: Record CartonInformation;
                    Cust: Record Customer;
                    rec1: record "Sales Header";
                    ReportLabel: Record ReportLabelStyle;
                begin
                    Cust.RESET;
                    Cust.Get(Rec."Sell-to Customer No.");
                    IF rec.ShippingLabelStyle = '' then
                        ERROR('Package Label Style Report needs to be set up in the Sales Order card for %1.  Package Label(s) cannot be printed at this time.', Rec."No.");

                    CustomSalesLine.SetRange("Document No.", Rec."No.");
                    if CustomSalesLine.FindFirst() then begin
                        ReportLabel.Reset();
                        ReportLabel.SetRange(Code, rec.ShippingLabelStyle);
                        if (ReportLabel.FindSet()) then
                            Report.RunModal(ReportLabel."Report ID", true, false, CustomSalesLine)
                        else
                            ERROR('Package Label Style Report needs to be set up in the Sales Order card for %1.  Package Label(s) cannot be printed at this time.', Rec."No.");
                        /*
                        case cust.PackageLabelStyle of
                            cust.PackageLabelStyle::Default:
                                Report.RunModal(Report::NewBolBarcode, true, false, CustomSalesLine);
                            cust.PackageLabelStyle::Pallet:
                                Report.RunModal(Report::PackageLabel2, true, false, CustomSalesLine);
                            cust.PackageLabelStyle::"Type 3":
                                Report.RunModal(Report::PackageLabel3, true, false, CustomSalesLine);
                            cust.PackageLabelStyle::"Type 4":
                                Report.RunModal(Report::PackageLabel4, true, false, CustomSalesLine);
                            cust.PackageLabelStyle::"Type 5":
                                Report.RunModal(Report::PackageLabel5, true, false, CustomSalesLine);
                        end;
                        */
                    end;

                end;
            }

            action(BatchPackageLabels)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Report;
                Caption = 'Batch Package Label(s)';

                trigger OnAction()
                var
                    Cust: Record Customer;
                    rptPackLabel2: Report BatchPackageLabel2;
                    rptPackBOLBarcode: Report BatchBOLBarcode;
                    rptPackLabel3: Report BatchPackageLabel3;
                    rptPackLabel4: Report BatchPackageLabel4;
                    rptPackLabel5: Report BatchPackageLabel5;
                    rptPackLabelPallet: Report PalletBatchBOLBarcode;
                    rec1: record "Sales Header";
                    ReportLabel: Record ReportLabelStyle;
                    reportNmae: text;
                    ShippingLabelStyleSelected: code[30];
                begin
                    Cust.RESET;
                    Cust.Get(Rec."Sell-to Customer No.");
                    IF rec.ShippingLabelStyle = '' then
                        ERROR('Package Label Style Report needs to be set up in the customer card for %1.  Package Label(s) cannot be printed at this time.', cust.Name);
                    //pr 4/18/25 - make sure all selected are the same label style start
                    rec1.Reset();
                    // gets shipping label of first row selected
                    CurrPage.SetSelectionFilter(rec1);
                    if rec1.FindFirst() then
                        ShippingLabelStyleSelected := rec1.ShippingLabelStyle;
                    rec1.Reset();
                    // makes sure all rows shipping label macth the first shippng label found
                    CurrPage.SetSelectionFilter(rec1);
                    if rec1.findset then
                        repeat
                            if (rec1.ShippingLabelStyle <> ShippingLabelStyleSelected) then
                                ERROR(txtMismacthLabelStyle, ShippingLabelStyleSelected);
                        until rec1.Next() = 0;
                    rec1.Reset();
                    //pr 4/18/25 - make sure all selected are the same label style end
                    ReportLabel.Reset();
                    ReportLabel.SetRange(Code, ShippingLabelStyleSelected);
                    if (ReportLabel.FindSet()) then begin
                        //Report.RunModal(ReportLabel."Repoort ID", true, false, CustomSalesLine)
                        //  else
                        //IF cust.PackageLabelStyle = 0 then
                        //  ERROR('Package Label Style Report needs to be set up in the customer card for %1.  Package Label(s) cannot be printed at this time.', cust.Name);


                        case ShippingLabelStyleSelected of
                            'Default Package':
                                begin
                                    If rec.Count >= 1 then begin
                                        CLEAR(rptPackBOLBarcode);
                                        CurrPage.SetSelectionFilter(rec1);
                                        if rec1.findset then
                                            repeat
                                                rptPackBOLBarcode.LoadCartonInfo(rec1);
                                            until rec1.Next() = 0;
                                        rptPackBOLBarcode.Run();
                                    end;
                                end;
                            'Pallet':
                                begin
                                    If rec.Count >= 1 then begin
                                        CLEAR(rptPackLabel2);
                                        CurrPage.SetSelectionFilter(rec1);
                                        if rec1.findset then
                                            repeat
                                                rptPackLabel2.LoadCartonInfo(rec1);
                                            until rec1.Next() = 0;
                                        rptPackLabel2.Run();
                                    end;
                                end;

                            'Type 3':
                                begin
                                    If rec.Count >= 1 then begin
                                        CLEAR(rptPackLabel3);
                                        CurrPage.SetSelectionFilter(rec1);
                                        if rec1.findset then
                                            repeat
                                                rptPackLabel3.LoadCartonInfo(rec1);
                                            until rec1.Next() = 0;
                                        rptPackLabel3.Run();
                                    end;
                                end;
                            'Type 4':
                                begin
                                    If rec.Count >= 1 then begin
                                        CLEAR(rptPackLabel4);
                                        CurrPage.SetSelectionFilter(rec1);
                                        if rec1.findset then
                                            repeat
                                                rptPackLabel4.LoadCartonInfo(rec1);
                                            until rec1.Next() = 0;
                                        rptPackLabel4.Run();
                                    end;
                                end;

                            'Type 5':
                                begin
                                    If rec.Count >= 1 then begin
                                        CLEAR(rptPackLabel5);
                                        CurrPage.SetSelectionFilter(rec1);
                                        if rec1.findset then
                                            repeat
                                                rptPackLabel5.LoadCartonInfo(rec1);
                                            until rec1.Next() = 0;
                                        rptPackLabel5.Run();
                                    end;
                                end;
                            'Default Pallet':
                                begin
                                    If rec.Count >= 1 then begin
                                        CLEAR(rptPackLabelPallet);
                                        CurrPage.SetSelectionFilter(rec1);
                                        if rec1.findset then
                                            repeat
                                                rptPackLabelPallet.LoadCartonInfo(rec1);
                                            until rec1.Next() = 0;
                                        rptPackLabelPallet.Run();
                                    end;
                                end;
                        end;
                    end;

                end;
            }

            action(RefreshBatch)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Refresh;
                Caption = 'Batch Refresh Packages';

                trigger OnAction()
                var

                    rec1: record "Sales Header";
                    RefreshStr: Label 'Package(s) refreshed for selected Sales Orders.';
                    RefreshCount: Integer;

                begin
                    RefreshCount := 0;
                    CurrPage.SetSelectionFilter(rec1);
                    if rec1.findset then
                        repeat
                            rec1.RefreshPkg();

                            RefreshCount += 1;

                        until rec1.Next() = 0;
                    if RefreshCount > 0 then begin
                        Message(RefreshStr)
                    end;
                end;
            }



        }






    }


    var
        workDescripTxt: text;
        txtExportDone: Label 'Selected picking instruction(s) successfully exported to %1.';
        txtConfirmation: Label 'Are you sure you want to export picking instructions for the selected records?';

        lblNoURL: Label 'No FTP URL is setup for %1 %2';
        txtNoFTPServerFound: Label 'No FTP Server Name found for location %1.';
        txtErrReservationILE: Label 'SO %1 Item %2: At this time, We are not allowing reservations from sources other than Item Ledger Entry.  Please review Reservation Source.';

        txtErrReservationLot: Label 'SO %1 Item %2: The Item quantity you reserved from Item Ledger Entries does not have an assigned Lot No.  Please contact your Item Ledger Entry Administrator.';

        txtLotNoConfirmation: Label 'Are you sure you want to auto assign Lot Number(s) to selected sales orders?';
        txtAutoAssignDone: Label 'Lot No.(s) automatically assigned based on Reserved quantities for selected Sales Orders.';
        txtNoReservation: Label 'No Reservations found.';
        txtMismacthLabelStyle: Label 'All selected rows must have the same Shipping Label Style of %1';
        TmpAutoAssignLotErr: Record TmpAutoAssignLotErr;  //this is a temporary table
        txtErrDuplicateSingleBOL: Label 'Master BOL CANNOT be assigned.  Single BOL No %1 (count = %2) is assigned to more than 1 Sales Order from your selected list.  Please goto the Sales Order Card of one of the sales orders and click onto Actions – Functions – Assign BOL No.';
        txtErrCustomerShipToCode: Label 'Customer Ship-to Code is blank for SO %1.  This is Mandatory.  Please update in Customer Card - Ship To Address.';

    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Work Description");
        workDescripTxt := rec.GetWorkDescription();
    end;

    local procedure UpdateErrAutoAssignLot(var TmpAutoAssignLotErr: Record TmpAutoAssignLotErr; SalesLine: Record "Sales Line"; ErrDescription: Text[250])
    begin
        TmpAutoAssignLotErr.Init();
        TmpAutoAssignLotErr."No." := SalesLine."Document No.";
        TmpAutoAssignLotErr.ItemNo := SalesLine."No.";
        TmpAutoAssignLotErr.LineNo := SalesLine."Line No.";
        TmpAutoAssignLotErr.Quantity := SalesLine.Quantity;
        TmpAutoAssignLotErr.UOM := SalesLine."Unit of Measure Code";
        TmpAutoAssignLotErr.ErrorDescription := ErrDescription;
        TmpAutoAssignLotErr.Insert();
    end;

    local Procedure UpdateParentPackageCnt(DocumentNo: Code[20])
    var
        GetPackageCnt: Decimal;
        GetWeight: Decimal;
        SalesHdr: Record "Sales Header";
        SalesLine: record "Sales Line";
        Item: Record Item;
    begin
        SalesHdr.Reset();
        SalesHdr.SetRange("No.", DocumentNo);
        SalesHdr.SetRange("Document Type", Rec."Document Type");
        if SalesHdr.FindFirst() then begin
            GetPackageCnt := 0;
            GetWeight := 0;
            SalesLine.RESET;
            SalesLine.SetRange("Document No.", DocumentNo);
            SalesLine.SetRange("Document Type", Rec."Document Type");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            IF SalesLine.FindSet() then
                repeat
                    Item.Get(SalesLine."No.");
                    If Item.Type = Item.Type::Inventory then begin
                        SalesLine.CalcFields("M-Pack Qty", "M-Pack Weight");
                        IF SalesLine."M-Pack Qty" > 0 then begin
                            GetPackageCnt := GetPackageCnt + (SalesLine."Quantity (Base)" / SalesLine."M-Pack Qty");
                            GetWeight := GetWeight + ((SalesLine."Quantity (Base)" / SalesLine."M-Pack Qty") * SalesLine."M-Pack Weight");
                        end;
                    end;

                until SalesLine.Next = 0;

            SalesHdr."Total Package Count" := GetPackageCnt;
            SalesHdr."Total Weight" := GetWeight;
            SalesHdr.Modify();
            CurrPage.Update();

        end;
    end;

}
