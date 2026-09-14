## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written
as a test without changing its title, a new test that passes before the code it names is written,
a fix that reaches outside `Schedule.swift`, `ScheduleWords.swift` and `DayView.swift`, or any
other test in the suite turning red.

Rule 3 governs §§ 3–4: take the next unticked box, write or change the one test named for it, watch
it fail, make it pass, then the next. Schedule tests go in
`src/DayByDayKit/Tests/DayByDayKitTests/ScheduleTests.swift`, day-screen tests in `DayViewTests.swift`.

## 2. The seam

- [ ] 2.1 `Schedule.inWords(given:)`, `DayView.Row.standing` and `ScheduleWords.weeklyQuota(_:given:)` exist with the signatures in `design.md` § *The seam*, and 3.1 is red before they do anything but compile
- [ ] 2.2 `Schedule.inWords`, `Commitment.rhythmInWords` and `Rhythm.inWords` are unchanged, and every commitments-screen test still passes untouched

## 3. `schedule` — one test each

- [ ] 3.1 a weekly quota said given a count says the count before its words — catches a space around the slash or the count after the words
- [ ] 3.2 a weekly quota said given a count above its quota says that count and caps nothing — catches a count capped at the quota
- [ ] 3.3 a weekly quota said given a count no week can hold says the count as given — catches a clamp to zero or seven
- [ ] 3.4 a schedule that is not a weekly quota said given a count says its plain words — catches a count prefixed on every shape

## 4. `day-screen` — one test each

- [ ] 4.1 a row says the rhythm its commitment runs on in words — the shipped test's "3x a week" becomes "0/3x a week"; red first, catches plain words on a week with nothing kept
- [ ] 4.2 two weekly-quota rows alike in commitment, date and day but differing in standing are different rows — catches equality that ignores the standing
- [ ] 4.3 two weekly-quota rows whose histories differ only outside the row's week through its date are the same row — catches a count of the whole week or a seven-day window
- [ ] 4.4 two rows on a schedule that is not a weekly quota whose histories differ on another day of the week are the same row — catches a standing held on every row
- [ ] 4.5 a weekly-quota row says its standing counted through its own date and from its own week's Monday — catches a standing counted as of today
- [ ] 4.6 a weekly-quota row past its quota says the true count and still offers a tick — catches a cap or a met row refusing its tick
- [ ] 4.7 a weekly-quota row for a day that has not arrived says its standing through its own date — catches a future row falling back to plain words
- [ ] 4.8 a weekly-quota row whose commitment is not a tick says its standing by the days kept — catches a count of records rather than of kept days
- [ ] 4.9 a row on a schedule that is not a weekly quota says its plain words whatever its week holds — catches counted words on another shape

## 5. The records

**The ADR amendments are written by this Story's proposal commit, not by the implementation.**
These boxes confirm rather than write.

- [ ] 5.1 Confirm the 2026-09-14 amendments to ADR-1034 and ADR-1050 and `CONTEXT.md` § *Row* and § *Rhythm in words* still describe what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [ ] 5.2 Confirm `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2) and `-- docs/adr/` reports only `1034-…`, `1050-…` and `README.md`

## 6. The gates

- [ ] 6.1 `openspec validate say-standing-in-quota-row --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [ ] 6.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, the three `docs/adr/` files, `Schedule.swift`, `ScheduleWords.swift`, `DayView.swift`, `ScheduleTests.swift` and `DayViewTests.swift`
- [ ] 6.3 `pnpm run check:budgets` warns about nothing in this folder, and `pnpm run verify` passes
- [ ] 6.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is twelve more than a run on `main` reports — both read off runs, never derived by arithmetic
- [ ] 6.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–6.4 are ticked and that the instruction below is written here for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff it produced: `openspec/specs/schedule/spec.md` gains one requirement with its four scenarios and changes one paragraph of *A schedule says the rhythm it runs on in words*; `openspec/specs/day-screen/spec.md` changes the prose of its two row requirements, the "3x a week" of one scenario, and gains nine scenarios under them; nothing else in any spec moves. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.
