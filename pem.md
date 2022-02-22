# CalendarCalc Documentation

Go to [Overview](DOCUMENTATION.md "Overview")

See also [Classes](classes.md "Classes").

## Properties ##

### CalendarCalc ###

| Name | Type | Information |
| ---- | ---- | ----------- |
| AdoptionYear, AdoptionMonth and AdoptionDay | N | The date on which the Gregorian reform of the calendar was adopted (only for Gregorian calendars) (defaults to 1582-10-15) |
| CalendarEvents | O | Events set (normally, for the current year). Each event has a unique identifier for access. Collection object. |
| EventsProcessors | O | Attached events processors. Each processor has a unique identifier for access. Collection object. |
| Historical | L | True if the calendar is not in current use, anymore (defaults to .F.) |
| Invalid | N | Numeric code explaining why a date is invalid (0 = valid) |
| LastJulianYear, LastJulianMonth and LastJuliannDay | N | The eve of the date on which the Gregorian reform of the calendar was adopted (only for Gregorian calendars) (defaults to 1582-10-04) |
| LocaleID | C | An idiom identifier to get names for months, days, and events (defaults to "en") |
| MaxYear, MaxMonth and MaxDay | N | The maximum date in the calendar system (defaults to .NULL.) |
| MinYear, MinMonth and MinDay | N | The minimum date in the calendar system (defaults to 1)|
| Vocabulary | O | Stores the localized calendrical names. A MSXML2.DOMDocument.60 object. |
| VocabularySource | C | The XML source for localized information | 
| WeekStart | N | The day that starts a week (1 = Monday, 7 = Sunday); informational. | 
| Year, Month and Day | N | The current calendar date |

### CalendarEvent ###

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

### CalendarEventProcessor ###

| Name | Type | Information |
| ---- | ---- | ----------- |
| Broker | O | A broker CalendarCalc object to allow date transformations between differente calendars |
| EventsDefinition | C | An XML document that defines fixed events. | 
| EventsFilter | O | A Collection of selected events that will be included, identified by their global identifier (the value of each member of the collection is the common name of the event). If unset, all events will be returned. |
| Host | O | The calendar object to which the processor is attached. |
| Observed | L | The default status of observance of the events (defaults to .T.) | 
| ReferenceCalendar | O | A CalendarCalc based object, used to perform calendrical calculations performed by the processor. |
| ReferenceCalendarClass | C | The name of the CalendarCalc class (defaults to "CalendarCalc") |
| Scope | C | The default status of observance scope (defaults to "" = unset).

## Methods ##

### Calendar ###

- **`AttachEventProcessor (Identifier AS String, ProcessorClass AS String, ProcessorLibrary AS String) AS Boolean`**
 - Attaches an event processor to calculate events for the calendar object. If the class is not in scope, pass the `m.ProcessorLibrary`, also.
---
- **`Cleanup ()`**
 - Clean up tasks.
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
- **`DaysDifference (CalYearOrDate AS CalendarCalc) AS Number`**
 - Returns the difference, in days, between current calendar date and the current calendar date of other Calendar object (it may be from a different calendar system)
- **`DaysDifference (CalYearOrDate AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Number`**
 - Returns the difference, in days, between current calendar date and some other calendar date
---
- **`DetachEventProcessor (Identifier AS String)`**
 - Detaches an event processor.
---
- **`DTOS () AS String`**
 - Returns a string representation of the current date that can be used in index expressions.
---
- **`EventsToCursor (CursorName AS String)`**
 - Creates a cursor image of the collection of events (`m.CursorName` is closed and created in each call to the method).
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
- **`IsAfter|Before|SameDay (CalYearOrDate AS CalendarCalc) AS Boolean`**
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
- **`MonthName ()`**
 - Returns the name of the month of the current calendar date
- **`MonthName (Month AS Number)`**
 - Returns the name of the month 
- **`MonthName (Month AS Number, Year AS Number)`**
 - Returns the name of the month of a specific year
- **`MonthName (Month AS Number, Year AS Number, ShortName AS Logical)`**
 - Returns the name of the month of a specific year, short version
---
- **`MonthsAdd (Months AS Number)`**
 - Adds a number of months (negative or positive) to the current calendar date (the result sets the new current calendar date)
---
- **`SetDate (CalYearDateOrEvent AS CalendarCalc)`**
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
- **`Validate (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Date`**
 - Validates a date (returns true if valid). A code explaining the reason for an invalid date is stored in the `Invalid` property.
---
- **`Weekday () AS Number`**
 - Returns the week day of the current calendar date (assuming the last day(s) of the week is for rest / religious obligations: 1 = Monday, 7 = Sunday)
- **`Weekday (Year AS Integer, Month AS Integer, Day AS Integer) AS Number`**
 - Returns the week day of the calendar date `m.Year`, `m.Month`, `m.Day` (assuming the last day(s) of the week is for rest / religious obligations: 1 = Monday, 7 = Sunday)
---
- **`WeekdayName () AS String`**
 - Returns the name of the week day of the current calendar date
- **`WeekdayName (Year AS Integer, Month AS Integer, Day AS Integer) AS String`**
 - Returns the name of the week day of the calendar date `m.Year`, `m.Month`, `m.Day`
- **`WeekdayName (Year AS Integer, Month AS Integer, Day AS Integer, ShortName AS Logical) AS String`**
 - Returns the short name of the week day of the calendar date `m.Year`, `m.Month`, `m.Day`
---
- **`YearsAdd (Years AS Number)`**
 - Adds a number of years (negative or positive) to the current calendar date (the result sets the new current calendar date)
---
- **`_fromJulian (JulianDate AS Number)`**
 - Specific calendar system calculation to transform a Julian Day Number into a calendar date
- **`_toJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Number`**
 - Specific calendar system calculation to transform a calendar date into a Julian Day Number

### CalendarEventProcessor ###

- **`Cleanup ()`**
 - Clean up tasks.
---
- **`GetOption (Option AS String) AS AnyType`**
 - Gets the current setting of an option.
---
- **`Init (Host AS CalendarCalc)`**
 - Sets the host, default properties, and instantiate the calendar that will serve as reference for calculations/settings.
---
- **`LoadDefinition (XMLorURL AS String, EventsList AS Collection)`**
 - Loads events definition from an XML file or string. The loaded events go into the `m.EventsList` collection. Respects `This.EventsFilter`.
---
- **`SetBroker (Year AS Integer)`**
 - Sets the Broker object, used to negotiate dates with the calendar host.
---
- **`SetDefaultOptions ()`**
 - Sets the default value of options.
---
- **`SetEvents () AS Collection`**
 - Sets events for the current year of the host Calendar.
- **`SetEvents (Year AS Number) AS Collection`**
 - Sets events for the specified year (in the host Calendar system).
---
- **`SetOption (Option AS String, Setting AS AnyType)`**
 - Sets an option setting value.
