# Survey B — `openspec/specs/commitment/spec.md`, requirements 19–36 (L2086–4741)

Range: 2,656 lines, 32,283 words, 178 scenarios. Prose between headings and first scenarios:
10,881 words. Scenario bodies are ~21,400 words and are **already** pure WHEN/THEN/AND bullets
throughout (see §4).

## Per-requirement table

| # | Short title | Lines | Prose words | Scen. | (a) normative | (b) rationale/"why" | (c) xref/exclusion/restatement | Verdict | After |
|---|---|---|---|---|---|---|---|---|---|
| 19 | screen refuses a rhythm number the calendar will not take | 2086–2160 | 355 | 5 | 35% | 37% | 28% | trim | 110 |
| 20 | already-kept vs. roster-could-not-be-written | 2161–2216 | 168 | 4 | 51% | 37% | 12% | trim | 95 |
| 21 | screen asks you to confirm a stop | 2217–2377 | 671 | 11 | 45% | 39% | 16% | **rewrite** | 230 |
| 22 | screen takes a stopped commitment up again in one tap | 2378–2431 | 154 | 4 | 67% | 32% | 1% | trim | 105 |
| 23 | same roster place as a day screen; re-read when shown | 2432–2480 | 167 | 4 | 63% | 30% | 7% | trim | 110 |
| 24 | screen that cannot read its roster | 2481–2567 | 279 | 7 | 59% | 27% | 14% | trim | 150 |
| 25 | screen holds the refused change and why, one at a time | 2568–2763 | 677 | 14 | 44% | 37% | 19% | **rewrite** | 240 |
| 26 | how long a refused change lasts | 2764–2946 | 381 | 15 | 62% | 27% | 11% | trim | 200 |
| 27 | screen says in words the rhythm its form is building | 2947–3005 | 309 | 5 | 61% | 24% | 15% | trim | 150 |
| 28 | roster removes a commitment and never lets it go | 3006–3149 | 600 | 11 | 65% | 25% | 10% | trim | 330 |
| 29 | screen removes only when the name is typed back | 3150–3363 | 599 | 17 | 70% | 19% | 11% | trim | 340 |
| 30 | roster moves a commitment | 3364–3621 | 1296 | 16 | 54% | 35% | 11% | **rewrite** | 450 |
| 31 | screen moves a commitment | 3622–3888 | 1244 | 16 | 50% | 35% | 15% | **rewrite** | 420 |
| 32 | roster puts a commitment under a category | 3889–4024 | 722 | 8 | 65% | 24% | 11% | trim | 400 |
| 33 | roster reads in groups, one per category | 4025–4134 | 501 | 8 | 76% | 17% | 7% | trim | 340 |
| 34 | screen puts under a category, offers the ones in use | 4135–4268 | 588 | 9 | 58% | 32% | 10% | trim | 290 |
| 35 | roster moves a group | 4269–4548 | 1356 | 14 | 53% | 35% | 12% | **rewrite** | 480 |
| 36 | screen moves a group | 4549–4741 | 814 | 10 | 53% | 32% | 15% | **rewrite** | 290 |

Nothing in the range is `keep`: every block carries at least one rationale paragraph, and 15 of 18
carry bold sentences, which the proposed shape forbids outright.

## 1. Rules at risk — sentences a naive trim would lose

Ordered roughly by severity. Every one of these sits in a paragraph a rationale-stripper would read
as droppable, and every one is load-bearing.

**#28, L3027–3030** — the worst case in the range. Inside the paragraph headed *"Removing is a last
state and not a departure"*, which otherwise ends in "was weighed and rejected … ADR-1035":
> "a roster whose every commitment has been removed still holds every one of them, still answers
> with each of them on every date up to the day it was kept until, and is therefore **not** the same
> roster as one that has been given no commitment at all"

Scenario 3097 (*a roster that has removed every commitment it holds is not a roster holding
nothing*) tests exactly this, and ADR-1027's day-one write depends on it. No SHALL anywhere in the
sentence.

**#30, L3396–3398** — reads as anti-rationale ("The carve-out is not tidiness") but the second half
is the rule:
> "**The carve-out is about the sequence and not about the category**: a move on one of those two
> offsets still puts the commitment under the category it was moved under"

Tested by scenario 3601.

**#30, L3390** — a gloss trailing the SHALL sentence, and the phrase the scenario title quotes:
> "A stopped or removed commitment lying between where the moved commitment was and where it goes is
> passed rather than pushed: the moved commitment goes by, and it stands still."

