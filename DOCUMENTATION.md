# Calendar Documentation

### Overview

Calendar for VFP is a set of classes that handle calendrical information and calculations. There is a base class, named Calendar, from which the actual calendar classes derive (that is, the ones for a specific calendar system, such as Hebrew, or Persian, or Gregorian).

To use a class, include in a project its PRG file and all the hierarchy of dependencies and locale files, up to the base Calendar class. For instance, if you want to use the British Calendar, select BritishCalendar class, and include in your project british-calendar.prg, gregorian-calendar.prg, julian-calendar.prg, julian.xml, and calendar.prg.

If you want to experiment from the Command Window, or from small code snippets, DO the top-level classes in a hierarchy chain (in the above example, `DO LOCFILE("british-calendar.prg")` would be enough).

If you want to keep it simple, just include all PRG and XML files, and any class will be available after DOing its PRG.

At the end of this document there are a few examples to get you started.

### Classes

Presentation order: base classes, then julian and gregorian classes, then alphabetical.

#### Calendar related

| Class | Filename | Dependency | Locale |
| ----- | -------- | ---------- | ------ |
| Calendar | [calendar.prg](calendar.prg "calendar.prg") | | |
| JulianCalendar | [julian-calendar.prg](julian-calendar.prg "julian-calendar.prg") | calendar.prg | [julian.xml](julian.xml "julian.xml") |
| ChristianJulianCalendar | [christian-julian-calendar.prg](christian-julian-calendar.prg "christian-julian-calendar.prg") | julian-calendar.prg | |
| GregorianCalendar | [gregorian-calendar.prg](gregorian-calendar.prg "gregorian-calendar.prg") | julian-calendar.prg | |
| AustrianCalendar | [austrian-calendar.prg](austrian-calendar.prg "austrian-calendar.prg") | gregorian-calendar.prg | |
| BritishCalendar | [british-calendar.prg](british-calendar.prg "british-calendar.prg") | gregorian-calendar.prg | |
| BulgarianCalendar | [bulgarian-calendar.prg](bulgarian-calendar.prg "bulgarian-calendar.prg") | gregorian-calendar.prg | |
| DanishCalendar | [danish-calendar.prg](danish-calendar.prg "danish-calendar.prg") | gregorian-calendar.prg | |
| FrenchCalendar | [french-calendar.prg](french-calendar.prg "french-calendar.prg") | gregorian-calendar.prg | |
| GermanCalendar | [german-calendar.prg](german-calendar.prg "german-calendar.prg") | gregorian-calendar.prg | |
| PrussianCalendar | german-calendar.prg | gregorian-calendar.prg | |
| GreekCalendar | [greek-calendar.prg](greek-calendar.prg "greek-calendar.prg") | gregorian-calendar.prg | |
| HungarianCalendar | [hungarian-calendar.prg](hungarian-calendar.prg "hungarian-calendar.prg") | gregorian-calendar.prg | |
| JapaneseCalendar | [japanese-calendar.prg](japanese-calendar.prg "japanese-calendar.prg") | gregorian-calendar.prg | |
| RomanianCalendar | [romanian-calendar.prg](romanian-calendar.prg "romanian-calendar.prg") | gregorian-calendar.prg | |
| RussianCalendar | [russian-calendar.prg](russian-calendar.prg "russian-calendar.prg") | gregorian-calendar.prg | |
| TurkishCalendar | [turkish-calendar.prg](turkish-calendar.prg "turkish-calendar.prg") | gregorian-calendar.prg | |
| HebrewCalendar | [hebrew-calendar.prg](hebrew-calendar.prg "hebrew-calendar.prg") | calendar.prg | [hebrew.xml](hebrew.xml "hebrew.xml") |
| IslamicCalendar | [islamic-calendar.prg](islamic-calendar.prg "islamic-calendar.prg") | calendar.prg | [islamic.xml](islamic.xml "islamic.xml") |
| PersianCalendar | [persian-calendar.prg](persian-calendar.prg "persian-calendar.prg") | calendar.prg | [persian.xml](persian.xml "persian.xml") |
| RepublicanCalendar | [republican-calendar.prg](republican-calendar.prg "republican-calendar.prg") | calendar.prg | [republican.xml](republican.xml "republican.xml") |

