table 50046 TOReceiptWarehouseHeader
{
    Caption = 'TOReceiptWarehouseHeader';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Transfer Order No."; Code[20])
        {
            Caption = 'Transfer Order No.';
        }
        field(2; "Container No."; Code[50])
        {
            Caption = 'Container No.';
        }
        field(3; "Received Date"; Date)
        {
            Caption = 'Received Date';
        }
        field(4; "Receipt No."; Code[20])
        {
            Caption = 'Receipt No.';
        }
        field(5; "Load No."; Code[20])
        {
            Caption = 'Load No.';
        }
        field(6; "Trailer No."; Code[20])
        {
            Caption = 'Trailer No.';
        }
        field(7; "Carrier No."; Code[20])
        {
            Caption = 'Carrier No.';
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
