pageextension 50098 DetailedVendorLedgEntriesExt extends "Detailed Vendor Ledg. Entries"
{

    layout
    {
        addafter("Entry No.")
        {
            field("Applied Vend. Ledger Entry No."; Rec."Applied Vend. Ledger Entry No.")
            {
                ApplicationArea = All;

            }
        }
    }
}
