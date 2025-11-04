page 50062 SalesSupport
{
    ApplicationArea = All;
    Caption = 'Sales Support';
    PageType = List;
    SourceTable = SalesSupport;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {

                }
            }
        }
    }
}
