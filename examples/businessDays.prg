* demonstrates the use of the BusinessCalendar class
* to calculate business day ahead of a date
DO LOCFILE("business-calendar.prg")
DO LOCFILE("us-calendar-events.prg")

CLEAR

LOCAL BC AS BusinessCalendar
LOCAL BusinessDays AS Integer
LOCAL CalendarDays AS Integer

m.BC = CREATEOBJECT("BusinessCalendar")

* attach an Event Processor (in this case, US events)
* several processors can be attached, the class instance will use
* whatever processors are attached to the calendar
m.BC.AttachEventProcessor("us", "USCalendarEvents")

* the properties that control the business week
m.BC.FirstBusinessDay = 1			&& 1 = Monday, ...
m.BC.Businessweeklength = 5		&& that is, from Monday to Friday

* test to see if we are in a business day
? m.BC.Dtos(),"is "
IF m.BC.AdvanceBusinessDays(0) != 0
	?? "not "
ENDIF
?? "a business day"
	
FOR m.BusinessDays = 1 TO 30

	* reset the calendar to the current system date
	m.BC.FromSystem()
	? m.BC.DTOS(), "+", TRANSFORM(m.BusinessDays, "999")
	?? " >> "
	* calculate the actual advance in calendar days
	m.CalendarDays = m.BC.AdvanceBusinessDays(m.BusinessDays)
	?? m.BC.DTOS()
	* how much days we actually have to move forward
	?? " = +",TRANSFORM(m.CalendarDays, "999")

ENDFOR
