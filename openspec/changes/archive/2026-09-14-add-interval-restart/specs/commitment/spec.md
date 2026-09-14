## ADDED Requirements

### Requirement: A commitments screen restarts an interval commitment it keeps, from a day it is given

A commitments screen SHALL restart a commitment on its kept list whose schedule is an interval of
days, on being given that commitment and a calendar date and nothing else. It SHALL supersede the
commitment as of the day before that date with a commitment alike in name, interval and kind whose
schedule starts on that date and which is kept from that date, under the category the commitment is
under.

It SHALL carry every record of the commitment made on or after that date onto the restarted
commitment at the record place, and SHALL leave every record made before that date under the
commitment it was made for. The record place SHALL be written before the roster place, and where no
record is carried nothing SHALL be written at the record place. A restart SHALL change no name, no
interval, no kind and no category.

#### Scenario: an interval commitment restarted from today is kept until yesterday and runs on from today under its name, interval and category

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, under the category "Care", is taken on at a roster place; a
  tick for it on Monday 10 August 2026 is kept at a record place; a commitments screen is opened at
  that roster place and that record place as of Monday 31 August 2026; and "Nails" is restarted
  through it from Monday 31 August 2026
- **THEN** nothing is refused
- **AND** what it keeps is one group, "Care", holding one entry named "Nails", saying "Every 4 days"
- **AND** a roster store opened afterwards at that place answers about Sunday 30 August 2026 with
  "Nails" on every 4 days starting on Monday 31 August 2026, kept from that day, and then "Nails" on
  every 4 days starting on Thursday 6 August 2026, kept from Tuesday 4 August 2026; and about Monday
  31 August 2026 with the first alone
- **AND** the content at that record place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: restarting an interval commitment carries every record on or after the day it restarts from onto the restarted commitment

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Saturday 1 August 2026, is taken on at a roster place; ticks for it on Thursday
  6 August 2026 and Monday 10 August 2026 are kept at a record place; a commitments screen is opened
  at that roster place and that record place as of Monday 31 August 2026; and "Nails" is restarted
  through it from Sunday 2 August 2026
- **THEN** nothing is refused
- **AND** a store opened afterwards at that record place answers that "Nails" on every 4 days
  starting on Sunday 2 August 2026, kept from that day, was kept on Thursday 6 August 2026 and on
  Monday 10 August 2026
- **AND** it answers that "Nails" kept from Saturday 1 August 2026 was kept on neither day

#### Scenario: an interval commitment restarted from the day it is kept from is kept on no date before the restart

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday
  31 August 2026; and "Nails" is restarted through it from Tuesday 4 August 2026
- **THEN** nothing is refused
- **AND** the commitment a roster store opened afterwards at that place is keeping is due on Tuesday
  4 August 2026 and on Saturday 8 August 2026, and not due on Thursday 6 August 2026
- **AND** that roster store answers about Tuesday 4 August 2026 with that commitment alone

#### Scenario: an interval commitment restarted through a commitments screen draws one row on a day screen on either side of the restart

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday
  31 August 2026; and "Nails" is restarted through it from Monday 31 August 2026
- **THEN** a day screen opened afterwards at those places as of Sunday 30 August 2026 draws one row,
  named "Nails"
- **AND** one opened as of Monday 31 August 2026 draws one row, named "Nails", and so does one
  opened as of Friday 4 September 2026
- **AND** one opened as of Thursday 3 September 2026 draws no row

### Requirement: A commitments screen refuses a restart it cannot make

A commitments screen SHALL refuse a restart from a date later than the day it was handed, from a
date earlier than the day the commitment is kept from, and from a date the commitment is already due
on, each told apart from every other refusal.

It SHALL refuse a restart as a commitment already kept where its roster holds the restarted
commitment in any state; as a day already recorded on that the change would leave not due where a
record on or after the date is on a day the restarted commitment is not due on; as records already
kept where the record place holds a record of the restarted commitment, the not-due cause given
where both hold; and as a place that could not be written. A refused restart SHALL keep nothing at
either place and SHALL be held against the commitment it was asked about.

#### Scenario: a restart from a day after today, a day before the day kept from, or a day the rhythm is already due on is refused, each told apart

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a commitments screen is
  opened at that roster place and at a record place where nothing has been kept as of Monday
  31 August 2026; and "Nails" is restarted through it three times — from Tuesday 1 September 2026,
  from Monday 3 August 2026 and from Sunday 30 August 2026
- **THEN** the three are refused as a day after today, a day before the day it is kept from and a day
  the rhythm is already due on, each told apart from the others and from a place that could not be
  written
- **AND** what it keeps is one entry named "Nails", and the content at both places is byte-for-byte
  what it was immediately after the screen was opened

