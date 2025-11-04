page 50059 FTPServerExportSelect
{
    ApplicationArea = All;
    Caption = 'FTPServerExportSelect';
    PageType = List;
    SourceTable = FTPServer;
    UsageCategory = None;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Server Name"; Rec."Server Name")
                {
                    ToolTip = 'Specifies the value of the Server Name field.', Comment = '%';
                }

            }
        }

    }


    procedure GetSelectedName() selectedName: text
    begin

        selectedName := rec."Server Name";


    end;

    var
        selectedFtpServer: Record FTPServer;
}
