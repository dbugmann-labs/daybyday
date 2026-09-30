## ADDED Requirements

### Requirement: A usual amount is an amount above zero, with a name or none

A usual amount SHALL be an amount and a name or none. The amount SHALL be a single number above
zero; it MAY have a decimal fraction, and the system MUST NOT round it, MUST NOT require a whole
number and MUST NOT attach a unit to it. An amount of zero or below SHALL form no usual amount. A
name that is empty or holds only blank space SHALL be no name, blank space meaning what it means for
a commitment's name. Every other name SHALL be kept exactly as given, blank space at its ends
included, with no limit on its length.

#### Scenario: a usual amount is formed from an amount above zero and reads back its amount and its name

- **WHEN** a usual amount of 35 named "Müesli" is formed
- **THEN** it reads back the amount 35 and the name "Müesli"
- **AND** one of 0.5 formed with no name reads back the amount 0.5 and no name

#### Scenario: an amount of zero or below forms no usual amount

- **WHEN** a usual amount of 0 named "Shake" is offered
- **THEN** no usual amount is formed
- **AND** one of -1 forms none either
- **AND** one of 0.0001 is formed

#### Scenario: a usual amount named only blank space has no name, and any other name is kept as given

- **WHEN** a usual amount of 20 named with a text of two spaces and a tab is formed
- **THEN** it reads back no name
- **AND** one of 20 named " Shake " reads back the name " Shake ", both spaces included

### Requirement: A roster declares a commitment's usual amounts on every era of it, and puts no era on

A roster SHALL declare usual amounts on a commitment it holds, kept or stopped, on being given that
commitment and a list of them, SHALL write that list on every era of it in place of the one it held,
and SHALL report that it declared. Every era of one commitment SHALL declare the same usual amounts.
Declaring SHALL put no era on, and SHALL leave each era's name, schedule, day kept from, kind and day
kept until, the commitment's state, its category and its place in the roster's order exactly as they
were. A commitment SHALL declare none until it is given some, and an empty list SHALL take every one
off. Putting an era on, renaming, stopping and taking up again SHALL leave a commitment's usual
amounts as they were.

#### Scenario: a roster declares usual amounts on a total commitment and reads them back

- **WHEN** a roster given a commitment named "Protein" of the total kind with a target of 120, on a
  schedule listing all seven weekdays, kept from 1 January 2026, is asked to declare on it a usual
  amount of 20 with no name and one of 35 named "Müesli"
- **THEN** the roster reports that it declared them
- **AND** it reads back those two usual amounts for "Protein"
- **AND** a commitment alike in every way but named "Creatine", given to the roster afterwards, reads
  back none
- **AND** declaring an empty list on "Protein" afterwards leaves it reading back none

#### Scenario: declaring usual amounts puts no era on and leaves everything else about the commitment as it was

- **WHEN** a roster given a commitment named "Water plants" and then one named "Protein" of the total
  kind with a target of 120 under the category "Food", both on a schedule listing all seven weekdays
  and both kept from 1 January 2026, is asked to declare a usual amount of 35 named "Müesli" on
  "Protein"
- **THEN** it reads back one era of "Protein", named "Protein", on every day, kept from 1 January
  2026, of the total kind with a target of 120
- **AND** it reads back "Protein" among the commitments it keeps, in the group "Food"
- **AND** it reads back "Water plants" declaring no usual amounts

#### Scenario: a commitment's usual amounts stay through a new era, a rename, a stop and a take-up again

- **WHEN** a roster given a commitment named "Protein" of the total kind with a target of 120, on a
  schedule listing all seven weekdays, kept from 1 January 2026, declares on it a usual amount of 35
  named "Müesli"; puts a new era on it of the total kind with a target of 150, kept from
  1 September 2026, as of 31 August 2026, under no category; renames it "Protein intake"; stops
  keeping it as of 30 September 2026; and takes it up again from 5 October 2026
- **THEN** it reads back the usual amount of 35 named "Müesli" for it
- **AND** asked with its earliest era, it reads back the same

#### Scenario: a stopped commitment's usual amounts are declared and it stays stopped

- **WHEN** a roster given a commitment named "Protein" of the total kind with a target of 120, on a
  schedule listing all seven weekdays, kept from 1 January 2026, stops keeping it as of 30 August
  2026 and is then asked to declare on it a usual amount of 20 with no name
- **THEN** the roster reports that it declared it
- **AND** it reads back one commitment it has stopped, "Protein", declaring 20 with no name
- **AND** it reads back nothing it keeps

### Requirement: A total declares at most five usual amounts, no two alike, answered smallest first

A roster SHALL refuse to declare usual amounts on a commitment it does not hold, a deleted one
included, on one whose kind is not a total, where the list holds more than five, or where two in it
are alike; it SHALL report each refusal and SHALL be left exactly as it was. Two usual amounts SHALL
be alike where their amounts are equal and either neither has a name or their names are one name, as
two commitment names are one. A roster SHALL answer a commitment's usual amounts smallest amount
first, and SHALL NOT keep the order they were given in. Of two with one amount, the one with no name
SHALL come first, and two names SHALL be ordered character by character with the case of their
letters and blank space at either end disregarded, consulting no locale.

#### Scenario: declaring usual amounts on a commitment that is not a total is refused

- **WHEN** a roster given a commitment named "Gym" of the tick kind, one named "Weight" of the number
  kind with a range of 40 to 150 and one named "Journal" of the note kind, all on a schedule listing
  all seven weekdays and all kept from 1 January 2026, is asked to declare a usual amount of 20 with
  no name on each in turn
- **THEN** it reports each time that it did not declare it
- **AND** the roster is the same roster as one that was never asked

#### Scenario: declaring more than five usual amounts is refused

- **WHEN** a roster given a commitment named "Protein" of the total kind with a target of 120, on a
  schedule listing all seven weekdays, kept from 1 January 2026, is asked to declare on it usual
  amounts of 10, 20, 30, 40, 50 and 60, none of them named
- **THEN** it reports that it did not declare them
- **AND** it reads back no usual amounts for "Protein"
- **AND** asked to declare 10, 20, 30, 40 and 50 alone, it reports that it declared all five

#### Scenario: declaring two usual amounts alike is refused

- **WHEN** a roster given a commitment named "Protein" of the total kind with a target of 120, on a
  schedule listing all seven weekdays, kept from 1 January 2026, is asked to declare on it a usual
  amount of 35 named "Müesli" and one of 35 named " MÜESLI "
- **THEN** it reports that it did not declare them
- **AND** it reads back no usual amounts for "Protein"
- **AND** asked to declare one of 20 and one of 20.0, neither named, it refuses them too
- **AND** asked to declare 35 named "Müesli", 35 named "Muesli" and 35 with no name, it declares all
  three

#### Scenario: declaring usual amounts on a commitment a roster does not hold is refused

- **WHEN** a roster given a commitment named "Protein" of the total kind with a target of 120 and one
  named "Creatine" of the total kind with a target of 5, both on a schedule listing all seven
  weekdays and both kept from 1 January 2026, deletes "Creatine" and is then asked to declare on it a
  usual amount of 5 with no name
- **THEN** it reports that it did not declare it
- **AND** the roster is the same roster as one that deleted "Creatine" and was never asked
- **AND** asked to declare it on a commitment alike to "Protein" in every part that it has never
  held, it reports that it did not declare it either

#### Scenario: a roster answers usual amounts smallest first, an unnamed one before a named one of the same amount

