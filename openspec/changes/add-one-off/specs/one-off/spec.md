## Purpose

Describes what a one-off is to DayByDay — a name and a date for something owed once and never
again — which single day it stands on as of a today, how it is ticked, taken back and removed, and
how a store of its own keeps one-offs across the app being closed and opened again.

## ADDED Requirements

### Requirement: A one-off is a name and a calendar date, and nothing else

A one-off SHALL be a name and a calendar date, and SHALL carry nothing else: no rhythm, no day it
is kept from, no kind, no category, no identifier, and no record of whether it is done. Two
one-offs SHALL be the same one-off exactly when their names and their dates are both equal, and
one differing in either SHALL be a different one-off. A one-off's name SHALL be kept exactly as it
was given, with no blank space removed from either end, so two names differing only in blank space
SHALL be two different names and two different one-offs.

#### Scenario: two one-offs alike in name and date are the same one-off

- **WHEN** a one-off named "Call mum" on 25 September 2026 is compared with another one-off named
  "Call mum" on 25 September 2026
- **THEN** they are the same one-off
- **AND** a one-off named "Call dad" on 25 September 2026 is a different one-off
- **AND** a one-off named "Call mum" on 26 September 2026 is a different one-off

#### Scenario: a one-off's name is kept exactly as it was given

- **WHEN** a one-off is made with the name " Call mum " on 25 September 2026
- **THEN** its name is " Call mum ", with the blank space at both ends
- **AND** a one-off named "Call mum" on 25 September 2026 is a different one-off

### Requirement: A one-off's name says something

Making a one-off from a name that says nothing SHALL be refused, and no one-off SHALL come of it: a
name that is empty and a name made only of blank space SHALL both be refused. Whether a name says
nothing SHALL be judged exactly as a commitment's name is judged, and this capability SHALL add no
further rule to a name and drop none: every other name SHALL be taken as given, whatever its
length, its script or its words.

#### Scenario: a name that says nothing is refused and makes no one-off

- **WHEN** a one-off is made with an empty name on 25 September 2026
- **THEN** making it is refused and no one-off is made
- **AND** a one-off made with a name of blank space alone is refused the same way
- **AND** a one-off made with a name of one character that is not blank space is made

### Requirement: A one-off stands on exactly one day at a time

A one-off that is held SHALL stand on exactly one day as of a today, and SHALL be answered with
that day. A one-off that is not done SHALL stand on the later of its date and that today: on its
own date while that date is still to come or is the today itself, and on the today once its date
has passed. A one-off that is done SHALL stand on the day it was ticked, whatever the today is, and
that day SHALL NOT move again. A one-off that is not held SHALL stand on no day at all, and SHALL
be answered as standing nowhere rather than with a day.

#### Scenario: a one-off that is not done stands on its date until that date has passed

- **WHEN** a one-off named "Call mum" on 25 September 2026 is held and not done, and is asked which
  day it stands on as of 21 September 2026
- **THEN** it stands on 25 September 2026
- **AND** asked as of 25 September 2026 it stands on 25 September 2026

#### Scenario: a one-off that is not done and whose date has passed stands on today

- **WHEN** a one-off named "Call mum" on 25 September 2026 is held and not done, and is asked which
  day it stands on as of 28 September 2026
- **THEN** it stands on 28 September 2026
- **AND** asked as of 5 October 2026 it stands on 5 October 2026

#### Scenario: a one-off that is done stands on the day it was ticked, whatever today is

- **WHEN** a one-off named "Call mum" on 25 September 2026 is ticked on 25 September 2026, and is
  asked which day it stands on as of 5 October 2026
- **THEN** it stands on 25 September 2026
- **AND** asked as of 25 September 2026 it stands on 25 September 2026

#### Scenario: a one-off ticked after its date stands on the day it was ticked and not on its date

- **WHEN** a one-off named "Call mum" on 25 September 2026 is ticked on 28 September 2026, and is
  asked which day it stands on as of 5 October 2026
- **THEN** it stands on 28 September 2026

#### Scenario: a one-off that is not held stands on no day

- **WHEN** one-offs holding nothing are asked which day a one-off named "Call mum" on
  25 September 2026 stands on as of 21 September 2026
- **THEN** they answer that it stands nowhere
- **AND** one-offs holding only a one-off named "Call dad" on 25 September 2026 answer the same way

### Requirement: One-offs hold what a person owes once, and refuse one they already hold

One-offs SHALL hold every one-off added to them and not since removed. Adding a one-off SHALL be
refused where a one-off with the same name and the same date is already held, whether that one is
done or not; the refusal SHALL be answered rather than silent, and what is held SHALL be unchanged
by it. A one-off differing in name or in date from every one-off held SHALL be added and held
beside them. A one-off MAY be added already done on a day, which SHALL hold it exactly as adding it
and then ticking it on that day would.

