tableextension 50007 "Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(50000; "Cancel Date"; Date)
        {
            Caption = 'Cancel Date';


        }
        field(50001; "Request Ship Date"; Date)
        {
            Caption = 'Request Ship Date';


        }
        field(50002; "Split"; Boolean)
        {
            Caption = 'Split';


        }
        field(50003; "FOB"; Text[20])
        {
            Caption = 'FOB';


        }
        field(50004; "Flag"; Option)
        {
            Caption = 'Flag';
            OptionMembers = " ","0","Allocated","China Drop Ship","Extension Pending","Issue with PO","Master PO","PO SPLIT","Portal Routed","Pre-Scheduled","Ready for Billing","Routed and Waiting for Product","Scheduled","Scheduled and Waiting for Product","Transfer Pending","Waiting Product","Waiting Sales","Warehouse Processing","Order Canceled","Tendered to BC","Reschedule Pending","Need to schedule","Future Ship Date";
            OptionCaption = ' ,0,Allocated,China Drop Ship,Extension Pending,Issue with PO,Master PO,PO SPLIT,Portal Routed,Pre-Scheduled,Ready for Billing,Routed and Waiting for Product,Scheduled,Scheduled and Waiting for Product,Transfer Pending,Waiting Product,Waiting Sales,Warehouse Processing,Order Canceled,Tendered to BC,Reschedule Pending,Need to schedule,Future Ship Date';
        }
        field(50005; "Start Ship Date"; Date)
        {
            Caption = 'Start Ship Date';

        }
        field(50006; "Single BOL No."; Code[20])
        {
            Caption = 'Single BOL No.';
        }
        field(50014; "FreightChargeTerm"; Option)
        {
            OptionMembers = " ","Prepaid","Collect","3rd Party";
            Caption = 'Freight Charge Terms';
        }
        field(50015; "BOL Comments"; Text[250])
        {
            Caption = 'BOL Comments';
        }
        field(50016; Type; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
        }
        field(50017; Dept; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Dept';
        }
        field(50018; "CustomerShipToCode"; Code[30])
        {
            Caption = 'Customer Ship-to Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Ship-to Address".CustomerShipToCode WHERE("Code" = field("Ship-to Code")));

        }
        field(50019; "APT Date"; Date)
        {
            Caption = 'APT Date';

        }
        field(50020; "APT Time"; Text[20])
        {
            Caption = 'APT Time';

        }
        field(50021; "Total Package Count"; Decimal)
        {
            Caption = 'Total Package Count';
        }
        field(50022; "Total Weight"; Decimal)
        {
            Caption = 'Total Weight';
        }
        field(50023; "Total Pallet Count"; Decimal)
        {
            Caption = 'Total Pallet Count';
        }
        field(50035; "Order Notes"; Text[255])
        {

        }
        //pr 3/24/35 - start
        field(50036; "ShipFromAdress"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Address WHERE(Code = field("Location Code")));
        }
        field(50037; "ShipFromCity"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.City WHERE(Code = field("Location Code")));
        }
        field(50038; "ShipFromState"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("SAT Address"."SAT State Code" WHERE(ID = field(SATAddress1)));
        }
        field(50039; "ShipFromContact"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Contact WHERE(Code = field("Location Code")));
        }
        field(50040; "ShipFromPostalCode"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Post Code" WHERE(Code = field("Location Code")));
        }
        field(50041; "ShipFromCountry"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Country/Region Code" WHERE(Code = field("Location Code")));
        }
        field(50042; "ShipFromName"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name WHERE(Code = field("Location Code")));

        }
        //pr 3/24/25 - end

        field(50043; SATAddress1; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."SAT Address ID" where(Code = field("Location Code")));
        }
        //pr 6/19/25 - start
        field(50045; "Freight Charge Name"; Text[100])
        {
        }
        field(50046; "Freight Charge Address"; Text[100])
        {
        }
        field(50047; "Freight Charge City"; Text[30])
        {
            TableRelation = if ("Bill-to Country/Region Code" = const('')) "Post Code".City;

        }
        field(50048; "Freight Charge State"; Text[100])
        {
            TableRelation = "Country/Region";
        }
        field(50049; "Freight Charge Zip"; Text[20])
        {
            TableRelation = if ("Sell-to Country/Region Code" = const('')) "Post Code";

        }
        field(50050; "Freight Charge Contact"; Text[100])
        {

        }
        field(50051; "In the Month"; text[20])
        {
            Caption = 'In the Month';
            TableRelation = "InTheMonthOptions"."Code";

        }


    }
}
