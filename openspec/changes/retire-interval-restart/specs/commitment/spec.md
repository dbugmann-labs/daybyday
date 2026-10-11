## ADDED Requirements

### Requirement: Reading the places undoes a torn save as it was, before anything is drawn from them

A day screen and a commitments screen SHALL read the save in progress each time they read their
places — when opened, when shown again, and a day screen when returned to — before drawing anything
from either place. Where one stands and the roster place holds, in any state, the commitment it names
the records carried to, the screen SHALL take the save in progress away and SHALL write nothing else.
Where one stands and the roster place holds no such commitment, the screen SHALL carry every record
of that commitment back to the commitment they were carried from, SHALL keep that at the record
place, SHALL then take the save in progress away, and SHALL say nothing of it.

#### Scenario: a rename torn between its two places is undone when a commitments screen is opened

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick on Monday 3 August 2026 for a commitment named
  "Gym 🏋️" alike in every other way is kept at a record place; a save in progress naming records
  carried from "Gym" to "Gym 🏋️" is kept beside that record place; and a commitments screen is
  opened at those places as of Monday 31 August 2026
- **THEN** what it keeps is one entry, named "Gym"
- **AND** a store opened afterwards at that record place answers that "Gym" was kept on Monday
  3 August 2026 and that "Gym 🏋️" was not
- **AND** no save in progress is kept beside that record place, and the screen does not say that
  records belong to no commitment

#### Scenario: a torn save is undone when a day screen is opened

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Saturday 1 August 2026, is taken on at a roster place; ticks on Thursday 6 August
  2026 and Monday 10 August 2026 for a commitment named "Nails" on a schedule of every 4 days
  starting on Sunday 2 August 2026, kept from that day, are kept at a record place; a save in
  progress naming records carried from the first to the second is kept beside that record place; and
  a day screen of no commitments is opened at those places as of Monday 10 August 2026
- **THEN** its day view holds one row, named "Nails", saying the commitment is kept
- **AND** a store opened afterwards at that record place answers that the first "Nails" was kept on
  both days and the second on neither
- **AND** no save in progress is kept beside that record place

#### Scenario: a save in progress for a save its roster took is taken away and nothing else is written

- **WHEN** a commitment named "Gym 🏋️" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place and stopped there as of Sunday 30 August 2026; a tick for it on
  Monday 3 August 2026 is kept at a record place; a save in progress naming records carried from a
  commitment named "Gym" alike in every other way to "Gym 🏋️" is kept beside that record place; the
  content at both places is read; and a commitments screen is opened at those places as of Monday
  31 August 2026
- **THEN** no save in progress is kept beside that record place
- **AND** the content at both places is byte-for-byte what was read

#### Scenario: a torn save is undone when a day screen is shown again

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a day screen of no commitments is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; a tick on that day
  for a commitment named "Gym 🏋️" alike in every other way, and a save in progress naming records
  carried from "Gym" to "Gym 🏋️", are then kept at those places by something else; and the screen is
  shown again as of Monday 31 August 2026
- **THEN** its day view holds one row, named "Gym", saying the commitment is kept
- **AND** no save in progress is kept beside that record place

#### Scenario: a torn save is undone when a day screen is returned to

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a day screen of no commitments is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; a tick on that day
  for a commitment named "Gym 🏋️" alike in every other way, and a save in progress naming records
  carried from "Gym" to "Gym 🏋️", are then kept at those places by something else; and the screen is
  returned to
- **THEN** its day view holds one row, named "Gym", saying the commitment is kept
- **AND** a store opened afterwards at that record place answers that "Gym 🏋️" was not kept on that
  day, and no save in progress is kept beside that record place

### Requirement: What a commitments screen tells on its sheet lasts until that field is edited, the next definition or change, the sheet closing or the app being shown again

What a commitments screen holds about a refusal on its sheet SHALL stand until the field it is about
is edited, until the next commitment is defined or changed through the screen, until the sheet is
closed, or until the app is shown again, and SHALL then be held no longer; nothing else
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
  day-kept-from field, its range field and its target field are each told edited
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

