page 50023 "Confirmation Dialog"
{
    //mbr 1/31/24 - start => standard dialog page that pops up when called
    ApplicationArea = All;
    Caption = 'Confirmation';
    PageType = ConfirmationDialog;



    layout
    {

        area(content)
        {
            // gives ok and cancel options
            field("popUpMessage"; popUpMessage)
            {
                ApplicationArea = All;
                Caption = '';
                CaptionClass = popUpMessage;
                Editable = false;
            }

        }
    }
    //sets the popUpMessage
    procedure setMessage(newMessage: Text)
    Begin
        popUpMessage := newMessage.Trim();
    End;
    //sets the Caption
    procedure setInputMessage(newMessage: Text)
    Begin

        inputMessage := newMessage.TrimEnd();
    End;
    //returns inputText
    procedure getInputText(): Text
    begin
        exit(inputText);
    end;


    var
        popUpMessage: Text;
        inputText: Text;
        inputMessage: Text;
    //1/31/24 - end => standard dialog page that pops up when called
}

