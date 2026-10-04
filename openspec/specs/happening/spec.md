# happening Specification

## Purpose
Describes what a happening is to DayByDay — a name for something that comes to a person rather than
something they owe — how happenings are held, made and renamed, the store that keeps them across the
app being closed, and the section of the commitments screen where a person makes and renames them.

## Requirements

### Requirement: A happening is a name and an identity, and nothing else

A happening SHALL be a name and an identity, and SHALL carry nothing else: no rhythm, no day it is
kept from, no kind and no category. The identity SHALL be given when the happening is made, and
SHALL never be derived from its name or changed by a rename. Two happenings SHALL be the same
happening exactly when their identities are the same, however their names compare, so two made
separately SHALL be two happenings even where their names are equal. Making a happening from a name
that says nothing SHALL be refused, judged exactly as a commitment's name is judged. A happening's
name SHALL be kept exactly as it was given, with no blank space removed from either end.

#### Scenario: two happenings made separately from one name are two happenings

- **WHEN** a happening is made from the name "Kopfweh", and another is made from the name "Kopfweh"
- **THEN** the two are different happenings
- **AND** each is the same happening as itself

#### Scenario: a happening's name is kept exactly as it was given

- **WHEN** a happening is made from the name " Kopfweh "
- **THEN** its name is " Kopfweh ", with the blank space at both ends

#### Scenario: a name that says nothing makes no happening

- **WHEN** a happening is made from an empty name
- **THEN** making it is refused and no happening is made
- **AND** a happening made from a name of blank space alone is refused the same way
- **AND** a happening made from a name of one character that is not blank space is made

### Requirement: Happenings hold the happenings made, in the order made, and refuse a second with one name

Happenings SHALL hold every happening added to them, in the order they were added, the newest last.
Adding a happening SHALL be refused where a happening they hold has the same name, or is the same
happening; the refusal SHALL be answered rather than silent, and what is held SHALL be unchanged by
it. Two names SHALL be one name where they differ only in the case of their letters, only in blank
space at the start or the end of them, or only in both; every other difference, blank space inside a
name included, SHALL make two names. Happenings SHALL answer, for any name, the happening they hold
that has that name, or none.

#### Scenario: happenings are held in the order they were added, the newest last

- **WHEN** happenings named "Augenmigräne", "Kopfweh" and "Schlecht geschlafen" are added in that
  order
- **THEN** none of the three is refused
- **AND** the happenings held are "Augenmigräne", "Kopfweh" and then "Schlecht geschlafen"

#### Scenario: adding a happening whose name one held already has is refused and changes nothing

- **WHEN** a happening named "Kopfweh" is held, and a happening named "kopfweh" is added
- **THEN** adding it is refused
- **AND** what is held is the same as before it was added
- **AND** the happening held that has the name "kopfweh" is the one named "Kopfweh"
- **AND** a happening named " KOPFWEH " is refused the same way, and so is the held "Kopfweh" added
  again
- **AND** a happening named "Kopf weh" is added and held after "Kopfweh"

### Requirement: A happening is renamed in place, keeping its identity and its place

Renaming a happening that is held SHALL give it the new name exactly as given, and SHALL keep its
identity and its place among the happenings held. Renaming SHALL be refused, and what is held SHALL
be unchanged, where the happening is not held, where the new name says nothing, and where another
happening held has the new name, judged as adding one judges names. The happening's own name SHALL
NOT refuse its rename, so a rename that changes only the case of its letters SHALL be made, and a
rename to exactly the name it already has SHALL be answered as not refused and SHALL change nothing.

#### Scenario: a happening renamed keeps its identity and its place

- **WHEN** happenings named "Augenmigräne", "Kopfweh" and "Schlecht geschlafen" are held, and
  "Kopfweh" is renamed "Spannungskopfweh"
- **THEN** renaming it is not refused
- **AND** the happenings held are "Augenmigräne", "Spannungskopfweh" and then "Schlecht geschlafen"
- **AND** "Spannungskopfweh" is the same happening "Kopfweh" was
- **AND** no happening held has the name "Kopfweh"

#### Scenario: renaming a happening onto another's name, to a name that says nothing, or when it is not held, is refused

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are held, and "Kopfweh" is renamed
  "augenmigräne"
- **THEN** renaming it is refused
- **AND** what is held is unchanged
- **AND** renaming "Kopfweh" to a name of blank space alone is refused the same way
- **AND** renaming a happening named "Schlecht geschlafen", which is not held, is refused the same way
- **AND** renaming "Kopfweh" to "KOPFWEH" is not refused, and the happenings held are "Augenmigräne"
  and then "KOPFWEH"

### Requirement: A happening store keeps happenings at a place, across the app being closed and opened again

