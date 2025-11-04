codeunit 50008 APReconciliationRunner
{
    procedure RunReconciliation(AsOfDate: Date)
    var
        APRec: Record "AP Reconciliation Ledger";
        GLE: record "G/L Entry";
        DVLE: Record "Detailed Vendor Ledg. Entry";
        VLE: Record "Vendor Ledger Entry";
        TotalAmountApplied: Decimal;
        AgedAPBalanceDue: Decimal;
        bSkipDelta: boolean;
        PaymentToleranceAmount: Decimal;
        PaymentDiscountAmount: Decimal;
    begin
        // Core logic:
        // 1. Clear reconciliation records for AsOfDate
        // 2. Loop GLE, DVLE, VLE to build reconciliation records
        // 3. Insert populated records into AP Reconciliation Ledger table

        //1. Clear Reconciliation Records
        APRec.SETRANGE("As of Date", AsOfDate);
        IF APRec.FindSet() then
            APRec.DeleteAll();

        // 2. Loop GLE, DVLE, VLE to build Reconciliation records
        GLE.Reset;
        GLE.SetRange("G/L Account No.", '20100');
        GLE.SetFilter("Posting Date", '<=%1', AsOfDate);
        //  GLE.SetRange("Entry No.", 425493); //mbr test
        IF GLE.FindSet() then
            repeat
                APRec.Init();
                ApRec."As of Date" := AsOfDate;
                Aprec."Run By User ID" := UserId;
                APRec."Run DateTime" := CurrentDateTime;
                APRec."Vendor No." := GLE."Source No.";
                ApRec."Document Type" := GLE."Document Type";
                APRec."Document No." := GLE."Document No.";
                APRec.GLEAmount := GLE.Amount;
                APRec.SourceGLEEntryNo := GLE."Entry No.";
                APRec."Source Code" := GLE."Source Code";

                PaymentToleranceAmount := 0;
                PaymentDiscountAmount := 0;
                TotalAmountApplied := 0;
                AgedAPBalanceDue := 0;
                bSkipDelta := false;

                //Calculate TotalAmounyApplied
                VLE.Reset();
                VLE.SetRange("Entry No.", APRec.SourceGLEEntryNo);
                IF VLE.FindFirst() then begin
                    DVLE.Reset();
                    DVLE.SetRange("Vendor Ledger Entry No.", VLE."Entry No.");
                    DVLE.SetFilter("Entry Type", '%1|%2|%3', DVLE."Entry Type"::Application, DVLE."Entry Type"::"Payment Tolerance", DVLE."Entry Type"::"Payment Discount");
                    IF DVLE.FindSet() then
                        repeat
                            case DVLE."Entry Type" of
                                DVLE."Entry Type"::Application:
                                    if DVLE."Posting Date" <= AsOfDate then
                                        TotalAmountApplied += DVLE.Amount;
                                DVLE."Entry Type"::"Payment Tolerance":
                                    PaymentToleranceAmount += DVLE.Amount;
                                DVLE."Entry Type"::"Payment Discount":
                                    PaymentDiscountAmount += DVLE.Amount;
                            end;
                        until DVLE.Next() = 0;
                END;
                //Get Aged AP Balance due from VLE and DVLE;
                VLE.Reset();
                VLE.SetRange("Entry No.", APRec.SourceGLEEntryNo);
                VLE.SetFilter("Posting Date", '..%1', AsOfDate);
                IF VLE.FindFirst() then begin
                    VLE.CalcFields(Amount);
                    AgedAPBalanceDue := VLE."Amount";
                    DVLE.Reset();
                    DVLE.SetRange("Vendor Ledger Entry No.", VLE."Entry No.");
                    DVLE.SetRange("Entry Type", DVLE."Entry Type"::Application);
                    DVLE.SetFilter("Posting Date", '..%1', AsOfDate);
                    IF DVLE.FindSet() then
                        repeat
                            AgedAPBalanceDue += DVLE.Amount;
                        until DVLE.Next() = 0;
                    if AgedAPBalanceDue <> 0 then
                        AgedAPBalanceDue -= PaymentToleranceAmount;
                end
                else begin
                    // No matching VLE found — zero out Aged AP Balance Due
                    AgedAPBalanceDue := 0;
                    Aprec.Status := 'No VLE Found';
                    Aprec.ExpectedBalance := 0;
                    APRec.Delta := 0;
                    bSkipDelta := true;

                    case APRec."Source Code" of
                        'GENJNL', 'JOURNAL':
                            if (APRec.GLEAmount > 0) and (APRec."Document Type" = APRec."Document Type"::Invoice) then
                                APRec.StatusDetails := 'Manual Journal Entry - Potential Incorrect DR'
                            else
                                APRec.StatusDetails := 'Manual Journal Entry';
                        'INVTPCOST', 'UNAPPPURCH', 'PURCHAPPL':
                            APRec.StatusDetails := 'Reclass or Purchase Application';
                        else
                            APRec.StatusDetails := 'NO VLE found - possibly unapplied or reclassified';
                    end;





                end;

                //update necessary fields;
                APRec.AmountApplied := TotalAmountApplied;
                APRec.AgedAPBalanceDue := AgedAPBalanceDue * -1;
                APRec.PaymentTolerance := PaymentToleranceAmount;
                APrec.PaymentDiscount := PaymentDiscountAmount;

                if bSkipDelta = false then begin
                    APRec.ExpectedBalance := APRec.GLEAmount + APRec.AmountApplied;
                    if (APRec.ExpectedBalance = 0) and (APRec.AgedAPBalanceDue = 0) then begin
                        APRec.Delta := 0;
                        APRec.Status := 'Closed';
                    end else
                        if abs(APRec.ExpectedBalance) = abs(APRec.AgedAPBalanceDue) then
                            APRec.Delta := 0
                        else
                            APRec.Delta := APRec.ExpectedBalance + APRec.AgedAPBalanceDue + PaymentToleranceAmount + PaymentDiscountAmount;


                    if APRec.Delta = 0 then begin
                        if APRec.AgedAPBalanceDue = 0 then
                            APRec.Status := 'Closed'
                        else
                            APRec.Status := 'Matched';

                    end
                    else if Abs(APRec.Delta) <= 0.01 then
                        APRec.Status := 'Partial Match'
                    else begin
                        if (APRec."Document Type" = APRec."Document Type"::Invoice) and
                           (Abs(APRec.ExpectedBalance) = APRec.AgedAPBalanceDue) then
                            APRec.Status := 'Matched'
                        else
                            APRec.Status := 'Mismatch';
                    end;
                end;
                APRec.Insert();
            until GLE.Next() = 0;





    end;

}
