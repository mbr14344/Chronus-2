reportextension 50123 DetailTrialBalanceExtReport extends "Detail Trial Balance"
{
    Trigger OnPreReport()
    var
        UserSetup: Record "User Setup";
        TxtErrNoAccess: Label 'Sorry, you have NO ACCESS to Detail Trial Balance';
    begin
        UserSetup.Reset();
        UserSetup.SETRANGE("User ID", UserId);
        UserSetup.SetRange(FinanceAdmin, true);
        IF NOT UserSetup.FindFirst() then begin
            Error(TxtErrNoAccess);
            CurrReport.Quit();
        end;

    end;
}
