tableextension 50013 "Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(50001; DoNotShipBeforeDate; Date)
        {
            Caption = 'Do Not Ship Before Date';
            DataClassification = CustomerContent;
        }
        field(50002; RequestedCargoReadyDate; Date)
        {
            Caption = 'Requested Cargo Ready Date';
            DataClassification = CustomerContent;
            // 7/7/25  - update CRD diff -- start
            trigger OnValidate()
            var
                PurchLines: Record "Purchase Line";
            begin
                PurchLines.Reset();
                PurchLines.SetRange("Document No.", rec."No.");
                PurchLines.SetRange("Document Type", rec."Document Type");
                PurchLines.SetRange(Type, PurchLines.Type::Item);
                if (PurchLines.FindSet()) then
                    repeat
                        PurchLines.GetCRDDif();
                    until PurchLines.Next() = 0;
            end;
            // 7/7/25 - updte CRRD diff - end
        }
        field(50003; RequestedInWhseDate; Date)
        {
            Caption = 'Requested In Whse Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if RequestedInWhseDate <> xRec.RequestedInWhseDate then
                    UpdPurchLineDates();
            end;
        }
        field(50004; "Incoterm"; Option)
        {
            Caption = 'Incoterm';
            DataClassification = CustomerContent;
            OptionCaption = ' ,CIF,DDP,EXW,FOB';
            OptionMembers = " ","CIF","DDP","EXW","FOB";
        }

        field(50005; "Port Of Loading"; Code[20])
        {
            Caption = 'Port of Loading';
            TableRelation = "Port of Loading".Port;
        }

        field(50006; CreatedUserID; Code[20])
        {
            Caption = 'Created By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50007; CreatedDate; Date)
        {
            Caption = 'Created Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50008; "Port Of Discharge"; Code[20])
        {
            Caption = 'Port of Discharge';
            TableRelation = "Port of Loading".Port;
        }
        field(50009; Forwarder; Code[10])
        {
            TableRelation = "Shipping Agent".code;
        }
        field(50010; "Production Status"; Option)
        {
            Caption = 'Production Status';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Waiting for factory to send print confirmation,Waiting for license approval,Waiting for design team approval,Deposit pending approval,Balance payment pending approval,Waiting for test report (DO NOT USE),Waiting for new mold ready ,Waiting for factory to confirm CRD,Finalizing product spec,Pre-production sample pending approval  ,Post-production sample pending approval,Approved for production,Waiting for factory to book shipment,Shipment booked,Waiting for forwarder to release vessel info,Shipped,Waiting for Artwork,PO on Hold,Waiting for component from US,Shipped - waiting for payment to release FCR,Waiting for factory provide pre-production samples,Waiting for pre-production test report,Waiting for post-production test report';
            OptionMembers = " ","Waiting for factory to send print confirmation","Waiting for license approval","Waiting for design team approval","Deposit pending approval","Balance payment pending approval","Waiting for test report (DO NOT USE)","Waiting for new mold ready ","Waiting for factory to confirm CRD","Finalizing product spec","Pre-production sample pending approval  ","Post-production sample pending approval","Approved for production","Waiting for factory to book shipment","Shipment booked","Waiting for forwarder to release vessel info","Shipped","Waiting for Artwork","PO on Hold","Waiting for component from US","Shipped - waiting for payment to release FCR","Waiting for factory provide pre-production samples","Waiting for pre-production test report","Waiting for post-production test report";
        }
        field(50011; Internal; Boolean)
        {

        }
        field(50012; VerifiedBy; Code[20])
        {
            Caption = 'Verified By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50013; VerifiedDate; Date)
        {
            Caption = 'Verified Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50014; TotalInvoiceAmounts; Decimal)
        {
            Caption = 'Total Invoice Amount';
            Editable = false;
        }
        field(50015; TotalPrepaidInvoiceAmounts; Decimal)
        {
            Caption = 'Total Prepaid Invoice Amount';
            Editable = false;
        }
        field(50016; TotalAppliedCreditMemoAmount; Decimal)
        {
            Caption = 'Total Applied Credit Memos';
            Editable = false;
        }
        field(50017; TotalAppliedPOPayment; Decimal)
        {
            Caption = 'Total Applied PO Payments';
            Editable = false;
        }
        field(50018; POBalance; Decimal)
        {
            Caption = 'PO Balance';
            Editable = false;
        }
        field(50019; TotalUnappliedPOPayment; Decimal)
        {
            Caption = 'Total Unapplied Payments';
            Editable = false;
        }
        field(50020; TotalReceivedAmount; Decimal)
        {
            Caption = 'Total Received Invoiced Amount';
            Editable = false;
        }
        field(50021; TotalUnappliedInvoices; Decimal)
        {
            Caption = 'Total Unapplied Invoices';
            Editable = false;
        }
        field(50022; Closed; Boolean)
        {
            Caption = 'Closed';
            Editable = false;
        }
        field(50023; TotalUnAppliedCreditMemoAmount; Decimal)
        {
            Caption = 'Total Unapplied Credit Memos';
            Editable = false;
        }
        field(50024; PaymentStandingBalance; Decimal)
        {
            Caption = 'Payment Standing Balance';
            Editable = false;
        }
        field(50025; POFinalizeDate; Date)
        {
            Caption = 'PO Finalized Date';
            Editable = true;
        }
    }

    var
        purchLineDelError: Label 'There is a paid balance of %1 that has not been accounted for.  Please inform Accounting.';

    trigger OnInsert()
    begin
        CreatedUserID := UserId;
        CreatedDate := Today;
        UpdPurchLineDates();
    end;
    // pr 8/12/24 On delete of PO (from Purchase Order Card….not from purchase line grid, allow deletion of Purchase Line)
    trigger OnBeforeDelete()
    var
        purchaseline: record "Purchase Line";
        purchInvHeader: Record "Purch. Inv. Header";
        gLentry: record "G/L Entry";
        purchCreditMemoHeader: Record "Purch. Cr. Memo Hdr.";
        purchInvLine: Record "Purch. Inv. Line";
        docNosStr: text;
        gLAccountNoStr: text;
        amountSum: Decimal;

    begin
        //check prep - check to see if it's okay to delete
        // pr 8/12/24 - get all the document nos from Prepayment Invoices
        docNosStr := '';
        amountSum := 0;
        purchInvHeader.Reset();
        purchInvHeader.SetRange("Prepayment Order No.", rec."No.");
        if (purchInvHeader.FindSet()) then
            repeat
                // if StrPos(docNosStr, purchInvHeader."No.") = 0 then
                docNosStr += format(purchInvHeader."No.") + '|';
            until purchInvHeader.Next() = 0;
        // pr 8/12/24 - get all the document nos from Invoices 
        purchInvHeader.Reset();
        purchInvHeader.SetRange("Order No.", rec."No.");
        if (purchInvHeader.FindSet()) then
            repeat
                //  if StrPos(docNosStr, purchInvHeader."No.") = 0 then
                docNosStr += format(purchInvHeader."No.") + '|';
            until purchInvHeader.Next() = 0;
        // pr 8/12/24 - get all document nos from Prepayment CMs 
        purchCreditMemoHeader.Reset();
        purchCreditMemoHeader.SetRange("Prepayment Order No.", Rec."No.");
        if (purchCreditMemoHeader.FindSet()) then
            repeat
                // if StrPos(docNosStr, purchCreditMemoHeader."No.") = 0 then
                docNosStr += format(purchCreditMemoHeader."No.") + '|';
            until purchCreditMemoHeader.Next() = 0;

        // pr 8/12/24 - Get the G/L Account from Prepayment Invoice, if exists
        purchInvHeader.Reset();
        purchInvHeader.SetRange("Prepayment Order No.", rec."No.");
        if (purchInvHeader.FindFirst()) then begin
            purchInvLine.Reset();
            purchInvLine.SetRange("Document No.", purchInvHeader."No.");
            if (purchInvLine.FindSet()) then
                gLAccountNoStr := Format(purchInvLine."No.");
        end;
        // pr 8/12/24 - Goto Gene Ledger Entries and filter Document Nos and G/L Account from Prepayment Invoice. 
        //              IF ZERO, allow deletion, if NOT, error out
        docNosStr := docNosStr.TrimEnd('|');
        gLentry.Reset();
        gLentry.SetFilter("Document No.", docNosStr);
        gLentry.SetRange("G/L Account No.", gLAccountNoStr);
        if (gLentry.FindSet()) then
            repeat
                amountSum += gLentry.Amount;
            until gLentry.Next() = 0;
        //end of check prep
        if (amountSum <= 0) then begin
            purchaseline.reset;
            purchaseline.SetRange("Document No.", rec."No.");
            purchaseline.SetRange("Document Type", rec."Document Type");
            purchaseline.SetRange(Type, purchaseline.Type::Item);
            if purchaseline.FindSet() then
                repeat
                    purchaseline.SetDelFromHeader(true);
                    purchaseline.Delete(true);
                until purchaseline.next = 0;
        end
        else begin
            Error(purchLineDelError, FORMAT(amountSum, 0, '<Precision,2:2><Standard Format,0>'));
        end;

    end;

    local procedure UpdPurchLineDates()
    var
        purchaseline: record "Purchase Line";
    begin
        purchaseline.reset;
        purchaseline.SetRange("Document No.", rec."No.");
        purchaseline.SetRange("Document Type", rec."Document Type");
        purchaseline.SetRange(Type, purchaseline.Type::Item);
        if purchaseline.FindSet() then
            repeat
                purchaseline.VALIDATE("Planned Receipt Date", rec.RequestedInWhseDate);
                purchaseline.Modify();
            until purchaseline.next = 0;
    end;
}
