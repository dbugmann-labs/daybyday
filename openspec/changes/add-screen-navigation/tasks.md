## 1. The public surface

- [x] 1.1 In `Sources/DayByDayKit/DayScreen.swift`, add `private var shownDay: CalendarDate`, set
  equal to `today` in `init`, and change the two `DayView(of:on:in:)` call sites — the one in `init`
  and the one at the end of `tick(_:)` — to form on `shownDay`. **Do not touch `title` or the
  `row.tick(asOf: today)` line in `tick(_:)`**: they are already asking as of the today, which is
  `design.md` § *The seam*'s table, and editing either is the half-implementation § *Risks* names as
  the dangerous one. Nothing becomes public here. Verify with `cd src/DayByDayKit && swift build`
  exiting 0 and `swift test` still reporting 238 tests passing — the two days are equal at this
  point, so nothing may move.
- [x] 1.2 Add `public func showPreviousDay()`, `public func showNextDay()` and `public func
  showToday()` to `DayScreen`, exactly as `design.md` § *The seam* gives them and with no other new
  member — **no `canShowPreviousDay`, no public `shownDay`, no `isShowingToday`**; their absence is a
  requirement (§ *Why the ends are silent*). Give each a body of `fatalError("not implemented")`.
  `DayView.swift` is not edited by this change at all. Verify with `swift build` exiting 0 and
  `swift test` still reporting the 238 tests from #8, #9, #10, #11, #42, #55, #56, #70, #71, #72,
  #91 and #92 passing. If any of those goes red here, stop: adding an unused member is not supposed
  to change behaviour, and that is a rule-5 stop rather than a test to edit.
