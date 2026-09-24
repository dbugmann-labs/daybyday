## ADDED Requirements

### Requirement: A birthday switch is kept at a place of its own, off until it is turned on

A birthday switch SHALL be opened at a place, and whether it is turned on SHALL be kept at that place
each time it changes. A switch opened afterwards at that place, where the phone gives full calendar
access, SHALL be on exactly when it was left on. The place a switch is kept at by default SHALL be
none of the record place, the roster place, the one-off place and the place the copy place is kept
at. A switch opened where nothing has been kept, or where what is kept cannot be read as a switch,
including a switch written in a later form than this app writes, SHALL be off and SHALL NOT be
refused. A copy SHALL hold nothing of the switch, and confirming a restore SHALL leave whether it is
turned on exactly as it was.

#### Scenario: a birthday switch opened where nothing has been kept is off

- **WHEN** a birthday switch is opened at a place where no birthday switch has ever been kept,
  asking a phone that has never been asked for calendar access
- **THEN** it opens without error, and it is off
- **AND** it says no refusal, and has asked the phone nothing
- **AND** the place a birthday switch is kept at by default is none of the record place, the roster
  place, the one-off place and the place the copy place is kept at

#### Scenario: a birthday switch opened again is on or off as it was left

- **WHEN** a birthday switch is opened at a place where nothing has been kept, asking a phone that
  gives full calendar access, and is turned on, and a second switch is then opened at the same place
  asking the same phone
- **THEN** the second switch is on
- **AND** with the first switch turned off before the second is opened, the second is off

#### Scenario: a birthday switch opened where what is kept cannot be read is off

- **WHEN** a birthday switch is opened, asking a phone that gives full calendar access, at a place
  holding a run of bytes that is not what a birthday switch writes
- **THEN** it opens without error, and it is off
- **AND** a switch opened at a place holding a switch turned on, written in a form one later than
  the form this app writes, is off the same way
- **AND** the first switch, then turned on, is on, and a switch opened again at its place is on

#### Scenario: a restore confirmed leaves the birthday switch as it was before the restore

- **WHEN** a birthday switch is opened at a place of its own asking a phone that gives full calendar
  access and is turned on; a commitment named "Gym" on a schedule listing all seven weekdays, kept
  from 1 January 2026, is taken on at a roster place; a commitments screen is opened at that roster
  place, a record place and a one-off place where nothing has been kept as of Monday 31 August 2026,
  and a copy is asked for as of that day at 14:32, written into a directory of its own; the switch is
  turned off; and the commitments screen is asked to restore from that copy and the restore is
  confirmed
- **THEN** a birthday switch opened again at the switch's place, asking the same phone, is off
- **AND** with the switch turned on again before the same copy is restored and confirmed once more,
  a birthday switch opened again at its place is on

### Requirement: Turning birthdays on asks the phone for calendar access, and they are on only if it gives full access

The phone's calendar access SHALL be one of never asked, full, write-only, denied and restricted. A
birthday switch turned on where the phone already gives full access SHALL be on and kept on, and
SHALL ask the phone nothing. Turned on where the phone does not, the switch SHALL ask the phone for
full access exactly once, and SHALL be on and kept on only if the phone then gives full access; any
other answer SHALL leave it off and kept off. Turned off, a switch SHALL be off and kept off, and
SHALL ask the phone nothing. Turning on a switch already on, or turning off a switch already off,
SHALL ask the phone nothing and SHALL change nothing at its place.

#### Scenario: birthdays turned on where the phone has never been asked are on once it gives full access

- **WHEN** a birthday switch is opened at a place where nothing has been kept, asking a phone that
  has never been asked for calendar access and gives full access when asked, and is turned on
- **THEN** it has asked the phone once
- **AND** it is on, and says no refusal
- **AND** a switch opened again at the same place, asking the same phone, is on

#### Scenario: birthdays turned on and refused at the prompt turn themselves back off

- **WHEN** a birthday switch is opened at a place where nothing has been kept, asking a phone that
  has never been asked for calendar access and denies it when asked, and is turned on
