## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5). That covers a rebase conflict in this folder or in `openspec/specs/`, a scenario that
cannot be written as a test without changing its title, a new test that passes before the code it
names exists, a fix reaching outside the two files `proposal.md` § *Impact* names, and any other
test in the suite turning red.

Rule 3 governs §§ 3–4: take the next unticked box, write the one test named for it, watch it fail,
make it pass, then take the next. Every test goes in `RosterStoreTests.swift`, beside the shipped
fold tests. Nothing in `openspec/specs/` is edited here (rule 2), and no fixture is copied from
`~/Coding/daybyday-data/` — the fixtures below are synthesized from the two shapes that file holds.

## 2. The seam

- [x] 2.1 `RosterDocument.folded()` and `RosterStore.init(at:)` keep the signatures `design.md`
  § *The seam* gives, and 3.1 is red before the assembly changes

## 3. `commitment`: where a fold stands each commitment's eras — one test each

- [x] 3.1 a commitment's eras fold together though the stored roster held another commitment's entry between them — catches the roster assembled in the stored document's own index order
- [x] 3.2 an era the stored roster held in front of the commitment it belongs to folds behind it — catches an era left in front of its own newest era, which reads back as stopped and kept at once
- [x] 3.3 a folded roster whose stored entries were interleaved is read back whole after the next change is kept — catches a fold whose output only this app's memory accepts

## 4. `commitment`: what cannot be read as a roster store — one test each

- [x] 4.1 a roster store holding one commitment's eras split apart by another commitment's entry is refused — catches the store's adjacency guard relaxed instead of the fold fixed
- [x] 4.2 a roster kept before a commitment had an identity holding one era twice is refused — catches the same-era guard applied to a minted commitment but not to an entry attached as an era
- [x] 4.3 the MODIFIED requirement carries every other scenario unchanged, and its shipped acceptance tests stand as they are — no shipped test is renamed or rewritten here

## 5. The records

- [x] 5.1 `CONTEXT.md` § *Fold* still describes what shipped; a sentence that turns out wrong is a
  **stop and a G4 question**, never an edit slipped in
- [x] 5.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 6. The walk (ADR-1053)

No pictures are owed: nothing in `src/DayByDay/` changes and no screen draws anything new, so there
is no simulator run and no walk comment. The two lines below are the owner's, because their own
roster is the one input the suite cannot hold. Both are walked from the G7 stop; the
**`implementer` ticks them** in its last commit before the archive, on the owner's reply relayed by
the conductor, and a line the owner cannot confirm is a stop and a report, never a tick.

- [x] 6.1 `phone:` install this build over the one on the phone, open the app so the fold runs,
  remove one stopped commitment, force-quit and reopen — every commitment still listed, each under
  the rhythm and in the group it had
- [x] 6.2 `phone:` rename one commitment that has more than one era, force-quit and reopen — the new
  name on every era, the day kept from unchanged, and nothing gone from either list

## 7. Gates and the archive handover

- [x] 7.1 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` reporting every test
  passing, the count read off the run and not derived
- [x] 7.2 `openspec validate keep-a-folded-rosters-eras-together --strict` exits 0,
  `pnpm run check:scenarios` exits 0, and `pnpm run checks` is clean but for what it is expected to
  warn
- [x] 7.3 `git diff --stat origin/main` lists only this change folder, `RosterDocument.swift` and
  `RosterStoreTests.swift`
- [x] 7.4 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [x] 7.5 The **`implementer` ticks this box in its last commit before the archive**, on the
  evidence that every box above is ticked and that this instruction is here for the janitor. The
  janitor then runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, and
  reads the spec diff that produced: `openspec/specs/commitment/spec.md` gains one requirement and
  changes one — that one by a single clause and two scenarios, every other scenario of it
  unchanged. Nothing else in any spec may move. `pnpm run checks` runs after the archive commit
  exists. **Any drift is a stop and a report, never a hand-edit**: rule 2 denies
  `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a
  box left unticked here cannot be reached afterwards.
