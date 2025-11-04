pageextension 50084 PostedAssemblyOrdersExtPagw extends "Posted Assembly Orders"
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
