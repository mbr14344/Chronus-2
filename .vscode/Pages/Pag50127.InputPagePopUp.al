page 50127 InputPagePopUp
{
    ApplicationArea = All;
    Caption = 'InputPagePopUp';
    PageType = ConfirmationDialog;

    layout
    {
        area(Content)
        {
            field(UserDate; UserDate)
            {
                Caption = 'Date';
                ApplicationArea = All;
                Editable = false;
            }
            field(EventType; EventType)
            {
                Caption = 'Event Type';
                ApplicationArea = All;
                Editable = true;
            }
            field(UserText; UserText)
            {
                Caption = '';
                ApplicationArea = All;
                Editable = true;
                CaptionClass = popUpMessage;
            }

        }

    }

    var
        UserText: Text[100];
        UserDate: Date;
        popUpMessage: Text;
        option: Option;
        EventType: Enum CalendarEventType;
        deleted: Boolean;

    procedure GetValues(var Txt: Text; var Dt: Date)
    begin
        Txt := UserText;
    end;

    procedure getInputText(): Text
    begin
        exit(UserText);
    end;

    procedure SetDate(newDate: Date)
    Begin
        UserDate := newDate;
    End;

    procedure GetDate(): Date
    begin
        exit(UserDate);
    end;

    procedure GetDeleted(): Boolean
    begin
        exit(deleted);
    end;

    procedure setMessage(newMessage: Text)
    Begin
        UserText := newMessage.Trim();
    End;

    procedure GetEventType(): Integer
    begin
        exit(EventType);
    end;

    procedure SetEventType(newEventType: Option)
    begin
        EventType := newEventType;
    end;
}
