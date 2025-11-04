pageextension 50056 PostedSalesInvoiceSubformExt extends "Posted Sales Invoice Subform"
{
    layout
    {

        addafter("Amount Including VAT")
        {
            field(ItemNotes; Rec.ItemNotes)
            {
                ApplicationArea = All;
            }
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
        }
        addbefore("Invoice Discount Amount")
        {
            field("Total Amount"; rec.CalculateGrossTotalsFromLine())
            {
                ApplicationArea = All;
                Caption = 'Total Amount';
            }
        }
    }
    var
        PackageCount: Decimal;
        Item: Record Item;

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
    end;

}