- **WHEN** a roster given a commitment named "Protein" of the total kind with a target of 120, on a
  schedule listing all seven weekdays, kept from 1 January 2026, is asked to declare on it, in this
  order, usual amounts of 45 named "Chicken breast", 35 named "Müesli", 20 with no name, 35 named
  "almonds" and 35 with no name
- **THEN** it reports that it declared them
- **AND** it reads back 20 with no name, 35 with no name, 35 named "almonds", 35 named "Müesli" and
  45 named "Chicken breast", in that order

### Requirement: A roster store keeps each commitment's usual amounts, and refuses usual amounts no total could declare

A roster store SHALL keep the usual amounts every commitment declares at its place across the app
being closed and opened again, in the order a roster answers them, each amount with no digit added
and none dropped and each name exactly as it was declared, and SHALL write them on every era of the
commitment. A roster store holding usual amounts no roster could declare — on a commitment whose
kind is not a total, more than five on one commitment, two alike, an amount not above zero, or eras
of one commitment declaring different ones — SHALL be refused as holding something that could not
be a roster, SHALL say it is not a roster store rather than a later form, and SHALL leave the
content at its place byte-for-byte as it was.

#### Scenario: usual amounts declared through a commitments screen are held by a roster store opened afterwards at the same place

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where nothing
  has been kept; a commitment named "Protein" of the total kind with a target of 120, on a
  weekday-set rhythm of all seven weekdays, kept from 1 January 2026, is defined through it with
  usual amounts typed as "35" named "Müesli" and "0.50" with a blank name; and "Protein" is then
  changed through it to a target of 150, on everything else it already has
- **THEN** a roster store opened afterwards at that place reads back two eras of "Protein"
- **AND** it reads back the usual amounts 0.5 with no name and 35 named "Müesli" for it, in that
  order

#### Scenario: a roster store holding usual amounts no total could declare is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Gym", is of the tick kind and declares a usual amount of 20
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** a roster store at a place holding one commitment of the total kind declaring six usual
  amounts, one declaring 35 named "Müesli" twice, or one declaring an amount of 0, is refused the
  same way
- **AND** the content at each place is byte-for-byte what it was before

#### Scenario: a roster store holding eras of one commitment declaring different usual amounts is refused

- **WHEN** a roster store is opened at a place holding a roster store in the form this app writes,
  whose one commitment, named "Protein", is of the total kind and has two eras, the newer declaring a
  usual amount of 35 named "Müesli" and the earlier declaring none
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

### Requirement: A commitments screen reads the usual amounts typed on its sheet, and refuses one it cannot keep under its row

A commitments screen SHALL take, with a total defined or changed through it, the usual amounts typed
on its sheet, each an amount and a name as typed, declaring them in the same save as the rest. An
amount SHALL be read as a target is. One with both fields blank SHALL be no usual amount and SHALL
NOT be refused. The screen SHALL refuse the first usual amount, in the order typed, whose amount is
blank or not a number above zero, that is alike with one typed before it, or that is the sixth, each
a refusal of its own, about the usual amounts field and naming that usual amount's place in the
order typed. It SHALL refuse one only where nothing else typed is refused, and before any other
refusal. Usual amounts typed for another kind SHALL be ignored. A refused ask SHALL keep nothing.

#### Scenario: a total commitment defined with usual amounts through a commitments screen declares them

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where nothing
  has been kept, and a commitment named "Protein" of the total kind with a target of 120, on a
  weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it with usual
  amounts typed as "35" named "Müesli" and then "20" with a blank name
- **THEN** nothing is refused
- **AND** what it says "Protein" is made of names 20 with no name and 35 named "Müesli", in that
  order
- **AND** a roster store opened afterwards at that place reads back the same two for "Protein"

#### Scenario: a usual amount's amount is read as a target is read

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where nothing
  has been kept, and a commitment named "Protein" of the total kind with a target of 120, on a
  weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it with usual
  amounts typed as two spaces, then "35,5", then a line break, named "Müesli", and "0000030.50" with a
  blank name
- **THEN** nothing is refused
- **AND** what it says "Protein" is made of names 30.5 with no name and 35.5 named "Müesli"

#### Scenario: a usual amount typed with both its fields blank is no usual amount and is not refused

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where nothing
  has been kept, and a commitment named "Protein" of the total kind with a target of 120, on a
  weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it with usual
  amounts typed as "20", "25", "30", "35" and "40", each with a blank name, with an empty amount and
  an empty name typed between the second and the third, and an amount of two spaces with a name of one
  tab typed between the fourth and the fifth
- **THEN** nothing is refused
- **AND** what it says "Protein" is made of names 20, 25, 30, 35 and 40, none named

#### Scenario: a usual amount that is not an amount is refused under its row

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where nothing
  has been kept, and a commitment named "Protein" of the total kind with a target of 120, on a
  weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it with usual
  amounts typed as "20" with a blank name and then an empty amount named "Shake"
- **THEN** it is refused as a usual amount that is not an amount, about the usual amounts field of
  its sheet, naming the second usual amount typed
- **AND** "abc", "0", "-5" and a whole number of thirty-nine nines, each typed in the second one's
  place named "Shake", are refused the same way
- **AND** a roster store opened afterwards at that place holds no commitment

#### Scenario: a usual amount alike with one typed before it is refused under its row

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where nothing
  has been kept, and a commitment named "Protein" of the total kind with a target of 120, on a
  weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it with usual
  amounts typed as "35" named "Müesli", "20" with a blank name and "35" named " müesli "
- **THEN** it is refused as a usual amount alike with one typed before it, about the usual amounts
  field of its sheet, naming the third usual amount typed
- **AND** "20" and then "20.0", both with a blank name, are refused the same way, naming the second
- **AND** "35" named "Müesli" and then "35" named "Muesli" are not refused

#### Scenario: a sixth usual amount is refused under its row

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where nothing
  has been kept, and a commitment named "Protein" of the total kind with a target of 120, on a
  weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it with usual
  amounts typed as "10", "20", "30", "40", "50" and "60", every name blank
- **THEN** it is refused as more than five usual amounts, about the usual amounts field of its sheet,
  naming the sixth usual amount typed
- **AND** a roster store opened afterwards at that place holds no commitment

#### Scenario: usual amounts typed on a kind that is not a total are ignored rather than refused

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where nothing
  has been kept, and a commitment named "Gym" of the tick kind, on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it with usual amounts typed as "abc" named
  "Shake" and "20" with a blank name
- **THEN** nothing is refused
- **AND** what it says "Gym" is made of names the tick kind and no usual amounts
- **AND** a commitment named "Weight" of the number kind with a range of 40 to 150 and one named
  "Journal" of the note kind, defined alike with those same usual amounts typed, are refused nothing
  and declare none

#### Scenario: a usual amount is refused only where nothing else typed on the sheet is, and before the roster is asked

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  all seven weekdays, kept from 1 January 2026, is taken on at a roster place; a commitments screen
  is opened at that roster place as of Monday 31 August 2026; and a commitment named "   " of the
  total kind with a target of 50, on a weekday-set rhythm of all seven weekdays, kept from that same
  day, is defined through it with a usual amount typed as "abc" named "Shake"
- **THEN** it is refused as a name that says nothing
- **AND** the same defined with the name "Creatine" and a target typed as "abc" is refused as a target
  that is not a target
- **AND** the same defined with the name "PROTEIN" and a target of 50 is refused as a usual amount
  that is not an amount, and not as a name already in use

