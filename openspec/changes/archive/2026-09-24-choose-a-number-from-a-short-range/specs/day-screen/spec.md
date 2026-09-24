## ADDED Requirements

### Requirement: A number entry is chosen from the values of a short range, and typed otherwise

A number entry SHALL be chosen where the range its row's commitment declares is short, and typed
otherwise, a commitment declaring no range included. A range SHALL be short where both its bounds
are whole numbers and it holds eleven whole numbers or fewer, both bounds counted. The commitment
SHALL be the one the row holds, the era holding the row's date, and never another.

A chosen entry SHALL say as its values every whole number from the lowest bound to the highest, both
included, lowest first, and SHALL say no hint. Neither whether an entry is chosen nor its values
SHALL depend on what the history holds, and a number the day holds that is not among them SHALL NOT
be added to them. Text committed in a chosen entry SHALL change nothing at all, a take-back
included, and SHALL end nothing already told.

#### Scenario: a number entry of a range of one to ten is chosen from the ten whole numbers in it

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Mood" of the number kind with a range of 1 to 10, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of that same
  day
- **THEN** the entry that row offers is chosen, and says the values 1, 2, 3, 4, 5, 6, 7, 8, 9 and 10
  in that order
- **AND** it says no hint and no number
- **AND** the entry of a row for a commitment alike in every way but with a range of 0 to 10 is
  chosen, and says the eleven values 0 to 10 in order
- **AND** the entry of one with a range of -2 to 2 says the values -2, -1, 0, 1 and 2 in that order
- **AND** the entry of one with a range of 4 to 4 says the one value 4

#### Scenario: a number entry of a range holding more than eleven whole numbers, or a bound that is not whole, is typed

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Hours" of the number kind with a range of 1 to 12, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of that same
  day
- **THEN** the entry that row offers is typed, says the hint "1–12" and says no values
- **AND** the entry of a row for a commitment alike in every way but with a range of 1 to 10.5 is
  typed and says the hint "1–10.5"
- **AND** the entry of one with a range of 0.5 to 5 is typed and says the hint "0.5–5"
- **AND** the entry of one with no range is typed and says no hint and no values

#### Scenario: a chosen entry on a day holding a number not among its values says that number, and its values as they are

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Mood" of the number
  kind with a range of 1 to 10, on a schedule listing Monday, Wednesday and Saturday, kept from 1
  January 2026, from a history holding a number of 5.5 for that commitment on that date, and its one
  row is asked as of that same day
- **THEN** the entry that row offers is chosen and says the number 5.5
- **AND** it says the values 1 to 10 in order, and no other
- **AND** the entry of a row of a day view formed the same way but from a history holding a number of
  7 instead says the number 7 and those same values

#### Scenario: a number entry is chosen or typed by the range of the era holding its day

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10, on a schedule
  listing all seven weekdays, kept from 1 January 2026, is taken on at a roster place; a
  commitments screen opened at that place as of Monday 31 August 2026 changes its range to 1 to 20;
  and a day screen of no commitments at all is then opened at that roster place and a record place
  where nothing has been kept, as of that same day
- **THEN** the entry its one row offers is typed and says the hint "1–20"
- **AND** once the screen is moved to the day before, the entry the row it then holds offers is
  chosen and says the values 1 to 10 in order
- **AND** where the range is changed the other way, from 1 to 20 to 1 to 10, the entry is chosen on
  Monday 31 August 2026 and typed on the day before

#### Scenario: text committed in a chosen entry changes nothing, whatever it holds

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record in which a
  commitment named "Mood" of the number kind with a range of 1 to 10 holds the number 7 on that
  date, of a commitment named "Weight" of the number kind with a range of 40 to 150 and that
  commitment, in that order, both on a schedule listing Monday, Wednesday and Saturday and both kept
  from 1 January 2026; "300" is committed on the row named "Weight"; and each of "8", "5.5", "11",
  "abc" and nothing at all is then committed in turn on the row named "Mood"
- **THEN** the entry the row named "Mood" then offers says the number 7
- **AND** the day screen still tells, on the row named "Weight", that the number must be between 40
  and 150
- **AND** a day screen opened afterwards at the same place as of the same day says "Mood" holds 7

### Requirement: A day screen keeps the value chosen in a row's entry, and takes the day's number back through its clear

A day screen SHALL keep the value chosen in a row's chosen entry, replacing any number the day
holds, one not among the values included, and SHALL take the day's number back where the entry's
clear is chosen instead. Choosing the value the day holds, or the clear on a day holding no number,
SHALL write nothing and SHALL NOT be refused.

