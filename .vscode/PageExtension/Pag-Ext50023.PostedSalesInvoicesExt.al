pageextension 50023 PostedSalesInvoicesExt extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Due Date")
        {
            field("Order Reference"; Rec."Order Reference")
            {
                ApplicationArea = All;
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
            }
            field(Internal; Rec.Internal)
            {
                ApplicationArea = All;
            }

        }
        addafter("Location Code")
        {
            field("Order Notes"; Rec."Order Notes")
            {
                ApplicationArea = All;

            }
        }
        addafter("Sell-to Customer Name")
        {
            //PR 3/17/25 - start
            field("Customer Salesperson Code"; Rec."Customer Salesperson Code")
            {
                ApplicationArea = All;
            }
            //PR 3/17/35 - end
            // 8/7/25 - start
            field("Ship-to County"; Rec."Ship-to County")
            {
                Caption = 'Ship-to State';
                ApplicationArea = All;
            }

            //8/7/25 - end
        }



    }


    actions
    {
        addfirst(processing)
        {
            //mbr 9/9/24 - Broker Sales Report - start
            action("Broker Sales Invoice Report")
            {
                ApplicationArea = all;
                Image = Sales;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()

                var
                    PSI: Record "Sales Invoice Header";
                    RptBrokerSales: report BrokerSalesReport;
                begin

                    If rec.Count >= 1 then begin
                        CLEAR(RptBrokerSales);
                        CurrPage.SetSelectionFilter(PSI);
                        if PSI.findset then begin
                            RptBrokerSales.SetTableView(PSI);
                            RptBrokerSales.RunModal();
                        end;

                    end;



                end;
            }
            ////mbr 9/9/24 - Broker Sales Report - end
        }
    }

    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Customer Salesperson Code");
    end;


}
