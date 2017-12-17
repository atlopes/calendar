# Calendar Documentation

Go to [Overview](DOCUMENTATION.md "Overview")

### Classes

To use a class, include in a project its PRG file and all the hierarchy of dependencies and locale files, up to the base Calendar class. For instance, if you want to use the British Calendar, select BritishCalendar class, and include in your project british-calendar.prg, gregorian-calendar.prg, christian-julian-calendar.prg, julian-calendar.prg, julian.xml, and calendar.prg.

If you want to experiment from the Command Window, or from small code snippets, DO the top-level classes in a hierarchy chain (in the above example, `DO LOCFILE("british-calendar.prg")` would be enough).

If you want to keep it simple, just include all PRG and XML files, and any class will be available after DOing its PRG.

Presentation order: base classes, then julian and gregorian classes, then alphabetical.

See also [Properties and Methods](pem.md "Properties and Methods").

#### Calendar related

| Class | Filename | Dependency | Locale |
| ----- | -------- | ---------- | ------ |
| Calendar | [calendar.prg](calendar.prg "calendar.prg") | | |
| JulianCalendar | [julian-calendar.prg](julian-calendar.prg "julian-calendar.prg") | calendar.prg | [julian.xml](julian.xml "julian.xml") |
| ChristianJulianCalendar | [christian-julian-calendar.prg](christian-julian-calendar.prg "christian-julian-calendar.prg") | julian-calendar.prg | |
| GregorianCalendar | [gregorian-calendar.prg](gregorian-calendar.prg "gregorian-calendar.prg") | christian-julian-calendar.prg | |
| AustrianCalendar | [austrian-calendar.prg](austrian-calendar.prg "austrian-calendar.prg") | gregorian-calendar.prg | |
| BritishCalendar | [british-calendar.prg](british-calendar.prg "british-calendar.prg") | gregorian-calendar.prg | |
| BulgarianCalendar | [bulgarian-calendar.prg](bulgarian-calendar.prg "bulgarian-calendar.prg") | gregorian-calendar.prg | |
| BusinessCalendar | [business-calendar.prg](business-calendar.prg "business-calendar.prg") | gregorian-calendar.prg | |
| DanishCalendar | [danish-calendar.prg](danish-calendar.prg "danish-calendar.prg") | gregorian-calendar.prg | |
| FrenchCalendar | [french-calendar.prg](french-calendar.prg "french-calendar.prg") | gregorian-calendar.prg | |
| GermanCalendar | [german-calendar.prg](german-calendar.prg "german-calendar.prg") | gregorian-calendar.prg | |
| └ PrussianCalendar | german-calendar.prg | gregorian-calendar.prg | |
| GreekCalendar | [greek-calendar.prg](greek-calendar.prg "greek-calendar.prg") | gregorian-calendar.prg | |
| HungarianCalendar | [hungarian-calendar.prg](hungarian-calendar.prg "hungarian-calendar.prg") | gregorian-calendar.prg | |
| JapaneseCalendar | [japanese-calendar.prg](japanese-calendar.prg "japanese-calendar.prg") | gregorian-calendar.prg | |
| RomanianCalendar | [romanian-calendar.prg](romanian-calendar.prg "romanian-calendar.prg") | gregorian-calendar.prg | |
| RussianCalendar | [russian-calendar.prg](russian-calendar.prg "russian-calendar.prg") | gregorian-calendar.prg | |
| TurkishCalendar | [turkish-calendar.prg](turkish-calendar.prg "turkish-calendar.prg") | gregorian-calendar.prg | |
| HebrewCalendar | [hebrew-calendar.prg](hebrew-calendar.prg "hebrew-calendar.prg") | calendar.prg | [hebrew.xml](hebrew.xml "hebrew.xml") |
| IslamicCalendar | [islamic-calendar.prg](islamic-calendar.prg "islamic-calendar.prg") | calendar.prg | [islamic.xml](islamic.xml "islamic.xml") |
| PersianCalendar | [persian-calendar.prg](persian-calendar.prg "persian-calendar.prg") | calendar.prg | [persian.xml](persian.xml "persian.xml") |
| RepublicanCalendar | [republican-calendar.prg](republican-calendar.prg "republican-calendar.prg") | calendar.prg | [republican.xml](republican.xml "republican.xml") |

#### Calendar events related

| Class | Filename | Dependency | Definitions |
| ----- | -------- | ---------- | ------ |
| CalendarEvent | [calendar.prg](calendar.prg "calendar.prg") | | |
| CalendarEventProcessor | calendar.prg | | |
| SolarCalendarEvents | [solar-calendar-events.prg](solar-calendar-events.prg "solar-calendar-events.prg") | [gregorian-calendar.prg](gregorian-calendar.prg "gregorian-calendar.prg") | |
| PaschaCalendarEvents | [pascha-calendar-events.prg](pascha-calendar-events.prg "pascha-calendar-events.prg") | gregorian-calendar.prg | |
| DutchCalendarEvents | [dutch-calendar-events.prg](dutch-calendar-events.prg "dutch-calendar-events.prg") | pascha-calendar-events.prg | [nl_events.xml](nl_events.xml "nl_events.xml") |
| PortugueseCalendarEvents | [portuguese-calendar-events.prg](portuguese-calendar-events.prg "portuguese-calendar-events.prg") | pascha-calendar-events.prg | [pt_events.xml](pt_events.xml "pt_events.xml") |
| USCalendarEvents | [us-calendar-events.prg](us-calendar-events.prg "us-calendar-events.prg") | [british-calendar.prg](british-calendar.prg "british-calendar.prg") | [us_events.xml](us_events.xml "us_events.xml") |
| HebrewCalendarEvents | [hebrew-calendar-events.prg](hebrew-calendar-events.prg "hebrew-calendar-events.prg") | [hebrew-calendar.prg](hebrew-calendar.prg "hebrew-calendar.prg") | [hebrew_events.xml](hebrew_events.xml "hebrew_events.xml") |