A choice SHALL change nothing on a row the day view does not hold, on a row offering no chosen entry
as of the screen's today, on a screen keeping no record, and for a value not among the entry's
values. A change SHALL be kept at the record place before the day view says so; one that cannot be
kept SHALL be refused and told on its row naming no cause, leaving the day view as it was. A choice
MUST NOT write to the roster's place.

#### Scenario: a value chosen in a chosen entry is kept, and the entry then says it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster place
  where nothing has been kept, of a commitment named "Mood" of the number kind with a range of 1 to
  10, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; the roster
  place is read once the screen has been opened; and 7 is chosen in its one row's entry
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** the entry the row it then holds offers says the number 7
- **AND** a day screen opened afterwards at the same places as of the same day says the same
- **AND** the content at the roster place is byte-for-byte what it was after the screen was opened

#### Scenario: a value chosen on a day holding another number replaces it, one not among the values included

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record in which a
  commitment named "Mood" of the number kind with a range of 1 to 10 holds the number 5.5 on that
  date, of that commitment on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and 7 is chosen in its one row's entry
- **THEN** the entry the row the day screen then holds offers says the number 7
- **AND** choosing 3 in the entry of the row it then holds leaves it saying the number 3
- **AND** a day screen opened afterwards at the same place as of the same day says the number 3

#### Scenario: choosing the value the day already holds writes nothing and is not refused

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and that holds a record in which a commitment named "Mood" of the number kind with
  a range of 1 to 10 holds the number 7 on that date, of a commitment named "Weight" of the number
  kind with a range of 40 to 150 and that commitment, in that order, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026; "300" is committed on the row
  named "Weight"; and 7 is then chosen in the entry of the row named "Mood"
- **THEN** choosing is not refused
- **AND** the entry the row named "Mood" then offers says the number 7
- **AND** the day screen still tells, on the row named "Weight", that the number must be between 40
  and 150, and tells nothing on the row named "Mood"

#### Scenario: the clear takes the day's number back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Mood" of the number kind with a range of 1 to 10, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; 7 is chosen in its one row's
  entry; and the clear is then chosen in the entry of the row it then holds
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** the entry its row offers says no number
- **AND** a day screen opened afterwards at the same place as of the same day says the same
- **AND** the clear chosen on a day screen opened at a place whose record holds 5.5 for that
  commitment on that date leaves its row's entry saying no number too

#### Scenario: the clear on a day holding no number writes nothing and is not refused

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and that holds a record in which a commitment named "Weight" of the number kind
  with a range of 40 to 150 holds the number 70.5 on that date, of that commitment and a commitment
  named "Mood" of the number kind with a range of 1 to 10, in that order, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026, and the clear is chosen in the
  entry of the row named "Mood"
- **THEN** choosing is not refused and the day screen tells nothing
- **AND** its day view still says "Weight" holds the number 70.5 on that date

#### Scenario: a choice that cannot be kept is refused, told on its row naming no cause, and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Mood" of the number
  kind with a range of 1 to 10, on a schedule listing Monday, Wednesday and Saturday, kept from 1
  January 2026, and 7 is chosen in its one row's entry
- **THEN** choosing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept, and names no cause
- **AND** its day view still says the commitment is not kept on that date
- **AND** the clear chosen on a day screen opened at a place that can be read from but not written
  to, whose record holds 7 for that commitment on that date, is refused and told alike, its day
  view still saying the number 7

#### Scenario: a value that is not among the entry's values changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Mood" of the number kind with a range of 1 to 10, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and each of 11, 0, -1 and 5.5 is
  chosen in turn in its one row's entry
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** the day screen tells nothing on any row
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a choice on a row that offers no chosen entry changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, a commitment named "Weight" of the number kind
  with a range of 40 to 150 and a commitment named "Mood" of the number kind with a range of 1 to
  10, all three on a schedule listing all seven weekdays and all kept from 1 January 2026; 70 is
  chosen on the row named "Weight" and 7 on the row named "Gym"; the screen is then moved to the day
  after; and 7 is chosen on the row it then holds named "Mood"
- **THEN** the day screen's day view says none of the three is kept on Tuesday 1 September 2026
- **AND** it tells nothing on any row
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says none of the
  three is kept on that date

#### Scenario: choosing on a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Mood" of the number kind with a range of 1 to 10,
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, are opened at one
  place where nothing has been kept, the first as of Monday 31 August 2026 and the second as of
  Wednesday 2 September 2026, and 7 is chosen on the first screen in the second screen's row's entry
