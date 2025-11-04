report 50005 "Outstanding Checks"
{
    Caption = 'Outstanding Checks';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/OutstandingChecks.rdl';
    dataset
    {
        dataitem(BankAccountLedgerEntry; "Bank Account Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.");

            column(DocumentNo; "Document No.") { }
            column(PostingDate; "Posting Date") { }
            column(Description; Description) { }
            column(Amount; Amount * -1) { }
            column(BankAccountNo; "Bank Account No.") { }
            column(StatementDate; StatementDate) { }
            column(StatementNo; StatementNo) { }
            column(CompanyInfo; CompanyInfo.Name) { }

            trigger OnPreDataItem()
            var
                BankAccStatement: Record "Bank Account Statement";
            begin
                // Get company information
                CompanyInfo.Get();
                if (StatementDate = 0D) or (BankAccountNo = '') then
                    Error('Please select both Bank Account and Statement Date.');

                // Validate that statement exists
                BankAccStatement.Reset();
                BankAccStatement.SetRange("Bank Account No.", BankAccountNo);
                BankAccStatement.SetRange("Statement Date", StatementDate);
                if not BankAccStatement.FindFirst() then
                    Error('No Bank Account Statement found for Bank Account %1 with Statement Date %2.', BankAccountNo, StatementDate);

                // Store the Statement No for use in OnAfterGetRecord
                StatementNo := BankAccStatement."Statement No.";

                // Filter Bank Account Ledger Entry for potential outstanding checks
                SetRange("Posting Date", 0D, StatementDate);
                SetRange("Document Type", "Document Type"::Payment);
                SetRange("Bal. Account Type", "Bal. Account Type"::Vendor);
                SetRange("Bank Account No.", BankAccountNo);
                SetFilter("Document No.", '<>G*');
            end;

            trigger OnAfterGetRecord()
            var
                BankAccStatementLine: Record "Bank Account Statement Line";
                CheckLedgerEntry: Record "Check Ledger Entry";
                BankAccStatement: Record "Bank Account Statement";
            begin
                // Check if this document has cleared in any statement up to the statement date
                BankAccStatement.Reset();
                BankAccStatement.SetRange("Bank Account No.", BankAccountNo);
                BankAccStatement.SetRange("Statement Date", 0D, StatementDate);

                if BankAccStatement.FindSet() then
                    repeat
                        BankAccStatementLine.Reset();
                        BankAccStatementLine.SetRange("Bank Account No.", BankAccountNo);
                        BankAccStatementLine.SetRange("Statement No.", BankAccStatement."Statement No.");
                        BankAccStatementLine.SetRange("Document No.", "Document No.");
                        BankAccStatementLine.SetFilter("Check No.", '<>%1', '');

                        // If found in any statement line up to statement date, this check has cleared - skip it
                        if BankAccStatementLine.FindFirst() then
                            CurrReport.Skip();
                    until BankAccStatement.Next() = 0;

                // Check if this check exists in Check Ledger Entry (must be a check)
                CheckLedgerEntry.Reset();
                CheckLedgerEntry.SetRange("Bank Account No.", BankAccountNo);
                CheckLedgerEntry.SetRange("Document No.", "Document No.");

                if not CheckLedgerEntry.FindFirst() then
                    CurrReport.Skip()  // Not a check - skip it
                else begin
                    // Check if this check is financially voided
                    if CheckLedgerEntry."Entry Status" = CheckLedgerEntry."Entry Status"::"Financially Voided" then
                        CurrReport.Skip();
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(ReportParameters)
                {
                    Caption = 'Report Parameters';
                    field(BankAccountNo; BankAccountNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Account No.';
                        TableRelation = "Bank Account";
                        ToolTip = 'Select the Bank Account';
                    }
                    field(StatementDate; StatementDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Statement Date';
                        ToolTip = 'Enter the Statement Date from your Bank Account Statement List.';

                        trigger OnValidate()
                        var
                            BankAccStatement: Record "Bank Account Statement";
                        begin
                            if StatementDate = 0D then
                                exit;

                            if BankAccountNo = '' then
                                Error('Please select a Bank Account first.');

                            BankAccStatement.Reset();
                            BankAccStatement.SetRange("Bank Account No.", BankAccountNo);
                            BankAccStatement.SetRange("Statement Date", StatementDate);

                            if not BankAccStatement.FindFirst() then
                                Error('No Bank Account Statement found for Bank Account %1 with Statement Date %2.\\Please verify the date exists in the Bank Account Statement list.', BankAccountNo, StatementDate);
                        end;
                    }
                }
            }
        }
    }

    var
        StatementDate: Date;
        BankAccountNo: Code[20];
        StatementNo: Code[20];
        CompanyInfo: Record "Company Information";

}