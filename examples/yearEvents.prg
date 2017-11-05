* Get all events of the current year of the USA calendar

* try with the inclusion and exclusion of Hebrew calendar events
#DEFINE INCLUDE_HEBREW_EVENTS   .F.

DO LOCFILE("us-calendar-events.prg")
#IF INCLUDE_HEBREW_EVENTS
DO LOCFILE("hebrew-calendar-events.prg")
#ENDIF

* we could use GregorianCalendar, it's the same, today
LOCAL USA AS BritishCalendar
LOCAL Year AS Integer
LOCAL DayEvents AS Collection
LOCAL DayEventId AS String

* attach the event processors
m.USA = CREATEOBJECT("BritishCalendar")
IF !m.USA.AttachEventProcessor("usa", "USCalendarEvents")
    MESSAGEBOX("Something went wrong, stepping down...")
    RETURN
ENDIF

#IF INCLUDE_HEBREW_EVENTS
IF !m.USA.AttachEventProcessor("hebrew", "HebrewCalendarEvents")
    MESSAGEBOX("Something went wrong, stepping down...")
    RETURN
ENDIF

* we won't consider hebrew events as observed, they are inserted in the Calendar just for reference
m.USA.EventsProcessors("hebrew").Observed = .F.
#ENDIF

* create a cursor to hold the information
CREATE CURSOR YearEvents (Day D, Observed L, Identifier Varchar(30), CommonName Varchar(80))

* set the events for the year
m.USA.Setevents()

* start with the first day of the year
m.Year = m.USA.Year
m.USA.SetDate(m.Year, 1, 1)

* for the entire year
DO WHILE m.USA.Year = m.Year

    WAIT WINDOW TRANSFORM(m.USA.ToSystem()) NOWAIT

    m.DayEvents = m.USA.DayEvents()
    * there are events related to the day?
    FOR EACH m.DayEventId IN m.DayEvents

        * insert into the cursor
        INSERT INTO YearEvents ;
            VALUES (m.USA.ToSystem(), ;
                        m.USA.CalendarEvents(m.DayEventId).Observed, ;
                        m.DayEventId, ;
                        m.USA.CalendarEvents(m.DayEventId).CommonName)

    ENDFOR

    m.DayEvents = .NULL.

    * step to the next day
    m.USA.DaysAdd(1)
ENDDO

WAIT CLEAR

SELECT YearEvents
GO TOP

BROWSE