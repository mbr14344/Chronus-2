table 50051 "Item Brand"
{
    Caption = 'Item Brand';
    DrillDownPageID = ItemBrand;
    LookupPageID = ItemBrand;
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Code"; code[30])
        {
            Caption = 'Code';
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