#### Scenario: what a commitments screen tells about a usual amount ends when its usual amounts are edited

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where nothing
  has been kept; a commitment named "Protein" of the total kind with a target of 120, on a
  weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it with a
  usual amount typed as "abc" named "Shake" and refused; and its sheet's name field and target field
  are told edited
- **THEN** it still tells a usual amount that is not an amount, about the usual amounts field of its
  sheet
- **AND** once its usual amounts field is told edited, it tells nothing on its sheet

### Requirement: A commitments screen offers another usual amount only while fewer than five are on its sheet

A commitments screen SHALL say, of the usual amounts on its sheet, whether it offers another. It
SHALL offer another while fewer than five are on the sheet and SHALL NOT offer one once five or more
are, counting every usual amount on the sheet whether typed or left with both fields blank, and
whatever is typed in them. What it offers SHALL NOT change what it refuses: a sixth usual amount
handed to it in a define or a change, however it arrives, SHALL still be refused as more than five.

#### Scenario: a commitments screen offers another usual amount while fewer than five are on its sheet, blank ones counted

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where nothing
  has been kept, and is asked whether it offers another usual amount after usual amounts typed as
  "10", "20", "30" and "40", every name blank
- **THEN** it offers another
- **AND** after none it offers another
- **AND** after "10", "20", "30", "40" and "50", every name blank, it offers none
- **AND** after "10", "20", "30", "40" and one with both its fields blank, it offers none
- **AND** after "10", "20", "30", "40", "abc" and "10", every name blank, it offers none

## RENAMED Requirements

- FROM: `### Requirement: A commitments screen changes a commitment by renaming it, moving the day it is kept from, or putting a new era on it`
- TO: `### Requirement: A commitments screen changes a commitment by renaming it, moving the day it is kept from, putting a new era on it, or declaring its usual amounts`

## MODIFIED Requirements

### Requirement: A commitments screen says what a commitment it is asked to change is made of

A commitments screen SHALL say, for a commitment on either of its lists, the things a change is
asked with: the name it has, the rhythm it runs on, the day it is kept from, the category it is
under, the range or the target its kind carries, and the usual amounts it declares, in the order a
roster answers them. For a commitment on neither list it SHALL say nothing at all. The day it is
kept from SHALL be that commitment's earliest era's, and the rhythm and the range or the target
SHALL be its newest era's; the screen SHALL say nothing at all about when the newest era began. The
rhythm SHALL be the one of the four that names that era's schedule, carrying the number that
schedule carries; an interval rhythm carries no start date, so an interval schedule's own start date
SHALL NOT be part of what is said.

It SHALL say whether anything beyond the name, the category and the usual amounts can be changed at
all: the rhythm, the day it is kept from and the range or the target alike can be changed for a
commitment its roster is keeping, and none of them can for one it has stopped keeping. It SHALL say
the kind that commitment's days take, with the range or the target that kind carries — the number
kind's range, or that it carries none; the total kind's target; nothing beside a tick or a note.
Which of the four kinds it is SHALL be shown and SHALL never be asked about. A control for each of
the things above SHALL be drawn, and the ones that cannot be changed SHALL NOT let a thumb in.

#### Scenario: a commitments screen says what a commitment it keeps is made of, on each of the four rhythms

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, one named
  "Finances" on a schedule on the 25th of the month, one named "Contact lenses" on a schedule of
  every 14 days starting on 1 January 2026, and one named "Reading" on a schedule of 3 times a week,
  all kept from 1 January 2026, are taken on at a roster place; and a commitments screen is opened at
  that roster place as of Monday 31 August 2026
- **THEN** what it says each is made of names a weekday-set rhythm of Monday, Wednesday and Saturday,
  a day-of-the-month rhythm of the 25th, an interval rhythm of 14 days and a weekly-quota rhythm of
  3 times a week, in that order
- **AND** each says the name that commitment has and 1 January 2026 as the day it is kept from

#### Scenario: a commitments screen says the category a commitment it keeps is under

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** what it says "Creatine" is made of says the category "Supplements"
- **AND** what it says "Gym" is made of says no category at all

#### Scenario: a commitments screen says a stopped commitment's rhythm and day kept from cannot be changed

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as of
  Sunday 30 August 2026; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** what it says "Gym" is made of says its rhythm and the day it is kept from cannot be changed
- **AND** what it says "Journaling" is made of says they can

#### Scenario: a commitments screen says a stopped commitment's range and target cannot be changed either

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10, one named "Protein"
  of the total kind with a target of 120, and one named "Weight" of the number kind with a range of
  40 to 150, all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on
  at a roster place; "Mood" and "Protein" are stopped there as of Sunday 30 August 2026; and a
  commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it says "Mood" is made of says its range cannot be changed, and what it says
  "Protein" is made of says its target cannot be changed
- **AND** what it says "Weight" is made of says its range can be changed

#### Scenario: a commitments screen says nothing about a commitment on neither of its lists

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is deleted there; and
  a commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** it says nothing about what "Gym" is made of
- **AND** it says nothing about what a commitment named "Run" alike in every other way, which its
  roster has never held, is made of

#### Scenario: a commitments screen says the kind a commitment it keeps takes, with what that kind carries

- **WHEN** a commitment named "Gym" of the tick kind, one named "Mood" of the number kind with a
  range of 1 to 10, one named "Journal" of the note kind, and one named "Protein" of the total kind
  with a target of 120, all on a schedule listing all seven weekdays and all kept from 1 January
  2026, are taken on at a roster place; and a commitments screen is opened at that roster place as of
  Monday 31 August 2026
- **THEN** what it says each is made of names the tick kind, the number kind carrying a range whose
  lowest is 1 and whose highest is 10, the note kind, and the total kind carrying a target of 120, in
  that order

#### Scenario: a commitments screen says a number commitment carrying no range takes the number kind and no range

- **WHEN** a commitment named "Weight" of the number kind carrying no range, and one named "Gym" of
  the tick kind, both on a schedule listing all seven weekdays and kept from 1 January 2026, are
  taken on at a roster place; "Weight" is stopped there as of Sunday 30 August 2026; and a
  commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it says "Weight" is made of names the number kind carrying no range
- **AND** it says that "Weight"'s rhythm and the day it is kept from cannot be changed

#### Scenario: a commitments screen says what a commitment it has stopped is made of

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there and stopped there as of Sunday 30 August 2026; and a commitments
  screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it says "Creatine" is made of names "Creatine", a weekday-set rhythm of all seven
  weekdays, 1 January 2026 as the day it is kept from, and the category "Supplements"
- **AND** it says that "Creatine"'s rhythm and the day it is kept from cannot be changed
#### Scenario: a commitments screen says a commitment's earliest era's day kept from and its newest era's rhythm

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category
- **THEN** what it says "Gym" is made of says the day kept from 1 January 2026
- **AND** it says a weekday-set rhythm of Tuesday and Thursday
- **AND** it says nothing naming Monday 31 August 2026, the day the newest era began

#### Scenario: a commitments screen says the usual amounts a total commitment declares, smallest first, and none for another kind

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, declaring a usual
  amount of 35 named "Müesli" and one of 20 with no name, and one named "Gym" of the tick kind, both
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; and a commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it says "Protein" is made of names 20 with no name and 35 named "Müesli", in that
  order
- **AND** what it says "Gym" is made of names no usual amounts

### Requirement: A commitments screen changes a commitment by renaming it, moving the day it is kept from, putting a new era on it, or declaring its usual amounts

