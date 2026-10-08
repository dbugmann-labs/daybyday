## ADDED Requirements

### Requirement: A shift kept on a day screen writes a copy at the copy place

Where a copy place is set, a day screen SHALL write a copy there after every shift it keeps at its
roster place, a shift back included, as of the moment its clock answers once the shift is kept, and
that copy SHALL hold the roster with its shifts as they then stand. A shift refused, and one asked
of a day the screen does not offer, SHALL write no copy and SHALL leave the last copy as it was. A
copy that cannot be made SHALL refuse no shift, as it refuses no other change.

#### Scenario: a shift kept on a day screen writes a copy at the copy place holding that shift

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a day screen is opened at that roster place, a
  record place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping
  its copy place at a place of its own and asking a clock that answers a later minute each time it
  is asked, from that day at 14:32; a directory of its own is given as its copy place through a
  commitments screen opened at those same places; and the row named "Gym" is shifted to Tuesday
  1 September 2026
- **THEN** the shift is not refused
- **AND** that directory's one file named `DayByDay.daybyday` is a copy made at Monday 31 August 2026
  at 14:33, holding a roster whose "Gym" is due on Tuesday 1 September 2026 and not on Monday
  31 August 2026
- **AND** the "Gym" row of the day after, shifted to Monday 31 August 2026 once the screen is moved
  there, writes a copy made at 14:34 holding a roster whose "Gym" is due on Monday 31 August 2026
  and not on Tuesday 1 September 2026

#### Scenario: a shift refused, or asked of a day not offered, writes no copy at the copy place

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a day screen is opened at that roster place, a
  record place and a one-off place where nothing has been kept as of Monday 31 August 2026, keeping
  its copy place at a place of its own and asking a clock that answers a later minute each time it
  is asked, from that day at 14:32; a directory of its own is given as its copy place through a
  commitments screen opened at those same places; what is at the roster place is then made
  impossible to write; and the row named "Gym" is shifted to Tuesday 1 September 2026
- **THEN** shifting is refused with an error
- **AND** the last copy made is still Monday 31 August 2026 at 14:32
- **AND** on a day screen opened the same way at a roster place that can be written, shifting its
  "Gym" row to Wednesday 2 September 2026 leaves the last copy made at 14:32
