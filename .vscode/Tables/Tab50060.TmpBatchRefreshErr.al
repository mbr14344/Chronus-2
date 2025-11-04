table 50060 TmpBatchRefreshErr
{
    Caption = 'TmpBatchRefreshErr';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(2; CustNo; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(3; "Location Code"; code[20])
        {
        }
        field(4; ErrorDescription; Text[250])
        {
            Caption = 'Error Description';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}