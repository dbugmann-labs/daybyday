## 1. Ground rules for this change

This delta is unusually large and almost entirely mechanical: **112 scenarios, of which 105 already
have an acceptance test carrying exactly the right name.** What changes in those 105 is what they
assert, not what they are called. Read these three before starting; each one is a way this change
can go wrong quietly.

**Two of those 105 arrived from somewhere else.** `add-commitment-editing` (#148, PR #188) landed on
`day-screen` after this folder was written, adding two scenarios to *A day screen reads its roster
again when it is returned to* and rewriting that requirement's prose. A MODIFIED block replaces the
whole requirement, so this delta had to take that requirement's current text and re-apply only its
own two edits to it; the two scenarios and their tests come across unchanged and neither asserts a
day title. Nothing else in this change moves, and § 3.2 covers the requirement exactly as before.

- [x] 1.1 **Never rename or delete a test that a delta scenario names.** Confirm before you start
  that all 112 scenario titles in `specs/day-screen/spec.md` are accounted for: 105 have a test
  today, 7 do not and are listed in § 4. Nine *other* tests are retired in § 3.4 because their
  requirements are `## REMOVED`; those nine are the only deletions this change makes, and their
  names are listed there. Verify with `pnpm run checks` reporting `112/112 scenario(s) covered` at
  the end, and with § 7.1's test count.
- [x] 1.2 **CI check 4 cannot catch a stale assertion in this change.** It matches scenario titles
  to test titles, and 105 of them already match — so a test whose assertion was never brought in
  line still passes it. `swift test` is what catches those, because the implementation returns
  `"Mon"` where the old assertion expects `"Today · Monday 31 August 2026"`. Never make a test pass
  by relaxing it: if an assertion cannot be made to match its scenario, that is a **stop**
  (rule 5), not a weakened test.
- [x] 1.3 **Read `design.md` § *What the other ten requirements assert instead* before touching
  `DayScreenTests.swift`.** Ten requirements change no behaviour at all; their scenarios swap a
  day-title assertion for `dayPickerReach.opensOn` or `offersGoingBackToToday`. If a scenario in
  the delta seems to require a *new* answer from `DayScreen`, you have misread it — nothing in this
  change adds one. Stop and report it.

## 2. The kit: what a day title says

- [x] 2.1 Take **`a day view says its day as the three-letter name of its weekday`** red-green as
  one cycle (rule 3). Write the test in `DayViewTests.swift` named exactly that; it asserts a day
  view of Monday 31 August 2026 says `"Mon"`, and it is red against today's implementation, which
  says `"Monday 31 August 2026"`. Then make it pass:
  `DayTitle.weekdayNames` becomes the three-letter names, `DayTitle.monthNames` is deleted with its
  only caller, and `DayView.title(asOf:)` becomes `public var title: String` returning that one
  lookup — no `date == today` comparison and no `"Today · "` prefix. `DayScreen.title` drops the
  `asOf: today` argument it passes on.
- [x] 2.2 Expect this one edit to turn a large number of shipped tests red at once — that is this
  change's shape, not a mistake, and § 3 is where they come back. Verify the edit itself is
  complete rather than the suite green: `cd src/DayByDayKit && swift build` succeeds, and
  `grep -rn 'monthNames\|title(asOf' src/` returns nothing.
- [x] 2.3 Confirm `Weekday.swift` and `ScheduleWords.swift` are **untouched** by this branch —
  `git diff --stat origin/main... -- src/DayByDayKit/Sources/DayByDayKit/Weekday.swift
  src/DayByDayKit/Sources/DayByDayKit/ScheduleWords.swift` reports nothing. `design.md` § *Why the
  two tables stay apart* says why the weekday names are not shared with `schedule`'s; merging them
  is a **stop and a G4 question**, not a tidy-up.

## 3. The kit: bringing the 105 named tests in line

Work **one requirement at a time**, in this order, and run `swift test` after each. Each box is
ticked when every test belonging to that requirement is green and asserts what its scenario in
`specs/day-screen/spec.md` says — no more and no less.

- [x] 3.1 **The two title requirements** (`## ADDED`). In `DayViewTests.swift`, the four reused
  names under *A day view says its day as a weekday*; in `DayScreenTests.swift`, the five reused
  names under *A day screen says the day it is showing*. Assertions become the short weekday.
- [x] 3.2 **The eight re-witnessed requirements.** *A day screen moves the day it is showing one
  calendar day either way*; *A day screen goes straight back to the today it was handed*; *A move
  with nowhere to go leaves a day screen exactly as it was*; *What a day screen tells on a row lasts
  until…*; *A day screen reads its roster again when it is returned to*; *A day screen says whether
  it offers the way back to today*; *A day screen says the reach of its day picker*; *A day screen
  shows a day picked on its day picker*. In each, a day-title assertion becomes an assertion on
  `screen.dayPickerReach.opensOn`, on `screen.offersGoingBackToToday`, or on both — read the
  scenario, do not pattern-match the old line.
- [x] 3.3 **The two requirements that keep a title assertion.** *A day screen that cannot read its
  roster draws the day and no rows* keeps its clause and it becomes `"Mon"` — that requirement is
  about the screen still saying its day. The five scenarios re-homed into *A day screen re-reads its
  day and its record when the app is shown again* keep their names and their tests, and their
  day-title clauses are re-witnessed as in 3.2.
- [x] 3.4 **Delete exactly these nine tests**, whose requirements are `## REMOVED` and whose names
  appear nowhere in the delta: `a day view says its day as a weekday, a day of the month, a month
  and a year`; `a day view of the day it is asked as of says Today before the date`; `a day view of
  a day before the one it is asked as of says the date and not Today`; `a day view of a day after
  the one it is asked as of says the date and not Today`; `a day of the month below ten is said
  without a leading zero`; `every month is said by its own name`; `a day screen says the day its own
  day view says, asked as of the day it was handed`; `a day screen moved to another day says that
  day and does not say Today`; `a day screen sent back onto today says Today again`. Deleting a
  tenth is a **stop**.

## 4. The kit: the six remaining new scenarios

One red-green cycle each, one scenario at a time (rule 3), each test named verbatim:

- [x] 4.1 `two day views whose dates fall on the same weekday say the same day title` — the scenario
  that pins *no day of the month, no month, no year*.
- [x] 4.2 `a day screen says its day the same way whether or not it is showing its today` — the
  scenario that pins *Today* being gone from the words. If this one is hard to make fail first, the
  implementation already dropped the prefix in § 2.1; write it anyway and confirm it is green for
  the right reason by temporarily restoring the prefix.
- [x] 4.3 `a day screen says the day its own day view says`.
- [x] 4.4 `a day screen moved to another day says that day`.
- [x] 4.5 `a day screen sent back onto today says that today's weekday`.
- [x] 4.6 `a day screen showing a day picked on its day picker says that day`.

## 5. The shell

Under ADR-1019's 2026-09-04 exception — a title nobody can see shortened would leave the wrap this
Story exists to fix exactly where it is.

- [x] 5.1 In `ContentView.swift`'s `dayList` `HStack`, arrange the row so the day picker sits
  between the chevrons and is what says the date, with the short title beside it (`grill.md`
  § *Settled* 5). The shell goes on reading `screen.title` and `screen.dayPickerReach` and computes
  neither. Verify: `xcodebuild build` for the `DayByDay` scheme succeeds.
- [x] 5.2 Confirm the shell formats no date and assembles no sentence — `CONTEXT.md` § *App shell*.
  It may pass a `CalendarDate` to `DatePicker` through the `Date` conversion already there; it may
  not build a string out of a weekday, a day, a month or a year. Any such string is a **stop**.
- [x] 5.3 Leave `WalkthroughUITests.swift` alone. It asserts the *Today* button and that some row
  was drawn, never the day title. `git diff --stat origin/main... -- src/DayByDay/DayByDayUITests/`
  reports nothing.

## 6. The records

**ADR-1022 and the three `CONTEXT.md` entries were amended by `spec-author`, on this branch, before
G4** — the grill assigned that wording to the delta's author (`grill.md` § *Terms landed in
CONTEXT.md*), and leaving them contradicting the delta would have made G4 a read of a doc set
disagreeing with itself. So 6.1 and 6.2 **confirm** rather than write:

