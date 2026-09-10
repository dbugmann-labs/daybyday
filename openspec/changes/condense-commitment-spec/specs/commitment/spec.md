## MODIFIED Requirements

### Requirement: A commitment is a name, a schedule, and the day it is kept from

A commitment SHALL be exactly four things: a name, the schedule deciding which days it is due on,
the calendar date it is kept from, and the kind its days take. It SHALL carry nothing else: no
identifier, no record of what was ticked, no position in a list, no state that can be paused or
archived. It SHALL read back its name and its kind.

The first three SHALL be required: the system MUST NOT form a commitment without a day it is kept
from, MUST NOT supply one of its own, and MUST NOT consult the present moment. The kind SHALL
default to the plain kind, a tick.

Two commitments SHALL be the same commitment when their name, their schedule, the day they are kept
from and their kind, with whatever that kind carries, are all the same, and different when any
differs. The kind SHALL be fixed when the commitment is formed, SHALL NOT change afterwards, and no
change SHALL reach it.

#### Scenario: a commitment reads back the name it was given

- **WHEN** a commitment is formed with the name "Gym", a schedule listing Monday, Wednesday and
  Saturday, and kept from 1 January 2026
- **THEN** the commitment's name reads back as "Gym"

#### Scenario: two commitments alike in name, schedule and kept-from day are the same commitment

- **WHEN** two commitments are formed, both named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday, and both kept from 1 January 2026
- **THEN** the two are the same commitment

#### Scenario: two commitments differing only in name are different commitments

- **WHEN** two commitments are formed on the same schedule listing Monday, Wednesday and Saturday
  and kept from the same 1 January 2026, one named "Gym" and one named "Run"
- **THEN** the two are different commitments

#### Scenario: two commitments differing only in schedule are different commitments

- **WHEN** two commitments are formed, both named "Gym" and both kept from 1 January 2026, one on a
  schedule listing Monday and one on a schedule listing Tuesday
- **THEN** the two are different commitments

#### Scenario: two commitments differing only in the day they are kept from are different commitments

- **WHEN** two commitments are formed, both named "Gym" and both on a schedule listing Monday,
  Wednesday and Saturday, one kept from 1 January 2026 and one kept from 2 January 2026
- **THEN** the two are different commitments

#### Scenario: two commitments differing only in the kind their days take are different commitments

- **WHEN** two commitments are formed, both named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, one of the tick kind and one of the note
  kind
- **THEN** the two are different commitments

#### Scenario: two number commitments differing only in their range are different commitments

- **WHEN** two commitments are formed, both named "Weight", both on a schedule listing Monday,
  Wednesday and Saturday, both kept from 1 January 2026 and both of the number kind, one with a
  range of 40 to 150 and one with no range at all
- **THEN** the two are different commitments
- **AND** a third alike in every way but carrying a range of 40 to 200 is a different commitment
  again

### Requirement: A commitment's name says something

The system SHALL refuse to form a commitment whose name is empty, or made only of whitespace, and
MUST refuse it rather than adjust it: it MUST NOT trim such a name down to nothing and accept the
result, and MUST NOT substitute a placeholder of its own.

Every other name SHALL be accepted, and SHALL be stored exactly as it was given, including any blank
space at the start or the end of it. There SHALL be no upper bound on a name's length, no
restriction on the script it is written in, no character the system reserves, and no name the system
rewrites. Two names differing only by blank space SHALL be different names, and commitments alike in
every other part SHALL then be different commitments.

#### Scenario: an empty name is not a commitment

- **WHEN** an empty name, a schedule listing Monday, Wednesday and Saturday, and 1 January 2026 as
  the day it is kept from are offered as a commitment
- **THEN** no commitment is formed

#### Scenario: a name of only whitespace is not a commitment

- **WHEN** a name of three spaces, a schedule listing Monday, Wednesday and Saturday, and 1 January
  2026 as the day it is kept from are offered as a commitment
- **THEN** no commitment is formed
- **AND** a name of a tab followed by a newline forms none either

#### Scenario: a name with a space at each end is stored exactly as given

- **WHEN** a commitment is formed with the name " Gym ", a schedule listing Monday, Wednesday and
  Saturday, and kept from 1 January 2026
- **THEN** the commitment's name reads back as " Gym ", with both spaces
- **AND** it is a different commitment from one named "Gym" alike in every other way

#### Scenario: a name of a single emoji is a commitment

- **WHEN** a commitment is formed with a name that is the single emoji 🏋️, a schedule listing
  Monday, Wednesday and Saturday, and kept from 1 January 2026
- **THEN** the commitment's name reads back as that emoji

### Requirement: A commitment's kind is a tick, a number, a note or a total

A commitment's kind SHALL be exactly one of four: a tick, a number, a note or a total. There SHALL
be no fifth and no way to hold none.

A tick and a note SHALL carry nothing, a number MAY carry a range, and a total MUST carry a target.
A range SHALL belong to the number kind and a target to the total kind, and the system MUST NOT
offer any way of attaching either to a kind it does not belong to: a commitment of a kind with no
room for one SHALL be one that cannot be formed at all, rather than one refused when it is tried.

A commitment SHALL read its kind back, along with whatever that kind carries. A commitment formed
without a kind named SHALL be of the plain kind, a tick, and naming the tick explicitly SHALL give
the same commitment as naming nothing. The kind SHALL NOT enter into whether a commitment is due.

#### Scenario: a commitment reads back the kind it was given

- **WHEN** a commitment named "Weight" on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, is formed of the number kind carrying no range
- **THEN** the commitment's kind reads back as the number kind
- **AND** it carries no range

#### Scenario: a commitment of each of the four kinds is formed and reads its kind back

- **WHEN** four commitments are formed, all named "Gym", all on a schedule listing Monday,
  Wednesday and Saturday and all kept from 1 January 2026 — one of the tick kind, one of the number
  kind carrying no range, one of the note kind, and one of the total kind with a target of 120
- **THEN** each of the four reads its own kind back
- **AND** the total reads back a target of 120

#### Scenario: a commitment formed without a kind is of the plain kind

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is formed without a kind being named
- **THEN** its kind reads back as the tick kind
- **AND** it is the same commitment as one formed alike in every way with the tick kind named

#### Scenario: a commitment's kind does not change whether it is due

- **WHEN** two commitments named "Gym" are formed on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, one of the tick kind and one of the number kind carrying a
  range of 40 to 150
- **THEN** both are due on Monday 31 August 2026
- **AND** neither is due on Tuesday 1 September 2026

### Requirement: A range is a lowest and a highest, and the lowest is not above the highest

A range SHALL be exactly two numbers: the lowest a number commitment will take and the highest. Both
SHALL be required. A commitment of the number kind declaring no range at all SHALL still be one of
the number kind, for which any number is a number.

Both ends SHALL be inclusive. The system MUST NOT form a range whose lowest is above its highest,
and MUST refuse rather than adjust: it MUST NOT swap the two ends, and MUST NOT keep one and drop
the other. That refusal SHALL be made where the range is formed, reaching every caller, and a screen
refusing the same thing in a person's words SHALL surface it rather than make a second one.

A range whose lowest and its highest are equal SHALL be a range. A range end MAY be negative and MAY
be zero. A value that is not a number SHALL NOT be an end of a range.

#### Scenario: a number commitment declares a range and reads it back

- **WHEN** a commitment named "Mood" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is formed of the number kind with a range of 1 to 10
- **THEN** its kind reads back as the number kind carrying that range
- **AND** the range reads back a lowest of 1 and a highest of 10

#### Scenario: a range whose lowest is above its highest is not a range

- **WHEN** a range of 10 down to 1 is offered — a lowest of 10 and a highest of 1
- **THEN** no range is formed
- **AND** a range of 1 to 10 is formed, with a lowest of 1 and a highest of 10

#### Scenario: a range whose lowest and highest are equal is a range

- **WHEN** a range with a lowest of 7 and a highest of 7 is offered
- **THEN** a range is formed
- **AND** a range with a lowest of -40.5 and a highest of 0 is formed too

#### Scenario: a range end that is not a number is not a range

- **WHEN** a range is offered whose lowest is not a number and whose highest is 5
- **THEN** no range is formed
- **AND** a range whose lowest is 5 and whose highest is not a number forms none either

### Requirement: A target is a number above zero

A target SHALL be a single number, and SHALL be above zero. The system MUST NOT form a target of
zero and MUST NOT form one below zero, and MUST refuse rather than adjust: it MUST NOT substitute a
target of its own, and MUST NOT treat a refused target as no target.

A target MAY have a decimal fraction. The system MUST NOT round it, MUST NOT require a whole number,
and MUST NOT attach a unit to it. A value that is not a number SHALL NOT be a target.

#### Scenario: a total commitment declares a target and reads it back

- **WHEN** a commitment named "Protein" on a schedule listing every day of the week, kept from
  1 January 2026, is formed of the total kind with a target of 120
- **THEN** its kind reads back as the total kind carrying that target
- **AND** the target reads back as 120

#### Scenario: a target with a decimal fraction is a target

- **WHEN** a target of 0.5 is offered
- **THEN** a target is formed, reading back as 0.5
- **AND** a target of 119.95 is formed too

#### Scenario: a target of zero and a target below zero are not targets

- **WHEN** a target of 0 is offered
- **THEN** no target is formed
- **AND** a target of -1 forms none either
- **AND** a target of 0.0001 is formed

#### Scenario: a target that is not a number is not a target

- **WHEN** a target that is not a number is offered
- **THEN** no target is formed

### Requirement: A commitment is due exactly when its schedule is due, on and after the day it is kept from

On the day a commitment is kept from and on every date after it, the commitment SHALL be due exactly
when the schedule it carries is due on that date, and SHALL NOT be due on any other such date. It
SHALL add nothing and take nothing away: the system MUST NOT consider the commitment's name, the
current time, the device's time zone, the locale, or whether the commitment has been ticked. The
question SHALL be asked of a calendar date rather than of the present moment, and a date in the past
SHALL answer today as it did when it was today.

Delegation SHALL hold for every schedule shape the `schedule` capability defines and for every shape
added to it later. A commitment on a schedule due on no date SHALL answer that it is not due, rather
than the system treating it as an error.

#### Scenario: a commitment on a weekday-set schedule is due on a listed weekday and not on another

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is asked about Monday 31 August 2026
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about Tuesday 1 September 2026 answers that it is not due

#### Scenario: a commitment on a day-of-month schedule is due on the last day of a month too short for its day

- **WHEN** a commitment named "Finances" on a schedule on the 31st of the month, kept from 1 January
  2026, is asked about 28 February 2027
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about 1 March 2027 answers that it is not due

#### Scenario: a commitment on an every-N-days schedule is due on its start date and not on the day before it

- **WHEN** a commitment named "Contact lenses" on a schedule of every 14 days starting on 25 August
  2026, kept from that same 25 August 2026, is asked about 25 August 2026
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about 24 August 2026 answers that it is not due

#### Scenario: two commitments with different names and the same schedule are due on the same dates

- **WHEN** a commitment named "Gym" and a commitment named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are each asked about every date from
  Monday 31 August through Sunday 6 September 2026
- **THEN** the two answer identically on all seven dates — due on 31 August, 2 September and
  5 September 2026, and not due on the other four

#### Scenario: a commitment on a schedule that is due on no date is never due

- **WHEN** a commitment named "Gym" on a schedule listing no weekday at all, kept from 1 January
  2026, is asked about each date from Monday 31 August through Sunday 6 September 2026
- **THEN** the commitment is due on none of those seven dates

### Requirement: A commitment is not due before the day it is kept from

A commitment SHALL NOT be due on any calendar date earlier than the day it is kept from, whatever
its schedule says about that date, and the system MUST NOT answer that a commitment was due on such
a date.

The rule SHALL apply to every schedule shape alike, and SHALL be a floor rather than a phase: the
day a commitment is kept from MAY be a day its schedule is not due on, and the floor MUST NOT shift
the schedule's own start date or the phase the schedule runs on. Where the schedule is an interval
of days, that interval's start date and this floor SHALL be separate and SHALL both apply.

#### Scenario: a commitment is not due on a date before the day it is kept from

- **WHEN** a commitment on a schedule listing Monday, Wednesday and Saturday, kept from Wednesday
  2 September 2026, is asked about Monday 31 August 2026
- **THEN** the commitment is not due on that date, though its schedule is due on it
- **AND** the same commitment asked about Wednesday 2 September 2026 answers that it is due

#### Scenario: a commitment is due on the day it is kept from when its schedule is due that day

- **WHEN** a commitment on a schedule listing Monday, Wednesday and Saturday, kept from Monday
  31 August 2026, is asked about Monday 31 August 2026
- **THEN** the commitment is due on that date

#### Scenario: a commitment is not due on the day it is kept from when its schedule is not due that day

- **WHEN** a commitment on a schedule listing Monday, Wednesday and Saturday, kept from Tuesday
  1 September 2026, is asked about Tuesday 1 September 2026
- **THEN** the commitment is not due on that date
- **AND** the same commitment asked about Wednesday 2 September 2026 answers that it is due

#### Scenario: a commitment is due on none of the dates in the month before it is kept from

- **WHEN** a commitment on a schedule on the 25th of the month, kept from 1 September 2026, is asked
  about each date from 1 through 31 August 2026
- **THEN** the commitment is due on none of those thirty-one dates
- **AND** the same commitment asked about 25 September 2026 answers that it is due

#### Scenario: an every-N-days occurrence before the day it is kept from is not due

- **WHEN** a commitment on a schedule of every 3 days starting on 25 August 2026, kept from
  1 September 2026, is asked about 28 August 2026
- **THEN** the commitment is not due on that date, though the interval lands on it
- **AND** the same commitment asked about 31 August 2026, the next landing before the floor, answers
  that it is not due
- **AND** the same commitment asked about 3 September 2026 answers that it is due

### Requirement: A roster holds the commitments a person keeps, in the order they were taken on

A roster SHALL hold commitments in an order it holds, and SHALL read back in that order every
commitment it has not stopped keeping. A roster given no commitment SHALL hold none, as an answer
rather than a refusal, and there SHALL be no upper bound on how many it holds.

The order SHALL be the person's. The order the commitments were taken on SHALL be its initial value
and the place a newly taken-on commitment lands, and moving SHALL be the only thing that ever
changes it. A move SHALL take one of exactly two things and there SHALL be no third: a commitment,
or a group, which takes every commitment under one category with it as a block. Changing one
commitment for another SHALL put the second exactly where the first was, and superseding SHALL take
the second on in the place the first held; neither is a move. A roster MUST NOT sort its commitments
by name, by the day each is kept from, or by any other property of them. The order SHALL run over
everything the roster holds, kept, stopped and removed alike, and a commitment stopped or removed
SHALL keep its place in it and return to that place when it is taken up again.

A roster SHALL hold, for each commitment, at most three further things — the category it is under,
the day it was kept until where it has stopped keeping or removed it, and that it was removed — and
nothing else. It MUST NOT give a commitment an identifier, a position it can be asked for, a record
of the day it was added, or any other state, and MUST NOT alter a commitment it holds: one read back
SHALL be the one that was put in. Changing one commitment for another SHALL NOT be altering one, and
the roster SHALL hold no link between the two. Being stopped, removed, put under a category, changed
or superseded SHALL give a commitment no fifth part, and SHALL leave it answering whether it is due
exactly as before. The ban on a position is a ban on a read: nothing SHALL ask a roster where a
commitment is, and moving one hands a place in rather than reading one out. A category SHALL be read
back as part of the groups the roster reads its commitments back in, and nothing SHALL ask it about
one commitment on its own.

Kept, stopped and removed SHALL be the three states, and a commitment the roster holds SHALL be in
exactly one of them: one it is keeping has no kept-until day and has not been removed, one it has
stopped keeping or removed has one. A category SHALL NOT be a fourth state and SHALL cut across all
three. Nothing SHALL take a commitment out of a roster, and a roster ever given one SHALL NOT be the
same roster as one given none.

A roster SHALL NOT consult the present moment, the device's clock, its time zone or its locale,
SHALL NOT be asked what day it is, and SHALL work only with dates it was handed, judging one only
against a day it was told a commitment was kept until. It MUST NOT judge a commitment's own day it
is kept from or its schedule, and MUST NOT decide whether a commitment is due.

A roster SHALL be a value: two holding the same commitments in the same order, each in the same
state, under the same category and with the same kept-until day, SHALL be the same roster; two
holding them in a different order SHALL be different rosters. Adding a commitment, stopping one,
removing one, moving one or putting one under a category SHALL leave every other roster untouched.

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

#### Scenario: two rosters differing only in the category one commitment is under are different rosters

- **WHEN** two rosters are each given a commitment named "Gym", then one named "Run", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026, and the first
  is asked to put "Gym" under the category "Sport"
- **THEN** the two are different rosters
- **AND** a third roster given the same two and asked to put "Gym" under "Sport" is the same roster
  as the first

#### Scenario: a commitment taken on to supersede another lands in that one's place rather than after every commitment already there

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, then one named "Journaling", all kept from 1 January 2026,
  supersedes "Gym" with a commitment named "Gym" on a schedule listing Tuesday and Thursday, kept
  from 1 September 2026, as of 31 August 2026, under no category
- **THEN** the roster reads back three commitments it is keeping, in the order "Water plants", then
  the "Gym" on Tuesday and Thursday, then "Journaling"
- **AND** a commitment named "Reading" added to that roster afterwards is read back last of the four

### Requirement: A roster refuses a commitment it already holds

A roster SHALL refuse a commitment equal to one it is already keeping, SHALL leave itself exactly as
it was — the same commitments in the same order, the one already held keeping its position and its
category — and SHALL report that the commitment was not added. A commitment the roster does not hold
at all SHALL be placed after every commitment already there, under the category it was offered
under, and SHALL be reported as added; one offered without a category being said at all SHALL be
added under none.

A roster SHALL use the four parts a commitment is made of, and nothing else, to decide what it
already holds, in each of the three states it holds a commitment in. Equality on the kind SHALL
compare the whole value: two commitments of the number kind SHALL be the same only where the range
that kind carries is the same range, and a target on the total kind SHALL be compared whole in the
same way. The category SHALL expressly not be a fifth part, in either direction. A roster MUST NOT
invent a coarser sameness of its own: commitments alike in name but differing in schedule, in the
day they are kept from or in kind SHALL be different commitments and SHALL both be held, and two
names differing only by blank space SHALL be different names.

A commitment MAY be offered with a category or without a category being said at all, and the two
SHALL be different asks; there SHALL be no third. One offered with a category SHALL be put under the
category said, and being offered under no category SHALL take the category off. One offered without
a category being said at all SHALL leave the category the roster holds for it exactly as it is —
none for a commitment it does not hold at all, whatever it was for one it is taking up again.

A commitment the roster has stopped keeping, and one it has removed, SHALL each be one it still
holds, and offering either again SHALL take it up again rather than be refused, which SHALL be the
one way back from a removal. The roster SHALL then drop the day that commitment was kept until,
SHALL no longer hold it as removed, SHALL read it back among the commitments it keeps in the place
it has rather than at the end, and SHALL report that it now keeps the commitment. It SHALL NOT hold
the commitment twice, and there SHALL be no second way to take one up again. Taking a commitment up
again SHALL change what the dates between the day it was kept until and the day it was offered again
answer about it, and SHALL leave what was actually done on those days untouched.

Reporting SHALL be part of the refusal and MUST NOT be dropped. A roster SHALL refuse nothing else
it is offered to add: it MUST NOT judge a name, a schedule, a day a commitment is kept from, a kind
or a category, MUST NOT refuse on how many commitments it holds, and MUST NOT refuse on a date.

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

#### Scenario: offering a commitment the roster has stopped keeping takes it up again

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, has stopped keeping it as of 31 January 2026, and is then
  given a commitment formed with that same name, that same schedule and that same day
- **THEN** the roster reports that it now keeps the commitment
- **AND** the roster reads back that one commitment and no second copy of it
- **AND** it is the same roster as one given that commitment once and never asked to stop keeping it

#### Scenario: a commitment taken up again keeps the place it was taken on in

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January
  2026, stops keeping "Gym" as of 31 January 2026 and is then given a commitment alike in every way
  to "Gym"
- **THEN** the roster reports that it now keeps the commitment
- **AND** the roster reads back three commitments in the order "Water plants", "Gym", "Journaling",
  with "Gym" in the place it was taken on in and not at the end

#### Scenario: two commitments alike in every way but the kind their days take are both held

- **WHEN** a roster holding a commitment named "Weight" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, of the number kind with a range of 40 to 150, is given one
  named "Weight" alike in name, schedule and the day it is kept from but of the note kind
- **THEN** the roster reports that the commitment was added
- **AND** the roster holds two commitments, the number one first and the note one second
- **AND** offering the number one again is refused

#### Scenario: two number commitments alike in every way but the range their kind carries are both held

- **WHEN** a roster holding a commitment named "Mood" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, of the number kind with a range of 1 to 10, is given one named
  "Mood" alike in name, schedule and the day it is kept from, of the number kind with a range of 1 to
  5
- **THEN** the roster reports that the commitment was added
- **AND** the roster holds two commitments, the one ranged 1 to 10 first and the one ranged 1 to 5
  second
- **AND** a commitment alike in every way of the number kind carrying no range, given to that roster
  afterwards, is added as a third
- **AND** offering the one ranged 1 to 10 again is refused

#### Scenario: offering a commitment the roster has removed takes it up again, in the place it was taken on in

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January
  2026, removes "Gym" as of 31 January 2026, and is then given a commitment formed with that same
  name, that same schedule and that same day
- **THEN** the roster reports that it now keeps the commitment
- **AND** the roster reads back three commitments in the order "Water plants", "Gym", "Journaling",
  with "Gym" in the place it was taken on in and not at the end
- **AND** it is the same roster as one given the three in that order and never asked to remove any of
  them

#### Scenario: a commitment taken up again after being removed is kept on every date again

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, removes it as of 31 January 2026, and is then given that same
  commitment again
- **THEN** it answers with that commitment on 31 January 2026, on 1 February 2026 and on 1 March 2026
- **AND** the roster reads back that one commitment and no second copy of it

#### Scenario: a commitment moved and then stopped is taken up again in the place it was moved to

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, moves "Journaling" to the offset 0, stops keeping it as of 31 January 2026, and is
  then given that same commitment again
- **THEN** the roster reports that it now keeps the commitment
- **AND** it reads back three commitments in the order "Journaling", "Water plants", "Gym"

#### Scenario: a commitment a roster does not hold is added under the category it was offered under

- **WHEN** a roster is given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, under the category "Supplements", then one named "Gym" alike in
  every other way under no category, and then one named "Journaling" alike in every other way with
  no category said at all
- **THEN** the roster reports that each was added
- **AND** it reads back two groups, one under "Supplements" holding "Creatine" and one under no
  category holding "Gym" and then "Journaling"

#### Scenario: a commitment offered again with no category said keeps the category it was under

- **WHEN** a roster given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, under the category "Supplements", stops keeping it as of
  31 January 2026, and is then given a commitment alike in every way with no category said at all
- **THEN** the roster reports that it now keeps the commitment
- **AND** it reads back one group, under "Supplements", holding "Creatine"

#### Scenario: a commitment taken up again is put under the category it was offered under

- **WHEN** a roster given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, under the category "Supplements", stops keeping it as of
  31 January 2026, and is then given a commitment alike in every way under the category "Morning"
- **THEN** the roster reports that it now keeps the commitment
- **AND** it reads back one group, under "Morning", holding "Creatine"
- **AND** a roster alike in every way offered it again under no category instead reads back one
  group, under no category, holding "Creatine"

#### Scenario: a commitment a roster is already keeping is refused whatever category it is offered under

- **WHEN** a roster given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, under the category "Supplements", is offered a commitment alike in
  every way under the category "Morning"
- **THEN** the roster reports that the commitment was not added
- **AND** it reads back one group, under "Supplements", holding "Creatine"
- **AND** it is the same roster as one given that commitment once under "Supplements" and asked
  nothing else

### Requirement: A roster stops keeping a commitment, on the day it was kept until

A roster SHALL stop keeping a commitment it holds, on being given that commitment and the calendar
date it was kept until, which is the last day it was kept. Stopping SHALL take the commitment out of
the commitments the roster reads back, SHALL record that day against it, and SHALL report that the
roster stopped keeping it, leaving everything else exactly as it was, in the order it was in.

The roster SHALL refuse to stop keeping a commitment in exactly three cases, and SHALL report each:
one it does not hold at all; one it has already stopped keeping; and one it has removed, a removal
being a last state there is nothing a stop could add to. In the second and the third the kept-until
day SHALL stand as first given, and in all three the roster SHALL be left exactly as it was, for as
long as the roster has stopped keeping that commitment or has removed it. Taking a commitment up
again SHALL clear that day and SHALL be the only thing that does, as *A roster refuses a commitment
it already holds* says, and a commitment taken up again SHALL be one the roster can stop keeping
again, on whatever day it was kept until the second time.

The roster SHALL refuse on no date: any calendar date the system supports SHALL be accepted as a day
a commitment was kept until, including the first, the last, and one earlier than the day that
commitment is kept from. The roster SHALL NOT ask what day it is, MUST NOT refuse a day for being in
the future, and MUST NOT accept one for being in the past.

