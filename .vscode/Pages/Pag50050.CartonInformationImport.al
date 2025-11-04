page 50050 "Carton Information Import"
{
    ApplicationArea = All;
    Caption = 'Carton Information Import';
    PageType = List;
    SourceTable = CartonInformationImport;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("From Entry No."; Rec."From Entry No.")
                {
                    ToolTip = 'Specifies the value of the From Entry No. field.', Comment = '%';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer No. field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("DocumentLine No."; Rec."DocumentLine No.")
                {
                    ToolTip = 'Specifies the value of the DocumentLine No. field.', Comment = '%';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
                }


                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }

                field("Serial No."; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the value of the SCC No. field.', Comment = '%';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.', Comment = '%';
                }
                field(ImportedPackagedQuantity; Rec.ImportedPackagedQuantity)
                {
                    ToolTip = 'Specifies the value of the Imported Packaged Quantity field.', Comment = '%';
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
