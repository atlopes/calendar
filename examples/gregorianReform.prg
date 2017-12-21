* the Gregorian reform of the calendar, in different countries

* no need to DO gregorian-calendar, it is implicitly DOne by the first of these
DO LOCFILE("french-calendar.prg")
DO LOCFILE("russian-calendar.prg")
DO LOCFILE("german-calendar.prg")

ReformAdoption("France", CREATEOBJECT("FrenchCalendar"))
ReformAdoption("German catholic states", CREATEOBJECT("GermanCalendar"))
ReformAdoption("Prussia", CREATEOBJECT("PrussianCalendar"))
ReformAdoption("Russia", CREATEOBJECT("RussianCalendar"))

FUNCTION ReformAdoption (Country AS String, Cal AS Calendar)

    m.Cal.SetDate(m.Cal.AdoptionYear, m.Cal.AdoptionMonth, m.Cal.AdoptionDay)
    ? "The Gregorian reform was adopted in " + m.Country + " in", CalendarDateFormat(m.Cal)

    m.Cal.DaysAdd(-1)
    ?? " (the previous day was " + CalendarDateFormat(m.Cal) + ")"

ENDFUNC

FUNCTION CalendarDateFormat (Cal AS CalendarCalc)

    RETURN TRANSFORM(m.Cal.Day) + ", " + m.Cal.MonthName() + ", " + TRANSFORM(m.Cal.Year)

ENDFUNC