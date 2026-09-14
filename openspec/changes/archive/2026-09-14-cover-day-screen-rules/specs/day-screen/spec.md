## MODIFIED Requirements

### Requirement: A day screen moves the day it is showing one calendar day either way

A day screen SHALL move the day it is showing one calendar day either way, giving what moving the
day view it holds gives, handed the record the screen holds and the commitments its roster answers
with on the day landed on. A move SHALL be asked of the screen and handed nothing. The today SHALL
NOT move, and every question a day screen asks as of a day SHALL still be asked as of that today.

A day screen SHALL step as far either way as the calendar goes: it MUST NOT stop at the today it
holds, at the earliest day a commitment its roster answers with is kept from, or at any day read off
what the record or the roster holds. A move SHALL NOT read either place again: it SHALL form the day
view from the record as the screen last read it — the reading done when the app was shown, together
with every change kept on the screen since — and from the roster as last read, asked afresh about
the day landed on, and SHALL leave what the screen says about either place exactly as it was. A day
screen not keeping one of them SHALL move like any other and go on saying so.

#### Scenario: a day screen moved to the day before shows the previous day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026, and it is moved to the day before
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Sunday 30 August 2026, from a history that has taken no tick
- **AND** it holds one row, named "Journaling"

#### Scenario: a day screen moved to the day after shows the next day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026, and it is moved to the day after
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Tuesday 1 September 2026, from a history that has taken no tick
- **AND** it holds one row, named "Journaling"

#### Scenario: moving a day screen does not change the today it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after
- **THEN** its day picker opens on Tuesday 1 September 2026, and it offers the way back to today
- **AND** moving it to the day before makes its day picker open on Monday 31 August 2026, which is
  the day it was handed, and makes it offer no way back

#### Scenario: a day screen moves onto a day that has not arrived and shows it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after four times
- **THEN** its day view is the same day view as one formed directly of that commitment on Friday
  4 September 2026 from a history that has taken no tick
- **AND** its day picker opens on Friday 4 September 2026

#### Scenario: a day screen moves back to a day before every commitment was kept from and shows no rows

- **WHEN** a day screen is opened as of Thursday 1 January 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day before
- **THEN** its day view holds no rows, Wednesday 31 December 2025 being before the day the commitment
  is kept from
- **AND** moving it to the day after gives back the day view it held when it was opened

#### Scenario: moving a day screen does not read the record again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; a tick for that commitment on Sunday 30 August 2026 is then kept at that place by
  something else; and the day screen is moved to the day before
- **THEN** its day view says the commitment is not kept on Sunday 30 August 2026
- **AND** it says it is keeping a record, exactly as it did before the move

#### Scenario: moving a day screen away and back shows the day it started from

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026, and it is moved to the day after and then to the day before
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** moving it to the day before and then to the day after gives that same day view again

#### Scenario: a day screen that is not keeping a record moves and goes on saying it is keeping none

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes that
  is not what a record is written as, of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 2026, and it is moved to the day before
- **THEN** its day view is the same day view as one formed directly of that commitment on Sunday
  30 August 2026 from a history that has taken no tick
- **AND** it says it is not keeping a record

#### Scenario: a day screen that is not keeping a roster moves and goes on saying why

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a roster
  written in a form one later than the form this app writes, holding no commitments, at a record
  place where nothing has been kept, of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 2026, and it is moved to the day before and then to the day
  after
- **THEN** after the move to the day before, its day view is the same day view as one formed directly
  of no commitments at all on Sunday 30 August 2026 from a history that has taken no tick
- **AND** after the move to the day after, its day view is the same day view as one formed directly of
  no commitments at all on Monday 31 August 2026 from that same history
- **AND** after each move it says it is not keeping a roster
- **AND** after each move it says the roster was written by a later version of DayByDay
- **AND** after each move its day view holds no rows

#### Scenario: a tick kept on a day screen is still shown after it moves away and back, goes back to today or has that day picked

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; its one row is ticked; and it is moved to the day before and then to the day after
- **THEN** its day view says the commitment is kept on Monday 31 August 2026
- **AND** moved to the day before and then sent back to today, its day view says the same
- **AND** moved to the day before and then with Monday 31 August 2026 picked on its day picker, its
  day view says the same

### Requirement: A day screen goes straight back to the today it was handed

A day screen SHALL go back, in one step and from whatever day it is showing, to the today it was
handed, making the day being shown that today and forming the day view again on it, from the
commitments its roster answers with on that today and the record the screen holds. It SHALL read
neither the record nor the roster again, SHALL leave what the screen says about either of them
alone, and SHALL move the day being shown and never the today.

The day it goes back to SHALL be the today the screen was last handed, and this capability MUST NOT
read a clock to find it. Going back SHALL take no day from the caller and SHALL reach that today and
no other. A day screen already showing its today SHALL be left showing it.

#### Scenario: a day screen moved into the past goes back to today in one step

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before three times; and it is then sent back to today
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: a day screen moved into the future goes back to today in one step

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day after three times; and it is then sent back to today
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: a day screen already showing today is left where it is when it is sent back to today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is sent back to today without having been moved
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: a day screen goes back to the today it was last handed rather than the day it opened on

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; the app is then shown again as of Wednesday 2 September 2026; it is moved to the
  day before twice; and it is then sent back to today
- **THEN** its day picker opens on Wednesday 2 September 2026, and it offers no way back to today

#### Scenario: going back to today does not read the record again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; a tick for that commitment on Monday 31 August 2026
  is then kept at that place by something else; and it is sent back to today
- **THEN** its day view says the commitment is not kept on Monday 31 August 2026
- **AND** it says it is keeping a record, exactly as it did before

#### Scenario: going back to today does not read the roster again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; it
  is moved to the day before; a commitment named "Gym" on that same schedule, kept from that same
  day, is then taken on at that roster place by something else; and it is sent back to today
- **THEN** its day view holds one row, named "Journaling"
- **AND** it says it is keeping a roster, exactly as it did before
- **AND** a day screen of no commitments at all opened as of that same day at a roster place of its
  own holding a roster written in a form one later than the form this app writes, holding no
  commitments, and at a record place of its own where nothing has been kept, moved to the day
  before, with what is at that roster place then removed so that nothing has been kept there, and
  sent back to today, says it is not keeping a roster, says the roster was written by a later
  version of DayByDay, and holds no rows

