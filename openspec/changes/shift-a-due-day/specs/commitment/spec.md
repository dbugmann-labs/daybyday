## ADDED Requirements

### Requirement: A roster shifts a due day of a commitment it holds onto a free day of that day's week

A roster SHALL shift a due day of a commitment it holds, kept or stopped, only where the era holding
it runs on a weekday set or a day of the month, and only onto a free day of it, and SHALL refuse
every other shift, changing nothing, a day the commitment is not due on and a commitment it does not
hold among them. A free day SHALL be a day of the due day's Monday-to-Sunday week, held by that same
era, that the era's schedule is not due on and that no shift of the commitment has put a due day on;
for a day a shift put there, the day that shift took it from SHALL be free as well. A day a shift
put there and shifted again SHALL keep the day it came from, and shifted to that day SHALL leave no
shift.

#### Scenario: a roster shifts a weekday-set due day onto a free day and leaves the rest of its rhythm as it was

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, and is asked to shift its due day on Monday 31 August 2026 to
  Tuesday 1 September 2026
- **THEN** the roster answers that it shifted it
- **AND** it still holds one era of "Gym", kept from 1 January 2026 and saying "Mon, Wed, Sat"
- **AND** the commitment it keeps is due on Wednesday 2 and Saturday 5 September 2026 and on Monday
  7 September 2026

#### Scenario: a roster shifts a day-of-month due day across the end of its month, inside its week

- **WHEN** a roster holds a commitment named "Finances" on a schedule on the 31st of the month, kept
  from 1 January 2026, and is asked to shift its due day on Monday 31 August 2026 to Tuesday
  1 September 2026
- **THEN** the roster answers that it shifted it
- **AND** the commitment it keeps is due on Tuesday 1 September 2026 and not on Monday 31 August
  2026
- **AND** it is due on Wednesday 30 September 2026, the last day of a month too short for its day

#### Scenario: a roster refuses to shift a due day onto one of its own days, a day another shift put a due day on, or a day of another week

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Wednesday 2 September 2026 is shifted to
  Thursday 3 September 2026, and is asked to shift its due day on Monday 31 August 2026 to Wednesday
  2 September 2026, to Thursday 3 September 2026, to Saturday 5 September 2026, to Tuesday
  8 September 2026 and to Monday 31 August 2026 itself
- **THEN** the roster refuses each of the five
- **AND** the commitment it keeps is still due on Monday 31 August and Thursday 3 September 2026, and
  not on Wednesday 2 September 2026

#### Scenario: a roster refuses to shift a due day onto a day the era holding it does not hold

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from Wednesday 2 September 2026, and is asked to shift its due day on that day to
  Tuesday 1 September 2026
- **THEN** the roster refuses it
- **AND** a roster holding "Gym" kept from 1 January 2026, stopped as of the day it was kept until,
  Wednesday 2 September 2026, and taken up again from Saturday 5 September 2026, refuses to shift its
  due day on Wednesday 2 September 2026 to Thursday 3, Friday 4 or Sunday 6 September 2026
- **AND** that roster shifts the same day to Tuesday 1 September 2026

#### Scenario: a roster refuses to shift a day the commitment is not due on, and an every-N-days due day

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Monday 31 August 2026 is shifted to Tuesday
  1 September 2026, and is asked to shift Monday 31 August 2026 to Thursday 3 September 2026, and
  Friday 4 September 2026 to Sunday 6 September 2026
- **THEN** the roster refuses both
- **AND** a roster holding a commitment named "Contact lenses" on a schedule of every 14 days
  starting on Tuesday 25 August 2026, kept from that day, refuses to shift its due day on that day
  to Wednesday 26 August 2026

#### Scenario: a roster shifts a day of a commitment it has stopped, and refuses one it does not hold

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026 and stopped as of the day it was kept until, Saturday
  5 September 2026, and is asked to shift its due day on Monday 31 August 2026 to Tuesday 1 September
  2026
