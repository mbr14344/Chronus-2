table 50039 "EDI G\L Account"
{
    Caption = 'EDI G\L Account';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "EDI G/L Account No."; code[20])
        {
            Caption = 'EDI G/L Account';
        }
        field(2; "Name"; Text[100])
        {
            Caption = 'G/L Account Name';
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Account".Name where("No." = field("EDI G/L Account No.")));
        }
    }
    keys
    {
        key(PK; "EDI G/L Account No.")
        {
            Clustered = true;
        }
    }
}