- **THEN** the first day screen's day view still says the commitment is not kept on Monday 31 August
  2026
- **AND** a day screen opened afterwards at that place as of Wednesday 2 September 2026 says the
  commitment is not kept on that date either

#### Scenario: choosing on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes that
  is not what a record is written as, of a commitment named "Mood" of the number kind with a range of
  1 to 10, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and 7 is
  chosen in its one row's entry
- **THEN** its day view still says the commitment is not kept on that date
- **AND** it still says it is not keeping a record
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

## MODIFIED Requirements

### Requirement: A number entry says the range its commitment takes and the number the day already holds

A number entry SHALL say two things and no others: the number the history the day view was formed
from holds for that commitment on that date, or no number where it holds none; and the range the
commitment declares, as a hint where the entry is typed and as its values where it is chosen, or no
hint where it declares none.

The hint SHALL be the lowest bound the commitment declares, an en dash, and the highest — "40–150"
for a range of 40 to 150 — in this package's own words and no locale's, each bound said as given, no
digit added or dropped. The number SHALL be the one the `record` capability answers for that
commitment on that date, MUST NOT be recomputed here, and SHALL be no number where the history has
had it taken back. A row SHALL NOT say the number itself.

#### Scenario: a number entry says the range its commitment declares as a hint

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Weight" of the number kind with a range of 40 to 150 and a commitment
  named "Sleep" of the number kind with a range of 0 to 24, both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, and both its rows are asked as of that
  same day
- **THEN** the entry the first row offers says the hint "40–150"
- **AND** the entry the second row offers says the hint "0–24"
- **AND** the entry of a row for a commitment alike in every way but with a range of 40.5 to
  150.25 says the hint "40.5–150.25"

#### Scenario: a number entry of a commitment that declares no range says no hint

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Weight" of the number kind with no range, on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of that same day
- **THEN** the entry that row offers says no hint

#### Scenario: a number entry says the number the history holds for that commitment on that date

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, from a history holding a number of 70.5 for that commitment on that
  date, and its one row is asked as of that same day
- **THEN** the entry that row offers says the number 70.5
- **AND** it says 70.5 exactly, not 70 and not 71

#### Scenario: a number entry says no number where the day holds none

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Weight"
  of the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, the first from a history that has taken no record and the
  second from a history a number of 70.5 for that commitment on that date was added to and then
  taken back from, and each one's row is asked as of that same day
- **THEN** the entry the first row offers says no number
- **AND** the entry the second row offers says no number

#### Scenario: a row for a number commitment holding a number says its name, its rhythm and that the day is kept

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, from a history holding a number of 70.5 for that commitment on that
  date
- **THEN** the day view holds one row named "Weight"
- **AND** that row says "Mon, Wed, Sat"
- **AND** it says the commitment is kept
- **AND** a row of a day view formed the same way but from a history holding a number of 71
  instead says all three of those things identically

### Requirement: A day screen reads what an entry is committed with as a number, as a take-back, or as neither

A day screen SHALL read what is committed in a number entry as exactly one of three things: a
number, a take-back, or a value that is not a number. It MUST NOT consult the device's locale,
region or keyboard. Blank space around what is committed SHALL be disregarded before it is read, and
SHALL mean whatever the `record` capability means by it, decided neither again here nor differently
for a note entry; a character of no width is not blank space.

What holds nothing once blank space is disregarded SHALL be a take-back, and nothing else SHALL be
one. It SHALL be a number when it holds, in this order and nothing else, an optional minus sign,
then digits and at most one decimal separator with at least one digit among them; the separator
SHALL be a full stop or a comma, read alike, and the number SHALL be exactly what those digits say.
Up to thirty-eight significant digits SHALL be kept, counted from the first digit that is not a zero
to the last that is not a zero; text saying more, or a number too large or too near zero to hold,
MUST NOT be rounded, shortened or fitted to what can be held. Everything else SHALL be a value that
is not a number: two separators, a separator with no digit beside it, a sign anywhere but the front,
an exponent, letters or spaces among the digits, a character of no width anywhere in it, a digit
that is not one of the ten this package reads, and digits saying a number that cannot be kept
exactly. Such a value SHALL keep nothing, take nothing back, and leave the day exactly as it was.