Stopping SHALL change nothing about the commitment itself and nothing recorded against it: a stopped
commitment SHALL answer whether it is due exactly as before, and every tick already recorded SHALL
stand. Stopping SHALL leave every other roster untouched, and two rosters differing only in the day
one commitment was kept until SHALL be different rosters.

#### Scenario: stopping a commitment a roster keeps says so and takes it out of the commitments read back

- **WHEN** a roster holding one commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to stop keeping that commitment as of 31 January 2026
- **THEN** the roster reports that it stopped keeping the commitment
- **AND** the roster reads back no commitments

#### Scenario: stopping one commitment leaves the others where they were

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January
  2026, is asked to stop keeping "Gym" as of 31 January 2026
- **THEN** the roster reads back two commitments in the order "Water plants", then "Journaling"

#### Scenario: stopping a commitment a roster does not hold says it was not stopped and leaves the roster as it was

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to stop keeping a commitment named "Run" alike in
  every other way, as of 31 January 2026
- **THEN** the roster reports that it did not stop keeping the commitment
- **AND** the roster is the same roster as one that was never asked

#### Scenario: stopping a commitment already stopped says it was not stopped and keeps the day first given

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, has stopped keeping it as of 31 January 2026, and is asked to
  stop keeping it again as of 28 February 2026
- **THEN** the roster reports that it did not stop keeping the commitment
- **AND** the roster is the same roster as one asked only the first time

#### Scenario: a commitment taken up again can be stopped again, on a new day

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, stops keeping it as of 31 January 2026, is given that same
  commitment again, and is then asked to stop keeping it as of 28 February 2026
- **THEN** the roster reports that it stopped keeping the commitment
- **AND** it answers with that commitment on 28 February 2026 and with nothing on 1 March 2026

#### Scenario: a commitment kept until a day before the day it is kept from is accepted

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 March 2026, is asked to stop keeping it as of 1 January 2026
- **THEN** the roster reports that it stopped keeping the commitment
- **AND** the roster reads back no commitments

#### Scenario: two rosters differing only in the day one commitment was kept until are different rosters

- **WHEN** two rosters each holding a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, stop keeping it — one as of 31 January 2026 and one as of
  28 February 2026
- **THEN** the two are different rosters
- **AND** a third roster stopping that commitment as of 31 January 2026 is the same roster as the
  first

#### Scenario: stopping a commitment on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is copied, and the copy stops keeping that commitment as of
  31 January 2026
- **THEN** the copy reads back no commitments
- **AND** the roster it was copied from still reads back that one commitment and is not the same
  roster as the copy

#### Scenario: stopping a commitment a roster has removed says it was not stopped and keeps the day it was kept until

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, removes it as of 31 January 2026, and is then asked to stop
  keeping it as of 28 February 2026
- **THEN** the roster reports that it did not stop keeping the commitment
- **AND** the roster is the same roster as one that removed the commitment as of 31 January 2026 and
  was never asked to stop keeping it

### Requirement: A roster answers which commitments it had not stopped keeping on a calendar date

For any calendar date the system supports, a roster SHALL answer with the commitments it had not
stopped keeping on that date: every one it holds that it has neither stopped nor removed, and every
one it has stopped or removed whose kept-until day is that date or later. The answer SHALL be in the
order the roster holds them, with a stopped or removed commitment in the place it has rather than at
either end. Moving a commitment SHALL change the order every date answers in and nothing else about
any date: a move SHALL be dated by nothing and SHALL move no kept-until day.

A removed commitment SHALL be answered exactly as a stopped one is. The roster SHALL answer with a
stopped or removed commitment on the day it was kept until, and SHALL NOT answer with it on any
later date. A commitment taken up again SHALL hold no kept-until day. The roster SHALL answer with
it on every date, the dates between the day it was kept until and the day it was taken up again
included; those dates SHALL answer differently afterwards, and every tick already recorded SHALL
stand.

The roster SHALL apply nothing else: it MUST NOT apply a commitment's own day it is kept from, MUST
NOT apply its schedule, and MUST NOT consider whether anything has been ticked. A date before
anything was taken on SHALL be answered no differently from any other. The answer SHALL be one every
date can be asked for, never a refusal, and a roster holding nothing SHALL answer with nothing on
every date. The roster SHALL NOT ask what day it is, and the same roster asked about the same date
SHALL answer the same way whenever it is asked.

#### Scenario: a roster answers with every commitment it keeps, in the order they were taken on

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", all on a schedule
  listing Monday, Wednesday and Saturday and all kept from 1 January 2026, is asked which
  commitments it had not stopped keeping on 31 January 2026
- **THEN** it answers with both, "Water plants" first and "Gym" second

#### Scenario: a stopped commitment is in the answer on the day it was kept until and out of it on the next day

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, stops keeping it as of 31 January 2026
- **THEN** it answers with that commitment on 31 January 2026
- **AND** it answers with nothing on 1 February 2026
- **AND** it answers with nothing on 1 March 2026

#### Scenario: a stopped commitment keeps its place in the answer for a date it was still kept on

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January
  2026, stops keeping "Gym" as of 31 January 2026
- **THEN** asked about 31 January 2026 it answers with all three in the order "Water plants", "Gym",
  "Journaling", with "Gym" in the middle and not at either end
- **AND** asked about 1 February 2026 it answers with "Water plants" and then "Journaling"

#### Scenario: taking a commitment up again puts it back in the answer for the dates between

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, stops keeping it as of 31 January 2026, and is then given that
  same commitment again
- **THEN** it answers with that commitment on 31 January 2026, on 1 February 2026 and on 1 March 2026

#### Scenario: stopping a commitment leaves every earlier date answering as it did

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked about 1 January 2026, 2 January 2026 and 1 January
  1583, and is then asked to stop keeping it as of 31 January 2026 and asked about those three dates
  again
- **THEN** all three answers are the same after the commitment was stopped as before it, each naming
  that one commitment

#### Scenario: a commitment kept from a later date is in the answer for a date before it

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 March 2026, is asked which commitments it had not stopped keeping on
  1 January 2026
- **THEN** it answers with that commitment, because the day it is kept from is the commitment's own
  answer and not the roster's

#### Scenario: a roster that holds nothing answers with nothing on every date

- **WHEN** a roster that has been given no commitment is asked about 1 January 1583, about 1 January
  2026 and about 31 December 9999
- **THEN** it answers with nothing on each of the three, and refuses none of them

#### Scenario: a removed commitment is in the answer on the day it was kept until and out of it on the next day

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January
  2026, removes "Gym" as of 31 January 2026
- **THEN** asked about 31 January 2026 it answers with all three in the order "Water plants", "Gym",
  "Journaling", with "Gym" in the middle and not at either end
- **AND** asked about 1 February 2026 it answers with "Water plants" and then "Journaling"
- **AND** asked about 1 March 2026 it answers with "Water plants" and then "Journaling"

#### Scenario: removing a commitment leaves every earlier date answering as it did

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked about 1 January 2026, 2 January 2026 and 1 January
  1583, and is then removed as of 31 January 2026 and asked about those three dates again
- **THEN** all three answers are the same after the commitment was removed as before it, each naming
  that one commitment

#### Scenario: a roster answers about a date in the order it was moved into

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, stops keeping "Gym" as of 31 January 2026 and then moves "Journaling" to the
  offset 0
- **THEN** asked about 31 January 2026 it answers with "Journaling", then "Water plants", then "Gym"
  — the offset naming "Water plants", the first of the two commitments it was keeping, as the one the
  moved commitment comes to stand before, and "Gym" still after "Water plants", passed rather than
  pushed
- **AND** asked about 1 February 2026 it answers with "Journaling" and then "Water plants"

### Requirement: A roster store keeps a roster at a place, across the app being closed and opened again

A roster store SHALL be opened at a place and SHALL hold a roster. Opening one where nothing has
been kept SHALL give a roster holding nothing rather than an error, and that SHALL be the only time
a roster store opens holding nothing.

A commitment taken on through a roster store SHALL be kept at that place before the store reports it
taken on. A store opened at the same place afterwards SHALL hold it, whether or not the first store
was ever closed. Stopping a commitment SHALL be kept the same way, and so SHALL removing one, moving
one, moving a whole group, putting one under a category, changing one commitment for another,
superseding one, and taking one up again. There SHALL be no separate step at which a roster store is
saved. A roster store that cannot keep a change MUST refuse it and MUST NOT hold it, and the roster
a store reports SHALL never be ahead of what is kept at its place.

A roster store SHALL report exactly what the roster reports and MUST NOT turn a roster's own refusal
into an error, whichever refusal it is, as the roster requirements state them. A change that leaves
the roster exactly as it was SHALL keep nothing at the place either, and SHALL still report what the
roster reported.

A roster store SHALL persist exactly what a roster is, and nothing it invented: each commitment with
the parts it is made of, the category it is under, the day a stopped or removed commitment was kept
until, and that a removed one was removed. A number commitment's range SHALL be kept where it has
one and be absent where it has none, both ends as given; a target SHALL be kept as given, decimal
fraction and all, and MUST NOT be rounded, widened or narrowed; a category SHALL be kept exactly as
it was given, blank space at either end and all, and MUST NOT be trimmed, case-folded, deduplicated
against another category or turned into a reference to a list kept elsewhere. The store SHALL keep
the commitments in the order the roster holds them and read them back in that order, MUST NOT impose
an order of its own, MUST NOT sort by name, by a day, by a category or by anything else, and MUST
NOT write its commitments grouped by category to the file. A roster read back SHALL be the same
roster that was kept, for every schedule shape, every kind, any name, any category, any date the
system supports, and each of the three states. The store MUST NOT key anything to the moment it was
entered, MUST NOT record the day a commitment was taken on, and MUST NOT pass a calendar date
through an instant, a time zone or a locale.

Roster stores at different places SHALL be independent of each other, and a roster store SHALL be
independent of any store keeping anything else. A change of commitment SHALL reach a record place as
well, and a roster store SHALL NOT be what reaches it.

#### Scenario: a roster store opened where nothing has been kept holds a roster holding nothing

- **WHEN** a roster store is opened at a place where no roster store has ever been kept
- **THEN** it opens without error
- **AND** its roster is the same roster as one that has been given no commitment

#### Scenario: a commitment taken on through a roster store is held by a second store opened at the same place while the first is still open

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store, and a second roster store is then opened at the
  same place with the first still open and nothing else done to it
- **THEN** the first store reports that the commitment was added
- **AND** the second store's roster is the same roster as one given that commitment once

#### Scenario: a roster store opened again holds its commitments in the order they were taken on

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  three on a schedule listing Monday, Wednesday and Saturday and all three kept from 1 January 2026,
  are taken on through a roster store, and a store is opened afterwards at the same place
- **THEN** the later store's roster reads back those three commitments in that order — "Water
  plants", then "Gym", then "Journaling" — and not in alphabetical order
- **AND** its roster is the same roster as one given the three in that order

#### Scenario: a commitment stopped through a roster store is read back stopped, on the day it was kept until

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; the store is asked to stop keeping "Gym" as of 31 January 2026; and a store
  is opened afterwards at the same place
- **THEN** the store reports that it stopped keeping the commitment
- **AND** the later store's roster, asked about 31 January 2026, answers with all three in the order
  "Water plants", "Gym", "Journaling"
- **AND** asked about 1 February 2026 it answers with "Water plants" and then "Journaling"

#### Scenario: a commitment taken up again through a roster store is read back kept, in the place it was taken on in

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; the store is asked to stop keeping "Gym" as of 31 January 2026; the store is
  then given a commitment alike in every way to "Gym"; and a store is opened afterwards at the same
  place
- **THEN** the later store's roster reads back three commitments in the order "Water plants", "Gym",
  "Journaling", with "Gym" in the place it was taken on in and not at the end
- **AND** its roster is the same roster as one given the three in that order and never asked to stop
  keeping any of them

#### Scenario: a commitment a roster store is already keeping is refused and nothing at its place changes

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store; a second commitment formed with that same name,
  that same schedule and that same day is then offered to it; and a store is opened afterwards at the
  same place
- **THEN** the store reports that the second commitment was not added, and does not report an error
- **AND** its roster still holds exactly one commitment, named "Gym"
- **AND** the later store's roster is the same roster as one given that commitment once

#### Scenario: a stop a roster store refuses is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store and the store is asked to stop keeping it as of
  31 January 2026; the store is then asked to stop keeping it again as of 28 February 2026, and asked
  to stop keeping a commitment named "Run" alike in every other way as of 31 January 2026; and a store
  is opened afterwards at the same place
- **THEN** the store reports of each of those two askings that it did not stop keeping the
  commitment, and reports no error
- **AND** the later store's roster answers with "Gym" on 31 January 2026 and with nothing on
  1 February 2026, the day first given standing
- **AND** its roster is the same roster as one given "Gym" and asked once to stop keeping it as of
  31 January 2026

#### Scenario: commitments on every schedule shape are read back as the same commitments

- **WHEN** one commitment on each schedule shape the system has is taken on through a roster store —
  a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026; a commitment named "Finances" on a schedule on the 25th of the month, kept from that same day;
  a commitment named "Plants" on a schedule of every 3 days starting on 25 August 2026, kept from
  1 September 2026; and a commitment named "Reading" on a weekly quota of 3 times a week, kept from
  1 January 2026 — in that order, and a store is opened afterwards at the same place
- **THEN** the later store's roster is the same roster as one given those same four commitments in
  that same order
- **AND** it reads back all four, in that order

#### Scenario: a commitment name is read back out of a roster store exactly, whatever it contains

- **WHEN** a commitment whose name is "Zürich — „langer“ Lauf 🏃" followed by a line break and the
  word "Sonntags", on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, is
  taken on through a roster store, and a store is opened afterwards at the same place
- **THEN** the later store's roster reads back one commitment whose name is exactly that
- **AND** its roster is the same roster as one given that commitment once

#### Scenario: a roster kept from the first supported date and stopped on the last is read back unchanged

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 1583, and then one named "Run" alike in every other way but kept from 31 December 9999,
  are taken on through a roster store; the store is asked to stop keeping "Gym" as of 31 December
  9999; and a store is opened afterwards at the same place
- **THEN** the later store's roster is the same roster as one given those two commitments in that
  order and asked to stop keeping the first as of 31 December 9999
- **AND** asked about 31 December 9999 it answers with both, "Gym" first and "Run" second

#### Scenario: roster stores at different places hold different rosters

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store at one place, and a roster store is opened at a
  different place where nothing has been kept
- **THEN** the second store's roster is the same roster as one that has been given no commitment
- **AND** a roster store opened afterwards at the first place reads back that one commitment

#### Scenario: a change that cannot be kept is refused and not held

- **WHEN** a roster store is opened at a place where nothing can be written — a path beneath an
  existing ordinary file — and a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is offered to it
- **THEN** taking the commitment on is refused with an error
- **AND** the store's roster is still the same roster as one that has been given no commitment
- **AND** a roster store opened afterwards at the same place holds a roster holding nothing

#### Scenario: a commitment of each kind is read back as the same commitment

- **WHEN** one commitment of each kind the system has is taken on through a roster store — a
  commitment named "Gym" of the tick kind; one named "Weight" of the number kind with no range; one
  named "Mood" of the number kind with a range of 1 to 10; one named "Journal" of the note kind; and
  one named "Protein" of the total kind with a target of 120 — all five on a schedule listing
  Monday, Wednesday and Saturday, all kept from 1 January 2026, in that order, and a store is opened
  afterwards at the same place
- **THEN** the later store's roster is the same roster as one given those same five commitments in
  that same order
- **AND** it reads back all five, in that order, each of the kind it was given

#### Scenario: a range and a target are read back exactly, decimal fractions and all

- **WHEN** a commitment named "Weight" of the number kind with a range of -40.5 to 150.25, and one
  named "Protein" of the total kind with a target of 119.95, both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store, and
  a store is opened afterwards at the same place
- **THEN** the later store's roster reads back a range whose lowest is -40.5 and whose highest is
  150.25, and a target of 119.95
- **AND** its roster is the same roster as one given those two commitments in that order

#### Scenario: a commitment removed through a roster store is read back removed, on the day it was kept until

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; the store is asked to remove "Gym" as of 31 January 2026; and a store is
  opened afterwards at the same place
- **THEN** the store reports that it removed the commitment
- **AND** the later store's roster is the same roster as one given the three in that order and asked
  to remove "Gym" as of 31 January 2026
- **AND** the later store's roster, asked about 31 January 2026, answers with all three in the order
  "Water plants", "Gym", "Journaling", and asked about 1 February 2026 answers with "Water plants"
  and then "Journaling"

#### Scenario: a removal a roster store refuses is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store and the store is asked to remove it as of
  31 January 2026; the store is then asked to remove it again as of 28 February 2026, and asked to
  remove a commitment named "Run" alike in every other way as of 31 January 2026; and a store is
  opened afterwards at the same place
- **THEN** the store reports of each of those two askings that it did not remove the commitment, and
  reports no error
- **AND** the later store's roster answers with "Gym" on 31 January 2026 and with nothing on
  1 February 2026, the day first given standing
- **AND** its roster is the same roster as one given "Gym" and asked once to remove it as of
  31 January 2026

#### Scenario: a commitment taken up again through a roster store after being removed is read back kept

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; the store is asked to remove "Gym" as of 31 January 2026; the store is then
  given a commitment alike in every way to "Gym"; and a store is opened afterwards at the same place
- **THEN** the later store's roster reads back three commitments in the order "Water plants", "Gym",
  "Journaling", with "Gym" in the place it was taken on in and not at the end
- **AND** its roster is the same roster as one given the three in that order and never asked to remove
  any of them

#### Scenario: a removal that cannot be kept is refused and the roster a store reports does not move

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store; what is at that place is then made impossible to
  write; and the store is asked to remove "Gym" as of 31 January 2026
- **THEN** removing the commitment is refused with an error
- **AND** the store's roster is still the same roster as one given that commitment once and asked
  nothing else

#### Scenario: a commitment moved through a roster store is read back in the place it was moved to

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; the store is asked to move "Journaling" to the offset 0; and a store is
  opened afterwards at the same place
- **THEN** the store reports that it moved the commitment
- **AND** the later store's roster reads back three commitments in the order "Journaling", "Water
  plants", "Gym"
- **AND** its roster is the same roster as one given the three in that order and never moved

#### Scenario: a move a roster store refuses is reported and nothing at its place changes

- **WHEN** a commitment named "Water plants" and one named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store; the
  store is asked to move a commitment named "Run" alike in every other way, and never taken on, to
  the offset 0; and a store is opened afterwards at the same place
- **THEN** the store reports that it did not move the commitment, and does not report an error
- **AND** the later store's roster reads back "Water plants" and then "Gym"

#### Scenario: a move that leaves a roster as it was keeps nothing at its place

- **WHEN** a commitment named "Water plants" and one named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store; the
  content at that place is read; and the store is then asked to move "Gym" to the offset 2
- **THEN** the store reports that it moved the commitment
- **AND** the content at that place is byte-for-byte what was read before the move
- **AND** the store's roster reads back "Water plants" and then "Gym"

#### Scenario: a move that cannot be kept is refused and the roster a store reports does not move

- **WHEN** a commitment named "Water plants" and one named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store; what
  is at that place is then made impossible to write; and the store is asked to move "Gym" to the
  offset 0
- **THEN** the move is refused
- **AND** the store's roster still reads back "Water plants" and then "Gym"

#### Scenario: a commitment put under a category through a roster store is read back under it

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Journaling", all on
  a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; the store is asked to put "Creatine" under the category "Supplements"; and
  a store is opened afterwards at the same place
- **THEN** the store reports that it put the commitment under the category
- **AND** the later store's roster reads back two groups, one under "Supplements" holding "Creatine"
  and one under no category holding "Gym" and then "Journaling"
- **AND** its roster is the same roster as one given the three in that order and asked to put
  "Creatine" under "Supplements"

#### Scenario: a category is read back out of a roster store exactly, blank space and all

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store;
  "Creatine" is put under the category " Supplements " and "Gym" under the category "Supplements";
  and a store is opened afterwards at the same place
- **THEN** the later store's roster reads back two groups, the first under " Supplements " with both
  spaces and the second under "Supplements"
- **AND** neither group holds both commitments

#### Scenario: a category change a roster store refuses is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store and the store is asked to stop keeping it as of
  31 January 2026; the store is then asked to put it under the category "Sport"; and a store is
  opened afterwards at the same place
- **THEN** the store reports that it did not put the commitment under the category, and reports no
  error
- **AND** its roster is the same roster as one given "Gym" and asked once to stop keeping it as of
  31 January 2026

#### Scenario: a category change that leaves a roster as it was keeps nothing at its place

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store;
  "Gym" is put under the category "Sport"; the content at that place is read; and the store is then
  asked to put "Gym" under "Sport" again
- **THEN** the store reports that it put the commitment under the category
- **AND** the content at that place is byte-for-byte what was read before that second asking

#### Scenario: a category change that cannot be kept is refused and the roster a store reports does not move

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store; what is at that place is then made impossible
  to write; and the store is asked to put "Gym" under the category "Sport"
- **THEN** putting the commitment under the category is refused with an error
- **AND** the store's roster is still the same roster as one given that commitment once and asked
  nothing else

#### Scenario: a commitment moved under a category through a roster store is read back moved and under it

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken
  on through a roster store; the store is asked to move "Journaling" to the offset 0 under the
  category "Sport"; and a store is opened afterwards at the same place
- **THEN** the store reports that it moved the commitment
- **AND** the later store's roster reads back two groups, one under "Sport" holding "Journaling" and
  one under no category holding "Water plants" and then "Gym"

#### Scenario: a group moved through a roster store is read back in the order it was moved into

- **WHEN** a commitment named "Gym", then one named "Creatine", then one named "Magnesium", all on a
  schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; "Gym" is put under the category "Sport" through it and "Creatine" and
  "Magnesium" under "Supplements"; the store is asked to move the group "Supplements" to the offset
  0, counted over the two groups it is keeping that are under a category; and a store is opened
  afterwards at the same place
- **THEN** the store reports that it moved the group
- **AND** the later store's roster reads back two groups, "Supplements" holding "Creatine" and then
  "Magnesium", and then "Sport" holding "Gym"
- **AND** the later store's roster reads its commitments back flat as "Creatine", then "Magnesium",
  then "Gym"

#### Scenario: a group move a roster store refuses keeps nothing at its place

- **WHEN** a commitment named "Gym" and one named "Creatine", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store;
  "Creatine" is put under the category "Supplements" through it; the content at that place is read;
  and the store is asked to move the group "Sport", which nothing it keeps is under, to the offset 0
- **THEN** the store reports that it did not move the group, without an error
- **AND** the content at that place is byte-for-byte what was read before
- **AND** asking it to move the group "Supplements" to the offset 2, one above the one group it is
  keeping under a category, likewise reports that it did not move the group and leaves that content
  byte-for-byte what it was

#### Scenario: a group move that leaves a group where it is keeps nothing at a roster store's place

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store;
  "Creatine" is put under the category "Supplements" through it; the content at that place is read;
  and the store is asked to move the group "Supplements" to the offset 0
- **THEN** the store reports that it moved the group
- **AND** the content at that place is byte-for-byte what was read before
- **AND** asking it to move the group "Supplements" to the offset 1 instead leaves that true again

#### Scenario: a commitment changed through a roster store is read back changed by a store opened afterwards

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on
  through a roster store; the store is asked to change "Gym" for a commitment named "Gym 🏋️" alike in
  every other way, under the category "Sport"; and a store is opened afterwards at the same place
- **THEN** the first store reports that it changed the commitment
- **AND** the later store's roster reads back three commitments in the order "Water plants", then
  "Gym 🏋️", then "Journaling", with "Gym 🏋️" under "Sport"

#### Scenario: a commitment superseded through a roster store is read back superseded by a store opened afterwards

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store; the store is asked to supersede it with a
  commitment named "Gym" on a schedule listing Tuesday and Thursday, kept from 1 September 2026, as of
  31 August 2026, under no category; and a store is opened afterwards at the same place
- **THEN** the first store reports that it superseded the commitment
- **AND** the later store's roster reads back one commitment it is keeping, on Tuesday and Thursday,
  and none it has stopped
- **AND** that roster answers about 31 August 2026 with both commitments

#### Scenario: a change and a supersession a roster refuses keep nothing at a roster store's place

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing Monday, Wednesday
  and Saturday and both kept from 1 January 2026, are taken on through a roster store; and the store
  is asked to change "Gym" for "Run" under no category, and then to supersede a commitment named
  "Journaling" alike in every other way, which it does not hold, with one named "Journal"
- **THEN** the store reports of each that the roster did not make the change, without an error
- **AND** the content at that place is byte-for-byte what it was before either ask

#### Scenario: a change of a commitment for itself keeps nothing at a roster store's place

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, under the category "Sport", is taken on through a roster store, and the store is
  asked to change that commitment for that same commitment, under the category "Sport"
- **THEN** the store reports that it changed the commitment
- **AND** the content at that place is byte-for-byte what it was before the ask

### Requirement: A roster store reads a roster kept before a commitment carried a kind

