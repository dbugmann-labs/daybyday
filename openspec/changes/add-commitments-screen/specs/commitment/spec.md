## ADDED Requirements

### Requirement: A commitments screen lists the commitments its roster keeps, in the order they were taken on

A commitments screen SHALL hold a roster, read at the place it keeps its roster, and SHALL list the
commitments that roster is keeping, in the order the roster answers with. A commitment the roster
has stopped keeping MUST NOT be in that list.

An entry in the list SHALL be a commitment's name and nothing else. Saying a rhythm in words is a
rule about how a schedule is said and belongs to the `schedule` capability whichever screen would
read it, so a commitments screen MUST NOT say one.

Two commitments alike in name and unlike in anything else are therefore two entries a person cannot
tell apart, and that is accepted rather than refused. The roster refuses only a commitment it is
already keeping, and a screen refusing a name the roster allows would forbid the same thing kept on
two rhythms.

A commitments screen SHALL ask its roster no date. What it lists is what a person keeps now; which
commitments a roster had not stopped keeping on a given date is the day screen's question and not
this screen's.

A roster holding nothing at all SHALL be listed as nothing at all. A commitments screen MUST NOT
take any commitment on of its own — day one belongs to the day screen and to the moment its roster
holds nothing (ADR-1027), and a second thing writing day one would take it on twice.

#### Scenario: a commitments screen lists the commitments its roster keeps, in the order they were taken on

- **WHEN** a commitment named "Water plants" on a schedule listing all seven weekdays, then one
  named "Gym" on a schedule listing Monday, Wednesday and Saturday, then one named "Journaling" on
  a schedule listing all seven weekdays, all kept from 1 January 2026, are taken on at a roster
  place; and a commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is three entries, named "Water plants", then "Gym", then "Journaling"
- **AND** it says it is keeping a roster

#### Scenario: a commitments screen does not list a commitment its roster has stopped keeping

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday and one
  named "Journaling" on a schedule listing all seven weekdays, both kept from 1 January 2026, are
  taken on at a roster place; "Gym" is stopped there as of Sunday 30 August 2026; and a commitments
  screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is one entry, named "Journaling"
- **AND** "Gym" is not in what it keeps, although Monday 31 August 2026 is the day after the day it
  was kept until and the screen was asked no date at all

#### Scenario: two commitments alike in name and not in rhythm are two entries a person cannot tell apart

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday and one named
  "Vitamins" on a schedule listing Tuesday and Thursday, both kept from 1 January 2026, are taken
  on at a roster place; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** what it keeps is two entries, both named "Vitamins"
- **AND** stopping the first of them leaves what it keeps as one entry named "Vitamins"

#### Scenario: a commitments screen opened on a roster that holds nothing lists nothing and takes nothing on

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept
- **THEN** what it keeps is nothing and what it has stopped is nothing
- **AND** it says it is keeping a roster
- **AND** nothing is kept at that roster place

### Requirement: A commitments screen lists what has been stopped, beside what it keeps

A commitments screen SHALL list, separately from the commitments its roster is keeping, the
commitments that roster has stopped keeping — in the order they were taken on, each as a name and
nothing else, exactly as the first list is. A commitment SHALL be in exactly one of the two lists
and never in both.

This second list exists because the roster's rule that offering a stopped commitment again *takes
it up again* cannot otherwise be reached from a phone. A person who had to retype a name, rebuild a
rhythm and match a day kept from exactly would in practice be making a different commitment, and a
roster every one of whose commitments has been stopped would be a day screen with no rows for ever.

A roster that has stopped nothing SHALL list nothing as stopped.

#### Scenario: a commitments screen lists what its roster has stopped keeping, in the order they were taken on

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling",
  all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Journaling" and then "Water plants" are stopped there as of Sunday 30 August 2026;
  and a commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it has stopped is two entries, named "Water plants" and then "Journaling"
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitments screen whose roster has stopped nothing lists nothing as stopped

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; and a commitments screen is opened at that roster
  place as of Monday 31 August 2026
- **THEN** what it has stopped is nothing
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitment a commitments screen keeps is not among what it has stopped

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all
  seven weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped
  there as of Sunday 30 August 2026; and a commitments screen is opened at that roster place as of
  Monday 31 August 2026
- **THEN** no commitment is in both of its lists
- **AND** what it keeps names only "Journaling" and what it has stopped names only "Gym"

