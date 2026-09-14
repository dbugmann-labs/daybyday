## ADDED Requirements

### Requirement: One-offs answer the one-offs standing on a day, earliest owed first

One-offs SHALL answer, when asked about a calendar date as of a today, every one-off they hold that
stands on that date as of that today, and no other. The answer SHALL be ordered by each one-off's own
date, earliest first, and one-offs owed on the same date SHALL keep the order they were added in. The
answer MUST NOT be ordered by name, by whether a one-off is done, or by the day one was done. A date
on which no one-off stands SHALL be answered with none rather than refused. A one-off store opened
again at a place SHALL give the same answer as the store that kept those one-offs there, in the same
order.

#### Scenario: one-offs standing on a day are answered earliest owed first

- **WHEN** one-offs named "Send form" on 27 September 2026, "Call mum" on 25 September 2026 and
  "Pay fine" on 20 September 2026 are added in that order, none done, and are asked which stand on
  28 September 2026 as of 28 September 2026
- **THEN** they answer "Pay fine", "Call mum" and then "Send form"
- **AND** asked which stand on 27 September 2026 as of 28 September 2026, they answer none

#### Scenario: one-offs owed on one date keep the order they were added in

- **WHEN** a one-off named "Call mum" and then one named "Book dentist", both on 25 September 2026
  and neither done, are added to a one-off store, and are asked which stand on 25 September 2026 as
  of 21 September 2026
- **THEN** they answer "Call mum" and then "Book dentist"
- **AND** a store opened afterwards at the same place answers the same, in the same order

#### Scenario: done and undone one-offs standing on one day are ordered by the date owed alone

- **WHEN** one-offs named "Send form" on 28 September 2026, "Call mum" on 25 September 2026 and
  "Pay fine" on 20 September 2026 are added in that order; "Call mum" is ticked on 28 September 2026;
  and they are asked which stand on 28 September 2026 as of 28 September 2026
- **THEN** they answer "Pay fine", "Call mum" and then "Send form"
- **AND** asked which stand on 28 September 2026 as of 5 October 2026, they answer "Call mum" alone
