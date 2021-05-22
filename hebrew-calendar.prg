
*!*	HebrewCalendar

*!*	A CalendarCalc subclass for the Hebrew Calendar.
*!*	Locales are stored in hebrew.xml file.

* install dependencies
IF _VFP.StartMode = 0
	DO LOCFILE("calendar.prg")
ELSE
	DO calendar.prg
ENDIF

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

* Julian day number of 1 Tishri 1
#DEFINE HEBREW_BEGIN	347997

#DEFINE SAFETHIS	ASSERT !USED("This") AND VARTYPE(This) == "O"

DEFINE CLASS HebrewCalendar AS CalendarCalc

	VocabularySource = "hebrew.xml"
	WeekStart = 7

	* IsLeapYear()
	* returns .T. if given year ia a leap year
	FUNCTION IsLeapYear (Year AS Number)

		SAFETHIS
		
		ASSERT PCOUNT() = 0 OR VARTYPE(m.Year) == "N" ;
			MESSAGE "Numeric parameter expected."

		IF PCOUNT() = 0
			m.Year = This.Year
		ENDIF

		RETURN (((7 * m.Year) + 1) % 19) < 7

	ENDFUNC

	* LastDayOfMonth()
	* returns the day of a month, in a given year
	FUNCTION LastDayOfMonth (Year AS Number, Month AS Number)

		SAFETHIS
		
		ASSERT PCOUNT() = 0 OR VARTYPE(m.Year) + VARTYPE(m.Month) == "NN" ;
			MESSAGE "Numeric parameters expected."

		IF PCOUNT() = 0
			m.Year = This.Year
			m.Month = This.Month
		ENDIF
		
		LOCAL MonthVal AS Number
		LOCAL LastDay AS Number
		
		m.MonthVal = m.Month
		
		IF m.MonthVal > 6 AND !(This.IsLeapYear(m.Year))
			m.MonthVal = m.MonthVal + 1
		ENDIF
		
		DO CASE
		CASE m.MonthVal = 2
			m.LastDay = IIF(This._longHeshvan(m.Year), 30, 29)
		
		CASE m.MonthVal = 3
			m.LastDay = IIF(This._shortKislev(m.Year), 29, 30)

		CASE m.MonthVal = 6
			m.LastDay = IIF(This.IsLeapYear(m.Year), 30, 29)

		CASE INLIST(m.MonthVal, 4, 7, 9, 11, 13)
			m.LastDay = 29

		CASE INLIST(m.MonthVal, 1, 5, 8, 10, 12)
			m.LastDay = 30
		
		OTHERWISE
			m.LastDay = 0
		ENDCASE
		
		RETURN m.LastDay

	ENDFUNC

	* MonthName()
	* returns the name of the month, for a given locale
	FUNCTION MonthName (Month AS Number, Year AS Number, ShortName AS Logical)
	
		SAFETHIS
		
		ASSERT PCOUNT() = 0 OR VARTYPE(m.Month) + VARTYPE(m.Year) + VARTYPE(m.ShortName) == "NNL" ;
			MESSAGE "Numeric and logical parameters expected."

		LOCAL MonthVal AS Number
		LOCAL MonthLeap AS String
		LOCAL Name AS String

		IF PCOUNT() = 0
			m.MonthVal = This.Month
			m.Year = This.Year
		ELSE
			m.MonthVal = m.Month
		ENDIF

		IF ISNULL(This.Vocabulary)
			This.SetVocabulary(LOCFILE("hebrew.xml"))
		ENDIF

		IF m.MonthVal < 0
			IF This.IsLeapYear(m.Year)
				m.MonthVal = m.MonthVal + 14
			ELSE
				m.MonthVal = m.MonthVal + 13
			ENDIF
		ENDIF

		IF m.MonthVal > 6 AND !This.IsLeapYear(m.Year)
			m.MonthVal = m.MonthVal + 1
		ENDIF
		IF m.MonthVal = 6 AND This.IsLeapYear(m.Year)
			m.MonthLeap = ".leap"
		ELSE
			m.MonthLeap = ""
		ENDIF

		m.Name = This.GetLocale("month." + IIF(m.ShortName, "short.", "") + TRANSFORM(m.MonthVal) + m.MonthLeap)

		RETURN EVL(m.Name, .NULL.)

	ENDFUNC

	* calculation to transform a Julian Day Number into a Hebrew calendar date
	* (called from FromJulian method)
	PROCEDURE _fromJulian (JulianDate AS Number, MoonCoding AS Boolean)
	
		SAFETHIS

		LOCAL AdjJulian AS Number
		LOCAL Tishri1 AS Number
		LOCAL LeftOverDays AS Number
		LOCAL DaysInMonth AS Number

		IF m.JulianDate <= HEBREW_BEGIN
		
			STORE 1 TO This.Year, This.Month, This.Date
		
		ELSE

			m.AdjJulian = m.JulianDate - HEBREW_BEGIN
			This.Year = INT(m.AdjJulian / 365) + 1

			m.Tishri1 = This._elapsedCalendarDays(This.Year)
			DO WHILE m.Tishri1 > m.AdjJulian
				This.Year = This.Year - 1
				m.Tishri1 = This._elapsedCalendarDays(This.Year)
			ENDDO
			
			This.Month = 1
			m.LeftOverDays = m.AdjJulian - m.Tishri1
			m.DaysInMonth = This.LastDayOfMonth()
			
			DO WHILE m.LeftOverDays >= m.DaysInMonth
				m.LeftOverDays = m.LeftOverDays - m.DaysInMonth
				This.Month = This.Month + 1
				m.DaysInMonth = This.LastDayOfMonth()
			ENDDO
			
			IF m.MoonCoding AND This.Month > 6
				IF This.IsLeapYear()
					This.Month = This.Month - 14
				ELSE
					This.Month = This.Month - 13
				ENDIF
			ENDIF
			
			This.Day = m.LeftOverDays + 1

		ENDIF
	
	ENDPROC
	
	* calculation to transform a Hebrew calendar date into a Julian Day Number
	* (called from ToJulian method)
	FUNCTION _toJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer)

		LOCAL MonthVal AS Number
		LOCAL JulianDayNumber AS Number
		LOCAL MonthIndex AS Integer

		m.MonthVal = IIF(m.CalMonth < 0, IIF(This.IsLeapYear(m.CalYear), m.CalMonth + 14, m.CalMonth + 13), m.CalMonth)

		m.JulianDayNumber = This._elapsedCalendarDays(m.CalYear)
		
		FOR m.MonthIndex = 1 TO m.MonthVal - 1
			m.JulianDayNumber = m.JulianDayNumber + This.LastDayOfMonth(m.CalYear, m.MonthIndex)
		ENDFOR
		
		m.JulianDayNumber = m.JulianDayNumber + (m.CalDay - 1 + HEBREW_BEGIN)
		
		RETURN m.JulianDayNumber
		
	ENDFUNC

	* auxiliary methods for the Hebrew calendar
	HIDDEN FUNCTION _elapsedCalendarDays (Year AS Number)
	
		LOCAL MonthsElapsed AS Number
		LOCAL PartsElapsed AS Number
		LOCAL HoursElapsed AS Number
		LOCAL ConjunctionDay AS Number
		LOCAL ConjunctionParts AS Number
		LOCAL AlternativeDay As Number

		m.MonthsElapsed = (235 * INT((m.Year - 1) / 19)) + ;
								(12 * ((m.Year - 1) % 19)) + ;
								INT((7 * ((m.Year - 1) % 19) + 1) / 19)
		m.PartsElapsed = 204 + 793 * (m.MonthsElapsed % 1080)
		m.HoursElapsed = 5 + 12 * m.MonthsElapsed + ;
								793 * INT(m.MonthsElapsed / 1080) + ;
								INT(m.PartsElapsed / 1080)
		m.ConjunctionDay = 1 + 29 * m.MonthsElapsed + INT(m.HoursElapsed / 24)
		m.ConjunctionParts = (1080 * (m.HoursElapsed % 24)) + (m.PartsElapsed % 1080)
		
		IF ((m.ConjunctionParts >= 19440) OR (((m.ConjunctionDay % 7) = 2) AND (m.ConjunctionParts >= 9924) AND ;
				!(This.IsLeapYear()))) OR ;
				(((m.ConjunctionDay % 7) = 1) AND (m.ConjunctionParts >= 16789) AND (This.IsLeapYear(m.Year - 1)))
			m.AlternativeDay = m.ConjunctionDay + 1
		ELSE
			m.AlternativeDay = m.ConjunctionDay
		ENDIF
		
		IF INLIST(m.AlternativeDay % 7, 0, 3, 5)
			m.AlternativeDay = m.AlternativeDay + 1
		ENDIF
		
		RETURN m.AlternativeDay
	ENDFUNC

	HIDDEN FUNCTION _longHeshvan (Year AS Number)
		RETURN (This._daysInYear(m.Year) % 10) = 5
	ENDFUNC

	HIDDEN FUNCTION _shortKislev (Year AS Number)
		RETURN (This._daysInYear(m.Year) % 10) = 3
	ENDFUNC

	HIDDEN FUNCTION _daysInYear (Year AS Number)
		RETURN This._elapsedCalendarDays(m.Year + 1) - This._elapsedCalendarDays(m.Year)
	ENDFUNC

ENDDEFINE