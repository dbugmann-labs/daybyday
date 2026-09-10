# Survey — `commitment`, the seven ADDED blocks (2026-09-10)

Scope: `openspec/specs/commitment/spec.md`, the seven ADDED requirements listed under `## commitment`
in `rebaseline-2026-09-10-changed-blocks.md`. Line spans, prose-word counts and scenario counts were
re-measured against the working tree and match the rebaseline exactly. MODIFIED rows are out of scope.
Prose words = words between the `### Requirement:` heading and the first `#### Scenario:`.

## 1. Blocks

Splits: (a) normative — SHALL/MUST sentences plus rules stated without a modal that a scenario asserts;
(b) rationale — why-this-over-that, alternatives rejected, "that is the decision"; (c) cross-reference,
exclusion, or restatement of the sentence above it in example form. Classified sentence by sentence;
the word counts sum to the measured prose total in every row.

| # | Short title | Lines | Prose words | Scenarios | (a) | (b) | (c) | Verdict | Est. after |
|---|---|---|---|---|---|---|---|---|---|
| 1 | roster answers the earliest day kept from | 4876–4962 | 417 | 7 | 53% | 28% | 19% | rewrite | 130 |
| 2 | roster changes a commitment for another | 4963–5079 | 525 | 8 | 47% | 32% | 21% | rewrite | 150 |
| 3 | roster supersedes a commitment from a day | 5080–5204 | 521 | 8 | 62% | 30% | 8% | rewrite | 150 |
| 4 | screen says what a commitment is made of | 5205–5303 | 531 | 6 | 39% | 32% | 30% | rewrite | 140 |
| 5 | screen changes a commitment on either list | 5304–5652 | 1622 | 21 | 55% | 31% | 14% | rewrite + split | 320 |
| 6 | screen offers the categories in use | 5653–5737 | 467 | 5 | 37% | 47% | 16% | rewrite | 110 |
| 7 | screen refuses a bad range and a bad target | 5738–5897 | 663 | 11 | 46% | 31% | 23% | rewrite | 170 |

No block is a `trim`: deleting every (b) and (c) word still leaves block 1 at 221 words, block 3 at
324 and block 7 at 304, all above the 150-word ceiling, so the normative core itself has to be re-said
more tightly in all seven.

## 2. Rules at risk

Rules carried by rationale-looking prose that a naive trim would delete; line numbers are current.

**Block 1**
- L4884 "Neither state SHALL raise the answer, and taking a commitment up again SHALL NOT lower it" —
  a SHALL inside the paragraph whose next two sentences are pure rationale. **No scenario** covers
  taking a commitment up again.
- L4897 "This capability MUST NOT consult the present moment, the device's time zone or the locale" —
  **no scenario.**
- L4903 "A commitment reads back the name it was given and the kind its days take and nothing else —
  the day it is kept from is a part it is made of, not a part it hands out" — a constraint on the
  `Commitment` value, stated only as rationale for why the answer is the roster's. **No scenario.**

**Block 2**
- L5001 "a roster holds no records and carries none over" — an exclusion that keeps the carry-over out
  of this seam. **No scenario**, and none is possible here.

**Block 3**
- L5089 "the superseded commitment sits immediately behind it in the roster's order" — no modal, sits
  in the paragraph that argues against appending; scenario 7 asserts it.
- L5106 "A commitment asked to supersede **itself** is refused by that same rule" — a refusal case
  buried in a bullet's rationale clause; scenario 5's last AND asserts it.
- L5109 "including the first and the last" supported date — **no scenario**; only the earlier-than-kept-from
  case (scenario 6) is covered.
- L5115 "the roster SHALL hold no link between the two" — normative negative, **no scenario**.

**Block 4**
- L5214 "An **interval** rhythm carries no start date, so an interval schedule's own start date is not
  part of what is said" — a rule about the shape of the answer; scenario 1 names an interval rhythm of
  14 days but does not assert the absence of a start date. **Partially covered.**
- L5226 "The kind is **not** among the four a change is asked with … so this is said to be *shown* and
  never to be asked about" — the shown-not-asked rule; block 5 restates the asked half normatively, so
  only the *shown* half is this requirement's, and it is only in rationale.
- L5235 "every control is there, and the ones that cannot be changed do not let a thumb in" — a UI rule
  with **no scenario**, and contradicted four lines later by "What a form draws … are the drawing's".
  Resolve before rewriting; do not carry both.

**Block 5**
- L5331 "the superseded commitment then carries the new name and the corrected day it was kept from …
  while the commitment taken on carries the new name, the new rhythm and the day the screen was handed"
  — the whole rule for the both-in-one-save case, stated only as the justification of the order.
  **Highest-risk sentence in scope.** Scenario 5 covers name + rhythm; **no scenario** covers a change
  that moves the day kept from *and* the rhythm together, which is exactly what this sentence fixes.
- L5342 "every day already recorded on stays due" — scenario 6 covers the widening only; **no scenario**
  covers a recorded day surviving a non-interval move.
