
*!*	RomanianCalendar

*!*	A Gregorian Calendar subclass for the Romanian Calendar.

* install dependencies
DO LOCFILE("Gregorian-Calendar.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

DEFINE CLASS RomanianCalendar AS GregorianCalendar

	AdoptionYear = 1919
	AdoptionMonth = 4
	AdoptionDay = 14
	LastJulianYear = 1919
	LastJulianMonth = 3
	LastJulianDay = 31

ENDDEFINE