## ADDED Requirements

### Requirement: A commitment is an identity, a name, a schedule, the day it is kept from and the kind its days take

A commitment SHALL be exactly five things: an identity, a name, the schedule deciding which days it
is due on, the calendar date it is kept from, and the kind its days take. It SHALL carry nothing
else: no record of what was ticked, no position in a list, no state that can be paused or archived.
It SHALL read back its name and its kind, and no identity SHALL ever be shown to a person.

An identity SHALL be given when a commitment is first formed, SHALL NOT be derived from any other
part, and SHALL NOT change afterwards. Forming two commitments SHALL give two identities however
alike every other part is. A commitment formed as a further era of one already formed SHALL be
formed with that one's identity rather than with an identity of its own.

Two commitments SHALL be the same commitment exactly when their identities are the same, whatever
their names, schedules, days kept from and kinds; two whose identities differ SHALL be different
commitments, and no other part SHALL enter into it.

The name, the schedule and the day kept from SHALL be required: the system MUST NOT form a
commitment without a day it is kept from, MUST NOT supply one of its own, and MUST NOT consult the
present moment. The kind SHALL default to the plain kind, a tick, SHALL be fixed when the commitment
is formed and SHALL NOT change afterwards.

#### Scenario: a commitment reads back the name it was given

- **WHEN** a commitment is formed with the name "Gym", a schedule listing Monday, Wednesday and
  Saturday, and kept from 1 January 2026
- **THEN** the commitment's name reads back as "Gym"

#### Scenario: two commitments formed alike in every part are two different commitments

- **WHEN** two commitments are formed, both named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday, both kept from 1 January 2026 and both of the tick kind
- **THEN** the two are different commitments
- **AND** neither reads back the other's identity

#### Scenario: a commitment formed as a further era of another is the same commitment

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is formed, and a second is formed as a further era of it, on a schedule listing
  Tuesday and Thursday, kept from 1 September 2026
- **THEN** the two are the same commitment
- **AND** the second reads back the name "Gym" and the tick kind
- **AND** a third formed with that same name, schedule and day, but not as an era of the first, is a
  different commitment from both

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

### Requirement: A roster holds a commitment's eras as the entries that carry its identity

A roster SHALL hold each era of a commitment as an entry of its own, and every entry carrying one
identity SHALL be an era of one commitment. The eras of a commitment SHALL stand together in the
roster's order, the newest first and each earlier era immediately behind the one it gave way to.
Every era of one commitment SHALL carry that commitment's name and the sort of its kind, and a
roster MUST NOT hold two eras of one commitment differing in either.

Each era but the newest SHALL carry the day it was kept until, and that day SHALL be the day before
the next era's day kept from. Kept, stopped and removed SHALL be states of the commitment rather
than of an era: the newest era SHALL carry the state, and an earlier era SHALL be read back neither
among the commitments the roster keeps nor among those it has stopped. A roster SHALL read back, for
a commitment it holds, its eras newest first, the day it is kept from — its earliest era's — and the
rhythm it runs on, which is its newest era's.

#### Scenario: a roster holding two eras of one commitment reads back one commitment it is keeping

- **WHEN** a roster given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, puts a new era on it on a schedule listing Tuesday and
  Thursday, kept from 1 September 2026, as of 31 August 2026, under no category
- **THEN** the roster reads back one commitment it is keeping, on Tuesday and Thursday
- **AND** it reads back nothing it has stopped
- **AND** it reads back two eras of that commitment, the one on Tuesday and Thursday first

#### Scenario: a roster says a commitment's day kept from as its earliest era's and its rhythm as its newest era's

- **WHEN** a roster given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, puts a new era on it on a schedule listing Tuesday and
  Thursday, kept from 1 September 2026, as of 31 August 2026, under no category
- **THEN** the roster says that commitment is kept from 1 January 2026
- **AND** it says the rhythm it runs on is "Tue, Thu"
- **AND** a third era on a schedule of 3 times a week, kept from 1 October 2026, leaves the day kept
  from 1 January 2026 and makes the rhythm "3x a week"

#### Scenario: a roster answers a date with the era of a commitment that holds that day

- **WHEN** a roster given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, puts a new era on it on a schedule listing Tuesday and
  Thursday, kept from 1 September 2026, as of 31 August 2026, under no category
- **THEN** asked about 31 August 2026 it answers with both eras, the one on Tuesday and Thursday
  first
- **AND** asked about 1 September 2026 it answers with the one on Tuesday and Thursday alone

#### Scenario: an earlier era of a stopped commitment is in neither what a roster keeps nor what it has stopped

- **WHEN** a roster given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, puts a new era on it on a schedule listing Tuesday and
  Thursday, kept from 1 September 2026, as of 31 August 2026, under no category, and then stops
  keeping it as of 30 September 2026
- **THEN** the roster reads back nothing it is keeping and one commitment it has stopped, on Tuesday
  and Thursday
- **AND** it reads back two eras of that commitment

#### Scenario: a roster holding eras of two commitments keeps each commitment's eras together

- **WHEN** a roster given a commitment named "Gym" and then one named "Run", both on a schedule
  listing Monday, Wednesday and Saturday and both kept from 1 January 2026, puts a new era on "Gym"
  on a schedule listing Tuesday and Thursday, kept from 1 September 2026, as of 31 August 2026,
  under no category
- **THEN** the roster reads back two commitments it is keeping, "Gym" first and "Run" second
- **AND** it reads back two eras of "Gym" and one of "Run"

### Requirement: A roster renames a commitment through every era of it

A roster SHALL rename a commitment it holds, on being given that commitment and a name, and SHALL
write that name on every era of it. Each era's schedule, day kept from, kind and day kept until, the
commitment's identity, its state, its category and its place in the roster's order SHALL be left
exactly as they were, and the roster SHALL report that it renamed. It SHALL rename a commitment in
any of the three states it holds one in.

The roster SHALL refuse to rename a commitment it does not hold at all, and SHALL refuse a name a
commitment it keeps or has stopped keeping already has, as *A roster refuses a commitment whose name
one it keeps or has stopped already has* says; it SHALL report each and SHALL be left exactly as it
was. Renaming a commitment to the name it already has SHALL change nothing, SHALL NOT be refused,
and SHALL NOT be read as that commitment's own name being in use. Renaming SHALL change nothing
recorded against the commitment and SHALL leave every other roster untouched.

#### Scenario: renaming a commitment writes the new name on every era of it

- **WHEN** a roster given a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, puts a new era on it on a schedule listing Tuesday and
  Thursday, kept from 1 September 2026, as of 31 August 2026, under no category, and is then asked
  to rename it "Lifting"
- **THEN** the roster reports that it renamed the commitment
- **AND** both its eras read back the name "Lifting"
- **AND** each era's schedule and day kept from are what they were

#### Scenario: a renamed commitment keeps its place, its category and its state

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym" under the category
  "Sport", then one named "Journaling", all on a schedule listing Monday, Wednesday and Saturday and
  all kept from 1 January 2026, stops keeping "Gym" as of 31 January 2026 and is then asked to
  rename it "Lifting"
- **THEN** the roster reports that it renamed the commitment
- **AND** it reads back two commitments it keeps, "Water plants" then "Journaling", and one it has
  stopped, named "Lifting"
- **AND** taking "Lifting" up again reads it back in the group "Sport", between "Water plants" and
  "Journaling"

#### Scenario: renaming a commitment a roster does not hold is refused and leaves the roster as it was

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to rename a commitment it does not hold "Lifting"
- **THEN** the roster reports that it did not rename the commitment
- **AND** the roster is the same roster as one that was never asked

#### Scenario: renaming a commitment to a name another commitment already has is refused

- **WHEN** a roster given a commitment named "Gym" and one named "Run", both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026, is asked to rename "Gym" "Run"
- **THEN** the roster reports that it did not rename the commitment
- **AND** the roster is the same roster as one that was never asked
- **AND** a roster that had stopped keeping "Run" refuses that rename too, and one that had removed
  "Run" makes it

#### Scenario: renaming a commitment to the name it already has changes nothing and is not refused

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to rename it "Gym"
- **THEN** the roster reports that it renamed the commitment
- **AND** the roster is the same roster as one that was never asked
- **AND** a roster asked to rename it "GYM" reports that it renamed it and reads the name back as
  "GYM"

#### Scenario: renaming a commitment on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is copied, and the copy renames that commitment "Lifting"
- **THEN** the copy reads back one commitment named "Lifting"
- **AND** the roster it was copied from still reads back one named "Gym" and is not the same roster
  as the copy

### Requirement: A roster refuses a commitment whose name one it keeps or has stopped already has

A roster SHALL refuse a commitment whose name a commitment it keeps or has stopped keeping already
has, SHALL leave itself exactly as it was, and SHALL report that the commitment was not added. Two
names SHALL be one name where they differ only in the case of their letters, only in blank space at
the start or the end of them, or only in both; every other difference, blank space inside a name
included, SHALL make two names. A name SHALL be stored exactly as it was given, and a roster MUST
NOT rewrite one it accepts. A commitment the roster has removed SHALL hold no name against a
commitment offered, and neither SHALL an earlier era beyond the name its own commitment carries.

A commitment the roster holds in no state SHALL be placed after every commitment already there,
under the category it was offered under, and SHALL be reported as added. A commitment the roster
holds — one of its eras carrying the identity offered — SHALL be taken up again where the roster has
stopped keeping it or has removed it, and refused where the roster is keeping it; taking up again
SHALL drop the day that commitment was kept until, SHALL no longer hold it as removed, SHALL read it
back among the commitments the roster keeps in the place it has, and SHALL be refused where a
commitment the roster keeps already has its name.

A commitment MAY be offered with a category or without a category being said at all, and the two
SHALL be different asks; there SHALL be no third. One offered with a category SHALL be put under the
category said, and being offered under no category SHALL take the category off. One offered without
a category being said at all SHALL leave the category the roster holds for it exactly as it is —
none for a commitment it does not hold at all, whatever it was for one it is taking up again.

Reporting SHALL be part of the refusal and MUST NOT be dropped. A roster SHALL refuse nothing else
it is offered to add: it MUST NOT judge a schedule, a day a commitment is kept from, a kind or a
category, MUST NOT refuse on how many commitments it holds, and MUST NOT refuse on a date.

#### Scenario: adding a commitment a roster does not hold places it after the ones already there and says it was added

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is given one named "Run" alike in every other way
- **THEN** the roster reports that the commitment was added
- **AND** the roster holds two commitments, "Gym" first and "Run" second

#### Scenario: adding a commitment whose name a roster already keeps says it was not added and leaves the roster as it was

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is given a second commitment named "Gym", formed on its own,
  alike in schedule and day kept from
- **THEN** the roster reports that the commitment was not added
- **AND** the roster still holds exactly one commitment, named "Gym"
- **AND** it is the same roster as one given that commitment once

#### Scenario: a commitment whose name a roster already keeps is refused whatever else differs

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, of the tick kind, is given a second commitment named "Gym",
  formed on its own, on a schedule listing Tuesday and Thursday, kept from 2 January 2026, of the
  note kind
- **THEN** the roster reports that the commitment was not added
- **AND** the roster still holds exactly one commitment

#### Scenario: a commitment whose name a roster has stopped keeping already has is refused

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, stops keeping it as of 31 January 2026 and is then given a
  second commitment named "Gym", formed on its own, alike in schedule and day kept from
- **THEN** the roster reports that the commitment was not added
- **AND** the roster reads back nothing it keeps and one commitment it has stopped, named "Gym"

#### Scenario: a name a roster has only removed a commitment under is free

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, removes it as of 31 January 2026 and is then given a second
  commitment named "Gym", formed on its own, alike in schedule and day kept from
- **THEN** the roster reports that the commitment was added
- **AND** the roster reads back one commitment it keeps, named "Gym"
- **AND** it holds the removed one still, and answers with both on 31 January 2026

#### Scenario: two names differing only in the case of a letter are one name and the second is refused

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is given commitments named "gym", "GYM" and " Gym ", each
  formed on its own and alike in every other way
- **THEN** the roster reports of each that it was not added
- **AND** the roster still holds exactly one commitment, whose name reads back as "Gym"

#### Scenario: two names differing by blank space inside them are two names and both are held

- **WHEN** a roster holding a commitment named "Water plants" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, is given one named "Waterplants" and then one
  named "Water  plants", each formed on its own and alike in every other way
- **THEN** the roster reports of each that it was added
- **AND** the roster holds three commitments, each reading back the name it was given

#### Scenario: a commitment offered again as itself where the roster has stopped keeping it takes it up again

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, has stopped keeping it as of 31 January 2026, and is then
  given that same commitment
- **THEN** the roster reports that it now keeps the commitment
- **AND** the roster reads back that one commitment and no second copy of it
- **AND** it is the same roster as one given that commitment once and never asked to stop keeping it

#### Scenario: a commitment offered again as itself is taken up again in the place it was taken on in

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January
  2026, stops keeping "Gym" as of 31 January 2026 and is then given that same commitment
- **THEN** the roster reports that it now keeps the commitment
- **AND** the roster reads back three commitments in the order "Water plants", "Gym", "Journaling",
  with "Gym" in the place it was taken on in and not at the end

#### Scenario: taking a stopped commitment up again is refused where a commitment the roster keeps already has its name

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, stops keeping it as of 31 January 2026; "Gym" is renamed
  "Lifting"; a commitment named "Gym" formed on its own is added; and the stopped commitment is
  renamed "Gym " and then offered again as itself
- **THEN** the roster reports that it did not take the commitment up again
- **AND** the roster reads back one commitment it keeps, named "Gym", and one it has stopped, named
  "Gym "

#### Scenario: a commitment offered again as itself where the roster has removed it takes it up again

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym", then one named
  "Journaling", all on a schedule listing Monday, Wednesday and Saturday and all kept from 1 January
  2026, removes "Gym" as of 31 January 2026, and is then given that same commitment
- **THEN** the roster reports that it now keeps the commitment
- **AND** the roster reads back three commitments in the order "Water plants", "Gym", "Journaling"
- **AND** it answers with that commitment on 31 January 2026, on 1 February 2026 and on 1 March 2026

#### Scenario: a commitment a roster is already keeping is refused whatever category it is offered under

- **WHEN** a roster given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, under the category "Supplements", is offered that same commitment under
  the category "Morning"
- **THEN** the roster reports that the commitment was not added
- **AND** it reads back one group, under "Supplements", holding "Creatine"
- **AND** it is the same roster as one given that commitment once under "Supplements" and asked
  nothing else

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
  31 January 2026, and is then given that same commitment with no category said at all
- **THEN** the roster reports that it now keeps the commitment
- **AND** it reads back one group, under "Supplements", holding "Creatine"

#### Scenario: a commitment taken up again is put under the category it was offered under

- **WHEN** a roster given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, under the category "Supplements", stops keeping it as of
  31 January 2026, and is then given that same commitment under the category "Morning"
- **THEN** the roster reports that it now keeps the commitment
- **AND** it reads back one group, under "Morning", holding "Creatine"
- **AND** a roster alike in every way offered it again under no category instead reads back one
  group, under no category, holding "Creatine"

#### Scenario: a roster takes on a commitment on a schedule due on no day

- **WHEN** a roster is given a commitment named "Gym" on a schedule listing no weekday at all, kept
  from 1 January 2026
- **THEN** the roster reports that the commitment was added
- **AND** the roster holds that one commitment

