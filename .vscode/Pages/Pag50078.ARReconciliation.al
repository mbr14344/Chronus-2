page 50078 ARReconciliation
{
    PageType = List;
    SourceTable = "AR Reconciliation Ledger";
    Caption = 'AR Reconciliation Ledger';
    ApplicationArea = All;

    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            field(GetDt; GetDt)
            {
                ApplicationArea = All;
                Caption = 'Reconciliation Date';
            }
            repeater(Group)
            {
                Editable = false;

                field("Customer No."; Rec."Customer No.")
                {

                }
                field("Document Type"; Rec."Document Type") { }
                field("Document No."; Rec."Document No.") { }
                field(GLEAmount; Rec.GLEAmount) { }
                field(AmountApplied; Rec.AmountApplied) { }
                field(PaymentTolerance; Rec.PaymentTolerance) { }
                field(PaymentDiscount; Rec.PaymentDiscount) { }
                field(ExpectedBalance; Rec.ExpectedBalance) { }
                field(AgedARBalanceDue; Rec.AgedARBalanceDue) { }
                field(Delta; Rec.Delta) { }
                field(Status; Rec.Status) { }
                field(StatusDetails; Rec.StatusDetails) { }
                field("As of Date"; Rec."As of Date") { }
                field("Run DateTime"; Rec."Run DateTime") { }
                field("Run By User ID"; Rec."Run By User ID") { }
                field(SourceGLEEntryNo; Rec.SourceGLEEntryNo) { }
                field("Source Code"; Rec."Source Code") { }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RunReconciliation)
            {
                Caption = 'Run Reconciliation';
                Image = Process;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ARRecon: Codeunit ARReconciliationRunner;

                begin
                    if GetDt = 0D then
                        error('Reconciliation Date CANNOT be BLANK.  Please Review');

                    ARRecon.RunReconciliation(GetDt);
                    Message('AR Reconciliation Completed.');

                end;
            }
        }
    }
    var
        GetDt: Date;
}
