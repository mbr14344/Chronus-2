tableextension 50026 CustomerLedgerEntryExt extends "Cust. Ledger Entry"
{
    fields
    {
        field(60100; Comment; Text[250])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;

        }
        field(50000; Internal; boolean)
        {
            Caption = 'Internal';
        }
    }

    //pr 4/28/25 - start
    procedure CalculateGrossTotals() ReturnVal: Decimal
    var
        SalesInvHdr: Record "Sales Invoice Header";
    begin
        ReturnVal := 0;
        if (rec."Document Type" = rec."Document Type"::Invoice) then begin
            SalesInvHdr.Reset();
            SalesInvHdr.SetRange("No.", rec."Document No.");
            if (SalesInvHdr.FindSet()) then begin
                ReturnVal := SalesInvHdr.CalculateGrossTotals();
            end;
        end;
    end;
    //pr 4/28/25 - end
    var
        myInt: Integer;
}
