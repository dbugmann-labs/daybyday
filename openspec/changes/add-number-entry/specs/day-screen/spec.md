## ADDED Requirements

### Requirement: A row offers the number entry its commitment takes, and offers none for a day that has not arrived

A row SHALL offer, when asked as of a calendar date, either exactly one number entry or nothing at
all. The entry it offers SHALL be the entry for that row's commitment on the date the day view
holding it is of, and nothing else: the row is a commitment on a date and a number is of a
commitment on a date, so there is nothing left for a caller to supply and nothing for the row to
choose.

The row SHALL offer nothing when its commitment's kind is not a number, and SHALL offer nothing when
the day view's date is later than the day it is asked as of. Where neither holds it SHALL offer the
entry. A row asked as of its own date SHALL offer it — a day that has arrived can have been kept,
and only one that has not is refused — and so SHALL a row whose date is earlier, however much
earlier: the past is writable back to the day the commitment is kept from, and a commitment that is
not due there has no row to ask.

The second refusal is the tick's own, word for word and for the same reason: a record is what a
person did about a day, and a day that has not happened has nothing yet to say about it. Its price
is the same too — such a row invites a tap it will not answer — and that price is deliberately paid
again here rather than fixed, so that one answer covers both kinds of row and whoever fixes it fixes
it once.

A row SHALL offer at most one of a tick and a number entry, and never both. A commitment's kind says
what its days take and it says one thing: a row whose commitment's kind is a tick offers the tick
and no number entry, one whose kind is a number offers the entry and no tick, and one whose kind is
a note or a total offers neither, on every day, until there is a record for what those days take.
Which of the two it offers is therefore the only thing a row says about its kind — a row of either
kind says its name, the rhythm it runs on and whether the day was kept in exactly the same way.

Whether a row offers an entry SHALL NOT depend on what the history says. A row already saying its
commitment is kept offers one exactly as a row saying it is not, because a number entered can be
entered again and a number entered on the wrong day has to be reachable to be taken back. What the
entry it offers *carries* does depend on the history, and that is the next requirement's.

The day the row is asked as of SHALL be given to it, and this capability MUST NOT read it from a
clock, MUST NOT consult the present moment, the device's time zone or the locale, and MUST NOT keep
it. A row therefore answers the same way for ever when asked as of the same day.

#### Scenario: a row offers the number entry for its commitment on the date the day view is of

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of
  Monday 31 August 2026
- **THEN** the day view holds one row named "Weight"
- **AND** that row offers a number entry

#### Scenario: a row for a commitment whose kind is not a number offers no number entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, one named "Journal" of the note kind and one named
  "Water" of the total kind with a target of 120, all three on a schedule listing Monday,
  Wednesday and Saturday and all kept from 1 January 2026, and each of its rows is asked as of
  Monday 31 August 2026
- **THEN** the day view holds three rows, named "Gym", "Journal" and "Water"
- **AND** none of them offers a number entry
- **AND** a row for a commitment alike in every way but of the number kind with no range, asked as
  of that same day, offers one

#### Scenario: a row offers a tick or a number entry and never both

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind and a commitment named "Weight" of the number kind
  with a range of 40 to 150, both on a schedule listing Monday, Wednesday and Saturday and both
  kept from 1 January 2026, and both its rows are asked as of Monday 31 August 2026
- **THEN** the row named "Gym" offers a tick and no number entry
- **AND** the row named "Weight" offers a number entry and no tick

#### Scenario: a row for a date later than the day it is asked as of offers no number entry

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  record, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is
  asked as of Monday 31 August 2026
- **THEN** the day view holds one row named "Weight"
- **AND** that row offers no number entry
- **AND** it offers no tick either

#### Scenario: a row for a date later than the day it is asked as of offers no number entry even where the day holds a number

- **WHEN** a day view is formed on Wednesday 2 September 2026, of a commitment named "Weight" of
  the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, from a history holding a number of 70.5 for that commitment on that
  date, and its one row is asked as of Monday 31 August 2026