A happening store SHALL be opened at a place and SHALL hold happenings: every happening added there,
with its identity, its name and its place in their order, every rename applied. It SHALL be a store
of its own, holding nothing another store holds. Opening a store where nothing has been kept SHALL
hold no happenings rather than give an error. Every change SHALL be kept at that place before the
store reports it kept, and nothing SHALL be held only in memory. A change that cannot be kept SHALL
be refused and not held, and a change the happenings themselves refuse SHALL leave the place
untouched. Stores at different places SHALL be independent.

#### Scenario: a happening store opened where nothing has been kept holds no happenings

- **WHEN** a happening store is opened at a place where no happening store has ever been kept
- **THEN** it opens without error
- **AND** it holds no happenings

#### Scenario: a happening store opened again holds the happenings left there, renamed and in their order

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are added to a happening store and
  "Kopfweh" is renamed "Spannungskopfweh", and a second store is then opened at the same place with
  the first still open and nothing else done to it
- **THEN** the second store holds "Augenmigräne" and then "Spannungskopfweh"
- **AND** each is the same happening the first store holds under that name

#### Scenario: a happening change that cannot be kept is refused and not held

- **WHEN** a happening store is opened at a place where nothing can be written — a path beneath an
  existing ordinary file — and a happening named "Kopfweh" is added to it
- **THEN** adding it is refused with an error
- **AND** the store holds no happenings
- **AND** renaming "Kopfweh" at a store whose place holds it and is then made so that it can be read
  from but not written to is refused with an error, and that store still holds "Kopfweh"

#### Scenario: a change the happenings refuse leaves the happening store's place untouched

- **WHEN** a happening named "Kopfweh" is added to a happening store, and a happening named
  "kopfweh" is then added
- **THEN** the second addition is refused without an error
- **AND** the content at that place is byte-for-byte what it was after the first addition
- **AND** renaming "Kopfweh" to a name of blank space alone is refused without an error and leaves
  that content the same

#### Scenario: happening stores at different places are independent

- **WHEN** a happening named "Kopfweh" is added to a happening store at one place, and a happening
  store is opened at a different place where nothing has been kept
- **THEN** the second store holds no happenings
- **AND** a store opened afterwards at the first place holds "Kopfweh"

### Requirement: A happening store that cannot be read is refused rather than emptied

Opening a happening store at a place holding something this app cannot read as one SHALL be refused
with an error, and the store SHALL say which of two causes it is: content that is not such a store,
or a store written in a form later than the one this app writes. The store MUST NOT hold no
happenings instead, overwrite or delete what is there, or keep the part that could be read: the
whole SHALL be refused and what is there left unchanged. A store holding what could not be a
happening, or what happenings could not hold — a name that says nothing, an identity that is not one,
two happenings with one name, two with one identity — SHALL be content that is not such a store.

#### Scenario: content that is not a happening store is refused and left as it was

- **WHEN** a happening store is opened at a place holding content that is not a happening store — a
  run of bytes that is not what the store writes
- **THEN** opening is refused with an error saying it is not a happening store
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a happening store written in a later form than this app knows is refused

- **WHEN** a happening store is opened at a place holding a happening store written in a form one
  later than the form this app writes, holding no happenings
- **THEN** opening is refused with an error saying it was written in a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a happening store holding what could not be a happening is refused

- **WHEN** a happening store is opened at a place holding a store in the form this app writes, whose
  one happening has a name of blank space alone
- **THEN** opening is refused with an error saying it is not a happening store
- **AND** a store whose one happening carries an identity that is not one is refused the same way
- **AND** a store holding happenings named "Kopfweh" and "kopfweh" is refused the same way
- **AND** a store holding two happenings with one identity, named "Kopfweh" and "Augenmigräne", is
  refused the same way
- **AND** the content at each place is byte-for-byte what it was before

### Requirement: A commitments screen keeps its happenings at a place of its own

The app SHALL name the place happenings are kept at: one file inside the directory belonging to this
app within the platform's application-support directory, the same place every time it is asked for,
and never the caches directory or the temporary directory. It SHALL be none of the places the record,
the roster, the one-offs and the birthday ticks are kept at. A commitments screen given no happening
place SHALL keep its happenings in the file of that name beside its record place, which for a screen
given no record place either SHALL be the place the app names.

#### Scenario: the happening place is a file of the app's own under Application Support, the same every time

- **WHEN** the place happenings are kept at is asked for twice
- **THEN** the two are the same place
- **AND** it is one file inside a directory of this app's own within the platform's
  application-support directory, not inside the caches directory and not inside the temporary
  directory
- **AND** it is none of the places the record, the roster, the one-offs and the birthday ticks are
  kept at

#### Scenario: a commitments screen given no happening place keeps its happenings beside its record place

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place and a record
  place of a directory of its own, given no happening place, and a happening named "Kopfweh" is made
  through it
