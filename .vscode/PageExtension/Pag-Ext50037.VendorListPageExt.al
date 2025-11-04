pageextension 50037 VendorListPageExt extends "Vendor List"
{
    layout
    {
        addbefore("Post Code")
        {
            field(Address; Rec.Address)
            {
                ApplicationArea = All;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = All;
            }
            field(City; Rec.City)
            {
                ApplicationArea = All;
            }
            field(County; Rec.County)
            {
                ApplicationArea = All;
            }
        }


    }

    actions
    {
        addafter(Quotes)
        {
            action(POPaymentDashboard)
            {
                ApplicationArea = all;
                Caption = 'PO Payment Balance Dashboard';
                Image = Balance;
                RunObject = Page "PO Payment Balance Dashboard";
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
