
*!*	GregorianCalendar

*!*	A Calendar subclass for the Gregorian Calendar, to base other Gregorian Calendar subclasses.
*!*	Locales are stored in julian.xml file.

*!*	Algorithms based on Calendar.c, a C++ transcript from the
*!*	original LISP code used for
*!*	Calendrical Calculations'' by Nachum Dershowitz and Edward M. Reingold,
*!*	Software - Practice & Experience, vol. 20, no. 9 (September, 1990), pp. 899--928.

* install dependencies
DO LOCFILE("christian-julian-Calendar.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

* First Gregorian day number of the Christian Era
#DEFINE GREGORIAN_EPOCH	1721426

#DEFINE SAFETHIS	ASSERT !USED("This") AND VARTYPE(This) == "O"

DEFINE CLASS GregorianCalendar AS Calendar

	ADD OBJECT PreReform AS ChristianJulianCalendar		&& deals with dates before the Gregorian calendar adoption

	VocabularySource = This.PreReform.VocabularySource

	AdoptionYear = 1582
	AdoptionMonth = 10
	AdoptionDay = 15
	LastJulianYear = 1582
	LastJulianMonth = 10
	LastJulianDay = 4
	LastJulianDayNumber = .NULL.

	_MemberData = '<VFPData>' + ;
						'<memberdata name="adoptionyear" type="property" display="AdoptionYear" />' + ;
						'<memberdata name="adoptionmonth" type="property" display="AdoptionMonth" />' + ;
						'<memberdata name="adoptionday" type="property" display="AdoptionDay" />' + ;
						'<memberdata name="lastjulianyear" type="property" display="LastJulianYear" />' + ;
						'<memberdata name="lastjulianmonth" type="property" display="LastJulianMonth" />' + ;
						'<memberdata name="lastjulianday" type="property" display="LastJulianDay" />' + ;
						'<memberdata name="lastjuliandaynumber" type="property" display="LastJulianDayNumber" />' + ;
						'<memberdata name="prereform" type="property" display="PreReform" />' + ;
						'<memberdata name="isreformed" type="method" display="IsReformed" />' + ;
						'</VFPData>'

	* IsReformed()
	* returns .T. if date is after adoption of the Gregorian calendar reform
	FUNCTION IsReformed (Year AS Number, Month AS Number, Day AS Number)

		SAFETHIS

		ASSERT PCOUNT() = 0 OR VARTYPE(m.Year) + VARTYPE(m.Month) + VARTYPE(m.Day) == "NNN" ;
			MESSAGE "Numeric parameters expected."

		IF PCOUNT() = 0
			m.Year = This.Year
			m.Month = This.Month
			m.Day = This.Day
		ENDIF

		RETURN m.Year > This.AdoptionYear OR ;
				(m.Year = This.AdoptionYear AND ;
					(m.Month > This.AdoptionMonth OR (m.Month = This.AdoptionMonth AND m.Day >= This.AdoptionDay)))
	ENDFUNC

	* LastDayOfMonth()
	* returns the day of a month, in a given year
	FUNCTION LastDayOfMonth (Year AS Number, Month AS Number)
	
		SAFETHIS
		
		ASSERT PCOUNT() = 0 OR VARTYPE(m.Year) + VARTYPE(m.Month) == "NN" ;
			MESSAGE "Numeric parameters expected."

		IF PCOUNT() = 0
			m.Year = This.Year
			m.Month = This.Month
		ENDIF

		DO CASE
		CASE INLIST(m.Month, 1, 3, 5, 7, 8, 10, 12)
			RETURN 31
		CASE m.Month = 2
			RETURN 28 + IIF(This.IsLeapYear(m.Year), 1, 0)
		OTHERWISE
			RETURN 30
		ENDCASE

	ENDFUNC

	* IsLeapYear()
	* returns .T. if a Gregorian leap year
	FUNCTION IsLeapYear (Year AS Number)

		SAFETHIS

		ASSERT VARTYPE(m.Year) == "N" ;
			MESSAGE "Numeric parameter expected."

		IF !This.IsReformed(m.Year, 3, 1)
			RETURN (m.Year % 4) = 0
		ELSE
			RETURN (m.Year % 4) = 0 AND ((m.Year % 100) != 0 OR (m.Year % 400) = 0)
		ENDIF

	ENDFUNC

	* calculation to transform a Julian Day Number into a Gregorian calendar date
	* (called from FromJulian method)
	PROCEDURE _fromJulian (JulianDate AS Number)

		LOCAL ReformDayNumber AS Number
		LOCAL DaysInMonth AS Number

		SAFETHIS

		* calculate (once, in the course of an instantiation) the Julian Day Number of the last Julian date of the calendar
		IF ISNULL(This.LastJulianDayNumber )
			This.LastJulianDayNumber = This.PreReform._toJulian(This.LastJulianYear, This.LastJulianMonth, This.LastJulianDay)
		ENDIF

		* use the Julian calculations, but considering the Christian Era
		IF m.JulianDate <= This.LastJulianDayNumber

			This.PreReform._fromJulian(m.JulianDate)
			This.Year = This.PreReform.Year
			This.Month = This.PreReform.Month
			This.Day = This.PreReform.Day

		ELSE

			* calculate as Gregorian, in the Christian Era
			This.Year = INT((m.JulianDate - GREGORIAN_EPOCH) / 366)
			DO WHILE m.JulianDate >= This._reformedToJulian(This.Year + 1, 1, 1)
				This.Year = This.Year + 1
			ENDDO

			* if not in the adoption year, a regular calculation
			IF This.Year > This.AdoptionYear

				This.Month = 1
				DO WHILE m.JulianDate > This._reformedToJulian(This.Year, This.Month, This.LastDayOfMonth())
					This.Month = This.Month + 1
				ENDDO

				This.Day = m.JulianDate - This._reformedToJulian(This.Year, This.Month, 1) + 1

			ELSE

				* if in the adoption year, the gap must be considered
				m.ReformDayNumber = m.JulianDate - This.LastJulianDayNumber
				* the month in which the Gregorian calendar was adopted had fewer days than its regular count
				This.Month = This.AdoptionMonth
				m.DaysInMonth = This.LastDayOfMonth() - This.AdoptionDay + 1

				* look for the remaining days
				DO WHILE m.ReformDayNumber >= m.DaysInMonth
					* in the following months
					This.Month = This.Month + 1
					m.ReformDayNumber = m.ReformDayNumber - m.DaysInMonth
					m.DaysInMonth = This.LastDayOfMonth()
				ENDDO

				This.Day = m.ReformDayNumber + IIF(This.Month = This.AdoptionMonth, This.AdoptionDay - 1, 0)

			ENDIF

		ENDIF

	ENDPROC
	
	* calculation to transform a Gregorian calendar date into a Julian Day Number
	* (called from ToJulian method)
	FUNCTION _toJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer)

		IF This.IsReformed(m.CalYear, m.CalMonth, m.CalDay)

			RETURN This._reformedToJulian(m.CalYear, m.CalMonth, m.CalDay)

		ELSE

			RETURN This.PreReform._toJulian(m.CalYear, m.CalMonth, m.CalDay)

		ENDIF

	* calculation to transform a Gregorian reformed calendar date into a Julian Day Number
	HIDDEN FUNCTION _reformedToJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer) AS Number

		LOCAL DaysThisYear AS Number
		LOCAL MonthIndex AS Number

		m.DaysThisYear = m.CalDay
		FOR m.MonthIndex = 1 TO m.CalMonth - 1
			m.DaysThisYear = m.DaysThisYear + This.LastDayOfMonth(m.CalYear, m.MonthIndex)
		ENDFOR

		RETURN m.DaysThisYear + 365 * (m.CalYear - 1) + ;
				INT((m.CalYear - 1) / 4) - INT((m.CalYear - 1) / 100) + INT((m.CalYear - 1) / 400) + GREGORIAN_EPOCH - 1

	ENDFUNC

ENDDEFINE