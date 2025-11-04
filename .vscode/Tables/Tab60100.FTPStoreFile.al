table 60100 FTPStoreFile
{
    Caption = 'FTPStoreFile';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "File Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; "File Content"; Blob)
        {
            DataClassification = CustomerContent;


        }
        field(4; "Document Type"; Enum FTPDocType)
        {
            Caption = 'Document Type';
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(6; CreatedDate; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(7; CreatedBy; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(8; RecordedDateTime; DateTime)
        {
            Caption = 'Recorded Date/Time';
            Editable = false;
        }
        field(9; FileType; Option)
        {
            Caption = 'File Type';
            OptionCaption = ' ,XML';
            OptionMembers = " ","XML";
        }
        field(10; Direction; Option)
        {
            Caption = 'Direction';
            OptionCaption = 'Export,Import';
            OptionMembers = "Export","Import";
        }
        field(11; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Transmitted,Imported,Error';
            OptionMembers = "Transmitted","Imported","Error";
        }
        field(12; Comments; Text[2048])
        {
            Caption = 'Comments';
            Editable = false;
        }
        field(13; CustomerNo; code[20])
        {
            Caption = 'Customer No.';

        }
        field(14; ExternalDocumentNo; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(15; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; CreatedDate)
        {
            Clustered = false;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
