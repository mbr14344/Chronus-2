tableextension 50031 GeneralLedgerSetupTableExt extends "General Ledger Setup"
{
    fields
    {
        field(50001; "Auto BC General Template"; Code[10])
        {
            Caption = 'Auto BC General Template';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(50002; "Auto BC General Batch"; Code[10])
        {
            Caption = 'Auto BC General Batch';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Auto BC General Template"));
        }

        field(50003; "Purchase Discount G/L Account"; Code[20])
        {
            Caption = 'Purchase Discount G/L Account';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(50004; "Sales Discount G/L Account"; Code[20])
        {
            Caption = 'Sales Discount G/L Account';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
    }
}
