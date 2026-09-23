## ADDED Requirements

### Requirement: A roster takes a commitment it has stopped up again from a day, as a new era

A roster SHALL take a commitment it has stopped up again from a day, the day of the resume,
reporting that it keeps it. It SHALL put a new era in front of the stopped one, on its schedule, kind, range and target, kept from the day of the resume or the stopped era's day kept from
where that is later, an interval's count beginning there; the stopped era SHALL keep its day kept
until, and the eras SHALL then be held mended. Where the new era would begin no later than the day
after that day kept until, it SHALL instead drop that day, putting no era on. The commitment
SHALL keep its place and category.

The roster SHALL refuse, report and change nothing for a commitment it does not hold, keeps or has
deleted, or whose name one it keeps has, refusing on no date.

#### Scenario: a commitment taken up again days after it was stopped begins a new era on the day of the resume

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, stops keeping it as of 31 January 2026 and is then asked to
  take it up again from 1 March 2026
- **THEN** the roster reports that it now keeps the commitment
- **AND** it reads back one commitment it keeps, with two eras, both on Monday, Wednesday and
  Saturday, the newer kept from 1 March 2026 and the older kept until 31 January 2026
- **AND** asked about 15 February 2026 it answers with the newer era alone, and about 31 January
  2026 with both
- **AND** a commitment named "Mood" of the number kind with a range of 1 to 10, stopped and taken up
  again alike, reads back a newer era ranging 1 to 10

#### Scenario: a commitment taken up again from the day after it was stopped is one era, as though it had never been stopped

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, stops keeping it as of 31 January 2026 and is then asked to
  take it up again from 1 February 2026
- **THEN** the roster reports that it now keeps the commitment
- **AND** it is the same roster as one given that commitment once and never asked to stop keeping it
- **AND** so is a roster alike asked to take it up again from 31 January 2026, and one asked to take
  it up again from 15 January 2026

#### Scenario: an interval commitment taken up again begins its count on the day of the resume

- **WHEN** a roster holding a commitment named "Nails" on a schedule of every 4 days starting on
  1 January 2026, kept from that day, stops keeping it as of 31 January 2026 and is then asked to
  take it up again from 16 February 2026
- **THEN** the commitment it reads back as kept is due on 16 February 2026 and on 20 February 2026
- **AND** it is not due on 18 February 2026, a day its count from 1 January 2026 fell on

#### Scenario: a commitment whose only era holds no day, taken up again, is kept from the day of the resume

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 March 2026, stops keeping it as of 28 February 2026 and is then asked to
  take it up again from 16 March 2026
- **THEN** the roster reports that it now keeps the commitment
- **AND** it reads back one era of it, kept from 16 March 2026
- **AND** a roster alike whose "Gym" is kept from 1 April 2026, stopped as of 28 February 2026 and
  taken up again from 16 March 2026, reads back one era of it, kept from 1 April 2026

#### Scenario: a commitment taken up again from a day keeps its place and its category

- **WHEN** a roster given a commitment named "Water plants", then one named "Gym" under the category
  "Sport", then one named "Journaling", all on a schedule listing Monday, Wednesday and Saturday and
  all kept from 1 January 2026, stops keeping "Gym" as of 31 January 2026 and is then asked to take
  it up again from 1 March 2026
- **THEN** it reads back three commitments it keeps, in the order "Water plants", "Gym",
  "Journaling"
- **AND** it reads back "Gym" in the group "Sport"

#### Scenario: taking up again from a day a commitment a roster keeps, does not hold or has deleted is refused

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to take it up again from 1 March 2026
- **THEN** the roster reports that it did not take the commitment up again
- **AND** the roster is the same roster as one that was never asked
- **AND** a roster that had deleted "Gym" refuses it too, and so does one that never held it

#### Scenario: taking up again from a day is refused where a commitment the roster keeps already has its name

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment had an identity, whose entries are "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026 and kept, and "Gym" on a schedule listing Tuesday and
  Thursday, kept from 1 January 2026 and stopped as of 31 January 2026; and the roster it reads
  back is asked to take that stopped commitment up again from 1 March 2026
- **THEN** the roster reports that it did not take the commitment up again
- **AND** the roster reads back one commitment it keeps, named "Gym", on a schedule listing Monday,
  Wednesday and Saturday, and one it has stopped, named "Gym", on a schedule listing Tuesday and
  Thursday

## MODIFIED Requirements

### Requirement: A commitments screen takes a commitment it has stopped up again in one tap

