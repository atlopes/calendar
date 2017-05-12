
*!*	ChristianJulianCalendar

*!*	A JulianCalendar subclass for the Christian Julian Calendar.

* install dependencies
DO LOCFILE("julian-calendar.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

* First Julian day number
#DEFINE JULIAN_EPOCH	-2
* first BeforeChrist Era year (Year 1 of Julian Calendar)
#DEFINE BCYEAR	4713

#DEFINE SAFETHIS	ASSERT !USED("This") AND VARTYPE(This) == "O"

DEFINE CLASS ChristianJulianCalendar AS JulianCalendar

	* the minimum date
	MinYear = -BCYEAR

	* IsLeapYear()
	* returns .T. if a leap year
	FUNCTION IsLeapYear (Year AS Number)
		IF m.Year < 0
			RETURN ((m.Year + BCYEAR + 1) % 4) = 0
		ELSE
			RETURN (m.Year % 4) = 0
		ENDIF
	ENDFUNC

	* calculation to transform a Julian Day Number into an Christian Julian calendar date
	* (called from FromJulian method)
	PROCEDURE _fromJulian (JulianDate AS Number)

		SAFETHIS

		IF m.JulianDate < JULIAN_EPOCH

			STORE 0 TO This.Year, This.Month, This.Day

		ELSE

			* take in consideration the Christian Era
			This.Year = INT((m.JulianDate + JULIAN_EPOCH) / 366) - BCYEAR + 1
			* Julian BC years are shifted away from 0 (the year 0 did not existed)
			IF This.Year <= 0
				This.Year = This.Year - 1
			ENDIF

			* the same precaution while going from the approximation to the exact year
			DO WHILE m.JulianDate >= This._toJulian(EVL(This.Year + 1,1), 1, 1)
				This.Year = EVL(This.Year + 1, 1)
			ENDDO

			This.Month = 1
			DO WHILE m.JulianDate > This._toJulian(This.Year, This.Month, This.LastDayOfMonth())
				This.Month = This.Month + 1
			ENDDO

			This.Day = m.JulianDate - This._toJulian(This.Year, This.Month, 1) + 1

		ENDIF

	ENDPROC
	
	* calculation to transform a Christian Julian calendar date into a Julian Day Number
	* (called from ToJulian method)
	FUNCTION _toJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer)

		LOCAL JulianYear AS Number
		LOCAL DaysThisYear AS Number
		LOCAL MonthIndex AS Number

		* get the Julian year for the Christian year
		IF m.CalYear < 0
			* in this case, the Julian year must compensate for the shift-away from non-existent Christian Year Zero
			m.JulianYear = m.CalYear + BCYEAR + 1
		ELSE
			m.JulianYear = m.CalYear + BCYEAR
		ENDIF

		m.DaysThisYear = m.CalDay
		FOR m.MonthIndex = 1 TO m.CalMonth - 1
			m.DaysThisYear = m.DaysThisYear + This.LastDayOfMonth(m.CalYear, m.MonthIndex)
		ENDFOR

		RETURN m.DaysThisYear + 365 * (m.JulianYear - 1) + INT((m.JulianYear - 1) / 4)

	ENDFUNC

ENDDEFINE