pageextension 50125 DetailedCustLedgEntriesExt extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addafter("Entry No.")
        {
            field("Transaction No."; Rec."Transaction No.")
            {
                ApplicationArea = All;
                ToolTip = 'Posting Transaction that ties payment + discount + cash lines.';
                Visible = true;
            }
            field("Applied Cust. Ledger Entry No."; Rec."Applied Cust. Ledger Entry No.")
            {
                ApplicationArea = All;
                ToolTip = 'The other side of the application; for discount rows this points to the invoice CLE.';
                Visible = true;
            }
        }
    }

    actions
    {
        addlast(Navigation)
        {
            action(ShowInvoicesForThisApply)
            {
                ApplicationArea = All;
                Caption = 'Show Invoices (This Apply)';
                Image = List;
                trigger OnAction()
                var
                    Dcle: Record "Detailed Cust. Ledg. Entry";
                    Cle: Record "Cust. Ledger Entry";
                    CleTemp: Record "Cust. Ledger Entry" temporary;
                    ClePage: Page CustLedgerEntryTemp;  // Using temp page - no char limit issues
                    First: Boolean;
                    EntryNoList: List of [Integer];
                    EntryNo: Integer;
                begin
                    if Rec."Transaction No." = 0 then
                        Error('Select a line that belongs to the payment/application (Transaction No. is 0).');
                    //  if (CleTemp.IsTemporary) then
                    // CleTemp.DeleteAll();
                    // Build the list of Invoice CLE Entry Nos from Application lines in the same Transaction No.
                    Dcle.Reset();
                    Dcle.SetRange("Transaction No.", Rec."Transaction No.");
                    Dcle.SetRange("Entry Type", Dcle."Entry Type"::Application);

                    First := true;
                    if Dcle.FindSet() then
                        repeat
                            // Try left side as Invoice
                            Cle.Reset();
                            Cle.SetRange("Entry No.", Dcle."Cust. Ledger Entry No.");
                            Cle.SetRange("Document Type", Cle."Document Type"::Invoice);
                            if Cle.FindFirst() then begin
                                if not EntryNoList.Contains(Cle."Entry No.") then begin
                                    EntryNoList.Add(Cle."Entry No.");
                                    First := false;
                                end;
                            end else begin
                                // Try right side as Invoice
                                Cle.Reset();
                                Cle.SetRange("Entry No.", Dcle."Applied Cust. Ledger Entry No.");
                                Cle.SetRange("Document Type", Cle."Document Type"::Invoice);
                                if Cle.FindFirst() then begin
                                    if not EntryNoList.Contains(Cle."Entry No.") then begin
                                        EntryNoList.Add(Cle."Entry No.");
                                        First := false;
                                    end;
                                end;
                            end;
                        until Dcle.Next() = 0;

                    if First then
                        Error('No invoice entries found for Transaction No. %1.', Rec."Transaction No.");

                    // Open standard CLE page filtered by Entry No.
                    Cle.Reset();
                    foreach EntryNo in EntryNoList do begin
                        Cle.SetRange("Entry No.", EntryNo);
                        if Cle.FindFirst() then begin
                            CleTemp.Init();
                            CleTemp.TransferFields(Cle);
                            if not CleTemp.Insert() then;  // Silently ignore if already exists
                        end;
                    end;

                    PAGE.RunModal(Page::CustLedgerEntryTemp, CleTemp);
                    // Tip: make sure CLE page shows "Pmt. Disc. Given (LCY)" column.
                end;
            }


        }
    }
}
