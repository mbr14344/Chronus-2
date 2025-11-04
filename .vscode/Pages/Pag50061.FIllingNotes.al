page 50061 FillingNotes
{
    ApplicationArea = All;
    Caption = 'Filling Notes';
    PageType = List;
    SourceTable = FillingNotes;
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