#### Scenario: a roster takes on a commitment offered under a category of nothing but blank space, under none

- **WHEN** a roster is given a commitment named "Creatine" on a schedule listing all seven weekdays,
  kept from 1 January 2026, under a category of three spaces
- **THEN** the roster reports that the commitment was added
- **AND** it reads back one group, with no category, holding "Creatine"

### Requirement: A roster puts a new era on a commitment it is keeping, from a day

A roster SHALL put a new era on a commitment it is keeping, on being given that commitment, the era
to put on it, a calendar date — the day the era it gives way to was kept until — and the category to
put the commitment under, which may be none. The new era SHALL take the place the commitment held
and SHALL become its newest era; the era it gives way to SHALL carry that date as the day it was
kept until and SHALL sit immediately behind it. The roster SHALL report that it put the era on, and
the commitment SHALL still be one commitment, kept, with the day kept from its earliest era has.

The roster SHALL refuse to put an era on a commitment it is not keeping — one it does not hold, one
it has stopped keeping and one it has removed alike — and SHALL refuse an era that does not carry
that commitment's identity, its name or the sort of its kind; it SHALL report each and SHALL be left
exactly as it was. It SHALL refuse on no date: any calendar date the system supports SHALL be
accepted, the first and the last included, and a date earlier than the day the era it gives way to
is kept from leaves that era holding no day at all. It SHALL NOT ask what day it is, SHALL NOT judge
either era's schedule and SHALL NOT decide whether either is due. Putting an era on SHALL change
nothing recorded against the commitment, SHALL leave every other roster untouched, and two rosters
differing only in an era put on SHALL be different rosters.

#### Scenario: a new era takes the place the commitment held and becomes its newest

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, then one named "Journaling", all kept from 1 January 2026,
  is asked to put a new era on "Gym" on a schedule listing Tuesday and Thursday, kept from
  1 September 2026, as of 31 August 2026, under no category
- **THEN** the roster reports that it put the era on
- **AND** it reads back three commitments it is keeping, in the order "Water plants", then "Gym" on
  Tuesday and Thursday, then "Journaling"
- **AND** it says "Gym" is kept from 1 January 2026

#### Scenario: the era a new one gives way to carries the day it was kept until and sits behind it

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to put a new era on it on a schedule listing Tuesday
  and Thursday, kept from 1 September 2026, as of 31 August 2026, under no category
- **THEN** the roster reads back two eras of that commitment, the one on Tuesday and Thursday first
- **AND** asked about 31 August 2026 it answers with both, the one on Tuesday and Thursday first
- **AND** asked about 1 September 2026 it answers with the one on Tuesday and Thursday alone

#### Scenario: a commitment a new era is put on is put under the category it was offered under

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, under the category "Sport", is asked to put a new era on it on
  a schedule listing Tuesday and Thursday, kept from 1 September 2026, as of 31 August 2026, under
  the category "Morning"
- **THEN** the roster reads back one group it is keeping, "Morning", holding the commitment on
  Tuesday and Thursday
- **AND** both its eras are under "Morning"

#### Scenario: putting an era on a commitment a roster is not keeping is refused

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, stops keeping it as of 31 January 2026, and is then asked to
  put a new era on it on a schedule listing Tuesday and Thursday, kept from 1 September 2026, as of
  31 August 2026, under no category
- **THEN** the roster reports that it did not put the era on
- **AND** the roster is the same roster as one that stopped keeping "Gym" and was never asked
- **AND** a roster that had removed "Gym" refuses it too, and so does one that never held it

#### Scenario: putting an era that is not of that commitment on it is refused

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to put on it an era formed on its own, named "Gym" on
  a schedule listing Tuesday and Thursday, kept from 1 September 2026, as of 31 August 2026, under
  no category
- **THEN** the roster reports that it did not put the era on
- **AND** the roster is the same roster as one that was never asked
- **AND** an era carrying that commitment's identity but the name "Lifting" is refused too, and so
  is one of the note kind

#### Scenario: an era put on as of a day before the day the era it gives way to is kept from leaves it holding no day

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 March 2026, is asked to put a new era on it on a schedule listing Tuesday
  and Thursday, kept from 1 March 2026, as of 28 February 2026, under no category
- **THEN** the roster reports that it put the era on
- **AND** asked about 28 February 2026 it answers with both eras, and asked about 1 March 2026 with
  the one on Tuesday and Thursday alone

#### Scenario: an era put on as of the first supported date and one as of the last are both accepted

- **WHEN** a roster holding a commitment named "Gym" and then one named "Run", both on a schedule
  listing Monday, Wednesday and Saturday and both kept from 1 March 2026, is asked to put a new era
  on "Gym" on a schedule listing Tuesday and Thursday as of 1 January 1583, and one on "Run" on that
  same schedule as of 31 December 9999, both new eras kept from 1 March 2026 and under no category
- **THEN** the roster reports of each that it put the era on
- **AND** asked about 1 January 1583 it answers with all four eras
- **AND** asked about 2 January 1583 it answers with three, in the order "Gym" on Tuesday and
  Thursday, "Run" on Tuesday and Thursday, "Run" on Monday, Wednesday and Saturday

#### Scenario: a third era put on a commitment leaves it one commitment with three eras

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, has a new era put on it on a schedule listing Tuesday and
  Thursday, kept from 1 February 2026, as of 31 January 2026, and then a third on a schedule of
  3 times a week, kept from 1 March 2026, as of 28 February 2026, both under no category
- **THEN** the roster reads back one commitment it is keeping, saying "3x a week"
- **AND** it reads back three eras of it, newest first
- **AND** it says the commitment is kept from 1 January 2026

#### Scenario: putting an era on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is copied, and the copy puts a new era on it on a schedule
  listing Tuesday and Thursday, kept from 1 September 2026, as of 31 August 2026, under no category
- **THEN** the copy reads back one commitment it is keeping, on Tuesday and Thursday, and two eras
  of it
- **AND** the roster it was copied from still reads back one era, on Monday, Wednesday and Saturday,
  and is not the same roster as the copy

### Requirement: A roster store folds a roster kept before a commitment had an identity

A roster store reading a roster kept in a form written before a commitment had an identity SHALL
fold it once, as it reads it, and SHALL read every later form as it stands. Each entry the stored
roster keeps or has stopped keeping SHALL become a commitment of its own, with an identity of its
own, in the place and the state and under the category it was held in.

Each entry the stored roster holds removed SHALL be judged in the order the roster holds them. One
whose name and kind sort are a commitment's, and whose day kept until is the day before the day
kept from of the era immediately in front of it in that chain, SHALL become an earlier era of that
commitment, carrying its identity and its name; where more than one answers, the nearest in the
roster's order SHALL be taken. One that chains to nothing but whose name and kind sort are those of
a commitment the stored roster keeps or has stopped SHALL become a stopped commitment of its own,
with an identity of its own, keeping the day it was kept until. Every other removed entry SHALL be
dropped, and no entry SHALL be held removed once the fold is done.

The fold SHALL say nothing to the person, SHALL invent no name and SHALL rename nothing: two
commitments it leaves holding one name SHALL both stand. It MUST NOT change what is at the place;
the next change kept there SHALL be written whole in the form this app writes.

#### Scenario: a chain of removed entries folds into the eras of the commitment in front of it

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment had an identity, whose entries are "Gym" on a schedule listing Tuesday and Thursday,
  kept from 1 March 2026 and kept; "Gym" on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 February 2026, removed and kept until 28 February 2026; and "Gym" on a schedule of 3 times
  a week, kept from 1 January 2026, removed and kept until 31 January 2026
- **THEN** it opens without error
- **AND** its roster reads back one commitment it is keeping, named "Gym", saying "Tue, Thu"
- **AND** it reads back three eras of that commitment, newest first, and nothing it has stopped
- **AND** it says that commitment is kept from 1 January 2026

#### Scenario: a removed entry nothing kept or stopped resembles is dropped by the fold

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment had an identity, whose entries are "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026 and kept, and "Yoga" on that same schedule, kept from
  1 January 2026, removed and kept until 31 January 2026
- **THEN** its roster reads back one commitment it is keeping, named "Gym", and one era of it
- **AND** it reads back nothing it has stopped and holds nothing removed
- **AND** asked about 31 January 2026 it answers with "Gym" alone

#### Scenario: a removed entry that resembles a live commitment but chains to nothing becomes a stopped commitment

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment had an identity, whose entries are "Gym" on a schedule listing Tuesday and Thursday,
  kept from 1 March 2026 and kept, and "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, removed and kept until 20 February 2026
- **THEN** its roster reads back one commitment it is keeping, named "Gym", saying "Tue, Thu", and
  one it has stopped, named "Gym", saying "Mon, Wed, Sat"
- **AND** the two are different commitments, each with one era
- **AND** it says the commitment it keeps is kept from 1 March 2026

#### Scenario: the fold takes the nearest of two removed entries that both chain

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment had an identity, whose entries are "Gym" on a schedule listing Tuesday and Thursday,
  kept from 4 March 2026 and kept; "Gym" on a schedule listing Monday, kept from 1 February 2026,
  removed and kept until 3 March 2026; and "Gym" on a schedule listing Wednesday, kept from
  1 January 2026, removed and kept until 3 March 2026
- **THEN** its roster reads back one commitment it is keeping with two eras, the newer on Tuesday
  and Thursday and the older on Monday
- **AND** it says that commitment is kept from 1 February 2026
- **AND** it reads back one commitment it has stopped, saying "Wed"

#### Scenario: a removed entry of another kind sort does not fold as an era

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment had an identity, whose entries are "Mood" of the number kind with a range of 1 to 5,
  kept from 1 March 2026 and kept, and "Mood" of the note kind, kept from 1 January 2026, removed
  and kept until 28 February 2026, both on a schedule listing all seven weekdays
- **THEN** its roster reads back one commitment it is keeping, of the number kind, with one era
- **AND** it reads back nothing it has stopped and holds nothing removed

#### Scenario: an era whose range differs folds behind the commitment in front of it

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment had an identity, whose entries are "Mood" of the number kind with a range of 1 to 5, on
  a schedule listing all seven weekdays, kept from 1 March 2026 and kept, and "Mood" of the number
  kind with a range of 1 to 10, alike in schedule, kept from 1 January 2026, removed and kept until
  28 February 2026
- **THEN** its roster reads back one commitment it is keeping with two eras, the newer ranging 1 to
  5 and the older 1 to 10
- **AND** it says that commitment is kept from 1 January 2026

#### Scenario: the fold leaves two commitments holding one name where the stored roster held two

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment had an identity, whose entries are "Gym" on a schedule listing Monday, kept from
  1 January 2026 and kept, and "Gym " — the same word with a trailing space — on a schedule listing
  Tuesday, kept from 1 January 2026 and kept
- **THEN** its roster reads back two commitments it is keeping, named "Gym" and then "Gym "
- **AND** each reads its name back exactly as it was stored

#### Scenario: folding a roster changes nothing at its place, and the next change is written in the form this app writes

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment had an identity, and nothing is asked of the store
- **THEN** the content at that place is byte-for-byte what it was before
- **AND** after a commitment named "Run" is taken on through it, a store opened afterwards at that
  place reads back the folded roster with "Run" last, and holds nothing removed

### Requirement: Reading the places carries the records of a folded roster onto the commitments the fold made

Once a roster kept before a commitment had an identity has been folded, a day screen and a
commitments screen SHALL give every record at the record place the identity of the era the
commitment it was kept against names, and SHALL keep that at the record place. A record whose
commitment names an entry the fold dropped SHALL be dropped with it. A record whose commitment names
no entry at all SHALL be left as a record of a commitment the roster holds in no state, under
*Reading the places carries an orphaned record back to its one possible source*.

The record place SHALL be written only where something moved, and nothing SHALL be said about it. A
screen that cannot read either place SHALL do none of this and SHALL leave both places as they are.

#### Scenario: a record kept against an era that folded is read back under the commitment it folded into

- **WHEN** a roster written in the form used before a commitment had an identity is at a roster
  place, whose entries are "Gym" on a schedule listing all seven weekdays, kept from 1 March 2026
  and kept, and "Gym" on that same schedule, kept from 1 January 2026, removed and kept until
  28 February 2026; a tick for the older entry on 15 February 2026 and one for the newer on
  3 March 2026 are at a record place in the form used before a record carried an identity; and a
  commitments screen is opened at those places as of Monday 31 August 2026
- **THEN** the screen does not say that records belong to no commitment
- **AND** a look-back at "Gym" counts both days kept
- **AND** a store opened afterwards at that record place answers that the commitment the screen
  keeps was kept on 15 February 2026 and on 3 March 2026

#### Scenario: a record kept against an entry the fold dropped is dropped with it

- **WHEN** a roster written in the form used before a commitment had an identity is at a roster
  place, whose entries are "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026
  and kept, and "Yoga" on that same schedule, kept from 1 January 2026, removed and kept until
  31 January 2026; a tick for "Yoga" on 15 January 2026 and one for "Gym" on 3 March 2026 are at a
  record place in the form used before a record carried an identity; and a commitments screen is
  opened at those places as of Monday 31 August 2026
- **THEN** the screen does not say that records belong to no commitment
- **AND** a store opened afterwards at that record place holds one record, and answers that the
  commitment the screen keeps was kept on 3 March 2026

#### Scenario: a record whose commitment the folded roster never held is left as an orphan

- **WHEN** a roster written in the form used before a commitment had an identity is at a roster
  place, whose one entry is "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026 and kept; a tick on Tuesday 4 August 2026 for a commitment named "Gym 🏋️" on a
  schedule listing Tuesday and Thursday, kept from that same day, is at a record place in the form
  used before a record carried an identity; and a commitments screen is opened at those places as
  of Monday 31 August 2026
- **THEN** the screen says that records belong to no commitment
- **AND** a store opened afterwards at that record place still holds that record

#### Scenario: a day screen opened on a folded roster carries the records too

- **WHEN** a roster written in the form used before a commitment had an identity is at a roster
  place, whose entries are "Gym" on a schedule listing all seven weekdays, kept from 1 March 2026
  and kept, and "Gym" on that same schedule, kept from 1 January 2026, removed and kept until
  28 February 2026; a tick for the older entry on 15 February 2026 is at a record place in the form
  used before a record carried an identity; and a day screen of no commitments is opened at those
  places as of Monday 31 August 2026
- **THEN** a store opened afterwards at that record place answers that the commitment the roster
  keeps was kept on 15 February 2026
- **AND** the day screen shown as of 15 February 2026 draws that row ticked

#### Scenario: a screen that cannot read its record place leaves a folded roster's records alone

- **WHEN** a roster written in the form used before a commitment had an identity is at a roster
  place, whose one entry is "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026
  and kept; a run of bytes that is not a record is at a record place; and a commitments screen is
  opened at those places as of Monday 31 August 2026
- **THEN** the content at both places is byte-for-byte what it was before the screen was opened
- **AND** the screen does not say that records belong to no commitment

### Requirement: A roster changes an era of a commitment it holds for another of that commitment

A roster SHALL change an era it holds for another era of that same commitment, on being given the
two and the category to put the commitment under, which may be none. It SHALL put the second in the
place the first held, SHALL leave the day that era was kept until and the state of its commitment
exactly as they were, SHALL put the commitment under the category it was offered under, and SHALL
report that it changed; nothing else it holds SHALL move. It SHALL change an era of a commitment in
any of the three states it holds one in.

