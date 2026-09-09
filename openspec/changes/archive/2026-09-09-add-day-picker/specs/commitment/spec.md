## ADDED Requirements

### Requirement: A roster answers the earliest day anything it holds has been kept from

A roster SHALL answer, of the commitments it holds, the earliest calendar date any of them is kept
from, and SHALL answer that there is none where it holds no commitment at all. A roster holding one
commitment answers the day that commitment is kept from; a roster holding several answers the
earliest of their days.

**Every commitment the roster holds SHALL count**, including one it has stopped keeping and one it
has removed. Neither state SHALL raise the answer, and taking a commitment up again SHALL NOT lower
it, because it was never left out. The days of a stopped commitment still hold whatever was recorded
against it while it was kept, and an answer that rose when a commitment was retired would put a day
a person actually kept behind an answer that no longer reaches it. This is the same rule
`add-roster-removal` (#155) settled for removal — a roster never lets a commitment go — read over
one more question.

**The answer SHALL be the day a commitment is kept from, and never a day it is due.** A roster MUST
NOT consult a commitment's schedule, its name, its kind, its category or its place in the order: a
commitment kept from a day its schedule is not due on puts the answer on that day all the same, and
a commitment due on no day inside any span still counts. Whether a commitment is due is that
commitment's own answer to a different question.

The answer SHALL be asked of the roster and SHALL be handed nothing. This capability MUST NOT
consult the present moment, the device's time zone or the locale to find it, so a roster answers the
same way for ever until a commitment is taken on. It SHALL follow what the roster holds: a
commitment taken on with an earlier day lowers it, and one taken on with a later day leaves it
exactly as it was.

**This answer is the roster's rather than the commitment's**, deliberately. A commitment reads back
the name it was given and the kind its days take and nothing else — the day it is kept from is a
part it is made of, not a part it hands out — so the only way anything outside this capability can
learn where a person's history begins is to ask the roster the one aggregate question. This
requirement gives that question and no other, and it is what `day-screen` asks to bound its day
picker.

#### Scenario: a roster holding no commitments answers no earliest day anything it holds is kept from

- **WHEN** a roster that has taken nothing on is asked the earliest day anything it holds is kept
  from
- **THEN** it answers that there is none

#### Scenario: a roster answers the earliest day among the commitments it holds

- **WHEN** a roster takes on a commitment named "Gym" kept from 1 March 2026, then one named "Run"
  kept from 1 January 2026, then one named "Journaling" kept from 1 February 2026, all three on a
  schedule listing all seven weekdays
- **THEN** it answers 1 January 2026
- **AND** a roster that took the same three on in the opposite order answers 1 January 2026 too

#### Scenario: a roster counts a commitment it has stopped keeping in the earliest day anything it holds is kept from

- **WHEN** a roster takes on a commitment named "Gym" kept from 1 January 2026 and one named "Run"
  kept from 1 March 2026, both on a schedule listing all seven weekdays, and "Gym" is then stopped
  as of 31 January 2026
- **THEN** it answers 1 January 2026
- **AND** the commitments it keeps are "Run" alone

#### Scenario: a roster counts a commitment it has removed in the earliest day anything it holds is kept from

- **WHEN** a roster takes on a commitment named "Gym" kept from 1 January 2026 and one named "Run"
  kept from 1 March 2026, both on a schedule listing all seven weekdays, and "Gym" is then removed
  as of 31 January 2026
- **THEN** it answers 1 January 2026
- **AND** the commitments it keeps are "Run" alone

#### Scenario: the earliest day anything a roster holds is kept from falls when a commitment kept from an earlier day is taken on

- **WHEN** a roster takes on a commitment named "Gym" kept from 1 March 2026 on a schedule listing
  all seven weekdays, and is then asked; and it afterwards takes on one named "Run" kept from
  1 January 2026 on that same schedule, and is asked again
- **THEN** the first answer is 1 March 2026 and the second is 1 January 2026
- **AND** taking on a third named "Journaling" kept from 1 June 2026 leaves the answer at
  1 January 2026

#### Scenario: a roster answers the day a commitment is kept from and not a day it is due

- **WHEN** a roster takes on a commitment named "Gym" on a schedule listing Monday alone, kept from
  Sunday 1 February 2026
- **THEN** it answers Sunday 1 February 2026
- **AND** that commitment is not due on Sunday 1 February 2026, the first day it is due being
  Monday 2 February 2026

#### Scenario: a roster answers the first supported date where a commitment it holds is kept from it

- **WHEN** a roster takes on a commitment named "Gym" kept from 31 December 9999 and one named
  "Run" kept from 1 January 1583, both on a schedule listing all seven weekdays
- **THEN** it answers 1 January 1583
