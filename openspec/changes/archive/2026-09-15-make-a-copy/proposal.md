## Why

A history lives at three places inside one app on one phone, and nothing takes it off that phone.
A person who loses the phone loses every tick they have made. This change gives them the first
of the three things `FEAT: restore` owes: a copy they can ask for and keep somewhere else.

## What Changes

- A copy is what the record, the roster and the one-offs hold, read at the moment it is asked for.
- The three are read the way the app reads them, so a torn save is undone and an earlier form is
  read up into the form the app writes now.
- A copy carries the moment it was made — the first time anything here knows a time of day.
- A copy carries a form of its own, so a later version can tell which shape it is reading.
- A store that cannot be read refuses the whole copy and names which store; nothing partial leaves.
- Three places where nothing has been kept still make a copy, holding nothing.
- The commitments screen offers a copy in a section of its own below what has been stopped.
- Asked for one, it writes a single file and answers where, for the share sheet to take.
- A copy's name says the day and the minute it was made; its kind is the app's own.
- A copy it cannot make is the screen's refused change, naming the store where one could not be read.
- A copy made changes nothing: no list moves, and a refusal already held goes on standing.

## Capabilities

### New Capabilities

- `restore`: ADDED five requirements — what a copy holds, what it carries, how the commitments
  screen makes one, what it is called, and what a copy it cannot make does.

### Modified Capabilities

- `commitment`: MODIFIED two requirements — making a copy joins the kinds of refused change a
  commitments screen holds, and a copy made is named among the calls that do not end one.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — a copy, a moment, the copy's form on disk
- `src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift`
- `src/DayByDayKit/Tests/DayByDayKitTests/`
- `src/DayByDay/DayByDay/CommitmentsView.swift`
- `src/DayByDay/DayByDay.xcodeproj/project.pbxproj` and a partial `Info.plist` beside it
- `CONTEXT.md`, `docs/adr/`
