table 50020 "Port of Loading"
{
    CaptionML = ENU = 'Port Of Loading/Discharge',
                ENC = 'Port Of LoadingDischarge';
    LookupPageId = "Port of Loading List";

    fields
    {
        field(1; "Port"; Code[20])
        {
            Caption = 'Port';
        }

    }

    keys
    {
        key(Key1; "Port")
        {
        }
    }


}

