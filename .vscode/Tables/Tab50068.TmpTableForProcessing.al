table 50068 TmpTableForProcessing
{
    Caption = 'TmpTableForProcessing';
    DataClassification = CustomerContent;

    fields
    {
        field(1; ExternalDocumentNo; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(2; DocumentNo; Code[35])
        {
            Caption = 'Document No.';
        }
        field(3; Decimal1; Decimal)
        {
            Caption = 'Decimal1';
            DecimalPlaces = 0 : 5;
        }
        field(4; Decimal2; Decimal)
        {
            Caption = 'Decimal2';
            DecimalPlaces = 0 : 5;
        }
    }
    keys
    {
        key(PK; DocumentNo, ExternalDocumentNo)
        {
            Clustered = true;
        }
    }
}