The roster SHALL refuse to change an era it does not hold at all, and one whose result does not
carry that era's identity, that commitment's name or the sort of its kind; it SHALL report each and
SHALL be left exactly as it was. Asked to change an era for itself it SHALL be left exactly as it
was but for the category offered, and SHALL report that it changed. Changing SHALL change nothing
recorded against the commitment; a roster holds no records and SHALL carry none over. It SHALL leave
every other roster untouched.

#### Scenario: changing an era puts the result in the place the one it replaced held

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 August 2026, then one named "Journaling", is
  asked to change "Gym"'s one era for an era of that same commitment kept from 1 June 2026, alike in
  every other way, under no category
- **THEN** the roster reports that it changed the era
- **AND** it reads back three commitments in the order "Water plants", "Gym", "Journaling"
- **AND** it says "Gym" is kept from 1 June 2026

#### Scenario: changing the earliest era of a commitment with two leaves the newer one alone

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 August 2026, with a newer era on a schedule listing Tuesday and Thursday,
  kept from 1 September 2026, put on as of 31 August 2026, is asked to change the earlier era for an
  era of that commitment kept from 1 June 2026, alike in every other way, under no category
- **THEN** the roster reports that it changed the era
- **AND** it says the commitment is kept from 1 June 2026 and runs on "Tue, Thu"
- **AND** it reads back two eras of it

#### Scenario: changing an era for one of another commitment is refused

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to change its era for a commitment named "Gym"
  formed on its own, alike in every other way, under no category
- **THEN** the roster reports that it did not change the era
- **AND** the roster is the same roster as one that was never asked
- **AND** a change for an era carrying that identity but the name "Lifting" is refused too, and so
  is one of the note kind

#### Scenario: changing an era a roster does not hold is refused and leaves the roster as it was

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to change an era it does not hold for another, under
  no category
- **THEN** the roster reports that it did not change the era
- **AND** the roster is the same roster as one that was never asked

#### Scenario: changing an era of a stopped commitment leaves it stopped, on the day it was kept until

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 August 2026, stops keeping it as of 31 August 2026, and is then asked to
  change its era for an era of that commitment kept from 1 June 2026, alike in every other way,
  under no category
- **THEN** the roster reports that it changed the era
- **AND** it reads back nothing it is keeping and one commitment it has stopped, kept from
  1 June 2026
- **AND** it answers with that commitment on 31 August 2026 and with nothing on 1 September 2026

#### Scenario: changing an era for itself under a different category puts its commitment under that category

- **WHEN** a roster given a commitment named "Gym" under the category "Sport" and then one named
  "Journaling" under no category, both on a schedule listing Monday, Wednesday and Saturday and both
  kept from 1 January 2026, is asked to change "Gym"'s era for that same era, under the category
  "Morning"
- **THEN** the roster reports that it changed the era
- **AND** it reads back two groups, "Morning" holding "Gym" and then a group with no category
  holding "Journaling"

#### Scenario: changing an era on a copy of a roster leaves the roster it was copied from unchanged

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 August 2026, is copied, and the copy changes its era for an era of that
  commitment kept from 1 June 2026, alike in every other way, under no category
- **THEN** the copy says its one commitment is kept from 1 June 2026
- **AND** the roster it was copied from still says 1 August 2026 and is not the same roster as the
  copy

### Requirement: A commitments screen tells a name already in use apart from a roster it could not write

A commitments screen SHALL refuse a commitment whose name a commitment its roster keeps or has
stopped keeping already has, and a change it could not keep at a place, and SHALL tell the two
apart. Neither SHALL change either of the screen's lists or what is at the roster place. The
refusal SHALL name the commitment it collided with, in that commitment's name exactly as the roster
holds it, and SHALL be about the name field of the screen's sheet. Names SHALL be judged as *A
roster refuses a commitment whose name one it keeps or has stopped already has* judges them. A
change the screen could not keep SHALL be told the same way whether it was the record place or the
roster place that would not take it.

A commitment the roster has stopped keeping SHALL hold its name against a commitment defined
through this screen: defining that name again SHALL be refused rather than take the stopped
commitment up again, and taking it up again SHALL be the one-tap act on its stopped row. A
commitment the roster has removed SHALL hold its name against nothing.

#### Scenario: a commitments screen refuses a name a commitment its roster is already keeping has

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and a commitment named "Gym" on a weekday-set rhythm of Tuesday and
  Thursday, kept from that same day, is defined through it
- **THEN** it is refused as a name already in use, naming "Gym"
- **AND** what the screen keeps is one entry, named "Gym"
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a commitments screen refuses a name that differs only in case or in blank space at its ends

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; and commitments named "gym", "GYM" and " Gym " on that same rhythm and day
  are each defined through it
- **THEN** each is refused as a name already in use, naming "Gym"
- **AND** what the screen keeps is one entry, named "Gym"

#### Scenario: a commitments screen refuses a name a commitment its roster has stopped keeping has

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as
  of Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and a commitment named "Gym" on that same rhythm, kept from that same day, is
  defined through it
- **THEN** it is refused as a name already in use, naming "Gym"
- **AND** what it keeps is one entry, named "Journaling", and what it has stopped is one, named "Gym"

#### Scenario: a commitments screen takes on a name only a commitment its roster has removed has

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; "Gym" is removed there as of Sunday 30 August 2026; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; and a commitment
  named "Gym" on that same rhythm, kept from that same day, is defined through it
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Gym"
- **AND** a look-back at it says the day kept from Monday 31 August 2026

#### Scenario: a commitments screen that could not keep a new commitment says the roster could not be written

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place under a
  directory that cannot be created, and a commitment named "Gym" on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it
- **THEN** it is refused as a roster that could not be written, told apart from a name already in use
- **AND** what the screen keeps is nothing

#### Scenario: a commitment a commitments screen refuses for its name is not taken on a second time

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and a commitment named "Gym" on that same rhythm and day is defined
  through it twice
- **THEN** both are refused as a name already in use
- **AND** a roster store opened afterwards at that place holds one commitment

### Requirement: A commitments screen changes a commitment by renaming it, moving the day it is kept from, or putting a new era on it

A commitments screen SHALL change a commitment on either of its lists from five things and no others
— a name, a rhythm, the day it is kept from, the category, which may be none, and the range or the
target its kind has room for — and SHALL work out from them which acts the change needs, doing each
it needs and no other, at the roster place alone. A different name SHALL rename the commitment
through every era of it. A different day kept from SHALL change the commitment's earliest era for
one kept from that day. A different rhythm, range or target SHALL put a new era on the commitment,
kept from the day the screen was handed, with the era it gives way to kept until the day before; the
name and the day kept from the change names SHALL already have been written by the two acts above,
so one save SHALL rename first, move the day second and put the era on third. A different category
SHALL be written by whichever act runs, and by a put where none does.

No change SHALL move a record, and nothing SHALL be written at the record place by any of them: a
record is a record of the commitment, which a rename, a moved day and a new era all leave standing.
Every past day SHALL go on answering about the commitment it answered about, under whatever name it
now carries and against whichever era holds that day.

On an interval rhythm the day kept from is also the rhythm's start date, so a change naming a
different day SHALL form the earliest era's schedule from that day and the days it was due on before
are not the days it is due on after; on the other three, dueness does not depend on that day, so
moving it earlier only widens the window and every day already recorded on SHALL stay due. A day
kept from moved forward past the day an era gives way SHALL drop every era it would leave holding no
day, and the earliest surviving era SHALL be kept from that day.

Which of the four kinds its days take is not one of the five and SHALL NOT change: every era SHALL
be of the kind the commitment is of. The range a number kind carries and the target a total kind
carries SHALL be what the change names, a range named where the commitment carried none and none
named where it carried one alike, and only the era put on SHALL carry the new one. A range or a
target named for a kind that has no room for it SHALL be ignored. A commitment its roster has
stopped keeping SHALL be changed in name and category only, and SHALL stay stopped on the day it was
kept until. Where the five things name what is already there, and the category it is already under,
the screen SHALL change nothing, SHALL write nothing at either place and SHALL refuse nothing.

#### Scenario: a commitment renamed through a commitments screen is drawn under its new name, in the place it held

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym"
  is changed through it to the name "Gym 🏋️", on the rhythm and the day kept from it already has,
  under no category
- **THEN** nothing is refused
- **AND** what it keeps is three entries, named "Water plants", then "Gym 🏋️", then "Journaling"
- **AND** a roster store opened afterwards at that place holds those three commitments in that order

#### Scenario: a renamed commitment keeps every record already made, and the record place is not written

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; the content at that record place is read; and "Gym" is changed through it
  to the name "Gym 🏋️", on the rhythm and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** a look-back at "Gym 🏋️" counts Monday 3 August 2026 kept
- **AND** the content at that record place is byte-for-byte what was read before the change

#### Scenario: a rename through a commitments screen reaches every era of the commitment

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category; and it is then changed to the name "Lifting", on the rhythm and the
  day kept from it now has
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Lifting" on Monday, Wednesday and Saturday, and about Monday 31 August 2026 with "Lifting" on
  Tuesday and Thursday
- **AND** a look-back at "Lifting" says the name "Lifting" and the day kept from "1 January 2026"

#### Scenario: a commitment whose rhythm is changed through a commitments screen is given a new era from today

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, on the name and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Gym", saying "Tue, Thu"
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with the
  era on Monday, Wednesday and Saturday and about Monday 31 August 2026 with the era on Tuesday and
  Thursday
- **AND** what it has stopped is nothing, and what the screen says "Gym" is made of says the day kept
  from 1 January 2026

#### Scenario: a rhythm changed through a commitments screen leaves every record already made standing

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category
- **THEN** nothing is refused
- **AND** a look-back at "Gym" counts Monday 3 August 2026 kept
- **AND** the content at that record place is byte-for-byte what it was before the change

#### Scenario: a name and a rhythm changed in one save put the new name on every era

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️" on a weekday-set
  rhythm of Tuesday and Thursday, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Gym 🏋️" on Monday, Wednesday and Saturday, and about Monday 31 August 2026 with "Gym 🏋️" on
  Tuesday and Thursday
- **AND** what the screen keeps is one entry, named "Gym 🏋️", saying "Tue, Thu"

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

#### Scenario: the day a commitment is kept from is moved onto a later era and the eras it leaves no day for are dropped

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 June 2026,
  is taken on at a roster place; a commitments screen is opened at that roster place as of Monday
  31 August 2026; "Gym" is changed through it to a weekday-set rhythm of Tuesday and Thursday, under
  no category; and "Gym" is then changed to the day kept from Monday 31 August 2026, on the name and
  the rhythm it now has
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place reads back one era of "Gym", on Tuesday and
  Thursday, kept from Monday 31 August 2026
- **AND** it says nothing about Sunday 30 August 2026, which "Gym" is not due on

#### Scenario: a change that names what is already there changes nothing and refuses nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, under the category "Sport", is taken on at a roster place; a tick for it on Monday
  3 August 2026 is kept at a record place; a commitments screen is opened at that roster place and
  that record place as of Monday 31 August 2026; and "Gym" is changed through it to exactly the name,
  rhythm, day kept from and category it already has
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Sport", holding one entry named "Gym"
- **AND** the content at both places is byte-for-byte what it was immediately after the screen was
  opened
- **AND** a screen alike in every way keeping "Mood" of the number kind with a range of 1 to 10,
  asked to change it to exactly the range it already carries beside everything else it already has,
  refuses nothing and leaves the content at both places byte-for-byte as it was

#### Scenario: a stopped commitment renamed through a commitments screen stays stopped, on the day it was kept until

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", on the rhythm and the day
  kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it has stopped is one entry, named "Gym 🏋️"
- **AND** what it keeps is one entry, named "Journaling"
- **AND** a roster store opened afterwards at that place answers with "Gym 🏋️" and then "Journaling"
  when asked what it had not stopped keeping on Sunday 30 August 2026, and with "Journaling" alone on
  Monday 31 August 2026

#### Scenario: a commitment of the number kind changed through a commitments screen keeps the kind its days take

- **WHEN** a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026, is taken on at a roster place; a commitments
  screen is opened at that roster place as of Monday 31 August 2026; and "Weight" is changed through
  it to the name "Bodyweight", on the rhythm, the day kept from and the range it already has, under
  no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is of the number kind
  with a range of 40 to 150
- **AND** what it keeps is one entry, named "Bodyweight"

#### Scenario: a rhythm changed on the first date the calendar supports puts the new era on as of that day itself

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 1583, is taken on at a roster place; a commitments screen is opened at that roster place
  as of 1 January 1583; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about 1 January 1583 with both eras,
  and about 2 January 1583 with the one on Tuesday and Thursday alone

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

#### Scenario: a commitment of the total kind whose rhythm is changed through a commitments screen keeps its kind and its target

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, is taken on at a roster place; a
  commitments screen is opened at that roster place and at a record place where nothing has been
  kept as of Monday 31 August 2026; and "Protein" is changed through it to a weekday-set rhythm of
  Tuesday and Thursday, on the name, the day kept from and the target it already has, under no
  category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place is keeping is of the total
  kind with a target of 120

#### Scenario: a stopped commitment put under a category through a commitments screen's change stays stopped under it

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is stopped there
  as of Sunday 30 August 2026; a commitments screen is opened at that roster place and at a record
  place where nothing has been kept as of Monday 31 August 2026; and "Creatine" is changed through
  it to the category "Supplements", on the name, the rhythm and the day kept from it already has
- **THEN** nothing is refused
- **AND** what it has stopped is one entry, named "Creatine", and what it says "Creatine" is made of
  says the category "Supplements"
- **AND** after "Creatine" is taken up again through the screen, what it keeps is two groups,
  "Supplements" holding "Creatine" and then a group with no category holding "Gym"

#### Scenario: a name, an earlier day kept from and a rhythm changed in one save reach every era

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 August 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; and "Gym" is
  changed through it to the name "Gym 🏋️", on a weekday-set rhythm of Tuesday and Thursday, kept
  from 1 June 2026, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Gym 🏋️" on Monday, Wednesday and Saturday, kept from 1 June 2026, and about Monday 31 August
  2026 with "Gym 🏋️" on Tuesday and Thursday, kept from 31 August 2026
- **AND** what the screen keeps is one entry, named "Gym 🏋️", saying "Tue, Thu", and what it says
  that commitment is made of says the day kept from 1 June 2026

#### Scenario: a change writes nothing at the record place, whatever it changes

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record
  place; a commitments screen is opened at that roster place and that record place as of Monday
  31 August 2026; the content at that record place is read; and "Gym" is changed through it three
  times — to the name "Gym 🏋️", then to the day kept from 1 June 2026, then to a weekday-set rhythm
  of Tuesday and Thursday
- **THEN** nothing is refused
- **AND** the content at that record place is byte-for-byte what was read before the first change

#### Scenario: a change of rhythm through a commitments screen puts the commitment under the category it was given

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, under the category "Sport", is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday 31
  August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and Thursday,
  under the category "Morning"
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Morning", holding one entry named "Gym", saying "Tue, Thu"