#### Scenario: a day screen sent back to today draws the commitments its roster had not stopped keeping on that today

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped as of Sunday 30 August 2026; a day
  screen of no commitments at all is opened at that roster place as of Monday 31 August 2026, at a
  record place where nothing has been kept; it is moved to the day before; and it is sent back to
  today
- **THEN** its day view holds no rows, Monday 31 August 2026 being after the day the commitment was
  kept until
- **AND** before it was sent back, its day view held one row, named "Journaling"

### Requirement: A day screen that cannot read its record draws the day and keeps nothing

Opening a day screen at a place holding something that cannot be read as a record SHALL give a day
screen rather than an error: it SHALL hold the day view of its day formed from a history that has
taken no tick, and SHALL say that it is not keeping a record. Such a screen SHALL take no tick — a
tick made on it MUST NOT be shown as kept, MUST NOT be held in memory to be kept later, and MUST NOT
be kept anywhere else — and SHALL leave what is at the place exactly as it was, not overwritten, not
moved, not emptied. Every way a store can refuse to open SHALL be answered in that one way.

A day screen that is not keeping a record SHALL say which of two things is so: that the record at
its place was written by a later version of DayByDay, or only that it could not be read. It MUST NOT
tell any other reason apart, and MUST NOT say a record was written by a later version when it was
refused for any other reason. A day screen that could read its record SHALL say that it is keeping
one.

#### Scenario: a day screen opened where the record cannot be read still holds the day view of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday and a commitment named "Run" on a schedule listing Tuesday, Thursday and
  Sunday, both kept from 1 January 2026
- **THEN** its day view holds one row, for "Gym"
- **AND** that row says the commitment is not kept

#### Scenario: a day screen opened where the record cannot be read says it is not keeping one and gives no further reason

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026
- **THEN** it says it is not keeping a record
- **AND** it does not say the record was written by a later version of DayByDay

#### Scenario: a record written in a later form than this app knows makes a day screen that says the record is from a later version

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record written
  in a form one later than the form this app writes, holding no ticks, of a commitment named "Gym"
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026
- **THEN** it says it is not keeping a record
- **AND** it says the record was written by a later version of DayByDay
- **AND** its day view holds one row, for "Gym", saying the commitment is not kept

#### Scenario: a day screen opened where the record can be read says it is keeping one

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026
- **THEN** it says it is keeping a record
- **AND** a day screen opened at a place where a tick has been kept says the same

#### Scenario: ticking a row on a day screen that is not keeping a record changes nothing and keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** its day view still says the commitment is not kept on that date
- **AND** it still says it is not keeping a record

#### Scenario: a day screen opened where the record cannot be read leaves what is at the place as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: ticking a row on a day screen holding a record from a later version keeps nothing and leaves the record as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record written
  in a form one later than the form this app writes, holding no ticks, of a commitment named "Gym"
  on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is
  ticked
- **THEN** its day view still says the commitment is not kept on that date
- **AND** it still says the record was written by a later version of DayByDay
- **AND** the content at that place is byte-for-byte what it was before the screen was opened

#### Scenario: a tick made on a day screen that cannot read its record is not kept once the record can be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday and one named "Run" on a schedule listing all seven days, in that order,
  both kept from 1 January 2026; the row for "Gym" is ticked; what is at that place is then removed,
  so that nothing has been kept there; the app is shown again as of Monday 31 August 2026; and the
  row for "Run" is then ticked
- **THEN** it says it is keeping a record
- **AND** its day view says "Gym" is not kept on that date and "Run" is kept on that date
- **AND** a day screen of those two commitments opened afterwards at that place as of that same day
  says the same

#### Scenario: a day screen whose record place cannot be opened for another reason answers as one that cannot read its record

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place that is a directory
  holding nothing rather than a file, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** it says it is not keeping a record
- **AND** it does not say the record was written by a later version of DayByDay
- **AND** its day view holds one row, for "Gym", saying the commitment is not kept
- **AND** that place is still a directory holding nothing

### Requirement: A day screen draws the commitments its roster had not stopped keeping on the day it is showing

A day screen SHALL form every day view from the commitments the roster at its roster place had not
stopped keeping on the day shown, in the roster's groups and order. Every day view SHALL ask the
roster again for the day then shown: when the screen is opened, moved, sent back to today, shown
again or returned to, and when a tick is made. The roster asked SHALL be the one read when the app
was last shown or the screen last returned to, whichever happened later, with any change kept since;
asking MUST NOT open the place. A commitment the roster stopped or removed SHALL have a row up to
and including the day it was kept until, and none after; a day screen MUST NOT tell the two apart in
any way: not in the row drawn, in what it says or offers, nor in its group. A group with nothing due
produces no group, as *A day view is a value and nothing else* states.

#### Scenario: a day screen draws the commitments its roster keeps, in the order they were taken on

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays and then one
  named "Supplements and habits" on that same schedule, both kept from 1 January 2026, are taken on
  at a roster place; and a day screen of no commitments at all is opened at that roster place as of
  Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day view holds two rows, named "Journaling" and then "Supplements and habits"
- **AND** it says it is keeping a roster

#### Scenario: a day screen draws a commitment on the day it was kept until and not on the day after it

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped as of Sunday 30 August 2026; a day screen
  of no commitments at all is opened at that roster place as of Monday 31 August 2026, at a record
  place where nothing has been kept; and it is moved to the day before
- **THEN** the day view it held when it was opened holds no rows, Monday 31 August 2026 being after
  the day the commitment was kept until
- **AND** after the move its day view holds one row, named "Journaling"

#### Scenario: moving a day screen does not read its roster again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from that same
  day, is then taken on at that roster place by something else; and the day screen is moved to the
  day before and then to the day after
- **THEN** its day view holds one row, named "Journaling"
- **AND** it says it is keeping a roster, exactly as it did before the move

#### Scenario: a tick made on a day screen leaves what is kept at its roster place as it was

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 31 August 2026 at a roster place and a record
  place where nothing has been kept, and its one row is ticked
- **THEN** its day view says the commitment is kept on that date
- **AND** the content at its roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a day screen draws a removed commitment on the day it was kept until and not on the day after it

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place, ticked on Sunday 30 August 2026, and removed as of
  that same day; and a day screen of no commitments at all is opened at that roster place as of
  Monday 31 August 2026, at the record place that tick was kept at
