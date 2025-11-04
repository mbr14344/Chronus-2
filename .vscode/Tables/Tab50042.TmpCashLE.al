table 50042 TmpCashLE
{
    Caption = 'Cash Ledger Entry';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(3; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            DataClassification = CustomerContent;
        }
        field(4; "Posting Date"; Date)
        {
            ClosingDates = true;
            DataClassification = CustomerContent;
        }
        field(5; "G/L Account Name"; Text[100])
        {
            Editable = false;
        }
        field(10; "Document Type"; Enum "SIMC CSH Document Type")
        {
            DataClassification = CustomerContent;
        }
        field(11; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Document Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(13; "GL Document Type"; Enum "Gen. Journal Document Type")
        {
            DataClassification = CustomerContent;
            // OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(14; "Source Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset",Employee;
        }
        field(15; "Source No."; Code[20])
        {
            DataClassification = CustomerContent;

        }
        // Extended fro 50 to 100 chars
        field(16; "Source Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(20; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(53; "Debit Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            BlankZero = true;
        }
        field(54; "Credit Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            BlankZero = true;
        }
        field(60; "Applied Document Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Sales Invoice","Sales Cr. Memo","Purchase Invoice","Purchase Cr. Memo","G/L Entry",Adjustment,Payment,Refund;
        }
        field(61; "Applied Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(62; "Applied Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(70; "Payment No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(71; "Created On"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(75; "From Balance G/L"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(481; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Editable = false;
        }
        field(482; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Editable = false;
        }
        field(483; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            Editable = false;
        }
        field(484; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            Editable = false;
        }
        field(485; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            Editable = false;
        }
        field(486; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            Editable = false;
        }

    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(key5; "Posting Date", "Applied Document Type", "Source Type", "Document Type")
        {

        }
        key(key6; "Posting Date", "Applied Document Type", "Source Type", "Source No.", "Document Type", "Document No.")
        {

        }
        key(Key2; "G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount";
        }
        key(Key3; "G/L Account No.", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount";
        }
        key(Key4; "Posting Date")
        {
        }
    }


}