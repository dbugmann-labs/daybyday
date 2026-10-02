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
