pageextension 50082 AssemblyOrdersListPage extends "Assembly Orders"
{
    layout
    {
        addafter("No.")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
