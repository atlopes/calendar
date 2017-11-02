
*!*	USCalendarEvents

*!*	A CalendarEventProcessor sub-class for US events

* dependencies
DO LOCFILE("british-calendar.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

DEFINE CLASS USCalendarEvents AS CalendarEventProcessor

	ReferenceCalendarClass = "BritishCalendar"
	EventsDefinition = LOCFILE("us_events.xml")

ENDDEFINE
