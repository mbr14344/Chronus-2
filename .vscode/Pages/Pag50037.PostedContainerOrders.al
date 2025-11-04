page 50037 "Posted Container Orders"
{
    // pr 6/4/24 created posted container orders page
    ApplicationArea = All;
    Caption = 'Posted Container Orders';
    PageType = List;
    SourceTable = "Posted Container Header";
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;
    CardPageID = "Posted Container Order";
    DataCaptionFields = "Container No.";
    Editable = false;

    RefreshOnActivate = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
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
                field("Empty Notification Date"; Rec."Empty Notification Date")
                {
                    ApplicationArea = All;
                }
                field("Container Return Date"; Rec."Container Return Date")
                {
                    ApplicationArea = All;
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
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        PoTRPg: Page "Posted Transfer Receipt";
                        TRHdr: Record "Transfer Receipt Header";
                    begin

                        TRHdr.Reset();
                        TRHdr.SetRange("Transfer Order No.", Rec."Transfer Order No.");
                        if TRHdr.FindFirst() then begin
                            Clear(PoTRPg);
                            PoTRPg.SetTableView(TRHdr);
                            PoTRPg.Run();
                        end;

                    end;

                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = All;
                }
                field("Freight Cost"; Rec."Freight Cost")
                {
                    ToolTip = 'Specifies the value of the Freight Cost field.';
                }
                field(ETD; Rec.ETD)
                {
                    ToolTip = 'Specifies the value of the Estimated Time of Departure field.';
                }
                field(ETA; Rec.ETA)
                {
                    ToolTip = 'Specifies the value of the Estimated Time of Arrival field.';
                }
                field(Forwarder; Rec.Forwarder)
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

            part(ContainerLine; "Posted Container List SubForm")
            {
                Caption = 'Container Order Lines';
                ApplicationArea = Basic, Suite;
                Editable = false;
                SubPageLink = "Container No." = field("Container No.");

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
