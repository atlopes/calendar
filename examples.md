# Calendar Documentation

Go to [Overview](DOCUMENTATION.md "Overview")

### Examples

**Display current date**
```foxpro
* display current date in different calendars
LOCAL GC AS GregorianCalendar
LOCAL HC AS HebrewCalendar
LOCAL IC AS IslamicCalendar
LOCAL PC AS PersianCalendar

DO LOCFILE("gregorian-calendar.prg")
DO LOCFILE("hebrew-calendar.prg")
DO LOCFILE("islamic-calendar.prg")
DO LOCFILE("persian-calendar.prg")

m.GC = CREATEOBJECT("GregorianCalendar")
m.HC = CREATEOBJECT("HebrewCalendar")
m.IC = CREATEOBJECT("IslamicCalendar")
m.PC = CREATEOBJECT("PersianCalendar")

? "Today"
? " - in the Gregorian calendar:", CalendarDateFormat(m.GC)
? " - in the Hebrew calendar:", CalendarDateFormat(m.HC)
? " - in the Islamic calendar:", CalendarDateFormat(m.IC)
? " - in the Persian calendar:", CalendarDateFormat(m.PC)

FUNCTION CalendarDateFormat (Cal AS Calendar)

	RETURN TRANSFORM(m.Cal.Day) + ", " + m.Cal.MonthName() + ", " + TRANSFORM(m.Cal.Year)

ENDFUNC
```

**Same date in other calendar**
```foxpro
* first day of 21st century in the Islamic Calendar
LOCAL GC AS GregorianCalendar
LOCAL IC AS IslamicCalendar

DO LOCFILE("gregorian-calendar.prg")
DO LOCFILE("islamic-calendar.prg")

m.GC = CREATEOBJECT("GregorianCalendar")
m.IC = CREATEOBJECT("IslamicCalendar")

m.GC.SetDate(2001, 1, 1)
m.IC.SetDate(m.GC)

? "The first day of the 21st century was on", CalendarDateFormat(m.IC)

FUNCTION CalendarDateFormat (Cal AS Calendar)

	RETURN TRANSFORM(m.Cal.Day) + ", " + m.Cal.MonthName() + ", " + TRANSFORM(m.Cal.Year)

ENDFUNC
```

**Days difference between two dates**
```foxpro
* difference between Shakespeare's and Cervantes' dates of death
LOCAL Shakespeare AS BritishCalendar
LOCAL Cervantes AS GregorianCalendar
LOCAL DaysGap AS Number

DO LOCFILE("british-calendar.prg")

m.Shakespeare = CREATEOBJECT("BritishCalendar")
m.Cervantes = CREATEOBJECT("GregorianCalendar")

* both died on the same April 23rd, 1616, but refering to distinct calendar systems
m.Shakespeare.SetDate(1616, 4, 23)
m.Cervantes.SetDate(1616, 4, 23)

m.DaysGap = m.Cervantes.DaysDifference(m.Shakespeare)

DO CASE
CASE m.DaysGap < 0
	? "Cervantes died " + TRANSFORM(ABS(m.DaysGap)) + " days before Shakespeare did."
CASE m.DaysGap > 0
	? "Cervantes died " + TRANSFORM(m.DaysGap) + " days after Shakespeare did."
OTHERWISE
	? "Cervantes and Shakespeare died in the same day."
ENDCASE
```

**Adoption of the Gregorian Reform**
```foxpro
* the Gregorian reform of the calendar, in different countries

* no need to DO gregorian-calendar, it is implicitly DOne by the first of these
DO LOCFILE("french-calendar.prg")
DO LOCFILE("russian-calendar.prg")
DO LOCFILE("german-calendar.prg")

ReformAdoption("France", CREATEOBJECT("FrenchCalendar"))
ReformAdoption("German catholic states", CREATEOBJECT("GermanCalendar"))
ReformAdoption("Prussia", CREATEOBJECT("PrussianCalendar"))
ReformAdoption("Russia", CREATEOBJECT("RussianCalendar"))

FUNCTION ReformAdoption (Country AS String, Cal AS Calendar)

	m.Cal.SetDate(m.Cal.AdoptionYear, m.Cal.AdoptionMonth, m.Cal.AdoptionDay)
	? "The Gregorian reform was adopted in " + m.Country + " in", CalendarDateFormat(m.Cal)
	
	m.Cal.DaysAdd(-1)
	?? " (the previous day was " + CalendarDateFormat(m.Cal) + ")"

ENDFUNC
	
FUNCTION CalendarDateFormat (Cal AS Calendar)

	RETURN TRANSFORM(m.Cal.Day) + ", " + m.Cal.MonthName() + ", " + TRANSFORM(m.Cal.Year)

ENDFUNC
```

**All the events of a year**
```foxpro
* Get all events of the current year of the USA calendar

* try with the inclusion and exclusion of Hebrew calendar events
#DEFINE INCLUDE_HEBREW_EVENTS	.F.

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
```

**Start of seasons**
```foxpro
* start of seasons in different calendars, for the current year in each calendar

LOCAL GC AS GregorianCalendar
LOCAL HC AS HebrewCalendar
LOCAL IC AS IslamicCalendar

DO LOCFILE("gregorian-calendar.prg")
DO LOCFILE("hebrew-calendar.prg")
DO LOCFILE("islamic-calendar.prg")

DO LOCFILE("solar-calendar-events.prg")

m.GC = CREATEOBJECT("GregorianCalendar")
m.HC = CREATEOBJECT("HebrewCalendar")
m.IC = CREATEOBJECT("IslamicCalendar")

* set the solar events in each calendar
m.GC.AttachEventProcessor("solar", "SolarCalendarEvents")
m.GC.SetEvents()
m.HC.AttachEventProcessor("solar", "SolarCalendarEvents")
m.HC.SetEvents()
m.IC.AttachEventProcessor("solar", "SolarCalendarEvents")
m.IC.SetEvents()

LOCAL SeasonIndex AS Integer
LOCAL ARRAY SeasonIds(4)
LOCAL SeasonId AS String

FOR m.SeasonIndex = 1 TO ALINES(m.SeasonIds, "solar.vequinox,solar.ssolstice,solar.aequinox,solar.wsolstice", 0, ",")

	m.SeasonId = m.SeasonIds(m.SeasonIndex)

	? TEXTMERGE("<<m.GC.CalendarEvents(m.SeasonId).CommonName>> starting in")
	m.GC.SetDate(m.SeasonId)
	? " - Gregorian:", CalendarDateFormat(m.GC)
	m.HC.SetDate(m.SeasonId)
	? " - Hebrew:", CalendarDateFormat(m.HC)
	m.IC.SetDate(m.SeasonId)
	? " - Islamic:", CalendarDateFormat(m.IC)
	?

ENDFOR

FUNCTION CalendarDateFormat (Cal AS Calendar)

    RETURN TRANSFORM(m.Cal.Day) + ", " + m.Cal.MonthName() + ", " + TRANSFORM(m.Cal.Year)

ENDFUNC
```