- **THEN** a happening store opened at the file of the happening place's name beside that record
  place holds "Kopfweh"

### Requirement: A commitments screen renames a happening it lists

A commitments screen SHALL rename a happening it lists, the blank space around the typed name
trimmed first, keeping the happening's identity and its place in the list. A rename SHALL be refused,
and nothing written, for a name that says nothing, for a name another listed happening has — the
refusal naming that happening exactly as it is held — and as not kept where the happening place
cannot be written. A rename to the name the happening already has, once trimmed, and a rename of a
happening the screen does not list SHALL each ask for no change: neither SHALL write anything, and
neither SHALL be refused or end what the screen tells about a happening.

#### Scenario: a happening renamed through a commitments screen keeps its place in the list

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a happening place holding
  "Augenmigräne" and then "Kopfweh", and "Kopfweh" is renamed through it to "Spannungskopfweh"
- **THEN** the rename is not refused
- **AND** it lists "Augenmigräne" and then "Spannungskopfweh", which is the same happening "Kopfweh"
  was
- **AND** a commitments screen opened afterwards at that happening place lists the same

#### Scenario: a commitments screen refuses a rename onto a name another listed happening has, naming that one

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a happening place holding
  "Augenmigräne" and "Kopfweh", and "Kopfweh" is renamed through it to "AUGENMIGRÄNE"
- **THEN** it is refused as a name already in use, naming "Augenmigräne"
- **AND** the content at that happening place is byte-for-byte what it was before
- **AND** "Kopfweh" renamed to an empty name is refused as a name that says nothing
- **AND** "Kopfweh" renamed to "kopfweh" is not refused, and it lists "Augenmigräne" and "kopfweh"

#### Scenario: a rename to the name a happening already has, or of one not listed, asks for no change

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a happening place holding
  "Kopfweh"; a happening is made through it from an empty name and refused; and "Kopfweh" is renamed
  through it to " Kopfweh "
- **THEN** the rename is not refused
- **AND** the content at that happening place is byte-for-byte what it was before
- **AND** it still tells a name that says nothing
- **AND** a happening named "Schlecht geschlafen", made on its own and never listed, renamed through it
  to "Migräne" leaves the content and what it tells the same

### Requirement: What a commitments screen tells about a happening lasts until its name is edited, the next ask, the sheet closing or the app being shown again

A commitments screen SHALL hold the refusal of the last happening made, renamed, stopped, resumed or
deleted through it until the name field of the happening sheet is edited, until the next happening
is made, renamed, stopped, resumed or deleted through it, until that sheet is closed, or until the
app is shown again, and SHALL then hold none; nothing else SHALL end it. An ask that is kept SHALL
end it and an ask that is refused SHALL replace it. Putting a stop or a deletion up for
confirmation, typing a name back and cancelling either SHALL NOT end it. It
SHALL be held apart from the screen's refused change and from what it tells on the commitment sheet:
nothing asked about a happening SHALL end or replace either, and nothing asked about a commitment
SHALL end or replace it.

#### Scenario: what a commitments screen tells about a happening ends when its name is edited, the sheet closes or the app is shown

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a happening place where
  nothing has been kept, a happening is made through it from an empty name and refused, and the
  happening sheet's name field is told edited
- **THEN** it tells nothing about a happening
- **AND** the same refusal ended instead by the happening sheet being told closed leaves it telling
  nothing, and so does the app being shown again on that day
- **AND** the same refusal followed by a happening made from the name "Kopfweh" leaves it telling
  nothing

#### Scenario: what a commitments screen tells about a happening is held apart from a commitment's refusal

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place and a
  happening place where nothing has been kept; a commitment named "   " on a weekday-set rhythm of
  all seven weekdays, kept from that same day, is defined through it and refused; and a happening is
  then made through it from the name "Kopfweh"
- **THEN** the happening is not refused
- **AND** it still holds a name that says nothing against defining a commitment, and still tells it on
  its commitment sheet
- **AND** a happening then made from an empty name and refused, followed by a commitment named
  "Gym" on that rhythm and day defined through it, leaves it telling a name that says nothing about a
  happening

#### Scenario: what a commitments screen tells about a happening ends when a stop, a resume or a deletion is kept

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a happening place holding
  "Augenmigräne" and "Kopfweh"; a happening is made through it from an empty name and refused; and
  it is asked to stop "Kopfweh"
- **THEN** it still tells a name that says nothing
- **AND** once that stop is confirmed it tells nothing about a happening
- **AND** the same refusal followed by "Kopfweh" resumed through it leaves it telling nothing
- **AND** the same refusal is still told once it is asked to delete "Augenmigräne" and
  "Augenmigräne" is typed back, and is ended once that deletion is confirmed

