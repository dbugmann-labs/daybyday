## 1. Before a line is written

- [x] 1.1 Confirm the starting point, and report rather than work around a different one (rule 5).
  From `src/DayByDayKit`, `swift test` reports **885 tests passing** — measured 2026-09-08 with this
  branch cut from `main` at `264c5a7`, which includes `add-commitment-category` (#167). **The branch
  has since been rebased onto `fe540d5`**, which adds the day swipe (#177) and a backlog capture and
  touches no Swift outside `ContentView.swift`, so the kit count is expected to be 885 there too;
  re-measure it rather than trusting that sentence, and a different number is a stop. From the repo
  root, `pnpm run check:scenarios` reports `scenario coverage — 3/20 scenario(s) covered` and names
  `"a day screen showing the today it was handed offers no way back to today"` as next. **Those three
  are the carried scenarios of the one MODIFIED requirement** — the two calendar-end scenarios and
  *a day screen at either end of the calendar still moves the other way* — and **no test behind them
  may be renamed, moved, or have an assertion changed by a box below**: that requirement changes in
  prose only.

- [x] 1.2 Confirm the four facts the derived answer rests on, before writing any test, and stop and
  report if any is false (`design.md` § *Context*):
  `Commitment.Kind` still has exactly four cases; `Tick.init?` still refuses a commitment whose kind
  is not a tick, so `tick(asOf:)` needs no kind guard of its own; `offersTakeBackLast(asOf:)` is still
  `totalEntry(asOf:) != nil && total > 0`, so the take-back cannot widen the new answer; and
  `DayScreen`'s `today` and `shownDay` are both still `private`, so nothing outside the screen can
  make the comparison § 2 adds. If a fifth kind exists, or a kind now offers nothing on a day that has
  arrived, that is a **stop and a G4 question** — the row requirement is written on the offers exactly
  so that such a kind is answered, but the delta's scenarios do not cover one.

- [x] 1.3 Re-read this box before § 2 and again before § 4. `day-screen` is a busy capability: if
  another Story delta-ing it merges to `main` while this branch is open, a clean rebase can still
  leave this delta's MODIFIED requirement quoting text that no longer exists. Check with
  `git fetch origin && git log --oneline origin/main -- openspec/specs/day-screen/spec.md`. A change
  there is a **stop** (rule 5), not a delta to refresh quietly: refreshing it needs a further G4.

## 2. `day-screen` — a day screen says whether it offers the way back to today

Ten scenarios, in `src/DayByDayKit/Tests/DayByDayKitTests/DayScreenTests.swift`. One red-green cycle
each, in this order, taking the next scenario verbatim as the `@Test` display name (rule 3). The whole
of the implementation is one computed property, `DayScreen.offersGoingBackToToday`
(`design.md` § *The seam*); if any box below asks for a stored field, a second today, or a clock read,
that is a stop.

- [x] 2.1 `a day screen showing the today it was handed offers no way back to today` — adds the
  member. Answered off `shownDay` and `today`, both already held.
- [x] 2.2 `a day screen moved into the past offers the way back to today`
- [x] 2.3 `a day screen moved into the future offers the way back to today`
- [x] 2.4 `a day screen offers no way back to today once it has gone back` — and a screen moved away
  and back by two moves offers none either. This is what makes the answer about the day being shown
  rather than about how many moves were made; an implementation counting moves passes 2.2 and 2.3 and
  fails here.
- [x] 2.5 `going back to today on a day screen that offers no way back leaves it showing that today`
  — `showToday()` is untouched by this change (`grill.md` § *Settled* 3). If this box needs an edit to
  `showToday()`, stop and report it: offered governs what is drawn as a target and never what the seam
  accepts.
- [x] 2.6 `a day screen shown again on a later day offers the way back to today from the day it
  stayed on`
- [x] 2.7 `a day screen showing its today when the app is shown again on a later day offers no way
  back to today` — the screen follows onto the new today, so it is showing it again.
- [x] 2.8 `a day screen the day it is showing has caught up with offers no way back to today` — the
  screen was moved and offers nothing all the same, because the today it is measured against has
  since become the day it is showing. An implementation holding "has it been moved" rather than
  comparing the two days passes every box above and fails this one.
- [x] 2.9 `a day screen whose move had nowhere to go offers no way back to today` — at both ends of
  the calendar. The move left `shownDay` alone, so the answer is unchanged; nothing about this needs a
  rule of its own.
- [x] 2.10 `a day screen that cannot read its record says whether it offers the way back to today
  like any other` — the answer is about the two days and about nothing else.

## 3. `day-screen` — a row says whether it offers anything at all

Seven scenarios, in `src/DayByDayKit/Tests/DayByDayKitTests/DayViewTests.swift`. One red-green cycle
each, in this order. The whole of the implementation is one member on `DayView.Row`,
`offersAnything(asOf:)`, **derived from the four offers the row already computes** and never from the
date (`design.md` § *Why the row's answer is derived from the offers and not from the date*).

**No scenario here can tell the two implementations apart**, because every kind offers exactly one
thing on a day that has arrived — `design.md` § *Risks* says so out loud. Write it as the four offers
anyway: that is what the requirement says is normative, and it is what a fifth kind will inherit.

- [x] 3.1 `a row of every kind offers something on a day that has arrived` — adds the member, over
  `tick(asOf:)`, `numberEntry(asOf:)`, `noteEntry(asOf:)` and `totalEntry(asOf:)`.
- [x] 3.2 `no row of a day view whose date has not arrived offers anything`
- [x] 3.3 `a row for a date earlier than the day it is asked as of offers something`
- [x] 3.4 `a row's answer about offering anything follows the day it is asked as of`
- [x] 3.5 `a row offers something whether or not its day says the commitment is kept`
- [x] 3.6 `a total row whose day holds no addition offers something` — the take-back is not a fifth
  thing asked about. If `offersTakeBackLast(asOf:)` appears in the implementation, stop: it can
  change no answer, and consulting it would make a row's tappability depend on the history.
- [x] 3.7 `a row offers something on its own date in the first supported year and in the last`

## 4. The app shell and the smoke layer

Under ADR-1019's 2026-09-04 amendment, whose three conditions `design.md` § *The shell rides this
Story* checks off one by one. **The shell computes neither answer**: it asks the screen and it asks
the row. If either condition ends up written as a comparison in `ContentView.swift`, stop and report
it — that is the one thing this Story exists to prevent.

- [x] 4.1 Draw the *Today* button only where `screen.offersGoingBackToToday`
  (`ContentView.swift:126`–`:132` today, drawn with no condition at all). **Hidden, not
  drawn-and-inert**: B-028's own words are "should not exist".
- [x] 4.2 Draw a row as a `Button` only where `row.offersAnything(asOf: today())`
  (`ContentView.swift:164`–`:212` today, every row a `Button` whatever it offers). Where it offers
  nothing, **the same label is drawn as plain content**: the row keeps its name, its rhythm, its
  "so far of target" line where it has one, and its kept mark, and only the tap goes. **No message,
  no second style, no greying rule** — B-035 was answered against its own words at the Feature grill.
  The four `nil` checks that choose which sheet to open stay exactly where they are; what goes is the
  decision about whether there is a tap at all.
- [x] 4.3 Move a day back in `WalkthroughUITests.swift` before it asserts `app.buttons["Today"]`
  (`:26`–`:28` today), so the smoke layer still proves the shell drew the button — and now also fails
  if the button is hidden everywhere. **That assertion goes red the moment 4.1 lands**, which is
  expected and is the whole reason this box exists; ADR-1029's rule that this layer says nothing about
  *what* was drawn is unchanged, and no second assertion is added.
- [x] 4.4 Walk it on the phone: `pnpm run phone`. Confirm five things and report anything else you
  find rather than fixing it here — today has no *Today* button; a day back has one and it returns;
  a future day's rows are drawn, say what they say, and do not respond to a tap; a past day's rows
  still tick, enter and take back exactly as before; and **the horizontal swipe still moves the day
  from a row that offers nothing**, which is the one thing #177 adds to this walkthrough: its
  recognizer is a `.simultaneousGesture` on the list rather than anything a row holds
  (`ContentView.swift:223`), so a row drawn as plain content should change nothing about it. If it
  does, stop and report it — ADR-1042 says that gesture is the screen's permanently, and a Story that
  quietly narrowed it would be the wrong place to find out.

  **Method, said plainly.** `pnpm run phone` built, installed and launched on the paired
  `DiegoiPhone`. The five confirmations themselves were driven and screenshotted on the Simulator,
  against the identical `ContentView.swift`, through a throwaway `scratchWalkthrough` XCUITest
  method written, run and then deleted (never committed — `git diff --stat` shows
  `WalkthroughUITests.swift` unchanged by this box). An agent has no way to operate a physical
  device's touchscreen; the Simulator run is the substitute and is named here rather than left
  implied. All five held: today drew no *Today* button; a day back drew one and tapping it
  returned and hid it again; a future day's rows drew (name, rhythm, no checkmark) and a tap on
  one changed nothing and opened no sheet; swiping three more days into the future — every row
  along the way offering nothing — still moved the day each time; and moving back onto a past day
  restored the tappable (blue) rows, where a tap ticked one as before. One incidental, unplanned
  and worth naming rather than fixing here: a row that stops being a `Button` also stops taking
  the List's default blue tint, so an offering row reads blue and a non-offering one reads the
  primary black — nothing in this Story's diff sets that color, it is `List`'s own default styling
  for a `Button` label versus plain content, and it happens to read as a small, unplanned bonus
  toward "only the tap goes" rather than against it.

## 5. The records

**Nothing is written under `docs/` or in `CONTEXT.md` by this Story**, and that is a decision rather
than an omission (`grill.md` § *Settled* 10, § *Terms landed in CONTEXT.md*). These boxes confirm
rather than write, and each is tickable while reading what is already there:

- [x] 5.1 Confirm `CONTEXT.md` § *Offered* still describes what shipped — a control offered when the
  screen can honour it, a screen drawing as a target only what it offers, the row that stays while its
  tap goes, and the chevrons at the calendar's two ends left drawn. If the implementation needed a
  rule that paragraph does not carry, that is a **stop and a G4 question**, not an edit to slip in.
- [x] 5.2 Confirm no ADR was written or amended by this branch:
  `git diff --stat origin/main... -- docs/` reports nothing under `docs/adr/`. ADR-1019 and ADR-1029
  are **used** here, not amended — the shell work is exactly the first's 2026-09-04 exception and the
  walkthrough change is exactly the second's one-tap smoke assertion. If either needed amending, stop
  and report it.
- [x] 5.3 Confirm `openspec/specs/day-screen/spec.md` was not hand-edited on this branch (rule 2):
  `git diff --stat origin/main... -- openspec/specs/` reports nothing.
- [x] 5.4 Leave `docs/backlog.md` alone. B-028 and B-035 are both answered by this Story, and moving a
  want to *Decided* is a grooming pass's act rather than a Story branch's. Confirm neither has been
  moved by this branch before the review.
- [x] 5.5 Leave `docs/open-questions.md` alone, and **carry its text into the hand-back instead**.
  `grill.md` § *Left open* settles that *the shell reads its own clock per row while the screen holds
  a today it was handed* belongs there as an open technical decision; `docs/open-questions.md` is
  written by neither `spec-author` nor `implementer` (`AGENTS.md` § *Agent roles and model routing*),
  so no box here can tick its writing. Confirm this branch has not touched the file, and put the entry
  — the skew, `ContentView.swift:164` and `:59`–`:62`, that it predates this Story because all five
  existing row offers are already asked that way, and that closing it means either exposing the
  screen's today or moving row answers onto the screen, both rejected at this grill — into the review
  hand-back, the way `add-commitment-category` (#147) carried its own § *Left open* to its close-out.

## 6. Before the review, and what the janitor does at the archive

- [x] 6.1 `cd src/DayByDayKit && swift test` — every test green, and the count is **902**: 885 at
  `264c5a7` plus the seventeen scenarios of § 2 and § 3. A count that comes back different is a
  **stop** (rule 5), not a number to write down — it would mean a test was renamed or removed by a box
  above, which § 1.1 forbids. From the repo root, `pnpm run verify` green and `pnpm run checks`
  reporting `20/20 scenario(s) covered`.
- [x] 6.2 `openspec validate add-offered-today-control --strict` exits 0, and `openspec validate --all
  --strict --no-interactive` exits 0.
- [x] 6.3 Rebase onto current `main` and push with `--force-with-lease`. A conflict inside
  `openspec/changes/add-offered-today-control/` or anywhere under `openspec/specs/` is a **stop**, not
  a merge to resolve (rule 5) — and so is a clean rebase that then fails 6.2, which is § 1.3's hazard
  arriving late.
- [x] 6.4 Hand back for the review (**G7**). The conductor spawns `reviewer`; do not run
  `mattpocock-skills:code-review` on your own diff and do not act on findings until they come back
  through the conductor. This box is ticked when the hand-back is written, and § 5.5's entry is part
  of it.
- [x] 6.5 Write the archive handover for the janitor, into the PR or the hand-back message, saying
  what it must check **after** `/opsx:archive` has run. **The `implementer` ticks this box, in its
  last commit before the archive**, on the evidence that the instruction has been written — the
  checking itself is the janitor's step and has no box of its own, deliberately: a box whose tick
  depends on the archive having run cannot be reached afterwards, because `/opsx:archive` moves this
  folder under `openspec/changes/archive/` and every editor is denied there.

  **Archive handover, for the janitor.** This delta carries two `## ADDED Requirements` —
  *A day screen says whether it offers the way back to today* and *A row says whether it offers
  anything at all* — and one `## MODIFIED Requirement`, *A move with nowhere to go leaves a day screen
  exactly as it was*, **which is not renamed and whose three scenarios are carried verbatim**: only
  one paragraph inside it is new. So after `/opsx:archive` runs, read the recomposed
  `openspec/specs/day-screen/spec.md` and confirm that the MODIFIED requirement still sits where it
  sat in requirement order, still holds exactly those three scenarios under their existing titles, and
  has gained only the paragraph beginning "That refusal is about the two ends of the calendar"; that
  both ADDED requirements landed in `day-screen` and nowhere else; that no other requirement in that
  spec moved or changed; and that `openspec validate --archived` exits 0. Any drift — a requirement
  moved, dropped, or reworded beyond this delta's own text — is **a stop and a report, never a
  hand-edit** (rule 2): `openspec/specs/` is written by `/opsx:archive` and by nothing else, and the
  archived folder is denied to every editor.
