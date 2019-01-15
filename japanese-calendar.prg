
*!*	JapaneseCalendar

*!*	A Gregorian Calendar subclass for the Japanese Calendar.

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

DEFINE CLASS JapaneseCalendar AS GregorianCalendar

	AdoptionYear = 1873
	AdoptionMonth = 1
	AdoptionDay = 1
	LastJulianYear = 1872
	LastJulianMonth = 12
	LastJulianDay = 19

ENDDEFINE