#### Calendar events related

| Class | Filename | Dependency | Definitions |
| ----- | -------- | ---------- | ------ |
| CalendarEvent | [calendar.prg](calendar.prg "calendar.prg") | | |
| CalendarEventProcessor | calendar.prg | | |
| SolarCalendarEvents | [solar-calendar-events.prg](solar-calendar-events.prg "solar-calendar-events.prg") | [gregorian-calendar.prg](gregorian-calendar.prg "gregorian-calendar.prg") | |
| PaschaCalendarEvents | [pascha-calendar-events.prg](pascha-calendar-events.prg "pascha-calendar-events.prg") | gregorian-calendar.prg | |
| DutchCalendarEvents | [dutch-calendar-events.prg](dutch-calendar-events.prg "dutch-calendar-events.prg") | pascha-calendar-events.prg | [nl_events.xml](nl_events.xml "nl_events.xml") |
| PortugueseCalendarEvents | [portuguese-calendar-events.prg](portuguese-calendar-events.prg "portuguese-calendar-events.prg") | pascha-calendar-events.prg | [pt_events.xml](pt_events.xml "pt_events.xml") |
| USCalendarEvents | [us-calendar-events.prg](us-calendar-events.prg "us-calendar-events.prg") | [british-calendar.prg](british-calendar.prg "british-calendar.prg") | [us_events.xml](us_events.xml "us_events.xml") |
| HebrewCalendarEvents | [hebrew-calendar-events.prg](hebrew-calendar-events.prg "hebrew-calendar-events.prg") | [hebrew-calendar.prg](hebrew-calendar.prg "hebrew-calendar.prg") | [hebrew_events.xml](hebrew_events.xml "hebrew_events.xml") |

### Properties

#### Calendar

| Name | Type | Information |
| ---- | ---- | ----------- |
| AdoptionYear, AdoptionMonth and AdoptionDay | N | The date on which the Gregorian reform of the calendar was adopted (only for Gregorian calendars) (defaults to 1582-10-15) |
| CalendarEvents | O | Events set (normally, for the current year). Each event has a unique identifier for access. Collection object. |
| EventsProcessors | O | Attached events processors. Each processor has a unique identifier for access. Collection object. |
| Historical | L | True if the calendar is not in current use, anymore (defaults to .F.) |
| LastJulianYear, LastJulianMonth and LastJuliannDay | N | The eve of the date on which the Gregorian reform of the calendar was adopted (only for Gregorian calendars) (defaults to 1582-10-04) |
| LocaleID | C | An idiom identifier to get names for months, days, and events (defaults to "en") |
| MaxYear, MaxMonth and MaxDay | N | The maximum date in the calendar system (defaults to .NULL.) |
| MinYear, MinMonth and MinDay | N | The minimum date in the calendar system (defualts to 1)|
| Vocabulary | O | Stores the localized calendrical names. A MSXML2.DOMDocument.60 object. |
| VocabularySource | C | The XML source for localized information | 
| Year, Month and Day | N | The current calendar date |

#### CalendarEvent

| Name | Type | Information |
| ---- | ---- | ----------- |
| CommonName | C | A common name for the event (defaults to ""). |
| Duration | N | The number of days that the event lasts (defaults to 1). |
| Fixed | L | Fixed or moveable (defaults to .F.). |
| Identifier | C | Event global identifier |
| Observed | L | Is observed in its scope? (defaults to .F.) |
| Origin | C | Where the event comes from (defaults to "Civil"). |
| Scope | C | Event coverage (defaults to "National"). |
| Year, Month, and Day | N | Event date. |
| YearBegin and YearEnd | N | The years in which the event was applied (defaults to 0, meaning that there are no specified limits). | 

#### CalendarEventProcessor