#### Scenario: a commitment whose range is changed through a commitments screen is given a new era from today

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10, on a schedule
  listing all seven weekdays, kept from 1 January 2026, is taken on at a roster place; a commitments
  screen is opened at that roster place and at a record place where nothing has been kept as of
  Monday 31 August 2026; and "Mood" is changed through it to a range of 1 to 5, on the name, the
  rhythm and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Mood"
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with the
  era ranging 1 to 10 and about Monday 31 August 2026 with the era ranging 1 to 5
- **AND** what it has stopped is nothing

#### Scenario: a target changed through a commitments screen puts a new era on and leaves every record standing

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  all seven weekdays, kept from 1 January 2026, is taken on at a roster place; additions summing to
  120 for it on Monday 3 August 2026 are kept at a record place; a commitments screen is opened at
  that roster place and that record place as of Monday 31 August 2026; the content at that record
  place is read; and "Protein" is changed through it to a target of 100, on the name, the rhythm and
  the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place is keeping is of the total
  kind with a target of 100
- **AND** a store opened afterwards at that record place answers 120 added for that commitment on
  Monday 3 August 2026
- **AND** the content at that record place is byte-for-byte what was read before the change

#### Scenario: a range added to a number commitment carrying none, and one taken off, each put a new era on

- **WHEN** a commitment named "Weight" of the number kind carrying no range and one named "Mood" of
  the number kind with a range of 1 to 10, both on a schedule listing all seven weekdays and kept
  from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that roster
  place and at a record place where nothing has been kept as of Monday 31 August 2026; "Weight" is
  changed through it to a range of 40 to 150 and "Mood" to no range at all, each on the name, rhythm
  and day kept from it already has, under no category
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place answers about Monday 31 August 2026 with
  "Weight" ranging 40 to 150 and "Mood" carrying no range
- **AND** it answers about Sunday 30 August 2026 with "Weight" carrying no range and "Mood" ranging
  1 to 10, among them
- **AND** each is one commitment with two eras, kept from 1 January 2026

### Requirement: A roster holds the commitments a person keeps and every era of each, in the order they were taken on

A roster SHALL hold commitments in an order it holds, and SHALL read back in that order every
commitment it has not stopped keeping. A roster given no commitment SHALL hold none, as an answer
rather than a refusal, and there SHALL be no upper bound on how many it holds.

The order SHALL be the person's. The order the commitments were taken on SHALL be its initial value
and the place a newly taken-on commitment lands, and moving SHALL be the only thing that ever
changes it. A move SHALL take one of exactly two things and there SHALL be no third: a commitment,
or a group, which takes every commitment under one category with it as a block. Changing one era
for another SHALL put the second exactly where the first was, and putting a new era on a commitment
SHALL take it on in the place that commitment held; neither is a move. A roster MUST NOT sort its commitments
by name, by the day each is kept from, or by any other property of them. The order SHALL run over
every era of everything the roster holds, kept, stopped and removed alike, and a commitment stopped
or removed SHALL keep its place in it and return to that place when it is taken up again.

A roster SHALL hold, for each era it holds, at most three further things — the category its
commitment is under, the day that era was kept until, and that its commitment was removed — and
nothing else. It MUST NOT give a commitment a position it can be asked for, a record of the day it
was added, or any other state, and MUST NOT alter a commitment it holds: one read back SHALL be the
one that was put in. An identity is a part of a commitment and not a thing the roster gives it, and
the eras of one commitment are linked by carrying it. Changing one era for another SHALL NOT be
altering one. Being stopped, removed, put under a category, changed
or superseded SHALL give a commitment no fifth part, and SHALL leave it answering whether it is due
exactly as before. The ban on a position is a ban on a read: nothing SHALL ask a roster where a
commitment is, and moving one hands a place in rather than reading one out. A category SHALL be read
back as part of the groups the roster reads its commitments back in, and nothing SHALL ask it about
one commitment on its own.

Kept, stopped and removed SHALL be the three states, and a commitment the roster holds SHALL be in
exactly one of them, carried by its newest era: one it is keeping has no kept-until day on that era
and has not been removed, one it has stopped keeping or removed has one. A category SHALL NOT be a fourth state and SHALL cut across all
three. Nothing SHALL take a commitment out of a roster, and a roster ever given one SHALL NOT be the
same roster as one given none.

A roster SHALL NOT consult the present moment, the device's clock, its time zone or its locale,
SHALL NOT be asked what day it is, and SHALL work only with dates it was handed, judging one only
against a day it was told a commitment was kept until. It MUST NOT judge a commitment's own day it
is kept from or its schedule, and MUST NOT decide whether a commitment is due.

A roster SHALL be a value: two holding the same eras of the same commitments in the same order,
each commitment in the same state and under the same category and each era with the same kept-until
day, SHALL be the same roster; two holding them in a different order SHALL be different rosters. Adding a commitment, stopping one,
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

#### Scenario: a new era put on a commitment lands in that commitment's place rather than after every commitment already there

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, then one named "Journaling", all kept from 1 January 2026,
  puts a new era on "Gym" on a schedule listing Tuesday and Thursday, kept from 1 September 2026, as
  of 31 August 2026, under no category
- **THEN** the roster reads back three commitments it is keeping, in the order "Water plants", then
  "Gym" on Tuesday and Thursday, then "Journaling"
- **AND** a commitment named "Reading" added to that roster afterwards is read back last of the four

#### Scenario: a roster store given a thousand commitments holds every one of them, in the order they were given

- **WHEN** a thousand commitments named "Commitment 1" through "Commitment 1000", all on a schedule
  listing Monday, Wednesday and Saturday and all kept from 1 January 2026, are taken on through a
  roster store in that order, and a store is opened afterwards at the same place
- **THEN** the store reports of each of the thousand that it was added
- **AND** the later store's roster reads back all thousand, "Commitment 1" first, "Commitment 2"
  second and "Commitment 1000" last, in the order they were given

### Requirement: A commitments screen says which field of its sheet a refusal it answers is about, or that it is about no field

Where a commitments screen refuses a commitment defined through it, a change to one, or a restart,
it SHALL hold that refusal with which field of its sheet it is about — at most one, the
last ask's, a restart's included. A name that says nothing SHALL be about the name field. A rhythm
due on no day, and a rhythm number the calendar will not take, SHALL be about the rhythm field. A
range that is not a range SHALL be about the range field, and a target that is not a target about
the target field. Every refusal a restart answers SHALL be about the restart day field but for a
place that could not be written. A name a commitment its roster keeps or has stopped keeping already has SHALL be about the name
field. A place that could not be written SHALL be about the whole change and no field.

#### Scenario: a refusal that a name says nothing is about the name field

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it
- **THEN** it is refused as a name that says nothing, about the name field of its sheet
- **AND** the screen holds that refusal against defining a commitment as well

#### Scenario: a refusal that a rhythm is due on no day is about the rhythm field

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Gym" on a weekday-set rhythm of no weekdays at all,
  kept from that same day, is defined through it
- **THEN** it is refused as a rhythm due on no day, about the rhythm field of its sheet

#### Scenario: a refusal that the calendar will not take a rhythm's number is about the rhythm field

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Contact lenses" on an interval rhythm of 0 days,
  kept from that same day, is defined through it
- **THEN** it is refused as a rhythm number the calendar will not take, about the rhythm field of
  its sheet
- **AND** one named "Finances" on a day-of-the-month rhythm of the 32nd is about that field too

#### Scenario: a refusal that a range is not a range is about the range field

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the number kind with a lowest of "10" and
  a highest of "1", is defined through it
- **THEN** it is refused as a range that is not a range, about the range field of its sheet

#### Scenario: a refusal that a target is not a target is about the target field

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Water" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the total kind with a target of "0", is
  defined through it
- **THEN** it is refused as a target that is not a target, about the target field of its sheet

#### Scenario: a refusal that a name is already in use is about the name field

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; and a commitment named "Gym" on that same rhythm and day is defined through the screen
- **THEN** it is refused as a name already in use, about the name field of its sheet

#### Scenario: a refusal that a roster could not be written is about the whole change and no field

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; what is at that place is then made impossible to write; and a commitment
  named "Journaling" on a weekday-set rhythm of all seven weekdays, kept from that same day, is
  defined through it
- **THEN** it is refused as a place that could not be written, about the whole change and about no
  field of its sheet

#### Scenario: a restart refused for the day it was asked from is about the restart day field

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday
  31 August 2026; and "Nails" is restarted through it from Monday 3 August 2026
- **THEN** it is refused as a day before the day it is kept from, about the restart day field of its
  sheet
- **AND** a restart from Tuesday 1 September 2026 and one from Sunday 30 August 2026 are each about
  that field too

#### Scenario: a restart refused by a place that could not be written is about the whole change

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Saturday 1 August 2026, is taken on at a roster place; ticks for it on Thursday
  6 August 2026 and Monday 10 August 2026 are kept at a record place; a commitments screen is opened
  at that roster place and that record place as of Monday 31 August 2026; what is at that roster
  place is then made impossible to write; and "Nails" is restarted through it from Sunday 2 August
  2026
- **THEN** it is refused as a place that could not be written, about the whole change and about no
  field of its sheet
#### Scenario: a restart refused for a day already recorded on is about the restart day field

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a tick for it on Sunday
  30 August 2026 is kept at a record place; a commitments screen is opened at that roster place and
  that record place as of Monday 31 August 2026; and "Nails" is restarted through it from Saturday
  29 August 2026
- **THEN** it is refused as a day already recorded on that the change would leave not due, about the
  restart day field of its sheet

### Requirement: A change leaves an interval era's start date where it was unless it names a different day kept from

Where a commitments screen changes a commitment whose schedule is an interval of days, and the
change names the day kept from that the commitment already has, the changed commitment's schedule
SHALL keep the start date the commitment's schedule already has, whether or not that start date is
the day kept from. The same SHALL hold for every era a save leaves in place before it puts a new era on. A save naming exactly the name, the rhythm, the day kept from and the category a
commitment already has SHALL change nothing, whatever its interval's start date.

A change naming a different day kept from SHALL form the earliest era's schedule starting on that
day, whatever start date that era's schedule had before.

#### Scenario: an interval commitment whose start differs from the day it is kept from is renamed and every day recorded on stays due

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a tick for it on Monday
  10 August 2026 is kept at a record place; a commitments screen is opened at that roster place and
  that record place as of Monday 31 August 2026; and "Nails" is changed through it to the name
  "Nails 💅", on the rhythm and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is due on Thursday
  6 August 2026 and on Monday 10 August 2026, and not due on Saturday 8 August 2026
- **AND** a look-back at "Nails 💅" counts Monday 10 August 2026 kept, and the content at that
  record place is byte-for-byte what it was before the change

#### Scenario: an interval commitment whose start differs from the day it is kept from is put under a category without touching the record place

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a tick for it on Monday
  10 August 2026 is kept at a record place; a commitments screen is opened at that roster place and
  that record place as of Monday 31 August 2026; and "Nails" is changed through it to the category
  "Care", on the name, the rhythm and the day kept from it already has
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Care", holding one entry named "Nails"
- **AND** the content at that record place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: an interval commitment whose start differs from the day it is kept from saved unchanged changes nothing

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a tick for it on Monday
  10 August 2026 is kept at a record place; a commitments screen is opened at that roster place and
  that record place as of Monday 31 August 2026; and "Nails" is changed through it to exactly the
  name, the rhythm of every 4 days, the day kept from and the category it already has
- **THEN** nothing is refused
- **AND** the content at both places is byte-for-byte what it was immediately after the screen was
  opened

#### Scenario: an interval commitment whose start differs from the day it is kept from is renamed on a new rhythm and the era it gives way to keeps its start

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a tick for it on Monday
  10 August 2026 is kept at a record place; a commitments screen is opened at that roster place and
  that record place as of Monday 31 August 2026; and "Nails" is changed through it to the name
  "Nails 💅" on a weekday-set rhythm of Sunday, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Nails 💅" on Sunday, kept from 31 August 2026, and then "Nails 💅" on every 4 days starting on
  Thursday 6 August 2026, kept from Tuesday 4 August 2026
- **AND** a look-back at "Nails 💅" counts Monday 10 August 2026 kept

#### Scenario: moving the day an interval commitment is kept from moves its start to that day even where the two had differed

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; and "Nails" is changed through it to the
  day kept from Monday 3 August 2026, on the name and the rhythm it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is due on Monday
  3 August 2026 and on Friday 7 August 2026
- **AND** it is not due on Thursday 6 August 2026

### Requirement: A commitments screen refuses a change it cannot make, and tells each refusal apart

A commitments screen SHALL refuse a change in the words it already uses: a name that says nothing,
a weekday set with no days in it, a rhythm number the calendar will not take, a name a commitment
its roster keeps or has stopped keeping already has, and a place that could not be written. A change
naming the name the commitment it is changing already has SHALL NOT be refused for it, and a name
only a removed commitment has SHALL NOT be refused either. A place that could not be written SHALL
be the roster place, which is the only place a change writes. A change naming a
range that is not a range, or a target that is not a target, SHALL be refused as that, on the grounds
*A commitments screen refuses to define a commitment whose range is not a range, or whose target is
not a target* gives.

Two refusals are this change's own, and each SHALL be told apart from the other seven and from each
other. A change asking for a different rhythm, a different day kept from, a different range or a
different target on a commitment its roster has stopped keeping SHALL be refused as **a change a
stopped commitment does not take**. A change SHALL be refused as **a day already recorded on that the change would leave not due**
where any day the commitment has a record on is a day it would not be due on after the change;
moving the day an interval commitment is kept from earlier by a whole number of intervals leaves
every day already recorded on due and SHALL NOT be refused.

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
- **AND** a look-back at "Contact lenses" counts Wednesday 15 July 2026 kept
- **AND** the content at that record place is byte-for-byte what it was before the change

#### Scenario: a change to a name another commitment already has is refused, kept or stopped alike

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; and "Gym" is changed through it to the
  name "Run", under no category
- **THEN** it is refused as a name already in use, naming "Run"
- **AND** what it keeps is two entries, named "Gym" and then "Run"
- **AND** the same change is refused the same way on a screen whose roster had stopped keeping "Run"
  as of Sunday 30 August 2026, and is not refused on one whose roster had removed it as of that day

#### Scenario: changing the rhythm or the day kept from of a stopped commitment is refused

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; "Gym" is stopped there as of Sunday 30 August 2026;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is
  changed through it to a weekday-set rhythm of Tuesday and Thursday, under no category
- **THEN** it is refused as a change a stopped commitment does not take, told apart from a name
  already in use and from a place that could not be written
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
- **THEN** it is refused as a place that could not be written, told apart from a name already in use
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a change refuses a name that says nothing, a rhythm due on no day and a rhythm number the calendar will not take

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is changed through it three times — once to the name "   ",
  once to a weekday-set rhythm listing no weekdays, and once to a day-of-the-month rhythm of the 32nd
- **THEN** the three are refused as a name that says nothing, a rhythm due on no day and a rhythm
  number the calendar will not take, each told apart from the others
- **AND** what it keeps is one entry, named "Gym", after all three

#### Scenario: a name and a rhythm changed in one save and refused at the roster place leave the record place as it was

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; the content at that record place is read; what is at that roster place is
  then made impossible to write; and "Gym" is changed through it to the name "Gym 🏋️" on a
  weekday-set rhythm of Tuesday and Thursday, under no category
- **THEN** it is refused as a place that could not be written
- **AND** the content at that record place is byte-for-byte what was read before the change

