page 50030 PostedCartonInformation
{
    Caption = 'Posted Package Information';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = CartonInformation;

    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("SCC No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                field(LineCount; Rec.LineCount)
                {

                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field(PSSNo; Rec.PSSNo)
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("DocumentLine No."; Rec."DocumentLine No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = All;
                }
                field("Package Quantity"; Rec."Package Quantity")
                {
                    ApplicationArea = All;
                }
                field("Item Reserved Quantity"; Rec."Item Reserved Quantity")
                {
                    ApplicationArea = All;
                }

                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = All;
                }
                field(ImportedPackagedQuantity; Rec.ImportedPackagedQuantity)
                {
                    ApplicationArea = All;
                }
                field(Imported; Rec.Imported)
                {
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {

        }

    }



    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Document No.", "DocumentLine No.", LineCount);
        Rec.SetRange(Posted, true);
    end;


}
