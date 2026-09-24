# birthday Specification

## Purpose
Describes what a birthday is to DayByDay once the phone's calendar has handed it over — a contact,
the calendar's words and a day — which birthdays fall on a day, the tick the app keeps against one,
and how a store of its own keeps those ticks across the app being closed and opened again.

## Requirements

### Requirement: A birthday is a contact, the calendar's words and a day, and nothing else

A birthday SHALL be a contact, the words the calendar gives that year's occurrence, and the day the
occurrence falls on, and SHALL carry nothing else: no name, age or year of birth apart from what its
words say, and no record of whether it is ticked. Two birthdays SHALL be the same birthday exactly
when their contacts, their words and their days are all equal. A birthday's words SHALL be kept
exactly as they were handed, whatever they are: nothing SHALL be taken out of them, added to them
or changed. Making a birthday whose contact says nothing SHALL be refused, and no birthday SHALL come
of it; whether a contact says nothing SHALL be judged exactly as a commitment's name is judged.

#### Scenario: two birthdays alike in contact, words and day are the same birthday

- **WHEN** a birthday of the contact "kate" worded "Kate Bell's 48th Birthday" on 25 September 2026
  is compared with another of the contact "kate" worded "Kate Bell's 48th Birthday" on
  25 September 2026
- **THEN** they are the same birthday
- **AND** one of the contact "john" with the same words on the same day is a different birthday
- **AND** one of the contact "kate" worded "Kate Smith's 48th Birthday" on 25 September 2026 is a
  different birthday
- **AND** one of the contact "kate" worded "Kate Bell's 48th Birthday" on 25 September 2027 is a
  different birthday

#### Scenario: a birthday's words are kept exactly as they were handed

- **WHEN** a birthday of the contact "kate" is made worded " Kate Bell's 48th Birthday " on
  25 September 2026
- **THEN** its words are " Kate Bell's 48th Birthday ", with the blank space at both ends
- **AND** one made worded "Kate Bell's Birthday", with no age, has the words "Kate Bell's Birthday"
- **AND** one made with empty words is made, and its words are empty

#### Scenario: a birthday whose contact says nothing is refused and makes no birthday

- **WHEN** a birthday is made of an empty contact worded "Kate Bell's 48th Birthday" on
  25 September 2026
- **THEN** making it is refused and no birthday is made
- **AND** one made of a contact of blank space alone is refused the same way
- **AND** one made of a contact of one character that is not blank space is made

### Requirement: The birthdays on a day are the ones handed that fall on it, in the order they were handed

Asked which birthdays fall on a day, out of birthdays handed to it, the answer SHALL be every
birthday handed whose day is that day and no other, in the order they were handed. No birthday
handed SHALL be left out, merged with another or added, so a birthday handed twice SHALL be answered
twice, and the answer SHALL impose no order of its own, whether by words or by contact. A day on
which no birthday handed falls, and a day asked about out of nothing handed, SHALL both be answered
with no birthdays rather than refused.

#### Scenario: the birthdays on a day are the ones handed that fall on it, in the order they were handed

- **WHEN** birthdays are handed in this order — the contact "kate" worded "Kate Bell's 48th
  Birthday" on 25 September 2026, the contact "john" worded "John Appleseed's 40th Birthday" on
  26 September 2026, and the contact "anna" worded "Anna Haro's Birthday" on 25 September 2026 —
  and the birthdays on 25 September 2026 are asked for
- **THEN** the answer is Kate's birthday and then Anna's, and nothing else
- **AND** with Anna's handed before Kate's, the answer is Anna's and then Kate's
- **AND** with Kate's handed twice, the answer holds Kate's twice

#### Scenario: a day on which no birthday handed falls holds no birthdays

- **WHEN** the same three birthdays are handed and the birthdays on 27 September 2026 are asked for
- **THEN** the answer holds no birthdays
- **AND** the birthdays on 25 September 2026 asked for out of nothing handed are no birthdays

### Requirement: A birthday is ticked against its contact and its day, and its tick can be taken back

