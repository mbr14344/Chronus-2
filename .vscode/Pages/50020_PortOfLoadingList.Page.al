page 50020 "Port of Loading List"
{
    ApplicationArea = All;
    Caption = 'Ports of Loading/Discharge';
    PageType = List;
    SourceTable = "Port of Loading";
    UsageCategory = Tasks;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Port"; Rec.Port)
                {
                    ToolTip = 'Specifies the Port of Loading/Discharge';
                    ApplicationArea = All;

                }

            }
        }
    }

}
