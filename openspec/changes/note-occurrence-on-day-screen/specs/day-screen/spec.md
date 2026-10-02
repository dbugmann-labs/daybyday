## ADDED Requirements

### Requirement: A day screen reads its happenings beside its record, when opened, shown or returned to

A day screen given no happening place SHALL keep its happenings in the file of the happening
place's name beside its record place, the file a commitments screen given none keeps them in. It
SHALL read that place when it is opened, when the app is shown again and whenever it is returned
to, each a fresh opening that sees every change made there since, and what it says about its
happenings SHALL be formed again each time from what is then there. Reading it SHALL write nothing
there. A day screen SHALL list the happenings it holds in the order they were made.

#### Scenario: a day screen lists the happenings beside its record place in the order they were made

- **WHEN** happenings named "Augenmigräne" and then "Kopfweh" are added to a happening store at the
  file of the happening place's name beside a record place, and a day screen of no commitments at
  all is opened at that record place as of Friday 2 October 2026, given no happening place
- **THEN** it lists "Augenmigräne" and then "Kopfweh", and says it is keeping happenings
- **AND** the content at that happening place is byte-for-byte what it was before it was opened
- **AND** a day screen opened the same way beside a record place with no happening store beside it
  lists no happening, says it is keeping happenings, and leaves nothing at that happening place

#### Scenario: a day screen returned to or shown again reads its happening place afresh

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place where nothing has been kept; a commitments screen opened at that place makes a happening
  named "Kopfweh"; and the day screen is returned to from it
- **THEN** the day screen lists "Kopfweh"
- **AND** once that place then holds a run of bytes that is not a happening store and the app is
  shown again on that day, it lists no happening and says it is not keeping happenings

### Requirement: A day screen offers noting a happening on today or a past day, while it lists one

A day screen SHALL offer noting an occurrence of a happening exactly while the day it is showing is
the today it was handed or a day before it, and it lists at least one happening. It MUST NOT offer
it on a day after its today, nor while it lists no happening, nor while it is not keeping
happenings. Whether it offers it SHALL read no place and change nothing, and SHALL NOT depend on
what the screen says about its record, its roster, its one-offs or its birthdays.

#### Scenario: a day screen offers noting a happening on today and a past day, and not on a later day

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Kopfweh"
- **THEN** it offers noting a happening
- **AND** with the day it is showing moved to Wednesday 30 September 2026 it offers it
- **AND** with the day it is showing moved to Saturday 3 October 2026 it does not

#### Scenario: a day screen that lists no happening offers no noting, whatever its other places hold

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place where nothing has been kept
- **THEN** it does not offer noting a happening
- **AND** a day screen opened as of that day at a happening place holding "Kopfweh", a record place
  holding a run of bytes that is not a record and a one-off place holding a run of bytes that is not
  one-offs offers it

### Requirement: A day screen starts an occurrence's time at the time now on today, and at none on any other day

Asked what time an occurrence it would note starts at, and handed the moment it is now, a day screen
SHALL answer the hour and the minute of that moment where the day it is showing is that moment's
date, and no time where it is showing any other day, its own today included where that moment is on
a later date. Asking SHALL read no place and change nothing.

#### Scenario: an occurrence's time starts at now on today and at none on a past day

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Kopfweh", and is asked what time an occurrence starts at, it being Friday
  2 October 2026 at 18:52
- **THEN** it answers 18:52
- **AND** with the day it is showing moved to Wednesday 30 September 2026, asked at the same moment,
  it answers no time
- **AND** a day screen opened as of Friday 2 October 2026 and showing that day, asked on Saturday
  3 October 2026 at 00:10, answers no time

### Requirement: A day screen notes an occurrence on the day it is showing, and keeps it before the day view says so

A day screen SHALL note an occurrence of a happening it lists on the day it is showing, at the time
it is given or at none, with what is committed as its note: blank space at the start and the end
disregarded, everything between kept exactly as written, and a note that says nothing noted as no
note. The occurrence SHALL be kept at the happening place before the day view is formed again from
what is then kept there. Two occurrences noted alike SHALL each be kept. A kept occurrence SHALL end
what the screen tells on a row, SHALL write nothing at the record, roster, one-off or birthday place,
and SHALL write no copy at the copy place.

#### Scenario: an occurrence noted on today is kept at the happening place and drawn on the day

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Kopfweh", and "Kopfweh" is noted through it at 18:40 with the note of two spaces,
  "Hinter dem Auge", a line break, "links" and two spaces, it being 18:52 on that day
- **THEN** noting it is not refused
- **AND** its day view holds one happening row, named "Kopfweh", saying "18:40"
- **AND** a happening store opened at that place holds one occurrence of "Kopfweh" on 2 October 2026
  at 18:40 with the note "Hinter dem Auge", a line break and "links"
- **AND** "Kopfweh" noted again at 18:40 with an empty note is not refused, the store then holds two
  occurrences, and the row says "18:40, 18:40"

#### Scenario: an occurrence noted with no time holds its day alone, on a past day and on today

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Kopfweh", the day it is showing is moved to Wednesday 30 September 2026, and
  "Kopfweh" is noted through it with no time and a note of three spaces, it being Friday
  2 October 2026 at 18:52
- **THEN** noting it is not refused
- **AND** a happening store opened at that place holds one occurrence of "Kopfweh" on
  30 September 2026 with no time and no note
- **AND** its day view holds one happening row, named "Kopfweh", saying "no time"
- **AND** with the day it is showing moved back to Friday 2 October 2026, "Kopfweh" noted with no
  time is not refused

