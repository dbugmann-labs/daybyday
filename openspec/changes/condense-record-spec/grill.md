# Grill — condense-record-spec (#205)

Held 2026-09-10 by the conductor with the owner, one round of four questions, every one answered
with the recommendation. The frontier was indexed from the two `record` surveys under
`docs/research/2026-09-09-concise-specs/` (`survey-record.md`, and `survey-2026-09-10-record.md`,
which supersedes it wherever they overlap — the first survey's line numbers are stale, so entries
are matched by requirement title) into `grill-frontier.md` beside this file: 6 pieces of rationale
with no ADR home, 7 rules with no scenario, 3 structural items. Every item resolves under one of
the four answers below. The frontier's measurement table was computed against the spec file rather
than copied from either survey and agrees with both: 17 requirements, 170 scenarios, 9,244 words of
requirement prose.

## Settled

1. **Each of the six pieces of rationale with no ADR home is homed in the nearest existing record
   before its prose is deleted, and dropped where nothing is near and no rule is at stake.** A1,
   note and text fidelity kept in the exact Unicode form it was typed in → one paragraph amending
   ADR-1032, extending its digit-for-digit fidelity to text. A2, a carry-over refuses on collision
   rather than merging → one paragraph amending ADR-1023, which states the all-or-none refusal but
   never weighs merge against refuse. A3, a part is judged against the form it was **first written
   at** and never the newest → one paragraph amending ADR-1031; **the rule itself stays in the
   requirement as a normative sentence**, because two of req 1's refusal scenarios rest on it, and
   only the "silently re-declare" argument goes. A4, a target is a floor a day must reach and never
   a ceiling → no ADR is near (ADR-1045 is about marking a target on screen, not its meaning); kept
   as one normative sentence in requirement 3, and its restatement in requirement 13 dropped as the
   file's clearest duplicate. A5, the five variants of "a false record of the sort this product
   exists to remove" → already in `CONTEXT.md` § *Product principles*, so all five spec copies are
   dropped; the refusal each sits beside is already normative. A6, "a record nothing can read back
   is not a record" → explains a reader's shape rather than asserting a rule, dropped outright.
   **No new ADR**: ADR-1050 stays free.

2. **The seven rules with no scenario each survive as a bare SHALL/MUST sentence, and this Story
   adds no scenario and no test** (ADR-1047 decision 2). They are: the comparison-direction rule for
   `Decimal` NaN (sum against target, never the reverse); kind-as-persisted; "a store MUST NOT
   persist the day's sum"; a history gives out the sum and not the additions; the three take-back
   prohibitions (only the last goes, none by naming its amount, none clearing a day in one act);
   "the form on disk does not move" for a carry-over — which the survey calls the most losable rule
   in scope, since no test would miss it; and an addition carrying no position of its own.
   `design.md` § Open Questions lists them as knowingly untested, one line each, and one backlog
   want captures them for a later behaviour Story. Several cannot be asserted in WHEN/THEN form at
   all, being the absence of a surface.

3. **Requirements 1 and 5 split in two each**, because neither reaches 150 words honestly at 837
   and 958 prose words. Mechanism: `## REMOVED Requirements` for the old heading with `**Reason**`
   and `**Migration**` one line each, `## ADDED Requirements` for the two halves, **every scenario
   title carried verbatim** to the half it belongs to, no scenario moved out or duplicated, no test
   moved. Requirement 1, *A store reads a history kept before a commitment carried a kind* (13
   scenarios) → *A store reads every form it has written* (5: the three shape-disagreement refusals,
   the never-written-form refusal, and changes-nothing-at-its-place-on-open) and *Each earlier form
   is read as the record it always was* (8: what each earlier form means, and writing forward over
   one). Requirement 5, *A store keeps a history at a place, across the app being closed and opened
   again* (29 scenarios) → *A store keeps what it is given before it reports it kept* (19: write
   before report, survives closing and reopening, isolated by place, refused and not held on a write
   failure) and *A store persists each kind of record as exactly what it is* (10: schedule shapes,
   names, first and last supported year, digits, characters, addition order). 13 = 5 + 8 and
   29 = 19 + 10. The archiver accepts REMOVED plus ADDED and lands the added halves at the end of
   the spec file rather than in the removed one's place; step 8 (#201) proved it on three
   requirements. If `openspec validate --strict` or the archiver refuses any of this, that is a
   rule-5 stop and a report, never a workaround.

4. **Requirements 3, 6 and 14 are accepted as honestly over the 150-word budget and disclosed in
   `design.md` rather than split further** — ADR-1047's own consequence allows exactly this, and
   step 8 finished with seventeen disclosed that way. Each carries four record kinds' worth of
   genuine rules with no clean seam between them. The disclosure is written from the delta as it
   actually lands, not from this prediction: `survey-record.md` §5's summary prose also names
   requirement 15 among the over-budget six while its own per-requirement table estimates that
   requirement at ~140 words, and the indexer could not reconcile the two and flagged it rather
   than guess. Whatever measures over 150 once written is listed, with the rule that keeps it there.

What follows from the plan and needs no answer: the delta carries every requirement in full, as
MODIFIED except for the two splits above; **no scenario title changes and no scenario is dropped**;
`design.md` names no seam and says why; the *Rules at risk* sections of the two surveys are the
checklist each rewritten requirement is verified against and the reviewer's fidelity axis at G7.
Scenario deduplication — the 31 duplicate candidates the surveys list — is phase 3 of the plan and
is **not** this Story.

## Left open

None. Every frontier item is disposed of by one of the four answers above. What remains — the
wording of each requirement, the exact sentence that carries each *Rules at risk* rule, and which
requirements finally measure over budget — is `spec-author`'s and the rewrite agents' work, and the
surveys give it line-level input. A question that only appears while the delta is written goes to
the owner as a residual round under `## Questions for you` in `design.md`.

## Terms landed in CONTEXT.md

None. This grill landed no new domain term: *Editorial Story* and *Budget* were both landed by
step 8 (#201) and are in `CONTEXT.md` § *Process vocabulary* already, unchanged by anything settled
here.