A roster store SHALL read a roster kept in any form this app has written before the one it writes
now, rather than refusing it, and SHALL read each as the roster it was. Every commitment in the form
written before a commitment carried a kind SHALL be read as being of the plain kind; every
commitment in the form written before a commitment could be removed SHALL be read as one the roster
has not removed; and every commitment in the form written before a commitment could be put under a
category SHALL be read as one the roster holds under no category.

Reading a roster kept in an earlier form MUST NOT change what is at the place. A store SHALL write
on a change being kept and at no other moment. Opening the app and doing nothing SHALL leave the
content byte-for-byte what it was, in the form it was already in. The next change kept there SHALL
be written in the form this app writes, whole, and SHALL still hold everything the earlier form held
— the order the commitments were taken on, every day one was kept until, and every part of every
commitment.

Each form SHALL be read as the shape that form has, and a roster store SHALL declare its form before
anything else in it is read. What a stored roster says about removal, and what it says about a
category, SHALL each agree with the form it declares, in both directions: a store declaring a form
written before a commitment could be removed, or before one could be put under a category, and yet
saying something about removal or a category SHALL be refused as content that is not a roster store,
and so SHALL one declaring the form this app writes and saying nothing about removal, or nothing
about a category for a commitment. A commitment under no category SHALL be said to be under none
rather than left unsaid.

The forms a roster store reads SHALL be exactly the ones this app has written: the form it writes
now and every form before it. It SHALL NOT weaken the refusal of a form later than the one it
writes, and SHALL refuse a form number it has never written — one below the earliest — as content
that is not a roster store.

#### Scenario: a roster kept before a commitment carried a kind is read with every commitment of the plain kind

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment carried a kind, whose two commitments are named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and "Finances" on a schedule on the 25th of the
  month, kept from that same day
- **THEN** it opens without error
- **AND** its roster is the same roster as one given those two commitments, both of the tick kind,
  in that order

#### Scenario: reading a roster kept in an earlier form changes nothing at its place

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment carried a kind, and nothing is asked of the store
- **THEN** the content at that place is byte-for-byte what it was before

#### Scenario: a commitment of another kind taken on over a roster kept in an earlier form is read back with its kind

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment carried a kind, whose one commitment is named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026; a commitment named "Weight" of the number kind
  with a range of 40 to 150, alike in schedule and kept-from day, is taken on through it; and a
  store is opened afterwards at the same place
- **THEN** the later store's roster reads back both commitments in that order, "Gym" of the tick
  kind and "Weight" of the number kind carrying that range

#### Scenario: a roster store written in a form this app has never written is refused

- **WHEN** a roster store is opened at a place holding a roster store whose form is one below the
  earliest form this app has ever written, holding no commitments
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster kept before a commitment could be removed is read with every commitment not removed

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could be removed, whose two commitments are named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026 and stopped as of 31 January 2026, and
  "Journaling" on that same schedule, kept from that same day and never stopped
- **THEN** it opens without error
- **AND** its roster is the same roster as one given those two commitments in that order and asked to
  stop keeping "Gym" as of 31 January 2026
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring a form written before removal and saying something about removal is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form used before a
  commitment could be removed and yet says, of its one commitment, that it has not been removed
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring the form this app writes and saying nothing about removal is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form this app
  writes and yet says nothing at all about removal for its one commitment
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a commitment removed over a roster kept before removal existed is read back removed

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could be removed, whose one commitment is named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026; that commitment is removed through it as of
  31 January 2026; and a store is opened afterwards at the same place
- **THEN** the later store's roster is the same roster as one given that commitment once and asked to
  remove it as of 31 January 2026
- **AND** the later store's roster reads back no commitments it is keeping

#### Scenario: a roster kept before a commitment could be put under a category is read with every commitment under none

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could be put under a category, whose two commitments are named "Creatine" on a schedule
  listing all seven weekdays, kept from 1 January 2026, and "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from that same day
- **THEN** it opens without error
- **AND** its roster reads back one group, under no category, holding "Creatine" and then "Gym"
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring a form written before categories and saying something about one is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form used before a
  commitment could be put under a category and yet says, of its one commitment, that it is under
  none
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring the form this app writes and saying nothing about a category is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form this app
  writes and yet says nothing at all about a category for its one commitment
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a commitment put under a category over a roster kept before categories existed is read back under it

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could be put under a category, whose two commitments are named "Creatine" and "Gym",
  both on a schedule listing all seven weekdays and both kept from 1 January 2026; "Creatine" is put
  under the category "Supplements" through it; and a store is opened afterwards at the same place
- **THEN** the later store's roster reads back two groups, one under "Supplements" holding
  "Creatine" and one under no category holding "Gym"
- **AND** the later store's roster reads back both commitments of the tick kind and neither as
  removed

### Requirement: A roster store that cannot be read is refused rather than emptied

Opening a roster store at a place holding something this app cannot read as a roster store SHALL be
refused with an error. The store MUST NOT answer with a roster holding nothing in its place, MUST
NOT overwrite, move or delete what is there, and MUST NOT keep the part of it that could be read.

This app cannot read, as a roster store: content that is not a roster store; a roster store written
in a form later than the one this app knows; and a roster store holding something that could not be
a roster — a commitment that could not be formed, a date that names no day, the same commitment held
twice, or a commitment held as removed with no day it was kept until. A commitment of the number
kind carrying only one end of a range SHALL be one that could not be formed, and SHALL be refused
with the rest; the missing end SHALL NOT be invented.

#### Scenario: content that is not a roster store is refused and left as it was

- **WHEN** a roster store is opened at a place holding content that is not a roster store — a run of
  bytes that is not what the store writes
- **THEN** opening is refused with an error
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store written in a later form than this app knows is refused

- **WHEN** a roster store is opened at a place holding a roster store written in a form one later
  than the form this app writes, holding no commitments
- **THEN** opening is refused with an error
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store holding what could not be a roster is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment has a name of three spaces — a name no commitment can be formed with
- **THEN** opening is refused with an error
- **AND** a roster store at a place holding one commitment kept from 30 February 2026, a date that
  names no day, is refused the same way
- **AND** a roster store at a place holding the same commitment twice — alike in name, schedule and
  the day it is kept from — is refused the same way
- **AND** the content at each of the three places is byte-for-byte what it was before

#### Scenario: a roster store holding a commitment with half a range is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment is of the number kind carrying a lowest of 40 and no highest at all
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** a roster store at a place holding one commitment of the number kind carrying a highest of
  150 and no lowest at all is refused the same way
- **AND** the content at each of the two places is byte-for-byte what it was before

#### Scenario: a roster store holding a commitment removed with no day it was kept until is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment is held as removed and carries no day it was kept until
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

### Requirement: A commitments screen lists the commitments its roster keeps, in the order they were taken on

A commitments screen SHALL hold a roster, read at the place it keeps its roster, and SHALL list the
commitments that roster is keeping, in groups, in the order the roster answers with; one the roster
has stopped keeping or removed MUST NOT be in that list. The groups, their order and their contents
SHALL be the roster's answer, read off it and drawn: a group sits where its first commitment sits,
entries under no category come last in a group with no category, and within a group entries are in the
roster's own order. Across its groups the list SHALL be the commitments the roster is keeping and
nothing else, each exactly once: a commitment given a category is drawn in that category's group while
staying where the roster holds it, and taking the category off draws it back among those under none.

An entry SHALL be a commitment's name and the rhythm it runs on in words and nothing else, in the
words the `schedule` capability says for that commitment's schedule, and SHALL NOT say the kind its
days take, the day it is kept from, or its category. Two commitments alike in name and unlike in
rhythm SHALL be two entries; two alike in both SHALL be two entries that say the same thing, and SHALL
NOT be refused. Where two are alike in name, the commitment removed SHALL be the one the removal was
asked about and never the one the typing picks out. A commitments screen SHALL ask its roster no date
and MUST NOT take any commitment on, and a roster holding nothing SHALL be listed as nothing at all,
in no groups at all.

#### Scenario: a commitments screen lists the commitments its roster keeps, in the order they were taken on

- **WHEN** a commitment named "Water plants" on a schedule listing all seven weekdays, then one
  named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one named "Journaling" on
  a schedule listing all seven weekdays, all kept from 1 January 2026, are taken on at a roster
  place; and a commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is three entries, named "Water plants", then "Gym", then "Journaling"
- **AND** it says it is keeping a roster

#### Scenario: a commitments screen does not list a commitment its roster has stopped keeping

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and one
  named "Journaling" on a schedule listing all seven weekdays, both kept from 1 January 2026, are
  taken on at a roster place; "Gym" is stopped there as of Sunday 30 August 2026; and a commitments
  screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is one entry, named "Journaling"
- **AND** "Gym" is not in what it keeps, although Monday 31 August 2026 is the day after the day it
  was kept until and the screen was asked no date at all

#### Scenario: an entry says the rhythm its commitment runs on, whichever of the four shapes it is

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, one named
  "Finances" on a schedule on the 25th of the month, one named "Contact lenses" on a schedule of
  every 14 days starting on 1 January 2026, and one named "Reading" on a schedule of 3 times a
  week, all kept from 1 January 2026, are taken on at a roster place; and a commitments screen is
  opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is four entries saying "Mon, Wed, Sat", "The 25th", "Every 14 days" and
  "3x a week" beside their names, in that order

#### Scenario: two commitments alike in name and not in rhythm are two entries a person cannot tell apart

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday and one named
  "Vitamins" on a schedule listing Tuesday and Thursday, both kept from 1 January 2026, are taken
  on at a roster place; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** what it keeps is two entries, both named "Vitamins"
- **AND** stopping the first of them leaves what it keeps as one entry named "Vitamins"

#### Scenario: two commitments alike in name and not in rhythm are told apart by the rhythm their entries say

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday and one named
  "Vitamins" on a schedule listing Tuesday and Thursday, both kept from 1 January 2026, are taken
  on at a roster place; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** what it keeps is two entries, both named "Vitamins", the first saying "Mon, Wed" and the
  second saying "Tue, Thu"
- **AND** stopping the first of them leaves what it keeps as one entry named "Vitamins", saying
  "Tue, Thu"

#### Scenario: two commitments alike in name and in rhythm are two entries that say the same thing

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday kept from
  1 January 2026, and one named "Vitamins" on a schedule listing Monday and Wednesday kept from
  1 June 2026, are taken on at a roster place; and a commitments screen is opened at that roster
  place as of Monday 31 August 2026
- **THEN** what it keeps is two entries, both named "Vitamins" and both saying "Mon, Wed"
- **AND** neither is refused, because the roster is keeping two different commitments

#### Scenario: a commitments screen opened on a roster that holds nothing lists nothing and takes nothing on

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept
- **THEN** what it keeps is nothing and what it has stopped is nothing
- **AND** it says it is keeping a roster
- **AND** nothing is kept at that roster place

#### Scenario: removing one of two entries alike in name removes the one it was asked about

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday and one named
  "Vitamins" on a schedule listing Tuesday and Thursday, both kept from 1 January 2026, are taken on
  at a roster place; a commitments screen is opened at that roster place as of Monday 31 August 2026;
  it is asked to remove the second of them; "Vitamins" is typed back; and the removal is confirmed
- **THEN** what it keeps is one entry, named "Vitamins", saying "Mon, Wed"
- **AND** what it has stopped is nothing

#### Scenario: a commitments screen draws what it keeps in groups, one per category

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", then
  one named "Finances", all on a schedule listing all seven weekdays and kept from 1 January 2026,
  are taken on at a roster place; "Creatine" and "Magnesium" are put under the category
  "Supplements" there and "Gym" under "Sport"; and a commitments screen is opened at that roster
  place as of Monday 31 August 2026
- **THEN** what it keeps is three groups: "Supplements" holding "Creatine" and then "Magnesium",
  then "Sport" holding "Gym", then a group with no category holding "Finances"
- **AND** what it keeps, read across its groups, is four entries, named "Creatine", "Magnesium",
  "Gym" and then "Finances"

#### Scenario: a group sits where its first commitment sits in the order the person set

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", all on
  a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Gym" is put under the category "Sport" there and "Magnesium" under "Supplements"; and a
  commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is three groups: "Sport" holding "Gym", then "Supplements" holding
  "Magnesium", then a group with no category holding "Creatine"
- **AND** the groups are not in alphabetical order

#### Scenario: a commitments screen whose commitments are none of them under a category draws one group

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; and a commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is one group, with no category, holding "Water plants", then "Gym", then
  "Journaling"

#### Scenario: a commitment given a category is drawn in that group and returns when the category is taken off

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; "Magnesium" is
  changed through it to the category "Supplements", on the name, the rhythm and the day kept from it
  already has; and "Magnesium" is then changed through it to no category, on those same three
- **THEN** immediately after the first change what it keeps is two groups, "Supplements" holding
  "Magnesium" and then a group with no category holding "Creatine" and then "Gym"
- **AND** afterwards what it keeps is one group, with no category, holding "Creatine", then "Gym",
  then "Magnesium", in the order the roster has held them throughout

### Requirement: A commitments screen lists what has been stopped, beside what it keeps

A commitments screen SHALL list, separately from the commitments its roster is keeping, the
commitments that roster has stopped keeping — in the order the roster holds them, each as a name and
the rhythm it runs on in words, exactly as the first list is. A stopped commitment SHALL never be
moved, and what has been stopped SHALL be listed in the order those commitments were taken on. A
commitment the roster has removed SHALL be in neither list, and every other SHALL be in exactly one of
the two and never in both. A roster that has stopped nothing SHALL list nothing as stopped. That list
SHALL NOT be grouped, and SHALL be one flat list whatever categories its commitments are under. A
commitment taken up again from this list SHALL be drawn in the group of the category it was under.

#### Scenario: a commitments screen lists what its roster has stopped keeping, in the order they were taken on

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling",
  all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Journaling" and then "Water plants" are stopped there as of Sunday 30 August 2026;
  and a commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it has stopped is two entries, named "Water plants" and then "Journaling"
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a stopped entry says the rhythm its commitment runs on, as a kept entry does

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday and one named
  "Vitamins" on a schedule of 3 times a week, both kept from 1 January 2026, are taken on at a
  roster place; both are stopped there as of Sunday 30 August 2026; and a commitments screen is
  opened at that roster place as of Monday 31 August 2026
- **THEN** what it has stopped is two entries, both named "Vitamins", the first saying "Mon, Wed"
  and the second saying "3x a week"

#### Scenario: a commitments screen whose roster has stopped nothing lists nothing as stopped

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; and a commitments screen is opened at that roster
  place as of Monday 31 August 2026
- **THEN** what it has stopped is nothing
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitment a commitments screen keeps is not among what it has stopped

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped
  there as of Sunday 30 August 2026; and a commitments screen is opened at that roster place as of
  Monday 31 August 2026
- **THEN** no commitment is in both of its lists
- **AND** what it keeps names only "Journaling" and what it has stopped names only "Gym"

#### Scenario: a commitments screen lists a commitment its roster has removed in neither of its lists

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Gym" is removed there as of Sunday 30 August 2026 and "Journaling" is stopped there as of
  that same day; and a commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is one entry, named "Water plants"
- **AND** what it has stopped is one entry, named "Journaling"
- **AND** "Gym" is in neither of its lists

#### Scenario: what a commitments screen has stopped is in the order its roster holds them

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026;
  "Journaling" is moved to the offset 0; and "Journaling" and then "Water plants" are stopped through
  it
- **THEN** what it has stopped is two entries, named "Journaling" and then "Water plants", and not in
  the order the two were taken on
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: what a commitments screen has stopped is one flat list whatever categories its commitments are under

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place;
  "Creatine" and "Magnesium" are put under the category "Supplements" there and "Gym" under "Sport";
  all three are stopped there as of Sunday 30 August 2026; and a commitments screen is opened at
  that roster place as of Monday 31 August 2026
- **THEN** what it has stopped is three entries, named "Creatine", then "Gym", then "Magnesium"
- **AND** what it keeps is no groups at all

#### Scenario: a stopped commitment taken up again is drawn in the group of the category it was under

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and stopped there as of Sunday 30 August 2026; a commitments screen
  is opened at that roster place as of Monday 31 August 2026; and "Creatine" is taken up again
  through it
- **THEN** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** what it has stopped is nothing

### Requirement: A commitments screen defines a commitment from a name, a rhythm and the day it is kept from

A commitments screen SHALL define a commitment from five things and no others: a name, a rhythm, the
day it is kept from, a category, which may be none, and the kind its days take. A change SHALL take
four of them, every one but the kind, and a commitment the screen already holds SHALL be offered no
kind at all. What is formed SHALL be taken on at the roster place before either list says so, and
SHALL then be last in what the screen keeps, in the group of the category given — unless the roster
holds it stopped or removed, when it SHALL be taken up again in the place it has, under
the category the form carried. Two commitments alike but for their kind SHALL be two here as in a roster. A rhythm SHALL be one of four, all four offered — a weekday set, a day of
the month, an interval of whole days, a weekly quota — and an interval rhythm carries no start date. A
kind SHALL likewise be one of four, all four offered — a tick, a number, a note, a total — and the
tick SHALL be the kind offered for a new commitment. A category of nothing but blank space is no
category and SHALL NOT be refused; every other SHALL be kept exactly as given, blank space at its ends
and all. The day a commitment is kept from SHALL also be an interval rhythm's start date on this
screen, though the two remain distinct in the model and may disagree where something else forms the
commitment. This screen SHALL offer the day it was handed for a new commitment, SHALL
accept any calendar date the system supports, the future included, and MUST NOT judge that date against
it or bound it beyond the calendar.

A number kind's two range ends and a total kind's target SHALL each be taken as text exactly as typed,
and SHALL NOT be judged, formed or blocked before they arrive. Each SHALL be read as a number entry
reads a committed number, and there SHALL be one such reading rather than two: no
locale consulted, blank space at either end disregarded, and what is left may carry a leading minus,
SHALL hold at least one digit, SHALL hold no character that is not a digit but for at most one
separator, a full stop or a comma, and SHALL hold no more than thirty-eight significant digits. What
that reading does not hold as a number SHALL NOT be rounded, truncated or adjusted to fit.
Whether a field is blank SHALL be asked before it is read as a number, blank being decided by the one
test this package asks for the question. A range end holding a zero-width space alone SHALL be
refused as not a number rather than as empty. Both range ends blank SHALL be a commitment of the
number kind carrying no range, while one end filled and the other blank is not no range. A range or a
target left in a field the chosen kind has no room for SHALL be ignored, and SHALL NOT be refused: the
tick and note kinds carry neither whatever those fields hold, the number kind takes its range and
ignores a target, and the total kind takes its target and ignores a range.

#### Scenario: a commitment defined through a commitments screen is kept at the roster place before either list says so

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Gym" on a weekday-set rhythm of Monday, Wednesday
  and Saturday, kept from that same day, is defined through it
- **THEN** a roster store opened afterwards at that place holds one commitment, named "Gym"
- **AND** what the screen keeps is one entry, named "Gym"
- **AND** nothing is refused

#### Scenario: a commitment defined through a commitments screen is last in what it keeps

- **WHEN** a commitment named "Water plants" and one named "Gym", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen
  is opened at that roster place as of Monday 31 August 2026; and a commitment named "Journaling"
  on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it
- **THEN** what it keeps is three entries, named "Water plants", then "Gym", then "Journaling"

#### Scenario: a commitment defined on each of the four rhythms is read back on the schedule that rhythm names

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and four commitments kept from that same day are defined through it — "Gym"
  on a weekday-set rhythm of Monday, Wednesday and Saturday; "Finances" on a day-of-the-month rhythm
  of the 25th; "Contact lenses" on an interval rhythm of 14 days; and "Reading" on a weekly-quota
  rhythm of 3 times a week
- **THEN** a roster store opened afterwards at that place holds four commitments equal, one for one
  and in that order, to commitments formed directly from those names, the schedules those rhythms
  name and Monday 31 August 2026

#### Scenario: a commitment defined on an interval rhythm counts from the day it is kept from

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Contact lenses" on an interval rhythm of 14 days,
  kept from Wednesday 1 July 2026, is defined through it
- **THEN** the commitment a roster store opened afterwards at that place holds is due on Wednesday
  1 July 2026 and on Wednesday 15 July 2026
- **AND** it is not due on Thursday 2 July 2026 and not due on Tuesday 30 June 2026

#### Scenario: a commitments screen offers the day it was handed as the day to keep a commitment from

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept
- **THEN** the day it offers to keep a commitment from is Monday 31 August 2026

#### Scenario: a commitments screen offers the tick kind for a new commitment

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept
- **THEN** the kind it offers for a new commitment is the tick kind
- **AND** a screen opened at a place keeping a commitment of the total kind offers the tick kind too

#### Scenario: a commitments screen accepts a day to keep from that has not arrived and one long past

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "Gym" on a weekday-set rhythm of all seven weekdays,
  kept from 31 December 9999, is defined through it; and a commitment named "Journaling" on that
  same rhythm, kept from 1 January 1583, is defined through it
- **THEN** neither is refused
- **AND** what the screen keeps is two entries, named "Gym" and then "Journaling"

#### Scenario: a commitment defined again after being removed is taken up again in the place it was taken on in

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Gym" is removed there as of Sunday 30 August 2026; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; and a commitment named "Gym" on a weekday-set rhythm of
  all seven weekdays, kept from 1 January 2026, is defined through it
- **THEN** nothing is refused
- **AND** what it keeps is three entries, named "Water plants", then "Gym", then "Journaling"
- **AND** what it has stopped is nothing

#### Scenario: a commitment defined under a category is drawn in that category's group and kept under it

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and a commitment named "Creatine" on a weekday-set rhythm of all
  seven weekdays, kept from that same day, under the category "Supplements", is defined through it
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** a roster store opened afterwards at that place reads back "Creatine" under "Supplements"

#### Scenario: a commitment defined under a category of nothing but blank space is under none and is not refused

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Gym" on a weekday-set rhythm of all seven weekdays,
  kept from that same day, under a category of three spaces, is defined through it
- **THEN** nothing is refused
- **AND** what it keeps is one group, with no category, holding "Gym"
- **AND** a commitment named "Journaling" alike in every other way defined under a category with
  nothing in it at all is likewise not refused and is in that same group

#### Scenario: a commitment defined again after being removed takes the category the form carried

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and removed there as of Sunday 30 August 2026; a commitments screen
  is opened at that roster place as of Monday 31 August 2026; and a commitment named "Creatine" on a
  weekday-set rhythm of all seven weekdays, kept from 1 January 2026, under the category "Morning",
  is defined through it
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Morning" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** a screen alike in every way that defines it under no category instead keeps one group,
  with no category, holding "Creatine" and then "Gym"

#### Scenario: a category is kept exactly as it was typed on the form

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and two commitments on a weekday-set rhythm of all seven weekdays, kept
  from that same day, are defined through it — one named "Creatine" under the category
  " Supplements " and one named "Magnesium" under the category "Supplements"
- **THEN** neither is refused
- **AND** what it keeps is two groups, the first " Supplements " with both spaces holding
  "Creatine", the second "Supplements" holding "Magnesium"

#### Scenario: a commitment of each of the four kinds is defined through a commitments screen and kept with that kind

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and four commitments on a weekday-set rhythm of all seven weekdays, kept
  from that same day, under no category, are defined through it — "Gym" of the tick kind; "Mood" of
  the number kind with a lowest of "1" and a highest of "10"; "Journal" of the note kind; and
  "Protein" of the total kind with a target of "120"
- **THEN** none of the four is refused
- **AND** a roster store opened afterwards at that place holds four commitments equal, one for one
  and in that order, to commitments formed directly from those names, that schedule and that day, of
  the tick kind, the number kind with a range of 1 to 10, the note kind, and the total kind with a
  target of 120

#### Scenario: a commitment of the number kind defined with both range fields blank carries no range

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Weight" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the number kind with a lowest of "" and a
  highest of "", is defined through it
- **THEN** it is not refused
- **AND** a roster store opened afterwards at that place holds one commitment, of the number kind
  carrying no range
- **AND** a screen alike in every way defining "Weight" with a lowest of "   " and a highest of "  "
  keeps a commitment of the number kind carrying no range too

#### Scenario: a range end and a target are read as a number entry reads a number

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and two commitments on a weekday-set rhythm of all seven weekdays, kept from
  that same day, under no category, are defined through it — "Temperature" of the number kind with a
  lowest of " -40,5 " and a highest of "150.00", and "Dose" of the total kind with a target of "0,5"
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place holds "Temperature" of the number kind with
  a range whose lowest is -40.5 and whose highest is 150, and "Dose" of the total kind with a target
  of 0.5

#### Scenario: a range typed on a kind with no room for one is ignored rather than refused

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and two commitments on a weekday-set rhythm of all seven weekdays, kept from
  that same day, under no category, are defined through it — "Journal" of the note kind with a lowest
  of "10" and a highest of "1" left in the range fields, and "Protein" of the total kind with a target
  of "120" and a lowest of "not a number" left in the range fields
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place holds "Journal" of the note kind and
  "Protein" of the total kind with a target of 120
- **AND** a screen alike in every way defining "Gym" of the tick kind with the same range fields
  filled in keeps a commitment of the tick kind

