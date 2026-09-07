## MODIFIED Requirements

### Requirement: A roster holds the commitments a person keeps, in the order they were taken on

A roster SHALL hold commitments, in the order they were added to it, and SHALL read back, in that
order, every commitment it has not stopped keeping. A roster that has been given no commitment SHALL
hold none, and SHALL be an answer rather than a refusal: a person who keeps nothing yet has an empty
roster, not a missing one. There SHALL be no upper bound on how many commitments a roster holds.

The order SHALL be the order they were taken on and nothing else. A roster MUST NOT sort its
commitments by name, by the day each is kept from, by the schedule each runs on, or by any other
property of them. It has no order of its own to invent: day one's commitments are all kept from the
same day, so an order taken from that day would leave them tied and the roster choosing between
them, and an order taken from a name would be a rule about the owner's own words. This is the same
reason a day view orders nothing of its own and shows what it was handed in the order it was handed
it.

A roster SHALL hold commitments and, for each commitment, at most two further things: the day that
commitment was **kept until**, where the roster has stopped keeping it or removed it, and **that it
was removed**, where it has been removed. It holds nothing else. It MUST NOT give a commitment an
identifier, a position a commitment can be asked for, a record of the day it was added, or any other
state of its own, and it MUST NOT alter a commitment it holds: a commitment read back out of a
roster SHALL be the commitment that was put in, with the same name, the same schedule and the same
day it is kept from. Neither the day a commitment was kept until nor its having been removed is ever
the commitment's: a commitment SHALL NOT gain a fourth part by being stopped or removed, and it
SHALL go on answering whether it is due on a date exactly as it did before.

**Kept, stopped and removed are the three states a roster holds a commitment in**, and a commitment
it holds is in exactly one of them. A commitment it is keeping has no kept-until day and has not been
removed; one it has stopped keeping has a kept-until day and has not been removed; one it has
removed has a kept-until day and has been removed. **A roster never lets a commitment go**: nothing
takes a commitment out of a roster, so a roster that has ever been given a commitment SHALL NOT be
the same roster as one that has been given none, whatever has since been done to what it holds.

A roster SHALL NOT consult the present moment, the device's clock, its time zone or its locale, and
SHALL NOT be asked what day it is; every date it works with SHALL be one it was handed. It SHALL
judge a date in one way only: against a day it was told a commitment was kept until. It MUST NOT
judge a commitment's own day it is kept from, MUST NOT judge a schedule, and MUST NOT decide whether
a commitment is due — a commitment kept from a day long past and a commitment kept from the last
date the system supports are held alike, and whether either is due on any date is the commitment's
own answer and not the roster's.

A roster SHALL be a value. Two rosters holding the same commitments in the same order, each in the
same one of the three states and each with the same kept-until day where it has one, SHALL be the
same roster, and two holding the same commitments in a different order SHALL be different rosters,
because the order is one of the things a roster holds. Adding a commitment to a roster, stopping
one, or removing one SHALL leave every other roster untouched, so a roster that was copied before
any of the three SHALL still hold what it held.

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

A roster SHALL refuse a commitment equal to one it is already keeping — one it holds and has neither
stopped keeping nor removed. Refusing SHALL leave the roster exactly as it was — the same
commitments, in the same order, with the one already held keeping the position it had — and the
roster SHALL report that the commitment was not added. Adding a commitment a roster does not hold at
all SHALL place it after every commitment already there and SHALL report that it was added.

