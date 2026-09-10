# Re-survey — the twelve MODIFIED blocks of `openspec/specs/commitment/spec.md`

Scope: exactly the twelve `MODIFIED` rows under `## commitment` in
`rebaseline-2026-09-10-changed-blocks.md`. ADDED and REMOVED rows are another agent's. Line spans
are current (`spec.md` is 5,896 lines). Prose words are the words between the requirement heading
and its first `#### Scenario:`, counted as the rebaseline counts them. Percentages are of those
prose words, assigned sentence by sentence: **(a)** normative SHALL/MUST rules, **(b)** rationale,
alternatives, "why X over Y", worked examples, **(c)** cross-reference, exclusion, or restatement of
a rule another requirement owns. Earlier reports are `survey-commitment-A.md` (its #1, #8, #9, #12,
#14, #15, #17) and `survey-commitment-B.md` (its #20, #24, #25, #26, #36), matched here by title.

## 1. The table

| # | Short title | Lines | Prose words | Scen. | (a) rules | (b) why | (c) xref/excl | Verdict | After |
|---|---|---|---|---|---|---|---|---|---|
| 1 | A commitment is name, schedule, kept-from | 13–101 | 595 | 7 | 28% | 33% | 39% | **rewrite** | 140 |
| 2 | A roster holds commitments in order | 401–547 | 1194 | 9 | 72% | 22% | 6% | **rewrite** | 340 |
| 3 | A roster refuses one it already holds | 548–799 | 1464 | 17 | 55% | 34% | 11% | **rewrite** | 350 |
| 4 | A roster store keeps a roster at a place | 1046–1479 | 1123 | 35 | 57% | 10% | 33% | **rewrite** | 330 |
| 5 | Unreadable store refused, not emptied | 1635–1703 | 383 | 5 | 50% | 48% | 2% | **rewrite** | 120 |
| 6 | Screen lists what its roster keeps | 1704–1880 | 809 | 12 | 53% | 37% | 10% | **rewrite** | 250 |
| 7 | Screen defines a commitment | 1995–2298 | 1730 | 18 | 55% | 34% | 11% | **rewrite** | 330 |
| 8 | Already-kept vs. could-not-be-written | 2426–2490 | 311 | 4 | 48% | 50% | 3% | **rewrite** | 110 |
| 9 | Screen that cannot read its roster | 2755–2840 | 274 | 7 | 54% | 23% | 23% | trim | 150 |
| 10 | Screen holds the refused change and why | 2841–3066 | 826 | 16 | 40% | 34% | 25% | **rewrite** | 240 |
| 11 | How long a refused change lasts | 3067–3273 | 475 | 17 | 63% | 35% | 2% | trim | 200 |
| 12 | Screen moves a group | 4683–4875 | 795 | 10 | 59% | 28% | 12% | **rewrite** | 290 |

Movement since the earlier reports (their prose counts, taken against base commit `4e64641`):

- **Grew hardest** — #7 [621 → 1,730, +179%], #8 [168 → 311, +85%], #5 [252 → 383], #1 [444 → 595],
  #10 [677 → 826], #11 [381 → 475], #3 [1,315 → 1,464], #2 [1,034 → 1,194], #4 [1,005 → 1,123].
- **Effectively unchanged** — #6 (prose byte-identical), #9 (one verb swapped: "to put one under a
  category" → "to change one"), #12 (one sentence rewritten from "the **seventh** kind of refused
  change" to "a refused **group move** … the only kind that names something other than a
  commitment"). All three are MODIFIED on scenario bodies, not prose; the earlier figures hold.
- **Verdicts that moved** — #1, #5, #7 and #8 were `trim` and are now `rewrite`. #9 is the only
  block in scope a trim still reaches; none is `keep`. All twelve use bold sentences as structure,
  and the smallest (#9, 274 words) is still nearly twice the 150-word ceiling.

## 2. Rules at risk

Listed only where a sentence carries a rule a test asserts or another requirement depends on **and**
sits in prose a rationale-stripper would read as droppable. **NEW** = absent from the earlier
report; **CARRIED** = present there, re-anchored.

**#1** — *CARRIED, L22–23*: "it cannot know what day it is, because the present moment is not
something this capability is allowed to consult" — still the only clock ban on commitment
*formation*. *CARRIED, L41–42*: "a record embeds the whole commitment by value", the premise the
`SHALL NOT change` at L40 rests on. *NEW, L52*: "The **kind** is the one part no change reaches at
all" — the only statement here that the new change operation cannot touch the kind; #7's L1999–2001
restates it, so it survives only if #7 does.

**#2** — *CARRIED, L408–414*: "**moving** is the only thing that ever changes the order … A move
takes one of exactly two things and there is no third". *NEW, L410–414*: "Two things put a
commitment somewhere other than last, and neither is a move: **changing** … puts the second exactly
where the first was, and **superseding** takes the second on in the place the first held" — two
placement rules read as a preamble to the rationale sentence that follows. The supersede half is
asserted by this block's new scenario at L538, the change half only by #4's scenario at L1442.
*NEW, L440–441*: "It still holds no link between the two, and being changed or superseded gives
neither of them a fifth part" — no scenario asserts the absent link; ADR-1023 L127 records it.
*CARRIED, L444–446*: "**The ban on a position is a ban on a read.**" *CARRIED, L450–452*: "The
roster answers it as part of the **groups** it reads its commitments back in".

**#3** — *NEW, L569–570*: "It compares whole values, and a **target** is the same story on the total
kind." The range half gained a scenario at L720; the target half is asserted nowhere in the spec.
*CARRIED, L596–599*: "Being offered under no category therefore takes the category off … *without
saying a category* … leaves the category alone." *CARRIED, L607–608*: "What was actually done on
those days is untouched either way, because that is the ticks and no tick moves."

**#4** — *CARRIED, L1077–1079*: "**A change that leaves the roster exactly as it was SHALL keep
nothing at the place either, and SHALL still report what the roster reported**". Re-anchored: the
earlier entry counted three examples and three scenarios; there are now **four** of each (L1327,
L1378, L1432, L1472). *CARRIED, L1104–1105*: "MUST NOT write its commitments grouped" — provable
only by inspecting the file, asserted by no scenario. *NEW, L1117–1119*: "**A change of commitment
reaches a record place as well, and a roster store is not what reaches it** … and whatever asks for
both is what puts them in an order" — a scoping rule with no scenario in this block.

**#5** — *NEW, L1649–1651*: "The last of those follows from what the three states are: a removed
commitment always has a kept-until day" — the only statement of why that fourth unreadable case
exists; the case itself is safe (scenario L1696). *NEW, L1657–1659*: "This is stated rather than
left to follow … it has been refused and tested since `add-commitment-kind` without a scenario of
its own to say so." Not a rule, and now **stale** — the scenario at L1686 was added by this very
change. Delete it, but knowingly rather than as collateral.

**#6** *(prose unchanged)* — *CARRIED, L1743–1744*: "which of the two is removed is the one the
removal was asked about, and never the one the typing picks out." *CARRIED, L1746–1753*: the
paragraph recording that a scenario title is now wrong and is kept only because `openspec` 1.10.0
refuses a MODIFIED requirement that drops a scenario. Removable only with that scenario and its test.

**#7** — *NEW, L2053–2055*: "For a commitment the screen already holds there is no kind to offer,
because a kind is not one of the things a change is asked with" — the rule that the change path
offers four fields, not five; no scenario here asserts it. *NEW, L2071*: "SHALL hold no more than
thirty-eight significant digits" — the one clause of that normative run the scenario at L2253 does
not exercise. *NEW, L2086–2088*: "Blank is decided by the one test this package asks for the
question (ADR-1039) … a range end holding a zero-width space alone is a range end that is not a
number, not an empty one" — decides which of two refusals a zero-width space produces, phrased
wholly as a consequence, with no scenario. *CARRIED, L2099–2101*: "The two remain distinct in the
model and may disagree where something other than this screen forms the commitment" — losing it
makes kept-from == interval start a model-wide rule.

**#8** — the sharpest block in scope: 168 → 311 prose words and **no new scenarios**, so all three
additions are rules none of its four scenarios asserts. *NEW, L2432–2435*: "A change to a commitment
is refused as one the roster already holds where the roster holds it in **any** of the three states
rather than only where it is keeping it" — asserted only at L5535, inside the out-of-scope ADDED
requirement *A commitments screen changes a commitment on either of its lists*. *NEW, L2435–2438*:
"a change the screen could not keep is told the same way whether it was the **record place** or the
**roster place** that would not take it" — nearest assertion L5591, also out of scope. *NEW,
L2448–2449*: "**Changing another commitment into it is a duplicate**, and is refused" — stated in
the same sentence as its own justification.

**#9** — no entries; the earlier report listed none, and the only change is one verb inside a
restatement clause.

**#10** — *NEW, L2854–2856*: "**A refused change names the commitment it was asked about and not the
one it would have produced**" — asserted by the new scenario at L3048, which names "Gym" rather than
"Run", so the rule survives only if that scenario does. *NEW, L2862–2867*: "**The seven are counted
here and numbered nowhere else.** A requirement that introduces one of them SHALL name it … and
SHALL NOT identify it by its position among them … A statement about the kinds that came *before* a
kind is not a position in this sense." A rule constraining how every other requirement is written,
unassertable by any test, and the reason #12's "seventh kind" sentence was rewritten in this same
change. Highest naive-trim risk in scope. *CARRIED, L2894*: "A name typed back that does not match
is emphatically not a refusal" — low risk only while the L2879–2892 enumeration survives, which a
length-driven rewrite may not allow.

**#11** — *NEW, L3082–3084*: "a change that writes nothing but a category is one of the last of
those rather than a kind of its own" — decides that a category-only save is not an eighth kind; the
scenario at L3212 exercises the behaviour, not the classification. *NEW, L3084–3085*: "A change of a
commitment reaches the record place as well as the roster place, and it ends what is held once it
has been kept — one act, one outcome, however many places it touched" — the record-place half is
asserted by nothing in scope. *NEW, L3096–3097*: "and a change asked about a commitment on neither
of the screen's lists" — last item of a four-item enumeration whose other three have scenarios
(L3201, L3244, L3265); this one has none.

**#12** *(prose all but unchanged)* — *CARRIED, L4692–4694*: "The offset is the screen's own count
and the roster's alike, and this screen converts nothing" (tested at L4752). *CARRIED, L4704–4707*:
"the list of what the screen has stopped is drawn in a different order afterwards … travels with the
group like every other."

**Earlier entries that no longer apply.** None has been deleted; every one re-anchors to a current
line. Two need re-reading rather than re-anchoring: survey A #12's entry miscounts the no-op
examples (three, now four — L1327/L1378/L1432/L1472), and survey B #36's framing of the group-move
refusal as "the **seventh** kind" is gone, replaced at L4728 by "a refused **group move** … the only
kind that names something other than a commitment". The rule is unchanged; only the numbering was
withdrawn, by the rule now at L2862.

## 3. Rationale needing a home

| Block | Rationale added | Home |
|---|---|---|
| 1 | L45–54, the whole *Changing a commitment is now a thing a person does* paragraph | **ADR-1023** (amended 2026-09-09: L7, L115, L122) and **ADR-1030** (amended 2026-09-09: L38, L84, L89), both already cited in it. Drop. |
| 2 | L410–414, L437–441 — why change and supersede are not moves; why a change is safe | **ADR-1023** L115–130 (the place, the no-link price). Drop the argument, keep the rules (§2). |
| 3 | L562–570 — why equality compares the whole kind | **ADR-1030** L67. The range/target-carry half is in no ADR but survives in the rule alone. Drop. |
| 4 | L1117–1119 — why the roster store is not what reaches the record place | **ADR-1023** L115. Drop the argument, keep the scoping rule. |
| 5 | L1653–1659 — why half a range is refused rather than completed | **none.** No ADR mentions half a range or "both ends or neither"; ADR-1031 is about store forms and is silent. One paragraph there, or drop the reasoning. |
| 7 | L2057–2065 — why a range and a target arrive as text where a rhythm number does not | **ADR-1046** (2026-09-10), this argument verbatim, already cited at L2065. Drop. |
| 7 | L2067–2074 — one reading of a typed number rather than two | **ADR-1046** § Consequences; **ADR-1040** for the digit cap. Drop. |
| 7 | L2076–2088 — blank asked before number; both ends blank is no range | **ADR-1046** L44, L88; **ADR-1039** for the blank test. Drop the argument, keep the zero-width rule. |
| 7 | L2090–2096 — why a range on a kind with no room for it is ignored, not refused | **none.** ADR-1046 decides how the two refusals are worded, not what an ignored field does. ~70 words; the SHALL at L2090 survives alone. |
| 7 | L2048–2052 — why the tick is the offered kind | **ADR-1030** (the plain kind, the pre-kind default). Drop. |
| 8 | L2432–2444 — refusal across all three states; both places told alike; why this does not follow the day screen | **ADR-1023** (2026-09-09) for the first; **ADR-1021** and **ADR-1036**, already cited, for the rest. Drop the argument, keep all three rules. |
| 10 | L2862–2867 — why the seven kinds are never numbered | **none.** It exists only in the archived `rework-commitment-row-actions` change folder. A rule about writing requirements — it belongs in an ADR or `docs/process.md`, and must land before the paragraph is cut. |
| 11 | L3084–3089 — one act, one outcome across two places | **none** as an ADR; the phrase appears only in two archived change folders. ADR-1022 covers the no-words half of the requirement, not this. |
| 12 | unchanged | **ADR-1044**, as before. Drop. |

Of thirteen additions, **eight have a durable home** and can be deleted outright. Four have none —
half a range (#5), ignore-rather-than-refuse (#7), the no-numbering rule (#10), one-act-one-outcome
(#11) — and the last two carry rules, not merely reasons.

## 4. Scenario duplication — new pairs only

Pairs created by this change. The earlier surveys' findings for the older scenarios still stand.

- **#4, L1472** (*a change of a commitment for itself keeps nothing at a roster store's place*) is a
  **fourth** fixture of one rule beside L1327, L1378 and L1432. Keep **L1327**.
- **#4, L1463** (*a change and a supersession a roster refuses keep nothing…*) is a further fixture
  of the store-reports-the-roster's-refusal family already holding L1167, L1177, L1273, L1318,
  L1367, L1420. Keep **L1167**; L1463 earns its place only by packing two verbs into one scenario.
- **#7, L2264 vs L2277** — a range and a target on a kind with no room for one; one rule, one field
  swapped. Keep **L2264**: its third `AND` covers a third kind and subsumes L2277.
- **#10, L3057** is the seventh verb fixture of the no-change-at-all rule (L2940, L2947, L2968,
  L2989, L3011, L3035). Keep **L2940** and **L3035** as the earlier survey recommended.
- **#11, L3255 / L3265** are the eighth and seventh fixtures of the rules at L3079 and L3091; keep
  the two the earlier survey named (L3120, L3149). **Caveat:** L3255 is the only scenario anywhere
  near the record-place clause at L3084–3085 and does not in fact reach a record place — dropping it
  costs nothing, but the rule is then asserted nowhere (§2).
- **Not duplicates, keep both:** #4 L1442 vs L1452 (change replaces in place; supersede keeps both);
  #7 L2241 vs L2253 (blank-is-no-range vs how a number reads); #2 L538; #3 L720; #5 L1686;
  #10 L3048.

Droppable on fixture grounds from the new scenarios alone: **4 of 157**.

## 5. Scenario prose

**Zero.** All 157 scenarios in scope were checked programmatically: every line of every scenario
body is a `- **WHEN/THEN/AND**` bullet or a continuation of one. Rationale *inside* a bullet is a
separate matter and is unchanged from the earlier surveys.

## 6. Totals

| | Now | After a concise rewrite |
|---|---|---|
| Lines | 2,249 | ~1,660 |
| Words total | 28,046 | ~20,900 |
| — requirement prose | 9,979 | ~2,850 (−71%) |
| — scenario bodies | 18,067 | ~18,000 |
| Scenarios | 157 | 153 |

**Rewrite eleven of the twelve; #9 is the only one a trim still reaches.** The scope has gained
2,010 prose words since the base commit, unevenly: #7 alone added 1,109 and is now the largest
requirement prose block in the file, while #6, #9 and #12 did not move and their earlier surveys
apply unchanged. Three things must be sequenced rather than swept. **#8 is the sharpest** — it grew
85% and gained no scenarios, so its three new rules live in prose alone and are asserted only from
an out-of-scope ADDED requirement; trim it before that requirement is surveyed and they vanish from
both places. **#10's no-numbering rule** constrains how every other requirement in this spec is
written, has no ADR, and is why a sentence in #12 was rewritten in this same change; it must land in
an ADR or `docs/process.md` first. **#4 and #10 are the two blocks whose bulk is restatement rather
than rationale** (33% and 25%): both re-enumerate refusals that #3, #9, #12 and the move
requirements already own, and both shrink furthest by deleting the enumerations outright rather than
rewriting sentences. Four rationale pieces still have no durable home, and two of those carry rules,
so they need a paragraph in an existing ADR before the prose is deleted — or an explicit decision to
lose them.
