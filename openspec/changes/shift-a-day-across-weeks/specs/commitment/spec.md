## ADDED Requirements

### Requirement: A roster shifts a weekday-set or day-of-month due day onto a free day of its week or between its due days either side

A roster SHALL shift a due day of a commitment it holds, kept or stopped, where the era holding it
runs on a weekday set or a day of the month, only onto a free day, and SHALL refuse, changing
nothing, every other such shift, a weekly-quota day, a day not due and a commitment not held.

A free day SHALL be held by that era, due by neither its schedule nor any shift, and in the due
day's Monday-to-Sunday week or between its schedule's due days either side, days away lying between
the two refusing nothing. A day a shift put a due day on SHALL be shifted as the day it
came from would be unshifted, keeping that day, which SHALL be free only where an era holding it
has a schedule due on it; shifted to it, no shift SHALL remain.

#### Scenario: a roster shifts a weekday-set due day onto a free day and leaves the rest of its rhythm as it was

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and is asked to shift its due day on Monday 31 August 2026 to
  Tuesday 1 September 2026
- **THEN** the roster answers that it shifted it
- **AND** it still holds one era of "Gym", kept from 1 January 2026 and saying "Mon, Wed, Sat"
- **AND** the commitment it keeps is due on Wednesday 2 and Saturday 5 September 2026 and on Monday
  7 September 2026

#### Scenario: a roster shifts a day-of-month due day across the end of its month, inside its week

- **WHEN** a roster holds a commitment named "Finances" on a schedule on the 31st of the month, kept
  from 1 January 2026, and is asked to shift its due day on Monday 31 August 2026 to Tuesday
  1 September 2026
- **THEN** the roster answers that it shifted it
- **AND** the commitment it keeps is due on Tuesday 1 September 2026 and not on Monday 31 August
  2026
- **AND** it is due on Wednesday 30 September 2026, the last day of a month too short for its day

#### Scenario: a roster refuses to shift a due day onto one of its own days, a day another shift put a due day on, or a day past both its week and its due days either side

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Wednesday 2 September 2026 is shifted to
  Thursday 3 September 2026, and is asked to shift its due day on Monday 31 August 2026 to Wednesday
  2 September 2026, to Thursday 3 September 2026, to Saturday 5 September 2026, to Tuesday
  8 September 2026 and to Monday 31 August 2026 itself
- **THEN** the roster refuses each of the five
- **AND** the commitment it keeps is still due on Monday 31 August and Thursday 3 September 2026,
  and not on Wednesday 2 September 2026

#### Scenario: a roster refuses to shift a due day onto a day the era holding it does not hold

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from Wednesday 2 September 2026, and is asked to shift its due day on that day to
  Tuesday 1 September 2026
- **THEN** the roster refuses it
- **AND** a roster holding "Gym" kept from 1 January 2026, stopped as of the day it was kept until,
  Wednesday 2 September 2026, and taken up again from Saturday 5 September 2026, refuses to shift
  its due day on Wednesday 2 September 2026 to Thursday 3, Friday 4 or Sunday 6 September 2026
- **AND** that roster shifts the same day to Tuesday 1 September 2026

#### Scenario: a roster refuses to shift a day the commitment is not due on, and a weekly-quota day

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Monday 31 August 2026 is shifted to Tuesday
  1 September 2026, and is asked to shift Monday 31 August 2026 to Thursday 3 September 2026, and
  Friday 4 September 2026 to Sunday 6 September 2026
- **THEN** the roster refuses both
- **AND** a roster holding a commitment named "Reading" on a weekly quota of 3 times a week, kept
  from 1 January 2026, refuses to shift its day on Monday 31 August 2026 to Tuesday 1 September 2026

#### Scenario: a roster shifts a day of a commitment it has stopped, and refuses one it does not hold

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026 and stopped as of the day it was kept until, Saturday 5
  September 2026, and is asked to shift its due day on Monday 31 August 2026 to Tuesday 1 September
  2026
- **THEN** the roster answers that it shifted it
- **AND** a roster asked the same of a commitment named "Run" it never held, or of "Gym" once it has
  deleted it, refuses it and is left as it was

