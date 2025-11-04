table 50023 TmpSalesLine
{
    Caption = 'TmpSalesLine';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; DocumentNo; Code[20])
        {
            Caption = 'DocumentNo';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(3; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(4; OrigQuantity; Decimal)
        {
            Caption = 'Original Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(5; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
        }
        field(6; "Loc1"; Code[20])
        {
            Caption = 'Loc1';
            Editable = false;
        }
        field(7; Loc1Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(8; "Loc2"; Code[20])
        {
            Caption = 'Loc2';
            Editable = false;
        }
        field(9; Loc2Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(10; "Loc3"; Code[20])
        {
            Caption = 'Loc3';
            Editable = false;
        }
        field(11; Loc3Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(12; "Loc4"; Code[20])
        {
            Caption = 'Loc4';
            Editable = false;
        }
        field(13; Loc4Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(14; "Loc5"; Code[20])
        {
            Caption = 'Loc5';
            Editable = false;
        }
        field(15; Loc5Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(16; EntryNo; Integer)
        {

        }
        field(17; LineNo; Integer)
        {
        }
    }
    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
    }
}