Ticking a birthday SHALL hold a tick against its contact and its day, and nothing else of it. A
birthday SHALL be ticked exactly when a tick is held against its contact and its day, whatever its
words, so a birthday whose words have changed since it was ticked SHALL still be ticked. A tick
SHALL NOT tick a birthday of another contact on the same day, nor a birthday of the same contact on
any other day. Ticking a birthday already ticked, under any words, SHALL be refused, and so SHALL
taking back the tick of a birthday that is not ticked; what is held SHALL be unchanged by either.
Taking back a tick, under any words, SHALL leave that birthday not ticked.

#### Scenario: a birthday ticked is ticked, and no other birthday is

- **WHEN** the birthday of the contact "kate" worded "Kate Bell's 48th Birthday" on
  25 September 2026 is ticked
- **THEN** ticking it is not refused
- **AND** that birthday is ticked
- **AND** the birthday of the contact "john" worded "John Appleseed's 40th Birthday" on
  25 September 2026 is not ticked
- **AND** the birthday of the contact "kate" worded "Kate Bell's 49th Birthday" on 25 September 2027
  is not ticked

#### Scenario: a tick follows its birthday when the calendar's words for it change

- **WHEN** the birthday of the contact "kate" worded "Kate Bell's 48th Birthday" on
  25 September 2026 is ticked, and the birthday of the contact "kate" worded "Kate Smith's 48th
  Birthday" on 25 September 2026 is asked about
- **THEN** it is ticked

#### Scenario: ticking a birthday already ticked is refused and changes nothing

- **WHEN** the birthday of the contact "kate" worded "Kate Bell's 48th Birthday" on
  25 September 2026 is ticked, and is ticked again
- **THEN** the second tick is refused
- **AND** what is held is the same as ticks that birthday was ticked in once
- **AND** ticking the birthday of the contact "kate" worded "Kate Smith's 48th Birthday" on
  25 September 2026 is refused the same way

#### Scenario: a tick taken back leaves the birthday not ticked

- **WHEN** the birthday of the contact "kate" worded "Kate Bell's 48th Birthday" on
  25 September 2026 is ticked, and its tick is taken back
- **THEN** taking it back is not refused
- **AND** that birthday is not ticked
- **AND** what is held is the same as ticks nothing was ticked in
- **AND** the tick is taken back the same way through the birthday of the contact "kate" worded
  "Kate Smith's 48th Birthday" on 25 September 2026

#### Scenario: taking back the tick of a birthday that is not ticked is refused

- **WHEN** ticks holding nothing are asked to take back the tick of the birthday of the contact
  "kate" worded "Kate Bell's 48th Birthday" on 25 September 2026
- **THEN** taking it back is refused
- **AND** what is held is the same as ticks nothing was ticked in
- **AND** where only that birthday is ticked, taking back the contact "kate"'s birthday on
  25 September 2027 is refused and the one on 25 September 2026 is still ticked

### Requirement: A birthday tick is held until it is taken back, whatever the calendar hands

A tick SHALL be held until it is taken back, and nothing but taking it back SHALL remove it. It
MUST NOT be removed, moved or changed because no birthday handed afterwards has its contact and its
day, and asking which birthdays fall on a day SHALL change no tick. A birthday handed again with the
contact and the day of a tick still held SHALL be ticked, whatever its words.

#### Scenario: a tick whose birthday the calendar no longer hands is kept, and ticks it again when it is handed again

- **WHEN** the birthday of the contact "kate" worded "Kate Bell's 48th Birthday" on
  25 September 2026 is ticked, and the birthdays on 25 September 2026 are asked for out of a hand
  holding only the contact "john"'s birthday worded "John Appleseed's 40th Birthday" on that day
- **THEN** the answer is John's birthday alone
- **AND** what is held is the same as ticks Kate's birthday was ticked in
- **AND** Kate's birthday on 25 September 2026, handed again, is ticked

### Requirement: A birthday store keeps birthday ticks at a place, across the app being closed and opened again

A birthday store SHALL be opened at a place and SHALL hold birthday ticks: every tick made there and
not since taken back. It SHALL hold nothing else — no birthday's words and not whether birthdays are
turned on — and nothing another store holds. Opening a store where nothing has been kept SHALL hold
no ticks rather than give an error. Every tick and every take-back SHALL be kept at that place
before the store reports it kept, and nothing SHALL be held only in memory. A store opened at that
place afterwards SHALL hold every change kept there, whether or not the store that kept it is still
open. A change that cannot be kept SHALL be refused and not held, and a change the ticks themselves
refuse SHALL leave the place untouched. Stores at different places SHALL be independent.

