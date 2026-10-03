## ADDED Requirements

### Requirement: A day screen answers a happening row's occurrences on the day it is showing, in the row's order

Asked for a happening row's occurrences, a day screen SHALL answer every occurrence, on the day it
is showing, of the happening it lists under that row's name, and no other: those with a time first,
earliest first, then those with none, those at one time and those with none each in the order
noted. Each SHALL hold its note and say its time as a happening row says it: the hour and the
minute as two digits each on the twenty-four-hour clock, joined by a colon, or "no time". A row
naming no happening the screen lists, or one with no occurrence on that day, SHALL be answered with
none. Asking SHALL read no place and change nothing.

#### Scenario: a happening row's occurrences are answered in the row's order, each with its time and its note

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Kopfweh", and "Kopfweh" is noted through it with no time and the note "Schwindel",
  at 18:40 with no note, at 09:10 with the note "Hinter dem Auge", and at 09:10 with the note
  "links", in that order, it being 18:52 on that day
- **THEN** asked for the occurrences of its day view's one happening row, it answers four: 09:10
  with the note "Hinter dem Auge", 09:10 with "links", 18:40 with no note, and one with no time and
  the note "Schwindel", in that order
- **AND** their times say "09:10", "09:10", "18:40" and "no time"

#### Scenario: a happening row's occurrences are those of the day the screen is showing

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Kopfweh"; "Kopfweh" is noted through it at 09:10; the day it is showing is moved to
  Thursday 1 October 2026 and "Kopfweh" is noted at 07:00; and the day is moved back, it being 18:52
  on Friday 2 October 2026
- **THEN** asked for the occurrences of its day view's one happening row, it answers the one at 09:10
- **AND** with the day it is showing moved to Thursday 1 October 2026, the same row answers the one
  at 07:00, and moved to Wednesday 30 September 2026 it answers none
- **AND** once "Kopfweh" is renamed "Spannungskopfweh" through a commitments screen at that place
  and the day screen is returned to from it, the row taken before the rename answers none

### Requirement: A day screen changes an occurrence's time and note, and keeps the change before the day view says so

A day screen SHALL change an occurrence held at its happening place to the time it is given or to
none, and to what is committed as its note, judged exactly as a note committed when noting is
judged. The change SHALL be kept at the happening place before the day view is formed again from
what is then kept there. A change to exactly the time and the note the occurrence holds, the
committed note judged first, SHALL ask for no change: it SHALL write nothing, change nothing and
SHALL NOT be refused. A kept change SHALL end what the screen tells on a row, SHALL write nothing at
the record, roster, one-off or birthday place, and SHALL write no copy at the copy place.

#### Scenario: an occurrence changed through a day screen is kept at the happening place and drawn on the day

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Kopfweh"; "Kopfweh" is noted through it at 09:10 with the note "links" and at 18:40
  with no note; and the first is changed through it to 07:30 with the note of two spaces, "rechts"
  and two spaces, it being 18:52 on that day
- **THEN** changing it is not refused
- **AND** its day view holds one happening row, named "Kopfweh", saying "07:30, 18:40"
- **AND** a happening store opened at that place holds "Kopfweh" on 2 October 2026 at 07:30 with the
  note "rechts", then at 18:40 with no note
- **AND** that occurrence then changed to no time and a note of three spaces is not refused, the store
  holds it first with no time and no note, and the row says "18:40, no time"

#### Scenario: a change to the time and note an occurrence holds asks for no change

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Kopfweh"; "Kopfweh" is noted through it at 09:10 with the note "links"; the place
  is then made so that it can be read from but not written to; and that occurrence is changed
  through it to 09:10 with the note "links" and a space, it being 18:52 on that day
- **THEN** changing it is not refused
- **AND** the content at that happening place is byte-for-byte what it was before it was changed
- **AND** its day view holds one happening row, named "Kopfweh", saying "09:10"

#### Scenario: changing or taking back an occurrence writes no copy, leaves the other places as they were and ends a notice

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026,
  is taken on at a roster place; a day screen is opened at that roster place, at a happening place
  holding "Kopfweh", and at a record place, a one-off place and a birthday place where nothing has
  been kept, as of Friday 2 October 2026, keeping its copy place at a place of its own and asking a
  clock that answers a later minute each time it is asked, from that day at 14:32; a directory of
  its own is given to it as its copy place; "Kopfweh" is noted through it at 14:00 and at 14:05; the
  first is changed to 14:10; and the second is taken back, it being 14:40 on that day
