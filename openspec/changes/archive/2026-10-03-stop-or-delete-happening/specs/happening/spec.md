## ADDED Requirements

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

## MODIFIED Requirements

### Requirement: A commitments screen lists the happenings and makes one from a name

A commitments screen SHALL list every happening at its happening place, in the order held, and SHALL
say whether it is keeping them. A happening SHALL be made through it from a name, the blank space
around the typed name trimmed first, and once kept SHALL be listed last. Making one SHALL be refused,
and nothing written, for a name that says nothing, for a name a listed happening already has —
the refusal naming that happening exactly as it is held — and as not kept where the happening place
cannot be written. Making, renaming, stopping, resuming or deleting a happening MUST NOT write at
the roster place, the record place, the one-off place or the birthday place, and SHALL write no
copy at the copy place.

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

#### Scenario: stopping, resuming and deleting a happening writes no copy and leaves the other places as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026,
  is taken on at a roster place; a commitments screen is opened at that roster place, at a happening
  place holding "Kopfweh" with one occurrence noted on 2 October 2026 at 09:10, and at a record
  place and a one-off place where nothing has been kept, as of Saturday 3 October 2026, keeping its
  copy place at a place of its own and asking a clock that answers a later minute each time it is
  asked, from that day at 14:32; a directory of its own is given to it as its copy place; and
  "Kopfweh" is stopped through it, resumed, and deleted with its name typed back
- **THEN** none of the three is refused
- **AND** the last copy made is still Saturday 3 October 2026 at 14:32
- **AND** the content at the roster place is byte-for-byte what it was after the copy place was
  given, and nothing is kept at the record place, the one-off place or the birthday place

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
