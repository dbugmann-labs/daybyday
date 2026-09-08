## ADDED Requirements

### Requirement: A row offers the total entry its commitment takes, and offers none for a day that has not arrived

A row SHALL offer, when asked as of a calendar date, either exactly one total entry or nothing at
all. The entry it offers SHALL be the entry for that row's commitment on the date the day view
holding it is of, and nothing else: the row is a commitment on a date and an addition is of a
commitment on a date, so there is nothing left for a caller to supply and nothing for the row to
choose.

The row SHALL offer nothing when its commitment's kind is not a total, and SHALL offer nothing when
the day view's date is later than the day it is asked as of. Where neither holds it SHALL offer the
entry. A row asked as of its own date SHALL offer it — a day that has arrived can have been kept,
and only one that has not is refused — and so SHALL a row whose date is earlier, however much
earlier: the past is writable back to the day the commitment is kept from, and a commitment that is
not due there has no row to ask.

The second refusal is the tick's own, the number entry's own and the note entry's own, word for word
and for the same reason: a record is what a person did about a day, and a day that has not happened
has nothing yet to say about it. Its price is the same too — such a row invites a tap it will not
answer — and that price is deliberately paid a fourth and last time here rather than fixed, so that
one answer covers every kind of row and whoever fixes it fixes it once.

A row SHALL offer at most one of a tick, a number entry, a note entry and a total entry, and never
two of them. A commitment's kind says what its days take and it says one thing: a row whose
commitment's kind is a tick offers the tick alone, one whose kind is a number offers the number entry
alone, one whose kind is a note offers the note entry alone, and one whose kind is a total offers the
total entry alone. **There is no longer a kind whose row offers nothing**, which is what this
requirement completes: which of the four it offers is the only thing a row says about its kind, and a
row of any kind says its name, the rhythm it runs on and whether the day was kept in exactly the same
way.

Whether a row offers an entry SHALL NOT depend on what the history says. A row already saying its
commitment is kept offers one exactly as a row saying it is not, because a day at its target can be
added to again and a day past it is not closed. What the entry it offers *carries* does depend on the
history, and that is the next requirement's.

The day the row is asked as of SHALL be given to it, and this capability MUST NOT read it from a
clock, MUST NOT consult the present moment, the device's time zone or the locale, and MUST NOT keep
it. A row therefore answers the same way for ever when asked as of the same day.

#### Scenario: a row offers the total entry for its commitment on the date the day view is of

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of Monday
  31 August 2026
- **THEN** the day view holds one row named "Protein"
- **AND** that row offers a total entry

#### Scenario: a row for a commitment whose kind is not a total offers no total entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with a range
  of 40 to 150 and one named "Journal" of the note kind, all three on a schedule listing Monday,
  Wednesday and Saturday and all kept from 1 January 2026, and each of its rows is asked as of Monday
  31 August 2026
- **THEN** the day view holds three rows, named "Gym", "Weight" and "Journal"
- **AND** none of them offers a total entry
- **AND** a row for a commitment alike in every way but of the total kind with a target of 120, asked
  as of that same day, offers one

#### Scenario: a row offers a tick, a number entry, a note entry or a total entry and never two of them

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with a range
  of 40 to 150, one named "Journal" of the note kind and one named "Protein" of the total kind with
  a target of 120, all on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, and all four of its rows are asked as of Monday 31 August 2026
- **THEN** the row named "Gym" offers a tick and none of the three entries
- **AND** the row named "Weight" offers a number entry and nothing else of the four
- **AND** the row named "Journal" offers a note entry and nothing else of the four
- **AND** the row named "Protein" offers a total entry and nothing else of the four

#### Scenario: a row for a date later than the day it is asked as of offers no total entry

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  record, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of
  Monday 31 August 2026
- **THEN** the day view holds one row named "Protein"
- **AND** that row offers no total entry
- **AND** it offers no tick, no number entry and no note entry either

#### Scenario: a row for a date later than the day it is asked as of offers no total entry even where the day holds additions

- **WHEN** a day view is formed on Wednesday 2 September 2026, of a commitment named "Protein" of
  the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, from a history holding additions of 30 and 90 for that commitment on that
  date, and its one row is asked as of Monday 31 August 2026
- **THEN** that row says the commitment is kept
- **AND** it offers no total entry

#### Scenario: a row for a date earlier than the day it is asked as of offers the total entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is asked as of Saturday
  5 September 2026
- **THEN** the row offers a total entry

#### Scenario: a row offers the total entry whether or not the day is already kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history holding an addition of 30 for that commitment on that
  date and the second from a history holding one of 120, and each one's row is asked as of that same
  day
- **THEN** the first row says the commitment is not kept and the second says it is
- **AND** both offer a total entry

### Requirement: A total entry says the day's sum and the commitment's target, and says nothing else

A total entry SHALL say exactly one thing: **the day's sum and the commitment's target, in words** —
"150 of 120" for a day that has added 150 against a target of 120. It is one phrase saying two
numbers, and it says them because a person adding to a day has to know how far the day has got and
how far it has to go; neither number answers that on its own.

The sum SHALL be the one the `record` capability answers for that commitment on that date, asked of
the history the day view was formed from, and MUST NOT be recomputed here — exactly as whether the
day is kept is, and exactly as the number and the note are. The target SHALL be the one the
commitment declares, said as it was declared with no digit added and none dropped, and the sum SHALL
be said the same way. A day that holds no addition SHALL say a sum of **zero** rather than saying
nothing, because zero is what that day has added and there is no such thing as a total entry with no
sum to say.

**It SHALL say the true sum, whether or not the sum has passed the target.** A day that has added
150 against a target of 120 says "150 of 120" and never "120 of 120": showing a person less than
they recorded would be this app editing their own record down to look tidy, which is the false record
this product exists to remove. The words SHALL be this package's own English and no locale's, as a
day title and a rhythm in words are.

**A total entry SHALL say no hint, and there is none to say.** A number entry says the range its
commitment declares, because a range is a bound one commitment declares and another does not, and a
person is owed it before it refuses them. Every total there will ever be takes the same amounts —
anything above zero — so a hint on a total entry would be the same words on every total row in the
app, which is noise rather than teaching. What a total entry refuses a person for is told when it
refuses them, and that is another requirement's.

**Its field is not prefilled, and this capability SHALL NOT say a value for one to be prefilled
from.** A number entry says the number the day already holds, because committing it again is a
replacement and a person editing 70.5 to 71 must see the 70.5. A commit in a total entry is an
**addition**, so a field opening on the day's 90 and committed unread would make the day 180 — the
sum a total entry says is for reading and never for editing, and it is the first thing in this system
of which that is true.

