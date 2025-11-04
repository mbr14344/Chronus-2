page 50202 "PostedTransferReceiptLines"
{
    ApplicationArea = All;
    Caption = 'Posted Transfer Receipt Lines';
    PageType = List;
    SourceTable = "Transfer Receipt Line";
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
                        TR: Page "Posted Transfer Receipt";
                        TRH: Record "Transfer Receipt Header";

                    begin

                        TRH.Reset();
                        TRH.SetRange("No.", Rec."Document No.");
                        if TRH.FindSet() then begin
                            Clear(TR);
                            TR.SetTableView(TRH);
                            TR.Run();
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
                field("Receipt Date"; Rec."Receipt Date")
                {

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
                    ToolTip = 'Actual Departure = Actual Time of Departure.  This is maintained in the Posted Transfer Receipt Card.';
                }
                field(ActualETA; Rec."Actual ETA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Actual Arrival = Actual Time of Arrival.  This is maintained in the Posted Transfer Receipt Card.';
                }
                //8/27/25 - add fields frm 944 import - start
                field("Expected Quantity"; Rec."Expected Quantity")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                field("Expected UOM"; Rec."Expected UOM")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                field("Received Good"; Rec."Received Good")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                field("Received Case"; Rec."Received Case")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                field("Received Pallet"; Rec."Received Pallet")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                field("Received Damage"; Rec."Received Damage")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;
                }
                field("Received Over"; Rec."Received Over")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtOverStyle;
                }
                field("Received Short"; Rec."Received Short")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtShortStyle;
                }
                field("Received Weight"; Rec."Received Weight")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtNoCustomStyle;

                }
                //8/25/27 - add fields frm 944 import - end
                //10/3/25 - start
                field("M-Pack Qty"; Rec."M-Pack Qty")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0;
                    Editable = false;
                }
                field("Package Count"; rec.GetPackageCount())
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 1;
                    Editable = false;
                }
                //10/3/25 - end


            }
        }
    }
    var
        TxtStyleExpr: Text;
        TxtNoCustomStyle: Text;
        TxtOverStyle: Text;
        TxtShortStyle: Text;
        constFav: Label 'Favorable';
        constStd: Label 'Standard';
        constUnfav: Label 'Unfavorable';

    trigger OnAfterGetRecord()
    var
        ArchPurchaseHeader: Record "Purchase Header Archive";
        POHdr: Record "Purchase Header";
        PostedPurchRcpt: Record "Purch. Rcpt. Header";
        PurLin: Record "Purchase Line";
        PRLine: Record "Purch. Rcpt. Line";
    begin
        rec.CalcFields("Container No.", "Posting Date", "Actual ETA",
         "Actual ETD", "Expiration Date", "Lot No.", "944 Receipt No.", Urgent, "M-Pack Qty");
        if Rec.Urgent = true then
            TxtStyleExpr := 'Unfavorable'   //BOLD RED
        ELSE
            TxtStyleExpr := 'Standard';  //Default


        //mbr 2/11/25 - start
        //depending on the valu of 944 fields, change the style of No.
        if strlen(Rec."944 Receipt No.") > 0 then begin
            TxtNoCustomStyle := constFav;
            TxtOverStyle := constFav;
            TxtShortStyle := constFav;
            if (Rec."Received Short" > 0) then
                TxtShortStyle := constUnFav;
            if (Rec."Received Over" > 0) then
                TxtOverStyle := constUnfav;
        end

        else begin
            TxtNoCustomStyle := constStd;
            TxtOverStyle := constStd;
            TxtShortStyle := constStd;
        end;
    end;
}
