
*!*	BritishCalendar

*!*	A Gregorian Calendar subclass for the British Calendar.

* install dependencies
DO gregorian-calendar.prg

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

DEFINE CLASS BritishCalendar AS GregorianCalendar

	AdoptionYear = 1752
	AdoptionMonth = 9
	AdoptionDay = 14
	LastJulianYear = 1752
	LastJulianMonth = 9
	LastJulianDay = 2

ENDDEFINE