A row SHALL NOT say the sum itself. What a row gives back is its name, the rhythm its commitment runs
on in words, whether that commitment is kept, and what it offers; the sum is reachable only through
the entry, exactly as the number and the note are. So a row for a day that has added 30 and a row for
a day that has added 90 say exactly what a ticked row says about themselves — that the day is not
kept — and how far the day has got is read in the one place a person can act on it.

#### Scenario: a total entry says the day's sum and the commitment's target

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding additions of 30 and 45.5 for that commitment on that date,
  and its one row is asked as of that same day
- **THEN** the entry that row offers says "75.5 of 120"
- **AND** the entry of a row for a commitment alike in every way but with a target of 0.5, asked as
  of that same day, says "75.5 of 0.5"

#### Scenario: a total entry of a day holding no addition says a sum of zero

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history that has taken no record and the second from a
  history an addition of 30 for that commitment on that date was added to and then taken back from,
  and each one's row is asked as of that same day
- **THEN** the entry the first row offers says "0 of 120"
- **AND** the entry the second row offers says "0 of 120"

#### Scenario: a total entry says the true sum once it has passed the target

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding additions of 120 and 30 for that commitment on that date,
  and its one row is asked as of that same day
- **THEN** the entry that row offers says "150 of 120"
- **AND** that row says the commitment is kept

#### Scenario: a row for a total commitment says its name, its rhythm and whether the day is kept, and never its sum

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding an addition of 30 for that commitment on that date
- **THEN** the day view holds one row named "Protein"
- **AND** that row says "Mon, Wed, Sat"
- **AND** it says the commitment is not kept
- **AND** a row of a day view formed the same way but from a history holding an addition of 90
  instead says all three of those things identically

### Requirement: A row offers taking back its day's last addition, and offers none where the day holds none

A row SHALL offer, when asked as of a calendar date, **taking its day's last addition back**, exactly
where two things hold: it offers a total entry as of that day, and the day it is for holds at least
one addition. Where either fails it SHALL offer no such thing. It is the only affordance in this
capability that appears and disappears with what the history says, and it is the **second** thing a
row offers, beside an entry, where every other kind of row offers exactly one thing.

It is a second thing because it cannot be the same gesture as the entry. A number entry and a note
entry are taken back by being committed blank, which works because a blank commit means *the day
holds nothing now* and the day held one record. A total's take-back removes the **last addition** and
leaves the rest, so the same gesture would silently delete the most recent thing a person added and
they would have to remember what it was to know what they had lost. Its own act is what makes that
impossible rather than merely unlikely.

Whether the day holds an addition SHALL be read off the day's **sum being above zero**, and this
capability SHALL NOT ask for the additions themselves. Every addition is above zero, so a day with
one has a sum above zero and a day with none has a sum of zero — the two questions have the same
answer, and asking the one that is already answered keeps the list of additions out of this
capability entirely.

A row that offers no take-back MUST NOT be hidden, MUST NOT be drawn as kept, and MUST NOT be given
some other act in its place. It offers a total entry like every other total row, says its name, its
rhythm and whether the day is kept like every other row, and the only difference is that there is
nothing there to take back.

#### Scenario: a row whose day holds an addition offers taking the last one back

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding an addition of 30 for that commitment on that date, and its
  one row is asked as of that same day
- **THEN** that row offers taking its day's last addition back
- **AND** a row of a day view formed the same way but from a history holding additions of 120 and 30
  offers it too, though that day is kept and past its target

#### Scenario: a row whose day holds no addition offers no take-back

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history that has taken no record and the second from a
  history an addition of 30 for that commitment on that date was added to and then taken back from,
  and each one's row is asked as of that same day
- **THEN** neither row offers taking its day's last addition back
- **AND** both offer a total entry

#### Scenario: a row for a commitment whose kind is not a total offers no take-back

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Gym" of the tick
  kind, one named "Weight" of the number kind with a range of 40 to 150 and one named "Journal" of
  the note kind, all three on a schedule listing Monday, Wednesday and Saturday and all kept from
  1 January 2026, from a history holding a tick for "Gym", a number of 70.5 for "Weight" and a note
  holding "Ran 8k." for "Journal", all on that date, and each of its rows is asked as of that same
  day
- **THEN** none of the three rows offers taking its day's last addition back

#### Scenario: a row for a date later than the day it is asked as of offers no take-back

- **WHEN** a day view is formed on Wednesday 2 September 2026, of a commitment named "Protein" of
  the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, from a history holding an addition of 30 for that commitment on that date,
  and its one row is asked as of Monday 31 August 2026
- **THEN** that row offers no take-back
- **AND** the same row asked as of Wednesday 2 September 2026 offers one

#### Scenario: a row goes on offering the take-back while the day still holds an addition

- **WHEN** a day view is formed on Monday 31 August 2026, of a commitment named "Protein" of the
  total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, from a history holding additions of 30 and 90 for that commitment on that date;
  that day's last addition is taken back from that history; and a day view is formed again from the
  history as it now stands
- **THEN** the row of the day view formed again offers taking its day's last addition back
- **AND** its entry says "30 of 120"
- **AND** a day view formed again after that day's last addition is taken back once more offers no
  take-back, and its entry says "0 of 120"

### Requirement: A day screen adds what is committed in a row's total entry, and keeps it before the day view says so

A day screen SHALL add, on one of its rows, the amount a person commits in that row's total entry,
to the additions that row's day already holds. A commit in a total entry is **always an addition**:
it is never a replacement of what the day holds, and it is never a take-back, however the day stood
before it. Committing 30 twice leaves a day of 60, where committing 70.5 twice in a number entry
leaves a day of 70.5, and that difference is the whole of what the total kind is.

**What is committed SHALL NOT be read as a take-back, whatever it says.** A commit that says nothing
at all — an empty field, or one holding nothing but blank space — SHALL keep nothing, take nothing
back and change nothing at all. That is where a total entry parts from a number entry and a note
entry, whose blank commit is exactly the take-back: a total's take-back removes only the *last*
addition, so reading a blank commit as one would silently delete the most recent thing a person added
and leave them to remember what it was. Taking an addition back is its own act on the row, and it is
its own requirement.

**Which entry a commit lands in SHALL be decided by the row it was made on, and by nothing about the
text itself.** A commit on a row offering a number entry is read as a number, a commit on a row
offering a note entry is read as a note, a commit on a row offering a total entry is read as an
amount to add, and a commit on a row offering none of the three changes nothing at all — so "30"
committed on a note row is the note "30" and on a total row is thirty added to the day, and a caller
cannot commit into an entry the row does not offer however the text is shaped.

