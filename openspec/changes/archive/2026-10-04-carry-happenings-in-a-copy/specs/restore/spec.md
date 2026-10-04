## ADDED Requirements

### Requirement: A copy holds the happenings at the happening place, and is refused whole where they cannot be read

Forming a copy SHALL read the happening place when the copy is asked for, and the copy SHALL hold
every happening kept there, stopped or not, with its identity, its name and its place in their
order, and every occurrence kept there, in the order noted. A happening place where nothing has been
kept SHALL count as holding no happenings and SHALL NOT refuse the copy. Where the happenings cannot
be read, or were written by a later version of DayByDay, the copy SHALL be refused whole for that
cause, and the store named SHALL be the happenings only where the record, the roster, the one-offs
and the birthday ticks could all be read; a copy the app makes on its own at the copy place SHALL
stop naming them the same way. Forming a copy SHALL leave the happening place as it found it.

#### Scenario: a copy holds the happenings and occurrences the happening place holds, and none where nothing has been kept there

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are added to a happening store at a
  happening place; an occurrence of "Kopfweh" is noted there on 2 October 2026 at 09:10 with the
  note "links"; "Augenmigräne" is stopped there; a commitments screen is opened as of Saturday
  3 October 2026 at that happening place and at a record place, a roster place, a one-off place and
  a birthday place where nothing has been kept; and a copy is asked for as of that day at 14:32,
  written into a directory of its own
- **THEN** the copy is not refused
- **AND** what is written holds "Augenmigräne" and then "Kopfweh", "Augenmigräne" stopped and
  "Kopfweh" not, each the same happening the store holds under that name, and one occurrence, of
  "Kopfweh" on 2 October 2026 at 09:10 with the note "links"
- **AND** the content at that happening place is byte-for-byte what it was immediately after the
  screen was opened
- **AND** a copy asked for the same way where nothing has been kept at the happening place is not
  refused, holds no happenings, and leaves nothing written at that happening place

#### Scenario: a copy is refused whole where the happenings cannot be read, naming them only where the other four stores read

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened as of Saturday
  3 October 2026 at that roster place, a record place, a one-off place and a birthday place where
  nothing has been kept, and a happening place holding a run of bytes that is not a happening store;
  and a copy is asked for as of that day at 14:32, written into a directory of its own
- **THEN** it is refused as a store that could not be read, naming the happenings
- **AND** no file stands in that directory, and the content at that happening place is byte-for-byte
  what it was before the copy was asked for
- **AND** a copy asked for where the happening place holds a happening store written in a form one
  later than the form this app writes is refused as a store written by a later version of DayByDay,
  naming the happenings
- **AND** a copy asked for where the birthday place is also a run of bytes that is not what birthday
  ticks are written as is refused as a store that could not be read, naming the birthday ticks

#### Scenario: a change kept where the happenings cannot be read is kept, and the stop names the happenings

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen is opened at that roster place and at
  a record place, a one-off place, a birthday place and a happening place where nothing has been
  kept as of Saturday 3 October 2026, keeping its copy place at a place of its own and asking a
  clock that answers a later minute each time it is asked, from that day at 14:32; a directory of
  its own is given as its copy place through a commitments screen opened at those same places; what
  is at that happening place is then made a run of bytes that is not a happening store; and the row
  named "Gym" is ticked
- **THEN** the tick is not refused, and a record store opened at that record place holds that tick
- **AND** the stop is a store that could not be read, naming the happenings, as of Saturday
  3 October 2026 at 14:33
- **AND** with a happening store written in a form one later than the form this app writes made to
  stand there instead, the stop is a store written by a later version of DayByDay, naming the
  happenings

### Requirement: A copy place reads the happenings where a commitments screen and a day screen keep them

A copy place SHALL read the happenings at the happening place a commitments screen and a day screen
keep them at. A copy place opened at a record place and given no happening place SHALL read them in
the file of the happening place's name beside that record place, which is the file a commitments
screen and a day screen given no happening place keep them in. Where that record place is the one a
day screen keeps its record at by default, the copy place SHALL read the happenings at the place
the app names for them.

#### Scenario: a copy place given no happening place copies the happenings a commitments screen given none keeps

- **WHEN** a happening named "Kopfweh" is added to a happening store at the file of the happening
  place's name beside a record place in a directory of its own; a commitments screen is opened as of
  Saturday 3 October 2026 at that record place and at a roster place and a one-off place beside it
  where nothing has been kept, given no happening place, and a copy place opened at that record
  place the same way, given no happening place and asking a clock that answers that day at 14:32, is
  handed to it; and a directory of its own is given to it as its copy place
- **THEN** the commitments screen lists "Kopfweh"
- **AND** that directory's one file named `DayByDay.daybyday` holds one happening, named "Kopfweh"

### Requirement: A copy made before copies held happenings holds none, and a copy's happenings are read whole