Scenario 3483 carries "passed rather than pushed" in its title.

**#30, L3409–3410** — inside *"The price of one order over three states, taken knowingly"*, a
paragraph that is otherwise pure justification:
> "A commitment the roster has stopped keeping has a place in the sequence and holds it, so taking it
> up again returns it exactly there"

Relied on by #22's scenario 2404 and #31's 3788, neither of which is in this requirement.

**#30, L3425–3426** — the tail of the 230-word two-offset arithmetic paragraph:
> "a stopped or removed commitment lying between the moved one and the one that follows it is not
> passed, because nothing goes by it"

Tested by scenario 3518. It is the *difference* between the two accepted offsets and is stated
nowhere else.

**#31, L3655–3657** — bold, framed as a consequence ("is therefore a place"):
> "**The end of a group is therefore a place a drop can reach, and reaching it files the commitment
> in that group and not in the one drawn after it.**"

Tested by scenario 3851. The rest of that paragraph is genuine rationale about offset expressiveness.

**#31, L3662–3665** — the paragraph explicitly says it is stating a consequence, and is the only
statement of a behaviour with its own scenario:
> "**Moving a group's first commitment away moves the group** … a group whose first commitment has
> gone somewhere else is afterwards drawn where its next commitment sits."

Tested by scenario 3878.

**#31, L3674–3676** — the scope limit on the no-op carve-out:
> "a commitment dropped in any group but the one it is already in is filed there at every offset that
> group has, because its category changes even where the drawn order would not"

Relied on by 3800 and 3811; without it the carve-out reads as applying across groups.

**#32, L3903–3904** — no SHALL, and it is the identity rule the whole grouping feature rests on:
> "Two commitments are under one category when the words are the same word, and under two when they
> are not."

**#32, L3920–3921** — no SHALL, sitting under a bold heading sentence about cutting across states:
> "A commitment the roster has stopped keeping or removed goes on being under the category it was
> under, and is read back under it wherever such a commitment is read back."

Tested by 3990 and by #33's 4126.

**#33, L4052–4053** — a "therefore" sentence with no SHALL:
> "Reading in groups and reading flat therefore answer with the same commitments, each exactly once,
> and disagree only in the order they come in."

Scenario 4105 tests it verbatim.

**#35, L4293** — five words, and per ADR-1044's 2026-09-09 amendment the delta once contradicted
itself over exactly this anchor:
> "immediately after the last commitment under the category of the last of them, **whatever state
> that one is in**"

Losing the qualifier silently swaps the after-the-last branch to the kept anchor. ADR-1044 measured
the two (18 mislandings vs. 0) and it is not recoverable by reasoning from the surrounding prose.

**#35, L4315–4317** — no SHALL, framed as the price of one order:
> "a group whose commitments were scattered through the order comes back **contiguous**, so a
> commitment under another category that lay between two of them is afterwards on one side of the
> whole group"

Tested by scenario 4419.

**#35, L4303–4306** — has a SHALL, but the whole paragraph is headed as a cost paid later and reads
droppable:
> "the roster SHALL afterwards answer about a date on which that commitment was still kept in the
> opposite group order to the one it reads back today"

Tested by scenario 4521.

**#36, L4558–4560** — no SHALL, and it is the entire specification of the screen's offset:
> "The offset is the screen's own count and the roster's alike, and this screen converts nothing. The
> groups it draws are the groups the roster answers with, in that order, so a place among the ones
> under a category is the same place at both."

Tested by scenario 4619. The remaining two thirds of that paragraph is rationale.

**#36, L4570–4572** — no SHALL, in a paragraph that ends "it is not a second rule and it is not a
defect":
> "the list of what the screen has stopped is drawn in a different order afterwards … a stopped
> commitment under the moved category travels with the group like every other"

Tested by scenario 4634.

**#34, L4171–4172** — bold, framed as "deliberate rather than an omission", no SHALL:
> "**A category on a commitment the screen has stopped is not offered**"

Tested by scenario 4217.

**#34, L4160–4162** — no SHALL, a "so that" consequence:
> "a category whose last kept commitment has been put under another is gone from what is offered at
> the same moment its heading goes, and a category is never offered that no heading shows"

Tested by scenario 4227.

**#19, L2094** — first sentence of an otherwise-rationale paragraph, no SHALL:
> "The three refusals are one refusal, told apart from every other the screen makes but not from each
> other."

