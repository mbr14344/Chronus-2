table 50038 FTPServer
{
    Caption = 'FTPServer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Server Name"; Code[50])
        {
            Caption = 'Server Name';
        }
        field(2; Mode; Option)
        {
            Caption = 'Mode';
            DataClassification = CustomerContent;
            OptionCaption = ' ,IMPORT,EXPORT';
            OptionMembers = " ","IMPORT","EXPORT";
        }
        field(3; URL; Text[500])
        {
            Caption = 'URL';
        }
        /*   field(4; FacilityCode; Code[10])
           {
               Caption = 'Facility Code';
           }*/
        field(5; CustomerID; Code[10])
        {
            Caption = 'Customer ID';
        }
        //2/7/25 - receive 944 from Whitehorse - start
        field(6; "945 Package Info Prefix"; code[30])
        {

        }
        field(7; "944 Receipt Advice Prefix"; code[30])
        {

        }
        //2/7/25 - receive 944 from Whitehorse - end
        //9/24/25 - add new FLowURLs fields - start
        field(8; FlowAURL; Text[2048])
        {
            Caption = 'Flow A URL';
            trigger OnValidate()
            begin
                if (CopyStr(FlowAUrl, 1, 8) <> 'https://') and (FlowAUrl <> '') then
                    Error('Flow A URL must start with https://');
            end;

        }
        field(9; FlowBURL; Text[2048])
        {
            Caption = 'Flow B URL';
            trigger OnValidate()
            begin
                if (CopyStr(FlowBURL, 1, 8) <> 'https://') and (FlowBURL <> '') then
                    Error('Flow B URL must start with https://');
            end;

        }
        field(10; AckDeleteURL; Text[2048])
        {
            Caption = 'Ack Delete URL';
            trigger OnValidate()
            begin
                if (CopyStr(AckDeleteURL, 1, 8) <> 'https://') and (AckDeleteURL <> '') then
                    Error('Ack Delete URL must start with https://');
            end;
        }
        //9/24/25 - add new FLowURLs fields - end
    }
    keys
    {
        key(PK; "Server Name", Mode)
        {
            Clustered = true;
        }
    }
}
