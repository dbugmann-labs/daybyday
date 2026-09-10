## 1. Before a line is written

- [ ] 1.1 Confirm the starting point, and report rather than work around a different one (rule 5).
  From `src/DayByDayKit`, `swift test` reports **1036 tests passing** — measured 2026-09-10 on this
  branch, whose one commit ahead of `origin/main` is the grill commit `5252fde`, sitting on `a04e151`.
  From the repo root, `pnpm run check:scenarios` reports **`56/78 scenario(s) covered`** and names *a
  commitments screen refuses a range whose lowest is above its highest* as next. Re-measure both
  rather than trusting these sentences; a different number is a stop.

  **That 56 is not progress.** Fifty-six of this delta's seventy-eight scenarios are restated word for
  word by `MODIFIED` and already have passing, name-matched tests, so the check counts them before
  anything has been written. Only the **22** genuinely new ones show as missing, and §§ 3–6 name all
  22 by hand.

- [ ] 1.2 Confirm the four facts the shape rests on, before writing any test, and stop and report if
  any is false (`design.md` § *Context*): `CommitmentsScreen.define(name:on:keptFrom:under:)` is
  declared at `CommitmentsScreen.swift:190` and forms its `Commitment` at `:203` without naming a
  kind; `Commitment.Range.init?` refuses a NaN end and a lowest above its highest, and
  `Commitment.Target.init?` refuses anything not above zero, both in `CommitmentKind.swift`;
  `DayScreen.read(_:)` is `private static` at `DayScreen.swift:263`, with `writtenOut(_:)` at `:320`
  and `CommittedText` at `:250`, called from exactly two places, `:349` and `:398`; and
  `Blank.saysNothing(_:)` is the whole of this package's blank test. If `read(_:)` has grown a third
  caller or moved, stop: § 2 is written on it being a two-caller private.

- [ ] 1.3 Re-read this box before § 3 and again before § 9. `commitment` is the busiest capability in
  the repo and this delta restates 56 of its scenarios. If another Story delta-ing it merges to `main`
  while this branch is open, a clean rebase can still leave this delta describing a spec that has
  moved. Check with `git fetch origin && git log --oneline origin/main --
  openspec/specs/commitment/spec.md`. A change there is a **stop** (rule 5), not a delta to refresh
  quietly: refreshing it needs a further G4.

## 2. One reading of a typed number, before any scenario needs it

**A pure extraction with no behaviour change and no scenario of its own**, done first and in its own
commit so that the diff of every later box is about this Story. Rule 3 is not bent here: no scenario
is being satisfied, and the existing suite is the whole of the check.

- [ ] 2.1 Move `DayScreen.read(_:)`, `DayScreen.writtenOut(_:)` and the `CommittedText` enum into a
  new package-internal `TypedNumber` in `src/DayByDayKit/Sources/DayByDayKit/TypedNumber.swift`,
  beside `Blank.swift` and `Digits.swift`. Change nothing else about them — same logic, same
  `Digits` calls, same three answers, the doc comments carried over with their references to #139's
  `design.md` intact. `DayScreen` calls `TypedNumber.read(_:)` at its two existing sites.

- [ ] 2.2 `swift test` from `src/DayByDayKit` reports **1036 passing**, the same number as 1.1, with
  no test renamed, added or deleted. **A red test here is a stop and a report** (rule 5): this box
  moves code and is not entitled to change an answer a `day-screen` scenario asserts.

## 3. The form takes a kind — seven red-green cycles

One test per box, in `src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenTests.swift`, taking
the scenario title verbatim as the `@Test` display name (rule 3). Every one of these belongs to *A
commitments screen defines a commitment from a name, a rhythm and the day it is kept from*; put them
beside that requirement's existing tests. The seam these drive is `design.md` § *The seam* — read it
before 3.1, because 3.1 and 3.2 between them fix the shape the other twenty tests are written
against, and changing it later is twenty edits.

- [ ] 3.1 `a commitments screen offers the tick kind for a new commitment` — adds
  `CommitmentsScreen.KindChoice` and `kindToOffer`.
