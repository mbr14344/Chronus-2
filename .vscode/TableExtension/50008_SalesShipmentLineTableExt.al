tableextension 50008 SalesShipmentLineTable extends "Sales Shipment Line"
{
    //pr 1/12/24 added fields for sales line
    fields
    {

        field(50002; "APT Date"; Date)
        {
            Caption = 'APT Date';

        }
        field(50003; "APT Time"; Text[20])
        {
            Caption = 'APT Time';

        }

        field(50004; "External Document No."; Code[35])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."External Document No." WHERE("Order No." = field("Order No."), "Sell-to Customer No." = field("Sell-to Customer No.")));
        }
        field(50011; "M-Pack Qty"; Decimal)
        {
            Caption = 'M-Pack Qty';
            FieldClass = FlowField;

            CalcFormula = lookup("Item Unit of Measure"."Qty. per Unit of Measure" WHERE("Item No." = field("No."), Code = CONST('M-PACK')));
        }
        field(50012; "M-Pack Weight"; Decimal)
        {
            Caption = 'M-Pack Weight';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure"."Weight" WHERE("Item No." = field("No."), Code = CONST('M-PACK')));
        }


    }
}
