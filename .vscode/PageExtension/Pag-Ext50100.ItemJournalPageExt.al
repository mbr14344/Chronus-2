pageextension 50100 ItemJournalPageExt extends "Item Journal"
{
    layout
    {
        addafter("Item No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Caption = 'Line No.';
            }
        }
        addlast(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Item Journal Line"),
                               "Line No." = field("Line No.");
            }
        }
    }
}
