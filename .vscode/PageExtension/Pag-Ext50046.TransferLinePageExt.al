pageextension 50046 TransferLinePageExt extends "Transfer Order Subform"
{
    layout
    {
        addbefore("Item No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Quantity Received")
        {
            field("Source Document No."; Rec."Source Document No.")
            {
                ApplicationArea = All;
            }
            field("Telex Released"; Rec."Telex Released")
            {
                ApplicationArea = All;
            }
            field("Telex Updated By"; Rec."Telex Updated By")
            {
                ApplicationArea = All;
            }
            field("Telex Updated Date"; Rec."Telex Updated Date")
            {
                ApplicationArea = All;
            }

        }
        addafter("Unit of Measure Code")
        {
            // 12/27/24 - start
            //PR 3/13/25
            field("CustCode"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = all;
                Visible = true;
            }
            field("M-Pack Qty"; Rec."M-Pack Qty")
            {
                ApplicationArea = All;
            }
            field("Package Count"; rec.GetPackageCount())
            {
                ApplicationArea = All;
            }

            // 12/27/24 - end
            field(Ti; Rec.Ti)
            {
                ApplicationArea = All;
            }
            field(Hi; Rec.Hi)
            {
                ApplicationArea = All;
            }
        }
        addafter("Custom Transit Number")
        {
            field("Container No."; Rec."Container No.")
            {
                ApplicationArea = All;
                StyleExpr = TxtStyleExpr;
            }
            field("Container Line No."; Rec."Container Line No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Port of Loading"; Rec."Port of Loading")
            {
                ApplicationArea = all;

            }
            field("Port of Discharge"; Rec."Port of Discharge")
            {
                ApplicationArea = all;
            }
            field(UPC; Rec.UPC)
            {
                ApplicationArea = all;
            }

            field("PO No."; Rec."PO No.")
            {
                ApplicationArea = all;
                Editable = true;
                trigger OnValidate()
                var
                    PurLin: Record "Purchase Line";
                    PRLine: Record "Purch. Rcpt. Line";
                begin
                    if rec."PO No." <> xRec."PO No." then begin
                        IF STRLEN(Rec."Shortcut Dimension 1 Code") = 0 then begin
                            PurLin.Reset();
                            PurLin.SetRange("Document No.", Rec."PO No.");
                            PurLin.SetRange(Type, PurLin.Type::Item);
                            PurLin.SetRange("No.", Rec."Item No.");
                            If PurLin.FindFirst() then begin
                                Rec."Shortcut Dimension 1 Code" := PurLin."Shortcut Dimension 1 Code";
                            end

                            else begin
                                PRLine.Reset();
                                PRLine.SetRange("Order No.", Rec."PO No.");
                                PRLine.SetRange(Type, PRLine.Type::Item);
                                PRLine.SetRange("No.", Rec."Item No.");
                                IF PRLine.FindFirst() then begin
                                    Rec."Shortcut Dimension 1 Code" := PRLine."Shortcut Dimension 1 Code";
                                end;
                            end;
                        end;
                    end;

                end;
            }

            field("PO Owner"; Rec."PO Owner")
            {
                ApplicationArea = all;
                Editable = false;
            }
            //PR 2/14/25 - start
            field("PO Vendor"; Rec."PO Vendor")
            {
                ApplicationArea = All;
                Editable = false;
            }
            //PR 2/14/25 - end
            field("Purchasing Code"; Rec."Purchasing Code")
            {
                ApplicationArea = All;
            }
            //PR 2/10/25 - start
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
            //PR 2/10/25 - end


        }
        addafter(Description)
        {
            field("Real Time Item Description"; Rec."Real Time Item Description")
            {
                ApplicationArea = all;
            }
        }
        modify(Description)
        {
            Visible = false;
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
        Rec."PO Owner" := '';  //initialize
        Rec."PO Vendor" := ''; //initalize
        if Rec.Urgent = true then
            TxtStyleExpr := 'Unfavorable'   //BOLD RED
        ELSE
            TxtStyleExpr := 'Standard';  //Default
        rec.CalcFields(ETA, ETD, "Actual ETA", "Actual ETD",
        "UPC", Urgent, "Port of Discharge", "Port of Loading", "Lot No.", "Purchasing Code", "M-Pack Qty", "944 Receipt No.", "Real Time Item Description", "Exp Date");

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
        //mbr 2/11/25 - end

        //mbr 12/11/24 - update PO owner
        IF Rec."PO No." <> '' then begin
            POHdr.Reset();
            POHdr.SetRange("Document Type", POHdr."Document Type"::Order);
            POHdr.SetRange("No.", Rec."PO No.");

            if POHdr.FindFirst() then begin
                Rec."PO Owner" := POHdr.CreatedUserID;
                rec."PO Vendor" := POHdr."Buy-from Vendor No.";
                // Rec.Modify();
                // Commit();
            end
            else begin
                PostedPurchRcpt.Reset();
                PostedPurchRcpt.SetRange("Order No.", Rec."PO No.");
                if PostedPurchRcpt.FindFirst() then begin
                    Rec."PO Owner" := PostedPurchRcpt.CreatedUserID;
                    rec."PO Vendor" := PostedPurchRcpt."Buy-from Vendor No.";
                    //  Rec.Modify();
                    //  Commit();
                end
                else begin
                    ArchPurchaseHeader.Reset();
                    ArchPurchaseHeader.SetCurrentKey("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
                    ArchPurchaseHeader.SetRange("Document Type", ArchPurchaseHeader."Document Type"::Order);
                    ArchPurchaseHeader.SetRange("No.", Rec."PO No.");
                    ArchPurchaseHeader.Ascending(false);
                    if ArchPurchaseHeader.FindFirst() then begin
                        Rec."PO Owner" := ArchPurchaseHeader.CreatedUserID;
                        rec."PO Vendor" := ArchPurchaseHeader."Buy-from Vendor No.";
                        //       Rec.Modify();
                        //       Commit();
                    end;
                end;


            end;
        end;
        //mbr 12/11/24 - update PO Owner
        //mbr  12/30/24 - start: Update CustCode.  It now has 2 possible sources; But only update if CustCode is still BLANK
        IF STRLEN(Rec."Shortcut Dimension 1 Code") = 0 then begin
            PurLin.Reset();
            PurLin.SetRange("Document No.", Rec."PO No.");
            PurLin.SetRange(Type, PurLin.Type::Item);
            PurLin.SetRange("No.", Rec."Item No.");
            If PurLin.FindFirst() then begin
                Rec."Shortcut Dimension 1 Code" := PurLin."Shortcut Dimension 1 Code";
            end

            else begin
                PRLine.Reset();
                PRLine.SetRange("Order No.", Rec."PO No.");
                PRLine.SetRange(Type, PRLine.Type::Item);
                PRLine.SetRange("No.", Rec."Item No.");
                IF PRLine.FindFirst() then begin
                    Rec."Shortcut Dimension 1 Code" := PRLine."Shortcut Dimension 1 Code";
                end;
            end;
        end;
        //mbr 12/30/24 - end

    end;



}
