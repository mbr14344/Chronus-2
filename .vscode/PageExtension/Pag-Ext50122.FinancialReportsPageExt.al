pageextension 50122 FinancialReportsPageExt extends "Financial Reports"
{
    layout
    {
        addafter("Financial Report Column Group")
        {
            field("Power BI"; Rec."Power BI")
            {
                ApplicationArea = All;
            }
            field("PBI Report Name"; Rec."PBI Report Name")
            {
                ApplicationArea = All;
            }
            field("PBI Workspace Nfame"; Rec."PBI Workspace Name")
            {
                ApplicationArea = All;
            }
            field("PBI Report Id"; Rec."PBI Report Id")
            {
                ApplicationArea = All;
            }
            field("PBI Workspace Id"; Rec."PBI Workspace Id")
            {
                ApplicationArea = All;
            }
            field("PBI Report URL"; Rec."PBI Report URL")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        modify(ViewFinancialReport)
        {
            Enabled = not UsePBI;
            Visible = true;
        }

        addafter(ViewFinancialReport)
        {
            action(ViewPBIReport)
            {
                Caption = 'View PBI Report';
                ApplicationArea = Basic, Suite;
                Image = PowerBI;
                Visible = true;
                Enabled = UsePBI;
                ToolTip = 'View the selected financial report in Power BI.';

                trigger OnAction()
                var
                    PowerBIPage: Page "Financial Report Power BI";
                    //  PowerBIARep: Page "Power BI Element Addin Host";
                    UrlTxt: Text;
                    WkspIdTxt: Text;
                    RptIdTxt: Text;
                begin
                    // Trim spaces so we don't branch on a whitespace URL
                    UrlTxt := DELCHR(Rec."PBI Report URL", '=', ' ');
                    WkspIdTxt := DELCHR(Rec."PBI Workspace Id", '=', ' ');
                    RptIdTxt := DELCHR(Rec."PBI Report Id", '=', ' ');

                    if (StrLen(WkspIdTxt) > 0) and (StrLen(RptIdTxt) > 0) then
                        GenCU.DisplayPowerBIReport(RptIdTxt, WkspIdTxt, Rec."PBI Report Name");
                    /*   PowerBIPage.SetReportIds(Rec."PBI Report Name", Rec."PBI Workspace Name", RptIdTxt, WkspIdTxt)
                   else if StrLen(UrlTxt) > 0 then
                       PowerBIPage.SetReportDetails(Rec."PBI Report Name", Rec."PBI Workspace Name", UrlTxt)
                   else
                       Error('Fill either PBI Workspace Id + PBI Report Id, or PBI Report URL.');

                   PowerBIPage.Run();*/
                end;
            }
        }
        // Add the promotion reference (this is key!)
        addafter(ViewFinancialReport_Promoted)
        {
            actionref(ViewPBIReport_Promoted; ViewPBIReport) { }
        }
    }


    var
        UsePBI: Boolean;
        GenCU: Codeunit GeneralCU;

    trigger OnAfterGetCurrRecord()
    begin
        UsePBI := Rec."Power BI";
    end;
}