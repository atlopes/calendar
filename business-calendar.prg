
*!*	 BusinessCalendar

*!*	 A GregorianCalendar sub-class to handle business days

*!*	 Introduces a method to calculate business days to calendar days equivalence

IF _VFP.StartMode = 0
	DO LOCFILE("gregorian-calendar.prg")
ELSE
	DO gregorian-calendar.prg
ENDIF

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

#DEFINE SAFETHIS	ASSERT !USED("This") AND VARTYPE(This) == "O"

DEFINE CLASS BusinessCalendar AS GregorianCalendar

	* the regular week length
	WeekLength = 7
	* the business week length
	BusinessWeekLength = 5
	* the first day of the business week (1 = monday, ...)
	FirstBusinessDay = 1

	_MemberData = '<VFPData>' + ;
						'<memberdata name="businessweeklength" type="property" display="BusinessWeekLength" />' + ;
						'<memberdata name="firstbusinessday" type="property" display="FirstBusinessDay" />' + ;
						'<memberdata name="weeklength" type="property" display="WeekLength" />' + ;
						'<memberdata name="advancebusinessdays" type="mthod" display="AdvanceBusinessDays" />' + ;
						'<memberdata name="businessweekday" type="mthod" display="BusinessWeekday" />' + ;
						'</VFPData>'

	* AdvanceBusinessDays
	* calculate the number of calendar days that corresponds to business days
	FUNCTION AdvanceBusinessDays (BusinessDaysToAdvance AS Integer) AS Integer

		SAFETHIS

		ASSERT VARTYPE(m.BusinessDaysToAdvance) == "N" AND m.BusinessDaysToAdvance >= 0 ;
			MESSAGE "Numeric parameter greater or equal to Zero expected."

		LOCAL StartDate AS Date
		LOCAL EndDate AS Date
		LOCAL TestDate AS Date
		LOCAL CalendarDaysToAdvance AS Integer
		LOCAL InitialAdvance AS Integer
		LOCAL StartYear AS Integer
		LOCAL EndYear AS Integer
		LOCAL YearsToConsider AS Integer
		LOCAL HolidaysCursor AS String
		LOCAL TempCursor AS String
		LOCAL TestHolidays AS Boolean
		LOCAL HolidaysInPeriod AS Integer
		LOCAL LoopIndex AS Integer
		LOCAL CurrentArea AS Integer
		LOCAL ARRAY Holidays(1)
		LOCAL WeekendLength AS Integer

		m.WeekendLength = This.WeekLength - This.BusinessWeekLength

		* calculate the initial advance, to put the start at a business day
		IF This.BusinessWeekday() > This.BusinessWeekLength
			m.InitialAdvance = This.WeekLength - This.BusinessWeekday() + 1
			This.DaysAdd(m.InitialAdvance)
		ELSE
			m.InitialAdvance = 0
		ENDIF

		* get a copy of the current date in a Date value
		m.StartYear = This.Year
		m.StartDate = This.ToSystem()

		* business days to advance in regular business weeks (holidays are disregarded)
		m.CalendarDaysToAdvance = m.BusinessDaysToAdvance + INT((This.BusinessWeekday() + m.BusinessDaysToAdvance- 1) / This.BusinessWeekLength) * m.WeekendLength

		* jump to the date, get a copy as a Date value
		This.DaysAdd(m.CalendarDaysToAdvance)
		m.EndYear = This.Year + 1
		m.EndDate = This.ToSystem()

		* get a list of events in the current yearm, and in the years to come (just to be safe)
		* find safe names for the cursors
		m.CurrentArea = SELECT()
		m.HolidaysCursor = "holidays"
		m.TempCursor = "temp"
		m.LoopIndex = 1
		DO WHILE USED(m.HolidaysCursor)
			m.HolidaysCursor = "holidays_" + LTRIM(STR(m.LoopIndex, 10, 0))
			m.LoopIndex = m.LoopIndex + 1
		ENDDO
		m.LoopIndex = 1
		DO WHILE USED(m.TempCursor)
			m.TempCursor = "temp_" +  LTRIM(STR(m.LoopIndex, 10, 0))
			m.LoopIndex = m.LoopIndex + 1
		ENDDO

		* and insert the events
		FOR m.YearsToConsider = m.StartYear TO m.EndYear
			This.SetEvents(m.YearsToConsider)
			IF m.YearsToConsider = m.StartYear
				This.EventsToCursor(m.HolidaysCursor)
			ELSE
				This.EventsToCursor(m.TempCursor)
				INSERT INTO (m.HolidaysCursor) SELECT * FROM (m.TempCursor)
				USE IN (m.TempCursor)
			ENDIF
		ENDFOR

		m.TestHolidays = .T.
		* the initial test period covers all advanced days, so far (between the start and initial end dates)
		m.TestDate = m.StartDate

		DO WHILE m.TestHolidays

			DIMENSION m.Holidays(1)
			m.Holidays(1) = .F.

			* get the holidays in the current test period
			SELECT DISTINCT(SystemDate) ;
				FROM (m.HolidaysCursor) ;
				WHERE SystemDate BETWEEN m.TestDate AND m.EndDate ;
					AND This.BusinessWeekday(Year, Month, Day) <= This.BusinessWeekLength ;
					AND Observed AND Scope == "National" ;
				INTO ARRAY Holidays

			m.HolidaysInPeriod = IIF(TYPE("m.Holidays(1)") == "L", 0, ALEN(m.Holidays))

			* if there are holidays in the period
			IF m.HolidaysInPeriod != 0

				* prepare the next test period
				m.TestDate = m.EndDate + 1
				* advance considering holidays but also weekends
				m.CalendarDaysToAdvance = m.CalendarDaysToAdvance + m.HolidaysInPeriod + INT((This.BusinessWeekday() + m.HolidaysInPeriod - 1) / This.BusinessWeekLength) * m.WeekendLength

				* make the calculation (it's safe to use the Date type)
				m.EndDate = m.StartDate + m.CalendarDaysToAdvance
				This.FromSystem(m.EndDate)
			ELSE
				* no more holidays, we are done
				m.TestHolidays = .F.
			ENDIF
		ENDDO

		* restore the workarea
		USE IN (m.HolidaysCursor)
		SELECT (m.CurrentArea)

		* the date is the current date, return the number of calendar days
		RETURN m.CalendarDaysToAdvance + m.InitialAdvance

	ENDFUNC

	* BusinessWeekday
	* return the business week day of a date (1 = first business week day)
	FUNCTION BusinessWeekday (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer)

		LOCAL OrdinalWeekday AS Integer
		LOCAL BusinessWeekday AS Integer

		IF PCOUNT() = 0
			m.OrdinalWeekday = This.Weekday()
		ELSE
			m.OrdinalWeekday = This.Weekday(m.CalYear, m.CalMonth, m.CalDay)
		ENDIF

		IF This.FirstBusinessDay != 1
			m.BusinessWeekday = m.OrdinalWeekday - This.FirstBusinessDay + 1
			IF m.BusinessWeekday < 0
				m.BusinessWeekday = m.BusinessWeekday + This.WeekLength 
			ENDIF
		ELSE
			m.BusinessWeekday = m.OrdinalWeekday
		ENDIF

		RETURN m.BusinessWeekday

	ENDFUNC

ENDDEFINE