#### Scenario: a number typed with a full stop is entered exactly as it was typed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and "70.5" is committed on its one row
- **THEN** the entry the row the day screen then holds offers says the number 70.5
- **AND** committing "0.000001" and then "98765432109876543210.5" on that row leaves it saying
  each of those numbers in turn, digit for digit

#### Scenario: a number typed with a comma is entered as the same number as one typed with a full stop

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "70,5" is committed on its
  one row
- **THEN** the entry the row the day screen then holds offers says the number 70.5

#### Scenario: a number typed with leading zeros or a trailing separator is entered as the number it says

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and "0000070.50" is committed on its
  one row
- **THEN** the entry the row the day screen then holds offers says the number 70.5
- **AND** committing "70." on that row leaves it saying the number 70
- **AND** committing " 70.5 " on that row leaves it saying the number 70.5

#### Scenario: a negative number is entered where the commitment declares no range

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Balance" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and "-12.75" is committed on its one
  row
- **THEN** the entry the row the day screen then holds offers says the number -12.75
- **AND** the day view says the commitment is kept on that date

#### Scenario: an entry committed empty takes the number back, and one holding nothing but space does the same

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a
  commitment named "Sleep" of the number kind with a range of 0 to 24, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026; "70.5" is committed on the
  first row and "8" on the second; and then nothing at all is committed on the first row and two
  spaces on the second
- **THEN** the day screen's day view says neither commitment is kept on that date
- **AND** the entry each of its rows offers says no number

#### Scenario: an entry committed with line breaks alone takes the number back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and a text of three line breaks is then committed on the row it then holds
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** the entry its row offers says no number
- **AND** the day screen tells nothing on any row
- **AND** committing "70.5" again and then a text of one tab followed by one line break leaves it
  saying no number too
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: an entry committed with a zero-width space alone keeps nothing and takes nothing back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and a text of one zero-width space is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 70.5
- **AND** the day view says the commitment is kept on that date
- **AND** the day screen tells, on that row, that it is not a number
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a value that is not a number keeps nothing and takes nothing back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one row;
  and each of "1.2.3", ".", "-", "12abc", "1e3", "7-0" and "٧٠" is then committed in turn on the
  row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 70.5 after every one
  of them
- **AND** the day view says the commitment is kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a number of as many digits as can be kept is entered exactly

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and a whole number of thirty-eight
  nines is committed on its one row
- **THEN** the entry the row the day screen then holds offers says that number, digit for digit
- **AND** the day view says the commitment is kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a number too long to be kept exactly keeps nothing and takes nothing back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one row; and
  a whole number of thirty-nine nines, a whole number of two hundred ones, and a number whose only
  digit that is not a zero is at the hundred-and-twenty-ninth place after the point are each then
  committed in turn on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 70.5 after every one
  of them
- **AND** the day screen tells, on that row, that it is not a number
- **AND** the day view says the commitment is kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a number whose zeros lie outside its significant digits is entered exactly

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and a whole number written as a one
  followed by fifty zeros is committed on its one row
- **THEN** the entry the row the day screen then holds offers says that number, digit for digit
- **AND** committing a number whose only digit that is not a zero is a one at the fifty-first place
  after the point leaves it saying that number, digit for digit
- **AND** committing a whole number written as thirty-eight nines followed by ten zeros leaves it
  saying that number, digit for digit

#### Scenario: a number too large to hold keeps nothing and takes nothing back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one row; and
  a whole number written as a one followed by two hundred zeros is then committed on the row it
  then holds
- **THEN** the entry the row the day screen then holds offers says the number 70.5
- **AND** the day screen tells, on that row, that it is not a number
- **AND** the day view says the commitment is kept on that date

#### Scenario: a number with spaces among its digits keeps nothing and takes nothing back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with no range, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one row; and
  each of "7 0", "1 000" and "70. 5" is then committed in turn on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 70.5 after every one
  of them
- **AND** the day screen tells, on that row, that it is not a number
- **AND** the day view says the commitment is kept on that date

### Requirement: A day screen tells on the row that was tapped that its change could not be kept

Where a change a row offers cannot be kept, a day screen SHALL tell it on the row tapped or
committed on and SHALL refuse the change to the caller as well; where the value given was refused
instead, that telling SHALL be the whole report and nothing SHALL be thrown. A cause SHALL be named
only where a person can act on it: a change the place refused SHALL name none, and MUST NOT tell
which change was asked or why it was refused.