- **THEN** that row says the commitment is kept
- **AND** it offers no number entry

#### Scenario: a row for a date earlier than the day it is asked as of offers the number entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of
  Saturday 5 September 2026
- **THEN** the row offers a number entry

#### Scenario: a row offers the number entry whether or not the day is already kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Weight"
  of the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, the first from a history that has taken no record and the
  second from a history holding a number of 70.5 for that commitment on that date, and each one's
  row is asked as of that same day
- **THEN** the first row says the commitment is not kept and the second says it is
- **AND** both offer a number entry

### Requirement: A number entry says the range its commitment takes and the number the day already holds

A number entry SHALL say two things and no others: the number the history the day view was formed
from holds for that commitment on that date, or **no number** where it holds none; and the range the
commitment declares, said as a hint, or **no hint** where it declares none.

The hint SHALL be the lowest the commitment declares, an en dash, and the highest, and nothing else
— "40–150" for a weight of 40 to 150, "1–10" for a mood of one to ten. It is this package's own
words and no locale's, as a day title and a rhythm in words are, and each bound SHALL be said as it
was given, with no digit added and none dropped: a range of 40.5 to 150 says "40.5–150". A
commitment that declares no range SHALL say no hint, because there is no bound to say and an
invented one would be a rule the commitment does not carry. A range hint exists so that a person
learns what a commitment takes before it refuses them; a range that is only ever a refusal teaches
by refusing, which is the one way this product will not teach.

The number SHALL be the one the `record` capability answers for that commitment on that date, asked
of the history the day view was formed from, and MUST NOT be recomputed here — exactly as whether
the day is kept is. An entry offered again from a history the number has been taken back from SHALL
say no number.

A row SHALL NOT say the number itself. What a row gives back is its name, the rhythm its commitment
runs on in words, whether that commitment is kept, and what it offers; the number is reachable only
through the entry. So a row for a day holding 70.5 and a row for a day holding 71 say exactly what a
ticked row says — that the day was kept — and a number is read where a number is worth reading,
which is not the daily list of what a day asks of you.

#### Scenario: a number entry says the range its commitment declares as a hint

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Weight" of the number kind with a range of 40 to 150 and a commitment
  named "Mood" of the number kind with a range of 1 to 10, both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, and both its rows are asked as of that
  same day
- **THEN** the entry the first row offers says the hint "40–150"
- **AND** the entry the second row offers says the hint "1–10"
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

### Requirement: A day screen enters the number a row's entry takes, and keeps it before the day view says so

A day screen SHALL enter, on one of its rows, the number a person commits in that row's number
entry, and SHALL take the number on that day back where what is committed is empty. Which of the two
a commit means SHALL be read off what was committed and MUST NOT be given to the screen: something
holding a number enters it, something holding nothing takes the number back, and there is nothing
else a commit can mean. What holds a number and what holds nothing is the next requirement's.

The entry SHALL be the one the row itself offers, asked as of the today the screen was handed and
never as of the day it is showing. A day screen moved onto a day that has not arrived therefore
enters nothing on it: the row it holds is for a date later than that today, and such a row offers no
entry. The screen MUST NOT form a number of its own, MUST NOT choose which day a commit is for, and
MUST NOT reach past a row to the commitment underneath it.

A commit SHALL change nothing at all — nothing kept, nothing shown, nothing told — in each of three
cases, and each is the tick's own answer to the same condition. A row the screen's day view does not
hold changes nothing: a row is a commitment's line on a date, so a row from a day this screen is no
longer on ticks nothing here and enters nothing here either. A row that offers no number entry
changes nothing, whether because its commitment's kind is not a number or because its date has not
arrived. And a screen that is not keeping a record changes nothing, whatever the reason its store
would not open — a screen that took a weight it could not keep would be exactly the lost record this
product exists to prevent.

A number the commitment refuses SHALL keep nothing and SHALL leave the day exactly as it was. Which
numbers a commitment refuses is the `record` capability's answer and this capability adds nothing to
it and takes nothing away: a row offers an entry only where its commitment's kind is a number, and a
row exists only on a date its commitment is due on, so the range the commitment declares is the only
refusal a number formed here can meet. What a person is told about it is the requirement on what a
day screen tells on a row.

