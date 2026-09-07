## MODIFIED Requirements

### Requirement: A commitments screen lists the commitments its roster keeps, in the order they were taken on

A commitments screen SHALL hold a roster, read at the place it keeps its roster, and SHALL list the
commitments that roster is keeping, in the order the roster answers with. A commitment the roster
has stopped keeping MUST NOT be in that list.

An entry in the list SHALL be a commitment's name and the rhythm it runs on **in words**, and
nothing else. The words are the ones the `schedule` capability says for the schedule that
commitment carries, read off the commitment the entry is for: this screen composes none of them and
chooses none of them, so an entry and a day screen's row say one rhythm the same way. An entry
SHALL NOT say the kind its days take, which is the surface `add-kind-to-commitments-screen` (#142)
adds, and SHALL NOT say the day the commitment is kept from, which says when it began rather than
what rhythm it runs on.

Two commitments alike in name and unlike in rhythm are therefore two entries a person can tell
apart, which is what a rhythm beside a name is for. Two alike in name **and** in rhythm, unlike
only in the day they are kept from or the kind their days take, are still two entries a person
cannot tell apart, and that is accepted rather than refused. The roster refuses only a commitment
it is already keeping, and a screen refusing a name the roster allows would forbid the same thing
kept on two rhythms.

**The scenario below titled *two commitments alike in name and not in rhythm are two entries a
person cannot tell apart* is kept exactly as it was, and its title is now wrong.** Everything it
asserts still holds — two entries, both named "Vitamins", the first of which can be stopped — but
the entries say different rhythms, so a person can tell them apart, and the scenario after it says
so. It is kept because `openspec` 1.10.0 refuses a MODIFIED requirement that drops any scenario the
current spec has, and the only way to drop one is to rename the requirement, which moves the whole
block to the bottom of the spec at archive time. `design.md` § *A scenario title that is now wrong*
has the evidence.

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

#### Scenario: an entry says the rhythm its commitment runs on, whichever of the four shapes it is

- **WHEN** a commitment named "Gym" on a schedule listing Monday, Wednesday and Saturday, one named
  "Finances" on a schedule on the 25th of the month, one named "Contact lenses" on a schedule of
  every 14 days starting on 1 January 2026, and one named "Reading" on a schedule of 3 times a
  week, all kept from 1 January 2026, are taken on at a roster place; and a commitments screen is
  opened at that roster place as of Monday 31 August 2026
- **THEN** what it keeps is four entries saying "Mon, Wed, Sat", "The 25th", "Every 14 days" and
  "3x a week" beside their names, in that order

#### Scenario: two commitments alike in name and not in rhythm are two entries a person cannot tell apart

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday and one named
  "Vitamins" on a schedule listing Tuesday and Thursday, both kept from 1 January 2026, are taken
  on at a roster place; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** what it keeps is two entries, both named "Vitamins"
- **AND** stopping the first of them leaves what it keeps as one entry named "Vitamins"

#### Scenario: two commitments alike in name and not in rhythm are told apart by the rhythm their entries say

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday and one named
  "Vitamins" on a schedule listing Tuesday and Thursday, both kept from 1 January 2026, are taken
  on at a roster place; and a commitments screen is opened at that roster place as of Monday
  31 August 2026
- **THEN** what it keeps is two entries, both named "Vitamins", the first saying "Mon, Wed" and the
  second saying "Tue, Thu"
- **AND** stopping the first of them leaves what it keeps as one entry named "Vitamins", saying
  "Tue, Thu"

#### Scenario: two commitments alike in name and in rhythm are two entries that say the same thing

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday kept from
  1 January 2026, and one named "Vitamins" on a schedule listing Monday and Wednesday kept from
  1 June 2026, are taken on at a roster place; and a commitments screen is opened at that roster
  place as of Monday 31 August 2026
- **THEN** what it keeps is two entries, both named "Vitamins" and both saying "Mon, Wed"
- **AND** neither is refused, because the roster is keeping two different commitments

#### Scenario: a commitments screen opened on a roster that holds nothing lists nothing and takes nothing on

- **WHEN** a commitments screen is opened as of Monday 31 August 2026 at a roster place where
  nothing has been kept
- **THEN** what it keeps is nothing and what it has stopped is nothing
- **AND** it says it is keeping a roster
- **AND** nothing is kept at that roster place

### Requirement: A commitments screen lists what has been stopped, beside what it keeps

A commitments screen SHALL list, separately from the commitments its roster is keeping, the
commitments that roster has stopped keeping — in the order they were taken on, each as a name and
the rhythm it runs on in words, exactly as the first list is. A commitment SHALL be in exactly one
of the two lists and never in both.

This second list exists because the roster's rule that offering a stopped commitment again *takes
it up again* cannot otherwise be reached from a phone. A person who had to retype a name, rebuild a
rhythm and match a day kept from exactly would in practice be making a different commitment, and a
roster every one of whose commitments has been stopped would be a day screen with no rows for ever.
It says a rhythm for the same reason the first list does: two stopped commitments alike in name are
as hard to tell apart as two kept ones, and this list is the one place a person picks which of them
to take up again.

A roster that has stopped nothing SHALL list nothing as stopped.

#### Scenario: a commitments screen lists what its roster has stopped keeping, in the order they were taken on

- **WHEN** a commitment named "Water plants", then one named "Gym", then one named "Journaling",
  all on a schedule listing all seven weekdays and kept from 1 January 2026, are taken on at a
  roster place; "Journaling" and then "Water plants" are stopped there as of Sunday 30 August 2026;
  and a commitments screen is opened at that roster place as of Monday 31 August 2026
- **THEN** what it has stopped is two entries, named "Water plants" and then "Journaling"
- **AND** what it keeps is one entry, named "Gym"

#### Scenario: a stopped entry says the rhythm its commitment runs on, as a kept entry does

- **WHEN** a commitment named "Vitamins" on a schedule listing Monday and Wednesday and one named
  "Vitamins" on a schedule of 3 times a week, both kept from 1 January 2026, are taken on at a
  roster place; both are stopped there as of Sunday 30 August 2026; and a commitments screen is
  opened at that roster place as of Monday 31 August 2026
- **THEN** what it has stopped is two entries, both named "Vitamins", the first saying "Mon, Wed"
  and the second saying "3x a week"

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

## ADDED Requirements

### Requirement: A commitments screen says in words the rhythm its form is building

A commitments screen SHALL say, for the rhythm its form is currently building, the words the
schedule that rhythm names would be said in — the same words the entry for that commitment will say
once it is defined, and no others. It SHALL say them as the rhythm is built rather than only once
it is defined, so that a person reads what their rhythm will say before they commit to it.

It SHALL say them **without being given a day to keep the commitment from**. An interval rhythm
carries no start date and an interval schedule's words never say one, so a rhythm's words are
exactly the words of the schedule it names, on every one of the four shapes and whatever day the
commitment would be kept from.

A rhythm this screen would refuse to define a commitment on SHALL be said in one of exactly two
ways, and never in the wording of the refusal itself:

- A **weekday set with no days in it** names a schedule the system forms, so it SHALL be said as
  that schedule is said — "No day". The screen refuses to define on it (ADR-1028); saying so is
  what the refusal does, and the words go on describing the rhythm being built.
- A **number no schedule can be built on** — a day of the month that is not one of the thirty-one,
  an interval of fewer than one day, a weekly quota outside one to seven — names no schedule at
  all, so there are no words for it and the screen SHALL say **nothing**. It MUST NOT substitute
  the nearest number that would work, and MUST NOT say a refusal here: what a person does about
  such a number is told when they try to define on it, in one place, by the requirement above.

#### Scenario: a rhythm being built is said in the words the schedule it names says

- **WHEN** a weekday-set rhythm of Monday, Wednesday and Saturday, a day-of-the-month rhythm of the
  25th, an interval rhythm of 14 days, and a weekly-quota rhythm of 3 times a week are each said in
  words for a commitments screen's form
- **THEN** they say "Mon, Wed, Sat", "The 25th", "Every 14 days" and "3x a week"

#### Scenario: an interval rhythm is said without a day to keep the commitment from

- **WHEN** an interval rhythm of 14 days is said in words for a commitments screen's form
- **THEN** it says "Every 14 days"
- **AND** those are the words of a schedule of every 14 days starting on 1 January 2026, and the
  words of a schedule of every 14 days starting on 31 August 2026, alike

#### Scenario: a weekday-set rhythm with no days in it is said as no day

- **WHEN** a weekday-set rhythm listing no weekdays at all is said in words for a commitments
  screen's form
- **THEN** it says "No day"

#### Scenario: a rhythm carrying a number the calendar will not take is said as nothing

- **WHEN** a day-of-the-month rhythm of the 32nd, a day-of-the-month rhythm of the 0th, an interval
  rhythm of 0 days and a weekly-quota rhythm of 8 times a week are each said in words for a
  commitments screen's form
- **THEN** each says nothing at all
- **AND** in particular none of them says "The 31st", "Every 1 day" or "7x a week"

#### Scenario: a rhythm carrying the number at each end of what it allows is said in words

- **WHEN** a day-of-the-month rhythm of the 1st, a day-of-the-month rhythm of the 31st, an interval
  rhythm of 1 day, a weekly-quota rhythm of 1 time a week and a weekly-quota rhythm of 7 times a
  week are each said in words for a commitments screen's form
- **THEN** they say "The 1st", "The 31st", "Every day", "1x a week" and "7x a week"
