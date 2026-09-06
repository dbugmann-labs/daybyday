## 1. The fourth part, before anything else moves

This section changes no behaviour and adds no test. It exists because `Commitment` gains a stored
part that every one of its roughly two hundred construction sites has to keep meaning the same thing
through, and because the two failable types this change introduces should be red on their first
assertion rather than accidentally green.

- [x] 1.1 Add `Sources/DayByDayKit/CommitmentKind.swift` declaring, in an `extension Commitment`,
  exactly what `design.md` § *The kind is an enum with associated values* gives:
  `public enum Kind: Hashable, Sendable` with `case tick`, `case number(range: Range?)`, `case note`
  and `case total(target: Target)`; `public struct Range: Hashable, Sendable` with
  `public let lowest: Decimal`, `public let highest: Decimal` and
  `public init?(lowest: Decimal, highest: Decimal)`; and `public struct Target: Hashable, Sendable`
  with `public let amount: Decimal` and `public init?(_ amount: Decimal)`. **Both initializers are
  bodied `fatalError("not implemented")`.** The file opens with `import Foundation`, which is where
  `Decimal` comes from. Nothing else is public. `cd src/DayByDayKit && swift build` exits 0.
- [x] 1.2 In `Sources/DayByDayKit/Commitment.swift`, add `public let kind: Kind` as the fourth stored
  part and give the initializer a fourth parameter, `kind: Kind = .tick`, assigned like the other
  three. The blank-name guard is the only guard and does not move. **No caller anywhere is edited**:
  the default is what keeps the nine day-one constructions in `ContentView.swift`,
  `CommitmentsScreen.define`, `CommitmentRecord.commitment()` and every existing test valid.
  `Hashable` stays synthesized, so identity picks the kind up for free. Verify with
  `cd src/DayByDayKit && swift test` reporting **391 tests passing**; a red test here is a rule-5
  stop, because nothing in this box was supposed to change an answer.
- [x] 1.3 Confirm the starting point before writing a test: from the repo root, `pnpm run checks`
  reports `scenario coverage — 64/92 scenario(s) covered` for this change and names
  `"a commitment reads back the kind it was given"` as next. A different number means something else
  moved; report it rather than working around it.

## 2. `commitment` — the kind, the range and the target

Fourteen scenarios from `specs/commitment/spec.md`, all in
`Tests/DayByDayKitTests/CommitmentTests.swift`. Each task takes exactly one `#### Scenario:` and
writes one acceptance test whose `@Test("...")` display name is that scenario title **verbatim**,
then makes it pass with the smallest change that does. Never write two before the first is green
(`AGENTS.md` rule 3). Verify each with `cd src/DayByDayKit && swift test`: the named test green,
every earlier test still green.