Exactly four causes SHALL be named and no fifth: "Not a number" for a value that is not a number, in
a number entry or a total entry; "Must be between 40 and 150" — the commitment's own declared range
— for a number it refuses; "Must be more than 0" for an amount not above zero; and "Too large to
add" for an amount that would take the day past what can be kept exactly. The words SHALL be this
package's own English and no locale's. Nothing about a note's
length, script, line breaks or characters SHALL be named as a cause. At most one row SHALL be told
at a time, the one tapped or committed on last, and a second refusal SHALL move what is told, with
its cause, onto its own row, leaving nothing on the first. Where a day view holds two rows that are
the same row, both SHALL be told of. Telling MUST NOT change what a day screen says about keeping a
record.

#### Scenario: a refused tick is told on the row that was tapped and on no other row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, a commitment named "Journaling" on a schedule listing
  all seven weekdays and a commitment named "Supplements and habits" on that same schedule, in
  that order and all kept from 1 January 2026, and the second of its three rows is ticked
- **THEN** the day screen tells, on the second row, that the change could not be kept
- **AND** it tells nothing on the first row and nothing on the third

#### Scenario: a refused take-back is told on the row that was tapped

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from
  but not written to and that holds a record in which a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, is already kept on that date,
  and its one row — which says the commitment is kept — is ticked
- **THEN** taking the tick back is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** its day view still says the commitment is kept on that date

#### Scenario: a second refused tap is told on the row tapped last and no longer on the first

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Journaling" on a schedule listing
  all seven weekdays, in that order and both kept from 1 January 2026; its first row is ticked;
  and its second row is then ticked
- **THEN** both taps are refused with an error
- **AND** the day screen tells, on the second row, that the change could not be kept
- **AND** it tells nothing on the first row

#### Scenario: a refused change does not change what a day screen says about keeping a record

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
  twice
- **THEN** the day screen says it is keeping a record
- **AND** it tells, on that row, that the change could not be kept

#### Scenario: a number outside the commitment's range is told on the row, naming the bounds it broke

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a
  commitment named "Sleep" of the number kind with a range of 0 to 24, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026, and "300" is committed on the
  first row
- **THEN** the day screen tells, on that row, that the number must be between 40 and 150
- **AND** it tells nothing on the second row
- **AND** committing "25" on the second row of the screen it then holds tells, on that row, that
  the number must be between 0 and 24

#### Scenario: a number refused by the place is told on the row and names no cause

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, and "70.5" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause

#### Scenario: a second refused commit is told on the row committed on last and no longer on the first

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a
  commitment named "Sleep" of the number kind with a range of 0 to 24, in that order and both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026; "300" is
  committed on the first row; and "1.2.3" is then committed on the second row of the screen it
  then holds
- **THEN** the day screen tells, on the second row, that it is not a number
- **AND** it tells nothing on the first row

#### Scenario: a note refused by the place is told on the row and names no cause

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journal" of the note
  kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  "Ran 8k." is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause
- **AND** committing a note of a hundred thousand characters on that row tells the same thing on it
  and names no cause either

#### Scenario: an amount that is not above zero is told on the row, saying so

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120 and a commitment
  named "Water" of the total kind with a target of 2, both on a schedule listing Monday, Wednesday
  and Saturday and both kept from 1 January 2026, and "0" is committed on the first row
- **THEN** the day screen tells, on that row, that it must be more than 0
- **AND** it tells nothing on the second row
- **AND** committing "-1" on the second row of the screen it then holds tells, on that row, that it
  must be more than 0, and tells nothing on the first

#### Scenario: an amount too large to add to the day is told on the row, saying so

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; a whole number of thirty-eight
  nines is committed on its one row; and "0.5" is then committed on the row it then holds
- **THEN** the day screen tells, on that row, that it is too large to add
- **AND** what it tells is not "Not a number" and not "Must be more than 0"

#### Scenario: a value that is not a number committed in a total entry is told the same thing a number entry tells

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a commitment
  named "Protein" of the total kind with a target of 120, in that order and both on a schedule
  listing Monday, Wednesday and Saturday and both kept from 1 January 2026, and "1.2.3" is committed
  on the first row and then on the second row of the screen it then holds
- **THEN** the day screen tells, on the second row, that it is not a number
- **AND** what it tells there is word for word what it told on the first row

#### Scenario: an addition refused by the place is told on the row and names no cause

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Protein" of the total
  kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and "30" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause

### Requirement: A day screen enters the number a row's entry takes, and keeps the change before the day view says so

