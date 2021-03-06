
*!*	PortugueseCalendarEvents

*!*	A CalendarEventProcessor sub-class for Portuguese events

* dependencies
IF _VFP.StartMode = 0
	DO LOCFILE("pascha-calendar-events.prg")
ELSE
	DO pascha-calendar-events.prg
ENDIF

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

#DEFINE SAFETHIS	ASSERT !USED("This") AND VARTYPE(This) == "O"

DEFINE CLASS PortugueseCalendarEvents AS CalendarEventProcessor

	ReferenceCalendarClass = "GregorianCalendar"
	EventsDefinition = "pt_events.xml"

	FUNCTION SetEvents (Year AS Integer) AS Collection

		SAFETHIS

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
		m.Pascoa.EventsFilter.Add("P�scoa", "pascha.easter")
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
