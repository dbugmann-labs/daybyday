## Context

`proposal.md` § *Why* says what this is for; `grill.md`'s four settled answers are what the delta is
written on, and the two record surveys under `docs/research/2026-09-09-concise-specs/` are what it is
written from. Measured on this branch:

- `openspec/specs/record/spec.md` is 2,235 lines — 17 requirements and 170 scenarios — carrying 9,244
  words of requirement prose, which the surveys split 53% normative, 31% rationale, 16%
  cross-reference or restatement.
- Sixteen of the seventeen requirements are over the 150-word prose budget; *A tick can be taken
  back*, at 129 words, is the one already inside it.
- No scenario carries prose: all 170 are `WHEN`/`THEN`/`AND` bullets, so the whole saving is in
  requirement prose.
- `survey-record.md` covers requirements 1–15 under its own numbers; `survey-2026-09-10-record.md`
  re-baselines requirement 5 as block 1 and covers requirements 16 and 17 as blocks 2 and 3,
  superseding the first wherever they overlap.
- All 170 scenario titles appear verbatim in `RecordTests.swift` and `RecordStoreTests.swift`, and
  every one of those tests passes today.

## Goals / Non-Goals

**Goals:** every rule the surveys list under *Rules at risk* stated once, as a SHALL/MUST sentence, in
the one requirement it belongs to; every requirement inside the 40–150 word budget, or split until it
is, or disclosed below; every piece of rationale with no ADR home homed before the sentence carrying
it goes.

**Non-Goals:** no scenario added, renamed, merged or dropped and no scenario body touched; no
behaviour change, no test change, nothing under `src/`; no other capability — `commitment`,
`day-screen` and `schedule` are surveyed and are their own Stories.

## Decisions

### The seam

**None, and that is what this Story is.** ADR-1047 decision 2: an editorial Story's delta rewrites
prose, changes no behaviour and changes no test, so there is no new or changed member for an
acceptance test to attach to, and rule 3's red-green loop is moot. `docs/process.md` § 9's Definition
of Ready asks for a seam **or** for `design.md` to state that no test changes and why, which is this
paragraph. Every scenario in the delta is already driven at a seam that ships — `Tick`, `Number`,
`Note`, `Addition`, `History` and `RecordStore` — by a test carrying its title verbatim, and every one
of those tests goes on passing untouched. Fidelity is judged instead against the surveys' *Rules at
risk* lists, which is what `tasks.md` gives a box per requirement and what `reviewer` reads at G7.

### Rationale is homed before the prose carrying it is deleted

Grill answer 1. Rationale one of the nine ADRs already records is deleted; of the six pieces with no
home, three are written down first, one dated paragraph each. **Text is kept in the exact form it was
typed in → ADR-1032**, which already makes that promise for numbers digit for digit: a sentence
rewritten on the way to disk is the same failure one place on. **A carry-over refuses on a
collision rather than merging → ADR-1023**, which states the all-or-none refusal but never weighs
merging against refusing. **A part is judged against the form it was first written at → ADR-1031**,
whose amendments cover a further form and not this; the rule stays normative, because three refusal
scenarios rest on it, and only the argument goes. The other three need no ADR: the target that is a
floor keeps one sentence in requirement 3 and loses its restatement in 13, the five "false record"
copies are `CONTEXT.md` § *Product principles*, and the note on why a reader gives back a value is
dropped as a shape rather than a rule.

### Every rule survives as a sentence, and this Story adds no scenario

Grill answer 2. The seven rules the surveys find with no scenario are kept as bare SHALL/MUST
sentences rather than deleted or tested: deleting one changes behaviour by omission, and writing a
scenario for one adds a test, which an editorial Story may not do. § *Open Questions* lists all seven
as knowingly untested. Several are the absence of a surface — no way to take back an addition by
naming its amount, no method giving out a day's additions — and cannot be put in `WHEN`/`THEN` form
at all, so the later Story that covers them will need a different kind of assertion for those.

### Two requirements split, and REMOVED plus ADDED is the mechanism

