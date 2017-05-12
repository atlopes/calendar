# Calendar Documentation

### Overview

Calendar for VFP is a set of classes that handle calendrical information and calculations. There is a base class, named Calendar, from which the actual calendar classes derive (that is, the ones for a specific calendar system, such as Hebrew, or Persian, or Gregorian).

To use a class, include in a project its PRG file and all the hierarchy of dependencies and locale files, up to the base Calendar class. For instance, if you want to use the British Calendar, select BritishCalendar class, and include in your project british-calendar.prg, gregorian-calendar.prg, julian-calendar.prg, julian.xml, and calendar.prg.

If you want to experiment from the Command Window, or from small code snippets, DO the top-level classes in a hierarchy chain (in the above example, `DO LOCFILE("british-calendar.prg")` would be enough).

If you want to keep it simple, just include all PRG and XML files, and any class will be available after DOing its PRG.

At the end of this document there are a few [examples](#examples) to get you started.

| Class | Filename | Dependency | Locale |
| ----- | -------- | ---------- | ------ |
| Calendar | Calendar.prg | | |
| JulianCalendar | julian-calendar.prg | calendar.prg | julian.xml |
| ChristianJulianCalendar | christian-julian-calendar.prg | julian-calendar.prg | |
| GregorianCalendar | gregorian-calendar.prg | julian-calendar.prg | |
| AustrianCalendar | austrian-calendar.prg | gregorian-calendar.prg | |
| BulgarianCalendar | bulgarian-calendar.prg | gregorian-calendar.prg | |
| DanishCalendar | danish-calendar.prg | gregorian-calendar.prg | |
| FrenchCalendar | french-calendar.prg | gregorian-calendar.prg | |
| GermanCalendar | german-calendar.prg | gregorian-calendar.prg | |
| PrussianCalendar | german-calendar.prg | gregorian-calendar.prg | |
| GreekCalendar | greek-calendar.prg | gregorian-calendar.prg | |
| HungarianCalendar | hungarian-calendar.prg | gregorian-calendar.prg | |
| JapaneseCalendar | japanese-calendar.prg | gregorian-calendar.prg | |
| RomanianCalendar | romanian-calendar.prg | gregorian-calendar.prg | |
| RussianCalendar | russian-calendar.prg | gregorian-calendar.prg | |
| TurkishCalendar | turkish-calendar.prg | gregorian-calendar.prg | |
| HebrewCalendar | hebrew-calendar.prg | calendar.prg | hebrew.xml |
| IslamicCalendar | islamic-calendar.prg | calendar.prg | islamic.xml |
| PersianCalendar | persian-calendar.prg | calendar.prg | persian.xml |
| RepublicanCalendar | republican-calendar.prg | calendar.prg | republican.xml |

### Properties

| Name | Type | Information |
| ---- | ---- | ----------- |
| AdoptionYear, AdoptionMonth and AdoptionDay | N | The date on which the Gregorian reform of the calendar was adopted (only for Gregorian calendars) (defaults to 1582-10-15) |
| Historical | L | True if the calendar is not in current use, anymore (defaults to .F.) |
| LastJulianYear, LastJulianMonth and LastJuliannDay | N | The eve of the date on which the Gregorian reform of the calendar was adopted (only for Gregorian calendars) (defaults to 1582-10-04) |
| LocaleID | C | An idiom identifier to get names for months, days, and events (defaults to "en") |
| MaxYear, MaxMonth and MaxDay | N | The maximum date in the calendar system (defaults to .NULL.) |
| MinYear, MinMonth and MinDay | N | The minimum date in the calendar system (defualts to 1)|
| Vocabulary | O | Stores the localized calendrical names (a MSXML2.DOMDocument.60 object) |
| VocabularySource | C | The XML source for localized information | 
| Year, Month and Day | N | The current calendar date |

### Methods

- **`DaysAdd (Days AS Number)`**
-- Adds a number of days (negative or positive) to the current calendar date (the result sets the new current calendar date)
- **`DaysDifference () AS Number`**
-- Returns the difference, in days, between current calendar date and current system date (that is, `DATE()`)
- **`DaysDifference (CalYearOrDate AS Date) AS Number`**
-- Returns the difference, in days, between current calendar date and a Date
- **`DaysDifference (CalYearOrDate AS Calendar) AS Number`**
-- Returns the difference, in days, between current calendar date and the current calendar date of other Calendar object (it may be from a different calendar system)
- **`DaysDifference (CalYearOrDate AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Number`**
-- Returns the difference, in days, between current calendar date and some other calendar date
- **`FromJulian (JulianDate AS Number)`**
-- Sets the current calendar date corresponding to `m.JulianDate` (a Julian Day Number)
- **`FromSystem ()`**
-- Sets the current calendar date from the current system date (that is, `DATE()`)
- **`FromSystem (SystemDate AS DateOrDatetime)`**
-- Sets the current calendar date from a `m.SystemDate` (a Date or Datetime value)
- **`GetLocale (Term AS String) AS String`**
-- Returns a string for a specific `m.Term` in the locale vocabulary
- **`Init ()`**
-- Instantiates a Calendar object (if not `.Historical`, sets the current calendar date to current system date, that is, `DATE()`)
- **`Init (SystemDate AS DateOrDatetime)`**
-- Instantiates a Calendar object, and sets the current calendar to `m.SystemDate`
- **`IsLeapYear () AS Boolean`**
-- Returns .T. if the current calendar year is a leap year
- **`IsLeapYear (Year AS Number) AS Boolean`**
-- Returns .T. if `m.Year` is a leap year
- **`LastDayOfMonth () AS Number`**
-- Returns the last day of the current calendar month
- **`LastDayOfMonth (Year AS Number, Month AS Number) AS Number`**
-- Returns the last day of `m.Month` of `m.Year`
- **`SetDate (CalYearDate AS Calendar)`**
-- Sets the current date to the current date of `m.CalendarDate` (this Calendar may be from a different calendar system).
- **`SetDate (CalYearDate AS Integer, CalMonth AS Integer, CalDay AS Integer)`**
-- Sets the current date to YMD passed as arguments (YMD refers to a date in the calendar date system).
- **`SetVocabulary (XMLorURL AS String) AS Boolean`**
-- Sets the vocabulary to be used for localized strings (returns .T. on success). `m.XMLorURL` may be an XML document or a URL to an XML document.
- **`ToJulian () AS Number`**
-- Returns the Julian Day Number corresponding to the current calendar date
- **`ToJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Number`**
-- Returns the Julian Day Number corresponding to a specific calendar date
- **`ToSystem () AS Date`**
-- Returns the current calendar date as a Date value
- **`Weekday () AS Number`**
-- Returns the week day of the current calendar date (assuming the last day(s) of the week is for rest / religious obligations: 1 = Monday, 7 = Sunday)
- **`Weekday (Year AS Integer, Month AS Integer, Day AS Integer) AS Number`**
-- Returns the week day of the calendar date `m.Year`, `m.Month`, `m.Day` (assuming the last day(s) of the week is for rest / religious obligations: 1 = Monday, 7 = Sunday)
- **`WeekdayName () AS String`**
-- Returns the week day of the current calendar date
- **`WeekdayName (Year AS Integer, Month AS Integer, Day AS Integer) AS String`**
-- Returns the week day of the calendar date `m.Year`, `m.Month`, `m.Day`
- **`_fromJulian (JulianDate AS Number)`**
-- Specific calendar system calculation to transform a Julian Day Number into a calendar date
- **`_toJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Number`**
-- Specific calendar system calculation to transform a calendar date into a Julian Day Number

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
