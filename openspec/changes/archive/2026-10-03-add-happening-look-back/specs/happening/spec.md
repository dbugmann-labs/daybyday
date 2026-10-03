## ADDED Requirements

### Requirement: A commitments screen answers a look-back at a happening it lists

A commitments screen SHALL answer a **look-back** at any happening it lists, and SHALL say in it that
happening's name exactly as the screen lists it. It SHALL answer no look-back at a happening it does
not list, and none at all while it cannot read its happening place. It SHALL answer one while it
cannot read its roster or its record. A happening's look-back SHALL be a value: asking for the same
happening twice SHALL answer the same look-back, and asking SHALL change nothing the screen holds or
tells and SHALL write nothing at any place it keeps.

#### Scenario: a commitments screen answers a look-back at a happening it lists, by its name as listed

- **WHEN** a commitments screen is opened as of 3 October 2026 at a happening place holding
  "Augenmigräne" and "Kopfweh", and is asked for a look-back at "Kopfweh"
- **THEN** it answers one, saying the name "Kopfweh"
- **AND** once "Kopfweh" is renamed through it to "Spannungskopfweh", a look-back asked for with the
  happening as it was before the rename says the name "Spannungskopfweh"

#### Scenario: a commitments screen answers no look-back at a happening it does not list, or while it cannot read its happening place

- **WHEN** a commitments screen is opened as of 3 October 2026 at a happening place holding
  "Kopfweh", and is asked for a look-back at a happening named "Schlecht geschlafen", made on its own
  and never listed
- **THEN** it answers no look-back
- **AND** a commitments screen opened at a happening place holding a run of bytes that is not a
  happening store answers no look-back at any happening

#### Scenario: a commitments screen that cannot read its roster or its record still answers a look-back at a happening

- **WHEN** a run of bytes that is not a roster store is written at a roster place and one that is not
  a record at a record place, and a commitments screen is opened at both as of 3 October 2026 at a
  happening place holding "Kopfweh" with one occurrence noted on 2 October 2026 at 18:40
- **THEN** it answers a look-back at "Kopfweh", saying one occurrence on "2 October 2026" at "18:40"

#### Scenario: asking a commitments screen for a happening's look-back changes nothing and writes nothing

- **WHEN** a commitments screen is opened as of 3 October 2026 at a happening place holding "Kopfweh"
  with one occurrence noted on 2 October 2026 at 18:40; a happening is made through it from an empty
  name and refused; and it is asked for a look-back at "Kopfweh" twice
- **THEN** both answers are the same look-back
- **AND** it still lists "Kopfweh" alone and still tells a name that says nothing
- **AND** the bytes at its happening place, its roster place and its record place are exactly what
  they were before the first ask

### Requirement: A happening's look-back says its occurrences newest first, each with its day, its time and its note

A happening's look-back SHALL say every occurrence of that happening its happening place holds, each
alike one said once for every time it is held, and no occurrence of another happening. It SHALL say
each with its day, said as a look-back says a day; its time, said as a day screen says a happening
row's occurrence's time; and its note exactly as held, every line break kept, or no note. It SHALL
say them by their day, the latest day first, whatever order they were noted in. Within one day it
SHALL say those with a time first, the latest time first, and then those with no time. Of two on one
day whose times are alike, or that both hold no time, the later noted SHALL be said first.

#### Scenario: a happening's look-back says its own occurrences, newest day first, each with its day, its time and its note

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are held, and occurrences are noted, in this
  order, of "Kopfweh" on 28 August 2026 at 07:15 with the note "Woke up with it.", of "Kopfweh" on
  2 October 2026 at 18:40 with the note "Behind the left eye", a line break and "then both", of
  "Augenmigräne" on 1 October 2026 at 09:00 with no note, and of "Kopfweh" on 14 July 2026 with no
  time and no note; and a commitments screen opened as of 3 October 2026 is asked for a look-back at
  "Kopfweh"
- **THEN** it says three occurrences, in this order: "2 October 2026" at "18:40" with the note
  "Behind the left eye", a line break and "then both"; "28 August 2026" at "07:15" with the note
  "Woke up with it."; and "14 July 2026" at "no time" with no note
- **AND** it says nothing about 1 October 2026

#### Scenario: a happening's look-back says a day's latest time first and its occurrences with no time after them

- **WHEN** a happening named "Kopfweh" is held, and occurrences of it are noted on 2 October 2026, in
  this order: with no time and the note "first", at 18:40 with no note, at 09:10 with no note, with no
  time and the note "second", and at 18:40 with the note "links"; and a commitments screen opened as
  of 3 October 2026 is asked for a look-back at it
- **THEN** it says five occurrences, in this order: "18:40" with the note "links", "18:40" with no
  note, "09:10" with no note, "no time" with the note "second", and "no time" with the note "first"