#### Scenario: a name and a rhythm changed in one save onto a name another commitment has are refused

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and kept from 1 January 2026, are taken on at a roster place; a commitments
  screen is opened at that roster place and at a record place where nothing has been kept as of
  Monday 31 August 2026; and "Gym" is changed through it to the name "Run" on a weekday-set rhythm
  of Tuesday and Thursday, under no category
- **THEN** it is refused as a name already in use, naming "Run"
- **AND** what it keeps is two entries, named "Gym" and then "Run", both saying "Mon, Wed, Sat"

#### Scenario: a name, a later day kept from and a rhythm changed in one save past a day recorded on is refused

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 June 2026,
  is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record place; a
  commitments screen is opened at that roster place and that record place as of Monday 31 August
  2026; and "Gym" is changed through it to the name "Gym 🏋️", on a weekday-set rhythm of Tuesday
  and Thursday, kept from 1 September 2026, under no category
- **THEN** it is refused as a day already recorded on that the change would leave not due
- **AND** what the screen keeps is one entry named "Gym", and the content at both places is
  byte-for-byte what it was immediately after the screen was opened

#### Scenario: a change of rhythm a commitments screen could not keep leaves both its lists as they were

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; what is at that
  roster place is then made impossible to write; and "Gym" is changed through it to a weekday-set
  rhythm of Tuesday and Thursday, under no category
- **THEN** it is refused as a place that could not be written
- **AND** what it keeps is one entry, named "Gym", saying "Mon, Wed, Sat", and what it has stopped
  is nothing
- **AND** the screen holds that refusal, against changing "Gym"

#### Scenario: a change refuses a range that is not a range and a target that is not a target

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10 and one named
  "Protein" of the total kind with a target of 120, both on a schedule listing all seven weekdays and
  kept from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that
  roster place and at a record place where nothing has been kept as of Monday 31 August 2026; "Mood"
  is changed through it to a lowest of "10" and a highest of "1"; and "Protein" is changed through it
  to a target of "0", each on the name, rhythm and day kept from it already has, under no category
- **THEN** the first is refused as a range that is not a range and the second as a target that is not
  a target, each told apart from the other and from a name already in use
- **AND** what it keeps is two entries, named "Mood" and then "Protein", and the content at that
  roster place is byte-for-byte what it was immediately after the screen was opened
- **AND** a change of "Mood" to a lowest of "40" and a highest left blank is refused as a range that
  is not a range too

#### Scenario: changing the range or the target of a stopped commitment is refused

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10 and one named
  "Protein" of the total kind with a target of 120, both on a schedule listing all seven weekdays and
  kept from 1 January 2026, are taken on at a roster place; both are stopped there as of Sunday
  30 August 2026; a commitments screen is opened at that roster place and at a record place where
  nothing has been kept as of Monday 31 August 2026; and "Mood" is changed through it to a range of
  1 to 5, on the name, rhythm and day kept from it already has, under no category
- **THEN** it is refused as a change a stopped commitment does not take, told apart from a range that
  is not a range and from a place that could not be written
- **AND** a change of "Protein" to a target of 100, alike in every other way, is refused the same way
- **AND** what it has stopped is two entries, named "Mood" and then "Protein"
#### Scenario: a change naming the name the commitment already has is not refused for it

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, on the name and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Gym", saying "Tue, Thu"
- **AND** a change to the name "GYM" beside that rhythm is not refused either

#### Scenario: a change to a name only a removed commitment has is not refused

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Run" is removed there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday 31 August
  2026; and "Gym" is changed through it to the name "Run", under no category
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Run"

### Requirement: A roster store keeps a roster and every era at a place, across the app being closed and opened again

A roster store SHALL be opened at a place and SHALL hold a roster. Opening one where nothing has
been kept SHALL give a roster holding nothing rather than an error, and that SHALL be the only time
a roster store opens holding nothing.

A commitment taken on through a roster store SHALL be kept at that place before the store reports it
taken on. A store opened at the same place afterwards SHALL hold it, whether or not the first store
was ever closed. Stopping a commitment SHALL be kept the same way, and so SHALL removing one, moving
one, moving a whole group, putting one under a category, changing one era for another, renaming one,
putting a new era on one, and taking one up again. There SHALL be no separate step at which a roster store is
saved. A roster store that cannot keep a change MUST refuse it and MUST NOT hold it, and the roster
a store reports SHALL never be ahead of what is kept at its place.

A roster store SHALL report exactly what the roster reports and MUST NOT turn a roster's own refusal
into an error, whichever refusal it is, as the roster requirements state them. A change that leaves
the roster exactly as it was SHALL keep nothing at the place either, and SHALL still report what the
roster reported.

A roster store SHALL persist exactly what a roster is, and nothing it invented: each era with the
parts its commitment is made of, its identity among them, the category that commitment is under, the
day that era was kept until, and that its commitment was removed. An identity SHALL be kept exactly
as it was given, MUST NOT be derived from any other part and MUST NOT be reissued on a write, so
that a store opened afterwards holds the same commitments and not commitments alike to them. A number commitment's range SHALL be kept where it has
one and be absent where it has none, both ends as given; a target SHALL be kept as given, decimal
fraction and all, and MUST NOT be rounded, widened or narrowed; a category SHALL be kept exactly as
it was given, blank space at either end and all, and MUST NOT be trimmed, case-folded, deduplicated
against another category or turned into a reference to a list kept elsewhere. The store SHALL keep
the commitments in the order the roster holds them and read them back in that order, MUST NOT impose
an order of its own, MUST NOT sort by name, by a day, by a category or by anything else, and MUST
NOT write its commitments grouped by category to the file. A roster read back SHALL be the same roster that was kept, for every schedule shape, every kind,
any name, any category, any date the system supports, each of the three states, and any number of
eras on one commitment. The store MUST NOT key anything to the moment it was
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
  then given that same commitment; and a store is opened afterwards at the same place
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
- **AND** the store reports that it stopped keeping "Gym"

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
  given that same commitment; and a store is opened afterwards at the same place
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

#### Scenario: a stop that cannot be kept is refused and the roster a store reports does not move

- **WHEN** a commitment named "Gym" under the category "Sport", one named "Journaling" under the
  category "Evening" and one named "Run" under no category, all on a schedule listing Monday,
  Wednesday and Saturday and all kept from 1 January 2026, are taken on through a roster store, and
  "Run" is stopped through it as of 31 January 2026; what is at that place is then made impossible
  to write; and the store is asked to stop keeping "Gym" as of 31 January 2026
- **THEN** it is refused with an error
- **AND** the store's roster is still the same roster it was before the ask

#### Scenario: a group move that cannot be kept is refused and the roster a store reports does not move

- **WHEN** a commitment named "Gym" under the category "Sport", one named "Journaling" under the
  category "Evening" and one named "Run" under no category, all on a schedule listing Monday,
  Wednesday and Saturday and all kept from 1 January 2026, are taken on through a roster store, and
  "Run" is stopped through it as of 31 January 2026; what is at that place is then made impossible
  to write; and the store is asked to move the group "Sport" to the offset 2
- **THEN** it is refused with an error
- **AND** the store's roster is still the same roster it was before the ask

#### Scenario: a change of one commitment for another that cannot be kept is refused and the roster a store reports does not move

- **WHEN** a commitment named "Gym" under the category "Sport", one named "Journaling" under the
  category "Evening" and one named "Run" under no category, all on a schedule listing Monday,
  Wednesday and Saturday and all kept from 1 January 2026, are taken on through a roster store, and
  "Run" is stopped through it as of 31 January 2026; what is at that place is then made impossible
  to write; and the store is asked to change "Gym" for a commitment named "Gym 🏋️" alike in every
  other way, under no category
- **THEN** it is refused with an error
- **AND** the store's roster is still the same roster it was before the ask

#### Scenario: a supersession that cannot be kept is refused and the roster a store reports does not move

- **WHEN** a commitment named "Gym" under the category "Sport", one named "Journaling" under the
  category "Evening" and one named "Run" under no category, all on a schedule listing Monday,
  Wednesday and Saturday and all kept from 1 January 2026, are taken on through a roster store, and
  "Run" is stopped through it as of 31 January 2026; what is at that place is then made impossible
  to write; and the store is asked to supersede "Gym" with a commitment named "Gym" on a schedule
  listing Tuesday and Thursday, kept from 1 September 2026, as of 31 August 2026, under no category
- **THEN** it is refused with an error
- **AND** the store's roster is still the same roster it was before the ask

#### Scenario: a take-up-again that cannot be kept is refused and the roster a store reports does not move

- **WHEN** a commitment named "Gym" under the category "Sport", one named "Journaling" under the
  category "Evening" and one named "Run" under no category, all on a schedule listing Monday,
  Wednesday and Saturday and all kept from 1 January 2026, are taken on through a roster store, and
  "Run" is stopped through it as of 31 January 2026; what is at that place is then made impossible
  to write; and the store is asked to take "Run" up again
- **THEN** it is refused with an error
- **AND** the store's roster is still the same roster it was before the ask

#### Scenario: a stop a roster store refuses for a removed commitment is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store;
  "Run" is removed through it as of 31 January 2026; the content at that place is read; and the
  store is asked to stop keeping "Run" as of 28 February 2026
- **THEN** the store reports that it did not stop keeping the commitment, and reports no error
- **AND** the content at that place is byte-for-byte what was read before the ask

#### Scenario: a move a roster store refuses for a stopped commitment is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store;
  "Run" is stopped through it as of 31 January 2026; the content at that place is read; and the
  store is asked to move "Run" to the offset 0
- **THEN** the store reports that it did not move the commitment, and reports no error
- **AND** the content at that place is byte-for-byte what was read before the ask

#### Scenario: a move a roster store refuses for a removed commitment is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store;
  "Run" is removed through it as of 31 January 2026; the content at that place is read; and the
  store is asked to move "Run" to the offset 0
- **THEN** the store reports that it did not move the commitment, and reports no error
- **AND** the content at that place is byte-for-byte what was read before the ask

#### Scenario: a move a roster store refuses for an offset it does not have is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store; the
  content at that place is read; and the store is asked to move "Gym" to the offset 3, and then to
  the offset -1
- **THEN** the store reports that it did not move the commitment either time, and reports no error
- **AND** the content at that place is byte-for-byte what was read before the ask

#### Scenario: a category change a roster store refuses for a commitment it does not hold is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store; the
  content at that place is read; and the store is asked to put a commitment named "Journaling" alike
  in every other way, which it does not hold, under the category "Sport"
- **THEN** the store reports that it did not put the commitment under the category, and reports no
  error
- **AND** the content at that place is byte-for-byte what was read before the ask

#### Scenario: a category change a roster store refuses for a removed commitment is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store;
  "Run" is removed through it as of 31 January 2026; the content at that place is read; and the
  store is asked to put "Run" under the category "Sport"
- **THEN** the store reports that it did not put the commitment under the category, and reports no
  error
- **AND** the content at that place is byte-for-byte what was read before the ask

#### Scenario: a change a roster store refuses for a commitment it does not hold is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store; the
  content at that place is read; and the store is asked to change a commitment named "Journaling"
  alike in every other way, which it does not hold, for one named "Journal", under no category
- **THEN** the store reports that it did not change the commitment, and reports no error
- **AND** the content at that place is byte-for-byte what was read before the ask

#### Scenario: a supersession a roster store refuses for a stopped commitment is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store;
  "Run" is stopped through it as of 31 January 2026; the content at that place is read; and the
  store is asked to supersede "Run" with a commitment named "Running" alike in every other way, as
  of 31 August 2026, under no category
- **THEN** the store reports that it did not supersede the commitment, and reports no error
- **AND** the content at that place is byte-for-byte what was read before the ask

#### Scenario: an era a roster store refuses to put on because it is not that commitment's is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store; the
  content at that place is read; and the store is asked to put "Run"'s era on "Gym", as of
  31 August 2026, under no category
- **THEN** the store reports that it did not put the era on, and reports no error
- **AND** the content at that place is byte-for-byte what was read before the ask

#### Scenario: categories differing only in case are read back out of a roster store as two categories

- **WHEN** a commitment named "Creatine" and one named "Magnesium", both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster
  store; "Creatine" is put under the category "Supplements" through it and "Magnesium" under the
  category "supplements"; and a store is opened afterwards at the same place
- **THEN** the later store's roster reads back two groups, "Supplements" holding "Creatine" and then
  "supplements" holding "Magnesium"

#### Scenario: a roster store and a record store kept beside it change nothing at each other's place

- **WHEN** a tick for a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, on Monday 5 January 2026 is kept at a record place; the content at that
  record place is read; and "Gym" is taken on through a roster store at a roster place in the same
  directory and stopped through it as of 31 January 2026
- **THEN** the content at that record place is byte-for-byte what was read
- **AND** a tick for "Gym" on Wednesday 7 January 2026 kept at that record place afterwards leaves
  the content at that roster place byte-for-byte what it was after the stop
#### Scenario: a commitment with two eras kept through a roster store is read back as one commitment with two eras

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store; a new era on a schedule listing Tuesday and
  Thursday, kept from 1 September 2026, is put on it as of 31 August 2026, under no category; and a
  store is opened afterwards at the same place
- **THEN** the later store's roster reads back one commitment it is keeping, saying "Tue, Thu", and
  two eras of it
- **AND** it says that commitment is kept from 1 January 2026
- **AND** it is the same roster as the first store's

#### Scenario: a roster store read back holds the same commitments rather than commitments alike to them

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are taken on through a roster store; a
  store is opened afterwards at the same place; and "Gym" is renamed "Lifting" through the later
  store
- **THEN** the later store reports that it renamed the commitment
- **AND** a third store opened at that place afterwards reads back "Lifting" and then "Run"
- **AND** the commitment the third store reads back first is the same commitment the first store was
  given first

#### Scenario: an era a roster store refuses to put on a removed commitment is reported and nothing at its place changes

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on through a roster store and removed through it as of 31 January 2026;
  the content at that place is read; and a new era on a schedule listing Tuesday and Thursday, kept
  from 1 September 2026, is put on it as of 31 August 2026, under no category
- **THEN** the store reports that it did not put the era on
- **AND** the content at that place is byte-for-byte what was read

### Requirement: A commitments screen defines a new commitment from a name, a rhythm and the day it is kept from

A commitments screen SHALL define a commitment from five things and no others: a name, a rhythm, the
day it is kept from, a category, which may be none, and the kind its days take. A change SHALL take
four of them, every one but the kind, and a commitment the screen already holds SHALL be offered no
kind at all. What is formed SHALL carry an identity of its own, SHALL be taken on at the roster place before
either list says so, and SHALL then be last in what the screen keeps, in the group of the category
given. It SHALL never find a commitment the roster holds stopped or removed, whatever it is named:
taking a stopped commitment up again is the one-tap act on its row, and a removed one is beyond
reach. Two commitments alike in every part SHALL be two here as in a roster. A
rhythm SHALL be one of four, all four offered — a weekday set, a day of the month, an interval of
whole days, a weekly quota — and an interval rhythm carries no start date. Three of the four take a
number, which a rhythm SHALL carry as the person gave it, judged by nothing on the way. A kind SHALL
likewise be one of four, all four offered — a tick, a number, a note, a total — and the tick SHALL
be the kind offered for a new commitment. A category of nothing but blank space is no category and
SHALL NOT be refused; every other SHALL be kept exactly as given, blank space at its ends and all.
The day a commitment is kept from SHALL also be an interval rhythm's start date on this screen,
though the two remain distinct in the model and may disagree where something else forms the
commitment. This screen SHALL offer the day it was handed for a new commitment, SHALL accept any
calendar date the system supports, the future included, and MUST NOT judge that date against it or
bound it beyond the calendar.

