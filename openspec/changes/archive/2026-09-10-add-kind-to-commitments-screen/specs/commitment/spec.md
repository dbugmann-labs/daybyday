## ADDED Requirements

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

## MODIFIED Requirements

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

