## ADDED Requirements

### Requirement: A day screen offers the way to the Birthdays screen exactly while birthdays are on, whichever day it is showing

A day screen SHALL offer the way to the Birthdays screen exactly while it was handed a calendar and a
birthday switch and that switch read on when it last formed the day view of the day it is showing,
whatever its calendar holds, whether or not its calendar or its birthday ticks could be read, and
whichever day it is showing, past, today or to come. Shown again, it SHALL show its switch again
before it forms that day view, so birthdays kept on where the phone no longer gives full calendar
access SHALL offer no way there. Saying whether it offers the way SHALL ask the phone and the
calendar nothing.

#### Scenario: a day screen offers the way to the Birthdays screen on whichever day it shows while birthdays are on, and none while they are off

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with birthdays on, its switch asking a phone that gives full
  calendar access, and a calendar that records every ask and holds the contact "kate"'s birthday
  worded "Kate Bell's 48th Birthday" on 20 January 2026
- **THEN** it offers the way to the Birthdays screen
- **AND** it still offers it after it is moved to the day before, and after it is then moved on to
  Thursday 22 January 2026
- **AND** saying so has asked the phone and the calendar nothing
- **AND** after the switch is turned off and the day screen is returned to, it offers none
- **AND** a day screen opened the same way with a birthday switch that is on and no calendar, and one
  opened with a calendar and no birthday switch, each offer none

#### Scenario: a day screen whose calendar or birthday ticks cannot be read still offers the way to the Birthdays screen

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at a record
  place, a roster place and a one-off place where nothing has been kept and a birthday place holding
  a run of bytes that is not what birthday ticks are written as, with birthdays on and a calendar
  whose every ask fails
- **THEN** it says birthdays could not be read, and offers the way to the Birthdays screen
- **AND** after the calendar holds the contact "kate"'s birthday worded "Kate Bell's 48th Birthday"
  on 20 January 2026 and answers, and the day screen is returned to, it says its birthday ticks could
  not be read, and still offers the way

#### Scenario: a day screen shown again after the phone withdraws calendar access offers no way to the Birthdays screen

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with birthdays on, its switch asking a phone that gives full
  calendar access, and a calendar holding the contact "kate"'s birthday worded "Kate Bell's 48th
  Birthday" on 20 January 2026; the phone then denies calendar access; and the app is shown again as
  of that same day
- **THEN** it offers no way to the Birthdays screen, and its birthday switch is off
- **AND** with the phone then giving full access again and the app shown again, it still offers none

### Requirement: A day screen opens the Birthdays screen as of the today it was last handed, whichever day it is showing

Where it offers the way to the Birthdays screen, a day screen SHALL open one as of the today it was
last handed, never the day it is showing, reading birthdays from its own calendar while on its own
birthday switch, keeping present ideas at the present-idea place beside its record place, and
copying to its copy place where it was handed one. Where it offers no way, it SHALL open none.
Opening one SHALL leave the day it is showing as it was.

#### Scenario: a day screen opens the Birthdays screen as of its today whichever day it is showing, and none while birthdays are off

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with birthdays on and a calendar that records every ask and
  hands, whatever it is asked for, the contact "kate"'s birthday worded "Kate Bell's 48th Birthday"
  on 20 January 2026; it is moved to the day before; and a Birthdays screen is opened through it
- **THEN** its calendar was last asked for 20 January 2026 through 19 January 2027
- **AND** it lists one line, saying "Kate Bell's 48th Birthday" and "Today"
- **AND** the day screen still shows Monday 19 January 2026
- **AND** one opened through it after it is moved on to Thursday 22 January 2026 lists the same line
- **AND** a day screen opened the same way with a birthday switch that is off opens none

#### Scenario: a Birthdays screen a day screen opens keeps its ideas beside the day screen's record place, and copies to the day screen's copy place

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, beside a present-idea place where nothing has been kept, with
  birthdays on, a calendar holding the contact "kate"'s birthday worded "Kate Bell's 48th Birthday"
  on 20 January 2026, and a copy place whose directory is given; a Birthdays screen is opened through
  it; and the idea "Scarf" is added through that to Kate's line
- **THEN** the add is not refused
- **AND** a Birthdays screen opened afterwards at the present-idea place beside the day screen's
  record place gives back the idea "Scarf" for Kate's line
- **AND** the copy at the copy place's directory holds the idea "Scarf" against the contact "kate"

### Requirement: A Birthdays screen lists only the lines whose words hold its search, whatever the capitals and accents

A Birthdays screen SHALL hold a search exactly as typed, empty when it is opened. A line SHALL match
a search exactly where the search, with the blank space before and after it disregarded, stands
anywhere in the line's words as the calendar handed them, letters compared whatever their capitals
and their accents; the screen SHALL consult no locale to compare them. A search that says nothing,
judged exactly as a commitment's name is judged, SHALL match every line. A line's day, its count of ideas and the present ideas of its contact MUST NOT be
searched. The lines that match SHALL be listed in the order the screen lists them with no search,
each the same line, and an edited search SHALL be followed at once, without its calendar being
asked again.

#### Scenario: a Birthdays screen with a search lists only the lines whose words hold it, whatever the capitals and accents

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  that records every ask and hands, whatever it is asked for, the contact "anna"'s birthday worded
  "Anna Müller's Birthday" on 14 November 2026, the contact "kate"'s worded "Kate Bell's 48th
  Birthday" on 1 December 2026 and the contact "hans"'s worded "Hans Muller's Birthday" on 1 January
  2027, and its search is edited to "mul"
- **THEN** it lists two lines, saying "Anna Müller's Birthday" and then "Hans Muller's Birthday",
  each the same line it listed before its search was edited
