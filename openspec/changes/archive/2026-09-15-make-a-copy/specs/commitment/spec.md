## MODIFIED Requirements

### Requirement: A commitments screen holds the change it refused and why it was refused, one at a time

Where a change asked of a commitments screen is refused, the screen SHALL hold which change was
asked for and why it was refused, as well as answering the refusal to the caller. The change held
SHALL be one of the nine a person can ask for — defining a commitment, stopping keeping one, taking
a stopped one up again, removing one, moving one, moving a whole group, changing one, restarting
one, making a copy — and for the six asked about a commitment already on one of its lists it SHALL
name that commitment: the one it was asked about, not the one the change would have produced. A
refused group move SHALL name the category instead, and a refused copy SHALL name the store that
could not be read, or no store at all where the copy could not be written. The nine are counted here
and numbered nowhere else: a requirement that introduces one SHALL name it, and SHALL NOT identify
it by its position among them.

Why it was refused SHALL be the same refusal answered to the caller and no more, and a commitments
screen SHALL hold no words a person reads. It SHALL hold at most one refused change at a time, the
change asked for last. A call asking for no change at all SHALL NOT be a refusal, and each SHALL
leave the screen holding no refused change and leave whatever it holds exactly as it was: a stop
asked about a commitment it does not keep; a stop confirmed with nothing awaiting confirmation; a
take-up-again of one it has not stopped; a removal asked about a commitment on neither list; a
removal confirmed with nothing awaiting removal; a removal confirmed while the name typed back does
not match; a move of one it does not keep; a move into a group it draws none of, or to an offset
that group does not have; a group move of a group it draws none of, those under no category among
them, or to an offset its category groups do not have; a change asked about a commitment on neither
list; and a change that names what a commitment already is. A name typed back that does not match is
not a refusal.

#### Scenario: a commitments screen holds a refused definition against defining a commitment

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it
- **THEN** it is refused as a name that says nothing
- **AND** the screen holds that refusal, against defining a commitment

#### Scenario: a commitments screen holds a refused take-up-again against the commitment it was asked to take up again

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped there as of Sunday 30 August 2026; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; what is at that
  place is then made impossible to write; and "Gym" is taken up again through the screen
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against taking "Gym" up again

#### Scenario: a commitments screen refused twice holds only the change it was asked for last

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; what is at that place is then made impossible to write; a commitment
  named "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined
  through the screen; and the screen is then asked to stop keeping "Gym" and the stop is confirmed
- **THEN** the screen holds one refused change, which is a roster that could not be written against
  stopping keeping "Gym"
- **AND** it holds nothing against defining a commitment

#### Scenario: a commitments screen holds nothing against a call that changes nothing at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; the screen is asked to stop keeping a commitment named "Journaling"
  on that same schedule and kept-from day, formed directly and never taken on; a stop is then
  confirmed with nothing awaiting confirmation; and "Gym", which has not been stopped, is taken up
  again through the screen
- **THEN** nothing is refused by any of the three
- **AND** the screen holds no refused change

#### Scenario: a commitments screen holds a refused removal against the commitment it was asked to remove

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to remove "Gym" and "Gym" is typed back; what is at that
  place is then made impossible to write; and the removal is confirmed
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against removing "Gym"
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitments screen holds nothing against a removal confirmed on a name that does not match

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; it is asked to remove "Gym";
  "Gymm" is typed back; and the removal is confirmed
- **THEN** the removal refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one entry, named "Gym", and "Gym" is still awaiting removal

#### Scenario: a commitments screen holds a refused move against the commitment it was asked to move

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, and one named "Journaling" alike in every other way are taken on at a roster place;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; what is at that
  place is then made impossible to write; and "Journaling" is moved to the offset 0
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against moving "Journaling"
- **AND** what it keeps is two entries, named "Gym" and then "Journaling"

#### Scenario: a commitments screen holds nothing against a move that asks for no change at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to move a commitment named "Journaling" on that same
  schedule and kept-from day, formed directly and never taken on, to the offset 0; and "Gym" is then
  moved to the offset 2, which a list of one commitment does not have
- **THEN** neither is refused
- **AND** the screen holds no refused change
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitments screen holds a refused category change against the commitment it was asked about

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; what is at that place is then made impossible to write; and "Gym" is
  changed through the screen to the category "Sport", on the name, the rhythm and the day kept from
  it already has
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against changing "Gym"
- **AND** what it keeps is one group, with no category, holding "Gym"

#### Scenario: a commitments screen holds nothing against a category change that asks for no change at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and put under the category "Sport" there; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it
  and refused; and "Gym" is changed through the screen to the category "Sport" it is already under,
  on the name, the rhythm and the day kept from it already has
- **THEN** the category change refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym"

#### Scenario: a commitments screen holds a refused group move against the category it was asked to move

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; what is at that place is then made impossible to write;
  and the group "Sport" is moved to the offset 0
- **THEN** it is refused as a roster that could not be written
- **AND** the screen holds that refusal, against moving the group "Sport"
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then "Sport" holding
  "Gym"

