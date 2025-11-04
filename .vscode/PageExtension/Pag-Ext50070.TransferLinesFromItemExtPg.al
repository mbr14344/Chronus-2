pageextension 50070 TransferLinesFromItemExtPg extends "Transfer Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Purchasing Code"; Rec."Purchasing Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Real Time Item Description"; Rec."Real Time Item Description")
            {
                ApplicationArea = All;
            }
        }
        addafter("Unit of Measure")
        {

            field(Status; Rec.Status)
            {
                ApplicationArea = All;
            }
            field(ETD; Rec.ETD)
            {
                ApplicationArea = All;
                ToolTip = 'ETD = Estimate Time of Departure.  This is maintained in the Container Order Card.';
            }
            field(ETA; Rec.ETA)
            {
                ApplicationArea = All;
                ToolTip = 'ETA = Estimate Time of Arrival.  This is maintained in the Container Order Card.';
            }
            field("Actual ETD"; Rec."Actual ETD")
            {
                ApplicationArea = All;
                ToolTip = 'Actual Departure.  This is maintained in the Container Order Card.';
            }
            field("Actual ETA"; Rec."Actual ETA")
            {
                ApplicationArea = All;
                ToolTip = 'Actual Arrival.  This is maintained in the Container Order Card.';
            }

            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
                ApplicationArea = All;
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = All;
            }
            field("Container No."; Rec."Container No.")
            {
                ApplicationArea = All;
            }
            field("Container Size"; Rec."Container Size")
            {
                ApplicationArea = All;
            }
            field("Telex Released"; Rec."Telex Released")
            {
                ApplicationArea = All;
            }
        }
    }

}