The entry SHALL be the one the row itself offers, asked as of the today the screen was handed and
never as of the day it is showing. A day screen moved onto a day that has not arrived therefore adds
nothing on it: the row it holds is for a date later than that today, and such a row offers no entry.
The screen MUST NOT form an addition of its own, MUST NOT choose which day a commit is for, and MUST
NOT reach past a row to the commitment underneath it.

A commit SHALL change nothing at all — nothing kept, nothing shown, nothing told — in each of three
cases, and each is the tick's own answer, the number's and the note's to the same condition. A row
the screen's day view does not hold changes nothing. A row that offers no total entry changes
nothing, whether because its commitment's kind is not a total or because its date has not arrived.
And a screen that is not keeping a record changes nothing, whatever the reason its store would not
open.

The change SHALL be kept at the screen's record place before its day view says so, and the day view
SHALL then be formed again, on the day the screen is showing, from the record as it stands and from
the commitments its roster had not stopped keeping on that day, rather than the day view it held
being altered. A change that could not be kept SHALL be refused, SHALL be reported to the caller
rather than passed over, and SHALL leave the day view exactly as it was. The day view a person reads
MUST NOT be ahead of what is kept at the place, and an addition that could not be kept MUST NOT be
held anywhere in its place.

An addition SHALL reach the record's place and nothing else. Making one MUST NOT write to the
roster's place, and MUST NOT change what the screen says about its roster: the two are kept
independently, and an addition is not a change to what a person keeps.

#### Scenario: adding on a total row makes the day screen say what the day has added

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "30" is committed on its one
  row
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** the day view says the commitment is not kept on that date

#### Scenario: a day's additions accumulate rather than replace one another

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "30" is committed on its one
  row and then "30" again on the row it then holds
- **THEN** the entry the row the day screen then holds offers says "60 of 120"
- **AND** committing "45.5" on the row it then holds leaves it saying "105.5 of 120"

#### Scenario: reaching the target makes the day screen say the commitment is kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "30" and then "90" are
  committed on the row it holds each time
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** the entry its row offers says "120 of 120"

#### Scenario: an addition past the target keeps the day and says the true sum

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "120" and then "30" are
  committed on the row it holds each time
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** the entry its row offers says "150 of 120"

#### Scenario: an addition entered on a day screen is held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" and then "90" are committed
  on the row it holds each time; and a second day screen of the same commitment is then opened at the
  same place as of the same day
- **THEN** the second day screen's day view says the commitment is kept on that date
- **AND** the entry its one row offers says "120 of 120"

#### Scenario: an addition that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Protein" of the total
  kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and "30" is committed on its one row
- **THEN** committing is refused with an error
- **AND** the entry the row the day screen then holds offers still says "0 of 120"
- **AND** a day screen opened afterwards at the same place says the same

#### Scenario: committing nothing at all in a total entry keeps nothing and takes nothing back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" and then "90" are committed
  on the row it holds each time; and nothing at all is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers still says "120 of 120"
- **AND** the day view still says the commitment is kept on that date
- **AND** committing two spaces, and then a text of three line breaks, leaves it saying the same
- **AND** a day screen opened afterwards at the same place as of the same day says the same

#### Scenario: adding on a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Protein" of the total kind with a target of 120,
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, are opened at one
  place where nothing has been kept, the first as of Monday 31 August 2026 and the second as of
  Wednesday 2 September 2026, and "30" is committed on the first screen in the second screen's row's
  total entry
- **THEN** the entry the first day screen's row offers still says "0 of 120"
- **AND** a day screen opened afterwards at that place as of Wednesday 2 September 2026 says "0 of
  120" too

#### Scenario: committing on a row that offers no total entry changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind and a commitment named "Protein" of the total
  kind with a target of 120, both on a schedule listing all seven weekdays and both kept from
  1 January 2026; "30" is committed on the row named "Gym"; the screen is then moved to the day
  after; and "30" is committed on the row it then holds named "Protein"
- **THEN** the day screen's day view says neither commitment is kept on Tuesday 1 September 2026
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says neither is
  kept on that date, and says "0 of 120" for "Protein"

#### Scenario: a commit is read as the entry the row it was made on offers, for all four kinds

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with a
  range of 40 to 150, one named "Journal" of the note kind and one named "Protein" of the total kind
  with a target of 120, in that order and all on a schedule listing Monday, Wednesday and Saturday
  and all kept from 1 January 2026, and "120" is committed in turn on each of the four rows the
  screen holds at the time
- **THEN** the entry the second row of the screen it then holds offers says the number 120
- **AND** the entry the third row offers says the note "120"
- **AND** the entry the fourth row offers says "120 of 120"
- **AND** the day view says "Gym" is not kept and the other three are kept on that date

#### Scenario: adding on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  "30" is committed on its one row
- **THEN** the entry its row offers still says "0 of 120"
- **AND** it still says it is not keeping a record
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: adding on one row leaves the other rows of the day as they were

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, a commitment named "Protein" of the total kind
  with a target of 120 and a commitment named "Water" of the total kind with a target of 2, in that
  order, all three on a schedule listing all seven weekdays and all kept from 1 January 2026, and
  "120" is committed on the second row
- **THEN** the day screen's day view holds three rows in that same order
- **AND** only the second says its commitment is kept
- **AND** the entry the third row offers says "0 of 2"

#### Scenario: adding on a day a day screen has moved back to keeps it on that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day before; and "120" is
  committed on its one row
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** a day screen opened afterwards at that place as of Sunday 30 August 2026 says the
  commitment is kept on that date
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says the
  commitment is not kept on that date, and says "0 of 120"

#### Scenario: adding writes nothing to the roster's place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster place
  where nothing has been kept, of a commitment named "Protein" of the total kind with a target of
  120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; the roster
  place is read once the screen has been opened; and "30" is then committed on its one row, and
  nothing at all committed on the row it then holds
- **THEN** the content at the roster place is byte-for-byte what it was after the screen was opened
- **AND** the day screen says it is keeping its roster

### Requirement: A day screen reads what is committed in a total entry as an amount to add, as nothing at all, or as a value it refuses

A day screen SHALL read what is committed in a total entry as exactly one of three things: an
**amount to add**, **nothing at all**, or a **value it refuses**. There is no fourth answer, and
none of the three is a take-back.

