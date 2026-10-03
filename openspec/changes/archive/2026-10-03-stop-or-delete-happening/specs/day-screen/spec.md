## ADDED Requirements

### Requirement: A day screen still draws a stopped happening's rows and opens its occurrences, and notes none of it

A day screen SHALL hold a happening row for a stopped happening on each day it came, as for any
other happening, and SHALL change and take back that happening's occurrences under the rules every
occurrence's change and take-back are under. Noting an occurrence of a stopped happening through it
SHALL be refused as not kept, and SHALL write nothing. A happening deleted at its happening place
SHALL be listed by none and have no row on any day once the screen has read that place again, and
changing or taking back an occurrence of it SHALL be refused as not kept.

#### Scenario: a stopped happening's row is still drawn on the days it came, and its occurrences are changed and taken back

- **WHEN** a happening named "Kopfweh" is added to a happening store at a happening place,
  occurrences of it are noted there on 30 September 2026 at 09:10 and at 18:40, each with no note,
  and "Kopfweh" is stopped there; and a day screen of no commitments at all is opened at that place
  as of Friday 2 October 2026, with the day it is showing moved to Wednesday 30 September 2026, it
  being 18:52 on Friday 2 October 2026
- **THEN** its day view holds one happening row, named "Kopfweh", saying "09:10, 18:40"
- **AND** asked for that row's occurrences, it answers the two
- **AND** the first changed through it to 08:00 with the note "links" is not refused, and the row
  says "08:00, 18:40"
- **AND** the second taken back through it is not refused, and the row says "08:00"
- **AND** a happening store opened at that place holds "Kopfweh" stopped, with one occurrence, on
  30 September 2026 at 08:00 with the note "links"

#### Scenario: noting a stopped happening through a day screen is refused as not kept

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are added to a happening store at a
  happening place and "Kopfweh" is stopped there; a day screen of no commitments at all is opened at
  that place as of Friday 2 October 2026; and "Kopfweh" is noted through it at 09:10, it being 18:52
  on that day
- **THEN** noting it is refused as not kept
- **AND** a happening store opened at that place holds no occurrence, and its day view holds no
  happening row
- **AND** "Augenmigräne" noted through it at 09:10 is not refused

#### Scenario: a happening deleted through a commitments screen has no row on the days it came

- **WHEN** a day screen of no commitments at all is opened as of Friday 2 October 2026 at a happening
  place holding "Augenmigräne" and "Kopfweh"; "Kopfweh" is noted through it at 09:10 and
  "Augenmigräne" with no time, it being 18:52 on that day; "Kopfweh" is deleted through a
  commitments screen opened at that place as of that day, its name typed back; and the day screen is
  returned to from it
- **THEN** it lists "Augenmigräne" alone
- **AND** its day view holds one happening row, named "Augenmigräne", saying "no time"
- **AND** the occurrence of "Kopfweh" at 09:10, taken back through it, is refused as not kept

## MODIFIED Requirements

### Requirement: A day screen reads its happenings beside its record, when opened, shown or returned to

A day screen given no happening place SHALL keep its happenings in the file of the happening
place's name beside its record place, the file a commitments screen given none keeps them in. It
SHALL read that place when it is opened, when the app is shown again and whenever it is returned
to, each a fresh opening that sees every change made there since, and what it says about its
happenings SHALL be formed again each time from what is then there. Reading it SHALL write nothing
there. A day screen SHALL list the happenings it holds that are not stopped, in the order they were
made, a resumed one in its place among them.

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

#### Scenario: a day screen lists no stopped happening, and lists one resumed in its place

- **WHEN** happenings named "Augenmigräne", "Kopfweh" and "Schlecht geschlafen" are added to a
  happening store at a happening place and "Kopfweh" is stopped there, and a day screen of no
  commitments at all is opened at that place as of Friday 2 October 2026
- **THEN** it lists "Augenmigräne" and then "Schlecht geschlafen", and says it is keeping happenings
- **AND** once "Kopfweh" is resumed through a commitments screen at that place and the day screen is
  returned to from it, it lists "Augenmigräne", "Kopfweh" and then "Schlecht geschlafen"
- **AND** a day screen opened as of that day at a happening place holding "Kopfweh" alone, stopped,
  lists no happening, says it is keeping happenings, and does not offer noting a happening, nor with
  the day it is showing moved to Wednesday 30 September 2026

### Requirement: A day screen answers a happening row's occurrences on the day it is showing, in the row's order

Asked for a happening row's occurrences, a day screen SHALL answer every occurrence, on the day it
is showing, of the happening it holds under that row's name, stopped or not, and no other: those
with a time first, earliest first, then those with none, those at one time and those with none each
in the order noted. Each SHALL hold its note and say its time as a happening row says it: the hour
and the minute as two digits each on the twenty-four-hour clock, joined by a colon, or "no time". A
row naming no happening the screen holds, or one with no occurrence on that day, SHALL be answered
with none. Asking SHALL read no place and change nothing.

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