A number kind's two range ends and a total kind's target SHALL each be taken as text exactly as
typed, and SHALL NOT be judged, formed or blocked before they arrive. Each SHALL be read as a number
entry reads a committed number, and there SHALL be one such reading rather than two: no locale
consulted, blank space at either end disregarded, and what is left may carry a leading minus, SHALL
hold at least one digit, SHALL hold no character that is not a digit but for at most one separator,
a full stop or a comma, and SHALL hold no more than thirty-eight significant digits. What that
reading does not hold as a number SHALL NOT be rounded, truncated or adjusted to fit. Whether a
field is blank SHALL be asked before it is read as a number, blank being decided by the one test
this package asks for the question. A range end holding a zero-width space alone SHALL be refused as
not a number rather than as empty. Both range ends blank SHALL be a commitment of the number kind
carrying no range, while one end filled and the other blank is not no range. A range or a target
left in a field the chosen kind has no room for SHALL be ignored, and SHALL NOT be refused: the tick
and note kinds carry neither whatever those fields hold, the number kind takes its range and ignores
a target, and the total kind takes its target and ignores a range.

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

#### Scenario: a target typed on the tick or the note kind is ignored rather than refused

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and two commitments on a weekday-set rhythm of all seven weekdays, kept
  from that same day, under no category, are defined through it — "Gym" of the tick kind and
  "Journal" of the note kind, each with a target of "0" left in the target field
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place holds "Gym" of the tick kind and "Journal"
  of the note kind

#### Scenario: a range whose two ends each hold a zero-width space alone is refused as not a number rather than taken as blank

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the number kind with a lowest of one
  zero-width space and a highest of one zero-width space, is defined through it
- **THEN** it is refused as a range that is not a range
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a range end holding no digit is refused as not a number

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the number kind with a lowest of "-" and
  a highest of "10", is defined through it
- **THEN** it is refused as a range that is not a range
- **AND** a commitment alike in every way with a lowest of "0" and a highest of "." is refused the
  same way
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a range end holding more than one separator is refused as not a number

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the number kind with a lowest of "1.2.3"
  and a highest of "10", is defined through it
- **THEN** it is refused as a range that is not a range
- **AND** a commitment alike in every way with a lowest of "1" and a highest of "1,5.0" is refused
  the same way
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitment defined through a commitments screen carries an identity of its own

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Gym" on a weekday-set rhythm of Monday, Wednesday
  and Saturday, kept from that same day, is defined through it; "Gym" is then renamed "Lifting"
  through it; and a commitment named "Gym" on that same rhythm and day is defined through it
- **THEN** neither is refused
- **AND** what it keeps is two entries, named "Lifting" and then "Gym"
- **AND** a look-back at "Lifting" and one at "Gym" are look-backs at different commitments

#### Scenario: a commitment defined under the name a removed commitment has is taken on last, under the category the form carried

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is removed there
  as of Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and a commitment named "Creatine" on that same rhythm, kept from that same day,
  under the category "Supplements", is defined through it
- **THEN** nothing is refused
- **AND** what it keeps is two groups, one with no category holding "Gym" and then "Supplements"
  holding "Creatine"
- **AND** a look-back at "Creatine" says the day kept from "31 August 2026"

### Requirement: A commitments screen restarts an interval commitment it keeps by putting a new era on it

A commitments screen SHALL restart a commitment on its kept list whose schedule is an interval of
days, on being given that commitment and a calendar date and nothing else. It SHALL put a new era on the commitment as of the day before that date — an era alike in name,
interval and kind whose schedule starts on that date and which is kept from that date — under the
category the commitment is under.

It SHALL move no record and SHALL write nothing at the record place: every record already made
stays a record of that commitment, on the day it was made for, whichever era now holds that day. A
restart SHALL change no name, no interval, no kind and no category, and SHALL leave the day the
commitment is kept from where it is.

#### Scenario: an interval commitment restarted from today is kept until yesterday and runs on from today under its name, interval and category

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, under the category "Care", is taken on at a roster place; a
  tick for it on Monday 10 August 2026 is kept at a record place; a commitments screen is opened at
  that roster place and that record place as of Monday 31 August 2026; and "Nails" is restarted
  through it from Monday 31 August 2026
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Care", holding one entry named "Nails", saying "Every 4 days"
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Nails" on every 4 days starting on Monday 31 August 2026, kept from that day, and then "Nails" on
  every 4 days starting on Thursday 6 August 2026, kept from Tuesday 4 August 2026; and about Monday
  31 August 2026 with the first alone
- **AND** the content at that record place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: an interval commitment restarted from the day it is kept from is kept on no date before the restart

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday
  31 August 2026; and "Nails" is restarted through it from Tuesday 4 August 2026
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place is keeping is due on Tuesday
  4 August 2026 and on Saturday 8 August 2026, and not due on Thursday 6 August 2026
- **AND** that roster store answers about Tuesday 4 August 2026 with that commitment alone

#### Scenario: an interval commitment restarted through a commitments screen draws one row on a day screen on either side of the restart

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday
  31 August 2026; and "Nails" is restarted through it from Monday 31 August 2026
- **THEN** a day screen opened afterwards at those places as of Sunday 30 August 2026 draws one row,
  named "Nails"
- **AND** one opened as of Monday 31 August 2026 draws one row, named "Nails", and so does one
  opened as of Friday 4 September 2026
- **AND** one opened as of Thursday 3 September 2026 draws no row

#### Scenario: restarting an interval commitment moves no record and writes nothing at the record place

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Saturday 1 August 2026, is taken on at a roster place; ticks for it on Thursday
  6 August 2026 and Monday 10 August 2026 are kept at a record place; a commitments screen is opened
  at that roster place and that record place as of Monday 31 August 2026; the content at that record
  place is read; and "Nails" is restarted through it from Sunday 2 August 2026
- **THEN** nothing is refused
- **AND** the content at that record place is byte-for-byte what was read
- **AND** a look-back at "Nails" counts Thursday 6 August 2026 and Monday 10 August 2026 kept, and
  says the day kept from "1 August 2026"

### Requirement: A commitments screen refuses a restart it cannot make, and tells each refusal apart

A commitments screen SHALL refuse a restart from a date later than the day it was handed, from a
date earlier than the day the commitment is kept from, and from a date the commitment is already due
on, each told apart from every other refusal.

It SHALL refuse a restart as a day already recorded on that the change would leave not due where a
record on or after the date is on a day the era the restart puts on is not due on, and as a place
that could not be written. It SHALL refuse a restart for no name and for no record already kept: a
restarted commitment is the commitment it was, and a restart takes no name and produces no second
commitment. A refused restart SHALL keep nothing at
either place and SHALL be held against the commitment it was asked about.

#### Scenario: a restart from a day after today, a day before the day kept from, or a day the rhythm is already due on is refused, each told apart

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday
  31 August 2026; and "Nails" is restarted through it three times — from Tuesday 1 September 2026,
  from Monday 3 August 2026 and from Sunday 30 August 2026
- **THEN** the three are refused as a day after today, a day before the day it is kept from and a day
  the rhythm is already due on, each told apart from the others and from a place that could not be
  written
- **AND** what it keeps is one entry named "Nails", and the content at both places is byte-for-byte
  what it was immediately after the screen was opened

#### Scenario: a restart that would leave a day recorded on after it not due is refused

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a tick for it on Sunday
  30 August 2026 is kept at a record place; a commitments screen is opened at that roster place and
  that record place as of Monday 31 August 2026; and "Nails" is restarted through it from Saturday
  29 August 2026
- **THEN** it is refused as a day already recorded on that the change would leave not due
- **AND** the content at both places is byte-for-byte what it was immediately after the screen was
  opened

#### Scenario: a restart is refused for no name and for no record already kept

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, and one named "Nails 2" on a schedule of every 4 days
  starting on Monday 31 August 2026, kept from that day, are taken on at a roster place; a tick for
  "Nails" on Thursday 6 August 2026 is kept at a record place; a commitments screen is opened at that
  roster place and that record place as of Monday 31 August 2026; and "Nails" is restarted through it
  from Monday 31 August 2026
- **THEN** nothing is refused
- **AND** what it keeps is two entries, named "Nails" and then "Nails 2"
- **AND** a look-back at "Nails" counts Thursday 6 August 2026 kept and says the day kept from
  "4 August 2026"

## MODIFIED Requirements

### Requirement: A commitments screen lists what has been stopped, beside what it keeps

A commitments screen SHALL list, separately from the commitments its roster is keeping, the
commitments that roster has stopped keeping — in the order the roster holds them, each as a name and
the rhythm it runs on in words, exactly as the first list is. A stopped commitment SHALL never be
moved. A commitment the roster has removed SHALL be in neither list, and neither SHALL any era of a
commitment but its newest; every other SHALL be in exactly one of the two and never in both. A roster that has stopped nothing SHALL list nothing as
stopped. That list SHALL NOT be grouped, and SHALL be one flat list whatever categories its
commitments are under. A commitment taken up again from this list SHALL be drawn in the group of the
category it was under.

#### Scenario: a commitments screen lists what its roster has stopped keeping, in the order they were taken on

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling",
  all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Journaling" and then "Water plants" are stopped there as of Sunday 30 August 2026;
  and a commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it has stopped is two entries, named "Water plants" and then "Journaling"
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a stopped entry says the rhythm its commitment runs on, as a kept entry does

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a
  roster written in the form used before a commitment had an identity, whose entries are "Vitamins"
  on a schedule listing Monday and Wednesday and "Vitamins" on a schedule of 3 times a week, both
  kept from 1 January 2026 and both stopped as of Sunday 30 August 2026
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
#### Scenario: an earlier era of a commitment is in neither of a commitments screen's lists

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a new era on a schedule listing Tuesday and
  Thursday, kept from Monday 31 August 2026, is put on it there as of Sunday 30 August 2026; and a
  commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is one entry, named "Gym", saying "Tue, Thu"
- **AND** what it has stopped is nothing
- **AND** the same screen with that commitment stopped there as of Monday 31 August 2026 has one
  stopped entry, saying "Tue, Thu", and keeps nothing

### Requirement: A roster stops keeping a commitment it holds, on the day it was kept until

A roster SHALL stop keeping a commitment it holds, on being given that commitment and the calendar
date it was kept until, which is the last day it was kept. Stopping SHALL take the commitment out of the commitments the roster reads back, SHALL record that
day against its newest era, and SHALL report that the roster stopped keeping it, leaving everything
else exactly as it was, in the order it was in; its earlier eras SHALL be left exactly as they are.

The roster SHALL refuse to stop keeping a commitment in exactly three cases, and SHALL report each:
one it does not hold at all; one it has already stopped keeping; and one it has removed, a removal
being a last state there is nothing a stop could add to. In the second and the third the kept-until
day SHALL stand as first given, and in all three the roster SHALL be left exactly as it was, for as
long as the roster has stopped keeping that commitment or has removed it. Taking a commitment up again SHALL clear that day and SHALL be the only thing that does, as *A
roster refuses a commitment whose name one it keeps or has stopped already has* says, and a commitment taken up again SHALL be one the roster can stop keeping
again, on whatever day it was kept until the second time.

The roster SHALL refuse on no date: any calendar date the system supports SHALL be accepted as a day
a commitment was kept until, including the first, the last, and one earlier than the day that
commitment is kept from. The roster SHALL NOT ask what day it is, MUST NOT refuse a day for being in
the future, and MUST NOT accept one for being in the past.

Stopping SHALL change nothing about the commitment itself and nothing recorded against it: a stopped
commitment SHALL answer whether it is due exactly as before, and every tick already recorded SHALL
stand. Stopping SHALL leave every other roster untouched, and two rosters differing only in the day
one commitment was kept until SHALL be different rosters.

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

#### Scenario: a commitment kept until the first supported date is accepted

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 1583, is asked to stop keeping it as of 1 January 1583
- **THEN** the roster reports that it stopped keeping the commitment
- **AND** it answers with that commitment on 1 January 1583 and with nothing on 2 January 1583
#### Scenario: stopping a commitment with two eras records the day against its newest

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, with a newer era on a schedule listing Tuesday and Thursday,
  kept from 1 March 2026, put on as of 28 February 2026, is asked to stop keeping it as of
  31 March 2026
- **THEN** the roster reports that it stopped keeping the commitment
- **AND** it reads back nothing it is keeping and one commitment it has stopped, with two eras
- **AND** it answers with the newer era on 31 March 2026 and with nothing on 1 April 2026

### Requirement: A roster removes a commitment it holds, and never lets it go

A roster SHALL remove a commitment it holds, on being given that commitment and a calendar date.
Removing SHALL take it out of the commitments the roster reads back and out of those it reads back
as stopped, SHALL hold it as removed, and SHALL report that the roster removed it; the commitment
SHALL stay in the place it has, and everything else SHALL be exactly as it was, in the order it was
in. It SHALL be recorded against the commitment's newest era, and its earlier eras SHALL be left
exactly as they are.
Where the roster is keeping it, the date given SHALL become the day it was kept until; where the
roster has already stopped keeping it, the day it holds SHALL stand and the date given SHALL NOT be
used. A roster SHALL NOT hold a removed commitment without a kept-until day.

A roster SHALL refuse to remove a commitment in exactly two cases and SHALL report each: one it does
not hold, and one it has already removed, whose kept-until day SHALL stand as first given. Either
SHALL leave the roster exactly as it was. A roster whose every commitment has been removed still holds
every one of them, still answers with each of them on every date up to the day it was kept until, and
SHALL NOT be the same roster as one that has been given no commitment at all. The one way back SHALL be offering that same commitment again, as *A roster refuses a commitment
whose name one it keeps or has stopped already has* says, which clears both its kept-until day and
its being removed; a commitment formed afresh carries an identity of its own and SHALL never find a
removed one. A roster SHALL refuse on no date, accepting any
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

### Requirement: A roster store reads a roster kept before a commitment carried a kind

A roster store SHALL read a roster kept in any form this app has written before the one it writes
now, rather than refusing it, and SHALL read each as the roster it was. Every commitment in the form
written before a commitment carried a kind SHALL be read as being of the plain kind; every
commitment in the form written before a commitment could be removed SHALL be read as one the roster
has not removed; every commitment in the form written before a commitment could be put under a category SHALL be
read as one the roster holds under no category; and every roster in a form written before a
commitment had an identity SHALL be folded, as *A roster store folds a roster kept before a
commitment had an identity* says.

Reading a roster kept in an earlier form MUST NOT change what is at the place. A store SHALL write
on a change being kept and at no other moment. Opening the app and doing nothing SHALL leave the
content byte-for-byte what it was, in the form it was already in. The next change kept there SHALL
be written in the form this app writes, whole, and SHALL still hold everything the earlier form held
— the order the commitments were taken on, every day one was kept until, and every part of every
commitment.

Each form SHALL be read as the shape that form has, and a roster store SHALL declare its form before
anything else in it is read. What a stored roster says about removal, what it says about a category, and what it says about an
identity SHALL each agree with the form it declares, in both directions: a store declaring a form
written before a commitment could be removed, before one could be put under a category, or before
one had an identity, and yet saying something about removal, a category or an identity SHALL be
refused as content that is not a roster store, and so SHALL one declaring the form this app writes
and saying nothing about removal, nothing about a category, or nothing about an identity for a
commitment. A commitment under no category SHALL be said to be under none
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

