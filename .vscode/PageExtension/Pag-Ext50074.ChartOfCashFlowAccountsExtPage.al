pageextension 50074 ChartOfCashFlowAccountsExtPage extends "Chart of Cash Flow Accounts"
{
    Trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        TxtErrNoAccess: Label 'Sorry, you have NO ACCESS to Chart of Cashflow Accounts.';
    begin
        UserSetup.Reset();
        UserSetup.SETRANGE("User ID", UserId);
        UserSetup.SetRange(FinanceAdmin, true);
        IF NOT UserSetup.FindFirst() then begin
            Error(TxtErrNoAccess);
            CurrPage.Close();
        end;

    end;
}
