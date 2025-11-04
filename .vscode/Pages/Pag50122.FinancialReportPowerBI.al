page 50122 "Financial Report Power BI"
{
    PageType = Document;
    Caption = 'Financial Report - Power BI';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(ReportGuidance)
            {
                Caption = 'Power BI Report';
                Visible = ShowGuidance;
                ShowCaption = false;

                /*    field(GuidanceText; GuidanceMessage)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        Editable = false;
                        Style = AttentionAccent;
                        MultiLine = true;
                    }*/
            }

            part(PowerBIReportPart; "Power BI Embedded Report Part")
            {
                ApplicationArea = All;
                Caption = '';
            }
        }
    }

    /*actions
    {
        area(Processing)
        {
            action(ShowReportInfo)
            {
                ApplicationArea = All;
                Caption = 'Toggle Guidance';
                Image = Info;

                trigger OnAction()
                begin
                    ShowGuidance := not ShowGuidance;
                    CurrPage.Update(false);
                end;
            }

            action(RefreshPowerBI)
            {
                ApplicationArea = All;
                Caption = 'Refresh Power BI';
                Image = Refresh;

                trigger OnAction()
                begin
                    // Refresh the Power BI part
                    CurrPage.PowerBIReportPart.Page.Update(true);
                end;
            }
        }
    }*/

    trigger OnOpenPage()
    begin
        if (ReportName = '') and (WorkspaceName = '') then begin
            ReportName := 'Not Configured';
            WorkspaceName := 'Please configure in Financial Reports';
            GuidanceMessage := 'This report is not configured. Please configure in Financial Reports.';
        end else begin
            GuidanceMessage := StrSubstNo('Loading "%1" report from "%2" workspace...', ReportName, WorkspaceName);
        end;

        ShowGuidance := true;

        // Set up the Power BI context using the correct method
        // SetupPowerBIReport();
    end;



    procedure SetReportDetails(NewReportName: Text[100]; NewWorkspaceName: Text[100]; NewReportUrl: Text)
    begin
        ReportName := NewReportName;
        WorkspaceName := NewWorkspaceName;
        ReportUrl := NewReportUrl;
        UpdateGuidanceMessage();
    end;

    procedure SetReportIds(NewReportName: Text[100]; NewWorkspaceName: Text[100]; NewReportId: Text[50]; NewWorkspaceId: Text[50])
    begin
        ReportName := NewReportName;
        WorkspaceName := NewWorkspaceName;
        ReportId := NewReportId;
        WorkspaceId := NewWorkspaceId;
        ReportUrl := '';
        UpdateGuidanceMessage();

        // Try to set up the report immediately if the page is already loaded
        SetupPowerBIReport();
    end;

    procedure SetupPowerBIReport()
    var
        PowerBIMgt: Codeunit "Power BI Service Mgt.";
        PowerBIDisplayedElement: Record "Power BI Displayed Element";
        ReportGuid: Guid;
        WorkspaceGuid: Guid;
        Context: Code[50];
    begin
        // Validate input
        if (ReportId = '') or (WorkspaceId = '') then begin
            GuidanceMessage := 'Report Id or Workspace Id is empty.';
            exit;
        end;

        if not Evaluate(ReportGuid, ReportId) then begin
            GuidanceMessage := StrSubstNo('Report Id "%1" is not a valid GUID.', ReportId);
            exit;
        end;

        if not Evaluate(WorkspaceGuid, WorkspaceId) then begin
            GuidanceMessage := StrSubstNo('Workspace Id "%1" is not a valid GUID.', WorkspaceId);
            exit;
        end;

        // Use a stable context for this page (PAGE<Id>)
        Context := StrSubstNo('PAGE%1', Page::"Financial Report Power BI");

        // 1) Clear any previous selection for this user/context
        PowerBIDisplayedElement.Reset();
        PowerBIDisplayedElement.SetRange(UserSID, UserSecurityId());
        PowerBIDisplayedElement.SetRange(Context, Context);
        if PowerBIDisplayedElement.FindSet() then
            PowerBIDisplayedElement.DeleteAll();

        // 2) Register the new selection for this user/context
        // /   (Workspace + Report + ElementType = Report)
        PowerBIMgt.AddReportForContext(ReportGuid, Context);

        // 3) Point the embedded part at the same context and refresh it
        CurrPage.PowerBIReportPart.PAGE.SetPageContext(Context);
        CurrPage.Update(false);
        //CurrPage.PowerBIReportPart.PAGE.
        GuidanceMessage :=
          StrSubstNo('Power BI configured: Report %1 in Workspace %2 for context %3.',
                     ReportId, WorkspaceId, Context);

        // Try to get the record created by AddReportForContext
        PowerBIDisplayedElement.Reset();
        PowerBIDisplayedElement.SetRange(UserSID, UserSecurityId());
        PowerBIDisplayedElement.SetRange(Context, Context);
        PowerBIDisplayedElement.SetRange(ElementId, ReportGuid);

        if not PowerBIDisplayedElement.FindFirst() then begin
            // If not found, create it manually
            Clear(PowerBIDisplayedElement);
            PowerBIDisplayedElement.Init();
            PowerBIDisplayedElement.UserSID := UserSecurityId();
            PowerBIDisplayedElement.Context := Context;
            PowerBIDisplayedElement.ElementId := ReportGuid;
            PowerBIDisplayedElement.ElementType := PowerBIDisplayedElement.ElementType::Report;
            PowerBIDisplayedElement.ElementName := ReportName;
            PowerBIDisplayedElement.ElementEmbedUrl := ConstructPowerBIEmbedUrl(ReportId, WorkspaceId);
            PowerBIDisplayedElement.ShowPanesInExpandedMode := false;
            if not PowerBIDisplayedElement.Insert() then
                PowerBIDisplayedElement.Modify();
        end else begin
            // If found but no embed URL, construct it
            if PowerBIDisplayedElement.ElementEmbedUrl = '' then begin
                PowerBIDisplayedElement.ElementEmbedUrl := ConstructPowerBIEmbedUrl(ReportId, WorkspaceId);
                PowerBIDisplayedElement.Modify();
            end;
        end;

        // Now set the properly initialized record to the Power BI page
        Clear(PowerBIARep);
        PowerBIARep.SetDisplayedElement(PowerBIDisplayedElement);
        PowerBIARep.Run();
    end;

    local procedure ConstructPowerBIEmbedUrl(ReportId: Text[50]; WorkspaceId: Text[50]): Text
    var
        company: Record Company;
    begin
        if (company.Get()) then begin
            // Construct the standard Power BI embed URL format
            if (ReportId <> '') and (WorkspaceId <> '') then
                exit(StrSubstNo('https://app.powerbi.com/reportEmbed?reportId=%1&groupId=%2', ReportId, WorkspaceId))
            else
                exit('');
        end;
    end;

    local procedure RefreshPowerBIEmbedUrl()
    var
        PowerBIDisplayedElement: Record "Power BI Displayed Element";
        Context: Text[50];
    begin
        // Try to refresh/get the embed URL from Power BI service
        Context := 'PAGE50122';

        PowerBIDisplayedElement.Reset();
        PowerBIDisplayedElement.SetRange(UserSID, UserSecurityId());
        PowerBIDisplayedElement.SetRange(Context, Context);

        if PowerBIDisplayedElement.FindFirst() then begin
            // If URL is still empty, try to construct it manually
            if PowerBIDisplayedElement.ElementEmbedUrl = '' then begin
                if (ReportId <> '') and (WorkspaceId <> '') then begin
                    PowerBIDisplayedElement.ElementEmbedUrl := ConstructPowerBIEmbedUrl(ReportId, WorkspaceId);
                    PowerBIDisplayedElement.Modify();
                    GuidanceMessage := 'Power BI embed URL constructed manually.';
                end else begin
                    GuidanceMessage := 'Cannot construct embed URL: Report ID or Workspace ID is missing.';
                end;
            end else begin
                GuidanceMessage := 'Power BI embed URL is already available.';
            end;
        end else begin
            GuidanceMessage := 'No Power BI displayed element found. Please set up the report first.';
        end;
    end;

    local procedure UpdateGuidanceMessage()
    begin
        if (ReportName <> '') and (WorkspaceName <> '') then
            GuidanceMessage := StrSubstNo('Configuring "%1" report in "%2" workspace...', ReportName, WorkspaceName)
        else
            GuidanceMessage := 'Report configuration missing.';
    end;

    var
        ReportUrl: Text;
        ReportName: Text[100];
        WorkspaceName: Text[100];
        ReportId: Text[50];
        WorkspaceId: Text[50];
        ShowGuidance: Boolean;
        GuidanceMessage: Text;
        PowerBIARep: Page "Power BI Element Addin Host";
}
