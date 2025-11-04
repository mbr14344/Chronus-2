pageextension 50013 CustCardPageExt extends "Customer Card"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("Sales Support"; Rec."Sales Support")
            {
                ApplicationArea = all;

            }
        }
        addafter(Name)
        {
            field("Supplier Alias"; Rec."Supplier Alias")
            {
                ApplicationArea = All;
            }
        }
        addafter("Disable Search by Name")
        {
            field("Freight Charge Terms"; Rec.FreightChargeTerm)
            {
                ApplicationArea = All;
            }
            field("GS1SCC Prefix"; Rec.GS1SCCPrefix)
            {
                ApplicationArea = All;
            }
            field("EDI ASN Customer"; Rec."EDI ASN Customer")
            {
                ApplicationArea = All;
            }
            field("EDI order"; Rec."EDI order")
            {
                ApplicationArea = all;
            }
            field("EDI Ship To Mandatory"; Rec."EDI Ship To Mandatory")
            {
                ApplicationArea = all;
            }
            field("EDI Buyer Part Number Mandory"; Rec."EDI Buyer Part Number Mandory")
            {
                ApplicationArea = all;
            }
            //pr 5/15/25 - start
            field("EDI Discount Calcualtion"; Rec."EDI Discount Calcualtion")
            {
                ApplicationArea = all;
            }
            //pr 5/15/25 - end
            field("Enable 945-Package Import"; Rec."Enable 945-Package Import")
            {
                ApplicationArea = all;
            }
            //pr 4/3/25 - start
            field("Exempt from Sales Price Check"; Rec."Exempt from Sales Price Check")
            {
                ApplicationArea = all;
            }
            field(SalesPriceByReqDelDt; Rec.SalesPriceByReqDelDt)
            {
                ApplicationArea = All;
            }
        }
        addafter("Shipping Advice")
        {
            field(PostalCodePrefix; Rec.PostalCodePrefix)
            {
                ApplicationArea = All;
            }
            field(MarketingVendorPrefix; Rec.MarketingVendorPrefix)
            {
                ApplicationArea = All;
            }
            field(MarketingVendorNo; Rec.MarketingVendorNo)
            {
                ApplicationArea = All;
            }
            field(APVendorPrefix; Rec.APVendorPrefix)
            {
                ApplicationArea = All;
            }
            field(APVendorNo; Rec.APVendorNo)
            {
                ApplicationArea = All;
            }
            field(ShipToCodePrefix; Rec.ShipToCodePrefix)
            {
                ApplicationArea = All;
            }

            field(SpecialReferenceCaption; Rec.SpecialReferenceCaption)
            {
                ApplicationArea = All;

            }
            field(PackageLabelStyle; rec.ShippingLabelStyle)
            {
                ApplicationArea = All;
            }
            field(ShippingLabelReportName; Rec.ShippingLabelReportName)
            {
                ApplicationArea = All;
            }

        }
        addbefore(SalesHistSelltoFactBox)
        {
            part(CustoemrContact; CustomerContactFactbox)
            {
                ApplicationArea = All;
                Caption = 'Contact List';
                SubPageLink = "Company Name" = field(Name), "Contact Business Relation" = const("Contact Business Relation"::Customer);
            }
        }
    }
    actions
    {
        addafter("Request Approval")
        {
            // pr 6/14/24 added button to search items by customer
            action(SearchByCustomer)
            {
                ApplicationArea = all;
                Caption = 'Search By Customer';
                Image = CheckList;
                RunObject = Page CustomerSearch;
            }
        }
    }
}