The change SHALL be kept at the screen's record place before its day view says so, and the day view
SHALL then be formed again, on the day the screen is showing, from the record as it stands and from
the commitments its roster had not stopped keeping on that day, rather than the day view it held
being altered. A change that could not be kept SHALL be refused, SHALL be reported to the caller
rather than passed over, and SHALL leave the day view exactly as it was. The day view a person reads
MUST NOT be ahead of what is kept at the place, and a number that could not be kept MUST NOT be held
anywhere in its place. A number entered on a day that already holds one replaces it, which is the
`record` capability's answer and not a second rule here.

Taking the number back SHALL reach the place whether or not the day holds a number, and SHALL be
refused only where the place would not take it. The outcome asked for on a day holding none already
holds, so nothing about the record changes; what does happen is that the place was written, which is
the proof a person is owed that the place would take a change.

A number SHALL reach the record's place and nothing else. Entering one or taking one back MUST NOT
write to the roster's place, and MUST NOT change what the screen says about its roster: the two are
kept independently, and a number is not a change to what a person keeps.

#### Scenario: entering a number on a row makes the day screen say the commitment is kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "70.5" is committed on its
  one row
- **THEN** the day screen's day view says the commitment is kept on that date

#### Scenario: a number entered on a day screen is held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "70.5" is committed on its one
  row; and a second day screen of the same commitment is then opened at the same place as of the
  same day
- **THEN** the second day screen's day view says the commitment is kept on that date
- **AND** the entry its one row offers says the number 70.5

#### Scenario: the number entry a row offers says the number just entered on it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "70.5" is committed on its
  one row
- **THEN** the entry the row the day screen then holds offers says the number 70.5

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

### Requirement: A day screen reads what an entry is committed with as a number, as a take-back, or as neither

A day screen SHALL read what is committed in a number entry as exactly one of three things: a
number, a take-back, or a value that is not a number. It SHALL read it itself, and MUST NOT consult
the device's locale, its region or its keyboard to do so — nothing in this system reads a locale,
and reading one here would make the same typing mean two things on two phones.

Space around what is committed SHALL be disregarded before it is read. What holds nothing once it is
disregarded — the empty text among them — SHALL be a **take-back**. Nothing else SHALL be one: a
value that is not a number MUST NOT be read as a take-back, because an entry a person had half typed
would then erase the day they were entering it on.

What is committed SHALL be a **number** when, once space around it is disregarded, it holds in this
order and holds nothing else: an optional minus sign, then digits and at most one decimal separator,
with at least one digit among them. The separator SHALL be a full stop or a comma, and both SHALL be
read the same way, because an iPhone's decimal keypad prints whichever the region it is set to says
and a field that refuses the key on its own keyboard is broken. The number it holds SHALL be the
number those digits say, exactly, with no digit added and none dropped.

Everything else SHALL be a value that is not a number: two separators, a separator with no digit
beside it, a sign anywhere but the front, an exponent, letters or spaces among the digits, a digit
that is not one of the ten this package reads. Such a value SHALL keep nothing and SHALL take
nothing back, and the day SHALL be left exactly as it was.

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
  commitment named "Mood" of the number kind with a range of 1 to 10, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026; "70.5" is committed on the
  first row and "8" on the second; and then nothing at all is committed on the first row and two
  spaces on the second
- **THEN** the day screen's day view says neither commitment is kept on that date
- **AND** the entry each of its rows offers says no number

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

## MODIFIED Requirements

### Requirement: A row is a commitment's line on a date

A row SHALL be three things and no others: the commitment it is a line for, the date the day view
holding it is of, and what the history the day view was formed from says about that commitment on
that date — whether it is kept, and, where its commitment's kind is a number, the number that day
holds. Two rows SHALL be the same row when all three agree, and SHALL be different when any one of
them differs.

