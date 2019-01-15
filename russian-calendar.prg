
*!*	RussianCalendar

*!*	A Gregorian Calendar subclass for the Russian Calendar.

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

DEFINE CLASS RussianCalendar AS GregorianCalendar

	AdoptionYear = 1918
	AdoptionMonth = 2
	AdoptionDay = 14
	LastJulianYear = 1918
	LastJulianMonth = 1
	LastJulianDay = 31

ENDDEFINE