**What is committed SHALL be nothing at all when it says nothing**: the empty text, and any text made
only of blank space. Such a commit changes nothing and refuses nothing, and nothing SHALL be told of
it — a person who opened a field and committed it empty asked for no change and got none. What the
screen was **already** telling on a row SHALL stand, because nothing has happened to end it; that is
the requirement on how long what is told lasts, and it is not restated here.

**Blank space SHALL mean whatever the `record` capability means by it**, and this capability SHALL
NOT decide it a third time. It is spaces, tabs and line breaks alike, exactly as it is where a
number entry and a note entry are read and where a commitment name is judged, and a character that
occupies no width is not blank space. Blank space at the start and the end of what is committed SHALL
be disregarded before it is read further.

**What is left SHALL be read as a decimal number in exactly the way a number entry's commit is
read**, and this capability SHALL NOT read it a second way: the same digits, the same two decimal
separators read alike, the same refusal of an exponent or a stray sign, and the same
**thirty-eight significant digits** beyond which text says a number this system cannot keep exactly.
That reading is its own requirement and is not restated here. Text it does not read as a number SHALL
be **refused**, SHALL keep nothing, SHALL take nothing back, and SHALL be told on the row as
**"Not a number"** — the cause a number entry already names for the same text, because the person's
next act is the same one.

**An amount that is not above zero SHALL be refused**, SHALL keep nothing, and SHALL be told on the
row as **"Must be more than 0"**. Zero and every amount below it are refused where the record is
formed, which is `record`'s own rule and not a second one here; what this capability adds is the
telling, and it names this cause because a person can act on it differently — they can give a
different amount, and "try again" is false for ever.

**An amount that would take the day's additions past what this system can keep exactly SHALL be
refused**, SHALL keep nothing, SHALL leave the day's additions standing, and SHALL be told on the row
as **"Too large to add"**. The bound is the day's sum as arithmetic gives it, counted in
**significant digits** from the first digit that is not a zero to the last that is not a zero: up to
thirty-eight SHALL be added, and text that would take the sum past that SHALL NOT. It is the same
bound, for the same reason, that a number entry already applies to one typed number, moved onto the
one record this system accumulates — a total whose sum has quietly stopped equalling what was added
is a false record, and it is worse than a refusal because nothing tells a person it happened. It
SHALL be judged against the sum arithmetic gives and never against any shortened form of it, because
a sum that has been shortened has already lost the digits that would prove it wrong. The cause names
only what a person can act on: the headroom it could otherwise name is a thirty-eight-digit number,
which is not something anybody types against.

**No further cause SHALL be named, and a total entry SHALL teach nothing before it refuses.** There
is no hint, no ceiling drawn on the field and no rule a total commitment declares of its own; a
person meets these three refusals by making one, which is the price of a rule that is the same for
every total there will ever be.

#### Scenario: an amount committed with space around it is added

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and a text of two spaces, then
  "30", then a line break, is committed on its one row
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** the day screen tells nothing on any row

#### Scenario: an amount typed with a comma is added as the same amount as one typed with a full stop

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "45,5" is committed on its
  one row
- **THEN** the entry the row the day screen then holds offers says "45.5 of 120"
- **AND** committing "0000030.50" on the row it then holds leaves it saying "76 of 120"

#### Scenario: an amount of zero or below is refused and told on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" is committed on its one
  row; and "0" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers still says "30 of 120"
- **AND** the day screen tells, on that row, that it must be more than 0
- **AND** committing "-30" and then "-0.000001" on the row leaves it saying "30 of 120" and telling
  the same thing each time
- **AND** a day screen opened afterwards at the same place as of the same day says "30 of 120"

#### Scenario: a value that is not a number committed in a total entry is refused and told on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" is committed on its one
  row; and each of "1.2.3", ".", "-", "12abc", "1e3" and a text of one zero-width space is then
  committed in turn on the row it then holds
- **THEN** the entry the row the day screen then holds offers says "30 of 120" after every one of
  them
- **AND** the day screen tells, on that row, that it is not a number
- **AND** a day screen opened afterwards at the same place as of the same day says "30 of 120"

#### Scenario: an amount that would take the day's sum past what can be kept exactly is refused and told on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; a whole number of thirty-eight
  nines is committed on its one row; and "0.5" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says the day's sum as that whole number
  of thirty-eight nines, of 120
- **AND** the day screen tells, on that row, that it is too large to add
- **AND** a day screen opened afterwards at the same place as of the same day says the same sum

#### Scenario: an amount that takes the day's sum to a number that can be kept exactly is added

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; a whole number of thirty-eight
  nines is committed on its one row; and "1" is then committed on the row it then holds
- **THEN** the entry the row the day screen then holds offers says a sum of 1 followed by
  thirty-eight zeros, of 120
- **AND** the day screen tells nothing on any row
- **AND** committing "0.5" on the row it then holds tells, on that row, that it is too large to add,
  and leaves the sum as it was

#### Scenario: a commit saying nothing in a total entry changes nothing and tells nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" is committed on its one
  row; "0" is then committed on the row it then holds; and nothing at all is then committed on the
  row it then holds
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** the day screen still tells, on that row, that it must be more than 0
- **AND** committing a text of one tab followed by one line break leaves it saying and telling the
  same

### Requirement: A day screen takes back the last addition a row offers, and keeps it before the day view says so

A day screen SHALL take back, on one of its rows, the last addition that row's day holds, and SHALL
keep the change before its day view says so. It is its **own act**, taking a row and nothing else:
there is no amount to give it, because the day's order names the addition that goes, and there is no
text to commit, because a commit in a total entry is always an addition.

It SHALL take back exactly one addition each time it is asked, and SHALL leave every earlier addition
of that day standing, in the order they were made. Taking back three additions is three acts, and
this capability SHALL offer no act that clears a day.

It SHALL change nothing at all — nothing kept, nothing shown, nothing told — in each of three cases,
which are the same three every other change on this screen has. A row the screen's day view does not
hold changes nothing. A row that **offers no take-back** changes nothing, whether because its
commitment's kind is not a total, because its date has not arrived, or because its day holds no
addition to take back. And a screen that is not keeping a record changes nothing, whatever the reason
its store would not open.

The change SHALL be kept at the screen's record place before its day view says so, and the day view
SHALL then be formed again, on the day the screen is showing, from the record as it stands and from
the commitments its roster had not stopped keeping on that day. A change that could not be kept SHALL
be refused, SHALL be reported to the caller rather than passed over, SHALL be told on the row naming
no cause, and SHALL leave the day view exactly as it was: a person whose take-back the place would
not accept is owed the same one thing to do as a person whose tick it would not accept, and no more.