#### Scenario: a commitments screen holds nothing against a group move that asks for no change at all

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; the group "Sport", which nothing it keeps is under, is moved to the offset 0; the
  group under no category is moved to the offset 0; and the group "Supplements" is then moved to the
  offset 2, which one group under a category does not have
- **THEN** none of the three is refused
- **AND** the screen holds no refused change
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"

#### Scenario: a commitments screen holds a refused change against the commitment it was asked to change

- **WHEN** a commitment named "Gym" and one named "Run", both on a schedule listing all seven weekdays
  and kept from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; and "Gym" is changed through it to the name "Run", under
  no category
- **THEN** it is refused as a commitment already kept
- **AND** the screen holds that refusal, against changing "Gym"

#### Scenario: a commitments screen holds nothing against a change that asks for no change at all

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is removed there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", under no category
- **THEN** the screen holds no refused change
- **AND** a change of "Journaling" to exactly the name, rhythm, day kept from and category it already
  has leaves the screen holding no refused change either

#### Scenario: what a commitments screen holds about a refused change stands when a stop is asked about a commitment it does not keep

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to stop keeping "Journaling"
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a removal is asked about a commitment on neither of its lists

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to remove a commitment named "Run" alike in every other way to "Gym" and never taken on
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a removal is confirmed with nothing awaiting removal

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to confirm a removal with nothing awaiting removal
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a move is asked about a commitment it does not keep

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to move "Journaling" to the offset 0
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a commitment is dropped in a group it draws none of

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to move "Gym" to the offset 0 in the group "Evening"
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a commitment is dropped at an offset its group does not have

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to move "Gym" to the offset 2 in the group "Sport"
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a group it draws none of is moved

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to move the group under no category to the offset 0, and then the group "Evening" to the
  offset 0
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a group is moved to an offset its groups do not have

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to move the group "Sport" to the offset 2
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: what a commitments screen holds about a refused change stands when a change is asked about a commitment on neither of its lists

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, under the category "Sport", and one named "Journaling" alike in every other way but under no
  category, are taken on at a roster place, and "Journaling" is stopped there as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the screen is then
  asked to change a commitment named "Run" alike in every other way to "Gym" and never taken on to
  the name "Running", under no category
- **THEN** that call refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is one group, "Sport", holding "Gym", and what it has stopped is one entry,
  named "Journaling"

#### Scenario: a commitments screen holds a refused copy against making a copy, naming the store that could not be read

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster
  place, a record place and a one-off place where nothing has been kept as of Monday 31 August 2026;
  what is at that record place is then made a run of bytes that is not a record; and a copy is asked
  for as of that day at 14:32
- **THEN** it is refused as a store that could not be read
- **AND** the screen holds that refusal, against making a copy, naming the record
- **AND** a copy asked for at a readable record place but written into a directory that cannot be
  written to is held against making a copy naming no store, as a place that could not be written

### Requirement: What a commitments screen holds about a refused change lasts until the app is shown again or a change is kept

A commitments screen SHALL go on holding a refused change until one of exactly two things happens, and
SHALL then hold nothing. Nothing else SHALL end it, and time passing in particular SHALL NOT. The app
being shown again SHALL end it, whether or not the roster can then be read. A change reaching a place
SHALL end it, whichever kind it was and whichever change was refused before it — a commitment defined
and taken on, a stop kept, a take-up-again kept, a removal kept, a move kept, a group move kept, a
change of a commitment kept — and a change that writes nothing but a category SHALL be one of the last
of those rather than a kind of its own. A change of a commitment reaches the record place as well as
the roster place, and SHALL end what is held once it has been kept: one act, one outcome, however many
places it touched.

A call that reaches the place with no change to make SHALL NOT end it: a move dropping a commitment
where it already is, a group move leaving a group where it is drawn, a change naming what a commitment
already is — the category it is already under among the fields it names — and a change asked
about a commitment on neither of the screen's lists. Nor SHALL putting a stop or a removal up for
confirmation, typing a name back, or cancelling either end it: none reaches the roster place. Nor
SHALL a copy made end it: the file a copy is written at is not a place this screen keeps a change
at.

#### Scenario: what a commitments screen holds about a refused change ends when the app is shown again

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and the app is then shown again as of
  that same day
- **THEN** the screen holds no refused change
- **AND** it says it is keeping a roster

#### Scenario: what a commitments screen holds about a refused change ends when the app is shown again where the roster then cannot be read

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; what is at that place is then made impossible to write; the screen is
  asked to stop keeping "Gym" and the stop is confirmed and refused; and the app is then shown again
  as of that same day
- **THEN** the screen holds no refused change
- **AND** it says it is not keeping a roster

#### Scenario: what a commitments screen holds about a refused change ends when a commitment is defined and kept

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and a commitment named "Journaling" on
  that same rhythm and kept-from day is then defined through it
- **THEN** "Journaling" is not refused
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change ends when a stop is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and the screen is then asked
  to stop keeping "Gym" and the stop is confirmed
- **THEN** the stop is not refused
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change ends when a commitment is taken up again and kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and stopped there as of Sunday 30 August 2026; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through
  it and refused; and "Gym" is then taken up again through the screen