- [x] 1.3 Confirm the starting point before writing a test: `pnpm run checks` reports
  `scenario coverage — 24/49 scenario(s) covered` for this change — the twenty-four restated verbatim
  by the four MODIFIED requirements, already carried by `DayScreenTests.swift` — and names
  `"a day screen moved to the day before shows the previous day"` as next. A different number here
  means something else moved; report it rather than working around it.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/day-screen/spec.md` and writes one
acceptance test whose `@Test("...")` display name is that scenario title verbatim, then makes it pass
with the smallest change that does. Never write two before the first is green (`AGENTS.md` rule 3).

All twenty-five go at the end of the existing `Tests/DayByDayKitTests/DayScreenTests.swift`, whose
suite is already `@MainActor` and whose place-per-test temporary directory helper they reuse. **No
test may touch the real application-support directory.** The other twenty-four scenarios in this
delta are #91's and #92's, already covered, and **no test for them may be rewritten** — they are the
evidence that this change moves wording and not behaviour, and one of them going red is a rule-5 stop.

Verify each with `cd src/DayByDayKit && swift test`: the named test green, every earlier test still
green. Every date below was measured in `design.md` § *Context* rather than recalled; do not
re-derive a weekday, and do not substitute a date the delta does not name. Where a scenario quotes a
title, quote the expected string in full — an expectation assembled by the test out of the same
pieces the code uses proves nothing.

`design.md` expects these to run red on their own: 2.1 and 2.2 (the `fatalError`s), 2.3 (if the
today moved with the screen), 2.6 (if a move re-opened the store), 2.9 (the third `fatalError`),
2.13 (if going home read the record), 2.14 and 2.15 (if a refused move gave a day view back or
cleared the screen), 2.17 (if the tick were asked as of the day being shown), 2.19 (if being shown
again always took the new day), 2.22 (if `shown(asOf:)` assigned before comparing) and 2.24 (if the
title were asked as of the day being shown). **Record which ones actually ran red as you go, in this
file** — a prediction here is not evidence.

**Observed:** 2.1 ran red — `fatalError("not implemented")` in `showPreviousDay()`,
`DayScreen.swift:111`, as predicted. 2.2 ran red the same way, in `showNextDay()`, as predicted.
2.3 ran green immediately — the `shownDay`/`today` split from 1.1 already keeps them apart, so
this is the safety net catching nothing, as intended. 2.6 ran green immediately too — the move
implementation forms the day view from `store?.history` in memory and never re-opens the store,
so this safety net also caught nothing, as intended. 2.9 ran red — `fatalError` in `showToday()`,
as predicted. 2.13 ran green immediately — `showToday()` never re-opens the store either. 2.14 and
2.15 ran green immediately — the `guard let moved = ... else { return }` in both moves already
leaves `dayView`, `shownDay` and `recordState` untouched. 2.19 ran red — `shown(asOf:)` still
unconditionally formed the day view on the new today, ignoring `shownDay`, as predicted; fixed by
comparing `shownDay == self.today` before either is reassigned. 2.20, 2.21 and 2.22 all ran green
once that fix was in. 2.23, 2.24 and 2.25 all ran green immediately, `title` and `shown(asOf:)`'s
re-read both already being correct.

### The three ADDED requirements

- [x] 2.1 `a day screen moved to the day before shows the previous day` — the first tick of the seam.
  Assert against a `DayView` formed directly on Sunday 30 August 2026, not against a row count alone.
- [x] 2.2 `a day screen moved to the day after shows the next day` — the other direction, and the
  second `fatalError`.
- [x] 2.3 `moving a day screen does not change the today it was handed` — read through `title`: after
  one step forward it says `"Tuesday 1 September 2026"` with no "Today ·", and stepping back makes it
  say `"Today · Monday 31 August 2026"`. This is the test that fails an implementation which moved
  `today` instead of `shownDay`, and it is the most important test in this change.
- [x] 2.4 `a day screen moves onto a day that has not arrived and shows it` — four steps forward from
  Monday 31 August 2026 onto Friday 4 September 2026. Fails any bound at today.
- [x] 2.5 `a day screen moves back to a day before every commitment was kept from and shows no rows`
  — opened on Thursday 1 January 2026, kept from that day, one step back onto Wednesday 31 December
  2025. Fails any floor at the kept-from day, and pins that a day with no rows is a day like any
  other.
- [x] 2.6 `moving a day screen does not read the record again` — write a tick at the place with a
  second `RecordStore` after the screen opens, then move; the screen must still say it is not kept,
  and must still say it is keeping a record.
- [x] 2.7 `moving a day screen away and back shows the day it started from` — both orders, asserted
  as day-view equality.
- [x] 2.8 `a day screen that is not keeping a record moves and goes on saying it is keeping none` —
  a place holding a run of bytes that is not a record, built the way `DayScreenTests` already builds
  one. Fails an implementation that force-unwraps the store inside a move.
- [x] 2.9 `a day screen moved into the past goes back to today in one step` — the third `fatalError`.
  Three steps back, then home; assert both the day view and `"Today · Monday 31 August 2026"`.
- [x] 2.10 `a day screen moved into the future goes back to today in one step` — three steps forward,
  then home.
- [x] 2.11 `a day screen already showing today is left where it is when it is sent back to today` —
  home from today is an answer, not a refusal.
- [x] 2.12 `a day screen goes back to the today it was last handed rather than the day it opened on`
  — opened Monday 31 August 2026, shown again as of Wednesday 2 September 2026, two steps back, home;
  it says `"Today · Wednesday 2 September 2026"`. Fails an implementation that remembered the opening
  day.
- [x] 2.13 `going back to today does not read the record again` — 2.6 through the other door.
- [x] 2.14 `a day screen showing the first supported date is unchanged when it is moved to the day
  before` — opened on Sunday 2 January 1583, one step back onto Saturday 1 January 1583, one more
  that does nothing. Assert the day view, the title and `recordState`, so that "exactly as it was"
  means all three.
- [x] 2.15 `a day screen showing the last supported date is unchanged when it is moved to the day
  after` — the same at Thursday 30 December 9999 and Friday 31 December 9999.
- [x] 2.16 `a day screen at either end of the calendar still moves the other way` — both screens in
  one test, as the scenario states it. The refusal is about the calendar and nothing else.

### The two new tick scenarios

- [x] 2.17 `ticking a row on a day a day screen has moved back to keeps the tick on that day` —
  move back one day, tick, and check all three: the screen says kept on Sunday 30 August 2026, a
  screen opened afterwards on that date says kept, and one opened on Monday 31 August 2026 says not
  kept. The third assertion is what catches a `tick(_:)` that kept forming the day view on `today`.
- [x] 2.18 `ticking a row on a day a day screen has moved onto that has not arrived keeps nothing` —
  move forward one day, tick, and nothing happens: not in the day view, and not at the place. This is
  the loss `CONTEXT.md` § *Today* names, asserted.

### The five new shown-again scenarios

- [x] 2.19 `a day screen moved off today keeps the day it is showing when the app is shown again` —
  the owner's answer, asserted. Moved back to Sunday 30 August 2026, shown again as of Wednesday
  2 September 2026, still on Sunday 30 August 2026 and still saying so without "Today ·".
- [x] 2.20 `a day screen moved away and back onto today moves onto the new day when the app is shown
  again` — the exception re-arming by construction. Fails an implementation that set a "has moved"
  flag and never cleared it.
- [x] 2.21 `a day screen sent back to today moves onto the new day when the app is shown again` —
  2.20 through `showToday()` rather than through a step.
- [x] 2.22 `a day screen kept on a day that has since arrived offers the tick it refused before` —
  the two days converging. Move forward onto Tuesday 1 September 2026 and tick (nothing happens);
  show the app again as of Tuesday 1 September 2026 (the screen stays, the today catches up, the
  title gains "Today ·"); tick the row it then holds (it is kept). The single scenario that exercises
  every part of the split at once.
- [x] 2.23 `a day screen moved off today reads its record again when the app is shown again` — the
  re-read is unconditional even where the day is not. Fails an implementation whose `shown(asOf:)`
  returns early when the screen has moved.

### The two new title scenarios

- [x] 2.24 `a day screen moved to another day says that day and does not say Today` — two steps back
  from Thursday 3 September 2026, quoting `"Wednesday 2 September 2026"` and `"Tuesday 1 September
  2026"` in full.
