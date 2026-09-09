# Survey B — `openspec/specs/day-screen/spec.md`, requirements 23–43 (lines 2139–4907)

Prose words = words between the `### Requirement:` heading and the first `#### Scenario:`.
Split = share of those words that are (a) normative, (b) rationale/alternatives/"why",
(c) cross-references, exclusions and restatements of other requirements.

| # | Short title | Lines | Prose w | Scen | a norm | b why | c xref | Verdict | After |
|---|---|---|---|---|---|---|---|---|---|
| 23 | tells on the tapped row that a change could not be kept | 2139–2369 | 1234 | 14 | 45% | 40% | 15% | rewrite | ~165 |
| 24 | what is told lasts until shown again / kept / day changes | 2370–2612 | 804 | 19 | 40% | 45% | 15% | rewrite | ~130 |
| 25 | tells nothing where there was no tick to refuse | 2613–2801 | 719 | 15 | 45% | 30% | 25% | rewrite | ~120 |
| 26 | reads its roster again when returned to | 2802–2900 | 334 | 8 | 55% | 25% | 20% | trim | ~140 |
| 27 | row offers the number entry / none for a future day | 2901–3009 | 538 | 7 | 50% | 25% | 25% | trim | ~130 |
| 28 | number entry says the range and the day's number | 3010–3085 | 352 | 5 | 55% | 30% | 15% | trim | ~150 |
| 29 | enters the number, keeps it before the day view says so | 3086–3273 | 688 | 14 | 65% | 20% | 15% | trim | ~180 |
| 30 | reads a commit as number / take-back / neither | 3274–3427 | 677 | 10 | 65% | 25% | 10% | trim | ~200 |
| 31 | row offers the note entry / none for a future day | 3428–3531 | 546 | 7 | 45% | 25% | 30% | rewrite | ~90 |
| 32 | note entry says the day's note and nothing else | 3532–3597 | 360 | 4 | 40% | 40% | 20% | trim | ~110 |
| 33 | enters the note, keeps it before the day view says so | 3598–3787 | 811 | 14 | 55% | 25% | 20% | rewrite | ~160 |
| 34 | reads a note commit as a note or a take-back | 3788–3881 | 431 | 6 | 50% | 30% | 20% | trim | ~120 |
| 35 | row offers the total entry / none for a future day | 3882–3990 | 551 | 7 | 45% | 25% | 30% | rewrite | ~90 |
| 36 | total entry says the day's sum and the target | 3991–4071 | 587 | 4 | 45% | 45% | 10% | rewrite | ~140 |
| 37 | row offers taking back the day's last addition | 4072–4148 | 331 | 5 | 50% | 40% | 10% | trim | ~120 |
| 38 | adds what is committed, keeps it before the view says so | 4149–4341 | 686 | 14 | 60% | 25% | 15% | trim | ~170 |
| 39 | reads a total commit as amount / nothing / refused | 4342–4469 | 695 | 7 | 60% | 25% | 15% | trim | ~200 |
| 40 | takes back the last addition a row offers | 4470–4587 | 348 | 9 | 75% | 15% | 10% | trim | ~150 |
| 41 | draws rows in the groups it was handed | 4588–4679 | 369 | 7 | 60% | 30% | 10% | trim | ~150 |
| 42 | says whether it offers the way back to today | 4680–4809 | 576 | 10 | 55% | 30% | 15% | trim | ~160 |
| 43 | row says whether it offers anything at all | 4810–4907 | 446 | 7 | 60% | 30% | 10% | trim | ~150 |

Five need a real rewrite for content reasons (23, 24, 25, 33, 36); 31 and 35 need one because they
are near-verbatim clones of 27. Only 40 is close to the target shape already.

## 1. Rules at risk from a naive trim

Sentences that look like rationale, cross-reference or "not our problem" but carry behaviour a test
asserts or a later requirement leans on. Ordered by risk.