`design.md` expects 2.5 (the first call into `Range.init?`'s `fatalError`), 2.6 (the comparison
itself), 2.8 (**the one that fails a `guard lowest <= highest`**, because `Decimal.nan <= Decimal(5)`
is `true`), 2.9 (the first call into `Target.init?`'s `fatalError`) and 2.11 (the `> 0` guard) to run
red on their own. **Record which ones actually ran red as you go, in § 9**; a prediction here is not
evidence.

- [x] 2.1 `a commitment reads back the kind it was given`
- [x] 2.2 `a commitment of each of the four kinds is formed and reads its kind back`
- [x] 2.3 `a commitment formed without a kind is of the plain kind` — assert both halves: the kind
  reads back as `.tick`, and the commitment is `==` one formed with `.tick` named.
- [x] 2.4 `a commitment's kind does not change whether it is due` — the guard against a kind that
  leaks into `isDue(on:)`.
- [x] 2.5 `a number commitment declares a range and reads it back`
- [x] 2.6 `a range whose lowest is above its highest is not a range`
- [x] 2.7 `a range whose lowest and highest are equal is a range` — and the negative pair in the
  `AND`, which is what stops someone reading "lowest" as "at least zero".
- [x] 2.8 `a range end that is not a number is not a range` — both orders, as the scenario says.
  `Decimal.nan` is the value; an implementation guarding only on `lowest <= highest` passes 2.6 and
  2.7 and fails exactly here.
- [x] 2.9 `a total commitment declares a target and reads it back`
- [x] 2.10 `a target with a decimal fraction is a target`
- [x] 2.11 `a target of zero and a target below zero are not targets`
- [x] 2.12 `a target that is not a number is not a target`
- [x] 2.13 `two commitments differing only in the kind their days take are different commitments`
- [x] 2.14 `two number commitments differing only in their range are different commitments` — the
  test that proves a kind's *parameters* are part of identity and not just the case.

## 3. `commitment` — the roster judges four parts

- [x] 3.1 `two commitments alike in every way but the kind their days take are both held` — one test
  at the end of `Tests/DayByDayKitTests/RosterTests.swift`. Expect it **green on first write**:
  `Roster` compares whole commitments, so the fourth part reaches it through `Hashable` without a
  line changing. That is the point of the test rather than a reason to skip it — it is what stops a
  later change replacing that comparison with a three-part one. A red test here is a real finding:
  report it before touching `Roster`.

## 4. `record` — a tick is of a commitment whose kind is a tick

Two scenarios from `specs/record/spec.md`, both in `Tests/DayByDayKitTests/RecordTests.swift`.

- [x] 4.1 `a commitment whose kind is not a tick takes no tick on a date it is due on` — add the
  guard to `Tick.init?` in `Sources/DayByDayKit/Tick.swift`, beside the `isDue(on:)` one. All four
  kinds are in this one scenario, plus the tick-kind control that must still form.
- [x] 4.2 `a commitment whose kind is not a tick was not kept on a date it is due on` — expect it
  green on first write once 4.1 is in: a history holds ticks, and there is now no tick of such a
  commitment to hold. Same standing as 3.1 — a red test is a finding, not a licence to edit
  `History`.

## 5. `day-screen` — the row that offers nothing

- [x] 5.1 `a row for a commitment whose kind is not a tick offers nothing` — one test at the end of
  `Tests/DayByDayKitTests/DayViewTests.swift`, from `specs/day-screen/spec.md`. **No line of
  `Sources/DayByDayKit/DayView.swift` changes:** `Row.tick(asOf:)` already returns whatever
  `Tick.init?` gives it, so § 4.1's guard reaches the row for free, and this test is what pins that
  the row still *exists* — a day view that dropped the row would fail the first assertion before it
  ever reached the tick. Expect green on first write once 4.1 is in.

## 6. The form on disk

This section moves both documents to the next form, teaches both stores to read the form before it,
and is the only section that edits an existing test. Do 6.1 through 6.3 as one mechanical step and
verify against the baseline before writing a single new test.

- [x] 6.1 In `Sources/DayByDayKit/CommitmentCoding.swift`, add `KindRecord` and give
  `CommitmentRecord` a fourth field, `var kind: KindRecord?`. The wire shape is fixed by `design.md`
  § *The form on disk*: one key per case, the key's value being that case's payload —
  `{"tick": {}}`, `{"number": {}}`, `{"number": {"lowest": …, "highest": …}}`, `{"note": {}}`,
  `{"total": {"target": …}}`. The conversion from `Commitment.Kind` is an **exhaustive `switch`**, so
  a fifth kind is a compile error here, exactly as `ScheduleRecord`'s is. `kind` decoded as `nil`
  means the tick kind, and `CommitmentRecord(_:)` always writes one. `KindRecord` needs no
  `Comparable`: `design.md` says why the record document's existing tiebreaker is still total.
- [x] 6.2 Move `RosterDocument.currentVersion` and `RecordDocument.currentVersion` from `1` to `2`,
  and in both `RosterStore.init(at:)` and `RecordStore.init(at:)` widen the one guard from
  `envelope.version == currentVersion` to the range `1...currentVersion`, leaving `>` throwing
  `.laterForm` and everything else `.notAStore`. Nothing else in either initializer moves, and
  neither store gains a write on open.
- [x] 6.3 Edit the eleven sites that say `2` to mean *a later form*, so they say `3`. Nine JSON
  fixtures — `RecordStoreTests.swift:267`, `RosterStoreTests.swift:323`,
  `CommitmentsScreenTests.swift:1024`, and `DayScreenTests.swift:370`, `:454`, `:585`, `:1673`,
  `:1831`, `:2471` — and two assertions, `RecordStoreTests.swift:270` and
  `RosterStoreTests.swift:326`, whose `laterForm(at:version: 2)` becomes `version: 3`. **No `@Test`
  display name, no other assertion, no date and no commitment may change**, and no test may be added
  or deleted by this box. Leave `DayScreenTests.swift:1595` exactly as it is: its
  `{"version": 1, "commitments": []}` is a valid earlier-form roster and reads as one. Verify with
  `swift test` reporting **391 tests passing**; a red test here is a rule-5 stop.
- [ ] 6.4 `a commitment of each kind is read back as the same commitment` — the first new test in
  `Tests/DayByDayKitTests/RosterStoreTests.swift`, and the one that proves 6.1's coding round-trips.
- [ ] 6.5 `a range and a target are read back exactly, decimal fractions and all` — the test that
  fails a coding that puts either number through a `Double` on the way to JSON.
- [ ] 6.6 `a roster kept before a commitment carried a kind is read with every commitment of the
  plain kind` — the fixture is written by hand as form-1 JSON, not by the current encoder; that is
  the whole point, so do not build it from a `RosterDocument`.
- [ ] 6.7 `reading a roster kept in an earlier form changes nothing at its place` — read the bytes
  back with `Data(contentsOf:)` and compare, as the other byte-for-byte tests in this file do.
- [ ] 6.8 `a commitment of another kind taken on over a roster kept in an earlier form is read back
  with its kind` — the lazy-upgrade test: an implementation that goes on writing the earlier form
  loses the kind here and passes everything before it.
- [ ] 6.9 `a roster store written in a form this app has never written is refused` — version 0.
  Assert the error is `.notAStore` and not `.laterForm`, and that the bytes are untouched.
- [ ] 6.10 `a history kept before a commitment carried a kind is read with every commitment of the
  plain kind` — the first new test in `Tests/DayByDayKitTests/RecordStoreTests.swift`, hand-written
  form-1 JSON as in 6.6.
- [ ] 6.11 `reading a history kept in an earlier form changes nothing at its place`
- [ ] 6.12 `a tick added over a history kept in an earlier form is read back beside the ticks already
  there`
- [ ] 6.13 `a store written in a form this app has never written is refused` — **this one is a
  rename, not a new test.** `RecordStoreTests.swift` already carries
  `@Test("a store written in an earlier form than version 1 is refused")`, which no scenario in
  `openspec/specs/record/spec.md` claims and whose name says something this change makes false.
  Change its display name and its function name to match the scenario, and **change nothing else in
  its body**: the fixture stays `{"version": 0, "ticks": []}`, the expectation stays
  `.notAStore(at: place)`, the byte comparison stays. `git diff` on that test shows two lines.
- [ ] 6.14 `cd src/DayByDayKit && swift test` reports **418 tests passing**, and from the repo root
  `pnpm run checks` reports `scenario coverage — 92/92`.

## 7. The shell, and the file that is already on a phone

- [ ] 7.1 `src/DayByDay/DayByDay/ContentView.swift` is **not edited**. Confirm it: `git diff --stat`
  names no file under `src/DayByDay/`, and the nine day-one commitments are still the nine ticks
  `docs/backlog.md` § *What day one looks like* quotes. Adding a kind to any of them here is #142's
  and would be a behaviour change with no requirement behind it.
- [ ] 7.2 Build and run the shell in the simulator, the way ADR-1019 and
  `archive/2026-09-04-add-roster-store/tasks.md` § 4 do, against a **roster and record already
  written by the previous build** — copy the two files out of the simulator's Application Support
  directory before installing the new build, or write them by hand in form 1. Confirm three things
  and record what was observed, with the simulator name, the iOS version and the exact commands: the
  day screen draws the nine commitments as it did; ticking one keeps it; and after that tick the
  **record** file has moved to the new form while the **roster** file is still byte-for-byte the
  form-1 file it was, because nothing was taken on. That last one is the whole of § *Migration Plan*
  and no unit test can reach it.

## 8. The documents

`docs/adr/1030-the-kind-is-a-commitments-fourth-part.md`,
`docs/adr/1031-a-store-reads-the-form-before-it.md`,
`docs/adr/1032-a-recorded-number-is-a-decimal.md`, their three rows in `docs/adr/README.md` and the
2026-09-06 amendment on `CONTEXT.md` § *Store* are **written with this folder** and are in the G4
diff, so 8.1 and 8.2 confirm rather than write.

- [ ] 8.1 Confirm before the review that 1030, 1031 and 1032 are still the three lowest free ADR
  numbers — `git log --all --name-only -- docs/adr` — and **report rather than renumber** if another
  branch has taken one (rule 5). 1029 was the highest on any local or remote ref on 2026-09-06.
- [ ] 8.2 Confirm each of the three ADRs still says what the code does, now that the code exists.
  1032 in particular carries two measurements taken before a line was written — the ten additions of
  0.1 and the asymmetric not-a-number comparison — and § 2.8 is the test that re-takes the second
  one. An ADR that has drifted from the implementation is edited in place and stamped, per
  `docs/adr/README.md`; a decision that has actually changed is a stop, not an edit.
- [ ] 8.3 Confirm `CONTEXT.md` gained the one amendment and **no new term**: the Feature grill landed
  all six of this Story's terms on `main` before the Story existed, and writing the delta turned up
  none. A seventh term appearing here means something was decided that should have been asked.
- [ ] 8.4 Two entries are owed in `docs/open-questions.md`, which is not this change's file to write
  (`AGENTS.md` § *Agent roles*). Write them as a **chore commit alongside the merge**, not here.
  First, under *Known gaps*: a commitment of a kind nothing can yet record draws a row that does
  nothing when tapped — unreachable today, made reachable by #142 and removed by #139, and the two
  are in different lanes so the order they land in decides whether anyone sees it. Second, on the
  read-back gap's list: `Commitment.kind` is public while `schedule` and `keptFrom` stay internal, so
  a commitment now has a fourth part that is readable and two that are not.

## 9. The evidence, before the review

- [ ] 9.1 Record, in this box, which of the tests § 2 predicted would run red actually did — 2.5,
  2.6, 2.8, 2.9 and 2.11 — and any test that ran red where none was expected. A prediction in a
  task file is not evidence; what happened is. A test that was expected red and came up green on
  first write is worth one line saying why, because it usually means the assertion is weaker than
  the scenario.
- [ ] 9.2 `pnpm run verify` green from the repo root, `cd src/DayByDayKit && swift test` reporting
  **418 tests passing**, `pnpm run checks` reporting `scenario coverage — 92/92`, and
  `openspec validate add-commitment-kind --strict` exiting 0 with the change folder as it finally
  stands.

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it. **Two things the
janitor must do rather than tick.** One: `openspec archive` in this repo moves *A commitment is a
name, a schedule, and the day it is kept from* and *A tick is of a commitment on a calendar date it
is due on* nowhere — both keep their positions, because neither is renamed. Confirm that after the
archive by reading the first `### Requirement:` line of `openspec/specs/commitment/spec.md` and of
`openspec/specs/record/spec.md`; if either has moved, that is drift, and drift is a stop and a
report, never a hand-edit — `openspec/specs/` is written by `/opsx:archive` and by nothing else
(rule 2). Two: `openspec validate --all --strict --no-interactive` must exit 0 on the result, which
it did when this change was archived into a throwaway copy of `openspec/` on 2026-09-06.