A commitments screen SHALL take a commitment it has stopped up again from the day the screen was
handed, as *A roster takes a commitment it has stopped up again from a day, as a new era* says,
without asking for confirmation and without asking for a name, a rhythm or a day. It SHALL keep that at the roster place before either
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

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a
  roster written in the form used before a commitment had an identity, whose entries are "Gym" on a
  schedule listing Monday and Wednesday, kept from 1 January 2026 and kept, and "Gym" on a schedule
  listing Tuesday and Thursday, kept from 1 January 2026 and stopped as of Sunday 30 August 2026;
  and the stopped commitment is taken up again through it
- **THEN** it is refused as a name already in use, naming "Gym", said against the stopped commitment
- **AND** what it keeps is one entry, named "Gym", saying "Mon, Wed", and what it has stopped is
  one, named "Gym", saying "Tue, Thu"
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a commitment taken up again through a commitments screen days after its stop begins a new era on the day the screen was handed

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; "Gym" is stopped there as of Sunday 23 August 2026;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is
  taken up again through it
- **THEN** a roster store opened afterwards at that place reads back two eras of "Gym", the newer
  kept from Monday 31 August 2026 and the older kept until Sunday 23 August 2026
- **AND** the era it answers with on Sunday 30 August 2026 is not due that day

#### Scenario: a commitment stopped and taken up again on one day through a commitments screen is one era, as though it had never been stopped

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; and it is asked to
  stop keeping "Gym", the stop is confirmed, and "Gym" is then taken up again through it
- **THEN** what it keeps is one entry, named "Gym", and what it has stopped is nothing
- **AND** a roster store opened afterwards at that place reads back one era of "Gym", kept from
  1 January 2026, and answers with it on Monday 31 August 2026
- **AND** a commitment alike whose record place holds a tick for it on Monday 31 August 2026,
  stopped through a screen opened as of that day and taken up again through one opened as of
  Tuesday 1 September 2026, reads back one era too

#### Scenario: an interval commitment taken up again through a commitments screen begins its count on the day the screen was handed

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Tuesday 4 August
  2026, kept from that day, is taken on at a roster place; "Nails" is stopped there as of Sunday
  23 August 2026; a commitments screen is opened at that roster place as of Monday 31 August 2026;
  and "Nails" is taken up again through it
- **THEN** a roster store opened afterwards at that place answers on Monday 31 August 2026 with an
  era of "Nails" due that day and on Friday 4 September 2026
- **AND** that era is not due on Tuesday 1 September 2026, a day its count from 4 August 2026 fell on

#### Scenario: a commitment defined and stopped on one day and taken up again on a later day is kept from that later day

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place and a record
  place where nothing has been kept; a commitment named "Gym" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and stopped through it; and a commitments
  screen opened at those places as of Monday 7 September 2026 takes "Gym" up again
- **THEN** what the second screen keeps is one entry, named "Gym"
- **AND** a roster store opened afterwards at that place reads back one era of "Gym", kept from
  Monday 7 September 2026

### Requirement: A roster holds a commitment's eras as the entries that carry its identity

A roster SHALL hold each era of a commitment as an entry of its own, and every entry carrying one
identity SHALL be an era of one commitment. The eras of a commitment SHALL stand together in the
roster's order, the newest first and each earlier era immediately behind the one it gave way to.
Every era of one commitment SHALL carry that commitment's name and the sort of its kind, and a
roster MUST NOT hold two eras of one commitment differing in either.

Each era but the newest SHALL carry the day it was kept until, and that day SHALL be the day before
the next era's day kept from or, where the commitment was stopped and taken up again, an earlier
day, the days between being a gap no era holds. Kept and stopped SHALL be states of the commitment rather than of an
era: the newest era SHALL carry the state, and an earlier era SHALL be read back neither
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

### Requirement: A roster stops keeping a commitment it keeps, on the day it was kept until

A roster SHALL stop keeping a commitment it holds, on being given that commitment and the calendar
date it was kept until, which is the last day it was kept. Stopping SHALL take the commitment out of the commitments the roster reads back, SHALL record that
day against its newest era and then hold its eras mended, and SHALL report that the roster stopped
keeping it, leaving everything else exactly as it was, in the order it was in. A newest era that day
leaves holding no day SHALL be dropped where an older era stands, and the era behind it SHALL be the
one stopped, as *A roster store reads each commitment's eras mended* says; every other earlier era
SHALL be left exactly as it is.