#### Scenario: a day a shift put a due day on, shifted again, keeps the day it came from

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Monday 31 August 2026 is shifted to Tuesday
  1 September 2026, and is asked to shift Tuesday 1 September 2026 to Thursday 3 September 2026
- **THEN** the roster answers that it shifted it
- **AND** the commitment it keeps is due on Thursday 3 September 2026, and on neither Monday
  31 August nor Tuesday 1 September 2026
- **AND** the roster then shifts Thursday 3 September 2026 to Monday 31 August 2026, leaving the
  commitment due on Monday 31 August 2026 and on neither Tuesday 1 nor Thursday 3 September 2026

#### Scenario: a day a shift put a due day on, shifted to the day it came from, leaves no shift

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at two roster places; and at the first, its due day on Monday
  31 August 2026 is shifted to Tuesday 1 September 2026 and Tuesday 1 September 2026 is then shifted
  to Monday 31 August 2026
- **THEN** both shifts are answered as shifted
- **AND** the commitment the first place's roster store keeps is due on Monday 31 August 2026 and
  not on Tuesday 1 September 2026
- **AND** the content at the first place is byte-for-byte the content at the second

#### Scenario: a roster refuses to shift a due day back to the day it came from once no era is due on that day

- **WHEN** a roster holds a commitment named "Run" on a schedule listing Tuesday and Thursday, kept
  from 1 January 2026, whose due day on Tuesday 1 September 2026 is shifted to Monday 31 August
  2026, and which is then stopped as of the day it was kept until, Monday 31 August 2026; and it is
  asked to shift Monday 31 August 2026 to Tuesday 1 September 2026
- **THEN** the roster refuses it, and the commitment it holds is still due on Monday 31 August 2026
- **AND** a roster holding "Run" shifted the same way, not stopped but given a further era on a
  schedule listing Wednesday and Friday, kept from Tuesday 1 September 2026, refuses the same shift
  and is still due on Monday 31 August 2026
- **AND** a roster holding "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, whose due day on Monday 31 August 2026 is shifted to Tuesday 1 September 2026 and
  which is then given a further era on a schedule listing Wednesday and Friday, kept from Tuesday
  1 September 2026, shifts Tuesday 1 September 2026 to Monday 31 August 2026, leaving it due on
  Monday 31 August 2026 and not on Tuesday 1 September 2026

#### Scenario: a roster shifts a weekday-set or day-of-month due day across days away, inside its week or past it, and onto none of their days

- **WHEN** a commitment named "Pool" on a schedule listing Friday, kept from 1 January 2026, is taken
  on at a roster place; days away from Saturday 17 through Sunday 18 October 2026 are said over it
  through a commitments screen opened at that roster place as of Monday 12 October 2026; and a
  roster store opened afterwards at that place is asked to shift its due day on Friday 16 October
  2026 to Sunday 18 October 2026, and then to Monday 19 October 2026
- **THEN** it refuses the first and shifts the second
- **AND** the roster store then shifts Monday 19 October 2026 back to Friday 16 October 2026
- **AND** where a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, is taken on at a roster place of its own and days away from Tuesday 13
  through Tuesday 13 October 2026 are said over it alike, a roster store opened afterwards there
  shifts its due day on Monday 12 October 2026 to Thursday 15 October 2026

#### Scenario: a roster shifts a one-weekday due day onto any day between its due days either side, a week crossed or not

- **WHEN** five rosters each hold a commitment named "Pool" on a schedule listing Friday, kept from
  1 January 2026, and each is asked to shift its due day on Friday 4 September 2026 to one of
  Saturday 29 August, Thursday 3 September, Saturday 5 September, Monday 7 September and Thursday
  10 September 2026
- **THEN** each of the five answers that it shifted it
- **AND** each still holds one era of "Pool", kept from 1 January 2026 and saying "Fri"
- **AND** the commitment the one shifted to Monday 7 September 2026 keeps is due on Monday 7 and
  Friday 11 September 2026, and not on Friday 4 September 2026

#### Scenario: a roster refuses to shift a one-weekday due day onto its due day either side or a day beyond them

