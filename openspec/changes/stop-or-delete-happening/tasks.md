**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red, or a Kit signature that has to differ from `design.md` § *The
seam*.

Rule 3 governs §§ 3–5: take the next unticked box, write the one test named for it — the scenario
title verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then the next.
§ 3 goes in `src/DayByDayKit/Tests/DayByDayKitTests/HappeningStopTests.swift`, § 4 in
`CommitmentsScreenHappeningStopTests.swift` and § 5 in `DayScreenStoppedHappeningTests.swift`, each
beside the happening tests already there.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's twenty-eight new scenarios uncovered and no other

## 2. The seam

- [ ] 2.1 The `Happenings`, `HappeningStore` and `CommitmentsScreen` members exist with the signatures in `design.md` § *The seam*, and 3.1 is red before any of them does more than compile
- [ ] 2.2 `Happenings` holds the stops beside `all`, its `==` and `hash` take them in, and `Happening` keeps exactly its two stored properties
- [ ] 2.3 `HappeningDocument.currentVersion` is 3, `formHappenings()` applies stops after occurrences, and every carried `HappeningStoreTests` test passes unedited
- [ ] 2.4 `DayScreen.happenings` holds the happenings not stopped, `occurrences(of:)` resolves against every happening held, and every carried `DayScreenHappeningTests` and `DayScreenOccurrenceChangeTests` test passes unedited
- [ ] 2.5 Every ask of a commitment's or a happening's stop or deletion clears the other three slots and both names typed back, and none of the new `CommitmentsScreen` members calls `keptAChange()`

## 3. The nine scenarios of `happening` at the value and the store — one test each

- [ ] 3.1 a happening stopped keeps its name, its place and its occurrences, and resumed is stopped no longer — catches a stop that removes the happening from `all`
- [ ] 3.2 a stopped happening takes no occurrence noted, and its occurrences are still changed and taken back — catches `change`/`takeBack` guarded on the stop too
- [ ] 3.3 a stopped happening's name refuses another's, and a stopped happening renamed stays stopped — catches `holding(name:)` filtering out the stopped
- [ ] 3.4 stopping a stopped happening, resuming one not stopped, or either of one not held is refused and changes nothing — catches an idempotent stop answered as kept
- [ ] 3.5 a happening deleted takes every occurrence of it and leaves the rest in their order — catches occurrences left orphaned in the value
- [ ] 3.6 deleting a happening not held is refused and changes nothing — catches a delete matched on name rather than identity
- [ ] 3.7 a happening store opened again holds the happenings as stopped, resumed and deleted — catches stops applied before occurrences on reading
- [ ] 3.8 a stop, a resume or a deletion the happening store cannot keep is refused and not held — catches the held value replaced before the write
- [ ] 3.9 a happening store in an earlier form is read as holding no happening stopped — catches form 2 refused, or rewritten on opening

## 4. The fifteen scenarios of `happening` at the commitments screen — one test each