#### Scenario: a target typed on a kind with no room for one is ignored rather than refused

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven weekdays,
  kept from that same day, under no category, of the number kind with a lowest of "1", a highest of
  "10" and a target of "0" left in the target field, is defined through it
- **THEN** it is not refused
- **AND** a roster store opened afterwards at that place holds one commitment, of the number kind
  with a range whose lowest is 1 and whose highest is 10

#### Scenario: a commitment alike in every way but the kind it takes is not one a commitments screen already keeps

- **WHEN** a commitment named "Weight" on a schedule listing all seven weekdays, kept from
  1 January 2026, of the tick kind, is taken on at a roster place; a commitments screen is opened at
  that roster place as of Monday 31 August 2026; and a commitment named "Weight" on a weekday-set
  rhythm of all seven weekdays, kept from 1 January 2026, under no category, of the number kind
  carrying no range, is defined through it
- **THEN** it is not refused
- **AND** what the screen keeps is two entries, both named "Weight"
- **AND** a screen alike in every way whose roster had stopped the tick "Weight" instead keeps one
  entry named "Weight", of the number kind, and has stopped one named "Weight"

### Requirement: A commitments screen refuses a name that says nothing, and a rhythm due on no day

A commitments screen SHALL refuse to define a commitment whose name is empty or made only of blank
space, and SHALL refuse to define one on a weekday set with no days in it. Neither SHALL be kept at
the roster place, and neither SHALL change either of the screen's lists. The two SHALL be told apart
from each other. The first refusal is the one a commitment already makes. The second is the screen's
own: a weekday set with no days in it is a legal schedule, due on no date the system supports, and the
`schedule` capability SHALL be unchanged by this requirement. A commitments screen SHALL refuse
nothing else about a name — there is no length limit, no restricted script and no reserved word.

#### Scenario: a commitments screen refuses a commitment named with nothing but blank space

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it
- **THEN** it is refused as a name that says nothing
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen refuses a weekday set with no days in it

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Gym" on a weekday-set rhythm listing no weekdays
  at all, kept from that same day, is defined through it
- **THEN** it is refused as a rhythm due on no day, told apart from a name that says nothing
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a weekday set with no days in it is still a schedule the rule engine accepts

- **WHEN** a commitment named "Gym" is formed directly from a schedule listing no weekdays at all,
  kept from 1 January 2026
- **THEN** the commitment is formed
- **AND** it is not due on 1 January 2026 and not due on any of the seven days after it

#### Scenario: a commitments screen refuses nothing else about a name

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and three commitments on a weekday-set rhythm of all seven weekdays, kept
  from that same day, are defined through it — one named "x", one named " Gym ", and one named
  "Gym 🏋️"
- **THEN** none of the three is refused
- **AND** what the screen keeps is three entries, named "x", then " Gym ", then "Gym 🏋️", the
  spaces around " Gym " kept exactly as they were given

### Requirement: A commitments screen refuses a rhythm number the calendar will not take

A commitments screen SHALL refuse to define a commitment on a day of the month that is not one of the
thirty-one, on an interval of fewer than one day, or on a weekly quota outside one to seven a week. It
SHALL refuse the number rather than change it: a number outside what a rhythm allows MUST NOT be moved
to the nearest allowed number, and MUST NOT be dropped in silence. Nothing SHALL be kept at the roster
place and neither of the screen's lists SHALL change. The three refusals SHALL be one refusal, told
apart from every other the screen makes but not from each other. The numbers a rhythm allows SHALL be
accepted at both ends: the first and the thirty-first of the month, an interval of one day, one and
seven times a week. The `schedule` capability is unchanged by this requirement.

#### Scenario: a commitments screen refuses a day of the month that is not one of the thirty-one

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Finances" on a day-of-the-month rhythm of the 0th,
  kept from that same day, is defined through it; and then one named "Finances" on a
  day-of-the-month rhythm of the 32nd, kept from that same day
- **THEN** both are refused as a rhythm number the calendar will not take
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen refuses an interval of fewer than one day

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Contact lenses" on an interval rhythm of 0 days,
  kept from that same day, is defined through it; and then one named "Contact lenses" on an
  interval rhythm of -7 days, kept from that same day
- **THEN** both are refused as a rhythm number the calendar will not take
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen refuses a weekly quota outside one to seven

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Reading" on a weekly-quota rhythm of 0 times a
  week, kept from that same day, is defined through it; and then one named "Reading" on a
  weekly-quota rhythm of 8 times a week, kept from that same day
- **THEN** both are refused as a rhythm number the calendar will not take
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a rhythm number a commitments screen refuses is told apart from its other refusals

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and three commitments kept from that same day are defined through it — one
  named "Finances" on a day-of-the-month rhythm of the 32nd, one named "   " on a weekday-set rhythm
  of all seven weekdays, and one named "Gym" on a weekday-set rhythm listing no weekdays at all
- **THEN** the first is refused as a rhythm number the calendar will not take
- **AND** the second is refused as a name that says nothing, and the third as a rhythm due on no
  day, each of the three told apart from the other two

#### Scenario: a commitments screen accepts the number at each end of what a rhythm allows

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and five commitments kept from that same day are defined through it —
  "Rent" on a day-of-the-month rhythm of the 1st, "Finances" on a day-of-the-month rhythm of the
  31st, "Shave" on an interval rhythm of 1 day, "Long run" on a weekly-quota rhythm of 1 time a
  week, and "Steps" on a weekly-quota rhythm of 7 times a week
- **THEN** none of the five is refused
- **AND** what the screen keeps is five entries, named "Rent", then "Finances", then "Shave", then
  "Long run", then "Steps"

### Requirement: A commitments screen tells a commitment it already keeps apart from a roster it could not write

A commitments screen SHALL refuse a commitment its roster is already keeping and a change it could not
keep at a place, and SHALL tell the two apart. Neither SHALL change either of the screen's lists or
what is at the roster place. A change to a commitment SHALL be refused as one the roster already holds
wherever the roster holds it and not only where it is keeping it, as the refusals *A roster refuses a
commitment it already holds* states. A change the screen could not keep SHALL be told the same way
whether it was the record place or the roster place that would not take it. A commitment the roster
has stopped keeping is not a duplicate: defining the same three things again SHALL take that
commitment up again, in the place it has. Changing another commitment into it SHALL be refused as a
duplicate.

#### Scenario: a commitments screen refuses a commitment its roster is already keeping

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and a commitment named "Gym" on a weekday-set rhythm of Monday,
  Wednesday and Saturday, kept from 1 January 2026, is defined through it
- **THEN** it is refused as a commitment already kept
- **AND** what the screen keeps is one entry, named "Gym"
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a commitments screen that could not keep a new commitment says the roster could not be written

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place under a
  directory that cannot be created, and a commitment named "Gym" on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it
- **THEN** it is refused as a roster that could not be written, told apart from a commitment already
  kept
- **AND** what the screen keeps is nothing

#### Scenario: defining a commitment a commitments screen has stopped keeping takes it up again in the place it was taken on in

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling",
  all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Gym" is stopped there as of Sunday 30 August 2026; a commitments screen is opened
  at that roster place as of Monday 31 August 2026; and a commitment named "Gym" on a weekday-set
  rhythm of all seven weekdays, kept from 1 January 2026, is defined through it
- **THEN** it is not refused
- **AND** what the screen keeps is three entries, named "Water plants", then "Gym", then
  "Journaling"
- **AND** what it has stopped is nothing

#### Scenario: a commitment a commitments screen refuses as already kept is not taken on a second time

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and that same commitment is defined through it twice
- **THEN** both are refused as a commitment already kept
- **AND** a roster store opened afterwards at that place holds one commitment

### Requirement: A commitments screen asks you to confirm before it stops keeping a commitment

A commitments screen SHALL be asked to stop keeping a commitment and SHALL change nothing until that
stop is confirmed. Until then it SHALL hold which commitment is awaiting confirmation, and being asked
about a second SHALL replace the first. A commitments screen SHALL have at most one change awaiting
confirmation of any kind, and being asked to stop SHALL leave nothing awaiting removal; moving a
commitment awaits no confirmation and takes neither slot, and a move SHALL leave whatever is awaiting
confirmation exactly as it is. A cancelled stop SHALL leave both lists and the roster place exactly as
they were and leave nothing awaiting confirmation, and confirming SHALL do the same where nothing is
awaiting confirmation.

A confirmed stop SHALL stop keeping the commitment as of the day before the one the screen was handed,
that day being the last it was kept, and SHALL keep that at the roster place before either list says
so; the commitment SHALL then be in what the screen has stopped and not in what it keeps, in the place
it has. Where the day the screen was handed has no day before it, the commitment SHALL be kept until
that day itself, and a commitment defined and stopped on the same day SHALL become one kept on no day
at all. A commitments screen SHALL offer no date to pick. Asked to stop
keeping a commitment its roster is not keeping it SHALL do nothing and SHALL say nothing; a stop it
could not keep at the roster place SHALL be refused as a roster that could not be written, leaving
both lists as they were.

#### Scenario: asking a commitments screen to stop keeping a commitment changes nothing until it is confirmed

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and it is asked to stop keeping "Gym"
- **THEN** it says "Gym" is awaiting confirmation
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a stop a commitments screen has been asked for and then cancelled changes nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to stop keeping "Gym"; and the stop is cancelled
- **THEN** nothing is awaiting confirmation
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a commitments screen asked to stop a second commitment awaits confirmation of that one only

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; it is asked to stop keeping "Gym"; it is
  then asked to stop keeping "Journaling"; and the stop is confirmed
- **THEN** what it has stopped is one entry, named "Journaling"
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitment stopped through a commitments screen is kept until the day the screen was handed

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and it is asked to stop keeping "Gym" and the stop is confirmed
- **THEN** a roster store opened afterwards at that place answers with "Gym" when asked what it had
  not stopped keeping on Sunday 30 August 2026
- **AND** it answers with nothing when asked the same about Monday 31 August 2026, the day the screen
  was handed
- **AND** it answers with nothing when asked the same about Tuesday 1 September 2026

#### Scenario: a commitment stopped through a commitments screen moves from what it keeps to what it has stopped

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling",
  all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; a commitments screen is opened at that roster place as of Monday 31 August 2026;
  and it is asked to stop keeping "Gym" and the stop is confirmed
- **THEN** what it keeps is two entries, named "Water plants" and then "Journaling"
- **AND** what it has stopped is one entry, named "Gym"
- **AND** nothing is awaiting confirmation

#### Scenario: a commitments screen asked to stop keeping a commitment it does not keep does nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; "Gym" is stopped there as of Sunday 30 August 2026;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; and it is asked
  to stop keeping "Gym" and the stop is confirmed
- **THEN** nothing is refused and nothing is awaiting confirmation
- **AND** what it has stopped is one entry, named "Gym", kept until Sunday 30 August 2026 as it was
  before

#### Scenario: a stop a commitments screen could not keep leaves both its lists as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster
  place as of Monday 31 August 2026; what is at that place is then made impossible to write; and
  the screen is asked to stop keeping "Gym" and the stop is confirmed
- **THEN** it is refused as a roster that could not be written
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing

#### Scenario: a commitment defined and stopped on one day through a commitments screen is kept on no day at all

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where nothing
  has been kept; a commitment named "Gym" on a weekday-set rhythm of all seven weekdays, kept from
  that same day, is defined through it; and it is asked to stop keeping "Gym" and the stop is
  confirmed
- **THEN** what it keeps is nothing and what it has stopped is one entry, named "Gym"
- **AND** a roster store opened afterwards at that place answers with nothing when asked what it had
  not stopped keeping on Monday 31 August 2026, and with "Gym" on Sunday 30 August 2026, the day it
  was kept until
- **AND** that "Gym" is not due on Sunday 30 August 2026, the day before the day it is kept from, so
  there is no date on which it is both answered with and due

#### Scenario: a commitments screen handed the first supported date stops a commitment as of that day

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  1583, is taken on at a roster place; a commitments screen is opened at that roster place as of
  1 January 1583; and it is asked to stop keeping "Gym" and the stop is confirmed
- **THEN** nothing is refused and what it has stopped is one entry, named "Gym"
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had
  not stopped keeping on 1 January 1583, and with nothing on 2 January 1583

#### Scenario: asking a commitments screen to stop keeping a commitment leaves nothing awaiting removal

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to remove "Gym"; and it is then asked to stop keeping
  "Gym"
- **THEN** nothing is awaiting removal
- **AND** it says "Gym" is awaiting confirmation
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing

#### Scenario: moving a commitment leaves a stop awaiting confirmation exactly as it was

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, and one named "Journaling" alike in every other way are taken on at a roster place;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; it is asked to
  stop keeping "Gym"; and "Journaling" is then moved to the offset 0
- **THEN** "Gym" is still awaiting confirmation
- **AND** what it keeps is two entries, named "Journaling" and then "Gym"
- **AND** confirming the stop then leaves what it keeps as one entry, named "Journaling"

### Requirement: A commitments screen takes a stopped commitment up again in one tap

A commitments screen SHALL take a commitment it has stopped up again, without asking for confirmation
and without asking for a name, a rhythm or a day. It SHALL keep that at the roster place before either
list says so; the commitment SHALL then be in what the screen keeps, in the place it has, and not in
what it has stopped. A commitments screen asked to take up again a commitment its roster has not
stopped SHALL do nothing and SHALL say nothing. One it could not keep at the roster place SHALL be
refused as a roster that could not be written, leaving both lists as they were.

#### Scenario: a commitment taken up again through a commitments screen moves from what it has stopped to what it keeps

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as
  of Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is taken up again through it
- **THEN** what it keeps is two entries, named "Gym" and then "Journaling"
- **AND** what it has stopped is nothing
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had
  not stopped keeping on Tuesday 1 September 2026

#### Scenario: a commitment taken up again through a commitments screen is in the place it was taken on in

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling",
  all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Water plants" is stopped there as of Sunday 30 August 2026; a commitments screen
  is opened at that roster place as of Monday 31 August 2026; and "Water plants" is taken up again
  through it
- **THEN** what it keeps is three entries, named "Water plants", then "Gym", then "Journaling"

#### Scenario: taking a commitment up again through a commitments screen asks for no confirmation

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; "Gym" is stopped there as of Sunday 30 August 2026;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is
  taken up again through it
- **THEN** nothing is awaiting confirmation at any point
- **AND** what it keeps is one entry, named "Gym", with nothing else asked of the screen

#### Scenario: a commitments screen asked to take up again a commitment it has not stopped does nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is taken up again through it
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

### Requirement: A commitments screen keeps its roster at the place a day screen keeps its, and reads it again when the app is shown

A commitments screen SHALL keep its roster, when it is not told another place, at exactly the place a
day screen keeps its. A commitments screen SHALL be handed the day it is asked on when it is opened,
and SHALL be handed one again when the app is shown. Being shown SHALL read the roster place again,
SHALL form both lists again from what is then there, and SHALL replace the day the screen holds; a
commitment stopped after midnight SHALL be kept until the day before the one it is actually
stopped on, and a screen the app was left on overnight SHALL NOT offer yesterday as the day to keep a
new commitment from. Nothing else SHALL change the day a commitments screen holds: it reads no clock,
and time passing does not move it.

#### Scenario: a commitments screen keeps its roster at the place a day screen keeps its

- **WHEN** a commitments screen is asked where it keeps its roster when it is told no place
- **THEN** it answers with exactly the place a day screen keeps its roster at

#### Scenario: a commitment defined through a commitments screen is held by a day screen opened afterwards at the same place

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "Journaling" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it; and a day screen of no commitments at
  all is then opened at that roster place as of Monday 31 August 2026, at a record place where
  nothing has been kept
- **THEN** the day screen's day view holds one row, named "Journaling"

#### Scenario: a commitments screen shown again reads its roster again

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "Gym" on a schedule listing all seven weekdays, kept
  from 1 January 2026, is taken on at that place by something else; and the screen is shown again
  as of Monday 31 August 2026
- **THEN** what it keeps is one entry, named "Gym"
- **AND** what it kept before it was shown again was nothing

#### Scenario: a commitments screen shown again on a later day stops a commitment as of that later day

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is shown again as of Tuesday 1 September 2026; and it is asked to
  stop keeping "Gym" and the stop is confirmed
- **THEN** a roster store opened afterwards at that place answers with "Gym" when asked what it had
  not stopped keeping on Monday 31 August 2026, the day before the one the screen was last handed
- **AND** it answers with nothing when asked the same about Tuesday 1 September 2026
- **AND** the day the screen offers to keep a commitment from is Tuesday 1 September 2026

### Requirement: A commitments screen that cannot read its roster lists nothing and changes nothing

A commitments screen whose roster place cannot be read SHALL list nothing in either list and SHALL say
that it is not keeping a roster. It MUST NOT take anything on and MUST NOT write over what is at the
place. It SHALL offer no category either. Defining a commitment through such a screen SHALL be refused
as a roster that could not be written. Asking it to stop keeping a commitment, to take one up again,
to remove one, to move one, or to change one SHALL do nothing and say nothing, by the rule that
already governs a commitment neither list holds. Every way the place can refuse to be read SHALL be
answered alike save one, which SHALL be named: a roster written by a later version of DayByDay. The
condition SHALL last only until the app is shown again, since being shown reads the place afresh.

#### Scenario: a commitments screen that cannot read its roster lists nothing and says it is not keeping one

- **WHEN** a run of bytes that is not a roster store is written at a roster place, and a commitments
  screen is opened at that place as of Monday 31 August 2026
- **THEN** what it keeps is nothing and what it has stopped is nothing
- **AND** it says it is not keeping a roster

#### Scenario: a roster written in a later form than this app knows makes a commitments screen that says the roster is from a later version

- **WHEN** a roster store document declaring a version later than this app writes is written at a
  roster place, and a commitments screen is opened at that place as of Monday 31 August 2026
- **THEN** it says the roster was written by a later version of DayByDay, told apart from a roster
  that could not be read
- **AND** what it keeps is nothing and what it has stopped is nothing

#### Scenario: a commitments screen that cannot read its roster refuses a new commitment and leaves what is at the place as it was

- **WHEN** a run of bytes that is not a roster store is written at a roster place; a commitments
  screen is opened at that place as of Monday 31 August 2026; a commitment named "Gym" on a
  weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it; and it
  is then asked to stop keeping a commitment named "Journaling" formed directly, and the stop is
  confirmed
- **THEN** defining "Gym" is refused as a roster that could not be written
- **AND** the stop refuses nothing and leaves nothing awaiting confirmation
- **AND** the content at that place is byte-for-byte what was written there

#### Scenario: a commitments screen that could not read its roster starts keeping one when it is shown again and the roster can be read

- **WHEN** a run of bytes that is not a roster store is written at a roster place; a commitments
  screen is opened at that place as of Monday 31 August 2026; what is at that place is replaced with
  a roster store holding a commitment named "Gym" on a schedule listing all seven weekdays, kept
  from 1 January 2026; and the screen is shown again as of Monday 31 August 2026
- **THEN** it says it is keeping a roster
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitments screen that cannot read its roster does nothing when it is asked to remove a commitment

- **WHEN** a run of bytes that is not a roster store is written at a roster place; a commitments
  screen is opened at that place as of Monday 31 August 2026; and it is asked to remove a commitment
  named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, formed directly
- **THEN** nothing is awaiting removal and nothing is refused
- **AND** the content at that place is byte-for-byte what was written there

#### Scenario: a commitments screen that cannot read its roster does nothing when it is asked to move a commitment

- **WHEN** a run of bytes that is not a roster store is written at a roster place; a commitments
  screen is opened at that place as of Monday 31 August 2026; and it is asked to move a commitment
  named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, formed directly, to
  the offset 0
- **THEN** nothing is refused and it says it is not keeping a roster
- **AND** the content at that place is byte-for-byte what was written there

#### Scenario: a commitments screen that cannot read its roster does nothing when it is asked to put a commitment under a category

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a
  run of bytes that is not what a roster is written as, and a commitment named "Gym" on a schedule
  listing all seven weekdays, kept from 1 January 2026, formed directly, is changed through it to the
  category "Sport", on the name, the rhythm and the day kept from it already has
- **THEN** nothing is refused and the screen holds no refused change
- **AND** it says it is not keeping a roster, and what it keeps is no groups at all
- **AND** the categories it offers are none
- **AND** the content at that roster place is byte-for-byte what it was before the screen was opened

### Requirement: A commitments screen holds the change it refused and why, one at a time

Where a change asked of a commitments screen is refused, the screen SHALL hold which change was asked
for and why it was refused, as well as answering the refusal to the caller. The change held SHALL be
one of the seven a person can ask for — defining a commitment, stopping keeping one, taking a stopped
one up again, removing one, moving one, moving a whole group, changing one — and for the five asked
about a commitment already on one of its lists it SHALL name that commitment: the one it was asked
about, not the one the change would have produced. A refused group move SHALL name the category
instead. The seven are counted here and numbered nowhere else: a requirement that introduces one SHALL
name it, and SHALL NOT identify it by its position among them.

Why it was refused SHALL be the same refusal answered to the caller and no more, and a commitments
screen SHALL hold no words a person reads. It SHALL hold at most one refused change at a time, the
change asked for last. A call asking for no change at all SHALL NOT be a refusal, and each SHALL leave
the screen holding no refused change and leave whatever it holds exactly as it was: a stop asked about a
commitment it does not keep; a stop confirmed with nothing awaiting confirmation; a
take-up-again of one it has not stopped; a removal asked about a commitment on neither list; a
removal confirmed with nothing awaiting removal; a removal confirmed while the name typed back does
not match; a move of one it does not keep; a move into a group it draws none of, or to
an offset that group does not have; a group move of a group it draws none of, those under no category
among them, or to an offset its category groups do not have; a change asked about a commitment on neither list; and a change that names what a commitment
already is. A name typed back that does not match is not a refusal.

#### Scenario: a commitments screen holds a refused definition against defining a commitment

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it
- **THEN** it is refused as a name that says nothing
- **AND** the screen holds that refusal, against defining a commitment

#### Scenario: a commitments screen holds a refused stop against the commitment it was asked to stop

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; what is at that place is then made impossible to write; and the
  screen is asked to stop keeping "Gym" and the stop is confirmed
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against stopping keeping "Gym"

#### Scenario: a commitments screen holds a refused take-up-again against the commitment it was asked to take up again

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped there as of Sunday 30 August 2026; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; what is at that
  place is then made impossible to write; and "Gym" is taken up again through the screen
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against taking "Gym" up again

#### Scenario: a commitments screen refused twice holds only the change it was asked for last

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; what is at that place is then made impossible to write; a commitment
  named "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined
  through the screen; and the screen is then asked to stop keeping "Gym" and the stop is confirmed
- **THEN** the screen holds one refused change, which is a roster that could not be written against
  stopping keeping "Gym"
- **AND** it holds nothing against defining a commitment

#### Scenario: a commitments screen that has been asked for no change holds no refused change

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place, and a commitments screen is opened at that roster
  place as of Monday 31 August 2026
- **THEN** the screen holds no refused change

#### Scenario: a commitments screen holds nothing against a call that changes nothing at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; the screen is asked to stop keeping a commitment named "Journaling"
  on that same schedule and kept-from day, formed directly and never taken on; a stop is then
  confirmed with nothing awaiting confirmation; and "Gym", which has not been stopped, is taken up
  again through the screen
- **THEN** nothing is refused by any of the three
- **AND** the screen holds no refused change

#### Scenario: a commitments screen holds a refused removal against the commitment it was asked to remove

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to remove "Gym" and "Gym" is typed back; what is at that
  place is then made impossible to write; and the removal is confirmed
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against removing "Gym"
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitments screen holds nothing against a removal confirmed on a name that does not match

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; it is asked to remove "Gym";
  "Gymm" is typed back; and the removal is confirmed
- **THEN** the removal refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one entry, named "Gym", and "Gym" is still awaiting removal

#### Scenario: a commitments screen holds a refused move against the commitment it was asked to move

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, and one named "Journaling" alike in every other way are taken on at a roster place;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; what is at that
  place is then made impossible to write; and "Journaling" is moved to the offset 0
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against moving "Journaling"
- **AND** what it keeps is two entries, named "Gym" and then "Journaling"

#### Scenario: a commitments screen holds nothing against a move that asks for no change at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to move a commitment named "Journaling" on that same
  schedule and kept-from day, formed directly and never taken on, to the offset 0; and "Gym" is then
  moved to the offset 2, which a list of one commitment does not have
- **THEN** neither is refused
- **AND** the screen holds no refused change
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitments screen holds a refused category change against the commitment it was asked about

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; what is at that place is then made impossible to write; and "Gym" is
  changed through the screen to the category "Sport", on the name, the rhythm and the day kept from
  it already has
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against changing "Gym"
- **AND** what it keeps is one group, with no category, holding "Gym"

#### Scenario: a commitments screen holds nothing against a category change that asks for no change at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and put under the category "Sport" there; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it
  and refused; and "Gym" is changed through the screen to the category "Sport" it is already under,
  on the name, the rhythm and the day kept from it already has
- **THEN** the category change refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym"