- **WHEN** a roster holds a commitment named "Pool" on a schedule listing Friday, kept from 1 January
  2026, and is asked to shift its due day on Friday 4 September 2026 to Thursday 27 August, Friday
  28 August, Friday 11 September and Saturday 12 September 2026
- **THEN** the roster refuses each of the four
- **AND** the commitment it keeps is still due on Friday 4 and Friday 11 September 2026

#### Scenario: a weekday-set due day is shifted past its own due days inside its week, and outside it only up to them

- **WHEN** three rosters each hold a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and each is asked to shift its due day on Monday 31 August
  2026 to one of Sunday 30 August, Thursday 3 September and Friday 4 September 2026
- **THEN** each of the three answers that it shifted it
- **AND** a roster holding "Gym" alike shifts its due day on Saturday 5 September 2026 to Tuesday
  1 September 2026
- **AND** a roster holding "Gym" alike refuses to shift its due day on Monday 31 August 2026 to
  Friday 28 August 2026, and its due day on Saturday 5 September 2026 to Tuesday 8 September 2026

#### Scenario: a roster shifts a day-of-month due day onto any day between its due days either side, about a month each way

- **WHEN** two rosters each hold a commitment named "Finances" on a schedule on the 31st of the
  month, kept from 1 January 2026, and the first is asked to shift its due day on Monday 31 August
  2026 to Saturday 1 August 2026 and the second to Tuesday 29 September 2026
- **THEN** both answer that they shifted it
- **AND** the commitment the second keeps is due on Tuesday 29 and Wednesday 30 September 2026, and
  not on Monday 31 August 2026
- **AND** a roster holding "Finances" alike refuses to shift its due day on Monday 31 August 2026 to
  Friday 31 July 2026, to Wednesday 30 September 2026 and to Thursday 1 October 2026

#### Scenario: a day a shift put into another week, shifted again, is judged from the day it came from

- **WHEN** a roster holds a commitment named "Pool" on a schedule listing Friday, kept from 1 January
  2026, whose due day on Friday 4 September 2026 is shifted to Monday 7 September 2026, and is asked
  to shift Monday 7 September 2026 to Saturday 12 September 2026 and then to Saturday 29 August 2026
- **THEN** it refuses the first and shifts the second
- **AND** the commitment it keeps is due on Saturday 29 August 2026, and on neither Friday 4 nor
  Monday 7 September 2026
- **AND** the roster then shifts Saturday 29 August 2026 to Friday 4 September 2026, leaving the
  commitment due on Friday 4 September 2026 and on neither Saturday 29 August nor Monday 7 September
  2026

#### Scenario: the due days either side of a day are its schedule's, never where another shift put one

- **WHEN** a roster holds a commitment named "Pool" on a schedule listing Friday, kept from 1 January
  2026, whose due day on Friday 4 September 2026 is shifted to Monday 7 September 2026, and is asked
  to shift its due day on Friday 11 September 2026 to Monday 7 September 2026 and then to Saturday
  5 September 2026
- **THEN** it refuses the first and shifts the second
- **AND** the commitment it keeps is due on Saturday 5 and Monday 7 September 2026, and on neither
  Friday 4 nor Friday 11 September 2026

## MODIFIED Requirements

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
every era of everything the roster holds, kept and stopped alike, and a commitment stopped SHALL keep
its place in it and return to that place when it is taken up again. A commitment deleted SHALL leave
it, and every other SHALL keep the order it had.

A roster SHALL hold, for each era it holds, at most two further things — the category its
commitment is under and the day that era was kept until — and, of the whole roster, whether deleting
emptied it, and nothing else. It MUST NOT give a commitment a position it can be asked for, a record of the day it
was added, or any other state, and MUST NOT alter a commitment it holds but by shifting a due day of it, as *A roster shifts a
weekday-set or day-of-month due day onto a free day of its week or between its due days either side* and *A roster shifts an
every-N-days due day onto a day between the due days either side of it, and runs its count on from
there* say: one read back SHALL otherwise be the one that was put in. An identity is a part of a commitment and not a thing the roster gives it, and
the eras of one commitment are linked by carrying it. Changing one era for another SHALL NOT be
altering one. Being stopped, put under a category, changed
or given a new era SHALL give a commitment no part beyond the six *A commitment is an identity, a
name, a schedule, the day it is kept from, the kind its days take and its shifts* names, SHALL leave
its shifts as they were, and SHALL leave it answering whether it is due exactly as before. The ban on a position is a ban on a read: nothing SHALL ask a roster where a
commitment is, and moving one hands a place in rather than reading one out. A category SHALL be read
back as part of the groups the roster reads its commitments back in, and nothing SHALL ask it about
one commitment on its own.

