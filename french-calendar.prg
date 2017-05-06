
*!*	FrenchCalendar

*!*	A Gregorian Calendar subclass for the French Calendar.

* install dependencies
DO LOCFILE("Gregorian-Calendar.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

DEFINE CLASS FrenchCalendar AS GregorianCalendar

	AdoptionYear = 1582
	AdoptionMonth = 12
	AdoptionDay = 20
	LastJulianYear = 1582
	LastJulianMonth = 12
	LastJulianDay = 9

ENDDEFINE