A take-back SHALL reach the record's place and nothing else, exactly as an addition does.

#### Scenario: taking back the last addition on a row leaves the day short by exactly that amount

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" and then "90" are committed
  on the row it holds each time; and that row's last addition is then taken back
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** the day view says the commitment is not kept on that date

#### Scenario: taking back the last addition twice removes the two most recent

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30", then "45", then "50" are
  committed on the row it holds each time; and the last addition of the row it then holds is taken
  back twice
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** that row still offers taking its day's last addition back
- **AND** taking it back once more leaves the entry saying "0 of 120" and the row offering no
  take-back

#### Scenario: a take-back is held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" and then "90" are committed
  on the row it holds each time; that row's last addition is taken back; and a second day screen of
  the same commitment is then opened at the same place as of the same day
- **THEN** the second day screen's day view says the commitment is not kept on that date
- **AND** the entry its one row offers says "30 of 120"

#### Scenario: a take-back that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and that holds a record in which a commitment named "Protein" of the total kind
  with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026, has added 30 and 90 on that date, and that row's last addition is taken back
- **THEN** taking back is refused with an error
- **AND** the entry the row the day screen then holds offers still says "120 of 120"
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause

#### Scenario: taking back on a row that offers no take-back changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind and a commitment named "Protein" of the total
  kind with a target of 120, both on a schedule listing Monday, Wednesday and Saturday and both kept
  from 1 January 2026, and the last addition is taken back on each of its two rows in turn
- **THEN** the day screen's day view says neither commitment is kept on that date
- **AND** the entry the second row offers says "0 of 120"
- **AND** the day screen tells nothing on any row

#### Scenario: taking back on a row for a day that has not arrived changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing all seven weekdays, kept from 1 January 2026; "30" is committed on its one row; the screen
  is moved to the day after; and the last addition is taken back on the row it then holds
- **THEN** a day screen opened afterwards at that place as of Monday 31 August 2026 says "30 of 120"
- **AND** the day screen tells nothing on any row

#### Scenario: taking back on a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Protein" of the total kind with a target of 120,
  on a schedule listing all seven weekdays, kept from 1 January 2026, are opened at one place where
  nothing has been kept, the first as of Monday 31 August 2026 and the second as of Tuesday
  1 September 2026; "30" is committed on each screen's own row; and the second screen's row is then
  taken back on the first screen
- **THEN** a day screen opened afterwards at that place as of Tuesday 1 September 2026 says "30 of
  120"

#### Scenario: taking back on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  the last addition is taken back on its one row
- **THEN** it says it is not keeping a record
- **AND** the day screen tells nothing on any row
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: taking back writes nothing to the roster's place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster place
  where nothing has been kept, of a commitment named "Protein" of the total kind with a target of
  120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; "30" is
  committed on its one row; the roster place is read; and that row's last addition is then taken
  back
- **THEN** the content at the roster place is byte-for-byte what it was before the take-back
- **AND** the day screen says it is keeping its roster

## MODIFIED Requirements

### Requirement: A row is a commitment's line on a date

A row SHALL be three things and no others: the commitment it is a line for, the date the day view
holding it is of, and what the history the day view was formed from says about that commitment on
that date — whether it is kept, and, where its commitment's kind is a number, a note or a total,
the number that day holds, the note that day holds, or **the sum that day's additions come to**. Two
rows SHALL be the same row when all three agree, and SHALL be different when any one of them
differs.

The third of the three is one thing rather than three. A tick commitment's day is kept or it is not
and there is nothing else to know about it; a number commitment's day holds a number or it does
not, a note commitment's day holds a note or it does not, and holding one is what makes either
kept. Two rows of one number commitment on one date holding different numbers are therefore
different rows, for the reason two dates are: they offer different number entries, and one cannot
stand in for the other. Two rows of one note commitment on one date holding different notes are
different rows by the very same argument, and a row's third part grows by the note for the same
reason it grew by the number rather than for a new one. It grows by the **sum** for that reason a
third and last time: two rows of one total commitment on one date whose days have added different
amounts offer different total entries, and one cannot stand in for the other.

What a total row holds is the day's **sum** and never its additions, so two rows of one total
commitment on one date whose days hold different additions summing alike SHALL be **the same row**.
That is the shape this capability wants rather than a gap in it: everything a row does with what its
day holds — what its entry says, whether it offers a take-back, whether it is kept — is answered by
the sum, and taking a last addition back is answered by the record at the place rather than by the
row that asked for it. A row carrying the list so that two such rows could be told apart would give
this capability the additions themselves, which the requirement on what a total entry says exists to
keep out of it.

A row SHALL hold **only what its own commitment's kind can put there**. A tick commitment's row
holds neither a number nor a note, a number commitment's row holds no note, and a note commitment's
row holds no number — the history answers *no number* and *no note* for a commitment of any other
kind, so this follows from what a history says rather than being a rule this capability adds. A row
of any kind but a total holds a sum of **zero**, and holds it as a sum rather than as nothing at all,
because that is what a history answers for such a commitment; so every row holds a sum, and only a
total row's can be above zero.

The date is part of what a row is rather than something the day view alone holds. Two rows for the
same commitment, each saying the same thing about it, on two different dates SHALL be different
rows: they offer different ticks, and one cannot stand in for the other. This adds to what a day
view is without changing it — a day view is already its rows and its date, so day views on two dates
were already two day views, and this makes them so a second way rather than a new way.

A row SHALL be reachable only through the day view that holds it, and SHALL give back four things:
its commitment's name, **the rhythm that commitment runs on in words**, whether that commitment is
kept, and **what it offers** — a tick, a number entry, a note entry or a total entry, according to
its commitment's kind, and, on a total row whose day holds an addition, taking that addition back
besides. It MUST NOT give back the commitment itself, the schedule underneath it, the day it is kept
from, the date the row is for, **the number that day holds**, **the note that day holds**, or **the
sum that day's additions come to**: what a reader is given is what a screen draws and what a tap
makes, and nothing else has been asked for.

None of the number, the note and the sum is among them, though a row now holds all three. Each is
given out only inside the entry a row offers, so that a screen drawing a row has nothing to draw it
with: a row for a day holding 70.5, a row for a day holding "Ran 8k." and a row for a day that has
added 30 each say what a ticked row says and no more. That is a shape rather than a rule someone has
to keep, which is why what the day holds is part of what a row *is* and no part of what a row *gives
back* — and it matters more for a note than for a number, since a note is the one record long enough
that drawing it in a list would change what the list is for.

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