#### Scenario: a commitments screen holds a refused group move against the category it was asked to move

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; what is at that place is then made impossible to write;
  and the group "Sport" is moved to the offset 0
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against moving the group "Sport"
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then "Sport" holding
  "Gym"

#### Scenario: a commitments screen holds nothing against a group move that asks for no change at all

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; the group "Sport", which nothing it keeps is under, is moved to the offset 0; the
  group under no category is moved to the offset 0; and the group "Supplements" is then moved to the
  offset 2, which one group under a category does not have
- **THEN** none of the three is refused
- **AND** the screen holds no refused change
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"

#### Scenario: a commitments screen holds a refused change against the commitment it was asked to change

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; and "Gym" is changed through it to the name "Run", under
  no category
- **THEN** it is refused as a commitment already kept
- **AND** the screen holds that refusal, against changing "Gym"

#### Scenario: a commitments screen holds nothing against a change that asks for no change at all

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is removed there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", under no category
- **THEN** the screen holds no refused change
- **AND** a change of "Journaling" to exactly the name, rhythm, day kept from and category it already
  has leaves the screen holding no refused change either

### Requirement: What a commitments screen holds about a refused change lasts until the app is shown again or a change is kept

A commitments screen SHALL go on holding a refused change until one of exactly two things happens, and
SHALL then hold nothing. Nothing else SHALL end it, and time passing in particular SHALL NOT. The app
being shown again SHALL end it, whether or not the roster can then be read. A change reaching a place
SHALL end it, whichever kind it was and whichever change was refused before it — a commitment defined
and taken on, a stop kept, a take-up-again kept, a removal kept, a move kept, a group move kept, a
change of a commitment kept — and a change that writes nothing but a category SHALL be one of the last
of those rather than a kind of its own. A change of a commitment reaches the record place as well as
the roster place, and SHALL end what is held once it has been kept: one act, one outcome, however many
places it touched.

A call that reaches the place with no change to make SHALL NOT end it: a move dropping a commitment
where it already is, a group move leaving a group where it is drawn, a change naming what a commitment
already is — the category it is already under among the fields it names — and a change asked
about a commitment on neither of the screen's lists. Nor SHALL putting a stop or a removal up for
confirmation, typing a name back, or cancelling either end it: none reaches the roster place.

#### Scenario: what a commitments screen holds about a refused change ends when the app is shown again

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and the app is then shown again as of
  that same day
- **THEN** the screen holds no refused change
- **AND** it says it is keeping a roster

#### Scenario: what a commitments screen holds about a refused change ends when the app is shown again where the roster then cannot be read

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; what is at that place is then made impossible to write; the screen is
  asked to stop keeping "Gym" and the stop is confirmed and refused; and the app is then shown again
  as of that same day
- **THEN** the screen holds no refused change
- **AND** it says it is not keeping a roster

#### Scenario: what a commitments screen holds about a refused change ends when a commitment is defined and kept

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and a commitment named "Journaling" on
  that same rhythm and kept-from day is then defined through it
- **THEN** "Journaling" is not refused
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change ends when a stop is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and the screen is then asked
  to stop keeping "Gym" and the stop is confirmed
- **THEN** the stop is not refused
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change ends when a commitment is taken up again and kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped there as of Sunday 30 August 2026; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through
  it and refused; and "Gym" is then taken up again through the screen
- **THEN** taking "Gym" up again is not refused
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change stands when a call changes nothing at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; "Gym", which has not been
  stopped, is then taken up again through the screen; and a stop is then confirmed with nothing
  awaiting confirmation
- **THEN** the screen still holds a name that says nothing, against defining a commitment

#### Scenario: what a commitments screen holds about a refused change stands when a stop is asked for and cancelled

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and the screen is then asked
  to stop keeping "Gym" and the stop is cancelled
- **THEN** the screen still holds a name that says nothing, against defining a commitment
- **AND** nothing is awaiting confirmation

#### Scenario: what a commitments screen holds about a refused change ends when a removal is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and the screen is then asked
  to remove "Gym", "Gym" is typed back, and the removal is confirmed
- **THEN** the removal is not refused
- **AND** the screen holds no refused change
- **AND** "Gym" is in neither of its lists

#### Scenario: what a commitments screen holds about a refused change stands when a removal is asked for and cancelled

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and the screen is then asked
  to remove "Gym", "Gym" is typed back, and the removal is cancelled
- **THEN** the screen still holds a name that says nothing, against defining a commitment
- **AND** nothing is awaiting removal and nothing has been typed back

#### Scenario: what a commitments screen holds about a refused change ends when a move is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, and one named "Journaling" alike in every other way are taken on at a roster place;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it
  and refused; and "Journaling" is then moved to the offset 0
- **THEN** the move is not refused
- **AND** the screen holds no refused change
- **AND** what it keeps is two entries, named "Journaling" and then "Gym"

#### Scenario: what a commitments screen holds about a refused change stands when a move drops a commitment where it already is

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, and one named "Journaling" alike in every other way are taken on at a roster place;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it
  and refused; and "Journaling" is then moved to the offset 2
- **THEN** the move is not refused
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is two entries, named "Gym" and then "Journaling"

#### Scenario: what a commitments screen holds about a refused change ends when a category change is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and "Gym" is changed through
  it to the category "Sport", on the name, the rhythm and the day kept from it already has
- **THEN** the screen holds no refused change
- **AND** what it keeps is one group, "Sport", holding "Gym"

#### Scenario: what a commitments screen holds about a refused change stands when a category change puts a commitment under the category it is already under

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and put under the category "Sport" there; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through
  it and refused; and "Gym" is changed through it to the category "Sport" it is already under, on the
  name, the rhythm and the day kept from it already has
- **THEN** the second change refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment

#### Scenario: what a commitments screen holds about a refused change ends when a group move is kept

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the group "Sport"
  is then moved to the offset 0
- **THEN** the group move refuses nothing
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change stands when a group move leaves a group where it is

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the group
  "Supplements" is then moved to the offset 0
- **THEN** the group move refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment

#### Scenario: what a commitments screen holds about a refused change ends when a change to a commitment is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and "Gym" is then changed through it to
  the name "Gym 🏋️", under no category
- **THEN** the change is not refused
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change stands when a change names what is already there

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and "Gym" is then changed through it to
  exactly the name, rhythm, day kept from and category it already has
- **THEN** the screen still holds a name that says nothing, against defining a commitment

### Requirement: A roster removes a commitment it holds, and never lets it go

A roster SHALL remove a commitment it holds, on being given that commitment and a calendar date.
Removing SHALL take it out of the commitments the roster reads back and out of those it reads back as
stopped, SHALL hold it as removed, and SHALL report that the roster removed it; the commitment SHALL
stay in the place it has, and everything else SHALL be exactly as it was, in the order it was in.
Where the roster is keeping it, the date given SHALL become the day it was kept until; where the
roster has already stopped keeping it, the day it holds SHALL stand and the date given SHALL NOT be
used. A roster SHALL NOT hold a removed commitment without a kept-until day.

A roster SHALL refuse to remove a commitment in exactly two cases and SHALL report each: one it does
not hold, and one it has already removed, whose kept-until day SHALL stand as first given. Either
SHALL leave the roster exactly as it was. A roster whose every commitment has been removed still holds
every one of them, still answers with each of them on every date up to the day it was kept until, and
SHALL NOT be the same roster as one that has been given no commitment at all. The one way back SHALL
be offering the commitment again, as *A roster refuses a commitment it already holds* says, which
clears both its kept-until day and its being removed. A roster SHALL refuse on no date, accepting any
the system supports — the first, the last, one earlier than the day the commitment is kept from — and
SHALL NOT ask what day it is. Removing SHALL change nothing about the commitment or what has been
recorded against it: it SHALL answer whether it is due on a date exactly as before, and every tick
against it SHALL stand. Removing SHALL leave every other roster untouched, and two rosters differing
only in whether one commitment has been removed SHALL be different rosters.

#### Scenario: removing a commitment a roster keeps says so and records the day it was kept until

- **WHEN** a roster holding one commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to remove it as of 31 January 2026
- **THEN** the roster reports that it removed the commitment
- **AND** the roster reads back no commitments it is keeping and none it has stopped keeping
- **AND** it answers with that commitment on 31 January 2026 and with nothing on 1 February 2026

#### Scenario: removing a commitment a roster has stopped keeping keeps the day it was already kept until

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, stops keeping it as of 31 January 2026, and is then asked to
  remove it as of 28 February 2026
- **THEN** the roster reports that it removed the commitment
- **AND** it answers with that commitment on 31 January 2026 and with nothing on 1 February 2026, the
  day the stop gave standing
- **AND** the roster reads back none it has stopped keeping

#### Scenario: removing one commitment leaves every other where it was

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January
  2026, is asked to remove "Gym" as of 31 January 2026
- **THEN** the roster reads back two commitments it is keeping, in the order "Water plants", then
  "Journaling"
- **AND** asked about 31 January 2026 it answers with all three in the order "Water plants", "Gym",
  "Journaling"

#### Scenario: removing a commitment a roster does not hold says it was not removed and leaves the roster as it was

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to remove a commitment named "Run" alike in every
  other way, as of 31 January 2026
- **THEN** the roster reports that it did not remove the commitment
- **AND** the roster is the same roster as one that was never asked

#### Scenario: removing a commitment already removed says it was not removed and keeps the day first given

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, removes it as of 31 January 2026, and is asked to remove it
  again as of 28 February 2026
- **THEN** the roster reports that it did not remove the commitment
- **AND** the roster is the same roster as one asked only the first time

#### Scenario: a roster that has removed every commitment it holds is not a roster holding nothing

- **WHEN** a roster is given a commitment named "Gym" and one named "Journaling", both on a schedule
  listing Monday, Wednesday and Saturday and both kept from 1 January 2026, and both are removed as
  of 31 January 2026
- **THEN** the roster is not the same roster as one that has been given no commitment
- **AND** it answers with both on 31 January 2026, "Gym" first and "Journaling" second
- **AND** it reads back no commitments it is keeping

#### Scenario: two rosters differing only in whether a commitment has been removed are different rosters

- **WHEN** two rosters each holding a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, are asked — one to stop keeping it as of 31 January 2026,
  the other to remove it as of that same day
- **THEN** the two are different rosters
- **AND** a third roster removing that commitment as of 31 January 2026 is the same roster as the
  second

#### Scenario: removing a commitment on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is copied, and the copy removes that commitment as of
  31 January 2026
- **THEN** the copy reads back no commitments it is keeping
- **AND** the roster it was copied from still reads back that one commitment and is not the same
  roster as the copy

#### Scenario: a commitment removed as of the first supported date and one as of the last are both accepted

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 March 2026, and one named "Run" alike in every other way, is asked to remove
  "Gym" as of 1 January 1583 and "Run" as of 31 December 9999
- **THEN** the roster reports of each that it removed the commitment
- **AND** asked about 1 January 1583 it answers with both, and asked about 2 January 1583 it answers
  with "Run" alone

#### Scenario: a removed commitment answers whether it is due on a date exactly as it did before

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to remove it as of 31 January 2026, and the commitment
  the roster answers with on 31 January 2026 is asked whether it is due
- **THEN** that commitment is due on Monday 5 January 2026 and not due on Tuesday 6 January 2026
- **AND** it reads back the name "Gym" and the day it is kept from, both unchanged

#### Scenario: removing a commitment that has been moved keeps it in the place it was moved to

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, moves "Journaling" to the offset 0 and then removes it as of 31 January 2026
- **THEN** the roster reports that it removed the commitment
- **AND** asked about 31 January 2026 it answers with "Journaling", then "Water plants", then "Gym"
- **AND** it reads back two commitments it is keeping, "Water plants" and then "Gym"

### Requirement: A commitments screen removes a commitment only when its name is typed back

A commitments screen SHALL be asked to remove a commitment on either of its lists and SHALL change
nothing until that removal is confirmed. Until then it SHALL hold which commitment is awaiting
removal; being asked about a second SHALL replace the first and leave nothing typed back against it,
and being asked to remove SHALL leave nothing awaiting a stop. The screen SHALL hold what has been
typed back and SHALL answer whether it matches the commitment awaiting removal: it matches when what
has been typed and the commitment's name are the same once surrounding blank space has been trimmed
from each, and case and blank space inside the name SHALL both matter. Nothing SHALL be awaiting
removal and nothing typed back when the screen is opened, after a removal is confirmed or cancelled,
or after the app is shown again.

A confirmed removal SHALL do nothing at all unless the name matches: it SHALL leave the commitment
awaiting removal, leave what has been typed, leave both lists and the roster place as they are, and
neither refuse nor say anything, exactly as confirming does with nothing awaiting removal. One whose
name matches SHALL remove the commitment at the roster place before either list says so, and it SHALL
then be in neither list; where the screen was keeping it, it SHALL be removed as of the day before the
one the screen was handed, or as of that day itself where that day has none before it, and where the
screen had stopped keeping it the day it was already kept until SHALL stand. A cancelled removal SHALL
leave both lists and the roster place exactly as they were. A commitments screen asked to remove a
commitment on neither of its lists SHALL do nothing and SHALL say nothing. A removal it could not keep
at the roster place SHALL be refused as a roster that could not be written, leaving both lists as they
were.

#### Scenario: asking a commitments screen to remove a commitment changes nothing until it is confirmed

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and it is asked to remove "Gym"
- **THEN** it says "Gym" is awaiting removal, and nothing has been typed back
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a commitments screen says a name typed back matches only when it is the commitment's name

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to remove "Gym"; and "G", then "Gy", then "Gym", then
  "Gymm" are typed back in turn
- **THEN** the name typed back does not match after "G", does not match after "Gy", matches after
  "Gym", and does not match after "Gymm"

#### Scenario: a name typed back with blank space at either end matches, and one differing in case does not

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and it is asked to remove "Gym"
- **THEN** "  Gym  " typed back matches
- **AND** "gym" typed back does not match, and "GYM" typed back does not match

#### Scenario: a name typed back differing in blank space inside the name does not match

- **WHEN** a commitment named "Water plants" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and it is asked to remove "Water plants"
- **THEN** "Water  plants", with two spaces between the words, typed back does not match
- **AND** "Waterplants" typed back does not match
- **AND** "Water plants" typed back matches

#### Scenario: a commitment whose name ends in a space is removed by typing the name without it

- **WHEN** a commitment named "Gym " — the word followed by a space — on a schedule listing all seven
  weekdays, kept from 1 January 2026, is taken on at a roster place; a commitments screen is opened
  at that roster place as of Monday 31 August 2026; it is asked to remove that commitment; "Gym" is
  typed back; and the removal is confirmed
- **THEN** the name typed back matched
- **AND** what it keeps is nothing and what it has stopped is nothing

#### Scenario: a removal confirmed on a name that does not match changes nothing and refuses nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to remove "Gym"; "gym" is typed back; and the removal is
  confirmed
- **THEN** nothing is refused
- **AND** "Gym" is still awaiting removal and "gym" is still what has been typed back
- **AND** what it keeps is one entry, named "Gym"
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a removal confirmed with nothing awaiting removal changes nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and a removal is confirmed with nothing awaiting removal
- **THEN** nothing is refused and nothing is awaiting removal
- **AND** what it keeps is one entry, named "Gym"
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a kept commitment removed through a commitments screen is kept until the day before the one the screen was handed

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to remove "Gym"; "Gym" is typed back; and the removal is
  confirmed
- **THEN** a roster store opened afterwards at that place answers with "Gym" when asked what it had
  not stopped keeping on Sunday 30 August 2026
- **AND** it answers with nothing when asked the same about Monday 31 August 2026 and about Tuesday
  1 September 2026

#### Scenario: a stopped commitment removed through a commitments screen keeps the day it was already kept until

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped there as of Sunday 23 August 2026; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; it is asked to
  remove "Gym"; "Gym" is typed back; and the removal is confirmed
- **THEN** a roster store opened afterwards at that place answers with "Gym" when asked what it had
  not stopped keeping on Sunday 23 August 2026
- **AND** it answers with nothing when asked the same about Monday 24 August 2026
- **AND** what the screen has stopped is nothing

#### Scenario: a commitment removed through a commitments screen is in neither of its lists

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026; it is
  asked to remove "Gym"; "Gym" is typed back; and the removal is confirmed
- **THEN** what it keeps is two entries, named "Water plants" and then "Journaling"
- **AND** what it has stopped is nothing
- **AND** nothing is awaiting removal and nothing has been typed back

#### Scenario: a removal a commitments screen has been asked for and then cancelled changes nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to remove "Gym"; "Gym" is typed back; and the removal is
  cancelled
- **THEN** nothing is awaiting removal and nothing has been typed back
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a commitments screen asked to remove a second commitment awaits removal of that one only

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; it is asked to remove "Gym"; "Gym" is
  typed back; and it is then asked to remove "Journaling"
- **THEN** "Journaling" is awaiting removal and nothing has been typed back
- **AND** confirming the removal changes nothing, because nothing has been typed back to match
- **AND** what it keeps is two entries, named "Gym" and then "Journaling"

#### Scenario: a commitments screen asked to remove a commitment on neither of its lists does nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and it is asked to remove a commitment named "Journaling" on that
  same schedule and kept-from day, formed directly and never taken on
- **THEN** nothing is awaiting removal and nothing is refused
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing

#### Scenario: a removal a commitments screen could not keep leaves both its lists as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to remove "Gym" and "Gym" is typed back; what is at that
  place is then made impossible to write; and the removal is confirmed
- **THEN** it is refused as a roster that could not be written
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing

#### Scenario: asking a commitments screen to remove a commitment leaves no stop awaiting confirmation

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to stop keeping "Gym"; and it is then asked to remove
  "Gym"
- **THEN** nothing is awaiting confirmation of a stop
- **AND** "Gym" is awaiting removal
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing

#### Scenario: a commitments screen shown again leaves nothing awaiting removal and nothing typed back

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to remove "Gym" and "Gym" is typed back; and the app is
  shown again as of Tuesday 1 September 2026
- **THEN** nothing is awaiting removal and nothing has been typed back
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitments screen handed the first supported date removes a kept commitment as of that day

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  1583, is taken on at a roster place; a commitments screen is opened at that roster place as of
  1 January 1583; it is asked to remove "Gym"; "Gym" is typed back; and the removal is confirmed
- **THEN** nothing is refused and "Gym" is in neither of its lists
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had
  not stopped keeping on 1 January 1583, and with nothing on 2 January 1583

### Requirement: A roster moves a commitment among the ones it keeps

A roster SHALL move a commitment it is keeping, on being given that commitment, an **offset** — a
place counted over the commitments it is keeping as they stand before the move, from 0, before the
first of them, to the number it is keeping — and the category to put it under, which may be none and
takes off the one it was under. It SHALL report that it moved the commitment.

Unless the offset is the one the commitment is at or the one just after it, the commitment SHALL be
taken out of the sequence and put back immediately before the commitment that stood at that offset,
or after the last of them where the offset is the number it is keeping, and a stopped or removed
commitment lying between where it was and where it goes SHALL be passed rather than pushed. On those
two offsets nothing in the sequence SHALL move and such a commitment lying between the moved one and
the one that follows SHALL NOT be passed, but the commitment SHALL still be put under the category
it was moved under and the move SHALL be reported. Every other commitment SHALL afterwards be in the
order it was in, kept, stopped and removed alike. A commitment the roster has stopped keeping SHALL
hold its place, so taking it up again SHALL return it exactly there.

The roster SHALL refuse to move a commitment it is not keeping — one it does not hold, one it has
stopped keeping, one it has removed — and an offset below 0 or above the number it is keeping, SHALL
report each, and SHALL be left exactly as it was, its categories included. A move SHALL NOT ask what
day it is, SHALL NOT be recorded, and SHALL change no day a commitment was kept until or is kept
from, nothing about the commitment and nothing recorded against it. It SHALL leave every other
roster untouched.

#### Scenario: moving a commitment to the end puts it after every commitment the roster is keeping

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, is asked to move "Water plants" to the offset 3, counted over the three commitments
  it is keeping
- **THEN** the roster reports that it moved the commitment
- **AND** it reads back three commitments in the order "Gym", "Journaling", "Water plants"

#### Scenario: moving a commitment to the front puts it before every commitment the roster is keeping

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, is asked to move "Journaling" to the offset 0
- **THEN** the roster reports that it moved the commitment
- **AND** it reads back three commitments in the order "Journaling", "Water plants", "Gym"

#### Scenario: an offset is counted over the commitments the roster is keeping as they stand before the move

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, is asked to move "Water plants" to the offset 2
- **THEN** it reads back three commitments in the order "Gym", "Water plants", "Journaling", the
  offset naming "Journaling" — the commitment that stood at it before the move — as the one the moved
  commitment comes to stand before
- **AND** a roster alike in every way asked to move "Water plants" to the offset 3 instead reads back
  "Gym", "Journaling", "Water plants"

#### Scenario: a stopped commitment between the two places is passed rather than pushed

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", then one named "Reading", all on a schedule listing Monday, Wednesday and Saturday
  and all kept from 1 January 2026, stops keeping "Gym" as of 31 January 2026, and is then asked to
  move "Water plants" to the offset 2, counted over the three commitments it is then keeping
- **THEN** the roster reports that it moved the commitment
- **AND** it reads back three commitments it is keeping, in the order "Journaling", "Water plants",
  "Reading"
- **AND** asked about 31 January 2026 it answers with "Gym", then "Journaling", then "Water plants",
  then "Reading" — "Gym" first, where it has been since it was taken on
- **AND** a roster that had removed "Gym" as of that same day instead answers with those four in that
  same order

#### Scenario: an offset of nothing at all puts a commitment before the first one kept and not before a stopped one

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, stops keeping "Water plants" as of 31 January 2026, and is then asked to move
  "Journaling" to the offset 0
- **THEN** the roster reports that it moved the commitment
- **AND** it reads back two commitments it is keeping, "Journaling" and then "Gym"
- **AND** asked about 31 January 2026 it answers with "Water plants", then "Journaling", then "Gym",
  the stopped commitment still first

#### Scenario: two offsets leave a commitment where it already is, and both are accepted

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, is asked to move "Gym" to the offset 1, and a roster alike in every way is asked to
  move "Gym" to the offset 2
- **THEN** each reports that it moved the commitment
- **AND** each reads back "Water plants", "Gym", "Journaling"
- **AND** each is the same roster as one that was never asked

#### Scenario: the offset just after a commitment's own passes nothing, with a stopped or removed commitment lying between

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", then one named "Reading", all on a schedule listing Monday, Wednesday and Saturday
  and all kept from 1 January 2026, stops keeping "Journaling" as of 31 January 2026, and is then
  asked to move "Gym" to the offset 2 — the offset just after "Gym"'s own among the three it is then
  keeping, which names "Reading" and not "Gym", with the stopped "Journaling" lying between the two
- **THEN** the roster reports that it moved the commitment
- **AND** the roster is the same roster as one that was never asked, "Journaling" still standing
  between "Gym" and "Reading" rather than passed
- **AND** a roster that had removed "Journaling" as of that same day instead reports that it moved
  the commitment and is likewise the same roster as one that was never asked

#### Scenario: moving a commitment the roster is not keeping says it was not moved and leaves the roster as it was

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, stops keeping "Gym" as of 31 January 2026 and removes "Journaling" as of that same
  day, and is then asked to move "Gym" to the offset 0
- **THEN** the roster reports that it did not move the commitment
- **AND** the roster is the same roster as one that was never asked
- **AND** asking it to move "Journaling" to the offset 0, and asking it to move a commitment named
  "Run" alike in every other way to "Water plants" and never given to it, each report that it did not
  move the commitment and leave the roster the same

#### Scenario: an offset below zero and one above the number of commitments kept are both refused

- **WHEN** a roster given a commitment named "Water plants" and then one named "Gym", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026, is asked to move
  "Gym" to the offset -1
- **THEN** the roster reports that it did not move the commitment
- **AND** the roster is the same roster as one that was never asked
- **AND** asking it to move "Gym" to the offset 3, one above the two commitments it is keeping,
  reports that it did not move the commitment and leaves the roster the same

#### Scenario: moving a commitment moves no day and changes no commitment

- **WHEN** a roster given a commitment named "Water plants" kept from 1 January 2026, then one named
  "Gym" kept from 1 March 2026, then one named "Journaling" kept from 1 June 2026, all on a schedule
  listing Monday, Wednesday and Saturday, stops keeping "Water plants" as of 31 January 2026, and is
  then asked to move "Journaling" to the offset 0
- **THEN** the roster answers with "Water plants" on 31 January 2026 and without it on
  1 February 2026, the day it was kept until unmoved
- **AND** each of the three reads back the day it is kept from unchanged
- **AND** "Gym" is due on Monday 2 March 2026 and not due on Tuesday 3 March 2026, exactly as it was
  before

#### Scenario: moving a commitment on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Water plants" and then one named "Gym", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026, is copied, and
  the copy moves "Gym" to the offset 0
- **THEN** the copy reads back "Gym" and then "Water plants"
- **AND** the roster it was copied from still reads back "Water plants" and then "Gym", and is not
  the same roster as the copy

#### Scenario: a roster keeping one commitment accepts both the offsets it has

- **WHEN** a roster holding one commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to move it to the offset 0, and a roster alike in
  every way is asked to move it to the offset 1
