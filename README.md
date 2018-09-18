# CalendarCalc #

A VFP set of classes to hold calendrical information, and perform simple calculations.

## Overview ##

* Use these classes to represent a day in different calendar systems, or to switch between different calendars, or to extend the time coverage or precision of VFP's Date data type, or to perform basic calendrical calculations, or to check for calendar events...
* Use the DatePicker visual library to easily pick dates and datetimes, and insert the picked value into a target textbox.
* The calculations are, for the most part, based on Kees Couprie's [Calendar Math](http://members.casema.nl/couprie/calmath/) website, and on Calendar.c, a C++ transcript from the original LISP code used for "Calendrical Calculations" by Nachum Dershowitz and Edward M. Reingold.

## Using ##

* See [UNLICENSE](UNLICENSE.md). Icons in the DatePicker Visual Library, by [Icons8](https://icons8.com "Icons8"), are licensed under an [Attribution-NoDerivs 3.0 Unported](https://creativecommons.org/licenses/by-nd/3.0/)  (CC BY-ND 3.0) license by their authors.
* In a project, include Calendar.prg (the base class) and any other specific classes that an application may require (for instance, ``gregorian-calendar.prg``, ``hebrew-calendar.prg``).
* To make available a class definition, DO its program (for instance, `DO persian-calendar.prg`)
* Create an object, and use it (see [DOCUMENTATION](DOCUMENTATION.md) for more info).

## Credits ##

* DatePicker icons by [Icons8](https://icons8.com "Icons8"), creators of tech iconography extraordinaire.

## Contributing ##

* Test, use, fork, improve.
* Review, suggest, and comment.

## To-Do ##

* More calendars...
* A DatePicker visual library that supports the CalendarCalc classes is being tested...
* iCalendar interface (see [iCal4VFP](https://bitbucket.org/atlopes/iCal4VFP) project)...

## Talk, talk, talk... ##

* atlopes, found here, at [LevelExtreme](https://www.levelextreme.com) (former UT), [Foxite](https://www.foxite.com), and[Tek-Tips](https://www.tek-tips.com).