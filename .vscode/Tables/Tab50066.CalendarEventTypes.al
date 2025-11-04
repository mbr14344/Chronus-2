table 50066 CalendarEventTypes
{
    Caption = 'Calendar Event Types';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[30])
        {
            Caption = 'Code';
        }
        field(2; "Color"; Text[20])
        {
            Caption = 'Color';
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
