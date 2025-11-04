pageextension 50028 PostedGeneralJournalPageExt extends "Posted General Journal"
{
    layout
    {
        addafter(Description)
        {
            field(Comment; Rec.Comment)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
