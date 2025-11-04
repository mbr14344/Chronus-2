pageextension 50076 InterCompanyCOAMappingExtPage extends "IC Mapping Chart of Account"
{
    Trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        TxtErrNoAccess: Label 'Sorry, you have NO ACCESS to InterCompany Chart of Accounts Mapping.';
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