- **THEN** it has asked the phone once
- **AND** it is off, and says it is refused
- **AND** a switch opened again at the same place, asking the same phone, is off

#### Scenario: birthdays turned on where the phone already gives full access are on without asking

- **WHEN** a birthday switch is opened at a place where nothing has been kept, asking a phone that
  gives full calendar access, and is turned on
- **THEN** it is on, and has asked the phone nothing
- **AND** turned on again, it is still on, it has still asked the phone nothing, and the content at
  its place is byte-for-byte what it was after it was first turned on

#### Scenario: birthdays turned on where the phone gives less than full access ask again, and are on only if it then gives it

- **WHEN** a birthday switch is opened at a place where nothing has been kept, asking a phone that
  gives only write access to its calendars and gives full access when asked, and is turned on
- **THEN** it has asked the phone once
- **AND** it is on, and says no refusal
- **AND** asking a phone that gives only write access and still gives only write access when asked,
  it has asked once and is off, and says it is refused
- **AND** asking a phone that denies calendar access and still denies it when asked, and one whose
  calendar access is restricted and stays so, each has asked once and is off, and says it is refused

#### Scenario: birthdays turned off are off and kept off, and ask nothing

- **WHEN** a birthday switch is opened at a place where nothing has been kept, asking a phone that
  gives full calendar access, and is turned on and then turned off
- **THEN** it is off, says no refusal and has asked the phone nothing
- **AND** a switch opened again at the same place, asking the same phone, is off
- **AND** turned off again, it is still off and the content at its place is byte-for-byte what it
  was after it was first turned off

### Requirement: Birthdays are on only while the phone gives full calendar access

A birthday switch SHALL be on only while the phone gives it full calendar access. It SHALL read the
phone's calendar access when it is opened, each time it is shown again, and after it asks. Where
that reading is anything but full access — write-only, denied, restricted or never asked — a switch
kept on SHALL be off and SHALL be kept off at its place. Full access given back afterwards MUST NOT
turn the switch on again, whether it is shown again or opened again; only turning it on SHALL.

#### Scenario: birthdays kept on are off when opened where the phone no longer gives full access

- **WHEN** a birthday switch is opened at a place where nothing has been kept, asking a phone that
  gives full calendar access, and is turned on; and a second switch is opened at the same place
  asking a phone that denies calendar access
- **THEN** the second switch is off, says it is refused and has asked the phone nothing
- **AND** a third switch opened afterwards at the same place, asking a phone that gives full access
  again, is off
- **AND** the second switch is off and says it is refused the same way where the phone gives only
  write access, and where its calendar access is restricted
- **AND** where the phone has never been asked for calendar access, the second switch is off and
  says no refusal

#### Scenario: birthdays on are off when shown again after access is withdrawn, and stay off when it is given back

- **WHEN** a birthday switch is opened at a place where nothing has been kept, asking a phone that
  gives full calendar access, and is turned on; the phone then denies calendar access; and the
  switch is shown again
- **THEN** it is off, says it is refused and has asked the phone nothing
- **AND** with the phone then giving full access again and the switch shown again, it is still off
  and says no refusal
- **AND** a switch opened again at the same place, asking the same phone, is off

### Requirement: A birthday switch says it is refused whenever the phone refuses calendar access

A birthday switch SHALL say it is refused exactly while the phone's calendar access, as last read, is
write-only, denied or restricted, whether or not the switch has ever been turned on, and SHALL go on
saying so each time it is opened or shown again for as long as that lasts. Where the access is full
or has never been asked, it SHALL say no refusal. Saying it is refused SHALL ask the phone nothing
and SHALL change nothing at the switch's place.

#### Scenario: a birthday switch says it is refused where the phone refuses, though it was never turned on

- **WHEN** a birthday switch is opened at a place where nothing has been kept, asking a phone that
  denies calendar access, and is never turned on
- **THEN** it is off, says it is refused and has asked the phone nothing
- **AND** shown again, and shown again once more, it still says it is refused
- **AND** nothing has been kept at its place
- **AND** it says it is refused the same way where the phone gives only write access, and where its
  calendar access is restricted
- **AND** where the phone gives full access, it is off and says no refusal
