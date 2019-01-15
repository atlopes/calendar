
*!*	GreekCalendar

*!*	A Gregorian Calendar subclass for the Greek Calendar.

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

DEFINE CLASS GreekCalendar AS GregorianCalendar

	AdoptionYear = 1923
	AdoptionMonth = 3
	AdoptionDay = 1
	LastJulianYear = 1923
	LastJulianMonth = 2
	LastJulianDay = 15

ENDDEFINE