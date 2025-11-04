pageextension 50119 UserSettingsList extends "User Settings List"
{

    trigger OnOpenPage();
    var
        UserPermissions: Codeunit "User Permissions";
        User: Record User;
        TxtErrNoAccess: Label 'Sorry, you have NO ACCESS to User Settings.';
    begin
        //9/26/25 - only let user users open - start
        User.Reset();
        User.SETRANGE("User Name", UserId);
        If User.FindFirst() then begin
            IF not UserPermissions.IsSuper(User."User Security ID") then begin
                Error(TxtErrNoAccess);
                CurrPage.Close();

            end
        end;
        //9/26/25 - only let user users open - end
    end;
}
