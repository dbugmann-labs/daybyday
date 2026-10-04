## ADDED Requirements

### Requirement: A day screen notes an occurrence on the day it is showing, keeping it at the happening place before the day view says so

A day screen SHALL note an occurrence of a happening it lists on the day it is showing, at the time
it is given or at none, with what is committed as its note: blank space at the start and the end
disregarded, everything between kept exactly as written, and a note that says nothing noted as no
note. The occurrence SHALL be kept at the happening place before the day view is formed again from
what is then kept there. Two occurrences noted alike SHALL each be kept. A kept occurrence SHALL end
what the screen tells on a row, and SHALL write nothing at the record, roster, one-off or birthday
place.

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

#### Scenario: noting an occurrence leaves the other places as they were and ends a notice

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026,
  is taken on at a roster place; a day screen is opened at that roster place, at a happening place
  holding "Kopfweh", and at a record place, a one-off place and a birthday place where nothing has
  been kept, as of Friday 2 October 2026, keeping its copy place at a place of its own and asking a
  clock that answers a later minute each time it is asked, from that day at 14:32; a directory of
  its own is given to it as its copy place; and "Kopfweh" is noted through it at 14:00, it being
  14:40 on that day
- **THEN** noting it is not refused
- **AND** the content at the roster place is byte-for-byte what it was before "Kopfweh" was noted,
  and nothing is kept at the record place, the one-off place or the birthday place
- **AND** a day screen whose tick on "Gym" was refused at a record place where nothing can be
  written tells nothing on that row once "Kopfweh" is noted through it

### Requirement: A day screen changes an occurrence's time and note, keeping the change at the happening place before the day view says so

A day screen SHALL change an occurrence held at its happening place to the time it is given or to
none, and to what is committed as its note, judged exactly as a note committed when noting is
judged. The change SHALL be kept at the happening place before the day view is formed again from
what is then kept there. A change to exactly the time and the note the occurrence holds, the
committed note judged first, SHALL ask for no change: it SHALL write nothing, change nothing and
SHALL NOT be refused. A kept change SHALL end what the screen tells on a row, and SHALL write nothing
at the record, roster, one-off or birthday place.

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

#### Scenario: changing or taking back an occurrence leaves the other places as they were and ends a notice

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026,
  is taken on at a roster place; a day screen is opened at that roster place, at a happening place
  holding "Kopfweh", and at a record place, a one-off place and a birthday place where nothing has
  been kept, as of Friday 2 October 2026, keeping its copy place at a place of its own and asking a
  clock that answers a later minute each time it is asked, from that day at 14:32; a directory of
  its own is given to it as its copy place; "Kopfweh" is noted through it at 14:00 and at 14:05; the
  first is changed to 14:10; and the second is taken back, it being 14:40 on that day
- **THEN** neither the change nor the take-back is refused
- **AND** the content at the roster place is byte-for-byte what it was before "Kopfweh" was noted,
  and nothing is kept at the record place, the one-off place or the birthday place
- **AND** a day screen whose tick on "Gym" was refused at a record place where nothing can be
  written, after an occurrence was noted through it, tells nothing on that row once that occurrence
  is changed, and the same once it is taken back after a second refused tick

## MODIFIED Requirements

### Requirement: A day screen takes an occurrence back, and keeps that before the day view says so

A day screen SHALL take back an occurrence held at its happening place, whatever day it is on,
removing that one alone where several held are alike, and SHALL keep that at the happening place
before the day view is formed again from what is then kept there. A happening whose last
occurrence on a day is taken back SHALL have no row on that day, and SHALL still be listed. A kept
take-back SHALL end what the screen tells on a row, and SHALL write nothing at the record, roster,
one-off or birthday place.

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

### Requirement: A day screen that cannot read its happening place lists none, offers no noting and holds no happening row

A day screen whose happening place cannot be read SHALL list no happening, SHALL offer no noting,
SHALL hold no happening row on any day, and SHALL say that it is not keeping happenings, telling
apart one cause, a store written by a later version of DayByDay, from every other. It MUST NOT write
over what is at the place. It SHALL draw its commitments, its one-offs and its birthdays as ever,
and what it says about its record, its roster and its one-offs SHALL NOT be read off that place.

#### Scenario: a day screen that cannot read its happening place lists none and leaves the place as it was

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a run of bytes that is not a happening store is
  written at a happening place; and a day screen is opened at both as of Friday 2 October 2026
- **THEN** it lists no happening, says it is not keeping happenings, and does not say they were
  written by a later version of DayByDay
- **AND** it does not offer noting a happening, and its day view holds one row, named "Gym", and no
  happening row
- **AND** it says it is keeping a record, a roster and one-offs
- **AND** the content at that happening place is byte-for-byte what it was before

#### Scenario: a happening place written by a later version makes a day screen that says so

- **WHEN** a happening store declaring a form later than this app writes is written at a happening
  place, and a day screen of no commitments at all is opened at that place as of Friday
  2 October 2026
- **THEN** it lists no happening and says its happenings were written by a later version of DayByDay
- **AND** it does not offer noting a happening
- **AND** the content at that happening place is byte-for-byte what it was before

## REMOVED Requirements

### Requirement: A day screen notes an occurrence on the day it is showing, and keeps it before the day view says so

**Reason**: Added back above under a name of its own, without the sentence that a kept occurrence
writes no copy and with its copy scenario retitled to match; an occurrence noted now writes a copy,
as the `restore` delta of this change requires.

**Migration**: The carried test that asserted no copy keeps everything else it asserts, is renamed
to the retitled scenario, and drops its last-copy assertion.

### Requirement: A day screen changes an occurrence's time and note, and keeps the change before the day view says so

**Reason**: Added back above under a name of its own, without the sentence that a kept change writes
no copy and with its copy scenario retitled to match; a change or a take-back now writes a copy, as
the `restore` delta of this change requires.

**Migration**: The carried test that asserted no copy keeps everything else it asserts, is renamed
to the retitled scenario, and drops its last-copy assertions.
