## ADDED Requirements

### Requirement: One-offs answer the one-offs standing on a day, every one owed before every one done

One-offs SHALL answer, when asked about a calendar date as of a today, every one-off they hold that
stands on that date as of that today, and no other. Every one-off in the answer that is not done
SHALL come before every one that is done. Those not done SHALL be ordered by each one-off's own date,
earliest first, and those owed on the same date SHALL keep the order they were added in. Those done
SHALL be ordered by the tick order, the most recently ticked first. The answer MUST NOT be ordered by
name or by the day a one-off was done. A date on which no one-off stands SHALL be answered with none
rather than refused. A one-off store opened again at a place SHALL give the same answer as the store
that kept those one-offs there, in the same order.

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

#### Scenario: every one-off owed stands before every one done, and the done stand most recently ticked first

- **WHEN** one-offs named "Call mum" on 20 September 2026, "Pay fine" on 25 September 2026 and
  "Send form" on 27 September 2026 are added in that order to a one-off store; "Call mum" and then
  "Pay fine" are ticked on 28 September 2026; and they are asked which stand on 28 September 2026 as
  of 28 September 2026
- **THEN** they answer "Send form", "Pay fine" and then "Call mum"
- **AND** asked which stand on 28 September 2026 as of 5 October 2026, they answer "Pay fine" and
  then "Call mum"
- **AND** a store opened afterwards at the same place answers the same, in the same order

### Requirement: One-offs keep the order their ticks were made in

One-offs SHALL keep the tick order: the order in which the one-offs they hold were made done. They
MUST NOT keep a time of day for it. A one-off ticked SHALL become the most recently ticked of those
held, and a one-off added already done SHALL become so as well. Taking back a one-off's tick SHALL
take it out of the tick order, and ticked again it SHALL become the most recently ticked. Renaming a
done one-off SHALL keep its place in the tick order, and removing a one-off SHALL leave the tick
order of every other one-off as it was. One-offs holding the same one-offs, each done on the same
day or not done, SHALL be the same one-offs exactly when their tick orders are the same.

#### Scenario: a tick taken back returns a one-off to its place among those owed, and ticked again it is the most recently ticked

- **WHEN** one-offs named "Call mum" and then "Book dentist", both on 25 September 2026, and then
  "Pay fine" on 20 September 2026 are added; "Call mum" and then "Pay fine" are ticked on
  28 September 2026; and the tick of "Call mum" is taken back
- **THEN** asked which stand on 28 September 2026 as of 28 September 2026, they answer "Call mum",
  "Book dentist" and then "Pay fine"
- **AND** after "Call mum" is ticked again on 28 September 2026, they answer "Book dentist",
  "Call mum" and then "Pay fine"

#### Scenario: a one-off added already done is the most recently ticked

- **WHEN** a one-off named "Call mum" on 20 September 2026 is added and ticked on 22 September 2026,
  and a one-off named "Pay fine" on 21 September 2026 is then added already done on
  22 September 2026
- **THEN** asked which stand on 22 September 2026 as of 28 September 2026, they answer "Pay fine" and
  then "Call mum"

#### Scenario: a done one-off renamed keeps its place in the tick order

- **WHEN** one-offs named "Call mum" on 20 September 2026 and "Pay fine" on 25 September 2026 are
  added, "Call mum" and then "Pay fine" are ticked on 28 September 2026, and "Call mum" is renamed
  "Ask mum"
- **THEN** asked which stand on 28 September 2026 as of 28 September 2026, they answer "Pay fine" and
  then "Ask mum"

#### Scenario: one-offs differing only in their tick order are different one-offs

- **WHEN** one-offs named "Call mum" and then "Pay fine", both on 25 September 2026, are added and
  ticked on 28 September 2026, "Call mum" first; and the same two are added in the same order to
  other one-offs and ticked on 28 September 2026, "Pay fine" first
- **THEN** the two are different one-offs
- **AND** one-offs to which "Call mum", "Send form" and "Pay fine", all on 25 September 2026, are
  added and ticked on 28 September 2026 in that order, and "Send form" then removed, are the same
  one-offs as the first

### Requirement: A one-off store keeps the tick order, reads the form before it, and refuses one it could not hold

A one-off store SHALL keep the tick order at its place with the one-offs. A one-off store opened at a
place holding one-offs written in the form before the tick order was kept SHALL be read, not refused,
and opening it SHALL write nothing there. Every one-off done in such a store SHALL be older in the
tick order than every one ticked after it was opened, and those done SHALL be answered among
themselves by each one-off's own date, earliest first, and those owed on one date in the order they
were added in. Opening a store whose tick order does not give every one-off done, and no other, a
place of its own, numbered from one without a gap, SHALL be refused with an error, leaving what is
there unchanged; so SHALL opening one in the form before the tick order that holds any place in it.

#### Scenario: a one-off store kept before the tick order answers its done one-offs by the date owed, older than any tick since

- **WHEN** a one-off store is opened at a place holding, in the form written before the tick order
  was kept, one-offs named "Pay fine" on 25 September 2026, "Call mum" on 20 September 2026 and
  "Book dentist" on 20 September 2026, held in that order and each done on 28 September 2026, and
  "Send form" on 26 September 2026, not done
- **THEN** opening it is not refused
- **AND** asked which stand on 28 September 2026 as of 28 September 2026, they answer "Send form",
  "Call mum", "Book dentist" and then "Pay fine"
- **AND** the content at that place is byte-for-byte what it was before
- **AND** after "Send form" is ticked there on 28 September 2026, a store opened afterwards at that
  place answers "Send form", "Call mum", "Book dentist" and then "Pay fine"

#### Scenario: a one-off store holding a tick order that could not be held is refused

- **WHEN** a one-off store is opened at a place holding a store in the form this app writes, whose
  one one-off is named "Call mum" on 25 September 2026, done on 28 September 2026 and given no place
  in the tick order
- **THEN** opening is refused with an error
- **AND** a store whose one one-off is not done and has a place in the tick order is refused the same
  way
- **AND** a store whose two done one-offs have the same place is refused the same way
- **AND** a store whose two done one-offs have the first place and the third is refused the same way
- **AND** a store in the form written before the tick order was kept, whose one done one-off has a
  place in it, is refused the same way
- **AND** the content at each place is byte-for-byte what it was before

## REMOVED Requirements

### Requirement: One-offs answer the one-offs standing on a day, earliest owed first

**Reason**: The order is no longer by the date owed alone: every one-off owed now stands before every
one done, and the done stand in the tick order. The ADDED requirement for the answer states it whole
and carries this requirement's first two scenarios verbatim.

**Migration**: The tests named for the two carried scenarios stand unedited. The test named for "done
and undone one-offs standing on one day are ordered by the date owed alone" is deleted, and the test
named for the ADDED scenario "every one-off owed stands before every one done, and the done stand
most recently ticked first" takes its place.
