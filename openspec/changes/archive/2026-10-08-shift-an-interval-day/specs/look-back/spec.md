## MODIFIED Requirements

### Requirement: A look-back counts a shifted due day where it landed, and the day it came from not at all

A look-back SHALL count the day a shift of the commitment put a due day on as due, in the month that
day falls in, and as kept where the history keeps the commitment on it, and SHALL NOT count the day
the shift took that due day from as due. On a weekday set or a day of the month, a month a due day
is shifted into SHALL count it beside its own due days, and the month it left SHALL count one due day
fewer, however few that leaves. On every N days, every due day after the shift SHALL be counted
where the count running on from the day it landed puts it, in whichever month that falls. A
look-back SHALL say nothing of a shift itself, in no line and no word.

#### Scenario: a weekday-set day shifted into the next month is counted due and kept there

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, whose days take a tick, is taken on at a roster place and its due day on Monday
  31 August 2026 is shifted there to Tuesday 1 September 2026; a tick for it on Tuesday 1 September
  2026 is kept at a record place; and a look-back is asked for at "Gym" through a commitments screen
  opened at those places as of Sunday 6 September 2026
- **THEN** the line for September 2026 says the fraction "1/3"
- **AND** the line for August 2026 says the fraction "0/13"

#### Scenario: a day-of-month day shifted into the month before leaves that month owing two days and its own none

- **WHEN** a commitment named "Finances" on a schedule on the 1st of the month, kept from 1 January
  2026, whose days take a tick, is taken on at a roster place and its due day on Tuesday 1 September
  2026 is shifted there to Monday 31 August 2026; and a look-back is asked for at "Finances" through
  a commitments screen opened at that roster place and a record place where nothing has been kept as
  of Wednesday 30 September 2026
- **THEN** the line for August 2026 says the fraction "0/2"
- **AND** the line for September 2026 says the fraction "0/0"

#### Scenario: an every-N-days day shifted back into the month before moves every later due day with it

- **WHEN** a commitment named "Contact lenses" on a schedule of every 14 days starting on Tuesday
  25 August 2026, kept from that day, whose days take a tick, is taken on at a roster place and its
  due day on Tuesday 8 September 2026 is shifted there to Monday 31 August 2026; ticks for it on
  Tuesday 25 August and Monday 31 August 2026 are kept at a record place; and a look-back is asked
  for at "Contact lenses" through a commitments screen opened at those places as of Wednesday
  30 September 2026
- **THEN** the line for August 2026 says the fraction "2/2"
- **AND** the line for September 2026 says the fraction "0/2"
