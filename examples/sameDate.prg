* first day of 21st century in the Islamic Calendar
LOCAL GC AS GregorianCalendar
LOCAL IC AS IslamicCalendar

DO LOCFILE("gregorian-calendar.prg")
DO LOCFILE("islamic-calendar.prg")

m.GC = CREATEOBJECT("GregorianCalendar")
m.IC = CREATEOBJECT("IslamicCalendar")

m.GC.SetDate(2001, 1, 1)
m.IC.SetDate(m.GC)

? "The first day of the 21st century was on", CalendarDateFormat(m.IC)

FUNCTION CalendarDateFormat (Cal AS CalendarCalc)

    RETURN TRANSFORM(m.Cal.Day) + ", " + m.Cal.MonthName() + ", " + TRANSFORM(m.Cal.Year)

ENDFUNC