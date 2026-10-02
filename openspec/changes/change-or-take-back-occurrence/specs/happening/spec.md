## ADDED Requirements

### Requirement: An occurrence's time and note are changed in place, keeping its happening, its day and its place

Changing an occurrence SHALL give the occurrence held that is alike to it the time given, or none,
and the note given, or none, a note that says nothing held as no note; it SHALL keep that
occurrence's happening, its day and its place in the order noted. Where several held are alike to
it, the earliest noted SHALL be changed and every other left as it was. Changing SHALL be refused,
and what is held SHALL be unchanged, where no occurrence held is alike to it. A change to exactly
the time and the note the occurrence already holds SHALL be answered as not refused and SHALL
change nothing. Changing an occurrence SHALL change no happening.

#### Scenario: an occurrence changed keeps its happening, its day and its place in the order noted

- **WHEN** a happening named "Kopfweh" is held, occurrences of it are noted on 2 October 2026 at
  09:10 with the note "links" and on 1 October 2026 with no time and no note, and the first is
  changed to 18:40 with no note
- **THEN** changing it is not refused
- **AND** the occurrences held are "Kopfweh" on 2 October 2026 at 18:40 with no note, then
  "Kopfweh" on 1 October 2026 with no time and no note
- **AND** that first occurrence changed again to no time and a note of two spaces holds no time and
  no note, and is still held first

#### Scenario: of two occurrences alike, the earliest noted is the one changed

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are held, and occurrences are noted of
  "Kopfweh" on 2 October 2026 at 18:40, of "Augenmigräne" on that day with no time, and of
  "Kopfweh" on that day at 18:40, each with no note; and an occurrence alike to the first is
  changed to 09:10 with no note
- **THEN** changing it is not refused
- **AND** the occurrences held are "Kopfweh" at 09:10, "Augenmigräne" with no time, and "Kopfweh"
  at 18:40, in that order

#### Scenario: changing an occurrence not held is refused, and a change to what it holds changes nothing

- **WHEN** a happening named "Kopfweh" is held with one occurrence noted on 2 October 2026 at 09:10
  with the note "links", and an occurrence of "Kopfweh" on that day at 09:11 with the note "links"
  is changed to 18:40 with no note
- **THEN** changing it is refused
- **AND** what is held is the same as before it was changed
- **AND** the held occurrence changed to 09:10 with the note "links" is not refused, and what is held
  is the same as before

### Requirement: An occurrence is taken back one at a time, the rest kept in their order

Taking back an occurrence SHALL remove from what is held the earliest noted occurrence alike to it,
and only that one, and SHALL keep every other occurrence held in the order noted, those alike to it
included. Taking back SHALL be refused, and what is held SHALL be unchanged, where no occurrence
held is alike to it. Taking back SHALL change no happening, and a happening whose every occurrence
has been taken back SHALL still be held.

#### Scenario: an occurrence taken back is removed once, and the rest keep their order

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are held, occurrences are noted of
  "Kopfweh" on 2 October 2026 at 18:40, of "Augenmigräne" on that day with no time, and of
  "Kopfweh" on that day at 18:40, each with no note, and an occurrence alike to the first is taken
  back
- **THEN** taking it back is not refused
- **AND** the occurrences held are "Augenmigräne" with no time, then "Kopfweh" at 18:40
- **AND** once both of those are taken back no occurrence is held, and "Augenmigräne" and "Kopfweh"
  are still held

#### Scenario: taking back an occurrence not held is refused and changes nothing

- **WHEN** a happening named "Kopfweh" is held with one occurrence noted on 2 October 2026 at 09:10
  with the note "links", and an occurrence of "Kopfweh" on that day at 09:10 with no note is taken
  back
- **THEN** taking it back is refused
- **AND** what is held is the same as before it was taken back

### Requirement: A happening store keeps an occurrence changed or taken back

A happening store SHALL keep every change of an occurrence and every occurrence taken back at it
under the rules every change it keeps is under: kept at its place before it reports it kept,
refused with an error and not held where it cannot be kept, and refused without an error, leaving
the place untouched, where the happenings refuse it. It SHALL keep them in the form it already
writes. A store opened again SHALL hold the occurrences as changed and taken back, in the order
noted.

#### Scenario: a happening store opened again holds the occurrences as changed and taken back

- **WHEN** a happening named "Kopfweh" is added to a happening store; occurrences of it are noted on
  2 October 2026 at 09:10 with the note "links", on that day at 18:40 with no note, and on
  30 September 2026 with no time and no note; the first is changed to 08:00 with no note; the
  second is taken back; and a second store is opened at the same place
- **THEN** the second store holds two occurrences of "Kopfweh", in this order: on 2 October 2026 at
  08:00 with no note, and on 30 September 2026 with no time and no note

#### Scenario: a change or a take-back the happening store cannot keep is refused and not held

- **WHEN** a happening named "Kopfweh" is added to a happening store and an occurrence of it noted on
  2 October 2026 at 09:10 with no note; its place is then made so that it can be read from but not
  written to; and that occurrence is changed to 18:40 with no note
- **THEN** changing it is refused with an error
- **AND** the store holds the one occurrence at 09:10
- **AND** taking it back is refused with an error, and the store still holds it
- **AND** at a store whose place can be written, changing or taking back an occurrence it does not
  hold is refused without an error, and the content at that place is byte-for-byte what it was
  before
