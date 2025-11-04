tableextension 50028 SalesInvoiceLineExt extends "Sales Invoice Line"
{
    fields
    {
        field(50001; "Your Reference"; Text[35])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."Your Reference" WHERE("No." = field("Document No.")));
        }
        field(50009; "External Document No."; Code[35])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."External Document No." WHERE("No." = field("Document No.")));
        }


        field(50012; "M-Pack Weight"; Decimal)
        {
            Caption = 'M-Pack Weight';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure"."Weight" WHERE("Item No." = field("No."), Code = CONST('M-PACK')));
        }
        field(50011; "M-Pack Qty"; Decimal)
        {
            Caption = 'M-Pack Qty';
            FieldClass = FlowField;

            CalcFormula = lookup("Item Unit of Measure"."Qty. per Unit of Measure" WHERE("Item No." = field("No."), Code = CONST('M-PACK')));
        }
        field(50013; "EDI Sequence Line No."; Integer)
        {
            Caption = 'EDI Sequence Line No.';
        }

        field(50023; ItemNotes; text[255])
        {
            Caption = 'Item Notes';
        }
        field(50024; "Order Reference"; Text[35])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."Order Reference" WHERE("No." = field("Document No.")));
        }
        field(50025; "EDI Inv Line Discount"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 2 : 5;
        }
        field(50026; "SPS EDI Unit Price"; Decimal)
        {
            Editable = false;
            Caption = 'SPS Allowance/Disc. EDI Unit Price';
        }
        field(50027; "Document Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."Document Date" WHERE("No." = field("Document No.")));
        }
        //PR 3/17/25 - start
        field(50037; "Customer Salesperson Code"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Salesperson Code" where("No." = field("Sell-to Customer No.")));
        }
        //PR 3/17/25 - end
        //MBR 6/9/25 -start
        field(50038; "License Exist"; Boolean)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist(ItemLicense WHERE("Item No." = Field("No.")));
        }
        //MBR 6/9/25 - end
        // 8/7/25 - start
        field(50039; "Ship-to County"; Code[30])
        {
            FieldClass = FlowField;
            Caption = 'Ship-to State';
            CalcFormula = lookup("Sales Invoice Header"."Ship-to County" WHERE("No." = field("Document No.")));
        }
        // 8/7/25 - end
    }
    //pr 4/24/25 - start


    procedure CalculateGrossTotalsFromLine() ReturnVal: Decimal
    var
        SalesInvHdr: Record "Sales Invoice Header";
    begin
        SalesInvHdr.Reset();
        SalesInvHdr.SetRange("No.", rec."Document No.");
        if (SalesInvHdr.FindSet()) then begin
            ReturnVal := SalesInvHdr.CalculateGrossTotals();
        end;
    end;
    //pr 4/24/25 - end
    //PR 4/15/25 - start
    procedure GetEdiUnitPriceSPS() returnVal: Decimal
    var
        SalesLineRef: RecordRef;
        EDIUnitPriceRef: FieldRef;
        SalesLineQtyRef: FieldRef;
    begin
        SalesLineRef.Open(Database::"Sales Invoice Line");
        SalesLineRef.GetTable(rec);
        SalesLineRef.SetRecFilter();
        if (SalesLineRef.FindSet()) then begin
            EDIUnitPriceRef := SalesLineRef.Field(70043);
            returnVal := EDIUnitPriceRef.Value();
            //  rec.ediUnitPriceSPS := EDIUnitPrice;
        end;
        SalesLineRef.Close();

    end;
    //PR 4/15/25 - end
}
