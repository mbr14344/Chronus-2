table 50067 "PurchLine Monday Update Audit"
{
    Caption = 'PurchLine Monday Update Audit';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = Item."No.";
        }

        field(2; "Monday.com ItemID"; Text[250])
        {
            Caption = 'Monday.com Pulse ID';
        }
        field(3; "Monday.com BoardID"; Text[250])
        {
            Caption = 'Monday.com Board ID';
        }

        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Purchase Header"."No.";
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; ValueJsonStr; Text[250])
        {
            Caption = 'Notes Value';
        }
        field(7; "Changed By User ID"; Text[250])
        {
            Caption = 'Changed By User ID';
        }
        field(8; "Changed On"; Date)
        {
            Caption = 'Changed On';
        }
        field(9; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(10; ColumnID; Text[250])
        {
            Caption = 'Column ID';
            Description = 'The Monday.com Column ID that was updated.';
        }
        field(11; Result; Boolean)
        {
            Caption = 'Success';
            Description = 'Indicates if the update to Monday.com was successful.';
        }
    }
    keys
    {
        key(PK; "No.", "Line No.", "Entry No.")
        {
            Clustered = true;
        }
    }

}
