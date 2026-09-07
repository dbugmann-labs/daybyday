## 1. Before a line is written

- [x] 1.1 Confirm the starting point, and report rather than work around a different one (rule 5).
  From `src/DayByDayKit`, `swift test` reports **418 tests passing**. From the repo root,
  `pnpm run checks` reports `scenario coverage — 10/42 scenario(s) covered` for this change and
  names `"an entry says the rhythm its commitment runs on, whichever of the four shapes it is"` as
  next. Those ten are the restated scenarios this delta carries verbatim; **none of their tests may
  be renamed, moved or have an assertion changed by any box below.**

**The order below is not the order the delta reads in, and that is deliberate.** The first scenario
in `specs/schedule/spec.md` — *each of the four schedule shapes says the rhythm it runs on in words*
— cannot be the first test written: making it pass needs all four shapes at once, which is four
red-green cycles collapsed into one (rule 3). One shape is written first, the other three follow,
and the three cross-shape scenarios come last, when there is something for them to be about.

## 2. `schedule` — a weekday set says its days

Five scenarios from `specs/schedule/spec.md`, all in `Tests/DayByDayKitTests/ScheduleTests.swift`.
Each task takes exactly one `#### Scenario:` and writes one acceptance test whose `@Test("...")`
display name is that scenario title **verbatim**, then makes it pass with the smallest change that
does. Never write two before the first is green (`AGENTS.md` rule 3). Verify each with
`cd src/DayByDayKit && swift test`: the named test green, every earlier test still green.

- [x] 2.1 `a weekday-set schedule says its weekdays as three-letter names` — the first test in this
  change and the one that creates `Sources/DayByDayKit/ScheduleWords.swift` and
  `public var Schedule.inWords: String`. `design.md` § *One table of words* fixes what goes in that
  file: it is internal, it publishes nothing, and it is the shape `DayTitle.swift` already is.
  `Schedule.inWords` may `fatalError` on the three shapes no test has reached yet, or answer them
  wrongly; what it may not do is guess at their words ahead of their own scenarios.
- [x] 2.2 `a weekday-set schedule says its weekdays in week order from Monday` — the test that makes
  the order real. A `Set<Weekday>` has no order at all, so an implementation that iterates the set
  passes 2.1 by luck and fails here, which is the point of writing it second. The fixed
  Monday-to-Sunday array `design.md` § *Monday-first* calls for goes in with this box; `Weekday`
  itself gains nothing — no `CaseIterable`, no `Comparable`, no raw value.
- [x] 2.3 `every weekday is said by its own three-letter name` — the roll call, and the only guard
  against a typo in one of the seven.
- [x] 2.4 `a weekday set listing every weekday is said as every day`
- [x] 2.5 `a weekday set listing no weekday is said as no day` — the case a commitments screen
  refuses to define on and the engine forms anyway; `design.md` § *Words for a schedule the screen
  would refuse* says why it has words at all.

## 3. `schedule` — an interval, a day of the month, a quota

Eleven scenarios from `specs/schedule/spec.md`, in the file that already holds each shape's
due-ness tests. Same rule as § 2: one scenario, one test, one name, verbatim.

- [x] 3.1 `an every-N-days schedule says its interval in days` — in
  `Tests/DayByDayKitTests/EveryNDaysScheduleTests.swift`.
- [x] 3.2 `an every-N-days schedule says the same words whatever its start date` — the test that
  fails an implementation which reaches for the start date because it is right there in the case.
- [x] 3.3 `an interval of one day is said as every day`
- [x] 3.4 `an interval of two days says its number` — the plural boundary, where an implementation
  that special-cases one day by dropping the number entirely goes wrong.
- [x] 3.5 `a day-of-month schedule says its day as an ordinal` — in
  `Tests/DayByDayKitTests/DayOfMonthScheduleTests.swift`.
- [x] 3.6 `the eleventh, twelfth and thirteenth are said with th and not with st, nd and rd` — write
  this **before** the roll call. An ordinal rule written from the last digit alone passes 3.5 and
  fails exactly here, and finding that with three strings is cheaper than finding it with
  thirty-one.
- [x] 3.7 `every day of the month from the first to the thirty-first is said as its own ordinal` —
  all thirty-one strings, in one test, exactly as the scenario lists them.