### Requirement: A commitments screen defines a commitment from a name, a rhythm and the day it is kept from

A commitments screen SHALL define a commitment from three things and no others: a name, a rhythm,
and the day it is kept from. The commitment so formed SHALL be taken on at the roster place before
either of the screen's lists says so, and SHALL then be last in what the screen keeps, because that
is the place the roster gives it.

A **rhythm** SHALL be one of four, and all four SHALL be offered: a weekday set, a day of the
month, an interval of a whole number of days, and a weekly quota. A rhythm carries nothing the
calendar does not supply — in particular an interval rhythm carries no start date.

**The day a commitment is kept from SHALL also be the start date of an interval rhythm.** The
commitment is due on the day a person started keeping it and every N days after it. The two remain
distinct in the model and may disagree where something other than this screen forms the commitment;
this screen offers one date and uses it for both.

A commitments screen SHALL offer, as the day to keep a commitment from, the day it was handed. It
SHALL accept any calendar date the system supports in that place, the future included: a person who
has kept something since June says June, and "I start the gym on Monday" is a real thing to want. A
commitments screen MUST NOT judge that date against the day it was handed, and MUST NOT bound it in
any way the calendar does not.

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

#### Scenario: a commitments screen accepts a day to keep from that has not arrived and one long past

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "Gym" on a weekday-set rhythm of all seven weekdays,
  kept from 31 December 9999, is defined through it; and a commitment named "Journaling" on that
  same rhythm, kept from 1 January 1583, is defined through it
- **THEN** neither is refused
- **AND** what the screen keeps is two entries, named "Gym" and then "Journaling"

### Requirement: A commitments screen refuses a name that says nothing, and a rhythm due on no day

A commitments screen SHALL refuse to define a commitment whose name is empty or made only of blank
space, and SHALL refuse to define one on a weekday set with no days in it. Neither SHALL be kept at
the roster place, and neither SHALL change either of the screen's lists. The two SHALL be told
apart from each other, because they are different things to fix.

The first refusal is the one a commitment already makes: a name that names nothing names nothing on
any screen.

**The second is the screen's own, and the rule engine goes on accepting the value.** A weekday set
with no days in it is a legal schedule, due on no date the system supports, and the `schedule`
capability SHALL be unchanged by this requirement. A commitment made on one is a commitment a
person would never see again, which is a rule about what a screen should offer to make rather than
about what a schedule value may be. ADR-1028.

A commitments screen SHALL refuse nothing else about a name. There is no length limit, no
restricted script and no reserved word: the name is the owner's own words rather than the system's.

#### Scenario: a commitments screen refuses a commitment named with nothing but blank space

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "   " on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it
- **THEN** it is refused as a name that says nothing
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a commitments screen refuses a weekday set with no days in it

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and a commitment named "Gym" on a weekday-set rhythm listing no weekdays
  at all, kept from that same day, is defined through it
- **THEN** it is refused as a rhythm due on no day, told apart from a name that says nothing
- **AND** what the screen keeps is nothing, and nothing is kept at that roster place

#### Scenario: a weekday set with no days in it is still a schedule the rule engine accepts

- **WHEN** a commitment named "Gym" is formed directly from a schedule listing no weekdays at all,
  kept from 1 January 2026
- **THEN** the commitment is formed
- **AND** it is not due on 1 January 2026 and not due on any of the seven days after it

#### Scenario: a commitments screen refuses nothing else about a name

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept, and three commitments on a weekday-set rhythm of all seven weekdays, kept
  from that same day, are defined through it — one named "x", one named " Gym ", and one named
  "Gym 🏋️"
- **THEN** none of the three is refused
- **AND** what the screen keeps is three entries, named "x", then " Gym ", then "Gym 🏋️", the
  spaces around " Gym " kept exactly as they were given

### Requirement: A commitments screen tells a commitment it already keeps apart from a roster it could not write

A commitments screen SHALL refuse a commitment its roster is already keeping, and SHALL refuse a
change it could not keep at the roster place, and SHALL tell the two apart. Neither SHALL change
either of the screen's lists, and neither SHALL change what is at the roster place.

