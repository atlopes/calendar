* difference between Shakespeare's and Cervantes' dates of death
LOCAL Shakespeare AS BritishCalendar
LOCAL Cervantes AS GregorianCalendar
LOCAL DaysGap AS Number

DO LOCFILE("british-calendar.prg")

m.Shakespeare = CREATEOBJECT("BritishCalendar")
m.Cervantes = CREATEOBJECT("GregorianCalendar")

* both died on the same April 23rd, 1616, but refering to distinct calendar systems
m.Shakespeare.SetDate(1616, 4, 23)
m.Cervantes.SetDate(1616, 4, 23)

m.DaysGap = m.Cervantes.DaysDifference(m.Shakespeare)

DO CASE
CASE m.DaysGap < 0
    ? "Cervantes died " + TRANSFORM(ABS(m.DaysGap)) + " days before Shakespeare did."
CASE m.DaysGap > 0
    ? "Cervantes died " + TRANSFORM(m.DaysGap) + " days after Shakespeare did."
OTHERWISE
    ? "Cervantes and Shakespeare died in the same day."
ENDCASE