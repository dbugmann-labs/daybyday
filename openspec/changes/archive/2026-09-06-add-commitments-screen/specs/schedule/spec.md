## ADDED Requirements

### Requirement: A calendar date gives back the year, the month and the day it names

A calendar date SHALL give back the three numbers it names — the year, the month and the day — and
SHALL give each of them back exactly as it was offered, unadjusted. Forming a calendar date from
the three a formed one gives back SHALL give an equal date: the read-back is the inverse of the
forming the requirements above describe, and it loses nothing on the way.

The three SHALL be readable and SHALL NOT be writable. A calendar date whose components could be
assigned one at a time could be walked, between two dates that both exist, through a combination
that names none — 31 January with its month set to February — and the refusals above would then be
a rule about how a date is first made rather than a rule about every calendar date that exists. The
only way to have a different calendar date is to form a new one, which is judged the same way the
first was.

This is the half of ADR-1004's conversion that could not be performed. That decision put calendar
dates in the rule engine and instants at the edge, and an edge converts in both directions: turning
an instant into a calendar date is a matter of asking a calendar for its components, and turning a
calendar date back into an instant is not possible at all unless those three numbers can be read.
The first thing to need it is a screen seeding a date picker with the day it offers to keep a
commitment from, which speaks instants and has no other way to be told which day that is. Without
the read-back such a screen must read a clock of its own, and then it is showing a day nobody
handed it.

This requirement is about a calendar date and nothing else. A day of the month, an interval of days
and a weekly quota still give their numbers back to nothing outside the module, and a calendar date
is still not ordered — `docs/open-questions.md` § *Known gaps* carries both, and neither is closed
here.

#### Scenario: a calendar date gives back the three numbers it was formed from

- **WHEN** a calendar date is formed from the year 2026, the month August and the day 31
- **THEN** the year it gives back is 2026, the month it gives back is 8, and the day it gives back
  is 31

#### Scenario: a calendar date gives back its month and its day the way round they were offered

- **WHEN** a calendar date is formed from the year 2026, the month December and the day 1, and a
  second from the year 2026, the month January and the day 12
- **THEN** the first gives back the month 12 and the day 1
- **AND** the second gives back the month 1 and the day 12

#### Scenario: a calendar date at each end of the supported years gives back that year

- **WHEN** a calendar date is formed from the year 1583, the month January and the day 1, and a
  second from the year 9999, the month December and the day 31
- **THEN** the first gives back the year 1583, the month 1 and the day 1
- **AND** the second gives back the year 9999, the month 12 and the day 31

#### Scenario: a calendar date formed again from what it gives back is the same date

- **WHEN** a calendar date is formed for 29 February 2028, and a second calendar date is formed
  from the three numbers the first gives back
- **THEN** the second calendar date is formed
- **AND** the two are equal
