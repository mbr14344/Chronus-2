reportextension 50119 ReconcileApToGLReportExt extends "Reconcile AP to GL"
{
    dataset
    {
    }
    procedure ChkNoRecords(): integer
    var
        POLine: record "Purchase Line";
        CntRec: Integer;
    begin
        CntRec := 0;
        POLine.Reset();
        POLine.SetRange("Document Type", POLine."Document Type"::Order);
        POline.SetFilter("Qty. Received (Base)", '>%1', 0);
        IF POLine.FindSet() then
            repeat
                IF POLine."Qty. Received (Base)" <> POLine."Qty. Invoiced (Base)" then
                    CntRec += 1;
            until POLine.Next = 0;
        exit(CntRec);
    end;

}
