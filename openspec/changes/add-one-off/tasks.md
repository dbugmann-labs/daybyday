## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written
as a test without changing its title, a test that passes before the code it names is written, a fix
that reaches into a shipped file, or any other test in the suite turning red.

Rule 3 governs §§ 3 and 4: take the next unticked box, write the one test named for it — the
scenario title verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then
the next. Never transcribe the twenty-nine up front. The value tests go in
`src/DayByDayKit/Tests/DayByDayKitTests/OneOffTests.swift`, the store tests in
`OneOffStoreTests.swift` beside it, whose `freshPlace()` mirrors `RosterStoreTests`'s.

## 2. The seam

- [ ] 2.1 `OneOff`, `OneOffs`, `OneOffStore` and `OneOffStoreError` exist with the signatures in
      `design.md` § *The seam*, and 3.1 is red before any of them does more than compile
- [ ] 2.2 The day a one-off was done is a field of the entry `OneOffs` holds, never a part of
      `OneOff`; `OneOff` has exactly the two stored properties the seam lists
- [ ] 2.3 Dates are compared with `days(until:)` and the name is judged with `Blank.saysNothing(_:)`;
      no second whitespace test and no `Comparable` conformance is added (ADR-1039)
- [ ] 2.4 `OneOffDocument` is `internal`, decodes through `OneOff.init?` and the held-by rules, and
      writes `doneOn` only where a one-off is done — no `IntroducedInVersion` constant at version 1

## 3. The twenty scenarios of the value — one test each

- [ ] 3.1 two one-offs alike in name and date are the same one-off — catches an identifier, or equality over a done day
- [ ] 3.2 a one-off's name is kept exactly as it was given — catches a trim on the way in
- [ ] 3.3 a name that says nothing is refused and makes no one-off — catches a length check instead of the blank test
- [ ] 3.4 a one-off that is not done stands on its date until that date has passed — catches a standing day that is always today
- [ ] 3.5 a one-off that is not done and whose date has passed stands on today — catches a standing day that is always the one-off's date, the likeliest wrong answer
- [ ] 3.6 a one-off that is done stands on the day it was ticked, whatever today is — catches a done one-off that goes on following today
- [ ] 3.7 a one-off ticked after its date stands on the day it was ticked and not on its date — catches a standing day taken from the date once done
- [ ] 3.8 a one-off that is not held stands on no day — catches an answer of a day for a one-off nobody holds
- [ ] 3.9 adding a one-off already held is refused and changes nothing — catches a silent second copy
- [ ] 3.10 a one-off differing in name or in date is held beside the one already there — catches a refusal that keys on the name alone
- [ ] 3.11 a one-off added already done stands on the day it was done — catches an add-done that holds it undone
- [ ] 3.12 a one-off ticked on a day is done and stands there — catches a tick that records no day
- [ ] 3.13 making a one-off done on a day before its date is refused — catches a tick accepted on any day, through either entry point
- [ ] 3.14 ticking a one-off that is already done is refused and leaves the day it holds — catches a second tick moving the day it was done
- [ ] 3.15 ticking a one-off that is not held is refused — catches a tick that adds what it cannot find
- [ ] 3.16 a tick taken back leaves the one-off held and standing by its date again — catches a take-back that removes the one-off
- [ ] 3.17 taking back the tick of a one-off that is not done is refused — catches a take-back that reports success on nothing
- [ ] 3.18 a one-off removed is held no longer and stands on no day — catches a removal that only unticks
- [ ] 3.19 a one-off that is done is removed outright, tick and all — catches a removal that refuses a done one-off, and one that takes others with it
- [ ] 3.20 removing a one-off that is not held is refused — catches a removal that reports success on nothing

## 4. The nine scenarios of the store — one test each

- [ ] 4.1 a store opened where nothing has been kept holds no one-offs — catches an error where a place is simply empty
- [ ] 4.2 a store opened again holds exactly the one-offs left there, done or not as they were left — catches a tick, a take-back or a removal that never reaches the disk
- [ ] 4.3 a change is kept before the store reports it kept — catches a write deferred to a save
- [ ] 4.4 a change that cannot be kept is refused and not held — catches a store that holds what the disk refused
- [ ] 4.5 a change the one-offs refuse leaves the place untouched — catches a rewrite on a refused addition
- [ ] 4.6 one-off stores at different places are independent — catches a shared or static place
- [ ] 4.7 content that is not a one-off store is refused and left as it was — catches opening empty over what is there
- [ ] 4.8 a one-off store written in a later form than this app knows is refused — catches a version read after the body
- [ ] 4.9 a one-off store holding what could not be a one-off is refused — catches a decoder that skips the bad entry, and one that misses two alike

## 5. The records

**ADR-1052 and its `docs/adr/README.md` row are written by this Story's proposal commit, not by the
implementation.** These boxes confirm rather than write, and each is tickable while reading what is
there.

- [ ] 5.1 Confirm ADR-1052 still describes what shipped — the later of the date and today while
      undone, the day it was ticked once done, and never a day before the date. A rule the
      implementation needed that the record does not carry is a **stop and a G4 question**
- [ ] 5.2 Confirm `CONTEXT.md` § *One-off* still describes what shipped; a sentence that turns out
      wrong is the same stop, because that term was landed by the Feature grill
- [ ] 5.3 Confirm no further ADR was written by this branch: `git diff --stat origin/main... --
      docs/adr/` reports only `1052-…` and `README.md`
- [ ] 5.4 Confirm `openspec/specs/` was not hand-edited on this branch (rule 2):
      `git diff --stat origin/main... -- openspec/specs/` reports nothing

## 6. The gates

- [ ] 6.1 `openspec validate add-one-off --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [ ] 6.2 `git diff --stat origin/main` lists only this change folder, the four new
      `Sources/DayByDayKit/` files, the two new test files, ADR-1052 and `docs/adr/README.md`
- [ ] 6.3 `pnpm run check:budgets` warns about nothing in this folder, and `pnpm run verify` passes
- [ ] 6.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is twenty-nine more than
      a run on `main` reports — both read off runs, never derived by arithmetic
- [ ] 6.5 **The archive handover — `implementer` ticks this in its last commit before the archive**,
      on the evidence that 2.1–6.4 are ticked and that the instruction below is written here for the
      janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of
      the sync it prints, then reads the spec diff it produced: `openspec/specs/one-off/spec.md` is
      created with this delta's eight requirements and their twenty-nine scenarios and the Purpose
      from the delta, and no other spec file moves. `pnpm run checks` runs after the archive commit
      exists. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies
      `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so
      a box left unticked here cannot be reached afterwards.