- [x] 3.8 `a day-of-month schedule does not say the clamp onto a short month` — expect it green on
  first write once 3.5 is in. It is what pins that nobody later "helpfully" adds "(or the last day
  of a shorter month)" to the words; a red test here is a real finding, not a licence to edit the
  ordinal rule.
- [x] 3.9 `a weekly-quota schedule says its number of times a week` — in
  `Tests/DayByDayKitTests/WeeklyQuotaScheduleTests.swift`.
- [x] 3.10 `a weekly quota of seven times a week is not said as every day` — asserts both strings,
  so a later change cannot quietly merge the two rhythms.
- [x] 3.11 `every number of times a week from one to seven is said in its own words`

## 4. `schedule` — the three rules that are about all four shapes

Three scenarios from `specs/schedule/spec.md`, in `Tests/DayByDayKitTests/ScheduleTests.swift`.
These come last because each is about the four shapes together. Expect 4.1 and 4.2 green on first
write; **record in § 9 which of the three actually ran red**, and treat a red one as a finding
about §§ 2–3 rather than as a reason to edit the words here.

- [x] 4.1 `each of the four schedule shapes says the rhythm it runs on in words`
- [x] 4.2 `two schedules that name the same rhythm say the same words`
- [x] 4.3 `a number is said in digits with no grouping separator` — "Every 1000 days". This one is
  expected red only if something reached for a locale-aware number formatter, which is the whole
  reason the scenario exists (ADR-1022, ADR-1033); if it passes on first write, say so in § 9 and
  confirm by reading the implementation that no formatter is there to be caught.

## 5. `commitment` — the entry and the form's preview

Nine scenarios from `specs/commitment/spec.md`, all in
`Tests/DayByDayKitTests/CommitmentsScreenTests.swift`.

- [x] 5.1 `an entry says the rhythm its commitment runs on, whichever of the four shapes it is` —
  adds `public var Commitment.rhythmInWords: String` in `Sources/DayByDayKit/Commitment.swift`,
  reading `schedule.inWords`. **No other member of `Commitment` changes visibility**: `schedule`
  and `keptFrom` stay internal, which is the whole of ADR-1033 and of what the grill settled.
- [x] 5.2 `two commitments alike in name and not in rhythm are told apart by the rhythm their
  entries say` — expect green on first write once 5.1 is in. It is the Story's own reason stated as
  an assertion, and it sits immediately after the scenario whose title says the opposite.
- [x] 5.3 `two commitments alike in name and in rhythm are two entries that say the same thing` —
  the honest half: a rhythm beside a name tells two commitments apart only when the rhythms differ.
- [x] 5.4 `a stopped entry says the rhythm its commitment runs on, as a kept entry does` — the
  second list, which is the one a commitment is taken up again from.
- [x] 5.5 `a rhythm being built is said in the words the schedule it names says` — adds
  `public var Rhythm.inWords: String?` in `Sources/DayByDayKit/Rhythm.swift`. `design.md` § *One
  table of words* fixes its shape: it switches onto the same `ScheduleWords` functions
  `Schedule.inWords` uses, and it guards each number through `DayOfMonth(day:)`,
  `DayInterval(days:)` and `WeeklyQuota(timesPerWeek:)` rather than restating `1...31`, `>= 1` or
  `1...7` anywhere.
- [x] 5.6 `an interval rhythm is said without a day to keep the commitment from` — the test that
  pins the two switches together, by comparing a rhythm's words with the words of the schedule it
  names from two different start dates.
- [x] 5.7 `a weekday-set rhythm with no days in it is said as no day`
- [x] 5.8 `a rhythm carrying a number the calendar will not take is said as nothing` — `nil`, and
  the assertion that none of the four says the nearest number that would have worked.
- [x] 5.9 `a rhythm carrying the number at each end of what it allows is said in words` — the
  mirror of the existing *a commitments screen accepts the number at each end of what a rhythm
  allows*, number for number.

## 6. `day-screen` — the row

Four scenarios from `specs/day-screen/spec.md`, all in `Tests/DayByDayKitTests/DayViewTests.swift`.

- [x] 6.1 `a row says the rhythm its commitment runs on in words` — adds
  `public var DayView.Row.rhythmInWords: String` in `Sources/DayByDayKit/DayView.swift`, reading
  `commitment.rhythmInWords`. `Row`'s stored parts do not change, and neither does what makes two
  rows the same row.