#### Scenario: two rows for the same note commitment and date holding different notes are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Journal"
  of the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  the first from a history holding a note of "Ran 8k." for that commitment on that date and the
  second from a history holding a note of "Rested." for it on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are different rows

#### Scenario: two rows for the same note commitment and date holding the same note are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Journal"
  of the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  each from a history holding a note of "Ran 8k." for that commitment on that date
- **THEN** each holds one row saying the commitment is kept
- **AND** the two rows are the same row

#### Scenario: two rows for the same total commitment and date whose days have added different amounts are different rows

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history holding an addition of 30 for that commitment on that
  date and the second from a history holding one of 90 for it on that date
- **THEN** each holds one row saying the commitment is not kept
- **AND** the two rows are different rows

#### Scenario: two rows for the same total commitment and date whose days have added the same amount are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, each from a history holding an addition of 30 for that commitment on that date
- **THEN** each holds one row saying the commitment is not kept
- **AND** the two rows are the same row

#### Scenario: two rows whose days hold different additions summing alike are the same row

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Protein"
  of the total kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept
  from 1 January 2026, the first from a history holding additions of 30 and 30 for that commitment on
  that date and the second from a history holding one addition of 60 for it on that date
- **THEN** the two rows are the same row
- **AND** the entry each offers says "60 of 120"

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
again here rather than fixed, so that one answer covers every kind of row and whoever fixes it fixes
it once.

A row SHALL offer at most one of a tick, a number entry, a note entry and a total entry, and never
two of them. A commitment's kind says what its days take and it says one thing: a row whose
commitment's kind is a tick offers the tick alone, one whose kind is a number offers the number entry
alone, one whose kind is a note offers the note entry alone, and one whose kind is a total offers the
total entry alone — there is no longer a kind whose row offers nothing. Which of them it offers is
therefore the only thing a row says about its kind — a row of any kind says its name, the rhythm it
runs on and whether the day was kept in exactly the same way.

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
- **AND** a row for a commitment alike in every way but of the note kind, asked as of that same
  day, offers neither of them
- **AND** a row for one alike in every way but of the total kind with a target of 120 offers neither
  of them either

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

### Requirement: A row offers the note entry its commitment takes, and offers none for a day that has not arrived

A row SHALL offer, when asked as of a calendar date, either exactly one note entry or nothing at all.
The entry it offers SHALL be the entry for that row's commitment on the date the day view holding it
is of, and nothing else: the row is a commitment on a date and a note is of a commitment on a date,
so there is nothing left for a caller to supply and nothing for the row to choose.

The row SHALL offer nothing when its commitment's kind is not a note, and SHALL offer nothing when
the day view's date is later than the day it is asked as of. Where neither holds it SHALL offer the
entry. A row asked as of its own date SHALL offer it — a day that has arrived can have been kept,
and only one that has not is refused — and so SHALL a row whose date is earlier, however much
earlier: the past is writable back to the day the commitment is kept from, and a commitment that is
not due there has no row to ask.

The second refusal is the tick's own and the number entry's own, word for word and for the same
reason: a record is what a person did about a day, and a day that has not happened has nothing yet to
say about it. Its price is the same too — such a row invites a tap it will not answer — and that
price is deliberately paid a third time here rather than fixed, so that one answer covers all three
kinds of row and whoever fixes it fixes it once.

A row SHALL offer at most one of a tick, a number entry, a note entry and a total entry, and never
two of them. A commitment's kind says what its days take and it says one thing: a row whose
commitment's kind is a tick offers the tick alone, one whose kind is a number offers the number entry
alone, one whose kind is a note offers the note entry alone, and one whose kind is a total offers the
total entry alone — there is no longer a kind whose row offers nothing. Which of them it offers is
therefore the only thing a row says about its kind — a row of any kind says its name, the rhythm it
runs on and whether the day was kept in exactly the same way.

Whether a row offers an entry SHALL NOT depend on what the history says. A row already saying its
commitment is kept offers one exactly as a row saying it is not, because a note written can be
written again and a note written on the wrong day has to be reachable to be taken back. What the
entry it offers *carries* does depend on the history, and that is the next requirement's.

The day the row is asked as of SHALL be given to it, and this capability MUST NOT read it from a
clock, MUST NOT consult the present moment, the device's time zone or the locale, and MUST NOT keep
it. A row therefore answers the same way for ever when asked as of the same day.

#### Scenario: a row offers the note entry for its commitment on the date the day view is of

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and its one row is asked as of Monday 31 August 2026
- **THEN** the day view holds one row named "Journal"
- **AND** that row offers a note entry

#### Scenario: a row for a commitment whose kind is not a note offers no note entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, one named "Weight" of the number kind with a range
  of 40 to 150 and one named "Water" of the total kind with a target of 120, all three on a schedule
  listing Monday, Wednesday and Saturday and all kept from 1 January 2026, and each of its rows is
  asked as of Monday 31 August 2026
- **THEN** the day view holds three rows, named "Gym", "Weight" and "Water"
- **AND** none of them offers a note entry
- **AND** a row for a commitment alike in every way but of the note kind, asked as of that same day,
  offers one

#### Scenario: a row offers a tick, a number entry or a note entry and never two of them

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Gym" of the tick kind, a commitment named "Weight" of the number kind with
  a range of 40 to 150 and a commitment named "Journal" of the note kind, all on a schedule listing
  Monday, Wednesday and Saturday and all kept from 1 January 2026, and all three of its rows are
  asked as of Monday 31 August 2026
- **THEN** the row named "Gym" offers a tick and neither a number entry nor a note entry
- **AND** the row named "Weight" offers a number entry and neither a tick nor a note entry
- **AND** the row named "Journal" offers a note entry and neither a tick nor a number entry
- **AND** a row for a commitment alike in every way but of the total kind with a target of 120,
  asked as of that same day, offers none of those three

#### Scenario: a row for a date later than the day it is asked as of offers no note entry

- **WHEN** a day view is formed on Wednesday 2 September 2026, from a history that has taken no
  record, of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026, and its one row is asked as of Monday 31 August 2026
- **THEN** the day view holds one row named "Journal"
- **AND** that row offers no note entry
- **AND** it offers neither a tick nor a number entry either

#### Scenario: a row for a date later than the day it is asked as of offers no note entry even where the day holds a note

- **WHEN** a day view is formed on Wednesday 2 September 2026, of a commitment named "Journal" of
  the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  from a history holding a note of "Ran 8k." for that commitment on that date, and its one row is
  asked as of Monday 31 August 2026
