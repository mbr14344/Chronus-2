table 50065 CalendarEvent
{
    Caption = 'Calendar Event';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; UserID; Code[50])
        {
            Caption = 'UserID';
        }
        field(2; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(3; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(4; "Text"; Text[250])
        {
            Caption = 'Text';
        }
        field(5; EntryType; Enum CalendarEventType)
        {
            trigger OnValidate()
            begin
                case EntryType of
                    EntryType::"Person PTO":
                        EntryColor := '#3788d8';
                    EntryType::"Others":
                        EntryColor := '#ff9f00';
                    EntryType::"China official work schedule":
                        EntryColor := '#ff6b6b';
                    EntryType::"Person Remote working":
                        EntryColor := '#4ecdc4';
                    else
                        EntryColor := '#3788d8'; // Default color for unknown types
                end;
            end;
        }
        field(6; EntryColor; Text[20])
        {
        }
    }
    keys
    {
        key(PK; "Date", "Line No")
        {
            Clustered = true;
        }
    }
}
enum 50002 CalendarEventType
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; "China official work schedule") { }
    value(1; "Person PTO") { }
    value(2; "Person Remote working") { }
    value(3; "Others") { }
}


