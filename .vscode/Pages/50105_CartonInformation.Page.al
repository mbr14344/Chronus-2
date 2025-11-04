page 50105 CartonInformation
{
    Caption = 'Package Information';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = CartonInformation;

    // DeleteAllowed = false;
    // ModifyAllowed = false;
    //  InsertAllowed = false;
    SourceTableView = sorting(LineCount);

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("SCC No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(LineCount; Rec.LineCount)
                {

                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("DocumentLine No."; Rec."DocumentLine No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("M-Pack Qty"; Rec."M-Pack Qty")
                {
                    ApplicationArea = All;
                }
                field("Package Quantity"; Rec."Package Quantity")
                {
                    ToolTip = 'For EDI Use only';
                    ApplicationArea = All;
                }
                field("Item Reserved Quantity"; Rec."Item Reserved Quantity")
                {
                    ApplicationArea = All;
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = All;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = All;
                }
                field(ImportedPackagedQuantity; Rec.ImportedPackagedQuantity)
                {
                    ApplicationArea = All;
                }
                field(ShippingLabelStyle; Rec.ShippingLabelStyle)
                {
                    ApplicationArea = All;
                }
                field(LabelTranslation; Rec.LabelTranslation)
                {
                    ApplicationArea = All;
                }
                field(Imported; Rec.Imported)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }

    }
    actions
    {
        area(Processing)
        {
            action("Create New Pallet")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Add;

                trigger OnAction()
                var
                    AssignItemPage: Page AssignItemFromCartonInfo;
                    AssignItems: Record AssignItemsFromCartInfo temporary;
                    cartonInfoLast: Record CartonInformation;
                    SalesLine: Record "Sales Line";
                    lastLine: Integer;
                    newSSCC: code[20];
                    GenCU: Codeunit GeneralCU;
                    bFound: Boolean;
                    Item: Record Item;

                begin

                    SalesLine.Reset();
                    SalesLine.SetRange("Document No.", AssignedSalesHdr."No.");
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    AssignItems.Reset();
                    clear(AssignItemPage);
                    AssignItemPage.SetRecord(AssignItems);
                    AssignItemPage.SetTableView(AssignItems);
                    AssignItemPage.Initiate(rec, AssignedSalesHdr, true);
                    Commit();
                    AssignItemPage.RunModal();
                end;
            }
            action("Assign Items")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Edit;
                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                    AssignItemPage: Page AssignItemFromCartonInfo;
                    AssignItems: Record AssignItemsFromCartInfo temporary;
                    CartoonInfoToAssign: Record CartonInformation;
                begin
                    IF STRLEN(rec."Serial No.") = 0 then
                        Error('SSCC is BlANK. you cannot assign items.');

                    AssignItems.Reset();
                    clear(AssignItemPage);
                    AssignItemPage.SetRecord(AssignItems);
                    AssignItemPage.SetTableView(AssignItems);
                    AssignItemPage.Initiate(rec, AssignedSalesHdr, false);
                    AssignItemPage.RunModal();
                end;
            }
        }
    }

    var
        AssignedSalesHdr: Record "Sales Header";

    trigger OnOpenPage()
    var
        UserPermissions: Codeunit "User Permissions";
        User: Record User;
    begin
        Rec.SetCurrentKey(LineCount);
        Rec.SetRange(Posted, false);
        //MBR 3/21/25 - start
        User.Reset();
        User.SETRANGE("User Name", UserId);
        If User.FindFirst() then begin
            IF UserPermissions.IsSuper(User."User Security ID") then begin
                CurrPage.Editable := true;
            end
            else
                CurrPage.Editable := false;

        end
        else
            CurrPage.Editable := false;

        //MBR 3/21/25 - end

    end;

    procedure GetAssignedSalesOrder(salesHdr: Record "Sales Header")
    begin
        AssignedSalesHdr := salesHdr;
    end;


}