#### Scenario: a birthday store opened where nothing has been kept holds no ticks

- **WHEN** a birthday store is opened at a place where no birthday store has ever been kept
- **THEN** it opens without error
- **AND** what it holds is the same as ticks nothing was ticked in

#### Scenario: a birthday store opened again holds exactly the ticks left there, and none of their words

- **WHEN** the birthdays of the contact "kate" worded "Kate Bell's 48th Birthday" on
  25 September 2026, the contact "john" worded "John Appleseed's 40th Birthday" on
  26 September 2026 and the contact "anna" worded "Anna Haro's Birthday" on 25 September 2026 are
  ticked in a birthday store, John's tick is taken back, and a store is opened afterwards at the
  same place
- **THEN** the later store holds the same as ticks Kate's and Anna's birthdays were ticked in
- **AND** the birthday of the contact "kate" worded "Kate Smith's 48th Birthday" on
  25 September 2026 is ticked there
- **AND** the content at that place holds none of the words any of the three was ticked under

#### Scenario: a birthday tick is kept before the store reports it kept

- **WHEN** the birthday of the contact "kate" worded "Kate Bell's 48th Birthday" on
  25 September 2026 is ticked in a birthday store, and a second store is then opened at the same
  place with the first still open and nothing else done to it
- **THEN** the second store holds that birthday ticked

#### Scenario: a birthday tick that cannot be kept is refused and not held

- **WHEN** a birthday store is opened at a place where nothing can be written — a path beneath an
  existing ordinary file — and the birthday of the contact "kate" worded "Kate Bell's 48th Birthday"
  on 25 September 2026 is ticked in it
- **THEN** ticking it is refused with an error
- **AND** what the store holds is the same as ticks nothing was ticked in
- **AND** a store opened afterwards at the same place holds no ticks

#### Scenario: a change the birthday ticks refuse leaves the place untouched

- **WHEN** the birthday of the contact "kate" worded "Kate Bell's 48th Birthday" on
  25 September 2026 is ticked in a birthday store, and is ticked again
- **THEN** the second tick is refused without an error
- **AND** the content at that place is byte-for-byte what it was after the first tick
- **AND** taking back the tick of the contact "john"'s birthday on 25 September 2026, never ticked,
  is refused without an error and leaves that content the same

#### Scenario: birthday stores at different places are independent

- **WHEN** the birthday of the contact "kate" worded "Kate Bell's 48th Birthday" on
  25 September 2026 is ticked in a birthday store at one place, and a birthday store is opened at a
  different place where nothing has been kept
- **THEN** the second store holds no ticks
- **AND** a store opened afterwards at the first place holds that birthday ticked

### Requirement: A birthday store that cannot be read is refused rather than emptied

Opening a birthday store at a place holding something this app cannot read as one SHALL be refused
with an error. The store MUST NOT hold no ticks instead, overwrite or delete what is there, or keep
the part that could be read: the whole SHALL be refused and what is there left unchanged. What
cannot be read SHALL include content that is not such a store, a store written in a form later than
the one this app writes, and a store holding what could not be a tick: a contact that says nothing,
a day that names no day, and two ticks alike in contact and day. Every rule a tick is made and held
by SHALL be applied again to what comes off the place, and no rule SHALL be added there or dropped.

#### Scenario: content that is not a birthday store is refused and left as it was

- **WHEN** a birthday store is opened at a place holding content that is not a birthday store — a
  run of bytes that is not what the store writes
- **THEN** opening is refused with an error
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a birthday store written in a later form than this app knows is refused

- **WHEN** a birthday store is opened at a place holding a birthday store written in a form one
  later than the form this app writes, holding no ticks
- **THEN** opening is refused with an error
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a birthday store holding what could not be a tick is refused

- **WHEN** a birthday store is opened at a place holding a store in the form this app writes, whose
  one tick is of a contact of blank space alone on 25 September 2026
- **THEN** opening is refused with an error
- **AND** a store whose one tick is of the contact "kate" on 30 February 2026, a day that names no
  day, is refused the same way
- **AND** a store holding two ticks both of the contact "kate" on 25 September 2026 is refused the
  same way
- **AND** the content at each place is byte-for-byte what it was before