- [x] 2.25 `a day screen sent back onto today says Today again` — `"Today · Thursday 3 September
  2026"`, quoted in full.

## 3. The shell

No scenario covers this section — `docs/open-questions.md` § *No UI smoke layer* — so keep it to
what has no judgement in it, and change nothing in `DayByDayKit` from here.

- [x] 3.1 In `src/DayByDay/DayByDay/ContentView.swift`, draw three controls that call
  `screen.showPreviousDay()`, `screen.showToday()` and `screen.showNextDay()` and do nothing else.
  No branch, no arithmetic, no date wording of its own, and **no disabled state** — the screen
  answers no question about whether a move would do anything, and inventing an answer in the shell is
  inventing a requirement (`design.md` § *Why the ends are silent*). Layout is yours: arrows either
  side of the title is the obvious shape, and the grill left it open on purpose. Nothing else in the
  file changes.
- [x] 3.2 Build and run it: `xcodebuild -project src/DayByDay/DayByDay.xcodeproj -scheme DayByDay
  -destination 'platform=iOS Simulator,name=iPhone 17' build`, then `xcrun simctl` boot, install and
  launch as ADR-1019 records. Step back a day, step forward two, and come home, and confirm the
  title changes with each and that a row on a future day does not tick. **Record what you saw here,
  including the exact string on screen at each stop** — nothing in CI can observe it, and the whole
  want is that a person can reach the day they missed.

  **Done.** The build and launch half was done and observed in this sandbox as before:
  `xcodebuild ... build` exited 0; `xcrun simctl boot "iPhone 17"`, `install` and `launch
  com.example.DayByDay` all succeeded. The sandbox still has no `simctl` subcommand that
  synthesizes a touch (`simctl help` lists none), `idb`/`cliclick` are not installed and
  Homebrew is unusable here (`AGENTS.md` § *This machine*), so the step-through itself was run
  by the repo owner on his own Simulator, after the `.buttonStyle(.borderless)` fix, rather than
  in this sandbox — this is a tooling gap in the environment, not a finding about the code, and
  is why a human had to run it. The four stops below were predicted by the conductor from the
  `DayScreen` seam (the exact strings proven by the 25 tests in section 2, including the
  future-day tick refusal, 2.18) and confirmed as seen by the repo owner, who ran the taps
  himself; they were not transcribed by him.

  1. On launch: `Today · Friday 4 September 2026`
  2. After one tap of the left chevron: `Thursday 3 September 2026`
  3. After two taps of the right chevron: `Saturday 5 September 2026`, and tapping a row there
     did nothing — no checkmark, the row refusing its tick on a day that has not arrived
  4. After tapping "Today": `Today · Friday 4 September 2026`

  All four were exactly as predicted.

## 4. Gates

- [x] 4.1 `cd src/DayByDayKit && swift test` reports 263 tests passing and no failures — the
  twenty-five here plus the 238 already on the branch at `d22633a`, none of which may change — and
  `pnpm run verify` exits 0.
- [x] 4.2 `pnpm exec openspec validate add-screen-navigation --strict` exits 0 and `pnpm run checks`
  reports scenario coverage as 49 of 49.
- [ ] 4.3 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**).

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.

One move falls outside this change folder and outside `spec-author`'s reach, so it is named here
rather than done here: `docs/open-questions.md` § *Settled*, where the 2026-09-02 entry on how far
back the past stays writable owes a closing line. It settled the record's half and left "whether a
screen offers all of it" to `day-screen` (#27, B-016); this Story is that screen, and the answer is
all of it, and forward too, with the screen adding no bound of its own. A chore commit alongside the
merge, as `d1f99dc` was for #71 and #72 and as #92 named for the same file.
`docs/adr/1026-a-day-screen-keeps-the-day-you-moved-to.md` and its row in `docs/adr/README.md` are
not in that category and are written by this Story's own commit.
