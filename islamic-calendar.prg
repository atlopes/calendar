
*!*	IslamicCalendar

*!*	A CalendarCalc subclass for the Islamic Calendar.
*!*	Locales are stored in islamic.xml file.

*!*	Algorithms based on Calendar.c, a C++ transcript from the
*!*	original LISP code used for
*!*	Calendrical Calculations'' by Nachum Dershowitz and Edward M. Reingold,
*!*	Software - Practice & Experience, vol. 20, no. 9 (September, 1990), pp. 899--928.

* install dependencies
DO LOCFILE("calendar.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

* Julian day number of (1 Muharram 1) - 1
* - this constant is not the same used in Calendar.C
#DEFINE ISLAMIC_EPOCH	1948439

#DEFINE SAFETHIS	ASSERT !USED("This") AND VARTYPE(This) == "O"

DEFINE CLASS IslamicCalendar AS CalendarCalc

	VocabularySource = "islamic.xml"

	* IsLeapYear()
	* returns .T. if an Islamic leap year
	FUNCTION IsLeapYear (Year AS Number)

		SAFETHIS
		
		ASSERT PCOUNT() = 0 OR VARTYPE(m.Year) == "N" ;
			MESSAGE "Numeric parameter expected."

		IF PCOUNT() = 0
			m.Year = This.Year
		ENDIF

		RETURN (((11 * m.Year) + 14) % 30) < 11
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
		CASE BETWEEN(m.Month, 1, 12) AND (((m.Month % 2) = 1) OR ((m.Month = 12) AND This.IsLeapYear(m.Year)))
			RETURN 30
		CASE BETWEEN(m.Month, 1, 12) AND (m.Month %2 = 0)
			RETURN 29
		OTHERWISE
			RETURN 0
		ENDCASE

	ENDFUNC

	* calculation to transform a Julian Day Number into an Islamic calendar date
	* (called from FromJulian method)
	PROCEDURE _fromJulian (JulianDate AS Number)
	
		SAFETHIS

		IF m.JulianDate <= ISLAMIC_EPOCH

			STORE 0 TO This.Year, This.Month, This.Day

		ELSE

			This.Year = INT((m.JulianDate - ISLAMIC_EPOCH) / 355)
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
	
	* calculation to transform an Islamic calendar date into a Julian Day Number
	* (called from ToJulian method)
	FUNCTION _toJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer)

		RETURN m.CalDay + 29 * (m.CalMonth - 1) + INT(m.CalMonth / 2) + 354 * (m.CalYear - 1) + ;
				INT((3 + (11 * m.CalYear)) / 30) + ISLAMIC_EPOCH

	ENDFUNC

ENDDEFINE