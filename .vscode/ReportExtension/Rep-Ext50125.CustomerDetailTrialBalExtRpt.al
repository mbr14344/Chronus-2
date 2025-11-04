reportextension 50125 CustomerDetailTrialBalExtRpt extends "Customer - Detail Trial Bal."
{

    Trigger OnPreReport()
    var
        UserSetup: Record "User Setup";
        TxtErrNoAccess: Label 'Sorry, you have NO ACCESS to Customer Detail Trial Balance Report.';
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