- [ ] 3.2 `a commitment of each of the four kinds is defined through a commitments screen and kept with that kind`
  — the big one. `define` gains `kind:`, `lowest:`, `highest:` and `target:`, all defaulted, and
  reads the three texts through `TypedNumber`. **Check while this is red that the 63 existing
  `define` call sites still compile untouched**; if any needs editing, the defaults are wrong and
  that is worth finding now rather than in § 9.
- [ ] 3.3 `a commitment of the number kind defined with both range fields blank carries no range` —
  `Blank.saysNothing` is asked before the reading, `design.md` § *Blank is asked before the reading*.
- [ ] 3.4 `a range end and a target are read as a number entry reads a number` — a comma separator,
  surrounding blank space and a trailing zero, on both a range end and a target. If this goes red in
  a way that implicates `TypedNumber` rather than the call, § 2 was not the pure move it claimed to
  be: stop and report.
- [ ] 3.5 `a range typed on a kind with no room for one is ignored rather than refused`.
- [ ] 3.6 `a target typed on a kind with no room for one is ignored rather than refused`.
- [ ] 3.7 `a commitment alike in every way but the kind it takes is not one a commitments screen already keeps`
  — expect this to go green with no change to `define` beyond 3.2's, because the roster already
  compares whole values. A red here is a finding about the roster, not about this screen: report what
  it says before changing anything.

## 4. The two new refusals — eleven red-green cycles

One test per box, same file, same rule. All eleven belong to the **ADDED** requirement *A
commitments screen refuses a range that is not a range, and a target that is not a target*, so put
them together and after § 3's. `Refusal` gains exactly two cases and `RefusedChange` gains none —
`design.md` § *Two refusals, not six* and § *The kinds of refused change stay at seven*.

- [ ] 4.1 `a commitments screen refuses a range whose lowest is above its highest`.
- [ ] 4.2 `a commitments screen refuses a range end that is not a number`.
- [ ] 4.3 `a commitments screen refuses a range with one end typed and the other blank`.
- [ ] 4.4 `a commitments screen refuses a target that is not a number`.
- [ ] 4.5 `a commitments screen refuses a target that is not above zero`.
- [ ] 4.6 `a commitments screen refuses a total with nothing in its target field`.
- [ ] 4.7 `a range end and a target of more than thirty-eight significant digits are not numbers` —
  a 1 followed by thirty-nine 9s is refused and a 1 followed by thirty-seven 9s is not. Build both
  literals in the test rather than typing them out, and count them there.
- [ ] 4.8 `a commitments screen accepts a range of one value, and one whose ends are negative and zero`.
- [ ] 4.9 `a commitments screen accepts a target with a decimal fraction, below one`.
- [ ] 4.10 `a range a commitments screen refuses is told apart from a target and from its other refusals`
  — four asks, four distinct refusals.
- [ ] 4.11 `a commitments screen holds a refused range against defining a commitment` — both new
  refusals are held as `.defining(…)`, which already exists.

## 5. What the change sheet is told — two red-green cycles

Both belong to *A commitments screen says what a commitment it is asked to change is made of*.
`Change` gains `kind: Commitment.Kind`; `change(_:toName:on:keptFrom:under:)` **does not move**.

- [ ] 5.1 `a commitments screen says the kind a commitment it keeps takes, with what that kind carries`.
- [ ] 5.2 `a commitments screen says a number commitment carrying no range takes the number kind and no range`
  — on a **stopped** commitment, which also re-asserts that its rhythm and day kept from cannot be
  changed.

## 6. The debt from #137's second review — two red-green cycles

`docs/open-questions.md` owes these two to whichever Story next touches `commitment`'s roster or
store requirements. **Expect both to go green with no change to `src/`**: the behaviour is
implemented and tested, and what is missing is a scenario that says so. A red that does not appear is
the honest outcome — **do not invent a production change to manufacture one**, and do not skip
writing the test because it would pass. If either goes red, report what it says before changing
anything.

- [ ] 6.1 `two number commitments alike in every way but the range their kind carries are both held`
  — in `RosterTests.swift`, beside `two commitments alike in every way but the kind their days take
  are both held`, which is the test this one exists to cover the gap in. Do **not** edit that test.
