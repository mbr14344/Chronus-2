page 50201 PostedTransferShipmentLines
{
    ApplicationArea = All;
    Caption = 'Posted Transfer Shipment Lines';
    PageType = List;
    SourceTable = "Transfer Shipment Line";
    UsageCategory = Lists;

    layout
    {
        area(Content)

        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        TS: Page "Posted Transfer Shipment";
                        TSH: Record "Transfer Shipment Header";

                    begin

                        TSH.Reset();
                        TSH.SetRange("No.", Rec."Document No.");
                        if TSH.FindSet() then begin
                            Clear(TS);
                            TS.SetTableView(TSH);
                            TS.Run();
                        end;

                    end;

                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                }
                field("Transfer Order No."; Rec."Transfer Order No.")
                {
                    ToolTip = 'Specifies the number of the related transfer order.';
                }


                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ToolTip = 'Specifies the code of the location that items are transferred from.';
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ToolTip = 'Specifies the code of the location that the items are transferred to.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Container No."; Rec."Container No.")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        ContPg: Page "Container Order Card";
                        PostedContPg: Page "Posted Container Order";
                        ContHdr: Record "Container Header";
                        PostedContHdr: Record "Posted Container Header";
                    begin

                        ContHdr.Reset();
                        ContHdr.SetRange("Container No.", Rec."Container No.");
                        if ContHdr.FindSet() then begin
                            Clear(ContPg);
                            ContPg.SetTableView(ContHdr);
                            ContPg.Run();
                        end
                        else begin
                            PostedContHdr.Reset();
                            PostedContHdr.SetRange("Container No.", Rec."Container No.");
                            if ContHdr.FindSet() then begin
                                Clear(PostedContPg);
                                PostedContPg.SetTableView(PostedContHdr);
                                PostedContPg.Run();
                            end
                        end;

                    end;
                }
                //7/24/25 - start
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                //7/24/25 - end         
                field(ActualETD; Rec."Actual ETD")
                {
                    ApplicationArea = All;
                    ToolTip = 'Actual Departure = Actual Time of Departure.  This is maintained in the Posted Transfer Shipment Card.';
                }
                field(ActualETA; Rec."Actual ETA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Actual Arrival = Actual Time of Arrival.  This is maintained in the Posted Transfer Shipment Card.';
                }


            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Container No.", "Posting Date", "Actual ETA", "Actual ETD", "Expiration Date", "Lot No.")
    end;
}
