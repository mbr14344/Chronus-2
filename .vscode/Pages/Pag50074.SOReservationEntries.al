page 50074 "SOReservationEntries"
{
    Caption = 'Sales Order Reservation Entries';
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Reservation Entry";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Reservation Status"; Rec."Reservation Status")
                {
                    ApplicationArea = Reservation;
                    Editable = false;
                    ToolTip = 'Specifies the status of the reservation.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Reservation;
                    Editable = false;
                    ToolTip = 'Specifies the number of the item that has been reserved in this entry.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    Editable = false;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Reservation;
                    Editable = false;
                    ToolTip = 'Specifies the Location of the items that have been reserved in the entry.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    ToolTip = 'Specifies the serial number of the item that is being handled on the document line.';
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        ItemTrackingManagement: Codeunit "Item Tracking Management";
                    begin
                        ItemTrackingManagement.LookupTrackingNoInfo(
                            Rec."Item No.", Rec."Variant Code", "Item Tracking Type"::"Serial No.", Rec."Serial No.");
                    end;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    ToolTip = 'Specifies the lot number of the item that is being handled with the associated document line.';
                    Visible = true;

                    trigger OnDrillDown()
                    var
                        ItemTrackingManagement: Codeunit "Item Tracking Management";
                    begin
                        ItemTrackingManagement.LookupTrackingNoInfo(
                            Rec."Item No.", Rec."Variant Code", "Item Tracking Type"::"Lot No.", Rec."Lot No.");
                    end;
                }
                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    ToolTip = 'Specifies the package number of the item that is being handled with the associated document line.';
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        ItemTrackingManagement: Codeunit "Item Tracking Management";
                    begin
                        ItemTrackingManagement.LookupTrackingNoInfo(
                            Rec."Item No.", Rec."Variant Code", "Item Tracking Type"::"Package No.", Rec."Package No.");
                    end;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Reservation;
                    Editable = false;
                    ToolTip = 'Specifies the date on which the reserved items are expected to enter inventory.';
                    Visible = false;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Reservation;
                    Editable = false;
                    ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
                    Visible = false;
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = Reservation;
                    ToolTip = 'Specifies the quantity of the item that has been reserved in the entry.';

                    trigger OnValidate()
                    begin
                        ReservEngineMgt.ModifyReservEntry(xRec, Rec."Quantity (Base)", Rec.Description, false);
                        QuantityBaseOnAfterValidate();
                    end;
                }

                field("ReservEngineMgt.CreateForText(Rec)"; ReservEngineMgt.CreateForText(Rec))
                {
                    ApplicationArea = Reservation;
                    Caption = 'Reserved For';
                    Editable = false;
                    ToolTip = 'Specifies which line or entry the items are reserved for.';

                    trigger OnDrillDown()
                    begin
                        LookupReservedFromSO();
                    end;
                }
                field(ReservedFrom; ReservEngineMgt.CreateFromText(Rec))
                {
                    ApplicationArea = Reservation;
                    Caption = 'Reserved From';
                    Editable = false;
                    ToolTip = 'Specifies which line or entry the items are reserved from.';

                    trigger OnDrillDown()
                    begin
                        LookupReservedForILE();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Reservation;
                    ToolTip = 'Specifies a description of the reservation entry.';
                    Visible = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Reservation;
                    Editable = false;
                    ToolTip = 'Specifies for which source type the reservation entry is related to.';
                    Visible = false;
                }
                field("Source Subtype"; Rec."Source Subtype")
                {
                    ApplicationArea = Reservation;
                    Editable = false;
                    ToolTip = 'Specifies which source subtype the reservation entry is related to.';
                    Visible = false;
                }
                field("Source ID"; Rec."Source ID")
                {
                    ApplicationArea = Reservation;
                    Editable = false;
                    ToolTip = 'Specifies which source ID the reservation entry is related to.';
                    // Visible = false;
                }
                field("Source Batch Name"; Rec."Source Batch Name")
                {
                    ApplicationArea = Reservation;
                    Editable = false;
                    ToolTip = 'Specifies the journal batch name if the reservation entry is related to a journal or requisition line.';
                    Visible = false;
                }
                field("Source Ref. No."; Rec."Source Ref. No.")
                {
                    ApplicationArea = Reservation;
                    Editable = false;
                    ToolTip = 'Specifies a reference number for the line, which the reservation entry is related to.';
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Reservation;
                    Editable = false;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Reservation;
                    Editable = false;
                    ToolTip = 'Specifies the date on which the entry was created.';
                    Visible = false;
                }
                field("Transferred from Entry No."; Rec."Transferred from Entry No.")
                {
                    ApplicationArea = Reservation;
                    Editable = false;
                    ToolTip = 'Specifies a value when the order tracking entry is for the quantity that remains on a document line after a partial posting.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Reservation;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Reservation;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Reservation;
                }
                field("Start Ship Date"; Rec."Start Ship Date")
                {
                    ApplicationArea = Reservation;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }



    trigger OnModifyRecord(): Boolean
    var
        Result: Boolean;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOnModifyRecord(Rec, xRec, Result, IsHandled);
        if IsHandled then
            exit(Result);

        ReservEngineMgt.ModifyReservEntry(xRec, Rec."Quantity (Base)", Rec.Description, true);
        exit(false);
    end;

    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Customer No.", "External Document No.", "Requested Delivery Date", "Start Ship Date");
    end;

    trigger OnOpenPage()
    begin
        rec.Reset();
        rec.SetRange("Source Type", Database::"Sales Line");
        rec.SetRange("Source Subtype", 1);
        rec.SetRange("Reservation Status", rec."Reservation Status"::Reservation);
    end;

    var
        CancelReservationQst: Label 'Cancel reservation of %1 of item number %2, reserved for %3 from %4?', Comment = '%1 - quantity, %2 - item number, %3 - from table name, %4 - to table name';

    protected var
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";

    local procedure LookupReservedFor()
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.Get(Rec."Entry No.", false);
        LookupReserved(ReservationEntry);
    end;

    local procedure LookupReservedFromSO()
    var
        SalesLine: Record "Sales Line";
        SaleslinePg: Page "Sales Lines";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", rec."Source ID");
        SalesLine.SetRange("Line No.", rec."Source Ref. No.");
        if (SalesLine.FindSet()) then begin
            Clear(SaleslinePg);
            SaleslinePg.SetTableView(SalesLine);
            SalesLinePg.SetRecord(SalesLine);
            SalesLinePg.RunModal();
        end;
    end;

    local procedure LookupReservedForILE()
    var
        itemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntryPg: Page "Item Ledger Entries";
        EntryNo: Integer;
        EntryNoStr: code[20];
        EntryText: Text;
        LastSpacePos: Integer;
        NumberPart: Text;
    begin
        EntryText := ReservEngineMgt.CreateFromText(Rec);

        // Find the last space in the text
        LastSpacePos := StrLen(EntryText);
        while (LastSpacePos > 1) do begin
            if CopyStr(EntryText, LastSpacePos, 1) = ' ' then
                break;
            LastSpacePos -= 1;
        end;

        // Get only the part after the last space
        if LastSpacePos > 1 then begin
            EntryNoStr := CopyStr(EntryText, LastSpacePos + 1);
            if EntryNoStr <> '' then begin
                Evaluate(EntryNo, EntryNoStr);
                itemLedgerEntry.reset;
                itemLedgerEntry.SetRange("Entry No.", EntryNo);
                if itemLedgerEntry.FindSet() then begin
                    Clear(ItemLedgerEntryPg);
                    ItemLedgerEntryPg.SetRecord(itemLedgerEntry);
                    ItemLedgerEntryPg.SetTableView(itemLedgerEntry);
                    ItemLedgerEntryPg.RunModal();
                end;
            end;
        end;
    end;

    local procedure LookupReservedFrom()
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.Get(Rec."Entry No.", true);
        LookupReserved(ReservationEntry);
    end;

    procedure LookupReserved(ReservationEntry: Record "Reservation Entry")
    begin
        OnLookupReserved(ReservationEntry);

        OnAfterLookupReserved(ReservationEntry);
    end;

    protected procedure QuantityBaseOnAfterValidate()
    begin
        CurrPage.Update();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLookupReserved(var ReservEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLookupReserved(var ReservationEntry: Record "Reservation Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnModifyRecord(var ReservEntry: Record "Reservation Entry"; xReservEntry: Record "Reservation Entry"; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCancelReservationOnBeforeConfirm(var ReservEntry: Record "Reservation Entry")
    begin
    end;


}

