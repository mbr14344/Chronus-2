pageextension 50090 "GL Entries" extends "SIMC Cash G/L Entries"
{
    //Caption = 'GL Entries', Locked = true, Comment = 'GL Entries';
    DataCaptionExpression = 'GL Entries';



    layout
    {
        Modify("Posting Date")
        {
            Caption = 'Posting Date';
        }
    }

}