- **THEN** each reports that it moved the commitment
- **AND** each is the same roster as one that was never asked
- **AND** a roster alike in every way asked to move it to the offset 2 reports that it did not move
  the commitment

#### Scenario: a move puts a commitment under the category it was moved under

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, is asked to move "Journaling" to the offset 0 under the category "Sport"
- **THEN** the roster reports that it moved the commitment
- **AND** it reads back two groups, one under "Sport" holding "Journaling" and one under no category
  holding "Water plants" and then "Gym"

#### Scenario: a move under no category takes a commitment's category off

- **WHEN** a roster given a commitment named "Gym" and then one named "Journaling", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026, puts "Gym"
  under the category "Sport", and is then asked to move "Gym" to the offset 2 under no category
- **THEN** the roster reports that it moved the commitment
- **AND** it reads back one group, under no category, holding "Journaling" and then "Gym"

#### Scenario: a move to the place a commitment already has still puts it under the category it was moved under

- **WHEN** a roster given a commitment named "Gym" and then one named "Journaling", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026, is asked to
  move "Gym" to the offset 0 under the category "Sport"
- **THEN** the roster reports that it moved the commitment
- **AND** it reads back two groups, one under "Sport" holding "Gym" and one under no category
  holding "Journaling"
- **AND** it is not the same roster as one that was never asked

#### Scenario: a refused move puts a commitment under no category at all

- **WHEN** a roster given a commitment named "Gym" and then one named "Journaling", both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026, stops keeping
  "Gym" as of 31 January 2026, and is then asked to move "Gym" to the offset 0 under the category
  "Sport"
- **THEN** the roster reports that it did not move the commitment
- **AND** the roster is the same roster as one that was never asked
- **AND** asking it to move "Journaling" to the offset -1 under "Sport" likewise reports that it did
  not move the commitment and leaves the roster the same

### Requirement: A commitments screen moves a commitment among the ones it keeps

A commitments screen SHALL move a commitment on the list of what it keeps, on being given that
commitment, the group it was dropped in and an offset counted over the entries drawn in that group
as they stand before the move, from 0, before the first of them, to the number drawn in that group,
and SHALL keep the move at the roster place before the list says so. It SHALL ask for no
confirmation and for nothing else. The commitment SHALL be put under the category of the group it
was dropped in, and a row dropped among the entries under no category has its category taken off. It
SHALL come to stand immediately before the entry drawn at that offset in that group, or after the
last entry drawn in it where the offset is the number drawn in it. The end of a group is a place a
drop can reach, and reaching it SHALL file the commitment in that group and not in the one drawn
after it. A group whose first commitment has been moved away SHALL afterwards be drawn where its
next commitment sits.

On the offset an entry is drawn at within its own group and the one just after it, the screen SHALL
change neither the order nor the category, SHALL refuse nothing and SHALL say nothing; those two
carve out nothing anywhere else, and a commitment dropped in any group but the one it is already in
SHALL be filed there at every offset that group has. A screen asked to move a commitment neither
list holds, one it has stopped, one into a group it draws none of — a category no commitment it
keeps is under, no category at all included — or one to an offset that group does not have SHALL do
nothing and SHALL say nothing. A move it could not keep at the roster place SHALL be refused as a
roster that could not be written, SHALL name the commitment it was asked to move, and SHALL leave
both lists as they were and the commitment under the category it was already under.

#### Scenario: a commitment moved through a commitments screen is where it was dropped, and is kept there

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026; and
  "Journaling" is moved to the offset 0
- **THEN** nothing is refused
- **AND** what it keeps is three entries, named "Journaling", "Water plants" and then "Gym"
- **AND** a commitments screen opened afterwards at that place as of that same day keeps those three
  in that same order

#### Scenario: an offset a commitments screen is given is counted over what it keeps before the move

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026; and "Water
  plants" is moved to the offset 2
- **THEN** what it keeps is three entries, named "Gym", "Water plants" and then "Journaling"
- **AND** a screen alike in every way that moves "Water plants" to the offset 3 instead keeps "Gym",
  "Journaling" and then "Water plants"

#### Scenario: a commitments screen asked to move a commitment it has stopped does nothing and says nothing

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and it is asked to move "Gym" to the offset 0
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is one entry, named "Journaling", and what it has stopped is one entry, named
  "Gym"

#### Scenario: a commitments screen asked to move a commitment on neither of its lists does nothing and says nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and it is asked to move a commitment named "Journaling" on that same
  schedule and kept-from day, formed directly and never taken on, to the offset 0
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitments screen given an offset the list it keeps does not have does nothing and says nothing

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; and "Gym" is moved to the offset 3, which
  a list of two does not have
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is two entries, named "Gym" and then "Journaling"
- **AND** moving "Gym" to the offset -1 refuses nothing and leaves what it keeps the same again

#### Scenario: a move a commitments screen could not keep leaves both its lists as they were

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; what is at that place is then made
  impossible to write; and "Journaling" is moved to the offset 0
- **THEN** it is refused as a roster that could not be written
- **AND** what it keeps is two entries, named "Gym" and then "Journaling", and what it has stopped is
  nothing

#### Scenario: a move that drops a commitment where it already is changes nothing and refuses nothing

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; the content at that place is read; and
  "Journaling" is moved to the offset 2
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is two entries, named "Gym" and then "Journaling"
- **AND** the content at that place is byte-for-byte what was read before the move

#### Scenario: a commitments screen shown again lists what it keeps in the order it was moved into

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026;
  "Journaling" is moved to the offset 0; and the screen is shown again as of Tuesday
  1 September 2026
- **THEN** what it keeps is three entries, named "Journaling", "Water plants" and then "Gym"

#### Scenario: a commitment moved and then stopped through a commitments screen keeps the place it was moved to

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026;
  "Journaling" is moved to the offset 0; and the screen is then asked to stop keeping "Journaling"
  and the stop is confirmed
- **THEN** what it keeps is two entries, named "Water plants" and then "Gym"
- **AND** what it has stopped is one entry, named "Journaling"
- **AND** a roster store opened afterwards at that place answers with "Journaling", then "Water
  plants", then "Gym" when asked what it had not stopped keeping on Sunday 30 August 2026

#### Scenario: a commitment dropped among another group's entries is put under that group's category

- **WHEN** a commitment named "Creatine", then one named "Magnesium", then one named "Gym", all on
  a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Creatine" and "Magnesium" are put under the category "Supplements" there; a commitments
  screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is moved to the
  offset 1 in the group "Supplements"
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Supplements", holding "Creatine", then "Gym", then
  "Magnesium"

#### Scenario: a commitment dropped among the entries under no category has its category taken off

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Journaling", all on
  a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Creatine" is put under the category "Supplements" there; a commitments screen is opened at
  that roster place as of Monday 31 August 2026; and "Creatine" is moved to the offset 2 in the
  group under no category, which is the number of entries drawn in it
- **THEN** nothing is refused
- **AND** what it keeps is one group, with no category, holding "Gym", then "Journaling", then
  "Creatine"

#### Scenario: an offset a commitments screen is given is counted over the group a drop landed in and not over the roster's own order

- **WHEN** a commitment named "Gym", then one named "Creatine", then one named "Magnesium", all on
  a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Creatine" and "Magnesium" are put under the category "Supplements" there; a commitments
  screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is moved to the
  offset 1 in the group "Supplements"
- **THEN** what it keeps is one group, "Supplements", holding "Creatine", then "Gym", then
  "Magnesium" — the offset naming the entry drawn at it in that group, "Magnesium", and not the
  commitment the roster holds at it, which is "Creatine"
- **AND** a roster store opened afterwards at that place reads back "Creatine", then "Gym", then
  "Magnesium", all three under "Supplements"
- **AND** a screen alike in every way asked to move "Gym" to the offset 3 in the group
  "Supplements", which a group of two entries does not have though the list it draws does, refuses
  nothing and leaves what it keeps exactly as it was

#### Scenario: a drop where a commitment is already drawn changes neither its place nor its category

- **WHEN** a commitment named "Creatine", then one named "Gym", all on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; the content at that place is read; and "Creatine" is moved to the offset 1 in the
  group "Supplements"
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** moving "Creatine" to the offset 0 in that same group leaves both of those true again
- **AND** the content at that place is byte-for-byte what was read before either move

#### Scenario: a commitment dropped after the last entry of a group is drawn at the end of that group

- **WHEN** a commitment named "Creatine", then one named "Magnesium", then one named "Gym", then one
  named "Journaling", all on a schedule listing all seven weekdays and kept from 1 January 2026, are
  taken on at a roster place; "Creatine" and "Magnesium" are put under the category "Supplements"
  there and "Gym" and "Journaling" under "Sport"; a commitments screen is opened at that roster
  place as of Monday 31 August 2026; and "Journaling" is moved to the offset 2 in the group
  "Supplements", which is the number of entries drawn in it
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Supplements" holding "Creatine", then "Magnesium", then
  "Journaling", and "Sport" holding "Gym"
- **AND** "Journaling" is under "Supplements" and not under "Sport", whose first entry is drawn
  immediately after it

#### Scenario: a commitments screen asked to move a commitment into a group it draws none of does nothing and says nothing

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; both are put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; the content at that place is read; and "Gym" is moved to the offset 0 in the group
  under no category, which nothing it keeps is under
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is one group, "Supplements", holding "Creatine" and then "Gym"
- **AND** moving "Gym" to the offset 0 in the group "Sport", which nothing it keeps is under either,
  leaves that true again
- **AND** the content at that place is byte-for-byte what was read before either move

#### Scenario: moving a group's only entry into another group leaves one heading fewer

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Journaling", all on
  a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; "Creatine" is put under the category "Supplements" there and "Gym" under "Sport"; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is moved
  to the offset 0 in the group "Supplements"
- **THEN** what it keeps is two groups, "Supplements" holding "Gym" and then "Creatine", and then a
  group with no category holding "Journaling"
- **AND** no group is drawn under "Sport"

### Requirement: A roster puts a commitment under a category

A roster SHALL put a commitment it is keeping under a **category**, on being given the two, and
SHALL report that it put the commitment under it. A category of nothing but blank space, and one
with nothing in it, both mean the commitment is under no category, and neither SHALL be refused.
Every other category SHALL be kept exactly as it was given — no length limit, no restricted script,
no reserved word, no trimming and no folding of case — so a category with blank space at its ends is
that category and not the one without. Two commitments SHALL be under one category when the words
are the same word, and under two when they are not.

The categories that exist SHALL be exactly the words the roster's commitments are under. A roster
MUST NOT keep a second collection of category words, MUST NOT hold a count of what is under each,
and MUST NOT refuse a category because no commitment is under it yet. Putting a commitment under a
category SHALL change nothing about the commitment itself, so every record already made against it
stands and it goes on answering whether it is due on a date as before. A commitment the roster has
stopped keeping or removed SHALL go on being under the category it was under, and SHALL be read back
under it wherever such a commitment is read back.

The roster SHALL refuse to change the category on a commitment it is not keeping — one it does not
hold, one it has stopped keeping, one it has removed — SHALL report that, and SHALL be left exactly
as it was. Putting a commitment under the category it is already under SHALL be accepted and
reported, and SHALL leave the roster the same roster it was. It SHALL NOT ask what day it is, SHALL
NOT record when one happened, and SHALL NOT change any day a commitment was kept until or the order
it holds its commitments in. It SHALL leave every other roster untouched, and two rosters alike but
for the category one commitment is under SHALL be different rosters.

#### Scenario: a commitment a roster is keeping is put under the category it was given

- **WHEN** a roster given a commitment named "Creatine" and then one named "Gym", both on a schedule
  listing all seven weekdays and both kept from 1 January 2026, is asked to put "Creatine" under the
  category "Supplements"
- **THEN** the roster reports that it put the commitment under the category
- **AND** it reads back two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"

#### Scenario: a category of nothing but blank space puts a commitment under none, and is not refused

- **WHEN** a roster given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, puts it under the category "Supplements", and is then asked to put it
  under a category of three spaces
- **THEN** the roster reports that it put the commitment under the category
- **AND** it reads back one group, with no category, holding "Creatine"
- **AND** a roster alike in every way asked instead for a category with nothing in it at all reads
  back that same one group

#### Scenario: a category is held exactly as it was given, blank space at its ends and all

- **WHEN** a roster given a commitment named "Creatine" and then one named "Magnesium", both on a
  schedule listing all seven weekdays and both kept from 1 January 2026, puts "Creatine" under the
  category " Supplements " and "Magnesium" under the category "Supplements"
- **THEN** it reads back two groups, the first " Supplements " with both spaces holding "Creatine"
  and the second "Supplements" holding "Magnesium"
- **AND** a roster alike in every way that puts "Magnesium" under " Supplements " too reads back one
  group holding both

#### Scenario: putting a commitment under the category it is already under is accepted and changes nothing

- **WHEN** a roster given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, puts it under the category "Supplements", and is then asked to put it
  under "Supplements" again
- **THEN** the roster reports that it put the commitment under the category
- **AND** it is the same roster as one asked only once

#### Scenario: putting a commitment the roster is not keeping under a category is refused

- **WHEN** a roster given a commitment named "Creatine", then one named "Gym", then one named
  "Journaling", all on a schedule listing all seven weekdays and all kept from 1 January 2026, stops
  keeping "Gym" as of 31 January 2026 and removes "Journaling" as of that same day, and is then
  asked to put "Gym" under the category "Sport"
- **THEN** the roster reports that it did not put the commitment under the category
- **AND** the roster is the same roster as one that was never asked
- **AND** asking it to put "Journaling" under "Sport", and asking it to put a commitment named "Run"
  alike in every other way and never given to it under "Sport", each report that it did not put the
  commitment under the category and leave the roster the same

#### Scenario: a commitment the roster has stopped keeping is still under the category it was under

- **WHEN** a roster given a commitment named "Creatine" and then one named "Gym", both on a schedule
  listing all seven weekdays and both kept from 1 January 2026, puts "Creatine" under the category
  "Supplements", stops keeping "Creatine" as of 31 January 2026, and is then given a commitment
  alike in every way to "Creatine" under "Supplements"
- **THEN** it reads back two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** it is the same roster as one given the two, asked to put "Creatine" under "Supplements",
  and never asked to stop keeping anything

#### Scenario: putting a commitment under a category changes no day, no commitment and no order

- **WHEN** a roster given a commitment named "Creatine" kept from 1 January 2026, then one named
  "Gym" kept from 1 March 2026, then one named "Journaling" kept from 1 June 2026, all on a schedule
  listing Monday, Wednesday and Saturday, stops keeping "Creatine" as of 31 January 2026, and then
  puts "Journaling" under the category "Evening"
- **THEN** the roster answers with "Creatine" on 31 January 2026 and without it on 1 February 2026,
  the day it was kept until unmoved
- **AND** each of the three reads back the day it is kept from unchanged
- **AND** "Gym" is due on Monday 2 March 2026 and not due on Tuesday 3 March 2026, exactly as it was
  before
- **AND** the roster reads back the commitments it is keeping as "Gym" and then "Journaling", in the
  order it held them before

#### Scenario: putting a commitment under a category on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Creatine" and then one named "Gym", both on a
  schedule listing all seven weekdays and both kept from 1 January 2026, is copied, and the copy
  puts "Creatine" under the category "Supplements"
- **THEN** the copy reads back two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** the roster it was copied from reads back one group, with no category, holding "Creatine"
  and then "Gym", and is not the same roster as the copy

### Requirement: A roster reads the commitments it is keeping in groups, one per category

A roster SHALL read back the commitments it is keeping in **groups**: a group is a category, or no
category at all, together with the commitments under it, in the order the roster holds them. It
SHALL answer the same way about a calendar date, taking the commitments it had not stopped keeping
on it — the ones it is keeping, and every commitment whose kept-until day is that date or later,
whether it was stopped or removed — each under the category it is under. A roster holding nothing,
and one none of whose commitments had been taken on by the date asked about, SHALL each read back no
groups at all rather than one empty group.

The groups SHALL be in the order in which each category is first met, walking the commitments in the
roster's own order, and the commitments within a group SHALL be in that same order. The group of the
commitments under no category SHALL come last, wherever the first of them sits, and SHALL be absent
where every commitment is under a category. A group for a category no commitment is under SHALL NOT
exist. The roster MUST NOT sort the groups by their category, MUST NOT sort within a group, and MUST
NOT put the group with no category anywhere but last. The order the roster holds its commitments in
SHALL be unchanged by anything about a category, and the flat reads SHALL go on answering in that
order and SHALL NOT be grouped or rearranged. Reading in groups and reading flat SHALL answer with
the same commitments, each exactly once, and SHALL disagree only in the order they come in. Nothing
SHALL be stored for a group.

#### Scenario: a roster none of whose commitments is under a category reads back one group

- **WHEN** a roster is given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing all seven weekdays and all kept from 1 January 2026
- **THEN** it reads back one group, with no category, holding "Water plants", then "Gym", then
  "Journaling"

#### Scenario: a roster that has been given no commitment reads back no groups at all

- **WHEN** a roster is formed and nothing is added to it
- **THEN** it reads back no groups at all
- **AND** a roster given one commitment and asked to stop keeping it likewise reads back no groups
  at all

#### Scenario: a group sits where its first commitment sits in the order the roster holds them

- **WHEN** a roster is given a commitment named "Creatine", then one named "Gym", then one named
  "Magnesium", then one named "Finances", all on a schedule listing all seven weekdays and all kept
  from 1 January 2026, and puts "Creatine" and "Magnesium" under the category "Supplements" and
  "Gym" under "Sport"
- **THEN** it reads back three groups: "Supplements" holding "Creatine" and then "Magnesium", then
  "Sport" holding "Gym", then a group with no category holding "Finances"
- **AND** the groups are not in alphabetical order

#### Scenario: the commitments under no category come last however early the first of them sits

- **WHEN** a roster is given a commitment named "Finances", then one named "Creatine", then one
  named "Gym", all on a schedule listing all seven weekdays and all kept from 1 January 2026, and
  puts "Creatine" under the category "Supplements" and "Gym" under "Sport"
- **THEN** it reads back three groups: "Supplements" holding "Creatine", then "Sport" holding "Gym",
  then a group with no category holding "Finances"
- **AND** a roster alike in every way that also puts "Finances" under "Supplements" reads back two
  groups, "Supplements" holding "Finances" and then "Creatine", and then "Sport" holding "Gym"

#### Scenario: a category whose last commitment is put under another is no longer a group

- **WHEN** a roster is given a commitment named "Creatine" and then one named "Gym", both on a
  schedule listing all seven weekdays and both kept from 1 January 2026, puts "Gym" under the
  category "Sport", and then puts "Gym" under the category "Supplements"
- **THEN** it reads back two groups, "Supplements" holding "Gym" and then a group with no category
  holding "Creatine"
- **AND** no group is under "Sport"

#### Scenario: reading in groups and reading flat answer with the same commitments in different orders

- **WHEN** a roster is given a commitment named "Creatine", then one named "Gym", then one named
  "Magnesium", all on a schedule listing all seven weekdays and all kept from 1 January 2026, and
  puts "Creatine" and "Magnesium" under the category "Supplements"
- **THEN** it reads back its commitments flat as "Creatine", then "Gym", then "Magnesium", in the
  order it holds them
- **AND** it reads back two groups, "Supplements" holding "Creatine" and then "Magnesium", and then
  a group with no category holding "Gym"

#### Scenario: a roster answers about a date in groups, with what it had not stopped keeping on it

- **WHEN** a roster is given a commitment named "Creatine", then one named "Gym", then one named
  "Journaling", all on a schedule listing all seven weekdays and all kept from 1 January 2026; puts
  "Creatine" under the category "Supplements" and "Gym" under "Sport"; and stops keeping "Gym" as of
  31 January 2026
- **THEN** asked about 31 January 2026 it reads back three groups: "Supplements" holding "Creatine",
  then "Sport" holding "Gym", then a group with no category holding "Journaling"
- **AND** asked about 1 February 2026 it reads back two groups, "Supplements" holding "Creatine" and
  then a group with no category holding "Journaling"

#### Scenario: a removed commitment is in the groups a roster answers a date with, under its category

- **WHEN** a roster is given a commitment named "Creatine" and then one named "Gym", both on a
  schedule listing all seven weekdays and both kept from 1 January 2026; puts "Gym" under the
  category "Sport"; and removes "Gym" as of 31 January 2026
- **THEN** asked about 31 January 2026 it reads back two groups, a group with no category holding
  "Creatine" coming after "Sport" holding "Gym"
- **AND** asked about 1 February 2026 it reads back one group, with no category, holding "Creatine"

### Requirement: A roster moves a group among the groups it is keeping

A roster SHALL move a group, on being given the category naming it and an offset counted over the
groups it is keeping that are under a category as they stand before the move, from 0 to the number
of them. It SHALL relocate every commitment under that category and SHALL report that it moved the
group. Everything under the category SHALL travel — kept, stopped and removed alike — keeping its
order against the others that travel.

Unless the offset asks for the place the group already has, every commitment under that category
SHALL be taken out of the sequence and put back immediately before the first commitment the roster
is keeping under the category of the group that stood at that offset, or, where the offset is the
number of those groups, after the last commitment under the category of the last of them, whatever
state that one is in. Where a stopped or removed commitment under the target group lies earlier in
the order than that group's first kept commitment, the roster SHALL afterwards answer about a date
on which that commitment was still kept in the opposite group order. Every commitment that does not
travel SHALL afterwards be in the order it was in against every other that does not travel, and a
group whose commitments were scattered comes back contiguous, so a commitment under another category
that lay between two of them is afterwards on one side of the group.

On the offset the group is at among those groups and the one just after it, nothing in the sequence
SHALL move, so a scattered group is not gathered there. The offset SHALL count neither the group of
the commitments under no category nor a category only a commitment it has stopped keeping or removed
is under.

The roster SHALL refuse to move a group for a category no commitment it is keeping is under — never
under one, under only a stopped or a removed commitment, and no category at all — and an offset
below 0 or above the number of those groups; it SHALL report each and SHALL be left exactly as it
was, its categories included. A group move SHALL put nothing under anything: every commitment
travels under the category that named the group. It SHALL NOT ask what day it is, SHALL NOT be
recorded, and SHALL change no day a commitment was kept until or is kept from, no state the roster
holds one in, nothing about the commitments and nothing recorded against them. It SHALL leave every
other roster untouched.

#### Scenario: moving a group to the front draws it before every other group under a category

- **WHEN** a roster given a commitment named "Gym", then one named "Creatine", then one named
  "Magnesium", all on a schedule listing all seven weekdays and all kept from 1 January 2026, puts
  "Gym" under the category "Sport" and "Creatine" and "Magnesium" under "Supplements", and is then
  asked to move the group "Supplements" to the offset 0
- **THEN** the roster reports that it moved the group
- **AND** it reads back two groups, "Supplements" holding "Creatine" and then "Magnesium", and then
  "Sport" holding "Gym"
- **AND** it reads its commitments back flat as "Creatine", then "Magnesium", then "Gym"

#### Scenario: moving a group to the end draws it after every other group under a category and before the commitments under none

- **WHEN** a roster given a commitment named "Creatine", then one named "Gym", then one named
  "Finances", all on a schedule listing all seven weekdays and all kept from 1 January 2026, puts
  "Creatine" under the category "Supplements" and "Gym" under "Sport", leaving "Finances" under none,
  and is then asked to move the group "Supplements" to the offset 2, the number of groups it is
  keeping under a category
- **THEN** the roster reports that it moved the group
- **AND** it reads back three groups: "Sport" holding "Gym", then "Supplements" holding "Creatine",
  then a group with no category holding "Finances"
- **AND** it reads its commitments back flat as "Gym", then "Creatine", then "Finances"

#### Scenario: an offset for a group is counted over the groups the roster is keeping that are under a category

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Creatine", then one named "Finances", all on a schedule listing all seven weekdays and all kept
  from 1 January 2026, puts "Gym" under the category "Sport", "Creatine" under "Supplements" and
  "Finances" under "Money", leaving "Water plants" under none, and is then asked to move the group
  "Money" to the offset 1
- **THEN** it reads back four groups: "Sport" holding "Gym", then "Money" holding "Finances", then
  "Supplements" holding "Creatine", then a group with no category holding "Water plants" — the offset
  naming "Supplements", the group that stood at it before the move, as the group the moved group comes
  to stand before
- **AND** a roster alike in every way asked to move the group "Sport" to the offset 3 instead, which
  is the number of groups it is keeping under a category and counts no group for the commitments
  under none, reads back "Supplements" holding "Creatine", then "Money" holding "Finances", then
  "Sport" holding "Gym", then a group with no category holding "Water plants"
- **AND** that group with no category is drawn last in both, though "Water plants" is the first
  commitment the roster holds

#### Scenario: a group's stopped and removed commitments travel with it

- **WHEN** a roster given a commitment named "Creatine", then one named "Magnesium", then one named
  "Gym", then one named "Journaling", all on a schedule listing all seven weekdays and all kept from
  1 January 2026, puts "Creatine" and "Magnesium" under the category "Supplements" and "Gym" and
  "Journaling" under "Sport", stops keeping "Creatine" as of 31 January 2026, and is then asked to
  move the group "Supplements" to the offset 2
