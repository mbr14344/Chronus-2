table 50052 "Item Sub Brand"
{
    Caption = 'Item Sub-Brand';
    DrillDownPageID = ItemSubBrand;
    LookupPageID = ItemSubBrand;
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
