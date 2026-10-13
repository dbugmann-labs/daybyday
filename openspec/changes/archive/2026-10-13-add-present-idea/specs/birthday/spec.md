## MODIFIED Requirements

### Requirement: A Birthdays screen lists every birthday the calendar hands from its today through the day before the same date a year later

A Birthdays screen SHALL be opened as of a today, with a calendar and a birthday switch, and SHALL
take its today when it is opened and each time it is shown again, and at no other moment. While
birthdays are on, it SHALL ask its calendar once when it is opened and once each time it is shown
again, and at no other moment, for the days from its today through the day before the same date a
year later — through 28 February where its today is 29 February — or through the last supported
date where that day would fall past it. It SHALL list one line for every birthday handed whose day
falls in that span and none for any other, leaving none out and merging none, so a birthday handed
twice SHALL be listed twice. Reading what it lists SHALL ask nothing.

#### Scenario: a Birthdays screen asks the calendar once, for the days from its today through the day before the same date a year later

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  that records every ask and hands, whatever it is asked for, the contact "kate"'s birthday worded
  "Kate Bell's 48th Birthday" on 14 November 2026, and its lines are read twice
- **THEN** its calendar has been asked once, for 12 October 2026 through 11 October 2027
- **AND** one opened the same way as of Monday 1 March 2027 asks for 1 March 2027 through
  29 February 2028
- **AND** one opened as of Tuesday 29 February 2028 asks for 29 February 2028 through
  28 February 2029
- **AND** one opened as of Tuesday 12 October 9999 asks for 12 October 9999 through
  31 December 9999

#### Scenario: a Birthdays screen lists each birthday handed in its span as often as it is handed, and none handed outside it

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  handing, whatever it is asked for, the contact "anna"'s birthday worded "Anna Haro's Birthday" on
  11 October 2026, the contact "kate"'s worded "Kate Bell's 48th Birthday" on 14 November 2026, the
  contact "john"'s worded "John Appleseed's 40th Birthday" on 11 October 2027 and the contact
  "zoe"'s worded "Zoe Adams's Birthday" on 12 October 2027
- **THEN** it lists two lines, saying "Kate Bell's 48th Birthday" and then "John Appleseed's 40th
  Birthday"
- **AND** with Kate's birthday handed twice, it lists three lines, Kate's twice, and those two are
  the same line
- **AND** with the contact "kate-2"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026
  handed as well, it lists three lines, and Kate-2's line is not the same line as Kate's

#### Scenario: a Birthdays screen takes a new today only when it is shown again

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  that records every ask and hands, whatever it is asked for, the contact "anna"'s birthday worded
  "Anna Haro's Birthday" on 12 October 2026 and the contact "john"'s worded "John Appleseed's 40th
  Birthday" on 13 October 2026
- **THEN** it lists Anna's line, saying "Today", and then John's, saying "Tue 13 October"
- **AND** after it is shown again as of Tuesday 13 October 2026, its calendar has been asked twice:
  for 12 October 2026 through 11 October 2027, and then for 13 October 2026 through 12 October 2027
- **AND** it then lists John's line alone, saying "Today"

### Requirement: A Birthdays screen line says the calendar's words and its day, or Today

Each line SHALL say its birthday's words exactly as the calendar handed them, empty words included,
and SHALL say its birthday's day: "Today" where that day is the screen's today, and otherwise the
three-letter name of its weekday, the day of the month with no leading zero and the month's name in
full, separated by single spaces and with no year, in this package's own words. A line SHALL give
back its birthday's contact, and SHALL be that contact, its words, its day in words and what it says
of present ideas, and nothing else, so two lines alike in all four SHALL be the same line. A line
SHALL NOT give back whether its birthday is ticked, and a Birthdays screen SHALL offer no tick.

#### Scenario: a Birthdays screen line says the calendar's words exactly, and its day as weekday, day and month

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  holding the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026
- **THEN** it lists one line, saying "Kate Bell's 48th Birthday" and "Sat 14 November"
- **AND** with the contact "john"'s birthday worded "John Appleseed's 40th Birthday" on 5 June 2027
  instead, its one line says "John Appleseed's 40th Birthday" and "Sat 5 June"
- **AND** with Kate's birthday worded " Kate Bell's 48th Birthday ", with blank space at both ends,
  its one line says exactly that
- **AND** with Kate's birthday worded with empty words, its one line says no words and
  "Sat 14 November"

#### Scenario: a Birthdays screen line says Today for a birthday falling on its today, and the date for any other

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  holding the contact "anna"'s birthday worded "Anna Haro's Birthday" on 12 October 2026, the
  contact "john"'s worded "John Appleseed's 40th Birthday" on 13 October 2026 and the contact
  "kate"'s worded "Kate Bell's 48th Birthday" on 11 October 2027
- **THEN** its three lines say their days as "Today", "Tue 13 October" and "Mon 11 October"

#### Scenario: a Birthdays screen says each month by its own name

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  holding twelve birthdays of twelve contacts, one on the first day of each month from
  1 November 2026 through 1 October 2027
- **THEN** its twelve lines say their days as "Sun 1 November", "Tue 1 December", "Fri 1 January",
  "Mon 1 February", "Mon 1 March", "Thu 1 April", "Sat 1 May", "Tue 1 June", "Thu 1 July",
  "Sun 1 August", "Wed 1 September" and "Fri 1 October"