- **THEN** that row says the commitment is kept
- **AND** it offers no note entry

#### Scenario: a row for a date earlier than the day it is asked as of offers the note entry

- **WHEN** a day view is formed on Monday 31 August 2026, from a history that has taken no record,
  of a commitment named "Journal" of the note kind, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and its one row is asked as of Saturday 5 September 2026
- **THEN** the row offers a note entry

#### Scenario: a row offers the note entry whether or not the day is already kept

- **WHEN** two day views are formed on Monday 31 August 2026, each of a commitment named "Journal"
  of the note kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026,
  the first from a history that has taken no record and the second from a history holding a note of
  "Ran 8k." for that commitment on that date, and each one's row is asked as of that same day
- **THEN** the first row says the commitment is not kept and the second says it is
- **AND** both offer a note entry

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
what a person must give instead. Which values those are is the requirement on entering a number,
the one on reading what an entry is committed with as a number, and the one on reading what is
committed in a total entry, and none of the three is restated here.

It SHALL name a cause **only where a person can act on that cause differently**, and SHALL tell
every other refusal the same way and name nothing at all. The test is what a person does next, and
it is the one this capability already applies to a record that could not be opened. A change the
place refused leaves a person exactly one thing to do whatever the reason was — try again, and if
it keeps failing, look at the device — so it names nothing: it MUST NOT tell which of making the
tick and taking it back was asked for, it MUST NOT tell which of entering a number and taking one
back was asked for, it MUST NOT tell which of writing a note and taking one back was asked for, it
MUST NOT tell which of adding to a day and taking that day's last addition back was asked for, and
it MUST NOT tell why the place would not take the change.

**Exactly four causes SHALL be named, and every one of them is the value a person gave.** A value
committed in a number entry **or in a total entry** that is not a number SHALL be told as "Not a
number" — one cause and not two, because the person's next act is the same one in both and a second
wording for it would be two messages saying one thing. A number the commitment refuses SHALL be told
by naming the range that commitment declares — "Must be between 40 and 150" for a range of 40 to
150 — because the one thing the person can do about it is give a number inside those bounds, and
"try again" is false there: 300 against 40 to 150 is refused for ever, however many times it is
committed. An amount committed in a total entry that is not above zero SHALL be told as **"Must be
more than 0"**. An amount that would take that day's additions past what this system can keep exactly
SHALL be told as **"Too large to add"**. The words SHALL be this package's own English and no
locale's, and each bound SHALL be said exactly as the commitment declares it, as a range hint says
it.

**The two new causes are named on this requirement's own test and no other.** A person told "Must be
more than 0" gives a different amount; a person told "Too large to add" gives a smaller one; neither
is anything "try again" would fix, and neither is the place's doing. The second says the only thing
its person can act on: the headroom it could otherwise name is a thirty-eight-digit number, and a
message nobody can use is a message that teaches them to ignore the next one.

**No fifth cause SHALL be named.** A number a commitment with no range would refuse does not exist —
every number is a number to it — and a total commitment declares no bound of its own at all, so the
refusals a total row can meet are exactly the three above and the place's own, which names nothing.
A cause a person cannot act on differently MUST NOT be named however easily it could be.

**A note names no cause at all.** A note commitment declares no bound, and every text that says
something is a note, so there is nothing this screen can refuse a committed note for but the place
refusing to take it — and a text that says nothing is not a refusal but the take-back. A note SHALL
therefore be told exactly as a refused tick is: on the row, naming nothing. Nothing about a note's
length, its script, its line breaks or its characters SHALL be named as a cause, because no such
refusal exists to name and inventing a message for one would teach a person a rule this product does
not have.

**A commit in a total entry that says nothing names no cause either, because it is no refusal.** It
keeps nothing and takes nothing back, which is what a person who committed an empty field asked for;
telling them something would be answering a question they did not ask.

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

#### Scenario: a note refused by the place is told on the row and names no cause

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journal" of the note
  kind, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  "Ran 8k." is committed on its one row
- **THEN** committing is refused with an error
- **AND** the day screen tells, on that row, that the change could not be kept
- **AND** what it tells names no cause
- **AND** committing nothing at all on that row tells the same thing on it and names no cause
  either
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

**A change reaching the record's place** ends it, on whichever row that change was made. A tick that
lands, a tick taken back, a number entered and a number taken back, a note written and a note taken
back, an addition made and a day's last addition taken back all count: what is being told is that
the place would not take your change, and any one of them landing is proof to the contrary. One rule
rather than eight, because a person cannot act on the difference. A change that does not reach the
place SHALL NOT end it — a second refusal moves it rather than ending it, and a tap that changes
nothing at all changes this nothing either.

A value the commitment refuses and a value that is not a number reach no place, so neither ends
it. Each is a refusal of its own and moves what is told, and the cause it names, onto its own row.
Someone told that the place would not take their tick and then typing 300 into a weight has
learned nothing about the place, so nothing about the place stops being true — it is replaced by
what they were told instead, which is the one-at-a-time rule and not a fourth end. **A note has no
such case**: every commit in a note entry either reaches the place or is a take-back that reaches
it, so a note is only ever one of the ends above or one of the refusals the place itself makes. **A
total entry has three such cases** — a value that is not a number, an amount not above zero, and an
amount too large to add — and each behaves exactly as a refused number does: it reaches no place,
so it ends nothing, and it moves what is told, with the cause it names, onto its own row.

**A commit in a total entry that says nothing is not an end either, and is not a refusal.** It
reaches no place, so it proves nothing about the place; and it refuses nothing, so there is nothing
of its own to move onto the row. What a day screen was telling therefore stands exactly as it was.
It is the same argument that keeps closing an entry without committing it from being a fourth end,
applied to the one entry in which committing nothing *is* a commit.

**The day the screen is showing changing** ends it. What is told is about a tap on a row of the day
you were on, and a day you have moved away from has no row to say it under; carrying it forward
would put a message under a commitment that refused nothing. The rule SHALL be the day being shown
**changing** and never the gesture that was made. A move with nowhere to go — the day before the
first supported date, the day after the last — and going back to today from a screen already showing
today both leave a day screen exactly as it was, which is already this capability's answer, and what
it is telling is part of how it was.

**Closing a number entry or a note entry without committing it is not a fourth end, and cannot
become one.** Someone who opens an entry and leaves it keeps nothing and commits nothing, so this
capability is never asked anything at all and what it is telling still describes the last thing that
happened. Each of the three ends is something that *changed* — the app was shown, a change landed,
the day moved — and nothing changed here. It is written down because a field with a Cancel beside it
is the most plausible fourth end anyone will propose, and a note's field, which a person may sit in
for a minute before backing out of it, is the most tempting instance of that.

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