#### Scenario: a refused change replaces what a refused definition told on a commitments screen's sheet

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it
  and refused; and "Gym" is then changed through it to a weekday-set rhythm of no weekdays at all,
  under no category, and refused
- **THEN** it tells a rhythm due on no day, about the rhythm field of its sheet
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

### Requirement: A commitments screen says which field of its sheet a refused definition or change is about, or that it is about no field

Where a commitments screen refuses a commitment defined through it or a change to one, it SHALL hold
that refusal with which field of its sheet it is about — at most one, the last ask's. A name that says nothing SHALL be about the name field. A rhythm
due on no day, and a rhythm number the calendar will not take, SHALL be about the rhythm field. A
range that is not a range SHALL be about the range field, and a target that is not a target about
the target field. A name a commitment its roster keeps or has stopped keeping already has SHALL be about the name
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

### Requirement: A commitments screen keeps no era a change leaves holding no day, and a change back leaves the commitment as it was

A commitments screen SHALL put on the era a change asks for as *A roster puts a new era on a
commitment it is keeping, from a day, and keeps no era holding no day* says.

Where, with the eras holding no day dropped, the era a change's new era would give way to runs on
the rhythm the change names and carries the range or target it names, no new era SHALL be put on,
and that era SHALL run on as the newest with the schedule it had, an interval's start date
included. A change back SHALL be refused for a recorded day it leaves not due as any change is.

#### Scenario: a rhythm changed and changed back on one day leaves the commitment as it was that morning

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; and "Gym" is
  changed through it to a weekday-set rhythm of Tuesday and Thursday and then back to one of Monday,
  Wednesday and Saturday, each on the name and the day kept from it already has, under no category
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place reads back one era of "Gym", on Monday,
  Wednesday and Saturday, kept from 1 January 2026, and answers about 31 August 2026 with that era
  alone
- **AND** a commitment named "Mood" of the number kind with a range of 1 to 10, changed alike to a
  range of 1 to 5 and back to one of 1 to 10, reads back one era, ranging 1 to 10, kept from
  1 January 2026

#### Scenario: a rhythm changed three times on one day leaves one era for that day and a roster that can be read

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; and "Gym" is
  changed through it to a weekday-set rhythm of Tuesday and Thursday, back to one of Monday,
  Wednesday and Saturday, and to one of Tuesday and Thursday again, each under no category
- **THEN** none of the three is refused
- **AND** a roster store opened afterwards at that place opens without error and reads back two eras
  of "Gym", the one on Tuesday and Thursday, kept from 31 August 2026, first and the one on Monday,
  Wednesday and Saturday, kept from 1 January 2026, second
- **AND** the screen shown again as of that day keeps one entry, named "Gym", saying "Tue, Thu"

#### Scenario: a commitment defined and changed on one day keeps one era, kept from that day

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place and a record
  place where nothing has been kept; a commitment named "Gym" on a weekday-set rhythm of Monday,
  Wednesday and Saturday, kept from that same day, is defined through it; and "Gym" is changed
  through it to a weekday-set rhythm of Tuesday and Thursday and then back to one of Monday,
  Wednesday and Saturday, each under no category
- **THEN** none is refused
- **AND** a roster store opened afterwards at that place opens without error and reads back one era
  of "Gym", on Monday, Wednesday and Saturday, kept from 31 August 2026

#### Scenario: an interval rhythm changed away and back on one day keeps the start date it had

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday
  31 August 2026; and "Nails" is changed through it to a weekday-set rhythm of Sunday and then back
  to an interval rhythm of 4 days, each under no category
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place reads back one era of "Nails", on every
  4 days starting on Thursday 6 August 2026, kept from Tuesday 4 August 2026
- **AND** that commitment is due on Sunday 30 August 2026 and on Thursday 3 September 2026, and not
  on Monday 31 August 2026

#### Scenario: a change back on one day is refused where a record made that day would be left not due

