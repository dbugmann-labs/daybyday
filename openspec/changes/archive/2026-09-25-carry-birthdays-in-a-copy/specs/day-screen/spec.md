## MODIFIED Requirements

### Requirement: A day screen keeps its birthday ticks at its own place, beside its other places

A day screen SHALL name the place it keeps its birthday ticks at, and MUST NOT leave that choice to
whatever draws it. The place SHALL be one file inside a directory belonging to this app, within the
directory the platform reserves for an application's own supporting data, and MUST NOT be inside
the caches directory or the temporary directory. It SHALL be the same place every time it is asked
for, and SHALL be none of the places the day screen keeps its record, its roster and its one-offs at,
nor the place a birthday switch is kept at by default. A day screen SHALL open its birthday place
when it is opened or the app is shown again, and when returned to from a commitments screen that
restored a copy, whether or not birthdays are on, and at no other moment; opening it SHALL write
nothing there.

#### Scenario: the place a day screen keeps its birthday ticks is a file of the app's own under Application Support, the same every time

- **WHEN** the place a day screen keeps its birthday ticks at is asked for twice
- **THEN** the two are the same place
- **AND** it is one file inside a directory of this app's own within the platform's
  application-support directory, rather than directly inside it
- **AND** it is not inside the platform's caches directory, and not inside the temporary directory

#### Scenario: the place a day screen keeps its birthday ticks is none of its other places

- **WHEN** the places a day screen keeps its birthday ticks, its record, its roster and its one-offs
  at, and the place a birthday switch is kept at by default, are all asked for
- **THEN** the five are five different places

#### Scenario: a day screen reads its birthday place again when shown and not when returned to or moved

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with birthdays on and a calendar holding the contact "kate"'s
  birthday worded "Kate Bell's 48th Birthday" on 20 January 2026; that birthday is then ticked at
  its birthday place by something else; and the day screen is returned to, moved to the day after
  and moved back
- **THEN** its Birthdays group holds one row, saying it is not ticked
- **AND** after the app is shown again as of that same day, that row says it is ticked
- **AND** a day screen opened the same way and never ticked leaves nothing kept at its birthday
  place

#### Scenario: a day screen returned to after a restore draws the birthday ticks the copy holds

- **WHEN** a day screen of no commitments at all is opened as of Tuesday 20 January 2026 at four
  places where nothing has been kept, with birthdays on and a calendar holding the contact "kate"'s
  birthday worded "Kate Bell's 48th Birthday" on 20 January 2026; a commitments screen is opened at
  the same places and a copy is made through it as of that day at 14:32; the day screen's one
  birthday row is then ticked; the commitments screen restores that copy; and the day screen is
  returned to from it
- **THEN** its Birthdays group holds one row, saying it is not ticked
- **AND** ticking that row then keeps its tick, and a birthday store opened afterwards at its birthday
  place holds that birthday ticked