### Requirement: A happening's look-back counts every occurrence it says, and says the day it counts since

A happening's look-back SHALL say a **count** of the occurrences it says: that number said as a
look-back says a number, a single space and the word "times", except that where it says exactly one
occurrence the count SHALL be "1 time". The count SHALL be the number of occurrences it says and
nothing else, and SHALL NOT be a fraction, a rate or a percentage. It SHALL say the day of its
earliest occurrence by day, never by the order noted, said as a look-back says a day, as the day it
counts since.

#### Scenario: a happening's look-back counts every occurrence it says and says the day of the earliest

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are held, and occurrences are noted, in this
  order, of "Kopfweh" on 28 August 2026 at 07:15, of "Kopfweh" on 2 October 2026 at 18:40, of
  "Augenmigräne" on 1 October 2026 at 09:00, and of "Kopfweh" on 14 July 2026 with no time, each with
  no note; and a commitments screen opened as of 3 October 2026 is asked for a look-back at "Kopfweh"
- **THEN** its count says "3 times"
- **AND** it says the day it counts since "14 July 2026"

#### Scenario: a happening's look-back that says one occurrence counts it in the singular

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are held, and occurrences are noted of
  "Kopfweh" on 2 October 2026 at 18:40 and of "Augenmigräne" on 1 October 2026 at 09:00, each with no
  note; and a commitments screen opened as of 3 October 2026 is asked for a look-back at
  "Augenmigräne"
- **THEN** its count says "1 time"
- **AND** it says the day it counts since "1 October 2026"

### Requirement: A happening's look-back counts each calendar month from its earliest occurrence's through the current one

A happening's look-back SHALL say a month line for each calendar month from the month of the earliest
occurrence it says through the month of the day the screen holds, or through the month of the latest
occurrence it says where that month is later. The month lines SHALL run unbroken, newest first, a
month holding no occurrence included. Each SHALL say its month as a look-back says a month, and a
count of the occurrences the look-back says on that month's days, said as its whole count is said; a
month holding none SHALL say "0 times".

#### Scenario: a happening's look-back counts each calendar month from the earliest occurrence's through the current one, newest first

- **WHEN** a happening named "Kopfweh" is held, and occurrences of it are noted on 14 July 2026 at
  18:00, on 12 August 2026 at 09:00, on 28 August 2026 at 07:15, on 28 August 2026 with no time, on
  2 October 2026 at 18:40 and on 2 October 2026 with no time, each with no note; and a commitments
  screen opened as of 3 October 2026 is asked for a look-back at it
- **THEN** it says four month lines, in this order: "October 2026" saying "2 times", "September 2026"
  saying "0 times", "August 2026" saying "3 times" and "July 2026" saying "1 time"
- **AND** its count says "6 times"
- **AND** a commitments screen opened as of 15 November 2026 at that place says five month lines, the
  first "November 2026" saying "0 times"

#### Scenario: a happening's look-back runs its months unbroken across the turn of a year

- **WHEN** a happening named "Kopfweh" is held, and occurrences of it are noted on 20 December 2025
  and on 3 February 2026, each with no time and no note; and a commitments screen opened as of
  5 February 2026 is asked for a look-back at it
- **THEN** it says three month lines, in this order: "February 2026" saying "1 time", "January 2026"
  saying "0 times" and "December 2025" saying "1 time"

#### Scenario: a happening's look-back says an occurrence on a day after the one the screen holds, and counts its month

- **WHEN** a happening named "Kopfweh" is held, and occurrences of it are noted on 20 October 2026
  and on 1 November 2026, each at 09:00 with no note; and a commitments screen opened as of
  31 October 2026 is asked for a look-back at it
- **THEN** it says two occurrences, "1 November 2026" and then "20 October 2026"
- **AND** its count says "2 times"
- **AND** it says two month lines, "November 2026" saying "1 time" and then "October 2026" saying
  "1 time"

### Requirement: A happening's look-back with nothing noted says its name and nothing else

Where its happening place holds no occurrence of a happening, that happening's look-back SHALL say
the happening's name, and SHALL say no occurrence, no count, no month line and no day it counts
since. It SHALL say the same where every occurrence of the happening has been taken back, and the
occurrences of another happening SHALL NOT change it.

#### Scenario: a happening's look-back with nothing noted says its name and nothing else

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are held, and one occurrence of
  "Augenmigräne" is noted on 1 October 2026 at 09:00 with no note; and a commitments screen opened
  as of 3 October 2026 is asked for a look-back at "Kopfweh"
- **THEN** it says the name "Kopfweh"
- **AND** it says no occurrence, no count, no month line and no day it counts since
- **AND** a look-back at "Augenmigräne" once its one occurrence has been taken back says the same
