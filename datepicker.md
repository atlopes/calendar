# CalendarCalc Documentation

Go to [Overview](DOCUMENTATION.md "Overview")

### DatePicker Visual Library (beta)

The DatePicker Visual Library is a set of visual classes that facilitate the task of date and time selection.

It is composed of

- `textdatepicker`, a textbox control where the picked date, or datetime, will be inserted
- `contdatepicker`, a container to be used in column grids and, or in situations where the textbox may be freely moved around the form
- `formdatepicker`, a form to control the process of date and datetime selection.

The interface mimics most of the features of date selection in W10 machines: the user starts with a month view, and from there he/she may pass to other views (months of the year, years of a decade). Time is selected by setting hours, minutes, seconds, and meridian position.

CalendarCalc classes may be passed to the date picker, and used instead or in addition of the system calendar. If a CalendarCalc is used, events attached to the calendar are displayed in the month view of the calendar.

Further documentation is going to follow. For now, please refer to the example form in the [examples](examples.md) page.