What is written for a copy SHALL say a form later than the form copies were written in before they
held happenings. A file that reads as a copy's form and moment, in an earlier form, SHALL be read as
holding no happenings and SHALL NOT be refused for it. A copy of a later form SHALL be refused as a
damaged copy where it holds no happenings, where they do not read as the shape their form has, or
where they hold what a happening place could not hold: a name that says nothing, an identity that
is not one, two happenings with one name or one identity, or an occurrence of an identity none of
them has. Happenings of a form later than the happening store reads SHALL make the copy one from a
later version, whatever else it holds.

#### Scenario: a copy made before copies held happenings is read as holding none, and restoring it leaves the happening place holding none

- **WHEN** a happening named "Kopfweh" is added to a happening store at a happening place, with one
  occurrence noted there on 2 October 2026 at 09:10; a commitments screen is opened as of Saturday
  3 October 2026 at that happening place and at a record place, a roster place, a one-off place and
  a birthday place where nothing has been kept; and it is asked to restore from a file holding a
  copy in the form copies were written in before they held happenings, made on that day at 09:07,
  holding a roster of one commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** it is not refused, and the restore awaiting confirmation says the copy holds no happening
  and has stopped none
- **AND** once the restore is confirmed, a happening store opened at that happening place holds no
  happening and no occurrence, the screen lists no happening, and what it keeps is one entry, named
  "Gym"
- **AND** a copy made through that screen afterwards says a form later than the form that file was
  written in
- **AND** a file holding a copy in the form copies were written in before they held birthday ticks
  is read the same way, as holding no happenings

#### Scenario: a copy whose happenings do not fit together is refused as a damaged copy, and one whose happenings are of a later form as a copy from a later version

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a record place, a roster
  place, a one-off place, a birthday place and a happening place where nothing has been kept; a copy
  is made through it as of that day at 14:32; the happenings that copy holds are then made to hold
  one happening named "Kopfweh" and one occurrence of an identity no happening it holds has; and the
  screen is asked to restore from it
- **THEN** it is refused as a damaged copy, and no restore is awaiting confirmation
- **AND** a copy whose happenings hold two happenings named "Kopfweh" and "kopfweh", and one whose
  happenings are taken out of it, are each refused the same way
- **AND** a copy whose happenings say a form one later than the happening store writes is refused as
  a copy from a later version, and so is one holding such happenings beside a roster that lacks a
  field its form always writes

### Requirement: A commitments screen says how many happenings a restore takes away and brings, and counts no occurrence

Asking to restore SHALL write nothing at the happening place. What the restore awaiting
confirmation says SHALL count, for the copy and for the phone, the happenings held that are not
stopped and, apart from them, the happenings held that are stopped, and SHALL count no occurrence.
A stopped happening MUST NOT be counted among those not stopped. The phone's happenings SHALL be
read as a copy reads them. Where the phone's happenings cannot be read, for either cause, it SHALL
say so in place of both of the phone's happening counts, and SHALL give every other count, of the
phone and of the copy, as it gives it where they can be read.

#### Scenario: a commitments screen asked to restore says how many happenings the copy and the phone hold and have stopped, and counts no occurrence

- **WHEN** happenings named "Augenmigräne", "Kopfweh" and "Schlecht geschlafen" are added to a
  happening store at a happening place, "Schlecht geschlafen" is stopped there, and three
  occurrences of "Kopfweh" are noted there on 2 October 2026 with no time; a commitments screen is
  opened as of Saturday 3 October 2026 at that happening place and at a record place, a roster
  place, a one-off place and a birthday place where nothing has been kept; a copy is made through it
  as of that day at 14:32; "Augenmigräne" is then deleted through it, its name typed back, and
  "Kopfweh" stopped through it; and the screen is asked to restore from that copy
- **THEN** it is not refused, and the restore awaiting confirmation says the copy holds two
  happenings not stopped and has stopped one
- **AND** it says the phone holds none not stopped and has stopped two, and says no place that
  cannot be read
- **AND** the content at that happening place is byte-for-byte what it was immediately before it was
  asked

#### Scenario: a commitments screen asked to restore where the happening place cannot be read says the happenings cannot be read in place of their counts

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a record place, a roster
  place, a one-off place, a birthday place and a happening place where nothing has been kept; a copy
  is made through it as of that day at 14:32; what is at that happening place is then made a run of
  bytes that is not a happening store; and the screen is asked to restore from that copy
- **THEN** it is not refused
- **AND** the restore awaiting confirmation says the happenings cannot be read, gives the phone no
  count of happenings not stopped or stopped, and gives the phone every other count
- **AND** it gives the copy no happening not stopped and none stopped
- **AND** it says the same where the happening place holds a happening store written in a form one
  later than the form this app writes

### Requirement: A restore confirmed makes the happening place hold the copy's happenings, and nothing of what was there

Confirming a restore SHALL write the happenings and the occurrences the copy holds at the happening
place, in the form the happening store writes now, and no happening or occurrence held there before
SHALL remain or be merged, whether or not what was there could be read. Where the happening place
cannot be written, confirming SHALL be refused as a place that could not be written, and the
happening place and the other four places SHALL each be byte-for-byte what they were before it was
confirmed. A restore confirmed SHALL leave the screen reading the happening place afresh and listing
what it then holds, with no happening awaiting a stop or a deletion and nothing typed back to
delete one.

