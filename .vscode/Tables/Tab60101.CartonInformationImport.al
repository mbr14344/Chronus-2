table 60101 CartonInformationImport
{
    Caption = 'CartonInformationImport';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }

        field(2; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(3; "DocumentLine No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Serial No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'SCC No.';
        }
        field(5; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(6; "From Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }

        field(11; "Sell-to Customer No."; Code[20])
        {

        }
        field(13; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(14; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }

        field(20; ImportedPackagedQuantity; Decimal)
        {
            Caption = 'Imported Packaged Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(21; Weight; Decimal)
        {
            Caption = 'Weight';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(22; ShippingLabelStyle; code[30])
        {
            Caption = 'Shipping Label Style';
            TableRelation = ReportLabelStyle;
            //pr 4/24/25 - start
            trigger OnValidate()
            var
                ReportStyle: Record ReportLabelStyle;
            begin
                ReportStyle.Reset();
                ReportStyle.SetRange(Code, ShippingLabelStyle);
                if (ReportStyle.FindFirst()) then
                    LabelTranslation := ReportStyle."Label Translation";
            end;
            //pr 4/24/25 - end
        }
        field(23; LabelTranslation; Code[20])
        {
            Caption = 'Label Translation';
            Editable = False;
        }

    }

    keys
    {
        key(PK; "Serial No.", "Line No.", "Document Type", "Document No.", "DocumentLine No.")
        {
            Clustered = true;
        }
        key(SecKey; "Document No.", "DocumentLine No.")
        {

        }


    }


    var
        SalesLine: Record "Sales Line";
}
