## ADDED Requirements

### Requirement: A copy holds the present ideas at the present-idea place, and is refused whole where they cannot be read

Forming a copy SHALL read the present-idea place when the copy is asked for, and the copy SHALL hold
every present idea kept there as the store holds it, given or not, whatever its contact and the
birthday switch. A present-idea place where nothing has been kept SHALL count as holding no ideas
and SHALL NOT refuse the copy. Where the present ideas cannot be read, or were written by a later
version of DayByDay, the copy SHALL be refused whole for that cause, whatever the switch, and the
store named SHALL be the present ideas only where the record, the roster, the one-offs, the birthday
ticks and the happenings could all be read; a copy the app makes on its own at the copy place SHALL
stop naming them the same way. Forming a copy SHALL leave the present-idea place as it found it.

#### Scenario: a copy holds every present idea the present-idea place holds, given or not, and none where nothing has been kept there

- **WHEN** the ideas "Ceramics class voucher" and "Hiking socks, size 38" with the link
  "https://bergzeit.ch/socks" are added to the contact "kate" in a present-idea store at a
  present-idea place, and "Ceramics class voucher" is marked given there; the idea "Book voucher" is
  added there to the contact "anna"; a commitments screen is opened as of Tuesday 13 October 2026 at
  that present-idea place and at a record place, a roster place, a one-off place, a birthday place
  and a happening place where nothing has been kept, handed a birthday switch that is off; and a
  copy is asked for as of that day at 14:32, written into a directory of its own
- **THEN** the copy is not refused
- **AND** what is written holds, against "kate", "Ceramics class voucher", given, and then "Hiking
  socks, size 38" with the link "https://bergzeit.ch/socks", not given; against "anna", "Book
  voucher", not given; and nothing else
- **AND** the content at that present-idea place is byte-for-byte what it was immediately after the
  screen was opened
- **AND** a copy asked for the same way where nothing has been kept at the present-idea place is not
  refused, holds no ideas, and leaves nothing written at that present-idea place

#### Scenario: a copy is refused whole where the present ideas cannot be read, naming them only where the other five stores read

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened as of Tuesday
  13 October 2026 at that roster place, a record place, a one-off place, a birthday place and a
  happening place where nothing has been kept, and a present-idea place holding a run of bytes that
  is not a present-idea store; and a copy is asked for as of that day at 14:32, written into a
  directory of its own
- **THEN** it is refused as a store that could not be read, naming the present ideas
- **AND** no file stands in that directory, and the content at that present-idea place is
  byte-for-byte what it was before the copy was asked for
- **AND** a copy asked for through a screen opened the same way, handed a birthday switch that is
  off, is refused the same way, naming the present ideas
- **AND** a copy asked for where the present-idea place holds a present-idea store written in a form
  one later than the form this app writes is refused as a store written by a later version of
  DayByDay, naming the present ideas
- **AND** a copy asked for where the happening place is also a run of bytes that is not a happening
  store is refused as a store that could not be read, naming the happenings

#### Scenario: a change kept where the present ideas cannot be read is kept, and the stop names the present ideas

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen is opened at that roster place and at
  a record place, a one-off place, a birthday place and a happening place where nothing has been
  kept as of Tuesday 13 October 2026, keeping its copy place at a place of its own and asking a
  clock that answers a later minute each time it is asked, from that day at 14:32; a directory of
  its own is given as its copy place through a commitments screen opened at those same places; what
  is at the present-idea place beside that record place is then made a run of bytes that is not a
  present-idea store; and the row named "Gym" is ticked
- **THEN** the tick is not refused, and a record store opened at that record place holds that tick
- **AND** the stop is a store that could not be read, naming the present ideas, as of Tuesday
  13 October 2026 at 14:33
- **AND** a copy place opened again at the place it is kept at says that same stop
- **AND** with a present-idea store written in a form one later than the form this app writes made
  to stand there instead, the stop is a store written by a later version of DayByDay, naming the
  present ideas

### Requirement: A copy place and a commitments screen given no present-idea place read the present ideas beside the record place