This deliberately does not follow the day screen, which tells every refused tick the same way
(ADR-1021). The reasoning there was that a refusal a person cannot act on differently should not be
told apart, and it does not carry: a commitment you already keep is your own doing and you can
change the name, the rhythm or the day you keep it from, while a place that will not take a write
leaves a person nothing to do but try again later.

A commitment the roster has **stopped** keeping is not a duplicate. Defining the same three things
again SHALL take that commitment up again, in the place it was taken on in, exactly as offering it
to the roster does.

#### Scenario: a commitments screen refuses a commitment its roster is already keeping

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and a commitment named "Gym" on a weekday-set rhythm of Monday,
  Wednesday and Saturday, kept from 1 January 2026, is defined through it
- **THEN** it is refused as a commitment already kept
- **AND** what the screen keeps is one entry, named "Gym"
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a commitments screen that could not keep a new commitment says the roster could not be written

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place under a
  directory that cannot be created, and a commitment named "Gym" on a weekday-set rhythm of all
  seven weekdays, kept from that same day, is defined through it
- **THEN** it is refused as a roster that could not be written, told apart from a commitment already
  kept
- **AND** what the screen keeps is nothing

#### Scenario: defining a commitment a commitments screen has stopped keeping takes it up again in the place it was taken on in

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling",
  all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Gym" is stopped there as of Sunday 30 August 2026; a commitments screen is opened
  at that roster place as of Monday 31 August 2026; and a commitment named "Gym" on a weekday-set
  rhythm of all seven weekdays, kept from 1 January 2026, is defined through it
- **THEN** it is not refused
- **AND** what the screen keeps is three entries, named "Water plants", then "Gym", then
  "Journaling"
- **AND** what it has stopped is nothing

#### Scenario: a commitment a commitments screen refuses as already kept is not taken on a second time

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and that same commitment is defined through it twice
- **THEN** both are refused as a commitment already kept
- **AND** a roster store opened afterwards at that place holds one commitment

### Requirement: A commitments screen asks you to confirm before it stops keeping a commitment

A commitments screen SHALL be asked to stop keeping a commitment, and SHALL change nothing until
that stop is confirmed. Until then it SHALL hold exactly which commitment is awaiting confirmation,
so that a person can be told which one they are about to stop; being asked about a second
commitment SHALL replace the first, since only one stop can be awaiting confirmation at a time.

A stop that is cancelled SHALL leave the screen's two lists, and what is at the roster place,
exactly as they were, and SHALL leave nothing awaiting confirmation. Confirming SHALL do the same
when there is nothing awaiting confirmation.

A confirmed stop SHALL stop keeping the commitment **as of the day the screen was handed**, that
day being the last day it was kept, and SHALL keep that at the roster place before either list says
so. The commitment SHALL then be in what the screen has stopped and not in what it keeps, in the
place it was taken on in. A commitments screen holds one day and no other, so it offers no date to
pick.

A commitments screen asked to stop keeping a commitment its roster is not keeping SHALL do nothing
and SHALL say nothing: there is no refusal a person can act on, because there is nothing there to
stop. A stop that could not be kept at the roster place SHALL be refused as a roster that could not
be written, and SHALL leave both lists as they were.

#### Scenario: asking a commitments screen to stop keeping a commitment changes nothing until it is confirmed

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and it is asked to stop keeping "Gym"
- **THEN** it says "Gym" is awaiting confirmation
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a stop a commitments screen has been asked for and then cancelled changes nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is asked to stop keeping "Gym"; and the stop is cancelled
- **THEN** nothing is awaiting confirmation
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a commitments screen asked to stop a second commitment awaits confirmation of that one only

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; a commitments screen is
  opened at that roster place as of Monday 31 August 2026; it is asked to stop keeping "Gym"; it is
  then asked to stop keeping "Journaling"; and the stop is confirmed
- **THEN** what it has stopped is one entry, named "Journaling"
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a commitment stopped through a commitments screen is kept until the day the screen was handed

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and it is asked to stop keeping "Gym" and the stop is confirmed
- **THEN** a roster store opened afterwards at that place answers with "Gym" when asked what it had
  not stopped keeping on Monday 31 August 2026
- **AND** it answers with nothing when asked the same about Tuesday 1 September 2026

#### Scenario: a commitment stopped through a commitments screen moves from what it keeps to what it has stopped

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling",
  all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; a commitments screen is opened at that roster place as of Monday 31 August 2026;
  and it is asked to stop keeping "Gym" and the stop is confirmed