#### Scenario: a restart that would leave a day recorded on after it not due is refused

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a tick for it on Sunday
  30 August 2026 is kept at a record place; a commitments screen is opened at that roster place and
  that record place as of Monday 31 August 2026; and "Nails" is restarted through it from Saturday
  29 August 2026
- **THEN** it is refused as a day already recorded on that the change would leave not due
- **AND** the content at both places is byte-for-byte what it was immediately after the screen was
  opened

#### Scenario: a restart onto a commitment whose records are already kept is refused for that cause

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, is taken on at a roster place; a tick on Monday 31 August
  2026 for a commitment named "Nails" on a schedule of every 4 days starting on that day, kept from
  that day, is kept at a record place; a commitments screen is opened at that roster place and that
  record place as of Monday 31 August 2026; and "Nails" is restarted through it from Monday
  31 August 2026
- **THEN** it is refused as records already kept under the commitment the change would produce, told
  apart from a day already recorded on that the change would leave not due
- **AND** the content at both places is byte-for-byte what it was immediately after the screen was
  opened

#### Scenario: a restart whose result the roster already holds is refused as a commitment already kept

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Tuesday 4 August 2026, and one named "Nails" on a schedule of every 4 days starting
  on Monday 31 August 2026, kept from that day, are taken on at a roster place; the second is removed
  there as of Sunday 30 August 2026; a commitments screen is opened at that roster place and at a
  record place where nothing has been kept as of Monday 31 August 2026; and the first is restarted
  through it from Monday 31 August 2026
- **THEN** it is refused as a commitment already kept
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

#### Scenario: a restart refused at the roster place after its records were carried over leaves the record place as it was

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Saturday 1 August 2026, is taken on at a roster place; ticks for it on Thursday
  6 August 2026 and Monday 10 August 2026 are kept at a record place; a commitments screen is opened
  at that roster place and that record place as of Monday 31 August 2026; the content at that record
  place is read; what is at that roster place is then made impossible to write; and "Nails" is
  restarted through it from Sunday 2 August 2026
- **THEN** it is refused as a place that could not be written
- **AND** the content at that record place is byte-for-byte what was read before the restart
- **AND** what it keeps is one entry named "Nails", and the screen holds that refusal, against
  restarting "Nails"

#### Scenario: a restart a commitments screen could not carry over at the record place leaves the roster place as it was

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on Thursday 6 August
  2026, kept from Saturday 1 August 2026, is taken on at a roster place; a tick for it on Thursday
  6 August 2026 is kept at a record place in a directory of its own; a commitments screen is opened
  at that roster place and that record place as of Monday 31 August 2026; the record place's
  directory is then made impossible to write, while the roster place's directory stays writable; and
  "Nails" is restarted through it from Sunday 2 August 2026
- **THEN** it is refused as a place that could not be written
- **AND** the content at that roster place is byte-for-byte what it was immediately after the screen
  was opened

### Requirement: A commitments screen says whether a commitment can be restarted, and offers the day it was handed to restart from

A commitments screen SHALL say, for a commitment on either of its lists, whether it can be restarted:
it can where its roster is keeping it and its schedule is an interval of days, and it cannot
otherwise. The day it SHALL offer to restart from is the day it was handed.

Asked to restart a commitment that cannot be restarted, or one on neither of its lists, a removed one
included, it SHALL do nothing: it SHALL write nothing at either place, SHALL refuse nothing and SHALL
hold no refused change.

#### Scenario: a commitments screen says only a kept interval commitment can be restarted

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on 1 January 2026, one
  named "Lenses" on that same schedule, and one named "Gym" on a schedule listing Monday, Wednesday
  and Saturday, all kept from 1 January 2026, are taken on at a roster place; "Lenses" is stopped
  there as of Sunday 30 August 2026; and a commitments screen is opened at that roster place as of
  Monday 31 August 2026
- **THEN** what it says "Nails" is made of says it can be restarted
- **AND** what it says "Lenses" and "Gym" are made of says each cannot
- **AND** the day it offers to restart from is Monday 31 August 2026

#### Scenario: a restart asked of a commitment that cannot be restarted does nothing and says nothing

- **WHEN** a commitment named "Nails" on a schedule of every 4 days starting on 1 January 2026, one
  named "Lenses" on that same schedule, one named "Pool" on that same schedule, and one named "Gym"
  on a schedule listing Monday, Wednesday and Saturday, all kept from 1 January 2026, are taken on at
  a roster place; "Lenses" is stopped there and "Pool" removed there, both as of Sunday 30 August
  2026; a commitments screen is opened at that roster place and at a record place where nothing has
  been kept as of Monday 31 August 2026; and "Lenses", "Pool" and "Gym" are each restarted through it
  from Monday 31 August 2026
- **THEN** nothing is refused and the screen holds no refused change
- **AND** the content at both places is byte-for-byte what it was immediately after the screen was
  opened
