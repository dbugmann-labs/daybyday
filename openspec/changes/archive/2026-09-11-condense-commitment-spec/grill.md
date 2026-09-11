# Grill — condense-commitment-spec (#204)

Held 2026-09-10 by the conductor with the owner, one round of four questions, every one answered
with the recommendation. The frontier was indexed from the four `commitment` surveys under
`docs/research/2026-09-09-concise-specs/` — `survey-commitment-A.md` (original requirements 1–18),
`survey-commitment-B.md` (19–36), and `survey-2026-09-10-commitment-modified.md` and
`survey-2026-09-10-commitment-added.md`, which supersede A and B by title wherever they overlap —
into `grill-frontier.md` beside this file: 11 pieces of rationale with no ADR home, 27 rules with
no scenario, 3 structural moves plus the ~20 requirements that will stay over budget. Every item
resolves under one of the four answers below.

The frontier was measured against the current file, not carried from the surveys: 41 requirements,
406 scenarios, 26,522 words of requirement prose, which matches the plan's figures exactly. Two
requirements A and B once covered no longer exist, so every heading is matched by title and never
by line number. **One survey claim did not hold up and is not carried**: survey B reads the
category same-word rule as untested, and the scenario *a category is held exactly as it was given,
blank space at its ends and all* covers its identity half.

## Settled

1. **The 27 rules with no scenario each survive as a bare SHALL/MUST sentence, and this Story adds
   no scenario.** It changes no test (ADR-1047), so deleting one would be behaviour change by
   omission and writing one a test this Story may not add. `design.md` § Open Questions lists the
   ones the surveys judge testable today as *knowingly untested*, and one backlog want captures
   them for a later behaviour Story. **One of the 27 is unlike the other 26 and is kept
   deliberately**: *the seven refusal kinds are counted here and nowhere else, and no other
   requirement may identify one by its position among them* is a rule about how the rest of this
   spec is written, untestable by any scenario in principle rather than merely untested today.

2. **Rationale with no ADR home is homed before the prose carrying it is deleted, by amending the
   nearest existing ADR with one paragraph each.** Nine of the eleven are load-bearing and are
   written down: the aggregate earliest-day question belonging to the roster rather than to any
   commitment → **ADR-1048**, which records `day-screen`'s picker consuming that answer but not why
   the roster owns the question; offering the categories in use rather than folding case →
   **ADR-1038**; half a range being its own refusal, and a value the chosen kind has no room for
   being ignored rather than refused → **ADR-1046**; one-act-one-outcome, the store not writing
   groups, and refuse-rather-than-empty → the nearest ADR `spec-author` judges (1038 and 1035 are
   the near ones; say which in `design.md`). **Two have no ADR near enough to take them without
   straining, and they share a subject** — the no-numbering rule for the seven refusal kinds, and
   the record place being written before the roster place — **so they get one new ADR, 1049**, on
   this capability's write and refusal discipline. 1048 is `condense-day-screen-spec`'s and 1050 is
   `condense-record-spec`'s; verify 1049 is free in `docs/adr/` and on no branch before writing it.
   **Two are dropped outright**: `stopped-list-not-grouped`'s unmeasured "would double the
   structure of the screen" claim, and `refuse-rather-than-adjust`, whose MUST NOT sentences in
   *A range is a lowest and a highest* and *A target is a number above zero* survive with no
   argument at all.

3. **One requirement splits, and the twenty-odd that stay over budget are named rather than
   divided.** *A commitments screen changes a commitment on either of its lists* (1,622 words, 21
   scenarios) becomes *which act a change performs* and *what a change is refused for* — the one
   division a survey actually designed. Mechanism: `## REMOVED Requirements` for the old heading
   with a Reason and a Migration, `## ADDED Requirements` for the two halves, **every scenario
   title carried verbatim** to the half it belongs to; no test moves and the added halves land at
   the end of the spec at archive time. **The other two big ones are not split**: *A roster store
   keeps a roster at a place* (1,123 words, 35 scenarios) and *A roster refuses a commitment it
   already holds* (1,464 words, 17) have no proposed division from any survey, and inventing a
   boundary for a 35-scenario requirement inside a rewrite the owner reads as one diff is design
   work nobody has done. They stay single, over budget, with the rule that keeps each one there
   named in `design.md` § *Overruns the budget* — and so do the roughly twenty further requirements
   the surveys project above 150 words after an honest rewrite, as a class. `condense-day-screen-spec`
   left 17 of 48 that way. If `openspec validate --strict` or the archiver refuses any of this,
   that is a rule-5 stop and a report, never a workaround.

4. **No scenario title changes and no scenario is dropped**, including the two ADR-1047 § decision 5
   already records as knowingly false — *two commitments alike in name and not in rhythm are two
   entries a person cannot tell apart* and *a commitment stopped through a commitments screen is
   kept until the day the screen was handed*. The two bookkeeping paragraphs that admit this (under
   *A commitments screen lists the commitments its roster keeps* and *A commitments screen asks you
   to confirm before it stops keeping a commitment*) are rationale this delta deletes; **ADR-1047
   needs no amendment**, because it cites both by title text and this Story adds no third. Scenario
   deduplication is phase 3 of the plan and is not this Story.

What follows from the plan and needs no answer: the delta carries every requirement in full, as
`## MODIFIED Requirements` plus the one REMOVED-and-two-ADDED split; `design.md` names no seam and
says why; the *Rules at risk* sections of the four surveys are the checklist each rewritten
requirement is verified against, and the reviewer's fidelity axis at G7; the 2026-09-10 pair
supersedes A and B wherever they overlap, and the correction above is not carried.

**Read before writing this delta**: `condense-day-screen-spec` (#201) ran this procedure first and
G7 found four defects in it that no mechanical check and no verification pass caught — a lost second
bound on a digit count, which made the spec refuse a number the code keeps; a cross-reference
deferring to "the eight answers" of a requirement that enumerates no eight; a `proposal.md` § Impact
naming a file the branch did not touch; and one requirement restating a rule its siblings correctly
dropped. **A cross-reference that names a count is a defect waiting to happen** — defer behaviour
for behaviour, with no number.

## Left open

None. Every frontier item is disposed of by one of the four settled answers. What remains — which
ADR is nearest for one-act-one-outcome, the store-must-not-write-groups corollary and
refuse-rather-than-empty; the two headings the split produces; the wording of every requirement —
is `spec-author`'s work, and the surveys give it line-level input. A question that only appears
while the delta is written goes to the owner as a residual round under `## Questions for you` in
`design.md`, before G4 and as a stop rather than a gate.

## Terms landed in CONTEXT.md

**None new.** The two terms this lane needs — **editorial Story** and **budget** — were landed in
`CONTEXT.md` § *Process vocabulary* by `condense-day-screen-spec` (#201) and are unchanged; the
split mechanism this Story uses is already inside the *editorial Story* entry. Every domain term
this grill touched (roster, roster store, commitments screen, category, group, range, target,
kept from, superseded) is already defined there. This Story introduces no product vocabulary,
because it introduces no behaviour.
