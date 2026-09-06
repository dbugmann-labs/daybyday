## Why

Tap a row on a day whose record cannot be written and the app does nothing at all. The row does not
change, no message appears, and the tap is indistinguishable from one that landed — which on a
product whose whole purpose is not losing a record is the worst of the two failures it can have.

The hole is exact and it is on the record twice. `DayScreen.tick(_:)` throws `RecordStoreError`
when the write is refused, and `#91`'s `design.md` justified that `throws` on the grounds that "a
person must be told"; `src/DayByDay/DayByDay/ContentView.swift` then calls it as
`try? screen.tick(row)`. `docs/open-questions.md` § *The shell swallows the one failure a tick
reports* has said so since 2026-09-03 and closes with "owed by whichever Story first gives the shell
a way to say anything at all". This is that Story. The other half is `docs/open-questions.md` § *No
UI smoke layer*: nothing automated can prove SwiftUI drew anything, so the only way the telling can
be tested at all is for it to be **a fact on the day screen at the seam** and for the shell to draw
that fact.

The shape was settled at the fourth grooming pass's Feature grill, for want B-027, and
`CONTEXT.md` § *Day screen* has carried it since: told **on the row that was tapped, under its
name**, and told **the same way for every refusal**, because a tick refused on a record that could
be read leaves a person nothing different to do — ADR-1021's reasoning, applied one step further.
This Story's own grill (`grill.md`, ten questions over three rounds, 2026-09-06) settled the edges
that only appear when someone tries to phrase the requirement, and `CONTEXT.md` was amended with
them on the same day.

## What Changes

- **A day screen tells, on the row that was tapped, that a change could not be kept.** A new fact on
  the screen, alongside what it already says about its record and its roster. It is told for a
  refused tick and for a refused take-back alike, and it names no cause — not which of the two was
  asked for, and not why the place would not take it.
- **The refusal still reaches the caller.** The two serve different readers: the throw is what a
  test asserts on and what stops a future shell swallowing the failure again, and the notice is what
  a person sees. Dropping either would trade one silence for another. Settled at the grill.
- **At most one row is told of at a time, and it is the row tapped last.** One refusal is one event;
  a second refused tap moves what is told rather than stacking a second message beside the first.
- **It lasts until one of three things.** The app being shown again, **any change reaching the
  record's place**, and **the day the screen is showing changing**. The second is wider than
  `CONTEXT.md` said before this grill — a take-back that lands ends it exactly as a tick that lands
  does, because what is being told is that the place would not take your change. The third is new:
  a notice is about a tap on a row of the day you were on, and a day you have left has no row to say
  it under.
- **The rule is the day being shown *changing*, not the gesture.** A move with nowhere to go, at
  either end of the calendar, and going back to today while already on today, both leave a day
  screen exactly as it was — which is already a requirement — and the notice is part of how it was.
- **It is silent where there was no tick to refuse.** A tap on a screen that is not keeping a record
  (its own statement already says more, and the two would share a lifetime and clear together); a
  tap on a row for a day that has not arrived, which offers no tick at all; and a tap on a row the
  screen's day view does not hold, which already "SHALL change nothing at all".
- **It is not what the screen says about keeping a record.** That answer is about whether the store
  opened at its place and is formed again only on being shown. A refused write is one change
  refused, not a store that will not open, and keeping them apart is what stops a screen guessing
  which condition a failed write proves.