#### Scenario: a change kept over a roster in an earlier form keeps every day a commitment was kept until

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could be removed, whose two commitments are named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026 and stopped as of 31 January 2026, and
  "Journaling" on that same schedule, kept from that same day; a commitment named "Run" alike in
  every other way to "Journaling" is taken on through it; and a store is opened afterwards at the
  same place
- **THEN** the later store's roster answers about 31 January 2026 with "Gym", then "Journaling",
  then "Run"
- **AND** asked about 1 February 2026 it answers with "Journaling" and then "Run"

#### Scenario: a roster store declaring a later form whose body this app cannot read is refused as a later form

- **WHEN** a roster store is opened at a place holding content that declares a form one later than
  the form this app writes and whose commitments are not a list at all
- **THEN** opening is refused with an error
- **AND** the error says the content is from a later form rather than that it is not a roster store
- **AND** the content at that place is byte-for-byte what it was before
#### Scenario: a roster store declaring a form written before identities and saying something about one is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form used before a
  commitment had an identity and yet says an identity for its one commitment
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring the form this app writes and saying nothing about an identity is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form this app
  writes and yet says nothing at all about an identity for its one commitment
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

### Requirement: A commitments screen says what a commitment it is asked to change is made of

A commitments screen SHALL say, for a commitment on either of its lists, the things a change is asked
with: the name it has, the rhythm it runs on, the day it is kept from, the category it is under and
the range or the target its kind carries. For a commitment on neither list it SHALL say nothing at
all. The day it is kept from SHALL be that commitment's earliest era's, and the rhythm and the range or
the target SHALL be its newest era's; the screen SHALL say nothing at all about when the newest era
began. The rhythm SHALL be the one of the four that names that era's schedule, carrying the number
that schedule carries; an interval rhythm carries no start date, so an interval schedule's own start
date SHALL NOT be part of what is said.

It SHALL say whether anything beyond the name and the category can be changed at all: the rhythm, the
day it is kept from and the range or the target alike can be changed for a commitment its roster is
keeping, and none of them can for one it has stopped keeping. It SHALL say the kind that commitment's
days take, with the range or the target that kind carries — the number kind's range, or that it
carries none; the total kind's target; nothing beside a tick or a note. Which of the four kinds it is
SHALL be shown and SHALL never be asked about. A control for each of the things above SHALL be drawn,
and the ones that cannot be changed SHALL NOT let a thumb in.

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

#### Scenario: a commitments screen says a stopped commitment's range and target cannot be changed either

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10, one named "Protein"
  of the total kind with a target of 120, and one named "Weight" of the number kind with a range of
  40 to 150, all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on
  at a roster place; "Mood" and "Protein" are stopped there as of Sunday 30 August 2026; and a
  commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it says "Mood" is made of says its range cannot be changed, and what it says
  "Protein" is made of says its target cannot be changed
- **AND** what it says "Weight" is made of says its range can be changed

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

#### Scenario: a commitments screen says what a commitment it has stopped is made of

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and stopped there as of Sunday 30 August 2026; and a commitments
  screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it says "Creatine" is made of names "Creatine", a weekday-set rhythm of all seven
  weekdays, 1 January 2026 as the day it is kept from, and the category "Supplements"
- **AND** it says that "Creatine"'s rhythm and the day it is kept from cannot be changed
#### Scenario: a commitments screen says a commitment's earliest era's day kept from and its newest era's rhythm

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category
- **THEN** what it says "Gym" is made of says the day kept from 1 January 2026
- **AND** it says a weekday-set rhythm of Tuesday and Thursday
- **AND** it says nothing naming Monday 31 August 2026, the day the newest era began

### Requirement: A commitments screen takes a commitment it has stopped up again in one tap

A commitments screen SHALL take a commitment it has stopped up again, without asking for confirmation
and without asking for a name, a rhythm or a day. It SHALL keep that at the roster place before either
list says so; the commitment SHALL then be in what the screen keeps, in the place it has, and not in
what it has stopped. A commitments screen asked to take up again a commitment its roster has not stopped SHALL do
nothing and SHALL say nothing. One whose name a commitment its roster keeps already has SHALL be
refused as a name already in use, said against that stopped commitment rather than on the sheet, and
both lists SHALL be left as they were. One it could not keep at the roster place SHALL be refused as
a roster that could not be written, leaving both lists as they were.

#### Scenario: a commitment taken up again through a commitments screen moves from what it has stopped to what it keeps

- **WHEN** a commitment named "Journaling" and then one named "Gym", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there
  as of Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is taken up again through it
- **THEN** what it keeps is two entries, named "Journaling" and then "Gym"
- **AND** what it has stopped is nothing
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had
  not stopped keeping on Tuesday 1 September 2026

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

#### Scenario: a take-up-again a commitments screen could not keep leaves both its lists as they were

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as
  of Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday 31
  August 2026; what is at that place is then made impossible to write; and "Gym" is taken up again
  through the screen
- **THEN** it is refused as a roster that could not be written
- **AND** what it keeps is one entry, named "Journaling", and what it has stopped is one entry,
  named "Gym"
#### Scenario: taking a commitment up again is refused where a commitment the screen keeps already has its name

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; "Gym" is stopped there as of Sunday 30 August 2026; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "GYM" on that same rhythm, kept from that same day, is defined through it; and the stopped
  commitment is taken up again through it
- **THEN** it is refused as a name already in use, naming "GYM", said against the stopped commitment
- **AND** what it keeps is one entry, named "GYM", and what it has stopped is one, named "Gym"
- **AND** the content at that roster place is byte-for-byte what it was after "GYM" was defined

### Requirement: Reading the places carries an orphaned record back to its one possible source

Once no save in progress stands, any fold is done and both places can be read, a day screen and a
commitments screen SHALL find every commitment the record place holds records of whose identity the
roster place holds in no era of any commitment. An era the roster holds, of a commitment in any
state, SHALL be a possible source of one where it is of the same kind carrying the same range or
target, runs on the same rhythm with an interval's start date set aside, and is due on every day
those records are on; carrying back SHALL give those records that era's identity. Where exactly one commitment is a
possible source, it holds no record on any of those days, and no other such commitment has it as its
one possible source, every one of those records SHALL be carried back to it and kept at the record
place, and nothing SHALL be said. Otherwise none of them SHALL move.

#### Scenario: an orphaned record with one possible source is carried back to it when a commitments screen is opened

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays and one named "Run" on a
  schedule listing Tuesday and Thursday, both kept from 1 January 2026, are taken on at a roster
  place; a tick on Monday 3 August 2026 for a commitment named "Gym 🏋️" alike to "Gym" in every other
  way is kept at a record place; and a commitments screen is opened at those places as of Monday
  31 August 2026
- **THEN** a store opened afterwards at that record place answers that "Gym" was kept on Monday
  3 August 2026 and that "Gym 🏋️" was not
- **AND** the screen does not say that records belong to no commitment

#### Scenario: an orphaned record is carried back to a removed commitment beside the records it already holds when a day screen is opened

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place and removed there as of Sunday 30 August 2026; a tick for it on
  Monday 3 August 2026, and one on Tuesday 4 August 2026 for a commitment named "Gym 🏋️" alike in
  every other way, are kept at a record place; and a day screen of no commitments is opened at those
  places as of Monday 31 August 2026
- **THEN** a store opened afterwards at that record place answers that "Gym" was kept on Monday
  3 August 2026 and on Tuesday 4 August 2026
- **AND** it answers that "Gym 🏋️" was kept on neither day

#### Scenario: an orphaned record with two possible sources stays where it is and is said

- **WHEN** a commitment named "Creatine" and one named "Magnesium", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a tick on Monday
  3 August 2026 for a commitment named "Creatin" alike to both in every other way is kept at a record
  place; the content at that record place is read; and a commitments screen is opened at those places
  as of Monday 31 August 2026
- **THEN** the screen says that records belong to no commitment
- **AND** the content at that record place is byte-for-byte what was read

#### Scenario: an orphaned record with no possible source stays where it is and is said

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick on Tuesday 4 August 2026 for a commitment
  named "Gym 🏋️" on a schedule listing Tuesday and Thursday, kept from that same day, is kept at a
  record place; the content at that record place is read; and a commitments screen is opened at those
  places as of Monday 31 August 2026
- **THEN** the screen says that records belong to no commitment
- **AND** the content at that record place is byte-for-byte what was read

#### Scenario: an orphaned record that would land on a day its source already holds moves none of its records

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 3 August 2026, and ticks on Monday
  3 August 2026 and Tuesday 4 August 2026 for a commitment named "Gym 🏋️" alike in every other way,
  are kept at a record place; the content at that record place is read; and a commitments screen is
  opened at those places as of Monday 31 August 2026
- **THEN** the screen says that records belong to no commitment
- **AND** the content at that record place is byte-for-byte what was read

#### Scenario: two orphaned commitments with the same one possible source both stay where they are

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick on Monday 3 August 2026 for a commitment named
  "Gym 🏋️" and one on Tuesday 4 August 2026 for a commitment named "Gym 2", both alike to "Gym" in
  every other way, are kept at a record place; the content at that record place is read; and a
  commitments screen is opened at those places as of Monday 31 August 2026
- **THEN** the screen says that records belong to no commitment
- **AND** the content at that record place is byte-for-byte what was read
#### Scenario: a record of an era a roster holds is not an orphan

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record
  place; a commitments screen is opened at those places as of Monday 31 August 2026; "Gym" is
  changed through it to a weekday-set rhythm of Tuesday and Thursday and then to the name "Lifting";
  and the screen is shown again as of Monday 31 August 2026
- **THEN** the screen does not say that records belong to no commitment
- **AND** a look-back at "Lifting" counts Monday 3 August 2026 kept

### Requirement: A commitment's kind is exactly one of a tick, a number, a note or a total

A commitment's kind SHALL be exactly one of four: a tick, a number, a note or a total. There SHALL
be no fifth and no way to hold none.

A tick and a note SHALL carry nothing, a number MAY carry a range, and a total MUST carry a target.
A range SHALL belong to the number kind and a target to the total kind, and the system MUST NOT
offer any way of attaching either to a kind it does not belong to: a commitment of a kind with no
room for one SHALL be one that cannot be formed at all, rather than one refused when it is tried.

A commitment SHALL read its kind back, along with whatever that kind carries. A commitment formed
without a kind named SHALL be of the plain kind, a tick, and naming the tick explicitly SHALL name
that same kind. The kind SHALL NOT enter into whether a commitment is due.

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
- **AND** one formed alike in every way with the tick kind named reads back that same kind

#### Scenario: a commitment's kind does not change whether it is due

- **WHEN** two commitments named "Gym" are formed on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, one of the tick kind and one of the number kind carrying a
  range of 40 to 150
- **THEN** both are due on Monday 31 August 2026
- **AND** neither is due on Tuesday 1 September 2026

### Requirement: A commitments screen lists the commitments its roster keeps, in the order the roster answers with

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
days take, the day it is kept from, or its category. Where a fold has left two commitments alike in
name, both SHALL be listed and neither SHALL be renamed or dropped: two unlike in rhythm SHALL be two
entries told apart by the rhythm each says, and two alike in rhythm SHALL be two entries that say the
same thing. Where two are alike in name, the commitment removed SHALL be the one the removal was
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

#### Scenario: two commitments alike in name and not in rhythm are told apart by the rhythm their entries say

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a
  roster written in the form used before a commitment had an identity, whose entries are "Vitamins"
  on a schedule listing Monday and Wednesday and "Vitamins" on a schedule listing Tuesday and
  Thursday, both kept from 1 January 2026 and both kept
- **THEN** what it keeps is two entries, both named "Vitamins", the first saying "Mon, Wed" and the
  second saying "Tue, Thu"
- **AND** stopping the first of them leaves what it keeps as one entry named "Vitamins", saying
  "Tue, Thu"

#### Scenario: two commitments alike in name and in rhythm are two entries that say the same thing

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a
  roster written in the form used before a commitment had an identity, whose entries are "Vitamins"
  on a schedule listing Monday and Wednesday, kept from 1 January 2026, and "Vitamins" on that same
  schedule, kept from 1 June 2026, both kept
- **THEN** what it keeps is two entries, both named "Vitamins" and both saying "Mon, Wed"
- **AND** the two are different commitments, each listed once

#### Scenario: a commitments screen opened on a roster that holds nothing lists nothing and takes nothing on

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept
- **THEN** what it keeps is nothing and what it has stopped is nothing
- **AND** it says it is keeping a roster
- **AND** nothing is kept at that roster place
- **AND** what it keeps is no groups at all

#### Scenario: removing one of two entries alike in name removes the one it was asked about

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a
  roster written in the form used before a commitment had an identity, whose entries are "Vitamins"
  on a schedule listing Monday and Wednesday and "Vitamins" on a schedule listing Tuesday and
  Thursday, both kept from 1 January 2026 and both kept; it is asked to remove the second of them;
  "Vitamins" is typed back; and the removal is confirmed
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

#### Scenario: a commitments screen does not list a commitment its roster has stopped keeping as of a day after the one the screen was handed

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as
  of Tuesday 1 September 2026; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** what it keeps is one entry, named "Journaling"
- **AND** what it has stopped is one entry, named "Gym"

### Requirement: A commitments screen holds the change it refused and why it was refused, one at a time

Where a change asked of a commitments screen is refused, the screen SHALL hold which change was
asked for and why it was refused, as well as answering the refusal to the caller. The change held
SHALL be one of the ten a person can ask for — defining a commitment, stopping keeping one, taking
a stopped one up again, removing one, moving one, moving a whole group, changing one, restarting
one, making a copy, restoring a copy — and for the six asked about a commitment already on one of
its lists it SHALL name that commitment: the one it was asked about, not the one the change would
have produced. A refused group move SHALL name the category instead, a refused copy SHALL name the
store that could not be read, or no store at all where the copy could not be written, and a refused
restore SHALL name neither a commitment nor a store. The ten are counted here
and numbered nowhere else: a requirement that introduces one SHALL name it, and SHALL NOT identify
it by its position among them.

Why it was refused SHALL be the same refusal answered to the caller and no more, and a commitments
screen SHALL hold no words a person reads. It SHALL hold at most one refused change at a time, the
change asked for last. A call asking for no change at all SHALL NOT be a refusal, and each SHALL
leave the screen holding no refused change and leave whatever it holds exactly as it was: a stop
asked about a commitment it does not keep; a stop confirmed with nothing awaiting confirmation; a
take-up-again of one it has not stopped; a removal asked about a commitment on neither list; a
removal confirmed with nothing awaiting removal; a removal confirmed while the name typed back does
not match; a move of one it does not keep; a move into a group it draws none of, or to an offset
that group does not have; a group move of a group it draws none of, those under no category among
them, or to an offset its category groups do not have; a change asked about a commitment on neither
list; a change that names what a commitment already is; and a restore confirmed with none awaiting
confirmation. A name typed back that does not match is
not a refusal.

#### Scenario: a commitments screen holds a refused definition against defining a commitment

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it
- **THEN** it is refused as a name that says nothing
- **AND** the screen holds that refusal, against defining a commitment

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
- **THEN** it is refused as a name already in use
- **AND** the screen holds that refusal, against changing "Gym"

