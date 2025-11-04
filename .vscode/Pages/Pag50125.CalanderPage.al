page 50125 "Calendar Page"
{
    PageType = Card;
    Caption = 'Ashtel Calendar';
    UsageCategory = Administration;   //shows up in Tell Me
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            usercontrol(Calendar; ad_CalendarCtrl)
            {
                ApplicationArea = All;
                trigger OnControlAddInReady()
                begin
                    LoadCalendarEvents();
                    // CurrPage."Calendar".CreateCalendar(false);


                end;

                trigger CreateEvent(EventText: Text; EventDate: Text; EventType: Text)
                var
                    DateValue: Date;
                begin
                    Evaluate(DateValue, EventDate);
                    //Message('CreateEvent triggered with: %1, %2', EventText, DateValue);
                    CreateCalendarEvent(EventText, DateValue, EventType);
                end;

                trigger UpdateEvent(EventText: Text; EventDate: Text; LineNo: Text; EventType: Integer)
                var
                    DateValue: Date;
                    lineValue: Integer;
                    EventTypeVal: Integer;

                begin
                    Evaluate(DateValue, EventDate);
                    Evaluate(lineValue, LineNo);
                    UpdateCalendarEvent(EventText, DateValue, lineValue, EventType);
                end;

                trigger DeleteEvent(EventDate: Text; LineNo: Text)
                var
                    lineValue: Integer;
                    DateValue: Date;
                begin
                    Evaluate(DateValue, EventDate);
                    Evaluate(lineValue, LineNo);
                    DeleteCalendarEvent(DateValue, lineValue);
                end;

                trigger GetNewInputs(EventDate: Text)
                var
                    inputText: Text;
                    inputPopUp: Page InputPagePopUp;
                    calendarEvent: Record CalendarEvent;
                    DateValue: Date;
                    LineNo: Integer;

                begin
                    Evaluate(DateValue, EventDate);

                    Clear(inputPopUp);
                    inputPopUp.SetDate(DateValue);
                    inputPopUp.setMessage(txtConfirmation);
                    if inputPopUp.RunModal() = Action::yes then begin
                        inputText := inputPopUp.getInputText();
                        // Message('--Input received: %1', inputText);
                        CurrPage."Calendar".LoadNewInputs(inputText, Format(inputPopUp.GetEventType()));
                    end;
                end;

                trigger GetUpdatedInputs(EventText: Text; EventDate: Text; LineNo: Text)
                var
                    inputText: Text;
                    inputPopUp: Page InputPagePopUp;
                    DateValue: Date;
                    lineValue: Integer;
                    calendarEvent: Record CalendarEvent;
                    eventTypeVal: Integer;
                begin
                    Evaluate(DateValue, EventDate);
                    Evaluate(lineValue, LineNo);
                    // calendarEvent.SetRange(UserID, UserId);
                    calendarEvent.SetRange("Date", DateValue);
                    calendarEvent.SetRange("Line No", lineValue);
                    if not calendarEvent.FindFirst() then
                        exit;
                    Clear(inputPopUp);
                    inputPopUp.SetDate(DateValue);
                    inputPopUp.SetEventType(calendarEvent.EntryType);
                    inputPopUp.setMessage(EventText);
                    if inputPopUp.RunModal() = Action::yes then begin
                        inputText := inputPopUp.getInputText();
                        eventTypeVal := inputPopUp.GetEventType();
                        //    Message('--Input received: %1', inputText);
                        CurrPage."Calendar".LoadUpdatedInputs(inputText, eventTypeVal);
                    end;
                end;

                trigger Expand()
                begin

                end;
            }
        }
    }
    var
        txtConfirmation: Label 'Enter Event Title';

    local procedure CreateCalendarEvent(EventText: Text; EventDate: Date; EventType: Text)
    var
        CalendarEvent: Record CalendarEvent;
        LineNo: Integer;
        EntryTypeVal: Integer;
    begin
        CalendarEvent.Reset();
        // Get the next line number for this user and date
        //  CalendarEvent.SetRange(UserID, UserId);
        CalendarEvent.SetRange("Date", EventDate);
        CalendarEvent.SetAscending("Line No", true);
        if CalendarEvent.FindLast() then
            LineNo := CalendarEvent."Line No" + 1
        else
            LineNo := 1;
        Evaluate(EntryTypeVal, EventType);
        // Create new calendar event record
        CalendarEvent.Init();
        CalendarEvent.UserID := UserId;
        CalendarEvent."Date" := EventDate;
        CalendarEvent."Line No" := LineNo;
        CalendarEvent."Text" := CopyStr(EventText, 1, MaxStrLen(CalendarEvent."Text"));
        CalendarEvent.Validate(EntryType, EntryTypeVal);
        CalendarEvent.Insert(true);

        // Refresh the calendar with new events
        LoadCalendarEvents();
    end;

    local procedure UpdateCalendarEvent(EventText: Text; EventDate: Date; LineNo: Integer; EventType: Integer)
    var
        CalendarEvent: Record CalendarEvent;
    begin
        // CalendarEvent.SetRange(UserID, UserId);
        CalendarEvent.SetRange("Date", EventDate);
        CalendarEvent.SetRange("Line No", LineNo);
        if CalendarEvent.FindFirst() then begin
            CalendarEvent."Text" := CopyStr(EventText, 1, MaxStrLen(CalendarEvent."Text"));
            CalendarEvent.Validate(EntryType, EventType);
            CalendarEvent.Modify(true);
            // Refresh the calendar with updated events
            LoadCalendarEvents();
            // Message('Event updated to "%1"', EventText);
        end;
    end;

    local procedure DeleteCalendarEvent(EventDate: Date; LineNo: Integer)
    var
        CalendarEvent: Record CalendarEvent;
    begin
        // CalendarEvent.SetRange(UserID, UserId);
        CalendarEvent.SetRange("Date", EventDate);
        CalendarEvent.SetRange("Line No", LineNo);
        if CalendarEvent.FindFirst() then begin
            CalendarEvent.Delete(true);
            // Refresh the calendar after deletion
            LoadCalendarEvents();
            //    Message('Event deleted');
        end;
    end;



    local procedure LoadCalendarEvents()
    var
        CalendarEvent: Record CalendarEvent;
        EventsJson: Text;
        EventJson: Text;
        DateText: Text;
    begin
        CalendarEvent.Reset();
        EventsJson := '[';
        // CalendarEvent.SetRange(UserID, UserId);
        if CalendarEvent.FindSet() then begin
            repeat
                if EventsJson <> '[' then
                    EventsJson += ',';

                // Format date as YYYY-MM-DD
                DateText := Format(CalendarEvent."Date", 0, '<Year4>-<Month,2>-<Day,2>');

                // Escape quotes in the text field and create JSON
                EventJson := StrSubstNo('{"id":"%1_%2_%3","title":"%4","start":"%5","allDay":true,"color":"%6"}',
                    CalendarEvent.UserID,
                    DateText,
                    Format(CalendarEvent."Line No"),
                    CalendarEvent."Text",
                    DateText,
                    CalendarEvent.EntryColor);

                EventsJson += EventJson;
            until CalendarEvent.Next() = 0;
        end;
        EventsJson += ']';

        CurrPage."Calendar".LoadEvents(EventsJson);
        CurrPage."Calendar".CreateCalendar(false);
    end;
}