// Update your Table Extension 70000:

tableextension 50075 "Financial Reports Ext" extends "Financial Report"
{
    fields
    {
        field(60100; "Power BI"; Boolean)
        {
            Caption = 'Power BI';
            DataClassification = CustomerContent;
        }
        field(60101; "PBI Report Id"; Text[50])  // Changed from Guid to Text
        {
            Caption = 'PBI Report Id';
            DataClassification = CustomerContent;
        }
        field(60102; "PBI Workspace Id"; Text[50])  // Changed from Guid to Text
        {
            Caption = 'PBI Workspace Id';
            DataClassification = CustomerContent;
        }
        field(60103; "PBI Report URL"; Text[2048])
        {
            Caption = 'PBI Report URL';
            DataClassification = CustomerContent;
        }
        field(60104; "PBI Report Name"; Text[100])
        {
            Caption = 'PBI Report Name';
            DataClassification = CustomerContent;
        }
        field(60105; "PBI Workspace Name"; Text[100])
        {
            Caption = 'PBI Workspace Name';
            DataClassification = CustomerContent;
        }
    }
}