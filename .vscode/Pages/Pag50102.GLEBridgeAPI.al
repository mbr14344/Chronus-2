page 50102 "GLE Bridge API"
{
    PageType = API;
    Caption = 'GLE Bridge API';
    SourceTable = "G/L Entry";
    APIPublisher = 'AshtelCustom';
    APIGroup = 'sales';
    APIVersion = 'v1.0';
    EntityName = 'gleBridgeEntry';
    EntitySetName = 'gleBridgeEntries';

    ODataKeyFields = SystemId;     // <- use GUID key
    InsertAllowed = false; // API pages should not allow insertions
    DelayedInsert = false;   //explicitly disabled to ensure data consistency in API responses

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { Caption = 'Id'; Editable = false; }
                field(entryNo; Rec."Entry No.") { Caption = 'Entry No.'; Editable = false; }
                field(documentNo; Rec."Document No.") { Caption = 'Document No.'; Editable = false; }
                field(documentType; Rec."Document Type") { Caption = 'Document Type'; Editable = false; }
            }
        }
    }
}
