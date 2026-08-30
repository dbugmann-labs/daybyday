## Why

The `schedule` capability (#6) has no requirements yet — `openspec/specs/schedule/` does not
exist. Half of the owner's day-one list is weekday rules ("gym Mon/Wed/Sat, run Tue/Thu/Sun"),
so a set of weekdays is the rule shape the product cannot ship without, and it is the smallest
of the four shapes `CONTEXT.md` records as needed.

It is also the first Swift in the repository. ADR 1001 decided the language and said the rule
engine — *is this commitment due on this date* — lives in a Swift Package whose exported entry
point is the seam. This Story is where that package appears, and where the question **what is a
date to the rule engine** is answered once for the three schedule Stories that follow it
(#9, #10, #11).

## What Changes

- Creates the `schedule` capability with its first requirements: a commitment whose schedule is
  a set of weekdays is due on a date exactly when that date's weekday is in the set.
- Fixes what a *calendar date* is to the engine — a year, a month and a day of that month, with
  no clock and no time zone — and makes a combination that names no real day impossible to form
  rather than silently rolled into the next month.
- Fixes the years the engine accepts — 1583 through 9999 — and refuses a year outside them rather
  than answering about it. This was added after the G7 review, which found the shipped code
  refusing those years for two good reasons (Foundation's calendar is Julian before the Gregorian
  reform of 1582, and a component large enough to be read back as unspecified is not a number worth
  judging) and no requirement saying it may.
- Fixes how a date's weekday is decided: by the Gregorian calendar, independent of locale and of
  which day anyone considers the week to start on.
- Settles two things left open in `docs/parking-lot.md`: a set of all seven weekdays is due every
  day (so "every day" needs no rule shape of its own), and an empty set is due on no day.
- Adds the Swift package that holds the rule engine, with one library target and one test target
  driven by `swift test`. No UI, no persistence, no app target.
- **Not in this change:** the other three rule shapes (#9, #10, #11); ticking; where a week
  begins; a commitment's identity, start date or end date; anything on screen.

## Capabilities

### New Capabilities

- `schedule`: how DayByDay decides whether a commitment is due on a given day, and what a day is
  to that decision.

### Modified Capabilities

None. Only `cli-version` exists in `openspec/specs/`, and it is untouched.

## Impact

- **Code:** the repository's first Swift package, at `src/DayByDayKit/`. It exports one public
  behaviour — the seam — and depends on nothing outside the standard library and Foundation.
  Paths, names and the seam signature are fixed in `design.md`.
- **Specs:** creates `openspec/specs/schedule/spec.md` at archive time. No existing spec is
  touched, so CI check 2 has exactly one claimed capability.
- **Repository configuration:** `.gitignore` needs `.build/` and `.swiftpm/` before the first
  `swift build`, or build products land in `git status`. That file is outside the implementer's
  stated write scope; `design.md` § *Risks* says so rather than leaving it to be discovered.
- **CI:** first exercise of the `swift` job, which discovers `Package.swift` and runs
  `swift test`, and of check 4 reading `@Test("...")` display names out of Swift source. Both
  were built for this Story and neither has ever run against real Swift.
- **Dependencies:** none added, in either language.
