pageextension 50072 ChartOfAccountsExtPage extends "Chart of Accounts"
{
    // 9/18/25 - start
    layout
    {
        addafter("Account Category")
        {
            field("Reverse Sign Power BI Custom"; Rec."Reverse Sign Power BI Custom")
            {
                ApplicationArea = All;
                Caption = 'Reverse Sign Power BI Custom';
            }
        }

    }
    // 9/18/25 - end
    Trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        TxtErrNoAccess: Label 'Sorry, you have NO ACCESS to Chart of Accounts.';
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