- **THEN** neither the change nor the take-back is refused
- **AND** the last copy made is still Friday 2 October 2026 at 14:32
- **AND** the content at the roster place is byte-for-byte what it was before "Kopfweh" was noted,
  and nothing is kept at the record place, the one-off place or the birthday place
- **AND** a day screen whose tick on "Gym" was refused at a record place where nothing can be
  written, after an occurrence was noted through it, tells nothing on that row once that occurrence
  is changed, and the same once it is taken back after a second refused tick

### Requirement: A day screen takes an occurrence back, and keeps that before the day view says so

A day screen SHALL take back an occurrence held at its happening place, whatever day it is on,
removing that one alone where several held are alike, and SHALL keep that at the happening place
before the day view is formed again from what is then kept there. A happening whose last
occurrence on a day is taken back SHALL have no row on that day, and SHALL still be listed. A kept
take-back SHALL end what the screen tells on a row, SHALL write nothing at the record, roster,
one-off or birthday place, and SHALL write no copy at the copy place.

#### Scenario: an occurrence taken back through a day screen is gone from the place and from the row

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Kopfweh"; "Kopfweh" is noted through it at 18:40, at 09:10 and at 18:40, each with
  no note; and an occurrence alike to the first is taken back through it, it being 18:52 on that day
- **THEN** taking it back is not refused
- **AND** its day view holds one happening row, named "Kopfweh", saying "09:10, 18:40"
- **AND** a happening store opened at that place holds two occurrences: at 09:10, then at 18:40
- **AND** once those two are taken back its day view holds no happening row, and it still lists
  "Kopfweh" and offers noting a happening
- **AND** with the day it is showing moved to Wednesday 30 September 2026, "Kopfweh" noted there with
  no time and then taken back is not refused, and that day's view holds no happening row

### Requirement: A day screen refuses a change to a time that has not come, and a change or take-back it cannot keep

Changing an occurrence SHALL be refused as not yet come where its day is later than the screen's
today or than the date of the moment handed as now, or where it is on that moment's date and the
time given is later than that moment; a time at that very minute SHALL NOT be refused, nor any time
on an earlier day. Changing and taking back SHALL each be refused as not kept where the happening
place cannot be written, where the screen is not keeping happenings, and where no occurrence alike
to the one given is held there. A refused change or take-back SHALL write nothing, and SHALL leave
the day view and what the screen tells on a row as they were.

#### Scenario: a change to a time later than now is refused as not yet come

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Kopfweh"; "Kopfweh" is noted through it at 09:10 with no note; and that occurrence
  is changed through it to 18:53 with no note, it being 18:52 on that day
- **THEN** changing it is refused as not yet come
- **AND** a happening store opened at that place holds it at 09:10, and the row says "09:10"
- **AND** the same occurrence changed to 18:52 at that same moment is not refused
- **AND** with the day it is showing moved to Wednesday 30 September 2026, "Kopfweh" noted there with
  no time and changed to 23:59 is not refused
- **AND** an occurrence of "Kopfweh" on Saturday 3 October 2026 with no time, noted at a happening
  store at that place before the screen is opened, changed through it with the day it is showing
  moved there is refused as not yet come

#### Scenario: a change or a take-back the happening place cannot take is refused as not kept

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Kopfweh"; "Kopfweh" is noted through it at 09:10 with no note; the place is then
  made so that it can be read from but not written to; and that occurrence is changed through it to
  10:00 with no note, it being 18:52 on that day
- **THEN** changing it is refused as not kept
- **AND** taking it back through it is refused as not kept
- **AND** its day view holds one happening row, named "Kopfweh", saying "09:10"
- **AND** at a happening place that can be written, an occurrence of "Kopfweh" on that day at 11:11,
  never noted, changed or taken back through it is refused as not kept, and the content at that
  place is byte-for-byte what it was before
- **AND** a day screen whose happening place holds a run of bytes that is not a happening store
  refuses as not kept both a change and a take-back of an occurrence of a happening named "Kopfweh",
  made on its own, and the content at that place is byte-for-byte what it was before
