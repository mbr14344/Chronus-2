table 50027 SelectIntoContainer
{
    Caption = 'SelectIntoContainer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; UserID; Code[50])
        {
            Caption = 'UserID';
        }
        field(2; DocumentNo; Code[20])
        {
            Caption = 'DocumentNo';
        }
        field(3; ItemNo; Code[20])
        {
            Caption = 'ItemNo';
        }
        field(4; LocationCode; Code[20])
        {
            Caption = 'LocationCode';
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(6; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
        }
        field(7; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(8; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
        }
        field(9; "Quantity Base"; Decimal)
        {
            Caption = 'Quantity Base';
        }
        field(10; DocumentLineNo; integer)
        {
            Caption = 'Document Line No.';
        }
        field(11; "Port of Discharge"; Code[20])
        {

        }
        field(12; "Port of Loading"; Code[20])
        {

        }
        field(13; "Container No."; Code[50])
        {

        }
        field(14; "Location Code"; Code[10])
        {
            Caption = 'Location Code';

        }
        field(15; DeliveryNotes; text[255])
        {
            Caption = 'Delivery Notes';
        }
        field(16; ActualCargoReadyDate; Date)
        {
            Caption = 'Actual Cargo Ready Date';
        }
        field(17; EstimatedInWarehouseDate; Date)
        {
            Caption = 'Estimated In-Warehouse Date';
        }
        field(18; RequestedInWhseDate; Date)
        {
            Caption = 'Requested In-Warehouse Date';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