- **THEN** taking "Gym" up again is not refused
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change stands when a call changes nothing at all

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; "Gym", which has not been
  stopped, is then taken up again through the screen; and a stop is then confirmed with nothing
  awaiting confirmation
- **THEN** the screen still holds a name that says nothing, against defining a commitment

#### Scenario: what a commitments screen holds about a refused change stands when a stop is asked for and cancelled

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and the screen is then asked
  to stop keeping "Gym" and the stop is cancelled
- **THEN** the screen still holds a name that says nothing, against defining a commitment
- **AND** nothing is awaiting confirmation

#### Scenario: what a commitments screen holds about a refused change ends when a removal is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and the screen is then asked
  to remove "Gym", "Gym" is typed back, and the removal is confirmed
- **THEN** the removal is not refused
- **AND** the screen holds no refused change
- **AND** "Gym" is in neither of its lists

#### Scenario: what a commitments screen holds about a refused change stands when a removal is asked for and cancelled

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and the screen is then asked
  to remove "Gym", "Gym" is typed back, and the removal is cancelled
- **THEN** the screen still holds a name that says nothing, against defining a commitment
- **AND** nothing is awaiting removal and nothing has been typed back

#### Scenario: what a commitments screen holds about a refused change ends when a move is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, and one named "Journaling" alike in every other way are taken on at a roster place;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it
  and refused; and "Journaling" is then moved to the offset 0
- **THEN** the move is not refused
- **AND** the screen holds no refused change
- **AND** what it keeps is two entries, named "Journaling" and then "Gym"

#### Scenario: what a commitments screen holds about a refused change stands when a move drops a commitment where it already is

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, and one named "Journaling" alike in every other way are taken on at a roster place;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it
  and refused; and "Journaling" is then moved to the offset 2
- **THEN** the move is not refused
- **AND** the screen still holds a name that says nothing, against defining a commitment
- **AND** what it keeps is two entries, named "Gym" and then "Journaling"

#### Scenario: what a commitments screen holds about a refused change ends when a category change is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it and refused; and "Gym" is changed through
  it to the category "Sport", on the name, the rhythm and the day kept from it already has
- **THEN** the screen holds no refused change
- **AND** what it keeps is one group, "Sport", holding "Gym"

#### Scenario: what a commitments screen holds about a refused change stands when a category change puts a commitment under the category it is already under

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place and put under the category "Sport" there; a
  commitments screen is opened at that roster place as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through
  it and refused; and "Gym" is changed through it to the category "Sport" it is already under, on the
  name, the rhythm and the day kept from it already has
- **THEN** the second change refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment

#### Scenario: what a commitments screen holds about a refused change ends when a group move is kept

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the group "Sport"
  is then moved to the offset 0
- **THEN** the group move refuses nothing
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change stands when a group move leaves a group where it is

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and "Gym" under "Sport"; a commitments screen is opened at that
  roster place as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it and refused; and the group
  "Supplements" is then moved to the offset 0
- **THEN** the group move refuses nothing
- **AND** the screen still holds a name that says nothing, against defining a commitment

#### Scenario: what a commitments screen holds about a refused change ends when a change to a commitment is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and "Gym" is then changed through it to
  the name "Gym 🏋️", under no category
- **THEN** the change is not refused
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change stands when a change names what is already there

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; a commitment named "   " on a weekday-set rhythm of all seven weekdays,
  kept from that same day, is defined through it and refused; and "Gym" is then changed through it to
  exactly the name, rhythm, day kept from and category it already has
- **THEN** the screen still holds a name that says nothing, against defining a commitment

#### Scenario: what a commitments screen holds about a refused change ends when a change of rhythm is kept

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through
  it and refused; and "Gym" is then changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category
- **THEN** the change is not refused
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change ends when a name and a rhythm changed in one save are kept

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; a commitment named
  "   " on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through
  it and refused; and "Gym" is then changed through it to the name "Gym 🏋️" on a weekday-set rhythm
  of Tuesday and Thursday, under no category
- **THEN** the change is not refused
- **AND** the screen holds no refused change

#### Scenario: what a commitments screen holds about a refused change ends when a change kept at both places is kept

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record
  place; a commitments screen is opened at that roster place and that record place as of Monday 31
  August 2026; a commitment named "   " on a weekday-set rhythm of all seven weekdays, kept from
  that same day, is defined through it and refused; and "Gym" is then changed through it to the name
  "Gym 🏋️", under no category
- **THEN** the change is not refused and the screen holds no refused change
- **AND** a store opened afterwards at that record place answers that "Gym 🏋️" was kept on Monday 3
  August 2026


#### Scenario: a copy made does not end what a commitments screen holds about a refused change

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster
  place, a record place and a one-off place where nothing has been kept as of Monday 31 August 2026;
  a commitment named "   " on a weekday-set rhythm of all seven weekdays, kept from that same day,
  is defined through it and refused; and a copy is asked for as of that day at 14:32, written into a
  directory of its own
- **THEN** the copy is not refused
- **AND** the screen still holds a name that says nothing, against defining a commitment