- [x] 6.1 Confirm `docs/adr/1022-the-day-is-said-in-the-apps-own-words.md` still describes what
  shipped: the app says the weekday in its own seven names, the date is the day picker's and so the
  device's, and nothing the app owns states a date. Its `- Amended: 2026-09-09` stamp is present.
  If the implementation needed a rule the ADR does not carry, that is a **stop and a G4 question**,
  not an edit to slip in. **Say what changed in the ADR and why in the PR** — `docs/adr/README.md`'s
  first requirement, read against this diff.
- [x] 6.2 Confirm the three amended `CONTEXT.md` entries still describe what shipped — **Day title**
  (weekday alone, three letters, no date, no *Today*, not asked as of a day), **Today** (the day
  title is no longer a question asked as of the today) and **Day picker** (between the chevrons, and
  what says the date). Coin no new term: writing the delta turned none up, and coining one here is a
  **stop**, not an edit.
- [x] 6.3 Confirm `openspec/specs/` was not hand-edited on this branch (rule 2):
  `git diff --stat origin/main... -- openspec/specs/` reports nothing before the archive.
- [x] 6.4 Leave `docs/backlog.md` and `docs/open-questions.md` alone. Moving a want is a grooming
  pass's act, not a Story branch's.

## 7. Before the review, and what the janitor does at the archive