#### Scenario: what a day screen tells on a row ends when a note is written and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and where nothing has been kept, of a commitment named "Journal" of the note kind,
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026; "Ran 8k." is
  committed on its one row and refused; the place is then made writable; and "Ran 8k." is committed
  again on the row the screen then holds
- **THEN** the day screen's day view says the commitment is kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a note is taken back and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind on a schedule listing Monday, Wednesday and
  Saturday and a commitment named "Gym" of the tick kind on a schedule listing all seven weekdays,
  in that order and both kept from 1 January 2026; "Ran 8k." is committed on the first row and kept;
  the place is then made unwritable; the second row is ticked and refused; the place is made
  writable again; and nothing at all is committed on the row for "Journal"
- **THEN** the day screen's day view says "Journal" is not kept on that date
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when an addition is made and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place that can be read from but
  not written to and where nothing has been kept, of a commitment named "Protein" of the total kind
  with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026; "30" is committed on its one row and refused; the place is then made writable; and "30" is
  committed again on the row the screen then holds
- **THEN** the entry the row the day screen then holds offers says "30 of 120"
- **AND** it tells nothing on any row

#### Scenario: what a day screen tells on a row ends when a last addition is taken back and kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120 on a schedule listing
  Monday, Wednesday and Saturday and a commitment named "Gym" of the tick kind on a schedule listing
  all seven weekdays, in that order and both kept from 1 January 2026; "30" is committed on the first
  row and kept; the place is then made unwritable; the second row is ticked and refused; the place is
  made writable again; and the last addition is taken back on the row for "Protein"
- **THEN** the entry that row then offers says "0 of 120"
- **AND** it tells nothing on any row

#### Scenario: a commit saying nothing in a total entry leaves what a day screen is telling standing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Protein" of the total
  kind with a target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; "30" is committed on its one row and refused; and nothing at all is then committed
  on the row it holds
- **THEN** the day screen still tells, on that row, that the change could not be kept
- **AND** the entry that row offers still says "0 of 120"

### Requirement: A day screen tells nothing on a row where there was no tick to refuse

A tap or a commit that never reaches the record's place is not a refused change. A day screen
SHALL tell nothing on the row for one, and SHALL NOT end what it is already telling on another
row: there is no refusal to report and nothing has been proved about the place either way.

**The four causes the requirement above names are the exception, and they are the whole of it.** A
value that is not a number, a number the commitment refuses, an amount that is not above zero and an
amount too large to add to its day all reach no place either, and every one of them is told, because
what a person is told there is not that the place refused them — it is what to give instead. Where
the value was never read at all, this requirement governs, and the four cases below are all of
them.

A tap or a commit on a day screen that is **not keeping a record** SHALL be the first, whatever
the reason the store would not open, and whatever was committed — a value that commitment would
refuse included, because such a screen never gets as far as reading what was committed and would
be naming a cause about a value it never read. It already says it is keeping no record, and that
says more than a per-row message would and is what a person can act on; the two would share the
same end — being shown again — and would clear together, so the row would only ever repeat it.

A tap or a commit on a row **for a day that has not arrived** SHALL be the second. Such a row offers
no tick, no number entry, no note entry, no total entry and no take-back, asked as of the today the
screen was handed, so there is no change to refuse and nothing was asked of the place. What is told
on a row means a change did not reach the place, and here there was no change. The honest answer to
a day that has not arrived is a row that does not invite the tap at all, and that is not this
capability's answer here — for the fourth and last kind of row now, and the price is paid a fourth
time rather than half-fixed.

A tap or a commit on a **row the day screen's day view does not hold** SHALL be the third. Such a
row already changes nothing at all, and telling something about it would be a change.

A commit on a **row that offers no entry at all for any other reason** SHALL be the fourth, and it
is now a **tick row alone**: such a row was never asked for anything to be committed and has nothing
to refuse. What is committed on one keeps nothing and says nothing, exactly as a tick made on a
number row, a note row or a total row does — a row answers for the kind its commitment declares and
stays silent about every other. **A take-back asked of a row that offers none** SHALL be told nothing
by the same rule and for the same reason, whichever of the three things makes the row offer none.

**A total row is no longer among them**, and that is what this change moves here — as #140 moved the
note row before it, and there is no fifth kind left to move. A total row offers a total entry, so a
commit on one is read, kept and answered for exactly as a commit on a number row is, and it names one
of three causes where a number row names one of two.

A commit in a total entry that **says nothing** SHALL likewise be told nothing on the row, and SHALL
NOT end what is already told on another. It is read rather than never read, so it is not one of the
four cases above; but it asks for no change, refuses nothing, and reaches no place, so there is
nothing to report about it in either direction. What it does to the day is the requirement on reading
what is committed in a total entry, and it is not restated here.

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

#### Scenario: a commit on a row that offers no entry at all is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" of the tick kind, on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and "Ran 8k." is committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on that date
- **AND** committing "30" and then nothing at all on that row tells nothing on any row either

#### Scenario: a commit on a note row on a day screen that is not keeping a record is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Journal" of the note kind, on a
  schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and "Ran 8k." is
  committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** it says it is not keeping a record
- **AND** committing nothing at all on that row tells nothing on any row either

#### Scenario: a commit on a note row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journal" of the note kind, on a schedule listing all seven weekdays,
  kept from 1 January 2026; it is moved to the day after; and "Ran 8k." is committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026

#### Scenario: a commit on a total row on a day screen that is not keeping a record is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Protein" of the total kind with a
  target of 120, on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and
  "30" is committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** it says it is not keeping a record
- **AND** committing "0", then "1.2.3", then nothing at all on that row tells nothing on any row
  either
- **AND** taking that row's last addition back tells nothing on any row either

#### Scenario: a commit on a total row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day after; and "0" is
  committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026
- **AND** taking that row's last addition back tells nothing on any row either

#### Scenario: taking back on a row that offers no take-back is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" of the tick kind
  and a commitment named "Protein" of the total kind with a target of 120, in that order and both on
  a schedule listing Monday, Wednesday and Saturday and both kept from 1 January 2026; the first row
  is ticked and refused; and the last addition is then taken back on the second row, whose day holds
  none
- **THEN** the day screen still tells, on the first row, that the change could not be kept
- **AND** it tells nothing on the second row
