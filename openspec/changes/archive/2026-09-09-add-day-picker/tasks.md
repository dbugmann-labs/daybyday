## 1. Before a line is written

- [x] 1.1 Confirm the starting point, and report rather than work around a different one (rule 5).
  From `src/DayByDayKit`, `swift test` reports **933 tests passing** — measured 2026-09-09 on this
  branch, whose only commit is the grill, rebased onto `4e64641` (#183, a shell chore that touches
  no kit source). Re-measure it rather than trusting that sentence; a different number is a stop.
  From the repo root,
  `pnpm run check:scenarios` should report `0/28 scenario(s) covered` and name *a roster holding no
  commitments answers no earliest day anything it holds is kept from* as next. **No test in this
  suite may be renamed, moved, or have an assertion changed by a box below**: this delta modifies no
  shipped requirement, so every existing test is expected to survive untouched.

- [x] 1.2 Confirm the five facts the shape rests on, before writing any test, and stop and report if
  any is false (`design.md` § *Context*): `Commitment.keptFrom` is still declared without `public`
  (`Commitment.swift:4`); `Roster.entries` still carries a `keptUntil` and an `isRemoved` per
  commitment (`Roster.swift:15`); `DayScreen`'s `today` and `shownDay` are both still `private`
  (`DayScreen.swift:24`, `:25`); `openRoster` still returns an **empty** `Roster` for both refusal
  states (`:117`, `:119`) and still takes day one on only where the place holds a roster holding
  nothing (`:122`); and `CalendarDate` is still not `Comparable`, with `days(until:)` internal
  (`CalendarDate.swift:78`). If `Commitment.keptFrom` has become public, that is a **stop and a G4
  question**, not a shortcut to take — the whole of § 2 exists because it is not.