- **THEN** the day view it held when it was opened holds no rows, Monday 31 August 2026 being after
  the day the commitment was kept until
- **AND** after it is moved to the day before, its day view holds one row, named "Journaling", saying
  the commitment is kept on that date

#### Scenario: a day screen draws its rows in the order its roster was moved into

- **WHEN** a commitment named "Journaling", then one named "Supplements and habits", then one named
  "Gym", all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Gym" is moved there to the offset 0; and a day screen of no commitments at all is
  opened at that roster place as of Monday 31 August 2026, at a record place where nothing has been
  kept
- **THEN** its day view holds three rows, named "Gym", "Journaling" and then "Supplements and habits"
- **AND** it says it is keeping a roster

#### Scenario: a day screen draws its rows in the groups its roster puts them in

- **WHEN** a commitment named "Creatine", then one named "Gym", then one named "Magnesium", then one
  named "Journaling", all on a schedule listing all seven weekdays and kept from 1 January 2026, are
  taken on at a roster place; "Creatine" and "Magnesium" are put under the category "Supplements"
  there and "Gym" under "Sport"; and a day screen of no commitments at all is opened at that roster
  place as of Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day view holds three groups: "Supplements" holding rows named "Creatine" and then
  "Magnesium", then "Sport" holding a row named "Gym", then a group with no category holding a row
  named "Journaling"
- **AND** it says it is keeping a roster

#### Scenario: a day screen draws a group again after a category is changed at its roster place

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a day screen of no
  commitments at all is opened at that roster place as of Monday 31 August 2026, at a record place
  where nothing has been kept; "Creatine" is put under the category "Supplements" at that roster
  place by something else; and the app is shown again as of that same day
- **THEN** the day view it held when it was opened holds one group, with no category, holding rows
  named "Creatine" and then "Gym"
- **AND** afterwards its day view holds two groups, "Supplements" holding a row named "Creatine" and
  then a group with no category holding a row named "Gym"

#### Scenario: a day screen draws a removed commitment under a category exactly as it draws a stopped one

- **WHEN** at each of two roster places a commitment named "Creatine" on a schedule listing all
  seven weekdays, kept from 1 January 2026, is taken on and put under the category "Supplements",
  and is then stopped as of Sunday 30 August 2026 at the first and removed as of that same day at
  the second; and a day screen of no commitments at all is opened at each roster place as of Monday
  31 August 2026, each at a record place of its own where nothing has been kept, and moved to the
  day before
- **THEN** the two day screens' day views are the same day view
- **AND** each holds one group, under "Supplements", holding one row named "Creatine"

### Requirement: A day screen that cannot read its roster draws the day and no rows

A day screen opened where the roster cannot be read SHALL still be a day screen: it SHALL hold no
rows, SHALL say it is not keeping a roster, and SHALL leave the place exactly as it was, not written
over with the commitments it was handed. It SHALL say which of two things is so: the roster was
written by a later version of DayByDay, or it only could not be read. It MUST NOT tell another
reason apart or name a later version for any other refusal.

What a day screen says about its roster SHALL be read off the roster's place and what it says about
its record off the record's, neither off the other, and it may be keeping one and not the other. A
day screen that could read its roster SHALL say so; one that could not SHALL say its day just the
same.

#### Scenario: a day screen opened where the roster cannot be read holds no rows and says it is not keeping one

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026
- **THEN** its day view holds no rows
- **AND** it says it is not keeping a roster
- **AND** it does not say the roster was written by a later version of DayByDay

#### Scenario: a roster written in a later form than this app knows makes a day screen that says the roster is from a later version

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a roster
  written in a form one later than the form this app writes, holding no commitments, at a record place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026
- **THEN** it says it is not keeping a roster
- **AND** it says the roster was written by a later version of DayByDay
- **AND** its day view holds no rows

#### Scenario: a day screen opened where the roster can be read says it is keeping one

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026
- **THEN** it says it is keeping a roster
- **AND** a day screen opened at a roster place where a commitment has already been taken on says the
  same

#### Scenario: a day screen that cannot read its roster still says the day and goes on keeping its record

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026
- **THEN** it says the day is "Mon"
- **AND** it says it is keeping a record
- **AND** it says it is not keeping a roster

#### Scenario: a day screen that cannot read its record still draws the commitments its roster keeps

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and then one
  named "Journaling" on a schedule listing all seven weekdays, both kept from 1 January 2026, are
  taken on at a roster place; and a day screen of no commitments at all is opened at that roster place
  as of Monday 31 August 2026, at a record place holding a run of bytes that is not what a record is
  written as
- **THEN** its day view holds two rows, named "Gym" and then "Journaling", neither saying its
  commitment is kept
- **AND** it says it is not keeping a record
- **AND** it says it is keeping a roster

#### Scenario: a day screen whose roster place cannot be opened for another reason does not say the roster is from a later version

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place that is a directory
  holding nothing rather than a file, at a record place where nothing has been kept, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026
- **THEN** it says it is not keeping a roster
- **AND** it does not say the roster was written by a later version of DayByDay

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
  commitment named "Mood" of the number kind with a range of 1 to 10, both on a schedule listing
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

### Requirement: A day screen says no day view before the first supported date and none after the last

A day screen showing 1 January 1583 SHALL say no day view of the day before it, and one showing 31
December 9999 SHALL say none of the day after it; the absence is the whole of the answer. The
absence SHALL be about the calendar and about nothing else: a screen showing either end SHALL go on
saying the day view on its other side, and a screen showing any other date SHALL say one on both
sides, whatever its roster holds, whatever its record holds, whether its day view has any rows, and
whichever day it was handed as today. The absence SHALL NOT be read as an answer about moving,
which *A move with nowhere to go leaves a day screen exactly as it was* states.

#### Scenario: a day screen showing the first supported date says no day view before it and says the day after

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** it says no day view of the day before
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Sunday 2 January 1583 from a history that has taken no tick

#### Scenario: a day screen showing the last supported date says no day view after it and says the day before

- **WHEN** a day screen is opened as of Friday 31 December 9999, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** it says no day view of the day after
- **AND** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Thursday 30 December 9999 from a history that has taken no tick

#### Scenario: a day screen moved off an end of the calendar says a day view either side of it

