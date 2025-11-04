page 50073 ItemDemandPlan
{
    ApplicationArea = All;
    Caption = 'Item Demand Plan Power BI Report';
    PageType = List;
    SourceTable = Item;
    UsageCategory = ReportsAndAnalysis;
    layout
    {
        area(Content)
        {
            part("ItemAvailabilityByEvent"; "Power BI Embedded Report Part")
            {
                ApplicationArea = All;
                Caption = 'ItemAvailabilityByEvent';
                SubPageView = where(Context = const('ItemAvailabilityByEvent'));
            }
        }
    }
}
