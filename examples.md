# Calendar Documentation

Go to [Overview](DOCUMENTATION.md "Overview")

### Examples

**Display current date**

When a Calendar object is created, the initial value is the current system date. By accessing `Year`, `Month`, and `Day`properties, the date can be displayed (`MonthName()` method will produce a name for the month in the class locale). 

```foxpro
FUNCTION CalendarDateFormat (Cal AS CalendarCalc)

	RETURN TRANSFORM(m.Cal.Day) + ", " + m.Cal.MonthName() + ", " + TRANSFORM(m.Cal.Year)

ENDFUNC
```

[Source](examples/displayCurrentDate.prg "Source")


**Same date in other calendar**

By receiving a Calendar object as an argument for the `SetDate()` method, it's possible to establish correspondences between dates of two distinct calendar systems. 

```foxpro
m.GC.SetDate(2001, 1, 1)
m.IC.SetDate(m.GC)

? "The first day of the 21st century was on", CalendarDateFormat(m.IC)
```

[Source](examples/sameDate.prg "Source")

**Days difference between two dates**

The `DaysDifference()` method calculates the difference between the current date of the Calendar object, and some other date (in any calendar).

```foxpro
* both died on the same April 23rd, 1616, but refering to distinct calendar systems
m.Shakespeare.SetDate(1616, 4, 23)
m.Cervantes.SetDate(1616, 4, 23)

m.DaysGap = m.Cervantes.DaysDifference(m.Shakespeare)
```

[Source](examples/daysDifference.prg "Source")

**Adoption of the Gregorian Reform**

Gregorian based calendars hold `Adoption*` properties about the days that were cut out when the western christian calendar was reformed. The `DaysAdd()` is prepared to change between the Gregorian and Julian eras transparently. 

```foxpro
	m.Cal.SetDate(m.Cal.AdoptionYear, m.Cal.AdoptionMonth, m.Cal.AdoptionDay)
	? "The Gregorian reform was adopted in " + m.Country + " in", CalendarDateFormat(m.Cal)
	
	m.Cal.DaysAdd(-1)
	?? " (the previous day was " + CalendarDateFormat(m.Cal) + ")"
```

[Source](examples/gregorianReform.prg "Source")

**All the events of a year**

Events processors can be attached to a calendar object, and the events set for a specific year. The same events processor class is attachable to different calendars, and in the same way different processors can be attached to the same calendar object.

```foxpro
* attach the event processors
m.USA = CREATEOBJECT("BritishCalendar")
IF !m.USA.AttachEventProcessor("usa", "USCalendarEvents")
	MESSAGEBOX("Something went wrong, stepping down...")
	RETURN
ENDIF

* set the events for the year
m.USA.Setevents()
```

[Source](examples/yearEvents.prg "Source")

**Business days ahead**

Calculating business days ahead depends on the definition of a business week (when does it start? how long does it last?), and on the holidays that may occur in a given period. The BusinessCalendar is based on GregorianCalendar, and comes with a business days calculator.

```foxpro
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
```

[Source](examples/businessDays.prg "Source")

**Start of seasons**

Events processors can be simple, and based on a set of predefined events, or relatively complex, for which some calculations must be made. Such is the case of the Easter-based set of events (that may be included by other events processors), or the astronomical start of seasons.

```foxpro
FOR m.SeasonIndex = 1 TO ALINES(m.SeasonIds, "solar.vequinox,solar.ssolstice,solar.aequinox,solar.wsolstice", 0, ",")

	m.SeasonId = m.SeasonIds(m.SeasonIndex)

	? TEXTMERGE("<<m.GC.CalendarEvents(m.SeasonId).CommonName>> starting in")
	m.GC.SetDate(m.SeasonId)
	? " - Gregorian:", CalendarDateFormat(m.GC)
	?

ENDFOR
```

[Source](examples/seasons.prg "Source")
