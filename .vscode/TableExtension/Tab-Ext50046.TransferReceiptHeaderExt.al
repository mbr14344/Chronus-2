tableextension 50046 TransferReceiptHeaderExt extends "Transfer Receipt Header"
{
    fields
    {
        field(50000; "Telex Released"; Boolean)
        {
            Caption = 'Telex Released';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; "Container No."; Code[50])
        {
            Caption = 'Container No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; ContainerSize; Code[20])
        {
            Caption = 'Container Size';
            TableRelation = "Container Size".Code;
            Editable = false;
        }

        field(50009; Forwarder; Code[10])
        {
            TableRelation = "Shipping Agent".code;
            Editable = false;
        }
        field(50010; "Port of Discharge"; Code[20])
        {
            TableRelation = "Port of Loading".Port;
            Editable = false;
        }
        field(50011; "Port of Loading"; Code[20])
        {
            TableRelation = "Port of Loading".Port;
            Editable = false;
        }
        field(50012; Carrier; Code[10])
        {
            TableRelation = "TO Carrier".Code;
            Editable = false;
        }
        field(50014; "Pier Pass"; boolean)
        {
            Editable = false;
        }
        field(50015; LFD; Date)
        {
            Editable = false;
        }
        field(50016; "Actual Pull Date"; Date)
        {
            Editable = false;
        }
        field(50017; "Container Return Date"; Date)
        {
            Editable = false;
        }
        field(50018; Terminal; Code[50])
        {
            TableRelation = Terminal;
            Editable = false;
            //CalcFormula = lookup("Transfer Header".Terminal where("No." = field("Transfer Order No.")));
        }
        field(50019; ActualETD; Date)
        {
            Caption = 'Actual Departure';
            Editable = false;
        }
        field(50020; ActualETA; Date)
        {
            Caption = 'Actual Arrival';
            Editable = false;
        }
        field(50021; Notes; text[250])
        {
            Caption = 'Transfer Order Notes';
            Editable = false;

        }

        field(50022; ActualDeliveryDate; Date)
        {
            Caption = 'Actual Delivery Date';
            Editable = false;
        }
        field(50023; Urgent; Boolean)
        {
            Caption = 'Urgent';
            Editable = false;
        }
        field(50027; "Actual Pull Time"; Time)
        {
            Editable = false;
        }

        //PR 3/6/25 - start
        field(50029; "Receiving Status"; code[50])
        {
            FieldClass = FlowField;
            TableRelation = ReceivingStatus;
            CalcFormula = lookup("Posted Container Header"."Receiving Status" Where("Container No." = field("Container No.")));

        }
        //PR 3/6/25 - end


        //PR 2/10/25 - start
        field(50048; "944 Received Date"; Date)
        {
            Editable = false;
        }
        field(50036; DrayageFF; Code[50])
        {
            Caption = 'Drayage';
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header".Drayage where("Container No." = field("Container No.")));
        }
        field(50049; "944 Receipt No."; code[20])
        {
            Editable = false;
        }
        field(50050; "944 Load No."; code[20])
        {
            Editable = false;
        }
        //PR 2/10/25 - end

        //PR 2/17/25 - start
        field(50051; "Total CBM"; Decimal)
        {
            Editable = false;
        }
        //PR 2/17/25 - end
        //PR 2/19/25 - start
        field(50052; "Filling Notes"; code[30])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Container Header"."Filling Notes" where("Container No." = field("Container No.")));
        }
        //PR 2/19/25 - end
        //8/25/25 - start
        field(50053; "Physical Transfer To Code"; Code[10])
        {
            Editable = false;
        }
        field(50054; "Allow Physical Transfer"; Boolean)
        {
            Editable = false;
        }
        //8/25/25 - start


    }
}