**Req 39, L4360–4364** — `"What is left SHALL be read as a decimal number in exactly the way a number
entry's commit is read", ... "That reading is its own requirement and is not restated here."`
The single most load-bearing cross-reference in the range: it is the whole of the total entry's
number grammar (separators, 38 significant digits, exponent refusal). A "no cross-references" pass
deletes the only statement of how a total commit is parsed. Scenarios L4402, L4423 depend on it.

**Reqs 27/31/35, L2922, L3448, L3903** — `"A row SHALL offer at most one of a tick, a number entry, a
note entry and a total entry, and never two of them."` Stated identically in all three. A
per-requirement trim that strikes it as "restating another requirement" in each of the three loses
it entirely. Three scenarios test it: L2960, L3485, L3942.

**Req 23, L2193–2195** — `"Nothing about a note's length, its script, its line breaks or its
characters SHALL be named as a cause"`, inside a paragraph otherwise arguing why a note has no
cause. Directly asserted by L2327 (`a note of a hundred thousand characters ... names no cause`).

**Req 24, L2402–2404** — `"A commit in a total entry that says nothing is not an end either, and is
not a refusal. ... What a day screen was telling therefore stands exactly as it was."` No SHALL,
reads as argument, and is the only statement of the rule scenario L2603 asserts.

**Req 25, L2626–2629** — `"whatever was committed — a value that commitment would refuse included,
because such a screen never gets as far as reading what was committed"`. The load-bearing clause is
a parenthetical inside a rationale sentence, and L2713 asserts it (`committing "300" and then
"1.2.3" ... tells nothing on any row either`).

**Req 24, L2378** — `"It SHALL end whether or not the record can then be read"`, buried in the
"that is inherited rather than added" paragraph. Tested by L2433.

**Reqs 29 and 33, L3122 and L3641** — `"A number/note entered on a day that already holds one
replaces it, which is the `record` capability's answer and not a second rule here."` Phrased as a
disclaimer, but it is the only statement of a behaviour with its own scenario in the same
requirement (L3160, L3677).

**Req 42, L4714–4717** — `"Offering none SHALL NOT make the way back a refusal. ... it stays
something a day screen does from whatever day it is showing, including from its today, where it
leaves the screen showing that today."` Reads exactly like a "this requirement does not cover"
exclusion; scenario L4757 tests it.

**Req 26, L2818–2820** — `"what a day screen tells on a row ends on exactly three things, of which
being returned to is not one. It stands, and the last scenario below is what says so."` Wrapped in
change history (`#100 landed while this Story was being written`). Strip the history and the rule
that L2892 tests goes with it.

**Req 30, L3315–3318** — the enumeration `"two separators, a separator with no digit beside it, a
sign anywhere but the front, an exponent, letters or spaces among the digits, a character of no
width anywhere in it, a digit that is not one of the ten this package reads"`. Looks illustrative;
it is the fixture list of L3392 and the only statement that non-ASCII digits (`٧٠`) are refused.

**Req 36, L4019–4020** — `"Its field is not prefilled, and this capability SHALL NOT say a value for
one to be prefilled from."` A real rule with **no scenario and no ADR** (see §2). It survives only
as prose today.

**Req 23, L2208–2211** — `"Where a day view holds two rows that are the same row, both are told of.
That is inherited rather than chosen here..."` A behavioural rule with no SHALL and no scenario in
range. If it matters, it needs a scenario; if not, drop it deliberately, not by accident.

**Req 24, L2416–2418** — `"Closing a number entry or a note entry without committing it is not a
fourth end, and cannot become one."` Rule, no SHALL, no scenario. Same call as above.

Lower risk but worth a second look: req 37 L4087 (`Whether the day holds an addition SHALL be read
off the day's sum being above zero, and this capability SHALL NOT ask for the additions themselves`
— architectural, untested); req 36 L4012 (`A total entry SHALL say no hint` — untested negative);
req 42 L4691 (`The answer SHALL be about the control and not about the position` — untestable by
construction, which the paragraph itself admits); req 29 L3125 (a take-back writes to the place even
where the day holds no number — asserted only in prose).

