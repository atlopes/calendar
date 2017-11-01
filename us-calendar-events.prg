
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

	FUNCTION SetEvents (Year AS Integer) AS Collection

		LOCAL ResultSet AS Collection

		* prepare the broker and the reference calendar, and load fixed events
		m.ResultSet = DODEFAULT(m.Year)

		LOCAL CalEvent AS CalendarEvent

		* get the 4th Thursday of november, that will be Thanksgiving day
		This.ReferenceCalendar.SetWeekday(This.ReferenceCalendar.Year, 11, 4, 4)
		This.Broker.SetDate(This.ReferenceCalendar)

		* if it fits in the year in the target calendar
		IF This.Broker.Year = m.Year

			* create and populate the event
			m.CalEvent = CREATEOBJECT("CalendarEvent")
			WITH m.CalEvent
				.Identifier = "us.thanksgiving"
				.CommonName = "Thanksgiving"
				.Scope = "National"
				.Observed = This.Observed
				.Year = m.Year
				.Month = This.Broker.Month
				.Day = This.Broker.Day
			ENDWITH

			* add to the fixed  events
			m.ResultSet.Add(m.CalEvent, m.CalEvent.Identifier)

		ENDIF

		RETURN m.ResultSet

	ENDFUNC

ENDDEFINE
