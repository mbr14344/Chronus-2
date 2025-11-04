report 50136 PurchaseQuoteSheetReport
{
    ApplicationArea = All;
    Caption = 'Purchase Quote Sheet Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/ReportLayout/PurchaseQuoteSheetReport.rdl';

    dataset
    {
        dataitem(QuoteSheet; QuoteSheet)
        {
            column(CartonHInch; "Carton H (Inch)")
            {
            }
            column(CartonLInch; "Carton L (Inch)")
            {
            }
            column(CartonWInch; "Carton W (Inch)")
            {
            }
            column(ChinaComment; "China Comment")
            {
            }
            column(ContainerType; "Container Type")
            {
            }
            column(Cube; Cube)
            {
            }
            column(CustomerMargin; "Customer Margin %")
            {
            }
            column(CustomerNo; "Customer No.")
            {
            }
            column(Description; Description)
            {
            }
            column(DomesticMargin; "Domestic Margin %")
            {
            }
            column(DomesticSellPrice; "Domestic Sell Price")
            {
            }
            column(DutyRate; "Duty Rate %")
            {
            }
            column(EstimatedLandedCost; "Estimated Landed Cost")
            {
            }
            column(FOBCost; "FOB Cost")
            {
            }
            column(Factory; Factory)
            {
            }
            column(FactoryFOBCost; "Factory FOB Cost ($)")
            {
            }
            column(FreightRate; "Freight Rate")
            {
            }
            column(GrossWeightGram; "Gross Weight (Gram)")
            {
            }
            column(HTN; HTN)
            {
            }
            column(Image; Picture)
            {
            }
            column(InnerPack; "Inner Pack")
            {
            }
            column(ItemHInch; "Item H (Inch)")
            {
            }
            column(ItemLInch; "Item L (Inch)")
            {
            }
            column(ItemWInch; "Item W (Inch)")
            {
            }
            column(LoadingPort; "Loading Port")
            {
            }
            column(MasterPack; "Master Pack")
            {
            }
            column(MaterialItemSpec; "Material & Item Spec")
            {
            }
            column(NetWeightGram; "Net Weight (Gram)")
            {
            }
            column(ProjectName; "Project Name")
            {
            }
            column(Retail; Retail)
            {
            }
            column(SpecialInstructions; "Special Instructions")
            {
            }
            column(Status; Status)
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column(UNITSPEC; "UNIT SPEC")
            {
            }
            column(USAlbsWeight; "USA lbs. Weight")
            {
            }
            column(VersionNo; "Version No.")
            {
            }
            column(Product_Spec; "Product Spec")
            {
            }
            column(Company; Company.Name)
            {


            }
            trigger OnAfterGetRecord()
            begin
                QuoteSheet.CalcVals();
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        Company: Record Company;
}
