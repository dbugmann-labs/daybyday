## ADDED Requirements

### Requirement: A weekly quota said given what its week owes says that number in place of its own times a week

A schedule SHALL be said in words given a count and what its week owes, two whole numbers. A weekly
quota said so SHALL say the count, a slash with no space on either side, and then its plain words
with what the week owes in place of its own number of times, so a count of one against a week owing
two SHALL be said "1/2x a week". Both numbers SHALL be said exactly as given and judged against
nothing, a week owing nothing included. A weekday set, a day of the month and an interval of days
said so SHALL say exactly the words each says plainly.

#### Scenario: a weekly quota said given a count and what its week owes says that number in place of its own

- **WHEN** a schedule of 3 times a week is said in words given a count of 1 and a week owing 2, and
  given a count of 0 and a week owing 0
- **THEN** they say "1/2x a week" and "0/0x a week"
- **AND** a schedule listing Monday, Wednesday and Saturday said given a count of 1 and a week owing
  2 says "Mon, Wed, Sat"
