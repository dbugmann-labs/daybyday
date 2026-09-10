# commitment Specification

## Purpose

Describes what a commitment is to DayByDay — the name a person gave something they owe themselves,
the schedule deciding which days it is due on, and the day from which they have been keeping it —
and how it answers whether it is due on a calendar date. The `schedule` capability owns the rules;
this one owns the thing that carries one, which is what a screen lists, what a person reads, and
what a tick is eventually recorded against.

## Requirements

### Requirement: A commitment is a name, a schedule, and the day it is kept from

A commitment SHALL be exactly four things: a name, the schedule that decides which days it is due
on, the calendar date from which it is kept, and the kind of record its days take. It SHALL carry
nothing else. In particular it has no identifier of its own, no record of what was ticked, no
position in a list, and no state that can be paused or archived — a commitment is what it is made
of, and nothing more. The name it was given SHALL be readable back, and so SHALL the kind.

The first three SHALL be required. The system MUST NOT form a commitment without a day it is kept
from, and MUST NOT supply one of its own in place of a missing one: it cannot know what day it is,
because the present moment is not something this capability is allowed to consult, and a default of
any other kind would be a guess about a person's history. The kind is the one part with a default,
and that default is the plain kind — a tick — because a day that takes a tick is what every
commitment took before there was a choice.

Two commitments SHALL be the same commitment when their name, their schedule, the day they are kept
from and their kind are all the same, and SHALL be different commitments when any of the four
differs. This is what "carries nothing else" means where it can be observed: a commitment holds no
hidden identity that would make two commitments a person would call identical distinguishable to the
system. A weight and a mood taken on the same rhythm, from the same day, under one name are two
commitments, because what their days hold is not the same thing.

The day a commitment is kept from is a calendar date, so it already names a day that exists inside
the supported years and needs no validity rule of its own here. It is deliberately not a record of
when the commitment was entered into the app: a person who has been going to the gym since June may
say so, and the day they are keeping it from is then in the past.

The kind is fixed when the commitment is formed and SHALL NOT change afterwards. There is no way to
move a commitment from one kind to another, and there is deliberately none: a record embeds the
whole commitment by value, so a part that changed would orphan everything already recorded against
it.

