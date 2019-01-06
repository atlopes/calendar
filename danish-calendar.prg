
*!*	DanishCalendar

*!*	A Gregorian Calendar subclass for the Danish Calendar.

* install dependencies
DO gregorian-calendar.prg

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

DEFINE CLASS DanishCalendar AS GregorianCalendar

	AdoptionYear = 1700
	AdoptionMonth = 3
	AdoptionDay = 1
	LastJulianYear = 1700
	LastJulianMonth = 2
	LastJulianDay = 18

ENDDEFINE