- **WHEN** a day screen is opened as of Saturday 1 January 1583, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583, and it is moved to the day after
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Saturday 1 January 1583 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Monday 3 January 1583 from that same history

#### Scenario: a day screen showing the first supported date says no day view before it whatever its places, its rows and its today

- **WHEN** a day screen is opened as of Sunday 2 January 1583, at a roster place holding a run of
  bytes that is not what a roster is written as and a record place holding a run of bytes that is
  not what a record is written as, of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 1583, and it is moved to the day before
- **THEN** its day view holds no rows, and it says no day view of the day before
- **AND** the day view it says of the day after is the same day view as one formed directly of no
  commitments at all on Sunday 2 January 1583 from a history that has taken no tick
- **AND** moved to the day after, it says a day view of the day before and a day view of the day
  after

### Requirement: A day screen makes every change on the day it is showing and none on a day either side of it

Every change a day screen makes SHALL be made on the day it is showing: a tick made or taken back, a
number or a note entered or taken back, an amount added and a last addition taken back are all
changes to the day being shown, and none of them SHALL be made on the day before it or the day after
it. A row that only a day either side holds SHALL change nothing: ticking, entering and taking back
with it SHALL each leave the record's place, the screen's day view and what it says of the days
either side exactly as they were — the shipped rule that a row the screen's day view does not hold
changes nothing, read over the rows this capability says. Nothing SHALL be told on such a row, and
what the screen is telling SHALL be left as it was.

#### Scenario: ticking a row a day screen says of the day before changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the one row of the day view it says of the day before is ticked
- **THEN** the day view it says of the day before still says the commitment is not kept on Sunday
  30 August 2026
- **AND** its day view is the same day view as the one it held when it was opened
- **AND** the content at its record place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: entering a number on a row a day screen says of the day after changes nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; and "72" is committed on the one row of the
  day view it says of the day after
- **THEN** the entry that row offers, asked again from the day view the screen then says of the day
  after, says no number
- **AND** its day view is the same day view as the one it held when it was opened
- **AND** the content at its record place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: taking back the last addition on a row a day screen says of the day before changes nothing

- **WHEN** a day screen is opened as of Sunday 30 August 2026, at a place where nothing has been
  kept, of a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing all seven weekdays, kept from 1 January 2026; "30" is committed on the one row it holds;
  it is moved to the day after; and the last addition is then taken back on the one row of the day
  view it says of the day before
- **THEN** the entry that row offers, asked again from the day view the screen then says of the day
  before, says "30 of 120"
- **AND** the content at its record place is byte-for-byte what it was immediately before that
  take-back was asked for

#### Scenario: a day screen tells nothing on a row of a day either side of the one it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026, and the one row of the day view it
  says of the day before is ticked
- **THEN** it is telling nothing on any row
- **AND** ticking that row is not refused with an error

#### Scenario: every change asked of a row a day screen says of the day before changes nothing and leaves what it is telling

- **WHEN** a record holding, on Sunday 30 August 2026, a tick for a commitment named "Gym" of the
  tick kind, a number of 70.5 for one named "Weight" of the number kind with a range of 40 to 150, a
  note of "Ran 8k." for one named "Journal" of the note kind and an addition of 30 for one named
  "Protein" of the total kind with a target of 120, all four on a schedule listing all seven
  weekdays and kept from 1 January 2026, is kept at a place; a day screen of those four
  commitments, in that order, is opened at that place as of Monday 31 August 2026; "300" is
  committed on its own row named "Weight"; and on the rows of the day view it then says of the day
  before, the row named "Gym" is ticked, nothing at all and then "1.2.3" are committed on the row
  named "Weight", "Rested." and then nothing at all on the row named "Journal", and "30" and then
  "0" on the row named "Protein"
- **THEN** the day view it says of the day before is the same day view as the one it said before
  those changes were asked for
- **AND** its day view is the same day view as the one it held before those changes were asked for
- **AND** the content at its record place is byte-for-byte what it was immediately after the screen
  was opened
- **AND** it still tells, on its own row named "Weight", that the number must be between 40 and 150

### Requirement: A day screen says the day its day picker opens on and the earliest day it reaches

A day screen SHALL say the reach of its day picker as one answer of two days: the day it opens on
and the earliest day it reaches. The day it opens on SHALL be the day being shown, whatever put it
there. The earliest day it reaches SHALL be the earlier of the earliest day anything on its roster
is kept from and the day being shown, and SHALL never be later than the day it opens on. Where the
roster answers no such day, the today last handed SHALL stand in its place. That day SHALL be the
`commitment` capability's answer for the roster the screen last read, counting every commitment it
holds, stopped and removed included; a day screen MUST NOT recompute it, nor narrow it to the
commitments due on some day, to those still kept, or to those its day view holds rows for.

#### Scenario: a day screen's day picker opens on the day it is showing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is not moved
- **THEN** its day picker opens on Monday 31 August 2026
- **AND** moved to the day before, its day picker opens on Sunday 30 August 2026
- **AND** moved from there to the day after twice, its day picker opens on Tuesday 1 September 2026

#### Scenario: a day screen's day picker reaches back to the earliest day anything on its roster is kept from

- **WHEN** a commitment named "Gym" kept from 1 March 2026, one named "Run" kept from 1 January
  2026 and one named "Journaling" kept from 1 February 2026, all on a schedule listing all seven
  weekdays, are taken on at a roster place; and a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day picker reaches back to 1 January 2026
- **AND** its day picker opens on Monday 31 August 2026

#### Scenario: a day screen's day picker reaches back past a commitment its roster has stopped keeping

- **WHEN** a commitment named "Gym" kept from 1 January 2026 and one named "Run" kept from 1 March
  2026, both on a schedule listing all seven weekdays, are taken on at a roster place; "Gym" is
  stopped there as of 31 January 2026; and a day screen of no commitments at all is opened at that
  roster place as of Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day picker reaches back to 1 January 2026
- **AND** its day view holds one row, named "Run"

#### Scenario: a day screen's day picker reaches back past a commitment its roster has removed

- **WHEN** a commitment named "Gym" kept from 1 January 2026 and one named "Run" kept from 1 March
  2026, both on a schedule listing all seven weekdays, are taken on at a roster place; "Gym" is
  removed there as of 31 January 2026; and a day screen of no commitments at all is opened at that
  roster place as of Monday 31 August 2026, at a record place where nothing has been kept