A commitment the roster has stopped keeping is one it still holds, and offering it again SHALL take
it up again rather than being refused. **A commitment the roster has removed is one it still holds
too, and offering it again SHALL take it up again in exactly the same way** — that is the one way
back from a removal, and it exists because a roster never lets a commitment go. In both cases the
roster SHALL drop the day that commitment was kept until, SHALL no longer hold it as removed, SHALL
read the commitment back once more among the commitments it keeps, in the place it was taken on in
rather than at the end, and SHALL report that the roster now keeps it — the same report an addition
makes, because it says the same thing. It SHALL NOT hold the commitment twice, and there SHALL be no
second way to take one up again: offering it is the way, whichever of the two states it was in.

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
decide what it already holds — when it refuses one it is keeping, and when it takes one up again
that it had stopped or removed. It MUST NOT invent a coarser sameness of its own: two commitments
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
a day a commitment is kept from or a kind — anything that is a commitment at all was already
accepted when the commitment was formed, and a range that could not be a range or a target that
could not be a target never reached a commitment to be offered here — it MUST NOT refuse on how many
commitments it holds, and it MUST NOT refuse on a date. What a roster refuses when it is asked to
*stop* keeping a commitment, and when it is asked to *remove* one, are separate rules, and this one
neither states them nor narrows them.

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
answer SHALL be in the order the commitments were taken on, the same order the roster reads them
back in, with a stopped or removed commitment in the place it has always had rather than at either
end.

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

### Requirement: A roster store keeps a roster at a place, across the app being closed and opened again

A roster store SHALL be opened at a place, and SHALL hold a roster: every commitment taken on
through it, in the order it was taken on, and against each commitment it has stopped keeping or
removed, the day that commitment was kept until, and against each commitment it has removed, that it
was removed. Opening a roster store at a place where nothing has been kept SHALL give a roster
holding nothing rather than an error — that is what the first launch looks like, and it is the only
time a roster store opens holding nothing.

A commitment taken on through a roster store SHALL be kept at that place before the store reports it
taken on, so that a store opened at the same place afterwards — by the app opened again, or by
anything else, and whether or not the first store was ever closed — holds it. Stopping a commitment
SHALL be kept the same way, and so SHALL removing one, and so SHALL taking one up again. There is no
separate step at which a roster store is saved: the app can be stopped at any moment without
warning, and a commitment waiting to be saved would be one a person believes they have taken on. A
roster store that cannot keep a change MUST refuse it and MUST NOT hold it: the roster a store
reports is never ahead of what is kept at its place.

A roster store SHALL report exactly what the roster reports, and MUST NOT turn a roster's own refusal
into an error. Offering a commitment the roster is already keeping, asking it to stop keeping one it
does not hold, asking it to stop keeping one it has already stopped or removed, and asking it to
remove one it does not hold or has already removed each leave the roster exactly as it was — so
nothing is kept at the place, and the store says what the roster said. What a roster accepts, what it
refuses and what it takes up again are the roster's own rules, stated above, and a store adds nothing
to them and takes nothing away.

A roster store SHALL persist exactly what a roster is — each commitment with the name, the
schedule, the day it is kept from and the kind its days take that the commitment is made of,
together with whatever that kind carries; against each stopped or removed commitment the day it was
kept until; and against each removed commitment that it was removed — and nothing it invented. A
number commitment's range SHALL be kept where it has one and SHALL be absent where it has none, both
ends exactly as they were given; a total commitment's target SHALL be kept exactly as it was given,
decimal fraction and all, and MUST NOT be rounded, widened or narrowed on the way in or out. It
SHALL keep the commitments in the order they were taken on and read them back in that order, because
the order is one of the things a roster is; a roster store MUST NOT impose an order of its own, and
MUST NOT sort by name, by a day or by anything else. A roster read back SHALL be the same roster
that was kept, for every schedule shape, for every kind, for any name a commitment can have, for any
date the system supports, and for each of the three states a roster holds a commitment in. The store
MUST NOT key anything to the moment it was entered, MUST NOT record the day a commitment was taken
on, and MUST NOT pass a calendar date through an instant, a time zone or a locale on the way in or
out.

Roster stores at different places SHALL be independent of each other, and a roster store SHALL be
independent of any store keeping anything else: taking on a commitment, stopping one or removing one
MUST NOT change what is kept at any other place.

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

### Requirement: A roster store reads a roster kept before a commitment carried a kind

