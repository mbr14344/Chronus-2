table 50047 TOReceiptWarehouseLine
{
    Caption = 'TOReceiptWarehouseLine';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transfer Order No."; Code[20])
        {
            Caption = 'Transfer Order No.';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(3; "Expected Quantity"; Decimal)
        {
            Caption = 'Expected Quantity';
        }
        field(4; "Expected Case"; Integer)
        {
            Caption = 'Expected Case';
        }
        field(5; UOM; Code[20])
        {
            Caption = 'UOM';
        }
        field(6; "Received Good"; Decimal)
        {
            Caption = 'Received Good';
        }
        field(7; "Received Case"; Integer)
        {
            Caption = 'Received Case';
        }
        field(8; "Received Pallet"; Integer)
        {
            Caption = 'Received Pallet';
        }
        field(9; "Received Damage"; Decimal)
        {
            Caption = 'Received Damage';
        }
        field(10; "Received Over"; Decimal)
        {
            Caption = 'Received Over';
        }
        field(11; "Received Short"; Decimal)
        {
            Caption = 'Received Short';
        }
        field(12; Weight; Decimal)
        {
            Caption = 'Weight';
        }
    }
    keys
    {
        key(PK; "Transfer Order No.")
        {
            Clustered = true;
        }
    }
}
