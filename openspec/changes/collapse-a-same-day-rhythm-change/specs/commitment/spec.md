## ADDED Requirements

### Requirement: A commitments screen keeps no era a change or a restart leaves holding no day, and a change back leaves the commitment as it was

A commitments screen SHALL put on the era a change or a restart asks for as *A roster puts a new
era on a commitment it is keeping, from a day, and keeps no era holding no day* says. A restart from
a day before a later era's day kept from SHALL replace every era begun after that day, and the era
holding the day before SHALL be kept until then.

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

#### Scenario: a restart reaches behind a change made days ago and replaces it

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen opened
  at that roster place and at a record place where nothing has been kept as of Thursday 20 August
  2026 changes it to an interval rhythm of 5 days, under no category; and a commitments screen
  opened at those places as of Monday 31 August 2026 restarts it from Tuesday 18 August 2026, a day
  its every 4 days from 6 August was due on
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place reads back two eras of "Nails", the newer on
  every 5 days starting on Tuesday 18 August 2026, kept from that day, and the older on every 4 days
  starting on Thursday 6 August 2026, kept from Tuesday 4 August 2026
- **AND** asked about Monday 17 August 2026 it answers with both eras, and about Tuesday 18 August
  2026 with the newer alone
- **AND** a commitment alike restarted from Tuesday 25 August 2026 through a screen as of that day,
  and then from Sunday 23 August 2026 through one as of Monday 31 August 2026, reads back two eras,
  the newer on every 4 days starting on Sunday 23 August 2026

### Requirement: A roster store reads each commitment's eras mended

A roster store SHALL read each commitment's eras mended, whatever form they were kept in, and SHALL
read a copy to be restored the same way. Newest first, each era but the newest SHALL hold only days
before the day the kept era in front of it is kept from, read as kept until the day before where it
carries a later day kept until or none. An era but the newest that then holds no day SHALL be
dropped. Two eras side by side alike in schedule and kind, range or target included, SHALL be read
as one, kept from the older's day and carrying the newer's day kept until, state and category. The
newest era SHALL NOT be dropped for holding no day.

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
  Thursday, kept from 31 August 2026 and stopped as of 30 August 2026; and on one listing Monday,
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

### Requirement: A roster puts a new era on a commitment it is keeping, from a day, and keeps no era holding no day

A roster SHALL put a new era on a commitment it is keeping, on being given that commitment, the era
to put on it, a calendar date — the day the era it gives way to was kept until — and the category to
put the commitment under, which may be none. The new era SHALL take the place the commitment held
and SHALL become its newest era; the era it gives way to SHALL carry that date as the day it was
kept until and SHALL sit immediately behind it, and the roster SHALL then hold that commitment's
eras mended, as *A roster store reads each commitment's eras mended* says. The roster SHALL report that it put the era on, and
the commitment SHALL still be one commitment, kept, with the day kept from its earliest era has.

The roster SHALL refuse to put an era on a commitment it is not keeping — one it does not hold, one
it has stopped keeping and one it has deleted alike — and SHALL refuse an era that does not carry
that commitment's identity, its name or the sort of its kind; it SHALL report each and SHALL be left
exactly as it was. It SHALL refuse on no date: any calendar date the system supports SHALL be
accepted, the first and the last included. It SHALL NOT ask what day it is, SHALL NOT judge
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
- **AND** a roster that had deleted "Gym" refuses it too, and so does one that never held it

#### Scenario: putting an era that is not of that commitment on it is refused

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, is asked to put on it an era formed on its own, named "Gym" on
  a schedule listing Tuesday and Thursday, kept from 1 September 2026, as of 31 August 2026, under
  no category
- **THEN** the roster reports that it did not put the era on
- **AND** the roster is the same roster as one that was never asked
- **AND** an era carrying that commitment's identity but the name "Lifting" is refused too, and so
  is one of the note kind

#### Scenario: an era put on as of a day before the day the era it gives way to is kept from drops that era

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 March 2026, is asked to put a new era on it on a schedule listing Tuesday
  and Thursday, kept from 1 March 2026, as of 28 February 2026, under no category