#### Scenario: a commitments screen holds nothing against a change that asks for no change at all

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is removed there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", under no category
- **THEN** the screen holds no refused change
- **AND** a change of "Journaling" to exactly the name, rhythm, day kept from and category it already
  has leaves the screen holding no refused change either

#### Scenario: what a commitments screen holds about a refused change stands when a stop is asked about a commitment it does not keep

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to stop keeping "Journaling"
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a removal is asked about a commitment on neither of its lists

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to remove a commitment named "Run" alike in every other way to "Gym" and never taken on
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a removal is confirmed with nothing awaiting removal

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to confirm a removal with nothing awaiting removal
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a move is asked about a commitment it does not keep

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to move "Journaling" to the offset 0
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a commitment is dropped in a group it draws none of

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to move "Gym" to the offset 0 in the group "Evening"
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a commitment is dropped at an offset its group does not have

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to move "Gym" to the offset 2 in the group "Sport"
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a group it draws none of is moved

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to move the group under no category to the offset 0, and then the group "Evening" to the
  offset 0
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a group is moved to an offset its groups do not have

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to move the group "Sport" to the offset 2
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a change is asked about a commitment on neither of its lists

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to change a commitment named "Run" alike in every other way to "Gym" and never taken on to
  the name "Running", under no category
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: a commitments screen holds a refused copy against making a copy, naming the store that could not be read

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster
  place, a record place and a one-off place where nothing has been kept as of Monday 31 August 2026;
  what is at that record place is then made a run of bytes that is not a record; and a copy is asked
  for as of that day at 14:32
- **THEN** it is refused as a store that could not be read
- **AND** the screen holds that refusal, against making a copy, naming the record
- **AND** a copy asked for at a readable record place but written into a directory that cannot be
  written to is held against making a copy naming no store, as a place that could not be written

#### Scenario: a commitments screen holds a refused restore against restoring a copy, naming no store

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster
  place, a record place and a one-off place where nothing has been kept as of Monday 31 August 2026;
  and it is asked to restore from a file holding a run of bytes that is not a copy
- **THEN** the screen holds that refusal, as not a copy, against restoring a copy and naming no store
- **AND** a restore of a copy confirmed where the one-off place cannot be written is held against
  restoring a copy, naming no store, as a place that could not be written

#### Scenario: what a commitments screen holds about a refused change stands when a restore is confirmed with none awaiting confirmation

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept; a commitment named "   " on a weekday-set
  rhythm of all seven weekdays, kept from that same day, is defined through it and refused; and a
  restore is then confirmed through it with none awaiting confirmation
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment, and holds
  no copy restored
- **AND** nothing is written at any of the three places

### Requirement: What a commitments screen tells on its sheet lasts until that field is edited, the next ask, the sheet closing or the app being shown again

What a commitments screen holds about a refusal on its sheet SHALL stand until the field it is about
is edited, until the next commitment is defined, changed or restarted through the screen, until the
sheet is closed, or until the app is shown again, and SHALL then be held no longer; nothing else
SHALL end it. A field being edited SHALL end only what is about that field, and what is about the
whole change SHALL be ended by no edit at all. An ask that is kept SHALL end it, an ask that is
refused SHALL replace it, and a call asking for no change at all SHALL leave it exactly as it was.
It SHALL be held beside what the screen holds about a refused change, which SHALL go on lasting as
long as its own requirement says.

#### Scenario: what a commitments screen tells on its sheet ends when the field it is about is edited

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and its sheet's name field is told
  edited
- **THEN** the screen tells nothing on its sheet
- **AND** it still holds a name that says nothing, against defining a commitment

#### Scenario: what a commitments screen tells on its sheet stands when another field is edited

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and its sheet's rhythm field, its
  day-kept-from field, its range field, its target field and its restart day field are each told
  edited
- **THEN** it still tells a name that says nothing, about the name field of its sheet

#### Scenario: what a commitments screen tells at the foot of its sheet stands when a field is edited

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; what is at that place is then made impossible to write; a commitment named
  "Journaling" on that same rhythm and kept-from day is defined through it and refused; and its
  sheet's name field is told edited
- **THEN** it still tells a place that could not be written, about the whole change and about no
  field of its sheet

#### Scenario: what a commitments screen tells on its sheet ends when the sheet is closed

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and its sheet is told closed
- **THEN** the screen tells nothing on its sheet
- **AND** a screen whose sheet is told closed after a second commitment named "Gym" was defined
  through it and refused tells nothing on its sheet either

#### Scenario: a refused restart replaces what a refused save told on a commitments screen's sheet

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday
  31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven weekdays, kept from
  that same day, is defined through it and refused; and "Nails" is then restarted through it from
  Monday 3 August 2026 and refused
- **THEN** it tells a day before the day it is kept from, about the restart day field of its sheet
- **AND** a screen asked for the two the other way about tells a name that says nothing, about the
  name field of its sheet

#### Scenario: what a commitments screen tells on its sheet ends when an ask is kept

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and a commitment named "Journaling"
  on that same rhythm and kept-from day is then defined through it
- **THEN** "Journaling" is not refused
- **AND** the screen tells nothing on its sheet

#### Scenario: what a commitments screen tells on its sheet ends when the app is shown again

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and the app is then shown again as of
  that same day
- **THEN** the screen tells nothing on its sheet

#### Scenario: what a commitments screen tells on its sheet stands when a call asks for no change at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and "Gym" is then changed through it
  to exactly the name, rhythm, day kept from and category it already has
- **THEN** that call refuses nothing
- **AND** the screen still tells a name that says nothing, about the name field of its sheet

### Requirement: A roster store that cannot be read is refused rather than emptied

Opening a roster store at a place holding something this app cannot read as a roster store SHALL be
refused with an error. The store MUST NOT answer with a roster holding nothing in its place, MUST
NOT overwrite, move or delete what is there, and MUST NOT keep the part of it that could be read.

This app cannot read, as a roster store: content that is not a roster store; a roster store written
in a form later than the one this app knows; and a roster store holding something that could not be
a roster — a commitment that could not be formed, a date that names no day, the same era held
twice, or a commitment held as removed with no day it was kept until. Two entries SHALL be the same
era where they carry one identity and are kept from one day, and, in a roster kept before a
commitment had an identity, where the commitments they hold are alike in every part; entries
carrying one identity and kept from different days SHALL be read as the eras of one commitment. A commitment of the number
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
- **AND** a roster store at a place holding the same era twice — two entries alike in identity, in
  name, in schedule and in the day it is kept from — is refused the same way
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

#### Scenario: a roster store holding a commitment again after holding it stopped or removed is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose two commitments are the same commitment — named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026 — the first held stopped as of 31 January 2026
  and the second held kept
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** a roster store at a place holding the same two, the first held removed as of 31 January
  2026, is refused the same way
- **AND** the content at each of the two places is byte-for-byte what it was before

#### Scenario: a roster store holding a day kept until that names no day is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Gym" on a schedule listing Monday, Wednesday and Saturday and kept
  from 1 January 2026, is held stopped as of 30 February 2026
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store holding a commitment whose range has its lowest above its highest is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Gym" and kept from 1 January 2026, on a schedule listing Monday,
  Wednesday and Saturday, is of the number kind with a lowest of 10 and a highest of 1
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store holding a commitment whose target is not above zero is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Gym" and kept from 1 January 2026, on a schedule listing Monday,
  Wednesday and Saturday, is of the total kind with a target of 0
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store holding a commitment on a day of the month outside the thirty-one is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Gym" and kept from 1 January 2026, is on a schedule on the 32nd of
  the month
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store holding an every-N-days schedule whose start date names no day is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Gym" and kept from 1 January 2026, is on a schedule of every 3 days
  starting on 30 February 2026
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

## REMOVED Requirements

### Requirement: A commitment is a name, a schedule, and the day it is kept from

**Reason:** a commitment now carries an identity as well, and sameness is that identity rather than
the four parts. Replaced in full by *A commitment is an identity, a name, a schedule, the day it is
kept from and the kind its days take*, which keeps six of this requirement's seven scenarios
verbatim.

**Migration:** the one scenario that goes is *two commitments alike in name, schedule and kept-from
day are the same commitment*, whose answer reverses; its test is renamed to *two commitments formed
alike in every part are two different commitments* and reversed with it.

### Requirement: A roster refuses a commitment it already holds

**Reason:** under an identity, value equality decides nothing, and what a person must not have twice
is a name rather than a value. Replaced in full by *A roster refuses a commitment whose name one it
keeps or has stopped already has*.

**Migration:** the scenarios asserting that two commitments alike in name but differing in schedule,
in the day kept from or in blank space at a name's end are both held go with it, along with their
tests; each is answered the other way by a scenario under the requirement replacing this one.

### Requirement: A roster supersedes a commitment it is keeping with another, from a day

**Reason:** a rhythm, a range or a target changing no longer takes a second commitment on beside a
removed one; it puts a new era on the commitment. Replaced in full by *A roster puts a new era on a
commitment it is keeping, from a day*.

**Migration:** every scenario under it is answered by one under the replacing requirement, and the
tests carrying these titles are renamed as those titles are taken.

### Requirement: A roster changes a commitment it holds for another, in the place it holds it

**Reason:** what a change replaces in place is an era of a commitment, and a name is no longer part
of it — renaming reaches every era and has its own act. Replaced in full by *A roster changes an era
of a commitment it holds for another of that commitment*.

**Migration:** the scenarios that changed a commitment's name through this act go with it; a rename
is asserted under *A roster renames a commitment through every era of it* instead.

### Requirement: A commitments screen tells a commitment it already keeps apart from a roster it could not write

**Reason:** the refusal it names is gone: a screen refuses a name rather than a value, says which
commitment the name belongs to, and no longer takes a stopped commitment up again by having it
defined afresh. Replaced in full by *A commitments screen tells a name already in use apart from a
roster it could not write*.

**Migration:** *defining a commitment a commitments screen has stopped keeping takes it up again in
the place it was taken on in* reverses and goes; taking one up again is the one-tap act on its
stopped row, which *A commitments screen takes a commitment it has stopped up again in one tap*
already covers.

### Requirement: A commitments screen works out which act a change on either of its lists needs

**Reason:** the two acts it chose between were a carry-over-then-change and a supersession, and
neither survives an identity: no change moves a record, and a rhythm, a range or a target puts an era
on the one commitment. Replaced in full by *A commitments screen changes a commitment by renaming
it, moving the day it is kept from, or putting a new era on it*.

**Migration:** the scenarios naming a carry-over or a superseded commitment are answered under the
replacing requirement by scenarios asserting the record place untouched and one commitment with two
eras; tests are renamed as those titles are taken.

### Requirement: A commitments screen refuses a change that would carry records onto records already kept

**Reason:** the refusal has nothing left to guard. It existed because a change produced a second
commitment that the record place might already hold records of; under an identity a change produces
no second commitment and moves no record, so the collision it refuses cannot arise.

**Migration:** none on disk. The scenarios under it and the tests carrying their titles go with it,
and so does the cause itself, which *A commitments screen says which field of its sheet a refusal it
answers is about* no longer has a field to name.

### Requirement: A roster holds the commitments a person keeps, in the order they were taken on

**Reason:** a roster's order now runs over every era of every commitment, and the ban on an identifier it
carried is the rule this change reverses. Replaced in full by *A roster holds the commitments a
person keeps and every era of each, in the order they were taken on*.

**Migration:** the scenario *a commitment taken on to supersede another lands in that one's place rather than
after every commitment already there* goes with it; the replacing requirement answers it as *a new
era put on a commitment lands in that commitment's place rather than after every commitment already
there*, and its test is renamed with it.

### Requirement: A commitments screen says which field of its sheet a refusal it answers is about

**Reason:** two of the refusals it routed no longer exist — a commitment already kept and records already kept
under what a change would produce — and the name already in use that replaces the first is about the
name field rather than the whole change. Replaced in full by *A commitments screen says which field
of its sheet a refusal it answers is about, or that it is about no field*.

**Migration:** four scenarios go with it, each naming a refusal this change withdraws; the replacing requirement
carries *a refusal that a name is already in use is about the name field* and *a restart refused for
a day already recorded on is about the restart day field* in their places, and the tests are renamed
as those titles are taken.

### Requirement: A change leaves an interval commitment's start date where it was unless it names a different day kept from

**Reason:** a change no longer carries records over before it supersedes, and what keeps its start date is an
era rather than a second commitment. Replaced in full by *A change leaves an interval era's start
date where it was unless it names a different day kept from*.

**Migration:** one scenario is renamed, from *... and the superseded one keeps its start* to *... and the era it
gives way to keeps its start*, and its test with it; the assertion about a record being carried over
becomes an assertion that the record place was not written.

### Requirement: A commitments screen refuses a change it cannot make

**Reason:** the refusal against a commitment the roster already holds becomes one against a name already in
use, and the record place is no longer a place a change writes, so three refusals it told apart have
nothing left to guard. Replaced in full by *A commitments screen refuses a change it cannot make,
and tells each refusal apart*.

**Migration:** seven scenarios go with it: three asserting a carry-over at the record place, two asserting a
value collision a name refusal now answers, and two whose titles are taken by the name refusal's own
scenarios under the replacing requirement. Their tests are renamed or deleted with them.

### Requirement: A roster store keeps a roster at a place, across the app being closed and opened again

**Reason:** what a store keeps is now an era per entry, with the identity that ties a commitment's eras
together, and superseding is no longer one of the changes it keeps. Replaced in full by *A roster
store keeps a roster and every era at a place, across the app being closed and opened again*.

**Migration:** two scenarios naming a supersession go with it; the replacing requirement answers both, with *a
commitment with two eras kept through a roster store is read back as one commitment with two eras*
and *an era a roster store refuses to put on a removed commitment is reported and nothing at its
place changes*.

### Requirement: A commitments screen defines a commitment from a name, a rhythm and the day it is kept from

**Reason:** defining a commitment no longer finds one the roster holds stopped or removed: what is defined
carries an identity of its own, and a stopped commitment's name is refused rather than reused.
Replaced in full by *A commitments screen defines a new commitment from a name, a rhythm and the day
it is kept from*.

**Migration:** three scenarios asserting that defining the same three things takes a stopped or removed
commitment up again go with it. Taking one up again is the one-tap act on its stopped row; the name
refusal is asserted under *A commitments screen tells a name already in use apart from a roster it
could not write*, and the removed case under the replacing requirement.

### Requirement: A commitments screen restarts an interval commitment it keeps, from a day it is given

**Reason:** a restart puts a new era on the commitment rather than superseding it, and moves no record.
Replaced in full by *A commitments screen restarts an interval commitment it keeps by putting a new
era on it*.

**Migration:** the scenario asserting that a restart carries every record on or after the day it restarts from
goes with it, answered by *restarting an interval commitment moves no record and writes nothing at
the record place*.

### Requirement: A commitments screen refuses a restart it cannot make

**Reason:** two of the four refusals it told apart — a commitment already kept and records already kept — have
nothing left to guard once a restart produces no second commitment. Replaced in full by *A
commitments screen refuses a restart it cannot make, and tells each refusal apart*.

**Migration:** four scenarios go with it, and *a restart is refused for no name and for no record already kept*
asserts the reverse of two of them under the replacing requirement.
