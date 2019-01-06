
*!*	BulgarianCalendar

*!*	A Gregorian Calendar subclass for the Bulgarian Calendar.

* install dependencies
DO gregorian-calendar.prg

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

DEFINE CLASS BulgarianCalendar AS GregorianCalendar

	AdoptionYear = 1916
	AdoptionMonth = 4
	AdoptionDay = 14
	LastJulianYear = 1916
	LastJulianMonth = 3
	LastJulianDay = 31

ENDDEFINE