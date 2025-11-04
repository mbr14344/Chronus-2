page 50120 CartonInformationImportLines
{
    //mbr 9/12/24 - list part to show packing information imported lines
    ApplicationArea = All;
    Caption = 'Packing Information Import Lines';
    PageType = ListPart;
    SourceTable = CartonInformationImport;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field("From Entry No."; Rec."From Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
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
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                }
                field(ImportedPackagedQuantity; Rec.ImportedPackagedQuantity)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = All;
                }
                field(ShippingLabelStyle; Rec.ShippingLabelStyle)
                {
                    ApplicationArea = All;
                }
                field(LabelTranslation; Rec.LabelTranslation)
                {
                    ApplicationArea = All;
                }


            }
        }
    }
}