### Requirement: A commitments screen that cannot read its happening place lists none and makes and renames none

A commitments screen whose happening place cannot be read SHALL list no happening, SHALL say that it
is not keeping happenings, and SHALL tell apart one cause, a store written by a later version of
DayByDay, from every other. It MUST NOT write over what is at the place. Making a happening through
it SHALL be refused as not kept, and renaming one SHALL ask for no change. Its commitments SHALL be
listed, defined and changed as ever, and a screen that cannot read its roster SHALL list, make and
rename happenings as ever. The condition SHALL last only until the app is shown again, since being
shown reads the place afresh.

#### Scenario: a commitments screen that cannot read its happening place lists none and leaves the place as it was

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a run of bytes that is not a happening store is
  written at a happening place; a commitments screen is opened at both as of Monday 31 August 2026;
  and a happening is made through it from the name "Kopfweh"
- **THEN** it lists no happening and says it is not keeping happenings
- **AND** making it is refused as not kept
- **AND** the content at that happening place is byte-for-byte what it was before
- **AND** it keeps "Gym", and a commitment named "Run" on that rhythm and day defined through it is
  not refused

#### Scenario: a happening place written by a later version makes a commitments screen that says so

- **WHEN** a happening store declaring a form later than this app writes is written at a happening
  place, and a commitments screen is opened at that place as of Monday 31 August 2026
- **THEN** it lists no happening and says its happenings were written by a later version of DayByDay
- **AND** the content at that happening place is byte-for-byte what it was before

#### Scenario: a commitments screen that could not read its happening place reads it again when the app is shown

- **WHEN** a run of bytes that is not a happening store is written at a happening place; a commitments
  screen is opened at that place as of Monday 31 August 2026; that content is replaced by a happening
  store holding "Kopfweh"; and the app is shown again on that day
- **THEN** it lists "Kopfweh" and says it is keeping happenings

#### Scenario: a commitments screen that cannot read its roster still makes and renames happenings

- **WHEN** a run of bytes that is not a roster store is written at a roster place, and a commitments
  screen is opened at that roster place and a happening place where nothing has been kept as of
  Monday 31 August 2026
- **THEN** it says it is keeping happenings
- **AND** a happening made through it from the name "Kopfweh" is not refused, and is then renamed
  "Spannungskopfweh" without refusal
- **AND** it lists "Spannungskopfweh"

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
untouched where the happenings refuse it. It SHALL read a store in its first form as holding its
happenings and no occurrences, writing nothing there on opening. A store holding an occurrence of an identity none of its happenings has, on a date that
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

### Requirement: A happening is stopped and resumed in place, keeping its name, its place and its occurrences

Happenings SHALL hold, for each happening they hold, whether it is stopped, and a happening added
SHALL NOT be stopped. Stopping a held happening that is not stopped SHALL make it stopped, and
resuming a stopped one SHALL make it not stopped; each SHALL keep the happening's identity, its
name, its place among those held and every occurrence of it. Stopping one already stopped, resuming
one not stopped, and stopping or resuming a happening not held SHALL each be refused, and what is
held SHALL be unchanged. Noting an occurrence of a stopped happening SHALL be refused, and changing
or taking back one of its occurrences SHALL be judged as for any other happening's. A stopped
happening's name SHALL refuse another's as any held name does, and a rename SHALL keep it stopped.

#### Scenario: a happening stopped keeps its name, its place and its occurrences, and resumed is stopped no longer

- **WHEN** happenings named "Augenmigräne", "Kopfweh" and "Schlecht geschlafen" are held, an
  occurrence of "Kopfweh" is noted on 2 October 2026 at 09:10 with no note, and "Kopfweh" is stopped
- **THEN** stopping it is not refused
- **AND** "Kopfweh" is stopped, and "Augenmigräne" and "Schlecht geschlafen" are not
- **AND** the happenings held are "Augenmigräne", "Kopfweh" and then "Schlecht geschlafen", and the
  one occurrence held is of "Kopfweh" on 2 October 2026 at 09:10
- **AND** "Kopfweh" then resumed is not refused, is not stopped, and is still held second

#### Scenario: a stopped happening takes no occurrence noted, and its occurrences are still changed and taken back

- **WHEN** a happening named "Kopfweh" is held with one occurrence noted on 2 October 2026 at 09:10
  with no note; "Kopfweh" is stopped; and an occurrence of it is noted on that day at 18:40
- **THEN** noting it is refused
- **AND** the one occurrence held is the one at 09:10
- **AND** that occurrence changed to 08:00 with the note "links" is not refused, and then taken back
  is not refused
- **AND** no occurrence is held, and "Kopfweh" is still held and stopped

#### Scenario: a stopped happening's name refuses another's, and a stopped happening renamed stays stopped