- [x] 1.3 Re-read this box before § 2 and again before § 4. `commitment` and `day-screen` are the
  two busiest capabilities here: if another Story delta-ing either merges to `main` while this
  branch is open, a clean rebase can still leave this delta describing a spec that has moved. Check
  with `git fetch origin && git log --oneline origin/main -- openspec/specs/commitment/spec.md
  openspec/specs/day-screen/spec.md`. A change there is a **stop** (rule 5), not a delta to refresh
  quietly: refreshing it needs a further G4. `add-commitment-editing` (#148) is open on `commitment`
  and is the one to watch.

## 2. `commitment` — a roster answers the earliest day anything it holds has been kept from

Seven scenarios, in `src/DayByDayKit/Tests/DayByDayKitTests/RosterTests.swift`. One red-green cycle
each, in this order, taking the next scenario verbatim as the `@Test` display name (rule 3). The
whole of the implementation is one computed property, `Roster.earliestKeptFrom`
(`design.md` § *The seam*), walking `entries` rather than `commitments` — if any box below needs a
stored field, a new `Entry` part, or a change to `add`, `retire`, `remove`, `put` or either `move`,
that is a stop.

- [x] 2.1 `a roster holding no commitments answers no earliest day anything it holds is kept from` —
  adds the member.
- [x] 2.2 `a roster answers the earliest day among the commitments it holds` — and the same three
  taken on in the opposite order answer the same. An implementation reading the first entry passes
  half of this and fails the other half.
- [x] 2.3 `a roster counts a commitment it has stopped keeping in the earliest day anything it holds is kept from`
  — this is what forces the walk over `entries`. An implementation over `commitments` passes 2.1 and
  2.2 and fails here.
- [x] 2.4 `a roster counts a commitment it has removed in the earliest day anything it holds is kept from`
  — ADR-1035: a roster never lets a commitment go, and this is that rule read over one more question.
- [x] 2.5 `the earliest day anything a roster holds is kept from falls when a commitment kept from an earlier day is taken on`
- [x] 2.6 `a roster answers the day a commitment is kept from and not a day it is due` — if
  `Schedule` or `isDue(on:)` appears anywhere in the implementation, stop and report it.
- [x] 2.7 `a roster answers the first supported date where a commitment it holds is kept from it`

## 3. `day-screen` — the reach of the day picker, and the day picked on it

Twenty-one scenarios over two requirements, in
`src/DayByDayKit/Tests/DayByDayKitTests/DayScreenTests.swift`. One red-green cycle each, in this
order. The whole of the implementation is one nested value `DayScreen.Reach`, one computed property
`dayPickerReach`, and one method `showDay(_:)` shaped exactly like `showToday()`
(`DayScreen.swift:481`). **`showDay(_:)` must not read the record or the roster again** — if either
`Self.open` or `Self.openRoster` appears in it, that is a stop.

### 3a. A day screen says the reach of its day picker — ten scenarios

- [x] 3.1 `a day screen's day picker opens on the day it is showing` — adds `Reach` and
  `dayPickerReach`, both answered off state the screen already holds.
- [x] 3.2 `a day screen's day picker reaches back to the earliest day anything on its roster is kept from`
  — asks `Roster.earliestKeptFrom` from § 2 and does not recompute it.
- [x] 3.3 `a day screen's day picker reaches back past a commitment its roster has stopped keeping`
- [x] 3.4 `a day screen's day picker reaches back past a commitment its roster has removed`
- [x] 3.5 `a day screen's day picker reaches back to the day it is showing where that is the earlier of the two`
  — the clamp. An implementation that used the roster's answer unconditionally passes everything
  above and fails here.
- [x] 3.6 `a day screen that cannot read its roster reaches back to the today it was handed` — the
  fallback, which is the `nil` from § 2 and no state of its own.
- [x] 3.7 `a day screen that takes on the commitments it was handed reaches back to the earliest of those`
  — a first launch is **not** the fallback case: day one is written before the screen answers
  anything (ADR-1027).
- [x] 3.8 `a day screen whose roster stops being readable goes on showing its day and reaches back to it`
  — **this is the box that separates a computed reach from one stored at `init`**
  (`design.md` § *Risks*). It also says the screen does not move when the floor rises, which is
  `grill.md` § *Settled* 6. If making it pass needs a change to `returnedTo()`, stop and report it.
- [x] 3.9 `a day screen that cannot read its record says the reach of its day picker like any other`
  — if `recordState` or `recordStore` appears in `dayPickerReach`, stop.
- [x] 3.10 `a day screen's day picker reaches back to the first supported date and opens on the last`

### 3b. A day screen shows a day picked on its day picker — eleven scenarios

- [x] 3.11 `a day screen shows a day picked between the earliest day its picker reaches and the day it was showing`
  — adds `showDay(_:)`.
- [x] 3.12 `a day screen shows a day picked after the today it was handed` — forward is open, to the
  last supported date.
- [x] 3.13 `a day screen shows the earliest day its day picker reaches when that day is picked` — the
  bound includes its own day. A `>` where a `>=` belongs fails here and nowhere else.
- [x] 3.14 `a day screen is left exactly as it was by a day picked earlier than its day picker reaches`
  — **not clamped**. If the implementation shows `dayPickerReach.earliest` instead of doing nothing,
  stop: that is the one thing `grill.md` § *Settled* 7 ruled out by name.
- [x] 3.15 `a day screen picking the day it is already showing changes nothing`
- [x] 3.16 `a day screen picking a day draws the commitments its roster had not stopped keeping on that day`
- [x] 3.17 `picking a day on a day screen does not read its roster or its record again`
- [x] 3.18 `picking a day on a day screen does not change the today it was handed`
- [x] 3.19 `a day screen stops telling what it was telling on a row when a picked day changes the day it is showing`
  — inherited from *What a day screen tells on a row lasts until the app is shown again, a change is
  kept, or the day it is showing changes*, which this delta does not modify. Write it as
  `showToday()` writes it: clear the notice only where the day actually changes.
- [x] 3.20 `a day screen goes on telling what it was telling on a row when a picked day is earlier than its day picker reaches`
  — the refused pick clears nothing. An implementation that clears the notice before the guard
  passes 3.19 and fails this.
- [x] 3.21 `a day screen offers the way back to today once a day other than that today is picked` —
  `offersGoingBackToToday` is untouched by this Story. If this box needs an edit to it, stop and
  report it.

## 4. The app shell

Under ADR-1019's 2026-09-04 amendment, whose three conditions `design.md` § *What the shell draws*
checks off one by one. **The shell computes neither the bound nor the day**: it reads both off
`screen.dayPickerReach` and writes through `screen.showDay(_:)`.

- [x] 4.1 Add a `DatePicker` with `displayedComponents: [.date]` to the day-title row
  (`ContentView.swift:109`–`:124` today: chevron, title, chevron), beside the chevrons and above the
  conditional *Today* button (`:126`). Its range is `screen.dayPickerReach.earliest...` as a
  `PartialRangeFrom`; its selection is a `Binding` whose `get` is `screen.dayPickerReach.opensOn`
  and whose `set` calls `screen.showDay(_:)`. The `Date` ↔ `CalendarDate` conversion is the ADR-1004
  edge conversion `CommitmentsView.date(from:)` (`:35`) already does in one direction and
  `ContentView.today()` (`:59`–`:62`) in the other. **Not `.graphical`** — a month grid pinned into
  the day screen is the look-back view B-040 left with B-007.
- [x] 4.2 Leave the chevrons, the *Today* button, the swipe recognizer and every row untouched. If
  any of them needs a change to make the picker work, stop and report it: the picker sits **beside**
  them, and ADR-1042 makes the horizontal swipe the screen's permanently.
- [x] 4.3 Walk it on the phone: `pnpm run phone`. Confirm five things and report anything else you
  find rather than fixing it here — the picker is drawn on the day screen and opens on the day being
  shown; picking a day weeks back shows that day, and the *Today* button appears and returns;
  picking a day in the future shows it; a day before the earliest kept-from day cannot be reached
  through the picker while the chevrons still step past it; and the horizontal swipe and both
  chevrons behave exactly as they did. Say plainly how each was confirmed, and on what.

  **Method, said plainly.** `pnpm run phone` targeted the paired `DiegoiPhone`
  (`00008130-001429A826A0001C`, `available (paired)` per `devicectl list devices`) but `xcodebuild`
  itself reported no destination matching that identifier — the phone is known to `devicectl` from a
  prior pairing but is not reachable from this machine right now (not on the same network / not
  connected), so the physical build could not run. This is a report, not a workaround (rule 5): an
  agent has no way to operate a physical device's touchscreen in any case, so — exactly as
  `add-offered-today-control` (#174) recorded doing at its own 4.4 — the five confirmations were
  driven and screenshotted on the Simulator (iPhone 15 Pro, iOS 26.5) against the identical
  `ContentView.swift`, through a throwaway `scratchWalkthroughDayPicker` XCUITest method written,
  run and then deleted (`git diff --stat` shows `WalkthroughUITests.swift` unchanged by this box).
  Today's date on the host and the Simulator was 2026-09-09; day one's `keptFrom` is 2026-09-04, so
  the floor sat 5 days behind today.

  All five held. **Drawn and opens on the day being shown**: the day-title row carries a compact
  `DatePicker` reading "9 Sep 2026" beside the chevrons, and tapping it opens the platform calendar
  on 9 with today's date circled. **A day back shows that day, and Today appears and returns**:
  picking 5 September drew that day's own (unticked) rows and titled "Saturday 5 September 2026"
  with no "Today" prefix, and a bright blue *Today* button appeared under the title row; tapping it
  returned to "Today · Wednesday 9 September 2026" with Creatine's earlier tick still showing —
  untouched by the excursion. **A future day shows**: paging the calendar to October and picking 15
  titled the screen "Thursday 15 October 2026" and the picker's own value read "15 Oct 2026".
  **The floor holds in the picker while the chevrons step past it**: with the screen on today, 1–3
  September sat greyed and untappable in the calendar (the floor is 4 September) and the previous-
  month chevron inside the popover was disabled; tapping the day screen's own *Back* chevron eight
  times in a row landed cleanly on "Tuesday 1 September 2026" — three days past that same floor —
  with an empty day view, exactly as a day with nothing kept before day one should read. **The
  chevrons and the swipe are unchanged**: the eight *Back* taps above worked as they always have,
  and separately the *existing* `testTheDayScreenDraws` XCUITest — which swipes the list right
  before asserting the *Today* button and that rows are drawn — still passes unmodified with the
  picker in place.

  **One unplanned finding, named rather than fixed here.** Once the picker sat back on 1 September —
  below the roster's own floor — reopening it showed 1 September itself now selectable and the rest
  of the month open, which is `grill.md` § *Settled* 5/6 and `design.md` § *Why the floor clamps to
  the day being shown* made visible: the reach fell to match the day being shown rather than staying
  pinned to the roster's 4 September. Also unplanned: the day-title row's `Text` now wraps to two
  lines ("Today · Wednesday 9 September 2026" no longer fits one line beside two chevrons and the
  picker) — a fourth control sharing that `HStack` costs width the row did not have before, and
  nothing in this Story's diff sets line-wrapping or truncation, so it is `List`'s own default
  behaviour rather than anything decided here. Worth a look, not a stop: nothing is clipped or
  unreadable, and the row still lays out at every width the five confirmations above needed.

## 5. The records

**Nothing is written under `docs/` or in `CONTEXT.md` by this Story**, and that is a decision rather
than an omission (`design.md` § *No ADR is owed*, `grill.md` § *Terms landed in CONTEXT.md*). These
boxes confirm rather than write, and each is tickable while reading what is already there:

- [x] 5.1 Confirm `ContentView.swift` compares no two days of its own. **`Reach.opensOn` makes the
  day being shown readable outside the screen for the first time** (`design.md` § *Giving back the
  day being shown*), so a *Today* button drawn off `opensOn != today()` would now compile and would
  bypass `offersGoingBackToToday`. Confirm the button is still drawn off `screen.offersGoingBackToToday`
  and nothing else. If the shell holds any comparison of `opensOn` against anything, stop and report
  it — that is the one regression this Story makes possible.
- [x] 5.2 Confirm `CONTEXT.md` § *Reach* and § *Day picker* still describe what shipped — the
  earliest kept-from day counting the stopped and the removed, the clamp to the day being shown, the
  today as the fallback, the control always drawn and open forward, and the bound on the control
  rather than on the screen. If the implementation needed a rule those two paragraphs do not carry,
  that is a **stop and a G4 question**, not an edit to slip in.
- [x] 5.3 Confirm no ADR was written or amended by this branch:
  `git diff --stat origin/main... -- docs/` reports nothing under `docs/adr/`. ADR-1019, ADR-1027,
  ADR-1035 and ADR-1004 are **used** here, not amended. If any needed amending, stop and report it.
- [x] 5.4 Confirm `openspec/specs/` was not hand-edited on this branch (rule 2):
  `git diff --stat origin/main... -- openspec/specs/` reports nothing.
- [x] 5.5 Leave `docs/backlog.md` alone. B-040 is answered by this Story, and moving a want to
  *Decided* is a grooming pass's act rather than a Story branch's. Confirm it has not been moved by
  this branch before the review.

## 6. Before the review, and what the janitor does at the archive

- [x] 6.1 `cd src/DayByDayKit && swift test` — every test green, and the count is **961**: 933 at
  the base plus the twenty-eight scenarios of § 2 and § 3. A count that comes back different is a
  **stop** (rule 5), not a number to write down — it would mean a test was renamed or removed by a
  box above, which § 1.1 forbids. From the repo root, `pnpm run verify` green and `pnpm run checks`
  reporting `28/28 scenario(s) covered`.
- [x] 6.2 `openspec validate add-day-picker --strict` exits 0, and `openspec validate --all --strict
  --no-interactive` exits 0.
- [x] 6.3 Rebase onto current `main` and push with `--force-with-lease`. A conflict inside
  `openspec/changes/add-day-picker/` or anywhere under `openspec/specs/` is a **stop**, not a merge
  to resolve (rule 5) — and so is a clean rebase that then fails 6.2, which is § 1.3's hazard
  arriving late.
- [x] 6.4 Hand back for the review (**G7**). The conductor spawns `reviewer`; do not run
  `mattpocock-skills:code-review` on your own diff and do not act on findings until they come back
  through the conductor. This box is ticked when the hand-back is written.

  **G7 fix pass, accepted by the repo owner.** Two findings came back and were both fixed in
  `src/` only, no scenario or test renamed or re-asserted. `ContentView.swift`'s `DatePicker` `set`
  closure force-unwrapped the `Date` → `CalendarDate` conversion; it now guards it with `guard
  let ... else { return }`, matching `CommitmentsView.define()`'s identical conversion on identical
  input — a `nil` (outside 1583–9999) is a no-op rather than a trap. `Roster.earliestKeptFrom`'s
  `reduce(into:)` became `entries.map(\.commitment.keptFrom).min { $0.days(until: $1) > 0 }`,
  keeping the convention that `CalendarDate` is compared with `days(until:)` rather than
  `Comparable`; the reviewer's suggested closure compared with `< 0`, which this pass found inverts
  the ordering (it settles on the *latest* `keptFrom`, not the earliest — confirmed both by manual
  trace against `CalendarDate.days(until:)`'s documented sign and against `DayScreen.swift:189`'s
  existing `a.days(until: b) < 0 ? b : a` "earlier of two" idiom, and empirically with a standalone
  Swift script), so `> 0` was used instead to preserve the exact behaviour the finding required.
  `swift test` from `src/DayByDayKit` still reports all **961** tests passing, including the
  `otherOrder` reversed-entries case in `RosterTests.swift` that a flipped sign would have broken;
  `xcodebuild build` for the `DayByDay` scheme against an iPhone 17 simulator succeeded; `pnpm run
  verify` and `pnpm run checks` are both green. Two other findings from the same pass were
  deliberately left: the day-title wrapping to two lines, left to #182
  (`shorten-day-title`), and § 4.3's walkthrough evidence standing on the Simulator rather than the
  phone, already accepted by the owner.
- [x] 6.5 Write the archive handover for the janitor, into the PR or the hand-back message, saying
  what it must check **after** `/opsx:archive` has run. **The `implementer` ticks this box, in its
  last commit before the archive**, on the evidence that the instruction has been written — the
  checking itself is the janitor's step and has no box of its own, deliberately: a box whose tick
  depends on the archive having run cannot be reached afterwards, because `/opsx:archive` moves this
  folder under `openspec/changes/archive/` and every editor is denied there.

  **Archive handover, for the janitor.** This change carries **two delta files and no MODIFIED
  requirement anywhere**: one `## ADDED Requirements` in `specs/commitment/` holding *A roster
  answers the earliest day anything it holds has been kept from*, and one in `specs/day-screen/`
  holding *A day screen says the reach of its day picker* and *A day screen shows a day picked on
  its day picker*. So after `/opsx:archive` runs, read both recomposed specs and confirm that
  `openspec/specs/commitment/spec.md` has gained exactly that one requirement and that
  `openspec/specs/day-screen/spec.md` has gained exactly those two; that **no existing requirement
  in either spec moved, was reworded, or lost or gained a scenario** — in particular *A day screen
  moves the day it is showing one calendar day either way*, *What a day screen tells on a row lasts
  until the app is shown again, a change is kept, or the day it is showing changes* and *A day
  screen says whether it offers the way back to today*, all three of which this delta deliberately
  leaves alone; that nothing landed in `record` or `schedule`; and that `openspec validate
  --archived` exits 0. Any drift is **a stop and a report, never a hand-edit** (rule 2):
  `openspec/specs/` is written by `/opsx:archive` and by nothing else, and the archived folder is
  denied to every editor.