- [ ] 6.2 `a roster store holding a commitment with half a range is refused` — in
  `RosterStoreTests.swift`. The malformed place it needs is already built inside `a roster store
  holding what could not be a roster is refused`, as that test's fourth place; **leave that test
  exactly as it is** and write the new one standing on its own, with both halves of the half-range
  (a lowest with no highest, and a highest with no lowest).

## 7. The shell — no requirement, walked on the phone

`src/DayByDay/DayByDay/CommitmentsView.swift` only. None of this is a requirement and none of it is
tested: what a form draws is the drawing's (ADR-1022), exactly as the rhythm fields already are.

- [ ] 7.1 The sheet gains a **Kind** picker over the four, starting on `screen.kindToOffer` when it
  is defining. Under Number it shows two range fields, under Total a target field, and under Tick and
  Note neither. The three fields are plain `TextField`s bound to `String`: no formatter, no
  `keyboardType` that forbids a minus or a separator, and nothing that blocks a character — the whole
  point of `design.md` § *One reading of a typed number* is that the screen says "that is not a
  number" out loud rather than the shell refusing the keystroke.
- [ ] 7.2 When the sheet is **changing** a commitment, the picker and the three fields are filled from
  `whatItIsMadeOf(_:)`'s new `kind` and `.disabled(true)`, beside the rhythm's existing treatment for
  a stopped commitment. The save path does not send them: `change(_:toName:on:keptFrom:under:)` takes
  four things and is not touched.
- [ ] 7.3 Two more lines in `refusalText(_:)`, one per new `Refusal` case, in this file's existing
  voice.
- [ ] 7.4 `xcodebuild build` for the `DayByDay` scheme against an iPhone 17 simulator succeeds —
  `swift test` compiles none of the app target, so nothing before this box has proved this one.
- [ ] 7.5 Walk it on the phone with `pnpm run phone`: define one commitment of each of the four kinds,
  a number with a range and a number without, and read both refusals by typing a lowest above a
  highest and an empty target. Then open the change sheet on the total and confirm the kind and the
  target are shown and will not take a thumb. **Do not run a UI test to do this** — a cold simulator
  boot outlives the 600-second stream watchdog and the run is killed mid-way.

## 8. The documentation, three boxes of which already landed

**8.1 to 8.3 were written into the propose commit and are part of what G4 signed.** They are not work
to do; they are a re-read after § 7, because § 7 is where a phone walk can make a written sentence
false. Tick each when you have confirmed it still says the truth, and **report a difference rather
than editing quietly** — a change to any of them after G4 is a finding the reviewer should see, not a
tidy-up (rule 5).

- [ ] 8.1 `CONTEXT.md` § *Commitments screen* carries **Amended 2026-09-10**: five things rather than
  four, the "four rather than five" reasoning withdrawn, the kind said with its range or target, a
  range end and a target arriving as text, and the two refusals that are not new kinds of refused
  change. Confirm the seven kinds it still names are seven.
- [ ] 8.2 `CONTEXT.md` § *Kind* carries **Amended 2026-09-10**: a row has read one since #137 and a
  commitments screen now writes one, with nothing about what a kind *is* changed. **No new term was
  landed and none should be** — if §§ 3–7 turned one up, that is a finding to report, not a term to
  add (`grill.md` § *Terms landed in CONTEXT.md*).
- [ ] 8.3 `docs/adr/1046-a-screen-judges-what-was-typed.md` exists, is `accepted`, and its row is the
  last in `docs/adr/README.md`. **If § 7's phone walk changed the shape — the shell formatting a
  number before `define` sees it, or a keyboard type that refuses a minus or a comma — this ADR is
  wrong and that is a stop**, because it is the one decision here that fixes where a rule lives.
- [ ] 8.4 `docs/open-questions.md` — **this one is work.** Move *Two of #137's tests do not match
  their scenarios clause for clause, and check 4 cannot see it* to the closed section, naming § 6's
  two scenarios and this Story, and say plainly whether either went red. It is left to this point
  rather than written at propose time because it claims two tests exist, and at propose time they did
  not. Leave every other entry alone.
