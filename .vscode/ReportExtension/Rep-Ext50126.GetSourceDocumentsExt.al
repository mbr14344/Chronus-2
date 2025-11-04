reportextension 50126 GetSourceDocumentsExt extends "Get Source Documents"
{
    dataset
    {
    }
    procedure GetLastPurchaseHeader(var PurchHeader: Record "Purchase Header")
    begin
        PurchHeader := "Purchase Header";
    end;
}
