page 50079 InventoryReconciliationLedger
{
    PageType = List;
    SourceTable = InventoryReconciliationLedger;
    Caption = 'Inventory Reconciliation Ledger';
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
                field("Rec ID"; Rec."Rec ID") { }
                field("Source Code"; Rec."Source Code") { }
                field(SourceDescription; Rec.SourceDescription) { }
                field("GL Entry No."; Rec."GL Entry No.") { }
                field("Item No."; Rec."Item No.")
                {

                }
                field(Valuation; Rec.Valuation) { }
                field(GLValue; Rec.GLValue) { }
                field("Expected Delta"; Rec."Expected Delta") { }
                field(Delta; Rec.Delta) { }

                field(Status; Rec.Status) { }
                field(StatusDetails; Rec.StatusDetails) { }
                field("As of Date"; Rec."As of Date") { }
                field("Run DateTime"; Rec."Run DateTime") { }
                field("Run By User ID"; Rec."Run By User ID") { }

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
                    ARRecon: Codeunit InvValToBSReconcile;

                begin
                    if GetDt = 0D then
                        error('Reconciliation Date CANNOT be BLANK.  Please Review');

                    ARRecon.RunReconciliation(GetDt);
                    Message('Inventory Reconciliation Completed.');

                end;
            }
        }
    }
    var
        GetDt: Date;
}
