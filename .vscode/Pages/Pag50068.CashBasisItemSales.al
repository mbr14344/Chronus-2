page 50068 CashBasisItemSales
{
    ApplicationArea = All;
    Caption = 'Cash Basis Item Sales';
    PageType = List;
    SourceTable = "Cash Basis Item Sales";
    UsageCategory = Lists;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    SourceTableView = sorting(CustNo, Type, DatePaid, InvoiceNo, ItemNo);
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(CustNo; Rec.CustNo)
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field(ItemNo; Rec.ItemNo)
                {
                    ApplicationArea = all;
                }
                field(DatePaid; Rec.DatePaid)
                {
                    ApplicationArea = all;
                }
                field(ExtDocNo; Rec.ExtDocNo)
                {
                    ApplicationArea = all;
                }
                field(CustName; Rec.CustName)
                {
                    ApplicationArea = all;
                }
                field(Qty; Rec.Qty)
                {
                    ApplicationArea = all;
                }
                field(SalesPrice; Rec.SalesPrice)
                {
                    ApplicationArea = all;
                }
                field(OriginalAmount; Rec.OriginalAmount)
                {
                    ApplicationArea = all;
                }
                field(PaidAmount; Rec.PaidAmount)
                {
                    ApplicationArea = all;
                }
                field(CashPaidAmount; Rec.CashPaidAmount)
                {
                    ApplicationArea = all;
                }
                field(InvoiceNo; Rec.InvoiceNo)
                {
                    ApplicationArea = all;
                }
                field(OrderNo; Rec.OrderNo)
                {
                    ApplicationArea = all;
                }
                field(InvDiscExists; Rec.InvDiscExists)
                {
                    ApplicationArea = all;
                }

                field(ItemSort; Rec.ItemSort)
                {
                    ApplicationArea = all;
                }
                field(License; Rec.License)
                {
                    ApplicationArea = all;
                }
                field(SubLicense; Rec.SubLicense)
                {
                    ApplicationArea = all;
                }
                field(UOM; Rec.UOM)
                {
                    ApplicationArea = all;
                }
                field(ReturnedAmount; Rec.ReturnedAmount)
                {
                    ApplicationArea = all;
                }
                field(TotalInvoiceLnAmount; Rec.TotalInvoiceLnAmount)
                {
                    ApplicationArea = all;
                }
                field(ReturnedQty; Rec.ReturnedQty)
                {
                    ApplicationArea = all;
                }
                field(FinalInvoiceAmount; Rec.FinalInvoiceAmount)
                {
                    ApplicationArea = all;
                }
                field(FinalQty; Rec.FinalQty)
                {
                    ApplicationArea = all;
                }
                field(CreatedDate; Rec.CreatedDate)
                {
                    ApplicationArea = All;
                }
                field(CreatedBy; Rec.CreatedBy)
                {
                    ApplicationArea = All;
                }
                field(OrigPaidAmount; Rec.OrigPaidAmount)
                {
                    ApplicationArea = all;
                    Visible = false;
                }


            }
        }
    }
}
