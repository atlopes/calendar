
*!*	PersianCalendar

*!*	A Calendar subclass for the Persian Calendar.
*!*	Locales are stored in persian.xml file.

* install dependencies
DO LOCFILE("Calendar.prg")

* install itself
IF !SYS(16) $ SET("Procedure")
	SET PROCEDURE TO (SYS(16)) ADDITIVE
ENDIF

* Julian day number of 1 Farvardin 1
#DEFINE PERSIAN_EPOCH	1948321
* Julian day number of 475 Farvardin 1
#DEFINE PERSIAN_DEPOCH	2121446

#DEFINE SAFETHIS	ASSERT !USED("This") AND VARTYPE(This) == "O"

DEFINE CLASS PersianCalendar AS Calendar

	VocabularySource = "persian.xml"

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