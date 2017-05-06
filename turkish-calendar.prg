
*!*	TurkishCalendar

*!*	A Gregorian Calendar subclass for the Turkish Calendar.

* install dependencies
DO LOCFILE("Gregorian-Calendar.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

DEFINE CLASS TurkishCalendar AS GregorianCalendar

	AdoptionYear = 1927
	AdoptionMonth = 1
	AdoptionDay = 1
	LastJulianYear = 1926
	LastJulianMonth = 12
	LastJulianDay = 18

ENDDEFINE