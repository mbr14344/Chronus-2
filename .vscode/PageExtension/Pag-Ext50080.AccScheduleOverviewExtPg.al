pageextension 50080 AccScheduleOverviewExtPg extends "Acc. Schedule Overview"
{
    Trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        TxtErrNoAccess: Label 'Sorry, you have NO ACCESS to Account Schedule Overview';
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
