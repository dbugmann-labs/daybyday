## ADDED Requirements

### Requirement: A copy holds the birthday ticks at the birthday place, and is refused whole where they cannot be read

Forming a copy SHALL read the birthday place when the copy is asked for, whether or not birthdays are
on, and the copy SHALL hold every birthday tick kept there. A birthday place where nothing has been kept SHALL count as
holding no ticks and SHALL NOT refuse the copy. Where the birthday ticks cannot be read, or were
written by a later version of DayByDay, the copy SHALL be refused whole for that cause, and the
store named SHALL be the birthday ticks only where the record, the roster and the one-offs could all
be read; a copy the app makes on its own at the copy place SHALL stop naming them the same way.
Forming a copy SHALL leave the birthday place as it found it.

#### Scenario: a copy holds the birthday ticks the birthday place holds, and none where nothing has been kept there

- **WHEN** the birthday of the contact "kate" worded "Kate Bell's 48th Birthday" on 25 September 2026
  is ticked at a birthday place; a commitments screen is opened as of Monday 31 August 2026 at that
  birthday place and at a record place, a roster place and a one-off place where nothing has been
  kept; and a copy is asked for as of that day at 14:32, written into a directory of its own
- **THEN** the copy is not refused
- **AND** what is written holds the contact "kate"'s birthday on 25 September 2026 ticked, and no
  other birthday tick
- **AND** the content at that birthday place is byte-for-byte what it was immediately after the
  screen was opened
- **AND** a copy asked for the same way where nothing has been kept at the birthday place is not
  refused, holds no birthday ticks, and leaves nothing written at that birthday place

#### Scenario: a copy is refused whole where the birthday ticks cannot be read, naming them only where the other three stores read

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened as of Monday
  31 August 2026 at that roster place, a record place and a one-off place where nothing has been
  kept, and a birthday place holding a run of bytes that is not what birthday ticks are written as;
  and a copy is asked for as of that day at 14:32, written into a directory of its own
- **THEN** it is refused as a store that could not be read, naming the birthday ticks
- **AND** no file stands in that directory, and the content at that birthday place is byte-for-byte
  what it was before the copy was asked for
- **AND** a copy asked for where the birthday place holds birthday ticks written in a form one later
  than the form this app writes is refused as a store written by a later version of DayByDay, naming
  the birthday ticks
- **AND** a copy asked for where the one-off place is also a run of bytes that is not a one-off
  holder is refused as a store that could not be read, naming the one-offs

#### Scenario: a change kept where the birthday ticks cannot be read is kept, and the stop names the birthday ticks

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen is opened at that roster place and at a
  record place, a one-off place and a birthday place where nothing has been kept as of Monday
  31 August 2026, keeping its copy place at a place of its own and asking a clock that answers a
  later minute each time it is asked, from that day at 14:32; a directory of its own is given as its
  copy place through a commitments screen opened at those same places; what is at that birthday place
  is then made a run of bytes that is not what birthday ticks are written as; and the row named "Gym"
  is ticked
- **THEN** the tick is not refused, and a record store opened at that record place holds that tick
- **AND** the stop is a store that could not be read, naming the birthday ticks, as of Monday
  31 August 2026 at 14:33
- **AND** with birthday ticks written in a form one later than the form this app writes made to
  stand there instead, the stop is a store written by a later version of DayByDay, naming the
  birthday ticks

### Requirement: A commitments screen and a copy place keep the birthday ticks where a day screen keeps them

A commitments screen and a copy place SHALL read and write birthday ticks at the birthday place a day
screen keeps them at. A day screen, a commitments screen and a copy place opened at the same record
place and given no birthday place SHALL each keep birthday ticks at the same place, and that place
SHALL be the one a day screen keeps them at by default wherever the record place is the one it keeps
its record at by default.

#### Scenario: a day screen, a commitments screen and a copy place given no birthday place keep their birthday ticks at the same place

- **WHEN** a day screen of no commitments at all and a commitments screen are opened as of Tuesday
  20 January 2026 at a record place, a roster place and a one-off place in one directory of their own
  where nothing has been kept, each given no birthday place, the day screen with birthdays on and a
  calendar holding the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 20 January
  2026, and a copy place opened the same way, asking a clock that answers a later minute each time
  it is asked from that day at 14:32, is handed to both; a directory of its own is given as the copy
  place through the commitments screen; and the day screen's one birthday row is ticked