- [x] 6.2 `a row says its rhythm whether or not its commitment is kept`
- [x] 6.3 `a row for a day that has not arrived says its rhythm` — the row that offers no tick and
  says its rhythm anyway; both halves are asserted in the one test.
- [x] 6.4 `two rows for commitments alike in name and not in rhythm say different rhythms` — expect
  green on first write once 6.1 is in. It is what stops a later change combining two rows that
  share a name, which `CONTEXT.md` § *Day view* already forbids for a different reason.
- [x] 6.5 `cd src/DayByDayKit && swift test` reports **450 tests passing**, and from the repo root
  `pnpm run checks` reports `scenario coverage — 42/42`.

## 7. The shell

Under ADR-1019's 2026-09-04 exception: this shell work exists only to make the Story usable and
rides its branch. No scenario covers this section — `docs/open-questions.md` § *No UI smoke layer*
— so keep it to what `design.md` § *The shell rides this Story* allows: every string arrives whole
from `DayByDayKit`, and the shell chooses no word, no separator and no order.

- [x] 7.1 In `src/DayByDay/DayByDay/CommitmentsView.swift`, draw `commitment.rhythmInWords` under
  the name in **both** the "Kept" and the "Stopped" sections, secondary to the name. The two
  `ForEach` bodies are the only lines that change there; the button, the tap target and
  `screen.askToStopKeeping` / `screen.keepAgain` are untouched. `cd src/DayByDayKit && swift test`
  still reports 450, since nothing behind the seam moved.
- [x] 7.2 In the same file's "Define a commitment" section, draw `rhythm.inWords` for the rhythm the
  form is currently building, and draw **nothing at all** where it is `nil` — no placeholder, no
  dash, no refusal text. Build the `Rhythm` for the preview through the same `switch` on
  `rhythmKind` the existing `define` call uses; if that means lifting that switch into one computed
  property both read, do that rather than writing it twice.
- [x] 7.3 In `src/DayByDay/DayByDay/ContentView.swift`, draw `row.rhythmInWords` under `row.name` in
  the day list, secondary to the name, on every row. The `ForEach` still keys on
  `Array(...).enumerated()` by offset for the reason the comment there already gives, and the
  refused-tick notice keeps its place under the name.
- [x] 7.4 Build and run the shell in the simulator, the way ADR-1019 and
  `archive/2026-09-06-add-commitment-kind/tasks.md` § 7.2 do, and record what was observed with the
  simulator name, the iOS version and the exact commands. Four things must be visible, and the
  fourth is the one no unit test can reach: the day screen's rows each say a rhythm under the name;
  the commitments screen says one under every name in both lists; the define form's preview changes
  as the rhythm is built and disappears entirely when the number is one the calendar will not take;
  and **an entry says the name and the rhythm and nothing else** — no kind, no day kept from — which
  is the "and nothing else" `design.md` § *The shell rides this Story* says only a person looking at
  the screen can check.

  Ran on the **iPhone 17 simulator, iOS 26.5** (Xcode 26.6, build `17F113`):

  ```bash
  xcodebuild test -project src/DayByDay/DayByDay.xcodeproj -scheme DayByDay \
    -destination 'platform=iOS Simulator,id=59430515-851B-41A8-9BE7-76B5F59DE053' \
    -only-testing:DayByDayUITests/ScratchRhythmInWordsUITests -parallel-testing-enabled NO
  ```

  against the app's own `dayOneCommitments` seed (`ContentView.swift`), which already spans all
  four shapes, on a fresh install (`xcrun simctl uninstall … com.dbugmann.daybyday` before each
  run). A scratch `XCUITest` case (never committed — added, run, screenshotted, then deleted,
  since it was untracked and had never been staged) drove it through `XCUIApplication`, the same
  seam `WalkthroughUITests.swift` uses.

  Day screen, launched as of "Today · Monday 7 September 2026": four rows, each with the rhythm
  under the name — Creatine "Every day", Magnesium "Every day", Gym "Mon, Wed, Sat", Yuno
  "5x a week".

  Commitments screen, "Kept": all nine day-one commitments, each with a rhythm under its name and
  nothing else — no kind badge, no kept-from date — covering all four shapes: "Every day"
  (Creatine, Magnesium), "Mon, Wed, Sat" (Gym), "Tue, Thu, Sun" (Run), "Fri" (Public Pool),
  "Every 14 days" (Contact Lenses), "Every 4 days" (Nails), "The 25th" (Finances), "5x a week"
  (Yuno).

  Define form's live preview, on the "Every N days" rhythm: typing "14" into the Days field showed
  "Every 14 days" on its own line below the field, updating from what "1" had shown ("Every day");
  typing "0" removed that line entirely — no placeholder, no dash, no refusal text, confirming the
  "previews nothing" case for a number the calendar will not take.

  **One thing observed and not fixed, because it is a pre-existing gap and not this Story's
  surface**: `XCUITest`'s synthesized `.tap()` on the weekday `Toggle` switches (`app.switches`)
  did not flip their bound state in this environment — `switches["Monday"].value` read `"0"`
  before and after the tap, on two separate attempts — so the live preview could not be observed
  changing for the weekdays shape specifically through automation. This is an automation-only
  finding: the same `rhythmBeingBuilt.inWords` computed property backs every shape identically, it
  is exercised correctly for "Every N days" above, and the weekday-set words themselves are
  confirmed correct on real, already-defined commitments (Gym: "Mon, Wed, Sat") on both the day
  screen and the commitments screen. Screenshots taken during this run are not part of the diff;
  they were viewed and are not retained.

