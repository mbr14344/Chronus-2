pageextension 50020 PaymentJournalPageExt extends "Payment Journal"
{
    actions
    {

        modify(PrintCheck)
        {

            trigger OnBeforeAction()
            var
                "Vendor Ledger Entry": Record "Vendor Ledger Entry";
            begin
                IF rec."Account Type" = rec."Account Type"::Vendor then begin
                    "Vendor Ledger Entry".SetRange("Vendor Ledger Entry"."Vendor No.", Rec."Account No.");
                    "Vendor Ledger Entry".SetRange("Vendor Ledger Entry"."Document Type", "Vendor Ledger Entry"."Document Type"::Invoice);
                    "Vendor Ledger Entry".SetRange("Applies-to ID", Rec."Applies-to ID");
                    IF "Vendor Ledger Entry".Count > 10 then
                        Error('You have applied more than 10 invoices for this check.  Please use the Check with No Stub option to print check.');
                end;

            end;


        }
        modify(ApplyEntries)
        {
            trigger OnBeforeAction()
            var
                apllyCustEntriesPage: Page "Apply Customer Entries";
            begin
                apllyCustEntriesPage.SetIsPostAndApply(false);
            end;
        }

        addafter(PreviewCheck)
        {

            action("Print Check Details")
            {
                AccessByPermission = TableData "Check Ledger Entry" = R;
                ApplicationArea = Basic, Suite;
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()

                var
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnlLine.SetRange("Posting Date", Rec."Posting Date");
                    GenJnlLine.SetRange("Document No.", Rec."Document No.");
                    IF GenJnlLine.FindFirst() then begin
                        Clear(ChkDetail);
                        ChkDetail.SetTableView(GenJnlLine);
                        ChkDetail.RunModal;
                    end;
                end;
            }
        }
        addafter(PrintCheck)
        {
            action(PrintCheckNoStub)
            {
                AccessByPermission = TableData "Check Ledger Entry" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Print Check w/No Stubs';
                Ellipsis = true;
                Image = PrintCheck;
                ToolTip = 'Prepare to print the check with no stubs.';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    DocumentPrint: Codeunit "Document-Print";
                begin
                    GenJournalLine.Reset();
                    GenJournalLine.Copy(Rec);
                    GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenCU.PrintCheckNoStub(GenJournalLine);
                    CODEUNIT.Run(CODEUNIT::"Adjust Gen. Journal Balance", Rec);
                end;
            }
            action(PrintFreeStyleCheck)
            {
                AccessByPermission = TableData "Check Ledger Entry" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Print FreeStyle Check';
                Ellipsis = true;
                Image = PrintCheck;
                ToolTip = 'Prepare to print the FreeStyle check.';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    DocumentPrint: Codeunit "Document-Print";
                begin
                    GenJournalLine.Reset();
                    GenJournalLine.Copy(Rec);
                    GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    IF GenJournalLine.FindFirst() then begin
                        description := '';
                        Clear(FreeStyleCheckPage);
                        FreeStyleCheckPage.SetGenJournalLine(GenJournalLine);
                        FreeStyleCheckPage.RunModal;
                        description := FreeStyleCheckPage.GetDescription();
                        FreeStyleCheckPage.Close();

                    end;
                end;
            }
        }
    }
    var
        ChkDetail: Report "Check Detail";
        FreeStyleCheckPage: Page "FreeStyleCheck";
        GenCU: Codeunit GeneralCU;
        description: Text[250];

}
