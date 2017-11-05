* display current date in different calendars
LOCAL GC AS GregorianCalendar
LOCAL HC AS HebrewCalendar
LOCAL IC AS IslamicCalendar
LOCAL PC AS PersianCalendar

DO LOCFILE("gregorian-calendar.prg")
DO LOCFILE("hebrew-calendar.prg")
DO LOCFILE("islamic-calendar.prg")
DO LOCFILE("persian-calendar.prg")

m.GC = CREATEOBJECT("GregorianCalendar")
m.HC = CREATEOBJECT("HebrewCalendar")
m.IC = CREATEOBJECT("IslamicCalendar")
m.PC = CREATEOBJECT("PersianCalendar")

? "Today"
? " - in the Gregorian calendar:", CalendarDateFormat(m.GC)
? " - in the Hebrew calendar:", CalendarDateFormat(m.HC)
? " - in the Islamic calendar:", CalendarDateFormat(m.IC)
? " - in the Persian calendar:", CalendarDateFormat(m.PC)

FUNCTION CalendarDateFormat (Cal AS Calendar)

    RETURN TRANSFORM(m.Cal.Day) + ", " + m.Cal.MonthName() + ", " + TRANSFORM(m.Cal.Year)

ENDFUNC