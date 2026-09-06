## ADDED Requirements

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

### Requirement: A roster store reads a roster kept before a commitment carried a kind

A roster store SHALL read a roster kept in the form written before a commitment carried a kind,
rather than refusing it, and SHALL read every commitment in it as being of the plain kind. That form
holds no kind for any commitment, and a tick is what every one of them was: reading them any other
way would change what a person keeps, and refusing them would tell a person who has kept a roster
since before this change that they keep nothing.

Reading a roster kept in an earlier form MUST NOT change what is at the place. A store writes on a
change being kept and at no other moment, so opening the app and doing nothing SHALL leave the
content byte-for-byte what it was, in the form it was already in. The next change kept there SHALL
be written in the form this app writes, whole, and everything the earlier form held SHALL still be
in it — the order the commitments were taken on, every day one was kept until, and every part of
every commitment.

The forms a roster store reads SHALL be exactly the ones this app has written: the form it writes
now and the form written before a commitment carried a kind. It SHALL NOT weaken the refusal of a
form *later* than the one it writes, which is a form it cannot know the shape of, and it SHALL
refuse a form number it has never written at all — one below the earliest — as content that is not a
roster store, because a number no version of this app ever wrote says nothing about the shape of
what follows it.

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

## MODIFIED Requirements

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
it. Changing what a person keeps is changing a commitment, which is a want of its own and not this.

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

### Requirement: A roster refuses a commitment it already holds

A roster SHALL refuse a commitment equal to one it is already keeping — one it holds and has not
stopped keeping. Refusing SHALL leave the roster exactly as it was — the same commitments, in the
same order, with the one already held keeping the position it had — and the roster SHALL report that
the commitment was not added. Adding a commitment a roster does not hold at all SHALL place it after
every commitment already there and SHALL report that it was added.

A commitment the roster has stopped keeping is one it still holds, and offering it again SHALL take
it up again rather than being refused. The roster SHALL drop the day that commitment was kept until,
SHALL read the commitment back once more among the commitments it keeps, in the place it was taken
on in rather than at the end, and SHALL report that the roster now keeps it — the same report an
addition makes, because it says the same thing. It SHALL NOT hold the commitment twice, and there
SHALL be no second way to take one up again: offering it is the way.

Taking a commitment up again SHALL change what the dates between the day it was kept until and the
day it was offered again answer about that commitment, and that is the decision rather than an
oversight. A roster holds at most one kept-until day for a commitment and holds no span of them, so
a commitment with no kept-until day is one it was keeping on every date. The alternative — refusing,
so that starting again means a commitment kept from a different day — was weighed and rejected: it
leaves a mis-tapped stop with no way back, and the commitment that came back would be a different
one, losing the place it was taken on in and starting a fresh history. What was actually done on
those days is untouched either way, because that is the ticks and no tick moves. What a screen
offers, and whether it says that the days between will read as kept, is the screen's.

Reporting is part of the refusal and MUST NOT be dropped. A caller that does not care may ignore
what it is told, but a caller that does care cannot recover a report that was never made: doing
nothing and saying nothing is indistinguishable to a person from having added a second commitment,
which is the one thing a roster exists to prevent. Whether anything is said on a screen, and in what
words, is not this requirement's — it is what a screen does with the report.

Two commitments are the same commitment when their name, their schedule, the day they are kept from
and the kind their days take are all the same, and a roster SHALL use those four and nothing else to
decide what it already holds — both when it refuses one it is keeping and when it takes one up again
that it had stopped. It MUST NOT invent a coarser sameness of its own: two commitments alike in name
but differing in schedule, in the day they are kept from or in the kind their days take are
different commitments and a roster SHALL hold both, and two names differing only by blank space are
different names, because a commitment's name is stored exactly as it was given and tidying it
belongs where a person typed it. A weight and a mood kept under one name, on one rhythm, from one
day differ in what their days hold and are two commitments; a roster judging them alike would leave
a person unable to say which of the two a screen was pointing at.

This is why the refusal exists at all. A commitment carries no identifier, so a roster holding two
commitments a person would call identical could not be told which of them to stop keeping, which of
them to change, or which of them a screen was pointing at. There is nothing to tell them apart by,
and so there must not be two.

A roster SHALL refuse nothing else that it is offered to add. It MUST NOT judge a name, a schedule,
a day a commitment is kept from or a kind — anything that is a commitment at all was already
accepted when the commitment was formed, and a range that could not be a range or a target that
could not be a target never reached a commitment to be offered here — it MUST NOT refuse on how many
commitments it holds, and it MUST NOT refuse on a date. What a roster refuses when it is asked to
*stop* keeping a commitment is a separate rule, and this one neither states it nor narrows it.

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

### Requirement: A roster store keeps a roster at a place, across the app being closed and opened again

A roster store SHALL be opened at a place, and SHALL hold a roster: every commitment taken on
through it, in the order it was taken on, and against each commitment it has stopped keeping, the
day that commitment was kept until. Opening a roster store at a place where nothing has been kept
SHALL give a roster holding nothing rather than an error — that is what the first launch looks like,
and it is the only time a roster store opens holding nothing.

A commitment taken on through a roster store SHALL be kept at that place before the store reports it
taken on, so that a store opened at the same place afterwards — by the app opened again, or by
anything else, and whether or not the first store was ever closed — holds it. Stopping a commitment
SHALL be kept the same way, and so SHALL taking one up again. There is no separate step at which a
roster store is saved: the app can be stopped at any moment without warning, and a commitment waiting
to be saved would be one a person believes they have taken on. A roster store that cannot keep a
change MUST refuse it and MUST NOT hold it: the roster a store reports is never ahead of what is kept
at its place.

A roster store SHALL report exactly what the roster reports, and MUST NOT turn a roster's own refusal
into an error. Offering a commitment the roster is already keeping, asking it to stop keeping one it
does not hold, and asking it to stop keeping one it has already stopped each leave the roster exactly
as it was — so nothing is kept at the place, and the store says what the roster said. What a roster
accepts, what it refuses and what it takes up again are the roster's own rules, stated above, and a
store adds nothing to them and takes nothing away.

A roster store SHALL persist exactly what a roster is — each commitment with the name, the
schedule, the day it is kept from and the kind its days take that the commitment is made of,
together with whatever that kind carries, and against each stopped commitment the day it was kept
until — and nothing it invented. A number commitment's range SHALL be kept where it has one and
SHALL be absent where it has none, both ends exactly as they were given; a total commitment's
target SHALL be kept exactly as it was given, decimal fraction and all, and MUST NOT be rounded,
widened or narrowed on the way in or out. It SHALL keep the commitments in the order they were
taken on and read them back in that order, because the order is one of the things a roster is; a
roster store MUST NOT impose an order of its own, and MUST NOT sort by name, by a day or by
anything else. A roster read back SHALL be the same roster that was kept, for every schedule
shape, for every kind, for any name a commitment can have, and for any date the system supports.
The store MUST NOT key anything to the moment it was entered, MUST NOT record the day a commitment
was taken on, and MUST NOT pass a calendar date through an instant, a time zone or a locale on the
way in or out.

Roster stores at different places SHALL be independent of each other, and a roster store SHALL be
independent of any store keeping anything else: taking on a commitment or stopping one MUST NOT
change what is kept at any other place.

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