A commitments screen SHALL change a commitment on either of its lists from six things and no others
— a name, a rhythm, the day it is kept from, the category, which may be none, the range or the
target its kind has room for, and the usual amounts a total declares — and SHALL work out from them
which acts the change needs, doing each it needs and no other, at the roster place alone. A
different name SHALL rename the commitment through every era of it. A different day kept from SHALL
change the commitment's earliest era for one kept from that day. A different rhythm, range or target
SHALL put a new era on the commitment, kept from the day the screen was handed — or from the day the
commitment is kept from, where that is later — with the era it gives way to kept until the day
before; the name and the day kept from the change names SHALL already have been written by the two
acts above, so one save SHALL rename first, move the day second and put the era on third. A
different category SHALL be written by whichever act runs, and by a put where none does. Different
usual amounts SHALL be declared on every era the save leaves, and SHALL put no era on.

No change SHALL move a record, and nothing SHALL be written at the record place by any of them: a
record is a record of the commitment, which a rename, a moved day and a new era all leave standing.
Every past day SHALL go on answering about the commitment it answered about, under whatever name it
now carries and against whichever era holds that day.

On an interval rhythm the day kept from is also the rhythm's start date, so a change naming a
different day SHALL form the earliest era's schedule from that day and the days it was due on before
are not the days it is due on after; on the other three, dueness does not depend on that day, so
moving it earlier only widens the window and every day already recorded on SHALL stay due. A day
kept from moved forward past the day an era gives way SHALL drop every era it would leave holding no
day, and the earliest surviving era SHALL be kept from that day.

Which of the four kinds its days take is not one of the six and SHALL NOT change: every era SHALL be
of the kind the commitment is of. The range a number kind carries and the target a total kind
carries SHALL be what the change names, a range named where the commitment carried none and none
named where it carried one alike, and only the era put on SHALL carry the new one. A range or a
target named for a kind that has no room for it SHALL be ignored. A commitment its roster has
stopped keeping SHALL be changed in name, category and usual amounts only, and SHALL stay stopped on
the day it was kept until. Where the six things name what is already there — the usual amounts it
already declares, in whatever order — and the category it is already under, the screen SHALL change
nothing, SHALL write nothing at either place and SHALL refuse nothing.

#### Scenario: a commitment renamed through a commitments screen is drawn under its new name, in the place it held

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling", all
  on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a roster
  place; a commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym"
  is changed through it to the name "Gym 🏋️", on the rhythm and the day kept from it already has,
  under no category
- **THEN** nothing is refused
- **AND** what it keeps is three entries, named "Water plants", then "Gym 🏋️", then "Journaling"
- **AND** a roster store opened afterwards at that place holds those three commitments in that order

#### Scenario: a renamed commitment keeps every record already made, and the record place is not written

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; the content at that record place is read; and "Gym" is changed through it
  to the name "Gym 🏋️", on the rhythm and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** a look-back at "Gym 🏋️" counts Monday 3 August 2026 kept
- **AND** the content at that record place is byte-for-byte what was read before the change

#### Scenario: a rename through a commitments screen reaches every era of the commitment

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category; and it is then changed to the name "Lifting", on the rhythm and the
  day kept from it now has
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Lifting" on Monday, Wednesday and Saturday, and about Monday 31 August 2026 with "Lifting" on
  Tuesday and Thursday
- **AND** a look-back at "Lifting" says the name "Lifting" and the day kept from "1 January 2026"

#### Scenario: a commitment whose rhythm is changed through a commitments screen is given a new era from today

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, on the name and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Gym", saying "Tue, Thu"
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with the
  era on Monday, Wednesday and Saturday and about Monday 31 August 2026 with the era on Tuesday and
  Thursday
- **AND** what it has stopped is nothing, and what the screen says "Gym" is made of says the day kept
  from 1 January 2026

#### Scenario: a rhythm changed through a commitments screen leaves every record already made standing

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a
  record place; a commitments screen is opened at that roster place and that record place as of
  Monday 31 August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category
- **THEN** nothing is refused
- **AND** a look-back at "Gym" counts Monday 3 August 2026 kept
- **AND** the content at that record place is byte-for-byte what it was before the change

#### Scenario: a name and a rhythm changed in one save put the new name on every era

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️" on a weekday-set
  rhythm of Tuesday and Thursday, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Gym 🏋️" on Monday, Wednesday and Saturday, and about Monday 31 August 2026 with "Gym 🏋️" on
  Tuesday and Thursday
- **AND** what the screen keeps is one entry, named "Gym 🏋️", saying "Tue, Thu"

#### Scenario: the day a commitment is kept from is moved earlier through a commitments screen and the days it opens become due

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 August
  2026, is taken on at a roster place; a commitments screen is opened at that roster place as of
  Monday 31 August 2026; and "Gym" is changed through it to the day kept from 1 June 2026, on the
  name and the rhythm it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is due on Monday
  1 June 2026 and on Monday 3 August 2026

#### Scenario: the day an interval commitment is kept from is moved earlier and every day it is due on moves with it

- **WHEN** a commitment named "Contact lenses" on an interval rhythm of 14 days, kept from Wednesday
  1 July 2026, is taken on at a roster place; a commitments screen is opened at that roster place as
  of Monday 31 August 2026; and "Contact lenses" is changed through it to the day kept from Monday
  29 June 2026, on the name and the rhythm it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is due on Monday 29 June
  2026 and on Monday 13 July 2026
- **AND** it is not due on Wednesday 1 July 2026

#### Scenario: the day a commitment is kept from is moved onto a later era and the eras it leaves no day for are dropped

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 June 2026,
  is taken on at a roster place; a commitments screen is opened at that roster place as of Monday
  31 August 2026; "Gym" is changed through it to a weekday-set rhythm of Tuesday and Thursday, under
  no category; and "Gym" is then changed to the day kept from Monday 31 August 2026, on the name and
  the rhythm it now has
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place reads back one era of "Gym", on Tuesday and
  Thursday, kept from Monday 31 August 2026
- **AND** it says nothing about Sunday 30 August 2026, which "Gym" is not due on

#### Scenario: a change that names what is already there changes nothing and refuses nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, under the category "Sport", is taken on at a roster place; a tick for it on Monday
  3 August 2026 is kept at a record place; a commitments screen is opened at that roster place and
  that record place as of Monday 31 August 2026; and "Gym" is changed through it to exactly the name,
  rhythm, day kept from and category it already has
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Sport", holding one entry named "Gym"
- **AND** the content at both places is byte-for-byte what it was immediately after the screen was
  opened
- **AND** a screen alike in every way keeping "Mood" of the number kind with a range of 1 to 10,
  asked to change it to exactly the range it already carries beside everything else it already has,
  refuses nothing and leaves the content at both places byte-for-byte as it was

#### Scenario: a stopped commitment renamed through a commitments screen stays stopped, on the day it was kept until

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as of
  Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is changed through it to the name "Gym 🏋️", on the rhythm and the day
  kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it has stopped is one entry, named "Gym 🏋️"
- **AND** what it keeps is one entry, named "Journaling"
- **AND** a roster store opened afterwards at that place answers with "Gym 🏋️" and then "Journaling"
  when asked what it had not stopped keeping on Sunday 30 August 2026, and with "Journaling" alone on
  Monday 31 August 2026

#### Scenario: a commitment of the number kind changed through a commitments screen keeps the kind its days take

