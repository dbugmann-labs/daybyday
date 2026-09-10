## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): `openspec validate` refusing the split, the archiver refusing a scenario, a rebase
conflict in this folder or in `openspec/specs/`.

**Every box in § 2 asks the same three things of one requirement**, and is ticked only when all
three hold: every *Rules at risk* sentence the surveys list for it is a SHALL/MUST sentence in the
rewritten prose; every scenario under it is byte-for-byte what it is today, title and body; and its
prose is 40–150 words, or is one of those `design.md` § *Overruns the budget* lists with the reason
it carries. A clause after a heading is the trap that requirement carries and nothing more — the
three things are still what the tick means. Where the surveys list no *Rules at risk* sentence for a
requirement, the first of the three is met by there being none.

**Where each requirement's *Rules at risk* list is**, both under
`docs/research/2026-09-09-concise-specs/`: `survey-record.md` § 1 for boxes 2.1–2.15, under its own
numbers 1–15, which carry an entry for 1, 2, 3, 5, 6, 7, 10, 13, 14 and 15 and none for the rest;
and `survey-2026-09-10-record.md` § 2 for boxes 2.5, 2.16 and 2.17, under its blocks 1–3. The second
supersedes the first for box 2.5, whose prose has gained a sentence since the first was written.

## 2. `record` — one box per requirement, in spec order

- [ ] 2.1 *A store reads a history kept before a commitment carried a kind* — **splits in two**, the reading mechanism against what each earlier form means; the rule that a part is judged against the form it was first written at stays normative, because three refusal scenarios rest on it, and only its argument goes to ADR-1031
- [ ] 2.2 *A tick is of a commitment on a calendar date it is due on* — the "false record this product exists to remove" sentence goes; the refusal it sits beside is already normative and stays
- [ ] 2.3 *A history answers whether a commitment was kept on a day from the ticks it holds* — holds the only statement of two rules: the sum is compared against the target in that order and never the reverse, and a target is a floor a day must reach and never a ceiling
- [ ] 2.4 *A tick can be taken back* — already inside the budget at 129 words; only ADR-1033's by-name rationale goes
- [ ] 2.5 *A store keeps a history at a place, across the app being closed and opened again* — **splits in two**, durability against what a store persists per record kind; keep kind-as-persisted, the prohibition on persisting a day's sum, text kept in the exact form it was typed in, and the sentence extending write-before-report to a carry-over
- [ ] 2.6 *A store that cannot be read is refused rather than emptied* — keep the exclusion that what a day's additions may sum to is `day-screen`'s cap and not this capability's; a scenario depends on it
- [ ] 2.7 *A number is of a number commitment on a calendar date it is due on* — keep the refusal of a not-a-number value at formation; the asymmetry argument behind it is ADR-1032's
- [ ] 2.8 *A history answers what number a commitment has on a day from the numbers it holds* — "a record nothing can read back is not a record" goes outright, homed nowhere
- [ ] 2.9 *A number can be taken back* — taking back names the commitment and the date and never the value; the argument is ADR-1033's
- [ ] 2.10 *A note is of a note commitment on a calendar date it is due on* — blank is one test asked in one way (ADR-1039) keeps its rule and its reference; the exact-Unicode-form rule stays as a sentence and its argument moves to ADR-1032
- [ ] 2.11 *A history answers what note a commitment has on a day from the notes it holds* — see 2.8
- [ ] 2.12 *A note can be taken back* — see 2.9
- [ ] 2.13 *An addition is of a total commitment on a calendar date it is due on* — keep the rule that an addition carries no position of its own among its day's additions; the target restatement goes, 2.3 holds it, and so does the defence of the `day-screen` cap
- [ ] 2.14 *A history answers what a commitment has added on a day from the additions it holds* — keep the surface rule that a history gives out the sum and never the additions themselves
- [ ] 2.15 *The last addition a day holds can be taken back* — keep all three prohibitions: only the last goes, none by naming its amount, and none clearing a day's additions in one act
- [ ] 2.16 *A history carries every record of one commitment over to another* — keep the all-or-none refusal and the sentence about the clock and the due date; "carrying over is not merging" goes to ADR-1023
- [ ] 2.17 *A store carries every record of one commitment over to another, at its place* — holds the most losable rule in scope: a carry-over adds no key, no field and no version to what a record is on disk, and no test would miss it

## 3. The gates

- [ ] 3.1 `openspec validate condense-record-spec --strict` exits 0.
- [ ] 3.2 `pnpm run check:scenarios` exits 0 — every scenario title in the delta still names a test
      that exists, which is what "byte-for-byte" means mechanically.
- [ ] 3.3 `pnpm run check:budgets` reports no requirement over 150 words except the ones
      `design.md` § *Overruns the budget* lists, and no artifact over its own budget.
- [ ] 3.4 `swift test` in `src/DayByDayKit` passes and reports the same number of tests as it does
      on `main` — read off both runs, never derived — because this Story touches no test file.
- [ ] 3.5 **The archive handover — `implementer` ticks this in its last commit before the archive**,
      on the evidence that 3.1–3.4 are ticked and that the instruction below is written here for the
      janitor to carry out. The janitor runs `/opsx:archive`, then reads the spec diff it produced:
      `openspec/specs/record/spec.md` must differ in requirement prose only, with every
      `#### Scenario:` title and body unchanged, and with the two split requirements gone from their
      old places and their four replacements at the end of the file. **Any other drift is a stop and
      a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json`
      denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached
      afterwards.