- [ ] 4.1 asking a commitments screen to stop a happening changes nothing until it is confirmed — catches a stop written on the ask
- [ ] 4.2 a happening stopped through a commitments screen is still listed in its place and said to be stopped — catches a stopped happening dropped from `happenings`
- [ ] 4.3 a happening resumed through a commitments screen asks for no confirmation and is said to be stopped no longer — catches a resume routed through the stop slot
- [ ] 4.4 asking to stop a stopped happening, or to resume one not stopped, does nothing and says nothing — catches a store refusal relayed as `.notKept`
- [ ] 4.5 a happening stop or resume the happening place cannot take is refused as not kept — catches the refusal left out of `happeningRefusal`
- [ ] 4.6 asking a commitments screen to delete a happening changes nothing until it is confirmed — catches a typed-back name surviving a second ask
- [ ] 4.7 a name typed back to delete a happening matches only when it is the happening's name — catches a case-insensitive match
- [ ] 4.8 a happening deleted through a commitments screen is listed no longer, and its occurrences are gone — catches the list not re-read after the write
- [ ] 4.9 a commitments screen says how many occurrences go with the happening awaiting deletion — catches "Its 1 occurrences" or every happening's occurrences counted
- [ ] 4.10 a happening deletion confirmed on a name that does not match, or with nothing awaiting, changes nothing — catches the slot cleared before the match is checked
- [ ] 4.11 a happening deletion the happening place cannot take is refused as not kept — catches the slot left awaiting after a refusal
- [ ] 4.12 asking about a happening leaves no commitment awaiting a stop or a deletion, and the reverse — catches one shared `nameTypedBack`
- [ ] 4.13 a commitments screen opened has no happening awaiting a stop or a deletion — catches a slot formed from the store
- [ ] 4.14 stopping, resuming and deleting a happening writes no copy and leaves the other places as they were — catches `keptAChange()` copied from the commitment's deletion
- [ ] 4.15 what a commitments screen tells about a happening ends when a stop, a resume or a deletion is kept — catches the ask itself ending the refusal

## 5. The four scenarios of `day-screen` — one test each

- [ ] 5.1 a stopped happening's row is still drawn on the days it came, and its occurrences are changed and taken back — catches `occurrences(of:)` left on the listed happenings
- [ ] 5.2 noting a stopped happening through a day screen is refused as not kept — catches `note` guarded on the store alone
- [ ] 5.3 a happening deleted through a commitments screen has no row on the days it came — catches orphaned occurrences drawn
- [ ] 5.4 a day screen lists no stopped happening, and lists one resumed in its place — catches a resumed happening appended last

## 6. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 6.1 `CommitmentsView` draws the swipes, the "- Stopped" marker, the alert, the delete sheet and the refusal footer exactly as `design.md` § *The shell* and § *What the shell draws* say
- [ ] 6.2 `git diff --stat origin/main... -- src/DayByDay/` lists `CommitmentsView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 7. The records

**The `CONTEXT.md` entry is written by this Story's proposal commit, not by the implementation.**

- [ ] 7.1 Confirm `CONTEXT.md` § *Happening* and its 2026-10-03 amendment describe what shipped; a sentence that turns out wrong is a stop and a G4 question
- [ ] 7.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 8. The gates and the archive handover

- [ ] 8.1 `openspec validate stop-or-delete-happening --strict` exits 0, and `pnpm run checks` is clean
- [ ] 8.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with twenty-eight more tests than a run on `origin/main` reports, both read off runs
- [ ] 8.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 8.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked and the walk comment's URL is in W.7. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `openspec/specs/happening/spec.md` gains six requirements and twenty-two scenarios and three of its requirements change, gaining two scenarios between them; `openspec/specs/day-screen/spec.md` gains one requirement and three scenarios and two of its requirements change, gaining one; no other spec file moves. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install; "Augenmigräne" and then "Kopfweh" made on the commitments screen; the day screen moved one day back and "Kopfweh" noted there at 09:10.

- [ ] W.1 The commitments screen, "Kopfweh" swiped and Stop tapped — "Stop noting this happening?" with a red "Stop noting Kopfweh" and "Cancel".
- [ ] W.2 The stop confirmed — the Happenings card reading "Augenmigräne", "Kopfweh - Stopped", then "New happening".
- [ ] W.3 The day screen on today, the bolt's menu open — "Augenmigräne" alone in it.
- [ ] W.4 The day screen one day back — the row "Kopfweh · 09:10" still drawn.
- [ ] W.5 The commitments screen, "Kopfweh" swiped, Delete tapped and "Kopfweh" typed back — the sheet titled "Delete Kopfweh", "Its 1 occurrence goes with it." under the field, Delete enabled.
- [ ] W.6 The deletion confirmed, the day screen one day back — no Kopfweh row.
- [ ] W.7 **The handover** — W.1–W.6, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL.
