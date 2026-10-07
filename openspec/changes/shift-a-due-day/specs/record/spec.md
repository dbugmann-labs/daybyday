## ADDED Requirements

### Requirement: A store keeps a record on a day a shift put a due day on, and reads it back

A store SHALL keep a record of any kind on a day a shift of its commitment put a due day on, and
SHALL read it back, once the app is closed and opened again, as that record of that commitment on
that day, whatever shifts the commitment has made since. It SHALL keep beside such a record the
shift that made its day due, a part first written at the seventh form, and SHALL read a history kept
in a form before it as holding none. A record on a day neither its commitment's schedule nor a shift
kept beside it makes due SHALL refuse the store, as a record that could not be formed already does.

#### Scenario: records on a day a shift put a due day on are read back after the app is closed and opened again

- **WHEN** a roster holds a commitment named "Gym" of the tick kind and one named "Protein" of the
  total kind with a target of 120, both on a schedule listing Monday, Wednesday and Saturday and kept
  from 1 January 2026, each with its due day on Monday 31 August 2026 shifted to Tuesday 1 September
  2026; a tick for "Gym" and an addition of 35 for "Protein" on Tuesday 1 September 2026, each
  formed against the commitment that roster keeps, are kept at a record place; "Gym"'s due day on
  Wednesday 2 September 2026 is then shifted to Thursday 3 September 2026; and a store is opened
  afterwards at that record place
- **THEN** opening is not refused
- **AND** its history keeps "Gym" on Tuesday 1 September 2026, and has added 35 for "Protein" on that
  day
- **AND** a store opened at a place holding, in the form this app writes, a tick for "Gym" on
  Tuesday 1 September 2026 with no shift kept beside it is refused with an error, the content there
  left byte-for-byte as it was