- **THEN** the roster reports that it moved the group
- **AND** it reads back two groups, "Sport" holding "Gym" and then "Journaling", then "Supplements"
  holding "Magnesium"
- **AND** asked about 31 January 2026 it reads back two groups, "Sport" holding "Gym" and then
  "Journaling", then "Supplements" holding "Creatine" and then "Magnesium" — the stopped "Creatine"
  under its own group and after "Sport", where the group was moved to
- **AND** a roster that had removed "Creatine" as of that same day instead answers about that day in
  those same two groups, in that same order

#### Scenario: a group's commitments are gathered into one block, keeping their order against each other

- **WHEN** a roster given a commitment named "Creatine", then one named "Gym", then one named
  "Magnesium", all on a schedule listing all seven weekdays and all kept from 1 January 2026, puts
  "Creatine" and "Magnesium" under the category "Supplements" and "Gym" under "Sport", and is then
  asked to move the group "Supplements" to the offset 2
- **THEN** the roster reports that it moved the group
- **AND** it reads its commitments back flat as "Gym", then "Creatine", then "Magnesium" — "Creatine"
  and "Magnesium" together and in the order they were in, and "Gym", which lay between them, on one
  side of both
- **AND** it reads back two groups, "Sport" holding "Gym", then "Supplements" holding "Creatine" and
  then "Magnesium"

#### Scenario: two offsets leave a group where it is, and both are accepted

- **WHEN** a roster given a commitment named "Creatine", then one named "Gym", then one named
  "Magnesium", all on a schedule listing all seven weekdays and all kept from 1 January 2026, puts
  "Creatine" and "Magnesium" under the category "Supplements" and "Gym" under "Sport", is asked to
  move the group "Supplements" to the offset 0, and a roster alike in every way is asked to move it
  to the offset 1
- **THEN** each reports that it moved the group
- **AND** each is the same roster as one that was never asked, reading its commitments back flat as
  "Creatine", then "Gym", then "Magnesium" — the group not gathered
- **AND** each reads back two groups, "Supplements" holding "Creatine" and then "Magnesium", and then
  "Sport" holding "Gym"

#### Scenario: moving the group of the commitments under no category is refused

- **WHEN** a roster given a commitment named "Creatine" and then one named "Gym", both on a schedule
  listing all seven weekdays and both kept from 1 January 2026, puts "Creatine" under the category
  "Supplements", and is then asked to move the group under no category to the offset 0
- **THEN** the roster reports that it did not move the group
- **AND** the roster is the same roster as one that was never asked
- **AND** asking it to move the group named by a category of three spaces to the offset 0 likewise
  reports that it did not move the group and leaves the roster the same

#### Scenario: moving a group no commitment the roster is keeping is under is refused

- **WHEN** a roster given a commitment named "Creatine", then one named "Gym", then one named
  "Journaling", all on a schedule listing all seven weekdays and all kept from 1 January 2026, puts
  "Creatine" under the category "Supplements", "Gym" under "Sport" and "Journaling" under "Money",
  stops keeping "Gym" as of 31 January 2026 and removes "Journaling" as of that same day, and is then
  asked to move the group "Sport" to the offset 0
- **THEN** the roster reports that it did not move the group
- **AND** the roster is the same roster as one that was never asked
- **AND** asking it to move the group "Money" to the offset 0, and asking it to move a group "Evening"
  that nothing it holds has ever been under, each report that it did not move the group and leave the
  roster the same

#### Scenario: an offset below zero and one above the number of groups under a category are both refused for a group

- **WHEN** a roster given a commitment named "Creatine", then one named "Gym", then one named
  "Finances", all on a schedule listing all seven weekdays and all kept from 1 January 2026, puts
  "Creatine" under the category "Supplements" and "Gym" under "Sport", leaving "Finances" under none,
  and is then asked to move the group "Sport" to the offset -1
- **THEN** the roster reports that it did not move the group
- **AND** the roster is the same roster as one that was never asked
- **AND** asking it to move the group "Sport" to the offset 3, one above the two groups it is keeping
  under a category though it reads back three groups in all, reports that it did not move the group
  and leaves the roster the same

#### Scenario: moving a group moves no day and changes no commitment

- **WHEN** a roster given a commitment named "Creatine" kept from 1 January 2026, then one named
  "Gym" kept from 1 March 2026, then one named "Journaling" kept from 1 June 2026, all on a schedule
  listing Monday, Wednesday and Saturday, puts "Creatine" under the category "Supplements" and "Gym"
  under "Sport" and leaves "Journaling" under none, stops keeping "Journaling" as of 31 January 2026,
  and is then asked to move the group "Sport" to the offset 0
- **THEN** the roster answers with "Journaling" on 31 January 2026 and without it on 1 February 2026,
  the day it was kept until unmoved
- **AND** each of the three reads back the day it is kept from unchanged
- **AND** "Gym" is due on Monday 2 March 2026 and not due on Tuesday 3 March 2026, exactly as it was
  before
- **AND** it reads back two groups, "Sport" holding "Gym" and then "Supplements" holding "Creatine",
  each commitment under the category it was already under

#### Scenario: moving a group on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Creatine" under the category "Supplements" and then
  one named "Gym" under "Sport", both on a schedule listing all seven weekdays and both kept from
  1 January 2026, is copied, and the copy moves the group "Sport" to the offset 0
- **THEN** the copy reads back two groups, "Sport" holding "Gym" and then "Supplements" holding
  "Creatine"
- **AND** the roster it was copied from still reads back "Supplements" holding "Creatine" and then
  "Sport" holding "Gym", and is not the same roster as the copy

#### Scenario: a group is put before the first commitment the roster is keeping under the group at the offset

- **WHEN** a roster given a commitment named "Creatine", then one named "Finances", then one named
  "Magnesium", then one named "Gym", all on a schedule listing all seven weekdays and all kept from
  1 January 2026, puts "Creatine" and "Magnesium" under the category "Supplements", "Finances" under
  "Money" and "Gym" under "Sport", stops keeping "Creatine" as of 31 January 2026 — leaving
  "Supplements" a group whose first commitment is one it has stopped — and is then asked to move the
  group "Sport" to the offset 1
- **THEN** the roster reports that it moved the group
- **AND** it reads back three groups: "Money" holding "Finances", then "Sport" holding "Gym", then
  "Supplements" holding "Magnesium" — "Sport" at the offset it was given, after "Money" and before
  "Supplements", the group that stood at that offset
- **AND** it reads its commitments back flat as "Creatine", then "Finances", then "Gym", then
  "Magnesium" — "Gym" put before "Magnesium", the first commitment the roster is keeping under
  "Supplements", and after "Creatine", which it is not

#### Scenario: a group placed against a kept commitment is read in a different order on a date before a stop

- **WHEN** a roster given a commitment named "Creatine", then one named "Magnesium", then one named
  "Vitamin D", then one named "Gym", all on a schedule listing all seven weekdays and all kept from
  1 January 2026, puts "Creatine", "Magnesium" and "Vitamin D" under the category "Supplements" and
  "Gym" under "Sport", stops keeping "Creatine" as of 31 January 2026, and is then asked to move the
  group "Sport" to the offset 0
- **THEN** the roster reports that it moved the group
- **AND** it reads back two groups, "Sport" holding "Gym", then "Supplements" holding "Magnesium" and
  then "Vitamin D"
- **AND** asked about 31 January 2026, a day on which it had not stopped keeping "Creatine", it reads
  back those two groups the other way round: "Supplements" holding "Creatine", then "Magnesium", then
  "Vitamin D", and then "Sport" holding "Gym" — because on that day the first commitment under
  "Supplements" is the one the move was not measured against
- **AND** it reads its commitments back flat as "Creatine", then "Gym", then "Magnesium", then
  "Vitamin D"

#### Scenario: a roster keeping one group under a category accepts both the offsets it has

- **WHEN** a roster holding a commitment named "Creatine" under the category "Supplements" and then
  one named "Gym" under no category, both on a schedule listing all seven weekdays and both kept from
  1 January 2026, is asked to move the group "Supplements" to the offset 0, and a roster alike in
  every way is asked to move it to the offset 1
- **THEN** each reports that it moved the group
- **AND** each is the same roster as one that was never asked
- **AND** a roster alike in every way asked to move it to the offset 2 reports that it did not move
  the group

### Requirement: A commitments screen moves a group among the groups it draws

A commitments screen SHALL move a group on the list of what it keeps, on being given the category
naming that group and an offset counted over the groups it draws that are under a category as they
stand before the move, and SHALL keep the move at the roster place before the list says so. It SHALL
ask for no confirmation and for nothing else. The offset is the screen's own count and the roster's
alike, and this screen SHALL convert nothing: the groups it draws are the groups the roster answers
with, in that order.

Everything under the category SHALL move with the group — a stopped commitment under it travels like
every other — so the list of what the screen has stopped SHALL be drawn in a different order
afterwards. The group SHALL come to rest at that offset on this list, every time. Where the group it
was put before has a commitment the screen has stopped lying earlier in the roster's order than the
first it keeps under that category, what is kept at the roster place SHALL afterwards answer about a
date before that stop with those two groups in the opposite order.

The group of the commitments under no category is not a group this act takes. A screen asked to move
it, to move a group it draws none of — a category nothing it keeps is under — or to an offset the
groups it draws under a category do not have SHALL do nothing and SHALL say nothing. A group move it
could not keep at the roster place SHALL be refused as a roster that could not be written, SHALL
name the category it was asked to move, and SHALL leave both lists as they were; a refused group
move is the only kind of refused change this screen holds that names something other than a
commitment. A group move that leaves a group where it is drawn SHALL change nothing, SHALL say
nothing, SHALL refuse nothing and SHALL NOT answer a refused change the screen is already holding.

#### Scenario: a group moved through a commitments screen is drawn where it was moved to, and is kept there

- **WHEN** a commitment named "Gym", then one named "Creatine", then one named "Magnesium", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place;
  "Gym" is put under the category "Sport" there and "Creatine" and "Magnesium" under "Supplements"; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; and the group
  "Supplements" is moved to the offset 0
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then "Magnesium", and
  then "Sport" holding "Gym"
- **AND** a commitments screen opened afterwards at that place as of that same day keeps those two
  groups in that same order

#### Scenario: an offset a commitments screen is given for a group is counted over the groups it draws that are under a category

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Creatine", then
  one named "Finances", all on a schedule listing all seven weekdays and kept from 1 January 2026,
  are taken on at a roster place; "Gym" is put under the category "Sport" there, "Creatine" under
  "Supplements" and "Finances" under "Money"; a commitments screen is opened at that roster place as
  of Monday 31 August 2026; and the group "Sport" is moved to the offset 3, the number of groups it
  draws that are under a category
- **THEN** nothing is refused
- **AND** what it keeps is four groups: "Supplements" holding "Creatine", then "Money" holding
  "Finances", then "Sport" holding "Gym", then a group with no category holding "Water plants"
- **AND** a screen alike in every way asked to move the group "Sport" to the offset 4, which the four
  groups it draws have but the three under a category do not, refuses nothing and leaves what it
  keeps exactly as it was

#### Scenario: a group moved through a commitments screen carries the commitments it has stopped with it

- **WHEN** a commitment named "Creatine", then one named "Magnesium", then one named "Gym", then one
  named "Journaling", all on a schedule listing all seven weekdays and kept from 1 January 2026, are
  taken on at a roster place; "Creatine" and "Magnesium" are put under the category "Supplements"
  there and "Gym" and "Journaling" under "Sport"; "Creatine" and "Journaling" are stopped there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and the group "Supplements" is moved to the offset 2
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Sport" holding "Gym", then "Supplements" holding "Magnesium"
- **AND** what it has stopped is two entries, named "Journaling" and then "Creatine", in the order the
  roster now holds them and not the order they were taken on in
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with two
  groups, "Sport" holding "Gym" and then "Journaling", then "Supplements" holding "Creatine" and then
  "Magnesium"

#### Scenario: a commitments screen asked to move the group of the commitments under no category does nothing and says nothing

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; the content at that place is read; and the group under no category is moved to the
  offset 0
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** moving the group named by a category of three spaces to the offset 0 leaves that true again
- **AND** the content at that place is byte-for-byte what was read before either move

#### Scenario: a commitments screen asked to move a group it draws none of does nothing and says nothing

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; "Gym" is stopped there as of Sunday
  30 August 2026; a commitments screen is opened at that roster place as of Monday 31 August 2026;
  the content at that place is read; and the group "Sport" is moved to the offset 0
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is one group, "Supplements", holding "Creatine", and what it has stopped is
  one entry, named "Gym"
- **AND** moving the group "Evening", which nothing either list holds is under, to the offset 0
  leaves that true again
- **AND** the content at that place is byte-for-byte what was read before either move

#### Scenario: a commitments screen given an offset the groups it draws do not have does nothing and says nothing

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; a commitments screen is opened at that roster
  place as of Monday 31 August 2026; the content at that place is read; and the group "Sport" is
  moved to the offset 3, which two groups under a category do not have
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then "Sport" holding
  "Gym"
- **AND** moving the group "Sport" to the offset -1 refuses nothing and leaves what it keeps the same
  again
- **AND** the content at that place is byte-for-byte what was read before either move

#### Scenario: a group move a commitments screen could not keep leaves both its lists as they were

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; a commitments screen is opened at that roster
  place as of Monday 31 August 2026; what is at that place is then made impossible to write; and the
  group "Sport" is moved to the offset 0
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against moving the group "Sport", naming the category and no
  commitment
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then "Sport" holding
  "Gym", and what it has stopped is nothing

#### Scenario: a group move that leaves a group where it is drawn changes nothing and refuses nothing

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place;
  "Creatine" and "Magnesium" are put under the category "Supplements" there and "Gym" under "Sport";
  a commitments screen is opened at that roster place as of Monday 31 August 2026; the content at
  that place is read; and the group "Supplements" is moved to the offset 0
- **THEN** nothing is refused and the screen holds no refused change
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then "Magnesium", and
  then "Sport" holding "Gym"
- **AND** moving the group "Supplements" to the offset 1 leaves that true again
- **AND** the content at that place is byte-for-byte what was read before either move

#### Scenario: a group moved above one whose first commitment is stopped is drawn where the person put it

- **WHEN** a commitment named "Creatine", then one named "Magnesium", then one named "Gym", all on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place;
  "Creatine" and "Magnesium" are put under the category "Supplements" there and "Gym" under "Sport";
  "Creatine" is stopped there as of Sunday 30 August 2026, leaving "Supplements" a group whose first
  commitment is one the screen has stopped; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; and the group "Sport" is moved to the offset 0
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Sport" holding "Gym", then "Supplements" holding "Magnesium" —
  drawn at the offset it was given and not after "Supplements"
- **AND** what it has stopped is one entry, named "Creatine"
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  those two groups the other way round, "Supplements" holding "Creatine" and then "Magnesium", and
  then "Sport" holding "Gym"

#### Scenario: a commitments screen shown again draws its groups in the order they were moved into

- **WHEN** a commitment named "Gym" and one named "Creatine", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is put under the
  category "Sport" there and "Creatine" under "Supplements"; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; the group "Supplements" is moved to the offset 0; and the
  screen is shown again as of Tuesday 1 September 2026
- **THEN** what it keeps is two groups, "Supplements" holding "Creatine" and then "Sport" holding
  "Gym"

### Requirement: A roster answers the earliest day anything it holds has been kept from

A roster SHALL answer, of the commitments it holds, the earliest calendar date any of them is kept
from, and that there is none where it holds no commitment at all. Every commitment SHALL count, one
it has stopped keeping and one it has removed included; neither state SHALL raise the answer, and
taking a commitment up again SHALL NOT lower it. The answer SHALL be a day a commitment is kept from
and never a day it is due, and the roster MUST NOT consult a commitment's schedule, its name, kind,
category or place in the order to find it. It SHALL be asked of the roster and handed nothing, and
this capability MUST NOT consult the present moment, the device's time zone or the locale. A
commitment taken on with an earlier day SHALL lower it, and one taken on with a later day SHALL
leave it exactly as it was. A commitment SHALL read back the name it was given and the kind its days
take and nothing else, never the day it is kept from.

#### Scenario: a roster holding no commitments answers no earliest day anything it holds is kept from

- **WHEN** a roster that has taken nothing on is asked the earliest day anything it holds is kept
  from
- **THEN** it answers that there is none

#### Scenario: a roster answers the earliest day among the commitments it holds

- **WHEN** a roster takes on a commitment named "Gym" kept from 1 March 2026, then one named "Run"
  kept from 1 January 2026, then one named "Journaling" kept from 1 February 2026, all three on a
  schedule listing all seven weekdays
- **THEN** it answers 1 January 2026
- **AND** a roster that took the same three on in the opposite order answers 1 January 2026 too

#### Scenario: a roster counts a commitment it has stopped keeping in the earliest day anything it holds is kept from

- **WHEN** a roster takes on a commitment named "Gym" kept from 1 January 2026 and one named "Run"
  kept from 1 March 2026, both on a schedule listing all seven weekdays, and "Gym" is then stopped
  as of 31 January 2026
- **THEN** it answers 1 January 2026
- **AND** the commitments it keeps are "Run" alone

#### Scenario: a roster counts a commitment it has removed in the earliest day anything it holds is kept from

- **WHEN** a roster takes on a commitment named "Gym" kept from 1 January 2026 and one named "Run"
  kept from 1 March 2026, both on a schedule listing all seven weekdays, and "Gym" is then removed
  as of 31 January 2026
- **THEN** it answers 1 January 2026
- **AND** the commitments it keeps are "Run" alone

#### Scenario: the earliest day anything a roster holds is kept from falls when a commitment kept from an earlier day is taken on

- **WHEN** a roster takes on a commitment named "Gym" kept from 1 March 2026 on a schedule listing
  all seven weekdays, and is then asked; and it afterwards takes on one named "Run" kept from
  1 January 2026 on that same schedule, and is asked again
- **THEN** the first answer is 1 March 2026 and the second is 1 January 2026
- **AND** taking on a third named "Journaling" kept from 1 June 2026 leaves the answer at
  1 January 2026

#### Scenario: a roster answers the day a commitment is kept from and not a day it is due

- **WHEN** a roster takes on a commitment named "Gym" on a schedule listing Monday alone, kept from
  Sunday 1 February 2026
- **THEN** it answers Sunday 1 February 2026
- **AND** that commitment is not due on Sunday 1 February 2026, the first day it is due being
  Monday 2 February 2026

#### Scenario: a roster answers the first supported date where a commitment it holds is kept from it

- **WHEN** a roster takes on a commitment named "Gym" kept from 31 December 9999 and one named
  "Run" kept from 1 January 1583, both on a schedule listing all seven weekdays
- **THEN** it answers 1 January 1583

### Requirement: A roster changes a commitment it holds for another, in the place it holds it

A roster SHALL change a commitment it holds for another, on being given the two and the category to
put the result under, which may be none. It SHALL put the second in the place the first held, SHALL
leave the day that commitment was kept until and whether it was removed exactly as they were, SHALL
put it under the category it was offered under, and SHALL report that it changed; nothing else it
holds SHALL move. It SHALL change a commitment in any of the three states it holds one in and SHALL
leave it in the state it was in.

The roster SHALL refuse to change a commitment it does not hold at all, and a change whose result is
a commitment it already holds, kept, stopped or removed alike; it SHALL report each and SHALL be
left exactly as it was. Asked to change a commitment for itself it SHALL be left exactly as it was
and SHALL report that it changed. Changing SHALL change nothing about either commitment and nothing
recorded against either; a roster holds no records and SHALL carry none over. It SHALL leave every
other roster untouched, and two rosters differing only in one commitment having been changed SHALL
be different rosters.

#### Scenario: changing a commitment a roster holds puts the result in the place the one it replaced held

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, is asked to change "Gym" for a commitment named "Gym 🏋️" alike in every other way,
  under no category
- **THEN** the roster reports that it changed the commitment
- **AND** it reads back three commitments in the order "Water plants", then "Gym 🏋️", then
  "Journaling"

#### Scenario: a changed commitment is put under the category the change was offered under

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, under the category "Sport", is asked to change it for a
  commitment named "Gym 🏋️" alike in every other way, under the category "Morning"
- **THEN** the roster reads back one group, "Morning", holding "Gym 🏋️"
- **AND** a roster asked for that same change under no category reads back one group, with no
  category, holding "Gym 🏋️"

#### Scenario: changing a commitment a roster has stopped keeping leaves it stopped, on the day it was kept until

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, stops keeping it as of 31 January 2026, and is then asked to
  change it for a commitment named "Gym 🏋️" alike in every other way, under no category
- **THEN** the roster reports that it changed the commitment
- **AND** it reads back no commitments it is keeping and one it has stopped, named "Gym 🏋️"
- **AND** it answers with "Gym 🏋️" on 31 January 2026 and with nothing on 1 February 2026

#### Scenario: changing a commitment a roster has removed leaves it removed

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, removes it as of 31 January 2026, and is then asked to change
  it for a commitment named "Gym 🏋️" alike in every other way, under no category
- **THEN** the roster reports that it changed the commitment
- **AND** it reads back no commitments it is keeping and none it has stopped
- **AND** it answers with "Gym 🏋️" on 31 January 2026 and with nothing on 1 February 2026

#### Scenario: changing a commitment a roster does not hold is refused and leaves the roster as it was

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to change a commitment named "Run" alike in every
  other way for one named "Runs", under no category
- **THEN** the roster reports that it did not change the commitment
- **AND** the roster is the same roster as one that was never asked

#### Scenario: changing a commitment into one the roster already holds is refused, whichever state it holds it in

- **WHEN** a roster given a commitment named "Gym" and one named "Run", both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026, is asked to change "Gym" for a
  commitment named "Run" alike in every other way, under no category
- **THEN** the roster reports that it did not change the commitment
- **AND** the roster is the same roster as one that was never asked
- **AND** a roster that had stopped keeping "Run" as of 31 January 2026 refuses that same change, and
  so does one that had removed it as of that day

#### Scenario: changing a commitment for itself changes nothing and is not refused

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, under the category "Sport", is asked to change that commitment
  for that same commitment, under the category "Sport"
- **THEN** the roster reports that it changed the commitment
- **AND** the roster is the same roster as one that was never asked

#### Scenario: changing a commitment on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is copied, and the copy changes that commitment for one named
  "Gym 🏋️" alike in every other way, under no category
- **THEN** the copy reads back one commitment, named "Gym 🏋️"
- **AND** the roster it was copied from still reads back one commitment named "Gym" and is not the
  same roster as the copy

### Requirement: A roster supersedes a commitment it is keeping with another, from a day

A roster SHALL **supersede** a commitment it is keeping with another, on being given the two, a
calendar date — the day the superseded commitment was kept until — and the category to put the
commitment taking its place under, which may be none. Superseding SHALL do three things as one act:
record that date as the day the superseded commitment was kept until, hold that commitment as
removed, and take the other on in the place the superseded one held, under the category it was
offered under. It SHALL report that it superseded, and the superseded commitment SHALL sit
immediately behind the one taking its place.

The roster SHALL refuse to supersede a commitment it is not keeping — one it does not hold, one it
has stopped keeping and one it has removed alike — and a superseding commitment it already holds,
kept, stopped or removed alike, which is the rule that refuses a commitment asked to supersede
itself; it SHALL report each. It SHALL refuse on no date: any calendar date the system supports
SHALL be accepted, the first and the last included, and a date earlier than the day that commitment
is kept from leaves one the roster was keeping on no date at all. It SHALL NOT ask what day it is,
SHALL NOT judge either commitment's schedule and SHALL NOT decide whether either is due.

Superseding SHALL change nothing about either commitment and nothing recorded against either, and
the roster SHALL hold no link between the two. It SHALL leave every other roster untouched, and two
rosters differing only in a supersession SHALL be different rosters.

#### Scenario: superseding a commitment takes the other one on in the place the superseded one held

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, then one named "Journaling", all kept from 1 January 2026,
  is asked to supersede "Gym" with a commitment named "Gym" on a schedule listing Tuesday and
  Thursday, kept from 1 September 2026, as of 31 August 2026, under no category
- **THEN** the roster reports that it superseded the commitment
- **AND** it reads back three commitments it is keeping, in the order "Water plants", then "Gym" on
  Tuesday and Thursday, then "Journaling"

#### Scenario: a superseded commitment is held removed, on the day it was kept until

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to supersede it with a commitment named "Gym" on a
  schedule listing Tuesday and Thursday, kept from 1 September 2026, as of 31 August 2026, under no
  category
- **THEN** the roster reads back one commitment it is keeping, on Tuesday and Thursday, and none it
  has stopped
- **AND** asked about 31 August 2026 it answers with both, the one on Tuesday and Thursday first
- **AND** asked about 1 September 2026 it answers with the one on Tuesday and Thursday alone

#### Scenario: the commitment that supersedes another is put under the category it was offered under

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, under the category "Sport", is asked to supersede it with a
  commitment named "Gym" on a schedule listing Tuesday and Thursday, kept from 1 September 2026, as
  of 31 August 2026, under the category "Morning"