- **THEN** the roster reports that it put the era on
- **AND** it reads back one era of that commitment, on Tuesday and Thursday, and says it is kept
  from 1 March 2026
- **AND** asked about 28 February 2026 it answers with the one on Tuesday and Thursday alone

#### Scenario: an era put on as of the first supported date and one as of the last are both accepted

- **WHEN** a roster holding a commitment named "Gym" and then one named "Run", both on a schedule
  listing Monday, Wednesday and Saturday and both kept from 1 March 2026, is asked to put a new era
  on "Gym" on a schedule listing Tuesday and Thursday as of 1 January 1583, and one on "Run" on that
  same schedule as of 31 December 9999, both new eras kept from 1 March 2026 and under no category
- **THEN** the roster reports of each that it put the era on
- **AND** it reads back one era of each, on Tuesday and Thursday, kept from 1 March 2026
- **AND** asked about 1 January 1583 it answers with those two eras alone, "Gym" first

#### Scenario: an era put on as of a day before a later era began replaces every era begun after that day

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, has a new era put on it on a schedule listing Tuesday and
  Thursday, kept from 1 September 2026, as of 31 August 2026, and then a new era on a schedule of
  3 times a week, kept from 20 August 2026, as of 19 August 2026, both under no category
- **THEN** the roster reports of each that it put the era on
- **AND** it reads back two eras of that commitment, the one on 3 times a week first, says it is
  kept from 1 January 2026 and says "3x a week"
- **AND** asked about 19 August 2026 it answers with both eras, and asked about 20 August 2026 with
  the one on 3 times a week alone

#### Scenario: an era put on alike the one it would give way to leaves that one the newest, as it was

- **WHEN** a roster holding a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, has a new era put on it on a schedule listing Tuesday and
  Thursday, kept from 31 August 2026, as of 30 August 2026, and then a new era on a schedule
  listing Monday, Wednesday and Saturday, kept from 31 August 2026, as of 30 August 2026, both under
  no category
- **THEN** the roster reports of each that it put the era on
- **AND** it reads back one commitment it is keeping and one era of it, on Monday, Wednesday and
  Saturday, kept from 1 January 2026
- **AND** a roster holding only that "Gym", asked to put on it an era on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 September 2026, as of 31 August 2026, reads back one era of
  it, kept from 1 January 2026

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

### Requirement: A roster store refuses what could not be a roster rather than emptying it, and mends what it can read

Opening a roster store at a place holding something this app cannot read as a roster store SHALL be
refused with an error. The store MUST NOT answer with a roster holding nothing in its place, MUST
NOT overwrite, move or delete what is there, and MUST NOT keep the part of it that could be read.

This app cannot read, as a roster store: content that is not a roster store; a roster store written
in a form later than the one this app knows; and a roster store holding something that could not be
a roster — a commitment that could not be formed, a date that names no day, one commitment held
twice, one commitment's eras with another commitment's entry standing between them, a commitment
held as removed with no day it was kept until, or a roster that says it was emptied and yet holds a
commitment. In a roster kept before a commitment had an identity, two entries alike in every part
that would each become a commitment of its own SHALL be one commitment held twice. Entries carrying
one identity SHALL be that commitment's eras, SHALL be read as one commitment and SHALL be read
mended, under *A roster store reads each commitment's eras mended*. A commitment of the number
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
- **AND** the content at each of the two places is byte-for-byte what it was before

#### Scenario: a roster store holding a commitment with half a range is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment is of the number kind carrying a lowest of 40 and no highest at all
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** a roster store at a place holding one commitment of the number kind carrying a highest of
  150 and no lowest at all is refused the same way
- **AND** the content at each of the two places is byte-for-byte what it was before

#### Scenario: a roster store holding a commitment removed with no day it was kept until is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form used before a
  commitment could be deleted, whose one commitment is held as removed and carries no day it was
  kept until
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store holding a commitment again after holding it stopped or removed is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form used before a
  commitment had an identity, whose two entries are the same commitment — named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026 — the first held stopped as of
  31 January 2026 and the second held kept
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** a roster store at a place holding the same two in that form, the first held removed as of
  31 January 2026, is refused the same way
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

