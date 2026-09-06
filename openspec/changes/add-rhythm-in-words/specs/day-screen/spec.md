## MODIFIED Requirements

### Requirement: A row is a commitment's line on a date

A row SHALL be three things and no others: the commitment it is a line for, the date the day view
holding it is of, and whether that commitment is kept on that date. Two rows SHALL be the same row
when all three agree, and SHALL be different when any one of them differs.

The date is part of what a row is rather than something the day view alone holds. Two rows for the
same commitment, each saying the same thing about it, on two different dates SHALL be different
rows: they offer different ticks, and one cannot stand in for the other. This adds to what a day
view is without changing it — a day view is already its rows and its date, so day views on two dates
were already two day views, and this makes them so a second way rather than a new way.

A row SHALL be reachable only through the day view that holds it, and SHALL give back four things:
its commitment's name, **the rhythm that commitment runs on in words**, whether that commitment is
kept, and the tick it offers. It MUST NOT give back the commitment itself, the schedule underneath
it, the day it is kept from, or the date the row is for: what a reader is given is what a screen
draws and what a tap makes, and nothing else has been asked for.

The words SHALL be the ones the `schedule` capability says for the schedule the row's commitment
carries, and this capability SHALL compose none of them — they are the same words a commitments
screen's entry says for the same commitment, so one rhythm reads the same way on both screens.
Giving them back is not this capability reaching past a commitment to the schedule underneath it:
the words are asked of the commitment, exactly as its name is.

Every row SHALL say its rhythm, on every day view, always — not only where two rows would otherwise
read alike. The day screen is the daily visit, and what rhythm a thing runs on is part of reading
the day rather than a disambiguation added when a name happens to repeat. A row SHALL say it whether
or not the commitment is kept on that date, and whether or not the row offers a tick at all: a row
for a day that has not arrived offers no tick and says its rhythm like every other row.

What a row **is** does not change: still the three things above. The words are read off the
commitment the row already holds, so two rows agreeing on those three agree on the rhythm they say,
and no row is made different from another by this requirement.

#### Scenario: two rows for the same commitment and date saying the same thing are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, each from a history
  holding a tick for that commitment on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are the same row

#### Scenario: two rows for the same commitment on different dates are different rows

- **WHEN** two day views are formed of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, each from a history that has taken no tick, one
  on Monday 31 August 2026 and one on Wednesday 2 September 2026
- **THEN** each holds one row named "Gym", saying the commitment is not kept
- **AND** the two rows are different rows

#### Scenario: two rows for the same commitment and date differing in whether it is kept are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a
  history that has taken no tick and the second from a history holding a tick for that commitment on
  that date
- **THEN** the two rows are different rows

#### Scenario: a row says the rhythm its commitment runs on in words

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, one named
  "Finances" on a schedule on the 31st of the month, one named "Contact lenses" on a schedule of
  every 14 days starting on 31 August 2026, and one named "Reading" on a schedule of 3 times a week,
  all kept from 1 January 2026
- **THEN** the day view holds four rows, saying "Mon, Wed, Sat", "The 31st", "Every 14 days" and
  "3x a week" in that order

#### Scenario: a row says its rhythm whether or not its commitment is kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a
  history that has taken no tick and the second from a history holding a tick for that commitment on
  that date
- **THEN** the first day view's row says it is not kept and says "Mon, Wed, Sat"
- **AND** the second day view's row says it is kept and says "Mon, Wed, Sat"

#### Scenario: a row for a day that has not arrived says its rhythm

- **WHEN** a day view is formed on Friday 4 September 2026, from a history that has taken no tick, of
  a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, and
  its row is asked for the tick it offers as of Thursday 3 September 2026
- **THEN** the row offers no tick
- **AND** the row says "Every day"

#### Scenario: two rows for commitments alike in name and not in rhythm say different rhythms

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick, of a
  commitment named "Vitamins" on a schedule listing Monday and Wednesday and a commitment named
  "Vitamins" on a schedule listing all seven weekdays, both kept from 1 January 2026
- **THEN** the day view holds two rows, both named "Vitamins"
- **AND** the first says "Mon, Wed" and the second says "Every day"