- L5348 "The record place is written before the roster place" — an ordering rule whose three following
  sentences are the argument for it. **No scenario**: no scenario makes the record place fail.
- L5354 "Where nothing is carried over, nothing is written at the record place at all." — **no scenario**;
  scenario 12's byte-for-byte assertion is about the roster place only.
- L5357 "SHALL carry whatever that kind carries unchanged with it" — scenario 18 covers number/range;
  **total/target uncovered.**
- L5391 "a change whose result the roster holds in **any** of the three states is refused" — closes a
  sentence opening "and that is the decision"; scenario 11 asserts it.
- L5394 "The fifth covers the record place as well as the roster place" — **no scenario**; scenario 16
  makes only the roster place unwritable.

**Block 6** — L5684, the **move** clause: the only sentence in scope saying a move writes a category.
It is a cross-reference to *A commitments screen moves a commitment among the ones it keeps* and
belongs there; cutting it loses nothing this requirement owns.

**Block 7**
- L5772 "Both ends blank is not this refusal and is not a refusal at all — it is a commitment of the
  number kind carrying no range" — a rule stated only to close a rationale paragraph, and **no scenario
  in this block** defines a number commitment through the screen with both ends blank. Flag hardest.
- L5763 "The `commitment` capability's rules for a range and a target are unchanged by this requirement."
  — an exclusion protecting another capability's spec. **No scenario**; keep as one clause.
- L5750 "told apart from every other this screen makes but not from each other" — the two-not-six rule,
  wrapped in the ADR-1021 argument; scenario 10 asserts it.

**Rules with no scenario at all** (gathered): B1 L4884, L4897, L4903; B2 L5001; B3 L5109 (first/last
date), L5115; B4 L5235; B5 L5348, L5354, L5394; B7 L5772, L5763 — twelve in all. Nine are negative or
cross-seam surfaces; **B5 L5348, B5 L5394 and B7 L5772 are the three that name behaviour a test could
assert today** and should either gain a scenario or be recorded as knowingly untested.

## 3. Rationale needing a home

| Block | Rationale | Home |
|---|---|---|
| 1 | stopped and removed both count; "a roster never lets a commitment go" (L4883–4889) | ADR-1035 — records that removed is a third state answered about a date exactly as stopped is |
| 1 | the answer is the roster's, not the commitment's; the commitment hands out no kept-from day (L4903–4909) | **none** — no ADR records the aggregate-question decision or the day-picker bound it serves |
| 2 | replacement rather than remove-then-add; order and kept-until preserved (L4971–4974) | ADR-1037 (a roster's order is the person's) for the order half; the kept-until half **none** |
| 2 | the offered category wins whatever the commitment was under (L4976–4978) | ADR-1038 — a category is the roster's, and what a commitment is offered under wins |
| 2/3 | changing *into* a commitment the roster holds would merge two histories (L4990–4993, L5104–5107) | **none** — the strictness is argued only in the spec |
| 3 | supersede rather than mutate; a commitment has no identity; the roster holds no link (L5089–5098, L5115–5118) | ADR-1023, 2026-09-09 amendment — states both acts and names the no-link price knowingly taken |
| 4 | a form that had lost the kind would read as a different form; the kind is shown, never asked (L5226–5238) | ADR-1030 — "the kind is the one part of the four that no change reaches"; the *shown* half is uncovered |
| 4 | this says what a commitment is, and no words a person reads (L5240–5242) | ADR-1022 via ADR-1046 L37, which cites it as "a screen holds no words a person reads" |
| 5 | name and kept-from correct the past; a rhythm change supersedes; the interval grid moves with the day (L5320–5346) | ADR-1023, 2026-09-09 amendment — carries all three, including the interval-grid refusal |
| 5 | the record place is written before the roster place, and why the reverse cannot be repaired (L5348–5355) | **none in `docs/adr/`** — it is in `openspec/changes/archive/2026-09-09-add-commitment-editing/design.md` L110–111, which is archived and not a live home |
| 5 | a fifth thing asked for would buy a refusal the form cannot produce (L5357–5364) | ADR-1030 |
| 5 | each refusal names a cause a person can act on differently (L5398–5401) | ADR-1036 |
| 6 | the phone capitalises, so offering removes the problem instead of folding case (L5662–5673) | **none** — ADR-1038 covers a category being the roster's but not the offering or the case rule |
| 6 | a stopped commitment's category is not offered because the stopped list draws no headings (L5675–5680) | ADR-1038 L68–72 — a stopped commitment goes on being under its category, off the filing list |
| 7 | two refusals, not six and not one (L5750–5758) | ADR-1021's rule as applied by ADR-1036 |
| 7 | the screen refuses exactly what the value refuses; contrast with ADR-1028 (L5760–5767) | ADR-1046 L48, L77 |
| 7 | a half-written range is the one case the value cannot be asked about (L5768–5774) | ADR-1046 L88–90 — records exactly this, that `nil` would conflate blank and not-a-number |

