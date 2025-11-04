pageextension 50085 PostedAssemblyOrderCard extends "Posted Assembly Order"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
            }

        }
    }
}
