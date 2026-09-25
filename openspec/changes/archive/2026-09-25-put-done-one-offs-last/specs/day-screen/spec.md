## MODIFIED Requirements

### Requirement: A one-off row is its one-off, its date and whether it is done

A one-off row SHALL be its one-off, its day view's date and whether its one-off is done. Two one-off
rows SHALL be the same row exactly when all three agree, and SHALL be different rows when any one
differs. A one-off row SHALL give back its name, what it says in the rhythm's place, whether its
one-off is done and whether it offers its tick, and MUST NOT give back the one-off, the one-off's
date or the row's date. A one-off row SHALL also give back a key. The keys of two one-off rows SHALL
be equal exactly when their one-offs and their dates agree, whether or not either one-off is done,
and a key MUST NOT give back the one-off, the one-off's date or the row's date.

#### Scenario: two one-off rows alike in one-off, date and whether done are the same row

- **WHEN** two day views are formed on Monday 28 September 2026 as of that same day, each of no
  commitments at all and of one-offs holding "Call mum" on 25 September 2026, the first with it not
  done and the second with it not done either
- **THEN** the two one-off rows are the same row
- **AND** a third day view formed the same way with "Call mum" ticked on 28 September 2026 holds a
  row that is a different row from both

#### Scenario: two one-off rows of one one-off on different dates are different rows

- **WHEN** a day view is formed on Monday 28 September 2026 as of that same day and another on
  Tuesday 29 September 2026 as of that same day, each of no commitments at all and of one-offs
  holding "Call mum" on 25 September 2026, not done
- **THEN** the first row says "3 days late" and the second says "4 days late"
- **AND** the two rows are different rows

#### Scenario: a one-off row keeps its key when its one-off is ticked, and no other row shares it

- **WHEN** a day view is formed on Monday 28 September 2026 as of that same day, of no commitments at
  all and of one-offs holding "Call mum" on 25 September 2026 and "Call mum" on 28 September 2026,
  neither done; and a second is formed the same way with "Call mum" on 25 September 2026 ticked on
  28 September 2026
- **THEN** the row of the first saying "3 days late" and the row of the second saying it is done
  have the same key, and are different rows
- **AND** the two rows of the first day view have different keys
- **AND** the row of "Call mum" on 25 September 2026, not done, in a day view formed the same way on
  Tuesday 29 September 2026 as of that same day has a different key from the row of the first
  saying "3 days late"