- **THEN** its day picker reaches back to 1 January 2026
- **AND** its day view holds one row, named "Run"

#### Scenario: a day screen's day picker reaches back to the day it is showing where that is the earlier of the two

- **WHEN** a day screen is opened as of Thursday 1 January 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 June 2026
- **THEN** its day picker opens on Thursday 1 January 2026 and reaches back to Thursday 1 January
  2026
- **AND** moved to the day before, its day picker opens on Wednesday 31 December 2025 and reaches
  back to Wednesday 31 December 2025

#### Scenario: a day screen that cannot read its roster reaches back to the today it was handed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of
  a commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** it says it is not keeping a roster
- **AND** its day picker opens on Monday 31 August 2026 and reaches back to Monday 31 August 2026
- **AND** moved to the day before, its day picker reaches back to Sunday 30 August 2026

#### Scenario: a day screen that takes on the commitments it was handed reaches back to the earliest of those

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding nothing at
  all, at a record place where nothing has been kept, of a commitment named "Gym" kept from
  1 March 2026 and one named "Journaling" kept from 1 February 2026, both on a schedule listing all
  seven weekdays
- **THEN** its day picker reaches back to 1 February 2026, those two having been taken on
- **AND** a second day screen opened as of that same day, at a roster place of its own also holding
  nothing at all and handed no commitments at all, reaches back to Monday 31 August 2026

#### Scenario: a day screen's day picker reaches back to the first supported date and opens on the last

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 1583
- **THEN** its day picker reaches back to 1 January 1583
- **AND** a second day screen opened the same way as of Friday 31 December 9999 opens on Friday
  31 December 9999 and reaches back to 1 January 1583

#### Scenario: a day screen's day picker reaches back to the day a commitment is kept from though nothing is due on that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Finances" on a schedule on the 25th of the
  month, kept from 1 January 2026, and one named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 March 2026
- **THEN** its day picker reaches back to 1 January 2026, and neither to 25 January 2026 nor to
  1 March 2026
- **AND** its day view holds one row, named "Journaling"

### Requirement: A day screen's reach bounds its day picker and is read again whenever its roster is

The reach SHALL bound the day picker and never the screen: *A day screen moves the day it is showing
one calendar day either way* is unchanged by it and MUST NOT be read as narrowed by it. What is
bounded SHALL be what a person may pick and what showing a picked day accepts. Nothing SHALL be
answered about whether the day picker is offered. The answer MUST NOT give out the today the screen
was last handed, under any name. It SHALL take no day from the caller and read no clock. It SHALL be
read again whenever the roster is, and reading it SHALL move no day: where the earliest day it
reaches rises, the screen SHALL go on showing its day and the reach SHALL reach less far. The answer
SHALL be about the roster the screen holds and the day being shown, and nothing else.

#### Scenario: a day screen whose roster stops being readable goes on showing its day and reaches back to it

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2020, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; it
  is moved to the day before; that roster place is then made to hold a run of bytes that is not
  what a roster is written as; and the screen is returned to
- **THEN** its day picker opens on Sunday 30 August 2026 and reaches back to Sunday 30 August
  2026
- **AND** before it was returned to, its day picker reached back to 1 January 2020

#### Scenario: a day screen that cannot read its record says the reach of its day picker like any other

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place holding a run of
  bytes that is not what a record is written as, of a commitment named "Journaling" on a schedule
  listing all seven weekdays, kept from 1 January 2026
- **THEN** it says it is not keeping a record
- **AND** its day picker opens on Monday 31 August 2026 and reaches back to 1 January 2026

#### Scenario: a day screen shown again reads the reach of its day picker off the roster it then reads

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2020, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on that same schedule, kept from 1 January 2010, is then taken on at that
  roster place by something else; and the app is shown again as of Monday 31 August 2026
- **THEN** its day picker reaches back to 1 January 2010
- **AND** before the app was shown again, its day picker reached back to 1 January 2020

### Requirement: A day screen asked the day either side reads neither place again and is left exactly as it was

Saying either SHALL read neither place again: the roster asked SHALL be the one read when the app
was last shown or the screen was last returned to, whichever happened later, and the record the one
the screen last read, each with every change kept since. Saying either SHALL change nothing about
the screen: the day being shown SHALL be the day it was, the today SHALL NOT move, nothing SHALL be
kept at either place, and what the screen is telling on a row SHALL be left exactly as it was. Both
SHALL follow the day being shown, whatever put the screen on it, and SHALL be formed from the roster
and the record then held. A day screen not keeping a record or not keeping a roster SHALL say them
like any other, and what it says about either place SHALL be untouched by being asked.

#### Scenario: saying the day either side of a day screen leaves the day it is showing exactly as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the day views it says of the day before and of the day after are both read
- **THEN** its day view is the same day view as the one it held when it was opened
- **AND** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: a day screen moved to another day says the day either side of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and it is moved to the day after
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Monday 31 August 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Wednesday 2 September 2026 from that same history

#### Scenario: a day screen sent back to today says the day either side of that today

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before three times; and it is then sent back to today
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Sunday 30 August 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Tuesday 1 September 2026 from that same history

#### Scenario: a day screen showing a day picked on its day picker says the day either side of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and Friday 25 September 2026 is picked on its day picker
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Thursday 24 September 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Saturday 26 September 2026 from that same history

#### Scenario: a day screen shown again on a new day says the day either side of that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and the app is then shown again as of Wednesday 2 September 2026
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Tuesday 1 September 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Thursday 3 September 2026 from that same history

#### Scenario: saying the day either side of a day screen does not read its record or its roster again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on a schedule listing all seven weekdays, kept from that same day, is then
  taken on at that roster place by something else, and a tick for "Journaling" on Sunday 30 August
  2026 is kept at that record place by something else
- **THEN** the day view it says of the day before holds one row, named "Journaling", saying the
  commitment is not kept
- **AND** the day view it says of the day after holds one row, named "Journaling"
- **AND** it says it is keeping a roster and keeping a record, exactly as it did before

#### Scenario: a day screen that cannot read its record says the day either side of it with nothing kept

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes that
  is not what a record is written as, of a commitment named "Journaling" on a schedule listing all
  seven weekdays, kept from 1 January 2026
- **THEN** the day view it says of the day before is the same day view as one formed directly of that
  commitment on Sunday 30 August 2026 from a history that has taken no tick