Tested by scenario 2140. The remaining ~75 words of that paragraph (ADR-1021's rule "applied where it
does hold") are droppable.

**#21, L2244–2246** — inside the pure-rationale day-before paragraph:
> "A commitment defined and stopped on the same day becomes one kept on no day at all"

Tested by scenario 2336. Same paragraph, L2243–2244, carries a cross-capability observable —
"a tick made this morning on a commitment stopped this afternoon is not drawn on today's day screen,
though the record of it stands untouched and the row returns on that day if the commitment is ever
taken up again" — which no scenario in this range asserts but the day-screen spec's readers rely on.

**#21, L2255–2260** — not a rule, but the highest-value paragraph in the range to *not* delete
blindly. It records that scenario 2296's title (*"…is kept until the day the screen was handed"*) is
false from the moment the change shipped, that the scenario asserts the day *before*, and that
`openspec` 1.10.0 is what prevents renaming it. Delete this and the next reader "fixes" the
assertion to match the title. It belongs in `design.md`/an ADR, not in the spec — but it must land
somewhere before it is cut.

**#27, L2963–2964** — trailing clause of a bullet:
> "saying so is what the refusal does, and the words go on describing the rhythm being built"

Tested by scenario 2985; without it "the screen refuses to define on it" could be read as licensing
the refusal wording in the words.

**#23, L2441–2442** — a "so that" gloss carrying two observables, one of which scenario 2470 tests:
> "so a commitment stopped after midnight is kept until the day before the one it is actually stopped
> on, and a screen the app was left on overnight does not offer yesterday as the day to keep a new
> commitment from"

**#25, L2611** — restates a rule already in the L2597–2609 enumeration; low risk *only if* that
enumeration survives, which a length-driven rewrite may not let it:
> "A name typed back that does not match is emphatically not a refusal"

Tested by 2685 and by #29's 3243.

## 2. Rationale needing a home

| Rationale | Reqs | Home today |
|---|---|---|
| Told apart only where a person acts differently; three refusals as one | 19, 20, 24 | **ADR-1021** + **ADR-1036** (1036 states the general test). Drop from spec. |
| A screen may refuse what the engine accepts; empty weekday set | 19, 27 | **ADR-1028**, explicitly (its Decision even cites this spec's requirement by name). Drop. |
| The stop uses the day *before* the day handed; the floor case | 21, 29 | **ADR-1023**, amended 2026-09-07 for exactly this (L6, L51, L61 of that file). Drop. |
| `openspec` 1.10.0 forbids dropping a scenario; three wrong titles | 21 | `design.md` § *Three scenario titles that are now wrong* — **outside the spec and not durable once the change archives**. Needs a new ADR or a note in `docs/process.md`; do **not** simply drop. |
| A screen holds no words a person reads | 25, 29 | **ADR-1022**. Drop. |
| Removing is a state, not a departure; dropping the entry rejected | 28 | **ADR-1035** (and ADR-1023's earlier refusal). Drop the argument, keep the rule at L3027–3030. |
| One order over three states, and what it costs | 30 | **ADR-1037** ("one order over three states" appears verbatim). Drop. |
| Offsets are not clamped | 30, 35 | **No ADR.** The rule is already carried by the SHALL-refuse sentence; "Not clamped. A clamp puts a commitment somewhere nobody asked for" is a restatement and can simply be dropped. |
| A category is the roster's, not the commitment's; the fourth/fifth-part argument | 32 | **ADR-1038**. Drop. |
| No list of categories anywhere; the pointer-table alternative | 32 | **ADR-1038** L98 (rejected alternative recorded). Drop the argument, keep the MUST NOTs. |
| Not sorting groups by the owner's own words | 33 | **ADR-1038** (grouping rule is its decision); the "owner's own words" argument is **ADR-1037**'s. Drop. |
| A phone capitalises the first letter, so offering removes the problem | 34 | **No ADR.** Roughly 70 words. Either a short new ADR or dropped — the rule it justifies (MUST NOT trim, fold, or match loosely) is already normative at L4152–4155. |
| A group move carries the whole block where a commitment's move steps over | 35, 36 | **ADR-1044**, including the contiguous/gather consequence (its L82) and the away-and-back non-restoration (its L99). Drop from spec. |
| The two anchors, measured; the tap is honoured | 35 | **ADR-1044**'s 2026-09-09 amendment, with the 18/4788 vs 102/5838 figures. Drop from spec. |

Everything above except two items already has a durable home. The two exceptions are the
`openspec` scenario-title note (#21) and the phone-capitalisation argument (#34).

## 3. Scenario duplication

Same behaviour, fixture only differs — keep the one named.

- **#26, 2813 / 2822 / 2832 / 2862 / 2883 / 2905 / 2925** — seven scenarios of one rule ("a change
  reaching the place ends it, whichever of the seven"), one per verb. Keep **2813** plus **2925**
  (the group move, which is the one that names a category rather than a commitment); the other five
  are verb fixtures.
- **#26, 2842 / 2852 / 2873 / 2894 / 2915 / 2936** — six scenarios of the mirror rule ("a call that
  reaches the place with no change does not end it"). Keep **2842** and **2894** (the move-to-where-
  it-already-is case, which is the one the prose singles out as non-obvious).
- **#25, 2657 / 2664 / 2706 / 2727 / 2751** — five variants of "asked for no change → holds no
  refused change". Keep **2664** (broadest) and **2751** (the group-move case, distinct because it
  names a category).
- **#24, 2540 / 2548 / 2557** — remove / move / put-under-a-category through an unreadable screen,
  identical THEN. Keep **2548**; 2520 already covers define, which is the one that behaves
  differently.
- **#19, 2113 / 2122 / 2131** — three rhythm shapes, identical THEN and AND, and the prose says
  outright they are one refusal. Keep **2113** if the range is being cut hard; defensible to keep all
  three since each exercises a different `Schedule` constructor.
- **#30, 3508 / 3574** — 3574 is 3508 on a one-commitment roster. Keep **3508**. Same pair in **#35,
  4432 / 4538** — keep **4432**.
- **#31, 3769 / 3838** — 3838 asserts everything 3769 does plus the category. Keep **3838**.
- **#31, 3740 / 3749** — both are "asks for no change at all" fixtures already covered by 3730 and
  3865. Keep **3730** and **3865**.
- **#36, 4650 / 4663** — the prose itself says the no-category ask "is what it already answers for a
  group it draws none of". Keep **4663**.
- **#29, 3217 / 3234** — 3234 is 3217's blank-space half carried through to the removal. Keep
  **3234** and narrow 3217 to the case difference.
- **Cross-requirement value-semantics quartet: 3115 (#28) / 3565 (#30) / 4015 (#32) / 4495 (#35)** —
  "…on a copy of a roster leaves the roster it was copied from unchanged", once per verb. Legitimate
  per-verb coverage, but if any cluster is a candidate for one parameterised scenario, it is this one.
  Same shape for **3553 / 4001 / 4480** ("moves no day and changes no commitment").

Roughly **20–24 scenarios** in the range could go without losing a distinct behaviour, almost all of
them in #24, #25, #26, #31 and #36. Each drop is a test deletion, so each needs a deliberate
decision — the titles are contracts.

## 4. Scenario prose

**Zero.** All 178 scenarios in the range are WHEN/THEN/AND bullets with indented continuation lines
and nothing else — verified mechanically over lines 2086–4741. Every bold sentence and every
paragraph of rationale is in requirement prose, never inside a scenario. The concise shape's
scenario rule is already met.

## 5. Totals and recommendation

| | Now | After |
|---|---|---|
| Lines | 2,656 | ~2,230 |
| Words | 32,283 | ~25,300 |
| Requirement prose words | 10,881 | ~4,730 (−56%) |
| Scenarios | 178 | ~156 |

**Recommendation: rewrite the six heavy requirements, trim the other twelve, and do the rewrites
one at a time.** Six requirements — 21, 25, 30, 31, 35, 36 — hold 6,058 of the range's 10,881 prose
words (56%) and every one of the high-severity rules in §1. They are not trimmable: the rules and the
rationale are interleaved sentence by sentence and often inside the same sentence, so a stripper
loses behaviour. The other twelve are genuinely trimmable — one or two clearly-delimited rationale
paragraphs each, whose subject already has an ADR (see §2), with the rules stated in SHALL sentences
that stand on their own. #33 is the closest thing to already-concise in the range at 76% normative
and would survive a light trim. The single biggest risk in the exercise is not length: it is that
about twenty rules in this range are stated **only** in prose that reads like justification — no
SHALL, often under a bold "this is the decision" opener — and eleven of them have a scenario testing
them by name. Any rewrite of 30, 31, 35 or 36 should start by extracting the rules in §1 into SHALL
sentences and *then* delete, rather than deleting and re-reading. #35's five-word "whatever state
that one is in" at L4293 is the one to watch: ADR-1044 records that a previous delta already got that
anchor wrong in exactly this way.