- **WHEN** a commitment named "Weight" of the number kind with a range of 40 to 150, on a schedule
  listing all seven weekdays, kept from 1 January 2026, is taken on at a roster place; a commitments
  screen is opened at that roster place as of Monday 31 August 2026; and "Weight" is changed through
  it to the name "Bodyweight", on the rhythm, the day kept from and the range it already has, under
  no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place holds is of the number kind
  with a range of 40 to 150
- **AND** what it keeps is one entry, named "Bodyweight"

#### Scenario: a rhythm changed on the first date the calendar supports puts the new era on as of that day itself

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 1583, is taken on at a roster place; a commitments screen is opened at that roster place
  as of 1 January 1583; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and
  Thursday, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place reads back one era of "Gym", on Tuesday and
  Thursday, kept from 1 January 1583, and answers about 1 January 1583 with that era alone

#### Scenario: a category set through a commitments screen's change is kept at the roster place

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; and "Creatine" is changed through it to
  the category "Supplements", on the name, the rhythm and the day kept from it already has
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** a commitments screen opened afterwards at that place as of that same day keeps those same
  two groups

#### Scenario: a category taken off through a commitments screen's change draws its commitment among the ones under none

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is put under the
  category "Supplements" there; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Creatine" is changed through it to a category of three spaces, on the name,
  the rhythm and the day kept from it already has
- **THEN** nothing is refused
- **AND** what it keeps is one group, with no category, holding "Creatine" and then "Gym"

#### Scenario: a commitment of the total kind whose rhythm is changed through a commitments screen keeps its kind and its target

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule
  listing Monday, Wednesday and Saturday, kept from 1 January 2026, is taken on at a roster place; a
  commitments screen is opened at that roster place and at a record place where nothing has been
  kept as of Monday 31 August 2026; and "Protein" is changed through it to a weekday-set rhythm of
  Tuesday and Thursday, on the name, the day kept from and the target it already has, under no
  category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place is keeping is of the total
  kind with a target of 120

#### Scenario: a stopped commitment put under a category through a commitments screen's change stays stopped under it

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is stopped there
  as of Sunday 30 August 2026; a commitments screen is opened at that roster place and at a record
  place where nothing has been kept as of Monday 31 August 2026; and "Creatine" is changed through
  it to the category "Supplements", on the name, the rhythm and the day kept from it already has
- **THEN** nothing is refused
- **AND** what it has stopped is one entry, named "Creatine", and what it says "Creatine" is made of
  says the category "Supplements"
- **AND** after "Creatine" is taken up again through the screen, what it keeps is two groups,
  "Supplements" holding "Creatine" and then a group with no category holding "Gym"

#### Scenario: a name, an earlier day kept from and a rhythm changed in one save reach every era

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 August 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  and at a record place where nothing has been kept as of Monday 31 August 2026; and "Gym" is
  changed through it to the name "Gym 🏋️", on a weekday-set rhythm of Tuesday and Thursday, kept
  from 1 June 2026, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Gym 🏋️" on Monday, Wednesday and Saturday, kept from 1 June 2026, and about Monday 31 August
  2026 with "Gym 🏋️" on Tuesday and Thursday, kept from 31 August 2026
- **AND** what the screen keeps is one entry, named "Gym 🏋️", saying "Tue, Thu", and what it says
  that commitment is made of says the day kept from 1 June 2026

#### Scenario: a change writes nothing at the record place, whatever it changes

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from 1 January
  2026, is taken on at a roster place; a tick for it on Monday 3 August 2026 is kept at a record
  place; a commitments screen is opened at that roster place and that record place as of Monday
  31 August 2026; the content at that record place is read; and "Gym" is changed through it three
  times — to the name "Gym 🏋️", then to the day kept from 1 June 2026, then to a weekday-set rhythm
  of Tuesday and Thursday
- **THEN** nothing is refused
- **AND** the content at that record place is byte-for-byte what was read before the first change

#### Scenario: a change of rhythm through a commitments screen puts the commitment under the category it was given

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, under the category "Sport", is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday 31
  August 2026; and "Gym" is changed through it to a weekday-set rhythm of Tuesday and Thursday,
  under the category "Morning"
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Morning", holding one entry named "Gym", saying "Tue, Thu"

#### Scenario: a commitment whose range is changed through a commitments screen is given a new era from today

- **WHEN** a commitment named "Mood" of the number kind with a range of 1 to 10, on a schedule
  listing all seven weekdays, kept from 1 January 2026, is taken on at a roster place; a commitments
  screen is opened at that roster place and at a record place where nothing has been kept as of
  Monday 31 August 2026; and "Mood" is changed through it to a range of 1 to 5, on the name, the
  rhythm and the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Mood"
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with the
  era ranging 1 to 10 and about Monday 31 August 2026 with the era ranging 1 to 5
- **AND** what it has stopped is nothing

#### Scenario: a target changed through a commitments screen puts a new era on and leaves every record standing

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  all seven weekdays, kept from 1 January 2026, is taken on at a roster place; additions summing to
  120 for it on Monday 3 August 2026 are kept at a record place; a commitments screen is opened at
  that roster place and that record place as of Monday 31 August 2026; the content at that record
  place is read; and "Protein" is changed through it to a target of 100, on the name, the rhythm and
  the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place is keeping is of the total
  kind with a target of 100
- **AND** a store opened afterwards at that record place answers 120 added for that commitment on
  Monday 3 August 2026
- **AND** the content at that record place is byte-for-byte what was read before the change

#### Scenario: a range added to a number commitment carrying none, and one taken off, each put a new era on

- **WHEN** a commitment named "Weight" of the number kind carrying no range and one named "Mood" of
  the number kind with a range of 1 to 10, both on a schedule listing all seven weekdays and kept
  from 1 January 2026, are taken on at a roster place; a commitments screen is opened at that roster
  place and at a record place where nothing has been kept as of Monday 31 August 2026; "Weight" is
  changed through it to a range of 40 to 150 and "Mood" to no range at all, each on the name, rhythm
  and day kept from it already has, under no category
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place answers about Monday 31 August 2026 with
  "Weight" ranging 40 to 150 and "Mood" carrying no range
- **AND** it answers about Sunday 30 August 2026 with "Weight" carrying no range and "Mood" ranging
  1 to 10, among them
- **AND** each is one commitment with two eras, kept from 1 January 2026

#### Scenario: a commitment kept from a day after today, changed before that day, keeps the day it is kept from

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  Friday 4 September 2026, is taken on at a roster place; a commitments screen is opened at that
  roster place and at a record place where nothing has been kept as of Tuesday 1 September 2026;
  and "Gym" is changed through it to a weekday-set rhythm of Tuesday and Thursday, on the name and
  the day kept from it already has, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place reads back one era of "Gym", on Tuesday and
  Thursday, kept from Friday 4 September 2026
- **AND** what the screen says "Gym" is made of says the day kept from 4 September 2026
- **AND** a commitment named "Nails" on an interval rhythm of 4 days, kept from that same Friday,
  changed alike to an interval rhythm of 5 days, reads back one era, on every 5 days starting on
  Friday 4 September 2026

#### Scenario: a total commitment's usual amounts changed through a commitments screen put no era on it and leave the record place as it was

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  all seven weekdays, kept from 1 January 2026, declaring a usual amount of 20 with no name, is taken
  on at a roster place; an addition of 30 for it on Monday 3 August 2026 is kept at a record place; a
  commitments screen is opened at that roster place and that record place as of Monday 31 August
  2026; and "Protein" is changed through it to usual amounts typed as "35" named "Müesli" and "20"
  with a blank name, on the name, the rhythm, the day kept from and the target it already has, under
  no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place reads back one era of "Protein", and the
  usual amounts 20 with no name and 35 named "Müesli" for it
