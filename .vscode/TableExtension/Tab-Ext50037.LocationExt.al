tableextension 50037 LocationExt extends Location
{
    fields
    {
        field(50000; "Exempt From Current Inv. Calc"; Boolean)
        {
            Caption = 'Exempt From Current Inv. Calc';
            DataClassification = ToBeClassified;
        }
        field(50001; "FTP Server Name"; Code[50])
        {
            Caption = 'FTP Server Name';
            DataClassification = CustomerContent;
            TableRelation = FTPServer."Server Name";
        }
        field(50002; "Facility Code"; Code[10])
        {
            Caption = 'Facility Code';
            DataClassification = CustomerContent;
            //  TableRelation = FTPServer.FacilityCode;
        }
        field(50003; "FDA Hold Location Code"; Code[20])
        {
        }
        field(50004; "Allow Physical Transfer"; Boolean)
        {
            Caption = 'Allow Physical Transfer';
            DataClassification = CustomerContent;
        }

    }
}
