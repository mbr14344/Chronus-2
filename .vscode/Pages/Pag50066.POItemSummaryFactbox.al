page 50066 POItemSummaryFactbox
{
    ApplicationArea = All;
    Caption = 'PO Item Summary Factbox';
    PageType = ListPart;
    SourceTable = "Purchase Line";
    SourceTableTemporary = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Caption = 'PO No.';
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Quantity; rec.Quantity)
                {
                    Caption = 'Qty';
                    ApplicationArea = all;
                }
                field("Unit of Measure"; rec."Unit of Measure")
                {
                    Caption = 'UOM';
                    ApplicationArea = all;
                }
            }

        }
    }
    var
        purchLinesSum: Record "Purchase Line" temporary;
        purchLines: Record "Purchase Line";
        purchLines2: Record "Purchase Line";
        item: Record Item;
        pruchHdr: Record "Purchase Header";
        totalQty: Decimal;
        count: Decimal;
        bSeen: Boolean;
        PONo: Code[20];

    trigger OnOpenPage()
    begin
        RefreshData(rec);
    end;

    procedure RefreshData(inPurchLine: Record "Purchase Line")
    begin

        purchLinesSum.DeleteAll();
        purchLinesSum.reset;
        pruchHdr.Reset();
        pruchHdr.SetRange("No.", inPurchLine."Document No.");
        //  pruchHdr.SetRange("Buy-from Vendor No.", inSalesHdr."Buy-from Vendor No.");
        pruchHdr.SetRange("Document Type", inPurchLine."Document Type");
        if (pruchHdr.FindFirst()) then begin
            rec.DeleteAll();
            rec.reset;
            count := 1;
            // groups purch lines by item and UOM
            purchLines.reset;
            purchLines.SetRange("Document No.", pruchHdr."No.");
            purchLines.SetRange("Buy-from Vendor No.", pruchHdr."Buy-from Vendor No.");
            purchLines.SetRange("Document Type", pruchHdr."Document Type");
            purchLines.SetRange(Type, purchLines.Type::Item);
            if (purchLines.FindSet()) then
                repeat
                    item.Reset;
                    item.SetRange("No.", purchLines."No.");
                    item.SetRange(Type, item.Type::Inventory);
                    if (item.FindFirst()) then begin
                        // groups items by item and UOM
                        rec.reset;
                        rec.SetRange("Document No.", pruchHdr."No.");
                        rec.SetRange("No.", purchLines."No.");
                        rec.SetRange("Unit of Measure", purchLines."Unit of Measure");
                        if (rec.FindFirst()) then begin
                            rec.Quantity += purchLines.Quantity;
                            rec.Modify();
                        end
                        else begin
                            count += 1;
                            rec.Init();
                            rec."Document No." := pruchHdr."No.";
                            rec."No." := purchLines."No.";
                            rec.Description := purchLines.Description;
                            rec."Unit of Measure" := purchLines."Unit of Measure";
                            rec.Quantity := purchLines.Quantity;
                            rec.Type := purchLines.Type;
                            rec."Line No." := count;
                            rec.Insert();
                        end;
                    end;
                until purchLines.Next() = 0;
        end;
        rec.reset;


    end;

    procedure SetPONo(InCode: code[20])
    var
        PurLines: Record "Purchase Line";
    begin
        PONo := InCode;
        PurLines.Reset();
        PurLines.SetRange("Document No.", PONo);
        PurLines.SetRange("Document Type", PurLines."Document Type"::Order);
        If PurLines.FindSet() then begin
            rec."Document No." := PONo;
            rec."Document Type" := PurLines."Document Type";
            rec."Buy-from Vendor No." := PurLines."Buy-from Vendor No.";
            RefreshData(PurLines);
            CurrPage.Update(false);
        end;
    end;
}
