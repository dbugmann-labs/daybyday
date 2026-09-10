## 1. Before a line is written

- [x] 1.1 Confirm the starting point, and report rather than work around a different one (rule 5).
  From `src/DayByDayKit`, `swift test` reports **1015 tests passing** — measured 2026-09-10 on this
  branch, whose only commit is the grill, on `84dfa5c`. Re-measure it rather than trusting that
  sentence; a different number is a stop. From the repo root, `pnpm run check:scenarios` should
  report `3/26 scenario(s) covered` and name *a day screen says the day view of the day before the
  one it is showing* as next — **26 and not 23, and 3 covered before a line is written**, because
  this delta restates three shipped scenarios under a modified requirement and the three tests
  carrying those names already cover them. **Those three tests may not be renamed, moved, or have an assertion changed by any
  box below**: `a day screen showing the first supported date is unchanged when it is moved to the
  day before`, `a day screen showing the last supported date is unchanged when it is moved to the
  day after`, and `a day screen at either end of the calendar still moves the other way`. The
  modified requirement changes prose and nothing a test can see; if making any box below pass needs
  one of them edited, that is a **stop and a G4 question**.

- [x] 1.2 Confirm the six facts the shape rests on, before writing any test, and stop and report if
  any is false (`design.md` § *Context*): `DayScreen`'s `today`, `shownDay`, `recordStore` and
  `roster` are all still `private` (`DayScreen.swift:24`–`:27`); `dayView` is still stored and still
  formed in ten places, three of them inline rather than through `dayViewOfShownDay()` (`:75`,
  `:539`, `:561`); `tick`, `enter(_:on:)` and `takeBackLast(on:)` each still open with
  `guard dayView.rows.contains(row) else { return }` (`:223`, `:341`, `:438`); `DayView.Row` still
  carries `commitment` and `date` as stored properties, so two rows of different days are never
  equal (`DayView.swift:37`–`:41`); `CalendarDate.adding(days:)` is still internal and still answers
  `nil` past either end at a ±1 step (`CalendarDate.swift:85`–`:95`); and `Roster.groups(on:)` is
  still the roster's per-date answer (`Roster.swift:58`). If the guard in any of the three write
  methods has moved or widened, stop: § 3b exists because it is where it is.

