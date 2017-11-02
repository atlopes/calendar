
*!*	SolarCalendarEvents

*!*	A CalendarEventProcessor sub-class for Solar related events

*!*	Source: "Equinox and Solstice Calculation", by Vernero Cifagni
*!*	Transcripted from the C++ code in http://www.codeguru.com/cpp/cpp/date_time/article.php/c4763/Equinox-and-Solstice-Calculation.htm
*!*	Declared accuracy: ~15 minutes

* dependencies
DO LOCFILE("gregorian-calendar.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

DEFINE CLASS SolarCalendarEvents AS CalendarEventProcessor

	ReferenceCalendarClass = "GregorianCalendar"
	EventsDefinition = ""

	FUNCTION SetDefaultOptions

		* Set "S" for South Hemisphere. If both hemispheres are required, instantiate the class twice with different options
		This.SetOption("Hemisphere", "N")
		* set to .NULL. for the system's timezone (measured in hours)
		This.SetOption("Timezone", 0)
		* comma delimited list of season names
		This.SetOption("CommonNames", "Spring,Summer,Autumn,Winter")

	ENDFUNC

	FUNCTION SetEvents (Year AS Integer) AS Collection

		LOCAL Result AS Collection

		m.Result = DODEFAULT(m.Year)

		RETURN This.CalculateYearEvents(m.Year, This.ReferenceCalendar.Year, m.Result)

	ENDFUNC

	HIDDEN FUNCTION CalculateYearEvents (Year AS Integer, RefYear AS Integer, SolarEvents AS Collection, Retrying AS Boolean) AS Collection

		LOCAL GYear AS Integer
		LOCAL ARRAY Solar(4)
		LOCAL ARRAY SolarId(4)
		LOCAL ARRAY SolarName(4)
		LOCAL Unfit AS Integer
		LOCAL EventIndex AS Integer
		LOCAL CalEvent AS CalendarEvent
		LOCAL Hemisphere AS String
		LOCAL Timezone AS Integer
		LOCAL CommonNames AS String

		* set the event reference number for every solar events
		m.GYear = (m.RefYear - 2000) / 1000
		m.Solar(1) = 2451623.80984 + 365242.37404 * m.GYear + 0.05169 * m.GYear^2 - 0.00411 * m.GYear^3 - 0.00057 * m.GYear^4
		m.Solar(2) = 2451716.56767 + 365241.62603 * m.GYear + 0.00325 * m.GYear^2 + 0.00888 * m.GYear^3 - 0.00030 * m.GYear^4
		m.Solar(3) = 2451810.21715 + 365242.01767 * m.GYear - 0.11575 * m.GYear^2 + 0.00337 * m.GYear^3 + 0.00078 * m.GYear^4
		m.Solar(4) = 2451900.05952 + 365242.74049 * m.GYear - 0.06223 * m.GYear^2 - 0.00823 * m.GYear^3 + 0.00032 * m.GYear^4

		m.Timezone = This.GetTimezone()
		m.Hemisphere = This.GetOption("Hemisphere")
		m.CommonNames = This.GetOption("CommonNames")
		
		IF m.Hemisphere == "S"
			m.SolarId(1) = "aequinox"
			m.SolarName(1) = GETWORDNUM(m.CommonNames, 3, ",")
			m.SolarId(2) = "wsolstice"
			m.SolarName(2) = GETWORDNUM(m.CommonNames, 4, ",")
			m.SolarId(3) = "vequinox"
			m.SolarName(3) = GETWORDNUM(m.CommonNames, 1, ",")
			m.SolarId(4) = "ssolstice"
			m.SolarName(4) = GETWORDNUM(m.CommonNames, 2, ",")
		ELSE
			m.SolarId(1) = "vequinox"
			m.SolarName(1) = GETWORDNUM(m.CommonNames, 1, ",")
			m.SolarId(2) = "ssolstice"
			m.SolarName(2) = GETWORDNUM(m.CommonNames, 2, ",")
			m.SolarId(3) = "aequinox"
			m.SolarName(3) = GETWORDNUM(m.CommonNames, 3, ",")
			m.SolarId(4) = "wsolstice"
			m.SolarName(4) = GETWORDNUM(m.CommonNames, 4, ",")
		ENDIF

		m.Unfit = 0

		* go through all events
		FOR m.EventIndex = 1 TO 4

			* set from a Gregorian day
			This.Broker.SetDate(This.CalculateSeasonEvent(m.Solar(m.EventIndex), m.Timezone))

			* if it fits in the intended year, add to the events collection
			IF This.Broker.Year = m.Year

				m.CalEvent = CREATEOBJECT("CalendarEvent")
				WITH m.CalEvent
					.Identifier = "solar." + m.SolarId(m.EventIndex)
					.Commonname = m.SolarName(m.EventIndex)
					.Scope = "Natural"
					.Origin = "Natural"
					.Day = This.Broker.Day
					.Month = This.Broker.Month
					.Year = This.Broker.Year
				ENDWITH

				m.SolarEvents.Add(m.CalEvent, m.CalEvent.Identifier)

			ELSE

				* if the first event does not fit, fetch the events from the next Gregorian year
				IF m.EventIndex = 1
					m.Unfit = 1
				ELSE
				* otherwise, if all previous events fit, try the previous Gregorian year
					m.Unfit = EVL(m.Unfit, -1)
				ENDIF

			ENDIF

		ENDFOR

		IF !m.Retrying AND m.Unfit != 0
			m.SolarEvents = This.CalculateYearEvents(m.Year, m.RefYear + m.Unfit, m.SolarEvents, .T.)
		ENDIF
			
		RETURN m.SolarEvents

	ENDFUNC

	HIDDEN FUNCTION CalculateSeasonEvent (EvRef AS Number, Timezone AS Integer) AS GregorianCalendar

		LOCAL JDN AS Number
		LOCAL UT AS Number
		LOCAL x, z
		LOCAL Year, Month, Day, Hour, Minute
		LOCAL daysPer400Years, fudgedDaysPer4000Years
		LOCAL SeasonEvent AS GregorianCalendar

		m.EvRef = m.EvRef + 0.5
		m.JDN = INT(m.EvRef)
		m.UT = m.EvRef - m.JDN
		m.x = m.JDN + 68569

		IF m.JDN <= 2299160
			m.x = m.x + 38
			m.daysPer400Years = 146100
			m.fudgedDaysPer4000Years = 1461000 + 1
		ELSE
			m.daysPer400Years = 146097
			m.fudgedDaysPer4000Years = 1460970 + 31
		ENDIF

		m.z = INT(4 * m.x / m.daysPer400Years)
		m.x = m.x - INT((m.daysPer400Years * m.z + 3) / 4)

		m.Year = INT(4000 * (m.x + 1) / m.fudgedDaysPer4000Years)
		m.x = m.x - INT(1461 * m.Year / 4) + 31
		m.Month = INT(80 * m.x / 2447)
		m.Day = m.x - INT(2447 * m.Month / 80)
		m.x = INT(m.Month / 11)
		m.Month = m.Month + 2 - 12 * m.x
		m.Year = 100 * (m.z - 49) + m.Year + m.x

		m.Hour = INT(m.UT * 24)
		m.Minute = INT((m.UT * 24 - m.Hour) * 60)

		m.SeasonEvent = CREATEOBJECT("GregorianCalendar")
		m.SeasonEvent.SetDate(m.Year, m.Month, m.Day)
		m.Hour = m.Hour + m.Timezone
		IF m.Hour < 0
			m.SeasonEvent.DaysAdd(-1)
		ELSE
			IF m.Hour >= 24
				m.SeasonEvent.DaysAdd(1)
			ENDIF
		ENDIF
		
		RETURN m.SeasonEvent

	ENDFUNC

	* get the timezone (measured in hours) from the processor option, or from the system if set to NULL
	HIDDEN FUNCTION GetTimezone ()

		LOCAL Timezone AS Integer
		LOCAL WMI AS Object
		LOCAL Instances AS Object
		LOCAL Instance AS Object

		m.Timezone = This.GetOption("TimeZone")
		IF ISNULL(m.Timezone)

			m.WMI = GETOBJECT("WINMGMTS:\\.\ROOT\cimv2")

			m.Instances = m.WMI.Execquery("SELECT * FROM Win32_TimeZone", , 48)

			FOR EACH m.Instance IN m.Instances
				m.Timezone = m.Instance.Bias / 60
			ENDFOR

		ELSE

			m.Timezone = VAL(TRANSFORM(m.Timezone))

		ENDIF

		RETURN m.Timezone

	ENDFUNC

ENDDEFINE
