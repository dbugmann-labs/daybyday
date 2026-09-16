## MODIFIED Requirements

### Requirement: A day screen takes back the last addition a row offers, and keeps it before the day view says so

A day screen SHALL take back, on one of its rows, the last addition that day holds, and SHALL keep
the change before its day view says so. It SHALL take back exactly one addition each time it is
asked, SHALL leave every earlier addition standing in the order they were made, and SHALL offer no
act that clears a day. It SHALL change nothing — nothing kept, nothing shown, nothing told — on a
row the screen's day view does not hold, on a row that offers no take-back, or on a screen that is
not keeping a record. The day view SHALL then be formed again. A change that could not be kept SHALL
be refused, reported to the caller, told on the row naming no cause, and SHALL leave the day view as
it was. A take-back SHALL reach the record's place and the copy place, and nothing else.

#### Scenario: taking back the last addition on a row leaves the day short by exactly that amount

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" and then "90" are committed
  on the row it holds each time; and that row's last addition is then taken back
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** the day view says the commitment is not kept on that date

#### Scenario: taking back the last addition twice removes the two most recent

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30", then "45", then "50" are
  committed on the row it holds each time; and the last addition of the row it then holds is taken
  back twice
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** that row still offers taking its day's last addition back
- **AND** taking it back once more leaves the entry saying "0 of 120" and the row offering no
  take-back

#### Scenario: a take-back is held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" and then "90" are committed
  on the row it holds each time; that row's last addition is taken back; and a second day screen of
  the same commitment is then opened at the same place as of the same day
- **THEN** the second day screen's day view says the commitment is not kept on that date
- **AND** the entry its one row offers says "30 of 120"

#### Scenario: a take-back that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and that holds a record in which a commitment named "Protein" of the total kind
  with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, has added 30 and 90 on that date, and that row's last addition is taken back
- **THEN** taking back is refused with an error
- **AND** the entry the row the day screen then holds offers still says "120 of 120"
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause

#### Scenario: taking back on a row that offers no take-back changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind and a commitment named "Protein" of the total
  kind with a target of 120, both on a schedule listing Monday, Wednesday and Saturday and both kept
  from 1 January 2026, and the last addition is taken back on each of its two rows in turn
- **THEN** the day screen's day view says neither commitment is kept on that date
- **AND** the entry the second row offers says "0 of 120"
- **AND** the day screen tells nothing on any row

#### Scenario: taking back on a row for a day that has not arrived changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing all seven weekdays, kept from 1 January 2026; "30" is committed on its one row; the screen
  is moved to the day after; and the last addition is taken back on the row it then holds
- **THEN** a day screen opened afterwards at that place as of Monday 31 August 2026 says "30 of 120"
- **AND** the day screen tells nothing on any row

#### Scenario: taking back on a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Protein" of the total kind with a target of 120,
  on a schedule listing all seven weekdays, kept from 1 January 2026, are opened at one place where
  nothing has been kept, the first as of Monday 31 August 2026 and the second as of Tuesday
  1 September 2026; "30" is committed on each screen's own row; and the second screen's row is then
  taken back on the first screen
- **THEN** a day screen opened afterwards at that place as of Tuesday 1 September 2026 says "30 of
  120"

#### Scenario: taking back on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  the last addition is taken back on its one row
- **THEN** it says it is not keeping a record
- **AND** the day screen tells nothing on any row
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: taking back writes nothing to the roster's place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster place
  where nothing has been kept, of a commitment named "Protein" of the total kind with a target of
  120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" is
  committed on its one row; the roster place is read; and that row's last addition is then taken
  back
- **THEN** the content at the roster place is byte-for-byte what it was before the take-back
- **AND** the day screen says it is keeping its roster
