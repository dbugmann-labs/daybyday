**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red, or a Kit signature that has to differ from `design.md` § *The
seam*.

Rule 3 governs §§ 3–4: take the next unticked box, write the one test named for it — the scenario
title verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then the next.
§ 3 goes in `src/DayByDayKit/Tests/DayByDayKitTests/OccurrenceChangeTests.swift`, § 4 in
`DayScreenOccurrenceChangeTests.swift` beside it.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's fifteen scenarios uncovered and no other

## 2. The seam

- [x] 2.1 The `Occurrence`, `Happenings`, `HappeningStore` and `DayScreen` members exist with the signatures in `design.md` § *The seam*, and 3.1 is red before any of them does more than compile
- [x] 2.2 `DayView.withHappenings(_:)` forms each time from `Occurrence.timeInWords`, and `HappeningRow` keeps exactly its two stored properties; every carried `DayScreenHappeningTests` test passes unedited
- [x] 2.3 `HappeningDocument.currentVersion` is unchanged, and `HappeningStore.change` and `takeBack` go through `Happenings` before the one `write(_:)`, as `note(_:)` does
- [x] 2.4 `DayScreen.change` and `takeBack` call no `keptAChange()` and touch neither `readPlaces` nor `saysACopyCanBeRestored`

## 3. The seven scenarios of `happening` — one test each

- [x] 3.1 an occurrence changed keeps its happening, its day and its place in the order noted — catches a changed occurrence appended last
- [x] 3.2 of two occurrences alike, the earliest noted is the one changed — catches the last alike changed, or every alike
- [x] 3.3 changing an occurrence not held is refused, and a change to what it holds changes nothing — catches a change that matches on happening and day alone
- [x] 3.4 an occurrence taken back is removed once, and the rest keep their order — catches `removeAll(where:)`
- [x] 3.5 taking back an occurrence not held is refused and changes nothing — catches a take-back that ignores the note
- [x] 3.6 a happening store opened again holds the occurrences as changed and taken back — catches a change held in memory and not written
- [x] 3.7 a change or a take-back the happening store cannot keep is refused and not held — catches the held value replaced before the write

## 4. The eight scenarios of `day-screen` — one test each

- [x] 4.1 a happening row's occurrences are answered in the row's order, each with its time and its note — catches the noted order kept, or an unstable sort on equal times
- [x] 4.2 a happening row's occurrences are those of the day the screen is showing — catches every day's occurrences answered
- [x] 4.3 an occurrence changed through a day screen is kept at the happening place and drawn on the day — catches an untrimmed note or a day view not re-formed
- [x] 4.4 a change to the time and note an occurrence holds asks for no change — catches the write attempted before the no-change check
- [x] 4.5 changing or taking back an occurrence writes no copy, leaves the other places as they were and ends a notice — catches `keptAChange()` copied from the one-offs
- [x] 4.6 an occurrence taken back through a day screen is gone from the place and from the row — catches every alike occurrence taken back
- [x] 4.7 a change to a time later than now is refused as not yet come — catches `>=` where `>` is meant, or the bound read against the day shown
- [x] 4.8 a change or a take-back the happening place cannot take is refused as not kept — catches a day view re-formed before the write

## 5. The shell (ADR-1019: no rule the Kit does not state)

- [x] 5.1 `ContentView` draws the row's tap, the popover, the filled-in sheet, its *Take back* and the confirmation exactly as `design.md` § *The shell* and § *What the shell draws* say, reading `occurrences(of:)` and handing `momentNow()` to `change`
- [x] 5.2 `git diff --stat origin/main... -- src/DayByDay/` lists `ContentView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 6. The records

**The `CONTEXT.md` entries are written by this Story's proposal commit, not by the implementation.**

- [x] 6.1 Confirm `CONTEXT.md` § *Happening row* and § *Occurrence* and their 2026-10-02 amendments describe what shipped; a sentence that turns out wrong is a stop and a G4 question
- [x] 6.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 7. The gates and the archive handover

- [x] 7.1 `openspec validate change-or-take-back-occurrence --strict` exits 0, and `pnpm run checks` is clean
- [x] 7.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with fifteen more tests than a run on `origin/main` reports, both read off runs
- [ ] 7.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 7.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked and the walk comment's URL is in W.9. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `openspec/specs/happening/spec.md` gains this delta's three requirements and seven scenarios, `openspec/specs/day-screen/spec.md` its four requirements and eight scenarios, and no other spec file moves. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install; "Kopfweh" made on the commitments screen; the day screen moved one day back, so no time is bounded at now.

- [x] W.1 One day back, Kopfweh noted at 09:10 with the note "Hinter dem Auge", a line break and "links", and at 18:40 with none — the row reads "Kopfweh · 09:10, 18:40".
- [x] W.2 The row tapped — the popover under it listing 09:10 with "Hinter dem Auge" and "links" beneath, then 18:40 alone, the day still in view.
- [x] W.3 09:10 tapped — the sheet titled Kopfweh, "Time" at 09:10 with its clear button, the note filled in, a red *Take back* at its foot, the keyboard down.
- [x] W.4 The time changed to 20:15 and saved — the day with no popover, the row reading "Kopfweh · 18:40, 20:15".
- [x] W.5 The row tapped, 18:40 opened, *Take back* tapped — "Take back this occurrence?" with a red *Take back* and *Cancel*.
- [x] W.6 Taken back — the day, the row reading "Kopfweh · 20:15".
- [x] W.7 The row tapped again — the sheet opened directly on 20:15 with its note, no popover.
- [x] W.8 *Take back* tapped and confirmed — the day with no Kopfweh row.
- [x] W.9 **The handover** — W.1–W.8, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL.
