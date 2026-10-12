## ADDED Requirements

### Requirement: A decline kept on a day screen writes a copy at the copy place, and a restore puts it back

Where a copy place is set, a day screen SHALL write a copy there after every decline it keeps at its
record place, a new reason and a take-back included, as of the moment its clock answers once the
change is kept, and that copy SHALL hold every decline the record place then holds, each with its
reason or none. A decline refused, and one asked of a row whose decline the screen does not offer,
SHALL write no copy and SHALL leave the last copy as it was. A restore confirmed SHALL make the record
place hold exactly the declines the copy holds, each with its reason or none, and nothing of a
decline it held before.

#### Scenario: a decline made, its reason changed and its take-back on a day screen each write a copy at the copy place

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen is opened at that roster place, a
  record place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping
  its copy place at a place of its own and asking a clock that answers a later minute each time it
  is asked, from that day at 14:32; a directory of its own is given as its copy place through a
  commitments screen opened at those same places; and the row named "Gym" is declined with "Away"
- **THEN** declining is not refused
- **AND** that directory's one file named `DayByDay.daybyday` is a copy made at Monday 31 August 2026
  at 14:33, holding a history declining "Gym" on Monday 31 August 2026 with the reason "Away"
- **AND** the row then declined with "Away at a wedding" writes a copy made at 14:34 holding that
  reason, and its decline then taken back writes one made at 14:35 holding a history that has taken
  no record
- **AND** on a day screen opened the same way whose record place is then made impossible to write,
  declining the "Gym" row is refused and the last copy made is still Monday 31 August 2026 at 14:32

#### Scenario: a copy holding a decline, restored, puts the decline and its reason back at the record place

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a decline of it with the reason "Away" on Sunday
  30 August 2026 is kept at a record place; a commitments screen is opened at those places as of
  Monday 31 August 2026; a copy is made through it as of that day at 14:32; the decline is then taken
  back at the record place and a tick for "Gym" on Monday 31 August 2026 is kept there; and the
  screen is asked to restore from that copy and the restore is confirmed
- **THEN** it is not refused
- **AND** a store opened afterwards at that record place holds a history the decline of "Gym" on
  Sunday 30 August 2026 with the reason "Away" alone was added to