A copy place and a commitments screen SHALL each be opened with a present-idea place or with none.
One opened at a record place and given none SHALL read and write the present ideas in the file of
the present-idea place's name beside that record place, and a restore a day screen undoes SHALL be
put back at the present-idea place beside that day screen's record place. Where that record place is
the one a day screen keeps its record at by default, the file beside it SHALL be the place the app
names for present ideas.

#### Scenario: a copy place given no present-idea place copies the present ideas kept beside its record place

- **WHEN** the idea "Book voucher" is added to the contact "kate" in a present-idea store at the file
  of the present-idea place's name beside a record place in a directory of its own; a commitments
  screen is opened as of Tuesday 13 October 2026 at that record place and at a roster place and a
  one-off place beside it where nothing has been kept, given no present-idea place, and a copy place
  opened at that record place the same way, given no present-idea place and asking a clock that
  answers that day at 14:32, is handed to it; and a directory of its own is given to it as its copy
  place
- **THEN** that directory's one file named `DayByDay.daybyday` holds one idea, "Book voucher",
  against "kate"
- **AND** a copy that commitments screen is asked for as of that day at 14:33, written into a
  directory of its own, holds the same one idea
- **AND** the file of the present-idea place's name beside the place a day screen keeps its record at
  by default is the place the app names for present ideas

### Requirement: A copy made before copies held present ideas holds none, and a copy's present ideas are read whole

What is written for a copy SHALL say a form later than the form copies were written in before they
held present ideas. A file that reads as a copy's form and moment, in an earlier form, SHALL be read
as holding no present ideas and SHALL NOT be refused for it. A copy of a later form SHALL be refused
as a damaged copy where it holds no present ideas, where they do not read as the shape their form
has, or where they hold anything a present-idea store would refuse at its own place as not such a
store, one contact held twice included. Present ideas of a form later than the present-idea store
reads SHALL make the copy one from a later version, whatever else it holds.

#### Scenario: a copy made before copies held present ideas is read as holding none, and restoring it leaves the present-idea place holding none

- **WHEN** the idea "Book voucher" is added to the contact "kate" in a present-idea store at a
  present-idea place; a commitments screen is opened as of Tuesday 13 October 2026 at that
  present-idea place and at a record place, a roster place, a one-off place, a birthday place and a
  happening place where nothing has been kept; and it is asked to restore from a file holding a copy
  in the form copies were written in before they held present ideas, made on that day at 09:07,
  holding a roster of one commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026
- **THEN** it is not refused, and the restore awaiting confirmation says the copy holds no present
  idea and the phone holds one
- **AND** once the restore is confirmed, a present-idea store opened at that present-idea place holds
  no idea against "kate", and what the screen keeps is one entry, named "Gym"
- **AND** a copy made through that screen afterwards says a form later than the form that file was
  written in
- **AND** a file holding a copy in the form copies were written in before they held happenings is
  read the same way, as holding no present ideas

#### Scenario: a copy holding present ideas the app never writes is refused as a damaged copy, and one whose present ideas are of a later form as a copy from a later version

- **WHEN** a commitments screen is opened as of Tuesday 13 October 2026 at a record place, a roster
  place, a one-off place, a birthday place, a happening place and a present-idea place where nothing
  has been kept; a copy is made through it as of that day at 14:32; the present ideas that copy
  holds are then made to hold one idea against the contact "kate" with neither a text nor a link;
  and the screen is asked to restore from it
- **THEN** it is refused as a damaged copy, and no restore is awaiting confirmation
- **AND** copies whose present ideas hold one idea against "kate" with the link "ask Anna", one with
  the link "amazon.de/xyz", or one with the text " Book voucher ", one holding "Book voucher"
  against a contact of blank space alone, one holding "kate" twice, and one whose present ideas are
  taken out of it, are each refused the same way
- **AND** a copy whose present ideas say a form one later than the present-idea store writes is
  refused as a copy from a later version, and so is one holding such present ideas beside a roster
  that lacks a field its form always writes

### Requirement: A commitments screen says how many present ideas a restore takes away and brings, given or not

Asking to restore SHALL write nothing at the present-idea place. What the restore awaiting
confirmation says SHALL count, for the copy and for the phone, every present idea held, given or
not, against whatever contact and whether or not birthdays are on, as one number. The phone's
present ideas SHALL be read as a copy reads them. Where the phone's present ideas cannot be read,
for either cause, it SHALL say so in place of the phone's present-idea count, and SHALL give every
other count, of the phone and of the copy, as it gives it where they can be read.

