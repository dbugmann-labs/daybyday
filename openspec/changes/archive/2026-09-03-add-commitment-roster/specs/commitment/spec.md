## ADDED Requirements

### Requirement: A roster holds the commitments a person keeps, in the order they were taken on

A roster SHALL hold commitments, in the order they were added to it, and SHALL read them back in
that order. A roster that has been given no commitment SHALL hold none, and SHALL be an answer
rather than a refusal: a person who keeps nothing yet has an empty roster, not a missing one.
There SHALL be no upper bound on how many commitments a roster holds.

The order SHALL be the order they were taken on and nothing else. A roster MUST NOT sort its
commitments by name, by the day each is kept from, by the schedule each runs on, or by any other
property of them. It has no order of its own to invent: day one's commitments are all kept from the
same day, so an order taken from that day would leave them tied and the roster choosing between
them, and an order taken from a name would be a rule about the owner's own words. This is the same
reason a day view orders nothing of its own and shows what it was handed in the order it was handed
it.

A roster SHALL hold commitments and nothing else. It MUST NOT give a commitment an identifier, a
position a commitment can be asked for, a record of the day it was added, or any state of its own,
and it MUST NOT alter a commitment it holds: a commitment read back out of a roster SHALL be the
commitment that was put in, with the same name, the same schedule and the same day it is kept from.

A roster SHALL NOT consult the present moment, the device's clock, its time zone or its locale, and
SHALL NOT be asked what day it is. It judges no date at all: a commitment kept from a day long past
and a commitment kept from the last date the system supports are held alike, and whether either is
due on any date is the commitment's own answer and not the roster's.

A roster SHALL be a value. Two rosters holding the same commitments in the same order SHALL be the
same roster, and two holding the same commitments in a different order SHALL be different rosters,
because the order is one of the things a roster holds. Adding a commitment to a roster SHALL leave
every other roster untouched, so a roster that was copied before an addition SHALL still hold what
it held.

#### Scenario: a roster that has been given no commitment holds none

- **WHEN** a roster is formed and nothing is added to it
- **THEN** the roster holds no commitments

#### Scenario: a roster reads its commitments back in the order they were added

- **WHEN** a roster is given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all three on a schedule listing Monday, Wednesday and Saturday and all three kept
  from 1 January 2026
- **THEN** the roster holds those three commitments in that order — "Water plants", then "Gym", then
  "Journaling" — and not in alphabetical order

#### Scenario: a roster does not order its commitments by the day they are kept from

- **WHEN** a roster is given a commitment named "Gym" kept from 1 March 2026, then one named "Run"
  kept from 1 January 2026, both on a schedule listing Monday, Wednesday and Saturday
- **THEN** the roster holds "Gym" first and "Run" second, in the order they were added and not in
  the order of the days they are kept from

#### Scenario: two rosters holding the same commitments in the same order are the same roster

- **WHEN** two rosters are each given a commitment named "Gym", then one named "Run", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026
- **THEN** the two are the same roster

#### Scenario: two rosters holding the same commitments in a different order are different rosters

- **WHEN** one roster is given a commitment named "Gym" and then one named "Run", and a second
  roster is given the same two the other way round, all on a schedule listing Monday, Wednesday and
  Saturday and all kept from 1 January 2026
- **THEN** the two are different rosters

#### Scenario: adding to a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is copied, and a commitment named "Run" alike in every other
  way is added to the copy
- **THEN** the copy holds two commitments, "Gym" and then "Run"
- **AND** the roster it was copied from still holds one commitment, "Gym", and is not the same
  roster as the copy

#### Scenario: a roster holds a commitment kept from the last supported date like any other

- **WHEN** a roster is given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 31 December 9999, and then one named "Run" alike in every other way but kept
  from 1 January 2026
- **THEN** the roster holds both, in that order, and reads each back with the day it is kept from
  unchanged

### Requirement: A roster refuses a commitment it already holds

A roster SHALL refuse a commitment equal to one it already holds. Refusing SHALL leave the roster
exactly as it was — the same commitments, in the same order, with the one already held keeping the
position it had — and the roster SHALL report that the commitment was not added. Adding a commitment
a roster does not hold SHALL place it after every commitment already there and SHALL report that it
was added.

Reporting is part of the refusal and MUST NOT be dropped. A caller that does not care may ignore
what it is told, but a caller that does care cannot recover a report that was never made: doing
nothing and saying nothing is indistinguishable to a person from having added a second commitment,
which is the one thing a roster exists to prevent. Whether anything is said on a screen, and in what
words, is not this requirement's — it is what a screen does with the report.

Two commitments are the same commitment when their name, their schedule and the day they are kept
from are all the same, and a roster SHALL use that and nothing else to decide what it already holds.
It MUST NOT invent a coarser sameness of its own: two commitments alike in name but differing in
schedule or in the day they are kept from are different commitments and a roster SHALL hold both,
and two names differing only by blank space are different names, because a commitment's name is
stored exactly as it was given and tidying it belongs where a person typed it.

This is why the refusal exists at all. A commitment carries no identifier, so a roster holding two
commitments a person would call identical could not be told which of them to stop keeping, which of
them to change, or which of them a screen was pointing at. There is nothing to tell them apart by,
and so there must not be two.

A roster SHALL refuse nothing else. It MUST NOT judge a name, a schedule or a day a commitment is
kept from — anything that is a commitment at all was already accepted when the commitment was formed
— it MUST NOT refuse on how many commitments it holds, and it MUST NOT refuse on a date.

#### Scenario: adding a commitment a roster does not hold places it after the ones already there and says it was added

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is given one named "Run" alike in every other way
- **THEN** the roster reports that the commitment was added
- **AND** the roster holds two commitments, "Gym" first and "Run" second

#### Scenario: adding a commitment a roster already holds says it was not added and leaves the roster as it was

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is given a second commitment formed with that same name, that
  same schedule and that same day
- **THEN** the roster reports that the commitment was not added
- **AND** the roster still holds exactly one commitment, named "Gym"
- **AND** it is the same roster as one given that commitment once

#### Scenario: a refused commitment does not move the one already held

- **WHEN** a roster is given a commitment named "Gym", then one named "Run", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January
  2026, and is then given a second commitment alike in every way to "Gym"
- **THEN** the roster still holds three commitments in the order "Gym", "Run", "Journaling", with
  "Gym" in the position it already had and not moved to the end

#### Scenario: two commitments alike in name but on different schedules are both held

- **WHEN** a roster is given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and then one named "Gym" on a schedule listing Tuesday and
  Thursday, kept from that same day
- **THEN** the roster reports that the second commitment was added
- **AND** the roster holds two commitments, both named "Gym"

#### Scenario: two commitments alike in name and schedule but kept from different days are both held

- **WHEN** a roster is given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and then one alike in name and schedule but kept from
  2 January 2026
- **THEN** the roster reports that the second commitment was added
- **AND** the roster holds two commitments, both named "Gym"

#### Scenario: two names differing only by a space at the end are different commitments and both are held

- **WHEN** a roster is given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and then one named "Gym " — the same word with a trailing
  space — alike in every other way
- **THEN** the roster reports that the second commitment was added
- **AND** the roster holds two commitments, the first reading back as "Gym" and the second as "Gym "
