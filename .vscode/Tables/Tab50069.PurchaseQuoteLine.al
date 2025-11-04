table 50069 QuoteSheet
{
    Caption = 'QuoteSheet';
    DataClassification = ToBeClassified;

    fields
    {

        field(1; Description; Text[255])
        {
            Caption = 'Description';

        }
        field(2; Picture; MediaSet)
        {
            Caption = 'Image';
        }

        field(4; "Project Name"; Text[150])
        {
            Caption = 'Project Name';
        }
        field(5; "Version No."; Text[50])
        {
            Caption = 'Version No.';
        }
        field(6; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = " ",Complete,Open,Hold,Legacy;
            OptionCaption = ' ,Complete,Open,Hold,Legacy';
        }
        field(7; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }

        field(9; "China Comment"; Text[500])
        {
            Caption = 'China Comment';
        }
        field(10; "Material & Item Spec"; Text[150])
        {
            Caption = 'Material & Item Spec';
        }
        field(11; "UNIT SPEC"; Text[250])
        {
            Caption = 'UNIT SPEC';
        }
        field(12; "Inner Pack"; Integer)
        {
            Caption = 'Inner Pack';
        }
        field(13; "Master Pack"; Integer)
        {
            Caption = 'Master Pack';
        }
        field(14; Factory; Text[100])
        {
            Caption = 'Factory';
        }
        field(15; "Loading Port"; Text[100])
        {
            Caption = 'Loading Port';
        }
        field(16; HTN; Text[100])
        {
            Caption = 'HTM';
        }
        field(17; "Duty Rate %"; Decimal)
        {
            Caption = 'Duty Rate %';
            DecimalPlaces = 2 : 2;
        }
        field(18; "Container Type"; Text[50])
        {
            Caption = 'Container Type';
            TableRelation = PurchQuoteType.Type;
        }
        field(19; "Freight Rate"; Decimal)
        {
            Caption = 'Freight Rate';
            DecimalPlaces = 2 : 5;
        }
        field(20; "Estimated Landed Cost"; Decimal)
        {
            Caption = 'Estimated Landed Cost';
            DecimalPlaces = 2 : 5;
            Editable = false;
        }
        field(21; "Domestic Sell Price"; Decimal)
        {
            Caption = 'Domestic Sell Price';
            DecimalPlaces = 2 : 5;
        }
        field(22; "Domestic Margin %"; Decimal)
        {
            Caption = 'Domestic Margin %';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(23; Retail; Decimal)
        {
            Caption = 'Retail ($)';
            DecimalPlaces = 2 : 3;
        }
        field(24; "Customer Margin %"; Decimal)
        {
            Caption = 'Customer Margin %';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(25; "Special Instructions"; Text[200])
        {
            Caption = 'Special Instructions';
        }
        field(26; "Item H (Inch)"; Decimal)
        {
            Caption = 'Item H (Inch)';
            DecimalPlaces = 0 : 5;
        }
        field(27; "Item W (Inch)"; Decimal)
        {
            Caption = 'Item W (Inch)';
            DecimalPlaces = 0 : 5;
        }
        field(28; "Item L (Inch)"; Decimal)
        {
            Caption = 'Item L (Inch)';
            DecimalPlaces = 0 : 5;
        }
        field(29; "Net Weight (Gram)"; Decimal)
        {
            Caption = 'Net Weight (Gram)';
            DecimalPlaces = 0 : 5;
        }
        field(30; "Gross Weight (Gram)"; Decimal)
        {
            Caption = 'Gross Weight (Gram)';
            DecimalPlaces = 0 : 5;
        }
        field(31; "Carton L (Inch)"; Decimal)
        {
            Caption = 'Carton L (Inch)';
            DecimalPlaces = 0 : 5;
        }
        field(32; "Carton W (Inch)"; Decimal)
        {
            Caption = 'Carton W (Inch)';
            DecimalPlaces = 0 : 5;
        }
        field(33; "Carton H (Inch)"; Decimal)
        {
            Caption = 'Carton H (Inch)';
            DecimalPlaces = 0 : 5;
        }
        field(34; "Cube"; Decimal)
        {
            Caption = 'Cube';
            DecimalPlaces = 0 : 5;
        }
        field(35; "USA lbs. Weight"; Decimal)
        {
            Caption = 'USA lbs. Weight';
            DecimalPlaces = 0 : 5;
        }
        field(36; "Factory FOB Cost ($)"; Decimal)
        {
            Caption = 'Factory FOB Cost ($)';

            DecimalPlaces = 0 : 5;
        }
        field(37; "FOB Cost"; Decimal)
        {
            Caption = 'Final FOB Cost';
            DecimalPlaces = 0 : 5;
        }
        field(38; SystemCreatedByUser; Text[50])
        {
            Caption = 'System Created By';
        }
        field(39; "Product Spec"; Text[500])
        {
        }



    }

    keys
    {
        key(PK; "project Name", "Version No.", Description)
        {
            Clustered = true;
        }
    }


    trigger OnInsert()
    begin
        rec.SystemCreatedByUser := USERID;
    end;

    trigger OnModify()
    begin
        CalcVals();
    end;

    procedure CalcVals()
    begin
        CalcCube();
        CalcCustomerMargin();
        CalcEstimatedLandedCost();
        CalcDomesticMargin();
    end;

    procedure CalcCube()
    begin
        rec.Cube := (rec."Carton L (Inch)" * rec."Carton W (Inch)" * rec."Carton H (Inch)") / 1728;
    end;
    /*procedure CalcDutyRatePercent()
    begin
        if (rec."Factory FOB Cost ($)" = 0) then
            rec."Duty Rate %" := 0
        else
            rec."Duty Rate %" := (rec."Estimated Landed Cost" - rec."FOB Cost" - (rec."Freight Rate" / 2100 * rec.Cube / rec."Master Pack")) / rec."Factory FOB Cost ($)";
    end;*/

    procedure CalcCustomerMargin()
    begin
        if (rec.Retail = 0) then
            rec."Customer Margin %" := 0
        else
            rec."Customer Margin %" := (1 - (rec."Domestic Sell Price" / rec.Retail)) * 100;
    end;

    procedure CalcDomesticMargin()
    begin
        CalcEstimatedLandedCost();
        if (rec."Domestic Sell Price" = 0) then
            rec."Domestic Margin %" := 0
        else
            rec."Domestic Margin %" := (1 - (rec."Estimated Landed Cost" / rec."Domestic Sell Price")) * 100;
    end;

    procedure CalcEstimatedLandedCost()
    begin
        if (rec."Master Pack" = 0) or (rec.Cube = 0) or (rec."Freight Rate" = 0) or (rec."Factory FOB Cost ($)" = 0) or (rec."Duty Rate %" = 0) or (rec."FOB Cost" = 0) then
            rec."Estimated Landed Cost" := 0
        else
            rec."Estimated Landed Cost" := rec."Freight Rate" / 2100 * rec.Cube / rec."Master Pack" + rec."Factory FOB Cost ($)" * (rec."Duty Rate %" / 100) + rec."FOB Cost";
    end;
}