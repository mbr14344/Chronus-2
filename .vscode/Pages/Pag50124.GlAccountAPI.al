page 50124 GlAccountAPI
{
    PageType = API;
    Caption = 'GL Account API';
    SourceTable = "G/L Account";
    APIPublisher = 'AshtelCustom';
    APIGroup = 'sales';
    APIVersion = 'v1.0';
    EntityName = 'glAccount';
    EntitySetName = 'glAccounts';

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
                field("accountNo"; Rec."No.") { Caption = 'No.'; Editable = false; }
                field("accountCategory"; Rec."Account Category") { Caption = 'Account Category'; Editable = false; }
                field("accountNo2"; Rec."No. 2") { Caption = 'No. 2'; Editable = false; }
                field("reverseSign"; Rec."Reverse Sign Power BI Custom") { Caption = 'Reverse Sign'; Editable = false; }
            }
        }
    }
}
