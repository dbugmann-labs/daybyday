## MODIFIED Requirements

### Requirement: A deletion erases every record of its commitment, or keeps nothing at either place

A commitments screen confirming a deletion SHALL erase at the record place every record against any
era of that commitment — every tick, number, note, addition and decline — and SHALL keep that before the
roster place is written. Every record of every other commitment SHALL be left exactly as it was, and
where the commitment holds no record the record place SHALL NOT be written. A deletion SHALL be
whole or nothing: where the record place cannot be read or written, it SHALL be refused as a roster
that could not be written, keeping nothing at either place; where the roster place then refuses it,
the screen SHALL put back at the record place exactly what it held and SHALL refuse it the same way,
leaving both lists as they were. A commitment defined afterwards SHALL never be given a deleted
commitment's records, however alike the two are.

#### Scenario: a deletion erases every tick, number, note and addition of the commitment, from every era

- **WHEN** a commitment named "Gym" of the tick kind, "Weight" of the number kind with a range of 40
  to 150, "Diary" of the note kind and "Water" of the total kind with a target of 2, each on a
  schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster place;
  "Gym" is given a new era on a schedule listing Tuesday and Thursday, kept from 1 March 2026; a tick
  for "Gym" on 15 February 2026 and on 3 March 2026, a number, a note and an addition for each of the
  other three on 3 March 2026 are kept at a record place; a commitments screen is opened at those
  places as of Monday 31 August 2026; and each of the four is deleted through it, its name typed back
- **THEN** none of the four deletions is refused
- **AND** a store opened afterwards at that record place holds no record at all

#### Scenario: a deletion leaves every record of every other commitment as it was

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; ticks for each on Monday
  3 August 2026 and Tuesday 4 August 2026 are kept at a record place; a commitments screen is opened
  at those places as of Monday 31 August 2026; and "Gym" is deleted through it, "Gym" typed back
- **THEN** a store opened afterwards at that record place answers that "Run" was kept on both days
- **AND** it holds no record of "Gym" on either day

#### Scenario: a commitment deleted with no record leaves the record place as it was

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a tick for "Run" on Monday
  3 August 2026 is kept at a record place; the content at that record place is read; a commitments
  screen is opened at those places as of Monday 31 August 2026; and "Gym" is deleted through it
- **THEN** nothing is refused
- **AND** the content at that record place is byte-for-byte what was read

#### Scenario: a deletion the record place cannot take is refused and keeps nothing at either place

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place in a directory of its own; a tick for it on Monday 3 August
  2026 is kept at a record place in another; a commitments screen is opened at those places as of
  Monday 31 August 2026; the content at both places is read; the record place's directory is then
  made impossible to write; and "Gym" is deleted through it, "Gym" typed back
- **THEN** it is refused as a roster that could not be written
- **AND** what it keeps is one entry, named "Gym"
- **AND** the content at both places is byte-for-byte what was read

#### Scenario: a deletion the roster place refuses puts the record place back as it was

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place in a directory of its own; a tick for it on Monday 3 August
  2026 is kept at a record place in another; a commitments screen is opened at those places as of
  Monday 31 August 2026; the content at both places is read; the roster place's directory is then
  made impossible to write; and "Gym" is deleted through it, "Gym" typed back
- **THEN** it is refused as a roster that could not be written
- **AND** what it keeps is one entry, named "Gym"
- **AND** a store opened afterwards at that record place answers that "Gym" was kept on Monday
  3 August 2026

#### Scenario: a deletion a commitments screen could not keep leaves both its lists as they were

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place, and "Run" is stopped there
  as of Sunday 23 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; what is at that place is then made impossible to write; and the screen is asked to
  delete "Run", "Run" is typed back and the deletion is confirmed
- **THEN** it is refused as a roster that could not be written
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is one entry, named "Run"

#### Scenario: a deletion on a commitments screen that cannot read its record is refused

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a run of bytes that is not a record is kept at a record
  place; a commitments screen is opened at those places as of Monday 31 August 2026; and "Gym" is
  deleted through it, "Gym" typed back
- **THEN** it is refused as a roster that could not be written
- **AND** what it keeps is one entry, named "Gym"
- **AND** the content at both places is byte-for-byte what it was before the screen was opened

#### Scenario: a commitment defined after a deletion holds none of the deleted commitment's records

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record
  place; a commitments screen is opened at those places as of Monday 31 August 2026; "Gym" is
  deleted through it; a commitment named "Lifting" on that same rhythm, kept from 1 January 2026, is
  defined through it; and the app is shown again as of Monday 31 August 2026
- **THEN** a look-back at "Lifting" counts no day of August 2026 kept
- **AND** the screen does not say that records belong to no commitment

#### Scenario: a deletion erases every decline of its commitment

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; a decline of "Gym" with the reason
  "Away" on Monday 3 August 2026, one with no reason on Tuesday 4 August 2026, and a decline of "Run"
  with the reason "Ill" on Monday 3 August 2026 are kept at a record place; a commitments screen is
  opened at those places as of Monday 31 August 2026; and "Gym" is deleted through it, "Gym" typed
  back
- **THEN** the deletion is not refused
- **AND** a store opened afterwards at that record place holds a history the decline of "Run" alone
  was added to, and the content at that place holds "Away" nowhere

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
  and the day view it says of the day before holds one row, named "Gym", saying "to Tue" and
  offering nothing
- **AND** where a tick for "Gym" on Tuesday 1 September 2026 is kept at the record place before the
  stop, a roster store opened afterwards answers with "Gym" when asked what it had not stopped
  keeping on Tuesday 1 September 2026, and that day screen holds one row, named "Gym", saying
  "from Mon" and saying its commitment is kept

#### Scenario: a commitment stopped through a commitments screen on a day it was declined is kept until that day

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a decline of "Gym" with the reason "Away" on Monday
  31 August 2026 is kept at a record place; a commitments screen is opened at those places as of that
  day; and it is asked to stop keeping "Gym" and the stop is confirmed
- **THEN** a roster store opened afterwards at that roster place answers with "Gym" when asked what
  it had not stopped keeping on Monday 31 August 2026, and with nothing on Tuesday 1 September 2026
- **AND** a day screen opened afterwards at those places as of Monday 31 August 2026 holds one row,
  named "Gym", declined with the reason "Away"
