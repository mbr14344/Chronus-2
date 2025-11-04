tableextension 50024 PurchasePriceTableExt extends "Purchase Price"
{
    fields
    {
        field(50001; "Rebate Unit Cost"; Decimal)
        {
            Caption = 'Rebate Unit Cost';
            DataClassification = ToBeClassified;
        }
        field(50002; "Reason For Change"; Text[50])
        {
            Caption = 'Reason For Change';
            DataClassification = ToBeClassified;
        }
        field(50003; "User ID"; Code[20])
        {
            Editable = false;
        }
        field(50004; "Last Date Modified"; Date)
        {
            Editable = false;
        }

    }
    keys
    {
        key(MinKey; "Vendor No.", "Item No.", "Minimum Quantity")
        {

        }
    }
    trigger OnAfterInsert()
    var
        GetPurPrice: Record "Purchase Price";
    begin
        GetPurPrice.RESET;
        GetPurPrice.SetRange("Vendor No.", Rec."Vendor No.");
        GetPurPrice.SetRange("Item No.", Rec."Item No.");
        IF GetPurPrice.Count > 1 then begin
            IF STRLEN(Rec."Reason For Change") = 0 then
                Error('You are attempting to enter new Direct Unit Cost.  Please make sure to enter Reason for Change');
        end;
        "User ID" := UserId;
        "Last Date Modified" := Today();
        Modify();
    end;

    trigger OnBeforeModify()
    begin
        "User ID" := UserId;
        "Last Date Modified" := Today();
    end;
}
