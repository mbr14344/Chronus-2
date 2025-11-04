tableextension 50100 ItemTableExt extends Item
{
    fields
    {
        // Add changes to table fields here\
        modify(GTIN)
        {
            Caption = 'UPC Code';
        }
        modify("Tariff No.")
        {
            trigger OnAfterValidate()
            begin
                Rec.CalcFields("Tariff Description", "Duty Percent", "Tariff Percent");
            end;
        }
        modify("Manufacturer Code")
        {
            Caption = 'Preferred 3PL Code';
        }

        field(50001; "Item Status"; Option)
        {
            OptionMembers = " ","Replenishable","Non-Replenishable","Discontinued";
        }

        field(50003; "Qty on Transfer Orders"; decimal)
        {
            Caption = 'Qty on Transfer Orders';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Transfer Line"."Quantity" WHERE("Item No." = FIELD("No."), "Derived From Line No." = const(0), "Variant Code" = FIELD("Variant Filter")));
        }
        field(50004; "Tariff Description"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Tariff Number".Description WHERE("No." = FIELD("Tariff No.")));
        }
        field(50005; "Duty Percent"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Tariff Number"."Duty Percent" WHERE("No." = FIELD("Tariff No.")));

        }
        field(50006; "Tariff Percent"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Tariff Number"."Tariff Percent" WHERE("No." = FIELD("Tariff No.")));
        }
        field(50007; "User ID"; Code[20])
        {
            Editable = false;
            Caption = 'Modifed By';
        }
        field(50008; CustNoSearch; Code[20])
        {

        }
        field(50009; "License Exist"; Boolean)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist(ItemLicense WHERE("Item No." = Field("No.")));
        }
        field(50010; "Qty. Needed From Ass. Ord."; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
            Caption = 'Qty. Needed From Assembly Orders';
            CalcFormula = sum("Assembly Line"."Remaining Quantity" where("No." = field("No."), Type = Filter('Item')));
        }
        field(50011; "Reserved Qty. On Ass. Lines"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;

            DecimalPlaces = 0 : 5;
            Caption = 'Reserved Qty. On Assembly Lines';

            CalcFormula = - sum("Reservation Entry".Quantity where("Source Type" = const(901),
            "Reservation Status" = filter('Reservation'), "Source Subtype" = const(1), "Item No." = field("No.")));
        }
        field(50012; OverseasQty; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
            Caption = 'Overseas Qty.';
            CalcFormula = sum("Item Ledger Entry"."Remaining Quantity" where("Item No." = field("No."), "Location Code" = filter('OVERSEAS'),
            Open = const(true)));
        }

        field(50015; TemplateApplied; Boolean)
        {
            Caption = 'Template Applied';
            Editable = false;

        }
        field(50016; "Qty on TO Received"; decimal)
        {
            Caption = 'Qty on Transfer Orders - Received';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Transfer Line"."Quantity Received" WHERE("Item No." = FIELD("No."), "Derived From Line No." = const(0), "Variant Code" = FIELD("Variant Filter")));
        }
        field(50017; "Orig Qty on TO"; decimal)
        {
            Caption = 'Orig Qty on Transfer Orders';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Transfer Line"."Quantity" WHERE("Item No." = FIELD("No."), "Derived From Line No." = const(0), "Variant Code" = FIELD("Variant Filter")));
        }
        field(50013; OceanQty; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
            Caption = 'Ocean Qty.';
            CalcFormula = sum("Item Ledger Entry"."Remaining Quantity" where("Item No." = field("No."), "Location Code" = filter('OCEAN'),
            Open = const(true)));
        }
        //PR 2/13/25 - start
        field(50014; Hazard; Boolean)
        {

        }
        //PR 2/13/25 - end
        //PR 2/24/25 - start
        field(50018; "M-Pack Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure"."Qty. per Unit of Measure" where("Item No." = field("No."), Code = const('M-PACK')));
            DecimalPlaces = 0 : 5;

        }
        field(50019; "Inner Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Unit of Measure"."Qty. per Unit of Measure" where("Item No." = field("No."), Code = const('INNER')));
            DecimalPlaces = 0 : 5;
        }
        field(50020; "Medical Device"; Boolean)
        {

        }
        field(50021; Cosmetic; Boolean)
        {

        }
        field(50022; OTC; Boolean)
        {

        }
        //PR 2/24/25 - end
        //MBR 2/25/25 - start
        field(50023; Brand; Code[30])
        {
            Caption = 'Brand';
            TableRelation = "Item Brand";
        }
        field(50024; "Sub-Brand"; Code[30])
        {
            Caption = 'Sub-Brand';
            TableRelation = "Item Sub Brand";
        }
        //mbr 2/25/25 - end

        //pr 4/14/25 - start
        field(50025; "Expiration Date Mandatory"; Boolean)
        {

        }
        //pr 4/14/25 - end
        //9/30/25 - start
        field(50026; "Monday.com URL"; Text[500])
        {
            trigger OnValidate()
            var
                Url: Text[500];
                BoardID: Text[100];
                ItemID: Text[100];
                BoardPos: Integer;
                PulsesPos: Integer;
                SlashPos: Integer;
            begin
                ReadMondayURL();
            end;
        }
        field(50027; "Monday.com BoardID"; Text[100])
        {
            Editable = false;
            Caption = 'Monday.com Board ID';
        }
        field(50028; "Monday.com ItemID"; Text[100])
        {
            Editable = false;
            Caption = 'Monday.com CRD Pulse ID';
        }
        field(50029; InterStateTransferNeeded; Boolean)
        {
            Caption = 'InterState Transfer Needed';
        }
        //9/30/25 - end
        field(50030; "Monday.com PO ItemID"; Text[100])
        {
            Caption = 'Monday.com PO Pulse ID';
        }





    }

    procedure ReadMondayURL()
    var
        Url: Text[500];
        BoardID: Text[100];
        ItemID: Text[100];
        BoardPos: Integer;
        PulsesPos: Integer;
        SlashPos: Integer;
    begin
        Url := Rec."Monday.com URL";
        if StrLen(Url) > 0 then begin
            // Find 'boards/'
            BoardPos := StrPos(Url, 'boards/');
            if BoardPos > 0 then begin
                BoardPos := BoardPos + StrLen('boards/');
                // Find next '/' after boards/
                SlashPos := StrPos(CopyStr(Url, BoardPos, StrLen(Url)), '/');
                if SlashPos > 0 then begin
                    BoardID := CopyStr(Url, BoardPos, SlashPos - 1);
                    // Find 'pulses/' after BoardID
                    PulsesPos := StrPos(Url, 'pulses/');
                    if PulsesPos > 0 then begin
                        PulsesPos := PulsesPos + StrLen('pulses/');
                        // ItemID is everything after pulses/
                        ItemID := CopyStr(Url, PulsesPos, StrLen(Url));
                        // If there is a slash after, trim it
                        SlashPos := StrPos(ItemID, '/');
                        if SlashPos = 0 then
                            Rec."Monday.com ItemID" := ItemID
                        else
                            Rec."Monday.com ItemID" := CopyStr(ItemID, 1, SlashPos - 1);
                    end else
                        Rec."Monday.com ItemID" := '';
                    Rec."Monday.com BoardID" := BoardID;
                end else
                    Rec."Monday.com BoardID" := '';
            end else begin
                Rec."Monday.com BoardID" := '';
                Rec."Monday.com ItemID" := '';
            end;
        end else begin
            Rec."Monday.com BoardID" := '';
            Rec."Monday.com ItemID" := '';
        end;
    end;


    var
        myInt: Integer;

        Loc: Record Location;
        ILE: record "Item Ledger Entry";



    procedure GetNetAvailable() ReturnValue: Decimal
    var
        GetQty: Decimal;
        GetNetQty: Decimal;
    begin
        Loc.Reset();
        Loc.SetRange("Exempt From Current Inv. Calc", true);


        CALCFields(Inventory, "Reserved Qty. on Sales Orders", "Reserved Qty. On Ass. Lines");

        GetNetQty := 0;
        GetNetQty := Rec.Inventory - rec."Reserved Qty. on Sales Orders" - Rec."Reserved Qty. On Ass. Lines";
        GetQty := 0;

        if Loc.FindSet() then  //This will remove qty from ILE that are exempt from Current Avail Calc.  Current Available = Inventory - GetQty below;
            repeat
                ILE.Reset();
                ILE.SetRange("Item No.", "No.");
                ILE.SetRange("Location Code", Loc.Code);
                ILE.SetFilter("Remaining Quantity", '>%1', 0);
                IF ILE.FINDSET then
                    repeat
                        GetQty += ILE."Remaining Quantity";
                    until ILE.NEXT = 0;
            until Loc.Next() = 0;


        GetNetQty := GetNetQty - GetQty;

        exit(GetNetQty);
    end;

    procedure GetCurrentAvailable() ReturnValue: Decimal
    var
        GetQty: Decimal;
        GetNetQty: Decimal;
    begin
        Loc.Reset();
        Loc.SetRange("Exempt From Current Inv. Calc", true);
        CALCFields(Inventory);

        GetNetQty := 0;
        GetNetQty := Rec.Inventory;
        GetQty := 0;

        if Loc.FindSet() then
            repeat
                ILE.Reset();
                ILE.SetRange("Item No.", "No.");
                ILE.SetRange("Location Code", Loc.Code);
                ILE.SetFilter("Remaining Quantity", '>%1', 0);
                IF ILE.FINDSET then
                    repeat
                        GetQty += ILE."Remaining Quantity";
                    until ILE.NEXT = 0;
            until Loc.Next() = 0;


        GetNetQty := GetNetQty - GetQty;

        exit(GetNetQty);
    end;
}