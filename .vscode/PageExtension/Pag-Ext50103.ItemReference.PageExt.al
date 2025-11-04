pageextension 50103 ItemReferenceExntriesExt extends "Item Reference Entries"
{
    layout
    {
        addbefore("Reference Type")
        {
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {

            field(Length; Rec.Length)
            {
                ApplicationArea = All;
            }
            field(Width; Rec.Width)
            {
                ApplicationArea = All;
            }
            field(Height; Rec.Height)
            {
                ApplicationArea = All;
            }
            field(Cubage; Rec.Cubage)
            {
                ApplicationArea = All;
            }
            field(GetDimensionM; Rec.GetDimensionM)
            {
                Caption = 'Dimension (m)';
                ApplicationArea = All;
                DecimalPlaces = 5;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}