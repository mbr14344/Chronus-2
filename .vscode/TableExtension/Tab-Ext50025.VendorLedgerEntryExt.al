tableextension 50025 VendorLedgerEntryExt extends "Vendor Ledger Entry"
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
        field(50001; "Verified By"; Code[50])
        {
            Caption = 'Verified By';
            TableRelation = User."User Name";
        }
        field(50002; "Hold By"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50003; "Hold Date"; Date)
        {
            Caption = 'Hold Date';
            Editable = false;
        }
        field(50004; "Verified Notes"; Text[2048])
        {
            Caption = 'Verified Notes';
        }
        field(50005; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            FieldClass = FlowField;
            CalcFormula = lookup("Vendor"."Responsibility Center" where("No." = field("Vendor No.")));
        }
        field(50006; "On Hold Vis"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'On Hold';
            // Editable = false;
            trigger OnValidate()
            begin
                rec."Hold By" := USERID;
                rec."Hold Date" := TODAY;
                rec.CalcOnHold();
                rec.Modify();
            end;
        }
        modify("On Hold")
        {
            trigger OnAfterValidate()
            begin
                rec."Hold By" := USERID;
                rec."Hold Date" := TODAY;
                rec.CalcOnHoldVis();
                rec.Modify();
            end;
        }

    }



    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
    procedure CalcOnHoldVis()
    begin
        if (LowerCase(rec."On Hold") = 'yes') then begin
            rec."On Hold Vis" := true;
        end

        else if (LowerCase(rec."On Hold") = 'no') then begin
            rec."On Hold Vis" := false;
        end;
    end;

    procedure CalcOnHold()
    begin
        if (rec."On Hold Vis" = true) then begin
            rec."On Hold" := 'YES';
        end

        else if (rec."On Hold Vis" = false) then begin
            rec."On Hold" := 'NO';
        end;
    end;

    var
        myInt: Integer;
}