Kept and stopped SHALL be the two states, and a commitment the roster holds SHALL be in exactly one
of them, carried by its newest era: one it is keeping has no kept-until day on that era, and one it
has stopped keeping has one. A category SHALL NOT be a third state and SHALL cut across both.
Deleting SHALL be the one thing that takes a commitment out of a roster, and a roster that deleting
has emptied SHALL NOT be the same roster as one given none.

A roster SHALL NOT consult the present moment, the device's clock, its time zone or its locale,
SHALL NOT be asked what day it is, and SHALL work only with dates it was handed, judging one only
against a day it was told a commitment was kept until and, where it shifts a due day, against the
commitment's eras, the days each holds and the shifts it carries, and against that day's
Monday-to-Sunday week on a weekday set or a day of the month, and the due days either side of it. Shifting a due day aside, it MUST NOT judge a commitment's own day it is kept from or
its schedule, and MUST NOT decide whether a commitment is due.

A roster SHALL be a value: two holding the same eras of the same commitments in the same order,
each commitment in the same state and under the same category and each era with the same kept-until
day, SHALL be the same roster; two holding them in a different order SHALL be different rosters. Adding a commitment, stopping one,
deleting one, moving one or putting one under a category SHALL leave every other roster untouched.

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
holds a tick, a number, a note, an addition or a decline of that commitment on it, but for a stop *A
commitments screen refuses a change deciding due days, and a stop, while a shift has a day after the
day it was handed* refuses; and it SHALL keep that at the roster place before either list says
so; the commitment SHALL then be in what the screen has stopped and not in what it keeps, in the place
it has. Where the day the screen was handed has no day before it, the commitment SHALL be kept until
that day itself, and a commitment defined and stopped on the same day, that day holding no record of
it, SHALL become one kept on no day at all. A screen that cannot read its record SHALL stop as of the day before, and a record taken
back after a stop SHALL leave the day kept until where it was. A stop SHALL end a due day a shift put
on the day handed exactly as it ends one the schedule put there, and SHALL leave every shift as it
was. A commitments screen SHALL offer no
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

#### Scenario: a stop confirmed on the day a shift put a due day on ends that due day unless the day holds a record of it

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and its due day on Monday 31 August 2026 is shifted
  there to Tuesday 1 September 2026; a commitments screen is opened at that roster place and at a
  record place where nothing has been kept as of Tuesday 1 September 2026; and it is asked to stop
  keeping "Gym" and the stop is confirmed
- **THEN** nothing is refused, and what it has stopped is one entry, named "Gym"
- **AND** a day screen opened afterwards at those places as of Tuesday 1 September 2026 holds no row,
  and the day view it says of the day before holds one row, named "Gym", saying "to Tue 1 Sep" and
  offering nothing
- **AND** where a tick for "Gym" on Tuesday 1 September 2026 is kept at the record place before the
  stop, a roster store opened afterwards answers with "Gym" when asked what it had not stopped
  keeping on Tuesday 1 September 2026, and that day screen holds one row, named "Gym", saying
  "from Mon 31 Aug" and saying its commitment is kept

#### Scenario: a commitment stopped through a commitments screen on a day it was declined is kept until that day

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a decline of "Gym" with the reason "Away" on Monday
  31 August 2026 is kept at a record place; a commitments screen is opened at those places as of that
  day; and it is asked to stop keeping "Gym" and the stop is confirmed
- **THEN** a roster store opened afterwards at that roster place answers with "Gym" when asked what
  it had not stopped keeping on Monday 31 August 2026, and with nothing on Tuesday 1 September 2026
- **AND** a day screen opened afterwards at those places as of Monday 31 August 2026 holds one row,
  named "Gym", declined with the reason "Away"

