
*!*	Calendar

*!*	A VFP class to hold calendrical information and calculation.

*!*	Its purpose is to serve as a base class to actual calendar classes,
*!*	referring to current (like Hebrew, or Persian) or historical calendars
*!*	(like the French Republican Calendar).

*!*	The calculations are, for the most part, based on Kees Couprie's
*!*	Calendar Math website, at http://members.casema.nl/couprie/calmath/.
*!*	Unless stated otherwise, refer to CalMath for all date algorithms.

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
						'<memberdata name="setdate" type="method" display="SetDate" />' + ;
						'<memberdata name="fromsystem" type="method" display="FromSystem" />' + ;
						'<memberdata name="tosystem" type="method" display="ToSystem" />' + ;
						'<memberdata name="fromjulian" type="method" display="FromJulian" />' + ;
						'<memberdata name="tojulian" type="method" display="ToJulian" />' + ;
						'<memberdata name="daysdifference" type="method" display="DaysDifference" />' + ;
						'<memberdata name="daysadd" type="method" display="DaysAdd" />' + ;
						'<memberdata name="isleapyear" type="method" display="IsLeapYear" />' + ;
						'<memberdata name="lastdayofmonth" type="method" display="LastDayOfMonth" />' + ;
						'<memberdata name="monthname" type="method" display="MonthName" />' + ;
						'<memberdata name="weekday" type="method" display="Weekday" />' + ;
						'<memberdata name="weekdayname" type="method" display="WeekdayName" />' + ;
						'<memberdata name="getlocale" type="method" display="GetLocale" />' + ;
						'<memberdata name="setvocabulary" type="method" display="SetVocabulary" />' + ;
						'</VFPData>'

	* a Date or Datetime object can be passed to the object initialization,
	* or the current date set as default
	FUNCTION Init (SystemDate AS DateOrDatetime)

		IF !This.Historical OR PCOUNT() = 1
			This.FromSystem(IIF(PCOUNT() = 0, DATE(), m.SystemDate))
		ENDIF
			
		RETURN .T.

	ENDFUNC

	* SetDate()
	* sets the current date
	FUNCTION SetDate (CalYearOrDate AS IntegerOrCalendar, CalMonth AS Integer, CalDay AS Integer)

		SAFETHIS

		ASSERT (PCOUNT() = 1 AND VARTYPE(m.CalYearOrDate) == "O") OR ;
				(PCOUNT() = 3 AND VARTYPE(m.CalYearOrDate) + VARTYPE(m.CalMonth) + VARTYPE(m.CalDay) == "NNN") ;
			MESSAGE "Numeric parameters expected, or a Calendar"

		* pass through Julian calculations to validate, if supported
		IF PCOUNT() = 3
			This.FromJulian(This._toJulian(m.CalYearOrDate, m.CalMonth, m.CalDay))
		ELSE
			This.FromJulian(m.CalYearOrDate.ToJulian())
		ENDIF

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
	* return the current date as a Date value
	FUNCTION ToSystem () AS Date

		SAFETHIS

		LOCAL SetDate AS String
		LOCAL SetCentury AS String
		LOCAL JulianDate AS String
		LOCAL Result AS Date

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

		* locate the term in the vocabulary
		m.LocaleNode = This.Vocabulary.selectNodes("//calendar/locales[@code = '" + This.LocaleID + "' or position() = 1]/term[@name='" + m.Term + "']")
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

ENDDEFINE
