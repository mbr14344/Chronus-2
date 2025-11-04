pageextension 50075 InterCompanyChartOfAcctExtPage extends "IC Chart of Accounts"
{
    Trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        TxtErrNoAccess: Label 'Sorry, you have NO ACCESS to Intercompany Chart of Accounts.';
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