- **AND** the content at the record place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a target and the usual amounts changed in one save put one era on, and every era declares the new usual amounts

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  all seven weekdays, kept from 1 January 2026, declaring a usual amount of 20 with no name, is taken
  on at a roster place; a commitments screen is opened at that roster place and at a record place
  where nothing has been kept as of Monday 31 August 2026; and "Protein" is changed through it to a
  target of 150 and a usual amount typed as "35" named "Müesli", on the name, the rhythm and the day
  kept from it already has, under no category
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place reads back two eras of "Protein", the newer
  with a target of 150
- **AND** it reads back the one usual amount 35 named "Müesli" for "Protein"

#### Scenario: a stopped total commitment's usual amounts changed through a commitments screen are declared, and it stays stopped

- **WHEN** a commitment named "Protein" of the total kind with a target of 120 and one named "Gym",
  both on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Protein" is stopped there as of Sunday 30 August 2026; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday
  31 August 2026; and "Protein" is changed through it to a usual amount typed as "20" with a blank
  name, on everything else it already has
- **THEN** nothing is refused
- **AND** what it has stopped is one entry, named "Protein", and what it says "Protein" is made of
  names 20 with no name
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a change naming the usual amounts a total commitment already declares, in another order, changes nothing

- **WHEN** a commitment named "Protein" of the total kind with a target of 120, on a schedule listing
  all seven weekdays, kept from 1 January 2026, declaring a usual amount of 20 with no name and one
  of 35 named "Müesli", is taken on at a roster place; a commitments screen is opened at that roster
  place and at a record place where nothing has been kept as of Monday 31 August 2026; and "Protein"
  is changed through it to usual amounts typed as "35" named "Müesli" and "20" with a blank name, on
  everything else it already has
- **THEN** nothing is refused
- **AND** the content at both places is byte-for-byte what it was immediately after the screen was
  opened

### Requirement: A roster store reads every form of roster this app has written before the one it writes now

A roster store SHALL read a roster kept in any form this app has written before the one it writes
now, rather than refusing it, and SHALL read each as the roster it was. Every commitment in the form
written before a commitment carried a kind SHALL be read as being of the plain kind; every
commitment in the form written before a commitment could be removed SHALL be read as one the roster
has not removed; every commitment in the form written before a commitment could be put under a
category SHALL be read as one the roster holds under no category; every roster in a form written
before a commitment had an identity SHALL be folded, as *A roster store folds a roster kept before a
commitment had an identity* says; every commitment a roster in the form written after a commitment
had an identity and before one could be deleted holds removed SHALL be read as deleted, as *A roster
store reads a commitment a stored roster held removed as deleted* says; and every commitment in a
form written before a commitment could declare usual amounts SHALL be read as declaring none.

Reading a roster kept in an earlier form MUST NOT change what is at the place. A store SHALL write
on a change being kept and at no other moment. Opening the app and doing nothing SHALL leave the
content byte-for-byte what it was, in the form it was already in. The next change kept there SHALL
be written in the form this app writes, whole, and SHALL still hold everything the earlier form held
— the order the commitments were taken on, every day one was kept until, and every part of every
commitment.

Each form SHALL be read as the shape that form has, and a roster store SHALL declare its form before
anything else in it is read. What a stored roster says about removal, about a category, about an
identity, about usual amounts and about being emptied SHALL each agree with the form it declares, in
both directions. Removal SHALL be said of every commitment exactly in the forms written after a
commitment could be removed and before one could be deleted; a category, an identity and the usual
amounts a commitment declares SHALL be said of every commitment in every form written since each was
introduced; and whether the roster was emptied SHALL be said once, of the whole roster, exactly in
the forms written since a commitment could be deleted. A store saying one of them where its form
does not, or leaving one unsaid where its form does, SHALL be refused as content that is not a
roster store. A commitment under no category SHALL be said to be under none, and one declaring no
usual amounts to declare none, rather than left unsaid.

The forms a roster store reads SHALL be exactly the ones this app has written: the form it writes
now and every form before it. It SHALL NOT weaken the refusal of a form later than the one it
writes, and SHALL refuse a form number it has never written — one below the earliest — as content
that is not a roster store.

#### Scenario: a roster kept before a commitment carried a kind is read with every commitment of the plain kind

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment carried a kind, whose two commitments are named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026, and "Finances" on a schedule on the 25th of the
  month, kept from that same day
- **THEN** it opens without error
- **AND** its roster is the same roster as one given those two commitments, both of the tick kind,
  in that order

#### Scenario: reading a roster kept in an earlier form changes nothing at its place

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment carried a kind, and nothing is asked of the store
- **THEN** the content at that place is byte-for-byte what it was before

#### Scenario: a commitment of another kind taken on over a roster kept in an earlier form is read back with its kind

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment carried a kind, whose one commitment is named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026; a commitment named "Weight" of the number kind
  with a range of 40 to 150, alike in schedule and kept-from day, is taken on through it; and a
  store is opened afterwards at the same place
- **THEN** the later store's roster reads back both commitments in that order, "Gym" of the tick
  kind and "Weight" of the number kind carrying that range

#### Scenario: a roster store written in a form this app has never written is refused

- **WHEN** a roster store is opened at a place holding a roster store whose form is one below the
  earliest form this app has ever written, holding no commitments
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster kept before a commitment could be removed is read with every commitment not removed

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could be removed, whose two commitments are named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026 and stopped as of 31 January 2026, and
  "Journaling" on that same schedule, kept from that same day and never stopped
- **THEN** it opens without error
- **AND** its roster is the same roster as one given those two commitments in that order and asked to
  stop keeping "Gym" as of 31 January 2026
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring a form written before removal and saying something about removal is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form used before a
  commitment could be removed and yet says, of its one commitment, that it has not been removed
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster kept before a commitment could be put under a category is read with every commitment under none

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could be put under a category, whose two commitments are named "Creatine" on a schedule
  listing all seven weekdays, kept from 1 January 2026, and "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from that same day
- **THEN** it opens without error
- **AND** its roster reads back one group, under no category, holding "Creatine" and then "Gym"
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring a form written before categories and saying something about one is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form used before a
  commitment could be put under a category and yet says, of its one commitment, that it is under
  none
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring the form this app writes and saying nothing about a category is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form this app
  writes and yet says nothing at all about a category for its one commitment
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a commitment put under a category over a roster kept before categories existed is read back under it

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could be put under a category, whose two commitments are named "Creatine" and "Gym",
  both on a schedule listing all seven weekdays and both kept from 1 January 2026; "Creatine" is put
  under the category "Supplements" through it; and a store is opened afterwards at the same place
- **THEN** the later store's roster reads back two groups, one under "Supplements" holding
  "Creatine" and one under no category holding "Gym"
- **AND** the later store's roster reads back both commitments of the tick kind

#### Scenario: a change kept over a roster in an earlier form keeps every day a commitment was kept until

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could be removed, whose two commitments are named "Gym" on a schedule listing Monday,
  Wednesday and Saturday, kept from 1 January 2026 and stopped as of 31 January 2026, and
  "Journaling" on that same schedule, kept from that same day; a commitment named "Run" alike in
  every other way to "Journaling" is taken on through it; and a store is opened afterwards at the
  same place
- **THEN** the later store's roster answers about 31 January 2026 with "Gym", then "Journaling",
  then "Run"
- **AND** asked about 1 February 2026 it answers with "Journaling" and then "Run"