#### Scenario: adding a one-off already held is refused and changes nothing

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added to one-offs already holding
  that one-off
- **THEN** adding it is refused
- **AND** what is held is the same as one-offs that one-off was added to once
- **AND** adding it is refused the same way where the one held is done

#### Scenario: a one-off differing in name or in date is held beside the one already there

- **WHEN** a one-off named "Call mum" on 25 September 2026 is held, and a one-off named "Call mum"
  on 26 September 2026 is added
- **THEN** adding it is not refused
- **AND** both one-offs stand on their own dates as of 21 September 2026
- **AND** a one-off named "Call dad" on 25 September 2026 is added and stands on 25 September 2026
  the same way

#### Scenario: a one-off added already done stands on the day it was done

- **WHEN** a one-off named "Call mum" on 20 September 2026 is added already done on
  20 September 2026
- **THEN** adding it is not refused
- **AND** it stands on 20 September 2026 as of 28 September 2026
- **AND** what is held is the same as one-offs that one-off was added to and then ticked on
  20 September 2026

### Requirement: A one-off is ticked on the day it was done, and its tick can be taken back

Ticking a one-off SHALL record the day it was done, and the one-off SHALL then be done. A one-off
SHALL NOT be made done on a day before its own date, however it is made done: ticking on such a day
and adding already done on such a day SHALL both be refused. Ticking a one-off that is not held,
and ticking one that is already done, SHALL both be refused, and what is held SHALL be unchanged by
either. Taking back a one-off's tick SHALL leave that one-off held and no longer done. Taking back
the tick of a one-off that is not done, or of one that is not held, SHALL be refused.

#### Scenario: a one-off ticked on a day is done and stands there

- **WHEN** a one-off named "Call mum" on 25 September 2026 is held and is ticked on
  25 September 2026
- **THEN** ticking it is not refused
- **AND** it stands on 25 September 2026 as of 5 October 2026

#### Scenario: making a one-off done on a day before its date is refused

- **WHEN** a one-off named "Call mum" on 25 September 2026 is held and is ticked on
  24 September 2026
- **THEN** ticking it is refused
- **AND** what is held is unchanged
- **AND** adding a one-off named "Call dad" on 25 September 2026 already done on 24 September 2026
  is refused the same way

#### Scenario: ticking a one-off that is already done is refused and leaves the day it holds

- **WHEN** a one-off named "Call mum" on 25 September 2026 that was ticked on 25 September 2026 is
  ticked again on 28 September 2026
- **THEN** ticking it is refused
- **AND** it still stands on 25 September 2026 as of 5 October 2026

#### Scenario: ticking a one-off that is not held is refused

- **WHEN** one-offs holding nothing are asked to tick a one-off named "Call mum" on
  25 September 2026 on 25 September 2026
- **THEN** ticking it is refused
- **AND** what is held is the same as one-offs nothing was added to

#### Scenario: a tick taken back leaves the one-off held and standing by its date again

- **WHEN** a one-off named "Call mum" on 25 September 2026 that was ticked on 25 September 2026 has
  its tick taken back, and is asked which day it stands on as of 21 September 2026
- **THEN** taking the tick back is not refused
- **AND** it stands on 25 September 2026
- **AND** asked as of 28 September 2026 it stands on 28 September 2026

#### Scenario: taking back the tick of a one-off that is not done is refused

- **WHEN** a one-off named "Call mum" on 25 September 2026 is held and not done, and its tick is
  taken back
- **THEN** taking it back is refused
- **AND** what is held is unchanged
- **AND** taking back the tick of a one-off that is not held is refused the same way

### Requirement: A one-off is removed outright, done or not

Removing a one-off SHALL take it away whole: nothing of it SHALL be kept, and it SHALL stand on no
day afterwards. A one-off that is done SHALL be removed in the same one act as one that is not,
with its tick and without its tick being taken back first. Removing a one-off that is not held
SHALL be refused, and what is held SHALL be unchanged by the refusal. Removing one one-off SHALL
leave every other one-off held exactly as it was, each still done or not as it was.

#### Scenario: a one-off removed is held no longer and stands on no day

- **WHEN** a one-off named "Call mum" on 25 September 2026 is held and is removed
- **THEN** removing it is not refused
- **AND** it stands nowhere as of 21 September 2026
- **AND** what is held is the same as one-offs nothing was added to

#### Scenario: a one-off that is done is removed outright, tick and all

- **WHEN** a one-off named "Call mum" on 25 September 2026 that was ticked on 25 September 2026 is
  removed, where a one-off named "Call dad" on 26 September 2026 ticked on 26 September 2026 is also
  held
- **THEN** removing it is not refused
- **AND** it stands nowhere as of 5 October 2026
- **AND** "Call dad" still stands on 26 September 2026 as of 5 October 2026

#### Scenario: removing a one-off that is not held is refused