A roster store SHALL read a roster kept in any form this app has written before the one it writes
now, rather than refusing it, and SHALL read each such roster as the roster it was. Two earlier forms
exist. The form written **before a commitment carried a kind** holds no kind for any commitment, and
every commitment in it SHALL be read as being of the plain kind — a tick is what every one of them
was: reading them any other way would change what a person keeps, and refusing them would tell a
person who has kept a roster since before this change that they keep nothing. The form written
**before a commitment could be removed** holds nothing about removal for any commitment, and every
commitment in it SHALL be read as one the roster has not removed, which every one of them was.

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
form this app writes and saying nothing about removal. Reading it any other way would make the
declared form decorative — every form would accept every other form's shape — and would launder a
file this app never wrote into a current-form one the next time something was kept there. The rule
that a commitment carrying no kind is read as a tick is unchanged and is stated above; that is what
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

#### Scenario: a roster store holding a commitment removed with no day it was kept until is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment is held as removed and carries no day it was kept until
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

### Requirement: A commitments screen lists the commitments its roster keeps, in the order they were taken on

A commitments screen SHALL hold a roster, read at the place it keeps its roster, and SHALL list the
commitments that roster is keeping, in the order the roster answers with. A commitment the roster
has stopped keeping MUST NOT be in that list, and neither MUST a commitment the roster has removed.