#### Scenario: a roster store declaring a later form whose body this app cannot read is refused as a later form

- **WHEN** a roster store is opened at a place holding content that declares a form one later than
  the form this app writes and whose commitments are not a list at all
- **THEN** opening is refused with an error
- **AND** the error says the content is from a later form rather than that it is not a roster store
- **AND** the content at that place is byte-for-byte what it was before
#### Scenario: a roster store declaring a form written before identities and saying something about one is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form used before a
  commitment had an identity and yet says an identity for its one commitment
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring the form this app writes and saying nothing about an identity is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form this app
  writes and yet says nothing at all about an identity for its one commitment
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring the form this app writes and saying something about removal is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form this app
  writes and yet says, of its one commitment, that it has not been removed
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring the form this app writes and saying nothing about being emptied is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form this app
  writes, holds one commitment named "Gym" and says nothing at all about whether it was emptied
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring a form written before deletion and saying whether it was emptied is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form used before a
  commitment could be deleted, holds one commitment named "Gym", and says it was not emptied
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a commitment deleted over a roster kept before removal existed is not read back

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could be removed, whose commitments are named "Gym" and "Journaling", both on a
  schedule listing Monday, Wednesday and Saturday and kept from 1 January 2026; "Gym" is deleted
  through it; and a store is opened afterwards at the same place
- **THEN** the later store's roster reads back one commitment it is keeping, named "Journaling"
- **AND** asked about 1 January 2026 it answers with "Journaling" alone

#### Scenario: a roster kept before a commitment could declare usual amounts is read with every commitment declaring none

- **WHEN** a roster store is opened at a place holding a roster written in the form used before a
  commitment could declare usual amounts, whose one commitment is named "Protein", of the total kind
  with a target of 120, on a schedule listing all seven weekdays, kept from 1 January 2026
- **THEN** it opens without error
- **AND** its roster reads back no usual amounts for "Protein"
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring a form written before usual amounts and saying something about them is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form used before a
  commitment could declare usual amounts and yet says, of its one commitment, that it declares none
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a roster store declaring the form this app writes and saying nothing about usual amounts is refused

- **WHEN** a roster store is opened at a place holding a roster that declares the form this app
  writes and yet says nothing at all about usual amounts for its one commitment
- **THEN** opening is refused with an error
- **AND** the error says the content is not a roster store rather than that it is from a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: usual amounts declared over a roster kept before they existed are read back

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place holding a
  roster written in the form used before a commitment could declare usual amounts, whose one
  commitment is named "Protein", of the total kind with a target of 120, on a schedule listing all
  seven weekdays, kept from 1 January 2026; and "Protein" is changed through it to a usual amount
  typed as "35" named "Müesli", on everything else it already has
- **THEN** nothing is refused
- **AND** a roster store opened afterwards at that place reads back the usual amount 35 named
  "Müesli" for "Protein"

### Requirement: A commitments screen defines a new commitment from a name, a rhythm and the day it is kept from, and never finds a deleted one

A commitments screen SHALL define a commitment from six things and no others: a name, a rhythm, the
day it is kept from, a category, which may be none, the kind its days take, and the usual amounts a
total declares. A change SHALL take five of them, every one but the kind, and a commitment the
screen already holds SHALL be offered no kind at all. What is formed SHALL carry an identity of its
own, SHALL be taken on at the roster place before either list says so, and SHALL then be last in
what the screen keeps, in the group of the category given. It SHALL never find a commitment the
roster holds stopped, whatever it is named, nor one it has deleted: taking a stopped commitment up
again is the one-tap act on its row, and a deleted one is gone. Two commitments alike in every part,
their kind included, SHALL be two commitments here as in a roster, and the second SHALL be refused
for the name the first already has. A rhythm SHALL be one of four, all four offered — a weekday set,
a day of the month, an interval of whole days, a weekly quota — and an interval rhythm carries no
start date. Three of the four take a number, which a rhythm SHALL carry as the person gave it,
judged by nothing on the way. A kind SHALL likewise be one of four, all four offered — a tick, a
number, a note, a total — and the tick SHALL be the kind offered for a new commitment. A category of
nothing but blank space is no category and SHALL NOT be refused; every other SHALL be kept exactly
as given, blank space at its ends and all. The day a commitment is kept from SHALL also be an
interval rhythm's start date on this screen, though the two remain distinct in the model and may
disagree where something else forms the commitment. This screen SHALL offer the day it was handed
for a new commitment, SHALL accept any calendar date the system supports, the future included, and
MUST NOT judge that date against it or bound it beyond the calendar.

A number kind's two range ends and a total kind's target SHALL each be taken as text exactly as
typed, and SHALL NOT be judged, formed or blocked before they arrive. Each SHALL be read as a number
entry reads a committed number, and there SHALL be one such reading rather than two: no locale
consulted, blank space at either end disregarded, and what is left may carry a leading minus, SHALL
hold at least one digit, SHALL hold no character that is not a digit but for at most one separator,
a full stop or a comma, and SHALL hold no more than thirty-eight significant digits. What that
reading does not hold as a number SHALL NOT be rounded, truncated or adjusted to fit. Whether a
field is blank SHALL be asked before it is read as a number, blank being decided by the one test
this package asks for the question. A range end holding a zero-width space alone SHALL be refused as
not a number rather than as empty. Both range ends blank SHALL be a commitment of the number kind
carrying no range, while one end filled and the other blank is not no range. A range or a target
left in a field the chosen kind has no room for SHALL be ignored, and SHALL NOT be refused: the tick
and note kinds carry neither whatever those fields hold, the number kind takes its range and ignores
a target, and the total kind takes its target and ignores a range.

#### Scenario: a commitment defined through a commitments screen is kept at the roster place before either list says so

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Gym" on a weekday-set rhythm of Monday, Wednesday
  and Saturday, kept from that same day, is defined through it
- **THEN** a roster store opened afterwards at that place holds one commitment, named "Gym"
- **AND** what the screen keeps is one entry, named "Gym"
- **AND** nothing is refused

#### Scenario: a commitment defined through a commitments screen is last in what it keeps

- **WHEN** a commitment named "Water plants" and one named "Gym", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen
  is opened at that roster place as of Monday 31 August 2026; and a commitment named "Journaling"
  on a weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it
- **THEN** what it keeps is three entries, named "Water plants", then "Gym", then "Journaling"

#### Scenario: a commitment defined on each of the four rhythms is read back on the schedule that rhythm names

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and four commitments kept from that same day are defined through it — "Gym"
  on a weekday-set rhythm of Monday, Wednesday and Saturday; "Finances" on a day-of-the-month rhythm
  of the 25th; "Contact lenses" on an interval rhythm of 14 days; and "Reading" on a weekly-quota
  rhythm of 3 times a week
- **THEN** a roster store opened afterwards at that place holds four commitments equal, one for one
  and in that order, to commitments formed directly from those names, the schedules those rhythms
  name and Monday 31 August 2026

#### Scenario: a commitment defined on an interval rhythm counts from the day it is kept from

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Contact lenses" on an interval rhythm of 14 days,
  kept from Wednesday 1 July 2026, is defined through it
- **THEN** the commitment a roster store opened afterwards at that place holds is due on Wednesday
  1 July 2026 and on Wednesday 15 July 2026
- **AND** it is not due on Thursday 2 July 2026 and not due on Tuesday 30 June 2026

#### Scenario: a commitments screen offers the day it was handed as the day to keep a commitment from

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept
- **THEN** the day it offers to keep a commitment from is Monday 31 August 2026

