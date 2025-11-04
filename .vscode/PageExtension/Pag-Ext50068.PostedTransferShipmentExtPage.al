pageextension 50068 PostedTransferShipmentExtPage extends "Posted Transfer Shipment"
{
    layout
    {
        addfirst(factboxes)
        {
            // pr 8/16/24 - added support for attaching documents and keeps track of # of attachments - start
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Transfer Shipment Header"),
                            "No." = field("No.");
            }
            // pr 8/16/24 - added support for attaching documents and keeps track of # of attachments - end
        }
        addafter("Posting Date")
        {
            field(Urgent; Rec.Urgent)
            {
                ApplicationArea = All;
            }

            field("Telex Released"; Rec."Telex Released")
            {
                ApplicationArea = all;
            }
            field("Container No."; Rec."Container No.")
            {
                ApplicationArea = all;
            }
            field("Container Size"; Rec.ContainerSize)
            {
                ApplicationArea = all;
            }
            field(Forwarder; Rec.Forwarder)
            {
                ApplicationArea = all;
            }
            field("Port of Discharge"; Rec."Port of Discharge")
            {
                ApplicationArea = all;
            }
            field("Port of Loading"; Rec."Port of Loading")
            {
                ApplicationArea = all;
            }
            field("Pier Pass"; Rec."Pier Pass")
            {
                ApplicationArea = all;
            }
            field(LFD; Rec.LFD)
            {
                ApplicationArea = all;
            }
            field("Actual Pull Date"; Rec."Actual Pull Date")
            {
                ApplicationArea = all;
            }
            field("Actual Pull Time"; Rec."Actual Pull Time")
            {
                ApplicationArea = All;
            }
            field("Actual Date"; Rec.ActualDeliveryDate)
            {
                ApplicationArea = All;
            }
            field("Actual ETD"; Rec.ActualETD)
            {
                ApplicationArea = all;
            }
            field("Actual ETA"; Rec.ActualETA)
            {
                ApplicationArea = all;
            }
            field(Drayage; Rec.DrayageFF)
            {
                ApplicationArea = all;
            }
            field(Terminal; Rec.Terminal)
            {
                ApplicationArea = all;
            }
            field(Notes; Rec.Notes)
            {
                ApplicationArea = all;
            }
            // 8/26/25 - start
            field("944 Load No."; Rec."944 Load No.")
            {
                ApplicationArea = all;
            }
            field("944 Received Date"; Rec."944 Received Date")
            {
                ApplicationArea = all;
            }
            field("944 Receipt No."; Rec."944 Receipt No.")
            {
                ApplicationArea = all;
            }
            //8/26/25 - end


        }
        addafter("Transfer-to Code")
        {
            field("Physical Transfer To Code"; Rec."Physical Transfer To Code")
            {
                ApplicationArea = all;
            }
        }
    }
    var
        txtDelErr: Label 'You are NOT allowed to delete Posted Transfer Shipment %1. Please undo shipment receipt.';

    trigger OnDeleteRecord(): Boolean
    begin
        Error(txtDelErr, Rec."No.");
    end;
}
