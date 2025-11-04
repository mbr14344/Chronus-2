table 50030 "Posted Container Header"
{
    Caption = 'Posted Container Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Container No."; Code[50])
        {
            Caption = 'Container No.';
        }
        field(2; "Freight Cost"; Decimal)
        {
            Caption = 'Freight Cost';
        }
        field(3; "ETD"; Date)
        {
            Caption = 'Initial Departure';
        }
        field(4; "ETA"; Date)
        {
            Caption = 'Initial Arrival';
        }
        field(5; Forwarder; Code[10])
        {
            TableRelation = "Shipping Agent".code;
        }
        field(7; "Container Size"; Code[20])
        {
            TableRelation = "Container Size".Code;
        }
        field(8; CreatedBy; Code[50])
        {
            TableRelation = User."User Name";
            Caption = 'Created By';
            Editable = false;
        }
        field(9; CreatedDate; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }

        field(12; "Port of Discharge"; Code[20])
        {
            Editable = false;
        }
        field(13; "Port of Loading"; Code[20])
        {
            Editable = false;
        }
        field(14; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
            Editable = false;
        }
        field(15; "Transfer Order No."; Code[20])
        {
            Editable = false;
        }
        field(16; "Posting Date"; Date)
        {

        }
        field(17; "Status"; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Assigned,Completed';
            OptionMembers = "Open","Assigned","Completed";
            Editable = false;
        }
        field(18; "Container Return Date"; Date)
        {

        }
        field(19; "Freight Bill Amount"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(20; "Freight Bill No."; Code[30])
        {

        }
        field(21; "PO No."; code[20])
        {
            Caption = 'PO No.';
            FieldClass = FlowField;
            CalcFormula = lookup(ContainerLine."Document No." where("Container No." = field("Container No.")));
        }
        field(22; "Empty Notification Date"; Date)
        {
            Editable = false;
        }


        field(23; ActualETD; Date)
        {
            Caption = 'Actual Departure';
        }
        field(24; ActualETA; Date)
        {
            Caption = 'Actual Arrival';
        }
        field(25; "Actual Pull Date"; Date)
        {

        }

        field(26; Carrier; Code[10])
        {
            TableRelation = "TO Carrier".Code;
        }
        field(27; Terminal; Code[50])
        {
            TableRelation = Terminal;
        }
        field(28; Drayage; Code[50])
        {
            TableRelation = Drayage;
        }
        field(29; "Container Status Notes"; Text[300])
        {

        }
        field(30; "Actual Pull Time"; Time)
        {

        }
        field(31; LFD; Date)
        {

        }
        field(32; "Actual Delivery Date"; Date)
        {

        }

        field(33; "Receiving Status"; code[50])
        {


        }
        field(34; "Telex Released"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header"."Telex Released" where("Transfer Order No." = field("Transfer Order No.")));
        }


        // PR 12/27/24
        field(35; "Transfer-to Code"; Code[10])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Receipt Header"."Transfer-to Code" where("Transfer Order No." = field("Transfer Order No.")));
        }
        //PR 2/17/25 - start

        field(37; "Container CBM"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Size".CBM where(Code = field("Container Size")));
        }
        field(38; "Percentage Threshold"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Container Size"."Percentage Threshold" where(Code = field("Container Size")));
        }
        //PR 2/17/25 - end
        //PR 2/19/25 - start
        field(39; "Filling Notes"; code[30])
        {
            TableRelation = FillingNotes.code;
        }
        //PR 2/19/25 - end


    }
    keys
    {
        key(PK; "Container No.")
        {
            Clustered = true;
        }
    }
}
