
*!*	ChristianJulianCalendar

*!*	A JulianCalendar subclass for the Christian Julian Calendar.

* install dependencies
DO julian-calendar.prg

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

* First Julian day number, adjusted to Julian Epoch (-2)
#DEFINE CHRISTIAN_EPOCH	1721424

#DEFINE SAFETHIS	ASSERT !USED("This") AND VARTYPE(This) == "O"

DEFINE CLASS ChristianJulianCalendar AS JulianCalendar

	* calculation to transform a Julian Day Number into a Christian Julian calendar date
	* (called from FromJulian method)
	PROCEDURE _fromJulian (JulianDate AS Number)

		SAFETHIS

		IF m.JulianDate < CHRISTIAN_EPOCH

			STORE 0 TO This.Year, This.Month, This.Day

		ELSE

			This.Year = INT((m.JulianDate - CHRISTIAN_EPOCH) / 366)

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
	
	* calculation to transform a Christian Julian calendar date into a Julian Day Number
	* (called from ToJulian method)
	FUNCTION _toJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer)

		LOCAL DaysThisYear AS Number
		LOCAL MonthIndex AS Number

		m.DaysThisYear = m.CalDay
		FOR m.MonthIndex = 1 TO m.CalMonth - 1
			m.DaysThisYear = m.DaysThisYear + This.LastDayOfMonth(m.CalYear, m.MonthIndex)
		ENDFOR

		RETURN m.DaysThisYear + 365 * (m.CalYear - 1) + INT((m.CalYear - 1) / 4) + (CHRISTIAN_EPOCH - 1)

	ENDFUNC

ENDDEFINE