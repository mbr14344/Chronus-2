table 50044
 ReceivingStatus
{
    Caption = 'ReceivingStatus';
    DataClassification = ToBeClassified;
    LookupPageId = ReceivingStatus;
    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
