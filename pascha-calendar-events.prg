
*!*	PaschaCalendarEvents

*!*	A CalendarEventProcessor sub-class for Pascha/Easter related events

* dependencies
DO LOCFILE("gregorian-calendar.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

DEFINE CLASS PaschaCalendarEvents AS CalendarEventProcessor

	ReferenceCalendarClass = "GregorianCalendar"
	EventsDefinition = ""

	FUNCTION SetDefaultOptions

		This.SetOption("AdditionalOffsets", "")

	ENDFUNC

	FUNCTION SetEvents (Year AS Integer) AS Collection

		LOCAL ResultSet AS Collection

		* prepare the broker and the reference calendar
		m.ResultSet = DODEFAULT(m.Year)

		LOCAL GYear AS Integer
		LOCAL GMonth AS Integer
		LOCAL GDay AS Integer

		LOCAL PaschaG AS Integer
		LOCAL PaschaC AS Integer
		LOCAL PaschaI AS Integer
		LOCAL PaschaJ AS Integer
		LOCAL PaschaK AS Integer
		LOCAL PaschaL AS Integer

		LOCAL CalEvent AS CalendarEvent
		LOCAL EasterRelated AS String
		LOCAL RelatedIndex AS Integer
		LOCAL RelatedEvent AS String
		LOCAL RelatedOffset AS Integer
		LOCAL CommonName AS String

		* calculate the Pascha/Easter day for a given year
		m.GYear = This.ReferenceCalendar.Year

		m.PaschaG = m.GYear % 19

		IF m.GYear > This.ReferenceCalendar.AdoptionYear

			m.PaschaC = INT(m.GYear / 100)
			m.PaschaK = INT((m.PaschaC - 17) / 25)
			m.PaschaI = m.PaschaC - INT(m.PaschaC / 4) - INT((m.PaschaC - m.PaschaK) / 3) + 19 * m.PaschaG + 15
			m.PaschaI = m.PaschaI % 30
			m.PaschaI = m.PaschaI - INT(m.PaschaI / 28) * (1 - INT(m.PaschaI / 28) * INT(29 / (m.PaschaI + 1)) * INT((21 - m.PaschaG) / 11))
			m.PaschaJ = m.GYear + INT(m.GYear / 4) + m.PaschaI + 2 - m.PaschaC + INT(m.PaschaC / 4)
			m.PaschaJ = m.PaschaJ % 7

		ELSE

			m.PaschaI = ((19 * m.PaschaG) + 15) % 30
			m.PaschaJ = (m.GYear + INT(m.GYear / 4) + m.PaschaI) % 7

		ENDIF

		m.PaschaL = m.PaschaI - m.PaschaJ

		* get the month and the day		
		m.GMonth = 3 + INT((m.PaschaL + 40) / 44)
		m.GDay = m.PaschaL + 28 - 31 * INT(m.GMonth / 4)

		* set a list of related events, and the offset, in days, from the Easter sunday
		m.EasterRelated = TRIM("easter:0 septuagesima:-63 quinquagesima:-49 carnival:-47 " + ;
								"ashwednesday:-46 palmsunday:-7 goodfriday:-2 rogationsunday:35 " + ;
								"ascension:39 pentecost:49 trinitysunday:56 corpuschristi:60 " + ;
								" " + This.GetOption("AdditionalOffsets"))

		FOR m.RelatedIndex = 1 TO GETWORDCOUNT(m.EasterRelated, " ")

			m.RelatedEvent = GETWORDNUM(m.EasterRelated, m.RelatedIndex, " ")
			m.RelatedOffset = VAL(SUBSTR(m.RelatedEvent, AT(":", m.RelatedEvent) + 1))
			m.RelatedEvent = "pascha." + LEFT(m.RelatedEvent, AT(":", m.RelatedEvent) - 1)

			* if the event is filtered out, skip to the next in the list
			IF This.EventsFilter.Count > 0
				IF This.EventsFilter.GetKey(m.RelatedEvent) = 0
					LOOP
				ELSE
					m.CommonName = This.EventsFilter(m.RelatedEvent)
				ENDIF
			ELSE
				m.CommonName = ""
			ENDIF

			* Easter
			This.ReferenceCalendar.SetDate(m.GYear, m.GMonth, m.GDay)
			IF m.RelatedOffset != 0
				This.ReferenceCalendar.DaysAdd(m.RelatedOffset)
			ENDIF
			* set the date in the target calendar (may be a different calendar system)
			This.Broker.SetDate(This.ReferenceCalendar)

			* if it fits in the year
			IF This.Broker.Year = m.Year
				* create and populate the event
				m.CalEvent = CREATEOBJECT("CalendarEvent")
				WITH m.CalEvent
					.Identifier = m.RelatedEvent
					.Observed = This.Observed
					.Scope = This.Scope
					.CommonName = m.CommonName
					.Origin = "Religious"
					.Year = This.Broker.Year
					.Month = This.Broker.Month
					.Day = This.Broker.Day
				ENDWITH

				* add to the events list
				m.ResultSet.Add(m.CalEvent, m.CalEvent.Identifier)
			ENDIF

		ENDFOR

		RETURN m.ResultSet

	ENDFUNC

ENDDEFINE