- **AND** with its search edited to "MÜL", it lists the same two lines
- **AND** with its search edited to "bell's 48", it lists Kate's line alone
- **AND** with its search edited to "birth", it lists all three lines, Anna's, Kate's and then Hans's
- **AND** with its search edited to "Bell Kate", it lists nothing
- **AND** its calendar has been asked once in all

#### Scenario: a Birthdays screen's search looks only in a line's words, never in its day, its count of ideas or its ideas

- **WHEN** a present-idea place holds the idea "Scarf" against the contact "kate", and a Birthdays
  screen is opened at it as of Monday 12 October 2026 with birthdays on and a calendar holding the
  contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026, its one line
  saying "Sat 14 November" and "1 idea"
- **THEN** with its search edited to "November", it lists nothing
- **AND** with its search edited to "idea", it lists nothing
- **AND** with its search edited to "scarf", it lists nothing
- **AND** with its search edited to "kate", it lists Kate's line

#### Scenario: a Birthdays screen disregards the spaces before and after its search, and a search of spaces only lists every line

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  holding the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026 and
  the contact "zoe"'s worded with empty words on 1 December 2026, and its search is edited to "  kate "
- **THEN** it lists Kate's line alone, and holds the search "  kate " exactly as typed
- **AND** with its search edited to "kate bell", it lists Kate's line alone, and edited to
  "kate  bell", with two spaces between, it lists nothing
- **AND** with its search edited to three spaces, it lists both lines, Zoe's saying no words, and
  edited to be empty, it lists both lines

### Requirement: A Birthdays screen whose search matches nobody says so, quoting it

Where it holds a search that says something and that no line it would list with no search matches, a
Birthdays screen SHALL list nothing and SHALL say "Nobody matches “”." with that search between the
quotation marks, the blank space before and after it disregarded, in this package's own words.
Where any line matches, or where its search says nothing, it SHALL say no such thing. Saying it
SHALL leave what the screen says about birthdays and about its present ideas as it was, and the
screen SHALL still offer its search.

#### Scenario: a Birthdays screen whose search matches nobody says so, quoting the search without the spaces around it

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  holding the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026, and
  its search is edited to " Kim  "
- **THEN** it lists nothing and says "Nobody matches “Kim”."
- **AND** it says birthdays are on, and still offers a search
- **AND** with its search edited to "kat", it lists Kate's line and says nothing of matching nobody
- **AND** with its search edited to three spaces, it lists Kate's line and says nothing of matching
  nobody

### Requirement: A Birthdays screen offers a search only while it lists a line, and holds it until the screen is left

A Birthdays screen SHALL offer a search exactly while, holding no search, it would list at least one
line, and SHALL offer none while birthdays are off, while its calendar cannot be read, or while
nobody falls in its span. While it offers none it SHALL hold an empty search, and editing its search
then SHALL change nothing. It SHALL keep its search across being shown again, matched against the
lines it then lists, and across ideas being added, changed, deleted or marked through it; shown
again offering none, it SHALL hold an empty search. A Birthdays screen opened afresh SHALL hold an
empty search.

#### Scenario: a Birthdays screen offers a search only while it lists a line, and holds none while it offers none

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  holding the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026
- **THEN** it offers a search
- **AND** one opened the same way with a calendar holding no birthdays offers none, and after its
  search is edited to "kate" it holds an empty search, lists nothing and says nothing of matching
  nobody
- **AND** one opened the same way with a birthday switch that is off offers none, and so does one
  opened with a calendar whose every ask fails

#### Scenario: a Birthdays screen keeps its search when an idea is added and when it is shown again, and one opened afresh holds none

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 at a present-idea place where
  nothing has been kept, with birthdays on and a calendar handing, whatever it is asked for, the
  contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026 and the contact
  "john"'s worded "John Appleseed's 40th Birthday" on 1 December 2026; its search is edited to
  "kate"; and the idea "Scarf" is added through it to Kate's line
- **THEN** it holds the search "kate" and lists Kate's line alone, saying "1 idea"
- **AND** after it is shown again as of Tuesday 13 October 2026, it still holds the search "kate" and
  lists Kate's line alone, saying "1 idea"
- **AND** a Birthdays screen opened afterwards the same way at that place holds an empty search and
  lists both lines

#### Scenario: a Birthdays screen shown again listing nobody ends its search

- **WHEN** a Birthdays screen is opened as of Monday 12 October 2026 with birthdays on and a calendar
  holding the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026, and
  its search is edited to "kate"; the calendar's every ask then fails; and the screen is shown again
  as of that same day
- **THEN** it lists nothing, says birthdays could not be read, offers no search and holds an empty
  search
- **AND** after the calendar answers again and the screen is shown again as of that same day, it
  lists Kate's line, offers a search and still holds an empty search

## MODIFIED Requirements

### Requirement: A Birthdays screen lists every birthday the calendar hands from its today through the day before the same date a year later

A Birthdays screen SHALL be opened as of a today, with a calendar and a birthday switch, and SHALL
take its today when it is opened and each time it is shown again, and at no other moment. While
birthdays are on, it SHALL ask its calendar once when it is opened and once each time it is shown
again, and at no other moment, for the days from its today through the day before the same date a
year later — through 28 February where its today is 29 February — or through the last supported
date where that day would fall past it. It SHALL list one line for every birthday handed falling in
that span and matching its search, and none for any other, leaving none out and merging none, so a
birthday handed twice SHALL be listed twice. Reading what it lists SHALL ask nothing.

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

## REMOVED Requirements

### Requirement: A commitments screen offers the way to the Birthdays screen exactly while birthdays are on

**Reason**: The way to the Birthdays screen moves to the day screen, and only there; the commitments
screen is for keeping commitments.
**Migration**: None on disk. A commitments screen is still opened with a birthday switch; it offers
no way to the Birthdays screen.
