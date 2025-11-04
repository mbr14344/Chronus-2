table 60103 SalesPersonCommission
{
    Caption = 'TmpSalesPersonComission';
    DataClassification = ToBeClassified;
    TableType = Temporary;
    fields
    {
        field(1; SalesPersonCode; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser" where(Blocked = const(false));
        }
        field(2; CustNo; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }

        field(3; CustName; Text[100])
        {
            Caption = 'CustName';
            FieldClass = FlowField;
            CalcFormula = lookup("Customer".Name where("No." = field(CustNo)));
        }

        field(4; OriginalInvoiceAmount; Decimal)
        {
            Caption = 'Original Invoice Amount';
            DecimalPlaces = 2;
        }
        field(6; PaidAmount; Decimal)
        {
            Caption = 'Paid Amount';
            DecimalPlaces = 2;
        }
        field(7; InvoiceAmountPaidByCM; Decimal)
        {
            Caption = 'Invoice Amount Paid by CM';
            DecimalPlaces = 2;
        }
        field(8; DocumentNo; Code[20])
        {

        }
    }
    keys
    {
        key(PK; SalesPersonCode, "CustNo", DocumentNo)
        {
            Clustered = true;
        }

    }
}

