# CALENDAR #

A VFP set of classes to hold calendrical information, and perform simple calculations.

### Overview ###

* Use these classes to represent a day in different calendar systems, or to switch between different calendars, or to extend the time coverage or precision of VFP's Date data type, or to perform basic calendrical calculations...
* The calculations are, for the most part, based on Kees Couprie's [Calendar Math](http://members.casema.nl/couprie/calmath/) website, and on Calendar.c, a C++ transcript from the original LISP code used for "Calendrical Calculations" by Nachum Dershowitz and Edward M. Reingold
* Version: just about to hatch.

### Using ###

* See UNLICENSE.
* In a project, include Calendar.prg (the base class) and any other specific classes that an application may require (for instance, Gregorian-Calendar.prg, Hebrew-calendar.prg)
* To make available a class definition, DO its program (for instance, DO Persian-Calendar.prg)
* Create an object, and use it (see DOCUMENTATION for more info).

### Contributing ###

* Test, use, fork, improve
* Review, suggest, and comment

### Talk, talk, talk... ###

* atlopes, found here, at [Foxite](https://www.foxite.com), [Tek-Tips](https://www.tek-tips.com), and [LevelExtreme](https://www.levelextreme.com) (former UT).