
*!*	PortugueseCalendarEvents

*!*	A CalendarEventProcessor sub-class for Portuguese events

* dependencies
DO LOCFILE("pascha-calendar-events.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

DEFINE CLASS PortugueseCalendarEvents AS CalendarEventProcessor

	ReferenceCalendarClass = "GregorianCalendar"
	EventsDefinition = LOCFILE("pt_events.xml")

	FUNCTION SetEvents (Year AS Integer) AS Collection

		LOCAL ResultSet AS Collection

		* prepare the broker and the reference calendar, and load fixed events
		m.ResultSet = DODEFAULT(m.Year)

		* moveable events in Portuguese calendar are related to Easter
		LOCAL Pascoa AS PaschaCalendarEvents
		LOCAL PascoaEvents AS Collection
		LOCAL PascoaEvent AS CalendarEvent

		* use an events processor in unattached mode
		m.Pascoa = CREATEOBJECT("PaschaCalendarEvents", This.Host)
		* cascade down the default settings
		m.Pascoa.Observed = This.Observed
		m.Pascoa.Scope = EVL(This.Scope, "National")

		* set the filter of the events we require
		m.Pascoa.EventsFilter.Add("Páscoa", "pascha.easter")
		m.Pascoa.EventsFilter.Add("Sexta-feira Santa", "pascha.goodfriday")
		m.Pascoa.EventsFilter.Add("Corpo de Deus", "pascha.corpuschristi")

		* set the events
		m.PascoaEvents = m.Pascoa.SetEvents(m.Year)

		* and add them to our list
		FOR EACH m.PascoaEvent IN m.PascoaEvents
			m.ResultSet.Add(m.PascoaEvent, m.PascoaEvent.Identifier)
		ENDFOR

		RETURN m.ResultSet

	ENDFUNC

ENDDEFINE
