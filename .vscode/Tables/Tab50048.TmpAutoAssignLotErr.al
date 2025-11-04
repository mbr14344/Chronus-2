table 50048 TmpAutoAssignLotErr
{
    Caption = 'TmpAutoAssignLotErr';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(2; ItemNo; Code[20])
        {
            Caption = 'Item No.';
        }
        field(3; LineNo; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Quantity';
        }
        field(5; UOM; Code[20])
        {
            Caption = 'UOM';
        }
        field(6; ErrorDescription; Text[250])
        {
            Caption = 'Error Description';
        }
    }
    keys
    {
        key(PK; "No.", ItemNo, LineNo)
        {
            Clustered = true;
        }
    }
}
