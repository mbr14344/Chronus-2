table 50053 POItemSummary
{
    Caption = 'POItemSummary';
    DataClassification = ToBeClassified;
    TableType = Temporary;
    fields
    {
        field(1; "Document Type"; Enum "Purchase Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Purchase Header"."No." where("Document Type" = field("Document Type"));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "No."; Code[20])
        {
        }
        field(6; "Quantity"; Decimal)
        {
        }
        field(7; "UOM Code"; Code[20])
        {
        }
        field(8; "Quantity per"; Decimal)
        {
        }
    }
    keys
    {
        key(PK; "Line No.", "No.")
        {
            Clustered = true;
        }
    }
}
