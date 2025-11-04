tableextension 50073 ItemJournalLineExt extends "Item Journal Line"
{
    fields
    {
        // Cannot use triggers in table extensions for existing fields.
        // Move validation logic to a subscriber in a codeunit.
        modify("Line No.")
        {
            trigger OnAfterValidate()
            begin
                Message(format(xrec."Line No.") + ' has been validated.');
            end;
        }
    }
    trigger OnBeforeInsert()
    var
        documentAttachment: Record "Document Attachment";
        documentAttachmentNew: Record "Document Attachment"; // Added declaration
    begin
        documentAttachment.Reset();
        documentAttachment.SetRange("Table ID", Database::"Item Journal Line");
        documentAttachment.SetRange("Line No.", 0);
        if (documentAttachment.FindSet()) then
            repeat
                //copy attachments to item ledger entry
                documentAttachmentNew.Init();
                documentAttachmentNew.Copy(documentAttachment);
                documentAttachmentNew."Table ID" := Database::"Item Journal Line";
                documentAttachmentNew."Line No." := rec."Line No.";
                documentAttachmentNew.Insert(true);
            until documentAttachment.Next() = 0;
        documentAttachment.Reset();
        documentAttachment.SetRange("Table ID", Database::"Item Journal Line");
        documentAttachment.SetRange("Line No.", 0);
        if (documentAttachment.FindSet()) then
            repeat
                //copy attachments to item ledger entry
                documentAttachment.Delete();
            until documentAttachment.Next() = 0;


    end;

}