- **THEN** the copy at that directory holds the contact "kate"'s birthday on 20 January 2026 ticked
- **AND** a copy asked for through the commitments screen as of that day at 14:40 holds it too
- **AND** the birthday place a day screen given no birthday place keeps beside the place it keeps its
  record at by default is the place it keeps its birthday ticks at by default

### Requirement: A copy made before copies held birthday ticks holds none, and a copy's birthday ticks are read whole

What is written for a copy SHALL say a form later than the form copies were written in before they
held birthday ticks. A file that reads as a copy's form and moment, in that earlier form, SHALL be
read as holding no birthday ticks and SHALL NOT be refused for it. A copy of a later form SHALL be
refused as a damaged copy where it holds no birthday ticks, where they do not read as the shape their
form has, or where they hold what could not be a tick: a contact that says nothing, a day that names
no day, or two ticks alike in contact and day. Birthday ticks of a form later than the birthday store
reads SHALL make the copy one from a later version, whatever else it holds. A refused file SHALL
leave no restore awaiting confirmation.

#### Scenario: a copy made before copies held birthday ticks is read as holding none, and restoring it leaves the birthday place holding none

- **WHEN** the birthday of the contact "kate" worded "Kate Bell's 48th Birthday" on 25 September 2026
  is ticked at a birthday place; a commitments screen is opened as of Monday 31 August 2026 at that
  birthday place and at a record place, a roster place and a one-off place where nothing has been
  kept; and it is asked to restore from a file holding a copy in the form copies were written in
  before they held birthday ticks, made on that day at 09:07, holding a roster of one commitment named
  "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** it is not refused, and the restore awaiting confirmation says the copy keeps one
  commitment, has stopped none and holds no one-offs
- **AND** once the restore is confirmed, a birthday store opened at that birthday place holds no
  ticks, and what the screen keeps is one entry, named "Gym"
- **AND** a copy made through that screen afterwards says a form later than the form that file was
  written in

#### Scenario: a copy whose birthday ticks do not read is refused as a damaged copy, and one whose birthday ticks are of a later form as a copy from a later version

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a record place, a roster
  place, a one-off place and a birthday place where nothing has been kept; a copy is made through it
  as of that day at 14:32; the birthday ticks that copy holds are then taken out of it; and the
  screen is asked to restore from it
- **THEN** it is refused as a damaged copy, and no restore is awaiting confirmation
- **AND** a copy whose birthday ticks hold two ticks both of the contact "kate" on 25 September 2026,
  and one whose birthday ticks hold one tick of a contact of blank space alone, are each refused the
  same way
- **AND** a copy whose birthday ticks say a form one later than the birthday store writes is refused
  as a copy from a later version, and so is one holding such birthday ticks beside a roster that
  lacks a field its form always writes

### Requirement: A restore puts the copy's birthday ticks at the birthday place, and counts none of them

Asking to restore SHALL write nothing at the birthday place, and what the restore awaiting
confirmation says SHALL count no birthday tick, of the copy or of the phone. Where the phone's
birthday ticks cannot be read, for either cause, it SHALL say so after what it says of the one-offs,
and only then. Confirming a
restore SHALL write the birthday ticks the copy holds at the birthday place, in the form the birthday
store writes now, whether or not birthdays are on, and no tick held there before SHALL remain or be
merged, whether or not what was there could be read. Where the birthday place cannot be written,
confirming SHALL be refused as a place that could not be written, and the birthday place and the
other three places SHALL each be byte-for-byte what they were before it was confirmed.

#### Scenario: a commitments screen asked to restore counts no birthday tick, and says the phone's birthday ticks cannot be read only where they cannot

- **WHEN** the birthday of the contact "kate" worded "Kate Bell's 48th Birthday" on 25 September 2026
  is ticked at a birthday place; a commitments screen is opened as of Monday 31 August 2026 at that
  birthday place and at a record place, a roster place and a one-off place where nothing has been
  kept; a copy is made through it as of that day at 14:32; the birthday of the contact "john" worded
  "John Appleseed's 40th Birthday" on 26 September 2026 is then ticked at that birthday place; and the
  screen is asked to restore from that copy
- **THEN** it is not refused, and the restore awaiting confirmation says the copy keeps no
  commitments, has stopped none and holds no one-offs, and says the same of the phone
- **AND** it says no place that cannot be read
- **AND** the content at that birthday place is byte-for-byte what it was immediately before it was
  asked
