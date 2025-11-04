pageextension 50004 "SalesOrderExt" extends "Sales Order"
{
    //pr 1/11/24 added extension for sales order page

    layout
    {

        modify("Due Date")
        {
            Caption = 'Payment Due Date';


        }
        modify("Shipping Agent Code")
        {
            Caption = 'Shipping Carrier';
            ApplicationArea = All;

        }
        modify("Shipping Agent Service Code")
        {
            Caption = 'Shipping Carrier Service Code';
            ApplicationArea = All;

        }
        modify("Posting Date")
        {
            style = StrongAccent;
            StyleExpr = true;

        }
        modify("External Document No.")
        {
            trigger OnBeforeValidate()
            var
                txtConfirmExtDocNo: Label 'Are you sure you want to change the External Document No. / Customer PO No.?';
            begin
                if (Rec."External Document No." <> xRec."External Document No.") and (xRec."External Document No." <> '') then begin
                    if not Confirm(txtConfirmExtDocNo, false) then
                        Error('Task Aborted');
                end;
            end;
        }
        addafter("Requested Delivery Date")
        {
            field("Cancel Date"; Rec."Cancel Date")
            {
                ApplicationArea = All;
            }

        }
        modify("Ship-to Code")
        {
            Caption = 'Ship to Code';

            Visible = true;
        }

        addbefore("Requested Delivery Date")
        {
            field("Request Ship Date"; Rec."Request Ship Date")
            {
                ApplicationArea = All;
            }
            field("Start Ship Date"; Rec."Start Ship Date")
            {
                ApplicationArea = All;
            }

            field("APT Date"; Rec."APT Date")
            {
                ApplicationArea = All;
            }
            field("APT Time"; Rec."APT Time")
            {
                ApplicationArea = All;
            }

        }
        addbefore("Sell-to")
        {
            field("Split"; Rec.Split)
            {
                ApplicationArea = All;
            }
        }
        addafter(Status)
        {
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
            //PR 4/15/25 - start
            field(ShippingLabeltype; Rec.ShippingLabelStyle)
            {
                ApplicationArea = All;
            }
            //PR 4/15/25 - end
            field("EDI discount Calculated"; Rec."EDI discount Calculated")
            {
                ApplicationArea = all;
                trigger OnValidate()
                var
                    Customer: Record Customer;
                begin

                    if (rec."EDI Discount Calculated" = false) then begin
                        Clear(popupConfirm);
                        popupConfirm.setMessage(txtRcalculate);
                        Commit;
                        if popupConfirm.RunModal() = Action::yes then
                            rec.CalcEDI(false)
                        else
                            bSkipEdiCalc := true;
                    end
                    else begin
                        rec.CalcEDI(false);
                    end;
                end;
            }


        }
        addAfter("External Document No.")
        {

            field("Order Reference"; Rec."Order Reference")
            {
                ApplicationArea = All;
            }
            field("Flag"; Rec.Flag)
            {
                ApplicationArea = All;
            }
            field("In the Month"; Rec."In the Month")
            {
                ApplicationArea = All;
            }
            field("Order Notes"; Rec."Order Notes")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
            field(Internal; Rec.Internal)
            {
                ApplicationArea = All;
            }
            field(Master; Rec.Master)
            {
                ApplicationArea = All;
            }

        }
        addafter("Completely Shipped")
        {
            field("Single BOL No."; Rec."Single BOL No.")
            {
                ApplicationArea = All;
                Editable = false;
                style = StrongAccent;
            }
            field("BOL Comment"; Rec."BOL Comments")
            {
                ApplicationArea = All;
            }
            field("Freight Charge Terms"; Rec.FreightChargeTerm)
            {
                ApplicationArea = all;
                Editable = true;
            }
            //pr 6/24/24 - start
            field("Freight Charge Name"; Rec."Freight Charge Name")
            {
                ApplicationArea = All;
            }
            field("Freight Charge Address"; Rec."Freight Charge Address")
            {
                ApplicationArea = All;
            }
            field("Freight Charge City"; Rec."Freight Charge City")
            {
                ApplicationArea = All;
            }
            field("Freight Charge State"; Rec."Freight Charge State")
            {
                ApplicationArea = All;
            }
            field("Freight Charge Zip"; Rec."Freight Charge Zip")
            {
                ApplicationArea = All;
            }
            field("Freight Charge Contact"; Rec."Freight Charge Contact")
            {
                ApplicationArea = All;
            }
            //pr 6/24/24 - end
            field(Type; Rec.Type)
            {
                ApplicationArea = All;
            }
            field(Dept; Rec.Dept)
            {
                ApplicationArea = All;
            }
            field("Total Package Count"; Rec."Total Package Count")
            {
                ApplicationArea = All;
            }
            field("Total Weight"; Rec."Total Weight")
            {
                ApplicationArea = All;
            }
            field("Total Pallet Count"; Rec."Total Pallet Count")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Start Ship Date")
        {
            field(LblStat; LblStat)
            {
                ApplicationArea = All;
                Editable = false;
                Style = Unfavorable;
                Caption = '';

            }
        }
        addafter("Sell-to Customer Name")
        {
            //PR 12/19/24
            field("Customer Responsibility Center"; Rec."Customer Responsibility Center")
            {
                ApplicationArea = All;
                ToolTip = 'Customer Responsibility Center: This is maintained in the Customer Card.';
            }
        }
        addafter("Ship-to Code")
        {
            field(CustomerShipToCode; Rec.CustomerShipToCode)
            {
                ApplicationArea = All;
                Editable = false;
            }

        }
        addafter("Work Description")
        {
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

        }




    }

    actions
    {
        addfirst(processing)
        {
            action(SplitSO)
            {
                ApplicationArea = All;
                Caption = 'Split Sales Order';
                Image = Split;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    SplitPg: page SelectLocationToSplit;
                    salesLine: Record "Sales Line";
                    GLWithNoEDIErr: Label 'Sales Line(s) %1 include a G/L Account defined in the EDI G/L Account Setup but missing an EDI Inv. Line Discount.  Please correct before splitting the Sales Order.';
                    errSalesLineGLErr: Label 'Sales Line %1 is a G/L Account %2 that is not defined in the EDI G/L Account setup.  Splitting of Sales Order is NOT allowed.  Please contact your SO Admin.';
                    ConfirmSalesLineGL: Label 'Sales Line %1 is a G/L Account %2 that is not defined in the EDI G/L Account setup.  Do you want to override and continue splitting the Sales Order?';
                    inValidGlLineNo: text;
                    inValidGlLineNoCount: Integer;
                    glSetup: Record "EDI G\L Account";
                    UserSetup: Record "User Setup";
                    errTaskAborted: Label 'Splitting of Sales Order Aborted by User.';
                begin
                    inValidGlLineNoCount := 0;
                    salesLine.Reset();
                    salesLine.SetRange("Document Type", rec."Document Type");
                    salesLine.SetRange("Document No.", rec."No.");
                    salesLine.SetRange(Type, salesLine.Type::"G/L Account");
                    if (salesLine.FindSet()) then
                        repeat
                            if (not glSetup.Get(salesLine."No.")) then begin
                                UserSetup.Reset();
                                UserSetup.SetRange("User ID", UserId);
                                UserSetup.SetRange(SOAdmin, true);
                                if not UserSetup.FindFirst() then
                                    Error(errSalesLineGLErr, salesLine."Line No.", salesLine."No.")
                                else begin
                                    if Confirm(StrSubstNo(ConfirmSalesLineGL, salesLine."Line No.", salesLine."No.")) = false then
                                        Error(errTaskAborted);
                                end;
                            end
                            else
                                if (salesLine."EDI Inv Line Discount" = 0) then begin
                                    inValidGlLineNoCount += 1;
                                    inValidGlLineNo := inValidGlLineNo + Format(salesLine."Line No.") + ', ';
                                end;

                        until salesLine.Next() = 0;

                    if inValidGlLineNoCount > 0 then begin
                        inValidGlLineNo := inValidGlLineNo.TrimEnd(',');
                        Error(GLWithNoEDIErr, inValidGlLineNo);
                    end;

                    Clear(SplitPg);
                    SplitPg.SetTableView(Rec);
                    SplitPg.SetRecord(Rec);
                    If SplitPg.RunModal() = Action::LookupOK then
                        SplitPg.GetRecord(Rec);
                end;
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

                begin
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.", Rec."No.");
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
                                                IF GetResEntry."Source Type" <> Database::"Item Ledger Entry" then
                                                    Error('At this time, We are not allowing reservations from sources other than Item Ledger Entry.  Please review Reservation Source.');
                                                IF GetResEntry."Item Tracking" <> GetResEntry."Item Tracking"::"Lot No." then begin
                                                    IF GetResEntry."Lot No." = '' then
                                                        Error('The Item quantity you reserved from Item Ledger Entries does not have an assigned Lot No.  Please contact your Item Ledger Entry Administrator.')
                                                end;
                                                ResEntry."Item Tracking" := GetResEntry."Item Tracking";
                                                ResEntry."Lot No." := GetResEntry."Lot No.";
                                                ResEntry."Expiration Date" := GetResEntry."Expiration Date";
                                                ResEntry.Modify();
                                            end;
                                        end;
                                    until ResEntry.Next = 0;
                            end
                        until SalesLine.Next() = 0;




                    Message(StrSubstNo('Lot No.(s) automatically assigned based on Reserved quantities for Sales Order No. %1.'), Rec."No.");
                end;
            }
            action(CreatePackages)
            {
                ApplicationArea = All;
                Caption = 'Refresh Package(s)';
                Image = Task;
                Promoted = true;
                PromotedCategory = Process;

                trigger onAction()
                var
                    bCont: Boolean;
                    SalesLine: Record "Sales Line";
                    Item: Record Item;
                    ReportLabel: Record ReportLabelStyle;
                begin
                    ReportLabel.Reset();
                    ReportLabel.SetRange("Use Pallet", true);
                    ReportLabel.SetRange(Code, Rec.ShippingLabelStyle);
                    if (ReportLabel.FindSet()) then begin
                        Error(txtPalletRefreshErr, Rec.ShippingLabelStyle);
                    end;
                    SalesLine.reset;
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.", Rec."No.");
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    SalesLine.SetFilter("M-Pack Qty", '%1', 0);
                    //mbr 3/25/25 - we only want to refresh the type item where item = inventory - start
                    if (SalesLine.FindSet()) then
                        repeat
                            Item.Reset;
                            item.SetRange("No.", SalesLine."No.");
                            item.SetRange(Type, item.Type::Inventory);
                            if item.FindFirst() then
                                Error(txtZeroQtyLineFound);
                        until SalesLine.Next() = 0;

                    bCont := true;
                    CartonInfo.Reset;
                    CartonInfo.SetRange("Document Type", Rec."Document Type");
                    CartonInfo.SetRange("Document No.", Rec."No.");
                    IF CartonInfo.FindFirst() then begin
                        Clear(popupConfirm);
                        if CartonInfo.Imported = false then
                            popupConfirm.setMessage(StrSubstNo(txtRefreshPackageReg, Rec."No."))
                        else
                            popupConfirm.setMessage(StrSubstNo(txtRefreshPackageImp, Rec."No."));

                        Commit;
                        if popupConfirm.RunModal() = Action::No then
                            bCont := false;
                    end;
                    if bCont = true then begin
                        rec.UpdatePackageInfo();
                        Message('Package(s) refreshed for Sales Order ' + rec."No." + '.');
                        CurrPage.Update();
                    end;

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
                trigger OnAction()

                var
                    ftpStoreFile: Record FTPStoreFile;
                    PgFTPExpImp: page "FTP Exported/Imported Files";
                begin
                    ftpStoreFile.Reset();
                    ftpStoreFile.SetRange("Document No.", Rec."No.");
                    if ftpStoreFile.FindSet() then begin
                        Clear(PgFTPExpImp);
                        PgFTPExpImp.SetRecord(ftpStoreFile);
                        PgFTPExpImp.SetTableView(ftpStoreFile);
                        PgFTPExpImp.RunModal();
                    end
                    else
                        Message(TxtNoDocAssoc, Rec."No.");

                end;
            }
            action(CartonInformation)
            {
                ApplicationArea = All;
                Caption = 'Package Information';
                Promoted = true;
                PromotedCategory = Process;
                Image = ViewPage;
                // RunObject = page CartonInformation;
                // RunPageLink = "Document No." = field("No.");
                trigger OnAction()
                var
                    CartonInfo: Record CartonInformation;
                    PkgInfoPage: page CartonInformation;
                begin
                    CartonInfo.Reset();
                    CartonInfo.SetRange("Document No.", rec."No.");
                    CartonInfo.SetFilter("Item No.", '<>%1', '');
                    PkgInfoPage.SetRecord(CartonInfo);
                    PkgInfoPage.SetTableView(CartonInfo);
                    PkgInfoPage.GetAssignedSalesOrder(rec);

                    PkgInfoPage.Run();

                end;
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
                    ReportLabel: Record ReportLabelStyle;
                begin
                    Cust.RESET;
                    Cust.Get(Rec."Sell-to Customer No.");

                    IF rec.ShippingLabelStyle = '' then
                        ERROR('Package Label Style Report needs to be set up in the Sales Order card for %1.  Package Label(s) cannot be printed at this time.', rec."No.");

                    CustomSalesLine.SetRange("Document No.", Rec."No.");
                    if CustomSalesLine.FindFirst() then begin
                        ReportLabel.Reset();
                        ReportLabel.SetRange(Code, rec.ShippingLabelStyle);
                        if (ReportLabel.FindSet()) then
                            Report.RunModal(ReportLabel."Report ID", true, false, CustomSalesLine)
                        else
                            ERROR('Package Label Style Report needs to be set up in the Sales Order card for %1.  Package Label(s) cannot be printed at this time.', rec."No.");
                        /* case cust.PackageLabelStyle of
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
                         end;*/
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
                begin
                    Clear(popupConfirm);
                    popupConfirm.setMessage(StrSubstNo(txtConfirmation, Rec."No."));
                    Commit;
                    if popupConfirm.RunModal() = Action::yes then begin
                        If Loc.Get(Rec."Location Code") then;
                        ftpserver.Reset();
                        ftpserver.SetRange("Server Name", Loc."FTP Server Name");
                        ftpserver.SetRange(Mode, ftpserver.Mode::EXPORT);
                        if NOT ftpserver.FindFirst() then
                            Error(txtNoFTPServerFound, Rec."Location Code");

                        if strlen(ftpserver.URL) = 0 then
                            Error(lblNoURL, ftpserver."Server Name", FORMAT(ftpserver.Mode));

                        CurrPage.SetSelectionFilter(SalesHdr);
                        if SalesHdr.FindFirst() then begin
                            //make sure CustomerShiptoCode is populated
                            SalesHdr.CalcFields(CustomerShipToCode);
                            if SalesHdr.CustomerShipToCode = '' then
                                Error(txtErrCustomerShipToCode, SalesHdr."No.");
                            XMLCU.ExportXML(SalesHdr, ftpserver);
                        end;



                        Message(txtExportDone, ftpserver."Server Name", Rec."No.");
                    end;


                end;

            }





        }


        addAfter("Report Picking List by Order")
        {

            // pr 1/24/24 added button to make BOL report
            action("Bill of Lading")
            {
                ApplicationArea = all;
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()

                var
                    PSS: Record "Sales Header";
                begin
                    //Message('1');
                    PSS.SetRange("No.", Rec."No.");
                    IF PSS.FindFirst() then begin
                        // Message('2');
                        Clear(myReport);
                        myReport.SetTableView(PSS);
                        myReport.RunModal;
                    end;
                end;
            }
            action("Bill of Lading - Detail")
            {
                ApplicationArea = all;
                Image = LedgerBook;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()

                var
                    PSS: Record "Sales Header";
                begin
                    //Message('1');
                    PSS.SetRange("No.", Rec."No.");
                    IF PSS.FindFirst() then begin
                        Clear(myReportDetail);
                        myReportDetail.SetTableView(PSS);
                        myReportDetail.RunModal;
                    end;
                end;
            }

        }
        addafter("Archive Document")
        {

            action("Assign BOL No.")
            {
                ApplicationArea = all;
                Image = Report;
                trigger OnAction()
                var
                    NewBOLNo: Code[20];
                    SalesHdr: Record "Sales Header";
                begin
                    if (SalesNRecieveable.FindFirst()) then;

                    IF STRLEN(SalesNRecieveable."Single BOL Nos.") = 0 then
                        Error('No. Series for Single BOL Nos. is NOT set up.  Please review.');
                    //NewBOLNo := NoSeriesMgt.DoGetNextNo(SalesNRecieveable."Single BOL Nos.", WorkDate(), true, true);  //old code
                    NewBOLNo := NoSeries.GetNextNo(SalesNRecieveable."Single BOL Nos.");
                    //Check to ensure we have unique BOL for the same customer
                    SalesHdr.Reset();
                    SalesHdr.SetRange("Document Type", Rec."Document Type");
                    SalesHdr.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");

                    SalesHdr.SetFilter("Single BOL No.", '=%1', NewBOLNo);
                    IF SalesHdr.FindFirst() then
                        Error('BOL No. %1 has already been assigned to %2.  Please try again or contact Admin.', NewBOLNo, SalesHdr."No.")
                    Else begin
                        Rec."Single BOL No." := NewBOLNo;
                        Rec.Modify();
                    end;

                end;

            }
        }

        modify(Post)
        {
            Trigger OnBeforeAction()
            begin
                CheckReserveQty();
            end;

        }
        modify(PostAndNew)
        {
            Trigger OnBeforeAction()
            begin
                CheckReserveQty();
            end;
        }
        modify(PostAndSend)
        {

            Trigger OnBeforeAction()
            begin
                CheckReserveQty();
            end;
        }
        modify(PreviewPosting)
        {
            trigger OnBeforeAction()
            begin
                CheckReserveQty();
            end;

        }
    }





    var
        GetBOLNo: Code[10];
        //NoSeriesMgt: Codeunit NoSeriesManagement;  //old code
        NoSeries: Codeunit "No. Series";
        GenCU: Codeunit GeneralCU;
        myReport: Report "Bill of Lading";
        workDescripTxt: text;

        myReportDetail: Report BOLDetailedReport;
        SalesNRecieveable: Record "Sales & Receivables Setup";
        LblStat: text[40];
        CartonInfo: Record CartonInformation;
        popupConfirm: Page "Confirmation Dialog";

        SalesHeader: Record "Sales Header";
        txtExportDone: Label '%2 picking instructions successfully exported to %1.';
        txtConfirmation: Label 'Are you sure you want to export picking instructions for Sales Order %1?';
        TxtNoDocAssoc: Label 'No Export/Import files found for %1.';
        txtRcalculate: Label 'Do you want to recalculate EDI discount(s)?';
        txtRefreshPackageReg: Label 'Package Label(s) currently exist for %1. Refresh anyway?';
        txtRefreshPackageImp: Label 'IMPORTED Package Label(s) currently exist for %1. Override?';
        txtZeroQtyLineFound: Label ' or more sales line items have M-Pack Qty = 0. Refresh Packages FAILED.';
        lblNoURL: Label 'No FTP URL is setup for %1 %2';
        txtNoFTPServerFound: Label 'No FTP Server Name found for location %1.';
        getSO_NO: Code[20];
        bSkipEdiCalc: Boolean;
        txtFinanceAdminConfirmation: Label 'Package information exists for Sales order %1. Do you really want to delete?';
        txtDelWithCartonInfo: Label 'Package information exists for Sales order %1 and CANNOT be deleted.';
        txtTaskAborted: Label '%1 Task Aborted!';
        txtPalletRefreshErr: Label 'Your Shipping Label Style Report is marked as %1.  You cannot use Refresh Package. Please use Package Information.';
        txtErrCustomerShipToCode: Label 'Customer Ship-to Code is blank for SO %1.  This is Mandatory.  Please update in Customer Card - Ship To Address.';

    trigger OnAfterGetRecord()
    var
        ship: Record "Ship-to Address";
    begin
        UpdPackageLabelTxt();

        RetrieveDeptType();  //Retrieve Dept/Type if applicable
        bSkipEdiCalc := false;  //reset bSkipEdiCalc

        if bSkipEdiCalc = false then begin
            // CurrPage.Update();
            RunEDIDiscountCalc();
            CurrPage.Update(false);
        end;
        UpdUnitPriceIfApplicable();
        rec.CalcFields(CustomerShipToCode);
        Commit();


    end;

    trigger OnOpenPage()
    var
        SalesHdr: Record "Sales Header";
    begin
        IF Rec."No." <> '' then begin
            SalesHdr.Reset();
            SalesHdr.SetRange("No.", Rec."No.");
            if SalesHdr.FindFirst() then begin
                SalesHdr.Validate("Posting Date", Today);
                SalesHdr.Modify();
            end;

        end;


    end;


    //PR 3/24/25 - start -if any package information exists, error out if regular users, else if Finance Admin (From User Setup), then give option to delete (Yes/No).
    trigger OnDeleteRecord(): Boolean
    var
        CartonInfo: Record CartonInformation;
        UserSetup: Record "User Setup";
    begin
        // checks if pkg info exists
        CartonInfo.Reset();
        CartonInfo.SetRange("Document No.", rec."No.");
        if (CartonInfo.FindFirst()) then begin
            UserSetup.Reset();
            UserSetup.SetRange("User ID", UserId);
            UserSetup.SetRange(FinanceAdmin, true);
            if UserSetup.FindFirst() then begin
                if Confirm(StrSubstNo(txtFinanceAdminConfirmation, rec."No.")) = false then
                    Error(txtTaskAborted, 'Delete');
            end
            else
                Error(txtDelWithCartonInfo, rec."No.");
        end;
    end;
    //PR 3/24/25 - end

    //mbr 9/23/24 - start
    //Before posting sales order, check each Sales Line Item.  If Qty to ship base <> Reserved qty base, then error out
    local procedure CheckReserveQty()
    var
        txtErrSalesLineQtyToShip: Label 'Item %1 Qty. To Ship <> Reserved Qty.';
        txtErrSalesLineQtyBase: Label 'Item %1 Outstanding Qty.<> Reserved Qty.';
        txtErrSalesLineQtyBaseConfirm: Label 'Item %1 Qty.<> Reserved Qty. Override?';
        txtErrSalesLineQtyToShipConfirm: Label 'Item %1 with Qty. To Ship <> Reserved Qty. Override?';
        UserSetup: Record "User Setup";
        Location: Record Location;
        bAdmin: Boolean;
        popupConfirm: Page "Confirmation Dialog";
        txtTaskAborted: Label 'Task Aborted!';
        SalesLine: Record "Sales Line";
        Item: Record Item;
        customer: Record Customer;
    begin

        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        UserSetup.SetRange(SOAdmin, true);
        if UserSetup.FindFirst() then
            bAdmin := true
        else
            bAdmin := false;


        //Mode = 1 => we are posting from Sales Order

        SalesLine.Reset();
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange(Type, SalesLine.Type::Item);

        IF SalesLine.FindSet() then
            repeat
                Item.Reset;
                Item.SETRANGE("No.", SalesLine."No.");
                Item.SETRANGE(Type, Item.Type::Inventory);
                IF Item.FindFirst() then begin
                    SalesLine.CalcFields("Reserved Qty. (Base)");
                    Location.Reset();
                    Location.SetRange(Code, SalesLine."Location Code");
                    Location.SetRange("Require Shipment", true);
                    if Location.FindFirst() then begin
                        if SalesLine."Outstanding Qty. (Base)" <> SalesLine."Reserved Qty. (Base)" then begin
                            if bAdmin = true then begin
                                Clear(popupConfirm);
                                popupConfirm.setMessage(StrSubstNo(txtErrSalesLineQtyBaseConfirm, SalesLine."No."));
                                Commit;
                                if popupConfirm.RunModal() = Action::No then
                                    Error(txtTaskAborted);
                            end
                            else
                                Error(txtErrSalesLineQtyBase, SalesLine."No.");
                        end;


                    end

                    else begin

                        if SalesLine."Qty. to Ship (Base)" <> SalesLine."Reserved Qty. (Base)" then begin
                            if bAdmin = true then begin
                                Clear(popupConfirm);
                                popupConfirm.setMessage(StrSubstNo(txtErrSalesLineQtyToShipConfirm, SalesLine."No."));
                                Commit;
                                if popupConfirm.RunModal() = Action::No then
                                    Error(txtTaskAborted);
                            end
                            else
                                Error(txtErrSalesLineQtyToShip, SalesLine."No.");
                        end;

                    end;
                end;


            until SalesLine.Next() = 0;




    end;
    //mbr 9/23/24 - end

    //mbr 10/4/24 - start
    //If Your Reference starts with 'EDI' and Type or Dept is Blank for Document type = Order, then copy Dept and/or Type from Sales Comment Line
    local procedure RetrieveDeptType()
    var
        SalesCommentLn: Record "Sales Comment Line";
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            If StrPos(Rec."Your Reference", 'EDI') = 1 then begin
                SalesCommentLn.Reset();
                SalesCommentLn.SetRange("Document Type", Rec."Document Type");
                SalesCommentLn.SetRange("No.", Rec."No.");
                SalesCommentLn.SetFilter(Code, '%1|%2', 'DP', 'MR');
                IF SalesCommentLn.FindSet() then
                    repeat
                        Case SalesCommentLn.Code of
                            'DP':
                                begin
                                    if StrLen(Rec.Dept) = 0 then begin
                                        Rec.Dept := CopyStr(SalesCommentLn.Comment.TrimEnd(), 4, STRLEN(SalesCommentLn.Comment.TrimEnd()) - 3);
                                    end;

                                end;
                            'MR':
                                begin
                                    if StrLen(Rec.Type) = 0 then begin
                                        Rec.Type := CopyStr(SalesCommentLn.Comment.TrimEnd(), 4, STRLEN(SalesCommentLn.Comment.TrimEnd()) - 3);
                                    end;

                                end;
                        end;
                    until SalesCommentLn.Next() = 0;
            end;

    end;

    local procedure RunEDIDiscountCalc()
    begin
        SalesHeader.Reset();
        SalesHeader.SetCurrentKey("No.", "Document Type");
        SalesHeader.SetRange("No.", Rec."No.");
        SalesHeader.SetRange("Document Type", Rec."Document Type");
        If SalesHeader.FindFirst() then begin
            if getSO_NO <> Rec."No." then begin
                getSO_NO := Rec."No.";
                SalesHeader.CalcEDI(true);
                //GenCU.CalcEDI(SalesHeader, true);
            end;

        end;
    end;

    local procedure UpdPackageLabelTxt()
    begin
        CartonInfo.Reset;
        CartonInfo.SetRange("Document Type", Rec."Document Type");
        CartonInfo.SetRange("Document No.", Rec."No.");
        IF CartonInfo.FindFirst() then
            LblStat := '***** Package Label(s) Created! *****'
        else
            LblStat := '';
    end;

    local procedure UpdUnitPriceIfApplicable()
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange(UnitPriceChecked, false);
        if SalesLine.FindSet() then begin
            repeat
                SalesLine.UpdateUnitPriceByReqDelDt(SalesLine);
                SalesLine.Modify();
            until SalesLine.Next() = 0;
            CurrPage.Update(false);
        end;

    end;
}
