pageextension 50078 GeneralLedgerEntriesExtPage extends "General Ledger Entries"
{
    layout
    {
        // Puts the field right after Description in the list
        addafter("Source Type")
        {
            field(Comment; Rec.Comment)
            {
                ApplicationArea = All;
            }
        }
    }
    Trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        TxtErrNoAccess: Label 'Sorry, you have NO ACCESS to General Ledger Entries.';
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