The third of the three is one thing rather than two. A tick commitment's day is kept or it is not
and there is nothing else to know about it; a number commitment's day holds a number or it does
not, and holding one is what makes it kept. Two rows of one number commitment on one date holding
different numbers are therefore different rows, for the reason two dates are: they offer different
number entries, and one cannot stand in for the other.

The date is part of what a row is rather than something the day view alone holds. Two rows for the
same commitment, each saying the same thing about it, on two different dates SHALL be different
rows: they offer different ticks, and one cannot stand in for the other. This adds to what a day
view is without changing it — a day view is already its rows and its date, so day views on two dates
were already two day views, and this makes them so a second way rather than a new way.

A row SHALL be reachable only through the day view that holds it, and SHALL give back four things:
its commitment's name, **the rhythm that commitment runs on in words**, whether that commitment is
kept, and **what it offers** — a tick or a number entry, according to its commitment's kind. It
MUST NOT give back the commitment itself, the schedule underneath it, the day it is kept from, the
date the row is for, or **the number that day holds**: what a reader is given is what a screen
draws and what a tap makes, and nothing else has been asked for.

The number is deliberately not among them, though a row now holds one. It is given out only inside
the number entry a row offers, so that a screen drawing a row has nothing to draw it with: a row
for a day holding 70.5 says what a ticked row says and no more. That is a shape rather than a rule
someone has to keep, which is why the number is part of what a row *is* and no part of what a row
*gives back*.

The words SHALL be the ones the `schedule` capability says for the schedule the row's commitment
carries, and this capability SHALL compose none of them — they are the same words a commitments
screen's entry says for the same commitment, so one rhythm reads the same way on both screens.
Giving them back is not this capability reaching past a commitment to the schedule underneath it:
the words are asked of the commitment, exactly as its name is.

Every row SHALL say its rhythm, on every day view, always — not only where two rows would otherwise
read alike. The day screen is the daily visit, and what rhythm a thing runs on is part of reading
the day rather than a disambiguation added when a name happens to repeat. A row SHALL say it
whether or not the commitment is kept on that date, and whatever the row offers or does not: a row
for a day that has not arrived offers nothing at all and says its rhythm like every other row, and
so does a row offering a number entry in a tick's place.

The rhythm is not a fourth thing a row is: the words are read off the commitment the row already
holds, so two rows agreeing on the three things above agree on the rhythm they say, and no row is
made different from another by this requirement.

#### Scenario: two rows for the same commitment and date saying the same thing are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on
  a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, each from a history
  holding a tick for that commitment on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are the same row

#### Scenario: two rows for the same commitment on different dates are different rows

- **WHEN** two day views are formed of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, each from a history that has taken no tick,
  one on Monday 31 August 2026 and one on Wednesday 2 September 2026
- **THEN** each holds one row named "Gym", saying the commitment is not kept
- **AND** the two rows are different rows

#### Scenario: two rows for the same commitment and date differing in whether it is kept are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on
  a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a
  history that has taken no tick and the second from a history holding a tick for that commitment
  on that date
- **THEN** the two rows are different rows

#### Scenario: a row says the rhythm its commitment runs on in words

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick,
  of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, one named
  "Finances" on a schedule on the 31st of the month, one named "Contact lenses" on a schedule of
  every 14 days starting on 31 August 2026, and one named "Reading" on a schedule of 3 times a
  week, all kept from 1 January 2026
- **THEN** the day view holds four rows, saying "Mon, Wed, Sat", "The 31st", "Every 14 days" and
  "3x a week" in that order

#### Scenario: a row says its rhythm whether or not its commitment is kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Gym" on
  a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, the first from a
  history that has taken no tick and the second from a history holding a tick for that commitment
  on that date
- **THEN** the first day view's row says it is not kept and says "Mon, Wed, Sat"
- **AND** the second day view's row says it is kept and says "Mon, Wed, Sat"

#### Scenario: a row for a day that has not arrived says its rhythm

- **WHEN** a day view is formed on Friday 4 September 2026, from a history that has taken no tick,
  of a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January 2026,
  and its row is asked for the tick it offers as of Thursday 3 September 2026
