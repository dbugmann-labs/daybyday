# Grill — condense-day-screen-spec (#201)

Held 2026-09-10 by the conductor with the owner, one round of four questions. The frontier was
indexed from the three `day-screen` surveys under `docs/research/2026-09-09-concise-specs/`
(`survey-day-screen-A.md`, `survey-day-screen-B.md`, `survey-2026-09-10-day-screen.md`) into
`grill-frontier.md` beside this file: 11 pieces of rationale with no ADR home, 19 rules with no
scenario, 8 structural items. Every item resolves under one of the four answers below.

## Settled

1. **The 19 rules with no scenario each survive as a bare SHALL/MUST sentence, and this Story adds
   no scenario.** It changes no test (ADR-1047). `design.md` § Open Questions lists the eight the
   surveys judge testable today as *knowingly untested* — frontier B1, B3, B4, B5, B9, B16, B17
   and the block-9 picker rules B10–B13 as one entry — and one backlog want captures them for a
   later behaviour Story.
2. **Rationale with no ADR home is homed before its prose is deleted, by amending the nearest
   existing ADR with one paragraph each**: A1 rhythm-shown-always → ADR-1034; A2 day-view-as-value
   → the ADR `spec-author` judges nearest (1026 or a new one); A5 no-prefill → ADR-1041; A6 the
   en-dash glyph stays in the requirement as a normative sentence; A7 keypad comma → ADR-1032; A8
   way-back-to-today encapsulation → ADR-1045; A9 the day picker's floor, clamp, refusal and
   always-offered → **one new short ADR** written from
   `openspec/changes/archive/2026-09-09-add-day-picker/design.md` and `CONTEXT.md` § *Reach*.
   A3, A4, A10 (the three straw-man arguments) and A11 (change history) are dropped outright.
3. **Three requirements split in two each**, because none reaches 150 words honestly: *A row is a
   commitment's line on a date* (identity and contents / what a row gives back, including the
   rhythm), *A day screen says the reach of its day picker*, and *A day screen says the day view
   of the day before … and of the day after*. Mechanism: `## REMOVED Requirements` for the old
   heading (Reason and Migration required), `## ADDED Requirements` for the two new ones, **every
   scenario title carried verbatim** to the half it belongs to; no test moves. The two rules the
   surveys found stated three times — *a row offers at most one entry kind* (requirements 27/31/35)
   and the shared eight-behaviour set (29/33/38) — are stated once, in the first requirement of
   each family, and cross-referenced in one clause elsewhere. If `openspec validate --strict` or
   the archiver refuses any of this, that is a rule-5 stop and a report, never a workaround.
4. **No scenario title changes and no scenario is dropped**, including the one the surveys mark
   documented-wrong since #148 (*a day screen returned to does not read its record again*, whose
   test asserts the opposite). `spec-author` amends ADR-1047's list of knowingly-false titles from
   two to three. Scenario deduplication (~50 candidates across the three surveys) is phase 3 of the
   plan and is not this Story.

What follows from the plan and needs no answer: the delta is `## MODIFIED Requirements` carrying
every requirement in full (plus the split above); `design.md` names no seam and says why; the
*Rules at risk* sections of the three surveys are the checklist each rewritten requirement is
verified against, and the reviewer's fidelity axis; the 2026-09-10 survey supersedes the earlier
two wherever they overlap, and its note that requirement 7's rule was reversed by #148 means the
older survey's entry for it is not carried.

## Left open

None. Every frontier item is disposed of by one of the four settled answers; what remains — which
ADR is nearest for A2, the exact two headings each split produces, the wording of every
requirement — is `spec-author`'s work, and the surveys give it line-level input. A question that
only appears while the delta is written goes to the owner as a residual round under
`## Questions for you` in `design.md`.

## Terms landed in CONTEXT.md

- **editorial Story** — a Story whose delta is MODIFIED-only, changes no behaviour and no test,
  and names no seam (ADR-1047).
- **budget** — the line or word ceiling an artifact is written to (ADR-1047).
