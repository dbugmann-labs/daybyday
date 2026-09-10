## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): `openspec validate` refusing the split, the archiver refusing a scenario, a rebase conflict
in this folder, in `docs/adr/README.md` or in `openspec/specs/`.

**Every box in § 2 asks the same three things of one requirement**, and reads as: its *Rules at risk*
sentences are SHALL/MUST sentences in the rewrite, its scenarios are byte-for-byte what they are
today in title and body, and its prose is 40–150 words or is one of the requirements `design.md`
§ *Overruns the budget* lists with the reason it carries. A clause after a heading is the trap that
requirement carries and nothing more — the three things are still what the tick means.

**Where each requirement's *Rules at risk* list is**, all under
`docs/research/2026-09-09-concise-specs/`: `survey-commitment-A.md` for boxes 2.1–2.18 under its own
numbers 1–18; `survey-commitment-B.md` for boxes 2.19–2.26 under its numbers 19–26 and for boxes
2.27–2.34 under its numbers 28–36 (its 27 covers a heading the spec no longer has);
`survey-2026-09-10-commitment-modified.md` for boxes 2.1, 2.8, 2.9, 2.12, 2.14, 2.15, 2.17, 2.20,
2.24, 2.25, 2.26 and 2.34 under its blocks 1–12; and `survey-2026-09-10-commitment-added.md` for
boxes 2.35–2.41 under its blocks 1–7. The 2026-09-10 pair supersedes A and B by title wherever they
overlap, and B's 34 is superseded by the added survey's block 6, which is box 2.40.

## 2. `commitment` — one box per requirement, in spec order

- [ ] 2.1 *A commitment is a name, a schedule, and the day it is kept from* — 39% of its prose is
      cross-reference and restatement; the rules it defers to are stated where they live
- [ ] 2.2 *A commitment's name says something* — blank is ADR-1039's one test, cited not restated
- [ ] 2.3 *A commitment's kind is a tick, a number, a note or a total* — a kind never changes, and
      ADR-1030 carries why
- [ ] 2.4 *A range is a lowest and a highest, and the lowest is not above the highest* — the
      refuse-rather-than-adjust argument is dropped; the MUST NOT sentences stay as they are
- [ ] 2.5 *A target is a number above zero* — see 2.4
- [ ] 2.6 *A commitment is due exactly when its schedule is due, on and after the day it is kept from*
- [ ] 2.7 *A commitment is not due before the day it is kept from* — keep the sentence that the floor
      does not shift the schedule's own start date or phase
- [ ] 2.8 *A roster holds the commitments a person keeps, in the order they were taken on* — keep
      that neither a changed nor a superseded commitment gains a fifth part and no link is held
- [ ] 2.9 *A roster refuses a commitment it already holds* — **not split**, over budget; keep that a
      target is compared by whole value exactly as a range is
- [ ] 2.10 *A roster stops keeping a commitment, on the day it was kept until*
- [ ] 2.11 *A roster answers which commitments it had not stopped keeping on a calendar date*
- [ ] 2.12 *A roster store keeps a roster at a place, across the app being closed and opened again* —
      **not split**, over budget; the MUST NOT write groups stays and its argument is ADR-1038's; a
      quarter of the prose re-enumerates refusals 2.9, 2.10 and the move requirements own
- [ ] 2.13 *A roster store reads a roster kept before a commitment carried a kind* — ADR-1031 says
      which forms are read; keep every sentence about what each form reads back as
- [ ] 2.14 *A roster store that cannot be read is refused rather than emptied* — the argument is
      ADR-1035's now; keep all three MUST NOTs and the four things that could not be a roster
- [ ] 2.15 *A commitments screen lists the commitments its roster keeps, in the order they were taken
      on* — holds one of the two knowingly-false scenario titles; its bookkeeping paragraph goes
- [ ] 2.16 *A commitments screen lists what has been stopped, beside what it keeps* — the "would
      double the structure of the screen" argument is dropped; the flat-list MUST NOT stays
- [ ] 2.17 *A commitments screen defines a commitment from a name, a rhythm and the day it is kept
      from* — ignore-rather-than-refuse becomes ADR-1046's; keep the thirty-eight-digit bound, the
      zero-width-space rule, and that a held commitment offers no kind to a change
- [ ] 2.18 *A commitments screen refuses a name that says nothing, and a rhythm due on no day*
- [ ] 2.19 *A commitments screen refuses a rhythm number the calendar will not take* — 28% xref;
      2.41 defers to this for how two refusals are told apart, and must not restate it
- [ ] 2.20 *A commitments screen tells a commitment it already keeps apart from a roster it could not
      write* — keep that the already-holds-it refusal covers all three states, not only kept