- **The shell draws it under the row's name and carries no requirement**, exactly as
  `add-screen-navigation` (#93) handled its own controls and `add-screen-date` (#92) its title.
  `tasks.md` § 3 covers it; `docs/open-questions.md` § *No UI smoke layer* is unchanged and still
  open.

## Capabilities

### New Capabilities

None. `day-screen` already exists, anchored by `openspec/specs/day-screen/spec.md`.

### Modified Capabilities

- `day-screen`: three requirements **ADDED** and **none modified** — what a day screen tells on the
  row that was tapped, how long it lasts, and where it is silent.

**No existing requirement is restated, and that is a claim worth checking rather than taking.** Four
were read line by line against the settled answers, and each says something that is still true:

- *A day screen makes and takes back the tick a row offers…* — "A change that could not be kept
  SHALL be refused, SHALL be reported to the caller rather than passed over, and SHALL leave the day
  view exactly as it was" all still hold. The notice is a fact on the **screen** and not part of the
  day view, and settled item 7 keeps the report to the caller exactly as written.
- *A day screen that cannot read its record draws the day and keeps nothing* — untouched. A tap
  there is silent, which is this delta's own new requirement rather than a change to that one, and
  "a day screen that could read its record SHALL say that it is keeping one" is still true after a
  write is refused.
- *A day screen re-reads its day and its record when the app is shown again* — this one already
  **requires** the first of the three ends. Its last paragraph reads "Nothing else of a day screen
  SHALL survive being shown again: the commitments it was handed, the two places it keeps its record
  and its roster at, and the day it is showing are all it carries across." A notice is not on that
  list, so it does not survive. The new requirement restates the end as part of the lifetime it owns
  and adds nothing that contradicts it.
- *A move with nowhere to go leaves a day screen exactly as it was* — "Staying SHALL be the whole of
  the answer" is the settled answer's own reasoning, and its enumeration of what the screen goes on
  saying is a list of the facts that existed when it was written rather than a bound on the ones
  that come later.

`record`, `commitment` and `schedule` are untouched. Nothing here writes a tick #71 did not already
write, asks a new question about due-ness, or needs a `CalendarDate`'s parts. In particular **the
`record` capability is not asked to say more about why a write failed** — the whole settled answer
is that no cause is named, so `RecordStoreError` is read for nothing but the fact that it was
thrown.

## Impact

- **`src/DayByDayKit`** — one source file is edited, `Sources/DayByDayKit/DayScreen.swift`. It gains
  one public stored property and clears it in three existing methods. `DayView.swift` is not
  touched: a `DayView` is formed from commitments, a date and a history and cannot know a write was
  refused, which is exactly why the notice is the screen's. Measured on this machine on 2026-09-06,
  on Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`: `cd src/DayByDayKit
  && swift test` reports **300 tests passing** at `566297e`; this change takes it to 320.
  `openspec` is 1.10.0 and `node --version` is v24.19.0.
- **`src/DayByDay`** — `ContentView.swift` draws the message under the row it is told of and nothing
  else. It already has the row in hand inside its `ForEach`, so this is an equality test and a
  `Text`. The `try?` on `screen.tick(row)` stays: the screen is now what does the telling, and a
  second telling in the shell would be the shell inventing a requirement.
- **`CONTEXT.md`** — **already amended, by the grill, uncommitted on this branch.** § *Day screen*
  carries a **2026-09-06** amendment holding all ten settled answers. No new term: the grill's own
  `## Terms landed in CONTEXT.md` says so, and writing this delta turned up none either. This change
  adds nothing further to that file.
- **No ADR.** The grill's judgement, and writing the delta did not overturn it: every answer is
  ADR-1021's reasoning applied one step further, nothing here is expensive to reverse, and
  `CONTEXT.md` § *Day screen* is where a future reader will look. The one thing that reads as
  surprising — that the notice names a **row by value**, so two rows of one day view that are equal
  are both told of — is a consequence of settled item 10 rather than a decision of this change's,
  and it is recorded in `design.md` § *The seam*.
- **`docs/open-questions.md` owes two edits, and `spec-author` may not write that file**
  (`AGENTS.md` § *Agent roles and model routing*), so `tasks.md` names them as a chore commit
  alongside the merge, exactly as #92 and #93 named their own. § *The shell swallows the one failure
  a tick reports* is closed by this Story. And a new entry is owed: `RecordStore.write` puts
  `try encoder.encode(document)` **outside** its `do`, so an encoding failure escapes as itself
  rather than as `RecordStoreError.cannotWrite`. It does not change this delta — the notice follows
  any refusal, whatever type it arrives as — which is why it is an entry and not a fix.
- **`docs/backlog.md`** — B-027 is already *Decided* against `FEAT: day-screen` (#27). This change
  does not edit the file.
- **`openspec/specs/day-screen/spec.md`** is rewritten at archive time, by `/opsx:archive` and
  nothing else. Exactly one capability is claimed, so CI check 2 stays green.
- **No new dependency, no platform floor change and no CI change.**