- [ ] 8.5 `docs/backlog.md` is **not** touched. The want the grill left — changing a range or a
  target on an existing commitment (`grill.md` § *Settled* 10) — is already captured as **B-043** on
  `chore/backlog`, and that file lives on that branch: editing it from a Story branch invites the
  rebase conflict rule 5 calls a stop. Tick this by confirming `git status` shows `docs/backlog.md`
  unchanged.

## 9. Before the review, and what the janitor does at the archive

- [ ] 9.1 `swift test` from `src/DayByDayKit` — **1058** green: 1036 from § 1.1 plus the 22 tests of
  §§ 3–6, none deleted and none renamed. From the repo root, `pnpm run verify` green and `pnpm run
  checks` reporting `78/78 scenario(s) covered`.
- [ ] 9.2 `openspec validate add-kind-to-commitments-screen --strict` exits 0, and `openspec validate
  --all --strict --no-interactive` exits 0.
- [ ] 9.3 Rebase onto current `main` and push with `--force-with-lease`. A conflict inside
  `openspec/changes/add-kind-to-commitments-screen/` or anywhere under `openspec/specs/` is a
  **stop**, not a merge to resolve (rule 5) — and so is a clean rebase that then fails 9.1 or 9.2,
  which is § 1.3's hazard arriving late. **Re-measure 9.1's number after the rebase**: a test count
  written inside a G4-signed folder goes stale when `main` moves under it.
- [ ] 9.4 Hand back for the review (**G7**). The conductor spawns `reviewer`; do not run
  `mattpocock-skills:code-review` on your own diff, and do not act on findings until they come back
  through the conductor. This box is ticked when the hand-back is written.
- [ ] 9.5 Write the archive handover below into the PR or the hand-back message. **The `implementer`
  ticks this box, in its last commit before the archive**, on the evidence that the handover has been
  written — the checking itself is the janitor's step and has no box of its own, deliberately: a box
  whose tick depends on the archive having run cannot be reached afterwards, because `/opsx:archive`
  moves this folder under `openspec/changes/archive/` and every editor is denied there.

  **Archive handover, for the janitor.** This change carries **one delta file**,
  `specs/commitment/spec.md`, in two sections — one `ADDED` requirement and five `MODIFIED` — and
  touches no other capability. After `/opsx:archive` runs, read
  `openspec/specs/commitment/spec.md` and confirm all five of these:

  1. *A commitments screen refuses a range that is not a range, and a target that is not a target* is
     **present**, with exactly **11** scenarios. It is the only requirement this change adds.
  2. The five modified requirements hold these scenario counts: *A commitments screen defines a
     commitment from a name, a rhythm and the day it is kept from* — **18** (was 11); *A commitments
     screen says what a commitment it is asked to change is made of* — **6** (was 4); *A commitments
     screen changes a commitment on either of its lists* — **21**, unchanged, modified in its prose
     only; *A roster refuses a commitment it already holds* — **17** (was 16); *A roster store that
     cannot be read is refused rather than emptied* — **5** (was 4).
  3. The define requirement's **header still names three things** — "…from a name, a rhythm and the
     day it is kept from" — while its first line says **five**. That is deliberate (`design.md`
     § *Why the delta restates so much*) and is not drift to correct. The sentence "which is why they
     are four rather than five" appears **nowhere** in the file, and neither does "the same four
     things it defines one from"; both are in it today and both go.
  4. **No requirement other than the six named in points 1 and 2 moved, was reworded, or lost or
     gained a scenario.** In particular *A commitments screen holds the change it refused and why,
     one at a time* is untouched and still counts **seven** kinds of change a person can ask for:
     this Story adds two refusal *reasons* and no new kind, so nothing there renumbers. *A roster
     store reads a roster kept before a commitment carried a kind*, *A commitment's kind is a tick, a
     number, a note or a total*, *A range is a lowest and a highest, and the lowest is not above the
     highest* and *A target is a number above zero* are all deliberately left alone.
  5. `openspec validate --archived` exits 0, and nothing landed in `day-screen`, `record`, `schedule`
     or `cli-version` — `day-screen` most particularly, since § 2 moved code out of `DayScreen`
     without touching a single one of its requirements.

  Any drift is **a stop and a report, never a hand-edit** (rule 2): `openspec/specs/` is written by
  `/opsx:archive` and by nothing else, and the archived folder is denied to every editor.
