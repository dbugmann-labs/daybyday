## Why

A day view (#70) says what a date asks of you and what you have done about it, and nothing can act
on it. `record` (#55, #56) can form a tick, hold it and keep it at a place, but a tick is of a
*commitment on a date* and the only place a person meets those two together is a row. The tap that
turns a row from *not kept* into *kept* is the interaction this whole product exists for —
`CONTEXT.md` § *Entered where you stand* — and today there is no seam at which it can be made.

It is also the Story that first needs to know what day it is. Everything in `DayByDayKit` so far is
a pure function of a `CalendarDate` and never of the present moment (ADR-1004), and `record`'s first
requirement says so in as many words: *"a screen that wants to withhold days that have not arrived
does so itself, with the day it asked the device for."* This is that screen's half. It does not put
a clock in the package — it takes the day as an argument, like every other date the engine has ever
seen.

## What Changes

- **A row offers the tick that keeps its commitment on the day view's date.** The row already knows
  the commitment and the day view already knows the date, so the tick a tap makes is fully
  determined by the row; nothing new has to be given to it. A screen adds that tick to a history or
  a store to tick, and takes it back to untick. Both of those are `record`'s, already public, and
  neither moves.
- **A row asked as of a day later than its own offers nothing.** A day that has not arrived cannot
  have been kept. The judgement is made where `record` said it would be — in the screen's
  capability, from a day the caller supplies — and it is made when the tap happens rather than when
  the view is formed, so an app left open across midnight refuses on last night's reckoning for no
  longer than the tap it is asked about.
- **The day is supplied, never read.** No clock, no time zone, no locale enters `DayByDayKit`. Two
  calls with the same arguments give the same answer for ever, which is what keeps every acceptance
  test deterministic in every time zone.
- **A row becomes a commitment's line on a *date*.** It already carried the commitment and the
  kept-ness; the date it is a row for now counts towards what it is, because two rows for the same
  commitment on different days offer different ticks and are not interchangeable.
- Sharpens `CONTEXT.md` § *Row* with what the row offers and when it refuses, and adds **Today** as
  a term of its own — the day a screen is being looked at on, always handed in and never asked for,
  which is a different thing from the date a day view is of. Confusing those two is the mistake this
  Story exists to make impossible.

Nothing is drawn. No screen, no app target, no gesture: whether one tap both ticks and unticks is
the app target's to decide, and the seam serves either. Nothing in `commitment`, `record` or
`schedule` changes, and none of #70's three requirements is touched — this delta is purely additive.

## Capabilities

### New Capabilities

None. `day-screen` already exists, anchored by `openspec/specs/day-screen/spec.md`.

### Modified Capabilities

- `day-screen`: two requirements ADDED — what a row offers and when it refuses, and that a row is a
  commitment's line on a date. #70's three existing requirements are unchanged and none is restated:
  a day view is still formed from three things, still orders nothing of its own, and is still the
  rows and the date it holds.

`record` is **not** modified. `Tick`, `History.add(_:)`, `History.remove(_:)`, `RecordStore.add(_:)`
and `RecordStore.remove(_:)` are all public already and are used exactly as they are; this delta
adds no requirement to that capability and takes none away.

## Impact

- **`src/DayByDayKit`** — one source file edited, `Sources/DayByDayKit/DayView.swift`: `Row` gains
  an internal stored `date` and one public member. One test file edited,
  `Tests/DayByDayKitTests/DayViewTests.swift`. Nothing else in the package is touched. Measured on
  this machine on 2026-09-03, on Apple Swift 6.3.3: `cd src/DayByDayKit && swift test` reports 135
  tests passing at `b26914a`, the app shell (#81), which adds no test to the package; this change
  takes it to 149. `openspec` is 1.10.0.
- **A public type's equality changes, and the app shell keys a list on it.** `src/DayByDay` draws
  `List(dayView.rows, id: \.self)`, so `Row`'s `Hashable` conformance is load-bearing in shipped
  code as of #81. It is unaffected: every row of one day view carries that day view's date, so two
  rows *in one list* compare exactly as they did before. Checked against the source rather than
  assumed. `DayView.Row` is `Hashable` and public, so two rows for the
  same commitment saying the same thing on two different dates stop being equal. Nothing in #70's
  spec says otherwise — its third requirement enumerates when two *day views* differ and never
  defines row equality — so this adds a requirement rather than modifying one, and a scenario pins
  it. No existing test asserts row equality across dates; all 135 stay green.
- **No new dependency, no `Package.swift` change, no CI change.** CI discovers `Package.swift` and
  reads `@Test("...")` display names out of the source, both of which this change leaves alone.
- **`openspec/specs/day-screen/spec.md`** is rewritten at archive time, by `/opsx:archive` and
  nothing else. Exactly one capability is claimed, so CI check 2 stays green.
- **`docs/open-questions.md` § *Known gaps*, "No UI smoke layer"** — unchanged and still open. This
  Story deliberately keeps the *decision* about a future day inside the seam rather than in SwiftUI,
  which is the best answer available while that gap stands, but it does not close it: a `Row` proved
  correct in `swift test` still says nothing about whether a button is wired to it.
- **The day this seam asks for already exists, and no gap is owed for it.** This paragraph said the
  opposite when the change folder was first pushed, and #81 landed in between: it asked
  `docs/open-questions.md` § *Known gaps* to record that converting the device's local day into the
  `CalendarDate` the engine speaks was a line of Foundation nobody had written. It is written —
  `ContentView.today()` in the app shell, reading `Calendar.current`'s year, month and day and
  rebuilding the date from those parts, which is the edge conversion ADR-1004 reserves for the app
  and is correct rather than merely present. This Story is its first consumer and does not move it.
  What stands unchanged is why the *refusal* belongs in the row and not in the view: `CalendarDate`
  exposes no way for a caller to compare two dates at all, so the app cannot make that judgement
  itself even if it wanted to. This change widens neither `CalendarDate` nor
  `docs/open-questions.md`.
- **`docs/backlog.md`** — B-019, *tick a commitment from the day I am looking at*, is already
  *Decided* against this Story. Its second half, *"whether the same tap takes the tick back"*, went
  into the Story rather than staying a want, and this delta answers it: the row offers one tick and
  taking it back is that same tick handed to `record`. B-016 is #72's. This change does not edit the
  file.
- **No ADR.** Argued in `design.md` § *No ADR*: the decision that would have earned one — that the
  engine never reads a clock and every "now" arrives as an argument — is ADR-1004's already, and
  this delta applies it rather than deciding it again.