#### Scenario: a commitments screen asked to restore says how many present ideas the copy and the phone hold, given and not given together

- **WHEN** the ideas "Ceramics class voucher" and "Hiking socks, size 38" are added to the contact
  "kate" in a present-idea store at a present-idea place, "Ceramics class voucher" is marked given
  there, and the idea "Book voucher" is added there to the contact "anna"; a commitments screen is
  opened as of Tuesday 13 October 2026 at that present-idea place and at a record place, a roster
  place, a one-off place, a birthday place and a happening place where nothing has been kept, handed
  a birthday switch that is off; a copy is made through it as of that day at 14:32; the ideas "Scarf"
  and "Kite" are then added there to the contact "john", and "Book voucher" is deleted there; and the
  screen is asked to restore from that copy
- **THEN** it is not refused, and the restore awaiting confirmation says the copy holds three present
  ideas and the phone holds four
- **AND** it says no place that cannot be read
- **AND** the content at that present-idea place is byte-for-byte what it was immediately before it
  was asked

#### Scenario: a commitments screen asked to restore where the present-idea place cannot be read says the present ideas cannot be read in place of their count

- **WHEN** a commitments screen is opened as of Tuesday 13 October 2026 at a record place, a roster
  place, a one-off place, a birthday place, a happening place and a present-idea place where nothing
  has been kept; a copy is made through it as of that day at 14:32; what is at that present-idea
  place is then made a run of bytes that is not a present-idea store; and the screen is asked to
  restore from that copy
- **THEN** it is not refused
- **AND** the restore awaiting confirmation says the present ideas cannot be read, gives the phone no
  count of present ideas, and gives the phone every other count
- **AND** it gives the copy no present idea
- **AND** it says the same where the present-idea place holds a present-idea store written in a form
  one later than the form this app writes

### Requirement: A restore confirmed makes the present-idea place hold the copy's present ideas, and nothing of what was there

Confirming a restore SHALL write the present ideas the copy holds at the present-idea place, in the
form the present-idea store writes now, each against its contact, in its order and with its mark,
and no idea held there before SHALL remain or be merged, whether or not what was there could be
read. Where the present-idea place cannot be written, confirming SHALL be refused as a place that
could not be written, and the present-idea place and the other five places SHALL each be byte-for-
byte what they were before it was confirmed. A Birthdays screen shown again afterwards SHALL give
back what the restore wrote there, as it reads its place whenever it is shown again.

#### Scenario: a restore confirmed makes the present-idea place hold the copy's present ideas, and the ideas there are gone

- **WHEN** the idea "Book voucher" is added to the contact "kate" in a present-idea store at a
  present-idea place; a Birthdays screen is opened at it as of Tuesday 13 October 2026 with
  birthdays on and a calendar handing the contact "kate"'s birthday worded "Kate Bell's 48th
  Birthday" on 14 November 2026 and the contact "john"'s worded "John Appleseed's 40th Birthday" on
  5 June 2027; a commitments screen is opened on that day at that present-idea place and at a record
  place, a roster place, a one-off place, a birthday place and a happening place where nothing has
  been kept; a copy is made through it as of that day at 14:32; "Book voucher" is then marked given
  through the Birthdays screen and the idea "Scarf" added through it to John's line; and the
  commitments screen is asked to restore from that copy and the restore is confirmed
- **THEN** it is not refused
- **AND** the content at that present-idea place is byte-for-byte what a present-idea store writes
  for "Book voucher" against "kate", not given, and nothing else
- **AND** the Birthdays screen, shown again on that day, says "1 idea" on Kate's line and nothing of
  ideas on John's
- **AND** a restore of that copy confirmed where that present-idea place holds a run of bytes that is
  not a present-idea store leaves the same content there

#### Scenario: a restore refused where the present-idea place cannot be written leaves the six places as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 12 October 2026 is kept at
  a record place; a one-off named "Book dentist" on 25 October 2026 is kept at a one-off place; a
  commitments screen is opened as of Tuesday 13 October 2026 at those places, at a birthday place
  and a happening place where nothing has been kept, and at a present-idea place where nothing can
  be written — a path beneath an existing ordinary file; and it is asked to restore from a copy
  holding a commitment named "Journaling" and the idea "Book voucher" against the contact "kate",
  and the restore is confirmed