Three subjects have no ADR: block 1's aggregate question, block 5's write order, and block 6's
offering-and-case rule. Those are the pieces an editorial rewrite cannot simply delete.

## 4. Scenario duplication

- **Block 1, scenarios 3 and 4** (L4917, L4926) — *counts a commitment it has stopped* / *counts a
  commitment it has removed*. Identical WHEN but for the verb, and byte-identical THEN and AND.
  A fixture-only pair. **Keep the removed one**, fold the stopped case into an AND: a naive
  implementation filtering to kept commitments fails either, and removed is the state most likely to
  be written as an exclusion.
- **Block 2, scenarios 3 and 4** — look like that pair but are not: 3 asserts one commitment on the
  stopped list, 4 asserts none. **Keep both.**
- **Block 5, scenarios 8 and 10** — checked arithmetic rather than assumed. Scenario 10 moves the day
  back by exactly one interval (17 June + 14 = 1 July), so its new grid still contains the old due
  days and it does **not** prove the grid moved off them; only scenario 8 does. **Keep both.**
- **Block 5, scenarios 7 and 9** — same shape, different rhythm and opposite direction of travel, and
  the prose states them as two separate rules. **Keep both.**
- **Block 5, scenarios 12 and 15** — same byte-for-byte assertion, different triggers. **Keep both.**
- **Block 5, 21 scenarios, hard look:** no true duplicate found. The pressure there is prose length,
  not scenario count — the block covers three acts and seven refusals in one requirement and is the
  one block that should be **split**, most naturally into *which act a change performs* and *what a
  change is refused for*.
- **Block 7, scenarios 1, 10 and 11** share one fixture ("Mood", lowest 10, highest 1). Scenario 1's
  only assertions — refused as a range that is not a range, nothing kept — are both contained in
  scenario 10, and scenario 11 re-runs the fixture for the held-against-defining assertion.
  **Keep 10 and 11; scenario 1 is droppable.** Scenario 5's first clause is likewise contained in 10,
  but its `-1` AND is not, so **keep 5**.
- **Block 7, scenarios 4 and 6** — "120g" vs. blank. Same refusal token, but the prose makes a missing
  target a deliberate decision rather than a commitment with no target. **Keep both.**

## 5. Scenario prose

**0 of 66 scenarios** carry text outside `WHEN`/`THEN`/`AND` bullets — measured by walking each
scenario body and rejecting any non-empty line that is neither a `- **…**` bullet nor an indented
continuation of one. Nothing to do here.

## 6. Totals and recommendation

| | Now | After |
|---|---|---|
| Lines | 1,022 | — |
| Words (whole blocks) | 12,636 | ~11,160 |
| Prose words (heading to first scenario) | 4,746 | ~1,170 |
| Scenarios | 66 | 65 (or 64 if block 1's pair is folded) |

The seven ADDED blocks average 678 prose words against a 150-word ceiling, and the split is stable
across them: roughly half normative, a third rationale, a sixth cross-reference. That regularity is
the good news — the rewrite is one repeated move, not seven judgements. Cut every "and that is the
decision", every rejected alternative and every "for the same reason X" pointer, and the prose falls
by about three quarters on its own. The care is owed in three places. First, twenty-two rules currently
ride inside rationale sentences (§2), twelve of them with no scenario at all and three of those
naming behaviour a test could assert today; and the rewrite is the moment to either write those scenarios or say in the change folder that
they are knowingly untested. Second, three rationale subjects have no ADR home (§3) — block 1's
aggregate question, block 5's record-place-before-roster-place order, and block 6's offering-and-case
rule — so an ADR has to be written or amended before the prose carrying them is deleted, not after.
Third, block 5 should be split rather than compressed: at 1,622 prose words and 21 scenarios it is a
requirement holding three acts and seven refusal causes, and no amount of trimming brings one heading
under 150 words honestly. Scenario titles need not move anywhere in this scope, and no scenario body
needs reshaping.

## Appendix — the two REMOVED rows

Both headings are confirmed absent from `openspec/specs/commitment/spec.md`; the only surviving copies
are under `openspec/changes/archive/`.
- *A commitments screen says in words the rhythm its form is building* — removed by `add-commitment-editing`
  in `23460a7`. **None of its five scenarios was absorbed**; all five are gone from the live spec, and
  the surviving "in words" rule at L1728/L1885 is the list-row rendering in *A commitments screen lists
  the commitments its roster keeps*, which is a different surface from the form preview.
- *A commitments screen puts a commitment under a category, and offers the categories in use* — removed by
  `rework-commitment-row-actions` in `f18314f`. **Five of its nine scenarios were absorbed verbatim by
  block 6**, *A commitments screen offers the categories in use* (all five of that block's scenarios);
  the four that wrote a category are gone, and the nearest survivor of *a category taken off …* is block
  5's *a category taken off through a commitments screen's change draws its commitment among the ones
  under none*, which asserts the same outcome through a change instead of a standalone act.
