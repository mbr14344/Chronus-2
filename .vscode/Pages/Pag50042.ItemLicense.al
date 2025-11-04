page 50042 ItemLicense
{
    // pr 6/13/24 made item license page
    ApplicationArea = All;
    Caption = 'Item License';
    PageType = List;
    SourceTable = ItemLicense;
    UsageCategory = Lists;
    DataCaptionFields = "Item No.";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    LookupPageId = "Item Card";
                    trigger OnDrillDown()
                    var
                        itemPage: Page "Item Card";
                        item: Record item;
                    begin
                        item.Reset();
                        item.SetRange("No.", rec."Item No.");
                        if (item.FindFirst()) then begin
                            Clear(itemPage);
                            itemPage.SetRecord(item);
                            itemPage.Run();
                        end;

                    end;

                }

                field(License; Rec.License)
                {
                    ApplicationArea = all;
                }
                field("Sub-License"; Rec.Sublicense)
                {
                    ApplicationArea = all;
                }
                field("License Percentage"; Rec."License Percentage")
                {
                    ApplicationArea = All;
                }
                field("Exp Date"; Rec."Expiration Date")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                }
                field("Quantity on Hand"; Rec."Quantity on Hand")
                {
                    ApplicationArea = all;


                }
                field("Qty on Purchase Order"; Rec."Qty on Purchase Order")
                {
                    ApplicationArea = all;

                }
                field("Qty on Sales Order"; Rec."Qty on Sales Order")
                {
                    ApplicationArea = all;

                }
                field("Qty on Assembly Order"; Rec."Qty on Assembly Order")
                {
                    ApplicationArea = all;

                }
                field("Qty on Transfer Order"; Rec."Qty on Transfer Order")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Qty on Assembly Order", "Qty on Purchase Order", "Qty on Sales Order", "Qty on Transfer Order", "Quantity on Hand");
    end;
}