- **THEN** the roster reads back one group it is keeping, "Morning", holding the commitment on
  Tuesday and Thursday

#### Scenario: superseding a commitment a roster is not keeping is refused

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, stops keeping it as of 31 January 2026, and is then asked to
  supersede it with a commitment named "Gym" on a schedule listing Tuesday and Thursday, kept from
  1 September 2026, as of 31 August 2026, under no category
- **THEN** the roster reports that it did not supersede the commitment
- **AND** the roster is the same roster as one that stopped keeping "Gym" as of 31 January 2026 and
  was never asked
- **AND** a roster that had removed "Gym" as of 31 January 2026 refuses that same supersession, and
  so does one that never held it at all

#### Scenario: superseding a commitment with one the roster already holds is refused

- **WHEN** a roster given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday and one named "Gym" on a schedule listing Tuesday and Thursday, both kept from
  1 January 2026, is asked to supersede the first with the second, as of 31 August 2026, under no
  category
- **THEN** the roster reports that it did not supersede the commitment
- **AND** the roster is the same roster as one that was never asked
- **AND** a roster asked to supersede a commitment with that same commitment refuses it too

#### Scenario: a commitment superseded as of a day before the day it is kept from was kept on no date

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 March 2026, is asked to supersede it with a commitment named "Gym" on a
  schedule listing Tuesday and Thursday, kept from 1 March 2026, as of 28 February 2026, under no
  category
- **THEN** the roster reports that it superseded the commitment
- **AND** asked about 28 February 2026 it answers with both, and asked about 1 March 2026 it answers
  with the one on Tuesday and Thursday alone

#### Scenario: a superseded commitment stays where it was for every date the roster answers about

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, then one named "Journaling", all kept from 1 January 2026,
  is asked to supersede "Gym" with a commitment named "Gym" on a schedule listing Tuesday and
  Thursday, kept from 1 September 2026, as of 31 August 2026, under no category
- **THEN** asked about 31 August 2026 it answers with four commitments, in the order "Water plants",
  the "Gym" on Tuesday and Thursday, the "Gym" on Monday, Wednesday and Saturday, then "Journaling"

#### Scenario: superseding on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is copied, and the copy supersedes it with a commitment named
  "Gym" on a schedule listing Tuesday and Thursday, kept from 1 September 2026, as of
  31 August 2026, under no category
- **THEN** the copy reads back one commitment it is keeping, on Tuesday and Thursday
- **AND** the roster it was copied from still reads back one commitment named "Gym" on Monday,
  Wednesday and Saturday, and is not the same roster as the copy

### Requirement: A commitments screen says what a commitment it is asked to change is made of

A commitments screen SHALL say, for a commitment on either of its lists, the four things a change is
asked with: the name it has, the rhythm it runs on, the day it is kept from and the category it is
under. For a commitment on neither list it SHALL say nothing at all. The rhythm SHALL be the one of
the four that names that commitment's schedule, carrying the number that schedule carries; an
interval rhythm carries no start date, so an interval schedule's own start date SHALL NOT be part of
what is said.

It SHALL say whether the rhythm and the day kept from can be changed at all: they can for a
commitment its roster is keeping, and they cannot for one it has stopped keeping. It SHALL say the
kind that commitment's days take, with the range or the target that kind carries — the number kind's
range, or that it carries none; the total kind's target; nothing beside a tick or a note. The kind
is not one of the four, so it SHALL be shown, SHALL never be asked about, and nothing SHALL be said
about whether it can be changed. Every control the form draws SHALL be there, and the ones that
cannot be changed SHALL NOT let a thumb in.

#### Scenario: a commitments screen says what a commitment it keeps is made of, on each of the four rhythms

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, one named
  "Finances" on a schedule on the 25th of the month, one named "Contact lenses" on a schedule of
  every 14 days starting on 1 January 2026, and one named "Reading" on a schedule of 3 times a week,
  all kept from 1 January 2026, are taken on at a roster place; and a commitments screen is opened at
  that roster place as of Monday 31 August 2026
- **THEN** what it says each is made of names a weekday-set rhythm of Monday, Wednesday and Saturday,
  a day-of-the-month rhythm of the 25th, an interval rhythm of 14 days and a weekly-quota rhythm of
  3 times a week, in that order
- **AND** each says the name that commitment has and 1 January 2026 as the day it is kept from

#### Scenario: a commitments screen says the category a commitment it keeps is under

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** what it says "Creatine" is made of says the category "Supplements"
- **AND** what it says "Gym" is made of says no category at all

#### Scenario: a commitments screen says a stopped commitment's rhythm and day kept from cannot be changed

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as of
  Sunday 30 August 2026; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** what it says "Gym" is made of says its rhythm and the day it is kept from cannot be changed
- **AND** what it says "Journaling" is made of says they can

#### Scenario: a commitments screen says nothing about a commitment on neither of its lists

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is removed there as of
  Sunday 30 August 2026; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** it says nothing about what "Gym" is made of
- **AND** it says nothing about what a commitment named "Run" alike in every other way, which its
  roster has never held, is made of

#### Scenario: a commitments screen says the kind a commitment it keeps takes, with what that kind carries

- **WHEN** a commitment named "Gym" of the tick kind, one named "Mood" of the number kind with a
  range of 1 to 10, one named "Journal" of the note kind, and one named "Protein" of the total kind
  with a target of 120, all on a schedule listing all seven weekdays and all kept from 1 January
  2026, are taken on at a roster place; and a commitments screen is opened at that roster place as of
  Monday 31 August 2026
- **THEN** what it says each is made of names the tick kind, the number kind carrying a range whose
  lowest is 1 and whose highest is 10, the note kind, and the total kind carrying a target of 120, in
  that order

#### Scenario: a commitments screen says a number commitment carrying no range takes the number kind and no range

- **WHEN** a commitment named "Weight" of the number kind carrying no range, and one named "Gym" of
  the tick kind, both on a schedule listing all seven weekdays and kept from 1 January 2026, are
  taken on at a roster place; "Weight" is stopped there as of Sunday 30 August 2026; and a
  commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it says "Weight" is made of names the number kind carrying no range
- **AND** it says that "Weight"'s rhythm and the day it is kept from cannot be changed

### Requirement: A commitments screen offers the categories in use

A commitments screen SHALL offer the categories already in use: the categories the commitments it
keeps are under, each once, in the order it draws its groups, and a screen keeping nothing under any
category SHALL offer none. They SHALL be read off the roster it is drawing rather than held
anywhere, so a category whose last kept commitment has been put under another SHALL be gone from
what is offered at the same moment its heading goes, and a category that no heading shows SHALL
never be offered. A category on a commitment the screen has stopped SHALL NOT be offered. Two
spellings that differ only in case are two categories and SHALL be offered as two: the screen MUST
NOT fold the case of a category and MUST NOT match one loosely against a category already in use,
here or anywhere else it handles one. What it offers SHALL be what the roster holds, exactly as the
roster holds it, and a category a person types that matches none of them SHALL be accepted exactly
as typed and become a group of its own.

#### Scenario: a commitments screen offers the categories the commitments it keeps are under, each once

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", then one
  named "Finances", all on a schedule listing all seven weekdays and kept from 1 January 2026, are
  taken on at a roster place; "Creatine" and "Magnesium" are put under the category "Supplements"
  there and "Gym" under "Sport"; and a commitments screen is opened at that roster place as of
  Monday 31 August 2026
- **THEN** the categories it offers are "Supplements" and then "Sport", in the order it draws its
  groups
- **AND** "Supplements" is offered once

#### Scenario: a commitments screen keeping nothing under a category offers none

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; and a commitments screen is
  opened at that roster place as of Monday 31 August 2026
- **THEN** the categories it offers are none
- **AND** what it keeps is one group, with no category, holding "Gym" and then "Journaling"

#### Scenario: a commitments screen offers no category that only a commitment it has stopped is under

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and stopped there as of Sunday 30 August 2026; and a commitments
  screen is opened at that roster place as of Monday 31 August 2026
- **THEN** the categories it offers are none
- **AND** after "Creatine" is taken up again through the screen, the categories it offers are
  "Supplements"

#### Scenario: a category no longer under any commitment kept is no longer offered

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Creatine" is changed through it to the category "Morning", on the name, the
  rhythm and the day kept from it already has
- **THEN** the categories it offers are "Morning"
- **AND** "Supplements" is not among them

#### Scenario: a commitments screen does not fold the case of a category it is given

- **WHEN** a commitment named "Creatine" and one named "Magnesium", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen
  is opened at that roster place as of Monday 31 August 2026; "Creatine" is changed through it to the
  category "Supplements"; and "Magnesium" is changed through it to the category "supplements", each
  on the name, the rhythm and the day kept from it already has
- **THEN** what it keeps is two groups, "Supplements" holding "Creatine" and then "supplements"
  holding "Magnesium"
- **AND** the categories it offers are "Supplements" and then "supplements"

### Requirement: A commitments screen refuses a range that is not a range, and a target that is not a target

A commitments screen SHALL refuse to define a commitment of the number kind whose range is not a
range, and one of the total kind whose target is not a target; nothing SHALL be kept at the roster
place, neither of its lists SHALL change, and each SHALL be held as a refused change against
defining a commitment. A range is not a range when its lowest is above its highest, when either end
is not a number, or when one end holds something and the other is blank, which is its own refusal
and not a range left blank. A target is not a target when it is not a number, when it is not above
zero, or when it is blank. Both ends of a range left blank SHALL NOT be this refusal and SHALL NOT
be a refusal at all: it is a commitment of the number kind carrying no range. A range or a target
left in a field the kind chosen has no room for is not refused, as *A commitments screen defines a
commitment from a name, a rhythm and the day it is kept from* says.

The three ways a range fails SHALL be one refusal, told apart from every other this screen makes but
not from each other, and the three ways a target fails SHALL be one refusal likewise; the two SHALL
be told apart from each other. This screen SHALL refuse exactly what the value refuses and SHALL
invent nothing, and the `commitment` capability's own rules for a range and a target are unchanged
by this requirement. A lowest equal to its highest is a range of exactly one value, a range end may
be negative and may be zero, and a target may carry a decimal fraction and SHALL NOT be rounded to a
whole number. A number typed with more significant digits than this system keeps exactly is not a
number and SHALL be refused as such rather than kept shortened.

#### Scenario: a commitments screen refuses a range whose lowest is above its highest

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven weekdays,
  kept from that same day, under no category, of the number kind with a lowest of "10" and a highest
  of "1", is defined through it
- **THEN** it is refused as a range that is not a range
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen refuses a range end that is not a number

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven weekdays,
  kept from that same day, under no category, of the number kind with a lowest of "one" and a highest
  of "10", is defined through it
- **THEN** it is refused as a range that is not a range
- **AND** a commitment alike in every way with a lowest of "1" and a highest of "1e2" is refused the
  same way
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen refuses a range with one end typed and the other blank

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Weight" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the number kind with a lowest of "40" and
  a highest of "", is defined through it
- **THEN** it is refused as a range that is not a range
- **AND** a commitment alike in every way with a lowest of "  " and a highest of "150" is refused the
  same way
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen refuses a target that is not a number

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Protein" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the total kind with a target of "120g", is
  defined through it
- **THEN** it is refused as a target that is not a target
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen refuses a target that is not above zero

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Protein" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the total kind with a target of "0", is
  defined through it
- **THEN** it is refused as a target that is not a target
- **AND** a commitment alike in every way with a target of "-1" is refused the same way
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen refuses a total with nothing in its target field

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Protein" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the total kind with a target of "", is
  defined through it
- **THEN** it is refused as a target that is not a target
- **AND** a commitment alike in every way with a target of "   " is refused the same way
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a range end and a target of more than thirty-eight significant digits are not numbers

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven weekdays,
  kept from that same day, under no category, of the number kind with a lowest of "1" and a highest
  of a 1 followed by thirty-nine 9s, is defined through it; and then one named "Protein" alike in
  rhythm, day and category, of the total kind with a target of that same number
- **THEN** the first is refused as a range that is not a range and the second as a target that is not
  a target
- **AND** a commitment named "Mood" alike in every way whose highest is a 1 followed by
  thirty-seven 9s is not refused
- **AND** what the screen keeps is that one entry, named "Mood"

#### Scenario: a commitments screen accepts a range of one value, and one whose ends are negative and zero

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and two commitments on a weekday-set rhythm of all seven weekdays, kept from
  that same day, under no category, are defined through it — "Doses" of the number kind with a lowest
  of "7" and a highest of "7", and "Weight change" of the number kind with a lowest of "-40.5" and a
  highest of "0"
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place holds "Doses" with a range whose lowest and
  highest are both 7, and "Weight change" with a range whose lowest is -40.5 and whose highest is 0

#### Scenario: a commitments screen accepts a target with a decimal fraction, below one

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and two commitments on a weekday-set rhythm of all seven weekdays, kept from
  that same day, under no category, are defined through it — "Dose" of the total kind with a target
  of "0.5" and "Vitamin D" of the total kind with a target of "0.0001"
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place holds "Dose" with a target of 0.5 and
  "Vitamin D" with a target of 0.0001

#### Scenario: a range a commitments screen refuses is told apart from a target and from its other refusals

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and four commitments on a weekday-set rhythm of all seven weekdays, kept
  from that same day, under no category, are defined through it — "Mood" of the number kind with a
  lowest of "10" and a highest of "1"; "Protein" of the total kind with a target of "0"; "   " of the
  tick kind; and "Finances" of the tick kind on a day-of-the-month rhythm of the 32nd instead
- **THEN** the first is refused as a range that is not a range, the second as a target that is not a
  target, the third as a name that says nothing and the fourth as a rhythm number the calendar will
  not take, each of the four told apart from the other three
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen holds a refused range against defining a commitment

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven weekdays,
  kept from that same day, under no category, of the number kind with a lowest of "10" and a highest
  of "1", is defined through it
- **THEN** the screen holds that refusal, against defining a commitment
- **AND** a screen alike in every way asked afterwards to define "Protein" of the total kind with a
  target of "0" holds that refusal instead, against defining a commitment

## REMOVED Requirements

### Requirement: A commitments screen changes a commitment on either of its lists
**Reason**: split into the two requirements added below — which act a change performs, and what a
change is refused for — with no change of behaviour.
**Migration**: every scenario of this requirement is carried verbatim to one of the two, thirteen to
the first and eight to the second; no test moves.

## ADDED Requirements

### Requirement: A commitments screen works out which act a change on either of its lists needs

A commitments screen SHALL change a commitment on either of its lists from four things and no others
— a name, a rhythm, the day it is kept from, and the category, which may be none — and SHALL work
out from them which of two acts the change needs. On a different name, a different day kept from, or
both, on the rhythm it already runs on, it SHALL carry every record of the commitment over at the
record place and then change it for the changed one at the roster place, in the place the roster
holds it; every past day afterwards answers about the changed commitment as it did about the one it
replaced. On a different rhythm it SHALL supersede: the commitment is kept until the day before the
day the screen was handed and held removed, and the one the four name, kept from the day the screen
was handed, takes its place; no record SHALL move and no past day SHALL change its answer. On both
in one save it SHALL carry over first and supersede second, so the superseded commitment carries the
new name and the corrected day it was kept from, and the commitment taken on the new name, the new
rhythm and the day the screen was handed.

On an interval rhythm the day kept from is also the rhythm's start date, so a change naming a
different day SHALL form the changed commitment's schedule from that day and the days it was due on
before are not the days it is due on after; on the other three, dueness does not depend on that day,
so moving it earlier only widens the window and every day already recorded on SHALL stay due. The
record place SHALL be written before the roster place, and where nothing is carried over nothing
SHALL be written at the record place at all.

The kind its days take is not one of the four and SHALL NOT change: the changed commitment SHALL be
of the kind the one it replaces is of and SHALL carry whatever that kind carries unchanged, a number
kind's range and a total kind's target alike. A change SHALL write the category it is given, and a
category of nothing but blank space SHALL take it off. A commitment its roster has stopped keeping
SHALL be changed in name and category only, and SHALL stay stopped on the day it was kept until.
Where the four things name the commitment that is already there, and the category it is already
under, the screen SHALL change nothing, SHALL write nothing at either place and SHALL refuse
nothing.

#### Scenario: a commitment renamed through a commitments screen is drawn under its new name, in the place it held

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym"
  is changed through it to the name "Gym 🏋️", on the rhythm and the day kept from it already has,
  under no category
- **THEN** nothing is refused
- **AND** what it keeps is three entries, named "Water plants", then "Gym 🏋️", then "Journaling"
- **AND** a roster store opened afterwards at that place holds those three commitments in that order

#### Scenario: every record of a commitment renamed through a commitments screen is carried over to the new name

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", on the rhythm and the
  day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** a store opened afterwards at that record place answers that "Gym 🏋️" was kept on Monday
  3 August 2026
- **AND** it answers that "Gym" was not kept on that day

#### Scenario: a commitment whose rhythm is changed through a commitments screen is kept until yesterday and the new one is taken on today

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, on the name and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Gym", saying "Tue, Thu"
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with the
  commitment on Monday, Wednesday and Saturday kept from 1 January 2026, and about Monday
  31 August 2026 with the one on Tuesday and Thursday kept from that day

#### Scenario: a rhythm changed through a commitments screen leaves every record already made standing

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category
- **THEN** nothing is refused
- **AND** a store opened afterwards at that record place answers that the commitment on Monday,
  Wednesday and Saturday was kept on Monday 3 August 2026
- **AND** the content at that record place is byte-for-byte what it was before the change

#### Scenario: a name and a rhythm changed in one save put the new name on the superseded commitment

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️" on a weekday-set
  rhythm of Tuesday and Thursday, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Gym 🏋️" on Monday, Wednesday and Saturday, kept from 1 January 2026
- **AND** what the screen keeps is one entry, named "Gym 🏋️", saying "Tue, Thu"
- **AND** a store opened afterwards at that record place answers that "Gym 🏋️" on Monday, Wednesday
  and Saturday was kept on Monday 3 August 2026

#### Scenario: the day a commitment is kept from is moved earlier through a commitments screen and the days it opens become due

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 August
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; and "Gym" is changed through it to the day kept from 1 June 2026, on the
  name and the rhythm it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is due on Monday
  1 June 2026 and on Monday 3 August 2026

#### Scenario: the day an interval commitment is kept from is moved earlier and every day it is due on moves with it

- **WHEN** a commitment named "Contact lenses" on an interval rhythm of 14 days, kept from Wednesday
  1 July 2026, is taken on at a roster place; a commitments screen is opened at that roster place as
  of Monday 31 August 2026; and "Contact lenses" is changed through it to the day kept from Monday
  29 June 2026, on the name and the rhythm it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is due on Monday 29 June
  2026 and on Monday 13 July 2026
- **AND** it is not due on Wednesday 1 July 2026

#### Scenario: a change that names what is already there changes nothing and refuses nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, under the category "Sport", is taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; and "Gym" is changed through it to exactly
  the name, rhythm, day kept from and category it already has
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Sport", holding one entry named "Gym"
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a stopped commitment renamed through a commitments screen stays stopped, on the day it was kept until

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", on the rhythm and the day
  kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it has stopped is one entry, named "Gym 🏋️"
- **AND** what it keeps is one entry, named "Journaling"

#### Scenario: a commitment of the number kind changed through a commitments screen keeps the kind its days take

- **WHEN** a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026, is taken on at a roster place; a commitments
  screen is opened at that roster place as of Monday 31 August 2026; and "Weight" is changed through
  it to the name "Bodyweight", under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is of the number kind
  with a range of 40 to 150

#### Scenario: a rhythm changed on the first date the calendar supports supersedes as of that day itself

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 1583, is taken on at a roster place; a commitments screen is opened at that roster place
  as of 1 January 1583; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about 1 January 1583 with both
  commitments, and about 2 January 1583 with the one on Tuesday and Thursday alone

#### Scenario: a category set through a commitments screen's change is kept at the roster place

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; and "Creatine" is changed through it to
  the category "Supplements", on the name, the rhythm and the day kept from it already has
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** a commitments screen opened afterwards at that place as of that same day keeps those same
  two groups

#### Scenario: a category taken off through a commitments screen's change draws its commitment among the ones under none

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Creatine" is changed through it to a category of three spaces, on the name,
  the rhythm and the day kept from it already has
- **THEN** nothing is refused
- **AND** what it keeps is one group, with no category, holding "Creatine" and then "Gym"

### Requirement: A commitments screen refuses a change it cannot make

A commitments screen SHALL refuse a change in the words it already uses: a name that says nothing, a
weekday set with no days in it, a rhythm number the calendar will not take, a commitment the roster
already holds, and a place that could not be written. A change whose result the roster already holds
SHALL be refused, kept, stopped or removed alike. A place that could not be written SHALL cover the
record place as well as the roster place, and the two SHALL be told the same way.

Two refusals are this change's own, and each SHALL be told apart from the other five and from each
other. A change asking for a different rhythm or a different day kept from on a commitment its
roster has stopped keeping SHALL be refused as **a change a stopped commitment does not take**. A
change SHALL be refused as **a day already recorded on that the change would leave not due** where
any day the commitment has a record on is a day the changed commitment is not due on, and no record
SHALL be carried over to a day it could not have been made on; moving the day an interval commitment
is kept from earlier by a whole number of intervals leaves every day already recorded on due and
SHALL NOT be refused.

A commitments screen asked to change a commitment on neither of its lists, one its roster has
removed included, SHALL do nothing and SHALL say nothing. Nothing SHALL be kept at either place by a
refused change, and neither of the screen's lists SHALL move.

#### Scenario: moving the day a commitment is kept from past a day it has a record on is refused

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 June 2026,
  is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record place; a
  commitments screen is opened at that roster place and that record place as of Monday
  31 August 2026; and "Gym" is changed through it to the day kept from 1 September 2026, under no
  category
- **THEN** it is refused as a day already recorded on that the change would leave not due, told
  apart from a place that could not be written
- **AND** what the screen keeps is one entry named "Gym", and the content at both places is
  byte-for-byte what it was immediately after the screen was opened

#### Scenario: moving the day an interval commitment is kept from off a day it has a record on is refused

- **WHEN** a commitment named "Contact lenses" on an interval rhythm of 14 days, kept from Wednesday
  1 July 2026, is taken on at a roster place; a tick for it on Wednesday 15 July 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of Monday
  31 August 2026; and "Contact lenses" is changed through it to the day kept from Monday 29 June 2026,
  on the name and the rhythm it already has, under no category
- **THEN** it is refused as a day already recorded on that the change would leave not due, told apart
  from a place that could not be written
- **AND** what the screen keeps is one entry named "Contact lenses", and the content at both places is
  byte-for-byte what it was immediately after the screen was opened

#### Scenario: an interval commitment's day kept from moved earlier by a whole number of intervals leaves every recorded day due

- **WHEN** a commitment named "Contact lenses" on an interval rhythm of 14 days, kept from Wednesday
  1 July 2026, is taken on at a roster place; a tick for it on Wednesday 15 July 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of Monday
  31 August 2026; and "Contact lenses" is changed through it to the day kept from Wednesday 17 June
  2026, on the name and the rhythm it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is due on Wednesday
  17 June 2026 and on Wednesday 15 July 2026
- **AND** a store opened afterwards at that record place answers that the commitment kept from
  Wednesday 17 June 2026 was kept on Wednesday 15 July 2026
- **AND** it answers that the commitment kept from Wednesday 1 July 2026 was not kept on that day

#### Scenario: a change whose result the roster already holds is refused, whichever state it holds it in

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; and "Gym" is changed through it to the
  name "Run", under no category
- **THEN** it is refused as a commitment already kept
- **AND** what it keeps is two entries, named "Gym" and then "Run"
- **AND** the same change is refused the same way on a screen whose roster had stopped keeping "Run"
  as of Sunday 30 August 2026, and on one whose roster had removed it as of that day

#### Scenario: changing the rhythm or the day kept from of a stopped commitment is refused

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; "Gym" is stopped there as of Sunday 30 August 2026;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is
  changed through it to a weekday-set rhythm of Tuesday and Thursday, under no category
- **THEN** it is refused as a change a stopped commitment does not take, told apart from a commitment
  already kept and from a place that could not be written
- **AND** a change to the day kept from 1 June 2026 on that same stopped commitment is refused the
  same way
- **AND** what it has stopped is one entry, named "Gym"

#### Scenario: a commitments screen asked to change a commitment on neither of its lists does nothing and says nothing

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is removed there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", under no category
- **THEN** nothing is refused
- **AND** what it keeps is one entry named "Journaling" and what it has stopped is nothing
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a change a commitments screen could not keep leaves both places as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; what is at that place is then made impossible to write; and "Gym" is
  changed through it to the name "Gym 🏋️", under no category
- **THEN** it is refused as a place that could not be written, told apart from a commitment already
  kept
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a change refuses a name that says nothing, a rhythm due on no day and a rhythm number the calendar will not take

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is changed through it three times — once to the name "   ",
  once to a weekday-set rhythm listing no weekdays, and once to a day-of-the-month rhythm of the 32nd
- **THEN** the three are refused as a name that says nothing, a rhythm due on no day and a rhythm
  number the calendar will not take, each told apart from the others
- **AND** what it keeps is one entry, named "Gym", after all three
