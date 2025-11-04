page 50100 "Sales Documents API"
{
    PageType = API;
    Caption = 'Sales Documents';
    APIPublisher = 'AshtelCustom';
    APIGroup = 'sales';
    APIVersion = 'v1.0';
    EntityName = 'salesDocument';
    EntitySetName = 'salesDocuments';

    SourceTable = "Sales Invoice Header";
    InsertAllowed = false; // API pages should not allow insertions
    DelayedInsert = false;   //explicitly disabled to ensure data consistency in API responses

    layout
    {
        area(content)
        {
            field(documentNo; Rec."No.")
            {
                Caption = 'Document No.';
                ToolTip = 'Specifies the unique identifier for the sales document.';
            }

            field(systemId; Rec.SystemId)
            {
                Caption = 'SystemId';
            }
            field(postingDate; Rec."Posting Date")
            {
                Caption = 'Posting Date';
            }
            field(customerNo; Rec."Sell-to Customer No.")
            {
                Caption = 'Customer No.';
            }
        }
    }
}