- **AND** where what is at that birthday place is instead made a run of bytes that is not what
  birthday ticks are written as before it is asked, it says the birthday ticks cannot be read and
  gives the phone every count as before, and it says the same where the birthday place holds birthday
  ticks written in a form one later than the form this app writes

#### Scenario: a restore confirmed makes the birthday place hold the copy's birthday ticks, and the ticks there are gone

- **WHEN** the birthday of the contact "kate" worded "Kate Bell's 48th Birthday" on 25 September 2026
  is ticked at a birthday place; a commitments screen is opened as of Monday 31 August 2026 at that
  birthday place and at a record place, a roster place and a one-off place where nothing has been
  kept; a copy is made through it as of that day at 14:32; the tick of Kate's birthday is then taken
  back at that birthday place and the birthday of the contact "john" worded "John Appleseed's 40th
  Birthday" on 26 September 2026 is ticked there; and the screen is asked to restore from that copy
  and the restore is confirmed
- **THEN** it is not refused
- **AND** the content at that birthday place is byte-for-byte what a birthday store writes for ticks
  holding the contact "kate"'s birthday on 25 September 2026 and nothing else
- **AND** a restore of that copy confirmed where that birthday place holds a run of bytes that is not
  what birthday ticks are written as leaves the same content there

#### Scenario: a restore refused where the birthday place cannot be written leaves the four places as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Sunday 30 August 2026 is kept at a
  record place; a one-off named "Book dentist" on 25 September 2026 is kept at a one-off place; a
  commitments screen is opened as of Monday 31 August 2026 at those places and at a birthday place
  where nothing can be written — a path beneath an existing ordinary file; and it is asked to restore
  from a copy holding a commitment named "Journaling" and the contact "kate"'s birthday on
  25 September 2026 ticked, and the restore is confirmed
- **THEN** it is refused as a place that could not be written
- **AND** the content at the record place, the roster place and the one-off place is byte-for-byte
  what it was immediately before the restore was confirmed, and nothing stands at the birthday place
- **AND** what it keeps is one entry, named "Gym", it holds no copy restored and no restore is
  awaiting confirmation

### Requirement: A restore stopped before it was whole is undone at the birthday place too

A restore SHALL keep what stood at the birthday place, or that nothing stood there, in the restore in
progress it keeps before it writes anything. A restore stopped before it was whole SHALL be undone at
the birthday place with the other three places when a commitments screen or a day screen next opens
them, before anything is read from them, putting back what stood at the birthday place before it
began and saying nothing. A restore in progress kept before restores wrote the birthday place SHALL
be undone leaving the birthday place as it stands.

#### Scenario: a restore stopped before it was whole is undone at the birthday place when the places are next opened

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; the birthday of the contact "kate" worded "Kate
  Bell's 48th Birthday" on 25 September 2026 is ticked at a birthday place; a restore of a copy
  holding a commitment named "Journaling" and the contact "john"'s birthday on 26 September 2026
  ticked, and nothing else, is left having written the record place, the roster place, the one-off
  place and the birthday place, with the restore in progress it left standing; and a commitments
  screen is opened at those places as of Monday 31 August 2026
- **THEN** what it keeps is one entry, named "Gym"
- **AND** the content at all four places is byte-for-byte what it was before that restore began, and
  no restore in progress stands
- **AND** a restore in progress kept in the form it had before restores wrote the birthday place,
  standing beside that record place instead, is undone the same way and leaves the content at the
  birthday place byte-for-byte what it was

### Requirement: A birthday tick kept on a day screen writes a copy at the copy place

Where a copy place is set, a day screen SHALL write a copy there after every birthday tick it makes
or takes back and keeps at its birthday place, as of the moment its clock answers once the tick is
kept, and that copy SHALL hold the birthday ticks as they then stand. A birthday tick that is
refused, and one asked of a row the day view does not hold or that offers no tick, SHALL write no
copy and SHALL leave the last copy as it was. A copy that cannot be made SHALL refuse no birthday
tick, as it refuses no other change.

#### Scenario: a birthday tick kept on a day screen writes a copy at the copy place holding that tick

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with birthdays on and a calendar holding the contact "kate"'s
  birthday worded "Kate Bell's 48th Birthday" on 20 January 2026, keeping its copy place at a place of
  its own and asking a clock that answers a later minute each time it is asked, from that day at
  14:32; a directory of its own is given as its copy place through a commitments screen opened at
  those same places; and its one birthday row is ticked
