## ADDED Requirements

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
  handed as well, its line is the same line as Kate's

#### Scenario: a Birthdays screen takes a new today only when it is shown again

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  that records every ask and hands, whatever it is asked for, the contact "anna"'s birthday worded
  "Anna Haro's Birthday" on 12 October 2026 and the contact "john"'s worded "John Appleseed's 40th
  Birthday" on 13 October 2026
- **THEN** it lists Anna's line, saying "Today", and then John's, saying "Tue 13 October"
- **AND** after it is shown again as of Tuesday 13 October 2026, its calendar has been asked twice:
  for 12 October 2026 through 11 October 2027, and then for 13 October 2026 through 12 October 2027
- **AND** it then lists John's line alone, saying "Today"

### Requirement: A Birthdays screen lists the soonest birthday first, and one day's birthdays in the order their words are collated in

A Birthdays screen SHALL list its lines in the order their birthdays' days fall, its today's first,
whatever order its calendar handed them in. Lines of birthdays falling on one day SHALL be in the
order its calendar says their words are collated in, and the screen SHALL consult no locale of its
own to order them. No order of words SHALL put a line before a line of an earlier day.

#### Scenario: a Birthdays screen lists the soonest birthday first, whatever order the calendar hands them in

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  handing, in this order, the contact "john"'s birthday worded "John Appleseed's 40th Birthday" on
  1 March 2027, the contact "zoe"'s worded "Zoe Adams's Birthday" on 1 January 2027, the contact
  "kate"'s worded "Kate Bell's 48th Birthday" on 14 November 2026 and the contact "anna"'s worded
  "Anna Haro's Birthday" on 12 October 2026
- **THEN** its lines say "Anna Haro's Birthday", "Kate Bell's 48th Birthday", "Zoe Adams's Birthday"
  and then "John Appleseed's 40th Birthday"
- **AND** with the calendar handing the same four in the reverse order, its lines are in the same
  order

#### Scenario: a Birthdays screen lists one day's birthdays in the order their words are collated in

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  collating words in alphabetical order with capitals and small letters alike, handing in this order
  the contact "aaron"'s birthday worded "Aaron Appleseed's Birthday" on 15 November 2026, then the
  contact "zoe"'s worded "Zoe Adams's Birthday", the contact "kate"'s worded "Kate Bell's 48th
  Birthday" and the contact "anna"'s worded "anna Haro's Birthday", these three on 14 November 2026
- **THEN** its lines say "anna Haro's Birthday", "Kate Bell's 48th Birthday", "Zoe Adams's Birthday"
  and then "Aaron Appleseed's Birthday"
- **AND** with a calendar collating words in the reverse of that order, the three lines of
  14 November 2026 are in the reverse order, and Aaron's line is still last

### Requirement: A Birthdays screen line says the calendar's words and its day, or Today

Each line SHALL say its birthday's words exactly as the calendar handed them, empty words included,
and SHALL say its birthday's day: "Today" where that day is the screen's today, and otherwise the
three-letter name of its weekday, the day of the month with no leading zero and the month's name in
full, separated by single spaces and with no year, in this package's own words. A line SHALL be its
words and its day in words and nothing else, so two lines alike in both SHALL be the same line. A
line SHALL NOT give back its birthday's contact or whether that birthday is ticked, and a Birthdays
screen SHALL offer no tick.

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

### Requirement: A Birthdays screen follows its birthday switch, and asks the calendar nothing while birthdays are off

Birthdays SHALL be on for a Birthdays screen exactly while its birthday switch is on, read when the
screen is opened and each time it is shown again. Opened or shown again while birthdays are off, it
SHALL list nothing, SHALL say birthdays are off and MUST NOT ask its calendar anything. Shown again,
it SHALL show its birthday switch again before it asks its calendar anything, so birthdays kept on
where the phone no longer gives full calendar access SHALL be off there. While birthdays are on and
its calendar answered, it SHALL say birthdays are on, whether or not it lists anything. A Birthdays
screen SHALL ask the phone for nothing.

