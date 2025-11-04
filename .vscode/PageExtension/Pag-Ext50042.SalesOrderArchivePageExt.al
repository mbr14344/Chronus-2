pageextension 50042 SalesOrderArchivePageExt extends "Sales Order Archive"
{
    layout
    {
        addafter("No.")
        {
            field(Split; Rec.Split)
            {
                ApplicationArea = All;
            }

        }
        addafter(Status)
        {
            field(Internal; Rec.Internal)
            {
                ApplicationArea = All;
            }
            field(CreatedUserID; Rec.CreatedUserID)
            {
                ApplicationArea = All;
            }
            field(CreatedDate; Rec.CreatedDate)
            {
                ApplicationArea = All;
            }
        }
    }
}