## 8. The documents

`docs/adr/1033-a-schedule-says-its-rhythm-in-words.md` and its row in `docs/adr/README.md` are
**written with this folder** and are in the G4 diff, so 8.1 and 8.2 confirm rather than write.

- [x] 8.1 Confirm before the review that 1033 is still the lowest free ADR number —
  `git log --all --name-only -- docs/adr` — and **report rather than renumber** if another branch
  has taken it (rule 5). 1032 was the highest on any local or remote ref on 2026-09-06.

  **Collision found, reported rather than resolved.** `git log --all --name-only -- docs/adr`
  on 2026-09-07 shows a second, unrelated ADR-1033 —
  `docs/adr/1033-a-number-is-taken-back-by-naming-the-day.md`, at commit `7f476e2` — proposed on
  `story/138-add-number-record` (`origin/story/138-add-number-record`), which is not merged to
  `origin/main` (`git merge-base --is-ancestor 7f476e2 origin/main` fails). This folder's own
  `docs/adr/1033-a-schedule-says-its-rhythm-in-words.md` is unchanged and is not this Story's to
  renumber — whichever of #138 and #144 merges second owes the renumber at that point, which is a
  decision for whoever reviews the two PRs together, not for either Story's own implementer.
- [x] 8.2 Confirm ADR-1033 still says what the code does, now that the code exists — in particular
  that no payload accessor became public on the way: `git diff origin/main -- src/DayByDayKit`
  shows no `internal`-to-`public` change on `Commitment.schedule`, `Commitment.keptFrom`,
  `DayOfMonth.day`, `DayInterval.days`, `WeeklyQuota.timesPerWeek`, `DayView.Row.commitment` or
  `DayView.Row.date`. One that did appear is a stop and a report, not a quiet widening: it would
  make the ADR false and the open question's ninth face wider.
- [x] 8.3 Confirm `CONTEXT.md` gained **no new term on this branch beyond the one the grill landed**
  — *rhythm in words*, committed with this folder. A second term appearing here means something was
  decided that should have been asked at the grill, and it is worth saying so in the PR rather than
  quietly adding it.
- [ ] 8.4 One entry is owed in `docs/open-questions.md`, which is not this change's file to write
  (`AGENTS.md` § *Agent roles*). Write it as a **chore commit alongside the merge**, not here, the
  way #92, #103 and #137 each left theirs. On the read-back gap, under *Known gaps*: **the ninth
  face's prediction has been answered and the gap is unchanged.** `add-rhythm-in-words` (#144) is
  the Story that entry has been naming since #9 as the one that would have to widen a schedule's
  payload — "the widening is still owed by whichever Story first renders a rule, and B-021 is that
  want" — and it renders every rule in the product without reading a single payload out. The
  package says the words (ADR-1033), so `Commitment.schedule`, `DayOfMonth.day`, `DayInterval.days`
  and `WeeklyQuota.timesPerWeek` are all still internal and all nine faces are still open. What
  changed is that nothing is now waiting on them: the next thing to need a payload will be
  something that must *compute* with one outside the package, not something that must *show* one.