- **THEN** what it keeps is two entries, named "Water plants" and then "Journaling"
- **AND** what it has stopped is one entry, named "Gym"
- **AND** nothing is awaiting confirmation

#### Scenario: a commitments screen asked to stop keeping a commitment it does not keep does nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; "Gym" is stopped there as of Sunday 30 August 2026;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; and it is asked
  to stop keeping "Gym" and the stop is confirmed
- **THEN** nothing is refused and nothing is awaiting confirmation
- **AND** what it has stopped is one entry, named "Gym", kept until Sunday 30 August 2026 as it was
  before

#### Scenario: a stop a commitments screen could not keep leaves both its lists as they were

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster
  place as of Monday 31 August 2026; what is at that place is then made impossible to write; and
  the screen is asked to stop keeping "Gym" and the stop is confirmed
- **THEN** it is refused as a roster that could not be written
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing

### Requirement: A commitments screen takes a stopped commitment up again in one tap

A commitments screen SHALL take a commitment it has stopped up again, without asking for
confirmation and without asking for a name, a rhythm or a day. It SHALL keep that at the roster
place before either list says so; the commitment SHALL then be in what the screen keeps, in the
place it was taken on in, and not in what it has stopped.

It asks for no confirmation because the whole point of the second list is that stopping costs one
tap to undo. It asks for nothing else because the commitment is already three things the roster
holds; asking again would be defining a different commitment.

A commitments screen asked to take up again a commitment its roster has not stopped SHALL do
nothing and SHALL say nothing. One it could not keep at the roster place SHALL be refused as a
roster that could not be written, leaving both lists as they were.

#### Scenario: a commitment taken up again through a commitments screen moves from what it has stopped to what it keeps

- **WHEN** a commitment named "Gym" and one named "Journaling", both on a schedule listing all seven
  weekdays and kept from 1 January 2026, are taken on at a roster place; "Gym" is stopped there as
  of Sunday 30 August 2026; a commitments screen is opened at that roster place as of Monday
  31 August 2026; and "Gym" is taken up again through it
- **THEN** what it keeps is two entries, named "Gym" and then "Journaling"
- **AND** what it has stopped is nothing
- **AND** a roster store opened afterwards at that place answers with "Gym" when asked what it had
  not stopped keeping on Tuesday 1 September 2026

#### Scenario: a commitment taken up again through a commitments screen is in the place it was taken on in

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling",
  all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Water plants" is stopped there as of Sunday 30 August 2026; a commitments screen
  is opened at that roster place as of Monday 31 August 2026; and "Water plants" is taken up again
  through it
- **THEN** what it keeps is three entries, named "Water plants", then "Gym", then "Journaling"

#### Scenario: taking a commitment up again through a commitments screen asks for no confirmation

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; "Gym" is stopped there as of Sunday 30 August 2026;
  a commitments screen is opened at that roster place as of Monday 31 August 2026; and "Gym" is
  taken up again through it
- **THEN** nothing is awaiting confirmation at any point
- **AND** what it keeps is one entry, named "Gym", with nothing else asked of the screen

#### Scenario: a commitments screen asked to take up again a commitment it has not stopped does nothing

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; and "Gym" is taken up again through it
- **THEN** nothing is refused
- **AND** what it keeps is one entry, named "Gym", and what it has stopped is nothing
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

### Requirement: A commitments screen keeps its roster at the place a day screen keeps its, and reads it again when the app is shown

A commitments screen SHALL keep its roster, when it is not told another place, at exactly the place
a day screen keeps its. The two screens are each other's only writer, and a person who defines a
commitment on one and looks for it on the other is looking at one file.

A commitments screen SHALL be handed the day it is asked on when it is opened, and SHALL be handed
one again when the app is shown. Being shown SHALL read the roster place again and form both lists
again from what is then there, and SHALL replace the day the screen holds — so a commitment stopped
after midnight is kept until the day it is actually stopped on, and a screen the app was left on
overnight does not offer yesterday as the day to keep a new commitment from.

Nothing else changes the day a commitments screen holds. It reads no clock, and time passing does
not move it.

#### Scenario: a commitments screen keeps its roster at the place a day screen keeps its

- **WHEN** a commitments screen is asked where it keeps its roster when it is told no place
- **THEN** it answers with exactly the place a day screen keeps its roster at