- **WHEN** a happening named "Kopfweh" is held and stopped, and a happening named "kopfweh" is added
- **THEN** adding it is refused
- **AND** "Kopfweh" renamed "Spannungskopfweh" is not refused, and "Spannungskopfweh" is stopped
- **AND** a happening named "Kopfweh" then added is not refused, and is not stopped

#### Scenario: stopping a stopped happening, resuming one not stopped, or either of one not held is refused and changes nothing

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are held, "Kopfweh" is stopped, and
  "Kopfweh" is stopped again
- **THEN** stopping it again is refused
- **AND** what is held is the same as before it was stopped again
- **AND** "Augenmigräne" resumed is refused the same way
- **AND** a happening named "Schlecht geschlafen", made on its own and never held, stopped is refused
  the same way, and resumed is refused the same way

### Requirement: A happening is deleted with every occurrence of it

Deleting a held happening, stopped or not, SHALL remove from what is held that happening and every
occurrence of it, and SHALL keep every other happening and every other occurrence in their order.
Deleting a happening not held SHALL be refused, and what is held SHALL be unchanged. Once a
happening is deleted, its name SHALL refuse no happening added, and noting, changing or taking back
an occurrence of it SHALL be refused as for any happening not held.

#### Scenario: a happening deleted takes every occurrence of it and leaves the rest in their order

- **WHEN** happenings named "Augenmigräne", "Kopfweh" and "Schlecht geschlafen" are held;
  occurrences are noted of "Kopfweh" on 2 October 2026 at 18:40, of "Augenmigräne" on 1 October 2026
  with no time, and of "Kopfweh" on 30 September 2026 with no time, each with no note; and "Kopfweh"
  is deleted
- **THEN** deleting it is not refused
- **AND** the happenings held are "Augenmigräne" and then "Schlecht geschlafen", and the one
  occurrence held is of "Augenmigräne" on 1 October 2026 with no time
- **AND** a happening named "kopfweh" then added is not refused
- **AND** "Schlecht geschlafen" stopped and then deleted is not refused, and the happenings held are
  "Augenmigräne" and then "kopfweh"

#### Scenario: deleting a happening not held is refused and changes nothing

- **WHEN** a happening named "Kopfweh" is held with one occurrence noted on 2 October 2026 at 09:10
  with no note, and a happening named "Kopfweh", made on its own and never held, is deleted
- **THEN** deleting it is refused
- **AND** what is held is the same as before it was deleted
- **AND** the held "Kopfweh" deleted is not refused, and deleted a second time is refused the same
  way
- **AND** the occurrence it held, noted again once it is deleted, is refused

### Requirement: A happening store keeps a stop, a resume and a deletion, and reads its earlier forms as holding none stopped

A happening store SHALL keep every stop, resume and deletion made at it under the rules every change
it keeps is under: kept at its place before it reports it kept, refused with an error and not held
where it cannot be kept, and refused without an error, leaving the place untouched, where the
happenings refuse it. It SHALL write a form one later than the form that first held occurrences,
and SHALL read a store in either earlier form as holding no happening stopped, writing nothing there
on opening. A store opened again SHALL hold each happening stopped or not as it was left, and a
deleted happening and its occurrences not at all.

#### Scenario: a happening store opened again holds the happenings as stopped, resumed and deleted

- **WHEN** happenings named "Augenmigräne", "Kopfweh" and "Schlecht geschlafen" are added to a
  happening store; occurrences are noted of "Kopfweh" on 2 October 2026 at 09:10 and of
  "Augenmigräne" on 1 October 2026 with no time, each with no note; "Kopfweh" is stopped;
  "Schlecht geschlafen" is stopped and resumed; "Augenmigräne" is deleted; and a second store is
  opened at the same place
- **THEN** the second store holds "Kopfweh" and then "Schlecht geschlafen", "Kopfweh" stopped and
  "Schlecht geschlafen" not
- **AND** it holds one occurrence, of "Kopfweh" on 2 October 2026 at 09:10

#### Scenario: a stop, a resume or a deletion the happening store cannot keep is refused and not held

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are added to a happening store, "Kopfweh"
  is stopped there, and an occurrence of "Augenmigräne" is noted on 2 October 2026 at 09:10; its
  place is then made so that it can be read from but not written to; and "Augenmigräne" is stopped
- **THEN** stopping it is refused with an error, and the store holds "Augenmigräne" not stopped
- **AND** resuming "Kopfweh" is refused with an error, and the store holds it stopped
- **AND** deleting "Augenmigräne" is refused with an error, and the store still holds it and its
  occurrence
- **AND** at a store whose place can be written, stopping a stopped happening is refused without an
  error, and the content at that place is byte-for-byte what it was before

#### Scenario: a happening store in an earlier form is read as holding no happening stopped

