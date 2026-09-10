# Grill frontier — day-screen spec, from three surveys

Index only, no added analysis. Refs are `survey-A` / `survey-B` / `survey-2026-09-10`.

## A. Rationale with no ADR home

1. Rhythm shown always, not only to disambiguate two rows — lives nowhere (ADR-1034 covers only
   the words). Rec: keep the SHALL, write an ADR paragraph or drop the argument. [survey-A req3 L383–388]
2. Day view is a value/snapshot, not a window — lives nowhere under `docs/adr/`, design.md material
   at most. Rec: keep the two SHALLs, drop the argument. [survey-A req5 L583–586, L599–602]
3. "Untappable but not tapped" would double one rule into two — lives nowhere. Rec: droppable. [survey-A req2 L195–196]
4. A note is too long to draw in a list without changing it — lives nowhere, strongest un-homed
   argument in range A. Rec: one ADR paragraph if wanted, else drop. [survey-A req3 L373–375]
5. Total entry's field is not prefilled — lives nowhere; `docs/adr/*.md` has no "prefill" hit. Rec:
   a paragraph in ADR-1041, or a new ADR — do not just drop. [survey-B req36 L4019–4024]
6. Range hint's en dash is the exact normative glyph — lives nowhere, though tested. Rec: keep as a
   normative sentence in the requirement, drop the "why". [survey-B req28 L3016–3019]
7. Comma/full stop read alike, because of the iPhone decimal keypad — ADR-1032 covers decimals, not
   the keypad argument. Rec: one sentence added to ADR-1032, or drop the reason and keep the rule. [survey-B req30 L3299–3301]
8. Way back to today is answered by the screen (encapsulation, gives out neither day) — lives
   nowhere; confirmed still **none** by survey-2026-09-10. No fix recommended beyond flagging it as
   the reason the requirement exists. [survey-B req42 L4685–4695; survey-2026-09-10 block8 L4553–4557]
9. Day picker's floor/clamp/refusal/always-offered rationale — lives in
   `openspec/changes/archive/2026-09-09-add-day-picker/design.md` and `CONTEXT.md` § *Reach*, not
   under `docs/adr/`. Rec: cite the design or write an ADR, do not just drop. [survey-2026-09-10 blocks 9–10, L4797ff/L4937ff]
10. Three arguments against proposals nobody made (a Cancel button's "fourth end"; withholding a
    neighbour costs more than the failure; the day title as an "am I on today" test) — lives
    nowhere. Rec: drop each, keep the SHALL beside it. [survey-2026-09-10 blocks 6/13/12, L2256–2260 / L5284–5286 / L5149–5153]
11. Change-history prose ("#100 landed while this Story was being written," the unrenamable
    scenario title) — none, and none wanted. Rec: drop, ~90 words. [survey-2026-09-10 block7 L2664–2670]

**A: 11 items.**

## B. Rules with no scenario

1. A non-total row's sum is zero, not nothing — testable: yes, just untested; implementations
   depend on it. [survey-A req3 L350–351]
2. A day screen must not say whether it can move either way — testable: no, it's a prohibition. [survey-A req11 L1061]
3. Total entry's field is not prefilled — testable: yes, currently neither scenario nor ADR. [survey-B req36 L4019–4020]
4. A day view holding two rows that are the same row tells of both — testable: yes, if a scenario
   is written; otherwise drop deliberately. [survey-B req23 L2208–2211]
5. Closing an entry without committing is not a "fourth end" — testable: yes, same call as #4;
   carried forward unchanged. [survey-B req24 L2416–2418; survey-2026-09-10 block6 L2254–2255]
6. Whether a day holds an addition is read off its sum being above zero, additions never inspected
   directly — testable: no, architectural/implementation-only per the survey. [survey-B req37 L4087]
7. A total entry says no hint — testable: no, it's an absence rule ("untested negative"). [survey-B req36 L4012]
8. The way-back-to-today answer is about the control, not the screen's day — testable: no,
   untestable by construction; block 12 now depends on it. [survey-B req42 L4691; survey-2026-09-10 block8 L4559–4560]
9. A take-back writes to the place even on a day with no number — testable: not stated; currently
   asserted only in prose. [survey-B req29 L3125]
10. The picker's reach bounds the picker only, never narrows the screen's day-view range —
    testable: not stated; no scenario at all. [survey-2026-09-10 block9 L4801–4804]
11. Reach must not narrow to due-today, still-kept, or has-rows commitments — testable: partially,
    only one of the three narrowings is tested. [survey-2026-09-10 block9 L4797–4799]
12. Nothing is answered about whether the day picker is offered — testable: not stated; no scenario. [survey-2026-09-10 block9 L4808–4810]
13. The picker must not give out the screen's today under any name — testable: not stated; no
    scenario. [survey-2026-09-10 block9 L4817–4820]
14. Showing a picked day is handed exactly one thing (a shape rule) — testable: not stated; no
    scenario. [survey-2026-09-10 block10 L4967–4969]
15. The day title says nothing else — no day-of-month, month, year or leading word — testable: not
    stated; no scenario. [survey-2026-09-10 block11 L5088]
16. The other-side day views stay unchanged in name, shape and every answer (non-regression) —
    testable: yes in principle; untested directly today. [survey-2026-09-10 block13 L5240–5244]
17. The neighbour-day-view answer holds regardless of roster, record, rows or today (four
    independences) — testable: not at all tested; only the first half of the rule is. [survey-2026-09-10 block14 L5461–5464]
18. Whether a move has anywhere to go is unanswered anywhere; a caller must not stand a move down
    on it — testable: not stated; no scenario in either of its two locations (twin). [survey-2026-09-10 block3 L1082–1085 & block14 L5466–5468]
19. The note names four kinds of change — testable: not stated; "the note has no scenario". [survey-2026-09-10 block15 L5501–5504]

**B: 19 items.**

## C. Structural moves the surveys ask for

1. Req 3 (row identity + contents) should split into two requirements, ~110 words each. [survey-A req3 table note]
2. Five scenarios misfiled under req 17 (day-title) actually test req 16 (app-shown-again) and
   should move — **already done**: survey-2026-09-10 confirms they moved into block 4 (L1561–1613). [survey-A §5]
3. The `Application Support` justification paragraph, duplicated verbatim between reqs 14 and 21,
   should be stated once. [survey-A §5]
4. The shared "at most one entry kind" rule (reqs 27/31/35) and the shared eight-behaviour set
   (reqs 29/33/38) should each be extracted once rather than struck three times. [survey-B §5]
5. Blocks 9 (day-picker reach) and 13 (day view either side) each carry too many separable rules
   and should split into two requirements, ~110 words each. [survey-2026-09-10 table note]
6. The two REMOVED day-title requirements were absorbed into blocks 11 and 12, keeping most
   scenario titles verbatim — **already done**. [survey-2026-09-10 §1]
7. Scenario title at L2713 ("a day screen returned to does not read its record again") is
   documented-wrong since #148 reversed the rule — flagged as a known defect, deliberately left
   unrenamed for now (not a move to make). [survey-2026-09-10 block7]
8. Scenario deduplication (~4 scenarios in survey A, ~33 in survey B, ~12 + 6 merges in the third)
   is recommended as its own gated change — each deletion removes an acceptance test and its
   CI-checked title, so none of it belongs in a prose-only pass. [survey-A §3/§5; survey-B §3/§5; survey-2026-09-10 §4/§6]

**C: 8 items.**
