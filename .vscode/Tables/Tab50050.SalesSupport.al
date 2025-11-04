table 50050 SalesSupport
{

    Caption = 'Sales Support';
    DrillDownPageID = SalesSupport;
    LookupPageID = SalesSupport;
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Code"; code[30])
        {
            Caption = 'Code';
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

}
