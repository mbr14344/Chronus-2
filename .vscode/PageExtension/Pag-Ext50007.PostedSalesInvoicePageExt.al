pageextension 50007 "Posted Sales Invoice" extends "Posted Sales Invoice"
{
    //mbr 1/12/24 - add new fields
    layout
    {
        modify("Due Date")
        {
            Caption = 'Invoice Due Date';


        }

        addafter("External Document No.")
        {

            field("Split"; Rec.Split)
            {
                ApplicationArea = All;
            }

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
                ToolTip = 'Indicates if the invoice is in the month.';
            }
            field("Order Notes"; Rec."Order Notes")
            {
                ApplicationArea = All;
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
        addafter("Ship-to Code")
        {
            field(CustomerShipToCode; Rec.CustomerShipToCode)
            {
                ApplicationArea = All;
                Editable = false;
            }
            //PR 3/17/25 - start
            field("Customer Salesperson Code"; Rec."Customer Salesperson Code")
            {
                ApplicationArea = All;
            }
            //PR 3/17/35 - end
            field("Single BOL No."; Rec."Single BOL No.")
            {
                ApplicationArea = All;
                Editable = false;
                style = StrongAccent;
            }
            field("BOL Comment"; Rec."BOL Comments")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Freight Charge Terms"; Rec.FreightChargeTerm)
            {
                ApplicationArea = all;
                Editable = false;
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
                Editable = false;
            }
            field("Total Package Count"; Rec."Total Package Count")
            {
                ApplicationArea = All;
                Editable = false;
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

    }
    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Customer Salesperson Code");
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; Code: boolean)
    begin
    end;

}
