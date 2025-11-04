pageextension 50087 PostedTransferReceiptSubform extends "Posted Transfer Rcpt. Subform"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("Purchasing Code"; Rec."Purchasing Code")
            {
                ApplicationArea = all;
            }
            field("Telex Released"; Rec."Telex Released")
            {
                ApplicationArea = All;
            }
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
        rec.CalcFields("944 Receipt No.", Urgent, "M-Pack Qty");
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

    /*trigger OnAfterGetRecord()
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
        end;*/



}