## 9. The evidence, before the review

- [x] 9.1 Record, in this box, which tests ran red on first write and which came up green — in
  particular §§ 3.8, 4.1, 4.2, 4.3, 5.2, 5.3 and 6.4, every one of which is predicted green above.
  A prediction in a task file is not evidence; what happened is. A test that was expected red and
  came up green is worth one line saying why, because it usually means the assertion is weaker than
  the scenario.

  **The seven predicted-green scenarios all ran green on first write**, confirmed by running each
  filtered alone before the full suite: 3.8 (clamp — `Schedule.dayOfMonth`'s words never consult
  `date.daysInMonth`, so there was nothing to catch), 4.1 and 4.2 (the four-shape and same-rhythm
  scenarios — each shape's own switch arm was already correct by the time these were written), 4.3
  (the grouping-separator scenario — string interpolation of `Int` was used throughout, so no
  formatter was ever reached for; confirmed by reading `ScheduleWords.swift`, which contains no
  `NumberFormatter` or locale-aware type), 5.2 and 5.3 (`Commitment.rhythmInWords` reads
  `schedule.inWords` with no per-commitment state, so two commitments differing only in rhythm or
  only in kept-from day behave exactly as the requirement predicts), 6.4 (`DayView.Row.rhythmInWords`
  reads `commitment.rhythmInWords` the same way).

  **Red for the right reason, on first write, at every seam-adding step**: 2.1 (`Schedule.inWords`
  did not exist), 3.1/3.5/3.9 (`Schedule.inWords` `fatalError`'d on the shape not yet reached),
  5.1 (`Commitment.rhythmInWords` did not exist), 5.5 (`Rhythm.inWords` did not exist), 6.1
  (`DayView.Row.rhythmInWords` did not exist).

  **Red for the right reason, on a deliberately naive implementation, exactly as tasks.md
  predicted**: 2.2 (a naive `Set<Weekday>` iteration passed 2.1 by chance — confirmed the chance
  failure directly: the full suite run immediately after 2.1 landed green showed
  `schedule.inWords → "Sat, Wed, Mon"` for the same input, a different hash seed from the isolated
  `--filter` run — and then failed 2.2 outright once a fixed order was asserted) and 3.6 (an
  ordinal rule written from the last digit alone said "The 11st", "The 12nd", "The 13rd").

  **No test came up green when it was expected red, other than the ones this file already predicts
  green** — so no assertion in this delta turned out weaker than its scenario.
- [x] 9.2 `pnpm run verify` green from the repo root, `cd src/DayByDayKit && swift test` reporting
  **450 tests passing**, `pnpm run checks` reporting `scenario coverage — 42/42`, and
  `openspec validate add-rhythm-in-words --strict` exiting 0 with the change folder as it finally
  stands.

  Confirmed on 2026-09-07: `pnpm run verify` green (lint, typecheck, 118 TypeScript tests);
  `cd src/DayByDayKit && swift test` reports **450 tests passing**; `pnpm run checks` reports
  `scenario coverage — all 42 scenario(s) have a matching test`; `openspec validate
  add-rhythm-in-words --strict` prints `Change 'add-rhythm-in-words' is valid` and exits 0.

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it. **Two things the
janitor must do rather than tick.** One: this change RENAMEs nothing, so every requirement it
touches must keep its position — confirm after the archive that
`openspec/specs/commitment/spec.md` still opens with *A commitment is a name, a schedule, and the
day it is kept from*, that `openspec/specs/day-screen/spec.md` still opens with *A day view is the
commitments due on a date, each with whether it is kept*, and that `openspec/specs/schedule/spec.md`
still opens with *A weekday-set schedule is due on the weekdays it lists* with the five new
requirements appended rather than interleaved. Any drift is a stop and a report, never a hand-edit:
`openspec/specs/` is written by `/opsx:archive` and by nothing else (rule 2). Two: `openspec
validate --all --strict --no-interactive` must exit 0 on the result.