- **WHEN** one-offs holding only a one-off named "Call dad" on 25 September 2026 are asked to remove
  a one-off named "Call mum" on 25 September 2026
- **THEN** removing it is refused
- **AND** what is held is the same as one-offs "Call dad" alone was added to

### Requirement: A one-off store keeps one-offs at a place, across the app being closed and opened again

A one-off store SHALL be opened at a place and SHALL hold one-offs: every one-off added there and
not since removed, each done or not as it was left. It SHALL be a store of its own, holding nothing
another store holds. Opening a store where nothing has been kept SHALL hold no one-offs rather than give an
error. Every change SHALL be kept at that place before the store reports it kept — a one-off added,
ticked, taken back or removed — and nothing SHALL be held only in memory. A store opened at that
place afterwards SHALL hold every change kept there, whether or not the store that kept it is still
open. A change that cannot be kept SHALL be refused and not held, and a change the one-offs
themselves refuse SHALL leave the place untouched. Stores at different places SHALL be independent.

#### Scenario: a store opened where nothing has been kept holds no one-offs

- **WHEN** a one-off store is opened at a place where no one-off store has ever been kept
- **THEN** it opens without error
- **AND** what it holds is the same as one-offs nothing was added to

#### Scenario: a store opened again holds exactly the one-offs left there, done or not as they were left

- **WHEN** one-offs named "Call mum" on 25 September 2026, "Call dad" on 26 September 2026 and
  "Send form" on 27 September 2026 are added to a one-off store; "Call mum" is ticked on
  28 September 2026; "Call dad" is ticked on 26 September 2026 and its tick taken back; "Send form"
  is removed; and a store is opened afterwards at the same place
- **THEN** the later store holds the same one-offs as one-offs "Call mum" and "Call dad" were added
  to with "Call mum" ticked on 28 September 2026
- **AND** "Call mum" stands on 28 September 2026 and "Call dad" on 5 October 2026, both as of
  5 October 2026
- **AND** "Send form" stands nowhere

#### Scenario: a change is kept before the store reports it kept

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added to a one-off store and ticked on
  25 September 2026, and a second store is then opened at the same place with the first still open
  and nothing else done to it
- **THEN** the second store holds that one-off
- **AND** it stands on 25 September 2026 as of 5 October 2026

#### Scenario: a change that cannot be kept is refused and not held

- **WHEN** a one-off store is opened at a place where nothing can be written — a path beneath an
  existing ordinary file — and a one-off named "Call mum" on 25 September 2026 is added to it
- **THEN** adding it is refused with an error
- **AND** what the store holds is the same as one-offs nothing was added to
- **AND** a store opened afterwards at the same place holds no one-offs

#### Scenario: a change the one-offs refuse leaves the place untouched

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added to a one-off store, and the same
  one-off is added again
- **THEN** the second addition is refused without an error
- **AND** the content at that place is byte-for-byte what it was after the first addition

#### Scenario: one-off stores at different places are independent

- **WHEN** a one-off named "Call mum" on 25 September 2026 is added to a one-off store at one place,
  and a one-off store is opened at a different place where nothing has been kept
- **THEN** the second store holds no one-offs
- **AND** a store opened afterwards at the first place holds that one-off

### Requirement: A one-off store that cannot be read is refused rather than emptied

Opening a one-off store at a place holding something this app cannot read as one SHALL be refused
with an error. The store MUST NOT hold no one-offs instead, overwrite or delete what is there, or
keep the part that could be read: the whole SHALL be refused and what is there left unchanged. What
cannot be read SHALL include content that is not such a store, a store written in a form later than
the one this app writes, and a store holding what could not be a one-off or could not be held: a
name that says nothing, a date that names no day, a day done before the one-off's own date, and two
one-offs alike in name and date. Every rule a one-off is formed and held by SHALL be applied again
to what comes off the place, and no rule SHALL be added there or dropped.

#### Scenario: content that is not a one-off store is refused and left as it was

- **WHEN** a one-off store is opened at a place holding content that is not a one-off store — a run
  of bytes that is not what the store writes
- **THEN** opening is refused with an error
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a one-off store written in a later form than this app knows is refused

- **WHEN** a one-off store is opened at a place holding a one-off store written in a form one later
  than the form this app writes, holding no one-offs
- **THEN** opening is refused with an error
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a one-off store holding what could not be a one-off is refused

- **WHEN** a one-off store is opened at a place holding a store in the form this app writes, whose
  one one-off has a name of blank space alone on 25 September 2026
- **THEN** opening is refused with an error
- **AND** a store whose one one-off is named "Call mum" on 30 February 2026, a date that names no
  day, is refused the same way
- **AND** a store whose one one-off is named "Call mum" on 25 September 2026 and done on
  24 September 2026 is refused the same way
- **AND** a store holding two one-offs both named "Call mum" on 25 September 2026 is refused the
  same way
- **AND** the content at each place is byte-for-byte what it was before