### Requirement: A commitments screen refuses a change deciding due days, and a stop, while a shift has a day after the day it was handed

A commitments screen SHALL refuse, as **a shifted day ahead**, a change asking for a different
rhythm, day kept from, range or target, and a stop, wherever a shift of the commitment has either
day later than the day the screen was handed; a shift with both days on or before it SHALL refuse
neither. It SHALL be told apart from every other refusal, keep nothing at either place, and be about
the field a recorded-day refusal of the same change is about. A change to the name, the category or
the usual amounts alone SHALL NOT be refused for a shift, and a change kept SHALL leave every shift
as it was. The refusal SHALL be the screen's alone: a roster SHALL stop, or change an era of, a
commitment whatever its shifts.

#### Scenario: a rhythm change is refused while a shift has a day after the day handed

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and its due day on Monday 31 August 2026 is shifted
  there to Thursday 3 September 2026; a commitments screen is opened at that roster place and a
  record place where nothing has been kept as of Tuesday 1 September 2026; and "Gym" is changed
  through it to a weekday-set rhythm of Tuesday and Thursday, on everything else it already has
- **THEN** it is refused as a shifted day ahead, about the rhythm field of its sheet, told apart from
  a day already recorded on that the change would leave not due
- **AND** what the screen keeps is one entry named "Gym", and the content at both places is
  byte-for-byte what it was immediately after the screen was opened
- **AND** the same change is refused the same way where the due day on Saturday 5 September 2026 is
  shifted to Friday 4 September 2026 instead and the screen is opened as of Friday 4 September 2026

#### Scenario: a range or a target change is refused while a shift has a day after the day handed

- **WHEN** a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, is taken on at a roster place
  and its due day on Monday 31 August 2026 is shifted there to Thursday 3 September 2026; a
  commitments screen is opened at that roster place as of Tuesday 1 September 2026; and "Weight" is
  changed through it to a range of 40 to 200, on everything else it already has
- **THEN** it is refused as a shifted day ahead, about the range field of its sheet
- **AND** a commitment named "Protein" of the total kind with a target of 120, held and shifted the
  same way, changed to a target of 150 is refused as a shifted day ahead, about the target field

#### Scenario: a move of the day kept from is refused while a shift has a day after the day handed

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and its due day on Monday 31 August 2026 is shifted
  there to Thursday 3 September 2026; a commitments screen is opened at that roster place as of
  Tuesday 1 September 2026; and "Gym" is changed through it to the day kept from 1 February 2026, on
  everything else it already has
- **THEN** it is refused as a shifted day ahead, about the day-kept-from field of its sheet
- **AND** what the screen keeps is one entry named "Gym", kept from 1 January 2026

#### Scenario: a stop is refused while a shift has a day after the day handed

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and its due day on Monday 31 August 2026 is shifted
  there to Thursday 3 September 2026; a commitments screen is opened at that roster place as of
  Tuesday 1 September 2026; and it is asked to stop keeping "Gym" and the stop is confirmed
- **THEN** it is refused as a shifted day ahead, told apart from a roster that could not be written
- **AND** what it keeps is one entry, named "Gym", what it has stopped is nothing, and the content at
  that place is byte-for-byte what it was immediately after the screen was opened

#### Scenario: a rename and a category are not refused while a shift has a day after the day handed

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and its due day on Monday 31 August 2026 is shifted
  there to Thursday 3 September 2026; a commitments screen is opened at that roster place as of
  Tuesday 1 September 2026; and "Gym" is changed through it to the name "Lifting", under "Sport", on
  everything else it already has
- **THEN** nothing is refused
- **AND** the commitment named "Lifting" a roster store opened afterwards at that place keeps is due
  on Thursday 3 September 2026 and not on Monday 31 August 2026

#### Scenario: a shift with no day after the day handed refuses no change and stands through it

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and its due day on Monday 31 August 2026 is shifted
  there to Tuesday 1 September 2026; a tick for it on Tuesday 1 September 2026 is kept at a record
  place; a commitments screen is opened at those places as of Tuesday 1 September 2026; and "Gym" is
  changed through it to the name "Lifting" and a weekday-set rhythm of Wednesday and Friday
