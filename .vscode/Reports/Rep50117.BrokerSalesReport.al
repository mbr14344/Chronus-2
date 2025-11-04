report 50117 BrokerSalesReport
{
    ApplicationArea = All;
    Caption = 'Broker Sales Invoice Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    RDLCLayout = './.vscode/ReportLayout/BrokerSalesReport.rdl';
    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            RequestFilterFields = "Sell-to Customer No.", "Posting Date";
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName; "Sell-to Customer Name")
            {
            }
            column(CutNo; "Sell-to Customer No.")
            {
            }
            column(SupplierAlias; Cust."Supplier Alias")
            {
            }
            column(InvoiceNo; "No.")
            {
            }
            column(InvoiceDate; "Posting Date")
            {
            }
            column(OrderDate; "Order Date")
            {
            }
            column(ShipDate; "Shipment Date")
            {
            }
            column(PurchOrderNo; "External Document No.")
            {

            }
            column(Invoice_Discount_Amount; "Invoice Discount Amount")
            {

            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(sellToCustNameLbl; sellToCustNameLbl)
            {
            }
            column(sellToCustNoLbl; sellToCustNoLbl)
            {
            }
            column(noLbl; noLbl)
            {
            }
            column(salesLineNoLbl; salesLineNoLbl)
            {
            }
            column(supplierAliasLbl; supplierAliasLbl)
            {
            }
            column(invoiveNoLbl; invoiveNoLbl)
            {
            }
            column(invoiceDateLbl; invoiceDateLbl)
            {
            }
            column(orderDateLbl; orderDateLbl)
            {
            }
            column(shipDateLbl; shipDateLbl)
            {
            }
            column(purchOrderNoLbl; purchOrderNoLbl)
            {
            }
            column(prodLbl; prodLbl)
            {
            }
            column(itemCodeQualifierLbl; itemCodeQualifierLbl)
            {
            }
            column(prodDescripLbl; prodDescripLbl)
            {
            }
            column(qtyShippedLbl; qtyShippedLbl)
            {
            }
            column(unitOfMeasure; unitOfMeasure)
            {
            }
            column(basePriceLbl; basePriceLbl)
            {
            }
            column(pricingUOMLbl; pricingUOMLbl)
            {
            }
            column(qtyInvoicedLbl; qtyInvoicedLbl)
            {
            }
            column(typeLbl; typeLbl)
            {
            }
            column(RptFilter; RptFilter)
            {

            }
            dataitem("Sales Inv Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(SalesLineNo; "No.")
                {

                }
                column(Type; Type)
                {
                }

                column(Prod; "No.")
                {
                }
                column(ItemCodeQualifer; "Item Reference No.")
                {
                }
                column(ProdDescrip; "Description")
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(UOM; "Unit of Measure")
                {
                }
                column(BasePrice; "Unit Price")
                {
                }
                column(PricingUOM; "Unit of Measure")
                {
                }
                column(QtyInvoice; QtyInvoice)
                {
                }
                column(Line_Discount_Amount; "Line Discount Amount")
                {

                }
                column(Amount; Amount)
                {

                }
                column(DiscountLbl; DiscountLbl)
                {

                }
                column(Amtlbl; Amtlbl)
                {

                }
                trigger OnAfterGetRecord()
                begin
                    QtyInvoice := ROUND("Sales Inv Line".Quantity * "Sales Inv Line"."Unit Price", 0.01, '=');
                    If Cust.Get("Sell-to Customer No.") then;
                end;


            }

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
    trigger OnPreReport()
    begin
        RptFilter := Format(SalesInvoiceHeader.GetFilters());
    end;

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var

        sellToCustNoLbl: Label 'Sell To Customer No.';
        sellToCustNameLbl: Label 'Sell to Customer Name';
        noLbl: Label 'No.';
        salesLineNoLbl: Label 'Sales Line No.';
        CompanyInfo: Record "Company Information";
        supplierAliasLbl: Label 'Supplier Alias';
        invoiveNoLbl: Label 'Invoice No.';
        invoiceDateLbl: Label 'Invoice Date (yyyymmdd)';
        orderDateLbl: Label 'Order Date (yyyymmdd)';
        shipDateLbl: Label 'Ship Date (yyyymmdd)';
        purchOrderNoLbl: Label 'Purchase Order Number';
        prodLbl: Label 'Product/Item';
        itemCodeQualifierLbl: Label 'Item Code Qualifier';
        prodDescripLbl: Label 'Product Description';
        qtyShippedLbl: Label 'Amount';
        unitOfMeasure: Label 'Unit of Measure';
        basePriceLbl: Label 'Base (Price)';
        pricingUOMLbl: Label 'Pricing UOM';
        qtyInvoicedLbl: Label 'Line Amount';
        typeLbl: Label 'Type';
        DiscountLbl: Label 'Line Discount Amount';
        Amtlbl: Label 'Invoiced Amount';

        QtyInvoice: Decimal;
        RptFilter: Text;
        Cust: Record Customer;
}
