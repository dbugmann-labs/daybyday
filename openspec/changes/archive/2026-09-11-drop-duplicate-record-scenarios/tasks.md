## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): the archiver refusing a block, a keeper test that does not assert what `design.md` says it
does, a carried scenario that is not byte-for-byte what it is today but for the two lines § 5 names,
or a rebase conflict in this folder or in `openspec/specs/`.

This is a pruning Story: no test is written, and rule 3's loop has no red. Each § 2 box is one
deletion, ticked only once the keeper `design.md` names for it has been read and its own `#expect`
holds every value the deleted test asserted. The only other edits to `src/` are § 3's seven kept
tests and § 4's two doc comments. § 5 is one box per carried requirement rather than per scenario,
because no carried scenario has work of its own.

## 2. The sixteen deletions — one box per dropped scenario

- [x] 2.1 Delete `a tick is formed for a commitment on a date it is due on` from `RecordTests.swift` — its keeper forms the tick-kind commitment's tick
- [x] 2.2 Delete `a commitment ticked on a date was kept on that date` from `RecordTests.swift`
- [x] 2.3 Delete `a commitment ticked on one date was not kept on another date it is due on` from `RecordTests.swift`
- [x] 2.4 Delete `a commitment was not kept on a date it is not due on` from `RecordTests.swift` — the week keeper asks about Tuesday 1 September
- [x] 2.5 Delete `a number commitment with a number recorded on a date was kept on that date` from `RecordTests.swift`
- [x] 2.6 Delete `a note commitment with a note recorded on a date was kept on that date` from `RecordTests.swift`
- [x] 2.7 Delete `a tick taken back leaves the commitment not kept on that date` from `RecordTests.swift`
- [x] 2.8 Delete `a number added to a history is the number that commitment has on that day` from `RecordTests.swift`
- [x] 2.9 Delete `a note is recorded for a note commitment on a date it is due on` from `RecordTests.swift`
- [x] 2.10 Delete `a note added to a history is the note that commitment has on that day` from `RecordTests.swift`
- [x] 2.11 Delete `an addition is recorded for a total commitment on a date it is due on` from `RecordTests.swift`
- [x] 2.12 Delete `an addition added to a history is the total that commitment has on that day` from `RecordTests.swift`
- [x] 2.13 Delete `a tick added to a store is held by a second store opened at the same place while the first is still open` from `RecordStoreTests.swift` — its number, note and addition siblings stay
- [x] 2.14 Delete `a tick taken back is not held by a store opened afterwards at the same place` from `RecordStoreTests.swift`
- [x] 2.15 Delete `a number taken back is not held by a store opened afterwards at the same place` from `RecordStoreTests.swift` — the keeper is the ticks-and-numbers reopen, not the ticks-only one
- [x] 2.16 Delete `a note taken back is not held by a store opened afterwards at the same place` from `RecordStoreTests.swift` — the keeper is the ticks, numbers and notes reopen

## 3. The seven kept tests — one attempt each, settled one of two ways

Each box asks for an attempt, not a result: bring the test to its unchanged scenario's values, title
and every assertion kept. The attempt settles one of two ways. **Kept:** the test passes. **Withdrawn**
(grill item 11): it goes red, is put back as it is on `main`, and the red is reported as a stop; the
correction leaves this Story and the rest proceeds. The box is ticked once the attempt has settled
either way. The diff and the stop report show which way it went; the box does not.

- [x] 3.1 Try `a note added to a store is held by a second store opened at the same place while the first is still open` with the text "Ran 8k before work. Knee held up."
- [x] 3.2 Try `a day's last addition taken back is not held by a store opened afterwards at the same place` with 30 then 90, and a second take-back
- [x] 3.3 Try `a day's additions are read back in the order they were made` with 30, 45 and 50, not 45 and 30
- [x] 3.4 Try `a store whose shape and declared form disagree about numbers is refused` with form 5, carrying `"additions": []`
- [x] 3.5 Try `a store whose shape and declared form disagree about notes is refused` with form 5, carrying `"additions": []`
- [x] 3.6 Try `two histories holding the same numbers are the same history` with Wednesday 2 September 2026
- [x] 3.7 Try `two histories holding the same notes are the same history` with Wednesday 2 September 2026

## 4. The two doc comments — comment only

- [x] 4.1 `Note.swift`'s type doc comment names *A note is of a note commitment on a calendar date it is due on, and holds one text*
- [x] 4.2 `Addition.swift`'s type doc comment names *An addition is of a total commitment on a calendar date it is due on, and holds one amount*

## 5. The carried requirements — one box per requirement in the delta

Each is ticked when its prose and scenarios are byte-for-byte the current spec's but for what its
line names, and every test under it passes.

- [x] 5.1 *A history carries every record of one commitment over to another* — only the THEN line of `carrying over the records of a commitment that has none refuses nothing and changes nothing` differs; its test is untouched
- [x] 5.2 *A store carries every record of one commitment over to another, at its place* — only the THEN line of `a carry-over with nothing to carry keeps nothing at a store's place` differs; its test is untouched
- [x] 5.3 *A tick is of a commitment on a calendar date it is due on, and nothing else*
- [x] 5.4 *A history answers whether a commitment was kept on a day from the records it holds*
- [x] 5.5 *A tick a history holds can be taken back*
- [x] 5.6 *A history answers what number a commitment has on a calendar date from the numbers it holds*
- [x] 5.7 *A note is of a note commitment on a calendar date it is due on, and holds one text*
- [x] 5.8 *A history answers what note a commitment has on a calendar date from the notes it holds*
- [x] 5.9 *An addition is of a total commitment on a calendar date it is due on, and holds one amount*
- [x] 5.10 *A history answers what a commitment has added on a calendar date from the additions it holds*
- [x] 5.11 *A store keeps every change it is given before it reports it kept*

## 6. The gates

- [x] 6.1 `openspec validate drop-duplicate-record-scenarios --strict` exits 0.
- [x] 6.2 `pnpm run check:scenarios` exits 0 — every title the delta carries still names a test.
- [x] 6.3 None of the sixteen dropped titles is found under `src/`; `git diff --stat origin/main -- src/`
      lists only `RecordTests.swift`, `RecordStoreTests.swift`, `Note.swift` and `Addition.swift`; and
      every line the diff adds to `Note.swift` and `Addition.swift` is inside a doc comment.
- [x] 6.4 `pnpm run check:budgets` warns about nothing in this folder but the four requirements
      `design.md` names, and `pnpm run verify` passes.
- [x] 6.5 `swift test` in `src/DayByDayKit` passes and reports sixteen fewer tests than on `main`, both
      counts read off a run and never derived.
- [x] 6.6 **The archive handover — `implementer` ticks this in its last commit before the archive**,
      on the evidence that 2.1–6.5 are ticked and that the instruction below is written here for the
      janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of
      the sync it prints, then reads the spec diff it produced: in `openspec/specs/record/spec.md` the
      nine requirements of 5.3–5.11 leave their places and reappear after every other requirement, in
      that order, under their new headings; the sixteen dropped scenarios are gone; the two THEN lines
      of 5.1 and 5.2 are the delta's; and nothing else moves. `git status` after the archive commit
      shows the source folder's deletion committed with it, and `pnpm run checks` runs after that
      commit exists. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies
      `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a
      box left unticked here cannot be reached afterwards.
