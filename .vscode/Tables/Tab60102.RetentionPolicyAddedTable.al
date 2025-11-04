table 60102 RetentionPolicyAddedTable
{
    Caption = 'RetentionPolicyAddedTable';
    fields
    {
        field(1; TblID; Integer)
        {
            Caption = 'Table ID';
        }
        field(2; TableName; Code[50])
        {
            Caption = 'Table Name';
        }
    }
    keys
    {
        key(PK; TblID)
        {
            Clustered = true;
        }
    }
}
