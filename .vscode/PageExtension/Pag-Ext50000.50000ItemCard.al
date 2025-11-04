pageextension 50001 "50001_ItemCard" extends "Item Card"
{

    layout
    {
        modify(Inventory)
        {
            ToolTip = 'Specifies total units we have on hand including both good and bad inventories.';
            Caption = 'Finished Goods Qty';
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
            field("Template Applied"; Rec.TemplateApplied)
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
        addafter(VariantMandatoryDefaultYes)
        {
            field("Expiration Date Mandatory"; Rec."Expiration Date Mandatory")
            {
                ApplicationArea = All;
            }
        }

        addafter(Inventory)
        {
            field("Qty on Transfer Orders"; Rec."Orig Qty on TO" - Rec."Qty on TO Received")
            {
                ApplicationArea = all;
                DecimalPlaces = 0;
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
            field("Net Available"; Rec.GetNetAvailable())
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
        }
        addafter("Tariff No.")
        {
            field("Tariff Description"; Rec."Tariff Description")
            {
                ApplicationArea = All;
            }
            field("Duty Percent"; Rec."Duty Percent")
            {
                ApplicationArea = All;
            }
            field("Tariff Percent"; Rec."Tariff Percent")
            {
                ApplicationArea = All;
            }
        }

        addafter("Last Date Modified")
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
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
            field("Monday.com URL"; Rec."Monday.com URL")
            {
                ApplicationArea = All;
            }
            field("Monday.com BoardID"; Rec."Monday.com BoardID")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("Monday.com ItemID"; Rec."Monday.com ItemID")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("Monday.com PO ItemID"; Rec."Monday.com PO ItemID")
            {
                ApplicationArea = All;
            }


        }


    }
    actions
    {
        addafter("Item Tracing")
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
        addafter(RequestApproval)
        {
            // pr 6/14/24 added button to search items by customer
            action(SearchByCustomer)
            {
                ApplicationArea = all;
                Caption = 'Search By Customer';
                Image = CheckList;
                RunObject = Page CustomerSearch;
            }
        }
        addafter("Item/Vendor Catalog")
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
                begin
                    item.reset;
                    item.SetRange("No.", rec."No.");
                    if (item.FindSet()) then begin
                        Clear(ItemImageReport);
                        ItemImageReport.SetTableView(item);
                        ItemImageReport.Run();
                    end;
                end;

            }
        }
    }
    var
        noTemplateErrorTxt: Label 'You MUST apply a Template.';
        isNew: Boolean;
        UserSetup: Record "User Setup";
        txtNotAdminMod: Label 'You are not allowed to modify items as you are not marked as Item Admin in User Setup. Please contact your system administrator.';
        txtNotAdminAdd: Label 'You are not allowed to add items as you are not marked as Item Admin in User Setup. Please contact your system administrator.';
        txtNotAdminDel: Label 'You are not allowed to delete items as you are not marked as Item Admin in User Setup. Please contact your system administrator.';




    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if UserSetup."Item Admin" = false then begin
            Error(txtNotAdminAdd);
        end;
        Rec."User ID" := UserId;
        isNew := true;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if UserSetup."Item Admin" = false then begin
            Error(txtNotAdminDel);
        end;
        isNew := false;
    end;

    trigger OnOpenPage()

    begin
        isNew := false;
        UserSetup.Get(UserId);

    end;

    trigger OnModifyRecord(): Boolean
    begin
        if UserSetup."Item Admin" = false then begin
            Error(txtNotAdminMod);
        end;
        Rec."User ID" := UserId;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if ((rec.TemplateApplied = false) and (isNew = true)) then begin
            error(noTemplateErrorTxt);
        end;

    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Orig Qty on TO", "Qty on TO Received");
    end;

    procedure GetUserNameFromSecurityId(UserSecurityID: Guid): Code[50]
    var
        User: Record User;
    begin
        IF User.Get(UserSecurityID) then
            exit(User."User Name");
    end;

}