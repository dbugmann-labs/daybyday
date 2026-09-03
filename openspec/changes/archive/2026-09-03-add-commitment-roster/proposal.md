## Why

A commitment exists (#42) and a day can be drawn from a handful of them (#70, #71, #72, #91), but
nothing in the product holds *which* commitments a person keeps. `DayView` and `DayScreen` are both
handed a bare `[Commitment]`, and the only list that has ever been handed to them is
`dayOneCommitments` — eight values written into `src/DayByDay/DayByDay/ContentView.swift` by hand,
in a file the app shell cannot change and a person cannot add to. Everything the owner asked for
under `FEAT: commitment` (#26) has to reach a commitment *through* such a list: defining one from
the phone (B-015) puts a commitment into it, seeing every commitment you keep (B-020) reads it, and
stopping keeping one (B-013) takes a commitment out of it.

A bare array cannot be that list, and the reason is the one #26's G1 already recorded: a commitment
carries no identifier, so an array can hold two commitments a person would call identical and
nothing can then say which of them to retire, to rename, or to point at. Retirement is held by
whatever holds the set — a fourth part on `Commitment` would change its identity and orphan every
tick already recorded (ADR-1013) — so the thing that holds it must first be a thing that cannot hold
the same commitment twice.

This is the first of four Stories under #26, and it is deliberately the smallest of them: the
roster as a value, with an order and a refusal, and nothing else. Retiring is #102's, keeping a
roster across the app being closed is #103's, and the screen that shows one is #104's.

## What Changes

- A roster holds the commitments a person keeps, in the order they were taken on, and reads them
  back in that order. It sorts nothing: not by name, not by the day each is kept from.
- A roster refuses a commitment equal to one it already holds, leaves itself exactly as it was, and
  reports that it did not take it. Anything else it is offered is added after the ones already
  there, and it says so too.
- Sameness is the commitment's own, already signed at #42: name, schedule and the day it is kept
  from. Two commitments alike in name but differing in either of the other two are both held, and so
  are two names differing only by blank space.
- A roster is a value, like a history and unlike a store. Two rosters holding the same commitments
  in the same order are the same roster; in a different order, they are not.
- A roster never asks what day it is and judges no date. Whether a commitment is due stays the
  commitment's answer (ADR-1004).
- Purely additive. Nothing in `openspec/specs/commitment/spec.md` is modified or removed: two ADDED
  requirements, no MODIFIED one, no REMOVED one, and no requirement of any other capability is
  touched.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: two ADDED requirements — a roster holds the commitments a person keeps in the order
  they were taken on, and a roster refuses a commitment it already holds.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/Roster.swift` — new. One public type, `Roster`, with an
  empty initialiser, its commitments read-only, and one mutating `add` that reports whether it took.
  Nothing else in the package changes: `Commitment`, `Schedule`, `Tick`, `History`, `RecordStore`,
  `DayView` and `DayScreen` are all untouched, and `Commitment`'s own members stay exactly as
  signed.
- `src/DayByDayKit/Tests/DayByDayKitTests/RosterTests.swift` — new. One acceptance test per
  scenario, named identically, added to the 192 passing at `125da39`.
- `src/DayByDay` — untouched by this Story. The shell still hands `DayScreen` its
  `dayOneCommitments` array. Nothing can *reach* a roster from a screen until #104, and rewiring the
  shell now would be a change to `openspec/specs/day-screen/spec.md`, which is a second capability
  and so a second Story (`AGENTS.md` rule 5).
- `CONTEXT.md` — one new term, **Roster**.
- No ADR. See `design.md` § *No ADR* for the three bars, and which decision each fails.
