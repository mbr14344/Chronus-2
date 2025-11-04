page 50072 PowerBIReports
{
    ApplicationArea = All;
    Caption = 'Power BI Reports';
    PageType = List;
    UsageCategory = ReportsAndAnalysis;
    SourceTable = PowerBIReport;
    layout
    {
        area(Content)
        {
            /*repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    trigger OnDrillDown()
                    begin
                        if (strlen(rec.URL) > 0) then
                            Hyperlink(rec.URL);
                    end;
                }
                field(URL; Rec.URL)
                {
                    ApplicationArea = all;
                }
            }*/
            part("Sales App"; "Power BI Embedded Report Part")
            {
                ApplicationArea = All;
                Caption = 'Sales App';
                SubPageView = where(Context = const('Sales App'));

            }
            part("ItemAvailabilityByEvent"; "Power BI Embedded Report Part")
            {
                ApplicationArea = All;
                Caption = 'ItemAvailabilityByEvent';
                SubPageView = where(Context = const('ItemAvailabilityByEvent'));
            }
            part("Finance App"; "Power BI Embedded Report Part")
            {
                ApplicationArea = All;
                Caption = 'Finance App';
                SubPageView = where(Context = const('Purchase App'));
            }
            part("Inventory App"; "Power BI Embedded Report Part")
            {
                ApplicationArea = All;
                Caption = 'Inventory App';
                SubPageView = where(Context = const('Inventory App'));
            }
            part("Purchase App"; "Power BI Embedded Report Part")
            {
                ApplicationArea = All;
                Caption = 'Inventory App';
                SubPageView = where(Context = const('5'));
            }
            part("Getting Started"; "Power BI Embedded Report Part")
            {
                ApplicationArea = All;
                Caption = 'Inventory App';
                SubPageView = where(Context = const('6'));
            }
        }
    }
    var
        ReportURL: Text;
}