An entry in the list SHALL be a commitment's name and the rhythm it runs on **in words**, and
nothing else. The words are the ones the `schedule` capability says for the schedule that
commitment carries, read off the commitment the entry is for: this screen composes none of them and
chooses none of them, so an entry and a day screen's row say one rhythm the same way. An entry
SHALL NOT say the kind its days take, which is the surface `add-kind-to-commitments-screen` (#142)
adds, and SHALL NOT say the day the commitment is kept from, which says when it began rather than
what rhythm it runs on.

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

A roster holding nothing at all SHALL be listed as nothing at all. A commitments screen MUST NOT
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

### Requirement: A commitments screen lists what has been stopped, beside what it keeps

A commitments screen SHALL list, separately from the commitments its roster is keeping, the
commitments that roster has stopped keeping — in the order they were taken on, each as a name and
the rhythm it runs on in words, exactly as the first list is. **A commitment the roster has removed
SHALL be in neither list**; every other commitment the roster holds SHALL be in exactly one of the
two and never in both.

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

### Requirement: A commitments screen defines a commitment from a name, a rhythm and the day it is kept from

A commitments screen SHALL define a commitment from three things and no others: a name, a rhythm,
and the day it is kept from. The commitment so formed SHALL be taken on at the roster place before
either of the screen's lists says so, and SHALL then be last in what the screen keeps, because that
is the place the roster gives it — **unless the roster already holds that commitment stopped or
removed, in which case it is taken up again in the place it was taken on in**, again because that is
the place the roster gives it. Defining is therefore the one way back to a removed commitment, and
the screen does nothing of its own to make it so: it hands the roster three things and reports what
the roster answers.

A **rhythm** SHALL be one of four, and all four SHALL be offered: a weekday set, a day of the
month, an interval of a whole number of days, and a weekly quota. A rhythm carries nothing the
calendar does not supply — in particular an interval rhythm carries no start date.

Three of the four are a number, and a rhythm SHALL carry that number as the person gave it, judged
by nothing on the way. A rhythm is what a person said, not what the system was able to make of it,
so the judging happens in one place — the screen, when it is asked to define — and the requirement
below says what it does there.

**The day a commitment is kept from SHALL also be the start date of an interval rhythm.** The
commitment is due on the day a person started keeping it and every N days after it. The two remain
distinct in the model and may disagree where something other than this screen forms the commitment;
this screen offers one date and uses it for both.

A commitments screen SHALL offer, as the day to keep a commitment from, the day it was handed. It
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

### Requirement: A commitments screen asks you to confirm before it stops keeping a commitment

A commitments screen SHALL be asked to stop keeping a commitment, and SHALL change nothing until
that stop is confirmed. Until then it SHALL hold exactly which commitment is awaiting confirmation,
so that a person can be told which one they are about to stop; being asked about a second
commitment SHALL replace the first, since only one stop can be awaiting confirmation at a time.
**A commitments screen SHALL have at most one change awaiting confirmation of any kind**, so being
asked to stop keeping a commitment SHALL leave nothing awaiting removal, and being asked to remove
one SHALL leave nothing awaiting a stop. A person is answering one question at a time, and a screen
holding two would have to be drawn twice over.

A stop that is cancelled SHALL leave the screen's two lists, and what is at the roster place,
exactly as they were, and SHALL leave nothing awaiting confirmation. Confirming SHALL do the same
when there is nothing awaiting confirmation.

A confirmed stop SHALL stop keeping the commitment **as of the day before the one the screen was
handed**, that day being the last day it was kept, and SHALL keep that at the roster place before
either list says so. The commitment SHALL then be in what the screen has stopped and not in what it
keeps, in the place it was taken on in. A commitments screen holds one day and no other, so it
offers no date to pick.

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
recover.

Defining a commitment through such a screen SHALL be refused as a roster that could not be written.
Asking it to stop keeping a commitment, to take one up again, or to remove one SHALL do nothing and
say nothing, by the rule that already governs a commitment neither list holds: both its lists are
empty, so there is nothing there to stop, nothing there to take up and nothing there to remove.

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

### Requirement: A commitments screen holds the change it refused and why, one at a time

Where a change asked of a commitments screen is refused, the screen SHALL hold **which change was
asked for** and **why it was refused**, as well as answering the refusal to the caller. The two are
not alternatives and neither replaces the other: the refusal answered to the caller is what a test
asserts on and what stops a shell drawn later from swallowing the failure a second time, and what
the screen holds is what a person is told from. A screen that only answered would leave how long a
person is told for to whatever drew it, and that lifetime would then be decided in a layer nothing
regresses.

The change it holds SHALL be one of the four a person can ask for — defining a commitment, stopping
keeping one, taking a stopped one up again, or removing one — and for the three that are asked about
a commitment already on one of its lists, it SHALL name that commitment. Which change it was is not
decoration: a person is told beside the thing they asked for, and the only other way to place the
message is for whatever draws the screen to remember which call it made.

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
lists, confirming a removal when nothing is awaiting removal, and **confirming a removal while the
name typed back does not match** each answer nothing and change nothing, so each SHALL leave the
screen holding no refused change and SHALL leave whatever it is already holding exactly as it was.
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

### Requirement: What a commitments screen holds about a refused change lasts until the app is shown again or a change is kept

A commitments screen SHALL go on holding a refused change until one of exactly two things happens,
and SHALL then hold nothing. Nothing else SHALL end it. Time passing in particular SHALL NOT,
because this capability reads no clock.

**The app being shown again** ends it. That is inherited rather than added: being shown reads the
roster place afresh and forms both lists again from what is then there, and what was refused is an
answer about a place that has since been read again. It SHALL end whether or not the roster can then
be read — a screen that is then not keeping a roster says that instead, and says more than a refused
change ever could.

**A change reaching the roster place** ends it, whichever of the four it was and whichever change
was refused before it. Defining a commitment that is taken on, a stop that is kept, a take-up-again
that is kept and a removal that is kept all count. This is one rule rather than four because it is
the at-most-one rule above read the other way round: a commitments screen holds the outcome of the
last change asked of it, so a change that is asked for and kept leaves nothing to hold. A person who
has just been told a change landed is not also told that an earlier one did not.

A call that reaches the place with no change to make SHALL NOT end it, by the rule above that such a
call is not a change asked for at all. Nor SHALL putting a stop or a removal up for confirmation,
typing a name back, or cancelling either: none of them reaches the roster place, and nothing has
been proved about it either way.

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

## ADDED Requirements

### Requirement: A roster removes a commitment it holds, and never lets it go

A roster SHALL remove a commitment it holds, on being given that commitment and a calendar date.
Removing SHALL take the commitment out of the commitments the roster reads back and out of the
commitments it reads back as stopped, SHALL hold it as **removed**, and SHALL report that the roster
removed it. The commitment SHALL stay in the place it was taken on in, and everything else the
roster holds SHALL be exactly as it was, in the order it was in.

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

The one way back SHALL be offering the commitment again, which takes it up again in the place it was
taken on in and clears both the day it was kept until and its being removed — the rule is *A roster
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
