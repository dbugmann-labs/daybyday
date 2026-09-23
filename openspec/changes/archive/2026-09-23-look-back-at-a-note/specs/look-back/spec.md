## ADDED Requirements

### Requirement: A note commitment's look-back says the notes its days hold, newest first

A look-back at a commitment whose days take a note SHALL say its **notes**, and no line, no whole
and no graph. It SHALL say one note for each day it counts that holds one, the note the record
holds for the era holding that day: that day, said as a look-back says a day, and the note's text
exactly as the record holds it, every line break kept and nothing left out. It SHALL say its notes
newest first, nothing at all about a day holding no note, and no note held on a day after the last
day it counts. Where no day it counts holds a note it SHALL say no note, and SHALL still say the
commitment's name, rhythm and dates as any other look-back does. A look-back at a commitment whose
days take anything but a note SHALL say no note.

#### Scenario: a note commitment's look-back says each day's note under its day, newest first

- **WHEN** a look-back is asked for at a commitment named "Journal" on a schedule listing every day,
  kept from 1 March 2026, whose days take a note, holding "Quiet day." on 1 March 2026, "Long walk."
  on 3 March 2026 and "Read in the evening." on 4 March 2026 and no note on any other day, as of 5
  March 2026
- **THEN** it says three notes, the first saying "Read in the evening." under the day "4 March
  2026", the second "Long walk." under "3 March 2026" and the third "Quiet day." under "1 March 2026"
- **AND** it says nothing at all about 2 March 2026 and 5 March 2026
- **AND** it says no line at all, no whole and no graph

#### Scenario: a note commitment's look-back says a note's text exactly as the record holds it, line breaks included

- **WHEN** a look-back is asked for at a commitment named "Journal" on a schedule listing every day,
  kept from 1 March 2026, whose days take a note, holding on 4 March 2026 a note of the four lines
  "Three things today:", "– finished the draft", "– called Anna" and "– early night", joined by one
  line break each, and no note on any other day, as of 5 March 2026
- **THEN** its one note says those four lines in that order, joined by one line break each, and
  nothing else
- **AND** a look-back at such a commitment holding on 4 March 2026 a note of one line 600
  characters long says that note whole

#### Scenario: a note commitment's look-back says no note where no day holds one

- **WHEN** a look-back is asked for at a commitment named "Journal" on a schedule listing every day,
  kept from 1 March 2026, whose days take a note, holding no note at all, as of 5 March 2026
- **THEN** it says no note, no line at all, no whole and no graph
- **AND** it says the name "Journal", the rhythm "Every day" and the day kept from "1 March 2026" as
  any other look-back does
- **AND** a look-back at such a commitment whose one note, on 3 March 2026, was taken back says no
  note either, and so does one at such a commitment kept from 1 April 2026
- **AND** a look-back at a commitment named "Gym" on a schedule listing every day, kept from 1 March
  2026, whose days take a tick, kept on 3 March 2026, says no note

#### Scenario: a stopped note commitment's look-back says no note after the day it was kept until

- **WHEN** a look-back is asked for at a commitment named "Journal" on a schedule listing every day,
  kept from 25 February 2026 and kept until 28 February 2026, whose days take a note, holding "Quiet
  day." on 27 February 2026 and "Long walk." on 4 March 2026, as of 5 March 2026
- **THEN** it says one note, "Quiet day." under the day "27 February 2026"
- **AND** it says the day kept until "28 February 2026"

#### Scenario: a note commitment's look-back says the notes of every era of its chain

- **WHEN** a look-back is asked for at a commitment named "Journal" whose days take a note, whose
  earlier era ran on a schedule listing every day from 1 March 2026 until 3 March 2026 and whose
  newest runs on a schedule listing Tuesday and Thursday from 4 March 2026, the older era holding
  "Quiet day." on 2 March 2026 and the newer "Long walk." on 5 March 2026, as of 8 March 2026
- **THEN** it says exactly two notes, "Long walk." under the day "5 March 2026" and then "Quiet day."
  under "2 March 2026"
- **AND** it says the day kept from "1 March 2026"

### Requirement: A note commitment's look-back counts the notes it says

A look-back at a commitment whose days take a note SHALL say a **count** of the notes it says: that
number said as a look-back says a number, a single space and the word "notes", except that where it
says exactly one note the count SHALL be "1 note". The count SHALL be the number of notes the
look-back says and nothing else, and SHALL NOT be a fraction, a percentage or a number out of the
days the commitment was due. A look-back that says no note SHALL say no count, and a look-back at a
commitment whose days take anything but a note SHALL say no count either.

#### Scenario: a note commitment's look-back counts the notes it says

- **WHEN** a look-back is asked for at a commitment named "Journal" on a schedule listing every day,
  kept from 1 March 2026, whose days take a note, holding "Quiet day." on 1 March 2026, "Long walk."
  on 3 March 2026 and "Read in the evening." on 4 March 2026 and no note on any other day, as of 5
  March 2026
- **THEN** its count says "3 notes"

#### Scenario: a note commitment's look-back that says one note counts it in the singular

- **WHEN** a look-back is asked for at a commitment named "Journal" on a schedule listing every day,
  kept from 25 February 2026 and kept until 28 February 2026, whose days take a note, holding "Quiet
  day." on 27 February 2026 and "Long walk." on 4 March 2026, as of 5 March 2026
- **THEN** its count says "1 note"

#### Scenario: a look-back that says no note says no count

- **WHEN** a look-back is asked for at a commitment named "Journal" on a schedule listing every day,
  kept from 1 March 2026, whose days take a note, holding no note at all, as of 5 March 2026
- **THEN** it says no count
- **AND** a look-back at a commitment named "Gym" on a schedule listing every day, kept from 1 March
  2026, whose days take a tick, kept on 3 March 2026, says no count either

## REMOVED Requirements

### Requirement: A look-back at a commitment whose days take a note says no line

**Reason**: A note's look-back now says its notes, newest first, and a count of them; that it still
says no line, no whole and no graph is said by the ADDED requirement in its place.

**Migration**: None. The test named for its one scenario is deleted; the tests named for the ADDED
scenarios replace it.
