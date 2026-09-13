# Rule coverage: a scenario for every rule that has none

**Read this before starting any of #221, #222, #223 or #224.** It is the handoff for the four
covering Stories accepted at G2 on 2026-09-12, at the seventh grooming pass. The tracking issue
is **#225**; this file holds what the pass settled, what each Story is walking into, and the
commands to start one. It carries no requirements — those are written at each Story's Stage 4,
in its own change folder (`AGENTS.md` rule 4).

It is the sequel to `docs/research/2026-09-09-concise-specs.md`, which condensed the four
capability specs and, in doing so, produced the four lists of rules nobody tests. Read that
file's § *Outcome, 2026-09-11* first if you have not.

## What the work is

The condensing Stories (#201, #204, #205, #208) each ended by naming the rules in their
capability that are **normative but untested** — a SHALL or a MUST NOT that no `#### Scenario:`
reaches. Forty-eight of them across four capabilities. The pruning Stories that followed
(#211, #214, #215, #216) then showed why that matters twice over: a rewrite dropped two MUST NOT
prohibitions and a closure sentence and every mechanical check passed, and a different rewrite
*introduced* a rule that a scenario in its own requirement disproves. A rule with no scenario is
a rule a later trim removes, and a rule nothing contradicts when it is written wrong.

Each Story gives its capability's uncovered rules a scenario each, and the test that goes with
it. No behaviour changes. Nothing in `src/DayByDay` or `DayByDayKit`'s sources moves.

## The lane

ADR-1047 defines two lanes for a Story that changes no behaviour, and **neither fits this work**:

- an **editorial Story** condenses a spec and changes no tests at all;
- a **pruning Story** deletes scenarios and their tests, and says in as many words that *no test
  is added*.

This is a third lane, and it needs recording. A **covering Story** adds scenarios to requirements
that already ship, adds the test named for each, changes no behaviour, and names the seam its
tests attach at. Its delta carries every requirement it touches in full, as the pruning Stories'
deltas do.

**A covering Story's tests are green the moment they are written.** The behaviour already ships,
so `AGENTS.md` rule 3's red step cannot happen in the ordinary way. That is accepted rather than
worked around — see the settled answers below — with exactly one exception, in #224.

## What the grill settled

Three rounds, twelve questions, 2026-09-12. The decisions a Story needs:

1. **No Feature, and no G1.** A Feature anchors on one capability spec and this spans four. The
   shape is #199's: an umbrella chore, one Story per capability, each reopening the Feature that
   passed G1 long ago. Accepted at G2.
2. **Tests are accepted green on arrival**, against the recommendation to prove each one by
   mutation. Write the test, run it, move on.
3. **The one exception is B-048's three tests**, in #224. Those are tests that *cannot* fail, so
   a rewrite of one is worth nothing without proof it now can. Mutate those three.
4. **Rules nothing can prove stay in their specs.** A rule enforced by the compiler, or an
   absence that a WHEN/THEN cannot assert, is not deleted. It keeps its place and is recorded.
5. **Each Story writes its own bullet** under `docs/open-questions.md` § *Known gaps*, naming its
   own capability's unprovable rules. One bullet per capability, never a shared list — two
   branches editing one list conflict on every rebase, which this repository already knows.
6. **Every list is re-derived at its own grill.** The archived lists were built for condensing,
   not for coverage. They are a starting hint. They are not the answer, and #224's in particular
   has a measured error rate.
7. **ADR-1047 is amended in place**, not superseded, per its own amendment rule.
8. **The change ids are `cover-<capability>-rules`**, the third member of the family beside
   `condense-<capability>-spec` and `drop-duplicate-<capability>-scenarios`.
9. **B-047, the reverse coverage check, lands after all four** as a chore — item 5 of #225. It
   binds CI and its allowlist of 117 deliberate orphans is unsettled, and nothing in the four
   needs it: every scenario they add arrives with a matching test, so none of them stresses the
   reverse direction.

## Sequencing

**The ADR amendment is the only thing any Story waits on**, and it does not have to be a Story
that writes it. ADR-1047 itself was written by a chore — `f6e1263`,
`chore(process): budget the change folder and the spec prose` (#200) — before a single one of the
eight condensing and pruning Stories started. The same move works here and it is the difference
between one Story then three, and four at once.

**Recommended.** Land the amendment as a chore, then run all four Stories concurrently:

```
chore: amend ADR-1047 with the covering lane
        │
        ├── #221 cover-schedule-rules      (schedule)
        ├── #222 cover-record-rules        (record)
        ├── #223 cover-day-screen-rules    (day-screen)
        └── #224 cover-commitment-rules    (commitment)
```

Four capabilities, four specs, four files — `docs/process.md` §7 permits concurrent Stories
outright while they target different capabilities, and these do. Nothing else couples them: no
Story reads another's delta, and each writes its own bullet under § *Known gaps*, so even that
file has no shared lines. **Adopting this means re-cutting the blocking edges**, which #221–#224
currently carry as accepted at G2; the tracker is the record and it says otherwise until an
`orchestrator` run changes it.

**As accepted at G2.** #221 first and alone, carrying the amendment, then #222, #223 and #224 in
parallel once it merges. One wave of one, then a wave of three. Nothing is wrong with it; it is
simply slower by one Story, and it puts the amendment behind a grill and two gates.

**Not recommended: starting all four with the amendment still inside #221.** Three Stories would
reach G4 citing an ADR that is not on `main`, and a G4 signature covers the folder as it stands —
if #221's grill moves the lane, three signed folders need a second approval. That is the expensive
version of the same parallelism the chore buys cleanly.

Whichever is chosen, **#221 is the one to start first**: schedule is much the lightest of the
four, so the lane gets proved where a mistake costs least. Its heaviest requirement is 69 lines
against #224's 397.

## The four Stories

Each brief names where its candidate list lives, what is known to be wrong with it, and what the
Story owes beyond the scenarios. **The counts are the archived lists' own and are not verified** —
re-deriving them is the first thing each grill does.

### #221 `cover-schedule-rules` — `schedule`, under `FEAT: schedule` (#6)

Lightest of the four. Twelve rules over ten requirements; the largest requirement is 69 lines.

- **Candidate list** — `openspec/changes/archive/2026-09-11-condense-schedule-spec/design.md`
  § *Open Questions*. Survey:
  `docs/research/2026-09-09-concise-specs/survey-schedule-cli.md`.
- **Trap** — the list is **one prose paragraph, not a list**, and it only counts to twelve if the
  clause about excluding the current time, the time zone and the locale is read as five separate
  rules, one per schedule shape. That reading is the right one — the Decisions section of the same
  file confirms five requirements each state it for their own answer — but it has to be made
  deliberately.
- **Unprovable** — at least one. *A calendar date's three numbers are not writable* is enforced by
  the compiler, and a WHEN/THEN cannot assert a `let`. It is the only one that file names as such
  in its own Open Questions.
- **Owes** — its § *Known gaps* bullet. Under the G2-accepted sequencing, also the ADR-1047
  amendment.

### #222 `cover-record-rules` — `record`, under `FEAT: record` (#53)

Seven rules over six requirements. Two of the seven share a requirement.

- **Candidate list** — `openspec/changes/archive/2026-09-11-condense-record-spec/design.md`
  § *Open Questions*. Surveys: `survey-record.md` and `survey-2026-09-10-record.md`, both under
  `docs/research/2026-09-09-concise-specs/`.
- **Trap** — **expect the highest proportion of unprovable rules of the four.** *A store persists
  no day's sum*, *a history gives out the sum and never the additions themselves*, and two of the
  three take-back prohibitions are **absences** — the lack of a surface — and a WHEN/THEN cannot
  assert that something was never offered. That language sits in the Decisions section rather than
  in Open Questions, so reading only the list understates it.
- **Owes** — its § *Known gaps* bullet.

### #223 `cover-day-screen-rules` — `day-screen`, under `FEAT: day-screen` (#27)

Eight rules over eight requirements — the only one of the four where every rule lands under a
different requirement.

- **Candidate list** — `openspec/changes/archive/2026-09-10-condense-day-screen-spec/design.md`
  § *Open Questions*. Survey:
  `docs/research/2026-09-09-concise-specs/survey-2026-09-10-day-screen.md`.
- **Trap** — **the two untestable-by-construction rules are not in that list.** `docs/backlog.md`
  B-044 named them, from survey blocks 8 and 14, and that design.md's Open Questions never
  mentions them. Whether they join the eight is the grill's to decide, and it will not be prompted
  by the file.
- **Owes** — its § *Known gaps* bullet.

### #224 `cover-commitment-rules` — `commitment`, under `FEAT: commitment` (#26)

The heavy one. Twenty-one rules over fourteen requirements, three of which are 397, 222 and 220
lines, and the delta carries each touched requirement in full. Taken as one Story against the
recommendation to split it down the middle into roster-side and screen-side; that decision was
reaffirmed and is made.

- **Candidate list** — `openspec/changes/archive/2026-09-11-condense-commitment-spec/design.md`
  § *Open Questions*. Surveys: `survey-commitment-A.md`, `survey-commitment-B.md`,
  `survey-2026-09-10-commitment-modified.md` and `survey-2026-09-10-commitment-added.md`, all
  under `docs/research/2026-09-09-concise-specs/`.
- **Trap — this list has been wrong five times.** Four are recorded in B-044's sibling entry: two
  entries had scenarios already, one was tested in the half it claimed was not, and one named a
  rule the spec does not state at all. The fifth was found on 2026-09-12: **that design.md's
  Decisions section says "the twenty-two testable today are listed under § Open Questions" and
  that section lists twenty-one.** Re-derive every one against
  `openspec/specs/commitment/spec.md` before writing a test for it.
- **A twenty-second rule, verified 2026-09-12 and not in the archived list.** *A commitments
  screen that cannot read its roster lists nothing and changes nothing*
  (`openspec/specs/commitment/spec.md`) names five verbs in its prose — stop keeping, take up
  again, remove, move, change — and only three have a scenario. **Stop keeping** and **take one up
  again** have none. Found at #216's frontier; #216 dropped no scenario of that requirement, so it
  owed the gap no delta.
- **Unprovable** — at least one: no requirement may identify a refusal by its position among the
  seven kinds. That is a rule about how the spec is written and is half of ADR-1049. Note it is
  *not* among the twenty-one — the same design.md's Decisions section puts it among five it
  excluded — so it arrives from the backlog rather than from the list.
- **Also owes B-048: three tests that cannot fail.** These are the one place in all four Stories
  where mutation is required, and each has a known mutation that exposes it:
  - the four *a change that leaves the roster as it was keeps nothing at its place* tests stay
    green when all four `if nextRoster != roster` guards are removed from `RosterStore` — `write`
    is byte-stable, so rewriting an unchanged roster is byte-identical. With the guards gone the
    whole suite passed, so nothing covers that sentence of the rule.
  - the *stopping* and *removing a commitment leaves every earlier date answering as it did* pair
    discard the `Bool` their mutator returns, so making `retire` or `remove` a no-op leaves both
    green.
  - *a commitment taken up again through a commitments screen moves from what it has stopped to
    what it keeps* cannot tell "its own place" from "the front of the list": mutating
    `Roster.addTakingUpAgain` to remove-and-insert-at-0 leaves it green. The rule stays pinned at
    roster level by *a commitment taken up again keeps the place it was taken on in*, which the
    same mutation reddens.
- **Owes** — its § *Known gaps* bullet, and the three fixes above with their mutations run.

## How mutation is run here

There is no mutation tool in this repository and none is being added. The procedure the pruning
Stories used, and the one #224 inherits: build a disposable tree with `git archive HEAD`, hand-edit
the one statement or guard on the shared code path, run the test against that copy, record whether
it reddens, discard the tree. **Never in a worktree and never committed** — #216 ran 48 mutations
this way over four passes and the working tree was never touched.

## Starting one

Every branch is worked in its own worktree (`AGENTS.md` rule 8). `pnpm run status` prints the
exact command for each open Story; these are those commands, and each ends ready to work:

```bash
# #221 — schedule
git fetch origin && git worktree add ../daybyday-cover-schedule-rules -b story/221-cover-schedule-rules origin/main && cd ../daybyday-cover-schedule-rules && git branch --unset-upstream && pnpm install

# #222 — record
git fetch origin && git worktree add ../daybyday-cover-record-rules -b story/222-cover-record-rules origin/main && cd ../daybyday-cover-record-rules && git branch --unset-upstream && pnpm install

# #223 — day-screen
git fetch origin && git worktree add ../daybyday-cover-day-screen-rules -b story/223-cover-day-screen-rules origin/main && cd ../daybyday-cover-day-screen-rules && git branch --unset-upstream && pnpm install

# #224 — commitment
git fetch origin && git worktree add ../daybyday-cover-commitment-rules -b story/224-cover-commitment-rules origin/main && cd ../daybyday-cover-commitment-rules && git branch --unset-upstream && pnpm install
```

Then, in a fresh session started in that worktree, `/atlas grill <issue#>` — the first step of
Stage 4. The conductor runs the grill in rounds, writes `grill.md` into the change folder it
creates, and spawns `spec-author`. From there to G7 runs unattended.

A non-interactive shell has neither Node nor pnpm on `PATH` and defaults to Node 20, where the
test run fails at startup with an error naming neither. Open every Bash session with the export
block in `AGENTS.md` § *This machine*.