- **THEN** the row offers no tick
- **AND** the row says "Every day"

#### Scenario: two rows for commitments alike in name and not in rhythm say different rhythms

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no tick,
  of a commitment named "Vitamins" on a schedule listing Monday and Wednesday and a commitment
  named "Vitamins" on a schedule listing all seven weekdays, both kept from 1 January 2026
- **THEN** the day view holds two rows, both named "Vitamins"
- **AND** the first says "Mon, Wed" and the second says "Every day"

#### Scenario: two rows for the same number commitment and date holding different numbers are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Weight"
  of the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, the first from a history holding a number of 70.5 for that
  commitment on that date and the second from a history holding a number of 71 for it on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are different rows

#### Scenario: two rows for the same number commitment and date holding the same number are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Weight"
  of the number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, each from a history holding a number of 70.5 for that
  commitment on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are the same row

### Requirement: A day screen tells on the row that was tapped that a change could not be kept

Where a change a row offers cannot be kept, a day screen SHALL tell it **on that row** — the row
that was tapped or committed on — as well as refusing the change to the caller. The two are not
alternatives and neither replaces the other: the refusal reaching the caller is what a test
asserts on and what stops a shell drawn later from swallowing the failure a second time, and what
is told on the row is what a person reads. A day screen that only threw would be silent to the
person; one that only told the row would be silent to everything else.

Where instead it is the **value** a person gave that was refused, the telling on the row SHALL be
the whole of the report and nothing SHALL be thrown. Nothing was asked of the place, so there is
no failure for a caller to swallow, and the cause named below carries more than a throw could:
what a person must give instead. Which values those are is the requirement on entering a number
and the one on reading what was committed, and neither is restated here.

It SHALL name a cause **only where a person can act on that cause differently**, and SHALL tell
every other refusal the same way and name nothing at all. The test is what a person does next, and
it is the one this capability already applies to a record that could not be opened. A change the
place refused leaves a person exactly one thing to do whatever the reason was — try again, and if
it keeps failing, look at the device — so it names nothing: it MUST NOT tell which of making the
tick and taking it back was asked for, it MUST NOT tell which of entering a number and taking one
back was asked for, and it MUST NOT tell why the place would not take the change.

**Exactly two causes SHALL be named, and both are the value a person gave.** A value committed in
a number entry that is not a number SHALL be told as "Not a number". A number the commitment
refuses SHALL be told by naming the range that commitment declares — "Must be between 40 and 150"
for a range of 40 to 150 — because the one thing the person can do about it is give a number
inside those bounds, and "try again" is false there: 300 against 40 to 150 is refused for ever,
however many times it is committed. The words SHALL be this package's own English and no locale's,
and each bound SHALL be said exactly as the commitment declares it, as a range hint says it.

**No third cause SHALL be named.** A number a commitment with no range would refuse does not exist
— every number is a number to it — so the only refusal such a commitment can meet is a value that
is not a number, and every other refusal reachable here is the place's own, which names nothing. A
cause a person cannot act on differently MUST NOT be named however easily it could be: a message a
person can do nothing with is a message that teaches them to ignore the next one.

It SHALL tell it of **at most one row at a time**, and that row SHALL be the row tapped or
committed on last. A second refusal SHALL move what is told — and the cause it names, or the
absence of one — onto its own row, and SHALL leave nothing on the first: one refusal is one event,
two notices say the same thing twice, and the tap the person is waiting on an answer for is the
one they just made.

The row it is told of SHALL be named by what a row is — a commitment's line on a date — and this
capability SHALL give a row no identity beyond that. Where a day view holds two rows that are the
same row, both are told of. That is inherited rather than chosen here: two rows are the same row
only when their commitments are alike in name, in schedule, in the day they are kept from and in
kind, and the two rows agree about the day as well — whether it is kept, and the number it holds.
Giving a row an identity of its own would change what a row is throughout this capability.

