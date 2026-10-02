## ADDED Requirements

### Requirement: An occurrence is one happening, a day, a time of that day or none, and a note or none

An occurrence SHALL be of exactly one happening, named by its identity, and SHALL hold a calendar
date, a time of day or none, and a note or none, and nothing else. A time of day SHALL be an hour
and a minute; an hour outside the twenty-four or a minute outside the sixty SHALL form no time of
day. A note that says nothing, judged exactly as a happening's name is judged, SHALL be held as no
note, and any other note SHALL be kept exactly as given, with no blank space removed. Two
occurrences SHALL be alike exactly when their happening, their date, their time and their note are
alike.

#### Scenario: an occurrence holds its happening, its day, its time and its note as given

- **WHEN** an occurrence of a happening named "Kopfweh" is formed on 2 October 2026 at 09:10 with
  the note " Hinter dem Auge", a line break and "links "
- **THEN** it is an occurrence of "Kopfweh" on 2 October 2026 at 09:10
- **AND** its note is " Hinter dem Auge", a line break and "links ", with the blank space at both ends
- **AND** an occurrence of "Kopfweh" formed on that day with no time holds no time

#### Scenario: a note that says nothing is no note, and a time outside the clock is no time

- **WHEN** an occurrence of a happening named "Kopfweh" is formed on 2 October 2026 with no time and
  a note of two spaces, a line break and a tab
- **THEN** it holds no note
- **AND** one formed with an empty note holds no note
- **AND** no time of day is formed from hour 24 and minute 0, nor from hour 9 and minute 60
- **AND** a time of day is formed from hour 0 and minute 0, and from hour 23 and minute 59

### Requirement: Happenings hold the occurrences noted, each counted on its own, in the order noted

Happenings SHALL hold every occurrence noted to them, in the order it was noted, the newest last,
and SHALL count each on its own: an occurrence alike in every part to one already held SHALL be held
a second time. Noting an occurrence SHALL be refused, and what is held SHALL be unchanged, where the
happening it is of is not held. A rename SHALL keep every occurrence of the renamed happening as an
occurrence of it, and adding or renaming a happening SHALL change no occurrence held.

#### Scenario: occurrences are held in the order noted, and two alike are both held

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are held, and occurrences are noted of
  "Kopfweh" on 2 October 2026 at 18:40, of "Augenmigräne" on 1 October 2026 with no time, and of
  "Kopfweh" on 2 October 2026 at 18:40, each with no note
- **THEN** none of the three is refused
- **AND** the occurrences held are those three, in the order noted, the first and the third alike

#### Scenario: an occurrence of a happening not held is refused and changes nothing

- **WHEN** a happening named "Kopfweh" is held, and an occurrence of a happening named "Schlecht
  geschlafen", made on its own and never held, is noted on 2 October 2026 at 07:00
- **THEN** noting it is refused
- **AND** what is held is the same as before it was noted, holding no occurrence

#### Scenario: a happening renamed keeps its occurrences

- **WHEN** a happening named "Kopfweh" is held with one occurrence noted on 2 October 2026 at 09:10,
  and "Kopfweh" is renamed "Spannungskopfweh"
- **THEN** the one occurrence held is an occurrence of "Spannungskopfweh", on 2 October 2026 at 09:10
- **AND** a happening named "Augenmigräne" added afterwards leaves that occurrence the one held

### Requirement: A happening store keeps the occurrences noted at it, and reads its first form as holding none

A happening store SHALL keep every occurrence noted at it, with its happening, its date, its time
and its note, in the order noted, under the rules every change it keeps is under: kept at its place
before it reports it kept, refused and not held where it cannot be kept, and leaving the place
untouched where the happenings refuse it. It SHALL write a form one later than its first, and SHALL
read a store in its first form as holding its happenings and no occurrences, writing nothing there
on opening. A store holding an occurrence of an identity none of its happenings has, on a date that
names no day, or at a time that is not one SHALL be content that is not such a store.

#### Scenario: a happening store opened again holds the occurrences noted there, in their order

- **WHEN** a happening named "Kopfweh" is added to a happening store; an occurrence of it is noted on
  2 October 2026 at 09:10 with the note "links", and another on 30 September 2026 with no time and no
  note; "Kopfweh" is renamed "Spannungskopfweh"; and a second store is opened at the same place
- **THEN** the second store holds the two occurrences, in that order, each of "Spannungskopfweh"
- **AND** the first is on 2 October 2026 at 09:10 with the note "links", and the second on
  30 September 2026 with no time and no note

#### Scenario: an occurrence the happening store cannot keep is refused and not held

- **WHEN** a happening named "Kopfweh" is added to a happening store whose place is then made so that
  it can be read from but not written to, and an occurrence of "Kopfweh" is noted at it on
  2 October 2026 at 09:10
- **THEN** noting it is refused with an error
- **AND** the store holds "Kopfweh" and no occurrence
- **AND** at a store whose place can be written, an occurrence of a happening it does not hold is
  refused without an error, and the content at that place is byte-for-byte what it was before

#### Scenario: a happening store in its first form is read as holding no occurrences

- **WHEN** a happening store is opened at a place holding a store in the first form, holding a
  happening named "Kopfweh"
- **THEN** it opens without error, holding "Kopfweh" and no occurrence
- **AND** the content at that place is byte-for-byte what it was before it was opened
- **AND** once an occurrence of "Kopfweh" is noted at it on 2 October 2026 with no time, a store
  opened again at that place holds "Kopfweh" and that occurrence

#### Scenario: a happening store holding an occurrence that could not be one is refused

- **WHEN** a happening store is opened at a place holding a store in the form this app writes, holding
  a happening named "Kopfweh" and one occurrence of an identity no happening it holds has
- **THEN** opening is refused with an error saying it is not a happening store
- **AND** a store whose one occurrence of "Kopfweh" is on 30 February 2026 is refused the same way
- **AND** a store whose one occurrence of "Kopfweh" is at hour 24 and minute 0 is refused the same way
- **AND** the content at each place is byte-for-byte what it was before
