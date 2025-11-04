pageextension 50096 FinancialReportsExt extends "Financial Reports"
{
    actions
    {

        modify(EditColumnGroup)
        {
            Enabled = bEditable;
        }
        modify(EditRowGroup)
        {
            Enabled = bEditable;
        }
        modify(Overview)
        {
            Enabled = bEditable;
        }

    }
    trigger OnOpenPage()
    var
        UserPermissions: Codeunit "User Permissions";
        User: Record User;
    begin
        //PR 5/21/25 - start
        bEditable := false;
        User.Reset();
        User.SETRANGE("User Name", UserId);
        If User.FindFirst() then begin
            IF UserPermissions.IsSuper(User."User Security ID") then begin
                bEditable := true;
            end
            else begin
                bEditable := false;
            end;

        end
        else begin
            bEditable := false;
        end;

        //PR 5/21/25 - end

    end;

    var
        bEditable: Boolean;
}
