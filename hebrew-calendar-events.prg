
*!*	HebrewCalendarEvents

*!*	A CalendarEventProcessor sub-class for Hebrew events

* dependencies
DO hebrew-calendar.prg

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

DEFINE CLASS HebrewCalendarEvents AS CalendarEventProcessor

	ReferenceCalendarClass = "HebrewCalendar"
	EventsDefinition = LOCFILE("hebrew_events.xml")

ENDDEFINE
