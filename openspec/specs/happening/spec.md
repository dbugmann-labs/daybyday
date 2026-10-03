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

### Requirement: A commitments screen lists the happenings and makes one from a name

A commitments screen SHALL list every happening at its happening place, in the order held, and SHALL
say whether it is keeping them. A happening SHALL be made through it from a name, the blank space
around the typed name trimmed first, and once kept SHALL be listed last. Making one SHALL be refused,
and nothing written, for a name that says nothing, for a name a listed happening already has —
the refusal naming that happening exactly as it is held — and as not kept where the happening place
cannot be written. Making or renaming a happening MUST NOT write at the roster place, the record
place, the one-off place or the birthday place, and SHALL write no copy at the copy place.

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

#### Scenario: making and renaming a happening writes no copy and leaves the other places as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place,
  and a record place, a one-off place and a happening place where nothing has been kept as of
  Monday 31 August 2026, keeping its copy place at a place of its own and asking a clock that answers
  a later minute each time it is asked, from that day at 14:32; a directory of its own is given to it
  as its copy place; and a happening named "Kopfweh" is made through it and renamed
  "Spannungskopfweh"
- **THEN** neither is refused
- **AND** the last copy made is still Monday 31 August 2026 at 14:32
- **AND** the content at the roster place is byte-for-byte what it was after the copy place was
  given, and nothing is kept at the record place, the one-off place or the birthday place

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

A commitments screen SHALL hold the refusal of the last happening made or renamed through it until
the name field of the happening sheet is edited, until the next happening is made or renamed through
it, until that sheet is closed, or until the app is shown again, and SHALL then hold none; nothing
else SHALL end it. An ask that is kept SHALL end it and an ask that is refused SHALL replace it. It
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
