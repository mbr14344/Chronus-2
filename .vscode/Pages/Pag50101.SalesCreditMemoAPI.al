page 50101 "Sales Credit Memo API"
{
    PageType = API;
    Caption = 'Sales Credit Memos';
    APIPublisher = 'AshtelCustom';
    APIGroup = 'sales';
    APIVersion = 'v1.0';
    EntityName = 'salesCreditMemo';
    EntitySetName = 'salesCreditMemos';

    SourceTable = "Sales Cr.Memo Header";
    InsertAllowed = false; // API pages should not allow insertions
    DelayedInsert = false;   //explicitly disabled to ensure data consistency in API responses

    layout
    {
        area(content)
        {
            field(No; Rec."No.")
            {
                Caption = 'Document No.';
            }
            field(SystemId; Rec.SystemId)
            {
                Caption = 'SystemId';
            }
            field(Posting_Date; Rec."Posting Date")
            {
                Caption = 'Posting Date';
            }
            field(Customer_No; Rec."Sell-to Customer No.")
            {
                Caption = 'Customer No.';
            }
        }
    }
}
