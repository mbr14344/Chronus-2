reportextension 50121 AccountSchedExtPage extends "Account Schedule"
{
    Trigger OnPreReport()
    var
        UserSetup: Record "User Setup";
        TxtErrNoAccess: Label 'Sorry, you have NO ACCESS to All Account Schedule Reports.';
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