- **THEN** the roster answers that it shifted it
- **AND** a roster asked the same of a commitment named "Run" it never held, or of "Gym" once it has
  deleted it, refuses it and is left as it was

#### Scenario: a day a shift put a due day on, shifted again, keeps the day it came from

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Monday 31 August 2026 is shifted to Tuesday
  1 September 2026, and is asked to shift Tuesday 1 September 2026 to Thursday 3 September 2026
- **THEN** the roster answers that it shifted it
- **AND** the commitment it keeps is due on Thursday 3 September 2026, and on neither Monday
  31 August nor Tuesday 1 September 2026
- **AND** the roster then shifts Thursday 3 September 2026 to Monday 31 August 2026, leaving the
  commitment due on Monday 31 August 2026 and on neither Tuesday 1 nor Thursday 3 September 2026

#### Scenario: a day a shift put a due day on, shifted to the day it came from, leaves no shift

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at two roster places; and at the first, its due day on Monday
  31 August 2026 is shifted to Tuesday 1 September 2026 and Tuesday 1 September 2026 is then shifted
  to Monday 31 August 2026
- **THEN** both shifts are answered as shifted
- **AND** the commitment the first place's roster store keeps is due on Monday 31 August 2026 and not
  on Tuesday 1 September 2026
- **AND** the content at the first place is byte-for-byte the content at the second

### Requirement: A commitments screen refuses a change deciding due days, and a stop, while a shift has a day after the day it was handed

A commitments screen SHALL refuse, as **a shifted day ahead**, a change asking for a different
rhythm, day kept from, range or target, and a stop, wherever a shift of the commitment took a due
day from, or put one on, a day later than the day the screen was handed; a shift with both days on
or before that day SHALL refuse neither. It SHALL be told apart from every other refusal, keep
nothing at either place, and be about the field *A commitments screen says whether a refusal about a
rhythm, a day kept from, a range or a target is about one of them or the whole change* gives a day
already recorded on. A change to the name, the category or the usual amounts alone SHALL NOT be
refused for a shift, and every change kept SHALL leave every shift as it was.

#### Scenario: a rhythm change is refused while a shift has a day after the day handed

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and its due day on Monday 31 August 2026 is shifted
  there to Thursday 3 September 2026; a commitments screen is opened at that roster place and a
  record place where nothing has been kept as of Tuesday 1 September 2026; and "Gym" is changed
  through it to a weekday-set rhythm of Tuesday and Thursday, on everything else it already has
- **THEN** it is refused as a shifted day ahead, about the rhythm field of its sheet, told apart from
  a day already recorded on that the change would leave not due
- **AND** what the screen keeps is one entry named "Gym", and the content at both places is
  byte-for-byte what it was immediately after the screen was opened
- **AND** the same change is refused the same way where the due day on Saturday 5 September 2026 is
  shifted to Friday 4 September 2026 instead and the screen is opened as of Friday 4 September 2026

#### Scenario: a range or a target change is refused while a shift has a day after the day handed

- **WHEN** a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, is taken on at a roster place
  and its due day on Monday 31 August 2026 is shifted there to Thursday 3 September 2026; a
  commitments screen is opened at that roster place as of Tuesday 1 September 2026; and "Weight" is
  changed through it to a range of 40 to 200, on everything else it already has
- **THEN** it is refused as a shifted day ahead, about the range field of its sheet
- **AND** a commitment named "Protein" of the total kind with a target of 120, held and shifted the
  same way, changed to a target of 150 is refused as a shifted day ahead, about the target field

#### Scenario: a move of the day kept from is refused while a shift has a day after the day handed

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and its due day on Monday 31 August 2026 is shifted
  there to Thursday 3 September 2026; a commitments screen is opened at that roster place as of
  Tuesday 1 September 2026; and "Gym" is changed through it to the day kept from 1 February 2026, on
  everything else it already has
