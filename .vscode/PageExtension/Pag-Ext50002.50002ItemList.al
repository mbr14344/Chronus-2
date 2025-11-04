pageextension 50002 "50002_ItemList" extends "Item List"
{
    layout
    {
        modify("Unit Cost")
        {
            Visible = false;
            Caption = 'Average Unit Cost';
        }
        modify("Last Direct Cost")
        {
            Visible = true;
            ApplicationArea = All;

        }
        modify("Description 2")
        {
            Visible = true;
        }
        addafter(Description)
        {
            field("Purchasing Code"; Rec."Purchasing Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Type")
        {
            field("Item Status"; Rec."Item Status")
            {
                ApplicationArea = All;
            }
            field("M-Pack Qty"; Rec."M-Pack Qty")
            {
                ApplicationArea = all;
            }
            field("Inner Qty"; Rec."Inner Qty")
            {
                ApplicationArea = all;
            }
            field("License Exist"; Rec."License Exist")
            {
                ApplicationArea = All;
            }
            field(Hazard; Rec.Hazard)
            {
                ApplicationArea = All;
            }
            field("Medical Device"; Rec."Medical Device")
            {
                ApplicationArea = All;
            }
            field(Cosmetic; Rec.Cosmetic)
            {
                ApplicationArea = All;
            }
            field(OTC; Rec.OTC)
            {
                ApplicationArea = All;
            }

            field(Brand; Rec.Brand)
            {
                ApplicationArea = All;
            }
            field("Sub-Brand"; Rec."Sub-Brand")
            {
                ApplicationArea = All;
            }
            field(InterStateTransferNeeded; Rec.InterStateTransferNeeded)
            {
                ApplicationArea = All;
            }
        }
        modify(InventoryField)
        {

            ToolTip = 'Specifies total units we have on hand including both good and bad inventories.';
            Caption = 'Finished Goods Qty';
        }
        addafter(InventoryField)
        {
            field(OverseasQty; Rec.OverseasQty)
            {
                ApplicationArea = all;
                DecimalPlaces = 0;
                ToolTip = 'Qty. in the Overseas Location';
            }
            field(OceanQty; Rec.OceanQty)
            {
                ApplicationArea = all;
                DecimalPlaces = 0;
                ToolTip = 'Qty. in the Ocean Location';
                trigger OnDrillDown()
                var
                    ContainerDeliveryPlanning: Page "Container Delivery Planning";
                    ContainerLineRec: Record ContainerLine;
                begin
                    ContainerLineRec.Reset();
                    ContainerLineRec.SetRange("Item No.", Rec."No.");
                    if ContainerLineRec.FindFirst() then begin
                        Clear(ContainerDeliveryPlanning);
                        ContainerDeliveryPlanning.SetTableView(ContainerLineRec);
                        ContainerDeliveryPlanning.Run();
                    end;
                end;
            }
            field("Qty on Transfer Orders"; Rec."Orig Qty on TO" - Rec."Qty on TO Received")
            {
                ApplicationArea = all;
                DecimalPlaces = 0;
                ToolTip = 'Qty. on Transfer Orders that are waiting to ship or in Transit';
                // pr 12/2/24 - show TransferLinesListPg page when clicked on - start
                trigger OnDrillDown()
                var
                    transferList: Page TransferLinesListPg;
                    transferLines: Record "Transfer Line";
                begin
                    transferLines.Reset();

                    transferLines.SetRange("Item No.", Rec."No.");
                    transferLines.SetFilter("Derived From Line No.", '0');
                    transferLines.SetRange("Variant Code", rec."Variant Filter");
                    if (transferLines.FindFirst()) then begin
                        Clear(transferList);
                        transferList.SetTableView(transferLines);
                        transferList.Run();
                    end;

                end;
                // pr 12/2/24 - show TransferLinesListPg page when clicked on - end
            }
            field("Reserved Qty on Sales Orders"; rec."Reserved Qty. on Sales Orders")
            {
                ApplicationArea = all;
                DecimalPlaces = 0;

            }
            field("Net Available"; rec.GetNetAvailable())
            {
                ApplicationArea = All;
                DecimalPlaces = 0;
                ToolTip = ' = Current Inventory - Reserved Qty from Sales Orders - Reserved Qty from Assembly Lines';
            }
            field("Current Inventory"; rec.GetCurrentAvailable())
            {
                ApplicationArea = All;
                DecimalPlaces = 0;
                ToolTip = ' = Qty on Hand - qty from warehouses that are marked as exclude from Current Inventory, such as OVERSEAS, DAMAGED, EXPIRED, SAMPLE, etc.';
            }
            field("Qty. on Purchase Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Assembly Order"; Rec."Qty. on Assembly Order")
            {
                ApplicationArea = All;

            }
            field("Qty. Needed From Ass. Ord."; Rec."Qty. Needed From Ass. Ord.")
            {
                ApplicationArea = All;
                DrillDown = true;
                trigger OnDrillDown()
                var

                    AssemblyLines: Page "Assembly Lines Page";
                    tblAssemblyLines: Record "Assembly Line";
                begin
                    tblAssemblyLines.Reset();
                    tblAssemblyLines.SetRange("No.", Rec."No.");
                    tblAssemblyLines.SetFilter(Type, 'Item');


                    if tblAssemblyLines.FindSet() then begin
                        Clear(AssemblyLines);
                        AssemblyLines.SetTableView(tblAssemblyLines);
                        AssemblyLines.Run();
                    end;
                end;
            }
            field("Reserved Qty. On Ass. Lines"; Rec."Reserved Qty. On Ass. Lines")
            {
                ApplicationArea = All;
            }
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
            }
            field("Searching by"; customerNoToSearch)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(CreatedBy; GetUserNameFromSecurityId(Rec.SystemCreatedBy))
            {
                ApplicationArea = all;
                Caption = 'Created By';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
            }

        }
        //PR 2/14/25 - start
        addbefore(Control1901314507)
        {
            part(ItemPicture; "Item Picture")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "No." = field("No.");
            }
        }
        //PR 2/14/25 - end





    }


    actions
    {
        addafter(History)
        {
            action(ItemLicense)
            {
                ApplicationArea = all;
                Caption = 'Item License';
                Image = CheckList;
                RunObject = Page ItemLicense;
                RunPageLink = "Item No." = field("No.");
                Promoted = true;
                PromotedCategory = Process;
            }
        }
        addafter("Item Substitutions")
        {
            action(ItemInvenotryImageReport)
            {
                ApplicationArea = all;
                Caption = 'Item Inventory With Images';
                Image = Report;
                //Promoted = true;
                //PromotedCategory = Report;
                trigger OnAction()
                var
                    item: Record Item;
                    ItemImageReport: Report "Item Inventory With Images";
                    items: text;
                begin
                    item.reset;
                    CurrPage.SetSelectionFilter(item);
                    Clear(ItemImageReport);
                    ItemImageReport.SetTableView(item);
                    ItemImageReport.Run();
                    // end;
                end;

            }
        }
        addafter(RequestApproval)
        {
            // pr 6/14/24 added button to search items by customer
            action(SearchByCustomer)
            {
                ApplicationArea = all;
                Caption = 'Search By Customer';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    //PgItemCustSearch: Page ItemCustomerSearch;
                    getStr: Text;

                begin
                    cust.Reset();
                    CLEAR(PgItemCustSearch);
                    PgItemCustSearch.SetTableView(Cust);
                    PgItemCustSearch.SetRecord(Cust);
                    if PgItemCustSearch.RunModal() = ACTION::OK then begin

                        searchesMade := 0;
                        PgItemCustSearch.GetRecord(Cust);
                        customerNoToSearch := Cust."No.";
                        SearchSalesPrice();
                        PgItemCustSearch.Close();

                    end;

                end;

            }

            action(Export832ItemMaster)
            {
                ApplicationArea = All;
                Caption = 'Export 832 - Item Master';
                ToolTip = 'Export 832 - Item Master';
                Image = ExportAttachment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Item: Record Item;
                    popupConfirm: Page "Confirmation Dialog";
                    ftpserver: Record FTPServer;
                    Loc: Record Location;
                    XMLCU: Codeunit XMLCU;
                    ftpSelect: Page FTPServerExportSelect;
                    selectedFtpServerName: text;
                    selectedItems: text;
                begin
                    selectedFtpServerName := '';
                    Clear(popupConfirm);
                    popupConfirm.setMessage(txtConfirmatio832);
                    Commit;
                    if popupConfirm.RunModal() = Action::yes then begin
                        ftpserver.Reset();
                        ftpserver.SetRange(Mode, ftpserver.Mode::EXPORT);
                        clear(ftpSelect);
                        ftpSelect.SetTableView(ftpserver);
                        ftpSelect.LookupMode(true);
                        ftpSelect.Caption('Select Destination File Server');

                        if (ftpSelect.RunModal() = Action::LookupOK) then begin
                            ftpSelect.SetSelectionFilter(ftpserver);

                        end;

                        if NOT ftpserver.FindFirst() then
                            Error(txtNoFTPServerFound, Rec."Item Tracking Code");


                        if strlen(ftpserver.URL) = 0 then
                            Error(lblNoURL, ftpserver."Server Name", FORMAT(ftpserver.Mode));

                        CurrPage.SetSelectionFilter(Item);
                    end;
                    if Item.FindSet then
                        repeat
                            selectedItems += item."No." + '|';
                        until Item.Next() = 0;
                    selectedItems := selectedItems.TrimEnd('|');
                    selectedItems := selectedItems.TrimStart('|');
                    selectedItems := selectedItems.Trim();
                    XMLCU.Export832ItemMasterReceiver(Item, ftpserver, selectedItems);

                    Message(txtExportDone832, ftpserver."Server Name");
                end;


            }

            action(Export832ItemMasterSpecial)
            {
                ApplicationArea = All;
                Caption = 'Export 832 - Item Master-Custom';
                ToolTip = 'Export 832 - Item Master-Custom';
                Image = ExportAttachment;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    Item: Record Item;
                    popupConfirm: Page "Confirmation Dialog";
                    ftpserver: Record FTPServer;
                    Loc: Record Location;
                    XMLCU: Codeunit XMLCU;
                    ftpSelect: Page FTPServerExportSelect;
                    selectedFtpServerName: text;
                    UserPermissions: Codeunit "User Permissions";
                    User: Record User;
                begin
                    User.Reset();
                    User.SETRANGE("User Name", UserId);
                    If User.FindFirst() then begin
                        IF Not UserPermissions.IsSuper(User."User Security ID") then
                            Error('You do NOT have permissions to run this process.  Please contact your System Administrator');

                    end;
                    selectedFtpServerName := '';
                    Clear(popupConfirm);
                    popupConfirm.setMessage(txtConfirmatio832);
                    Commit;
                    if popupConfirm.RunModal() = Action::yes then begin
                        ftpserver.Reset();
                        ftpserver.SetRange(Mode, ftpserver.Mode::EXPORT);
                        clear(ftpSelect);
                        ftpSelect.SetTableView(ftpserver);
                        ftpSelect.LookupMode(true);
                        ftpSelect.Caption('Select Destination File Server');

                        if (ftpSelect.RunModal() = Action::LookupOK) then begin
                            ftpSelect.SetSelectionFilter(ftpserver);

                        end;

                        if NOT ftpserver.FindFirst() then
                            Error(txtNoFTPServerFound, Rec."Item Tracking Code");


                        if strlen(ftpserver.URL) = 0 then
                            Error(lblNoURL, ftpserver."Server Name", FORMAT(ftpserver.Mode));

                        CurrPage.SetSelectionFilter(Item);
                    end;

                    XMLCU.Export832ItemMasterReceiverCustom(Item, ftpserver);

                    Message(txtExportDone832, ftpserver."Server Name");
                end;


            }

        }

        addlast(Processing)
        {
            action(AshtelCalendar)
            {
                ApplicationArea = All;
                Caption = 'Ashtel Calendar';
                Image = Calendar;
                ToolTip = 'Open the shared Ashtel Calendar';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PgAshtelCalendar: Page "Calendar Page";
                begin
                    Clear(PgAshtelCalendar);
                    PgAshtelCalendar.Run();
                end;
            }
        }
    }

    local procedure SearchSalesPrice()
    begin

        itemSearchStr := '';
        salesPrice.Reset();
        salesPrice.SetRange("Sales Code", customerNoToSearch);
        salesPrice.SetRange("Sales Type", salesPrice."Sales Type"::Customer);

        if (salesPrice.FindSet()) then begin

            tempItemSearchStr := itemSearchStr;

            isSearchingForCust := true;
            repeat
                itemSearchStr += salesPrice."Item No." + '|';
            until salesPrice.Next() = 0;
            itemSearchStr := itemSearchStr.TrimEnd('|');
            itemSearchStr := itemSearchStr.TrimStart('|');
            itemSearchStr := itemSearchStr.Trim();


            // notifys user that items were found 
            notificationSearch.Message('Searching for : ' + customerNoToSearch);
            notificationSearch.Scope(NotificationScope::LocalScope);
            notificationSearch.Send();
            // filters table for customer specifc items
            Rec.Reset();
            Rec.SetFilter("No.", itemSearchStr);


        end
        // if no items were found
        else begin
            //isSearchingForCust := false;
            Rec.Reset();
            Rec.SetFilter("No.", '');
            notificationSearch.Recall();
        end;



    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if UserSetup."Item Admin" = false then begin
            Error(txtNotAdminAdd);
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if UserSetup."Item Admin" = false then begin
            Error(txtNotAdminDel);
        end;
    end;



    trigger OnModifyRecord(): Boolean
    begin
        if UserSetup."Item Admin" = false then begin
            Error(txtNotAdminMod);
        end;
    end;

    trigger OnOpenPage()
    begin
        isSearchingForCust := false;
        searchesMade := 0;
        tempItemSearchStr := '';
        UserSetup.Get(UserId);
    end;



    trigger OnAfterGetCurrRecord()
    begin
        ChkFilter := rec.GetFilter("No.");


        if StrLen(customerNoToSearch) > 0 then begin
            if StrLen(ChkFilter) <= 0 then
                notificationSearch.Recall()
            else begin
                notificationSearch.Message('Searching for : ' + customerNoToSearch);
                notificationSearch.Scope(NotificationScope::LocalScope);
                notificationSearch.Send();
            end;

        end;
        descripFilter := rec.GetFilter(Description);
        if (StrLen(descripFilter) > 0) then begin
            // rec.SetFilter(Description, '@' + descripFilter);
        end;

    end;

    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Qty on TO Received", "Orig Qty on TO");


    end;


    var
        userSetup: Record "User Setup";
        salesPrice: Record "Sales Price";
        itemSearchStr: Text;
        tempItemSearchStr: Text;
        olditemSearchstr: Text;
        customerNoToSearch: code[20];
        Cust: Record Customer;
        notificationSearch: Notification;

        PgItemCustSearch: Page ItemCustomerSearch;
        searchesMade: Integer;

        x: Integer;
        y: integer;
        isSearchingForCust: Boolean;
        ChkFilter: Text;
        descripFilter: Text;
        LastChkFilter: Text;
        txtExportDone: Label 'Selected 943 - Receiver notice for Transfer Order(s) successfully exported to %1.';
        txtExportDone832: Label 'Selected 832 - Item Master File Notice(s) exported to %1.';
        txtConfirmation: Label 'Are you sure you want to export 943 - Receiver Notice(s)?';
        txtConfirmatio832: Label 'Are you sure you want to export 832 - Item Master File Notice(s)?';

        lblNoURL: Label 'No FTP URL is setup for %1 %2';
        txtNoFTPServerFound: Label 'No FTP Server Name found for location %1.';
        txtOnDelete: Label 'Transfer Order %1 is assigned to Container %2. DELETE NOT allowed. Please unassign Container %2.';
        txtNotAdminMod: Label 'You are not allowed to modify items as you are not marked as Item Admin in User Setup. Please contact your system administrator.';
        txtNotAdminAdd: Label 'You are not allowed to add items as you are not marked as Item Admin in User Setup. Please contact your system administrator.';
        txtNotAdminDel: Label 'You are not allowed to delete items as you are not marked as Item Admin in User Setup. Please contact your system administrator.';

    procedure GetUserNameFromSecurityId(UserSecurityID: Guid): Code[50]
    var
        User: Record User;
    begin
        User.Get(UserSecurityID);
        exit(User."User Name");
    end;
}
