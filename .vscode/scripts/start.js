//Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('Test', '');
var calendarEl = document.getElementById('controlAddIn');
var isCardPart = false;
var size;
calendarEl.style.fixedWeekCount = true;

//calendarEl.style.minHeight = '200px';
//calendarEl.style.aspectRatio = '1.2'; // Adjust as needed
//ar calendar;
var loadedEvents = [];
var clickTimer = null;
var clickTimerEvent = null;
var input = '';
var EntryType = '';
var eventClicked = false;
var pendingEventInfo = null; // Store the event info while waiting for input
var initialized = false;
// Function to load events from Business Central
window.LoadEvents = function LoadEvents(eventsJson) {
  try {
    // Parse the JSON events from Business Central
    var events = JSON.parse(eventsJson);
    // Sort events by LineNo
    events.sort(function (a, b) {
      var lineNoA = parseInt(getLineNoFromEventId(a.id)) || 0;
      var lineNoB = parseInt(getLineNoFromEventId(b.id)) || 0;
      return lineNoA - lineNoB;
    });

    // Always update loadedEvents variable
    loadedEvents = events;

    if (calendar) {
      // Remove all existing events
      calendar.removeAllEvents();

      // Add the new events from Business Central
      calendar.addEventSource(events);
    }
  } catch (e) {
    console.error('Error parsing events JSON:', e);
    console.error('JSON received:', eventsJson);


  }

}

// function to load new event title from Business Central
window.LoadNewInputs = function LoadNewInputs(inputText, EntryType) {
  input = inputText;
  EntryType = EntryType;
  // alert('***----Input received: ' + input);

  // If we have pending event info, complete the event now
  if (pendingEventInfo) {
    CompleteEvent(pendingEventInfo, input, EntryType);
    pendingEventInfo = null; // Clear the pending info
  }
}

// Function to load updated event title from Business Central
window.LoadUpdatedInputs = function LoadUpdatedInputs(inputText, EventType) {
  input = inputText;
  //alert('***Input received: ' + input);

  // If we have pending event info, complete the event now
  if (pendingEventInfo) {
    UpdateEvent(pendingEventInfo, EventType);
    pendingEventInfo = null; // Clear the pending info
  }
}

// Function to get line number from event ID
function getLineNoFromEventId(eventId) {
  var parts = eventId.split('_');
  return parts.length >= 3 ? parts[2] : '0';
}

// Function to format date for BC
function formatDateForBC(date) {
  const d = new Date(date);
  if (isNaN(d.getTime())) {
    console.error('Invalid date:', date);
    return ''; // always return a string
  }

  // Force UTC and slice out the date part → "YYYY-MM-DD"
  return d.toISOString().slice(0, 10);
}

window.CreateCalendar = function CreateCalendar(cardPart) {
}

/* if (isCardPart) {
   contentSize = 350;
   size = 600;
 }
 else {
   contentSize = 'auto';
   size = 'auto';
 }*/
contentSize = 'auto';
size = 'auto';
//alert('isCardPart: ' + isCardPart + '  offset: ' + calendarEl.offsetHeight + '  parent Size: ' + calendarEl.parentElement?.offsetHeight);


const userTZ = Intl.DateTimeFormat().resolvedOptions().timeZone || 'UTC';

// 2) Detect UI locale for labels (en-US, zh-CN, etc.)
const userLocale = navigator.language || 'en';

// 3) Pick first day of week by region (US = Sunday, most others = Monday)
const firstDay = userLocale.startsWith('en-US') ? 0 : 1;