- **AND** the day view it says of the day after is the same day view as one formed directly of that
  commitment on Tuesday 1 September 2026 from that same history
- **AND** it says it is not keeping a record

#### Scenario: a day screen that cannot read its roster says the day either side of it and neither holds rows

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of a
  commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** the day view it says of the day before holds no rows
- **AND** the day view it says of the day after holds no rows
- **AND** it says it is not keeping a roster

#### Scenario: a day screen goes on telling what it was telling on a row when it is asked the day either side of it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Journaling" on a
  schedule listing all seven weekdays, kept from 1 January 2026; its one row is ticked and the
  change is refused; and the day views it says of the day before and of the day after are then both
  read
- **THEN** it is still telling, on that row, that the change could not be kept
- **AND** its day view is the same day view as the one it held when it was opened

#### Scenario: a day screen returned to says the day either side of it from the roster it then holds

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on a schedule listing all seven weekdays, kept from that same day, is then
  taken on at that roster place by something else; and the screen is returned to
- **THEN** the day view it says of the day before holds two rows, named "Journaling" and then "Gym"
- **AND** the day view it says of the day after holds two rows, named "Journaling" and then "Gym"

#### Scenario: saying the day either side of a day screen keeps nothing at either place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place and a roster place
  where nothing has been kept, of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026; the roster place is read; and the day views it says of the
  day before and of the day after are both read
- **THEN** nothing has been kept at its record place
- **AND** the content at its roster place is byte-for-byte what it was before those day views were
  read

### Requirement: A day screen makes and takes back the tick a row offers, and keeps the change before the day view says so

A day screen SHALL make the tick one of its rows offers and SHALL take that same tick back where the
row says its commitment is kept; which of the two a tap means SHALL be read off the row and MUST NOT
be given to the screen. The tick SHALL be the one the row offers asked as of the today the screen
was handed, never as of the day it is showing, so moving a screen forward MUST NOT make a tick
formable that was not formable before. A row the screen's day view does not hold SHALL change
nothing at all.

The change SHALL be kept at the screen's record place before its day view says so, the day view then
being formed again, on the day the screen is showing, from the record as it stands and the
commitments its roster answers with on that day. A change that could not be kept SHALL be refused,
SHALL be reported to the caller rather than passed over, and SHALL leave the day view exactly as it
was. Making a tick or taking one back MUST NOT write to the roster's place, and MUST NOT change what
the screen says about its roster.

#### Scenario: ticking a row that says its commitment is kept takes the tick back

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; its one row is ticked; and the row the day screen then holds is ticked again
- **THEN** the day screen's day view says the commitment is not kept on that date
- **AND** its day view is the same day view as the one the screen held when it was opened

#### Scenario: a tick taken back on a day screen is not held by a day screen opened afterwards at the same place

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; its one row is ticked and the resulting row ticked again; and a second day screen
  of the same commitment is then opened at the same place as of the same day
- **THEN** the second day screen's day view says the commitment is not kept on that date

#### Scenario: ticking one row leaves the other rows of the day as they were

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, a
  commitment named "Journaling" on a schedule listing all seven weekdays and a commitment named
  "Supplements and habits" on that same schedule, in that order and all kept from 1 January 2026,
  and the second of its three rows is ticked
- **THEN** the day screen's day view holds three rows in that same order
- **AND** only the second says its commitment is kept

#### Scenario: a change that cannot be kept is refused and leaves the day view as it was

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing can be
  written — a path beneath an existing ordinary file — of a commitment named "Gym" on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, and its one row is ticked
- **THEN** ticking is refused with an error
- **AND** the day screen's day view still says the commitment is not kept on that date
- **AND** a day screen opened afterwards at the same place says the same

#### Scenario: a row the day screen's day view does not hold changes nothing

- **WHEN** two day screens of a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, are opened at one place where nothing has been kept, the first
  as of Monday 31 August 2026 and the second as of Wednesday 2 September 2026, and the second
  screen's row is ticked on the first screen
- **THEN** the first day screen's day view still says the commitment is not kept on Monday 31 August
  2026
- **AND** a day screen opened afterwards at that place as of Wednesday 2 September 2026 says the
  commitment is not kept on that date either

#### Scenario: ticking a row on a day a day screen has moved back to keeps the tick on that day

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; and its one row is ticked
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** a day screen opened afterwards at that place as of Sunday 30 August 2026 says the
  commitment is kept on that date
- **AND** a day screen opened afterwards at that place as of Monday 31 August 2026 says the
  commitment is not kept on that date

#### Scenario: ticking a row on a day a day screen has moved onto that has not arrived keeps nothing

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day after; and its one row is ticked
- **THEN** its day view still says the commitment is not kept on Tuesday 1 September 2026
- **AND** a day screen opened afterwards at that place as of Tuesday 1 September 2026 says the
  commitment is not kept on that date

#### Scenario: a tick made on a day screen does not change what it says about its roster

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026; its roster place is then made to hold a run of bytes that is
  not what a roster is written as; and its one row is ticked
- **THEN** it says it is keeping a roster, exactly as it did before the tick
- **AND** its day view holds one row, named "Journaling", saying the commitment is kept on that date

### Requirement: A day screen re-reads its day and its places when the app is shown again

A day screen SHALL be told when the app has been shown — opened from nothing, or brought back in
front of a person — and SHALL be handed the day it has been shown on. It SHALL then take that day as
its today and form its day view again from the record and the roster read again at their places,
whatever day it is showing, a tick made on it being no such moment. A day screen showing the day it
was last handed as today SHALL show the day it has now been shown on, and one showing any other day
SHALL go on showing that day; that comparison SHALL be made against the today the screen held before
it was told, and against nothing kept for the purpose. A day screen shown again on the day it is
already showing SHALL hold that day's day view, formed again rather than merely kept.

Reading either place again SHALL be a fresh opening there, so a change made since SHALL be seen, and
what the screen says about the record and about the roster SHALL each be formed again from what is
then there, the reason included and nothing carried over. A roster read again that holds nothing at
all SHALL have the commitments the screen was handed taken on into it. Nothing else SHALL survive
being shown again: those commitments, the two places and the day it is showing are all a day screen
carries across.

#### Scenario: a day screen shown again on a later day holds that day's day view

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Run" on a schedule listing Tuesday, Thursday and Sunday, both kept from 1 January
  2026, and it is then shown as of Tuesday 1 September 2026