#### Scenario: a Birthdays screen opened with birthdays off lists nothing, says they are off and asks the calendar nothing

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with a birthday switch that is
  off, asking a phone that gives full calendar access, and a calendar holding the contact "kate"'s
  birthday worded "Kate Bell's 48th Birthday" on 14 November 2026
- **THEN** it lists nothing and says birthdays are off
- **AND** its calendar has been asked nothing, and the phone has been asked nothing
- **AND** shown again as of that same day, it still lists nothing, says birthdays are off and has
  asked its calendar nothing

#### Scenario: a Birthdays screen shown again after the phone withdraws calendar access lists nothing and says birthdays are off

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on, its switch
  asking a phone that gives full calendar access, and a calendar holding the contact "kate"'s
  birthday worded "Kate Bell's 48th Birthday" on 14 November 2026; the phone then denies calendar
  access; and the screen is shown again as of that same day
- **THEN** it lists nothing and says birthdays are off
- **AND** its birthday switch is off
- **AND** its calendar has been asked once in all, when the screen was opened
- **AND** a Birthdays screen opened the same way whose switch is turned off, and which is then shown
  again, lists nothing and says birthdays are off the same way

#### Scenario: a Birthdays screen with birthdays on and nobody handed in its span lists nothing and says birthdays are on

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  holding no birthdays
- **THEN** it lists nothing and says birthdays are on
- **AND** one opened the same way with a calendar handing, whatever it is asked for, only the
  contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 12 October 2027 lists nothing and
  says birthdays are on

### Requirement: A Birthdays screen whose calendar cannot be read lists nothing and says so

Where asking its calendar fails, a Birthdays screen SHALL list nothing and SHALL say birthdays could
not be read, telling no reason the calendar failed. What it lists and says SHALL be formed again
each time it is shown again, so an ask that then succeeds SHALL list the birthdays handed and say
birthdays are on.

#### Scenario: a Birthdays screen whose calendar cannot be read lists nothing and says birthdays could not be read

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  whose every ask fails
- **THEN** it lists nothing and says birthdays could not be read
- **AND** after the calendar holds the contact "kate"'s birthday worded "Kate Bell's 48th Birthday"
  on 14 November 2026 and answers, and the screen is shown again as of that same day, it lists one
  line saying "Kate Bell's 48th Birthday" and "Sat 14 November", and says birthdays are on

### Requirement: A commitments screen offers the way to the Birthdays screen exactly while birthdays are on

A commitments screen MAY be opened with a birthday switch. It SHALL offer the way to the Birthdays
screen exactly while it was handed a switch and that switch is on, whatever any calendar holds, and
SHALL read the switch each time it is asked. A commitments screen shown again SHALL show its switch
again, so birthdays kept on where the phone no longer gives full calendar access SHALL offer no way
there. Saying whether it offers the way SHALL ask the phone nothing.

#### Scenario: a commitments screen offers the way to the Birthdays screen while birthdays are on, and none while they are off

- **WHEN** a commitments screen is opened as of Monday 12 October 2026 at places where nothing has
  been kept, with a birthday switch that is on, asking a phone that gives full calendar access
- **THEN** it offers the way to the Birthdays screen
- **AND** after the switch is turned off, it offers none, though it is neither opened nor shown again
- **AND** a commitments screen opened the same way with no birthday switch offers none
- **AND** the phone has been asked nothing

#### Scenario: a commitments screen shown again after the phone withdraws calendar access offers no way to the Birthdays screen

- **WHEN** a commitments screen is opened as of Monday 12 October 2026 at places where nothing has
  been kept, with a birthday switch that is on, asking a phone that gives full calendar access; the
  phone then denies calendar access; and the commitments screen is shown again as of that same day
- **THEN** it offers no way to the Birthdays screen, and its birthday switch is off
- **AND** with the phone then giving full access again and the commitments screen shown again, it
  still offers none