var
  calendar = new FullCalendar.Calendar(calendarEl, {

    initialView: 'dayGridMonth',
    firstDay: firstDay,
    plugins: ['dayGrid', 'timeGrid', 'list', 'bootstrap', 'interaction'],
    timeZone: userTZ,          // <-- render in the viewer’s local zone
    locale: userLocale,        // <-- localize month/day names
    themeSystem: 'bootstrap',
    customButtons: {
      expand: {
        text: 'Expand',
        click: function () {
          Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('Expand', '');
        }
      }
    },
    header: {
      left: 'prev,next,today' + (isCardPart ? ',expand' : ''),
      center: 'title',
      right: 'dayGridMonth,timeGridWeek,timeGridDay,listMonth'
    },
    weekNumbers: true,
    eventLimit: true, // allow "more" link when too many events
    height: size,
    contentHeight: contentSize,
    fixedWeekCount: true,

    // Custom event ordering by LineNo
    eventOrder: function (a, b) {
      var lineNoA = parseInt(getLineNoFromEventId(a.id)) || 0;
      var lineNoB = parseInt(getLineNoFromEventId(b.id)) || 0;
      return lineNoA - lineNoB;
    },

    // Enable date clicking and event creation
    selectable: true,
    selectMirror: true,
    editable: false, // Disable drag/drop for BC integration
    eventResizableFromStart: false,

    // Use events loaded from Business Central instead of demo events
    events: [loadedEvents],


    // Custom double-click handler
    dateClick: function (info) {
    },

    // Handle double-click on dates only
    dateClick: function (info) {
      if (clickTimer) {
        // second click within time -> double click
        const bcDate = formatDateForBC(info.date);
        var eventDate = formatDateForBC(info.date);
        // var lineNo = getLineNoFromEventId(info.id);
        pendingEventInfo = info; // Store the event info
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('GetNewInputs', [eventDate]);
        clearTimeout(clickTimer);
        clickTimer = null;
        // Don't call CompleteEvent here - let LoadInputs call it when ready
      } else {
        // first click -> wait to see if another follows
        clickTimer = setTimeout(() => {
          // alert("Single click!");
          clickTimer = null;
        }, 250); // 250ms threshold
      }
    },



    // Handle event clicks (edit existing events)
    eventClick: function (info) {
      if (clickTimerEvent) {
        const bcDate = formatDateForBC(info.event.start);
        var eventDate = formatDateForBC(info.event.start);
        var lineNo = getLineNoFromEventId(info.event.id);
        // second click within time -> double click
        pendingEventInfo = info; // Store the event info
        // alert(' event clicked -- (' + info.Date + ') ' + formatDateForBC(info.Date) + ' (' + info.event.Date + ') ' + formatDateForBC(info.event.Date) + "  " + info.event.start + "  " + info.event.end + "  ");
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('GetUpdatedInputs', [info.event.title, eventDate, lineNo]);
        // }
        clearTimeout(clickTimerEvent);
        clickTimerEvent = null;
      }
      else {
        // first click -> wait to see if another follows
        clickTimerEvent = setTimeout(() => {
          // alert("Single click!");
          clickTimerEvent = null;
        }, 250); // 250ms threshold
      }
    }
  });
calendar.render();
calendar.updateSize();
initialized = true;


// After calendar is rendered, load any events that were stored before the calendar was ready
if (loadedEvents.length > 0 && initialized) {
  calendar.addEventSource(loadedEvents);
  console.log('Pre-loaded events added to calendar after render');
}


//updates event with new title or deletes if title is empty
function UpdateEvent(info, EventType) {
  var currentTitle = info.event.title;
  var eventDate = formatDateForBC(info.event.start);
  var lineNo = getLineNoFromEventId(info.event.id);
  if (currentTitle.length > 0) {
    //var newTitle = prompt('-- Edit Event Title:', currentTitle);
    if (input.trim() == '') {
      // Delete event if title is empty
      // Call Business Central to delete the event
      Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('DeleteEvent', [eventDate, lineNo]);

    } else {
      // Update event title
      // Call Business Central to update the event
      Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('UpdateEvent', [input.trim(), eventDate, lineNo, EventType]);
    }
    eventClicked = false;
  }
}

// adds new event with given title on double-click
function CompleteEvent(info, input, EntryType) {
  if (input && input.trim() !== '' && !eventClicked) {
    var eventDate = formatDateForBC(info.date);

    // Try the most common Business Central pattern
    if (typeof window.Microsoft !== 'undefined' &&
      typeof window.Microsoft.Dynamics !== 'undefined' &&
      typeof window.Microsoft.Dynamics.NAV !== 'undefined') {
      try {

        //alert('Creating event: ' + input.trim() + ' for date: ' + info.dateStr);
        //Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CreateEvent', [input.trim(), info.dateStr,EntryType]);
        addEventFromData(input.trim(), info.dateStr, EntryType);
        input = '';
      } catch (e) {
        //    alert('Error with window.Microsoft.Dynamics.NAV:', e);
      }
    } else if (typeof Microsoft !== 'undefined' &&
      typeof Microsoft.Dynamics !== 'undefined' &&
      typeof Microsoft.Dynamics.NAV !== 'undefined') {
      try {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CreateEvent', input.trim(), eventDate);
        input = '';
      } catch (e) {
        // alert('Error with Microsoft.Dynamics.NAV:', e);

      }
    }
  }
}

// Function to add a new event to the calendar
function addEventFromData(title, start, EntryType, options) {
  const eventId = (options && options.id) || 'event_' + Date.now();
  const newEvent = {
    id: eventId,
    title: title,
    start: start      // 'YYYY-MM-DD' or ISO
  };

  if (options) {
    if (options.end) newEvent.end = options.end;       // only if you really need it
    if (options.allDay !== undefined) newEvent.allDay = options.allDay;
    if (options.color) newEvent.color = options.color;
    if (options.textColor) newEvent.textColor = options.textColor;
    if (options.borderColor) newEvent.borderColor = options.borderColor;
  }

  Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CreateEvent', [title, start, EntryType]);
  // Add the event to the calendar
  calendar.addEvent(newEvent);

  return newEvent;
}



// Notify Business Central that the calendar is ready to receive events
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('OnControlAddInReady');