- **THEN** its day view holds one row, for "Run"

#### Scenario: a day screen shown again on the day it is already on holds that day's day view

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, and it is then shown as of Monday 31 August 2026
- **THEN** its day view is the same day view as the one it held when it was opened

#### Scenario: a day screen that could not read its record starts keeping one when it is shown again and the record can be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a run of bytes
  that is not what a record is written as, of a commitment named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026; what is at that place is then replaced by a
  record holding a tick for that commitment on that date; and the day screen is shown as of Monday
  31 August 2026
- **THEN** it says it is keeping a record
- **AND** its day view says the commitment is kept on that date

#### Scenario: a day screen that was keeping a record stops when it is shown again and the record cannot be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; what is at that place is then replaced by a run of bytes that is not what a record
  is written as; and the day screen is shown as of Monday 31 August 2026
- **THEN** it says it is not keeping a record
- **AND** its day view says the commitment is not kept on that date

#### Scenario: a day screen shown again where the record is from a later version says so

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026; what is at that place is then replaced by a record written in a form one later
  than the form this app writes, holding no ticks; and the day screen is shown as of Monday 31
  August 2026
- **THEN** it says it is not keeping a record
- **AND** it says the record was written by a later version of DayByDay
- **AND** its day view says the commitment is not kept on that date

#### Scenario: a day screen does not change day when a tick is made on it

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Run" on a schedule listing Tuesday, Thursday and Sunday, both kept from 1 January
  2026, and its one row is ticked
- **THEN** its day view is the same day view as one formed directly of those two commitments, in
  that order, on Monday 31 August 2026, from a history holding exactly that one tick

#### Scenario: a day screen shown again reads its roster again

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from that same
  day, is then taken on at that roster place by something else; and the day screen is shown as of
  Monday 31 August 2026
- **THEN** its day view holds two rows, named "Journaling" and then "Gym"

#### Scenario: a day screen that could not read its roster starts keeping one when it is shown again and the roster can be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place holding a run of
  bytes that is not what a roster is written as, at a record place where nothing has been kept, of a
  commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January
  2026; what is at that roster place is then replaced by a roster that has been given a commitment
  named "Journaling" on a schedule listing all seven weekdays, kept from that same day; and the day
  screen is shown as of Monday 31 August 2026
- **THEN** it says it is keeping a roster
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen that was keeping a roster stops when it is shown again and the roster cannot be read

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a roster place and a record place
  where nothing has been kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026; what is at that roster place is then replaced by a roster
  written in a form one later than the form this app writes, holding no commitments; and the day
  screen is shown as of Monday 31 August 2026
- **THEN** it says it is not keeping a roster
- **AND** it says the roster was written by a later version of DayByDay
- **AND** its day view holds no rows

#### Scenario: a day screen moved off today keeps the day it is showing when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before; and the app is then shown again as of Wednesday
  2 September 2026
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Sunday 30 August 2026, from a history that has taken no tick
- **AND** its day picker opens on Sunday 30 August 2026, and it offers the way back to today

#### Scenario: a day screen moved away and back onto today moves onto the new day when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and a
  commitment named "Journaling" on a schedule listing all seven weekdays, in that order and both kept
  from 1 January 2026; it is moved to the day before and then to the day after; and the app is then
  shown again as of Wednesday 2 September 2026
- **THEN** its day view is the same day view as one formed directly of those two commitments, in that
  order, on Wednesday 2 September 2026, from a history that has taken no tick
- **AND** its day picker opens on Wednesday 2 September 2026, and it offers no way back to today

#### Scenario: a day screen sent back to today moves onto the new day when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before three times; it is sent back to today; and the app is
  then shown again as of Wednesday 2 September 2026
- **THEN** its day picker opens on Wednesday 2 September 2026, and it offers no way back to today

#### Scenario: a day screen kept on a day that has since arrived offers the tick it refused before

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day after, onto Tuesday 1 September 2026, and its one row is
  ticked; the app is then shown again as of Tuesday 1 September 2026; and the one row it then holds
  is ticked
- **THEN** the first ticking left the day view saying the commitment is not kept
- **AND** after being shown again its day picker opens on Tuesday 1 September 2026, and it offers
  no way back to today
- **AND** the second ticking makes its day view say the commitment is kept on Tuesday 1 September
  2026

#### Scenario: a day screen moved off today reads its record again when the app is shown again

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026; it is moved to the day before; a tick for that commitment on Sunday 30 August 2026
  is then kept at that place by something else; and the app is shown again as of Monday 31 August
  2026
- **THEN** its day view says the commitment is kept on Sunday 30 August 2026
- **AND** its day picker still opens on Sunday 30 August 2026, the screen not having moved

#### Scenario: a day screen shown again carries over no reason it gave for not keeping its record or its roster

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a record place holding a record
  and a roster place holding a roster, each written in a form one later than the form this app
  writes and holding nothing, of a commitment named "Gym" on a schedule listing Monday, Wednesday
  and Saturday, kept from 1 January 2026; what is at each place is then replaced by a run of bytes
  that is not what a record or a roster is written as; and the app is shown again as of Monday
  31 August 2026
- **THEN** it says it is not keeping a record, and does not say the record was written by a later
  version of DayByDay
- **AND** it says it is not keeping a roster, and does not say the roster was written by a later
  version of DayByDay

### Requirement: A day screen tells nothing on a row where there was no change to refuse

A tap or a commit that never reaches the record's place is not a refused change: apart from the four
causes named above, a day screen SHALL tell nothing on its row and SHALL NOT end what it is already
telling on another row. It SHALL tell nothing for a tap or commit on a day screen not keeping a
record, whatever the reason its store would not open and whatever was committed, a refused value
included; for one on a row for a day that has not arrived; for one on a row the screen's day view
does not hold; and for a commit on a row that offers no entry at all, or a take-back asked of a row
offering none, whatever makes it offer none. A commit in a total entry that says nothing SHALL
likewise be told nothing and SHALL NOT end what is already told.

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

#### Scenario: a tap on a row a day screen's day view does not hold does not end what is already told

- **WHEN** two day screens of a commitment named "Journaling" on a schedule listing all seven
  weekdays, kept from 1 January 2026, are opened at one place where nothing can be written — a
  path beneath an existing ordinary file — the first as of Monday 31 August 2026 and the second as
  of Wednesday 2 September 2026; the first screen's own row is ticked; and the second screen's row
  is then ticked on the first screen