## 2. Rationale needing a home

Almost all of it is already recorded, which is what makes this range trimmable.

| Rationale | Reqs | Home |
|---|---|---|
| A notice names a cause only where a person can act on it; four causes, no fifth; the exact wordings | 23, 25, 39 | **ADR-1036** (amended 2026-09-08 when the set went two → four) |
| Blank is one test asked in one place; zero-width space is not blank; the trim is the screen's | 30, 34, 39 | **ADR-1039** |
| Thirty-eight significant digits, judged on the sum arithmetic gives, refused at the row | 30, 39, 23 | **ADR-1040** |
| A total's blank commit means nothing; the take-back is its own act, offered only where the day holds an addition | 37, 38, 39, 24, 25 | **ADR-1041** |
| A screen may refuse what the engine accepts | 27, 29, 35 | **ADR-1028** |
| Group order and category are the roster's; a day view sorts nothing | 41 | **ADR-1037**, **ADR-1038** |
| A row that offers nothing recedes; it is not hidden and not drawn as kept | 37, 43 | **ADR-1045** |
| A day screen without its record still draws the day | 25 | **ADR-1021** |
| A screen keeps the day you moved to | 24, 42 | **ADR-1026** |
| The kind is a commitment's fourth part (one kind → one affordance) | 27, 31, 35 | **ADR-1030** |
| A recorded number is a decimal | 30 | **ADR-1032** |
| The day is said in the app's own words (no locale) | 28, 36 | **ADR-1022** |

Not recorded anywhere, and each needs a decision:

- **The total entry's field is not prefilled** (36, L4019–4024). No ADR mentions prefilling; grep
  for `prefill` across `docs/adr/*.md` returns nothing. Either a paragraph in ADR-1041 (which
  already owns "a total's commit is an addition") or a new ADR. Do not just drop it.
- **The range hint's en dash** (28, L3016–3019). The exact glyph is normative and tested (L3036);
  no ADR carries it. It should stay in the requirement as a normative sentence, and the *why*
  ("a range that is only ever a refusal teaches by refusing") can be dropped outright.
- **The comma and full stop are read alike because of the iPhone decimal keypad** (30, L3299–3301).
  ADR-1032 covers decimals but not the keypad argument. One sentence in ADR-1032, or drop the
  reason and keep the rule.
- **The way back to today is answered by the screen, because the screen gives out neither day**
  (42, L4685–4695). An encapsulation decision with no ADR. Small, but it is the reason the
  requirement exists at all.

