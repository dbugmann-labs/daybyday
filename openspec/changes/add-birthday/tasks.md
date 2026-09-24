## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written
as a test without changing its title, a test that passes before the code it names is written, a fix
that reaches into a shipped file, or any other test in the suite turning red.

Rule 3 governs §§ 3 and 4: take the next unticked box, write the one test named for it — the
scenario title verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then
the next. The value tests go in `src/DayByDayKit/Tests/DayByDayKitTests/BirthdayTests.swift`, the
store tests in `BirthdayStoreTests.swift` beside it, whose `freshPlace()` mirrors
`OneOffStoreTests`'s. Nothing reads the calendar and nothing touches `src/DayByDay/`.

## 2. The seam

- [x] 2.1 `Birthday`, `BirthdayTicks`, `BirthdayStore` and `BirthdayStoreError` exist with the
      signatures in `design.md` § *The seam*, and 3.1 is red before any of them does more than compile
- [x] 2.2 `BirthdayTicks` holds an internal key of contact and day and never a `Birthday`; `Birthday`
      has exactly the three stored properties the seam lists and synthesised equality over all three
- [x] 2.3 The contact is judged with `Blank.saysNothing(_:)`; no second whitespace test, no
      `Comparable` conformance and no date arithmetic is added (ADR-1039)
- [x] 2.4 `BirthdayDocument` is `internal`, version 1, decodes through `Birthday`'s contact rule and
      `CalendarDate.init?`, and writes ticks by contact then day with `.sortedKeys` and no words

## 3. The eleven scenarios of the value — one test each

- [x] 3.1 two birthdays alike in contact, words and day are the same birthday — catches equality over the contact alone
- [x] 3.2 a birthday's words are kept exactly as they were handed — catches a trim, or a refusal of empty words
- [x] 3.3 a birthday whose contact says nothing is refused and makes no birthday — catches a length check instead of the blank test
- [x] 3.4 the birthdays on a day are the ones handed that fall on it, in the order they were handed — catches a sort, or a de-duplication
- [x] 3.5 a day on which no birthday handed falls holds no birthdays — catches an answer that falls back to the nearest day
- [x] 3.6 a birthday ticked is ticked, and no other birthday is — catches a key on the contact alone, which ticks every year
- [x] 3.7 a tick follows its birthday when the calendar's words for it change — catches the words in the key, the likeliest wrong implementation
- [x] 3.8 ticking a birthday already ticked is refused and changes nothing — catches a second tick held under new words
- [x] 3.9 a tick taken back leaves the birthday not ticked — catches a take-back that matches on the words
- [x] 3.10 taking back the tick of a birthday that is not ticked is refused — catches a take-back that reports success on nothing
- [x] 3.11 a tick whose birthday the calendar no longer hands is kept, and ticks it again when it is handed again — catches ticks pruned to what was handed

## 4. The nine scenarios of the store — one test each

- [x] 4.1 a birthday store opened where nothing has been kept holds no ticks — catches an error where a place is simply empty
- [x] 4.2 a birthday store opened again holds exactly the ticks left there, and none of their words — catches a take-back that never reaches the disk, or words written to it
- [x] 4.3 a birthday tick is kept before the store reports it kept — catches a write deferred to a save
- [x] 4.4 a birthday tick that cannot be kept is refused and not held — catches a store that holds what the disk refused
- [x] 4.5 a change the birthday ticks refuse leaves the place untouched — catches a rewrite on a refused tick or take-back
- [x] 4.6 birthday stores at different places are independent — catches a shared or static place
- [x] 4.7 content that is not a birthday store is refused and left as it was — catches opening empty over what is there
- [x] 4.8 a birthday store written in a later form than this app knows is refused — catches a version read after the body
- [x] 4.9 a birthday store holding what could not be a tick is refused — catches a decoder that skips the bad entry, or misses two alike

## 5. The records

**ADR-1062, its `docs/adr/README.md` row and the `CONTEXT.md` amendments are written by this
Story's proposal commit, not by the implementation.** These boxes confirm rather than write.

- [x] 5.1 Confirm ADR-1062 still describes what shipped — a tick keyed to contact and day, the words
      outside it, and a tick kept until taken back. A rule the implementation needed that the record
      does not carry is a **stop and a G4 question**
- [x] 5.2 Confirm `CONTEXT.md` § *Birthday* and § *Birthday store* still describe what shipped; a
      sentence that turns out wrong is the same stop
- [x] 5.3 Confirm ADR-1062 is still the only record numbered 1062 on `origin/main` after the last
      rebase; a clash is a stop and a report, never a renumber by the implementer
- [x] 5.4 Confirm `openspec/specs/` was not hand-edited on this branch (rule 2):
      `git diff --stat origin/main... -- openspec/specs/` reports nothing

## 6. The gates

- [x] 6.1 `openspec validate add-birthday --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [x] 6.2 `git diff --stat origin/main` lists only this change folder, the four new
      `Sources/DayByDayKit/` files, the two new test files, ADR-1062, `docs/adr/README.md` and
      `CONTEXT.md`
- [x] 6.3 `pnpm run check:budgets` warns about nothing in this folder, and `pnpm run verify` passes
- [x] 6.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is twenty more than a
      run on `main` reports — both read off runs, never derived by arithmetic
- [x] 6.5 **The archive handover — `implementer` ticks this in its last commit before the archive**,
      on the evidence that 2.1–6.4 are ticked and that the instruction below is written here for the
      janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of
      the sync it prints, then reads the spec diff it produced: `openspec/specs/birthday/spec.md` is
      created with this delta's six requirements and their twenty scenarios and the Purpose from the
      delta, and no other spec file moves. `pnpm run checks` runs after the archive commit exists.
      **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies
      `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so
      a box left unticked here cannot be reached afterwards.
