page 50031 "Container Size"
{
    ApplicationArea = All;
    Caption = 'Container Size';
    PageType = List;
    SourceTable = "Container Size";
    UsageCategory = Tasks;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Container Size"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Container Size field.', Comment = '%';
                }
                field(CBM; Rec.CBM)
                {

                }
                field("Container Percentage Threshold"; Rec."Percentage Threshold")
                {

                }
            }
        }
    }
}