- **WHEN** a commitment named "Gym" on a schedule listing Tuesday and Thursday, kept from 1 January
  2026, is taken on at a roster place; a commitments screen is opened at that roster place and at a
  record place where nothing has been kept as of Monday 31 August 2026; "Gym" is changed through it
  to a weekday-set rhythm of Monday, under no category; a tick for "Gym" on Monday 31 August 2026 is
  then kept at that record place and the screen is shown again as of that day; and "Gym" is changed
  back to a weekday-set rhythm of Tuesday and Thursday
- **THEN** the change back is refused as a day already recorded on that the change would leave not
  due
- **AND** a roster store opened afterwards at that place answers about Monday 31 August 2026 with the
  era on Monday alone

## MODIFIED Requirements

### Requirement: A change that carries records leaves a save in progress until its roster place is written

A commitments screen SHALL, before a change writes anything at the record place, keep a
save in progress beside the record place naming the commitment its records are carried from and the
one they are carried to, and SHALL take it away once the roster place is written. A change
that carries no record SHALL keep no save in progress. Where it cannot be kept, the change SHALL be
refused as a place that could not be written, writing nothing at either place.

Where the roster place refuses a change whose records were already carried, the screen
SHALL undo the torn save exactly as reading its places does and SHALL then refuse it as a place that
could not be written. Where that undo fails, the screen SHALL from then on hold a torn save it cannot
undo.

#### Scenario: a change that carries records leaves no save in progress once it is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record
  place; a commitments screen is opened at that roster place and that record place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", under no category
- **THEN** nothing is refused
- **AND** no save in progress is kept beside that record place

#### Scenario: a change that carries no record is kept where nothing beside the record place can be written

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and one named "Run" on a schedule listing all seven weekdays, kept from that same
  day, are taken on at a roster place; a tick for "Gym" on Monday 3 August 2026 is kept at a record
  place in a directory of its own; a commitments screen is opened at those places as of Monday
  31 August 2026; the record place's directory is then made impossible to write, while the roster
  place's directory stays writable; "Gym" is changed through it to a weekday-set rhythm of Tuesday
  and Thursday; and "Run" is changed through it to the name "Running"
- **THEN** neither change is refused
- **AND** what it keeps is an entry named "Gym" saying "Tue, Thu" and an entry named "Running"

#### Scenario: a change refused at the roster place after carrying its records leaves no save in progress and a roster still kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record
  place; a commitments screen is opened at those places as of Monday 31 August 2026; what is at that
  roster place is then made impossible to write; and "Gym" is changed through it to the name
  "Gym 🏋️", under no category
- **THEN** it is refused as a place that could not be written
- **AND** no save in progress is kept beside that record place
- **AND** the screen says it is keeping a roster, and what it keeps is one entry, named "Gym"

### Requirement: A commitments screen holds the change it refused and why, one at a time

Where a change asked of a commitments screen is refused, the screen SHALL hold which change was
asked for and why it was refused, as well as answering the refusal to the caller. The change held
SHALL be one of the ten a person can ask for — defining a commitment, stopping keeping one, taking
a stopped one up again, deleting one, moving one, moving a whole group, changing one, making a
copy, taking out the files, restoring a copy — and for the five asked about a commitment already on one of
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
take-up-again of one it has not stopped; a deletion asked about a commitment on neither list; a
deletion confirmed with nothing awaiting deletion; a deletion confirmed while the name typed back
does not match; a move of one it does not keep; a move into a group it draws none of, or to an offset
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

#### Scenario: a commitments screen holds a refused deletion against the commitment it was asked to delete

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to delete "Gym" and "Gym" is typed back; what is at that
  place is then made impossible to write; and the deletion is confirmed
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against deleting "Gym"
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitments screen holds nothing against a deletion confirmed on a name that does not match

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; it is asked to delete "Gym";
  "Gymm" is typed back; and the deletion is confirmed
- **THEN** the deletion refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one entry, named "Gym", and "Gym" is still awaiting deletion

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
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is deleted there; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is changed
  through it to the name "Gym 🏋️", under no category
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

