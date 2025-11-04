pageextension 50000 "50000_ItemUnitsMeasurePageExt" extends "Item Units of Measure"
{
    layout
    {
        addafter("Item No.")
        {
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = All;
            }
        }
        addafter("Qty. per Unit of Measure")
        {
            field(Ti; Rec.Ti)
            {
                ApplicationArea = All;
                StyleExpr = StyleName;
            }
            field(Hi; Rec.Hi)
            {
                ApplicationArea = All;
                StyleExpr = StyleName;
            }
            field(UPCCode; Rec.UPCCode)
            {
                ApplicationArea = All;
            }
            field(Notes; Rec.Notes)
            {
                ApplicationArea = All;
            }
        }
        addafter(Weight)
        {
            field("Weight kgs"; Rec."Weight kgs")
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnPageBackgroundTaskCompleted(TaskId: Integer; Results: Dictionary of [Text, Text])
    begin
        CurrPage.Update();
    end;
}
