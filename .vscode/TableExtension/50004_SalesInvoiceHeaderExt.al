tableextension 50004 "Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(50000; "Cancel Date"; Date)
        {
            Caption = 'Cancel Date';


        }
        field(50001; "Request Ship Date"; Date)
        {
            Caption = 'Request Ship Date';



        }
        field(50002; "Split"; Boolean)
        {
            Caption = 'Split';


        }
        field(50003; "Order Reference"; Text[20])
        {
            Caption = 'Order Reference';


        }
        field(50004; "Flag"; Option)
        {
            Caption = 'Flag';
            OptionMembers = " ","0","Allocated","China Drop Ship","Extension Pending","Issue with PO","Master PO","PO SPLIT","Portal Routed","Pre-Scheduled","Ready for Billing","Routed and Waiting for Product","Scheduled","Scheduled and Waiting for Product","Transfer Pending","Waiting Product","Waiting Sales","Warehouse Processing","Order Canceled","Tendered to BC","Reschedule Pending","Need to schedule","Future Ship Date";
            OptionCaption = ' ,0,Allocated,China Drop Ship,Extension Pending,Issue with PO,Master PO,PO SPLIT,Portal Routed,Pre-Scheduled,Ready for Billing,Routed and Waiting for Product,Scheduled,Scheduled and Waiting for Product,Transfer Pending,Waiting Product,Waiting Sales,Warehouse Processing,Order Canceled,Tendered to BC,Reschedule Pending,Need to schedule,Future Ship Date';
        }
        field(50005; "Start Ship Date"; Date)
        {
            Caption = 'Start Ship Date';

        }
        //pr 1/24/24 added fields for bol 
        field(50006; "Single BOL No."; Code[20])
        {
            Caption = 'Single BOL No.';
        }
        field(50007; "ShipFromAdress"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Address WHERE(Code = field("Location Code")));
        }
        field(50008; "ShipFromCity"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.City WHERE(Code = field("Location Code")));
        }
        field(50009; "ShipFromState"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("SAT Address"."SAT State Code" WHERE(ID = field(SATAddress1)));
        }
        field(50010; "ShipFromContact"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Contact WHERE(Code = field("Location Code")));
        }
        field(50011; "ShipFromPostalCode"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Post Code" WHERE(Code = field("Location Code")));
        }
        field(50012; "ShipFromCountry"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."Country/Region Code" WHERE(Code = field("Location Code")));
        }
        field(50013; "ShipFromName"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name WHERE(Code = field("Location Code")));
        }
        field(50014; "FreightChargeTerm"; Option)
        {
            OptionMembers = " ","Prepaid","Collect","3rd Party";
            Caption = 'Freight Charge Terms';
        }
        field(50015; "BOL Comments"; Text[250])
        {
        }
        field(50016; Type; Text[10])
        {
            Caption = 'Type';
        }
        field(50017; Dept; Text[10])
        {
            Caption = 'Dept';
        }

        field(50018; "CustomerShipToCode"; Code[30])
        {
            Caption = 'Customer Ship-to Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Ship-to Address".CustomerShipToCode WHERE("Code" = field("Ship-to Code")));

        }
        field(50019; "APT Date"; Date)
        {
            Caption = 'APT Date';

        }
        field(50020; "APT Time"; Text[20])
        {
            Caption = 'APT Time';

        }
        field(50021; "Total Package Count"; Decimal)
        {
            Caption = 'Total Package Count';
        }


        field(50022; "Total Weight"; Decimal)
        {
            Caption = 'Total Weight';
        }
        field(50023; "Total Pallet Count"; Decimal)
        {
            Caption = 'Total Pallet Count';
        }
        field(50024; SOCreatedUserID; Code[20])
        {
            Caption = 'SO Created By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50025; CreatedDate; Date)
        {
            Caption = 'SO Created Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50026; Verified; Boolean)
        {
            DataClassification = Customercontent;

        }
        field(50027; "Verified By"; code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50028; "Verified Date"; date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50029; "Modified By"; code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50030; "Modified Date"; date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(50031; Internal; Boolean)
        {

        }

        field(50032; Master; Boolean)
        {
            DataClassification = CustomerContent;
        }
        // pr 10/28/24 - add form field for supplier alias
        field(50033; "Supplier Allias"; code[20])
        {
            Caption = 'Supplier Allias';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Supplier Alias" WHERE("No." = field("Sell-to Customer No.")));
        }
        field(50034; "Customer Responsibility Center"; code[10])
        {
            FieldClass = FlowField;

            CalcFormula = lookup(Customer."Responsibility Center" where("No." = field("Sell-to Customer No.")));
        }

        field(50035; "Order Notes"; Text[255])
        {

        }
        field(50036; "IncludeNonItemWhsePost"; Boolean)
        {
            Caption = 'Include Non-Item Lines on Whse Post';
            DataClassification = CustomerContent;
        }
        //PR 3/17/25 - start
        field(50037; "Customer Salesperson Code"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Salesperson Code" where("No." = field("Sell-to Customer No.")));
        }
        //PR 3/17/25 - end

        field(50038; SATAddress1; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location."SAT Address ID" where(Code = field("Location Code")));
        }
        //pr 6/19/25 - start
        field(50045; "Freight Charge Name"; Text[100])
        {
        }
        field(50046; "Freight Charge Address"; Text[100])
        {
        }
        field(50047; "Freight Charge City"; Text[30])
        {
            TableRelation = if ("Bill-to Country/Region Code" = const('')) "Post Code".City;

        }
        field(50048; "Freight Charge State"; Text[100])
        {
            TableRelation = "Country/Region";
        }
        field(50049; "Freight Charge Zip"; Text[20])
        {
            TableRelation = if ("Sell-to Country/Region Code" = const('')) "Post Code";

        }
        field(50050; "Freight Charge Contact"; Text[100])
        {

        }
        field(50051; "In the Month"; text[20])
        {
            Caption = 'In the Month';
            TableRelation = "InTheMonthOptions"."Code";

        }

    }



    keys
    {
        key(KeyNoSource; "No.", "Sell-to Customer No.", "Order No.")
        {
        }

    }
    //pr 4/24/25 - start
    var
        Currency: Record Currency;
        SalesInvLine: Record "Sales Invoice Line";
        AmountInclVAT: Decimal;
        AmountLCY: Decimal;
        CostLCY: Decimal;
        CustAmount: Decimal;
        InvDiscAmount: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
        Cust: Record Customer;
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TotalAdjCostLCY: Decimal;
        VATAmount: Decimal;
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        AdjProfitLCY: Decimal;
        AdjProfitPct: Decimal;
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        VATPercentage: Decimal;
        VATAmountText: Text[30];
#pragma warning disable AA0074
        Text000: Label 'VAT Amount';
#pragma warning disable AA0470
        Text001: Label '%1% VAT';
        StatsTotalAmount: Decimal;

    procedure CalculateTotals()
    var
        CostCalcMgt: Codeunit "Cost Calculation Management";
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        SalesInvLine.SetRange("Document No.", Rec."No.");
        if SalesInvLine.Find('-') then
            repeat
                CustAmount += SalesInvLine.Amount;
                AmountInclVAT += SalesInvLine."Amount Including VAT";
                if Rec."Prices Including VAT" then
                    InvDiscAmount += SalesInvLine."Inv. Discount Amount" / (1 + SalesInvLine."VAT %" / 100)
                else
                    InvDiscAmount += SalesInvLine."Inv. Discount Amount";
                CostLCY += SalesInvLine.Quantity * SalesInvLine."Unit Cost (LCY)";
                LineQty += SalesInvLine.Quantity;
                TotalNetWeight += SalesInvLine.Quantity * SalesInvLine."Net Weight";
                TotalGrossWeight += SalesInvLine.Quantity * SalesInvLine."Gross Weight";
                TotalVolume += SalesInvLine.Quantity * SalesInvLine."Unit Volume";
                if SalesInvLine."Units per Parcel" > 0 then
                    TotalParcels += Round(SalesInvLine.Quantity / SalesInvLine."Units per Parcel", 1, '>');
                if SalesInvLine."VAT %" <> VATPercentage then
                    if VATPercentage = 0 then
                        VATPercentage := SalesInvLine."VAT %"
                    else
                        VATPercentage := -1;
                TotalAdjCostLCY +=
                  CostCalcMgt.CalcSalesInvLineCostLCY(SalesInvLine) + CostCalcMgt.CalcSalesInvLineNonInvtblCostAmt(SalesInvLine);


            until SalesInvLine.Next() = 0;
    end;

    procedure CalculateGrossTotals() ReutrnVal: Decimal;
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        Currency.Initialize(Rec."Currency Code");

        CalculateTotals();

        VATAmount := AmountInclVAT - CustAmount;
        InvDiscAmount := Round(InvDiscAmount, Currency."Amount Rounding Precision");

        if VATPercentage <= 0 then
            VATAmountText := Text000
        else
            VATAmountText := StrSubstNo(Text001, VATPercentage);

        if Rec."Currency Code" = '' then
            AmountLCY := CustAmount
        else
            AmountLCY :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                WorkDate(), Rec."Currency Code", CustAmount, Rec."Currency Factor");

        CustLedgEntry.SetCurrentKey("Document No.");
        CustLedgEntry.SetRange("Document No.", Rec."No.");
        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
        CustLedgEntry.SetRange("Customer No.", Rec."Bill-to Customer No.");
        if not CustLedgEntry.IsEmpty() then begin
            CustLedgEntry.CalcSums("Sales (LCY)");
            AmountLCY := CustLedgEntry."Sales (LCY)";
        end;

        ProfitLCY := AmountLCY - CostLCY;
        if AmountLCY <> 0 then
            ProfitPct := Round(100 * ProfitLCY / AmountLCY, 0.1);

        AdjProfitLCY := AmountLCY - TotalAdjCostLCY;
        if AmountLCY <> 0 then
            AdjProfitPct := Round(100 * AdjProfitLCY / AmountLCY, 0.1);

        if Cust.Get(Rec."Bill-to Customer No.") then
            Cust.CalcFields("Balance (LCY)")
        else
            Clear(Cust);

        case true of
            Cust."Credit Limit (LCY)" = 0:
                CreditLimitLCYExpendedPct := 0;
            Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0:
                CreditLimitLCYExpendedPct := 0;
            Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1:
                CreditLimitLCYExpendedPct := 10000;
            else
                CreditLimitLCYExpendedPct := Round(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000, 1);
        end;

        SalesInvLine.CalcVATAmountLines(Rec, TempVATAmountLine);
        StatsTotalAmount := CustAmount + InvDiscAmount;
        ReutrnVal := StatsTotalAmount;
    end;
    //pr 4/24/25 - end
    //pr 6/3/25 - start
    procedure GetEDIShipToCode() ReturnVal: code[30]
    var
        ShiptToAddress: Record "Ship-to Address";
        ShipToAddrRef: RecordRef;
        EDIRef: FieldRef;
    begin
        ReturnVal := '--';
        ShiptToAddress.Reset();
        ShiptToAddress.SetRange(Code, rec."Ship-to Code");
        ShiptToAddress.SetRange("Customer No.", rec."Sell-to Customer No.");
        if ShiptToAddress.FindFirst() then begin
            ShipToAddrRef.Open(Database::"Ship-to Address");
            ShipToAddrRef.GetTable(ShiptToAddress);
            ShipToAddrRef.SetRecFilter();
            if (ShipToAddrRef.FindSet()) then begin
                EDIRef := ShipToAddrRef.Field(70010);
                returnVal := EDIRef.Value();
            end;
            ShipToAddrRef.Close();
        end;

    end;

    //pr 6/3/25 - end



}
