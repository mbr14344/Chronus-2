page 50026 "Container Orders"
{
    ApplicationArea = All;
    Caption = 'Container Orders';
    PageType = List;
    SourceTable = "Container Header";
    UsageCategory = Lists;



    CardPageID = "Container Order Card";
    DataCaptionFields = "Container No.";
    Editable = true;
    RefreshOnActivate = true;



    AboutTitle = 'About Container Orders';
    AboutText = 'Use a Container Order when you are planning to assign purchase order items to include in a container.';



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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Transfer Order No. Assigned"; Rec."Transfer Order No.")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        TOPg: Page "Transfer Order";
                        TOHdr: Record "Transfer Header";
                        PoTRPg: Page "Posted Transfer Receipt";
                        TRHdr: Record "Transfer Receipt Header";
                    begin

                        TOHdr.Reset();
                        TOHdr.SetRange("No.", Rec."Transfer Order No.");
                        if TOHdr.FindFirst() then begin
                            Clear(TOPg);
                            TOPg.SetTableView(TOHdr);
                            TOPg.Run();
                        end
                        else begin
                            TRHdr.Reset();
                            TRHdr.SetRange("Transfer Order No.", Rec."Transfer Order No.");
                            if TRHdr.FindFirst() then begin
                                Clear(PoTRPg);
                                PoTRPg.SetTableView(TRHdr);
                                PoTRPg.Run();
                            end;
                        end;
                    end;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = all;
                }
                field("Telex Released"; Rec."Telex Released")
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

                field("Filling Notes"; Rec."Filling Notes")
                {
                    ApplicationArea = all;

                }
                //PR 2/17/25 - end
                field("Container Size"; Rec."Container Size")
                {
                    ApplicationArea = All;
                }
                //PR 2/17/24 - start
                field("Total CBM"; Rec.GetTotalCBM())
                {
                    ApplicationArea = All;
                    StyleExpr = TxtCBMStyle;
                }
                field("Total Weight"; Rec.GetTotalWeight())
                {
                    ApplicationArea = All;
                }
                //PR 2/17/25 - start
                field("Container CBM"; Rec."Container CBM")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Container Percentage Threshold"; Rec."Percentage Threshold")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                //PR 2/17/24 - end
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
                field("Receiving Status"; Rec."Receiving Status")
                {
                    ApplicationArea = All;
                }
                field("Container Status Notes"; Rec."Container Status Notes")
                {
                    ApplicationArea = All;
                }
                field(Drayage; Rec.Drayage)
                {
                    ApplicationArea = All;
                }
                field(Terminal; Rec.Terminal)
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
                field(ModifiedBy; Rec.ModifiedBy)
                {
                    ApplicationArea = All;
                }
                field(ModifiedDate; Rec.ModifiedDate)
                {
                    ApplicationArea = All;
                }
                field("FDA Hold"; Rec."FDA Hold")
                {
                    ApplicationArea = All;
                }


            }

            part(ContainerLine; "Container Order Subform")
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
                SubPageLink = "Table ID" = const(Database::"Container Header"),
                            "No." = field("Container No.");
            }
            // pr 8/16/24 - added support for attaching documents and keeps track of # of attachments - end
        }



    }

    actions
    {
        area(Processing)
        {

            action("Assign Now")
            {
                ApplicationArea = all;
                Image = Reserve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = bAssignVis;
                trigger OnAction()
                begin
                    AssignNow();
                    CurrPage.Close();
                end;

            }

        }
    }

    var
        bAssignVis: Boolean;
        TransferOrderNo: Code[20];
        TxtCBMStyle: Text;


    procedure SetAssignNow(inValue: Boolean; InTransferNo: Code[20])
    begin
        bAssignVis := inValue;
        TransferOrderNo := InTransferNo;
    end;

    procedure AssignNow()
    var
        TransferHeader: Record "Transfer Header";
    begin
        // PR 12/13/24 check if Transfer Order Has Container No. value. If so, error out - start
        TransferHeader.Reset();
        TransferHeader.SetRange("No.", TransferOrderNo);
        if (TransferHeader.FindSet()) then begin
            if (TransferHeader."Container No." <> '') then
                Error('Container No. %1 is already assigned to TO %2. Container No. %3 assignment aborted.', TransferHeader."Container No.", TransferOrderNo, Rec."Container No.")
            else
                Rec.GetReceiptLines(TransferOrderNo);
        end;
        // PR 12/13/24 check if Transfer Order Has Container No. value. If so, error out - end
    end;

    trigger OnOpenPage()
    begin
        //mbr temporary disable
        //  Error('Sorry, Container Order page is CURRENTLY UNDER CONSTRUCTION!');

    end;

    trigger OnAfterGetRecord()
    var
        TransferOrder: Record "Transfer Header";

        PostedTransferRec: Record "Transfer Receipt Header";
    begin

        Rec."Telex Released" := false; //initialize
        Rec."Transfer-to Code" := '';  //initialize

        TransferOrder.Reset();
        TransferOrder.SetRange("No.", rec."Transfer Order No.");
        if (TransferOrder.FindFirst()) then begin
            rec."Telex Released" := TransferOrder."Telex Released";
            rec."Transfer-to Code" := TransferOrder."Transfer-to Code";
        end

        else begin
            PostedTransferRec.Reset();
            PostedTransferRec.SetRange("Transfer Order No.", rec."Transfer Order No.");
            if PostedTransferRec.FindFirst() then begin
                rec."Telex Released" := PostedTransferRec."Telex Released";
                rec."Transfer-to Code" := PostedTransferRec."Transfer-to Code";
            end;


        end;
        rec.CalcFields("Container CBM", "Percentage Threshold");
        rec.UpdateFDAHoldStatus();
        Rec.Modify();
        //PR 2/19/25 - start
        if (rec.GetTotalCBM() < (rec."Container CBM" * 0.75)) then
            TxtCBMStyle := 'Unfavorable'
        else
            TxtCBMStyle := 'Standard';
        //PR 2/19/25 - end
    end;
}