#### Scenario: a commitments screen offers the tick kind for a new commitment

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept
- **THEN** the kind it offers for a new commitment is the tick kind
- **AND** a screen opened at a place keeping a commitment of the total kind offers the tick kind too

#### Scenario: a commitments screen accepts a day to keep from that has not arrived and one long past

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "Gym" on a weekday-set rhythm of all seven weekdays,
  kept from 31 December 9999, is defined through it; and a commitment named "Journaling" on that
  same rhythm, kept from 1 January 1583, is defined through it
- **THEN** neither is refused
- **AND** what the screen keeps is two entries, named "Gym" and then "Journaling"

#### Scenario: a commitment defined under a category is drawn in that category's group and kept under it

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and a commitment named "Creatine" on a weekday-set rhythm of all
  seven weekdays, kept from that same day, under the category "Supplements", is defined through it
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then a group with no
  category holding "Gym"
- **AND** a roster store opened afterwards at that place reads back "Creatine" under "Supplements"

#### Scenario: a commitment defined under a category of nothing but blank space is under none and is not refused

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Gym" on a weekday-set rhythm of all seven weekdays,
  kept from that same day, under a category of three spaces, is defined through it
- **THEN** nothing is refused
- **AND** what it keeps is one group, with no category, holding "Gym"
- **AND** a commitment named "Journaling" alike in every other way defined under a category with
  nothing in it at all is likewise not refused and is in that same group

#### Scenario: a category is kept exactly as it was typed on the form

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and two commitments on a weekday-set rhythm of all seven weekdays, kept
  from that same day, are defined through it — one named "Creatine" under the category
  " Supplements " and one named "Magnesium" under the category "Supplements"
- **THEN** neither is refused
- **AND** what it keeps is two groups, the first " Supplements " with both spaces holding
  "Creatine", the second "Supplements" holding "Magnesium"

#### Scenario: a commitment of each of the four kinds is defined through a commitments screen and kept with that kind

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and four commitments on a weekday-set rhythm of all seven weekdays, kept
  from that same day, under no category, are defined through it — "Gym" of the tick kind; "Mood" of
  the number kind with a lowest of "1" and a highest of "10"; "Journal" of the note kind; and
  "Protein" of the total kind with a target of "120"
- **THEN** none of the four is refused
- **AND** a roster store opened afterwards at that place holds four commitments equal, one for one
  and in that order, to commitments formed directly from those names, that schedule and that day, of
  the tick kind, the number kind with a range of 1 to 10, the note kind, and the total kind with a
  target of 120

#### Scenario: a commitment of the number kind defined with both range fields blank carries no range

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Weight" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the number kind with a lowest of "" and a
  highest of "", is defined through it
- **THEN** it is not refused
- **AND** a roster store opened afterwards at that place holds one commitment, of the number kind
  carrying no range
- **AND** a screen alike in every way defining "Weight" with a lowest of "   " and a highest of "  "
  keeps a commitment of the number kind carrying no range too

#### Scenario: a range end and a target are read as a number entry reads a number

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and two commitments on a weekday-set rhythm of all seven weekdays, kept from
  that same day, under no category, are defined through it — "Temperature" of the number kind with a
  lowest of " -40,5 " and a highest of "150.00", and "Dose" of the total kind with a target of "0,5"
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place holds "Temperature" of the number kind with
  a range whose lowest is -40.5 and whose highest is 150, and "Dose" of the total kind with a target
  of 0.5

#### Scenario: a range typed on a kind with no room for one is ignored rather than refused

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and two commitments on a weekday-set rhythm of all seven weekdays, kept from
  that same day, under no category, are defined through it — "Journal" of the note kind with a lowest
  of "10" and a highest of "1" left in the range fields, and "Protein" of the total kind with a target
  of "120" and a lowest of "not a number" left in the range fields
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place holds "Journal" of the note kind and
  "Protein" of the total kind with a target of 120
- **AND** a screen alike in every way defining "Gym" of the tick kind with the same range fields
  filled in keeps a commitment of the tick kind

#### Scenario: a target typed on a kind with no room for one is ignored rather than refused

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven weekdays,
  kept from that same day, under no category, of the number kind with a lowest of "1", a highest of
  "10" and a target of "0" left in the target field, is defined through it
- **THEN** it is not refused
- **AND** a roster store opened afterwards at that place holds one commitment, of the number kind
  with a range whose lowest is 1 and whose highest is 10

#### Scenario: a commitment alike in every way but the kind it takes is refused for the name it shares

- **WHEN** a commitment named "Weight" on a schedule listing all seven weekdays, kept from
  1 January 2026, of the tick kind, is taken on at a roster place; a commitments screen is opened at
  that roster place as of Monday 31 August 2026; and a commitment named "Weight" on a weekday-set
  rhythm of all seven weekdays, kept from 1 January 2026, under no category, of the number kind
  carrying no range, is defined through it
- **THEN** it is refused as a name already in use, naming "Weight"
- **AND** what the screen keeps is one entry, named "Weight", of the tick kind
- **AND** a screen alike in every way whose roster had stopped the tick "Weight" instead refuses it
  the same way, and still keeps nothing and has stopped one named "Weight"

#### Scenario: a target typed on the tick or the note kind is ignored rather than refused

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and two commitments on a weekday-set rhythm of all seven weekdays, kept
  from that same day, under no category, are defined through it — "Gym" of the tick kind and
  "Journal" of the note kind, each with a target of "0" left in the target field
- **THEN** neither is refused
- **AND** a roster store opened afterwards at that place holds "Gym" of the tick kind and "Journal"
  of the note kind

#### Scenario: a range whose two ends each hold a zero-width space alone is refused as not a number rather than taken as blank

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the number kind with a lowest of one
  zero-width space and a highest of one zero-width space, is defined through it
- **THEN** it is refused as a range that is not a range
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a range end holding no digit is refused as not a number

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the number kind with a lowest of "-" and
  a highest of "10", is defined through it
- **THEN** it is refused as a range that is not a range
- **AND** a commitment alike in every way with a lowest of "0" and a highest of "." is refused the
  same way
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a range end holding more than one separator is refused as not a number

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Mood" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, under no category, of the number kind with a lowest of "1.2.3"
  and a highest of "10", is defined through it
- **THEN** it is refused as a range that is not a range
- **AND** a commitment alike in every way with a lowest of "1" and a highest of "1,5.0" is refused
  the same way
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitment defined through a commitments screen carries an identity of its own

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Gym" on a weekday-set rhythm of Monday, Wednesday
  and Saturday, kept from that same day, is defined through it; "Gym" is then renamed "Lifting"
  through it; and a commitment named "Gym" on that same rhythm and day is defined through it
- **THEN** neither is refused
- **AND** what it keeps is two entries, named "Lifting" and then "Gym"
- **AND** a look-back at "Lifting" and one at "Gym" are look-backs at different commitments

#### Scenario: a commitment defined under the name a deleted commitment had is taken on last, under the category the form carried

- **WHEN** a commitment named "Creatine" and one named "Gym", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Creatine" is deleted there;
  a commitments screen is opened at that roster place as of Monday
  31 August 2026; and a commitment named "Creatine" on that same rhythm, kept from that same day,
  under the category "Supplements", is defined through it
- **THEN** nothing is refused
- **AND** what it keeps is two groups, "Supplements" holding "Creatine" and then one with no
  category holding "Gym"
- **AND** a look-back at "Creatine" says the day kept from "31 August 2026"
