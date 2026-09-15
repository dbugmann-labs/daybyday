## ADDED Requirements

### Requirement: A one-off is renamed in place, keeping its date, whether it is done and its place

Renaming a one-off that is held SHALL give it the new name exactly as given, and SHALL keep its
date, whether it is done, the day it was done where it is, and its place among the one-offs owed on
its date in the order they are answered. The one-off under its old name SHALL then be held no
longer. Renaming SHALL be refused, and what is held SHALL be unchanged, where the one-off is not
held, where the new name says nothing, and where a one-off with the new name on the same date is
already held, the one-off being renamed included. A one-off store SHALL keep a rename at its place
before it reports it kept, and SHALL refuse and not hold a rename that cannot be kept.

#### Scenario: a one-off renamed keeps its date, whether it is done and its place among one-offs owed on its date

- **WHEN** one-offs named "Call mum" and then "Book dentist", both on 25 September 2026 and neither
  done, are held, and "Call mum" is renamed "Ring mum"
- **THEN** renaming it is not refused
- **AND** asked which stand on 25 September 2026 as of 21 September 2026, they answer "Ring mum" and
  then "Book dentist"
- **AND** a one-off named "Call mum" on 25 September 2026 stands nowhere
- **AND** a one-off named "Pay fine" on 20 September 2026, ticked on 28 September 2026 and then
  renamed "Pay the fine", stands on 28 September 2026 as of 5 October 2026

#### Scenario: renaming a one-off onto a one-off already held on its date is refused and changes nothing

- **WHEN** one-offs named "Call mum" and "Ring mum", both on 25 September 2026, and "Ring mum" on
  26 September 2026 are held, and "Call mum" on 25 September 2026 is renamed "Ring mum"
- **THEN** renaming it is refused
- **AND** what is held is unchanged
- **AND** renaming "Call mum" on 25 September 2026 to "Call mum" is refused the same way
- **AND** renaming "Ring mum" on 26 September 2026 to "Call mum" is not refused

#### Scenario: renaming a one-off to a name that says nothing, or renaming one not held, is refused

- **WHEN** a one-off named "Call mum" on 25 September 2026 is held and is renamed with a name of
  blank space alone
- **THEN** renaming it is refused
- **AND** what is held is unchanged
- **AND** renaming it with an empty name is refused the same way
- **AND** renaming a one-off named "Call dad" on 25 September 2026, which is not held, is refused the
  same way

#### Scenario: a rename is kept at a one-off store before the store reports it, and one that cannot be kept is refused

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added to a one-off store and renamed
  "Ring mum", and a second store is then opened at the same place with the first still open
- **THEN** the second store holds a one-off named "Ring mum" on 25 September 2026 and none named
  "Call mum"
- **AND** renaming "Call mum" on 25 September 2026 to "Ring mum" at a store whose place holds it and
  is then made so that it can be read from but not written to is refused with an error
- **AND** a store opened afterwards at that place holds "Call mum" alone