- **THEN** it is refused as a place that could not be written
- **AND** the content at the record place, the roster place and the one-off place is byte-for-byte
  what it was immediately before the restore was confirmed, and nothing stands at the birthday place,
  the happening place or the present-idea place
- **AND** what it keeps is one entry, named "Gym", it holds no copy restored and no restore is
  awaiting confirmation

### Requirement: A restore stopped before it was whole is undone at the present-idea place too

A restore SHALL keep what stood at the present-idea place, or that nothing stood there, in the
restore in progress it keeps before it writes anything. A restore stopped before it was whole SHALL
be undone at the present-idea place with the other five places when a commitments screen or a day
screen next opens them, before anything is read from them, putting back what stood at the present-
idea place before it began and saying nothing. A restore in progress kept before restores wrote the
present-idea place SHALL be undone leaving the present-idea place as it stands.

#### Scenario: a restore stopped before it was whole is undone at the present-idea place when the places are next opened

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; the idea "Book voucher" is added to the contact
  "kate" in a present-idea store at the present-idea place beside a record place; a restore of a
  copy holding a commitment named "Journaling" and the idea "Scarf" against the contact "john", and
  nothing else, is left having written the record place, the roster place, the one-off place, the
  birthday place, the happening place and the present-idea place, with the restore in progress it
  left standing; and a commitments screen is opened at those places as of Tuesday 13 October 2026
- **THEN** what it keeps is one entry, named "Gym"
- **AND** the content at all six places is byte-for-byte what it was before that restore began, and
  no restore in progress stands
- **AND** a day screen of that commitment opened at those places instead, on that day, leaves the
  same content at all six places and no restore in progress standing
- **AND** a restore in progress kept in the form it had before restores wrote the present-idea place,
  standing beside that record place instead, is undone the same way and leaves the content at the
  present-idea place byte-for-byte what it was

### Requirement: A change a person keeps to a present idea writes a copy at the copy place

Where a copy place is set, a Birthdays screen handed it SHALL write a copy there after every change
a person keeps at its present-idea place, as of the moment its clock answers once that change is
kept: an idea added, changed, deleted once the deletion is confirmed, marked given, or its mark
taken back. That copy SHALL hold the present ideas as they then stand. A change that is refused, and
a mark already so, SHALL write no copy and SHALL leave the last copy as it was, and so SHALL asking
for a deletion and cancelling it. A copy that cannot be made SHALL refuse no present-idea change, as
it refuses no other change.

#### Scenario: an idea added, changed, marked given, unmarked and deleted through a Birthdays screen each write a copy at the copy place

- **WHEN** a Birthdays screen is opened as of Tuesday 13 October 2026 at a present-idea place where
  nothing has been kept, beside a record place, a roster place, a one-off place, a birthday place and
  a happening place where nothing has been kept, with birthdays on and a calendar handing the contact
  "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026, handed a copy place kept
  at a place of its own and asking a clock that answers a later minute each time it is asked, from
  that day at 14:32; a directory of its own is given as that copy place through a commitments screen
  opened at those same places; and the idea "Book voucher" is added through it to Kate's line,
  changed to "Book voucher" with the link "orellfuessli.ch", marked given, its mark taken back, and
  deleted once the deletion is confirmed
- **THEN** none of the five is refused
- **AND** the copy at that directory after each of the five holds the present ideas exactly as that
  change left them at the present-idea place
- **AND** the last copy made after the deletion is Tuesday 13 October 2026 at 14:37, and holds no
  idea

#### Scenario: a present-idea change refused, or a mark already so, writes no copy at the copy place

