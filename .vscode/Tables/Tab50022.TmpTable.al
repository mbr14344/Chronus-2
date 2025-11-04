table 50022 TmpTable
{
    Caption = 'TmpTable';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; Code; Code[30])
        {
            Caption = 'Code';
        }
        field(3; DocumentNo; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; LineNo; Integer)
        {

        }
        field(5; Qty; Integer)
        {

        }
        field(6; "Address"; Text[100])
        {

        }
        field(7; "City"; Text[50])
        {

        }
        field(8; "State"; Text[50])
        {

        }
        field(9; "Name"; Text[100])
        {

        }
        field(10; "PostalCode"; Text[50])
        {

        }
        field(11; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
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
