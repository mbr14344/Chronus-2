page 50051 "FTP Server Setup"
{
    ApplicationArea = All;
    Caption = 'FTP Server Setup';
    PageType = List;
    SourceTable = FTPServer;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Server Name"; Rec."Server Name")
                {
                    ToolTip = 'Specifies the value of the Server Name field.', Comment = '%';
                }
                field(Mode; Rec.Mode)
                {
                    ToolTip = 'Specifies the value of the Mode field.', Comment = '%';
                }
                field(URL; Rec.URL)
                {
                    ToolTip = 'Specifies the value of the URL field.', Comment = '%';
                }
                field(FlowAURL; Rec.FlowAURL)
                {
                    ToolTip = 'Specifies the value of the Flow A URL field.', Comment = '%';
                }
                field(FlowBURL; Rec.FlowBURL)
                {
                    ToolTip = 'Specifies the value of the Flow B URL field.', Comment = '%';
                }
                field(AckDeleteURL; Rec.AckDeleteURL)
                {
                    ToolTip = 'Specifies the value of the Ack Delete URL field.', Comment = '%';
                }
                /*field(FacilityCode; Rec.FacilityCode)
                {
                    ToolTip = 'Specifies the value of the Facility Code field.', Comment = '%';
                }*/
                field(CustomerID; Rec.CustomerID)
                {
                    ToolTip = 'Specifies the value of the Customer ID field.', Comment = '%';
                }
                //PR 2/7/25 - receive 944 from Whitehorse - start
                field("945 Package Info Prefix"; rec."945 Package Info Prefix")
                {

                }
                field("944 Receipt Advice Prefix"; rec."944 Receipt Advice Prefix")
                {

                }
                //PR 2/7/25 - receive 944 from Whitehorse - end
            }
        }
    }
    trigger OnOpenPage()
    var
        User: Record User;
        UserPermissions: Codeunit "User Permissions";
        TxtErrNoAccess: Label 'Sorry, you have NO ACCESS to FTP Server Setup.';
    begin
        //9/26/25 - secure the FTP Server Setup page as we have sensitive info here - start
        User.Reset();
        User.SETRANGE("User Name", UserId);
        If User.FindFirst() then begin
            IF not UserPermissions.IsSuper(User."User Security ID") then begin
                Error(TxtErrNoAccess);
                CurrPage.Close();

            end
        end;
        //9/26/25 - secure the FTP Server Setup page as we have sensitive info here - end
    end;
}