- **WHEN** a Birthdays screen is opened as of Tuesday 13 October 2026 at a present-idea place holding
  "Book voucher" against the contact "kate", not given, beside a record place, a roster place, a
  one-off place, a birthday place and a happening place where nothing has been kept, with birthdays
  on and a calendar handing the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on
  14 November 2026, handed a copy place kept at a place of its own and asking a clock that answers a
  later minute each time it is asked, from that day at 14:32; a directory of its own is given as that
  copy place through a commitments screen opened at those same places; and, through the Birthdays
  screen, an empty text with an empty link is added to Kate's line and refused, "Book voucher" is
  changed to the text "Book voucher" with the link "ask Anna" and refused, the third idea of Kate's
  line is marked given and refused, "Book voucher" is marked not given, and its deletion is asked for
  and cancelled
- **THEN** the last copy made is still Tuesday 13 October 2026 at 14:32, and no stop stands
- **AND** the content at that present-idea place is byte-for-byte what it was before

#### Scenario: an idea added where the copy place cannot be written is kept and is not refused

- **WHEN** a Birthdays screen is opened as of Tuesday 13 October 2026 at a present-idea place where
  nothing has been kept, beside a record place, a roster place, a one-off place, a birthday place and
  a happening place where nothing has been kept, with birthdays on and a calendar handing the contact
  "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026, handed a copy place kept
  at a place of its own and asking a clock that answers a later minute each time it is asked, from
  that day at 14:32; a directory that cannot be written to is given as that copy place through a
  commitments screen opened at those same places; and the idea "Book voucher" is added through it to
  Kate's line
- **THEN** the add is not refused, and a present-idea store opened at that present-idea place holds
  "Book voucher" against "kate"
- **AND** the stop is the folder that cannot be written, as of Tuesday 13 October 2026 at 14:32

### Requirement: A Birthdays screen that cannot read its present ideas says a copy can be restored and where

A Birthdays screen SHALL say that a copy can be restored and SHALL name Settings as where, exactly
while it says its present ideas could not be read, whether or not birthdays are on. It MUST NOT say
it where its present ideas were written by a later version of DayByDay, and MUST NOT say it where it
is keeping them. What it says SHALL be words alone, offering nothing to act on, and saying it SHALL
read no place and change nothing. Whether a day screen says a copy can be restored MUST NOT depend
on the present ideas.

#### Scenario: a Birthdays screen that cannot read its present ideas says a copy can be restored, and says nothing of it where they were written by a later version

- **WHEN** a run of bytes that is not a present-idea store is written at a present-idea place, and a
  Birthdays screen is opened at it as of Tuesday 13 October 2026 with birthdays on and a calendar
  handing the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026
- **THEN** it says its present ideas could not be read, and says a copy can be restored, naming
  Settings as where
- **AND** one opened the same way with birthdays off says the same
- **AND** one opened at a present-idea place holding a present-idea store written in a form one later
  than the form this app writes, and one opened where nothing has been kept, each say nothing about
  restoring a copy
- **AND** a day screen of no commitments at all opened as of that day at a record place, a roster
  place, a one-off place, a birthday place and a happening place where nothing has been kept, beside
  that present-idea place, says nothing about restoring a copy
- **AND** once that content is replaced by a present-idea store holding "Book voucher" against
  "kate" and the Birthdays screen is shown again on that day, it says nothing about restoring a copy

## RENAMED Requirements

- FROM: `### Requirement: A take-out is the files at the five places exactly as they lie`
- TO: `### Requirement: A take-out is the files at the six places exactly as they lie`

## MODIFIED Requirements

### Requirement: A take-out is the files at the six places exactly as they lie

A take-out SHALL be the file standing at each of the record place, the roster place, the one-off
place, the birthday place, the happening place and the present-idea place, each as it lies and under
the name it lies under, together with a save in progress and a restore in progress still standing
beside them. A place where no file stands SHALL contribute none and SHALL NOT refuse the take-out.
Forming a take-out SHALL read no store as a value, SHALL bring nothing to the form the app writes
now, SHALL undo no save in progress and no restore in progress, and SHALL leave every one of those
files byte-for-byte as it found them. The copy place SHALL NOT be taken out.

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

#### Scenario: a take-out hands out the file at the present-idea place byte-for-byte under the name it lies under

- **WHEN** the idea "Book voucher" is added to the contact "kate" in a present-idea store at a
  present-idea place; what is at a record place is made a run of bytes that is not a record; and a
  commitments screen opened at those two places and at a roster place, a one-off place, a birthday
  place and a happening place where nothing has been kept as of Tuesday 13 October 2026 is asked for
  a take-out, written into a directory of its own
