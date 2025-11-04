page 50131 "Purchase Quote Sheet"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Purchase Quote Sheet';
    SourceTable = "QuoteSheet";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Project Name"; Rec."Project Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Project Name field.';
                }
                field("Version No."; Rec."Version No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Version No. field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    TableRelation = Customer;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }

                field("China Comment"; Rec."China Comment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the China Comment field.';
                }
                field("Material & Item Spec"; Rec."Material & Item Spec")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Material & Item Spec field.';
                }
                field("UNIT SPEC"; Rec."UNIT SPEC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UNIT SPEC field.';
                }
                field("Inner Pack"; Rec."Inner Pack")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inner Pack field.';
                }
                field("Master Pack"; Rec."Master Pack")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Master Pack field.';
                }

                field("Item H (Inch)"; Rec."Item H (Inch)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item H (Inch) field.';
                    DecimalPlaces = 2;
                }
                field("Item W (Inch)"; Rec."Item W (Inch)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item W (Inch) field.';
                    DecimalPlaces = 2;
                }
                field("Item L (Inch)"; Rec."Item L (Inch)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item L (Inch) field.';
                    DecimalPlaces = 2;
                }
                field("Net Weight (Gram)"; Rec."Net Weight (Gram)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Net Weight (Gram) field.';
                    DecimalPlaces = 2;
                }
                field("Gross Weight (Gram)"; Rec."Gross Weight (Gram)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gross Weight (Gram) field.';
                    DecimalPlaces = 2;
                }
                field("Carton L (Inch)"; Rec."Carton L (Inch)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Carton L (Inch) field.';
                    DecimalPlaces = 2;
                }
                field("Carton W (Inch)"; Rec."Carton W (Inch)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Carton W (Inch) field.';
                    DecimalPlaces = 2;
                }
                field("Carton H (Inch)"; Rec."Carton H (Inch)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Carton H (Inch) field.';
                    DecimalPlaces = 2;
                }
                field(Cube; Rec.Cube)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cube field.';
                    DecimalPlaces = 3;
                    Editable = false;
                    Style = StrongAccent;
                }
                field("USA lbs. Weight"; Rec."USA lbs. Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the USA lbs. Weight field.';
                    DecimalPlaces = 2;
                }
                field("Factory FOB Cost ($)"; Rec."Factory FOB Cost ($)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Factory FOB Cost ($) field.';
                }
                field("FOB Cost ($)"; Rec."FOB Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FOB Cost field.';
                }
                field(Factory; Rec.Factory)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Factory field.';
                }
                field("Loading Port"; Rec."Loading Port")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loading Port field.';
                }
                field(HTM; Rec.HTN)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HTM field.';
                }
                field("Duty Rate %"; Rec."Duty Rate %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Duty Rate % field.';
                    DecimalPlaces = 2;
                }
                field("Container Type"; Rec."Container Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container Type field.';
                }
                field("Freight Rate ($)"; Rec."Freight Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Freight Rate field.';
                }
                field("Estimated Landed Cost"; Rec."Estimated Landed Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Estimated Landed Cost field.';
                    Style = StrongAccent;
                }
                field("Domestic Sell Price"; Rec."Domestic Sell Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Domestic Sell Price field.';
                }
                field("Domestic Margin %"; Rec."Domestic Margin %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Domestic Margin % field.';
                    Style = StrongAccent;
                    Editable = false;
                }
                field(Retail; Rec.Retail)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Retail field.';
                }
                field("Customer Margin %"; Rec."Customer Margin %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Margin % field.';
                    Style = StrongAccent;
                    Editable = false;
                }
                field("Special Instructions"; Rec."Special Instructions")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Special Instructions field.';
                }
                field("Product Spec"; Rec."Product Spec")
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; GenCU.GetUserNameFromSecurityId(Rec.SystemCreatedBy))
                {
                    ApplicationArea = All;
                    Caption = 'Created By';
                    Editable = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                }

            }
        }
        area(FactBoxes)
        {
            part(ItemPicture; QuoteSheetImageFactBox)
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "Project Name" = field("Project Name"), "Version No." = field("Version No.");
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(Report)
            {
                ApplicationArea = All;
                Caption = 'Report';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Print the Purchase Quote Sheet report.';
                RunObject = Report PurchaseQuoteSheetReport;

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.CalcVals();
    end;

    var
        GenCU: Codeunit GeneralCU;
}