#### Scenario: a restore confirmed makes the happening place hold the copy's happenings, and the happenings there are gone

- **WHEN** a happening named "Kopfweh" is added to a happening store at a happening place, with one
  occurrence noted there on 2 October 2026 at 09:10; a commitments screen is opened as of Saturday
  3 October 2026 at that happening place and at a record place, a roster place, a one-off place and
  a birthday place where nothing has been kept; a copy is made through it as of that day at 14:32;
  "Kopfweh" is then renamed through it to "Spannungskopfweh" and a happening named "Augenmigräne"
  is made through it; and the screen is asked to restore from that copy and the restore is confirmed
- **THEN** it is not refused
- **AND** the content at that happening place is byte-for-byte what a happening store writes for
  "Kopfweh", the same happening it was, with one occurrence on 2 October 2026 at 09:10, and nothing
  else
- **AND** a restore of that copy confirmed where that happening place holds a run of bytes that is
  not a happening store leaves the same content there

#### Scenario: a commitments screen that restored a copy lists the copy's happenings, and no happening is awaiting a stop or a deletion

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are added to a happening store at a
  happening place, and "Kopfweh" is stopped there; a commitments screen is opened as of Saturday
  3 October 2026 at that happening place and at a record place, a roster place, a one-off place and
  a birthday place where nothing has been kept; a copy is made through it as of that day at 14:32;
  "Augenmigräne" is then deleted through it, its name typed back, and "Kopfweh" resumed through it;
  it is asked to delete "Kopfweh" and "Kopfweh" is typed back; and it is asked to restore from that
  copy and the restore is confirmed
- **THEN** it lists "Augenmigräne" and then "Kopfweh", says "Kopfweh" alone is stopped, and says it
  is keeping happenings
- **AND** no happening is awaiting a stop or deletion, and nothing is typed back to delete one
- **AND** a screen asked to stop "Kopfweh" rather than to delete it, before the restore was asked
  for, has no happening awaiting a stop afterwards
- **AND** a commitments screen opened where that happening place held a run of bytes that is not a
  happening store, and restoring that copy, lists the same and says it is keeping happenings
- **AND** a day screen of no commitments at all opened at those places before the restore, returned
  to from the commitments screen that restored it, lists "Augenmigräne" alone

#### Scenario: a restore refused where the happening place cannot be written leaves the five places as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Friday 2 October 2026 is kept at a
  record place; a one-off named "Book dentist" on 25 October 2026 is kept at a one-off place; a
  commitments screen is opened as of Saturday 3 October 2026 at those places, at a birthday place
  where nothing has been kept, and at a happening place where nothing can be written — a path
  beneath an existing ordinary file; and it is asked to restore from a copy holding a commitment
  named "Journaling" and a happening named "Kopfweh", and the restore is confirmed
- **THEN** it is refused as a place that could not be written
- **AND** the content at the record place, the roster place and the one-off place is byte-for-byte
  what it was immediately before the restore was confirmed, and nothing stands at the birthday place
  or at the happening place
- **AND** what it keeps is one entry, named "Gym", it lists no happening, it holds no copy restored
  and no restore is awaiting confirmation

### Requirement: A restore stopped before it was whole is undone at the happening place too

A restore SHALL keep what stood at the happening place, or that nothing stood there, in the restore
in progress it keeps before it writes anything. A restore stopped before it was whole SHALL be
undone at the happening place with the other four places when a commitments screen or a day screen
next opens them, before anything is read from them, putting back what stood at the happening place
before it began and saying nothing. A restore in progress kept before restores wrote the happening
place SHALL be undone leaving the happening place as it stands.

#### Scenario: a restore stopped before it was whole is undone at the happening place when the places are next opened

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a happening named "Kopfweh" is added to a happening
  store at a happening place; a restore of a copy holding a commitment named "Journaling" and a
  happening named "Augenmigräne", and nothing else, is left having written the record place, the
  roster place, the one-off place, the birthday place and the happening place, with the restore in
  progress it left standing; and a commitments screen is opened at those places as of Saturday
  3 October 2026
- **THEN** what it keeps is one entry, named "Gym", and it lists "Kopfweh" alone
- **AND** the content at all five places is byte-for-byte what it was before that restore began, and
  no restore in progress stands
- **AND** a day screen of no commitments at all opened at those places instead, on that day, lists
  "Kopfweh" alone, and so does one opened there before that restore was left and returned to after
- **AND** a restore in progress kept in the form it had before restores wrote the happening place,
  standing beside that record place instead, is undone the same way and leaves the content at the
  happening place byte-for-byte what it was

### Requirement: A change a person keeps to a happening or an occurrence writes a copy at the copy place