#### Scenario: a roster store holding one commitment's eras split apart by another commitment's entry is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose three entries are two eras of one commitment named "Gym" — the newer on a schedule listing
  Tuesday and Thursday, kept from 1 March 2026, and the earlier on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026 and kept until 28 February 2026 — with the one
  entry of a commitment named "Run" standing between them
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before


#### Scenario: a roster store saying it was emptied while holding a commitment is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  which says it was emptied and holds one commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

## MODIFIED Requirements

### Requirement: A commitments screen changes a commitment by renaming it, moving the day it is kept from, or putting a new era on it

A commitments screen SHALL change a commitment on either of its lists from five things and no others
— a name, a rhythm, the day it is kept from, the category, which may be none, and the range or the
target its kind has room for — and SHALL work out from them which acts the change needs, doing each
it needs and no other, at the roster place alone. A different name SHALL rename the commitment
through every era of it. A different day kept from SHALL change the commitment's earliest era for
one kept from that day. A different rhythm, range or target SHALL put a new era on the commitment,
kept from the day the screen was handed — or from the day the commitment is kept from, where that
is later — with the era it gives way to kept until the day before; the
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

#### Scenario: a commitment kept from a day after today, changed before that day, keeps the day it is kept from

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  Friday 4 September 2026, is taken on at a roster place; a commitments screen is opened at that
  roster place and at a record place where nothing has been kept as of Tuesday 1 September 2026;
  and "Gym" is changed through it to a weekday-set rhythm of Tuesday and Thursday, on the name and
  the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place reads back one era of "Gym", on Tuesday and
  Thursday, kept from Friday 4 September 2026
- **AND** what the screen says "Gym" is made of says the day kept from 4 September 2026
- **AND** a commitment named "Nails" on an interval rhythm of 4 days, kept from that same Friday,
  changed alike to an interval rhythm of 5 days, reads back one era, on every 5 days starting on
  Friday 4 September 2026

### Requirement: A commitments screen refuses a restart it cannot make, and tells each refusal apart

A commitments screen SHALL refuse a restart from a date later than the day it was handed, from a
date earlier than the day the commitment is kept from, and from a date the commitment's newest era
is already due on, each told apart from every other refusal.

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

#### Scenario: a restart reaching behind a change is refused where a record the change's era holds would be left not due

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen opened
  at that roster place and at a record place where nothing has been kept as of Thursday 20 August
  2026 changes it to an interval rhythm of 5 days, under no category; a tick for it on Tuesday
  25 August 2026 is kept at that record place; and a commitments screen opened at those places as
  of Monday 31 August 2026 restarts it from Tuesday 18 August 2026
- **THEN** it is refused as a day already recorded on that the change would leave not due
- **AND** the content at both places is byte-for-byte what it was immediately after the second
  screen was opened

## REMOVED Requirements

### Requirement: A roster puts a new era on a commitment it is keeping, from a day

**Reason:** an era put on no longer leaves the one it gives way to holding no day (#305). Replaced by
*A roster puts a new era on a commitment it is keeping, from a day, and keeps no era holding no day*.

**Migration:** every scenario is carried under the new heading with its test. *An era put on as of a
day before the day the era it gives way to is kept from leaves it holding no day* goes, and its test
is renamed and rewritten as *an era put on as of a day before the day the era it gives way to is
kept from drops that era*; *an era put on as of the first supported date and one as of the last are
both accepted* keeps its title and its test changes to what it now says.

### Requirement: A roster store that cannot be read is refused rather than emptied

**Reason:** one era held twice in a roster that carries identities is mended rather than refused
(#305). Replaced by *A roster store refuses what could not be a roster rather than emptying it, and
mends what it can read*.

**Migration:** every scenario is carried under the new heading with its test, titles unchanged; *a
roster store holding what could not be a roster is refused* loses its fixture of one era held twice.
*A roster kept before a commitment had an identity holding one era twice is refused* goes, and its
test is rewritten as *a roster kept before a commitment had an identity holding an era that holds no
day is read back without it*.
