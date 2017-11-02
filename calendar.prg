
*!*	Calendar

*!*	A VFP class to hold calendrical information and calculation.

*!*	Its purpose is to serve as a base class to actual calendar classes,
*!*	referring to current (like Hebrew, or Persian) or historical calendars
*!*	(like the French Republican Calendar).

*!*	The calculations are, for the most part, based on Kees Couprie's
*!*	Calendar Math website, at http://members.casema.nl/couprie/calmath/.
*!*	Unless stated otherwise, refer to CalMath for all date algorithms.

*!*	Includes CalendarEvent* classes to extend a Calendar object with event information.

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

IF _VFP.StartMode = 0
	SET ASSERTS ON
ENDIF

#DEFINE SAFETHIS	ASSERT !USED("This") AND VARTYPE(This) == "O"

* The general base class (actual calendar classes will derive from this)
DEFINE CLASS Calendar AS Custom

	ADD OBJECT CalendarEvents AS Collection
	ADD OBJECT EventsProcessors AS Collection

	* the minimum date
	MinYear = 1
	MinMonth = 1
	MinDay = 1
	* the maximum date
	MaxYear = .NULL.
	MaxMonth = .NULL.
	MaxDay = .NULL.
	* the current date, in the calendar
	Year = This.MinYear
	Month = This.MinMonth
	Day = This.MinDay
	* historical?
	Historical = .F.
	* an idiom identifier to get names for months, days, and events
	LocaleID = "en"
	* the vocabulary object (an XML DOM object)
	Vocabulary = .NULL.
	* the vocabulary source (an XML document)
	VocabularySource = .NULL.

	_MemberData = '<VFPData>' + ;
						'<memberdata name="calendarevents" type="property" display="CalendarEvents" />' + ;
						'<memberdata name="eventsprocessors" type="property" display="EventsProcessors" />' + ;
						'<memberdata name="year" type="property" display="Year" />' + ;
						'<memberdata name="month" type="property" display="Month" />' + ;
						'<memberdata name="day" type="property" display="Day" />' + ;
						'<memberdata name="minyear" type="property" display="MinYear" />' + ;
						'<memberdata name="minmonth" type="property" display="MinMonth" />' + ;
						'<memberdata name="minday" type="property" display="MinDay" />' + ;
						'<memberdata name="maxyear" type="property" display="MaxYear" />' + ;
						'<memberdata name="maxmonth" type="property" display="MaxMonth" />' + ;
						'<memberdata name="maxday" type="property" display="MaxDay" />' + ;
						'<memberdata name="historical" type="property" display="Historical" />' + ;
						'<memberdata name="localeid" type="property" display="LocaleID" />' + ;
						'<memberdata name="vocabulary" type="property" display="Vocabulary" />' + ;
						'<memberdata name="vocabularysource" type="property" display="VocabularySource" />' + ;
						'<memberdata name="clone" type="method" display="Clone" />' + ;
						'<memberdata name="setdate" type="method" display="SetDate" />' + ;
						'<memberdata name="fromsystem" type="method" display="FromSystem" />' + ;
						'<memberdata name="tosystem" type="method" display="ToSystem" />' + ;
						'<memberdata name="fromjulian" type="method" display="FromJulian" />' + ;
						'<memberdata name="tojulian" type="method" display="ToJulian" />' + ;
						'<memberdata name="daysdifference" type="method" display="DaysDifference" />' + ;
						'<memberdata name="isbefore" type="method" display="IsBefore" />' + ;
						'<memberdata name="issameday" type="method" display="IsSameDay" />' + ;
						'<memberdata name="isafter" type="method" display="IsAfter" />' + ;
						'<memberdata name="daysadd" type="method" display="DaysAdd" />' + ;
						'<memberdata name="isleapyear" type="method" display="IsLeapYear" />' + ;
						'<memberdata name="lastdayofmonth" type="method" display="LastDayOfMonth" />' + ;
						'<memberdata name="monthname" type="method" display="MonthName" />' + ;
						'<memberdata name="weekday" type="method" display="Weekday" />' + ;
						'<memberdata name="weekdayname" type="method" display="WeekdayName" />' + ;
						'<memberdata name="setweekday" type="method" display="SetWeekday" />' + ;
						'<memberdata name="dtos" type="method" display="DTOS" />' + ;
						'<memberdata name="getlocale" type="method" display="GetLocale" />' + ;
						'<memberdata name="setvocabulary" type="method" display="SetVocabulary" />' + ;
						'<memberdata name="attacheventprocessor" type="method" display="AttachEventProcessor" />' + ;
						'<memberdata name="setevents" type="method" display="SetEvents" />' + ;
						'<memberdata name="locateevents" type="method" display="LocateEvents" />' + ;
						'<memberdata name="dayevents" type="method" display="DayEvents" />' + ;
						'</VFPData>'

	* a Date or Datetime object can be passed to the object initialization,
	* or the current date set as default
	FUNCTION Init (SystemDate AS DateOrDatetime)

		SAFETHIS

		IF !This.Historical OR PCOUNT() = 1
			This.FromSystem(IIF(PCOUNT() = 0, DATE(), m.SystemDate))
		ENDIF
			
		RETURN .T.

	ENDFUNC

	* Clone
	* returns a copy of the object
	FUNCTION Clone

		SAFETHIS

		LOCAL Calendar AS CalendarBasedObject

		m.Calendar = CREATEOBJECT(This.Class)
		m.Calendar.SetDate(This.Year, This.Month, This.Day)

		RETURN m.Calendar
	ENDFUNC

	* SetDate()
	* sets the current date
	FUNCTION SetDate (CalYearOrDateOrEvent AS IntegerOrCalendarOrString, CalMonth AS Integer, CalDay AS Integer)

		SAFETHIS

		ASSERT (PCOUNT() = 1 AND VARTYPE(m.CalYearOrDateOrEvent) $ "OC") OR ;
				(PCOUNT() = 3 AND VARTYPE(m.CalYearOrDateOrEvent) + VARTYPE(m.CalMonth) + VARTYPE(m.CalDay) == "NNN") ;
			MESSAGE "Numeric parameters expected, or a Calendar, or a String."

		LOCAL CalEvent AS CalendarEvent

		DO CASE
		* if jumping to an event, locate it and try to set the date accordingly
		CASE PCOUNT() = 1 AND VARTYPE(m.CalYearOrDateOrEvent) == "C"
			m.CalEvent = This.LocateEvent(m.CalYearOrDateOrEvent)
			IF !ISNULL(m.CalEvent)
				This.FromJulian(This._toJulian(m.CalEvent.Year, m.CalEvent.Month, m.CalEvent.Day))
			ENDIF

		* pass through Julian calculations to validate, if supported
		CASE PCOUNT() = 3
			This.FromJulian(This._toJulian(m.CalYearOrDateOrEvent, m.CalMonth, m.CalDay))

		* set date from other calendar
		OTHERWISE
			This.FromJulian(m.CalYearOrDateOrEvent.ToJulian())

		ENDCASE

	ENDFUNC

	* FromSystem()
	* set the current calendar date from a Date or Datetime value
	PROCEDURE FromSystem (SystemDate AS DateOrDatetime)

		ASSERT PCOUNT() = 0 OR VARTYPE(m.SystemDate) $ "DT" ;
			MESSAGE "Date or Datetime parameter expected"

		* this is actually done from the corresponding Julian Day Number
		This.FromJulian(VAL(SYS(11, IIF(PCOUNT() = 0, DATE(), m.SystemDate))))

	ENDPROC

	* ToSystem()
	* return the current date or a specific calendar date as a Date value
	FUNCTION ToSystem (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Date

		SAFETHIS

		ASSERT PCOUNT() = 0 OR VARTYPE(m.CalYear) + VARTYPE(m.CalMonth) + VARTYPE(m.CalDay) == "NNN" ;
			MESSAGE "Numeric parameters expected."

		LOCAL SetDate AS String
		LOCAL SetCentury AS String
		LOCAL JulianDate AS String
		LOCAL CurrentYear AS Integer
		LOCAL CurrentMonth AS Integer
		LOCAL CurrentDay AS Integer
		LOCAL Result AS Date

		* no parameters? use the current calendar date
		IF PCOUNT() = 0
			* save settings, to restore later
			m.SetDate = SET("Date")
			m.SetCentury = SET("Century")

			SET DATE TO ANSI
			SET CENTURY ON

			* transform the current calendar date in a Julian Day Number, and get its string representation
			m.JulianDate = SYS(10,This._toJulian(This.Year, This.Month, This.Day))
			* to turn it into a Date value
			m.Result = EVALUATE("{^" + m.JulianDate + "}")

			SET CENTURY &SetCentury.
			SET DATE &SetDate.

		* if a specific calendar date was passed, get its Date corresponding value
		ELSE
			* save current values
			m.CurrentYear = This.Year
			m.CurrentMonth = This.Month
			m.CurrentDay = This.Day

			* set passed values as current
			This.SetDate(m.CalYear, m.CalMonth, m.CalDay)

			* call itself without parameters, this time
			m.Result = This.ToSystem()

			* restore saved values
			* (for efficiency sake, set properties directly instead of going through SetDate() method)
			This.Year = m.CurrentYear
			This.Month = m.CurrentMonth
			This.Day = m.CurrentDay
		ENDIF

		RETURN m.Result

	ENDFUNC

	* FromJulian()
	* set the current calendar date corresponding to the Julian Day Number
	PROCEDURE FromJulian (JulianDate AS Number)

		ASSERT PCOUNT() = 1 AND VARTYPE(m.JulianDate) == "N" ;
			MESSAGE "Numeric parameter expected."

		This._fromJulian(This.CalcInt(m.JulianDate))

	ENDPROC
	
	* ToJulian()
	* return the Julian Day Number corresponding to the current calendar date, or to a specific calendar date
	FUNCTION ToJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Number

		SAFETHIS

		ASSERT PCOUNT() = 0 OR VARTYPE(m.CalYear) + VARTYPE(m.CalMonth) + VARTYPE(m.CalDay) == "NNN" ;
			MESSAGE "Numeric parameters expected."

		IF PCOUNT() = 0
			RETURN This._toJulian(This.Year, This.Month, This.Day)
		ELSE
			RETURN This._toJulian(m.CalYear, m.CalMonth, m.CalDay)
		ENDIF

	ENDFUNC

	* DaysDifference()
	* returns the difference, in days, between current calendar date and some other date
	FUNCTION DaysDifference (CalYearOrDate AS IntegerDateOrCalendar, CalMonth AS Integer, CalDay AS Integer) AS Number

		SAFETHIS

		ASSERT PCOUNT() = 0 OR (PCOUNT() = 1 AND VARTYPE(m.CalYearOrDate) $ "DTO") OR ;
				(PCOUNT() = 3 AND VARTYPE(m.CalYearOrDate) + VARTYPE(m.CalMonth) + VARTYPE(m.CalDay) == "NNN") ;
			MESSAGE "Numeric parameters expected, or a Date, or a Calendar"

		LOCAL ThisJulianDate AS Number
		LOCAL OtherJulianDate AS Number

		DO CASE
		CASE PCOUNT() = 0								&& difference to current system date
			m.OtherJulianDate = VAL(SYS(1))

		CASE PCOUNT() = 3								&& difference to other date in the same calendar
			m.OtherJulianDate = This._toJulian(m.CalYearOrDate, m.CalMonth, m.CalDay)

		CASE VARTYPE(m.CalYearOrDate) $ "DT"	&& difference to a system date
			m.OtherJulianDate = VAL(SYS(11, m.CalYearOrDate))

		OTHERWISE										&& difference to other date in a calendar
			m.OtherJulianDate = m.CalYearOrDate.ToJulian()

		ENDCASE

		* the other date Julian Day Number is calculated, now see how many days to the current date
		RETURN This.ToJulian() - m.OtherJulianDate
	ENDFUNC

	* Is* comparison methods
	* compares current date to other date and returns True if Before, SameDay, or After
	FUNCTION IsBefore (CalYearOrDate AS IntegerDateOrCalendar, CalMonth AS Integer, CalDay AS Integer) AS Boolean
		RETURN This.Compare("<", PCOUNT(), m.CalYearOrDate, m.CalMonth, m.CalDay)
	ENDFUNC

	FUNCTION IsSameDay (CalYearOrDate AS IntegerDateOrCalendar, CalMonth AS Integer, CalDay AS Integer) AS Boolean
		RETURN This.Compare("=", PCOUNT(), m.CalYearOrDate, m.CalMonth, m.CalDay)
	ENDFUNC

	FUNCTION IsAfter (CalYearOrDate AS IntegerDateOrCalendar, CalMonth AS Integer, CalDay AS Integer) AS Boolean
		RETURN This.Compare(">", PCOUNT(), m.CalYearOrDate, m.CalMonth, m.CalDay)
	ENDFUNC

	* DaysAdd()
	* adds a number of days (negative or positive) to the current date
	PROCEDURE DaysAdd (Days AS Number)

		SAFETHIS

		This.FromJulian(This.ToJulian() + m.Days)
	ENDPROC

	* IsLeapYear()
	* returns .T. if the calendar year is a leap year
	FUNCTION IsLeapYear (Year AS Number) AS Boolean
		RETURN .NULL.		&& not implemented at the base class
	ENDFUNC

	* LastDayOfMonth()
	* returns the last day of a month in a specific year
	FUNCTION LastDayOfMonth (Year AS Number, Month AS Number) AS Number
		RETURN .NULL.		&& not implemented at the base class
	ENDFUNC

	* MonthName()
	* gets the name of the month, for the current locale
	FUNCTION MonthName (Month AS Number) AS String
	
		SAFETHIS
		
		ASSERT PCOUNT() = 0 OR VARTYPE(m.Month) = "N" ;
			MESSAGE "Numeric parameter expected."

		LOCAL Name AS String

		IF PCOUNT() = 0
			m.Month = This.Month
		ENDIF

		IF ISNULL(This.Vocabulary) AND !ISNULL(This.VocabularySource)
			This.SetVocabulary(LOCFILE(This.VocabularySource))
		ENDIF

		IF !ISNULL(This.Vocabulary)
			m.Name = This.GetLocale("month." + TRANSFORM(m.Month))
		ENDIF
	
		RETURN EVL(m.Name, .NULL.)

	ENDFUNC

	* Weekday()
	* returns the week day (assuming the last day of the week is for rest / religious obligations: 1 = Monday, 7 = Sunday)
	FUNCTION Weekday (Year AS Integer, Month AS Integer, Day AS Integer) AS Number

		LOCAL JulianDayNumber AS Number

		SAFETHIS

		ASSERT PCOUNT() = 0 OR VARTYPE(m.Year) + VARTYPE(m.Month) + VARTYPE(m.Day) == "NNN" ;
			MESSAGE "Numeric parameters expected."

		IF PCOUNT() = 0
			m.Year = This.Year
			m.Month = This.Month
			m.Day = This.Day
		ENDIF
	
		m.JulianDayNumber = This._toJulian(m.Year, m.Month, m.Day)

		RETURN (m.JulianDayNumber % 7) + 1
		
	ENDFUNC

	* WeekdayName()
	* returns the name of the weekday, for a given locale
	FUNCTION WeekdayName (Year AS Number, Month AS Number, Day AS Number) AS Number
	
		SAFETHIS

		ASSERT PCOUNT() = 0 OR VARTYPE(m.Month) + VARTYPE(m.Year) + VARTYPE(m.Day) == "NNN" ;
			MESSAGE "Numeric parameters expected."

		LOCAL Name AS String
		
		IF PCOUNT() = 0
			m.Day = This.Day
			m.Month = This.Month
			m.Year = This.Year
		ENDIF

		IF ISNULL(This.Vocabulary) AND !ISNULL(This.VocabularySource)
			This.SetVocabulary(LOCFILE(This.VocabularySource))
		ENDIF

		IF !ISNULL(This.Vocabulary)
			m.Name = This.GetLocale("weekday." + TRANSFORM(This.Weekday(m.Year, m.Month, m.Day)))
		ENDIF

		RETURN EVL(m.Name, .NULL.)

	ENDFUNC

	* SetWeekday()
	* sets the date to a specific week day (1 = Monday, 7 = Sunday)
	FUNCTION SetWeekday (Year AS Integer, Month AS Integer, WeekDay AS Integer, Ordinal AS Integer) AS Boolean

		SAFETHIS

		ASSERT VARTYPE(m.Year) + VARTYPE(m.Month) + VARTYPE(m.WeekDay) == "NNN" ;
				AND (PCOUNT() = 3 OR VARTYPE(m.Ordinal) == "N") ;
			MESSAGE "Numeric parameters expected."

		LOCAL FirstWeekDay AS Integer
		LOCAL Day AS Integer

		IF PCOUNT() = 3
			m.Ordinal = 1
		ENDIF

		m.FirstWeekDay = This.Weekday(m.Year, m.Month, 1)
		m.Day = ((m.Ordinal - IIF(m.FirstWeekDay <= m.WeekDay, 1, 0)) * 7) + (m.WeekDay - m.FirstWeekDay) + 1

		IF m.Day <= This.LastDayOfMonth(m.Year, m.Month)
			This.SetDate(m.Year, m.Month, m.Day)
			RETURN .T.
		ELSE
			RETURN .F.
		ENDIF
		
	ENDFUNC

	* DTOS()
	* returns a string representation of the current data that can be used in index expressions
	FUNCTION DTOS () AS String

		SAFETHIS

		RETURN CHRTRAN(STR(This.Year, 4, 0) + STR(This.Month, 2, 0) + STR(This.Day, 2, 0), " ", "0")
	ENDFUNC

	* placeholders for auxiliary methods
	* calculations to transform a Julian Day Number into a calendar date, and vice-versa
	PROCEDURE _fromJulian (JulianDate AS Number)
	ENDPROC

	FUNCTION _toJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Number
		RETURN .NULL.		&& not implemented at the base class
	ENDFUNC

	* auxiliary calculation functions
	PROTECTED FUNCTION CalcInt (ANumber AS Number)
		RETURN INT(m.ANumber) - IIF(m.ANumber < 0, 1, 0)
	ENDFUNC

	PROTECTED FUNCTION CalcFix (ANumber AS Number)
		RETURN INT(m.ANumber)
	ENDFUNC

	PROTECTED FUNCTION CalcCeil (ANumber AS Number)
		IF m.ANumber >=0
			RETURN ROUND(m.ANumber + 0.5,0)
		ELSE
			RETURN This.CalcInt(m.ANumber)
		ENDIF
	ENDFUNC

	* auxiliary compare two dates function
	HIDDEN FUNCTION Compare (Comparison AS Character, ParameterCount AS Integer, CalYearOrDate AS IntegerDateOrCalendar, CalMonth AS Integer, CalDay AS Integer) AS Boolean

		LOCAL Days AS Integer

		DO CASE
		CASE m.ParameterCount = 0
			m.Days = This.DaysDifference()

		CASE m.ParameterCount = 1
			m.Days = This.DaysDifference(m.CalYearOrDate)

		OTHERWISE
			m.Days = This.DaysDifference(m.CalYearOrDate, m.CalMonth, m.CalDay)
		ENDCASE

		RETURN (m.Days = 0 AND m.Comparison == "=") OR (m.Days < 0 AND m.Comparison == "<") OR (m.Days > 0 AND m.Comparison == ">")
	ENDFUNC

	* GetLocale()
	* return a string for a specific term in the locale vocabulary
	FUNCTION GetLocale (Term AS String) AS String

		SAFETHIS
		
		ASSERT VARTYPE(m.Term) == "C" ;
			MESSAGE "String parameter expected."
		ASSERT !ISNULL(This.Vocabulary) ;
			MESSAGE "Vocabulary is not set."

		LOCAL LocaleNode AS MSXML2.IXMLDOMNodeList
		LOCAL Locale AS String
		LOCAL XPath AS String

		* locate the term in the vocabulary
		m.XPath = TEXTMERGE("(/calendar/locales[@code = '<<This.LocaleID>>'] | /calendar/locales[position()=1 and not(/calendar/locales[@code='<<This.LocaleID>>'])])/term[@name = '<<m.Term>>']")
		m.LocaleNode = This.Vocabulary.selectNodes(m.XPath)
		IF m.LocaleNode.length = 1
			RETURN m.LocaleNode.item(0).text
		ENDIF
		
		RETURN ""

	ENDFUNC

	* SetVocabulary()
	* sets a vocabulary to be used in locale identification
	FUNCTION SetVocabulary (XMLorURL AS String) AS Boolean

		SAFETHIS

		ASSERT VARTYPE(m.XMLorURL) == "C" ;
			MESSAGE "String parameter expected."

		IF !ISNULL(This.Vocabulary)
			This.Vocabulary = .NULL.
		ENDIF

		This.Vocabulary = CREATEOBJECT("MSXML2.DOMDocument.6.0")
		This.Vocabulary.Async = .F.
		* try to load from a URL or from a string
		IF This.Vocabulary.Load(m.XMLorURL) OR This.Vocabulary.LoadXML(m.XMLorURL)
			RETURN .T.
		ENDIF

		This.Vocabulary = .NULL.
		RETURN .F.

	ENDFUNC

	* AttachEventProcessor
	* attaches an event processor to calculate events for the calendar object
	FUNCTION AttachEventProcessor (Identifier AS String, ProcessorClass AS String, ProcessorLibrary AS String)

		SAFETHIS

		ASSERT VARTYPE(m.Identifier) + VARTYPE(m.ProcessorClass) == "CC" ;
			MESSAGE "String parameters expected."
		ASSERT PCOUNT() = 2 OR (VARTYPE(m.ProcessorLibrary) == "C" AND FILE(m.ProcessorLibrary)) ;
			MESSAGE "Library not found or not properly identified."

		* the processor key will identify the processor hereafter
		m.ProcessorKey = m.Identifier

		TRY
			IF PCOUNT() = 3
				* if a library was given, create an object from it and store the object at the processors collection
				This.EventsProcessors.Add(NEWOBJECT(m.ProcessorClass, LOCFILE(m.ProcessorLibrary), .NULL., This), m.Identifier)
			ELSE
				* otherwise, the class must be in scope
				This.EventsProcessors.Add(CREATEOBJECT(m.ProcessorClass, This), m.Identifier)
			ENDIF
			* in any case, a reference to the Calendar object is passed, so that its methods and properties can be accessed
			* from the instantiated processor
		CATCH
		ENDTRY

		* return success
		RETURN This.EventsProcessors.GetKey(m.Identifier) > 0

	ENDFUNC

	* SetEvents
	* set events from the event processors 
	FUNCTION SetEvents (Year AS Integer)

		ASSERT PCOUNT() = 0 OR VARTYPE(m.Year) == "N" ;
			MESSAGE "Numeric parameter expected."

		LOCAL Processor AS CalendarEventProcessor
		LOCAL ProcessorResult AS Collection
		LOCAL NewEvent AS CalendarEvent

		* refer to a specific year, or to the current year
		IF PCOUNT() = 0
			m.Year = This.Year
		ENDIF

		* clear the events
		This.CalendarEvents.Remove(-1)

		* go through all attached processors, and ask for events
		FOR EACH m.Processor IN This.EventsProcessors

			m.ProcessorResult = m.Processor.SetEvents(m.Year)
			FOR EACH m.NewEvent IN m.ProcessorResult
				IF This.CalendarEvents.GetKey(m.NewEvent.Identifier) > 0
					This.CalendarEvents.Remove(m.NewEvent.Identifier)
				ENDIF
				This.CalendarEvents.Add(m.NewEvent, m.NewEvent.Identifier)
			ENDFOR

		ENDFOR

	ENDFUNC

	* LocateEvent
	* locates a calendar event, from the collection of set events
	FUNCTION LocateEvent (Identifier AS String) AS CalendarEvent

		ASSERT VARTYPE(m.Identifier) == "C" ;
			MESSAGE "String parameter expected."

		IF This.CalendarEvents.GetKey(m.Identifier) > 0
			RETURN This.CalendarEvents(m.Identifier)
		ELSE
			RETURN .NULL.
		ENDIF

	ENDFUNC

	* DayEvents
	* returns the collection of events for a specific day
	FUNCTION DayEvents (Year AS Number, Month AS Number, Day AS Number) AS Collection
	
		SAFETHIS

		ASSERT PCOUNT() = 0 OR VARTYPE(m.Month) + VARTYPE(m.Year) + VARTYPE(m.Day) == "NNN" ;
			MESSAGE "Numeric parameters expected."

		LOCAL DayEvents AS Collection
		LOCAL RefDate AS Calendar
		LOCAL CalEvent AS CalendarEvents

		* the result will be a collection  of identifiers
		m.DayEvents = CREATEOBJECT("Collection")
		* the reference date
		m.RefDate = This.Clone()

		* if no specific date was given, use the curremt date
		IF PCOUNT() = 0
			m.Year = This.Year
			m.Month = This.Month
			m.Day = This.Day
		ENDIF

		* it will be used as a reference
		m.RefDate.SetDate(m.Year, m.Month, m.Day)

		* go through the set events
		FOR EACH m.CalEvent IN This.CalendarEvents

			IF m.CalEvent.Year = m.Year
				* if the day is the same in the event and the reference, add the identifier to the result
				IF m.CalEvent.Month = m.Month AND m.CalEvent.Day = m.Day
					m.DayEvents.Add(m.CalEvent.Identifier)
				ELSE
					* the event spans through several days? and passes through the reference date?
					IF m.CalEvent.Duration > 1 AND BETWEEN(m.RefDate.DaysDifference(m.CalEvent.Year, m.CalEvent.Month, m.CalEvent.Day), 0, m.CalEvent.Duration - 1)
						* add the identifier to the result: the date is the middle of an event
						m.DayEvents.Add(m.CalEvent.Identifier)
					ENDIF
				ENDIF
			ENDIF 

		ENDFOR

		RETURN m.DayEvents
						
	ENDFUNC

ENDDEFINE

DEFINE CLASS CalendarEvent AS Custom

	Identifier = ""
	CommonName = ""
	Scope = "National"
	Origin = "Civil"
	Observed = .F.
	Fixed = .F.
	Year = 0
	Month = 0
	Day = 0
	Duration = 1
	YearBegin = 0
	YearEnd = 0

	_MemberData = '<VFPData>' + ;
						'<memberdata name="identifier" type="property" display="Identifier" />' + ;
						'<memberdata name="commonname" type="property" display="CommonName" />' + ;
						'<memberdata name="scope" type="property" display="Scope" />' + ;
						'<memberdata name="origin" type="property" display="Origin" />' + ;
						'<memberdata name="observed" type="property" display="Observed" />' + ;
						'<memberdata name="fixed" type="property" display="Fixed" />' + ;
						'<memberdata name="year" type="property" display="Year" />' + ;
						'<memberdata name="month" type="property" display="Month" />' + ;
						'<memberdata name="day" type="property" display="Day" />' + ;
						'<memberdata name="duration" type="property" display="Duration" />' + ;
						'<memberdata name="yearbegin" type="property" display="YearBegin" />' + ;
						'<memberdata name="yearend" type="property" display="YearEnd" />' + ;
						'</VFPData>'
ENDDEFINE

DEFINE CLASS CalendarEventProcessor AS Custom

	ADD OBJECT PROTECTED Options AS Collection
	ADD OBJECT EventsFilter AS Collection

	* the calendar object to which this processor is going to be attached
	Host = .NULL.
	* a broker object to allow date transformations between calendars
	Broker = .NULL.
	* a processor uses a calendar class of some kind for reference 
	ReferenceCalendarClass = "Calendar"
	ReferenceCalendar = .NULL.
	* events definition, in XML
	EventsDefinition = ""
	* accept observed holidays, if set in definitions
	Observed = .T.
	* default scope (unset)
	Scope = ""

	_MemberData = '<VFPData>' + ;
						'<memberdata name="options" type="property" display="Options" />' + ;
						'<memberdata name="eventsfilter" type="property" display="EventsFilter" />' + ;
						'<memberdata name="host" type="property" display="Host" />' + ;
						'<memberdata name="broker" type="property" display="Broker" />' + ;
						'<memberdata name="referencecalendarclass" type="property" display="ReferenceCalendarClass" />' + ;
						'<memberdata name="referencecalendar" type="property" display="ReferenceCalendar" />' + ;
						'<memberdata name="eventsdefinition" type="property" display="EventsDefinition" />' + ;
						'<memberdata name="observed" type="property" display="Observed" />' + ;
						'<memberdata name="scope" type="property" display="Scope" />' + ;
						'<memberdata name="setevents" type="method" display="SetEvents" />' + ;
						'<memberdata name="setbroker" type="method" display="SetBroker" />' + ;
						'<memberdata name="setoption" type="method" display="SetOption" />' + ;
						'<memberdata name="setdefaultoptions" type="method" display="SetDefaultOptions" />' + ;
						'<memberdata name="getoption" type="method" display="GetOption" />' + ;
						'</VFPData>'

	* Init
	* sets the host, default properties, and instantiate the calendar that will serve as reference for calculations/settings
	FUNCTION Init (Host AS Calendar)

		LOCAL Success AS Boolean

		This.Host = m.Host
		This.SetDefaultOptions()

		This.ReferenceCalendar = CREATEOBJECT(This.ReferenceCalendarClass)
		m.Success = !ISNULL(This.ReferenceCalendar) AND TYPE("This.ReferenceCalendar") == "O"

		RETURN m.Success

	ENDFUNC

	* SetEvents
	* sets the events that this processor knows
	FUNCTION SetEvents (Year AS Integer) AS Collection

		SAFETHIS

		ASSERT VARTYPE(m.Year) == "N" ;
			MESSAGE "Numeric parameter expected."

		LOCAL ResultSet AS Collection

		* where these events will be stored
		m.ResultSet = CREATEOBJECT("Collection")

		* set the broker and the reference calendar objects
		This.SetBroker(m.Year)

		* if there is an XML definition for the events, load it and set the events
		IF !EMPTY(This.EventsDefinition)
			This.LoadDefinition(This.EventsDefinition, m.ResultSet)
		ENDIF
	
		* return the result set, empty or partially filled, for this section of the event list 
		RETURN m.ResultSet

	ENDFUNC

	* SetBroker
	* sets the broker object, to negotiate dates with the calendar host
	PROTECTED FUNCTION SetBroker (Year AS Integer)

		SAFETHIS

		* clear a previous instance, if any
		This.Broker = .NULL.
		* get a copy of the host date
		This.Broker = This.Host.Clone()
		* and set it to the start of the year
		This.Broker.SetDate(m.Year, 1, 1)
		* translate the date into the calendar system of the reference that will be used for event calculation
		This.ReferenceCalendar.SetDate(This.Broker)

	ENDFUNC

	* SetDefaultOptions
	* sets the default value of options defined for a processor
	FUNCTION SetDefaultOptions
	ENDFUNC

	* SetOption
	* sets an option required by a processor (no need to change, in principle)
	FUNCTION SetOption (Option AS String, Setting AS AnyType)

		LOCAL OptionKey AS String

		m.OptionKey = UPPER(m.Option)

		IF !EMPTY(This.Options.GetKey(m.OptionKey))
			This.Options.Remove(m.OptionKey)
		ENDIF
		This.Options.Add(m.Setting, m.OptionKey)

	ENDFUNC
	
	* GetOption
	* gets the current setting of an option
	FUNCTION GetOption (Option AS String) AS AnyType

		RETURN This.Options(UPPER(m.Option))

	ENDFUNC

	* LoadDefinition
	* loads events definition from an XML file
	PROTECTED FUNCTION LoadDefinition (XMLorURL AS String, EventsList AS Collection)

		LOCAL Definition AS MSXML2.DOMDocument60
		LOCAL EventElements AS MSXML2.IXMLDOMNodeList
		LOCAL EventElement AS MSXML2.IXMLDOMNode
		LOCAL EventDefinition AS CalendarEvent
		LOCAL Identifier AS String
		LOCAL CommonName AS String
		LOCAL Interval AS Integer
		LOCAL Inverted AS Boolean
		LOCAL Year AS Integer
		LOCAL DefDay AS Integer
		LOCAL DefMonth AS Integer
		LOCAL DefMove AS Integer
		LOCAL MoveIndex AS Integer
		LOCAL MoveRef AS String
		LOCAL MoveCondition AS Integer
		LOCAL BrokerYear AS Integer

		m.Definition = CREATEOBJECT("MSXML2.DOMDocument.6.0")
		m.Definition.Async = .F.

		* the definition may come from a file or a string
		IF m.Definition.Load(m.XMLorURL) OR m.Definition.LoadXML(m.XMLorURL)

			m.Year = This.ReferenceCalendar.Year
			m.BrokerYear = This.Broker.Year

			m.EventElements = m.Definition.Selectnodes("//events/event")

			* fetch each event
			FOR EACH m.EventElement IN m.EventElements

				m.Identifier = This._definitionValue(m.EventElement, "identifier")
				m.CommonName = ""
				* if a filter is in place, check to see if this event/identifier is filtered in
				IF This.EventsFilter.Count > 0
					IF This.EventsFilter.GetKey(m.Identifier) = 0
						m.Identifier = ""
					ELSE
						m.CommonName = This.EventsFilter(m.Identifier)
					ENDIF
				ENDIF

				m.Interval = EVL(VAL(This._definitionValue(m.EventElement, "interval")), 1)
				m.Inverted = This._definitionValue(m.EventElement, "interval/@inverted") == "true"

				* is not filtered out and covered by the chronology?
				IF !EMPTY(m.Identifier) AND ;
							m.Year >= EVL(VAL(This._definitionValue(m.EventElement, "yearbegin")), m.Year) AND ;
							m.Year <= EVL(VAL(This._definitionValue(m.EventElement, "yearend")), m.Year) AND ;
							((!m.Inverted AND (m.Year - VAL(This._definitionValue(m.EventElement, "yearbegin"))) % m.Interval = 0) OR ;
							(m.Inverted AND (m.Year - VAL(This._definitionValue(m.EventElement, "yearbegin"))) % m.Interval != 0))

					* create an event to be inserted into the calendar
					m.EventDefinition = CREATEOBJECT("CalendarEvent")
					m.EventDefinition.Identifier = m.Identifier
					m.EventDefinition.Fixed = .T.

					* extract data from the XML document
					m.EventDefinition.CommonName = EVL(m.CommonName, This._definitionValue(m.EventElement, "commonname"))
					m.EventDefinition.Scope = EVL(This.Scope, This._definitionValue(m.EventElement, "scope"))
					m.EventDefinition.Origin = This._definitionValue(m.EventElement, "origin")
					m.EventDefinition.Observed = This._definitionValue(m.EventElement, "observed") == "true" AND This.Observed

					* fetch the day and month
					m.DefDay = VAL(This._definitionValue(m.EventElement, "day"))
					m.DefMonth = VAL(This._definitionValue(m.EventElement, "month"))

					* the date, as a literal
					IF !EMPTY(m.DefDay)
						This.ReferenceCalendar.SetDate(m.Year, m.DefMonth, m.DefDay)
					ELSE
						* or as a weekday
						m.DefDay = VAL(This._definitionValue(m.EventElement, "weekday"))
						This.ReferenceCalendar.SetWeekday(m.Year, m.DefMonth, m.DefDay, EVL(VAL(This._definitionValue(m.EventElement, "weekday/@ordinal")), 1))
					ENDIF

					* check if needed to move, on verifiable conditions
					* there may be more than one condition set in place, but only the first one that applies will be accepted
					m.MoveIndex = 1
					DO WHILE m.MoveIndex != 0
						m.MoveRef = "move[" + TRANSFORM(m.MoveIndex) + "]"
						m.DefMove = VAL(This._definitionValue(m.EventElement, m.MoveRef))
						IF !EMPTY(m.DefMove)
							* move when the event is on a specific day?
							m.MoveCondition = VAL(This._definitionValue(m.EventElement, m.MoveRef + "/@onday"))
							IF m.MoveCondition != 0 AND This.ReferenceCalendar.Day = m.MoveCondition
								 This.ReferenceCalendar.DaysAdd(m.DefMove)
								 m.MoveIndex = 0
							ELSE
								* move when the event is on a specific weekday?
								m.MoveCondition = VAL(This._definitionValue(m.EventElement, m.MoveRef + "/@onweekday"))
								IF m.MoveCondition != 0 AND This.ReferenceCalendar.Weekday() = m.MoveCondition
									This.ReferenceCalendar.DaysAdd(m.DefMove)
									m.MoveIndex = 0
								ELSE
									m.MoveIndex = m.MoveIndex + 1
								ENDIF
							ENDIF
						ELSE
							m.MoveIndex = 0
						ENDIF
					ENDDO

					* and now translated into the target calendar
					This.Broker.SetDate(This.ReferenceCalendar)

					* if not fitting in the expected year, try to insert the date in the previous or next year
					IF This.Broker.Year < m.BrokerYear
						This.ReferenceCalendar.Year = This.ReferenceCalendar.Year + 1
						This.Broker.SetDate(This.ReferenceCalendar)
					ELSE
						IF This.Broker.Year > m.BrokerYear
							This.ReferenceCalendar.Year = This.ReferenceCalendar.Year - 1
							This.Broker.SetDate(This.ReferenceCalendar)
						ENDIF
					ENDIF

					* success: data can be populated
					IF m.BrokerYear = This.Broker.Year

						m.EventDefinition.Year = m.BrokerYear
						m.EventDefinition.Month = This.Broker.Month
						m.EventDefinition.Day = This.Broker.Day
						m.EventDefinition.Duration = EVL(VAL(This._definitionValue(m.EventElement, "duration")), 1)

						* and added to the events already set
						IF m.EventsList.GetKey(m.Identifier) > 0
							m.EventsList.Remove(m.Identifier)
						ENDIF
						m.EventsList.Add(m.EventDefinition, m.Identifier)

					ELSE

						m.EventDefinition = .NULL.

					ENDIF

				ENDIF

			ENDFOR
		ENDIF

	ENDFUNC

	* _definitionValue
	* fetchs a value from an event XML definition
	HIDDEN FUNCTION _definitionValue (Definition AS MSXML2.IXMLDOMNode, Property AS String)

		LOCAL DefinitionProperty AS MSXML2.IXMLDOMNodeList

		m.DefinitionProperty = m.Definition.selectNodes(m.Property)
		IF m.DefinitionProperty.length = 1
			RETURN m.DefinitionProperty.item(0).text
		ELSE
			RETURN ""
		ENDIF

	ENDFUNC

ENDDEFINE

