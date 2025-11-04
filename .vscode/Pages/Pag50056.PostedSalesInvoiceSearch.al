page 50056 PostedSalesInvoiceSearch
{
    ApplicationArea = All;
    Caption = 'Search by Item License';
    SourceTable = ItemLicense;
    PageType = NavigatePage;
    //SourceTable = Customer;
    SourceTableTemporary = true;
    UsageCategory = Administration;
    //ModifyAllowed = false;
    //  InsertAllowed = true;
    // DeleteAllowed = false;
    ShowFilter = false;

    layout
    {

        area(Content)
        {

            group(General)
            {

                field(License; licenseStr)
                {

                    ApplicationArea = all;
                    TableRelation = LicenseOwner.License;
                    trigger OnValidate()
                    begin
                        subLicenseStr := '';
                    end;
                }
                field(SubLicense; subLicenseStr)
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        subLicensePage: Page SubLicenseList;
                        subLicense: Record SubLicenseHeader;
                    begin
                        subLicense.Reset();
                        subLicense.SETFILTER(License, licenseStr);
                        if (subLicense.FindSet()) then begin
                            subLicensePage.SetRecord(subLicense);
                            subLicensePage.SetTableView(subLicense);
                            if subLicensePage.RunModal() = ACTION::OK then begin
                                subLicensePage.GetRecord(subLicense);
                                // surrounds subLisence in ' ' if it contains special chars & or '
                                if ((StrPos(subLicense.Sublicense, '&') > 0)) then begin
                                    subLicenseStr += '|''' + format(subLicense.Sublicense) + '''';
                                end
                                else
                                    subLicenseStr += '|' + format(subLicense.Sublicense);
                                subLicenseStr := subLicenseStr.TrimStart('|');
                                subLicensePage.Close();
                            end;
                        end;
                    end;
                    //  TableRelation = SubLicenseHeader.SubLicense;
                    // TableRelation = SubLicenseHeader.SubLicense where(License = field(License));
                }

            }
        }
    }
    actions
    {

        area(Processing)
        {
            action(Search)
            {
                ApplicationArea = all;
                Caption = 'Search Now';
                Image = Navigate;
                InFooterBar = true;

                trigger OnAction()
                begin

                    SearchItemLicense();

                    if (StrLen(itemSearchStr) > 0) then begin
                        CurrPage.Close();
                    end
                    else begin
                        Message('No items were found');
                    end;

                end;
            }

        }
    }
    // pr 12/27/24 searches item license for entries with a certain license and sub licesne
    // and then builds builds a string that is a collection of Item No.'s seperated by '|'
    local procedure SearchItemLicense()
    begin
        // customerNo := Rec."No.";
        itemSearchStr := '';
        subLicenseStr := subLicenseStr.TrimStart('|');
        itemLicense.Reset();
        itemLicense.SetFilter(License, licenseStr);
        itemLicense.SetFilter("Sublicense", subLicenseStr);

        if (itemLicense.FindSet()) then
            repeat
                itemSearchStr += itemLicense."Item No." + '|';
            until itemLicense.Next() = 0;
        itemSearchStr := itemSearchStr.TrimEnd('|');
        itemSearchStr := itemSearchStr.TrimStart('|');
        itemSearchStr := itemSearchStr.Trim();

    end;

    procedure GetSublicenseStr(): Text
    begin
        exit(subLicenseStr);
    end;

    procedure GetLicenseStr(): Text
    begin
        exit(licenseStr);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if strlen(licenseStr) > 0 then begin
            rec := itemLicense;
        end;


    end;

    trigger OnOpenPage()
    begin
        // rec.DeleteAll();
        // rec.Init();
        //  rec.Insert();

    end;

    var
        itemLicense: Record ItemLicense;
        licenseStr: Text;
        subLicenseStr: Text;
        itemList: Record "Sales Invoice Line";
        itemSearchStr: Text;
        serchItemsPage: Page "Posted Sales Invoice Lines";
        itemLicRef: Record ItemLicense temporary;
        subLicenRef: Record SubLicenseHeader;


}
