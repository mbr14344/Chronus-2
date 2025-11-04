pageextension 50050 CustomerListPageExt extends "Customer List"
{
    layout
    {
        modify("Salesperson Code")
        {
            Visible = true;
        }
        addafter("Salesperson Code")
        {
            field("Sales Support"; Rec."Sales Support")
            {
                ApplicationArea = all;

            }
            field("Responsibility Ctr"; Rec."Responsibility Center")
            {
                ApplicationArea = All;
                Visible = true;
            }
            field("EDI ASN Customer"; Rec."EDI ASN Customer")
            {
                ApplicationArea = All;
            }
            field(ShippingLabelStyle; Rec.ShippingLabelStyle)
            {
                ApplicationArea = All;
            }
            field(ShippingLabelReportName; Rec.ShippingLabelReportName)
            {
                ApplicationArea = All;
            }

        }
        modify("Responsibility Center")
        {
            Visible = false;
        }

        addbefore(SalesHistSelltoFactBox)
        {
            part(CustoemrContact; CustomerContactFactbox)
            {
                ApplicationArea = All;
                Caption = 'Contact List';
                SubPageLink = "Company Name" = field(Name), "Contact Business Relation" = const("Contact Business Relation"::Customer);
            }
        }
    }
    actions
    {
        addafter("Request Approval")
        {
            action(SearchByCustomer)
            {
                ApplicationArea = all;
                Caption = 'Search By Customer';
                Image = CheckList;
                RunObject = Page CustomerSearch;
                Promoted = true;
                PromotedCategory = Process;
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

}
