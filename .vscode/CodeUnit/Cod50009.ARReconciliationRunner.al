codeunit 50009 ARReconciliationRunner
{
    procedure RunReconciliation(AsOfDate: Date)
    var
        ARRec: Record "AR Reconciliation Ledger";
        GLE: record "G/L Entry";
        DCLE: Record "Detailed Cust. Ledg. Entry";
        CLE: Record "Cust. Ledger Entry";
        TotalAmountApplied: Decimal;
        AgedARBalanceDue: Decimal;
        bSkipDelta: boolean;
        PaymentToleranceAmount: Decimal;
        PaymentDiscountAmount: Decimal;

    begin
        // Core logic:
        // 1. Clear reconciliation records for AsOfDate
        // 2. Loop GLE, DCLE, CLE to build reconciliation records
        // 3. Insert populated records into AR Reconciliation Ledger table

        //1. Clear Reconciliation Records
        ARRec.SETRANGE("As of Date", AsOfDate);
        IF ARRec.FindSet() then
            ARRec.DeleteAll();

        // 2. Loop GLE, DCLE, CLE to build Reconciliation records
        GLE.Reset;
        GLE.SetRange("G/L Account No.", '10400');
        GLE.SetFilter("Posting Date", '<=%1', AsOfDate);
        //GLE.SetRange("Entry No.", 233403); //mbr test
        IF GLE.FindSet() then
            repeat
                ARRec.Init();
                ARRec."As of Date" := AsOfDate;
                ARRec."Run By User ID" := UserId;
                ARRec."Run DateTime" := CurrentDateTime;
                ARRec."Customer No." := GLE."Source No.";
                ARRec."Document Type" := GLE."Document Type";
                ARRec."Document No." := GLE."Document No.";
                ARRec.GLEAmount := GLE.Amount;
                ARRec.SourceGLEEntryNo := GLE."Entry No.";
                ARRec."Source Code" := GLE."Source Code";

                PaymentToleranceAmount := 0;
                PaymentDiscountAmount := 0;
                TotalAmountApplied := 0;
                AgedARBalanceDue := 0;
                bSkipDelta := false;

                If GLE.Reversed = true then begin
                    ARRec.Status := 'Closed';
                    ARRec.StatusDetails := 'Fully Applied and Reversed';
                    ARRec.ExpectedBalance := 0;
                    ARRec.Delta := 0;
                    bSkipDelta := true;
                    TotalAmountApplied := GLE.Amount * -1;
                end
                else begin
                    //Calculate TotalAmounyApplied
                    CLE.Reset();
                    CLE.SetRange("Entry No.", ARRec.SourceGLEEntryNo);
                    IF CLE.FindFirst() then begin

                        DCLE.Reset();
                        DCLE.SetRange("Cust. Ledger Entry No.", CLE."Entry No.");
                        DCLE.SetFilter("Entry Type", '%1|%2|%3', DCLE."Entry Type"::Application, DCLE."Entry Type"::"Payment Tolerance", DCLE."Entry Type"::"Payment Discount");
                        IF DCLE.FindSet() then
                            repeat
                                case DCLE."Entry Type" of
                                    DCLE."Entry Type"::Application:
                                        if DCLE."Posting Date" <= AsOfDate then
                                            TotalAmountApplied += DCLE.Amount;
                                    DCLE."Entry Type"::"Payment Tolerance":
                                        PaymentToleranceAmount += DCLE.Amount;
                                    DCLE."Entry Type"::"Payment Discount":
                                        PaymentDiscountAmount += DCLE.Amount;
                                end;
                            until DCLE.Next() = 0;
                    END;

                    //Get Aged AR Balance due from CLE and DCLE;
                    CLE.Reset();
                    CLE.SetRange("Entry No.", ARRec.SourceGLEEntryNo);
                    CLE.SetFilter("Posting Date", '..%1', AsOfDate);
                    IF CLE.FindFirst() then begin

                        CLE.CalcFields(Amount);

                        AgedARBalanceDue := CLE."Amount";
                        DCLE.Reset();
                        DCLE.SetRange("Cust. Ledger Entry No.", CLE."Entry No.");
                        DCLE.SetRange("Entry Type", DCLE."Entry Type"::Application);
                        DCLE.SetFilter("Posting Date", '..%1', AsOfDate);
                        IF DCLE.FindSet() then
                            repeat
                                AgedARBalanceDue += DCLE.Amount;
                            until DCLE.Next() = 0;
                        if AgedARBalanceDue <> 0 then
                            AgedARBalanceDue -= PaymentToleranceAmount;





                    end

                    else begin
                        // No matching CLE found — zero out Aged AR Balance Due
                        AgedARBalanceDue := 0;
                        ARRec.Status := 'No CLE Found';
                        ARRec.ExpectedBalance := 0;
                        ARRec.Delta := 0;
                        bSkipDelta := true;

                        case ARRec."Source Code" of
                            'GENJNL', 'JOURNAL':
                                if (ARRec.GLEAmount > 0) and (ARRec."Document Type" = ARRec."Document Type"::Invoice) then
                                    ARRec.StatusDetails := 'Manual Journal Entry - Potential Incorrect CR'
                                else
                                    ARRec.StatusDetails := 'Manual Journal Entry';
                            'INVTPCOST', 'UNAPPSALES', 'SALESAPPL':
                                ARRec.StatusDetails := 'Reclass or Sales Application';
                            else
                                ARRec.StatusDetails := 'NO CLE found - possibly unapplied or reclassified';
                        end;
                    end;
                end;





                //update necessary fields;
                ARRec.AmountApplied := TotalAmountApplied;
                ARRec.AgedARBalanceDue := AgedARBalanceDue * -1;
                ARRec.PaymentTolerance := PaymentToleranceAmount;
                ARrec.PaymentDiscount := PaymentDiscountAmount;



                if bSkipDelta = false then begin

                    ARRec.ExpectedBalance := ARRec.GLEAmount + ARRec.AmountApplied;


                    if (ARRec.ExpectedBalance = 0) and (ARRec.AgedARBalanceDue = 0) then begin
                        ARRec.Delta := 0;
                        ARRec.Status := 'Closed';
                    end else
                        if abs(ARRec.ExpectedBalance) = abs(ARRec.AgedARBalanceDue) then
                            ARRec.Delta := 0
                        else
                            ARRec.Delta := ARRec.ExpectedBalance + ARRec.AgedARBalanceDue + PaymentDiscountAmount + PaymentToleranceAmount;



                    if ARRec.Delta = 0 then begin
                        if ARRec.AgedARBalanceDue = 0 then
                            ARRec.Status := 'Closed'
                        else begin
                            ARRec.Status := 'Matched';
                            if abs(ARRec.ExpectedBalance) <> abs(ARRec.AgedARBalanceDue) then begin
                                ARRec.ExpectedBalance := ARRec.ExpectedBalance + PaymentDiscountAmount + PaymentToleranceAmount;
                            end;
                        end;


                    end
                    else if Abs(ARRec.Delta) <= 0.01 then
                        ARRec.Status := 'Partial Match'
                    else begin
                        if (ARRec."Document Type" = ARRec."Document Type"::Invoice) and
                           (Abs(ARRec.ExpectedBalance) = ARRec.AgedARBalanceDue) then
                            ARRec.Status := 'Matched'
                        else
                            ARRec.Status := 'Mismatch';
                    end;
                end;
                ARRec.Insert();
            until GLE.Next() = 0;

        ARRec.Reset();
        ARRec.SetRange("As of Date", AsOfDate);
        ARRec.SetRange(Status, 'Mismatch');
        ARRec.SetRange("Document Type", ARRec."Document Type"::Payment);
        ARRec.SetRange(AgedARBalanceDue, 0);
        If ARRec.FindSet() then
            repeat
                If (ARRec.PaymentDiscount + ARRec.ExpectedBalance) = (ARRec.Delta) then begin
                    ARRec.PaymentTolerance := ARRec.Delta * -1;
                    ARRec.ExpectedBalance := ARRec.GLEAmount + ARRec.AmountApplied + ARRec.PaymentTolerance + ARRec.PaymentDiscount;
                    ARRec.Delta := ARRec.ExpectedBalance + ARRec.AgedARBalanceDue;
                    If ARRec.Delta = 0 then begin
                        ARRec.Status := 'Matched';
                        ARRec.StatusDetails := '';
                        ARRec.Modify();
                    end;
                end;
            until ARRec.Next() = 0;

    end;


}
