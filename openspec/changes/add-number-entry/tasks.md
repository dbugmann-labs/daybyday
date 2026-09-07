## 1. The baseline, and the one rename

This section changes no behaviour and adds no test. It pins the starting point and moves the
notice's public name, so that everything after it is measured against a number rather than a memory
and nothing later has to touch those 26 lines twice.

- [x] 1.1 Confirm the branch point before touching anything: from `src/DayByDayKit`, `swift test`
  reports **489 tests passing**. Measured on this machine on 2026-09-07, Apple Swift 6.3.3
  (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`, at `8f78852` — the branch point, re-measured
  after `main` moved under this branch once already while the folder was being written. A different
  number means it has moved again; report it rather than working around it (`AGENTS.md` rule 5).
  **The base moved again after this box was ticked**, and every absolute number below is read
  against the base it was measured on: the branch was rebased onto `origin/main` at `00a8f23` on
  2026-09-07, where `add-roster-removal` (#156) had landed, and that base reports **544 passing**
  before any test this branch adds. 489 is what §§ 1.2–1.3 ran against and stays the record of what
  they ran against; 544 is what § 11.2 counts from. A count that is neither is a stop and a report.
- [x] 1.2 Rename the notice. In `Sources/DayByDayKit/DayScreen.swift`, add
  `public struct Notice: Hashable, Sendable { public let row: DayView.Row }` nested in `DayScreen`
  and replace `public private(set) var refusedChangeRow: DayView.Row?` (`:179`) with
  `public private(set) var notice: Notice?`; the five assignment sites are `:203` (which becomes
  `notice = Notice(row: row)`), `:206`, `:229`, `:241`, `:250` and `:260`. **`cause` is not added
  here** — § 7 adds it, driven by the first scenario that needs it. In
  `src/DayByDay/DayByDay/ContentView.swift:158`, `row == screen.refusedChangeRow` becomes
  `row == screen.notice?.row` — that line moved from 159 to 158 when
  `chore(shell): draw a commitment's rhythm beside its name` (#157) landed on `main` under this
  branch, so read it before editing it.
- [x] 1.3 Move the 26 assertion sites in `Tests/DayByDayKitTests/DayScreenTests.swift`: lines 2036,
  2064, 2065, 2066, 2095, 2126, 2127, 2151, 2171, 2198, 2229, 2266, 2302, 2325, 2349, 2374, 2414,
  2415, 2441, 2461, 2481, 2503, 2531, 2558, 2583 and 2587. A comparison **against a row** becomes
  `screen.notice?.row`; a comparison **against `nil`** becomes `screen.notice == nil`, never
  `screen.notice?.row == nil`, which is true for two different reasons and would weaken the
  assertion. **No `@Test` display name changes, no assertion changes meaning, and no test is added
  or removed here.** `swift test` reports after this box exactly the count it reported before it —
  489 on the base this box ran against, and whatever § 1.1's second paragraph says on any later one.
  A red test is a rule-5 stop, because nothing in this box was supposed to change an answer.
- [x] 1.4 Confirm the coverage tool agrees before writing a test: from the repo root,
  `pnpm run checks` reports `scenario coverage — 27/73 scenario(s) covered` for this change and
  names `"a row offers the number entry for its commitment on the date the day view is of"` as next.
  A different number means something else moved; report it rather than working around it. **The
  delta gained two scenarios at G7** (§ 12), so 73 is the total this box was measured against and 75
  is the total every box after § 12 is measured against.

## 2. What a row offers

Seven scenarios from `specs/day-screen/spec.md` § *A row offers the number entry its commitment
takes, and offers none for a day that has not arrived*, all in
`Tests/DayByDayKitTests/DayViewTests.swift`. Each task takes exactly one `#### Scenario:` and writes
one acceptance test whose `@Test("...")` display name is that scenario title **verbatim**, then makes
it pass with the smallest change that does. Never write two before the first is green (`AGENTS.md`
rule 3). Verify each with `cd src/DayByDayKit && swift test`: the named test green, every earlier
test still green.

`DayView.NumberEntry` and `Row.numberEntry(asOf:)` are shaped by `design.md` § *The seam*. Expect 2.1
red on the missing method and 2.4 red on the day guard; 2.2 should be red before the kind guard
exists. **Record which ones actually ran red as you go, in § 11**; a prediction here is not evidence.

- [x] 2.1 `a row offers the number entry for its commitment on the date the day view is of`
- [x] 2.2 `a row for a commitment whose kind is not a number offers no number entry` — the tick, note
  and total kinds, plus the number-kind control that must offer one.
- [x] 2.3 `a row offers a tick or a number entry and never both`
- [x] 2.4 `a row for a date later than the day it is asked as of offers no number entry` — the same
  guard `tick(asOf:)` carries, and the assertion that no tick is offered either.
- [x] 2.5 `a row for a date later than the day it is asked as of offers no number entry even where the
  day holds a number`
- [x] 2.6 `a row for a date earlier than the day it is asked as of offers the number entry`
- [x] 2.7 `a row offers the number entry whether or not the day is already kept`

## 3. What a number entry says

Five scenarios from § *A number entry says the range its commitment takes and the number the day
already holds*, in `Tests/DayByDayKitTests/DayViewTests.swift`. `DayView.Row` gains the internal
`number` it was formed with, per `design.md` § *A row holds the number and does not give it out* —
it is stored, it takes part in equality, and it is reachable only through `numberEntry(asOf:)`.

The hint is composed in this package's own words, with an **en dash** (`–`, U+2013) and no spaces
around it, and each bound said by `Decimal`'s own description. There is no `NumberFormatter` and no
`Locale` anywhere in it (ADR-1004, ADR-1022).

- [x] 3.1 `a number entry says the range its commitment declares as a hint` — three ranges, including
  one with fractional bounds; assert the strings exactly.
- [x] 3.2 `a number entry of a commitment that declares no range says no hint`
- [x] 3.3 `a number entry says the number the history holds for that commitment on that date` — the
  value exactly, which is what stops a `Double` creeping in later.
- [x] 3.4 `a number entry says no number where the day holds none` — a history that took none, and a
  history a number was added to and taken back from.
- [x] 3.5 `a row for a number commitment holding a number says its name, its rhythm and that the day
  is kept` — and says all three identically for a row holding a different number. This is the
  assertable half of "the row never says the number"; the unassertable half is the shape, and
  `design.md` says why no scenario can carry it.

## 4. What a row is

Two scenarios from the MODIFIED § *A row is a commitment's line on a date*, in
`Tests/DayByDayKitTests/DayViewTests.swift`. Both should be green the moment § 3's stored `number`
is in, since `Row`'s `Hashable` conformance is synthesized — a red test here means the number was
stored outside equality, which `design.md` rejects by name.

- [x] 4.1 `two rows for the same number commitment and date holding different numbers are different
  rows`
- [x] 4.2 `two rows for the same number commitment and date holding the same number are the same row`
- [x] 4.3 Confirm that the seven restated scenarios of that requirement still have their original
  tests, unrenamed and with no assertion changed: `two rows for the same commitment and date saying
  the same thing are the same row`, `two rows for the same commitment on different dates are
  different rows`, `two rows for the same commitment and date differing in whether it is kept are
  different rows`, `a row says the rhythm its commitment runs on in words`, `a row says its rhythm
  whether or not its commitment is kept`, `a row for a day that has not arrived says its rhythm`, and
  `two rows for commitments alike in name and not in rhythm say different rhythms`. All seven green.

## 5. Entering a number

Fourteen scenarios from § *A day screen enters the number a row's entry takes, and keeps it before
the day view says so*, all in `Tests/DayByDayKitTests/DayScreenTests.swift`. `DayScreen.enter(_:on:)`
guards in the same order `tick(_:)` does — the row is held, the record is kept, the row offers the
entry — then reads what was committed, then writes, then re-forms the day view. § 6 is what drives
the reading out; until then, take the smallest reading that passes the scenario in front of you.

- [x] 5.1 `entering a number on a row makes the day screen say the commitment is kept`
- [x] 5.2 `a number entered on a day screen is held by a day screen opened afterwards at the same
  place`
- [x] 5.3 `the number entry a row offers says the number just entered on it` — the prefill, end to
  end. This is the scenario the grill's answer 8 turns on.
- [x] 5.4 `a number entered on a day that already holds one replaces it` — `record`'s answer, asserted
  through the screen; no replacement logic belongs here.
- [x] 5.5 `committing an empty entry takes the number back`
- [x] 5.6 `committing an empty entry on a day that holds no number leaves the day as it was`
- [x] 5.7 `a number the commitment refuses keeps nothing and leaves the day as it was`
- [x] 5.8 `a number that cannot be kept is refused and leaves the day view as it was` — the throw, on
  a path beneath an existing ordinary file.
- [x] 5.9 `entering a number on a row the day screen's day view does not hold changes nothing`
- [x] 5.10 `committing on a row that offers no number entry changes nothing` — a tick row, and a
  number row on a day that has not arrived.
- [x] 5.11 `entering a number on a day screen that is not keeping a record changes nothing and keeps
  nothing` — including that the place is byte-for-byte what it was.
- [x] 5.12 `entering a number on one row leaves the other rows of the day as they were`
- [x] 5.13 `entering a number on a day a day screen has moved back to keeps it on that day`
- [x] 5.14 `entering a number writes nothing to the roster's place` — read the roster file after the
  screen has opened (day one writes it then), then compare byte for byte after an entry and a
  take-back.

## 6. Reading what was committed

Six of the eight scenarios of § *A day screen reads what an entry is committed with as a number, as
a take-back, or as neither*, in `Tests/DayByDayKitTests/DayScreenTests.swift`. The other two are the
review's, in § 12. The reading is one private function
on `DayScreen`; `design.md` § *Reading what was committed* fixes its order, and § *Context* has the
measurements that say why `Decimal(string:)` is never called on unchecked text.

Expect 6.2 (the comma), 6.3 (the trailing separator and the surrounding space) and **6.6** to run red
against any implementation that hands the text straight to `Decimal(string:)`: on this machine
`Decimal(string: "70,5")` is **70**, `Decimal(string: ".")` is **0** and `Decimal(string: "1.2.3")` is
**1.2**. 6.6 is the one that fails a lenient parse loudly, because it asserts the day still holds the
number entered before it.

- [x] 6.1 `a number typed with a full stop is entered exactly as it was typed` — including a very
  small and a very large value, digit for digit.
- [x] 6.2 `a number typed with a comma is entered as the same number as one typed with a full stop`
- [x] 6.3 `a number typed with leading zeros or a trailing separator is entered as the number it says`
  — `"0000070.50"`, `"70."` and `" 70.5 "`.
- [x] 6.4 `a negative number is entered where the commitment declares no range`
- [x] 6.5 `an entry committed empty takes the number back, and one holding nothing but space does the
  same`
- [x] 6.6 `a value that is not a number keeps nothing and takes nothing back` — all seven values, each
  over a day already holding 70.5.

## 7. The cause a notice names

Four scenarios from the MODIFIED § *A day screen tells on the row that was tapped that a change could
not be kept*, in `Tests/DayByDayKitTests/DayScreenTests.swift`. `DayScreen.Notice` gains
`public let cause: String?` here and not in § 1, so 7.1 is red before that field exists.

The two sentences are fixed by the delta and are asserted verbatim: `"Must be between 40 and 150"`
and `"Not a number"`. They are composed in `DayByDayKit`, with each bound said by `Decimal`'s own
description exactly as § 3's hint says it — `docs/adr/1036`.

- [x] 7.1 `a number outside the commitment's range is told on the row, naming the bounds it broke` —
  two commitments with two different ranges, so that the bounds cannot be a constant.
- [x] 7.2 `a value that is not a number is told on the row, saying so` — with a range and with none.
- [x] 7.3 `a number refused by the place is told on the row and names no cause` — the entry and the
  take-back, both with `cause == nil`.
- [x] 7.4 `a second refused commit is told on the row committed on last and no longer on the first`
- [x] 7.5 Confirm the five restated scenarios of that requirement still have their original tests,
  unrenamed and with no assertion changed beyond § 1.3's mechanical move: `a refused tick is told on
  the row that was tapped`, `a refused tick is told on the row that was tapped and on no other row`,
  `a refused take-back is told on the row that was tapped`, `a second refused tap is told on the row
  tapped last and no longer on the first`, and `a refused change does not change what a day screen
  says about keeping a record`. All five green.

## 8. Where nothing is told, and how long it lasts

Eight scenarios across the two remaining MODIFIED requirements, in
`Tests/DayByDayKitTests/DayScreenTests.swift`. The four in § 8.1–8.4 should each be green off the
guards § 5 already drove out — a red one is a real finding about the order those guards run in, and
in particular 8.1 is red if the text is read before the store is checked.

- [x] 8.1 `a commit on a day screen that is not keeping a record is told nothing on the row` —
  including a value the commitment would refuse and one that is not a number.
- [x] 8.2 `a commit on a row for a day that has not arrived is told nothing on the row`
- [x] 8.3 `a commit on a row that offers no number entry is told nothing on the row`
- [x] 8.4 `a commit on a row a day screen's day view does not hold is told nothing and does not end
  what is already told`
- [x] 8.5 `what a day screen tells on a row ends when a number is entered and kept`
- [x] 8.6 `what a day screen tells on a row ends when a number is taken back and kept`
- [x] 8.7 `what a day screen tells about a refused value ends when the app is shown again`
- [x] 8.8 `what a day screen tells about a refused value ends when the day screen is moved to the day
  before`
- [x] 8.9 Confirm the fifteen restated scenarios of those two requirements are still green with no
  `@Test` display name changed and no assertion changed beyond § 1.3's mechanical move. A refused
  *value* must not end a notice and a refused *value* must not be ended by one: if any of the ten
  lifetime scenarios goes red, the clearing of `notice` moved somewhere it should not have.

## 9. The shell

No requirement and no test — `CONTEXT.md` § *App shell*, and `docs/open-questions.md` § *No UI smoke
layer*. Do this after § 8 so that everything it draws already answers.

- [x] 9.1 In `src/DayByDay/DayByDay/ContentView.swift`, draw the number row: a standard disclosure
  chevron where `row.numberEntry(asOf:)` is non-`nil`, a tap opening an `.alert` holding one
  `TextField` prefilled from `entry.number` and place-held with `entry.hint`, with **Save** and
  **Cancel**. Save calls `try? screen.enter(text, on: row)` and closes; **Cancel closes and calls
  nothing at all** — that is what keeps it from becoming a fourth end for the notice. A tick row's
  tap is unchanged.
- [x] 9.2 In the same file, draw the cause: the notice's line becomes
  `Text(screen.notice?.cause ?? "Not saved. Try again.")`. The constant stays in the shell and is
  not moved into the package — `design.md` § *The notice carries a cause* says why.
- [x] 9.3 Add one number commitment to `dayOneCommitments` so the field is reachable on a fresh
  install: a weight with a range. **Day one is a seed, not the roster** — the comment in that file
  says so — so this changes nothing on an install that has already run, and § 10.2 deletes the app
  first for that reason.

## 10. The documents

`docs/adr/1036-a-notice-names-a-cause-a-person-can-act-on.md`, its row in `docs/adr/README.md`, and
`CONTEXT.md`'s one new term and two amendments are **written with this folder** and are in the G4
diff, so these boxes confirm rather than write.

- [x] 10.1 Confirm before the review that 1036 is still the lowest free ADR number:
  `for r in $(git for-each-ref --format='%(refname)' refs/heads refs/remotes); do git ls-tree --name-only $r docs/adr/; done | sort -u`.
  1035 was the highest on any local or remote ref on 2026-09-07, taken by
  `story/145-add-roster-removal`. **Report rather than renumber** if another branch has taken 1036
  (`AGENTS.md` rule 5).
- [x] 10.2 Confirm 1036 still says what the code does, now that the code exists: that exactly two
  causes are named, that both sentences are composed inside `DayByDayKit`, and that `Notice.cause` is
  `nil` for every refusal by the place. An ADR that has drifted from the implementation is edited in
  place and stamped (`docs/adr/README.md`); a decision that has actually changed is a stop, not an
  edit.
- [x] 10.3 Confirm `docs/adr/1021-a-day-screen-without-its-record-draws-the-day.md` is still
  untouched and still true. It decides what a screen does with a record it cannot open; if writing
  the code made a sentence of it false, that is a stop and a report, not a quiet amendment.
- [x] 10.4 Confirm `CONTEXT.md` gained exactly one new term — **Number entry** — and two amendments,
  § *Row* and § *Day screen*, and that all three say what the delta says. The grill drafted them in
  `grill.md` § *Terms landed in CONTEXT.md* and its commit `f1f10cb` did not write them; if a term
  appears here that is in neither that section nor this change's `design.md`, something was decided
  that should have been asked.

## 11. Closing the Story

- [x] 11.1 Record in this file, under a `## Notes` heading appended at the end, which of the boxes
  predicted red in §§ 2, 6 and 8 actually ran red before the code that satisfies them was written. A
  prediction in a task is not evidence; this is.
- [ ] 11.2 Re-run after § 12, which is why this box is open again: `pnpm run verify` green from the
  repo root, and `pnpm run checks` reporting `scenario coverage — 75/75`. `cd src/DayByDayKit &&
  swift test` reports **592 tests passing** — 544 on the base this branch now sits on (§ 1.1), plus
  the forty-six written in §§ 2–8 and the two written in § 12, plus none removed. **Read the number
  the run prints and tick this against that, never against this arithmetic**: the first time this
  box was ticked it asserted 535, which had been right against the old base and was wrong by 55 the
  moment the branch was rebased, and nothing caught it until the review. A count that is neither
  measured nor explained by § 1.1 is a stop and a report.
- [ ] 11.3 Open the app on the phone with `pnpm run phone`, **after deleting the installed app** so
  that § 9.3's day one is taken on. Enter a weight from its row, read it back after force-quitting
  and reopening, type a number outside the range and read the sentence on the row, then open the
  entry and press Cancel and confirm nothing changed and nothing new is told. Nothing automated sees
  any of this.
- [ ] 11.4 Add two lines to `docs/open-questions.md` as a **chore commit that lands before this
  branch's archive**, not on this branch — `AGENTS.md` § *Agent roles* puts that file outside a
  Story's reach, and landing it first is what lets this box be ticked on evidence rather than in
  anticipation (the ordering `add-number-record` (#138) § 9.5 settled with the owner). The two: the
  known gap *a commitment of a kind nothing can yet record is a row that does nothing when tapped*
  closes for the number kind and stays open for the note and the total; and the public-surface gap
  gains an eleventh face — a row gives its number out through the entry it offers while still giving
  no tick out, so the same row answers one question with a value and the other with a yes or no. The
  review adds a third: § *No UI smoke layer* describes the shell as picking the notice with
  `row == screen.refusedChangeRow`, and § 1.2 renamed that property, so the line now reads
  `row == screen.notice?.row` (`ContentView.swift:168`) and the document says otherwise.
- [ ] 11.5 Run `/opsx:archive` as the last commit on the branch, then push it. **The janitor's own
  instruction, not a box that waits on the archive:** after the archive has run, read
  `openspec/specs/day-screen/spec.md` and confirm that the four MODIFIED requirements are still in
  the positions they held before it — *A row is a commitment's line on a date* third, and the three
  notice requirements last, in the order they are in today. Nothing here is `RENAMED`, so nothing
  should have moved. Any drift is a stop and a report, never a hand-edit: `openspec/specs/` is
  written by `/opsx:archive` and by nothing else (`AGENTS.md` rule 2).

## 12. What the review found

The G7 review of PR #158 raised eight findings and the owner accepted seven for fix before the
archive. **Three were the change folder's and are already done in this diff**: the delta's silence
about a number that cannot be kept exactly (§ *A day screen reads what an entry is committed with*
gained a clause and two scenarios, § 12.1–12.2 below), § 11.2's wrong test count and § 1.1's stale
base, and the § *Notes* record of the guard order, which was written backwards. The eighth is
`docs/open-questions.md`, which no Story may edit, and it is § 11.4's third line.

What is left is code, and it runs **before** § 11.2, § 11.3 and § 11.5, all of which are open for it.
§§ 12.1 and 12.2 are two more red-green cycles under `AGENTS.md` rule 3 — one scenario, one
acceptance test named after it verbatim, smallest change that passes. §§ 12.3–12.6 add no scenario
and change no behaviour.

- [x] 12.1 `a number of as many digits as can be kept is entered exactly` — in
  `Tests/DayByDayKitTests/DayScreenTests.swift`. Expect it **green on arrival**: 38 nines already
  parse exactly and already survive the store, measured on this machine on 2026-09-07. Record in
  § *Notes* whether it actually ran red, as §§ 2, 6 and 8 did.
- [x] 12.2 `a number too long to be kept exactly keeps nothing and takes nothing back` — same file.
  Expect it red, and expect the red to be **the test process aborting rather than a failure being
  reported**: `read(_:)` at `DayScreen.swift:265` force-unwraps `Decimal(string:)`, which is `nil`
  for two of this scenario's three values, and a `fatalError` takes the whole run down. That is the
  finding. Make it pass by giving the reading the size rule in `design.md` § *A number this system
  cannot keep exactly is not a number here* — at most 38 significant digits, and a power of ten
  between −128 and 127, checked on the text before `Decimal(string:)` is called — and by **removing
  the `!`**: a `nil` from that call is read as a value that is not a number, never trusted. The
  notice this scenario asserts is `"Not a number"`, the existing sentence and not a third cause;
  `docs/adr/1036` says why, and it is not amended by this box.
- [x] 12.3 Add the third assertion to the existing test named `a number that cannot be kept is
  refused and leaves the day view as it was` (`DayScreenTests.swift`). The scenario has three THEN
  bullets and the test asserts two; the missing one is **"a day screen opened afterwards at the same
  place says the same"**, which every sibling scenario in that requirement opens a second screen
  for. Nothing else in the test changes and its `@Test` display name does not change.
- [x] 12.4 Correct the doc comment on `DayScreen.notice` (`DayScreen.swift:188-190`). It says the
  notice is "Set when `tick(_:)` throws", which was true before § 7: `enter(_:on:)` now also sets it
  where the commitment refuses the number and where the value is not a number, and neither throws.
  Say what the public surface actually does — set when a change is refused, whether by the place,
  which throws, or by the value, which does not — and leave the three ends as they are.
- [x] 12.5 Call `dayViewOfShownDay()` from `enter(_:on:)` (`DayScreen.swift:326-327`) instead of the
  copy of `tick(_:)`'s day-view block. Past the `recordStore` guard the two are equivalent, since
  `recordStore?.history ?? History()` reduces to `recordStore.history` there. `tick(_:)`'s own copy
  at `:219-220` goes the same way. Every test stays green; a red one means the two were not
  equivalent and is a rule-5 stop.
- [ ] 12.6 Strengthen the two `DayViewTests.swift` assertions that pass for the wrong reason:
  `a number entry of a commitment that declares no range says no hint` and `a number entry says no
  number where the day holds none`. Both read `...numberEntry(asOf: monday)?.hint == nil` and
  `?.number == nil`, which hold just as well when `numberEntry(asOf:)` returns `nil` and the entry
  was never offered. Require the entry first, then assert on it — the same weakening § 1.3 refused
  by name for the rename. Neither `@Test` display name changes.

## Notes

Which boxes predicted red in §§ 2, 6 and 8 actually ran red, checked at the moment each test was
first run against the code that existed before it:

- **2.1 ran red**, as predicted — `value of type 'DayView.Row' has no member 'numberEntry'` — before
  `numberEntry(asOf:)` existed at all.
- **2.2 and 2.4 did not run red.** Both guards `numberEntry(asOf:)` needed — the kind check and the
  day-not-arrived check — were written together in 2.1's cycle, since both were one small function
  and design.md fixed their shape already. 2.2 and 2.4 were green the moment they were written.
- **6.2 ran red**, as predicted, and for the predicted reason: `Decimal(string: "70,5")` read as
  `70`, so `screen.dayView.rows[0].numberEntry(asOf: monday)?.number → 70) == 70.5` failed before the
  shape-checked reading replaced the naive one.
- **6.3 and 6.6 did not run red.** Both were written after 6.2's fix landed, so the shape-checked
  reading already handled leading zeros, a trailing separator, surrounding space and all seven
  not-a-number values by the time either test existed.
- **8.1 through 8.4 did not run red**, confirming the guards written in § 5 already run in an order
  that satisfies all four, with no reordering needed. **The order itself was recorded backwards here
  and is corrected at G7**, read off `DayScreen.swift` rather than remembered: `enter(_:on:)` guards
  row membership first, then the record store, then the entry the row offers, and only then reads
  the text — the same three in the same order as `tick(_:)`, which is what § 5 asked for. No
  scenario tells the store-first order from the membership-first one, so nothing about the behaviour
  turns on it; what turned on it was 11.1's own claim to be evidence rather than a prediction.
- **12.1 did not run red**, as predicted: 38 nines already parsed exactly and already survived the
  store before the size rule existed, since `Decimal(string:)` itself keeps 38 digits exactly.
- **12.2 ran red**, and for the predicted reason: the test process aborted rather than reporting a
  failure — `Fatal error: Unexpectedly found nil while unwrapping an Optional value` at
  `DayScreen.swift:265`, the `Decimal(string: normalized)!` on text the size rule had not yet
  ruled out. The size check plus removing the `!` made it pass.
