pageextension 50051 UnitOfMeasurePageExt extends "Units of Measure"
{
    layout
    {
        addafter(Description)
        {
            field("Convert Down Unit"; Rec."Convert Down Unit")
            {
                ApplicationArea = All;
            }
            field("Convert Up Unit"; Rec."Convert Up Unit")
            {
                ApplicationArea = All;
            }
        }

    }
}