#### Scenario: a commitment defined through a commitments screen is held by a day screen opened afterwards at the same place

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "Journaling" on a weekday-set rhythm of all seven
  weekdays, kept from that same day, is defined through it; and a day screen of no commitments at
  all is then opened at that roster place as of Monday 31 August 2026, at a record place where
  nothing has been kept
- **THEN** the day screen's day view holds one row, named "Journaling"

#### Scenario: a commitments screen shown again reads its roster again

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept; a commitment named "Gym" on a schedule listing all seven weekdays, kept
  from 1 January 2026, is taken on at that place by something else; and the screen is shown again
  as of Monday 31 August 2026
- **THEN** what it keeps is one entry, named "Gym"
- **AND** what it kept before it was shown again was nothing

#### Scenario: a commitments screen shown again on a later day stops a commitment as of that later day

- **WHEN** a commitment named "Gym" on a schedule listing all seven weekdays, kept from
  1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster place
  as of Monday 31 August 2026; it is shown again as of Tuesday 1 September 2026; and it is asked to
  stop keeping "Gym" and the stop is confirmed
- **THEN** a roster store opened afterwards at that place answers with "Gym" when asked what it had
  not stopped keeping on Tuesday 1 September 2026
- **AND** the day the screen offers to keep a commitment from is Tuesday 1 September 2026

### Requirement: A commitments screen that cannot read its roster lists nothing and changes nothing

A commitments screen whose roster place cannot be read SHALL list nothing in either list and SHALL
say that it is not keeping a roster. It MUST NOT take anything on, and it MUST NOT write over what
is at the place — what is there is left untouched for a person or a later version of the app to
recover.

Defining a commitment through such a screen SHALL be refused as a roster that could not be written.
Asking it to stop keeping a commitment, or to take one up again, SHALL do nothing and say nothing,
by the rule that already governs a commitment neither list holds: both its lists are empty, so
there is nothing there to stop and nothing there to take up.

Every way the place can refuse to be read SHALL be answered alike, save one, which SHALL be named:
a roster **written by a later version of DayByDay**. That roster is whole and it is the app that is
behind, so the person's answer is to update the app and leave the file completely alone, where a
screen saying only that something is wrong invites deleting it. No other reason leaves a person
anything different to do, so no other reason is told apart. ADR-1021.

The condition SHALL last only until the app is shown again, since being shown reads the place
afresh.

#### Scenario: a commitments screen that cannot read its roster lists nothing and says it is not keeping one

- **WHEN** a run of bytes that is not a roster store is written at a roster place, and a commitments
  screen is opened at that place as of Monday 31 August 2026
- **THEN** what it keeps is nothing and what it has stopped is nothing
- **AND** it says it is not keeping a roster

#### Scenario: a roster written in a later form than this app knows makes a commitments screen that says the roster is from a later version

- **WHEN** a roster store document declaring a version later than this app writes is written at a
  roster place, and a commitments screen is opened at that place as of Monday 31 August 2026
- **THEN** it says the roster was written by a later version of DayByDay, told apart from a roster
  that could not be read
- **AND** what it keeps is nothing and what it has stopped is nothing

#### Scenario: a commitments screen that cannot read its roster refuses a new commitment and leaves what is at the place as it was

- **WHEN** a run of bytes that is not a roster store is written at a roster place; a commitments
  screen is opened at that place as of Monday 31 August 2026; a commitment named "Gym" on a
  weekday-set rhythm of all seven weekdays, kept from that same day, is defined through it; and it
  is then asked to stop keeping a commitment named "Journaling" formed directly, and the stop is
  confirmed
- **THEN** defining "Gym" is refused as a roster that could not be written
- **AND** the stop refuses nothing and leaves nothing awaiting confirmation
- **AND** the content at that place is byte-for-byte what was written there

#### Scenario: a commitments screen that could not read its roster starts keeping one when it is shown again and the roster can be read

- **WHEN** a run of bytes that is not a roster store is written at a roster place; a commitments
  screen is opened at that place as of Monday 31 August 2026; what is at that place is replaced with
  a roster store holding a commitment named "Gym" on a schedule listing all seven weekdays, kept
  from 1 January 2026; and the screen is shown again as of Monday 31 August 2026
- **THEN** it says it is keeping a roster
- **AND** what it keeps is one entry, named "Gym"
