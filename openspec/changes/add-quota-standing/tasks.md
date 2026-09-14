## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written
as a test without changing its title, a test that passes before the code it names is written, a fix
that reaches outside `History.swift`, or any other test in the suite turning red.

Rule 3 governs § 3: take the next unticked box, write the one test named for it in
`src/DayByDayKit/Tests/DayByDayKitTests/RecordTests.swift`, watch it fail, make it pass, then the
next. Never transcribe the eleven up front. The test's name is the scenario title verbatim —
`pnpm run check:scenarios` checks it.

## 2. The seam

- [ ] 2.1 `History.standing(for:through:)` exists with the signature in `design.md` § *The seam*,
      and 3.1 is red before it does anything but compile
- [ ] 2.2 The week is worked out by a private function in `History.swift` stepping one day at a
      time; `CalendarDate` and `Weekday` gain no member, and `git diff --stat` proves it

## 3. The eleven scenarios — one test each

- [ ] 3.1 a history that has taken no record answers a standing of zero for a commitment in any week — catches an answer of nothing rather than zero
- [ ] 3.2 a standing counts the week's days through the date and never a day after it — catches a count of the whole week
- [ ] 3.3 a Sunday's standing counts back to the Monday of its week rather than forward from it — catches a Sunday-first week, the most likely wrong implementation
- [ ] 3.4 a record in the week before and one in the week after do not count toward a standing — catches a seven-day window ending at the date instead of a week
- [ ] 3.5 a standing is counted by date and never by when a record was entered — catches a running tally kept as records arrive
- [ ] 3.6 a standing past what a quota asks for is the count of kept days and is never capped — catches a count capped at the quota
- [ ] 3.7 a commitment on a schedule that is not a weekly quota is answered a standing just the same — catches a refusal or a zero for another schedule shape
- [ ] 3.8 a number, a note and a total at its target each count their day, and a total short of it does not — catches a count of ticks rather than of kept days
- [ ] 3.9 another commitment's records do not count toward a standing — catches a count taken over the whole history
- [ ] 3.10 a week reaching back before the first supported date counts the days of it that exist — catches a crash or a wrong answer where the week's Monday is 1582
- [ ] 3.11 a standing on the last supported date counts its week's days through it — catches an implementation that forms the week's Sunday first

## 4. The records

**ADR-1050, ADR-1015's amendment and the `docs/adr/README.md` row are written by this Story's
proposal commit, not by the implementation** (`design.md` § *ADR-1050 is written and ADR-1015 is
amended*). These boxes confirm rather than write, and each is tickable while reading what is there.

- [ ] 4.1 Confirm ADR-1050 still describes what shipped — Monday to Sunday on every phone, nothing
      on a week's turn, the history counting and the day screen saying. A rule the implementation
      needed that the record does not carry is a **stop and a G4 question**, never an edit slipped in
- [ ] 4.2 Confirm `CONTEXT.md` § *Week* and § *Standing* still describe what shipped; a sentence that
      turns out wrong is the same stop, because those terms were landed by the Feature grill
- [ ] 4.3 Confirm no further ADR was written by this branch: `git diff --stat origin/main... --
      docs/adr/` reports only `1050-…`, `1015-a-weekly-quota-is-due-every-day.md` and `README.md`
- [ ] 4.4 Confirm `openspec/specs/` was not hand-edited on this branch (rule 2):
      `git diff --stat origin/main... -- openspec/specs/` reports nothing

## 5. The gates

- [ ] 5.1 `openspec validate add-quota-standing --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [ ] 5.2 `git diff --stat origin/main` lists only this change folder, `History.swift`,
      `RecordTests.swift`, the two ADRs and `docs/adr/README.md`
- [ ] 5.3 `pnpm run check:budgets` warns about nothing in this folder, and `pnpm run verify` passes
- [ ] 5.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is eleven more than a
      run on `main` reports — both read off runs, never derived by arithmetic
- [ ] 5.5 **The archive handover — `implementer` ticks this in its last commit before the archive**,
      on the evidence that 2.1–5.4 are ticked and that the instruction below is written here for the
      janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of
      the sync it prints, then reads the spec diff it produced: `openspec/specs/record/spec.md`
      gains exactly one requirement, *A history answers a commitment's standing in the week of a
      calendar date*, with its eleven scenarios, and nothing else in that file or in any other spec
      moves. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and
      a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json`
      denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached
      afterwards.