- **WHEN** a happening store is opened at a place holding a store in the form that first held
  occurrences, holding a happening named "Kopfweh" with one occurrence on 2 October 2026 with no
  time and no note
- **THEN** it opens without error, holding "Kopfweh" not stopped, and that occurrence
- **AND** the content at that place is byte-for-byte what it was before it was opened
- **AND** a store in the first form holding "Kopfweh" opens the same way, holding it not stopped
- **AND** once "Kopfweh" is stopped at the first of them, a store opened again at that place holds it
  stopped, with its occurrence

### Requirement: A commitments screen stops a happening once the stop is confirmed, and resumes one in one tap

A commitments screen asked to stop a happening it lists that is not stopped SHALL hold it awaiting a
stop and SHALL change nothing until the stop is confirmed; asking about a second SHALL replace the
first, and a cancelled stop SHALL leave nothing awaiting. A confirmed stop SHALL be kept at the
happening place before the list says so; the happening SHALL then be listed in its place, said to be
stopped, its look-back still answered. The screen SHALL resume a stopped happening it lists without
confirmation, keeping that before the list says so. Asking to stop a happening stopped or not
listed, resuming one not stopped or not listed, and confirming with nothing awaiting SHALL each do
nothing and say nothing. A stop or a resume the happening place cannot take SHALL be refused as not
kept.

#### Scenario: asking a commitments screen to stop a happening changes nothing until it is confirmed

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a happening place holding
  "Augenmigräne" and "Kopfweh", and is asked to stop "Kopfweh"
- **THEN** "Kopfweh" is awaiting a stop, and neither happening is said to be stopped
- **AND** the content at that happening place is byte-for-byte what it was before
- **AND** asked then to stop "Augenmigräne", "Augenmigräne" is awaiting a stop instead
- **AND** that stop cancelled leaves nothing awaiting a stop, and that content the same

#### Scenario: a happening stopped through a commitments screen is still listed in its place and said to be stopped

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a happening place holding
  "Augenmigräne", "Kopfweh" and "Schlecht geschlafen", "Kopfweh" with one occurrence noted on
  2 October 2026 at 18:40; and it is asked to stop "Kopfweh" and the stop is confirmed
- **THEN** the stop is not refused, and nothing is awaiting a stop
- **AND** it lists "Augenmigräne", "Kopfweh" and then "Schlecht geschlafen", and says "Kopfweh" alone
  is stopped
- **AND** a happening store opened at that place holds "Kopfweh" stopped, with its occurrence
- **AND** it answers a look-back at "Kopfweh", saying one occurrence on "2 October 2026" at "18:40"
- **AND** a happening made through it from the name "kopfweh" is refused as a name already in use,
  naming "Kopfweh"

#### Scenario: a happening resumed through a commitments screen asks for no confirmation and is said to be stopped no longer

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are added to a happening store at a
  happening place and "Kopfweh" is stopped there; a commitments screen is opened at that place as of
  Saturday 3 October 2026; and "Kopfweh" is resumed through it
- **THEN** resuming it is not refused, and nothing is awaiting a stop at any point
- **AND** it lists "Augenmigräne" and then "Kopfweh", and says neither is stopped
- **AND** a happening store opened at that place holds "Kopfweh" not stopped

#### Scenario: asking to stop a stopped happening, or to resume one not stopped, does nothing and says nothing

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are added to a happening store at a
  happening place and "Kopfweh" is stopped there; a commitments screen is opened at that place as of
  Saturday 3 October 2026; and it is asked to stop "Kopfweh"
- **THEN** nothing is awaiting a stop
- **AND** "Augenmigräne" resumed through it is not refused, and it tells nothing about a happening
- **AND** a stop confirmed with nothing awaiting is not refused
- **AND** a happening named "Schlecht geschlafen", made on its own and never listed, asked to be
  stopped leaves nothing awaiting a stop, and resumed is not refused
- **AND** the content at that happening place is byte-for-byte what it was before the screen was
  opened

#### Scenario: a happening stop or resume the happening place cannot take is refused as not kept

- **WHEN** happenings named "Augenmigräne" and "Kopfweh" are added to a happening store at a
  happening place and "Kopfweh" is stopped there; a commitments screen is opened at that place as of
  Saturday 3 October 2026; the place is then made so that it can be read from but not written to;
  and the screen is asked to stop "Augenmigräne" and the stop is confirmed
- **THEN** it is refused as not kept, and it tells that about a happening
- **AND** "Kopfweh" resumed through it is refused as not kept
- **AND** it says "Kopfweh" alone is stopped, and the content at that place is byte-for-byte what it
  was before

### Requirement: A commitments screen deletes a happening only when its name is typed back, saying how many occurrences go with it