- **THEN** it is refused as a shifted day ahead, about the day-kept-from field of its sheet
- **AND** what the screen keeps is one entry named "Gym", kept from 1 January 2026

#### Scenario: a stop is refused while a shift has a day after the day handed

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and its due day on Monday 31 August 2026 is shifted
  there to Thursday 3 September 2026; a commitments screen is opened at that roster place as of
  Tuesday 1 September 2026; and it is asked to stop keeping "Gym" and the stop is confirmed
- **THEN** it is refused as a shifted day ahead, told apart from a roster that could not be written
- **AND** what it keeps is one entry, named "Gym", what it has stopped is nothing, and the content at
  that place is byte-for-byte what it was immediately after the screen was opened

#### Scenario: a rename and a category are not refused while a shift has a day after the day handed

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and its due day on Monday 31 August 2026 is shifted
  there to Thursday 3 September 2026; a commitments screen is opened at that roster place as of
  Tuesday 1 September 2026; and "Gym" is changed through it to the name "Lifting", under "Sport", on
  everything else it already has
- **THEN** nothing is refused
- **AND** the commitment named "Lifting" a roster store opened afterwards at that place keeps is due
  on Thursday 3 September 2026 and not on Monday 31 August 2026

#### Scenario: a shift with no day after the day handed refuses no change and stands through it

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place and its due day on Monday 31 August 2026 is shifted
  there to Tuesday 1 September 2026; a tick for it on Tuesday 1 September 2026 is kept at a record
  place; a commitments screen is opened at those places as of Tuesday 1 September 2026; and "Gym" is
  changed through it to the name "Lifting" and a weekday-set rhythm of Wednesday and Friday
- **THEN** nothing is refused
- **AND** a day screen opened afterwards at those places as of Tuesday 1 September 2026 holds one
  row, named "Lifting", saying "from Mon" and saying its commitment is kept
- **AND** the day view it says of the day before holds a row named "Lifting" saying "to Tue"

### Requirement: A roster store keeps every shift at its place, and refuses a shift no roster could hold

A roster store SHALL keep every shift its roster holds at its place across the app being closed and
opened again, the day each took a due day from and the day it put it on, writing the same shifts on
every era of the commitment, and SHALL read a roster kept in a form written before a commitment
carried shifts as holding none. A roster store holding a shift no roster could hold — its two days
not in one Monday-to-Sunday week, one day twice, two shifts of one commitment from one day or onto
one day, or eras of one commitment carrying different shifts — SHALL be refused as holding
something that could not be a roster, SHALL say it is not a roster store rather than a later form,
and SHALL leave the content at its place byte-for-byte as it was.

#### Scenario: a shift kept at a roster place is held by a roster store opened afterwards at the same place

- **WHEN** a roster store is opened at a roster place where nothing has been kept; a commitment
  named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from 1 January 2026, is
  taken on through it; its due day on Monday 31 August 2026 is shifted to Tuesday 1 September 2026;
  and a further era of "Gym", on a schedule listing Tuesday and Thursday, kept from Monday
  7 September 2026, is then put on it
- **THEN** a roster store opened afterwards at that place reads back two eras of "Gym"
- **AND** the commitment it answers on Tuesday 1 September 2026 is due on that date, and the one it
  answers on Monday 31 August 2026 is not

#### Scenario: a roster kept in the form before shifts is read as holding none, and its place is left as it was

- **WHEN** a roster store is opened at a place holding a roster store in the form written before a
  commitment carried shifts, whose one commitment, named "Gym", is on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026
- **THEN** opening is not refused
- **AND** the commitment it keeps is due on Monday 31 August 2026 and not on Tuesday 1 September 2026
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store holding a shift no roster could hold is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Gym", on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, holds a shift from Sunday 6 September 2026 to Monday 7 September 2026
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** a roster store at a place whose "Gym" holds a shift from Monday 31 August 2026 to that same
  day, two shifts from Monday 31 August 2026, or two eras carrying different shifts, is refused the
  same way
