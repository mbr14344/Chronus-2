page 50038 "Posted Container Order"
{
    // pr 6/4/24 created posted container order page
    ApplicationArea = All;
    Caption = 'Posted Container Order';
    PageType = Card;
    SourceTable = "Posted Container Header";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {

            group(General)
            {
                Caption = 'General';

                field("Container No."; Rec."Container No.")
                {
                    ToolTip = 'Specifies the value of the Container No. field.';
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;

                }
                field(PostedBy; GetUserNameFromSecurityId(Rec.SystemCreatedBy))
                {
                    ApplicationArea = all;
                    Caption = 'Posted By';
                }

                field("Freight Bill Amount"; Rec."Freight Bill Amount")
                {
                    ApplicationArea = All;

                }
                field("Freight Bill No."; Rec."Freight Bill No.")
                {
                    ApplicationArea = All;

                }
                field("Transfer Order No. Assigned"; Rec."Transfer Order No.")
                {

                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = All;
                }

                field("Freight Cost"; Rec."Freight Cost")
                {
                    ToolTip = 'Specifies the value of the Freight Cost field.';

                }

                field(Forwarder; Rec.Forwarder)
                {
                    ApplicationArea = All;

                }
                field("Container Size"; Rec."Container Size")
                {
                    ApplicationArea = All;

                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;

                }
                field("Port of Loading"; Rec."Port of Loading")
                {
                    ApplicationArea = All;

                }
                field("Port of Discharge"; Rec."Port of Discharge")
                {
                    ApplicationArea = All;

                }
                field(CreatedBy; Rec.CreatedBy)
                {
                    ApplicationArea = All;
                }
                field(CreatedDate; Rec.CreatedDate)
                {
                    ApplicationArea = All;
                }
                field("Telex Released"; Rec."Telex Released")
                {
                    ApplicationArea = All;
                    ToolTip = 'Telex Released: This is maintained in the Posted Transfer Receipt Page.';
                }

            }
            group(Container)
            {
                field(ETD; Rec.ETD)
                {
                    ToolTip = 'Specifies the value of the Estimated Time of Departure field.';

                }
                field(ETA; Rec.ETA)
                {
                    ToolTip = 'Specifies the value of the Estimated Time of Arrival field.';

                }
                field(ActualETD; Rec.ActualETD)
                {
                    ApplicationArea = ALL;
                }
                field(ActualETA; Rec.ActualETA)
                {
                    ApplicationArea = ALL;
                }
                field(LFD; Rec.LFD)
                {
                    ApplicationArea = All;
                }

                field("Actual Pull Date"; Rec."Actual Pull Date")
                {
                    ApplicationArea = All;
                }
                field("Actual Pull Time"; Rec."Actual Pull Time")
                {
                    ApplicationArea = All;
                }
                field("Actual Delivery Date"; Rec."Actual Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("Empty Notification Date"; Rec."Empty Notification Date")
                {
                    ApplicationArea = All;
                }
                // pr 12/2/24 - end
                field("Container Return Date"; Rec."Container Return Date")
                {
                    ApplicationArea = All;

                }

                field(Carrier; Rec.Carrier)
                {
                    ApplicationArea = All;
                }
                field(Terminal; Rec.Terminal)
                {
                    ApplicationArea = All;
                }
                field(Drayage; Rec.Drayage)
                {
                    ApplicationArea = All;
                }

                field("Container Status Notes"; Rec."Container Status Notes")
                {
                    ApplicationArea = All;
                }
                field("Receiving Status"; Rec."Receiving Status")
                {
                    ApplicationArea = All;
                }
            }


            part(ContainerLines; "Posted Container List SubForm")
            {
                Caption = 'Container Lines';
                ApplicationArea = Basic, Suite;
                Editable = false;
                Enabled = true;
                SubPageLink = "Container No." = field("Container No.");
                UpdatePropagation = Both;
            }
        }
        area(FactBoxes)
        {

            // pr 8/16/24 - added support for attaching documents and keeps track of # of attachments - start
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Posted Container Header"),
                            "No." = field("Container No.");
            }
            // pr 8/16/24 - added support for attaching documents and keeps track of # of attachments - end
        }
    }
    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Telex Released");
    end;

    procedure GetUserNameFromSecurityId(UserSecurityID: Guid): Code[50]
    var
        User: Record User;
    begin
        IF User.Get(UserSecurityID) then
            exit(User."User Name");
    end;
}
