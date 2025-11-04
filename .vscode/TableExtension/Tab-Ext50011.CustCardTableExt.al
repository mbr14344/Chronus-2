tableextension 50011 CustCardTableExt extends Customer
{
    fields
    {
        // pr 1/24/24 added field to cust card
        field(50001; "FreightChargeTerm"; Option)
        {
            Caption = 'Freight Charge Terms';
            OptionMembers = " ","Prepaid","Collect","3rd Party";
        }
        // mbr 1/24/24 - Add GetGS1SCCPrefix
        field(50002; GS1SCCPrefix; code[20])
        {
            Caption = 'GS1SCC Prefix';
        }
        field(50003; PostalCodePrefix; code[10])
        {
            Caption = 'Postal Code Prefix';
        }
        field(50004; MarketingVendorPrefix; code[5])
        {
            Caption = 'Marketing Vendor Prefix';
        }
        field(50005; MarketingVendorNo; code[20])
        {
            Caption = 'Marketing Vendor No.';
        }
        field(50006; APVendorPrefix; code[5])
        {
            Caption = 'A/P Vendor Prefix';
        }
        field(50007; APVendorNo; code[20])
        {
            Caption = 'A/P Vendor No';
        }
        field(50008; SpecialReferenceCaption; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Special Reference Caption';
        }
        //mbr 2/3/24 - add Package Report Style
        field(50009; ShippingLabelStyle; CODE[30])
        {
            Caption = 'Shipping Label Style Report';
            // OptionMembers = " ","Default","Pallet","Type 3","Type 4","Type 5","Default Pallet";
            //PR 4/16/25 - convert to user table - start
            TableRelation = ReportLabelStyle."Code";
            //PR 4/16/25 - convert to user table - end
        }
        field(50010; ShipToCodePrefix; code[5])
        {
            Caption = 'Ship-to Code Prefix';
        }
        field(50011; "EDI ASN Customer"; boolean)
        {
            Caption = 'EDI ASN Customer';
        }
        field(50012; "Supplier Alias"; code[10])
        {
            Caption = 'Supplier Alias';

        }
        field(50013; "EDI order"; code[10])
        {
            TableRelation = "Unit of Measure".Code;
        }
        field(50014; "EDI Ship To Mandatory"; Boolean)
        {
        }
        field(50015; "EDI Buyer Part Number Mandory"; Boolean)
        {
        }
        field(50016; "Enable 945-Package Import"; Boolean)
        {
            Caption = 'Enable 945-Package Import';
        }
        field(50017; "Sales Support"; code[30])
        {
            TableRelation = SalesSupport.Code;
        }
        field(50018; "Exempt from Sales Price Check"; Boolean)
        {

        }
        field(50019; ShippingLabelReportName; text[100])
        {
            Caption = 'Shipping Label Type Report Name';
            FieldClass = FlowField;
            CalcFormula = lookup(ReportLabelStyle."Report Name" where(Code = field(ShippingLabelStyle)));

        }
        //pr 5/15/25 - start
        field(50020; "EDI Discount Calcualtion"; Option)
        {
            OptionMembers = " ","Calculate From EDI Unit Price","Calculate from Line Discount";
        }
        //pr 5/15/25 - end

        field(50021; SalesPriceByReqDelDt; Boolean)
        {
            Caption = 'Sales Price by Requested Delivery Date';

        }
    }
}