The roster SHALL refuse to stop keeping a commitment in exactly two cases, and SHALL report each: one
it does not hold at all, a deleted one included; and one it has already stopped keeping, whose
kept-until day SHALL stand as first given. In both the roster SHALL be left exactly as it was, for as
long as the roster has stopped keeping that commitment. Taking a commitment up again SHALL be the only thing that ends a stop, as *A roster refuses a
commitment whose name one it keeps or has stopped already has* and *A roster takes a commitment it
has stopped up again from a day, as a new era* say, and a commitment taken up again SHALL be one the
roster can stop keeping again, on whatever day it was kept until the second time.

The roster SHALL refuse on no date: any calendar date the system supports SHALL be accepted as a day
a commitment was kept until, including the first, the last, and one earlier than the day that
commitment is kept from. The roster SHALL NOT ask what day it is, MUST NOT refuse a day for being in
the future, and MUST NOT accept one for being in the past.

Stopping SHALL change nothing recorded against the commitment: every era it leaves SHALL answer
whether it is due exactly as before, and every tick already recorded SHALL stand. Stopping SHALL leave every other roster untouched, and two rosters differing only in the day
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

#### Scenario: stopping a commitment as of a day before its newest era began stops the era behind it

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, with a newer era on a schedule listing Tuesday and Thursday,
  kept from 1 March 2026, put on as of 28 February 2026, is asked to stop keeping it as of
  28 February 2026
- **THEN** the roster reports that it stopped keeping the commitment
- **AND** it reads back one commitment it has stopped, saying "Mon, Wed, Sat", and one era of it
- **AND** it answers with that era on 28 February 2026 and with nothing on 1 March 2026

### Requirement: A commitments screen asks for confirmation before it stops keeping a commitment, and awaits one change at a time

A commitments screen SHALL be asked to stop keeping a commitment and SHALL change nothing until that
stop is confirmed. Until then it SHALL hold which commitment is awaiting confirmation, and being asked
about a second SHALL replace the first. A commitments screen SHALL have at most one change awaiting
confirmation of any kind, and being asked to stop SHALL leave nothing awaiting deletion; moving a
commitment awaits no confirmation and takes neither slot, and a move SHALL leave whatever is awaiting
confirmation exactly as it is. A cancelled stop SHALL leave both lists and the roster place exactly as
they were and leave nothing awaiting confirmation, and confirming SHALL do the same where nothing is
awaiting confirmation.

A confirmed stop SHALL stop keeping the commitment as of the day before the one the screen was handed,
that day being the last it was kept, or as of the day handed itself where the record the screen reads
holds a tick, a number, a note or an addition of that commitment on it, and SHALL keep that at the roster place before either list says
so; the commitment SHALL then be in what the screen has stopped and not in what it keeps, in the place
it has. Where the day the screen was handed has no day before it, the commitment SHALL be kept until
that day itself, and a commitment defined and stopped on the same day, that day holding no record of
it, SHALL become one kept on no day at all. A screen that cannot read its record SHALL stop as of the day before, and a record taken
back after a stop SHALL leave the day kept until where it was. A commitments screen SHALL offer no
date to pick. Asked to stop
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

#### Scenario: a commitment stopped through a commitments screen is kept until the day before the one the screen was handed

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

#### Scenario: asking a commitments screen to stop keeping a commitment leaves nothing awaiting deletion

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to delete "Gym"; and it is then asked to stop keeping
  "Gym"
- **THEN** nothing is awaiting deletion
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

#### Scenario: a stop confirmed with nothing awaiting confirmation changes nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; and a stop is confirmed with nothing awaiting confirmation
- **THEN** nothing is refused and nothing is awaiting confirmation
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: moving a commitment leaves a deletion awaiting confirmation and what has been typed back exactly as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, and one named "Journaling" alike in every other way are taken on at a roster place; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; it is asked to
  delete "Gym"; "Gy" is typed back; and "Journaling" is then moved to the offset 0
- **THEN** "Gym" is still awaiting deletion and "Gy" is still what has been typed back
- **AND** what it keeps is two entries, named "Journaling" and then "Gym"

#### Scenario: a commitment stopped through a commitments screen on a day holding a record of it is kept until that day

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for "Gym" on Monday 31 August 2026 is kept
  at a record place; a commitments screen is opened at those places as of that day; and it is asked
  to stop keeping "Gym" and the stop is confirmed
- **THEN** a roster store opened afterwards at that roster place answers with "Gym" when asked what
  it had not stopped keeping on Monday 31 August 2026, and with nothing on Tuesday 1 September 2026