A commitments screen asked to delete a happening it lists SHALL hold it awaiting deletion with
nothing typed back, changing nothing until it is confirmed; asking about a second SHALL replace the
first. What is typed back SHALL match as a name typed back to delete a commitment matches. Nothing
SHALL await deletion or be typed back once a deletion is confirmed or cancelled or the app is shown
again. While one awaits, the screen SHALL say "Its N occurrences go with it.", N the number of its
occurrences held, in digits; "Its 1 occurrence goes with it." for one; and "It has no occurrences."
for none. A confirmed deletion whose name matches SHALL be kept at the happening place before the
list says so; any other, or one with nothing awaiting, SHALL do nothing. A deletion the happening
place cannot take SHALL be refused as not kept.

#### Scenario: asking a commitments screen to delete a happening changes nothing until it is confirmed

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a happening place holding
  "Augenmigräne" and "Kopfweh", and is asked to delete "Kopfweh"
- **THEN** "Kopfweh" is awaiting deletion, nothing has been typed back, and the name typed back does
  not match
- **AND** it lists "Augenmigräne" and then "Kopfweh", and the content at that happening place is
  byte-for-byte what it was before
- **AND** asked then to delete "Augenmigräne" once "Kopfweh" is typed back, "Augenmigräne" is
  awaiting deletion and nothing has been typed back
- **AND** that deletion cancelled leaves nothing awaiting deletion and nothing typed back

#### Scenario: a name typed back to delete a happening matches only when it is the happening's name

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a happening place holding
  "Kopfweh", is asked to delete "Kopfweh", and "Kopf", then "Kopfweh", then "Kopfwehh" are typed back
  in turn
- **THEN** the name typed back does not match after "Kopf", matches after "Kopfweh", and does not
  match after "Kopfwehh"
- **AND** "  Kopfweh  " typed back matches, and "kopfweh" and "KOPFWEH" typed back do not

#### Scenario: a happening deleted through a commitments screen is listed no longer, and its occurrences are gone

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a happening place holding
  "Augenmigräne" and "Kopfweh", "Kopfweh" stopped and with occurrences noted on 2 October 2026 at
  18:40 and on 1 October 2026 with no time, and "Augenmigräne" with one noted on 1 October 2026 at
  09:00; it is asked to delete "Kopfweh"; "Kopfweh" is typed back; and the deletion is confirmed
- **THEN** the deletion is not refused, nothing is awaiting deletion and nothing has been typed back
- **AND** it lists "Augenmigräne" alone
- **AND** a happening store opened at that place holds "Augenmigräne" and its one occurrence, and
  nothing else
- **AND** it answers no look-back at "Kopfweh", and a happening made through it from the name
  "Kopfweh" is not refused

#### Scenario: a commitments screen says how many occurrences go with the happening awaiting deletion

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a happening place holding
  "Augenmigräne", "Kopfweh" and "Schlecht geschlafen", "Kopfweh" with twelve occurrences noted on
  2 October 2026 with no time and no note and "Augenmigräne" with one, and none of "Schlecht
  geschlafen"; and it is asked to delete "Kopfweh"
- **THEN** it says "Its 12 occurrences go with it."
- **AND** asked to delete "Augenmigräne" instead, it says "Its 1 occurrence goes with it."
- **AND** asked to delete "Schlecht geschlafen" instead, it says "It has no occurrences."
- **AND** with nothing awaiting deletion it says none of these

#### Scenario: a happening deletion confirmed on a name that does not match, or with nothing awaiting, changes nothing

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a happening place holding
  "Kopfweh"; it is asked to delete "Kopfweh"; "kopfweh" is typed back; and the deletion is confirmed
- **THEN** nothing is refused
- **AND** "Kopfweh" is still awaiting deletion and "kopfweh" is still what has been typed back
- **AND** once the app is shown again on that day nothing is awaiting deletion and nothing has been
  typed back, and a deletion then confirmed is not refused
- **AND** it lists "Kopfweh", and the content at that happening place is byte-for-byte what it was
  before

#### Scenario: a happening deletion the happening place cannot take is refused as not kept

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a happening place holding
  "Kopfweh" with one occurrence noted on 2 October 2026 at 09:10; the place is then made so that it
  can be read from but not written to; it is asked to delete "Kopfweh"; "Kopfweh" is typed back; and
  the deletion is confirmed
- **THEN** it is refused as not kept, and it tells that about a happening
- **AND** nothing is awaiting deletion, and it lists "Kopfweh"
- **AND** the content at that place is byte-for-byte what it was before

### Requirement: A commitments screen awaits one confirmation of any kind, a happening's stop and deletion included