- **AND** the content at each place is byte-for-byte what it was before

## RENAMED Requirements

- FROM: `### Requirement: A commitment is an identity, a name, a schedule, the day it is kept from and the kind its days take`
- TO: `### Requirement: A commitment is an identity, a name, a schedule, the day it is kept from, the kind its days take and its shifts`

- FROM: `### Requirement: A commitment is due exactly when its schedule is due, on and after the day it is kept from`
- TO: `### Requirement: A commitment is due exactly when its schedule is due, on and after the day it is kept from, but where a shift moved a due day`

## MODIFIED Requirements

### Requirement: A commitment is an identity, a name, a schedule, the day it is kept from, the kind its days take and its shifts

A commitment SHALL be exactly six things: an identity, a name, the schedule deciding which days it
is due on, the calendar date it is kept from, the kind its days take, and the shifts made of its due
days, none where no shift has been made. It SHALL carry nothing else: no record of what was ticked,
no position in a list, no state that can be paused or archived. It SHALL read back its name and its
kind, and no identity SHALL ever be shown to a person.

An identity SHALL be given when a commitment is first formed, SHALL NOT be derived from any other
part, and SHALL NOT change afterwards. Forming two commitments SHALL give two identities however
alike every other part is. A commitment formed as a further era of one already formed SHALL be
formed with that one's identity and its shifts rather than with an identity of its own, and a
commitment renamed SHALL keep its shifts.

Two commitments SHALL be the same commitment exactly when their identities are the same, whatever
their names, schedules, days kept from, kinds and shifts; two whose identities differ SHALL be different
commitments, and no other part SHALL enter into it.

The name, the schedule and the day kept from SHALL be required: the system MUST NOT form a
commitment without a day it is kept from, MUST NOT supply one of its own, and MUST NOT consult the
present moment. The kind SHALL default to the plain kind, a tick, SHALL be fixed when the commitment
is formed and SHALL NOT change afterwards.

#### Scenario: a commitment reads back the name it was given

- **WHEN** a commitment is formed with the name "Gym", a schedule listing Monday, Wednesday and
  Saturday, and kept from 1 January 2026
- **THEN** the commitment's name reads back as "Gym"

#### Scenario: two commitments formed alike in every part are two different commitments

- **WHEN** two commitments are formed, both named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday, both kept from 1 January 2026 and both of the tick kind
- **THEN** the two are different commitments
- **AND** neither reads back the other's identity

#### Scenario: a commitment formed as a further era of another is the same commitment

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is formed, and a second is formed as a further era of it, on a schedule listing
  Tuesday and Thursday, kept from 1 September 2026
- **THEN** the two are the same commitment
- **AND** the second reads back the name "Gym" and the tick kind
- **AND** a third formed with that same name, schedule and day, but not as an era of the first, is a
  different commitment from both

#### Scenario: two commitments differing only in name are different commitments

- **WHEN** two commitments are formed on the same schedule listing Monday, Wednesday and Saturday
  and kept from the same 1 January 2026, one named "Gym" and one named "Run"
- **THEN** the two are different commitments

#### Scenario: two commitments differing only in schedule are different commitments

- **WHEN** two commitments are formed, both named "Gym" and both kept from 1 January 2026, one on a
  schedule listing Monday and one on a schedule listing Tuesday
- **THEN** the two are different commitments

#### Scenario: two commitments differing only in the day they are kept from are different commitments

- **WHEN** two commitments are formed, both named "Gym" and both on a schedule listing Monday,
  Wednesday and Saturday, one kept from 1 January 2026 and one kept from 2 January 2026
- **THEN** the two are different commitments

#### Scenario: two commitments differing only in the kind their days take are different commitments

- **WHEN** two commitments are formed, both named "Gym", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, one of the tick kind and one of the note
  kind
