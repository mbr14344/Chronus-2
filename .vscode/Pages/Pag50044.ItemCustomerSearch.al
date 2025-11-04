page 50044 ItemCustomerSearch
{
    // pr 6/13/24 added page to show items attached to sales price 
    // that is also assocaited with a specific customer No
    ApplicationArea = All;
    Caption = 'Customer Item Search';

    PageType = NavigatePage;

    SourceTable = Customer;
    ShowFilter = false;

    layout
    {
        area(Content)
        {
            group(General)
            {

                field("Customer No."; customerNo)
                {
                    ApplicationArea = all;

                    TableRelation = Customer."No.";
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
                    SearchSalesPrice();
                    if (StrLen(itemSearchStr) > 0) then begin
                        /*itemList.Reset();
                        itemList.SetFilter("No.", itemSearchStr);
                        itemList.FindSet();
                        serchItemsPage.SetRecord(itemList);
                        serchItemsPage.SetTableView(itemList);*/
                        //serchItemsPage.Run();
                        CurrPage.Close();
                    end
                    else begin
                        Message('No items were found');
                    end;

                end;
            }

        }
    }

    // pr 6/14/24 searches slaes prices for entries with a certain "Customer No."
    // and then builds builds a string that is a collection of Item No.'s seperated by '|'
    local procedure SearchSalesPrice()
    begin
        // customerNo := Rec."No.";
        itemSearchStr := '';
        salesPrice.Reset();
        salesPrice.SetRange("Sales Code", customerNo);
        salesPrice.SetRange("Sales Type", salesPrice."Sales Type"::Customer);

        if (salesPrice.FindSet()) then
            repeat
                itemSearchStr += salesPrice."Item No." + '|';
            until salesPrice.Next() = 0;
        itemSearchStr := itemSearchStr.TrimEnd('|');
        itemSearchStr := itemSearchStr.TrimStart('|');
        itemSearchStr := itemSearchStr.Trim();


    end;

    var
        salesPrice: Record "Sales Price";
        itemList: Record Item;
        itemSearchStr: Text;
        customerNo: code[20];
        serchItemsPage: Page "Item List";




    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if strlen(customerNo) > 0 then begin
            Rec.SetRange("No.", customerNo);
            if Rec.FindFirst() then;

        end;
    end;

    trigger OnClosePage()
    begin


    end;
}