Where a copy place is set, the app SHALL write a copy there after every change a person keeps at the
happening place, as of the moment its clock answers once that change is kept: a happening made,
renamed, stopped, resumed or deleted through a commitments screen, and an occurrence noted, changed
or taken back through a day screen. That copy SHALL hold the happenings as they then stand. A
change that is refused, and one that asks for no change, SHALL write no copy and SHALL leave the
last copy as it was, and so SHALL asking for a stop or a deletion, typing a name back, and
cancelling either. A copy that cannot be made SHALL refuse no happening change, as it refuses no
other change.

#### Scenario: a happening made, renamed, stopped, resumed and deleted through a commitments screen each write a copy at the copy place

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a record place, a roster
  place, a one-off place, a birthday place and a happening place where nothing has been kept,
  keeping its copy place at a place of its own and asking a clock that answers a later minute each
  time it is asked, from that day at 14:32; a directory of its own is given to it as its copy place;
  and a happening named "Kopfweh" is made through it, renamed "Spannungskopfweh", stopped, resumed,
  and deleted with its name typed back
- **THEN** none of the five is refused
- **AND** the copy at that directory after each of the five holds happenings in exactly the state
  that change left at the happening place
- **AND** the last copy made after the deletion is Saturday 3 October 2026 at 14:37, and holds no
  happening at all

#### Scenario: an occurrence noted, changed and taken back on a day screen each write a copy at the copy place

- **WHEN** a day screen of no commitments at all is opened as of Saturday 3 October 2026 at a
  happening place holding "Kopfweh" and at a record place, a roster place, a one-off place and a
  birthday place where nothing has been kept, keeping its copy place at a place of its own and
  asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  directory of its own is given as its copy place through a commitments screen opened at those same
  places; and "Kopfweh" is noted through it at 09:10 with the note "links", that occurrence is
  changed through it to 08:00 with no note, and it is then taken back through it, it being 18:52 on
  that day
- **THEN** none of the three is refused
- **AND** the copy at that directory after the note holds one occurrence of "Kopfweh" on
  3 October 2026 at 09:10 with the note "links", after the change one at 08:00 with no note, and
  after the take-back none
- **AND** the last copy made after the take-back is Saturday 3 October 2026 at 14:35

#### Scenario: a happening change refused, or one that asks for no change, writes no copy at the copy place

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a happening place holding
  "Kopfweh" with one occurrence noted on 2 October 2026 at 09:10 with no note, and at a record place,
  a roster place, a one-off place and a birthday place where nothing has been kept, keeping its copy
  place at a place of its own and asking a clock that answers a later minute each time it is asked,
  from that day at 14:32; a directory of its own is given to it as its copy place; a happening is
  made through it from the name "kopfweh" and refused; "Kopfweh" is renamed through it to
  " Kopfweh "; it is asked to stop "Kopfweh" and the stop is cancelled; and it is asked to delete
  "Kopfweh", "Kopfweh" is typed back and the deletion is cancelled
- **THEN** the last copy made is still Saturday 3 October 2026 at 14:32, and no stop stands
- **AND** a day screen opened at those places with that copy place, through which "Kopfweh" is
  noted at 18:53, it being 18:52 on that day, is refused as not yet come and leaves the last copy
  made at that same moment
- **AND** that occurrence on 2 October 2026 changed through that day screen to 09:10 with no note
  asks for no change and leaves the last copy made at that same moment too

#### Scenario: an occurrence noted where the copy place cannot be written is kept and is not refused

- **WHEN** a day screen of no commitments at all is opened as of Saturday 3 October 2026 at a
  happening place holding "Kopfweh" and at a record place, a roster place, a one-off place and a
  birthday place where nothing has been kept, keeping its copy place at a place of its own and
  asking a clock that answers a later minute each time it is asked, from that day at 14:32; a
  directory that cannot be written to is given as its copy place through a commitments screen opened
  at those same places; and "Kopfweh" is noted through it at 09:10, it being 18:52 on that day
- **THEN** noting it is not refused, and a happening store opened at that place holds that occurrence
- **AND** the stop is the folder that cannot be written, as of Saturday 3 October 2026 at 14:32
- **AND** a happening named "Augenmigräne" then made through that commitments screen is not
  refused, and the stop keeps that moment

## RENAMED Requirements

- FROM: `### Requirement: A take-out is the files at the four places exactly as they lie`
- TO: `### Requirement: A take-out is the files at the five places exactly as they lie`

## MODIFIED Requirements

### Requirement: A take-out is the files at the five places exactly as they lie

A take-out SHALL be the file standing at each of the record place, the roster place, the one-off
place, the birthday place and the happening place, each as it lies and under the name it lies under, together
with a save in progress and a restore in progress still standing beside them. A place where no file
stands SHALL contribute none and SHALL NOT refuse the take-out. Forming a take-out SHALL read no
store as a value, SHALL bring nothing to the form the app writes now, SHALL undo no save in progress
and no restore in progress, and SHALL leave every one of those files byte-for-byte as it found them.
The copy place SHALL NOT be taken out.