- **AND** a commitment alike of the note kind holding a note on that day, one of the number kind
  holding a number, and one of the total kind with a target of 120 holding an addition of 30, are
  each kept until Monday 31 August 2026 too
- **AND** "Gym" stopped alike through a screen whose record place holds a run of bytes that is not a
  record is kept until Sunday 30 August 2026

#### Scenario: a record taken back on the day its commitment was stopped leaves the row and the day kept until as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for "Gym" on Monday 31 August 2026 is kept
  at a record place; a commitments screen opened at those places as of that day is asked to stop
  keeping "Gym" and the stop is confirmed; and a day screen of no commitments at all, opened at those
  places as of that day, takes back the tick its row offers
- **THEN** before the take-back the day screen's day view holds one row, named "Gym", saying it is
  kept
- **AND** afterwards it holds one row, named "Gym", saying it is not kept
- **AND** a roster store opened afterwards at that roster place answers with "Gym" on Monday
  31 August 2026 and with nothing on Tuesday 1 September 2026

#### Scenario: a commitment stopped through a commitments screen on the day its newest era began is stopped at the era before it

- **WHEN** a commitment named "Gym" on a schedule listing Tuesday and Thursday, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place and at a
  record place where nothing has been kept as of Monday 31 August 2026; "Gym" is changed through it
  to a weekday-set rhythm of Monday, on the name and the day kept from it already has, under no
  category; and it is asked to stop keeping "Gym" and the stop is confirmed
- **THEN** what it has stopped is one entry, named "Gym", saying "Tue, Thu"
- **AND** a roster store opened afterwards at that place reads back one era of "Gym", kept from
  1 January 2026, and answers with it on Sunday 30 August 2026 and with nothing on Monday 31 August
  2026

#### Scenario: a commitment stopped through a commitments screen on the day its newest era began keeps that era where the day holds a record of it

- **WHEN** a commitment named "Gym" on a schedule listing Tuesday and Thursday, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place and at a
  record place where nothing has been kept as of Monday 31 August 2026; "Gym" is changed through it
  to a weekday-set rhythm of Monday, on the name and the day kept from it already has, under no
  category; a tick for "Gym" on Monday 31 August 2026 is then kept at that record place and the
  screen is shown again as of that day; and it is asked to stop keeping "Gym" and the stop is
  confirmed
- **THEN** what it has stopped is one entry, named "Gym", saying "Mon"
- **AND** a roster store opened afterwards at that place reads back two eras of "Gym"
- **AND** it answers about Monday 31 August 2026 with the era on Monday alone, and about Tuesday
  1 September 2026 with nothing

### Requirement: A roster store reads each commitment's eras mended

A roster store SHALL read each commitment's eras mended, whatever form they were kept in, and SHALL
read a copy to be restored the same way. Newest first, each era but the newest SHALL hold only days
before the day the kept era in front of it is kept from, read as kept until the day before where it
carries a later day kept until or none. An era but the newest that then holds no day SHALL be
dropped. Two eras side by side alike in schedule and kind, range or target included, with no day
between the older's day kept until and the newer's day kept from, SHALL be read as one, kept from the
older's day and carrying the newer's day kept until, state and category; alike eras with a gap
between them SHALL be read as two. The newest era SHALL NOT be dropped for holding no day, except
that a stopped newest era holding none SHALL be dropped while an older era stands behind it, which
SHALL then carry its state, its category and the earlier of the two days kept until.

Mending SHALL say nothing to the person and MUST NOT change what is at the place; the next change
kept there SHALL be written mended.

#### Scenario: a stored roster holding eras that hold no day is read back without them

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose entries are four eras of one commitment named "Gym" — on a schedule listing Tuesday and
  Thursday, kept from 31 August 2026 and kept; on one listing Monday, Wednesday and Saturday, kept
  from 31 August 2026 and kept until 30 August 2026; on one listing Tuesday and Thursday, kept from
  31 August 2026 and kept until 30 August 2026; and on one listing Monday, Wednesday and Saturday,
  kept from 1 January 2026 and kept until 30 August 2026
- **THEN** it opens without error
- **AND** it reads back two eras of "Gym", the one on Tuesday and Thursday, kept from 31 August 2026,
  first and the one on Monday, Wednesday and Saturday, kept from 1 January 2026, second
- **AND** the content at that place is byte-for-byte what it was before
- **AND** a commitments screen opened at a place holding that same roster as of Monday 31 August
  2026 keeps one entry, named "Gym", saying "Tue, Thu"
