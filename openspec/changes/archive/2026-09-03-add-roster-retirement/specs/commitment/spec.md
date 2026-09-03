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

A roster SHALL hold commitments and, for each commitment it has stopped keeping, the day that
commitment was kept until — and nothing else. It MUST NOT give a commitment an identifier, a
position a commitment can be asked for, a record of the day it was added, or any other state of its
own, and it MUST NOT alter a commitment it holds: a commitment read back out of a roster SHALL be
the commitment that was put in, with the same name, the same schedule and the same day it is kept
from. The day a commitment was kept until is the roster's own and never the commitment's: a
commitment SHALL NOT gain a fourth part by being stopped, and it SHALL go on answering whether it is
due on a date exactly as it did before.

A roster SHALL NOT consult the present moment, the device's clock, its time zone or its locale, and
SHALL NOT be asked what day it is; every date it works with SHALL be one it was handed. It SHALL
judge a date in one way only: against a day it was told a commitment was kept until. It MUST NOT
judge a commitment's own day it is kept from, MUST NOT judge a schedule, and MUST NOT decide whether
a commitment is due — a commitment kept from a day long past and a commitment kept from the last
date the system supports are held alike, and whether either is due on any date is the commitment's
own answer and not the roster's.

A roster SHALL be a value. Two rosters holding the same commitments in the same order, each stopped
on the same day or each not stopped at all, SHALL be the same roster, and two holding the same
commitments in a different order SHALL be different rosters, because the order is one of the things
a roster holds. Adding a commitment to a roster, or stopping one, SHALL leave every other roster
untouched, so a roster that was copied before either SHALL still hold what it held.

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

Two commitments are the same commitment when their name, their schedule and the day they are kept
from are all the same, and a roster SHALL use that and nothing else to decide what it already holds
— both when it refuses one it is keeping and when it takes one up again that it had stopped.
It MUST NOT invent a coarser sameness of its own: two commitments alike in name but differing in
schedule or in the day they are kept from are different commitments and a roster SHALL hold both,
and two names differing only by blank space are different names, because a commitment's name is
stored exactly as it was given and tidying it belongs where a person typed it.

This is why the refusal exists at all. A commitment carries no identifier, so a roster holding two
commitments a person would call identical could not be told which of them to stop keeping, which of
them to change, or which of them a screen was pointing at. There is nothing to tell them apart by,
and so there must not be two.

A roster SHALL refuse nothing else that it is offered to add. It MUST NOT judge a name, a schedule
or a day a commitment is kept from — anything that is a commitment at all was already accepted when
the commitment was formed — it MUST NOT refuse on how many commitments it holds, and it MUST NOT
refuse on a date. What a roster refuses when it is asked to *stop* keeping a commitment is a
separate rule, and this one neither states it nor narrows it.

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

## ADDED Requirements

### Requirement: A roster stops keeping a commitment, on the day it was kept until

A roster SHALL stop keeping a commitment it holds, on being given that commitment and a calendar
date: the day the commitment was **kept until**, which is the last day it was kept. Stopping SHALL
take the commitment out of the commitments the roster reads back, SHALL record the day it was kept
until against it, and SHALL report that the roster stopped keeping it. Everything else the roster
holds SHALL be exactly as it was, in the order it was in.

The roster SHALL refuse to stop keeping a commitment in exactly two cases, and SHALL report each
rather than doing nothing silently, for the same reason a refused addition is reported:

- a commitment the roster does not hold at all; and
- a commitment it has already stopped keeping, whose kept-until day SHALL stand as first given.

A day once given SHALL NOT move for as long as the roster has stopped keeping that commitment. This
is what makes stopping safe to build on: no second stop can slide a boundary a person cannot see,
and every date's answer about a stopped commitment is fixed while it stays stopped, in the way
ADR-1013 fixes that a past day's answer does not change once given. A roster asked to stop a
commitment it does not hold, or one it has already stopped, SHALL be left exactly as it was.

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

### Requirement: A roster answers which commitments it had not stopped keeping on a calendar date

For any calendar date the system supports, a roster SHALL answer with the commitments it had not
stopped keeping on that date: every commitment it holds and has not stopped at all, and every
commitment it has stopped whose kept-until day is that date or later. The answer SHALL be in the
order the commitments were taken on, the same order the roster reads them back in, with a stopped
commitment in the place it has always had rather than at either end.

The day a commitment was kept until is the last day it was kept. The roster SHALL answer with that
commitment on that date, and SHALL NOT answer with it on the day after it or on any later date.

A commitment the roster has taken up again after stopping holds no kept-until day, so the roster
SHALL answer with it on every date, the dates between the day it was kept until and the day it was
taken up again included. Those dates SHALL therefore answer differently after a commitment is taken
up again from the way they answered while it was stopped. That is the one thing that changes a past
date's answer in this capability, it happens only because a person asked to take the commitment up
again, and it reaches no further than this answer: every tick already recorded stands, so what was
actually done on those days is unchanged.

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