- **THEN** the two are different commitments

#### Scenario: two number commitments differing only in their range are different commitments

- **WHEN** two commitments are formed, both named "Weight", both on a schedule listing Monday,
  Wednesday and Saturday, both kept from 1 January 2026 and both of the number kind, one with a
  range of 40 to 150 and one with no range at all
- **THEN** the two are different commitments
- **AND** a third alike in every way but carrying a range of 40 to 200 is a different commitment
  again

### Requirement: A commitment is due exactly when its schedule is due, on and after the day it is kept from, but where a shift moved a due day

On the day a commitment is kept from and on every date after it, the commitment SHALL be due exactly
when the schedule it carries is due on that date, and SHALL NOT be due on any other such date, but
that a date a shift of it took a due day from SHALL NOT be due and a date a shift of it put a due
day on SHALL be due, whatever its schedule says of either. Beyond its shifts it SHALL add nothing and
take nothing away: the system MUST NOT consider the commitment's name, the
current time, the device's time zone, the locale, or whether the commitment has been ticked. The
question SHALL be asked of a calendar date rather than of the present moment, and a date in the past
SHALL answer today as it did when it was today.

Delegation SHALL hold for every schedule shape the `schedule` capability defines and for every shape
added to it later. A commitment on a schedule due on no date SHALL answer that it is not due, rather
than the system treating it as an error.

#### Scenario: a commitment on a weekday-set schedule is due on a listed weekday and not on another

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is asked about Monday 31 August 2026
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about Tuesday 1 September 2026 answers that it is not due

#### Scenario: a commitment on a day-of-month schedule is due on the last day of a month too short for its day

- **WHEN** a commitment named "Finances" on a schedule on the 31st of the month, kept from 1 January
  2026, is asked about 28 February 2027
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about 1 March 2027 answers that it is not due

#### Scenario: a commitment on an every-N-days schedule is due on its start date and not on the day before it

- **WHEN** a commitment named "Contact lenses" on a schedule of every 14 days starting on 25 August
  2026, kept from that same 25 August 2026, is asked about 25 August 2026
- **THEN** the commitment is due on that date
- **AND** the same commitment asked about 24 August 2026 answers that it is not due

#### Scenario: two commitments with different names and the same schedule are due on the same dates

- **WHEN** a commitment named "Gym" and a commitment named "Run", both on a schedule listing Monday,
  Wednesday and Saturday and both kept from 1 January 2026, are each asked about every date from
  Monday 31 August through Sunday 6 September 2026
- **THEN** the two answer identically on all seven dates — due on 31 August, 2 September and
  5 September 2026, and not due on the other four

#### Scenario: a commitment on a schedule that is due on no date is never due

- **WHEN** a commitment named "Gym" on a schedule listing no weekday at all, kept from 1 January
  2026, is asked about each date from Monday 31 August through Sunday 6 September 2026
- **THEN** the commitment is due on none of those seven dates

#### Scenario: a commitment on a weekly-quota schedule is due on every date on and after the day it is kept from

- **WHEN** a commitment named "Reading" on a weekly quota of 3 times a week, kept from 1 January
  2026, is asked about each date from Monday 31 August through Sunday 6 September 2026
- **THEN** the commitment is due on all seven of those dates

#### Scenario: a commitment is not due on the day a shift took its due day from, and is due on the day it put it on

- **WHEN** a roster holds a commitment named "Gym" on a schedule listing Monday, Wednesday and
  Saturday, kept from 1 January 2026, whose due day on Monday 31 August 2026 is shifted to Tuesday
  1 September 2026, and the commitment it keeps is asked about each date from Monday 31 August
  through Monday 7 September 2026
- **THEN** it is due on Tuesday 1, Wednesday 2, Saturday 5 and Monday 7 September 2026
- **AND** it is due on none of the other four, Monday 31 August 2026 among them