Grill answer 3. *A store reads a history kept before a commitment carried a kind* (837 prose words, 13
scenarios) and *A store keeps a history at a place, across the app being closed and opened again* (958
words, 29) each wear one heading over two requirements, and neither reaches 150 words without losing a
rule a test reads. The first becomes *A store reads every form it has written* (5 scenarios) and *Each
earlier form is read as the record it always was* (8); the second becomes *A store keeps what it is
given before it reports it kept* (19) and *A store persists each kind of record as exactly what it is*
(10). Each is one `## REMOVED Requirements` heading with a one-line Reason and Migration plus two
`## ADDED Requirements`, every scenario title going verbatim to the half it belongs to and none
duplicated. ADR-1047 records the mechanism as tried and accepted and #201 shipped it on three
requirements; the added halves land at the end of the spec file, which nothing reads.

### Overruns the budget

Measured, eight requirements are over 150 prose words: rule 1 outranks the cap, as ADR-1047 allows.

- *A history answers whether a commitment was kept on a day from the ticks it holds* — 304; four record kinds' keeping rules, the total-and-target rules, the comparison direction and the isolation rules, across 20 scenarios.
- *A store that cannot be read is refused rather than emptied* — 282; the refusal contract, the enumerated list of what cannot be a record, and the per-addition re-forming rule with its `day-screen` exclusion.
- *A history answers what a commitment has added on a day from the additions it holds* — 219; nine distinct rules, from order and accumulate-not-replace through zero-is-a-true-answer to sum-not-the-list.
- *A number is of a number commitment on a calendar date it is due on* — 208; two refusal families, the four range rules, the not-a-number rule and the three-part identity, each separately tested.
- *A note is of a note commitment on a calendar date it is due on* — 171; the two refusal families, the blank-space test with both prohibitions against accepting or substituting, and the kept-exactly-as-given rule.
- *An addition is of a total commitment on a calendar date it is due on* — 168; the three-part shape with its carries-nothing-else closure, the refusals of zero, of below zero and of a non-number with their two prohibitions, and the no-ceiling exclusion.
- *A store persists each kind of record as exactly what it is* — 167; the fidelity half of the requirement-5 split: four persistence shapes, three fidelity standards, four prohibitions, addition order.
- *The last addition a day holds can be taken back* — 167; eleven rules, including the three take-back prohibitions and "as though it had never been made" with its three consequences, each now its own SHALL.

## Risks / Trade-offs

- **A dropped rule is invisible to every check.** The tests pass whatever the prose says, so nothing
  but a reader catches a rule that went out with its paragraph. → One `tasks.md` box per requirement,
  ticked against that requirement's *Rules at risk* list, and the same list is the reviewer's fidelity
  axis at G7.
- **Two surveys disagree about requirement 5 and about the file's line numbers.** The older one was
  written against a 2,076-line file and one requirement has gained a sentence since. → The
  2026-09-10 survey supersedes it wherever they overlap, and every box in `tasks.md` names which
  survey it reads. Where that survey disagrees with itself, its § 5 prose was right to list
  requirement 15 among the over-budget requirements and its table row's ~140-word estimate was
  wrong: the rewritten requirement measures 167.
- **A split turns one heading into four blocks**, so a rule the old prose stated once can be dropped
  twice, each half taking it for the other's. → The scenario allocation is fixed above and in
  `grill.md`, and box 2.1 and box 2.5 name what each split must still carry.
- **Splitting moves two requirements to the end of the spec at archive time**, so the archived file's
  order is not today's. Nothing reads that order and no scenario title moves.

## Open Questions

**Seven rules stay knowingly untested**, each a SHALL/MUST sentence with no scenario; one backlog want
files them for a later behaviour Story. Nothing else is open, and no residual round came out of this.

- a day's sum is compared against the target, in that order and never the reverse
- a non-default kind round-trips through a store as the kind it is
- a store persists no day's sum, which is derived from the additions
- a history gives out the sum and never the additions themselves
- the three take-back prohibitions: only the last, none by amount, none clearing a day at once
- a carry-over adds no key, no field and no version to what a record is on disk
- an addition carries no position of its own among the additions of its day
