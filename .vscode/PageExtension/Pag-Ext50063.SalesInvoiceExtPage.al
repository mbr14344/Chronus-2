pageextension 50063 SalesInvoiceExtPage extends "Sales Invoice"
{
    layout
    {
        addafter("Document Date")
        {
            field(Internal; Rec.Internal)
            {
                ApplicationArea = All;
            }

        }

    }
    // pr 8/14/24 
    actions
    {
        modify(CopyDocument)
        {
            trigger OnAfterAction()
            var
                salesLine: Record "Sales Line";
            begin
                salesLine.Reset();
                salesLine.SetRange("Document No.", rec."No.");
                salesLine.FindFirst();
            end;
        }
    }
    procedure setToFirst()
    begin

    end;


}
