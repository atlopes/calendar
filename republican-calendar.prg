
*!*	RepublicanCalendar

*!*	A CalendarCalc subclass for the historical French Republican Calendar.
*!*	Locales are stored in republican.xml file.

*!*	The extra 5 or 6 days at the end of a year are coded as belonging to the
*!*	13th month, although the Republican calendar only has 12 month

* install dependencies
DO calendar.prg

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

* the Julian Day Number for 1 Vendémiaire 1 (first day of the calendar)
#DEFINE REPOCH		2375840
* the Julian Day Number for 10 Nivôse 14 (last day of the calendar)
#DEFINE RFINAL		2380687

#DEFINE SAFETHIS	ASSERT !USED("This") AND VARTYPE(This) == "O"

DEFINE CLASS RepublicanCalendar AS CalendarCalc

	MinYear = 1
	MinMonth = 1
	MinDay = 1
	MaxYear = 14
	MaxMonth = 4
	MaxDay = 10
	Historical = .T.

	* IsLeapYear()
	* returns .T. for leap years
	FUNCTION IsLeapYear (Year AS Number) AS Boolean

		SAFETHIS

		ASSERT PCOUNT() = 0 OR VARTYPE(m.Year) == "N" ;
			MESSAGE "Numeric parameter expected."

		IF PCOUNT() = 0
			m.Year = This.Year
		ENDIF

		RETURN INLIST(m.Year, 3, 7, 11)
	ENDFUNC

	* MonthName()
	* gets the name of the month, for the current locale
	* the final days of the year calendar are marked as the 13th month
	FUNCTION MonthName (Month AS Number, Jour AS Number)
	
		SAFETHIS
		
		ASSERT PCOUNT() = 0 OR (VARTYPE(m.Month) == "N" AND (PCOUNT() = 1 OR VARTYPE(m.Jour) == "N")) ;
			MESSAGE "Numeric parameters expected."

		IF PCOUNT() = 0
			m.Month = This.Month
		ENDIF
		IF m.Month = 13 AND PCOUNT() < 2
			m.Jour = This.Day
		ENDIF

		IF ISNULL(This.Vocabulary)
			This.SetVocabulary(LOCFILE("republican.xml"))
		ENDIF

		IF m.Month < 13
			m.Name = This.GetLocale("month." + TRANSFORM(m.Month))
		ELSE
			m.Name = This.GetLocale("month.j." + TRANSFORM(m.Jour))
		ENDIF

		RETURN EVL(m.Name, .NULL.)

	ENDFUNC

	* calculation to transform a Julian Day Number into a Republican calendar date
	* (called from FromJulian method)
	* very simplified calculation, only valid for the legal period of the calendar
	PROCEDURE _fromJulian (JulianDate AS Number)
	
		SAFETHIS

		LOCAL DaysInYear AS Number
		LOCAL DaysLeft AS Number

		IF BETWEEN(m.JulianDate, REPOCH, RFINAL)

			This.Year = 1
			m.DaysLeft = m.JulianDate - REPOCH + 1
			m.DaysInYear = 365
			
			DO WHILE m.DaysLeft > m.DaysInYear
				m.DaysLeft = m.DaysLeft - m.DaysInYear
				This.Year = This.Year + 1
				m.DaysInYear = IIF(This.IsLeapYear(), 366, 365)
			ENDDO

			This.Month = INT((m.DaysLeft - 1)/ 30) + 1
			This.Day = m.DaysLeft % 30
		
		ELSE
			STORE 0 TO This.Day, This.Month, This.Year
		ENDIF

	ENDPROC
	
	* calculation to transform a Republican calendar date into a Julian Day Number
	* (called from ToJulian method)
	* very simplified calculation, only valid for the legal period of the calendar
	FUNCTION _toJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer)

		LOCAL JulianDate AS Number
		LOCAL YearsLeft AS Number

		m.JulianDate = REPOCH + (m.CalMonth - 1) * 30 + (m.CalDay - 1)
		m.YearsLeft = m.CalYear - 1
		DO WHILE m.YearsLeft > 0
			m.JulianDate = m.JulianDate + IIF(This.IsLeapYear(m.YearsLeft), 366, 365)
			m.YearsLeft = m.YearsLeft - 1
		ENDDO

		RETURN m.JulianDate

	ENDFUNC

ENDDEFINE