- [x] 7.1 `cd src/DayByDayKit && swift test` — every test green, and the count is **1015**: 1017 at
  the base, plus the seven new tests of § 2.1 and § 4, minus the nine retired in § 3.4. A count that
  comes back different is a **stop** (rule 5), not a number to write down — it means a test was
  renamed or dropped that § 1.1 forbids. *The base was 961 when this folder was written;
  `add-commitment-editing` (PR #188) landed 56 tests on `main` afterwards, so both numbers moved by
  56 and the arithmetic between them did not.* From the repo root, `pnpm run verify` green and
  `pnpm run checks` reporting `112/112 scenario(s) covered`.
- [x] 7.2 `openspec validate shorten-day-title --strict` exits 0, and `openspec validate --all
  --strict --no-interactive` exits 0.
- [x] 7.3 Rebase onto current `main` and push with `--force-with-lease`. A conflict inside
  `openspec/changes/shorten-day-title/` or anywhere under `openspec/specs/` is a **stop**, not a
  merge to resolve (rule 5) — this delta restates twelve requirements of `day-screen`, so any other
  Story that landed on that capability meanwhile conflicts with it by construction.
- [x] 7.4 Hand back for the review (**G7**). The conductor spawns `reviewer`; do not run
  `mattpocock-skills:code-review` on your own diff, and do not act on findings until they come back
  through the conductor. This box is ticked when the hand-back is written.
- [x] 7.5 Write the archive handover for the janitor, into the PR or the hand-back message.
  **The `implementer` ticks this box, in its last commit before the archive**, on the evidence that
  the handover has been written — the checking itself is the janitor's step and has no box of its
  own, deliberately: a box whose tick depends on the archive having run cannot be reached
  afterwards, because `/opsx:archive` moves this folder under `openspec/changes/archive/` and every
  editor is denied there.

  **Archive handover, for the janitor.** This delta carries all four operation sections —
  `## ADDED` (2 requirements), `## MODIFIED` (10), `## REMOVED` (2) — against the single capability
  `day-screen`, and it is the first change in this repo to use `## REMOVED` at all. After
  `/opsx:archive` has run, check three things in `openspec/specs/day-screen/spec.md` and report,
  never edit: that the two removed requirement headers are **gone** (grep for
  `says Today on the day it is asked as of` and for `as of the day it was handed` — both must
  return nothing); that the two added ones are **present**; and that `A day screen re-reads its day
  and its record when the app is shown again` now holds **15** scenarios rather than 10, the five
  re-homed ones included. Then `openspec validate --all --strict --no-interactive` and
  `openspec validate --archived` must both exit 0. **Any drift is a stop and a report, never a
  hand-edit** — `openspec/specs/` is written by `/opsx:archive` and nothing else (rule 2), and the
  archive path is denied to every editor anyway.