| Name | Type | Information |
| ---- | ---- | ----------- |
| Broker | O | A broker Calendar object to allow date transformations between differente calendars |
| EventsDefinition | C | An XML document that defines fixed events. | 
| EventsFilter | O | A Collection of selected events that will be included, identified by their global identifier (the value of each member of the collection is the common name of the event). If unset, all events will be returned. |
| Host | O | The calendar object to which the processor is attached. |
| Observed | L | The default status of observance of the events (defaults to .T.) | 
| ReferenceCalendar | O | A Calendar based object, used to perform calendrical calculations performed by the processor. |
| ReferenceCalendarClass | C | The name of the Calendar class (defaults to "Calendar") |
| Scope | C | The default status of observance scope (defaults to "" = unset).

### Methods

#### Calendar

- **`AttachEventProcessor (Identifier AS String, ProcessorClass AS String, ProcessorLibrary AS String) AS Boolean`**
 - Attaches an event processor to calculate events for the calendar object. If the class is not in scope, pass the `m.ProcessorLibrary`, also.
---
- **`Clone () AS Object`**
 - Returns a copy of the object (with the current date).
---
- **`DayEvents () AS Collection`**
 - Returns the collection of event identifiers for the currentc date.
- **`DayEvents (Year AS Number, Month AS Number, Day AS Number) AS Collection`**
 - Returns the collection of event identifiers for a specific day.
---
- **`DaysAdd (Days AS Number)`**
 - Adds a number of days (negative or positive) to the current calendar date (the result sets the new current calendar date)
---
- **`DaysDifference () AS Number`**
 - Returns the difference, in days, between current calendar date and current system date (that is, `DATE()`)
- **`DaysDifference (CalYearOrDate AS Date) AS Number`**
 - Returns the difference, in days, between current calendar date and a Date
- **`DaysDifference (CalYearOrDate AS Calendar) AS Number`**
 - Returns the difference, in days, between current calendar date and the current calendar date of other Calendar object (it may be from a different calendar system)
- **`DaysDifference (CalYearOrDate AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Number`**
 - Returns the difference, in days, between current calendar date and some other calendar date
---
- **`DTOS () AS String`**
 - Returns a string representation of the current date that can be used in index expressions.
---
- **`FromJulian (JulianDate AS Number)`**
 - Sets the current calendar date corresponding to `m.JulianDate` (a Julian Day Number)
---
- **`FromSystem ()`**
 - Sets the current calendar date from the current system date (that is, `DATE()`)
- **`FromSystem (SystemDate AS DateOrDatetime)`**
 - Sets the current calendar date from a `m.SystemDate` (a Date or Datetime value)
---
- **`GetLocale (Term AS String) AS String`**
 - Returns a string for a specific `m.Term` in the locale vocabulary
---
- **`Init ()`**
 - Instantiates a Calendar object (if not `.Historical`, sets the current calendar date to current system date, that is, `DATE()`)
- **`Init (SystemDate AS DateOrDatetime)`**
 - Instantiates a Calendar object, and sets the current calendar to `m.SystemDate`
---
- **`IsAfter|Before|SameDay (CalYearOrDate AS Calendar) AS Boolean`**
 - Returns .T. if the current date is after/before/in the same day of other calendar date.
- **`IsAfter|Before|SameDay (CalYearOrDate AS Date) AS Boolean`**
 - Returns .T. if the current date is after/before/in the same day of a system Date or DateTime.
- **`IsAfter|Before|SameDay (CalYearOrDate AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Boolean`**
 - Returns .T. if the current date is after/before/in the same day of a specific calendar date.
---
- **`IsLeapYear () AS Boolean`**
 - Returns .T. if the current calendar year is a leap year
- **`IsLeapYear (Year AS Number) AS Boolean`**
 - Returns .T. if `m.Year` is a leap year
---
- **`LastDayOfMonth () AS Number`**
 - Returns the last day of the current calendar month
- **`LastDayOfMonth (Year AS Number, Month AS Number) AS Number`**
 - Returns the last day of `m.Month` of `m.Year`
