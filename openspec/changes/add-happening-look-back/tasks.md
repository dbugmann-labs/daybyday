**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red, or a Kit signature that has to differ from `design.md` § *The
seam*.

Rule 3 governs § 3: take the next unticked box, write the one test named for it — the scenario title
verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then the next. Every
test goes in `src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenHappeningLookBackTests.swift`.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's twelve scenarios uncovered and no other

## 2. The seam

- [ ] 2.1 `HappeningLookBack`, its `Month` and `SaidOccurrence`, `CommitmentsScreen.lookBack(at:)` for a happening and `LookBackWords.times(_:)` exist with the signatures in `design.md` § *The seam*, and 3.1 is red before any of them does more than compile
- [ ] 2.2 `LookBack`, `LookBack.form(...)` and `lookBack(at:)` for a commitment are unchanged, and every carried `LookBackTests` test passes unedited
- [ ] 2.3 `lookBack(at:)` for a happening reads the store the screen already holds, opens no store and calls no write, `keptAChange()` or `readHappenings()`

## 3. The twelve scenarios of `happening` — one test each

- [ ] 3.1 a commitments screen answers a look-back at a happening it lists, by its name as listed — catches the name read off the argument rather than the list
- [ ] 3.2 a commitments screen answers no look-back at a happening it does not list, or while it cannot read its happening place — catches a look-back formed for any happening by identity alone
- [ ] 3.3 a commitments screen that cannot read its roster or its record still answers a look-back at a happening — catches a guard copied from the commitment's `lookBack(at:)`
- [ ] 3.4 asking a commitments screen for a happening's look-back changes nothing and writes nothing — catches a look-back that ends the happening refusal
- [ ] 3.5 a happening's look-back says its own occurrences, newest day first, each with its day, its time and its note — catches the noted order kept, or another happening's occurrences said
- [ ] 3.6 a happening's look-back says a day's latest time first and its occurrences with no time after them — catches the day screen's order reversed, or ties left in the noted order
- [ ] 3.7 a happening's look-back counts every occurrence it says and says the day of the earliest — catches "since" taken from the first occurrence noted
- [ ] 3.8 a happening's look-back that says one occurrence counts it in the singular — catches "1 times"
- [ ] 3.9 a happening's look-back counts each calendar month from the earliest occurrence's through the current one, newest first — catches months that end at the latest occurrence or skip an empty one
- [ ] 3.10 a happening's look-back runs its months unbroken across the turn of a year — catches a month step that does not roll the year
- [ ] 3.11 a happening's look-back says an occurrence on a day after the one the screen holds, and counts its month — catches occurrences after today dropped, or months that stop short of them
- [ ] 3.12 a happening's look-back with nothing noted says its name and nothing else — catches a "since" or a "0 times" month formed from no occurrence

## 4. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 4.1 `CommitmentsView`'s happening row is a `NavigationLink` to `HappeningLookBackView`, keeping its leading swipe, and the view draws `HappeningLookBack` exactly as `design.md` § *The shell* and § *What the shell draws* say, composing no string but "Since", "Months" and "Nothing noted yet."
- [ ] 4.2 `git diff --stat origin/main... -- src/DayByDay/` lists `CommitmentsView.swift` and `LookBackView.swift` alone; a commitment's look-back draws as before, the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 5. The records

**The `CONTEXT.md` entries are written by this Story's proposal commit, not by the implementation.**

- [ ] 5.1 Confirm `CONTEXT.md` § *Look-back* and its 2026-10-03 amendment describe what shipped; a sentence that turns out wrong is a stop and a G4 question
- [ ] 5.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 6. The gates and the archive handover

- [ ] 6.1 `openspec validate add-happening-look-back --strict` exits 0, and `pnpm run checks` is clean
- [ ] 6.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with twelve more tests than a run on `origin/main` reports, both read off runs
- [ ] 6.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 6.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked and the walk comment's URL is in W.4. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `openspec/specs/happening/spec.md` gains this delta's five requirements and twelve scenarios, and no other spec file moves. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install; "Kopfweh" and "Schlecht geschlafen" made on the commitments screen. On the day screen, Kopfweh noted on a day two calendar months back at 07:15; then on today, once at the current time with a three-line note, and once with its time cleared. Nothing is noted in the month between.

- [ ] W.1 The commitments screen — the Happenings section listing "Kopfweh" and "Schlecht geschlafen", each row with a grey chevron.
- [ ] W.2 Kopfweh tapped — the large title "Kopfweh"; the head card "Since" and the day two months back; "Months" with this month "2 times", last month "0 times", the month before "1 time"; "3 times"; today's timed card with its note folded to two lines, today's "no time" card, then the 07:15 card.
- [ ] W.3 Back, Schlecht geschlafen tapped — the large title "Schlecht geschlafen" and "Nothing noted yet." alone, no head card and no months.
- [ ] W.4 **The handover** — W.1–W.3, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL.