- **THEN** nothing is refused
- **AND** a day screen opened afterwards at those places as of Tuesday 1 September 2026 holds one
  row, named "Lifting", saying "from Mon 31 Aug" and saying its commitment is kept
- **AND** the day view it says of the day before holds a row named "Lifting" saying "to Tue 1 Sep"

### Requirement: A roster store keeps every shift at its place, and refuses a shift no roster could hold

A roster store SHALL keep every shift its roster holds at its place across the app being closed and
opened again, the day each took a due day from and the day it put it on, writing the same shifts on
every era of the commitment. It SHALL read a shift whose two days lie in two
Monday-to-Sunday weeks, whatever rhythm the eras holding them run on. A roster store holding a shift
no roster could hold — one day twice, two shifts of one commitment from one day or onto one day, or
eras of one commitment carrying different shifts — SHALL be refused as holding
something that could not be a roster, SHALL say it is not a roster store rather than a later form,
and SHALL leave the content at its place byte-for-byte as it was.

#### Scenario: a shift kept at a roster place is held by a roster store opened afterwards at the same place

- **WHEN** a roster store is opened at a roster place where nothing has been kept; a commitment
  named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, is
  taken on through it; its due day on Monday 31 August 2026 is shifted to Tuesday 1 September 2026;
  and a further era of "Gym", on a schedule listing Tuesday and Thursday, kept from Monday
  7 September 2026, is then put on it
- **THEN** a roster store opened afterwards at that place reads back two eras of "Gym"
- **AND** the commitment it answers on Tuesday 1 September 2026 is due on that date, and the one it
  answers on Monday 31 August 2026 is not

#### Scenario: a roster store holding a shift no roster could hold is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Gym", on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, holds a shift from Monday 31 August 2026 to that same day
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** a roster store at a place whose "Gym" holds two shifts from Monday 31 August 2026, or two
  eras carrying different shifts, is refused the same way
- **AND** the content at each place is byte-for-byte what it was before

#### Scenario: an every-N-days shift across a week is held by a roster store opened afterwards

- **WHEN** a roster store is opened at a roster place where nothing has been kept; a commitment
  named "Contact lenses" on a schedule of every 14 days starting on Tuesday 25 August 2026, kept
  from that day, is taken on through it; and its due day on Tuesday 8 September 2026 is shifted to
  Saturday 5 September 2026
- **THEN** opening a roster store afterwards at that place is not refused
- **AND** the commitment it keeps is due on Saturday 5 and Saturday 19 September 2026 and on neither
  Tuesday 8 nor Tuesday 22 September 2026

#### Scenario: a weekday-set or day-of-month shift across a week is held by a roster store opened afterwards

- **WHEN** a roster store is opened at a roster place where nothing has been kept; a commitment
  named "Pool" on a schedule listing Friday and one named "Finances" on a schedule on the 31st of
  the month, both kept from 1 January 2026, are taken on through it; and the due day of "Pool" on
  Friday 4 September 2026 is shifted to Monday 7 September 2026, and that of "Finances" on Monday
  31 August 2026 to Tuesday 29 September 2026
- **THEN** opening a roster store afterwards at that place is not refused
- **AND** the "Pool" it keeps is due on Monday 7 September 2026 and not on Friday 4 September 2026,
  and its "Finances" is due on Tuesday 29 September 2026 and not on Monday 31 August 2026

## REMOVED Requirements

### Requirement: A roster shifts a weekday-set or day-of-month due day onto a free day of its week

**Reason**: its free days stop at the due day's week, so a Friday slipped to the Monday after is
refused. It is replaced by *A roster shifts a weekday-set or day-of-month due day onto a free day of its week or between its due days either side*, added above, which carries it with its free-day sentence
rewritten for the due days either side and for a day shifted again.
**Migration**: every scenario is carried verbatim but "a roster refuses to shift a due day onto one
of its own days, a day another shift put a due day on, or a day of another week", renamed "a roster
refuses to shift a due day onto one of its own days, a day another shift put a due day on, or a day
past both its week and its due days either side" with its body unchanged; its test is renamed.