---
- **`LocateEvent (Identifier AS String) AS CalendarEvent`**
 - Locates a calendar event from the collection of set events. Returns `.NULL.` if not found.
---
- **`SetDate (CalYearDateOrEvent AS Calendar)`**
 - Sets the current date to the current date of `m.CalYearDateOrEvent` (this Calendar may be from a different calendar system).
- **`SetDate (CalYearDateOrEvent AS String)`**
 - Sets the current date to the current date of the event identified by `m.CalYearDateOrEvent`. If the event is not set, the current date is not changed.
- **`SetDate (CalYearDateOrEvent AS Integer, CalMonth AS Integer, CalDay AS Integer)`**
 - Sets the current date to YMD passed as arguments (YMD refers to a date in the calendar date system).
---
- **`SetEvents ()`**
 - Set events from the attached event processors, for the current year. `This.CalendarEvents.Count` will hold the number of events set by the processors.
- **`SetEvents (Year AS Number)`**
 - Set events from the attached event processors, for the specified year. `This.CalendarEvents.Count` will hold the number of events set by the processors.
---
- **`SetVocabulary (XMLorURL AS String) AS Boolean`**
 - Sets the vocabulary to be used for localized strings (returns .T. on success). `m.XMLorURL` may be an XML document or a URL to an XML document.
---
- **`SetWeekday (Year AS Integer, Month AS Integer, WeekDay AS Integer, Ordinal AS Integer) AS Boolean`**
 - Sets the date to a specific week day (1 = Monday, 7 = Sunday). `m.Ordinal` indicates the order of the weekday in the month (1 = first = default, 2 = second, up to 5). Returns .T. on success.
---
- **`ToJulian () AS Number`**
 - Returns the Julian Day Number corresponding to the current calendar date
- **`ToJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Number`**
 - Returns the Julian Day Number corresponding to a specific calendar date
---
- **`ToSystem () AS Date`**
 - Returns the current calendar date as a Date value
- **`ToSystem (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Date`**
 - Returns a specific calendar date as a Date value.
---
- **`Weekday () AS Number`**
 - Returns the week day of the current calendar date (assuming the last day(s) of the week is for rest / religious obligations: 1 = Monday, 7 = Sunday)
- **`Weekday (Year AS Integer, Month AS Integer, Day AS Integer) AS Number`**
 - Returns the week day of the calendar date `m.Year`, `m.Month`, `m.Day` (assuming the last day(s) of the week is for rest / religious obligations: 1 = Monday, 7 = Sunday)
---
- **`WeekdayName () AS String`**
 - Returns the week day of the current calendar date
- **`WeekdayName (Year AS Integer, Month AS Integer, Day AS Integer) AS String`**
 - Returns the week day of the calendar date `m.Year`, `m.Month`, `m.Day`
---
- **`_fromJulian (JulianDate AS Number)`**
 - Specific calendar system calculation to transform a Julian Day Number into a calendar date
- **`_toJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Number`**
 - Specific calendar system calculation to transform a calendar date into a Julian Day Number

#### CalendarEventProcessor

- **`GetOption (Option AS String) AS AnyType`**
 - Gets the current setting of an option.
---
- **`Init (Host AS Calendar)`**
 - Sets thehost, default properties, and instantiate the calendar that will serve as reference for calculations/settings.
---
- **`LoadDefinition (XMLorURL AS String, EventsList AS Collection)`**
 - Loads events definition from an XML file or string. The loaded events go into the `m.EventsList` collection. Respects `This.EventsFilter`.
---
- **`SetBroker (Year AS Integer)`**
 - Sets the Broker object, used to negotiate dates with the calendar host.
---
- **`SetDefaultOptions ()`**
 - Set the default value of options.
---
- **`SetEvents () AS Collection`**
 - Set events for the current year of the host Calendar.
- **`SetEvents (Year AS Number) AS Collection`**
 - Set events for the specified year (in the host Calendar system).
---
- **`SetOption (Option AS String, Setting AS AnyType)`**
 - Set an option setting value.


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