A day screen SHALL enter, on one of its rows, the number a person commits in that row's number
entry, and SHALL take that day's number back where what is committed is empty; which of the two a
commit means SHALL be read off what was committed and MUST NOT be given to the screen. The entry
SHALL be the one the row itself offers, asked as of the today the screen was handed and never the
day it is showing.

A commit SHALL change nothing at all — nothing kept, nothing shown, nothing told — on a row the
screen's day view does not hold, on a row that offers no number entry, and on a screen that is not
keeping a record. A number the commitment refuses SHALL keep nothing and SHALL leave the day exactly
as it was. The change SHALL be kept at the screen's record place before its day view says so, and
the day view SHALL then be formed again from the record as it stands rather than altered; a change
that could not be kept SHALL be refused, reported to the caller, and SHALL leave the day view
exactly as it was. A number entered on a day that already holds one SHALL replace it. Taking one
back SHALL reach the place only where the day holds a number, and SHALL be refused only by the
place.
Entering a number or taking one back MUST NOT write to the roster's place or change what the screen
says about its roster.

#### Scenario: a number entered on a day that already holds one replaces it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and "71.2" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 71.2
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: committing an empty entry takes the number back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and nothing at all is then committed on the row it then holds
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** the entry its row offers says no number
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: committing an empty entry on a day that holds no number leaves the day as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and nothing at all is
  committed on its one row
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a number the commitment refuses keeps nothing and leaves the day as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and "300" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the number 70.5
- **AND** the day view says the commitment is kept on that date
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: a number that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, and "70.5" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen's day view still says the commitment is not kept on that date
- **AND** a day screen opened afterwards at the same place says the same

#### Scenario: entering a number on a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, are opened
  at one place where nothing has been kept, the first as of Monday 31 August 2026 and the second
  as of Wednesday 2 September 2026, and "70.5" is committed on the first screen in the second
  screen's row's number entry
- **THEN** the first day screen's day view still says the commitment is not kept on Monday 31
  August 2026
- **AND** a day screen opened afterwards at that place as of Wednesday 2 September 2026 says the
  commitment is not kept on that date either

#### Scenario: committing on a row that offers no number entry changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind and a commitment named "Weight" of the number
  kind with a range of 40 to 150, both on a schedule listing all seven weekdays and both kept from
  1 January 2026; "70.5" is committed on the row named "Gym"; the screen is then moved to the day
  after; and "70.5" is committed on the row it then holds named "Weight"
- **THEN** the day screen's day view says neither commitment is kept on Tuesday 1 September 2026
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says neither is
  kept on that date

#### Scenario: entering a number on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Weight" of the number kind with
  a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and "70.5" is committed on its one row
- **THEN** its day view still says the commitment is not kept on that date
- **AND** it still says it is not keeping a record
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: entering a number on one row leaves the other rows of the day as they were

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, a commitment named "Weight" of the number
  kind with a range of 40 to 150 and a commitment named "Mood" of the number kind with a range of
  1 to 10, in that order, all three on a schedule listing all seven weekdays and all kept from 1
  January 2026, and "70.5" is committed on the second row
- **THEN** the day screen's day view holds three rows in that same order
- **AND** only the second says its commitment is kept

#### Scenario: entering a number on a day a day screen has moved back to keeps it on that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day before; and "70.5"
  is committed on its one row
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** a day screen opened afterwards at that place as of Sunday 30 August 2026 says the
  commitment is kept on that date
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says the
  commitment is not kept on that date

#### Scenario: entering a number writes nothing to the roster's place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster
  place where nothing has been kept, of a commitment named "Weight" of the number kind with a
  range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026; the roster place is read once the screen has been opened; and "70.5" is then committed on
  its one row, and nothing at all committed on the row it then holds
- **THEN** the content at the roster place is byte-for-byte what it was after the screen was
  opened
- **AND** the day screen says it is keeping its roster

#### Scenario: committing an empty entry at a place that cannot be written is refused only on a row whose day holds a number

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and that holds a record in which a commitment named "Weight" of the number kind
  with a range of 40 to 150 holds the number 70.5 on that date, of that commitment and a commitment
  named "Sleep" of the number kind with a range of 0 to 24, in that order, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026; nothing at all is committed on
  the row named "Sleep"; and nothing at all is then committed on the row named "Weight"
- **THEN** committing on the row named "Sleep" is not refused and the day screen tells nothing
- **AND** committing on the row named "Weight" is refused with an error
- **AND** the day screen then tells, on the row named "Weight", that the change could not be kept
- **AND** its day view still says "Weight" holds the number 70.5 on that date
