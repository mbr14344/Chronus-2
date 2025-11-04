table 50104 CartonInformation

{
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
        field(6; "Reserved Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Package Count';
            DecimalPlaces = 0 : 5;
        }
        field(7; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
        field(8; LineCount; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line Count';
        }
        field(9; Posted; Boolean)
        {
        }
        field(10; PSSNo; Code[20])
        {
            Caption = 'Posted Sales Shipment No.';
        }
        field(11; "Sell-to Customer No."; Code[20])
        {

        }
        field(12; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Sell-to Customer Name" WHERE("Sell-to Customer No." = field("Sell-to Customer No.")));
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
        field(15; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(16; "Package Quantity"; Decimal)
        {
            Caption = 'Package Quantity';
            DecimalPlaces = 0 : 5;
        }

        field(17; "Item Reserved Quantity"; Decimal)
        {
            Caption = 'Item Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(18; "Package ID No."; Integer)
        {
            Caption = 'Package ID No.';
        }
        field(19; Imported; boolean)
        {
            Caption = 'Imported';
        }
        field(20; ImportedPackagedQuantity; Decimal)
        {
            Caption = 'Imported Packaged Count';
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
        field(24; "M-Pack Qty"; Decimal)
        {

        }

    }

    keys
    {
        key(PK; "Serial No.", "Line No.", "Document Type", "Document No.", "DocumentLine No.")
        {
            Clustered = true;
        }
        key(SecKey; "Document No.", "DocumentLine No.", LineCount)
        {

        }
        key(PSSSecKey; PSSNo, "Document No.", Posted)
        {

        }
        key(LCKey; LineCount)
        {

        }

    }

    var
        SalesLine: Record "Sales Line";

}