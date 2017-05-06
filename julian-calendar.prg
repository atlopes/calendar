
*!*	JulianCalendar

*!*	A Calendar subclass for the Julian Calendar.
*!*	Locales are stored in julian.xml file.

*!*	Algorithms based on Calendar.c, a C++ transcript from the
*!*	original LISP code used for
*!*	Calendrical Calculations'' by Nachum Dershowitz and Edward M. Reingold,
*!*	Software - Practice & Experience, vol. 20, no. 9 (September, 1990), pp. 899--928.

* install dependencies
DO LOCFILE("Calendar.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

* First Julian day number
#DEFINE JULIAN_EPOCH	-2

#DEFINE SAFETHIS	ASSERT !USED("This") AND VARTYPE(This) == "O"

DEFINE CLASS JulianCalendar AS Calendar

	* IsLeapYear()
	* returns .T. if a Julian leap year
	FUNCTION IsLeapYear (Year AS Number)
		RETURN (m.Year % 4) = 0
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

		DO CASE
		CASE INLIST(m.Month, 1, 3, 5, 7, 8, 10, 12)
			RETURN 31
		CASE m.Month = 2
			RETURN 28 + IIF(This.IsLeapYear(m.Year), 1, 0)
		OTHERWISE
			RETURN 30
		ENDCASE

	ENDFUNC

	* MonthName()
	* gets the name of the month, for the current locale
	FUNCTION MonthName (Month AS Number)
	
		SAFETHIS
		
		ASSERT PCOUNT() = 0 OR VARTYPE(m.Month) = "N" ;
			MESSAGE "Numeric parameter expected."

		IF PCOUNT() = 0
			m.Month = This.Month
		ENDIF

		IF ISNULL(This.Vocabulary)
			This.SetVocabulary(LOCFILE("julian.xml"))
		ENDIF

		m.Name = This.GetLocale("month." + TRANSFORM(m.Month))

		RETURN EVL(m.Name, .NULL.)

	ENDFUNC

	* calculation to transform a Julian Day Number into an Julian calendar date
	* (called from FromJulian method)
	PROCEDURE _fromJulian (JulianDate AS Number)
	
		SAFETHIS

		IF m.JulianDate < JULIAN_EPOCH

			STORE 0 TO This.Year, This.Month, This.Day

		ELSE

			This.Year = INT((m.JulianDate + JULIAN_EPOCH) / 366)
			DO WHILE m.JulianDate >= This._toJulian(This.Year + 1, 1, 1)
				This.Year = This.Year + 1
			ENDDO

			This.Month = 1
			DO WHILE m.JulianDate > This._toJulian(This.Year, This.Month, This.LastDayOfMonth())
				This.Month = This.Month + 1
			ENDDO

			This.Day = m.JulianDate - This._toJulian(This.Year, This.Month, 1) + 1

		ENDIF

	ENDPROC
	
	* calculation to transform a Julian calendar date into a Julian Day Number
	* (called from ToJulian method)
	FUNCTION _toJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer)

		LOCAL DaysThisYear AS Number
		LOCAL MonthIndex AS Number

		m.DaysThisYear = m.CalDay
		FOR m.MonthIndex = 1 TO m.CalMonth - 1
			m.DaysThisYear = m.DaysThisYear + This.LastDayOfMonth(m.CalYear, m.MonthIndex)
		ENDFOR

		RETURN m.DaysThisYear + 365 * (m.CalYear - 1) + INT((m.CalYear - 1) / 4)

	ENDFUNC

ENDDEFINE