#### Scenario: what a commitments screen holds about a refused change stands when a deletion is asked about a commitment on neither of its lists

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to delete a commitment named "Run" alike in every other way to "Gym" and never taken on
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a deletion is confirmed with nothing awaiting deletion

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to confirm a deletion with nothing awaiting deletion
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

### Requirement: A roster store reads each commitment's eras mended

A roster store SHALL read each commitment's eras mended, whatever form they were kept in, and a copy
to be restored alike. Newest first, each era but the newest SHALL hold only days before the day the
kept era in front of it is kept from, dropped where it then holds none. Two neighbouring eras alike
in schedule and kind, range or target included, SHALL be one where no day lies between them, kept
from the older's day with the newer's day kept until, state and category, two otherwise. The newest
era SHALL NOT be dropped for holding no day, but a stopped one holding none SHALL be while an older
era stands behind it, taking its state, category and earlier day kept until.

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
  from 1 January 2026, which it is keeping

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

#### Scenario: neighbouring every-N-days eras of one interval counting from different days are read back as two

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose entries are two eras of one commitment named "Nails" — on every 4 days starting on
  31 August 2026, kept from that day and kept; and on every 4 days starting on 6 August 2026, kept
  from 4 August 2026 and kept until 30 August 2026
- **THEN** it reads back two eras of "Nails", the one starting on 31 August 2026 first
- **AND** asked about 30 August 2026 it answers with both eras, and about 31 August 2026 with the
  newer alone
- **AND** the newer era is due on 31 August 2026 and on 4 September 2026 and not on 3 September
  2026, and the older is due on 30 August 2026

## REMOVED Requirements

### Requirement: A commitments screen says whether a commitment can be restarted, and offers the day it was handed to restart from

**Reason**: Restarting is retired; a shift of an every-N-days due day replaces it (ADR-1067).
**Migration**: None on disk. Eras a restart made are ordinary eras and read exactly as before.

### Requirement: A commitments screen restarts an interval commitment it keeps by putting a new era on it

**Reason**: Restarting is retired; a shift of an every-N-days due day replaces it (ADR-1067).
**Migration**: None on disk. Eras a restart made are ordinary eras and read exactly as before.

### Requirement: A commitments screen refuses a restart it cannot make, and tells each refusal apart

**Reason**: Restarting is retired; a shift of an every-N-days due day replaces it (ADR-1067).
**Migration**: None on disk. Eras a restart made are ordinary eras and read exactly as before.

### Requirement: Reading the places undoes a torn save as it was

**Reason**: One scenario title names a restart, and a requirement cannot rename a scenario under
its own heading.
**Migration**: Carried verbatim but for that title, as *Reading the places undoes a torn save as it was, before anything is drawn from them*.

### Requirement: What a commitments screen tells on its sheet lasts until that field is edited, the next ask, the sheet closing or the app being shown again

**Reason**: Its restart words and its restart scenario are withdrawn with restarting (ADR-1067), and
a requirement cannot drop a scenario under its own heading.
**Migration**: Carried, otherwise verbatim, as *What a commitments screen tells on its sheet lasts until that field is edited, the next definition or change, the sheet closing or the app being shown again*, the restart scenario replaced by one a definition and a change ask.

### Requirement: A commitments screen says which field of its sheet a refusal it answers is about, or that it is about no field

**Reason**: Its restart sentences and scenarios are withdrawn with restarting (ADR-1067), and a
requirement cannot drop a scenario under its own heading.
**Migration**: Carried, otherwise verbatim, as *A commitments screen says which field of its sheet a refused definition or change is about, or that it is about no field*.

### Requirement: A commitments screen keeps no era a change or a restart leaves holding no day, and a change back leaves the commitment as it was

**Reason**: Its restart sentences and scenarios are withdrawn with restarting (ADR-1067), and a
requirement cannot drop a scenario under its own heading.
**Migration**: Carried, otherwise verbatim, as *A commitments screen keeps no era a change leaves holding no day, and a change back leaves the commitment as it was*.
