# Survey — `openspec/specs/day-screen/spec.md`, the fifteen blocks changed since `4e64641`

Scope: the eight MODIFIED and seven ADDED `day-screen` rows of
`rebaseline-2026-09-10-changed-blocks.md`; line spans verified against the current file. Prose words
= words between the `### Requirement:` heading and the first `#### Scenario:`. Split = share of those
that are (a) normative, (b) rationale/alternatives/change history, (c) cross-references, exclusions
and restatements of other requirements.

**Blocks 1, 2, 4, 5, 6 and 8 have byte-identical prose to `4e64641`**: what changed is scenario ANDs,
where `it says the day is "Today · Monday 31 August 2026"` became `its day picker opens on Monday
31 August 2026` / `it offers the way back to today` after `shorten-day-title` (#182) and
`add-offered-today-control` (#174); block 4 also gained five scenarios. Their splits are carried from
survey A/B rather than re-derived. Blocks 3 and 7 have new prose and are measured fresh, as are all
seven ADDED.

## 1. Per-block table

| # | Kind | Short title | Lines | Prose w | Scen | a / b / c | Verdict | After |
|---|---|---|---|---|---|---|---|---|
| 1 | MOD | moves the day one calendar day either way | 873–982 | 562 | 8 | 55/28/17 | rewrite | 150 |
| 2 | MOD | goes straight back to the today it was handed | 983–1046 | 253 | 5 | 62/22/16 | trim | 120 |
| 3 | MOD | a move with nowhere to go leaves it as it was | 1047–1121 | 656 | 3 | 31/30/39 | rewrite | 120 |
| 4 | MOD | re-reads day and record when shown again | 1425–1613 | 584 | 15 | 60/25/15 | trim | 150 |
| 5 | MOD | cannot read its roster: the day, no rows | 1897–1976 | 399 | 5 | 58/30/12 | trim | 140 |
| 6 | MOD | what it tells lasts until one of three things | 2208–2450 | 804 | 19 | 40/45/15 | rewrite | 130 |
| 7 | MOD | reads its roster again when returned to | 2640–2768 | 511 | 10 | 29/46/25 | rewrite | 150 |
| 8 | MOD | says whether it offers the way back to today | 4548–4677 | 576 | 10 | 55/30/15 | trim | 150 |
| 9 | ADD | says the reach of its day picker | 4777–4932 | 874 | 10 | 60/26/14 | rewrite | 170* |
| 10 | ADD | shows a day picked on its day picker | 4933–5079 | 547 | 11 | 61/20/19 | rewrite | 140 |
| 11 | ADD | a day view says its day as a weekday | 5080–5139 | 371 | 6 | 64/25/11 | trim | 110 |
| 12 | ADD | says the day it is showing | 5140–5237 | 307 | 10 | 58/9/33 | trim | 90 |
| 13 | ADD | says the day view of the day either side | 5238–5452 | 746 | 16 | 56/34/10 | rewrite | 170* |
| 14 | ADD | no day view before the first date, none after the last | 5453–5498 | 219 | 3 | 56/10/34 | trim | 90 |
| 15 | ADD | makes every change on the day it is showing | 5499–5563 | 287 | 4 | 71/9/20 | trim | 110 |

\* 9 and 13 cannot reach 150 honestly: block 9 carries five separable rules and block 13 six; either
splits into two requirements of ~110 words, or stays over target.

**The two REMOVED rows, confirmed by grep** — neither heading survives, `Today` appears nowhere:

- *A day view says its day as a weekday and a date, and says Today on the day it is asked as of* —
  absorbed by block 11, which keeps four of its titles verbatim (`every weekday is said by its own
  name`, `…in the first supported year and in the last`, `…the leap day of a leap year`, `…holding no
  rows says its day just the same`); its five misfiled app-shown-again scenarios moved into block 4
  at L1561–1613, the structural fix survey A §5 asked for; the `Today ·` and date-format ones retire.
- *A day screen says the day it is showing, as of the day it was handed* — absorbed by block 12,
  which keeps five titles verbatim and retires the two `Today` ones for `…says its day the same way
  whether or not it is showing its today` and `…showing a day picked on its day picker says that
  day`.

## 2. Rules at risk

Sentences that read as rationale, cross-reference or exclusion but carry behaviour a test asserts or
another requirement leans on; NEW/CARRIED marked for the MODIFIED blocks.

**Block 1** (all CARRIED). L888–890 *"Every question a day screen asks as of a day SHALL still be
asked as of that today"*; L901–903 *"It SHALL form the day view from the record as the screen last
read it — the reading done when the app was shown, together with every change kept on the screen
since"* (L956; block 13 L5256–5259 now leans on it); L906–907 *"a day screen that is not keeping one
of them SHALL move like any other and go on saying so"* (L974). **NEW risk on an old sentence:**
L893–894 *"It MUST NOT stop at … the earliest day a commitment its roster answers with is kept from"*
is the counterweight to block 9's reach, which defers to it by name at L4801–4804 — trim both and the
screen's unboundedness is stated nowhere.

**Block 2** (CARRIED). L988–990 *"it reads neither the record nor the roster again, it leaves what the
screen says about either of them alone, and it moves the day being shown and never the today"* —
framed as "a move like any other", i.e. what a restatement-trim deletes (L1038). L992 *"The day it
goes back to SHALL be the today the screen was last handed"* (L1030).

**Block 3.** CARRIED: L1054–1056 (go on showing, and MUST NOT report the move had nowhere to go —
L1092, L1102); L1061 *"A day screen SHALL NOT say whether it can move either way"* (no scenario);
L1067 is a later requirement's rule appearing here — drop as cross-reference, not as a rule.
**NEW, both untested here:** L1082–1083 *"a caller MUST NOT stand a move down on the strength of it"*
and L1083–1085 *"Asking for a move that has nowhere to go SHALL go on being answered by this
requirement"*. The whole 206-word paragraph L1075–1085 reads as an exclusion, two rules sit inside
it, and block 14 L5466–5469 states the same pair, also untested.

**Block 4** (CARRIED, at current line numbers). L1439 *"That comparison SHALL be made against the
today the screen held before it was told, and against nothing kept for the purpose"* (L1572, L1583);
L1451–1454 *"What it says about the record SHALL be formed again … the reason included"* (L1509);
L1460–1462 *"A roster read again that holds nothing at all SHALL have the commitments the screen was
handed taken on into it"* — the only statement of that timing rule; L1464–1465 *"Nothing else of a
day screen SHALL survive being shown again"* — block 6 L2214–2216 and block 7 L2661–2663 derive from
it. Survey A's structural finding no longer applies: the five stray scenarios have moved in.

**Block 5** (CARRIED). L1904 *"not written over with the commitments it was handed"* — tail of a
sentence whose opening is justification, and the intersection with the take-on-an-empty-roster rule.
L1916–1920 *"What a day screen says about its roster SHALL be read off the roster's place and what it
says about its record off the record's … A day screen may be keeping one and not the other, in either
combination"* (L1955, L1965).

**Block 6.** CARRIED: L2216–2217 *"It SHALL end whether or not the record can then be read"* (L2271);
L2240–2242 *"A commit in a total entry that says nothing is not an end either, and is not a refusal …
What a day screen was telling therefore stands exactly as it was"* — no SHALL, and the only statement
of what L2441 asserts; L2254–2255 *"Closing a number entry or a note entry without committing it is
not a fourth end"* — rule, no SHALL, no scenario. **NEW (not in survey B's list):** L2225–2227 *"A
change that does not reach the place SHALL NOT end it — a second refusal moves it rather than ending
it"*, and L2248–2249 *"The rule SHALL be the day being shown **changing** and never the gesture that
was made"* — L2338 and L2350 test it, and block 10 L4960–4965 derives from it by name.

**Block 7.** CARRIED: L2668–2670 *"what a day screen tells on a row ends on exactly three things, of
which being returned to is not one"*, wrapped in change history (`#100 landed while this Story was
being written`) — strip the history and L2742/L2761 lose their rule. **NEW:** L2655 *"It SHALL read
its record place again where it is keeping a record, and SHALL NOT where it is not"* (L2751, L2761);
L2661–2663 *"a screen not keeping a record does not start keeping one by being returned to, so that
state … SHALL still stand across being returned to"* (L2713); L2672–2675 *"Where the roster it then
reads holds nothing at all, a day screen SHALL take on the commitments it was handed … and where the
place cannot be read, it SHALL say so and draw no rows"* (L2723, L2733). **No longer applies:** the
rule survey B recorded here — being returned to "does three things fewer" and "SHALL NOT read the
record again" — was reversed by `add-commitment-editing` (#148), so a trim that carries the old
sentence forward restates a retired rule. Defect to leave alone: the title at L2713, *a day screen
returned to does not read its record again*, is documented-wrong and deliberately unrenamed.

**Block 8** (CARRIED). L4559–4560 *"The answer SHALL be about the control and not about the position
… it MUST NOT be phrased as, or stand in for, whether the screen is showing its today"* — untestable
by construction, and block 12 L5146–5151 now depends on it. L4574–4575 *"A move that had nowhere to
go MUST NOT change the answer"* (L4660). L4582–4584 *"Offering none SHALL NOT make the way back a
refusal … it stays something a day screen does from whatever day it is showing, including from its
today"* (L4625) — reads exactly like an exclusion.

**Block 9 (ADDED).** L4801–4804 *"The reach SHALL bound the day picker and never the screen … that
requirement is unchanged by this one and MUST NOT be read as narrowed by it"* — **no scenario**, the
sentence a cross-reference pass deletes first, and the only thing keeping the reach off the chevrons.
L4797–4799 *"MUST NOT narrow it to the commitments due on some day, to the commitments the roster is
still keeping, or to the commitments the day view holds rows for"* — only the second narrowing is
tested (L4858, L4867). L4808–4810 *"Nothing SHALL be answered about whether the day picker is
offered"* and L4817–4820 *"It MUST NOT give out the today the screen was last handed, under any
name"* — both **no scenario**. L4829–4832 *"the screen SHALL go on showing the day it was showing,
and the reach SHALL simply reach less far"* (L4905).

**Block 10 (ADDED).** L4937–4938 *"The earliest day the picker reaches SHALL itself be shown when it
is given: the bound includes its own day"* (L4991) — one clause after a colon. L4967–4969 *"Showing a
picked day SHALL be asked of the screen and handed exactly one thing"* — **no scenario**, shape rule.
L4960–4961 *"A pick that leaves the day being shown unchanged SHALL change nothing at all"* (L5009,
L5061) — one sentence covering two different acts.

**Block 11 (ADDED).** L5088 *"and nothing else: no day of the month, no month, no year, and no word
in front of it"* — the last clause is what retired `Today ·` and has **no scenario**. L5096–5097
*"What day of the month, month and year a day view is of is said … by the day picker … and this
capability says none of it"* — reads as pure cross-reference, and is the only statement that the
title excludes the date. L5099–5101 the fixed English names and the locale refusal (L5111).

**Block 12 (ADDED).** L5146–5148 *"they MUST NOT follow the today the screen was handed … there is no
word, mark or spacing that tells the two apart"* (L5171), inside a paragraph that is otherwise two
cross-references: L5149–5153 is the block's whole `c` share and is droppable, the first half of
L5146 is not.

**Block 13 (ADDED).** L5240–5244 *"They SHALL be two answers rather than one … and the day view of
the day being shown SHALL go on being said exactly as it is today, unchanged in name, in shape and in
every answer it gives"* — the non-regression clause, **untested directly**. L5252–5254
*"MUST NOT form either from the commitments answered for the day being shown"* (L5368). L5256–5258
*"The roster asked is the one read when the app was last shown or the screen was last returned to,
whichever happened later"* (L5443) — `whichever happened later` is load-bearing, as in block 7.
L5263–5264 *"what the screen is telling on a row SHALL be left exactly as it was"* (L5433). L5270–5271
*"Exactly one day either side SHALL be said, and never a run of them"* (L5309).

**Block 14 (ADDED).** L5461–5464 *"A screen showing either end SHALL go on saying the day view on its
other side; a screen showing any other date SHALL say one on both sides, whatever its roster holds,
whatever its record holds, whether its day view has any rows, and whichever day it was handed as
today"* — only the first half is tested (L5471, L5480, L5489), the four independences not at all.
L5466–5468 *"whether a move has anywhere to go is not answered here and is not answered anywhere, and
a caller MUST NOT stand a move down on the strength of it"* — **no scenario**, block 3's twin.

**Block 15 (ADDED).** L5510–5513 *"This is the shipped rule that *a row the screen's day view does
not hold SHALL change nothing at all*, read over the rows this capability now says"* — the only link
to the inherited rule; deleted as a cross-reference, the requirement's derivation goes with it.
L5501–5504 names four kinds of change; **the note has no scenario**.

## 3. Rationale needing a home

| Rationale | Blocks | Home |
|---|---|---|
| Answering a date, never a clock; the 1583/9999 ends | 1, 3, 11, 14 | **ADR-1004** |
| A screen refuses silently where a value gives nothing back | 3 (L1056–1059) | **ADR-1028** |
| The chevrons say nothing; what bounds an offer | 3 (L1066–1073), 8 (L4553–4557) | `CONTEXT.md` § *Offered*; **ADR-1042/1043/1045**. The encapsulation half of block 8 — the screen answers because it gives out neither day — is still **none** |
| The neighbour day views exist, and stepping there and back to sample one wipes a refusal | 3 (L1075–1085), 13 (L5264–5268) | **ADR-1043** § *Amendment, 2026-09-10* and its *Alternatives* entry "Sample the neighbour by stepping the screen there and back" |
| A screen keeps the day you moved to; phone down overnight | 4 (L1432–1437) | **ADR-1026** |
| Later-version vs merely-unreadable | 5 (L1912–1914) | **ADR-1021**, already cited in the prose |
| A notice names a cause a person can act on; one at a time | 6 (L2229–2233) | **ADR-1036** |
| A total's blank commit means nothing | 6 (L2240–2244) | **ADR-1041** |
| A rename carries every record over, so the record place has a second writer | 7 (L2656–2660) | **ADR-1023** (amended 2026-09-09) and `openspec/changes/archive/2026-09-09-add-commitment-editing/design.md` § *A rename touches two files* |
| `#100 landed while this Story was being written`; the unrenamable scenario title | 7 (L2664–2670) | **none, and none wanted** — change history, ~90 words, drop |
| The picker's floor, why it clamps to the day being shown, why a pick below it is refused rather than clamped, why the picker is always offered | 9, 10 | **none under `docs/adr/`** — recorded in `openspec/changes/archive/2026-09-09-add-day-picker/design.md` §§ *Why a pick below the floor is refused rather than clamped* / *Why the floor clamps to the day being shown*, and `CONTEXT.md` § *Reach*. Cite the design or write an ADR; do not just drop |
| The weekday alone, the three-letter names, the date being the picker's and therefore the device's | 11 (L5089–5090, L5096–5097, L5099–5101) | **ADR-1022**, amended 2026-09-09 by `shorten-day-title` (#182) |
| Three with no home and none wanted: the "fourth end" a Cancel button would be, withholding a neighbour costing more than the failure, the day title as an "am I on today" test | 6 (L2256–2260), 13 (L5284–5286), 12 (L5149–5153) | **none** — arguments against proposals nobody made; drop each, keep the SHALL beside it |

## 4. Scenario duplication

**Block 6 — the largest saving in scope.** L2281/L2300 (a tick kept, a take-back kept) are repeated
with a number fixture at L2359/L2369, a note fixture at L2399/L2409 and a total fixture at
L2420/L2430; the prose says so itself — *"One rule rather than eight"* (L2224). Keep L2281, L2290
(another row) and L2300, drop the other six. L2320 (moved to the day after) is L2311 (day before)
with the direction flipped — keep L2311 plus L2329 (sent back). L2390 is L2311 with a refused-value
fixture — drop it; L2381 stays as the pair with L2262. **~7 droppable.**

**Block 13.** L5288 (day before) and L5299 (day after) are one fixture with one direction each, and
L5309 already asserts both directions — merge into one with two THENs. L5328 (moved), L5338 (sent
back), L5348 (picked) and L5358 (shown again) are four fixture variants of *both follow the day being
shown*: keep L5328 and L5358 — the move keeps the today, being shown replaces it — and merge L5338
with L5348. L5443 (returned to) reads like a fifth but asserts the roster re-read, so it stays; L5388
and L5443 share a fixture and assert opposite things, so both stay. **~3 droppable, 2 merges.**

**Blocks 4, 10 and 12.** L1572 (moved away and back onto today) and L1583 (sent back) test one rule
the prose states once at L1440–1442 — keep L1572, fold L1583; L1604 is L1482 with L1561's
moved-off-today fixture, the weakest of the three but the combination that could break independently.
L5043 and L5070 prove the same fact between them, L5070's first AND being redundant with L5043's
second — keep both titles, drop the AND; L5009 and L5061 are one prose rule (L4960–4961) tested
twice, and both stay because the acts differ. L5209 (sent back) and L5216 (picked) are the
fixture-only pair among block 12's four — keep L5201 and one of them. **~2 droppable.**

**Keep despite looking duplicated.** Block 9's L4858 (stopped) / L4867 (removed) differ by one word,
but the indistinguishability of stopped and removed is itself the rule (ADR-1035), as survey A ruled
for the same pair elsewhere. Block 15's L5520, L5531 and L5543 look like a kind-substitution family
and are not: they cover tick/number/take-back against day-before/day-after/day-before, the third with
a non-empty record. The note kind is the gap there, not the duplicate.

**Blocks 1, 2, 8.** Three direction pairs — L909/L919, L1004/L1013, L4600/L4608 — one behaviour
tested twice with the direction flipped; mergeable into one scenario with two THENs each, at the cost
of three titles. Total across the scope: **~12 droppable and 6 merges, of 135.** Every one deletes an
acceptance test and a CI-checked title, so this is a separate gated change, not part of a prose pass.

## 5. Scenario prose

**0 of 135.** Checked mechanically over the fifteen spans: every line between a `#### Scenario:`
heading and the next is a `- **WHEN**` / `**THEN**` / `**AND**` bullet, a wrapped continuation, or
blank, with no orphan indented paragraph. Nothing to do.

## 6. Totals

| | Now | After a concise rewrite |
|---|---|---|
| Lines (15 blocks) | 1,807 | ~1,430 |
| Words, all | 23,252 | ~17,550 (prose pass only) |
| Words, requirement prose | 7,696 | ~1,990 (−74%) |
| Scenarios | 135 | 135 (prose pass); ~117 if §4 is taken |
| Blocks over 150 prose words | 15 of 15 | 2 (9 and 13, or 0 if each splits) |

**Rewrite the prose block by block and leave the scenarios alone in the same pass.** The fifteen
blocks carry 7,696 prose words holding roughly 2,000 words of rules; the rest is rationale ADR-1004,
1021, 1022, 1023, 1026, 1028, 1036, 1041, 1042, 1043 and 1045 already record, change history that
belongs nowhere (~250 words in block 7 alone), and cross-references. Two things separate this range
from those surveyed on 2026-09-09. The seven ADDED blocks were written after that survey and repeat
its worst habit at full strength: block 9 hides four untested rules inside sentences that open as
cross-references, and blocks 3 and 14 state the *same* pair of move-vs-draw rules in two places with
no scenario under either — trim both and the rule is stated nowhere, the failure survey A caught
between its reqs 5 and 19. And block 7's shipped rule was reversed by #148 while the old sentence's
shape survived, so a trimmer working from survey B's notes would preserve a retired rule. Do blocks
3, 7, 9 and 13 by extracting their rules to a checklist against their own scenario titles first;
blocks 2, 5, 11, 12, 14 and 15 can be cut paragraph-wise, keeping every sentence in §2. Treat the
eight rules flagged **no scenario** as questions for the human rather than as trims.
