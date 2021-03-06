
*!*	GermanCalendar

*!*	A Gregorian Calendar subclass for the German Calendars (Catholic states and Prussia).

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

DEFINE CLASS GermanCalendar AS GregorianCalendar

	AdoptionYear = 1583
	AdoptionMonth = 1
	AdoptionDay = 11
	LastJulianYear = 1582
	LastJulianMonth = 12
	LastJulianDay = 31

ENDDEFINE

DEFINE CLASS PrussianCalendar AS GregorianCalendar

	AdoptionYear = 1610
	AdoptionMonth = 9
	AdoptionDay = 2
	LastJulianYear = 1610
	LastJulianMonth = 8
	LastJulianDay = 22

ENDDEFINE