Telling it MUST NOT change what a day screen says about **keeping a record**. A refused change is
one change refused; whether a screen is keeping a record is about whether the store opened at its
place, and it is formed again only when the app is shown. A screen that opened its record goes on
saying it is keeping one however many changes it refuses, so that the screen never guesses which
condition a failed write proves.

What the day view holds is unaffected, which is the requirement on making and taking back a tick
and the one on entering a number, and is not restated here.

#### Scenario: a refused tick is told on the row that was tapped

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** ticking is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept

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
  commitment named "Mood" of the number kind with a range of 1 to 10, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026, and "300" is committed on the
  first row
- **THEN** the day screen tells, on that row, that the number must be between 40 and 150
- **AND** it tells nothing on the second row
- **AND** committing "0.5" on the second row of the screen it then holds tells, on that row, that
  the number must be between 1 and 10

#### Scenario: a value that is not a number is told on the row, saying so

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "1.2.3" is committed on
  its one row
- **THEN** the day screen tells, on that row, that it is not a number
- **AND** a day screen alike in every way but of a commitment with no range tells the same thing
  on its own row for the same value

#### Scenario: a number refused by the place is told on the row and names no cause

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Weight" of the
  number kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday,
  kept from 1 January 2026, and "70.5" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause
- **AND** committing nothing at all on that row tells the same thing on it and names no cause
  either

#### Scenario: a second refused commit is told on the row committed on last and no longer on the first

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 and a
  commitment named "Mood" of the number kind with a range of 1 to 10, in that order and both on a
  schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026; "300" is
  committed on the first row; and "1.2.3" is then committed on the second row of the screen it
  then holds
- **THEN** the day screen tells, on the second row, that it is not a number
- **AND** it tells nothing on the first row

### Requirement: What a day screen tells on a row lasts until the app is shown again, a change is kept, or the day it is showing changes

A day screen SHALL go on telling it, on the same row, until one of exactly three things happens, and
SHALL then tell nothing on any row. Nothing else SHALL end it. Time passing in particular SHALL NOT,
because this capability reads no clock.

**The app being shown again** ends it. That is inherited rather than added: nothing of a day screen
but the commitments it was handed, the two places it keeps its record and its roster at and the day
it is showing survives being shown, and this is not one of them. It SHALL end whether or not the
record can then be read, because being shown forms what a screen says again from what is at the
place rather than carrying anything over — a screen that is then not keeping a record says that
instead, and says more than a row ever could.

**A change reaching the record's place** ends it, on whichever row that change was made. A tick
that lands, a tick taken back, a number entered and a number taken back all count: what is being
told is that the place would not take your change, and any one of them landing is proof to the
contrary. One rule rather than four, because a person cannot act on the difference. A change that
does not reach the place SHALL NOT end it — a second refusal moves it rather than ending it, and a
tap that changes nothing at all changes this nothing either.

A value the commitment refuses and a value that is not a number reach no place, so neither ends
it. Each is a refusal of its own and moves what is told, and the cause it names, onto its own row.
Someone told that the place would not take their tick and then typing 300 into a weight has
learned nothing about the place, so nothing about the place stops being true — it is replaced by
what they were told instead, which is the one-at-a-time rule and not a fourth end.

**The day the screen is showing changing** ends it. What is told is about a tap on a row of the day
you were on, and a day you have moved away from has no row to say it under; carrying it forward
would put a message under a commitment that refused nothing. The rule SHALL be the day being shown
**changing** and never the gesture that was made. A move with nowhere to go — the day before the
first supported date, the day after the last — and going back to today from a screen already showing
today both leave a day screen exactly as it was, which is already this capability's answer, and what
it is telling is part of how it was.

**Closing a number entry without committing it is not a fourth end, and cannot become one.**
Someone who opens an entry and leaves it keeps nothing and commits nothing, so this capability is
never asked anything at all and what it is telling still describes the last thing that happened.
Each of the three ends is something that *changed* — the app was shown, a change landed, the day
moved — and nothing changed here. It is written down because a field with a Cancel beside it is
the most plausible fourth end anyone will propose.

