controladdin "ad_CalendarCtrl"
{
    Scripts =
        '.vscode/scripts/core/main.min.js',
        '.vscode/scripts/daygrid/main.min.js',
        '.vscode/scripts/timegrid/main.min.js',
        '.vscode/scripts/list/main.min.js',
        '.vscode/scripts/bootstrap/main.min.js',
        '.vscode/scripts/interaction/main.min.js';

    StartupScript = '.vscode/scripts/start.js';
    StyleSheets =
        'https://use.fontawesome.com/releases/v5.0.6/css/all.css',
        'https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css',
        '.vscode/scripts/core/main.min.css',
        '.vscode/scripts/daygrid/main.min.css',
        '.vscode/scripts/timegrid/main.min.css',
        '.vscode/scripts/list/main.min.css',
        '.vscode/scripts/bootstrap/main.min.css';

    //9/23/25 - Modified RequestedHeight 
    RequestedHeight = 600;  //- we want to make this 600 so it will show in the cardpart as 4 rows. 320;  
    RequestedWidth = 300;
    MinimumHeight = 180;
    MinimumWidth = 200;
    VerticalShrink = true;
    HorizontalShrink = true;
    VerticalStretch = true;
    HorizontalStretch = true;


    event OnControlAddInReady();
    event Test();
    event CreateEvent(EventText: Text; EventDate: Text; EventType: Text);
    event UpdateEvent(EventText: Text; EventDate: Text; LineNo: Text; EventType: Integer);
    event DeleteEvent(EventDate: Text; LineNo: Text);
    event GetNewInputs(EventDate: Text);
    event Expand();
    event GetUpdatedInputs(EventText: Text; EventDate: Text; LineNo: Text);
    procedure LoadNewInputs(Input: Text; EntryType: Text);
    procedure LoadUpdatedInputs(Input: Text; EventType: Integer);
    procedure LoadDeletedInputs(Input: Text);
    procedure LoadEvents(EventsJson: Text);
    procedure CreateCalendar(isCardPart: Boolean)

}

controladdin "ad_CalendarCtrlPart"
{
    Scripts =
        '.vscode/scripts/core/main.min.js',
        '.vscode/scripts/daygrid/main.min.js',
        '.vscode/scripts/timegrid/main.min.js',
        '.vscode/scripts/list/main.min.js',
        '.vscode/scripts/bootstrap/main.min.js',
        '.vscode/scripts/interaction/main.min.js';

    StartupScript = '.vscode/scripts/start_CardPart.js';
    StyleSheets =
        'https://use.fontawesome.com/releases/v5.0.6/css/all.css',
        'https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css',
        '.vscode/scripts/core/main.min.css',
        '.vscode/scripts/daygrid/main.min.css',
        '.vscode/scripts/timegrid/main.min.css',
        '.vscode/scripts/list/main.min.css',
        '.vscode/scripts/bootstrap/main.min.css';

    RequestedHeight = 600;  //- we want to make this 600 so it will show in the cardpart as 4 rows. 320;
    RequestedWidth = 300;
    MinimumHeight = 600;
    MinimumWidth = 300;
    VerticalShrink = true;
    HorizontalShrink = true;
    VerticalStretch = true;
    HorizontalStretch = true;


    event OnControlAddInReady();
    event Test();
    event CreateEvent(EventText: Text; EventDate: Text; EventType: Text);
    event UpdateEvent(EventText: Text; EventDate: Text; LineNo: Text; EventType: Integer);
    event DeleteEvent(EventDate: Text; LineNo: Text);
    event GetNewInputs(EventDate: Text);
    event Expand();
    event GetUpdatedInputs(EventText: Text; EventDate: Text; LineNo: Text);
    procedure LoadNewInputs(Input: Text; EntryType: Text);
    procedure LoadUpdatedInputs(Input: Text; EventType: Integer);
    procedure LoadDeletedInputs(Input: Text);
    procedure LoadEvents(EventsJson: Text);
    procedure CreateCalendar(isCardPart: Boolean)

}
