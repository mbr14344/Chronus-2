table 50071 PurchQuoteType
{
    Caption = 'PurchQuoteType';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type"; Text[50])
        {
            Caption = 'Type';
        }
    }
    keys
    {
        key(PK; "Type")
        {
            Clustered = true;
        }
    }
}
