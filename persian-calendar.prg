
*!*	PersianCalendar

*!*	A CalendarCalc subclass for the Persian Calendar.
*!*	Locales are stored in persian.xml file.

* install dependencies
DO LOCFILE("calendar.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

* Julian day number of 1 Farvardin 1
#DEFINE PERSIAN_EPOCH	1948321
* Julian day number of 475 Farvardin 1
#DEFINE PERSIAN_DEPOCH	2121446

#DEFINE SAFETHIS	ASSERT !USED("This") AND VARTYPE(This) == "O"

DEFINE CLASS PersianCalendar AS CalendarCalc

	VocabularySource = "persian.xml"

	* IsLeapYear()
	* returns .T. if an Persian leap year
	FUNCTION IsLeapYear (Year AS Number)

		SAFETHIS
		
		ASSERT PCOUNT() = 0 OR VARTYPE(m.Year) == "N" ;
			MESSAGE "Numeric parameter expected."

		LOCAL OuterCycle AS Integer
		LOCAL MidCycle AS Integer
		LOCAL InnerCycle AS Integer
		LOCAL IsLeap AS Boolean

		IF PCOUNT() = 0
			m.Year = This.Year
		ENDIF

		* leap pattern repeats every 2820 years
		m.OuterCycle = ((m.Year - 1) % 2820) + 1
		* a mid patterned cycle occupies 128 years
		m.MidCycle = ((m.OuterCycle - 1) % 128) + 1
		* the first 29 years follow one pattern
		IF m.MidCycle <= 29
			m.MidCycle = m.MidCycle + 4
			* the remainer, another one of 33 years
		ELSE
			m.MidCycle = m.MidCycle - 29
		ENDIF
		* normalize the first cycle to a regular 33 cycle
		m.InnerCycle = ((m.MidCycle - 1) % 33) + 1

		DO CASE
		* in a 33 cycle, the last leap year is pushed back one year
		CASE m.InnerCycle = 33
			m.IsLeap = .T.

		* so, the last regular 4-year leap cycle does not occur at the expected year
		CASE m.InnerCycle = 32
			m.IsLeap = .F.

		* but all other leaps do
		OTHERWISE
			m.IsLeap = (m.InnerCycle % 4) = 0

		ENDCASE

		RETURN m.IsLeap

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
		CASE INLIST(m.Month, 1, 2, 3, 4, 5, 6)
			RETURN 31

		CASE INLIST(m.Month, 7, 8, 9, 10, 11)
			RETURN 30

		CASE m.Month = 12
			RETURN 29 + IIF(This.IsLeapYear(m.Year), 1, 0)

		OTHERWISE
			RETURN 0
		ENDCASE

	ENDFUNC

	* calculation to transform a Julian Day Number into a Persian calendar date
	* (called from FromJulian method)
	PROCEDURE _fromJulian (JulianDate AS Number)
	
		SAFETHIS

		LOCAL DEpoch AS Number

		m.DEpoch = m.JulianDate - PERSIAN_DEPOCH
		
		LOCAL Cycle AS Number
		LOCAL CYear AS Number
		LOCAL YCycle AS Number
		LOCAL Aux1 AS Number
		LOCAL Aux2 AS Number
		LOCAL YDay AS Number
		
		m.Cycle = This.CalcFix(m.DEpoch / 1029983)
		m.CYear = m.DEpoch % 1029983
		
		IF m.CYear = 1029982
			m.YCycle = 2820
		ELSE
			m.Aux1 = This.CalcFix(m.CYear / 366)
			m.Aux2 = m.CYear % 366
			m.YCycle = This.CalcInt(((2134 * m.Aux1) + (2816 * m.Aux2) + 2815) / 1028522) + m.Aux1 + 1
		ENDIF

		This.Year = m.YCycle + (2820 * m.Cycle) + 474
		IF This.Year <= 0
			This.Year = This.Year - 1
		ENDIF

		m.YDay = (m.JulianDate - This._toJulian(This.Year, 1, 1)) + 1
		
		IF m.YDay <= 186
			This.Month = This.CalcCeil(m.YDay / 31)
		ELSE
			This.Month = This.CalcCeil((m.YDay - 6) / 30)
		ENDIF

		This.Day = (m.JulianDate - This._toJulian(This.Year, This.Month, 1)) + 1

	ENDPROC
	
	* calculation to transform a Persian calendar date into a Julian Day Number
	* (called from ToJulian method)
	FUNCTION _toJulian (CalYear AS Integer, CalMonth AS Integer, CalDay AS Integer)

		LOCAL EpBase AS Number
		LOCAL EpYear AS Number
		LOCAL MDays AS Number

		IF m.CalYear >= 0
			m.EpBase = m.CalYear - 474
		ELSE
			m.EpBase = m.CalYear - 473
		ENDIF
		
		m.EpYear = 474 + (m.EpBase % 2820)

		IF m.CalMonth <= 7
			m.MDays = (m.CalMonth - 1) * 31
		ELSE
			m.MDays = (m.CalMonth - 1) * 30 + 6
		ENDIF

		RETURN m.CalDay + m.MDays + This.CalcFix(((m.EpYear * 682) - 110) / 2816) + (m.EpYear - 1) * 365 + ;
					This.CalcFix(m.EpBase / 2820) * 1029983 + (PERSIAN_EPOCH - 1)
	ENDFUNC

ENDDEFINE