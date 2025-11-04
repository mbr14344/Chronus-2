pageextension 50034 PostedSalesInvoiceLinesPageExt extends "Posted Sales Invoice Lines"
{
    layout
    {
        addafter("No.")
        {
            field("Item Reference No."; Rec."Item Reference No.")
            {
                ApplicationArea = All;
            }
            field("License Exist"; Rec."License Exist")
            {
                ApplicationArea = all;
                Visible = true;
            }

        }
        addafter("Document No.")
        {
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = All;
            }
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Sell-to Customer No.")
        {
            field("Customer Salesperson Code"; Rec."Customer Salesperson Code")
            {
                ApplicationArea = All;
            }
            field("Order No. Cust"; Rec."Order No.")
            {
                Caption = 'Order No.';
                ApplicationArea = All;
            }
            Field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = All;
            }
            field("Order Reference"; Rec."Order Reference")
            {

                ApplicationArea = All;
            }
            //8/7/25 - start

            field("Ship-to County"; Rec."Ship-to County")
            {
                ApplicationArea = All;
            }

            //8/7/25 - end



        }
        addafter("Unit of Measure Code")
        {
            field("M-Pack Qty"; Rec."M-Pack Qty")
            {
                ApplicationArea = all;
                Enabled = false;
                DecimalPlaces = 0;
            }
            field("Package Count"; PackageCount)
            {
                ApplicationArea = all;
                Enabled = false;
                DecimalPlaces = 1;

            }
            field("EDI Inv Line Discount"; Rec."EDI Inv Line Discount")
            {
                ApplicationArea = All;
            }
            field("SPS EDI Unit Price"; Rec."SPS EDI Unit Price")
            {
                ApplicationArea = All;
            }
            field(ediUnitPriceSPSVis; Rec.GetEdiUnitPriceSPS())
            {
                Caption = 'EDI Unit Price SPS';
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = ALL;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = ALL;
            }
            field(ItemNotes; Rec.ItemNotes)
            {
                ApplicationArea = All;
            }

        }



    }

    actions
    {
        addafter("Item &Tracking Lines")
        {
            //PR 12/27/24 - Add Search By Item License button - start
            action(SearchByCustomer)
            {
                ApplicationArea = all;
                Caption = 'Search By Item License';
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    //PgItemCustSearch: Page ItemCustomerSearch;
                    getStr: Text;

                begin
                    itemLicense.Reset();
                    CLEAR(PgItemLicenseSearch);
                    PgItemLicenseSearch.SetTableView(itemLicense);
                    PgItemLicenseSearch.SetRecord(itemLicense);
                    if PgItemLicenseSearch.RunModal() = ACTION::OK then begin

                        searchesMade := 0;
                        PgItemLicenseSearch.GetRecord(itemLicense);
                        itemLicenseToSearch := PgItemLicenseSearch.GetLicenseStr();
                        itemSubLicenseToSearch := PgItemLicenseSearch.GetSublicenseStr();
                        SearchSalesPrice();
                        PgItemLicenseSearch.Close();

                    end;




                end;

            }
            //PR 12/27/24 - Add Search By Item License button - end
        }
    }
    local procedure SearchSalesPrice()
    begin
        If (itemLicenseToSearch <> '') then begin
            itemLicenseSearchStr := '';
            itemLicense2.Reset();
            itemLicense2.SetFilter(License, itemLicenseToSearch);
            itemLicense2.SetFilter("Sublicense", itemSubLicenseToSearch);

            if (itemLicense2.FindSet()) then begin

                tempItemLicenseSearchStr := itemLicenseSearchStr;

                isSearchingForLicense := true;
                repeat
                    itemLicenseSearchStr += itemLicense2."Item No." + '|';
                until itemLicense2.Next() = 0;
                itemLicenseSearchStr := itemLicenseSearchStr.TrimEnd('|');
                itemLicenseSearchStr := itemLicenseSearchStr.TrimStart('|');
                itemLicenseSearchStr := itemLicenseSearchStr.Trim();


                // notifys user that items were found 
                notificationSearch.Message('Searching for : License of ' + itemLicenseToSearch + ' and a SubLicense of ' + itemSubLicenseToSearch);
                notificationSearch.Scope(NotificationScope::LocalScope);
                notificationSearch.Send();
                // filters table for customer specifc items
                Rec.Reset();
                Rec.SetFilter("No.", itemLicenseSearchStr);


            end
            // if no items were found
            else begin
                //isSearchingForCust := false;
                Rec.Reset();
                Rec.SetFilter("No.", '');
                // notificationSearch.Recall();
            end;
        end;




    end;

    var
        notificationSearch: Notification;
        itemLicenseSearchStr: Text;
        tempItemLicenseSearchStr: Text;
        myInt: Integer;
        PackageCount: Decimal;
        Item: Record Item;

        isSearchingForLicense: Boolean;
        PgItemLicenseSearch: Page PostedSalesInvoiceSearch;
        itemLicense: Record ItemLicense;
        searchesMade: Integer;
        itemLicenseToSearch: code[20];
        itemSubLicenseToSearch: text;
        itemLicense2: Record ItemLicense;
        postesSalesInvLine: Record "Sales Invoice Line";

    procedure UpdatePackageCnt()
    begin
        If Rec.Type = Rec.Type::Item then begin
            If Item.Get(Rec."No.") then
                if Item.Type = Item.Type::Inventory then begin
                    Rec.CalcFields("M-Pack Qty");
                    PackageCount := 0;
                    IF Rec."M-Pack Qty" > 0 then
                        PackageCount := Rec."Quantity (Base)" / Rec."M-Pack Qty";

                end;
        end;



    end;

    trigger OnAfterGetRecord()
    begin
        UpdatePackageCnt();

        rec.CalcFields("Customer Salesperson Code");
    end;
}