- **THEN** it is not refused, and two files stand there, named as the files at the record place and
  the present-idea place are named
- **AND** the one named as the file at the present-idea place holds byte-for-byte what stands there

### Requirement: A commitments screen offers a take-out only while a store cannot be read, and says which

A commitments screen SHALL offer a take-out exactly while at least one of its six places cannot be
read, whether what lies there is not a store of its kind or was written by a later version of
DayByDay; where all six read it SHALL offer none. With the offer it SHALL say every place that
cannot be read, in the order record, roster, one-offs, birthday ticks, happenings, present ideas, and for each SHALL say which
of the two is so. It SHALL read the six places when it is opened, when the app is shown
again and when a restore is confirmed, and MUST NOT read them because it is drawn. A screen holding
a save in progress or a restore in progress it could not undo SHALL say the record, the roster and
the one-offs could not be read, and the other three only where they cannot.

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

#### Scenario: a commitments screen offers a take-out over present ideas that cannot be read, naming them after the happenings

- **WHEN** a commitments screen is opened as of Tuesday 13 October 2026 at a record place, a roster
  place, a one-off place, a birthday place and a happening place where nothing has been kept, and a
  present-idea place holding a run of bytes that is not a present-idea store
- **THEN** it offers a take-out, and says the present ideas alone, as a place that could not be read
- **AND** a screen opened the same way, handed a birthday switch that is off, says the same
- **AND** a screen opened where the happening place also holds a run of bytes that is not a
  happening store says the happenings and then the present ideas
- **AND** a screen opened where the present-idea place holds a present-idea store written in a form
  one later than the form this app writes says the present ideas as written by a later version of
  DayByDay, told apart from ones that could not be read
- **AND** a screen holding a restore in progress it could not undo says the record, the roster and
  the one-offs and nothing of the present ideas where the present-idea place holds "Book voucher"
  against the contact "kate", and says the present ideas after the one-offs where it holds that run
  of bytes

### Requirement: A commitments screen takes out the files when it is asked, and holds nothing about one it took out

Asked for a take-out, a commitments screen SHALL write every file that take-out holds where it is
given to write take-outs into, each under the name it lies under at its place, and SHALL answer where
each was written, in the order record, roster, one-offs, birthday ticks, happenings, present ideas, save in progress, restore in progress. It
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

#### Scenario: a commitments screen asked for a take-out answers the present ideas' file after the happenings' and before a save in progress

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a happening named "Kopfweh" is added to a happening
  store at a happening place; the idea "Book voucher" is added to the contact "kate" in a
  present-idea store at a present-idea place; a run of bytes that is not a save in progress is kept
  where one is kept beside a record place where nothing has been kept; and a commitments screen
  opened at those places and at a one-off place and a birthday place where nothing has been kept as
  of Tuesday 13 October 2026 is asked for a take-out, written into a directory of its own
- **THEN** it answers four places: the roster's, then the happenings', then the present ideas',
  then the save in progress's
- **AND** the directory it was given holds those four files and no other

### Requirement: A take-out that cannot be made hands out nothing and leaves the places as they were

Where a file the take-out holds cannot be handed over as it lies, or where the files cannot be
written where they are to be written, a commitments screen SHALL hand out no file at all and SHALL
answer why: a store that could not be taken out, naming it, or a place that could not be written,
naming none, told apart from one another. A save in progress and a restore in progress SHALL each be
named as the record, the place they stand beside. It SHALL leave no file of its own where it was to
write, and each of the six places and both in-progress
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

#### Scenario: a take-out refused over the present-idea place names the present ideas and hands out none of the others

- **WHEN** a roster place holds a run of bytes that is not a roster; a present-idea place beside it
  is made a directory holding nothing rather than a file; and a commitments screen opened at those
  places and at a record place, a one-off place, a birthday place and a happening place where
  nothing has been kept as of Tuesday 13 October 2026 is asked for a take-out, written into a
  directory of its own
- **THEN** it is refused as a store that could not be taken out, naming the present ideas
- **AND** no file stands in that directory
- **AND** the content at that roster place is byte-for-byte what it was, and that present-idea place
  is still a directory holding nothing
