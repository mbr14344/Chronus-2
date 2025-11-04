table 50059 TempItemUOMRec
{
    Caption = 'TempItemUOMRec';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Item No."; Code[20]) { }
        field(2; "Unit of Measure Code"; Code[10]) { }
    }
    keys
    {
        key(PK; "Item No.", "Unit of Measure Code") { }
    }
}