#### Scenario: noting an occurrence writes no copy, leaves the other places as they were and ends a notice

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026,
  is taken on at a roster place; a day screen is opened at that roster place, at a happening place
  holding "Kopfweh", and at a record place, a one-off place and a birthday place where nothing has
  been kept, as of Friday 2 October 2026, keeping its copy place at a place of its own and asking a
  clock that answers a later minute each time it is asked, from that day at 14:32; a directory of
  its own is given to it as its copy place; and "Kopfweh" is noted through it at 14:00, it being
  14:40 on that day
- **THEN** noting it is not refused
- **AND** the last copy made is still Friday 2 October 2026 at 14:32
- **AND** the content at the roster place is byte-for-byte what it was before "Kopfweh" was noted,
  and nothing is kept at the record place, the one-off place or the birthday place
- **AND** a day screen whose tick on "Gym" was refused at a record place where nothing can be
  written tells nothing on that row once "Kopfweh" is noted through it

### Requirement: A day screen refuses an occurrence on a day or at a time that has not come, and one it cannot keep

Noting an occurrence SHALL be refused as not yet come where the day the screen is showing is later
than its today or than the date of the moment it is handed as now, or where the time given, on the
day shown, is later than that moment; a time at that very minute SHALL NOT be refused. It SHALL be
refused as not kept where the happening place cannot be written, where the screen is not keeping
happenings, and where the happening is not one it lists. A refused occurrence SHALL write nothing,
and SHALL leave the day view and what the screen tells on a row as they were.

#### Scenario: an occurrence at a time later than now, or on a day that has not come, is refused as not yet come

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Kopfweh", and "Kopfweh" is noted through it at 18:53 with no note, it being 18:52
  on that day
- **THEN** noting it is refused as not yet come
- **AND** a happening store opened at that place holds no occurrence, and its day view holds no
  happening row
- **AND** "Kopfweh" noted at 18:52 at that same moment is not refused
- **AND** with the day it is showing moved to Saturday 3 October 2026, "Kopfweh" noted with no time is
  refused as not yet come

#### Scenario: an occurrence the happening place cannot take is refused as not kept

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Kopfweh" that is then made so that it can be read from but not written to, and
  "Kopfweh" is noted through it at 09:10, it being 18:52 on that day
- **THEN** noting it is refused as not kept
- **AND** its day view holds no happening row
- **AND** at a happening place that can be written, a happening named "Schlecht geschlafen", made on
  its own and never listed, noted through it is refused as not kept, and the content at that place is
  byte-for-byte what it was before

### Requirement: A day view holds a row for each happening that came on its date, saying the times it came

A day view SHALL hold one happening row for each happening with at least one occurrence on its date,
and none for a happening without one, in the order the happenings were made. A row SHALL say the
happening's name as it is now held, and the times its occurrences on that date came: each timed
occurrence's hour and minute as two digits each on the twenty-four-hour clock, joined by a colon,
earliest first, then "no time" for each occurrence without one, all joined by a comma and a space,
every occurrence said once however many are alike. A row SHALL say no note. The day views a day
screen says for the day either side SHALL hold their rows as a move there would.

#### Scenario: a happening row says its times earliest first, then each occurrence with no time

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Kopfweh", and "Kopfweh" is noted through it with no time, then at 18:40, then at
  09:10, it being 18:52 on that day
- **THEN** its day view holds one happening row, named "Kopfweh", saying "09:10, 18:40, no time"

#### Scenario: a day view holds rows only for the happenings that came, in the order they were made

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Augenmigräne", "Kopfweh" and "Schlecht geschlafen", and "Kopfweh" is noted through
  it at 09:10 and then "Augenmigräne" with no time, it being 18:52 on that day
- **THEN** its day view holds two happening rows: "Augenmigräne" saying "no time", then "Kopfweh"
  saying "09:10"
- **AND** the day view it says for the day before holds no happening row
- **AND** with the day it is showing moved to Saturday 3 October 2026, the day view it says for the
  day before holds the same two rows
- **AND** once "Kopfweh" is renamed "Spannungskopfweh" through a commitments screen at that place and
  the day screen, moved back to Friday 2 October 2026, is returned to from it, its second row is named
  "Spannungskopfweh"

### Requirement: A day screen that cannot read its happening place lists none, offers no noting and holds no happening row

A day screen whose happening place cannot be read SHALL list no happening, SHALL offer no noting,
SHALL hold no happening row on any day, and SHALL say that it is not keeping happenings, telling
apart one cause, a store written by a later version of DayByDay, from every other. It MUST NOT write
over what is at the place. It SHALL draw its commitments, its one-offs and its birthdays as ever,
SHALL NOT say a copy can be restored on that account, and what it says about its record, its roster
and its one-offs SHALL NOT be read off that place.

#### Scenario: a day screen that cannot read its happening place lists none and leaves the place as it was

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a run of bytes that is not a happening store is
  written at a happening place; and a day screen is opened at both as of Friday 2 October 2026
- **THEN** it lists no happening, says it is not keeping happenings, and does not say they were
  written by a later version of DayByDay
- **AND** it does not offer noting a happening, and its day view holds one row, named "Gym", and no
  happening row
- **AND** it says it is keeping a record, a roster and one-offs, and does not say a copy can be
  restored
- **AND** the content at that happening place is byte-for-byte what it was before

#### Scenario: a happening place written by a later version makes a day screen that says so

- **WHEN** a happening store declaring a form later than this app writes is written at a happening
  place, and a day screen of no commitments at all is opened at that place as of Friday
  2 October 2026
- **THEN** it lists no happening and says its happenings were written by a later version of DayByDay
- **AND** it does not offer noting a happening
- **AND** the content at that happening place is byte-for-byte what it was before
