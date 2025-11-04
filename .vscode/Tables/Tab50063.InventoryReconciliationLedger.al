table 50063 "InventoryReconciliationLedger"
{
    Caption = 'Inventory Reconciliation Ledger';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }

        field(3; "GLValue"; Decimal)
        {
            Caption = 'G/L Value';
        }
        field(4; "Valuation"; Decimal)  //Qty * Cost
        {
            Caption = 'Valuation';
        }
        field(5; "Expected Delta"; Decimal)  //GLE - Valuation
        {
            Caption = 'Expected Delta';
        }

        field(7; Delta; Decimal)
        {
            Caption = 'Delta';
        }
        field(8; Status; text[50])
        {
            Caption = 'Status';
        }
        field(9; "As of Date"; Date)
        {
            Caption = 'Reconciliation As of Date';
        }

        field(10; "Run DateTime"; DateTime)
        {
            Caption = 'Run Date/Time';
        }
        field(11; "Run By User ID"; Code[50])
        {
            Caption = 'Run By User';
        }
        field(12; StatusDetails; Text[50])
        {
            Caption = 'Status Details';
        }
        field(13; "GL Entry No."; Integer)
        {
            Caption = 'G/L Entry No.';
        }
        field(14; "Rec ID"; Integer)
        {
            Caption = 'Rec ID';
            AutoIncrement = true;
        }
        field(17; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(18; SourceDescription; Text[100])
        {
            Caption = 'Source Description';
        }

    }
    keys
    {
        key(Key1; "As of Date", "Rec ID")
        {
            Clustered = true;
        }

    }
}
