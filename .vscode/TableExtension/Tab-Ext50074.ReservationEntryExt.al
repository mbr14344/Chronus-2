tableextension 50074 ReservationEntryExt extends "Reservation Entry"
{
    fields
    {
        field(50000; "Customer No."; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Sell-to Customer No." WHERE("No." = field("Source ID"), "Location Code" = field("Location Code")));
        }
        field(50001; "External Document No."; code[35])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."External Document No." WHERE("No." = field("Source ID"), "Location Code" = field("Location Code")));
        }
        field(50002; "Requested Delivery Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Requested Delivery Date" WHERE("No." = field("Source ID"), "Location Code" = field("Location Code")));
        }
        field(50003; "Start Ship Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Start Ship Date" WHERE("No." = field("Source ID"), "Location Code" = field("Location Code")));
        }
    }
}