Everything else — "the price is deliberately paid a third/fourth time", "as #140 moved the note row
before it", "`add-refused-tick-notice` (#100) landed while this Story was being written", "which is
the shape that produced the defect the number entry's own requirement now closes", "the two new
causes are named on this requirement's own test and no other" — is change history and can be
dropped without a home. Roughly 900 words of it.

## 3. Scenario duplication

193 scenarios in range. ~33 are kind-substitutions or subsumed cases.

**Req 24 — one rule, eight scenarios.** L2443, L2452, L2462, L2521, L2531, L2561, L2571, L2582,
L2592 all test "a change reaching the place ends what is told", varying only the kind. The prose
says so itself: *"One rule rather than eight"* (L2387). Keep L2443 (a change kept), L2462 (a
take-back kept) and L2452 (kept on another row); drop the other five.
Also: L2482 (moved to the day after) duplicates L2473 (day before) — keep L2473 plus L2491 (sent
back). L2552 duplicates L2473 with a value-refusal fixture — drop.

**Req 25 — four kinds per rule.** "not keeping a record": L2662, L2705, L2751, L2769 → keep L2662
and L2769 (the total one carries the extra ANDs). "day that has not arrived": L2679, L2715, L2761,
L2781 → keep L2679 and L2781. L2688 is subsumed by L2696 (which asserts the standing notice too) —
drop L2688. L2724 ("offers no number entry") is subsumed by L2742 ("offers no entry at all"), same
tick fixture — drop L2724.

**Reqs 27 / 31 / 35 — seven behaviours × three kinds = 21 scenarios.** L2939/L3465/L3921,
L2948/L3473/L3930, L2960/L3485/L3942, L2973/L3498/L3954, L2983/L3507/L3964, L2992/L3516/L3973,
L3000/L3523/L3981. L3942 ("a tick, a number entry, a note entry or a total entry and never two")
subsumes L2960 and L3485 outright — drop those two. The "later date offers none" and "earlier date
offers it" triples answer identically for every kind: keep the four-kind version, drop four.

**Reqs 29 / 33 / 38 — eight behaviours × three kinds = 24 scenarios.** The row-not-held,
offers-no-entry, not-keeping-a-record, other-rows-unchanged, moved-back-to, writes-nothing-to-roster,
cannot-be-kept and held-by-a-later-screen sets are identical in shape at L3208/L3714/L4264,
L3220/L3725/L4275, L3231/L3747/L4299, L3241/L3757/L4309, L3251/L3767/L4320, L3263/L3778/L4332,
L3198/L3704/L4243, L3142/L3660/L4233. Keep the number and the total versions (the total's answers
differ), drop the note ones: ~8 scenarios.

**Subsumed pairs.** L3736 ("a commit is read as the entry the row it was made on offers") is fully
contained in L4286 (same, "for all four kinds") — drop L3736. L2223 ("told on the row that was
tapped") is contained in L2231 ("...and on no other row") — drop L2223.

**Keep despite looking duplicated.** L2283 vs L2350 (the second asserts word-for-word identity of
the message across two kinds — that is the contract). L2791 vs L4539 (tells nothing vs changes
nothing — different assertions). L4243 vs L4528 (an addition refused vs a take-back refused).

## 4. Scenario prose

**Zero.** All 193 scenarios in the range are `- **WHEN** / **THEN** / **AND**` bullets with no
paragraph or stray sentence. Checked mechanically (no non-bullet, non-blank, non-continuation line
between a `#### Scenario:` heading and the next heading). The scenario bodies are long — 19,999
words, averaging 104 words each — but the length is fixture detail inside bullets, and several ANDs
carry a second fixture (`AND committing "-1" on the second row ... tells ...`), which is a merge
already done rather than prose to strip.

## 5. Totals

| | Now | After a concise rewrite |
|---|---|---|
| Lines | 2,770 | ~1,850 |
| Words, all | 35,907 | ~22,500 |
| Words, requirement prose | 12,083 | ~3,025 (−75%) |
| Words, scenario bodies | 19,999 | ~16,600 |
| Scenarios | 193 | ~160 |
| Requirements over 150 prose words | 21 of 21 | ~7 |

**Recommendation: rewrite the whole range, prose only, and leave the scenarios alone in the same
pass.** The prose is where the fat is — 12,083 words carrying maybe 3,000 words of rules, with the
rest split between rationale that ADR-1036, 1039, 1040, 1041, 1028, 1037, 1038 and 1045 already
record properly and change history ("as #140 moved the note row before it") that belongs nowhere.
Every requirement in the range exceeds the 40–150 word target, five of them by more than 4×. But
this is not a mechanical trim: the range's compression comes precisely from cross-references
(req 39 defers its entire number grammar to req 30 in one sentence) and from paragraphs that argue
their way to a rule without ever writing SHALL (req 24's three ends, req 25's four cases). §1 lists
thirteen sentences whose deletion would silently drop tested behaviour, and the 27/31/35 and
29/33/38 clone families need their shared rules extracted once rather than struck three times. Do
the prose requirement by requirement against the scenario list of that same requirement, and treat
any rule with no scenario (req 36's no-prefill, req 23's two-alike-rows, req 24's fourth end) as a
question for the human rather than a trim. The scenario deduplication in §3 is worth ~33 scenarios
and ~3,400 words, but it deletes acceptance tests and CI-checked titles, so it is a separate,
gated change — not part of a "make the prose concise" pass.