#### Scenario: a take-out hands out the three files byte-for-byte under the names they lie under

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a one-off named "Book dentist" on 25 September 2026
  is kept at a one-off place; what is at the record place beside them is made a run of bytes that is
  not a record; and a commitments screen opened at those three places as of Monday 31 August 2026 is
  asked for a take-out, written into a directory of its own
- **THEN** it is not refused, and three files stand there, named as the files at the three places are
  named
- **AND** each holds byte-for-byte what stands at the place it was taken from
- **AND** a take-out of a roster kept in the earliest form a roster store reads hands out those same
  bytes, unchanged

#### Scenario: a take-out where nothing has been kept at a place hands out only the files that stand

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a run
  of bytes that is not a roster, and at a record place and a one-off place where nothing has been
  kept, and it is asked for a take-out, written into a directory of its own
- **THEN** it is not refused, and one file stands there, holding byte-for-byte what is at that roster
  place
- **AND** nothing is written at the record place or the one-off place

#### Scenario: a take-out hands out a save in progress and a restore in progress that could not be undone

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a run of bytes that is not a save in progress and a
  run of bytes that is not a restore in progress are each kept where one is kept beside the record
  place; and a commitments screen opened at those places and at a one-off place where nothing has
  been kept as of Monday 31 August 2026 is asked for a take-out, written into a directory of its own
- **THEN** it is not refused, and the file at the roster place, the save in progress and the restore
  in progress each stand there, byte-for-byte as they lie
- **AND** the save in progress and the restore in progress are still at their places, byte-for-byte
  what they were

#### Scenario: a take-out does not hand out the copy place

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a record place holding a run
  of bytes that is not a record, and at a roster place and a one-off place where nothing has been
  kept, keeping its copy place at a place of its own in the directory those three stand in and asking
  a clock that answers that day at 14:32; a directory of its own is given to it as its copy place;
  and it is asked for a take-out, written into a directory of its own
- **THEN** it is not refused, and one file stands there, holding byte-for-byte what is at that record
  place
- **AND** nothing it hands out was taken from the place the copy place is kept at, and the copy place
  still says the folder it was given

#### Scenario: a take-out hands out the file at the birthday place byte-for-byte under the name it lies under

- **WHEN** the birthday of the contact "kate" worded "Kate Bell's 48th Birthday" on 25 September 2026
  is ticked at a birthday place; what is at a record place is made a run of bytes that is not a
  record; and a commitments screen opened at those two places and at a roster place and a one-off
  place where nothing has been kept as of Monday 31 August 2026 is asked for a take-out, written into
  a directory of its own
- **THEN** it is not refused, and two files stand there, named as the files at the record place and
  the birthday place are named
- **AND** the one named as the file at the birthday place holds byte-for-byte what stands there

#### Scenario: a take-out hands out the file at the happening place byte-for-byte under the name it lies under

- **WHEN** a happening named "Kopfweh" is added to a happening store at a happening place, with one
  occurrence noted there on 2 October 2026 at 09:10; what is at a record place is made a run of
  bytes that is not a record; and a commitments screen opened at those two places and at a roster
  place, a one-off place and a birthday place where nothing has been kept as of Saturday
  3 October 2026 is asked for a take-out, written into a directory of its own
- **THEN** it is not refused, and two files stand there, named as the files at the record place and
  the happening place are named
- **AND** the one named as the file at the happening place holds byte-for-byte what stands there

### Requirement: A commitments screen offers a take-out only while a store cannot be read, and says which

A commitments screen SHALL offer a take-out exactly while at least one of its five places cannot be
read, whether what lies there is not a store of its kind or was written by a later version of
DayByDay; where all five read it SHALL offer none. With the offer it SHALL say every place that
cannot be read, in the order record, roster, one-offs, birthday ticks, happenings, and for each SHALL say which
of the two is so. It SHALL read the five places when it is opened, when the app is shown
again and when a restore is confirmed, and MUST NOT read them because it is drawn. A screen holding
a save in progress or a restore in progress it could not undo SHALL say the record, the roster and
the one-offs could not be read, and the birthday ticks and the happenings only where they cannot.

#### Scenario: a commitments screen whose three places all read offers no take-out

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place, and a commitments screen is opened at that roster
  place, a record place and a one-off place where nothing has been kept as of Monday 31 August 2026
- **THEN** it offers no take-out, and says no place that could not be read

#### Scenario: a commitments screen offers a take-out naming every place that cannot be read, in the order record, roster, one-offs

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a record place, a roster
  place and a one-off place each holding a run of bytes that is not a store of its kind
- **THEN** it offers a take-out, and says the record, then the roster, then the one-offs, each as a
  place that could not be read
- **AND** a screen opened where only the one-off place holds such a run of bytes offers one and says
  the one-offs alone

#### Scenario: a commitments screen offers a take-out over a store written by a later version, and says so rather than that it could not be read

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a
  roster written in a form one later than the form this app writes, and at a record place and a
  one-off place where nothing has been kept
- **THEN** it offers a take-out, and says the roster as a place written by a later version of
  DayByDay, told apart from one that could not be read
