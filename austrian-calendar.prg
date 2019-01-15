
*!*	AustrianCalendar

*!*	A Gregorian Calendar subclass for the Austrian Calendar.

* install dependencies
IF _VFP.StartMode = 0
	DO LOCFILE("gregorian-calendar.prg")
ELSE
	DO gregorian-calendar.prg
ENDIF

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

DEFINE CLASS AustrianCalendar AS GregorianCalendar

	AdoptionYear = 1583
	AdoptionMonth = 10
	AdoptionDay = 16
	LastJulianYear = 1583
	LastJulianMonth = 10
	LastJulianDay = 5

ENDDEFINE