## ADDED Requirements

### Requirement: A history answers a commitment's standing in the week of a calendar date

A history SHALL answer a commitment's standing on a calendar date: how many days of that date's
week hold a record keeping it. A week SHALL be Monday through the following Sunday, whatever the
host's calendar says. The count SHALL run from that Monday through the date asked about, that date
included, and no later day. Where that Monday is before the first date the system forms, it SHALL
count the days that exist.

A day SHALL count exactly where the history answers that commitment kept on it, whatever kind of
record keeps it. The answer SHALL depend on the commitment and the date alone: no other
commitment's records SHALL count, and when a record was entered SHALL NOT matter. A history SHALL
answer for every commitment and SHALL consult no schedule. The standing SHALL be that count and
SHALL NOT be capped at what a quota asks for.

#### Scenario: a history that has taken no record answers a standing of zero for a commitment in any week

- **WHEN** a history that has taken no record is asked the standing of a commitment named "Reading"
  on a weekly quota of 3 times a week, kept from 1 January 2026, on Wednesday 2 September 2026
- **THEN** it answers zero
- **AND** it answers zero rather than nothing
- **AND** it answers zero for that commitment on Monday 31 August 2026 and on Sunday 6 September 2026 too

#### Scenario: a standing counts the week's days through the date and never a day after it

- **WHEN** ticks for a commitment named "Reading" on a weekly quota of 3 times a week, kept from
  1 January 2026, on Monday 31 August, Wednesday 2 September and Friday 4 September 2026 are added
  to a history
- **THEN** it answers a standing of 2 for that commitment on Wednesday 2 September 2026
- **AND** a standing of 2 on Thursday 3 September 2026
- **AND** a standing of 3 on Friday 4 September 2026
- **AND** a standing of 1 on Monday 31 August 2026

#### Scenario: a Sunday's standing counts back to the Monday of its week rather than forward from it

- **WHEN** ticks for a commitment named "Reading" on a weekly quota of 3 times a week, kept from
  1 January 2026, on Monday 31 August and Sunday 6 September 2026 are added to a history
- **THEN** it answers a standing of 2 for that commitment on Sunday 6 September 2026
- **AND** a standing of zero on Monday 7 September 2026, the first day of the week after

#### Scenario: a record in the week before and one in the week after do not count toward a standing

- **WHEN** ticks for a commitment named "Reading" on a weekly quota of 3 times a week, kept from
  1 January 2026, on Sunday 30 August, Wednesday 2 September and Monday 7 September 2026 are added
  to a history
- **THEN** it answers a standing of 1 for that commitment on Sunday 6 September 2026
- **AND** a standing of 1 on Sunday 30 August 2026
- **AND** a standing of 1 on Monday 7 September 2026

#### Scenario: a standing is counted by date and never by when a record was entered

- **WHEN** a tick for a commitment named "Reading" on a weekly quota of 3 times a week, kept from
  1 January 2026, on Wednesday 2 September 2026 is added to a history, and a tick on Thursday
  3 September 2026 is added after it, and a tick on Tuesday 1 September 2026 after that
- **THEN** the history answers a standing of 2 for that commitment on Wednesday 2 September 2026
- **AND** a standing of 3 on Thursday 3 September 2026

#### Scenario: a standing past what a quota asks for is the count of kept days and is never capped

- **WHEN** ticks for a commitment named "Reading" on a weekly quota of 3 times a week, kept from
  1 January 2026, on Monday 31 August, Tuesday 1 September, Wednesday 2 September and Thursday
  3 September 2026 are added to a history
- **THEN** it answers a standing of 4 for that commitment on Thursday 3 September 2026
- **AND** a standing of 4 on Sunday 6 September 2026

#### Scenario: a commitment on a schedule that is not a weekly quota is answered a standing just the same

- **WHEN** ticks are added to a history for a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, on Monday 31 August and Wednesday 2 September
  2026, and for a commitment named "Lenses" on a schedule of every 3 days from 1 January 2026, kept
  from that day, on Tuesday 1 September and Friday 4 September 2026
- **THEN** the history answers a standing of 2 for "Gym" on Saturday 5 September 2026
- **AND** a standing of 2 for "Lenses" on Saturday 5 September 2026

#### Scenario: a number, a note and a total at its target each count their day, and a total short of it does not

- **WHEN** a number of 70.5 on Monday 31 August 2026 is added to a history for a commitment named
  "Weight" of the number kind, a note on Tuesday 1 September 2026 for one named "Journal" of the
  note kind, an addition of 120 on Wednesday 2 September 2026 for one named "Protein" of the total
  kind with a target of 120, and an addition of 30 on Thursday 3 September 2026 for that same
  "Protein" — all on a schedule listing all seven weekdays and kept from 1 January 2026
- **THEN** the history answers a standing of 1 for "Weight" on Thursday 3 September 2026
- **AND** a standing of 1 for "Journal" on Thursday 3 September 2026
- **AND** a standing of 1 for "Protein" on Thursday 3 September 2026, the day short of its target
  counting for nothing

#### Scenario: another commitment's records do not count toward a standing

- **WHEN** ticks for a commitment named "Reading" on Monday 31 August 2026 and for one named
  "Meditation" on Tuesday 1 September and Wednesday 2 September 2026, both on a weekly quota of
  3 times a week and both kept from 1 January 2026, are added to a history
- **THEN** it answers a standing of 1 for "Reading" on Wednesday 2 September 2026
- **AND** a standing of 2 for "Meditation" on that date

#### Scenario: a week reaching back before the first supported date counts the days of it that exist

- **WHEN** ticks for a commitment named "Reading" on a weekly quota of 3 times a week, kept from
  1 January 1583, on Saturday 1 January and Sunday 2 January 1583 are added to a history
- **THEN** it answers a standing of 1 for that commitment on Saturday 1 January 1583
- **AND** a standing of 2 on Sunday 2 January 1583
- **AND** a standing of zero on Monday 3 January 1583, the first day of the week after

#### Scenario: a standing on the last supported date counts its week's days through it

- **WHEN** ticks for a commitment named "Reading" on a weekly quota of 3 times a week, kept from
  1 January 2026, on Monday 27 December, Wednesday 29 December and Friday 31 December 9999 are
  added to a history
- **THEN** it answers a standing of 3 for that commitment on Friday 31 December 9999
- **AND** a standing of 2 on Wednesday 29 December 9999
