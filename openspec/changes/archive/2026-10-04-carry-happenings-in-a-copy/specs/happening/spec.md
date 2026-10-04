## ADDED Requirements

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

## REMOVED Requirements

### Requirement: A commitments screen lists the happenings and makes one from a name

**Reason**: Added back above under a name of its own, without the sentence that a happening change
writes no copy and with its two scenarios retitled to match; a happening change now writes a copy,
as the `restore` delta of this change requires.

**Migration**: The two carried tests that asserted no copy keep everything else they assert, are
renamed to the retitled scenarios, and drop their last-copy assertions.