Asking a commitments screen to stop or to delete a happening SHALL leave nothing else awaiting a
stop or a deletion, a commitment's included, and nothing typed back to delete a commitment. Asking
it to stop keeping or to delete a commitment SHALL leave no happening awaiting a stop or a deletion
and nothing typed back to delete one. A commitments screen opened SHALL have no happening awaiting
either, and nothing typed back to delete one.

#### Scenario: asking about a happening leaves no commitment awaiting a stop or a deletion, and the reverse

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  and a happening place holding "Kopfweh" as of Saturday 3 October 2026; it is asked to delete "Gym"
  and "Gym" is typed back; and it is then asked to stop "Kopfweh"
- **THEN** no commitment is awaiting confirmation or deletion, and nothing is typed back to delete one
- **AND** "Kopfweh" is awaiting a stop
- **AND** asked then to delete "Kopfweh", "Kopfweh" is awaiting deletion and nothing is awaiting a
  stop
- **AND** asked then to stop keeping "Gym", "Gym" is awaiting confirmation, and no happening is
  awaiting a stop or deletion

#### Scenario: a commitments screen opened has no happening awaiting a stop or a deletion

- **WHEN** a commitments screen is opened as of Saturday 3 October 2026 at a happening place holding
  "Kopfweh"
- **THEN** no happening is awaiting a stop or deletion, and nothing is typed back to delete one
- **AND** the name typed back to delete a happening does not match

### Requirement: A commitments screen lists the happenings and makes one from a name, writing at no other store's place

A commitments screen SHALL list every happening at its happening place, in the order held, and SHALL
say whether it is keeping them. A happening SHALL be made through it from a name, the blank space
around the typed name trimmed first, and once kept SHALL be listed last. Making one SHALL be refused,
and nothing written, for a name that says nothing, for a name a listed happening already has —
the refusal naming that happening exactly as it is held — and as not kept where the happening place
cannot be written. Making, renaming, stopping, resuming or deleting a happening MUST NOT write at
the roster place, the record place, the one-off place or the birthday place.

#### Scenario: a commitments screen lists the happenings at its happening place in the order they were made

- **WHEN** happenings named "Augenmigräne" and then "Kopfweh" are added to a happening store at a
  happening place, and a commitments screen is opened at that place as of Monday 31 August 2026
- **THEN** it lists "Augenmigräne" and then "Kopfweh", and says it is keeping happenings
- **AND** a commitments screen opened at a happening place where nothing has been kept lists no
  happening, says it is keeping happenings, and leaves nothing at that place

#### Scenario: a happening made through a commitments screen is listed last and kept at its place

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a happening place holding
  "Augenmigräne", and a happening is made through it from the name " Kopfweh "
- **THEN** making it is not refused
- **AND** it lists "Augenmigräne" and then "Kopfweh", with no blank space around the name
- **AND** a commitments screen opened afterwards at that happening place lists the same

#### Scenario: a commitments screen refuses a happening whose name a listed one has, naming the listed one

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a happening place holding
  "Kopfweh", and a happening is made through it from the name "kopfweh"
- **THEN** it is refused as a name already in use, naming "Kopfweh"
- **AND** it lists "Kopfweh" alone, and the content at that happening place is byte-for-byte what it
  was before
- **AND** a happening made from a name of blank space alone is refused as a name that says nothing

#### Scenario: a happening the happening place cannot take is refused as not kept

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a happening place where
  nothing can be written — a path beneath an existing ordinary file — and a happening is made through
  it from the name "Kopfweh"
- **THEN** it is refused as not kept
- **AND** it lists no happening

#### Scenario: making and renaming a happening leaves the other places as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place,
  and a record place, a one-off place and a happening place where nothing has been kept as of
  Monday 31 August 2026, keeping its copy place at a place of its own and asking a clock that answers
  a later minute each time it is asked, from that day at 14:32; a directory of its own is given to it
  as its copy place; and a happening named "Kopfweh" is made through it and renamed
  "Spannungskopfweh"
- **THEN** neither is refused
- **AND** the content at the roster place is byte-for-byte what it was after the copy place was
  given, and nothing is kept at the record place, the one-off place or the birthday place

#### Scenario: stopping, resuming and deleting a happening leaves the other places as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026,
  is taken on at a roster place; a commitments screen is opened at that roster place, at a happening
  place holding "Kopfweh" with one occurrence noted on 2 October 2026 at 09:10, and at a record
  place and a one-off place where nothing has been kept, as of Saturday 3 October 2026, keeping its
  copy place at a place of its own and asking a clock that answers a later minute each time it is
  asked, from that day at 14:32; a directory of its own is given to it as its copy place; and
  "Kopfweh" is stopped through it, resumed, and deleted with its name typed back
- **THEN** none of the three is refused
- **AND** the content at the roster place is byte-for-byte what it was after the copy place was
  given, and nothing is kept at the record place, the one-off place or the birthday place