- [ ] 2.21 *A commitments screen asks you to confirm before it stops keeping a commitment* — holds
      the second knowingly-false scenario title; its bookkeeping paragraph goes
- [ ] 2.22 *A commitments screen takes a stopped commitment up again in one tap* — the category comes
      back with it, which 2.40 relies on
- [ ] 2.23 *A commitments screen keeps its roster at the place a day screen keeps its, and reads it
      again when the app is shown* — the `Application Support` argument is ADR-1017's
- [ ] 2.24 *A commitments screen that cannot read its roster lists nothing and changes nothing*
- [ ] 2.25 *A commitments screen holds the change it refused and why, one at a time* — the seven
      kinds are counted here and numbered nowhere else: keep that rule as a SHALL, and ADR-1049
      carries its argument. No other box may name a kind by its position
- [ ] 2.26 *What a commitments screen holds about a refused change lasts until the app is shown again
      or a change is kept* — one act, one outcome stays as a rule; its argument is ADR-1038's
- [ ] 2.27 *A roster removes a commitment it holds, and never lets it go* — ADR-1035 carries why
- [ ] 2.28 *A commitments screen removes a commitment only when its name is typed back*
- [ ] 2.29 *A roster moves a commitment among the ones it keeps*
- [ ] 2.30 *A commitments screen moves a commitment among the ones it keeps* — defers to 2.29 in one
      clause rather than restating what a move is
- [ ] 2.31 *A roster puts a commitment under a category* — keep the same-word rule in both halves;
      only its identity half has a scenario. ADR-1038 carries why a category is the roster's
- [ ] 2.32 *A roster reads the commitments it is keeping in groups, one per category*
- [ ] 2.33 *A roster moves a group among the groups it is keeping* — keep the "whatever state that
      last commitment is in" qualifier; ADR-1044 records it as previously mis-implemented
- [ ] 2.34 *A commitments screen moves a group among the groups it draws* — a refused group move
      names the category, not one of its commitments
- [ ] 2.35 *A roster answers the earliest day anything it holds has been kept from* — the aggregate
      argument becomes ADR-1048's; keep that nothing raises the answer and that it consults no
      present moment, time zone or locale
- [ ] 2.36 *A roster changes a commitment it holds for another, in the place it holds it* — keep that
      a roster holds no records and carries none over
- [ ] 2.37 *A roster supersedes a commitment it is keeping with another, from a day* — keep the
      supported-range ends and that no link is held to the commitment that replaces it
- [ ] 2.38 *A commitments screen says what a commitment it is asked to change is made of* — the
      every-control rule is kept as the *Rules at risk* sentence it is, and the sentence four lines
      on that contradicted it is cut as a restatement of ADR-1022's rule; `design.md` § *Risks /
      Trade-offs* carries why
- [ ] 2.39 *A commitments screen changes a commitment on either of its lists* — **splits in two**,
      which act a change performs against what a change is refused for; every scenario title goes
      verbatim to the half it belongs to. The record place is written before the roster place stays
      as a SHALL in the acts half, and ADR-1049 carries its argument
- [ ] 2.40 *A commitments screen offers the categories in use* — the offering-as-safety argument
      becomes ADR-1038's; the MUST NOT fold case and MUST NOT match loosely stay
- [ ] 2.41 *A commitments screen refuses a range that is not a range, and a target that is not a
      target* — half-a-range and ignore-rather-than-refuse become ADR-1046's; keep both refusals,
      the both-ends-blank exclusion, and the clause deferring to 2.19 rather than restating it

## 3. The gates

- [ ] 3.1 `openspec validate condense-commitment-spec --strict` exits 0.
- [ ] 3.2 `pnpm run check:scenarios` exits 0 — every scenario title in the delta still names a test
      that exists, which is what "byte-for-byte" means mechanically.
- [ ] 3.3 `pnpm run check:budgets` reports no requirement over 150 words except the thirty-one
      `design.md` § *Overruns the budget* lists, and no artifact over its budget except `design.md`,
      which that section says is over and why.
- [ ] 3.4 `pnpm run verify` passes.
- [ ] 3.5 `swift test` in `src/DayByDayKit` passes and reports the same number of tests as it does on
      `main` — read off both runs, never derived — because this Story touches no test file.
- [ ] 3.6 **The archive handover — `implementer` ticks this in its last commit before the archive**,
      on the evidence that 3.1–3.5 are ticked and that the instruction below is written here for the
      janitor to carry out. The janitor runs `/opsx:archive`, then reads the spec diff it produced:
      `openspec/specs/commitment/spec.md` must differ in requirement prose only, with every
      `#### Scenario:` title and body unchanged, and with the split requirement gone from its old
      place and its two replacements at the end of the file. **Any other drift is a stop and a
      report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json`
      denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached
      afterwards.