- **AND** a screen opened where the record place holds a record written in a later form and the
  one-off place holds a run of bytes that is not a one-off holder says the record as written by a
  later version and the one-offs as a place that could not be read

#### Scenario: a commitments screen shown again says what the three places then hold

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place, a record
  place and a one-off place where nothing has been kept; what is at that record place is then made a
  run of bytes that is not a record; and the screen is shown again as of that same day
- **THEN** it offered no take-out before it was shown again, and offers one afterwards, saying the
  record
- **AND** with what is at that record place then made readable, it still offers one until it is shown
  again, and offers none once it is

#### Scenario: a commitments screen that confirmed a restore offers no take-out

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a record place holding a run
  of bytes that is not a record, and at a roster place and a one-off place where nothing has been
  kept; and it is asked to restore from a copy made on that day at 14:32 holding a roster of one
  commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026, and the
  restore is confirmed
- **THEN** it offered a take-out before the restore was confirmed, and offers none afterwards

#### Scenario: a commitments screen holding a save in progress it could not undo offers a take-out naming all three

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a run of bytes that is not a save in progress is kept
  where one is kept beside a record place where nothing has been kept; and a commitments screen is
  opened at those places and at a one-off place where nothing has been kept as of Monday 31 August
  2026
- **THEN** it offers a take-out, and says the record, the roster and the one-offs, each as a place
  that could not be read

#### Scenario: a commitments screen offers a take-out over birthday ticks that cannot be read, naming them after the one-offs

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a record place, a roster
  place and a one-off place where nothing has been kept, and a birthday place holding a run of bytes
  that is not what birthday ticks are written as
- **THEN** it offers a take-out, and says the birthday ticks alone, as a place that could not be read
- **AND** a screen opened where the one-off place also holds a run of bytes that is not a one-off
  holder says the one-offs and then the birthday ticks
- **AND** a screen opened where the birthday place holds birthday ticks written in a form one later
  than the form this app writes says the birthday ticks as written by a later version of DayByDay,
  told apart from ones that could not be read

#### Scenario: a commitments screen holding a restore in progress it could not undo names the birthday ticks only where they cannot be read

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; the birthday of the contact "kate" worded "Kate
  Bell's 48th Birthday" on 25 September 2026 is ticked at a birthday place; a run of bytes that is
  not a restore in progress is kept where one is kept beside a record place where nothing has been
  kept; and a commitments screen is opened at those places and at a one-off place where nothing has
  been kept as of Monday 31 August 2026
- **THEN** it offers a take-out, and says the record, the roster and the one-offs, each as a place
  that could not be read, and says nothing of the birthday ticks
- **AND** with that birthday place holding a run of bytes that is not what birthday ticks are written
  as instead, it says the record, the roster, the one-offs and then the birthday ticks

#### Scenario: a commitments screen offers a take-out over happenings that cannot be read, naming them after the birthday ticks

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a record place, a roster
  place, a one-off place and a birthday place where nothing has been kept, and a happening place
  holding a run of bytes that is not a happening store
- **THEN** it offers a take-out, and says the happenings alone, as a place that could not be read
- **AND** a screen opened where the birthday place also holds a run of bytes that is not what
  birthday ticks are written as says the birthday ticks and then the happenings
- **AND** a screen opened where the happening place holds a happening store written in a form one
  later than the form this app writes says the happenings as written by a later version of DayByDay,
  told apart from ones that could not be read
- **AND** a screen holding a restore in progress it could not undo says the record, the roster and
  the one-offs and nothing of the happenings where the happening place holds "Kopfweh", and says the
  happenings after the one-offs where it holds that run of bytes

### Requirement: A commitments screen takes out the files when it is asked, and holds nothing about one it took out

Asked for a take-out, a commitments screen SHALL write every file that take-out holds where it is
given to write take-outs into, each under the name it lies under at its place, and SHALL answer where
each was written, in the order record, roster, one-offs, birthday ticks, happenings, save in progress, restore in progress. It
SHALL write nothing else anywhere, and a take-out it makes MUST NOT stand where the files of another
it made stand. Asked for one where it offers none, it SHALL hand out nothing and write nothing. A
take-out it made SHALL leave the screen exactly as it was: what it keeps, what it has stopped, the
commitment awaiting confirmation, the commitment awaiting deletion, the name typed back and the
refused change it holds SHALL each be what they were, and it SHALL say nothing of its own about a
take-out it made.

#### Scenario: a commitments screen asked for a take-out answers where every file was written, in the order record, roster, one-offs

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a one-off named "Book dentist" on 25 September 2026
  is kept at a one-off place; what is at the record place beside them is made a run of bytes that is
  not a record; and a commitments screen opened at those three places as of Monday 31 August 2026 is
  asked for a take-out, written into a directory of its own
- **THEN** it answers three places, the record's first, then the roster's, then the one-offs', and a
  file stands at each
- **AND** the directory it was given holds those three files and no other