#### Scenario: what a day screen tells on a row ends when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked; and the
  app is then shown again as of that same day
- **THEN** the day screen tells nothing on any row
- **AND** its one row still says the commitment is not kept on that date

#### Scenario: what a day screen tells on a row ends when the app is shown again where the record then cannot be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked; that
  place is then made to hold a run of bytes that is not what a record is written as; and the app
  is shown again as of that same day
- **THEN** the day screen says it is not keeping a record
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when the same change is made again and is kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from
  but not written to and where nothing has been kept, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; its one row is ticked and
  refused; the place is then made writable; and the row the screen holds is ticked again
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a change is kept on another row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from
  but not written to and where nothing has been kept, of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Journaling" on a schedule listing
  all seven weekdays, in that order and both kept from 1 January 2026; its first row is ticked and
  refused; the place is then made writable; and its second row is ticked
- **THEN** the day screen's day view says "Journaling" is kept on that date and "Gym" is not
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a take-back is kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both
  kept from 1 January 2026; its second row is ticked and kept; the place is then made unwritable;
  its first row is ticked and refused; the place is made writable again; and the row for
  "Journaling" is ticked once more
- **THEN** the day screen's day view says "Journaling" is not kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when the day screen is moved to the day before

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; its one row is ticked; and it is
  then moved to the day before
- **THEN** the day screen tells nothing on any row
- **AND** it says "Sunday 30 August 2026"

#### Scenario: what a day screen tells on a row ends when the day screen is moved to the day after

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; its one row is ticked; and it is
  then moved to the day after
- **THEN** the day screen tells nothing on any row
- **AND** it says "Tuesday 1 September 2026"

#### Scenario: what a day screen tells on a row ends when the day screen is sent back to today from another day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; it is moved to the day before;
  its one row is ticked; and it is then sent back to today
- **THEN** the day screen tells nothing on any row
- **AND** it says "Today · Monday 31 August 2026"

#### Scenario: what a day screen tells on a row stands when a move has nowhere to go

- **WHEN** a day screen is opened as of Saturday 1 January 1583 and another as of Friday 31
  December 9999, each at its own place where nothing can be written — a path beneath an existing
  ordinary file — of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 1583; each screen's one row is ticked; and the first is then moved to the
  day before and the second to the day after
- **THEN** each day screen still tells, on the row that was ticked on it, that the change could
  not be kept
- **AND** the first says "Today · Saturday 1 January 1583" and the second says "Today · Friday 31
  December 9999"

#### Scenario: what a day screen tells on a row stands when a day screen showing today is sent back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; its one row is ticked; and it is
  then sent back to today without having been moved
- **THEN** the day screen still tells, on that row, that the change could not be kept
- **AND** it says "Today · Monday 31 August 2026"

#### Scenario: what a day screen tells on a row ends when a number is entered and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from
  but not written to and where nothing has been kept, of a commitment named "Weight" of the number
  kind with a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; "70.5" is committed on its one row and refused; the place is then made writable;
  and "70.5" is committed again on the row the screen then holds
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a number is taken back and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150 on a schedule
  listing Monday, Wednesday and Saturday and a commitment named "Journaling" of the tick kind on a
  schedule listing all seven weekdays, in that order and both kept from 1 January 2026; "70.5" is
  committed on the first row and kept; the place is then made unwritable; the second row is ticked
  and refused; the place is made writable again; and nothing at all is committed on the row for
  "Weight"
- **THEN** the day screen's day view says "Weight" is not kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells about a refused value ends when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "300" is committed on its one
  row; and the app is then shown again as of that same day
- **THEN** the day screen tells nothing on any row
- **AND** its one row still says the commitment is not kept on that date

#### Scenario: what a day screen tells about a refused value ends when the day screen is moved to the day before

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; "1.2.3" is committed on its one row; and
  it is then moved to the day before
- **THEN** the day screen tells nothing on any row
- **AND** it says "Sunday 30 August 2026"

### Requirement: A day screen tells nothing on a row where there was no tick to refuse

