
*!*	USCalendarEvents

*!*	A CalendarEventProcessor sub-class for US events

* dependencies
IF _VFP.StartMode = 0
	DO LOCFILE("british-calendar.prg")
ELSE
	DO british-calendar.prg
ENDIF

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

DEFINE CLASS USCalendarEvents AS CalendarEventProcessor

	ReferenceCalendarClass = "BritishCalendar"
	EventsDefinition = "us_events.xml"

ENDDEFINE