**Changing a commitment is now a thing a person does, and none of it happens here.** A commitment
still carries nothing else and still has no identity of its own, so no part of one is mutable and
nothing about this requirement moves. What changes is carried one level up and one capability across:
a **different name** or a **different day kept from** is a second commitment that every record of the
first is carried over to (`record`), put in the place the roster holds the first in; a **different
rhythm** is a second commitment the roster takes on in the first's place while holding the first
**removed**, kept until the day before. Neither re-keys anything, because in both cases every record
still embeds a commitment the roster still holds. The **kind** is the one part no change reaches at
all, and that is the ground ADR-1030 stands on: what a person keeps is not something they can edit
into something else. ADR-1023 and ADR-1030, both amended for `add-commitment-editing` (#148).

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

The system SHALL refuse to form a commitment whose name is empty, or whose name is made only of
whitespace, and MUST refuse it rather than adjust it: it MUST NOT trim the name down to nothing and
accept the result, and MUST NOT substitute a placeholder of its own such as "Untitled". A name of
nothing but blank space names nothing, so it picks out no commitment for the person reading a list
of them — the same refusal, for the same reason, that stops a calendar date being formed from a
combination that names no day.

Every other name SHALL be accepted, and SHALL be stored exactly as it was given. There is no upper
bound on a name's length, no restriction on the script it is written in, no character the system
reserves, and no name it rewrites: a commitment's name is the words its owner chose, including any
blank space at the start or the end of them. Tidying what a person typed belongs where they typed
it, not in the rule that decides what a commitment is.

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

A commitment's kind SHALL be exactly one of four: a **tick**, a **number**, a **note** or a
**total**. There SHALL be no fifth, and no way to hold none: a commitment's days take something,
and what they take is decided when the commitment is defined rather than the first time a day is
entered.

Each kind SHALL carry its own parameters and no others. A tick SHALL carry nothing and a note SHALL
carry nothing: both are made of the fact that they are there. A number MAY carry a **range**, and a
total MUST carry a **target**. A range SHALL belong to the number kind and a target to the total
kind, and the system MUST NOT offer any way of attaching either to a kind it does not belong to —
this is a rule about what can be *formed at all* rather than one about what is refused when it is
tried, so there is no such thing as a note with a target to write a scenario about. A total SHALL
NOT be formed without a target: a total whose sum has nothing to reach is a number a person only
wants to watch, which is the number kind and not this one.

A commitment SHALL read its kind back, along with whatever that kind carries. It is not enough that
the commitment holds one: a caller that has to decide what to offer a person before anything has
been recorded — the row on a day screen, the screen a commitment is defined on — has no other way to
know, and a kind it cannot read is a kind that may as well not be there.

A commitment formed without a kind being named SHALL be of the plain kind, a tick. This is the one
part of a commitment with a default, and it has one because every commitment that existed before
kinds did is a tick and a stated default is what keeps that true in one place rather than at every
call. It is a default and not a fallback: naming a kind is always allowed, and naming the tick
explicitly SHALL give the same commitment as naming nothing.

The kind SHALL NOT enter into whether a commitment is due. Due-ness is the schedule and the day the
commitment is kept from, and nothing else; a number commitment is due on its days exactly as a tick
commitment is, and it is what a due day *takes* that the kind decides.

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
SHALL be required — a range is both ends or neither, and a number commitment declaring only a floor
or only a ceiling is not a thing this system has. A commitment of the number kind that declares no
range at all SHALL be a commitment of the number kind, and any number is then a number for it.

Both ends SHALL be inclusive: a mood of one to ten takes 1 and takes 10. The system MUST NOT form a
range whose lowest is above its highest, and MUST refuse rather than adjust — it MUST NOT swap the
two ends, and MUST NOT keep one of them and drop the other. This is the refusal that stops 30
February being a calendar date and 32 a day of the month, made where the range is formed so that
every caller gets it: a screen refusing the same thing in words a person can read is #142's, and it
is that refusal surfaced rather than a second one.

A range whose lowest and its highest are equal SHALL be a range — a range of exactly one value,
which is a strange thing to want and not a contradiction. A range end MAY be negative and MAY be
zero: a temperature and a weight change both go below zero, and nothing about a range says which
numbers a person is allowed to care about.

A value that is not a number SHALL NOT be an end of a range. Neither end may be one, and this is
stated rather than left to the comparison, because a comparison against a value that is not a number
answers *true* in one direction and *false* in the other and would let one through.

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
zero, and MUST NOT form one below zero: a target of zero is reached before anything has been added,
so every day of that commitment would be kept the moment it was defined, which is the opposite of
what a total is for. It MUST refuse rather than adjust — it MUST NOT substitute a target of its own
and MUST NOT treat a refused target as no target, because a total without a target is not a total.

A target MAY have a decimal fraction. It is the same kind of number a day's additions are made of,
and 0.5 of a dose is a target a person can mean; the system MUST NOT round it, MUST NOT require a
whole number, and MUST NOT attach a unit to it — the commitment's name says grams.

A value that is not a number SHALL NOT be a target, for the same reason it is not an end of a range.

What a target *does* — the sum a day's additions have to reach for that day to be kept — is not this
requirement's and is not this change's: it is `record`'s, once a total can be recorded at all. This
requirement fixes only what a target is and what refuses to be one.

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
adds nothing to its schedule's answer and takes nothing away: the system MUST NOT consider the
commitment's name, the current time, the device's time zone, the locale, or whether the commitment
has been ticked. As throughout `schedule`, the question is asked of a calendar date rather than of
the present moment, so a date in the past answers the same way today as it did when it was today.

Delegation is the whole of the rule from that day onwards, and it holds for every schedule shape the
`schedule` capability defines and for every shape added to it later, without this requirement
changing. It holds equally for a schedule that is due on no date at all: such a commitment SHALL
answer that it is not due, rather than the system treating it as an error, exactly as `schedule`
requires of the schedule itself.

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
its schedule says about that date. The day it is kept from is where the commitment begins to be
owed; the dates before it are dates on which nothing had been committed to, and the system MUST NOT
answer that a commitment was due on one of them.

This is what stops the product inventing a history of failures. Because an unticked due day reads as
a day the commitment was missed, a rule anchored only to the calendar would fill every earlier year
with misses nobody could ever have avoided: a commitment on Mondays, Wednesdays and Saturdays, kept
from this week, would otherwise answer *due* for every such day back to the first year the system
supports. A record of what was actually kept cannot open with a fabricated one.

The rule applies to every schedule shape alike, and it is a floor rather than a phase: the day a
commitment is kept from does not have to be a day its schedule is due on, and it does not shift the
schedule to begin there. When the schedule is an interval of days, its own start date and this floor
are separate and both apply — the interval decides which dates the rhythm lands on, this requirement
decides that landings before the floor are not due, and a start date earlier than the floor is
therefore a rhythm whose first occurrences are simply never owed.

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

A roster SHALL hold commitments, in an order it holds, and SHALL read back, in that order, every
commitment it has not stopped keeping. A roster that has been given no commitment SHALL
hold none, and SHALL be an answer rather than a refusal: a person who keeps nothing yet has an empty
roster, not a missing one. There SHALL be no upper bound on how many commitments a roster holds.

**The order SHALL be the person's.** The order the commitments were taken on is its initial value
and the place a newly taken-on commitment lands, and **moving** is the only thing that ever changes
the order of the commitments a roster already holds. Two things put a commitment somewhere other than
last, and neither is a move: **changing** one commitment for another puts the second exactly where
the first was, and **superseding** takes the second on in the place the first held. Both are a person
correcting or replacing a row they are looking at, so a row that jumped to the bottom of the list
would be the roster undoing an order they set. A move takes one of exactly two things and there is no third: a **commitment**, which goes where
the move says on its own, or a **group**, which takes every commitment under one category with it as
a block. A roster MUST NOT sort its commitments by name, by the day each is kept from, by
the schedule each runs on, by the category each is under, or by any other property of them: it still
has no order of its own to invent, because day one's commitments are all kept from the same day, so
an order taken from that day would leave them tied and the roster choosing between them, and an
order taken from a name would be a rule about the owner's own words. None of that argues against the
owner choosing, and only they can, because what an order is for — which rows a thumb reaches first —
is not something a roster can work out. This is the same reason a day view orders nothing of its own
and shows what it was handed in the order it was handed it. ADR-1037.

**The order runs over everything the roster holds**, kept, stopped and removed alike, as one
sequence. A roster holds one order and not one per state, so a commitment it has stopped keeping or
removed has a place in that sequence exactly as a kept one does, keeps that place while it is
stopped or removed, and returns to it when it is taken up again.

A roster SHALL hold commitments and, for each commitment, at most three further things: the
**category** that commitment is under, where it is under one; the day that commitment was **kept
until**, where the roster has stopped keeping it or removed it; and **that it was removed**, where
it has been removed. It holds nothing else. It MUST NOT give a commitment an identifier, a position
a commitment can be asked for, a record of the day it was added, or any other state of its own, and
it MUST NOT alter a commitment it holds: a commitment read back out of a roster SHALL be the
commitment that was put in, with the same name, the same schedule and the same day it is kept from.
**Changing one commitment for another is not altering one**, and the difference is the whole of why a
change is safe: the roster is handed a second commitment, already formed, and puts it where the first
was — it edits no part of anything, and the commitment it reads back afterwards is the one it was
handed, exactly as before. It still holds no link between the two, and being changed or superseded
gives neither of them a fifth part.
None of the three is ever the commitment's: a commitment SHALL NOT gain a fifth part by being
stopped, by being removed or by being put under a category, and it SHALL go on answering whether it
is due on a date exactly as it did before. **The ban on a position is a ban on a read.** Nothing asks
a roster where a commitment is, and moving one hands a place **in** rather than reading one out; the
sequence is observable only as the order the roster reads its commitments back in.

**A category is read back where a position is not, and the difference is what the read would mean.**
A position is something the roster worked out about a commitment; a category is a word the person
chose and put there, so reading it back is reading back what they said. The roster answers it as
part of the **groups** it reads its commitments back in, and nothing asks it about one commitment on
its own.

**Kept, stopped and removed are the three states a roster holds a commitment in**, and a commitment
it holds is in exactly one of them. A commitment it is keeping has no kept-until day and has not been
removed; one it has stopped keeping has a kept-until day and has not been removed; one it has
removed has a kept-until day and has been removed. A category is not a fourth state and cuts across
all three: a commitment in any of them is under a category or under none. **A roster never lets a
commitment go**: nothing takes a commitment out of a roster, so a roster that has ever been given a
commitment SHALL NOT be the same roster as one that has been given none, whatever has since been
done to what it holds.

A roster SHALL NOT consult the present moment, the device's clock, its time zone or its locale, and
SHALL NOT be asked what day it is; every date it works with SHALL be one it was handed. It SHALL
judge a date in one way only: against a day it was told a commitment was kept until. It MUST NOT
judge a commitment's own day it is kept from, MUST NOT judge a schedule, and MUST NOT decide whether
a commitment is due — a commitment kept from a day long past and a commitment kept from the last
date the system supports are held alike, and whether either is due on any date is the commitment's
own answer and not the roster's.

A roster SHALL be a value. Two rosters holding the same commitments in the same order, each in the
same one of the three states, each under the same category where it is under one, and each with the
same kept-until day where it has one, SHALL be the same roster, and two holding the same commitments
in a different order SHALL be different rosters, because the order is one of the things a roster
holds. Adding a commitment to a roster, stopping one, removing one, moving one or putting one under
a category SHALL leave every other roster untouched, so a roster that was copied before any of the
five SHALL still hold what it held.

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

A roster SHALL refuse a commitment equal to one it is already keeping — one it holds and has neither
stopped keeping nor removed. Refusing SHALL leave the roster exactly as it was — the same
commitments, in the same order, with the one already held keeping the position it had **and the
category it is under** — and the roster SHALL report that the commitment was not added. **A category
offered alongside a commitment the roster is already keeping SHALL change nothing**: the category is
held on the roster's entry rather than on the commitment, so it is not one of the things that decide
whether two commitments are the same one, and a refusal that quietly recategorised would be a change
made by an ask that was turned down. Adding a commitment a roster does not hold at all SHALL place
it after every commitment already there, **under the category it was offered under**, and SHALL
report that it was added; a commitment offered **without a category being said at all** SHALL be
added under none.

**Equal means equal in the whole of what a commitment is, and a kind is more than which of the four
it is.** Two commitments alike in name, schedule and the day they are kept from, both of the number
kind, are the same commitment only where the **range** that kind carries is the same range — and a
range of 1 to 10, a range of 1 to 5 and no range at all are three different things to say about one
name. A roster that compared the kind while ignoring what it carries would refuse a commitment a
person deliberately declared differently, and there would be no way to say so twice; a roster that
compared nothing about the kind would refuse two commitments this capability has said since
`add-commitment-kind` are two. It compares whole values, and a **target** is the same story on the
total kind.

**A commitment may be offered with a category or without one, and the two are different asks.** A
commitment offered with a category is offered by something that has a category to say — a form a
person has just filled in — and the category it says is applied. A commitment offered without one is
offered by something with nothing to say about categories, and the roster SHALL then leave the
category it holds for that commitment exactly as it is: none for a commitment it does not hold at
all, and whatever it was for a commitment it is taking up again. There is no third form of the ask
and no way to say "leave it alone" while also saying a category, because saying nothing is what
leaving it alone is.

A commitment the roster has stopped keeping is one it still holds, and offering it again SHALL take
it up again rather than being refused. **A commitment the roster has removed is one it still holds
too, and offering it again SHALL take it up again in exactly the same way** — that is the one way
back from a removal, and it exists because a roster never lets a commitment go. In both cases the
roster SHALL drop the day that commitment was kept until, SHALL no longer hold it as removed, SHALL
read the commitment back once more among the commitments it keeps, in the place it has rather than
at the end, **SHALL put it under the category it was offered under where a category was said,
whatever category it was under before, and SHALL leave the category it is under exactly as it is
where none was said,** and SHALL report that the roster now keeps it — the same report an addition
makes, because it says the same thing. It SHALL NOT hold the commitment twice, and there SHALL be no
second way to take one up again: offering it is the way, whichever of the two states it was in.

**The offered category wins on a commitment taken up again, and that is the decision.** A commitment
is offered again with a category by a person filling a form in, and the category on that form is what
they are saying now; keeping the old one would be the roster overriding them, and there would then be
no way to take a category off a commitment while taking it up again. Being offered under no category
therefore takes the category off. Offering it again *without saying a category* — which is what a
screen's one tap on a stopped commitment does, since that tap asks for nothing — leaves the category
alone, so a commitment taken up again that way comes back under the category it was under.

Taking a commitment up again SHALL change what the dates between the day it was kept until and the
day it was offered again answer about that commitment, and that is the decision rather than an
oversight. A roster holds at most one kept-until day for a commitment and holds no span of them, so
a commitment with no kept-until day is one it was keeping on every date. The alternative — refusing,
so that starting again means a commitment kept from a different day — was weighed and rejected: it
leaves a mis-tapped stop with no way back, and the commitment that came back would be a different
one, losing the place it has and starting a fresh history. What was actually done on
those days is untouched either way, because that is the ticks and no tick moves. What a screen
offers, and whether it says that the days between will read as kept, is the screen's.

Reporting is part of the refusal and MUST NOT be dropped. A caller that does not care may ignore
what it is told, but a caller that does care cannot recover a report that was never made: doing
nothing and saying nothing is indistinguishable to a person from having added a second commitment,
which is the one thing a roster exists to prevent. Whether anything is said on a screen, and in what
words, is not this requirement's — it is what a screen does with the report.

Two commitments are the same commitment when their name, their schedule, the day they are kept from
and the kind their days take are all the same, and a roster SHALL use those four and nothing else to
decide what it already holds — when it refuses one it is keeping, and when it takes one up again
that it had stopped or removed. **The category is expressly not a fifth**, in either direction: a
commitment offered under one category and held under another is still the commitment the roster
holds, and two commitments alike in all four parts are still one commitment however they are filed.
A roster MUST NOT invent a coarser sameness of its own either: two commitments
alike in name but differing in schedule, in the day they are kept from or in the kind their days
take are different commitments and a roster SHALL hold both, and two names differing only by blank
space are different names, because a commitment's name is stored exactly as it was given and tidying
it belongs where a person typed it. A weight and a mood kept under one name, on one rhythm, from one
day differ in what their days hold and are two commitments; a roster judging them alike would leave
a person unable to say which of the two a screen was pointing at.

This is why the refusal exists at all. A commitment carries no identifier, so a roster holding two
commitments a person would call identical could not be told which of them to stop keeping, which of
them to remove, which of them to change, or which of them a screen was pointing at. There is nothing
to tell them apart by, and so there must not be two.

A roster SHALL refuse nothing else that it is offered to add. It MUST NOT judge a name, a schedule,
a day a commitment is kept from, a kind or a category — anything that is a commitment at all was
already accepted when the commitment was formed, and a range that could not be a range or a target
that could not be a target never reached a commitment to be offered here — it MUST NOT refuse on how
many commitments it holds, and it MUST NOT refuse on a date. What a roster refuses when it is asked
to *stop* keeping a commitment, and when it is asked to *remove* one, are separate rules, and this
one neither states them nor narrows them.

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

A roster SHALL stop keeping a commitment it holds, on being given that commitment and a calendar
date: the day the commitment was **kept until**, which is the last day it was kept. Stopping SHALL
take the commitment out of the commitments the roster reads back, SHALL record the day it was kept
until against it, and SHALL report that the roster stopped keeping it. Everything else the roster
holds SHALL be exactly as it was, in the order it was in.

The roster SHALL refuse to stop keeping a commitment in exactly three cases, and SHALL report each
rather than doing nothing silently, for the same reason a refused addition is reported:

- a commitment the roster does not hold at all;
- a commitment it has already stopped keeping, whose kept-until day SHALL stand as first given; and
- **a commitment it has removed**, whose kept-until day SHALL stand as first given in the same way.
  A removal is a last state: there is nothing a stop could add to it, and a stop that reached one
  would move a day a person can no longer see either list to check.

A day once given SHALL NOT move for as long as the roster has stopped keeping that commitment or has
removed it. This is what makes stopping safe to build on: no second stop can slide a boundary a
person cannot see, and every date's answer about a stopped commitment is fixed while it stays
stopped, in the way ADR-1013 fixes that a past day's answer does not change once given. A roster
asked to stop a commitment it does not hold, one it has already stopped, or one it has removed SHALL
be left exactly as it was.

Taking a commitment up again clears the day it was kept until, and is the only thing that does — the
rule is *A roster refuses a commitment it already holds*, and it is a deliberate act of the person's
that reports itself rather than a day moving underneath them. A commitment taken up again SHALL be
one the roster can stop keeping again, on whatever day it was kept until the second time, and the
refusal above SHALL apply to it again from that moment.

The roster SHALL refuse on no date. Any calendar date the system supports SHALL be accepted as a day
a commitment was kept until, including the first and the last, and including a date earlier than the
day that commitment is kept from: such a commitment is one the roster was keeping on no date at all,
which is what changing your mind before starting looks like, and the roster MUST NOT treat it as an
error. As everywhere else, the roster SHALL NOT ask what day it is: the day a commitment was kept
until is handed to it, never worked out, so it MUST NOT refuse a day for being in the future or
accept one for being in the past.

Stopping SHALL change nothing about the commitment itself and nothing about what has been recorded
against it. A commitment that has been stopped SHALL answer whether it is due on a date exactly as
it did before, and every tick already recorded against it SHALL stand — a tick is not the roster's,
and the roster stopping a commitment is not a person taking anything back.

A roster SHALL be a value here too: stopping a commitment SHALL leave every other roster untouched,
and two rosters differing only in the day one commitment was kept until SHALL be different rosters.

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
stopped keeping on that date: every commitment it holds that it has neither stopped nor removed, and
every commitment it has stopped **or removed** whose kept-until day is that date or later. The
answer SHALL be in the order the roster holds them, the same order it reads them back in, with a
stopped or removed commitment in the place it has rather than at either end. Moving a commitment
therefore changes the order every date answers in, and changes nothing else about any date: a move
is dated by nothing and moves no kept-until day.

**A removed commitment is answered exactly as a stopped one is, and that is the whole of what
removal costs a past date: nothing.** A person who gets rid of a commitment for good is saying
something about the days ahead, never about the days behind, so every date up to and including the
day it was kept until answers with it after the removal exactly as it did before. This is the one
place the difference between stopped and removed is deliberately invisible; the difference lives on
a screen, where a removed commitment is listed nowhere.

The day a commitment was kept until is the last day it was kept. The roster SHALL answer with that
commitment on that date, and SHALL NOT answer with it on the day after it or on any later date.

A commitment the roster has taken up again after stopping or removing holds no kept-until day, so
the roster SHALL answer with it on every date, the dates between the day it was kept until and the
day it was taken up again included. Those dates SHALL therefore answer differently after a
commitment is taken up again from the way they answered while it was stopped or removed. That is the
one thing that changes a past date's answer in this capability, it happens only because a person
asked to take the commitment up again, and it reaches no further than this answer: every tick
already recorded stands, so what was actually done on those days is unchanged.

The roster SHALL apply nothing else to the answer. It MUST NOT apply a commitment's own day it is
kept from, MUST NOT apply its schedule, and MUST NOT consider whether anything has been ticked: a
commitment kept from a date later than the one asked about is in the answer, because the day a
commitment is kept from is the commitment's own floor and the commitment answers for it. A day drawn
from this answer asks each commitment whether it is due and gets that floor there, which is why
stating it twice would be two places to be wrong rather than one.

A roster holds no record of the day a commitment was added, so a date before anything was taken on
SHALL be answered no differently from any other: the answer is a question about what has been
stopped and about nothing else.

The answer SHALL be one every date can be asked for, never a refusal. A roster holding nothing SHALL
answer with nothing, on every date. The roster SHALL NOT ask what day it is to answer, so the same
roster asked about the same date SHALL answer the same way today, tomorrow and on the day the date
itself falls.

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

A roster store SHALL be opened at a place, and SHALL hold a roster: every commitment taken on
through it, in the order the roster holds them, against each commitment the category it is under,
and against each commitment it has stopped keeping
or removed, the day that commitment was kept until, and against each commitment it has removed, that it
was removed. Opening a roster store at a place where nothing has been kept SHALL give a roster
holding nothing rather than an error — that is what the first launch looks like, and it is the only
time a roster store opens holding nothing.

A commitment taken on through a roster store SHALL be kept at that place before the store reports it
taken on, so that a store opened at the same place afterwards — by the app opened again, or by
anything else, and whether or not the first store was ever closed — holds it. Stopping a commitment
SHALL be kept the same way, and so SHALL removing one, moving one, **moving a whole group**, putting
one under a category, **changing one commitment for another**, **superseding one with another**, and
taking one up again. There is no
separate step at which a roster store is saved: the app can be stopped at any moment without
warning, and a commitment waiting to be saved would be one a person believes they have taken on. A
roster store that cannot keep a change MUST refuse it and MUST NOT hold it: the roster a store
reports is never ahead of what is kept at its place.

A roster store SHALL report exactly what the roster reports, and MUST NOT turn a roster's own refusal
into an error. Offering a commitment the roster is already keeping, asking it to stop keeping one it
does not hold, asking it to stop keeping one it has already stopped or removed, and asking it to
remove one it does not hold or has already removed, asking it to move one it is not keeping or
to move one to an offset outside the commitments it is keeping, **asking it to move a group no
commitment it is keeping is under, or to move a group to an offset outside the groups it is keeping
that are under a category**, **asking it to change a commitment it does not hold or to change one
into a commitment it already holds**, **asking it to supersede a commitment it is not keeping or to
supersede one with a commitment it already holds**, and asking it to put one it is not
keeping under a category each leave the roster exactly as it was — so nothing is kept at the place,
and the store says what the roster said. **A change that leaves
the roster exactly as it was SHALL keep nothing at the place either, and SHALL still report what the
roster reported** — a move that put a commitment back where it already was under the category it was
already under, **a group move that put a group back where it already was**, a category change
that put a commitment under the category it was already under, **and a change of a commitment for
itself under the category it was already under**,
are all such a change: a store keeps what a change made, and a
change that made none has nothing to keep. What a roster accepts, what it
refuses and what it takes up again are the roster's own rules, stated above, and a store adds nothing
to them and takes nothing away.

A roster store SHALL persist exactly what a roster is — each commitment with the name, the
schedule, the day it is kept from and the kind its days take that the commitment is made of,
together with whatever that kind carries; against each commitment the category it is under, and
that it is under none where it is under none; against each stopped or removed commitment the day it was
kept until; and against each removed commitment that it was removed — and nothing it invented. A
number commitment's range SHALL be kept where it has one and SHALL be absent where it has none, both
ends exactly as they were given; a total commitment's target SHALL be kept exactly as it was given,
decimal fraction and all, and MUST NOT be rounded, widened or narrowed on the way in or out. **A
category SHALL be kept exactly as it was given**, blank space at either end and all, and MUST NOT be
trimmed, case-folded, deduplicated against another category or turned into a reference to a list of
categories kept somewhere else: there is no such list, and the categories that exist are exactly the
words the commitments carry. It
SHALL keep the commitments in the order the roster holds them and read them back in that order,
because the order is one of the things a roster is — and it is the person's, so a store that
reordered would be overwriting a decision rather than tidying a history. A roster store MUST NOT
impose an order of its own, MUST NOT sort by name, by a day, by a category or by anything else, and
MUST NOT write its commitments grouped: the groups are a reading of the roster's one order and are
worked out again on every read, so a store that wrote them would be keeping the same fact twice. A roster read back SHALL be the same roster
that was kept, for every schedule shape, for every kind, for any name a commitment can have, for any
category a commitment can be under, for any
date the system supports, and for each of the three states a roster holds a commitment in. The store
MUST NOT key anything to the moment it was entered, MUST NOT record the day a commitment was taken
on, and MUST NOT pass a calendar date through an instant, a time zone or a locale on the way in or
out.

Roster stores at different places SHALL be independent of each other, and a roster store SHALL be
independent of any store keeping anything else: taking on a commitment, stopping one, removing one,
moving one, moving a group, putting one under a category, changing one for another or superseding one
MUST NOT change what is kept at any other
place. **A change of commitment reaches a record place as well, and a roster store is not what
reaches it**: carrying a commitment's records over is the `record` capability's, kept at its own place
by its own store, and whatever asks for both is what puts them in an order.

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
now, rather than refusing it, and SHALL read each such roster as the roster it was. Three earlier
forms exist. The form written **before a commitment carried a kind** holds no kind for any commitment, and
every commitment in it SHALL be read as being of the plain kind — a tick is what every one of them
was: reading them any other way would change what a person keeps, and refusing them would tell a
person who has kept a roster since before this change that they keep nothing. The form written
**before a commitment could be removed** holds nothing about removal for any commitment, and every
commitment in it SHALL be read as one the roster has not removed, which every one of them was. The
form written **before a commitment could be put under a category** holds nothing about a category for
any commitment, and every commitment in it SHALL be read as one the roster holds under no category —
which every one of them was, and which is an ordinary state rather than a gap, so nothing needs
inventing to fill it.

Reading a roster kept in an earlier form MUST NOT change what is at the place. A store writes on a
change being kept and at no other moment, so opening the app and doing nothing SHALL leave the
content byte-for-byte what it was, in the form it was already in. The next change kept there SHALL
be written in the form this app writes, whole, and everything the earlier form held SHALL still be
in it — the order the commitments were taken on, every day one was kept until, and every part of
every commitment.

**Each form SHALL be read as the shape that form has.** A roster store declares its form before
anything else in it is read, so what may be in it is known rather than guessed at. Whether a stored
roster says anything about removal SHALL agree with the form it declares, in both directions: a
roster store declaring a form written before a commitment could be removed and yet saying something
about removal SHALL be refused as content that is not a roster store, and so SHALL one declaring the
form this app writes and saying nothing about removal. **Whether it says anything about a category
SHALL agree with the form it declares in exactly the same two directions**: a store declaring a form
written before a commitment could be put under a category and yet saying something about one SHALL
be refused as content that is not a roster store, and so SHALL one declaring the form this app
writes and saying nothing about a category for a commitment. A commitment under no category is said
so rather than left unsaid, which is what lets the two be told apart at all —
reading it any other way would make the declared form decorative — every form would accept every
other form's shape — and would launder a file this app never wrote into a current-form one the next
time something was kept there. The
rule that a commitment carrying no kind is read as a tick is unchanged and is stated above; that is what
an *absent* part means where the part belongs to the commitment, and this paragraph is about what a
*form* is allowed to contain.

The forms a roster store reads SHALL be exactly the ones this app has written: the form it writes
now and every form before it. It SHALL NOT weaken the refusal of a form *later* than the one it
writes, which is a form it cannot know the shape of, and it SHALL refuse a form number it has never
written at all — one below the earliest — as content that is not a roster store, because a number no
version of this app ever wrote says nothing about the shape of what follows it.

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

Opening a roster store at a place that holds something this app cannot read as a roster store SHALL
be refused with an error. The store MUST NOT answer with a roster holding nothing in its place, MUST
NOT overwrite, move or delete what is there, and MUST NOT keep the part of it that could be read: the
whole is refused, so that whatever is at that place is still there, unchanged, for a person or a
later version of the app to recover. An honest error on opening is the failure the product can
survive; a list of commitments silently replaced by an empty one is a person told they keep nothing.

Three things this app cannot read as a roster store: content that is not a roster store at all; a
roster store written in a form later than the one this app knows, which a later version of the app
may have left behind; and a roster store holding something that could not be a roster — a commitment
that could not be formed, a date that names no day, the same commitment held twice, or **a commitment
held as removed with no day it was kept until** — because a roster that could not be formed is not one
this app wrote. The last of those follows from what the three states are: a removed commitment always
has a kept-until day, so an entry claiming removal without one describes a state a roster has never
been in.

**A commitment of the number kind carrying only one end of a range is one that could not be formed**,
and is refused with the rest. A **range** is both ends or neither, so a file holding a lowest without
a highest describes a commitment this app has never written and never could: there is no such value
to read it back as, and inventing the missing end would put a bound on a person's commitment that
nobody typed. This is stated rather than left to follow, because it is the one of the four that is a
fact about a *part* of a commitment rather than about the commitment or the roster, and it has been
refused and tested since `add-commitment-kind` without a scenario of its own to say so.

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
commitments that roster is keeping, **in groups**, in the order the roster answers with. A commitment
the roster has stopped keeping MUST NOT be in that list, and neither MUST a commitment the roster
has removed.

**A group is a category and the entries under it, and the screen makes none of them.** The groups,
their order, which entries are in each and which entries are under no category at all are the
roster's answer, read off it and drawn: a group sits where its first commitment sits in the order
the person set, the entries under no category come last in a group with no category, and within a
group the entries are in the roster's own order. This screen SHALL NOT sort the groups, SHALL NOT
put the group with no category anywhere but last, and SHALL NOT invent a group for a category no
commitment it keeps is under. Ordering the groups by name would be a rule about the owner's own
words, which is the argument the roster's order has always rested on, and a second thing working out
where a group goes is a second thing that could disagree with the first — which is exactly what
ADR-1037 refused for the order itself.

**What it keeps, read across its groups, is the commitments the roster is keeping and nothing else**
— the same commitments, and each exactly once. Grouping rearranges what is drawn and changes nothing
about what the roster holds, so a commitment given a category is drawn in that category's group while
staying exactly where the roster holds it, and taking the category off draws it back among the ones
under none, where it never stopped being.

An entry in the list SHALL be a commitment's name and the rhythm it runs on **in words**, and
nothing else. The words are the ones the `schedule` capability says for the schedule that
commitment carries, read off the commitment the entry is for: this screen composes none of them and
chooses none of them, so an entry and a day screen's row say one rhythm the same way. An entry
SHALL NOT say the kind its days take, which is the surface `add-kind-to-commitments-screen` (#142)
adds, and SHALL NOT say the day the commitment is kept from, which says when it began rather than
what rhythm it runs on. **An entry SHALL NOT say its category either**: the group it is drawn in
says it, and saying it twice would leave a screen able to say two different things.

Two commitments alike in name and unlike in rhythm are therefore two entries a person can tell
apart, which is what a rhythm beside a name is for. Two alike in name **and** in rhythm, unlike
only in the day they are kept from or the kind their days take, are still two entries a person
cannot tell apart, and that is accepted rather than refused. The roster refuses only a commitment
it is already keeping, and a screen refusing a name the roster allows would forbid the same thing
kept on two rhythms. **Two such entries are also the one case where a person removing one of them
must be careful**, because the name typed back matches both; which of the two is removed is the one
the removal was asked about, and never the one the typing picks out.

**The scenario below titled *two commitments alike in name and not in rhythm are two entries a
person cannot tell apart* is kept exactly as it was, and its title is now wrong.** Everything it
asserts still holds — two entries, both named "Vitamins", the first of which can be stopped — but
the entries say different rhythms, so a person can tell them apart, and the scenario after it says
so. It is kept because `openspec` 1.10.0 refuses a MODIFIED requirement that drops any scenario the
current spec has, and the only way to drop one is to rename the requirement, which moves the whole
block to the bottom of the spec at archive time. `design.md` § *Three scenario titles that are now
wrong* has the evidence.

A commitments screen SHALL ask its roster no date. What it lists is what a person keeps now; which
commitments a roster had not stopped keeping on a given date is the day screen's question and not
this screen's.

A roster holding nothing at all SHALL be listed as nothing at all, in no groups at all. A
commitments screen MUST NOT
take any commitment on of its own — day one belongs to the day screen and to the moment its roster
holds nothing (ADR-1027), and a second thing writing day one would take it on twice.

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
the rhythm it runs on in words, exactly as the first list is. A stopped commitment is never moved,
so that is the order it was taken on in for as long as nobody has moved a commitment past it. **A commitment the roster has removed
SHALL be in neither list**; every other commitment the roster holds SHALL be in exactly one of the
two and never in both.

**The list of what has been stopped SHALL NOT be grouped.** It is one flat list whatever categories
its commitments are under, and a stopped commitment's category is said nowhere on this screen. It is
not the list a person reads daily, and it is the shortest-lived of the two; grouping would double the
structure of the screen for the list that needs it least, and it would draw a heading for a category
no commitment being kept is under. A commitment the roster has stopped keeping goes on being under
the category it was under, so taking it up again from this list — which asks for nothing — draws it
back in that category's group, and nothing about that has to be shown here.

That a removed commitment is in neither list is the whole of what removal is on a screen. The roster
still holds it, every past day still draws it and every tick against it still stands; what has
changed is that a person is no longer offered it, anywhere, and the two lists are once more only the
things they have a decision to make about.

This second list exists because the roster's rule that offering a stopped commitment again *takes
it up again* cannot otherwise be reached from a phone. A person who had to retype a name, rebuild a
rhythm and match a day kept from exactly would in practice be making a different commitment, and a
roster every one of whose commitments has been stopped would be a day screen with no rows for ever.
It says a rhythm for the same reason the first list does: two stopped commitments alike in name are
as hard to tell apart as two kept ones, and this list is the one place a person picks which of them
to take up again.

A removed commitment has no such list, and that is the price of removal rather than an oversight:
the way back is to define the identical commitment again, which the roster takes as taking it up
again. A person who cannot reproduce the name, the rhythm and the day exactly cannot get it back,
which is what "for good" means and why the removal is confirmed by typing.

A roster that has stopped nothing SHALL list nothing as stopped.

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

A commitments screen SHALL define a commitment from five things and no others: a name, a rhythm,
the day it is kept from, the **category** to put it under, which may be none, and the **kind** its
days take. **Changing a commitment takes four of the five** — every one but the kind, which is set
when a commitment is defined and never changes, so a change is neither asked for one nor able to
produce one. One form still serves both acts; what a change does with the fifth field is show it and
never ask about it. The commitment so formed SHALL be taken on at the roster place before either of
the screen's lists says so, and SHALL then be last in what the screen keeps, in the group of the
category it was given, because that is
the place the roster gives it — **unless the roster already holds that commitment stopped or
removed, in which case it is taken up again in the place it has**, again because that is
the place the roster gives it. Defining is therefore the one way back to a removed commitment, and
the screen does nothing of its own to make it so: it hands the roster what the form said and reports
what the roster answers.

**The kind is one of the things that decide which commitment was named**, so two commitments alike in
name, rhythm and the day they are kept from but not in their kind are two commitments here exactly as
they are two in a roster. A screen already keeping "Weight" as a tick SHALL NOT refuse "Weight" as a
number as a commitment it already keeps, and defining "Weight" as a number SHALL NOT take a stopped
"Weight" tick up again. That is the roster's rule reported rather than a rule of this screen's, and
it is the honest answer to a person who has decided a tick is not what that day should take: the
commitment they had stays exactly as it was, with everything recorded against it, and the one they
have just described is a new one.

**A commitment taken up again by being defined again is put under the category the form carried**,
whatever category it was under before, and under none where the form carried none. That is the
roster's rule and not this screen's, and it is right here for the reason it is right there: the
person is looking at the form now, so what it says is what they are saying. Taking a stopped
commitment up again from the list of what has been stopped is a different act, asks for nothing, and
leaves the category alone.

**A category made of nothing but blank space is no category, and SHALL NOT be refused.** Unlike a
name, a category is optional, so a field with nothing in it and a field with three spaces in it both
say the same thing — that this commitment is under none — and emptying the field is how a category is
taken off. Every other category SHALL be accepted and kept exactly as it was given, blank space at
its ends and all: there is no length limit, no restricted script and no reserved word, because a
category is the owner's own words in exactly the way a name is.

A **rhythm** SHALL be one of four, and all four SHALL be offered: a weekday set, a day of the
month, an interval of a whole number of days, and a weekly quota. A rhythm carries nothing the
calendar does not supply — in particular an interval rhythm carries no start date.

Three of the four are a number, and a rhythm SHALL carry that number as the person gave it, judged
by nothing on the way. A rhythm is what a person said, not what the system was able to make of it,
so the judging happens in one place — the screen, when it is asked to define — and the requirement
below says what it does there.

A **kind** SHALL be one of four, and all four SHALL be offered: a tick, a number, a note and a
total. It follows the shape the rhythm above has and is not left to whatever draws the screen — a
form offering three of them would be a rule about what a person may keep, decided in a layer nothing
regresses.

**A commitments screen SHALL offer, as the kind for a new commitment, the tick.** It is the plain
kind and the common case — the day-one week is nine ticks — and a weight, a note or a total is the
deliberate choice that should cost the tap. It is also the same default a commitment formed without a
kind takes and the same kind every commitment written before kinds existed reads back as, so the form,
the value and a roster read off an older file all mean one thing by saying nothing. For a commitment
the screen already holds there is no kind to offer, because a kind is not one of the things a change
is asked with; what that commitment's kind *is* is said by *A commitments screen says what a
commitment it is asked to change is made of*.

**A range and a target reach this screen as the person typed them, and this screen judges them.** A
number kind's two range ends and a total kind's target SHALL each be taken as text, exactly as
typed, and SHALL NOT be judged, formed or blocked before they arrive. This is a deliberate departure
from the shape a **rhythm** number arrives in: three of the four rhythms carry a number the app shell
has already made, and all this screen judges of one is whether the rhythm allows it. It matches
instead the shape a **number entry** takes on a day screen, and for that surface's reason — "that is
not a number" is a refusal a person reads beside the field they typed it in, where a field the shell
silently refuses to accept a character into is a person left guessing, and the shell goes on deciding
nothing. ADR-1046.

**A range end and a target SHALL be read as a number entry reads a committed number, and there SHALL
be one such reading in this system rather than two.** No locale is consulted; blank space at either
end is disregarded; what is left may carry a leading minus, SHALL hold at least one digit, SHALL hold
no character that is not a digit but for at most one separator, which may be a full stop or a comma,
and SHALL hold no more than thirty-eight significant digits. A text that reading does not hold as a
number is not a number here, and SHALL NOT be rounded, truncated or otherwise adjusted to fit: a
bound or a target a person did not type is one they meet later without knowing why, and this system
already refuses to keep a number it cannot keep exactly (ADR-1040).

**Whether a field is blank SHALL be asked before it is read as a number**, and the two answers are
different things. A field holding nothing but blank space is not a number that failed to read; it is
a field nobody filled in, and what that means belongs to the kind — no range where both ends are
blank, and no target at all, which a total cannot be defined without.

**Both range fields blank is no range.** A commitment of the number kind defined with both ends blank
SHALL be of the number kind carrying no range, and any number is then a number for it — two spaces and
an untouched field say the same thing, so clearing a range is not a delete-every-character operation.
**One end filled and the other blank is not no range**, and is refused by the requirement below: a
typed floor is something a person deliberately entered, and reading it as "no range at all" throws it
away. Blank is decided by the one test this package asks for the question (ADR-1039), so a character
that occupies no width is a character like any other: a range end holding a zero-width space alone is
a range end that is not a number, not an empty one.

**A range or a target left in a field the chosen kind has no room for SHALL be ignored, and SHALL NOT
be refused.** A commitment defined of the tick or the note kind carries neither, whatever those fields
hold; one of the number kind takes its range and ignores a target; one of the total kind takes its
target and ignores a range. A person who typed a range and then chose Note is not asking for a range,
and refusing something nobody asked for is noise in front of the thing they did ask for. This is held
against the one-end-blank rule deliberately, and the two do not disagree: there the person had chosen
the kind the field belongs to, and the bound they typed meant something.

**The day a commitment is kept from SHALL also be the start date of an interval rhythm.** The
commitment is due on the day a person started keeping it and every N days after it. The two remain
distinct in the model and may disagree where something other than this screen forms the commitment;
this screen offers one date and uses it for both.

A commitments screen SHALL offer, as the day to keep a **new** commitment from, the day it was
handed. For a commitment it already holds, the day it offers is that commitment's own day and is said
by the requirement *A commitments screen says what a commitment it is asked to change is made of*;
this one is about defining, and defining is what the day the screen was handed is the right answer
for. It
SHALL accept any calendar date the system supports in that place, the future included: a person who
has kept something since June says June, and "I start the gym on Monday" is a real thing to want. A
commitments screen MUST NOT judge that date against the day it was handed, and MUST NOT bound it in
any way the calendar does not.

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
the roster place, and neither SHALL change either of the screen's lists. The two SHALL be told
apart from each other, because they are different things to fix.

The first refusal is the one a commitment already makes: a name that names nothing names nothing on
any screen.

**The second is the screen's own, and the rule engine goes on accepting the value.** A weekday set
with no days in it is a legal schedule, due on no date the system supports, and the `schedule`
capability SHALL be unchanged by this requirement. A commitment made on one is a commitment a
person would never see again, which is a rule about what a screen should offer to make rather than
about what a schedule value may be. ADR-1028.

A commitments screen SHALL refuse nothing else about a name. There is no length limit, no
restricted script and no reserved word: the name is the owner's own words rather than the system's.

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

A commitments screen SHALL refuse to define a commitment on a day of the month that is not one of
the thirty-one, on an interval of fewer than one day, or on a weekly quota outside one to seven a
week. It SHALL refuse the number rather than change it: a number outside what a rhythm allows MUST
NOT be moved to the nearest number that is allowed, and MUST NOT be dropped in silence. Nothing
SHALL be kept at the roster place and neither of the screen's lists SHALL change.

The three refusals are one refusal, told apart from every other the screen makes but not from each
other. What a person does about any of them is the same thing — put a different number in the field
they are already looking at — and the form knows which field that is, so a second case would buy a
distinction nothing could act on. That is ADR-1021's rule, applied where it does hold, in the same
change that departs from it where it does not.

**This is not the screen disagreeing with the rule engine, and it is the opposite of the
requirement above.** A weekday set with no days in it is a value the engine accepts and the screen
refuses (ADR-1028). A day of the month of 32 is a value the engine refuses to form at all: the
`schedule` capability already says a day of the month is a number from the first to the
thirty-first, an interval is a whole number of days at least one, and a weekly quota is a number of
times from one to seven, and the `schedule` capability is unchanged by this requirement. All this
requirement does is make the screen *say* what the value said, which ADR-1028 records as what every
screen in this product already did.

The numbers a rhythm allows SHALL be accepted at both ends. The first and the thirty-first of the
month, an interval of one day, and one and seven times a week are each the last number that is
allowed rather than the first that is not.

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

A commitments screen SHALL refuse a commitment its roster is already keeping, and SHALL refuse a
change it could not keep at a place, and SHALL tell the two apart. Neither SHALL change
either of the screen's lists, and neither SHALL change what is at the roster place.

**Both refusals reach further than defining now, and in different directions.** A change to a
commitment is refused as one the roster already holds where the roster holds it in **any** of the
three states rather than only where it is keeping it, because changing one commitment into another
would put two histories under one value where defining one merely takes it up again. And a change the
screen could not keep is told the same way whether it was the **record place** or the **roster place**
that would not take it: a person can do nothing about either but try again later, which is the test
this requirement has always applied.

This deliberately does not follow the day screen, which tells every refused tick the same way
(ADR-1021). The reasoning there was that a refusal a person cannot act on differently should not be
told apart, and it does not carry: a commitment you already keep is your own doing and you can
change the name, the rhythm or the day you keep it from, while a place that will not take a write
leaves a person nothing to do but try again later.

A commitment the roster has **stopped** keeping is not a duplicate. Defining the same three things
again SHALL take that commitment up again, in the place it has, exactly as offering it to the
roster does. **Changing another commitment into it is a duplicate**, and is refused: the way back to
a stopped or a removed commitment stays the deliberate one, and a spelling correction is not it.

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

A commitments screen SHALL be asked to stop keeping a commitment, and SHALL change nothing until
that stop is confirmed. Until then it SHALL hold exactly which commitment is awaiting confirmation,
so that a person can be told which one they are about to stop; being asked about a second
commitment SHALL replace the first, since only one stop can be awaiting confirmation at a time.
**A commitments screen SHALL have at most one change awaiting confirmation of any kind**, so being
asked to stop keeping a commitment SHALL leave nothing awaiting removal, and being asked to remove
one SHALL leave nothing awaiting a stop. A person is answering one question at a time, and a screen
holding two would have to be drawn twice over. **Moving a commitment awaits no confirmation and
takes neither slot**, so a move SHALL leave whatever is awaiting confirmation exactly as it is: a
drag is its own confirmation, and a drag back is its undo.

A stop that is cancelled SHALL leave the screen's two lists, and what is at the roster place,
exactly as they were, and SHALL leave nothing awaiting confirmation. Confirming SHALL do the same
when there is nothing awaiting confirmation.

A confirmed stop SHALL stop keeping the commitment **as of the day before the one the screen was
handed**, that day being the last day it was kept, and SHALL keep that at the roster place before
either list says so. The commitment SHALL then be in what the screen has stopped and not in what it
keeps, in the place it has. A commitments screen holds one day and no other, so it offers no date to
pick.

**The day before, and not the day the screen was handed, so that the row leaves today's screen at
once.** A row that outlived the stop that was just made reads as a stop that failed, on the one
screen whose purpose is to make the change. The price is stated rather than hidden: a tick made this
morning on a commitment stopped this afternoon is not drawn on today's day screen, though the record
of it stands untouched and the row returns on that day if the commitment is ever taken up again. A
commitment defined and stopped on the same day becomes one kept on no day at all, which the roster
already accepts as what changing your mind before starting looks like. ADR-1023 is amended in place
and its kept-until day is still inclusive and still the roster's to judge; what this requirement
fixes is which day the screen hands it.

Where the day the screen was handed has no day before it — the first date the system supports — the
commitment SHALL be kept until that day itself. A person asked for a stop and a stop is what they
get; refusing on the calendar's own floor would be a refusal about a thing they cannot act on, and no
device will present that day.

**The scenario below titled *a commitment stopped through a commitments screen is kept until the day
the screen was handed* is kept exactly as it was in name and asserts the day before instead.** Its
title is wrong from the moment this change ships. It is kept because `openspec` 1.10.0 refuses a
MODIFIED requirement that drops any scenario the current spec has, and the only way to drop one is to
rename the requirement, which moves the whole block to the bottom of the spec at archive time.
`design.md` § *Three scenario titles that are now wrong* has the evidence and the two others.

A commitments screen asked to stop keeping a commitment its roster is not keeping SHALL do nothing
and SHALL say nothing: there is no refusal a person can act on, because there is nothing there to
stop. A stop that could not be kept at the roster place SHALL be refused as a roster that could not
be written, and SHALL leave both lists as they were.

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

A commitments screen SHALL take a commitment it has stopped up again, without asking for
confirmation and without asking for a name, a rhythm or a day. It SHALL keep that at the roster
place before either list says so; the commitment SHALL then be in what the screen keeps, in the
place it has, and not in what it has stopped.

It asks for no confirmation because the whole point of the second list is that stopping costs one
tap to undo. It asks for nothing else because the commitment is already three things the roster
holds; asking again would be defining a different commitment.

A commitments screen asked to take up again a commitment its roster has not stopped SHALL do
nothing and SHALL say nothing. One it could not keep at the roster place SHALL be refused as a
roster that could not be written, leaving both lists as they were.

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

A commitments screen SHALL keep its roster, when it is not told another place, at exactly the place
a day screen keeps its. The two screens are each other's only writer, and a person who defines a
commitment on one and looks for it on the other is looking at one file.

A commitments screen SHALL be handed the day it is asked on when it is opened, and SHALL be handed
one again when the app is shown. Being shown SHALL read the roster place again and form both lists
again from what is then there, and SHALL replace the day the screen holds — so a commitment stopped
after midnight is kept until the day before the one it is actually stopped on, and a screen the app
was left on overnight does not offer yesterday as the day to keep a new commitment from.

Nothing else changes the day a commitments screen holds. It reads no clock, and time passing does
not move it.

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

A commitments screen whose roster place cannot be read SHALL list nothing in either list and SHALL
say that it is not keeping a roster. It MUST NOT take anything on, and it MUST NOT write over what
is at the place — what is there is left untouched for a person or a later version of the app to
recover. It SHALL offer no category either: the categories it offers are the ones the commitments it
keeps are under, and it keeps none.

Defining a commitment through such a screen SHALL be refused as a roster that could not be written.
Asking it to stop keeping a commitment, to take one up again, to remove one, to move one, or to
change one SHALL do nothing and say nothing, by the rule that already governs a commitment neither
list holds: both its lists are empty, so there is nothing there to stop, nothing there to take up,
nothing there to remove, nothing there to move and nothing there to change.

Every way the place can refuse to be read SHALL be answered alike, save one, which SHALL be named:
a roster **written by a later version of DayByDay**. That roster is whole and it is the app that is
behind, so the person's answer is to update the app and leave the file completely alone, where a
screen saying only that something is wrong invites deleting it. No other reason leaves a person
anything different to do, so no other reason is told apart. ADR-1021.

The condition SHALL last only until the app is shown again, since being shown reads the place
afresh.

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

Where a change asked of a commitments screen is refused, the screen SHALL hold **which change was
asked for** and **why it was refused**, as well as answering the refusal to the caller. The two are
not alternatives and neither replaces the other: the refusal answered to the caller is what a test
asserts on and what stops a shell drawn later from swallowing the failure a second time, and what
the screen holds is what a person is told from. A screen that only answered would leave how long a
person is told for to whatever drew it, and that lifetime would then be decided in a layer nothing
regresses.

The change it holds SHALL be one of the seven a person can ask for — defining a commitment, stopping
keeping one, taking a stopped one up again, removing one, moving one, **moving a whole group**, or
**changing one** — and for the five that are asked about a commitment already on one of its lists, it
SHALL name that commitment. **A refused change names the commitment it was asked about and not the
one it would have produced**, because the row a person is told beside is the row they tapped, and the
commitment they asked for does not exist. **A refused group move SHALL name the category instead**,
because a group is what was tapped and a category is the whole of what a group is: naming one of its
commitments would point at a row the person did not touch. Which change it was is not
decoration: a person is told beside the thing they asked for, and the only other way to place the
message is for whatever draws the screen to remember which call it made.

**The seven are counted here and numbered nowhere else.** A requirement that introduces one of them
SHALL name it — a refused move, a refused group move, a refused change — and SHALL NOT identify it by
its position among them, because withdrawing a kind renumbers every position after it and falsifies
both the requirements that state one and the archived change folders that cite one, which are never
edited. A statement about the kinds that came *before* a kind is not a position in this sense: it
names them, all of them go on existing, and nothing withdrawn later can make it untrue.

Why it was refused SHALL be the same refusal that was answered to the caller, and no more. A
commitments screen SHALL hold **no words a person reads**: the distinction between its refusals is
this capability's, and the sentence said for each is the drawing's, exactly as it already is for
whether the screen is keeping a roster. ADR-1022.

It SHALL hold **at most one refused change at a time**, and that change SHALL be the change asked
for last. Asking for a second change replaces what is held rather than adding to it: one refusal is
one event, two would tell a person twice about two different moments, and the ask they are waiting
on an answer for is the one they just made.

A call that asks for **no change at all** SHALL NOT be a refusal. Asking to stop keeping a
commitment the screen does not keep, confirming a stop when nothing is awaiting confirmation, taking
up again a commitment the screen has not stopped, asking to remove a commitment on neither of its
lists, confirming a removal when nothing is awaiting removal, **confirming a removal while the name
typed back does not match**, **asking to move a commitment the screen does not keep**, **asking
to move one into a group the screen draws none of or to an offset that group does not have**,
**asking to move a group the screen draws none of — the group of the commitments under no category
among them — or to move a group to an offset the groups it draws under a category do not have**,
**asking to change a commitment on neither of its lists** and **asking for a change that names what a
commitment already is** each answer nothing and
change nothing, so each
SHALL leave the screen holding no refused change and SHALL leave whatever it is already holding
exactly as it was.
There is nothing to report and nothing has been proved about the roster place either way.

A name typed back that does not match is emphatically not a refusal, and that is the decision rather
than an omission. A person mid-way through typing a name has asked for nothing yet; telling them
they are wrong on every keystroke would be the screen refusing what nobody offered it. What the
screen answers instead is whether the name matches, which is what makes the confirmation reachable
or not, and there is nothing else to say.

Which refusals exist, and which of them are told apart, are the requirements above and are not
restated here.

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

A commitments screen SHALL go on holding a refused change until one of exactly two things happens,
and SHALL then hold nothing. Nothing else SHALL end it. Time passing in particular SHALL NOT,
because this capability reads no clock.

**The app being shown again** ends it. That is inherited rather than added: being shown reads the
roster place afresh and forms both lists again from what is then there, and what was refused is an
answer about a place that has since been read again. It SHALL end whether or not the roster can then
be read — a screen that is then not keeping a roster says that instead, and says more than a refused
change ever could.

**A change reaching a place** ends it, whichever kind it was and whichever change was refused before
it. Defining a commitment that is taken on, a stop that is kept, a take-up-again that is kept, a
removal that is kept, a move that is kept, **a group move that is kept** and **a change of a
commitment that is kept** all count, and a change that writes nothing but a category is one of the
last of those rather than a kind of its own, because a category is one of the four things a change
is made of. A change of a commitment reaches the record place as well as the roster place, and it
ends what is held once it has been kept — one act, one outcome, however many places it touched. This
is one rule rather than one for each kind because it is the at-most-one rule above read the other
way round: a commitments screen holds the outcome of the last change asked of it, so a change that
is asked for and kept leaves nothing to hold. A person who has just been told a change landed is not
also told that an earlier one did not.

A call that reaches the place with no change to make SHALL NOT end it, by the rule above that such a
call is not a change asked for at all. **A move that drops a commitment where it already is is
exactly such a call** — it is accepted rather than refused, and nothing is kept at the place, so
there is nothing to have answered a notice with — **and so are a group move that leaves a group
where it is drawn, a change that names what a commitment already is, the category it is already
under among the four things it names, and a change asked about a commitment on neither of the
screen's lists**. Nor SHALL putting a stop or a removal up for confirmation, typing a name back, or
cancelling either: none of them reaches the roster place, and nothing has been proved about it
either way.

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
Removing SHALL take the commitment out of the commitments the roster reads back and out of the
commitments it reads back as stopped, SHALL hold it as **removed**, and SHALL report that the roster
removed it. The commitment SHALL stay in the place it has, and everything else the roster holds
SHALL be exactly as it was, in the order it was in.

**A removed commitment keeps a day it was kept until.** Where the roster is keeping the commitment,
the date it is given SHALL become the day that commitment was kept until, exactly as a stop's date
does. Where the roster has already stopped keeping it, the day it already holds SHALL stand and the
date given SHALL NOT be used — the day a person could see on the stopped list is the day that goes
on being true, and a removal is not an occasion to move it. Either way the commitment has a
kept-until day afterwards, and a roster SHALL NOT hold a removed commitment without one.

The roster SHALL refuse to remove a commitment in exactly two cases, and SHALL report each rather
than doing nothing silently, for the same reason a refused addition is reported: a commitment the
roster does not hold at all, and a commitment it has already removed, whose kept-until day SHALL
stand as first given. A roster asked either SHALL be left exactly as it was.

**Removing is a last state and not a departure.** Nothing takes a commitment out of a roster, and
that is the decision this requirement exists to state: a roster whose every commitment has been
removed still holds every one of them, still answers with each of them on every date up to the day
it was kept until, and is therefore **not** the same roster as one that has been given no commitment
at all. The alternative — dropping the entry — was weighed and rejected, because every past day
would then lose that commitment's rows and a roster emptied by removal would read as a first launch
to whatever writes day one. ADR-1035.

The one way back SHALL be offering the commitment again, which takes it up again in the place it has
and clears both the day it was kept until and its being removed — the rule is *A roster
refuses a commitment it already holds*, and there is no second way.

The roster SHALL refuse on no date. Any calendar date the system supports SHALL be accepted as a day
a commitment was kept until when it is removed, including the first and the last, and including a
date earlier than the day that commitment is kept from. As everywhere else, the roster SHALL NOT ask
what day it is: the date is handed to it, never worked out.

Removing SHALL change nothing about the commitment itself and nothing about what has been recorded
against it. A commitment that has been removed SHALL answer whether it is due on a date exactly as
it did before, and every tick already recorded against it SHALL stand. A person getting rid of a
commitment is saying something about the days ahead; what they actually did on the days behind is
not the roster's to take back and is not taken back.

A roster SHALL be a value here too: removing a commitment SHALL leave every other roster untouched,
and two rosters differing only in whether one commitment has been removed SHALL be different
rosters.

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

A commitments screen SHALL be asked to remove a commitment on either of its lists, and SHALL change
nothing until that removal is confirmed. Until then it SHALL hold exactly which commitment is
awaiting removal, so that a person can be told which one they are about to get rid of; being asked
about a second commitment SHALL replace the first, and SHALL leave nothing typed back against the
first. At most one change of any kind is awaiting confirmation on this screen, so being asked to
remove SHALL leave nothing awaiting a stop.

A commitments screen SHALL hold **what has been typed back**, and SHALL answer whether it **matches**
the commitment awaiting removal. It matches when what has been typed and the commitment's name are
the same once surrounding blank space has been trimmed from each. Case SHALL matter and blank space
inside the name SHALL matter: "gym" does not match "Gym", and "Water  plants" with two spaces does
not match "Water plants" with one. Blank space is trimmed from both sides of the comparison rather
than from the typed name alone, so that a commitment whose name was given with a space at either end
is one a person can actually type back; the roster holds such a name exactly as it was given, and a
name nobody could reproduce would be a commitment nobody could ever remove.

Nothing SHALL be awaiting removal and nothing SHALL have been typed back when the screen is opened,
after a removal is confirmed or cancelled, and after the app is shown again.

**A confirmed removal SHALL do nothing at all unless the name matches.** Confirming while what has
been typed does not match SHALL leave the commitment awaiting removal, SHALL leave what has been
typed as it is, SHALL leave both lists and the roster place exactly as they are, and SHALL neither
refuse nor say anything — exactly as confirming does when nothing is awaiting removal. The screen
answers whether the name matches and that is the whole of the check; there is no second thing a
person is told, because a name still being typed is not a change anybody has asked for yet.

A confirmed removal whose name matches SHALL remove the commitment at the roster place before either
list says so, and the commitment SHALL then be in neither list. Where the screen was keeping the
commitment, it SHALL be removed **as of the day before the one the screen was handed**, by the same
rule and for the same reason a stop is, and where the day the screen was handed has no day before it
that day itself SHALL be used. Where the screen had stopped keeping it, the day it was already kept
until SHALL stand.

A removal that is cancelled SHALL leave both lists, and what is at the roster place, exactly as they
were.

A commitments screen asked to remove a commitment on neither of its lists SHALL do nothing and SHALL
say nothing, by the rule that already governs a stop asked about a commitment it does not keep:
there is no refusal a person can act on, because there is nothing there to remove. A removal that
could not be kept at the roster place SHALL be refused as a roster that could not be written, and
SHALL leave both lists as they were.

A commitments screen SHALL hold no words a person reads here either. Whether the name matches is
this capability's answer; whether that makes a button pressable, and what the button says, are the
drawing's. ADR-1022.

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
place counted over the commitments the roster is keeping **as they stand before the move**, running
from 0, before the first of them, to the number it is keeping, which is after the last — and the
**category** to put it under, which may be none. Moving SHALL put the commitment under that category
and SHALL report that the roster moved the commitment. **Moving is the only thing that ever changes
a roster's order**, and a commitment is one of the two things a move takes: the other is a **group**,
which takes every commitment under one category with it as a block. Everything below is about the
first of the two, and a group move's own rules are stated where they belong.

**A move carries a category because the ask above it does.** A commitment moved into another group's
rows has been moved and recategorised by one act, and a roster that took the two separately would
keep one of them where the other could not be kept. Where a move is asked for with the category the
commitment is already under, the category is the one it already had and nothing about it changes; the
category is applied on every move rather than only on some, so there is no move that silently leaves
it alone.

**The moved commitment is put where the offset points, and nothing else is picked up.** Unless the
offset is one of the two that ask for the place the commitment already has — the offset it is at
among the commitments the roster is keeping, and the one just after that — the commitment SHALL be
taken out of the sequence the roster holds and put back immediately before the commitment that stood
at that offset among the ones the roster was keeping, or immediately after the last of them where
the offset is the number it is keeping. Every other commitment the roster holds SHALL afterwards be
in the order it was in — kept, stopped and removed alike — and no two of them SHALL be reordered
against each other. A stopped or removed commitment lying between where the moved commitment was and
where it goes is passed rather than pushed: the moved commitment goes by, and it stands still.

**On those two offsets the commitment SHALL NOT be taken out of the sequence at all**, and nothing
in the sequence SHALL move. The carve-out is not tidiness: taking the commitment out and putting it
back immediately before whatever stood at the offset just after its own would walk it past a stopped
or removed commitment lying between the two, and hand back a roster that is not the roster it was.
**The carve-out is about the sequence and not about the category**: a move on one of those two
offsets still puts the commitment under the category it was moved under, because the offset says
where and the category says what, and only the first of the two has anything to carve out.
The paragraph below says why both offsets ask for the place the commitment already has.

**An offset is counted over the commitments the roster is keeping and over nothing else.** The
commitments a roster has stopped keeping or removed are in its order but not in that count, because
the list a person is looking at when they move something is the list of what they keep; a place
counted over all three states would be a number nothing shows. It is counted over the order the
roster holds and not over the order the roster **draws** — the groups are a reading of that order,
and the screen that draws them is where a place on the screen becomes a place in the order.

**The price of one order over three states, taken knowingly.** A commitment the roster has stopped
keeping has a place in the sequence and holds it, so taking it up again returns it exactly there —
but the commitments around it may have moved since, so what it comes back beside is where the
sequence now puts it and not the neighbour it used to have. That is what one order over everything a
roster holds costs. The alternative, an order per state, would mean a roster holding more than one
order, which it is not.

**An offset that puts a commitment where it already is, under the category it is already under,
SHALL be accepted**, SHALL report that the roster moved it, and SHALL leave the roster the same
roster it was. Two offsets do this for any commitment — the one it is at, and the one just after it
— and they arrive there differently. The
offset it is at names the moved commitment itself, and immediately before itself is where it already
stands. The offset just after it names the **next** commitment the roster is keeping and not the
moved one — or, where the moved commitment is the last one kept, is the number kept, which is after
the last of them and so is again where it already stands — and a commitment is already immediately
before the one that follows it among the ones the roster is keeping. Neither offset asks for a
commitment the roster is keeping to stand anywhere new, so nothing in the sequence the roster holds
moves at all: a stopped or removed commitment lying between the moved one and the one that follows
it is not passed, because nothing goes by it. This is not a refusal: the roster's refusals are about
a move it cannot make at all, and this is one it can make whose result is the roster it already had.
A person who picks a row up and puts it back has made no mistake to be told about.

The roster SHALL refuse to move a commitment in exactly two cases, and SHALL report each rather than
doing nothing silently, for the same reason a refused addition is reported:

- **a commitment it is not keeping** — one it does not hold at all, one it has stopped keeping, or
  one it has removed. A stopped or a removed commitment already has its place, and a move that
  reached one would rearrange an order against a list nobody moves things on.
- **an offset below 0, or above the number of commitments the roster is keeping.** Not clamped. A
  clamp puts a commitment somewhere nobody asked for, which is the silently-wrong-thing the roster's
  other refusals exist to prevent; no gesture can produce such an offset, but a gesture is not the
  only way in.

A roster asked either SHALL be left exactly as it was, **its categories included**: a refused move
puts nothing under anything.

**A move takes no date and moves none.** The roster SHALL NOT be asked what day it is for a move,
SHALL NOT record when one happened, and SHALL NOT change any day a commitment was kept until or any
commitment's own day it is kept from. Moving SHALL change nothing about the commitment itself and
nothing about what has been recorded against it: every tick already recorded SHALL stand, and the
commitment SHALL go on answering whether it is due on a date exactly as it did before. That holds of
the category a move carries as much as of the place: a category is the roster's, so putting a
commitment under one re-keys nothing.

A roster SHALL be a value here too: moving a commitment SHALL leave every other roster untouched,
and two rosters holding the same commitments in a different order are already different rosters.

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
commitment, **the group it was dropped in** and an **offset counted over the entries drawn in that
group as they stand before the move**, and SHALL keep the move at the roster place before the list
says so. It SHALL ask for no confirmation and SHALL ask for nothing else: the gesture is a drag, a
drag is its own confirmation, and dragging back is the undo. This is where the order a **day screen**
draws in is set, as far as the rows inside a group go; the order the **groups** themselves are drawn
in is set by moving a group, which is a second act on this same screen. Between them, this screen is
the only place a person sets either.

**A drop says which group it landed in, and its offset is counted inside that group** — from 0
before the first entry drawn in that group to the number of entries drawn in it, which is after the
last. The group is named by its category, or by there being no category, which is the group of the
commitments under none. Where nothing the screen keeps is under a category there is one group, the
one under none, and an offset counted over that group is an offset counted over the whole list the
screen draws. Turning a place inside a group into a place in the roster's order is this screen's work
and nobody else's: putting it here is what keeps every other layer from holding a second copy of the
grouping rule.

**A drop also says what the row is now under.** The commitment SHALL be put under the category of the
group it was dropped in. A row dropped into another group is therefore moved **and** put under that
group's category by one act, and a row dropped among the entries under no category is moved and has
its category taken off. One ask doing both was chosen over a move that only ever reordered, and the
price is stated rather than hidden: a move is now the second way a category changes, beside the
field.

**The place the commitment comes to stand in the roster's order is immediately before the entry drawn
at that offset in that group**, or immediately after the last entry drawn in that group where the
offset is the number drawn in it. Because the moved commitment is under that group's category once
the drop is made, and a group's entries are drawn in the roster's own order, that is the place that
draws it where it was dropped.

**The end of a group is therefore a place a drop can reach, and reaching it files the commitment in
that group and not in the one drawn after it.** Appending a row to a group is the ordinary thing a
person does with a group, and an offset counted over the whole drawn list could not express it: the
place after a group's last entry and the place before the next group's first are one offset on that
list, so one of the two has to be unreachable. Counting inside the group is what gives them one
offset each.

**Moving a group's first commitment away moves the group**, and that follows from where a group sits
rather than from anything this requirement adds: a group sits where its first commitment sits, so a
group whose first commitment has gone somewhere else is afterwards drawn where its next commitment
sits. A person who moves the only row of a group into another group therefore sees one heading fewer,
and a person who moves a group's top row to the bottom of the list may see that group follow it. It
is stated here because it is the one result of a move that is not the row that was moved. **It is not
how a group is meant to be moved** — moving a group is its own act, which carries the whole group and
leaves every row where it was inside it — and this stays a consequence of moving a *row* rather than
a second way to reach the same end.

**Two offsets leave a commitment where it is drawn, and on those the screen SHALL change nothing at
all** — not the order, and not the category. They are the offset the entry is drawn at within its own
group and the one just after it, and they carve out nothing anywhere else: a commitment dropped in
any group but the one it is already in is filed there at every offset that group has, because its
category changes even where the drawn order would not. A drop that has moved nothing has not
recategorised anything either — a person who picks a row up inside its own group and puts it back
down has said nothing.

**The move is offered on what the screen keeps and nowhere else.** A commitment on the list of what
it has stopped SHALL NOT be moved through this screen: it already has a place in the roster's order,
taking it up again returns it there, and that list is not the one an order is read off. It is not
grouped either, so there is no group on it to drop anything into.

A commitments screen asked to move a commitment neither of its lists holds, one on the list of what
it has stopped, one **into a group it draws none of**, or one to an offset that the group it was
dropped in does not have SHALL do nothing and SHALL say nothing. Each of those asks for no change at
all, by the rule that already governs a commitment neither list holds, so the roster's own two
refusals are never reached through this screen and there is nothing for it to word. **A group it
draws none of** is a category no commitment it keeps is under, and it includes no category at all
where everything it keeps is under one: a group nobody is in is drawn nowhere, so no drop can land
in it, and answering with a new group would be the screen inventing a place a person could not have
pointed at.

A move the screen could not keep at the roster place SHALL be refused as a roster that could not be
written, leaving both lists as they were, **and leaving the commitment under the category it was
already under**. That is the **fifth** kind of refused change a commitments
screen holds, beside defining a commitment, stopping keeping one, taking one up again and removing
one, and it SHALL name the commitment it was asked to move. A reorder that silently failed to write
would leave a person looking at an order the phone forgets the moment it is closed, which is what
this screen's refusals exist to prevent.

**A drop that puts a commitment where it already is changes nothing and says nothing.** It is not
refused, it changes neither list, and it does not answer a refused change the screen is already
holding: nothing reached the roster place, so nothing has been proved about it either way. Two
offsets do this for any commitment dropped in the group it is already in, which is the gesture's own
arithmetic rather than a rule this screen makes.

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

A roster SHALL put a commitment it is keeping under a **category**, on being given that commitment
and the category, and SHALL report that it put the commitment under it. This is a fifth act on a
commitment beside taking one on, stopping keeping one, removing one and moving one, and it is the
only act that changes a category on its own — a move carries one too, because the gesture that makes
a move carries one.

**A category is a word the person chose, and the roster judges it for saying something and for
nothing else.** A category made of nothing but blank space, and a category with nothing in it at
all, both mean the commitment is under **no** category, and neither SHALL be refused: unlike a name,
a category is optional, so a field emptied is how one is taken off rather than a mistake to report.
Every other category SHALL be kept exactly as it was given — no length limit, no restricted script,
no reserved word, no trimming and no folding of case, so a category with blank space at its ends is
that category and not the one without. Two commitments are under one category when the words are
the same word, and under two when they are not.

**There is no list of categories anywhere.** The categories that exist are exactly the words the
roster's commitments are under, so a category no commitment is under has stopped existing and there
is nothing to delete; nothing creates a category before a commitment is put under it, and nothing
holds one afterwards. A roster MUST NOT keep a second collection of category words, MUST NOT hold a
count of what is under each, and MUST NOT refuse a category because no commitment is under it yet.

**A category is the roster's and never the commitment's.** Putting a commitment under one SHALL
change nothing about the commitment itself: the same name, the same schedule, the same day it is
kept from and the same kind, so it goes on answering whether it is due on a date exactly as it did
before and every record already made against it stands. That is why a category may change at all —
a fifth part on the commitment would orphan everything recorded against it the moment a person
refiled it. ADR-1038.

**A category cuts across the three states rather than adding one.** A commitment the roster has
stopped keeping or removed goes on being under the category it was under, and is read back under it
wherever such a commitment is read back. But the roster SHALL refuse to *change* the category on a
commitment it is not keeping — one it does not hold at all, one it has stopped keeping, or one it has
removed — and SHALL report that rather than doing nothing silently, exactly as it refuses to move
one. A stopped commitment is not on the list a person is filing things on, and a change made against
it would be a change made to a list nobody is looking at. A roster asked for one SHALL be left
exactly as it was.

**Putting a commitment under the category it is already under SHALL be accepted**, SHALL report that
the roster put it under the category, and SHALL leave the roster the same roster it was. It is not a
refusal, for the reason a drop where a commitment already is is not one: it is a change the roster
can make whose result is the roster it already had.

A roster SHALL NOT be asked what day it is to put a commitment under a category, SHALL NOT record
when one happened, and SHALL NOT change any day a commitment was kept until or the order it holds
its commitments in. **Only a move changes the order**, and putting a commitment under a category is
not a move: a commitment given a category is drawn somewhere else and held exactly where it was, so
taking the category off draws it back where it never stopped being. A roster SHALL be a value here
too: putting a commitment under a category SHALL leave every other roster untouched, and two rosters
alike in every way but the category one commitment is under are different rosters.

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
SHALL answer the same way about a calendar date, with the commitments it had not stopped keeping on
that date. This is the one place in the product where grouping is worked out, and everything that
draws groups draws these.

**A group sits where its first commitment sits in the order the roster holds its commitments.** The
groups SHALL be in the order in which each category is first met, walking the commitments in the
roster's own order, and the commitments within a group SHALL be in that same order. **The group of
the commitments under no category SHALL come last**, wherever the first of them sits, and SHALL be
absent entirely where every commitment is under a category. A group for a category no commitment is
under SHALL NOT exist, so a category whose last commitment has been put under another has no group
and there is nothing left to delete.

The roster SHALL invent no other arrangement. It MUST NOT sort the groups by their category, MUST
NOT sort within a group, and MUST NOT put the group with no category anywhere but last: ordering by
the words would be a rule about the owner's own words, which is the argument the order itself has
always rested on. Placing a group where its first commitment sits is not such a rule — it is the
person's order, read a second way — and putting the uncategorised last is the one arrangement that
leaves a roster nobody has categorised looking exactly as it looked before there were categories.

**The groups are a reading of the roster's one order and not a second order.** The order the roster
holds its commitments in is unchanged by anything about a category, and the flat reads — the
commitments it is keeping, and the commitments it had not stopped keeping on a date — SHALL go on
answering in that order and SHALL NOT be grouped or rearranged. Reading in groups and reading flat
therefore answer with the same commitments, each exactly once, and disagree only in the order they
come in. Nothing is stored for a group: they are worked out on every read, from the order and the
categories, and there is nowhere for the two readings to drift apart.

Reading in groups over a date SHALL take exactly the commitments the roster had not stopped keeping
on that date — the commitments it is keeping, and every commitment whose kept-until day is that date
or later, whether it was stopped or removed — each under the category it is under. A roster holding
nothing at all, and a roster none of whose commitments had been taken on by the date asked about,
SHALL each read back no groups at all rather than one empty group.

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

A roster SHALL move a **group**, on being given the **category** naming it and an **offset** — a
place counted over the groups the roster is keeping that are under a category, **as they stand
before the move**, running from 0, before the first of them, to the number of them, which is after
the last. Moving a group SHALL relocate every commitment under that category and SHALL report that
the roster moved the group. This is the second of the two things a move takes, and between them a
move is still the only thing that ever changes a roster's order.

**Everything under the category travels — kept, stopped and removed alike — and keeps its order
against the others that travel.** This is deliberately not the rule a commitment's move follows,
which passes a stopped or removed commitment lying in its way rather than taking it along, and the
difference is observable rather than a taste: a roster answers about a calendar date in groups too,
drawing the commitments it had not stopped keeping on that date each under its category, so a member
left behind would go on sitting where the group used to be and a day in January would read the groups
in an order the person never set. Carrying every member is what lets a past date read the group order
the person set; the one case where it still does not is named two paragraphs below, and that one
comes from where the block is **placed** rather than from what it carries. ADR-1044.

**The group is put where the offset points, and it arrives as one block.** Unless the offset is one
of the two that ask for the place the group already has, every commitment under that category SHALL
be taken out of the sequence the roster holds and put back **immediately before the first commitment
the roster is keeping under the category of the group that stood at that offset**, or, where the
offset is the number of the groups it is keeping under a category, **immediately after the last
commitment under the category of the last of them**, whatever state that one is in. The first is
measured over the commitments the roster is **keeping**, and not over every commitment under the
target category, because the offset itself is counted over the groups a person can see: measured
against a stopped or removed commitment lying earlier than the target group's first kept one, the
block would come to rest at a place the offset never named, and rest there with nothing refused and
the roster written. The second is deliberately not measured that way, and the difference is not an
oversight: after the last of a group is after every commitment under it either way, so no offset can
land wrong there, and placing after the whole of it leaves the group being measured against unbroken.

**What the first of those costs is paid on a past date, and it is said here rather than found
later.** Where a commitment the roster has stopped keeping or removed under the **target** group lies
earlier in the order than that group's first kept commitment, the arriving block is put after it — so
the roster SHALL afterwards answer about a date on which that commitment was still kept in the
opposite group order to the one it reads back today. That follows from the grouping rule rather than
from this act: a group sits where its first commitment sits, and on such a date the first one under
the target is the stopped one. It is accepted deliberately, as the narrower of two harms — what a
person taps lands where they aimed it, on the list they are looking at, every time, and the
disagreement is reachable only by scrolling back to a date before the stop. ADR-1044.

**Every commitment that does not travel SHALL afterwards be in the order it was in against every
other commitment that does not travel** — kept, stopped and removed alike — and no two of them SHALL
be reordered against each other. Nothing further is promised, and what is not promised is the price
of one order over one roster rather than an omission: a group whose commitments were scattered
through the order comes back **contiguous**, so a commitment under another category that lay between
two of them is afterwards on one side of the whole group. There is one order and every reading comes
off it, so a group cannot be moved in the reading without being moved in the order.

**On those two offsets the group SHALL NOT be taken out of the sequence at all**, and nothing in the
sequence SHALL move. They are the offset the group is at among the groups the roster is keeping under
a category, and the one just after it. The first names the group itself, and immediately before
itself is where it already stands; the second names the group that already follows it, or, where it
is the last of them, is the number of them, which is again where it already stands. The carve-out is
where a scattered group is **not** gathered, and that is the point of it: a person who asks for the
place a group already has has made no change, and gathering would be one. It follows — and is said
rather than left to be discovered — that moving a scattered group away and back does not restore the
roster it started with, because the first of the two moves gathered it.

**An offset is counted over the groups the roster is keeping that are under a category, and over
nothing else.** The group of the commitments under **no** category is not in that count, so there is
no offset that puts a group after it: the reading rule appends that group last wherever its
commitments sit, so such an offset could only draw exactly what the offset before it draws while
changing the order the roster holds — a change nobody could have asked for, which is the
silently-wrong-thing this roster's refusals exist to prevent. A category only a commitment it has
stopped keeping or removed is under is not in the count either, for the reason a stopped commitment
is not in a commitment move's own count: the groups a person is looking at when they move one are
the groups they are keeping.

The roster SHALL refuse to move a group in exactly two cases, and SHALL report each rather than doing
nothing silently, for the same reason a refused move of a commitment is reported:

- **a category no commitment it is keeping is under** — one nothing it holds has ever been under, one
  only a stopped or a removed commitment is under, and **no category at all**. The group of the
  commitments under none is a group the roster reads back and is not a group it moves: where that
  group sits is the reading rule's answer and not the person's.
- **an offset below 0, or above the number of groups it is keeping that are under a category.** Not
  clamped, for the reason a commitment's move is not: a clamp puts a group somewhere nobody asked
  for.

A roster asked either SHALL be left exactly as it was, **its categories included**.

**A group move changes no category, no commitment and no day.** It SHALL put nothing under anything:
every commitment travels under the category it was already under, which is the category that named
the group. The roster SHALL NOT be asked what day it is for a group move, SHALL NOT record when one
happened, SHALL NOT change any day a commitment was kept until or is kept from, and SHALL NOT change
which of the three states it holds any commitment in. Every record already made SHALL stand, and
every commitment SHALL go on answering whether it is due on a date exactly as it did before.

A roster SHALL be a value here too: moving a group SHALL leave every other roster untouched.

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

A commitments screen SHALL move a group on the list of what it keeps, on being given the **category**
naming that group and an **offset counted over the groups it draws that are under a category, as they
stand before the move**, and SHALL keep the move at the roster place before the list says so. It
SHALL ask for no confirmation and SHALL ask for nothing else: moving a group back is the undo, as it
is for a row. This is where the order the **groups** are drawn in — here and on a **day screen** —
is set, and it is the only place a person sets it.

**The offset is the screen's own count and the roster's alike, and this screen converts nothing.**
The groups it draws are the groups the roster answers with, in that order, so a place among the ones
under a category is the same place at both. That is the whole difference from moving a commitment,
whose offset is counted inside one group and has to be turned into a place in the roster's order
here; there is nothing of the sort to do for a group, and inventing an arithmetic would be this
screen holding a second copy of a rule.

**The group of the commitments under no category is not a group this act takes.** It draws no
heading, so there is nothing on the screen to take hold of; and the reading rule draws it last
wherever its commitments sit, so there is nowhere to put it. A screen asked for it does nothing and
says nothing, which is what it already answers for a group it draws none of.

**Everything under the category moves with the group, and the list of what the screen has stopped is
drawn in a different order afterwards.** That list is one flat list in the roster's own order, a
group move changes that order, and a stopped commitment under the moved category travels with the
group like every other. It is not a second rule and it is not a defect: both lists are read off the
roster after the change, and the alternative — a stopped list that held still — would be a second
order for something to keep in step.

**A group is drawn where the person put it, and a past day may draw the groups the other way round.**
The offset is counted over the groups this screen draws, so the group SHALL come to rest at that
offset on this list, every time. Where the group it was put before has a commitment the screen has
stopped lying earlier in the roster's order than the first one it keeps under that category, what is
kept at the roster place SHALL afterwards answer about a date before that stop with those two groups
in the opposite order. That is the roster's own rule read back through the place this screen keeps,
rather than a second rule of the screen's, and it is the accepted price of landing the group where it
was put.

A commitments screen asked to move a group it draws none of — a category nothing it keeps is under,
and no category at all among them — or to an offset that the groups it draws under a category do not
have SHALL do nothing and SHALL say nothing. Each asks for no change at all, by the rule that already
governs a commitment neither list holds, so the roster's own two refusals are never reached through
this screen and there is nothing for it to word.

A group move the screen could not keep at the roster place SHALL be refused as a roster that could
not be written, leaving both lists as they were, and it SHALL name the **category** it was asked to
move. That is a refused **group move**, and it is the only kind of refused change a commitments
screen holds that names something other than a commitment — a group is a category and the commitments
under it, a person tapped the heading, and naming one of the rows would point at a row they did not
touch.

**A group move that leaves a group where it is drawn changes nothing and says nothing.** It is not
refused, it changes neither list, and it does not answer a refused change the screen is already
holding: nothing reached the roster place, so nothing has been proved about it either way. Two
offsets do this for any group — the one it is drawn at among the groups under a category, and the one
just after it — which is the same arithmetic a drop back where a row already is runs on.

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
from, and SHALL answer that there is none where it holds no commitment at all. A roster holding one
commitment answers the day that commitment is kept from; a roster holding several answers the
earliest of their days.

**Every commitment the roster holds SHALL count**, including one it has stopped keeping and one it
has removed. Neither state SHALL raise the answer, and taking a commitment up again SHALL NOT lower
it, because it was never left out. The days of a stopped commitment still hold whatever was recorded
against it while it was kept, and an answer that rose when a commitment was retired would put a day
a person actually kept behind an answer that no longer reaches it. This is the same rule
`add-roster-removal` (#155) settled for removal — a roster never lets a commitment go — read over
one more question.

**The answer SHALL be the day a commitment is kept from, and never a day it is due.** A roster MUST
NOT consult a commitment's schedule, its name, its kind, its category or its place in the order: a
commitment kept from a day its schedule is not due on puts the answer on that day all the same, and
a commitment due on no day inside any span still counts. Whether a commitment is due is that
commitment's own answer to a different question.

The answer SHALL be asked of the roster and SHALL be handed nothing. This capability MUST NOT
consult the present moment, the device's time zone or the locale to find it, so a roster answers the
same way for ever until a commitment is taken on. It SHALL follow what the roster holds: a
commitment taken on with an earlier day lowers it, and one taken on with a later day leaves it
exactly as it was.

**This answer is the roster's rather than the commitment's**, deliberately. A commitment reads back
the name it was given and the kind its days take and nothing else — the day it is kept from is a
part it is made of, not a part it hands out — so the only way anything outside this capability can
learn where a person's history begins is to ask the roster the one aggregate question. This
requirement gives that question and no other, and it is what `day-screen` asks to bound its day
picker.

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

A roster SHALL change a commitment it holds for another, on being given the two and the **category**
to put the result under, which may be none. Changing SHALL put the second commitment in the place the
first held, SHALL leave the day that commitment was kept until and whether it was removed exactly as
they were, SHALL put it under the category it was offered under, and SHALL report that it changed.
Nothing else the roster holds SHALL move.

**This is a replacement and deliberately not a removal followed by an addition.** A commitment taken
on third stays third, one the roster has stopped stays stopped on the day it was kept until, and one
it has removed stays removed. Adding would put the result last in an order the person set, and
removing would put a kept-until day on a commitment nobody stopped keeping.

**The category is the offered one, whatever the commitment was under before**, for the reason it is
the offered one when a commitment is taken up again: a change is asked for by something holding a
form, and the category on that form is what the person is saying now. Being offered under no category
takes the category off.

A roster SHALL change a commitment in any of the three states it holds one in, and SHALL leave it in
the state it was in. Which commitments a person can reach in order to change one is a screen's
question and not a roster's: a roster draws no lists and offers nothing.

The roster SHALL refuse to change a commitment in exactly two cases, and SHALL report each rather
than doing nothing silently, for the same reason a refused addition is reported:

- a commitment the roster does not hold at all; and
- a change whose result is a commitment the roster **already holds** — kept, stopped or removed
  alike. This is stricter than what a roster refuses when it is offered a commitment, and the
  difference is deliberate: offering a stopped or removed commitment takes it up again, which is one
  history returning, while changing one commitment into another the roster holds would put two
  histories under one value with no way back to the fact that they were deliberately kept apart.

A roster asked to change a commitment **for itself** SHALL be left exactly as it was and SHALL report
that it changed, exactly as a move that puts a commitment back where it already is is accepted rather
than refused. A change that makes no change is not an error, and a roster asked for one has nothing
to refuse.

Changing SHALL change nothing about either commitment and nothing about what has been recorded
against either. What a record of the commitment that was replaced is now a record of is the `record`
capability's question, asked of a history and never of a roster; a roster holds no records and
carries none over.

A roster SHALL be a value here too: changing a commitment SHALL leave every other roster untouched,
and two rosters differing only in one commitment having been changed SHALL be different rosters.

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
calendar date — the day the superseded commitment was **kept until** — and the **category** to put
the commitment taking its place under, which may be none. Superseding SHALL do three things as one
act: record the date as the day the superseded commitment was kept until, hold that commitment as
**removed**, and take the other commitment on in the place the superseded one held, under the
category it was offered under. It SHALL report that it superseded.

**The commitment taking the place is the one that keeps it**, and the superseded commitment sits
immediately behind it in the roster's order. A person changing a rhythm has not asked for a row to
move, and appending the new commitment would send it to the end of an order they set. The superseded
commitment is drawn in neither of a screen's lists, so the only place the two are read together is a
date's answer, where they are adjacent and only one of them is ever due.

Superseding is the roster's answer to a person changing the rhythm a commitment runs on, and it is
carried this way because **a commitment has no identity of its own** and a record embeds the whole
commitment by value: a rhythm that could change on the commitment would orphan every record already
made against it. ADR-1023 and ADR-1030, both amended for this Story.

The roster SHALL refuse to supersede in exactly two cases, and SHALL report each:

- a commitment the roster is **not keeping** — one it does not hold, one it has stopped keeping, and
  one it has removed alike. There is nothing for a rhythm to decide about days a commitment has none
  of; and
- a superseding commitment the roster **already holds**, kept, stopped or removed alike, for the
  reason a change into one it already holds is refused. A commitment asked to supersede **itself** is
  refused by that same rule and asks for nothing.

The roster SHALL refuse on no date. Any calendar date the system supports SHALL be accepted as the
day the superseded commitment was kept until, including the first and the last, and including a date
earlier than the day that commitment is kept from: such a commitment is one the roster was keeping on
no date at all, exactly as a stop on such a date already leaves one. As everywhere else, the roster
SHALL NOT ask what day it is, SHALL NOT judge either commitment's schedule, and SHALL NOT decide
whether either is due.

Superseding SHALL change nothing about either commitment and nothing about what has been recorded
against either, and **the roster SHALL hold no link between the two**. Nothing reads one, and a
surface with no reader is not a requirement; the cost is that one commitment's record across a change
cannot afterwards be read as a single run.

A roster SHALL be a value here too: superseding SHALL leave every other roster untouched, and two
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
asked with — the **name** it has, the **rhythm** it runs on, the **day it is kept from** and the
**category** it is under — so that a form opened to change it starts from what that commitment is
rather than from what a new one would be. For a commitment on neither of its lists it SHALL say
nothing at all.

The rhythm it says SHALL be the one of the four that names that commitment's schedule, carrying the
number that schedule carries. An **interval** rhythm carries no start date, so an interval schedule's
own start date is not part of what is said; the day the commitment is kept from is said separately,
and on a commitment this screen defined the two are the same day. There is no rhythm a commitment's
schedule cannot be said as, because every schedule this screen can define one on was named by a
rhythm in the first place.

It SHALL also say **whether the rhythm and the day kept from can be changed at all**: they can for a
commitment its roster is keeping, and they cannot for one it has stopped keeping. A stopped
commitment has no days left for a rhythm to decide about, so the only change it takes is a rename.

It SHALL also say the **kind** that commitment's days take, together with the **range** or the
**target** that kind carries: the number kind's range, or that it carries none; the total kind's
target; and nothing beside a tick or a note, which carry nothing. The kind is **not** among the four
a change is asked with and never will be — a kind is set when a commitment is defined and changing
one is what defining a different commitment is — so this is said to be *shown* and never to be asked
about. Nothing needs saying about whether it can be changed, which is where it parts from the rhythm
and the day kept from: no commitment's kind can be, so there is no per-commitment answer to give.

**It is said because a form that had lost it would read as a different form.** Someone opening
"Mood" should see Number, 1 to 10 — the five things they defined it from — rather than a sheet that
has quietly shed two of them, and a screen that said nothing would leave whatever draws it to
invent what a form shows. This is the same answer the rhythm and the day kept from already get for a
**stopped** commitment: every control is there, and the ones that cannot be changed do not let a
thumb in. What a form draws and which of its fields a thumb reaches are the drawing's, exactly as
they already are for everything else this screen answers.

This says what a commitment *is*, and no words a person reads. What a form draws, where it is reached
from and which of its fields it lets a thumb into are the drawing's, exactly as they already are for
everything else this screen answers. ADR-1022.

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

### Requirement: A commitments screen changes a commitment on either of its lists

A commitments screen SHALL change a commitment on either of its lists, from four things and no
others: a **name**, a **rhythm**, the **day it is kept from**, and the **category** to put it under,
which may be none. They are four of the **five** a commitment is defined from, and the fifth is the
**kind** its days take: a kind is set when a commitment is defined and never changes, so a change is
neither asked for one nor able to produce one. A form opened to change a commitment shows that
commitment's kind, because *A commitments screen says what a commitment it is asked to change is made
of* says it — showing a thing and asking for it are different, and a change does only the first. It
SHALL work out from those four which of two acts the change needs, and where it needs both it SHALL
perform them in one order and no other.

- **A different name, a different day kept from, or both, on the rhythm the commitment already runs
  on.** The screen SHALL carry every record of that commitment over to the changed one at the record
  place, and SHALL then change the commitment for the changed one at the roster place, in the place
  the roster holds it. Every past day afterwards draws the changed commitment and answers about it
  exactly as it answered about the one it replaced. **A name is not a rule** — nothing is due or not
  due because of it — and **the day a commitment is kept from is a claim about a person's own
  history** rather than a rule about days ahead, so correcting either corrects the whole of what has
  been kept rather than starting something new.
- **A different rhythm.** The screen SHALL supersede: the commitment is kept until the day **before**
  the day the screen was handed and held removed, and the commitment the four things name — kept from
  the day the screen was handed — is taken on in its place. **No record moves and no past day
  changes its answer**: the new rhythm decides the days from today onward and every day already lived
  answers exactly as it did (ADR-1013).
- **Both, in one save: the carry-over first, then the supersession.** It is the only order that
  satisfies the two rules above at once — the superseded commitment then carries the new name and the
  corrected day it was kept from, so every past day redraws correctly, while the commitment taken on
  carries the new name, the new rhythm and the day the screen was handed as the day it is kept from.
  The day the person typed into the field reaches the past, which is what they were correcting, and
  not the commitment starting today, which cannot begin before today without rewriting the days
  behind it.

**On an interval rhythm the day a commitment is kept from is also the rhythm's start date, and
changing that day moves the grid with it.** A commitment kept every N days from one day is due on that
day and every N days after it, so a change that names a different day SHALL form the changed
commitment's schedule from the day the change names, exactly as defining one does: one date is offered
and one date answers for both, and a person is never asked for a second. The days such a commitment
was due on before the change are therefore not the days it is due on after it. On the other three
rhythms — a weekday set, a day of the month, a weekly quota — dueness does not depend on the day kept
from at all, so moving that day earlier only widens the window and every day already recorded on stays
due. That difference is why the refusal below is about what the change would leave, and never about
which way the day moved.

**The record place is written before the roster place, and that order is part of the decision.** The
two are separate files and nothing makes one write of both. Written the other way round, a roster
that took the change and a record place that then refused it would leave a past day drawing a
commitment it holds no record of, and asking for the same change again could not repair it, because
the commitment the second ask names as the one to change is no longer the one the records are under.
In the order stated, the same second ask carries nothing over — there is nothing left under the old
commitment — and then writes the roster, which is exactly the repair. Where nothing is carried over,
nothing is written at the record place at all.

**The kind its days take is not one of the four and SHALL NOT change.** The changed commitment SHALL
be of the kind the commitment it replaces is of, on every one of the acts above, and SHALL carry
whatever that kind carries unchanged with it — the **range** a number kind declares and the **target**
a total kind requires travel with the kind and are no more asked for here than it is. ADR-1030. A
fifth thing asked for here would buy a refusal for a state the form cannot produce, and the way a
person gets the commitment they now want is the way this capability has always given them: define
it, which leaves the one they had exactly as it stands, with everything recorded against it.

**A change is the only act on this screen that writes a category without a move.** The category is
one of the four, picked from the categories the screen offers or typed; a commitment given one is
drawn in that category's group and a category of nothing but blank space takes it off, exactly as
defining one does. What a commitments screen no longer does is put a commitment under a category as
an act of its own, so a change is the whole of how a person refiles without dragging. The other way
a category changes on this screen is a **move**: a commitment dropped into another group is put
under that group's category by the same act, because the place a drop names is inside a group. That
is *A commitments screen moves a commitment among the ones it keeps*, which this change leaves
untouched, and the two do not need keeping in step — a drag says where a row sits and takes the
category of where it landed, and a change says what the commitment is.

**Where the four things name the commitment that is already there, and the category it is already
under**, the screen SHALL change nothing, SHALL write nothing at either place and SHALL refuse
nothing. Closing a form opened by accident is not an error.

**A commitment its roster has stopped keeping SHALL be changed in name and category only**, and a
change asking for a different rhythm or a different day kept from on one SHALL be refused as a change
a stopped commitment does not take, told apart from every other refusal, because what a person does
about it — take the commitment up again first — is theirs to do. A commitment its roster has
**removed** is on neither of this screen's lists; a screen asked to change one, or to change any
commitment on neither list, SHALL do nothing and SHALL say nothing, exactly as it already answers
every other change asked about a commitment it does not have.

A change SHALL be refused in the words this screen already uses wherever it already has them, and
for the same reasons: a **name that says nothing**, a **weekday set with no days in it**, a **rhythm
number the calendar will not take**, a **commitment the roster already holds** and a **place that
could not be written**. The fourth is stricter here than it is for defining, and that is the
decision: defining a commitment the roster has stopped or removed takes that commitment up again,
while changing one *into* it would put two histories under one value, so a change whose result the
roster holds in **any** of the three states is refused. The fifth covers the record place as well as
the roster place: neither leaves a person anything to do but try again later, so the two are told the
same way.

Two refusals are this change's own, because nothing before it could produce them, and each SHALL be
told apart from the other five for the reason ADR-1036 gives — a person can act on each, and on each
differently:

- **A change a stopped commitment does not take**, above: take the commitment up again first.
- **A day already recorded on that the change would leave not due.** A change SHALL be refused where
  any day the commitment has a record on is a day the changed commitment is not due on, and carrying
  the record over to a day it could not have been made on is not something this system does. Moving
  the day a commitment is kept from *later* can strand a recorded day on any of the four rhythms. On
  an interval rhythm, where the grid moves with the day, moving it **earlier** does the same: unless
  the day moves by a whole number of intervals, every day already recorded on falls off the new grid.
  What a person does about it is pick a day that leaves every recorded day due, or leave the day
  alone.

Nothing SHALL be kept at either place by a refused change, and neither of the screen's lists SHALL
move.

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

#### Scenario: the day an interval commitment is kept from is moved earlier and every day it is due on moves with it

- **WHEN** a commitment named "Contact lenses" on an interval rhythm of 14 days, kept from Wednesday
  1 July 2026, is taken on at a roster place; a commitments screen is opened at that roster place as
  of Monday 31 August 2026; and "Contact lenses" is changed through it to the day kept from Monday
  29 June 2026, on the name and the rhythm it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is due on Monday 29 June
  2026 and on Monday 13 July 2026
- **AND** it is not due on Wednesday 1 July 2026

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

### Requirement: A commitments screen offers the categories in use

**A commitments screen SHALL offer the categories already in use**, so that a person picks one
rather than typing it again. They SHALL be the categories the commitments it **keeps** are under,
each once, in the order the screen draws its groups; a screen keeping nothing under any category
SHALL offer none. They are read off the roster the screen is drawing rather than held anywhere, so a
category whose last kept commitment has been put under another is gone from what is offered at the
same moment its heading goes, and a category is never offered that no heading shows.

**The offering is what makes typing safe rather than a convenience.** A phone capitalises the first
letter of a field, so "Supplements" typed once and "supplements" typed the next time would silently
become two groups — and the alternative, folding case when matching, would have the app decide which
spelling a person meant. Offering the words already in use removes the problem instead of judging
the owner's words. A category a person types that matches none of them is accepted exactly as typed
and becomes a group of its own, which is how the first commitment under a new category gets there.

**Two spellings that differ only in case are two categories, and SHALL be offered as two.** The
screen MUST NOT fold the case of a category and MUST NOT match one loosely against a category
already in use, here or anywhere else it handles one: a screen that folded case would be choosing
which of a person's spellings a heading shows. What it offers is what the roster holds, exactly as
the roster holds it.

**A category on a commitment the screen has stopped is not offered**, and that is deliberate rather
than an omission: the categories offered are the ones a heading is drawn for, the stopped list draws
no headings, and a stopped commitment brings its own category back with it when it is taken up again
in one tap. Nothing is lost by leaving it out, and offering it would draw a word from a list nobody
is looking at.

**What is offered is picked on the act that writes a category without a move: a change.** The
category is one of the four things a change is made of, so a person who wants a word already in use
takes it from what this requirement offers rather than typing it a second time, and the screen that
offers a word is the screen that writes it. A **move** writes a category too — a commitment dropped
into another group is put under that group's category by the same act — but a move needs no
offering: the word it writes is the one the group it landed in already carries.

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

A commitments screen SHALL refuse to define a commitment of the **number** kind whose range is not a
range, and one of the **total** kind whose target is not a target. Nothing SHALL be kept at the roster
place, neither of the screen's lists SHALL change, and each SHALL be held as a refused change against
**defining a commitment**, exactly as every other refusal this screen makes is.

**A range is not a range** when its lowest is above its highest, when either end is not a number, or
when one end holds something and the other is blank. **A target is not a target** when it is not a
number, when it is not above zero, or when it is blank — a total whose sum has nothing to reach is
not a total, so a missing target is a refusal here rather than a commitment with none.

**Two refusals, not six and not one.** The three ways a range fails are one refusal, told apart from
every other this screen makes but not from each other, because what a person does about any of them
is the same thing: put something else in the two fields they are already looking at. The three ways a
target fails are one refusal for the same reason, over the one field. The two are told apart from
each other, because the fields differ and so does the act. That is ADR-1021's rule applied exactly
where *A commitments screen refuses a rhythm number the calendar will not take* already applies it,
and it is why this Story adds two reasons a change can be refused for while adding no new kind of
change to be refused: the kinds of change a person can ask for are counted in *A commitments screen
holds the change it refused and why, one at a time* and are untouched here.

**This screen refuses exactly what the value refuses, and invents nothing.** A range whose lowest is
above its highest, a range end that is not a number, a target that is not above zero and a target that
is not a number are each a refusal `commitment` already makes where the value is formed; this is that
refusal surfaced in something a person can read, and not a second one. The `commitment` capability's
rules for a range and a target are unchanged by this requirement. It is therefore the opposite of a
weekday set with no days in it, which is a value the rule engine accepts and this screen refuses
(ADR-1028), and the same shape as the rhythm numbers, which the engine refuses to form at all.

**A half-written range is the one of the six the value cannot be asked about**, because a range is
both ends or neither and there is no such value as half a range to offer anything. It is refused here
for the reason the value has none: a typed floor is something a person deliberately entered, and
reading it as "no range at all" throws away what they said, while inventing the other end would put a
bound on their commitment that nobody typed. Both ends blank is not this refusal and is not a refusal
at all — it is a commitment of the number kind carrying no range, which the requirement above says.

**What a range and a target allow SHALL be accepted at both ends of it.** A lowest equal to its
highest is a range of exactly one value; a range end may be negative and may be zero; and a target
may carry a decimal fraction and SHALL NOT be rounded to a whole number, so the smallest target this
screen takes is the smallest number above zero it can read and never one. A number typed with more
significant digits than this system keeps exactly is **not a number** by the reading the requirement
above fixes, and is refused as such rather than kept shortened.

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
