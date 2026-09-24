Anything that fails or surprises is a stop and a report, never a workaround (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a new test that passes before the code it names is written, a carried
test turning red other than the three § 6 names, or a change to `scripts/walk.ts`. Rule 3 throughout:
take the next unticked scenario box, write the one test named for it, watch it fail, make it pass.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` names this change's uncovered scenarios; they are exactly the eight titles boxed in §§ 3–5. Any other uncovered title is a stop.
- [ ] 1.2 The test named "done and undone one-offs standing on one day are ordered by the date owed alone" is deleted in the commit that makes 3.1 pass, and no other test is deleted

## 2. The seam

- [ ] 2.1 `DayView.OneOffRow.Key` and `key` exist with the signatures in `design.md` § *The seam*, and no other public signature in the Kit changes
- [ ] 2.2 `OneOffs` holds the tick order as `design.md` § *The tick order is a list in the value* says, and every mutation that refuses leaves it unchanged

## 3. The order and the tick order

- [ ] 3.1 every one-off owed stands before every one done, and the done stand most recently ticked first — catches the done sorted by date owed or by name
- [ ] 3.2 a tick taken back returns a one-off to its place among those owed, and ticked again it is the most recently ticked — catches a take-back to the bottom of the owed, or a re-tick restoring its old place
- [ ] 3.3 a one-off added already done is the most recently ticked — catches an add already done left out of the tick order
- [ ] 3.4 a done one-off renamed keeps its place in the tick order — catches a rename made as a removal and an add
- [ ] 3.5 one-offs differing only in their tick order are different one-offs — catches equality over entries alone, or a counter that leaves a hole after a removal

## 4. The one-off store

- [ ] 4.1 a one-off store kept before the tick order answers its done one-offs by the date owed, older than any tick since — catches old ticks put on top, or ordered as held
- [ ] 4.2 a one-off store holding a tick order that could not be held is refused — catches a lenient reader, or one that renumbers what it finds
- [ ] 4.3 A unit test beside `CopyTests` (not an acceptance test): a copy formed from one-offs with two ticks reads back as equal one-offs, and a copy nesting form-1 one-offs reads back with the order 4.1 names; no copy source file changes

## 5. The one-off row's key

- [ ] 5.1 a one-off row keeps its key when its one-off is ticked, and no other row shares it — catches a key by name alone, or one that counts whether done

## 6. The carried tests

- [ ] 6.1 "a one-off store written in a later form than this app knows is refused" and "a day screen not keeping one-offs adds nothing whatever is committed in its one-off entry" write `OneOffDocument.currentVersion + 1` in place of the literal 2; nothing else in either changes
- [ ] 6.2 "a one-off store holding what could not be a one-off is refused" writes its four fixtures at form 2, the done-before-its-date one carrying place 1; nothing else in it changes
- [ ] 6.3 "a change is kept before the store reports it kept" holds the first store open until the second is read, with `withExtendedLifetime`; nothing else in it changes
- [ ] 6.4 Every other test passes unedited, the two carried scenarios of the removed requirement included

## 7. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 7.1 `ContentView` keys one-off rows by `\.key` and wraps a one-off row's tick and take-back, and nothing else, in `withAnimation`, as `design.md` § *A one-off row's key* says; commitment and birthday rows are untouched
- [ ] 7.2 The app target builds for the simulator

## 8. The records

- [x] 8.1 The conductor removes the entry "The one-off store's 'kept before the store reports it kept' test does not keep the first store open" from `docs/open-questions.md` on this branch, and ticks this box on that commit — not the implementer's file
- [ ] 8.2 Confirm `CONTEXT.md` § *One-off* still describes what shipped; a sentence that turns out wrong is a stop and a G4 question, never an edit
- [ ] 8.3 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 9. Gates and the archive handover

- [ ] 9.1 `openspec validate put-done-one-offs-last --strict` exits 0, and `pnpm run checks` is clean
- [ ] 9.2 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` passing, its count read off the run
- [ ] 9.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 9.4 **The implementer ticks this box in its last commit before the archive**, on the evidence that every other box is ticked — 8.1 and W.5 by the conductor — and the walk comment's URL is in W.6. The janitor then runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, and checks afterwards that `openspec/specs/one-off/spec.md` lost "One-offs answer the one-offs standing on a day, earliest owed first" and gained this delta's three added requirements, that `openspec/specs/day-screen/spec.md`'s one MODIFIED requirement is whole, and that no other spec file moved. **Any drift is a stop and a report, never a hand-edit.**

## The walk

Today holds three one-offs: "Call mum" owed three days ago, "Send form" owed today, and "Pay fine" owed five days ago and ticked today.

- [ ] W.1 Before any tick — "Call mum" saying "3 days late", then "Send form", then "Pay fine" grey, struck through, with the green check.
- [ ] W.2 "Call mum" ticked — "Send form", then "Call mum" struck through, then "Pay fine" struck through.
- [ ] W.3 "Send form" ticked — "Send form", "Call mum" and "Pay fine", all three struck through, in that order.
- [ ] W.4 "Call mum"'s tick taken back — "Call mum" saying "3 days late" first again, above "Send form" and "Pay fine", both struck through.
- [ ] W.5 phone: tick a one-off above a done one and take the tick back — the row slides down to just below the last one owed and back up, and can be followed with the eye both ways.
- [ ] W.6 **The handover** — W.1–W.4, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL. W.5 is the human's at G7; the conductor ticks it on the G7 approval.