- **THEN** the tick is not refused
- **AND** that directory's one file named `DayByDay.daybyday` is a copy made at Tuesday 20 January
  2026 at 14:33, holding the contact "kate"'s birthday on 20 January 2026 ticked
- **AND** the row ticked again writes a copy made at 14:34 holding no birthday ticks

#### Scenario: a birthday tick refused, or asked of a row that offers none, writes no copy at the copy place

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at a record
  place, a roster place and a one-off place where nothing has been kept and a birthday place where
  nothing can be written — a path beneath an existing ordinary file — with birthdays on and a
  calendar holding the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 20 January
  2026, keeping its copy place at a place of its own and asking a clock that answers a later minute
  each time it is asked, from that day at 14:32; a directory of its own is given as its copy place
  through a commitments screen opened at those same places; and its one birthday row is ticked
- **THEN** ticking is refused with an error
- **AND** the last copy made is still Tuesday 20 January 2026 at 14:32, and no stop stands
- **AND** on a day screen opened the same way at a birthday place that can be written, with the
  contact "john"'s birthday on 21 January 2026 instead, ticking the birthday row of the day view it
  says of the day after, and then that row once it has moved to the day after, leaves the last copy
  made at 14:32

## RENAMED Requirements

- FROM: `### Requirement: A take-out is the files at the three places exactly as they lie`
- TO: `### Requirement: A take-out is the files at the four places exactly as they lie`

## MODIFIED Requirements

### Requirement: A take-out is the files at the four places exactly as they lie

A take-out SHALL be the file standing at each of the record place, the roster place, the one-off
place and the birthday place, each as it lies and under the name it lies under, together
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

### Requirement: A commitments screen offers a take-out only while a store cannot be read, and says which

A commitments screen SHALL offer a take-out exactly while at least one of its four places cannot be
read, whether what lies there is not a store of its kind or was written by a later version of
DayByDay; where all four read it SHALL offer none. With the offer it SHALL say every place that
cannot be read, in the order record, roster, one-offs, birthday ticks, and for each SHALL say which
of those two things is so. It SHALL read the four places when it is opened, when the app is shown
again and when a restore is confirmed, and MUST NOT read them because it is drawn. A screen holding
a save in progress or a restore in progress it could not undo SHALL say the record, the roster and
the one-offs could not be read, and the birthday ticks only where they cannot.

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

### Requirement: A commitments screen takes out the files when it is asked, and holds nothing about one it took out

Asked for a take-out, a commitments screen SHALL write every file that take-out holds where it is
given to write take-outs into, each under the name it lies under at its place, and SHALL answer where
each was written, in the order record, roster, one-offs, birthday ticks, save in progress, restore in progress. It
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

### Requirement: A take-out that cannot be made hands out nothing and leaves the places as they were

Where a file the take-out holds cannot be handed over as it lies, or where the files cannot be
written where they are to be written, a commitments screen SHALL hand out no file at all and SHALL
answer why: a store that could not be taken out, naming it, or a place that could not be written,
naming none, told apart from one another. A save in progress and a restore in progress SHALL each be
named as the record, the place they stand beside. It SHALL leave no file of its own where it was to
write, and the record place, the roster place, the one-off place, the birthday place and both in-progress
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

### Requirement: A day screen that is not keeping a store says a copy can be restored and where

A day screen SHALL say that a copy can be restored and SHALL name the commitments screen as where,
exactly while it could not read its record, could not read its one-offs, is not keeping its roster
for either of that roster's two causes, or says its birthday ticks could not be read. However many of
the four are so, it SHALL say it once and no more. It MUST NOT say it where the only store it is not
keeping was written by a later version of DayByDay, and MUST NOT say it where it is keeping all three
and does not say its birthday ticks could not be read. What it says SHALL be words alone,
offering nothing to act on, and saying it SHALL read no place and change nothing.

#### Scenario: a day screen that cannot read its record says a copy can be restored and where

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place holding a run of
  bytes that is not a record, with a roster place and a one-off place where nothing has been kept, of
  a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** it says a copy can be restored, and names the commitments screen as where
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
- **THEN** it says its birthday ticks could not be read, and says a copy can be restored, naming the
  commitments screen as where
- **AND** with its record place also holding a run of bytes that is not a record, it says so once and
  no more
- **AND** a day screen opened the same way with birthdays off, one whose calendar cannot be read, and
  one whose birthday place holds birthday ticks written in a form one later than the form this app
  writes each say nothing about restoring a copy