#### Scenario: a take-out made leaves a commitments screen's lists and what it is awaiting exactly as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, and one named "Journaling" alike in every other way are taken on at a roster place;
  "Journaling" is stopped there as of Sunday 30 August 2026; a one-off place beside them is made a
  run of bytes that is not a one-off holder; a commitments screen is opened at those places and at a
  record place where nothing has been kept as of Monday 31 August 2026; it is asked to delete "Gym"
  and "Gym" is typed back; and a take-out is asked for
- **THEN** what it keeps is one entry, named "Gym", and what it has stopped is one entry, named
  "Journaling"
- **AND** "Gym" is still awaiting deletion, with "Gym" still typed back
- **AND** nothing is awaiting confirmation

#### Scenario: a take-out made leaves a refused change standing and says nothing of its own

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a one-off place beside it is made a run of bytes
  that is not a one-off holder; a commitments screen is opened at those places and at a record place
  where nothing has been kept as of Monday 31 August 2026; a second commitment named "Gym" on that
  same rhythm and day is defined through it and refused for its name; and a take-out is asked for
- **THEN** the take-out is not refused, and the screen still holds that refused definition against
  defining a commitment
- **AND** it says nothing of its own about the take-out it made

#### Scenario: a take-out asked for where a commitments screen offers none hands out nothing and writes nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place, and a commitments screen opened at that roster
  place, a record place and a one-off place where nothing has been kept as of Monday 31 August 2026
  is asked for a take-out, written into a directory of its own
- **THEN** it answers no place at all, and is not refused
- **AND** no file stands in that directory, and the content at the roster place is byte-for-byte what
  it was immediately after the screen was opened

#### Scenario: a take-out asked for twice leaves the files of the first standing

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a run
  of bytes that is not a roster, and at a record place and a one-off place where nothing has been
  kept; a take-out is asked for, written into a directory of its own; and a take-out is asked for
  again, written into that same directory
- **THEN** neither is refused, and the two answer different places
- **AND** the file the first answered still holds byte-for-byte what it held

#### Scenario: a commitments screen asked for a take-out answers the birthday ticks' file after the one-offs' and before a save in progress

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a one-off named "Book dentist" on 25 September 2026
  is kept at a one-off place; the birthday of the contact "kate" worded "Kate Bell's 48th Birthday"
  on 25 September 2026 is ticked at a birthday place; a run of bytes that is not a save in progress
  is kept where one is kept beside a record place where nothing has been kept; and a commitments
  screen opened at those four places as of Monday 31 August 2026 is asked for a take-out, written
  into a directory of its own
- **THEN** it answers four places: the roster's, then the one-offs', then the birthday ticks', then
  the save in progress's
- **AND** the directory it was given holds those four files and no other

#### Scenario: a commitments screen asked for a take-out answers the happenings' file after the birthday ticks' and before a save in progress

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; the birthday of the contact "kate" worded "Kate
  Bell's 48th Birthday" on 25 September 2026 is ticked at a birthday place; a happening named
  "Kopfweh" is added to a happening store at a happening place; a run of bytes that is not a save in
  progress is kept where one is kept beside a record place where nothing has been kept; and a
  commitments screen opened at those places and at a one-off place where nothing has been kept as
  of Saturday 3 October 2026 is asked for a take-out, written into a directory of its own
- **THEN** it answers four places: the roster's, then the birthday ticks', then the happenings',
  then the save in progress's
- **AND** the directory it was given holds those four files and no other

### Requirement: A take-out that cannot be made hands out nothing and leaves the places as they were

Where a file the take-out holds cannot be handed over as it lies, or where the files cannot be
written where they are to be written, a commitments screen SHALL hand out no file at all and SHALL
answer why: a store that could not be taken out, naming it, or a place that could not be written,
naming none, told apart from one another. A save in progress and a restore in progress SHALL each be
named as the record, the place they stand beside. It SHALL leave no file of its own where it was to
write, and the record place, the roster place, the one-off place, the birthday place, the happening place and both in-progress
files SHALL be byte-for-byte what they were. What the screen then holds about the refused take-out is the refused
change it holds for every other change it would not make.

#### Scenario: a take-out refused names the store that could not be taken out and hands out none of the others

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; the record place beside it is made a directory
  holding nothing rather than a file; and a commitments screen opened at those places and at a
  one-off place where nothing has been kept as of Monday 31 August 2026 is asked for a take-out,
  written into a directory of its own
- **THEN** it is refused as a store that could not be taken out, naming the record
- **AND** no file stands in that directory
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened
- **AND** a take-out refused over a save in progress that cannot be handed over is refused the same
  way, naming the record

#### Scenario: a take-out that cannot be written where it is to be written is refused as a place that could not be written

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a run
  of bytes that is not a roster, and at a record place and a one-off place where nothing has been
  kept, and it is asked for a take-out, written into a directory that cannot be written to
- **THEN** it is refused as a place that could not be written, told apart from a store that could not
  be taken out, and naming no store
- **AND** no file stands in that directory

#### Scenario: a take-out refused replaces the refused change a commitments screen held

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place,
  a record place where nothing has been kept, and a one-off place holding a run of bytes that is not
  a one-off holder as of Monday 31 August 2026; a second commitment named "Gym" on that same rhythm
  and day is defined through it and refused for its name; and a take-out is asked for, written into
  a directory that cannot be written to
