* start of seasons in different calendars, for the current year in each calendar

LOCAL GC AS GregorianCalendar
LOCAL HC AS HebrewCalendar
LOCAL IC AS IslamicCalendar

DO LOCFILE("gregorian-calendar.prg")
DO LOCFILE("hebrew-calendar.prg")
DO LOCFILE("islamic-calendar.prg")

DO LOCFILE("solar-calendar-events.prg")

m.GC = CREATEOBJECT("GregorianCalendar")
m.HC = CREATEOBJECT("HebrewCalendar")
m.IC = CREATEOBJECT("IslamicCalendar")

* set the solar events in each calendar
m.GC.AttachEventProcessor("solar", "SolarCalendarEvents")
m.GC.SetEvents()
m.HC.AttachEventProcessor("solar", "SolarCalendarEvents")
m.HC.SetEvents()
m.IC.AttachEventProcessor("solar", "SolarCalendarEvents")
m.IC.SetEvents()

LOCAL SeasonIndex AS Integer
LOCAL ARRAY SeasonIds(4)
LOCAL SeasonId AS String

FOR m.SeasonIndex = 1 TO ALINES(m.SeasonIds, "solar.vequinox,solar.ssolstice,solar.aequinox,solar.wsolstice", 0, ",")

    m.SeasonId = m.SeasonIds(m.SeasonIndex)

    ? TEXTMERGE("<<m.GC.CalendarEvents(m.SeasonId).CommonName>> starting in")
    m.GC.SetDate(m.SeasonId)
    ? " - Gregorian:", CalendarDateFormat(m.GC)
    m.HC.SetDate(m.SeasonId)
    ? " - Hebrew:", CalendarDateFormat(m.HC)
    m.IC.SetDate(m.SeasonId)
    ? " - Islamic:", CalendarDateFormat(m.IC)
    ?

ENDFOR

FUNCTION CalendarDateFormat (Cal AS Calendar)

    RETURN TRANSFORM(m.Cal.Day) + ", " + m.Cal.MonthName() + ", " + TRANSFORM(m.Cal.Year)

ENDFUNC