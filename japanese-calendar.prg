
*!*	JapaneseCalendar

*!*	A Gregorian Calendar subclass for the Japanese Calendar.

* install dependencies
DO LOCFILE("Gregorian-Calendar.prg")

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