**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5).
That includes a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be
written as a test without changing its title, a test that passes before the code it names is
written, a carried test that has to be edited beyond § 2.1's one binding or turns red, and a Kit
signature that has to differ from `design.md` § *The seam*.

Rule 3 governs § 2: take the next unticked box and write the one test named for it, its title the
scenario's verbatim, which `pnpm run check:scenarios` checks. Watch it fail, make it pass, then take
the next.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's 7 new scenarios uncovered and no other, and `openspec validate count-declined-days --strict` exits 0 on a branch rebased onto current `main`

## 2. `LookBack` — the declined count

- [x] 2.1 The members in `design.md` § *The seam* exist with those signatures, `declinedInWords` and every month line's count answering `nil`; the twelve positional `.month` matches gain one `_` binding and no other change; every carried test still passes, and 2.2 is red before any member does more than compile
- [x] 2.2 a look-back counts every day declined since the day it is kept from, and its whole still counts them due and unkept — catches a declined day dropped from the whole's due days, or counted kept
- [x] 2.3 a month line says how many of its days were declined beside its fraction — catches "1 declined" pluralised, a count on a month holding none, or a fraction moved by the count
- [x] 2.4 a declined day in a week a week line says is counted on its month line, and no week line says a declined count — catches bucketing by calendar week rather than by the era holding the day
- [x] 2.5 a number commitment's look-back counts a day declined however long ago, and its graph says no point on one — catches a count limited to the month span, or a count on the tick kind only
- [x] 2.6 a look-back that says no graph or no note still counts its declined days — catches the count formed inside the graph or the notes and lost where they are `nil` or empty
- [x] 2.7 a look-back counts no decline on a day it does not count due — catches counting every decline the history holds in reach, gap, stop, quota or rhythm aside
- [x] 2.8 a look-back that counts no declined day says no declined count — catches "0" in place of `nil`, or a decline replaced by a tick still counted

## 3. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 3.1 The head card's last row is a `LookBackDateRow` labelled "Declined" drawing `declinedInWords` in monospaced digits, drawn exactly where that is not `nil`, under "The whole" on a tick page and under "Kept from" or "Kept until" on every other, as § *What the shell draws* has it
- [ ] 3.2 A month line with a declined count draws it under the month's name in `.caption`, secondary, the fraction staying on the name's baseline; a month without one and every week line draw exactly as shipped
- [ ] 3.3 `git diff --stat origin/main... -- src/DayByDay/` lists `LookBackView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 4. The records

- [ ] 4.1 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2), and `CONTEXT.md` is as this folder's PR left it and has not been edited since G4

## 5. The gates and the archive handover

- [ ] 5.1 `openspec validate count-declined-days --strict` exits 0, and `pnpm run checks` is clean but for `check:budgets` warnings on carried requirements
- [ ] 5.2 `pnpm run verify` is green, and `swift test` in `src/DayByDayKit` passes with 7 more tests than a run on `origin/main` reports, both counts read off runs
- [ ] 5.3 **G7** — the reviewer's findings are answered, and the PR is rebased onto current `main`
- [ ] 5.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, once every other box is ticked and the walk comment's URL is in W.4. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `look-back` alone moves, gaining this delta's two requirements and 7 scenarios. **Any other drift is a stop and a report, never a hand-edit**: the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install, walked on the simulator on any day, light only; `pnpm run walk` uninstalls the app,
so every record is typed through the day screen, never seeded. W.1's commitment is defined with a
"Kept from" two calendar months back, so its look-back says three months.

- [ ] W.1 A tick commitment's look-back, declined on days in its newest and its oldest month and on none in the month between: a "N declined" caption under each of those two months' names, the middle month on one line, and a "DECLINED" row last in the head card, under "THE WHOLE", saying their sum.
- [ ] W.2 Weight's look-back, holding a number on a few days and declined on one: the head card's "DECLINED" row under "KEPT FROM", over the graph drawn as it is without the decline.
- [ ] W.3 A tick commitment's look-back holding ticks and no decline: the head card ending on "THE WHOLE", and every month on one line.
- [ ] W.4 **The handover**: W.1–W.3, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>` before hand-back, never with `gh pr comment --attach`, and this box is ticked on that comment's URL.