- **AND** after a commitment named "Run" is taken on through the store, a store opened afterwards at
  that place reads back those two eras of "Gym" and then "Run"

#### Scenario: alike eras standing side by side are read back as one

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose entries are three eras of one commitment named "Gym" — on a schedule listing Monday,
  Wednesday and Saturday, kept from 31 August 2026 and kept; on one listing Tuesday and Thursday,
  kept from 31 August 2026 and kept until 30 August 2026; and on one listing Monday, Wednesday and
  Saturday, kept from 1 January 2026 and kept until 30 August 2026
- **THEN** it reads back one commitment it is keeping and one era of it, on Monday, Wednesday and
  Saturday, kept from 1 January 2026
- **AND** a roster store holding two eras of "Gym" on that schedule and nothing between them, the
  newer kept from 1 September 2026 and kept and the older kept from 1 January 2026 and kept until
  31 August 2026, reads back one era of it, kept from 1 January 2026

#### Scenario: eras holding the same days are read back with the newer keeping them

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose entries are three eras of one commitment named "Nails" — on every 4 days starting on
  18 August 2026, kept from that day and kept; on every 5 days starting on 20 August 2026, kept from
  that day and kept until 17 August 2026; and on every 4 days starting on 6 August 2026, kept from
  4 August 2026 and kept until 19 August 2026
- **THEN** it reads back two eras of "Nails", the one starting on 18 August 2026 first
- **AND** asked about 17 August 2026 it answers with both eras, and about 18 August 2026 with the
  newer alone
- **AND** a roster store holding two eras of "Gym" alike in every part, both kept from 1 January
  2026, the newer kept and the older kept until 31 January 2026, reads back one era of "Gym", kept

#### Scenario: the newest era of a commitment stopped on the day it began is read back as it is

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose entries are two eras of one commitment named "Gym" — on a schedule listing Tuesday and
  Thursday, kept from 31 August 2026 and stopped as of 31 August 2026; and on one listing Monday,
  Wednesday and Saturday, kept from 1 January 2026 and kept until 30 August 2026
- **THEN** it reads back nothing it is keeping and one commitment it has stopped, "Gym", saying
  "Tue, Thu"
- **AND** it reads back two eras of "Gym"

#### Scenario: a roster kept before a commitment had an identity holding an era that holds no day is read back without it

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment had an identity, whose entries are "Gym" on a schedule listing Monday, kept from
  1 March 2026 and kept, and "Gym" on that same schedule, kept from 1 March 2026, removed and kept
  until 28 February 2026
- **THEN** it opens without error
- **AND** it reads back one commitment it is keeping, named "Gym", with one era, kept from 1 March
  2026
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a copy holding eras that hold no day is restored with them mended

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept, and is asked to restore from a copy of the
  form written now, made on that day at 14:32, holding a roster whose one commitment "Gym" has four
  eras — on Tuesday and Thursday kept from 31 August 2026; on
  Monday, Wednesday and Saturday and on Tuesday and Thursday, each kept from 31 August 2026 and kept
  until 30 August 2026; and on Monday, Wednesday and Saturday kept from 1 January 2026 and kept until
  30 August 2026 — and the restore is confirmed
- **THEN** asking is not refused, and the restore awaiting confirmation says the copy keeps one
  commitment
- **AND** a roster store opened afterwards at that roster place reads back two eras of "Gym", the one
  on Tuesday and Thursday first

#### Scenario: a stopped newest era holding no day is read back without it, the era behind it stopped

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose entries are two eras of one commitment named "Gym" — on a schedule listing Tuesday and
  Thursday, kept from 31 August 2026 and stopped as of 30 August 2026; and on one listing Monday,
  Wednesday and Saturday, kept from 1 January 2026 and kept until 30 August 2026
- **THEN** it reads back nothing it is keeping and one commitment it has stopped, "Gym", saying
  "Mon, Wed, Sat"
- **AND** it reads back one era of "Gym", and answers with it on 30 August 2026 and with nothing on
  31 August 2026
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: alike eras with days between them are read back as two

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose entries are two eras of one commitment named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday — kept from 1 March 2026 and kept; and kept from 1 January 2026 and kept
  until 31 January 2026
- **THEN** it reads back two eras of "Gym", the one kept from 1 March 2026 first
- **AND** asked about 15 February 2026 it answers with that one alone, and about 31 January 2026
  with both
