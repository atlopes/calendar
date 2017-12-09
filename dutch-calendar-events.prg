
*!*	DutchCalendarEvents

*!*	A CalendarEventProcessor sub-class for Dutch events

* dependencies
DO LOCFILE("pascha-calendar-events.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

#DEFINE SAFETHIS	ASSERT !USED("This") AND VARTYPE(This) == "O"

DEFINE CLASS DutchCalendarEvents AS CalendarEventProcessor

	ReferenceCalendarClass = "GregorianCalendar"
	EventsDefinition = LOCFILE("nl_events.xml")

	FUNCTION SetEvents (Year AS Integer) AS Collection

		SAFETHIS

		LOCAL ResultSet AS Collection
		LOCAL CalEvent AS CalendarEvent

		* prepare the broker and the reference calendar, and load fixed events
		m.ResultSet = DODEFAULT(m.Year)

		* moveable events in Dutch calendar are related to Easter
		LOCAL Easter AS PaschaCalendarEvents
		LOCAL EasterEvents AS Collection
		LOCAL EasterEvent AS CalendarEvent

		* use an events processor in unattached mode
		m.Easter = CREATEOBJECT("PaschaCalendarEvents", This.Host)
		* cascade down the default settings
		m.Easter.Observed = This.Observed
		m.Easter.Scope = EVL(This.Scope, "National")

		* set the filter of the events we require
		m.Easter.EventsFilter.Add("Pasen", "pascha.easter")
		m.Easter.EventsFilter.Add("Goede Vrijdag", "pascha.goodfriday")
		m.Easter.EventsFilter.Add("Hemelvaartsdag", "pascha.ascension")
		m.Easter.EventsFilter.Add("Pinksteren", "pascha.pentecost")

		* set the events
		m.EasterEvents = m.Easter.SetEvents(m.Year)

		* and add them to our list
		FOR EACH m.EasterEvent IN m.EasterEvents
			* Easter and Pentecost last for 2 days
			IF m.EasterEvent.Identifier == "pascha.easter" OR m.EasterEvent.Identifier == "pascha.pentecost"
				m.EasterEvent.Duration = 2
			ENDIF
			m.ResultSet.Add(m.EasterEvent, m.EasterEvent.Identifier)
		ENDFOR

		RETURN m.ResultSet

	ENDFUNC

ENDDEFINE