- **THEN** the screen holds the refused take-out, and no longer holds the refused definition

#### Scenario: a take-out refused over the birthday place names the birthday ticks and hands out none of the others

- **WHEN** a roster place holds a run of bytes that is not a roster; a birthday place beside it is
  made a directory holding nothing rather than a file; and a commitments screen opened at those places
  and at a record place and a one-off place where nothing has been kept as of Monday 31 August 2026
  is asked for a take-out, written into a directory of its own
- **THEN** it is refused as a store that could not be taken out, naming the birthday ticks
- **AND** no file stands in that directory
- **AND** the content at that roster place is byte-for-byte what it was, and that birthday place is
  still a directory holding nothing

#### Scenario: a take-out refused over the happening place names the happenings and hands out none of the others

- **WHEN** a roster place holds a run of bytes that is not a roster; a happening place beside it is
  made a directory holding nothing rather than a file; and a commitments screen opened at those
  places and at a record place, a one-off place and a birthday place where nothing has been kept as
  of Saturday 3 October 2026 is asked for a take-out, written into a directory of its own
- **THEN** it is refused as a store that could not be taken out, naming the happenings
- **AND** no file stands in that directory
- **AND** the content at that roster place is byte-for-byte what it was, and that happening place is
  still a directory holding nothing

### Requirement: A day screen that is not keeping a store says a copy can be restored and where

A day screen SHALL say that a copy can be restored and SHALL name Settings as where,
exactly while it could not read its record, could not read its one-offs, is not keeping its roster
for either of that roster's two causes, says its birthday ticks could not be read, or is not keeping
its happenings for a cause that is not a later version of DayByDay. However many of the five are so, it SHALL say it once and no more. It MUST NOT say it where the only store it is not
keeping was written by a later version of DayByDay, and MUST NOT say it where it is keeping all three
and its happenings and does not say its birthday ticks could not be read. What it says SHALL be words alone,
offering nothing to act on, and saying it SHALL read no place and change nothing.

#### Scenario: a day screen that cannot read its record says a copy can be restored and where

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place holding a run of
  bytes that is not a record, with a roster place and a one-off place where nothing has been kept, of
  a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** it says a copy can be restored, and names Settings as where
- **AND** a day screen that is not keeping its roster, and one that cannot read its one-offs, each say
  the same
- **AND** a day screen that cannot read its record beside a roster written by a later version of
  DayByDay says the same

#### Scenario: a day screen not keeping any of its three stores says a copy can be restored once

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place, a roster place and
  a one-off place each holding a run of bytes that is not a store of its kind, of a commitment named
  "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** it says a copy can be restored, once and no more, whatever the number of stores it is not
  keeping

#### Scenario: a day screen whose only store not kept was written by a later version says nothing about restoring a copy

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place holding a record
  written in a form one later than the form this app writes, with a roster place and a one-off place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing all seven weekdays,
  kept from 1 January 2026
- **THEN** it does not say a copy can be restored
- **AND** a day screen whose roster alone, and one whose one-offs alone, were written in a form one
  later than the form this app writes each say nothing about restoring a copy either

#### Scenario: a day screen keeping all three of its stores says nothing about restoring a copy

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place, a roster place and
  a one-off place where nothing has been kept, of a commitment named "Gym" on a schedule listing all
  seven weekdays, kept from 1 January 2026
- **THEN** it does not say a copy can be restored
- **AND** a day screen that could not read its record, once what is at that place is made readable and
  the app is shown again, says nothing about restoring a copy either

#### Scenario: a day screen that says its birthday ticks could not be read says a copy can be restored, and says nothing of it while birthdays are off

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at a record
  place, a roster place and a one-off place where nothing has been kept and a birthday place holding
  a run of bytes that is not what birthday ticks are written as, with birthdays on and a calendar
  holding the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 20 January 2026
- **THEN** it says its birthday ticks could not be read, and says a copy can be restored, naming Settings
  as where
- **AND** with its record place also holding a run of bytes that is not a record, it says so once and
  no more
- **AND** a day screen opened the same way with birthdays off, one whose calendar cannot be read, and
  one whose birthday place holds birthday ticks written in a form one later than the form this app
  writes each say nothing about restoring a copy

#### Scenario: a day screen that cannot read its happenings says a copy can be restored, and says nothing of it where they were written by a later version

- **WHEN** a day screen of no commitments at all is opened as of Saturday 3 October 2026 at a record
  place, a roster place, a one-off place and a birthday place where nothing has been kept and a
  happening place holding a run of bytes that is not a happening store
- **THEN** it says it is not keeping happenings, and says a copy can be restored, naming Settings as
  where
- **AND** with its record place also holding a run of bytes that is not a record, it says so once and
  no more
- **AND** a day screen opened the same way at a happening place holding a happening store written in
  a form one later than the form this app writes says nothing about restoring a copy