- [x] 1.3 Re-read this box before § 2 and again before § 4. `day-screen` is the busiest capability in
  the repository: if another Story delta-ing it merges to `main` while this branch is open, a clean
  rebase can still leave this delta describing a spec that has moved — and this one restates a whole
  shipped requirement, which makes it more exposed than most. Check with
  `git fetch origin && git log --oneline origin/main -- openspec/specs/day-screen/spec.md`. A change
  there is a **stop** (rule 5), not a delta to refresh quietly: refreshing it needs a further G4.
  `rework-commitment-row-actions` (#192) is open and is the one to watch.

## 2. `day-screen` — a day screen says the day view either side of the one it is showing

Sixteen scenarios, in `src/DayByDayKit/Tests/DayByDayKitTests/DayScreenTests.swift`. One red-green
cycle each, in this order, taking the next scenario verbatim as the `@Test` display name (rule 3).
The whole of the implementation is two computed properties and one private helper
(`design.md` § *The seam*) — if any box below needs a stored field, a change to `DayView`, to
`Roster`, or to any existing member of `DayScreen` beyond `dayViewOfShownDay()` gaining a parameter,
that is a stop.

- [x] 2.1 `a day screen says the day view of the day before the one it is showing` — adds
  `previousDayView`.
- [x] 2.2 `a day screen says the day view of the day after the one it is showing` — adds
  `nextDayView`.
- [x] 2.3 `a day screen says the day one calendar day either side and no day further` — one day, not
  two, and across a month boundary. 2026 is not a leap year, so the day before Sunday 1 March 2026 is
  Saturday 28 February 2026.
- [x] 2.4 `saying the day either side of a day screen leaves the day it is showing exactly as it was`
  — reading either answer moves nothing. If either property is not `get`-only, stop.
- [x] 2.5 `a day screen moved to another day says the day either side of that day`
- [x] 2.6 `a day screen sent back to today says the day either side of that today`
- [x] 2.7 `a day screen showing a day picked on its day picker says the day either side of that day`
- [x] 2.8 `a day screen shown again on a new day says the day either side of that day` — 2.5 to 2.8
  are the four ways the day being shown moves, and they are what a **stored** pair of neighbours
  would have to be refreshed at. They pass for free against the computed pair `design.md` names, and
  that is the point of writing them: an implementation that stores instead must keep all four green.
- [x] 2.9 `a day screen says a day either side drawn from the commitments its roster had not stopped keeping on that day`
  — **the box that separates a right implementation from the likely wrong one.** An implementation
  that formed a neighbour from `roster.groups(on: shownDay)`, or from the groups already inside
  `dayView`, passes every other box in § 2 and fails this one. If making it pass needs
  `DayView.previousDay(of:in:)` or `nextDay(of:in:)`, read `design.md` § *The seam* first: those take
  the groups they are handed, which is exactly the wrong day's.
- [x] 2.10 `a day screen says a day either side drawn from the record it already holds`
- [x] 2.11 `saying the day either side of a day screen does not read its record or its roster again`
  — if `Self.open` or `Self.openRoster` is reachable from either property, that is a stop.
- [x] 2.12 `a tick made on the day a day screen is showing leaves the day either side of it as it was`
- [x] 2.13 `a day screen that cannot read its record says the day either side of it with nothing kept`
- [x] 2.14 `a day screen that cannot read its roster says the day either side of it and neither holds rows`
  — 2.13 and 2.14 are `grill.md` § *Settled* 6: a store failure must not take the gesture away as
  well.
- [x] 2.15 `a day screen goes on telling what it was telling on a row when it is asked the day either side of it`
  — the notice survives being asked. This is the box that closes ADR-1043's rejected workaround by
  name: if either property sets `notice`, or clears it, stop.
- [x] 2.16 `a day screen returned to says the day either side of it from the roster it then holds`

## 3. `day-screen` — the ends of the calendar, and where a change may be made

Seven scenarios over two requirements, in the same file. One red-green cycle each, in this order.

### 3a. A day screen says no day view before the first supported date and none after the last — three scenarios

- [x] 3.1 `a day screen showing the first supported date says no day view before it and says the day after`
  — the absence comes from `CalendarDate.adding(days:)` answering `nil`, not from a date comparison
  written here. If a literal 1583 or 9999 appears in `DayScreen.swift`, stop.
- [x] 3.2 `a day screen showing the last supported date says no day view after it and says the day before`
- [x] 3.3 `a day screen moved off an end of the calendar says a day view either side of it` — the
  absence is about the calendar and never about the screen.

### 3b. A day screen makes every change on the day it is showing and none either side — four scenarios

**These four are already true of the shipped code** — `tick`, `enter(_:on:)` and `takeBackLast(on:)`
each return early on a row `dayView.rows` does not contain, and a neighbour's row is never in
`dayView.rows` because a `Row` carries its date (`design.md` § *Acting stays on the day being
shown*). They are still written and still start red, because they cannot compile before § 2 exists.
**No box here may change any of those three guards.** If one of them looks like it wants widening to
"any row this screen can draw", that is the exact regression these four fences exist to catch.

- [x] 3.4 `ticking a row a day screen says of the day before changes nothing`
- [x] 3.5 `entering a number on a row a day screen says of the day after changes nothing`
- [x] 3.6 `taking back the last addition on a row a day screen says of the day before changes nothing`
- [x] 3.7 `a day screen tells nothing on a row of a day either side of the one it is showing`

## 4. The app shell — the day screen pages under the finger

Under ADR-1019's 2026-09-04 amendment, whose three conditions `design.md` § *What the shell draws*
checks off one by one. **The shell computes no day and holds none**: it reads the two neighbours off
the screen and moves it with the same `showPreviousDay()` and `showNextDay()` the chevrons already
call.

- [x] 4.1 Lift the fixed controls out of the day `List`: the day-title `HStack` (chevrons and
  `DatePicker`), the conditional `Today` button and the two store messages become a fixed row above
  the paged content, and the `ForEach` over the day's groups is what pages.
  `grill.md` § *Settled* 9. The store messages stay with the controls — they are facts about the
  screen, not about a day.
- [x] 4.2 Draw three day lists in an `HStack`, each the width of the container: `screen.previousDayView`,
  `screen.dayView`, `screen.nextDayView`. Translate them by the drag's own `width` through
  `.simultaneousGesture`, keeping the existing test that a drag whose vertical travel exceeds its
  horizontal is not a day move. Where a neighbour is `nil` there is no page to reveal: the drag
  resists and settles back.
- [x] 4.3 On a carry, call `screen.showPreviousDay()` or `screen.showNextDay()` and **never
  `screen.showDay(_:)`** — that one is bounded by the day picker's reach and would silently refuse a
  page back below the roster's earliest kept-from day, which the chevrons and the swipe deliberately
  reach past. If a box here needs `showDay(_:)`, stop and report it.
- [x] 4.4 Keep `ForEach(Array(group.rows.enumerated()), id: \.offset)` exactly as it is, in all three
  lists, and hand no two days' rows to one `ForEach` to diff. ADR-1043 and
  `docs/open-questions.md` § *The shell identifies rows by position*: a paged screen makes that
  temptation worse, not safer. Any change to the keying is a **stop**.
- [x] 4.5 Animate the settle at release, and a chevron tap, in the direction of the move — leftwards
  onto the next day, rightwards onto the previous. Read `@Environment(\.accessibilityReduceMotion)`
  and make both an instant change where it is set, leaving the drag tracking the finger either way
  (`grill.md` § *Settled* 8 and 11). The day picker and `Today` replace where they stand and animate
  nothing, exactly as they do today.
- [x] 4.6 **The rule-5 stop.** Apple documents nothing either way about a vertically scrolling `List`
  inside a horizontally paged container, and this app targets iOS 26.0. Build it and try it; if
  vertical scrolling, row taps and the page gesture cannot co-exist without moving a line that could
  be wrong in a way a test would catch, **report it and stop** — do not push it through, do not move
  a rule into the shell, and do not change the kit. ADR-1019's guard does not move and a kit change
  found here needs a further G4.

  **Does not fire.** Walked on a paired iPhone off `ded912c` (§ 4.7, PR #194) — vertical scrolling,
  row taps and the page gesture co-exist on iOS 26 without any rule moving into the shell. The kit is
  untouched.
- [x] 4.7 Walk it on the phone: `pnpm run phone`. Confirm six things and report anything else you
  find rather than fixing it here — dragging left draws tomorrow's rows moving in under the thumb and
  dragging right draws yesterday's; releasing short settles back and changes nothing; releasing past
  the threshold lands on that day and the day picker says so; the chevrons play the same movement in
  the same direction; the day picker and `Today` still replace where they stand; and the day's rows
  still scroll vertically and still open their entries on a tap. Say plainly how each was confirmed
  and on what. If the phone is not reachable from this machine, say so as a report rather than a
  workaround, and say what was driven on the Simulator instead.

  **Walked 2026-09-10** on a paired iPhone with `pnpm run phone` off `ded912c` (PR #194 comment). All
  six confirmed by the owner: dragging left draws tomorrow's rows moving in under the thumb and
  dragging right draws yesterday's; releasing short settles back and changes nothing; releasing past
  the threshold lands on that day and the picker says so; the chevrons play the same movement in the
  same direction; the picker and `Today` replace where they stand; and the day's rows still scroll
  vertically and still open their entries on a tap. Two shell changes the walk asked for — the drag
  must lock to one axis, and more space above the first commitment — landed on this branch under
  ADR-1019, in `ContentView.swift` only; neither needed a requirement.
- [x] 4.8 Confirm the spacing at the top of the screen. Lifting four controls out of the `List`
  changes what sits above the rows, and that spacing was measured twice already (#180 and ADR-1043's
  chore). Report what it looks like rather than tuning it: a spacing change nobody asked for is a
  finding for the owner at G7, not a line to slip in here.

  **Reported at § 4.7, then tuned per PR #194's comment**, which is what asked for it: the gap between
  `Today` (or the date row on a day that is today) and where the commitments start was too tight,
  reported rather than fixed on the phone walk, and is now tuned — `ContentView.swift`'s
  `dayControls` gains a matching 24pt bottom padding, the same precedent as #180 and ADR-1043's
  chore. The owner re-walks it on the phone to confirm.

## 5. The records

**`CONTEXT.md` and `docs/adr/1043-a-day-change-pages-under-the-finger.md` are written by this Story's
proposal commit, not by the implementation** (`design.md` § *ADR-1043 is amended* and § *`CONTEXT.md`
gains the term the grill declared*). These boxes confirm rather than write, and each is tickable
while reading what is already there:

- [x] 5.1 Confirm `CONTEXT.md` § *Adjacent day view* still describes what shipped — one day either
  side, formed for that day's own roster answer, none past either end of the calendar, drawn and
  never acted on. If the implementation needed a rule that paragraph does not carry, that is a **stop
  and a G4 question**, not an edit to slip in.
- [x] 5.2 Confirm ADR-1043's four amended decisions still describe what shipped: the chevron plays
  the same settle in the same direction, Reduce Motion governs the played half only, the day's rows
  page while the controls stay put, and the day picker always replaces. If the phone answered
  differently at § 4.7, **report it** — the record is amended by a later act, never quietly at the
  end of an implementation.
- [x] 5.3 Confirm no further ADR was written by this branch:
  `git diff --stat origin/main... -- docs/adr/` reports **only** `1043-a-day-change-pages-under-the-finger.md`.
  ADR-1019, ADR-1029, ADR-1042 and ADR-1045 are **used** here, not amended.
- [x] 5.4 Confirm `openspec/specs/` was not hand-edited on this branch (rule 2):
  `git diff --stat origin/main... -- openspec/specs/` reports nothing.
- [x] 5.5 Leave `docs/backlog.md` and `docs/open-questions.md` alone. § *The shell identifies rows by
  position* stays open — this Story does not close it, and closing it is a grooming pass's act rather
  than a Story branch's. Confirm neither file has been touched by this branch before the review.

## 6. Before the review, and what the janitor does at the archive

- [x] 6.1 `cd src/DayByDayKit && swift test` — every test green, and the count is **1038**: 1015 at
  the base plus the twenty-three new scenarios of § 2 and § 3. A count that comes back different is a
  **stop** (rule 5), not a number to write down — it would mean a test was renamed or removed by a
  box above, which § 1.1 forbids. From the repo root, `pnpm run verify` green and `pnpm run checks`
  reporting `26/26 scenario(s) covered`.
- [x] 6.2 `openspec validate add-adjacent-day-views --strict` exits 0, and `openspec validate --all
  --strict --no-interactive` exits 0.
- [x] 6.3 Rebase onto current `main` and push with `--force-with-lease`. A conflict inside
  `openspec/changes/add-adjacent-day-views/` or anywhere under `openspec/specs/` is a **stop**, not a
  merge to resolve (rule 5) — and so is a clean rebase that then fails 6.2, which is § 1.3's hazard
  arriving late.
- [x] 6.4 Hand back for the review (**G7**). The conductor spawns `reviewer`; do not run
  `mattpocock-skills:code-review` on your own diff and do not act on findings until they come back
  through the conductor. This box is ticked when the hand-back is written.
- [x] 6.5 Write the archive handover for the janitor, into the PR or the hand-back message, saying
  what it must check **after** `/opsx:archive` has run. **The `implementer` ticks this box, in its
  last commit before the archive**, on the evidence that the instruction has been written — the
  checking itself is the janitor's step and has no box of its own, deliberately: a box whose tick
  depends on the archive having run cannot be reached afterwards, because `/opsx:archive` moves this
  folder under `openspec/changes/archive/` and every editor is denied there.

  **What the handover must say.** This change carries **one delta file, three ADDED requirements and
  one MODIFIED**. So after `/opsx:archive` runs, read the recomposed
  `openspec/specs/day-screen/spec.md` and confirm that it has gained exactly *A day screen says the
  day view of the day before the one it is showing and of the day after*, *A day screen says no day
  view before the first supported date and none after the last* and *A day screen makes every change
  on the day it is showing and none on a day either side of it*; that *A move with nowhere to go
  leaves a day screen exactly as it was* now carries the added paragraph and **still carries its
  three scenarios word for word**; that **no other requirement moved, was reworded, or lost or gained
  a scenario** — in particular *A day screen moves the day it is showing one calendar day either
  way*, *A day screen makes and takes back the tick a row offers* and *A day screen says the reach of
  its day picker*; that nothing landed in `commitment`, `record` or `schedule`; and that
  `openspec validate --archived` exits 0. Any drift is **a stop and a report, never a hand-edit**
  (rule 2): `openspec/specs/` is written by `/opsx:archive` and by nothing else, and the archived
  folder is denied to every editor.
