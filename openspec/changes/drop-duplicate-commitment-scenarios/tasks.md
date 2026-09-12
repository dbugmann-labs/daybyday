## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): the archiver refusing a block, a keeper test that does not assert what `design.md` says it
does, a carried requirement that is not byte-for-byte what it is today but for its heading, or a
rebase conflict in this folder, in `docs/adr/` or in `openspec/specs/`.

This is a pruning Story: no test is written and no kept test is edited, so rule 3's loop has no red
and § 2 has no precondition step in front of it. Each § 2 box is ticked only once the keeper
`design.md` names for it has been read and its own `#expect` holds every value the deleted test
asserted. The only edits to `src/` are § 2's eight deletions. § 3 is one box per carried requirement
rather than per scenario, because no carried scenario has work of its own.

**Two traps, from grill item 16.** `swift test --filter` takes a test's **Swift function name**, not
its `@Test` display string — a display-string filter reports `0 tests ... passed`, which reads like
green. And every test span shifts as soon as anything above it goes, so locate each test by the
function name grill item 2 gives for it, or delete from the bottom of each file upward.

The two ADR edits `design.md` names are already in this folder's pull request, made with the delta;
4.4 checks them rather than asking for them.

## 2. The eight deletions — one box per dropped scenario

- [ ] 2.1 Delete `a commitment reads back the kind it was given` from `CommitmentTests.swift` — its keeper reads back all four kinds, the number kind among them
- [ ] 2.2 Delete `stopping a commitment a roster keeps says so and takes it out of the commitments read back` from `RosterTests.swift` — its keeper is the kept-until-before-kept-from test, not the leaves-the-others test, which discards what the roster reports
- [ ] 2.3 Delete `two commitments alike in name and not in rhythm are two entries a person cannot tell apart` from `CommitmentsScreenTests.swift` — the keeper's title is longer and its fixture identical; delete only the exact name
- [ ] 2.4 Delete `a commitment taken up again through a commitments screen is in the place it was taken on in` from `CommitmentsScreenTests.swift`
- [ ] 2.5 Delete `a commitments screen holds a refused stop against the commitment it was asked to stop` from `CommitmentsScreenTests.swift` — its keeper's setup is a strict superset and its `#expect`s are verbatim identical
- [ ] 2.6 Delete `a commitments screen that has been asked for no change holds no refused change` from `CommitmentsScreenTests.swift`
- [ ] 2.7 Delete `a commitment dropped among another group's entries is put under that group's category` from `CommitmentsScreenTests.swift` — every other drop-into-a-group test stays, including the one taking a category off
- [ ] 2.8 Delete `a commitments screen refuses a range whose lowest is above its highest` from `CommitmentsScreenTests.swift` — the refuses-a-range-end and refuses-one-end-blank tests stay

## 3. The carried requirements — one box per requirement in the delta

Each is ticked when its prose and scenarios are byte-for-byte the current spec's, its heading is the
delta's, and every test under it passes.

- [ ] 3.1 *A commitment's kind is exactly one of a tick, a number, a note or a total* — only the heading differs
- [ ] 3.2 *A roster stops keeping a commitment it holds, on the day it was kept until* — only the heading differs
- [ ] 3.3 *A commitments screen lists the commitments its roster keeps, in the order the roster answers with* — only the heading differs, and the scenario that once matched it word for word is carried unchanged
- [ ] 3.4 *A commitments screen takes a commitment it has stopped up again in one tap* — only the heading differs
- [ ] 3.5 *A commitments screen holds the change it refused and why it was refused, one at a time* — only the heading differs; this is the heading ADR-1049 cites
- [ ] 3.6 *A commitments screen moves a commitment among the ones it is keeping* — only the heading differs
- [ ] 3.7 *A commitments screen refuses to define a commitment whose range is not a range, or whose target is not a target* — only the heading differs

## 4. The gates

- [ ] 4.1 `openspec validate drop-duplicate-commitment-scenarios --strict` exits 0.
- [ ] 4.2 `pnpm run check:scenarios` exits 0 — every title the delta carries still names a test.
- [ ] 4.3 None of the eight dropped titles is found as an exact test name under `src/`, and
      `git diff --stat origin/main -- src/` lists only `CommitmentTests.swift`, `RosterTests.swift`
      and `CommitmentsScreenTests.swift`, with no line added under `src/` at all.
- [ ] 4.4 `git diff --stat origin/main -- docs/` lists only the two ADR files, and in them: 1047's
      decision 5 reads two false titles and its decision 6 carries the mutation discriminator;
      1049's § *Context* names 3.5's heading.
- [ ] 4.5 `pnpm run check:budgets` warns about nothing in this folder but the six requirements
      `design.md` § Context names, and `pnpm run verify` passes.
- [ ] 4.6 `swift test` in `src/DayByDayKit` passes and reports eight fewer tests than on `main`,
      both counts read off a run and never derived.
- [ ] 4.7 **The archive handover — `implementer` ticks this in its last commit before the archive**,
      on the evidence that 2.1–4.6 are ticked and that the instruction below is written here for the
      janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of
      the sync it prints, then reads the spec diff it produced: in `openspec/specs/commitment/spec.md`
      the seven requirements of 3.1–3.7 leave their places and reappear after every other
      requirement, in that order, under their new headings; the eight dropped scenarios are gone; and
      nothing else moves. After the archive commit, `git status` is clean and
      `openspec/changes/drop-duplicate-commitment-scenarios/` no longer exists, its deletion
      committed with the archive, and `pnpm run checks` runs after that commit exists. **Any other
      drift is a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and
      `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked
      here cannot be reached afterwards.
