pageextension 50062 PurchaseInvoiceExtPage extends "Purchase Invoice"
{
    layout
    {
        addafter("Document Date")
        {
            field(Internal; Rec.Internal)
            {
                ApplicationArea = All;
            }
            field(CreatedUserID; Rec.CreatedUserID)
            {
                ApplicationArea = All;
            }
            field(CreatedDate; Rec.CreatedDate)
            {
                ApplicationArea = All;
            }
            field(VerifiedBy; Rec.VerifiedBy)
            {
                ApplicationArea = All;
            }
            field(VerifiedDate; Rec.VerifiedDate)
            {
                ApplicationArea = All;
            }

        }
    }
    actions
    {
        modify(CopyDocument)
        {
            trigger OnAfterAction()
            var
                purchaseLine: Record "Purchase Line";
                delpurchaseline: Record "Purchase Line";
            begin
                if (Rec."Document Type" = Rec."Document Type"::Invoice) or (Rec."Document Type" = Rec."Document Type"::"Credit Memo") then begin
                    purchaseLine.Reset();
                    purchaseLine.SetRange("Document No.", Rec."No.");
                    purchaseLine.SetRange("Document Type", Rec."Document Type");
                    purchaseLine.SetRange(Type, purchaseLine.Type::" ");
                    If purchaseLine.FindSet() then
                        repeat
                            if StrPos(purchaseLine.Description, 'Invoice No.') > 0 then begin
                                delpurchaseline.reset;
                                delpurchaseline.SetRange("Document No.", purchaseLine."Document No.");
                                delpurchaseline.SetRange("Document Type", purchaseLine."Document Type");
                                delpurchaseline.SetRange("Line No.", purchaseLine."Line No.");
                                delpurchaseline.SetRange(Type, delpurchaseline.Type::" ");
                                if delpurchaseline.FindFirst() then
                                    delpurchaseline.Delete();
                            end;
                        until purchaseLine.Next() = 0;
                end;

            end;
        }
    }
}