- **THEN** the first day screen still tells, on its own row, that the change could not be kept

#### Scenario: a commit on a row for a day that has not arrived is told nothing on the row

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place where nothing has been
  kept, of a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026; it is moved to the day after; and "300" is
  committed on its one row
- **THEN** the day screen tells nothing on any row
- **AND** its day view still says the commitment is not kept on Tuesday 1 September 2026

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

#### Scenario: a commit on a day screen holding a record from a later version is told nothing whatever was committed

- **WHEN** a day screen is opened as of Monday 31 August 2026, at a place holding a record written
  in a form one later than the form this app writes, holding nothing, of a commitment named "Weight"
  of the number kind with a range of 40 to 150, one named "Journal" of the note kind and one named
  "Protein" of the total kind with a target of 120, all three on a schedule listing Monday,
  Wednesday and Saturday and kept from 1 January 2026; and "300" and then "1.2.3" are committed on
  the row named "Weight", "Ran 8k." and then nothing at all on the row named "Journal", and "0" on
  the row named "Protein"
- **THEN** no commit is refused with an error
- **AND** the day screen tells nothing on any row
- **AND** it says the record was written by a later version of DayByDay

### Requirement: A day screen reads its roster again whenever it is returned to

A day screen returned to SHALL read its roster place again and SHALL form its day view from the
roster it then reads. Being returned to SHALL NOT take a new today nor move the day being shown. It
SHALL read its record place again where it is keeping a record and SHALL NOT where it is not: a
screen not keeping one does not start by being returned to, and that state, with anything else that
lasts until the app is shown again, SHALL stand across being returned to. What a day screen tells on
a row ends on exactly three things, of which being returned to is not one; it SHALL go on telling
it. Where the roster it then reads holds nothing at all, it SHALL take on the commitments it was
handed; where that place cannot be read, it SHALL say so and draw no rows.

#### Scenario: a commitment taken on at a day screen's roster place is drawn when the screen is returned to

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; a
  commitment named "Gym" on that same schedule, kept from that same day, is then taken on at that
  roster place by something else; and the day screen is returned to
- **THEN** its day view holds two rows, named "Journaling" and then "Gym"
- **AND** the day view it held before it was returned to held one row, named "Journaling"

#### Scenario: a commitment stopped at a day screen's roster place is not drawn when the screen is returned to

- **WHEN** a commitment named "Journaling" and one named "Gym", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a day screen of no
  commitments at all is opened at that roster place as of Monday 31 August 2026, at a record place
  where nothing has been kept; "Gym" is then stopped at that roster place by something else, as of
  Sunday 30 August 2026; and the day screen is returned to
- **THEN** its day view holds one row, named "Journaling"

#### Scenario: a day screen returned to goes on showing the day it was showing

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; it
  is moved to the day before; and it is returned to
- **THEN** its day picker opens on Sunday 30 August 2026
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen returned to keeps the today it was handed

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept; and
  it is returned to
- **THEN** its day picker opens on Monday 31 August 2026, and it offers no way back to today

#### Scenario: a day screen returned to does not read its record again

- **WHEN** a run of bytes that is not a record store is written at a record place; a day screen of
  a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is opened as of Monday 31 August 2026 at that record place and at a roster place
  where nothing has been kept; what is at the record place is removed, so that nothing has been kept
  there and the place reads clean; and the day screen is returned to
- **THEN** it still says it is keeping no record
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen that could not read its roster starts keeping one when it is returned to and the roster can be read

- **WHEN** a run of bytes that is not a roster store is written at a roster place; a day screen of
  no commitments at all is opened at that place as of Monday 31 August 2026, at a record place where
  nothing has been kept; what is at the roster place is replaced with a roster store holding a
  commitment named "Journaling" on a schedule listing all seven weekdays, kept from 1 January 2026;
  and the day screen is returned to
- **THEN** it says it is keeping a roster
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen returned to on a roster that holds nothing takes the commitments it was handed on again

- **WHEN** a day screen of a commitment named "Journaling" on a schedule listing all seven weekdays,
  kept from 1 January 2026, is opened as of Monday 31 August 2026 at a roster place where nothing
  has been kept and a record place where nothing has been kept; everything kept at the roster place
  is removed; and the day screen is returned to
- **THEN** a roster store opened afterwards at that place holds one commitment, named "Journaling"
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a day screen returned to goes on telling what it was telling on a row

- **WHEN** a day screen of no commitments at all is opened as of Monday 31 August 2026 at a roster
  place holding a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, and at a record place where nothing can be written — a path beneath an existing
  ordinary file; its one row is ticked and refused; and the day screen is returned to
- **THEN** it still tells, on that row, that the change could not be kept
- **AND** its day view holds one row, named "Journaling"

#### Scenario: a commitment renamed at a day screen's places is drawn under its new name and still kept when the screen is returned to

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 31 August 2026 is kept at a
  record place; a day screen of no commitments at all is opened at that roster place and that record
  place as of Monday 31 August 2026; that commitment is then changed at both places by something else
  to the name "Gym 🏋️"; and the day screen is returned to
- **THEN** its day view holds one row, named "Gym 🏋️"
- **AND** that row says its commitment was kept

#### Scenario: a day screen returned to where its roster cannot be read says so and draws no rows

- **WHEN** a commitment named "Journaling" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a day screen of no commitments at all is opened at
  that roster place as of Monday 31 August 2026, at a record place where nothing has been kept;
  that roster place is then made to hold a run of bytes that is not what a roster is written as;
  and the day screen is returned to
- **THEN** it says it is not keeping a roster
- **AND** its day view holds no rows
- **AND** before it was returned to, its day view held one row, named "Journaling"

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
  named "Mood" of the number kind with a range of 1 to 10, in that order, both on a schedule listing
  Monday, Wednesday and Saturday and both kept from 1 January 2026; nothing at all is committed on
  the row named "Mood"; and nothing at all is then committed on the row named "Weight"
- **THEN** committing on the row named "Mood" is not refused and the day screen tells nothing
- **AND** committing on the row named "Weight" is refused with an error
- **AND** the day screen then tells, on the row named "Weight", that the change could not be kept
- **AND** its day view still says "Weight" holds the number 70.5 on that date