A tap or a commit that never reaches the record's place is not a refused change. A day screen
SHALL tell nothing on the row for one, and SHALL NOT end what it is already telling on another
row: there is no refusal to report and nothing has been proved about the place either way.

**The two causes the requirement above names are the exception, and they are the whole of it.** A
value that is not a number and a number the commitment refuses reach no place either, and both are
told, because what a person is told there is not that the place refused them — it is what to give
instead. Where the value was never read at all, this requirement governs, and the four cases below
are all of them.

A tap or a commit on a day screen that is **not keeping a record** SHALL be the first, whatever
the reason the store would not open, and whatever was committed — a value that commitment would
refuse included, because such a screen never gets as far as reading what was committed and would
be naming a cause about a value it never read. It already says it is keeping no record, and that
says more than a per-row message would and is what a person can act on; the two would share the
same end — being shown again — and would clear together, so the row would only ever repeat it.

A tap or a commit on a row **for a day that has not arrived** SHALL be the second. Such a row
offers neither a tick nor a number entry, asked as of the today the screen was handed, so there is
no change to refuse and nothing was asked of the place. What is told on a row means a change did
not reach the place, and here there was no change. The honest answer to a day that has not arrived
is a row that does not invite the tap at all, and that is not this capability's answer here.

A tap or a commit on a **row the day screen's day view does not hold** SHALL be the third. Such a
row already changes nothing at all, and telling something about it would be a change.

A commit on a **row that offers no number entry for any other reason** SHALL be the fourth: a tick
row, a note row and a total row were never asked for a number and have nothing to refuse. A number
committed on one keeps nothing and says nothing, exactly as a tick made on a number row does — a
row answers for the kind its commitment declares and stays silent about every other.

#### Scenario: a tap on a day screen that is not keeping a record is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** the day screen tells nothing on any row
- **AND** it says it is not keeping a record

#### Scenario: a tap on a day screen holding a record from a later version is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record written
  in a form one later than the form this app writes, holding no ticks, of a commitment named "Gym"
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row
  is ticked
- **THEN** the day screen tells nothing on any row
- **AND** it says the record was written by a later version of DayByDay

#### Scenario: a tap on a row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; it is moved to the day after; and
  its one row is ticked
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026

#### Scenario: a tap on a row a day screen's day view does not hold is told nothing on the row

- **WHEN** two day screens of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026, are opened at one place where nothing can be written — a
  path beneath an existing ordinary file — the first as of Monday 31 August 2026 and the second as
  of Wednesday 2 September 2026, and the second screen's row is ticked on the first screen
- **THEN** the first day screen tells nothing on any row

#### Scenario: a tap on a row a day screen's day view does not hold does not end what is already told

- **WHEN** two day screens of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026, are opened at one place where nothing can be written — a
  path beneath an existing ordinary file — the first as of Monday 31 August 2026 and the second as
  of Wednesday 2 September 2026; the first screen's own row is ticked; and the second screen's row
  is then ticked on the first screen
- **THEN** the first day screen still tells, on its own row, that the change could not be kept

#### Scenario: a commit on a day screen that is not keeping a record is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Weight" of the number kind with
  a range of 40 to 150, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, and "70.5" is committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** it says it is not keeping a record
- **AND** committing "300" and then "1.2.3" on that row tells nothing on any row either

#### Scenario: a commit on a row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day after; and "300" is
  committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026

#### Scenario: a commit on a row that offers no number entry is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and "1.2.3" is committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on that date

#### Scenario: a commit on a row a day screen's day view does not hold is told nothing and does not end what is already told

- **WHEN** two day screens of a commitment named "Weight" of the number kind with a range of 40 to
  150, on a schedule listing all seven weekdays, kept from 1 January 2026, are opened at one place
  where nothing has been kept, the first as of Monday 31 August 2026 and the second as of
  Wednesday 2 September 2026; "300" is committed on the first screen's own row; and "1.2.3" is
  then committed on the first screen, on the second screen's row
- **THEN** the first day screen still tells, on its own row, that the number must be between 40
  and 150
