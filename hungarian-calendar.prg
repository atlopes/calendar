
*!*	HungarianCalendar

*!*	A Gregorian Calendar subclass for the Hungarian Calendar.

* install dependencies
DO LOCFILE("Gregorian-Calendar.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

DEFINE CLASS HungarianCalendar AS GregorianCalendar

	AdoptionYear = 1587
	AdoptionMonth = 11
	AdoptionDay = 1
	LastJulianYear = 1587
	LastJulianMonth =10
	LastJulianDay = 21

ENDDEFINE