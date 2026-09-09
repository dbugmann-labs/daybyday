# Survey: `openspec/specs/record/spec.md`

2,076 lines, 25,729 words, 15 requirements, 159 scenarios. Prose between a requirement heading and
its first scenario totals **8,473 words** (583 lines) — 33% of the file. Scenario titles are
confirmed contracts (`RecordTests.swift` carries them verbatim).

## Per-requirement table

Split columns are: (a) normative rules / (b) rationale, alternatives, "why" / (c) cross-references,
exclusions, restatements of other requirements.

| # | Requirement (short) | Lines | Prose words | Scen. | (a) | (b) | (c) | Verdict | After |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Store reads every earlier form | 12–217 | 837 | 13 | 45% | 40% | 15% | rewrite | ~190 |
| 2 | A tick is commitment + due date | 218–370 | 717 | 14 | 40% | 35% | 25% | rewrite | ~150 |
| 3 | History answers *kept* | 371–576 | 714 | 20 | 50% | 30% | 20% | rewrite | ~170 |
| 4 | A tick can be taken back | 577–624 | 129 | 5 | 80% | 15% | 5% | keep | ~110 |
| 5 | Store keeps a history at a place | 625–973 | 882 | 29 | 60% | 25% | 15% | rewrite | ~200 |
| 6 | Unreadable store refused, not emptied | 974–1086 | 530 | 7 | 55% | 30% | 15% | trim | ~170 |
| 7 | A number is of a number commitment | 1087–1238 | 715 | 11 | 40% | 35% | 25% | rewrite | ~140 |
| 8 | History answers *what number* | 1239–1346 | 404 | 9 | 60% | 25% | 15% | trim | ~130 |
| 9 | A number can be taken back | 1347–1410 | 276 | 5 | 60% | 30% | 10% | trim | ~120 |
| 10 | A note is of a note commitment | 1411–1541 | 766 | 8 | 45% | 35% | 20% | rewrite | ~150 |
| 11 | History answers *what note* | 1542–1656 | 417 | 9 | 60% | 25% | 15% | trim | ~130 |
| 12 | A note can be taken back | 1657–1721 | 294 | 5 | 60% | 30% | 10% | trim | ~120 |
| 13 | An addition is of a total commitment | 1722–1842 | 733 | 7 | 45% | 35% | 20% | rewrite | ~150 |
| 14 | History answers *what added* | 1843–1983 | 662 | 10 | 55% | 30% | 15% | rewrite | ~160 |
| 15 | Last addition can be taken back | 1984–2076 | 397 | 7 | 70% | 20% | 10% | trim | ~140 |

Prose after rewrite: **~2,230 words** (a 74% cut). Six requirements land above the 150-word target
even when concise — 1, 3, 5, 6, 14 and 15 each carry four record types' worth of genuine rules, and
1 and 5 will not fit 150 words without losing something a test reads. Recommend those two be split
(see Totals) rather than squeezed.

## 1. Rules at risk

Sentences that read like rationale but carry a rule a test or a later requirement depends on. A
naive "cut the *because* clauses" pass loses these.

**Req 1 — store reads every earlier form**
- L34: `"— so with a total of zero on every day, and with every total commitment in it not kept —"`
  looks like a gloss on the preceding rule; it is the exact assertion of the last two `AND` bullets
  of *a history kept before a day could hold an addition is read…* (L188–189).
- L48: `"it SHALL refuse a form number it has never written at all — one below the earliest — as
  content that is not a store"` — the scenario at L96 asserts the *error kind* ("says the content is
  not a store rather than that it is from a later form"). The rule is in the middle of a sentence
  that ends in rationale about "a number no version of this app ever wrote".
- L41–43: `"The next change kept there SHALL be written in the form this app writes, whole, and every
  tick, every number and every note the earlier form held SHALL still be in it."` — this is the whole
  of the three "X added over a history kept in an earlier form is read back beside…" scenarios. It
  sits inside the paragraph whose headline rule is the byte-for-byte no-op on open.
- L61–63: `"Which shape belongs to which form SHALL be judged against the form each part was first
  written at… Numbers arrived at the third form, notes at the fourth and additions at the fifth"` —
  the second half reads as history but is the only place the spec says which form each part begins
  at, and the L165/L206 scenarios ("a store written in the form used before a note, holding neither
  notes nor additions, is read without error") test exactly it.

**Req 2 — a tick**
- L233–237: the `commitment`-delegation sentence ends `"so a date before the day the commitment is
  kept from takes no tick… and a commitment whose schedule is due on no date takes no tick on any"`.
  Those two clauses are two scenarios (L279, L286). The paragraph's rule sentence alone does not
  produce them.
- L246–256: the three "the refusal here does not soften because such a record now exists" clauses
  each carry a scenario (L343, L352, L360), including `"whether or not those additions have reached
  its target"`. Everything around them is restatement of reqs 7/10/13 and is droppable; these are
  not.
- L259: `"a screen that wants to withhold days that have not arrived does so itself, with the day it
  asked the device for"` — reads as advice to another capability, but it is the only statement of
  the *scope exclusion* behind "no present moment". Repeated verbatim at L1129, L1456, L1768. Keep
  once, as a single normative "the system MUST NOT consult the present moment" plus one exclusion
  sentence; do not keep four copies.

**Req 3 — history answers *kept***
- L389–392: `"The comparison SHALL be the sum against the target, in that order and never the target
  against the sum: the two do not answer alike where a sum is not a number at all, and only the first
  of them answers not kept there."` This is a rule about comparison *direction*, grounded in
  `Decimal`'s asymmetric NaN comparisons (ADR-1032). It is the most deletable-looking and least
  droppable sentence in the file — no scenario names it, so nothing in CI catches its loss.
- L387–388: `"a day holding no addition sums to zero, which is below every target there can be, a
  target being above zero"` — carries the *target is above zero* fact this capability otherwise never
  states, and req 14's zero-sum rule leans on it.
- L404: `"never widens the question to the commitments alike to it in three parts out of four"` —
  reads as flourish; it is the rule that commitment identity is all four parts, and the L471 and
  L487 scenarios ("a commitment alike in every way but of the tick kind") depend on it. Repeated at
  L1252, L1557, L1877.

**Req 5 — the store**
- L644–647: `"keeping the kind changes what is written rather than what can be read back; it is kept
  all the same, because a store persists what a commitment is and not the parts of it that happen to
  vary."` The *rule* — the kind is persisted — exists nowhere else, and the earlier-form scenarios
  (L104, L138) read a kind back. Pure-looking rationale wrapping a persistence requirement.
- L676: `"the order read back SHALL be the order they were made in, because the order is what names
  the addition a take-back removes"` — the rule is safe; the *because* clause is the only statement
  linking store order to req 15, and the L907 scenario's last `AND` ("so the addition of 50 was the
  one the order named") tests that link.
- L679–680: `"A store MUST NOT persist the day's sum, which is derived from the additions and is not
  a record."` Normative, easily read as commentary, no scenario asserts it.
- L662–669 (note fidelity): `"in the very form each character was given in rather than any other
  form of the same writing"` is the Unicode-normalisation rule, and it is the second `AND` of the
  L857 scenario. It reads as emphasis on "character for character".

**Req 6 — unreadable store**
- L991–992: `"A fourth is named by *A store reads a history kept before a commitment carried a kind*
  above"` — a cross-reference, but it is the only thing tying req 1's shape/form-mismatch refusals
  into this requirement's refusal contract. Safe to drop *if* req 1 keeps its own refusal rules.
- L1000–1009: the whole *"Each addition SHALL be re-formed on its own, and no rule SHALL be applied
  across a day"* paragraph is a rule plus a large "that is not the leniency the paragraph above
  forbids" defence. The L1075 scenario (a day summing past exact keeping is read, not refused)
  depends on the rule *and* on the scope exclusion `"what a day's additions may sum to is not a rule
  this capability has — it is decided where a person makes an addition"` (ADR-1040). This is the one
  exclusion the concise shape's "no exclusions unless a test depends on them" clause must let stand.

**Req 7 — a number**
- L1112–1115: `"A range is bounds and nothing else: it does not say a number must be whole, it fixes
  no step, and it does not enumerate the values it allows"` — three rules in one rationale-shaped
  sentence; L1187 ("5.5 on a range of 1 to 10") tests them.
- L1120–1123: the NaN paragraph's `"a value that is not a number compares as below every bound and
  above none, so a commitment with no range would take one"` is why the refusal sits at formation
  rather than at the range check; L1202's second `AND` (refused with *and* without a range) tests
  the consequence.

**Req 10 — a note**
- L1437–1441: `"Blank space SHALL mean whitespace in the full sense, and SHALL be judged by the same
  test this system already judges a commitment name by… a character that test does not call
  whitespace is not blank space here however little of it a person can see."` This is the ADR-1039
  rule, stated only as a cross-reference. L1493 tests the no-break space. The trailing clause is the
  rule that a zero-width space is *not* blank — which ADR-1039 says a real paste bug turned on.
- L1449–1451: `"Blank space at the start or the end of a note is kept with it"` — the L1503
  scenario's whole point, buried in a sentence that ends in rationale about where tidying belongs.
- L1445–1447: `"A note MAY hold a line break, and holding one changes nothing about it"` — tested at
  L1511.

**Req 13 — an addition**
- L1726: `"no position of its own among the additions of its day"` — an identity rule (an addition
  does not carry an index), and the reason req 14's equality is order-of-the-day rather than
  per-record. Reads as part of a list of absences.
- L1749–1752: the "second way back" paragraph is rationale for refusing negatives, but
  `"MUST NOT accept the amount and add nothing, and MUST NOT substitute an amount of its own"`
  (L1745–1747) sits in the same block and is normative.
- L1758–1761: `"This capability declares no ceiling of its own: a day may be added to as many times
  as a person adds to it, and what a day's additions may sum to is decided where a person makes
  one"` — the scope exclusion req 6's L1075 scenario relies on. Must survive.
- L1772–1774: `"That two additions of 30 on one day are the same addition does not make a day given
  both hold one"` — reads as a disclaimer; it is the reconciliation of req 13's identity rule with
  req 14's multi-record rule, and the L929 store scenario tests the outcome.

**Req 14 — history answers *what added***
- L1868–1871: `"A history SHALL give out the sum and SHALL NOT give out the additions themselves."`
  A surface/API rule (ADR-1041 records it), followed by "nothing needs the list" rationale. No
  scenario can assert an absence, so a trim that takes the paragraph as a block deletes the rule
  silently.
- L1861–1863: `"the sum of no additions really is zero whatever the commitment, so zero is a true
  answer rather than a stand-in"` plus `"every addition is above zero, so a sum above zero means the
  day holds at least one"` — the second clause is the invariant req 15's L2059 no-op scenario reads.
- L1886–1890: `"in the same order on every day SHALL be the same history… they do not answer the
  same take-back"` — the rule is safe; the clause is why L1962 ("different orders are different
  histories") exists.

**Req 15 — last addition**
- L1992–1997: `"Only the last SHALL go, and there SHALL be no way to take back any other… MUST NOT
  offer taking back an addition by naming its amount… and MUST NOT offer clearing a day's additions
  in one act."` Three surface prohibitions; no scenario asserts any of them (absences again). The
  "one act erasing six records" sentence after them is droppable rationale, but the prohibitions are
  not.

## 2. Rationale needing a home

| Rationale | Home |
|---|---|
| Reading every earlier form rather than refusing; each form read as its own shape; no rewrite on open (req 1, L14–58) | **ADR-1031** — records exactly this, amended twice for the fourth form. Drop from spec. |
| Judging each part against the form it was **first** written at (req 1, L61–68) | **Not in ADR-1031** (its amendments cover "a fourth form", not per-part first-form). Keep the rule normative; the "silently re-declare" argument needs a sentence in ADR-1031 or is dropped. |
| Numbers are decimals; a not-a-number value must be refused at formation because comparisons are asymmetric (reqs 3 L389, 7 L1120, 13 L1753) | **ADR-1032**. Drop the argument; keep the comparison-direction rule. |
| Take-back by naming commitment + date, not by value; the tick keeps its by-value shape (reqs 9 L1349, 12 L1659, 15 L1986) | **ADR-1033**. Drop from all three; keep the rule. |
| Blank is one test in one place, `Character.isWhitespace` (req 10, L1437) | **ADR-1039**. Drop the "one test, asked in one way" paragraph; keep the rule and the reference. |
| What a day's additions may sum to is the `day-screen`'s cap, not this capability's (reqs 6 L1005, 13 L1758) | **ADR-1040**. Keep as a scope exclusion (a test depends on it); drop the "second, quieter definition in the other direction" defence. |
| A history gives out the sum, never the list; no one-act clearing (reqs 14 L1868, 15 L1996) | **ADR-1041** (L90 states it). Drop the argument; keep the prohibitions. |
| Records live in one file / durability with no separate save step (req 5, L634–638) | **ADR-1017**. Drop the "the app can be stopped at any moment" argument; keep "kept before the store reports it added". |
| "A false record of the sort this product exists to remove" (reqs 2 L243, 7 L1104, 10 L1425, 13 L1738; also req 6 L980) | Product-principle rhetoric, four near-identical copies. Belongs in `CONTEXT.md` § Product principles if anywhere; **simply dropped** from the spec. |
| "It is here because a record nothing can read back is not a record" (reqs 8 L1244, 11 L1547) | No ADR; a design note about why a reader exists. **Dropped.** |
| "A target is what a day has to reach and never a ceiling" (reqs 3 L386, 13 L1762) | No dedicated ADR; ADR-1045 is about marking a target on screen, not this. Keep as one normative sentence (additions past the target keep the day); drop the restatement. |

## 3. Scenario duplication

Pairs/families that differ only by fixture. Recommended keeper in **bold**.

- **Req 1 (drop 5):** four "*X* added over a history kept before a day could hold *X* is read back
  beside the records already there" (L86, L116, L151, **L192**) — one behaviour: a change written
  over an earlier form is read back whole. Keep the additions one. Three "a store whose shape and
  declared form disagree about *X* is refused" (L128, L165, **L206**) — keep the additions one; it
  already carries the "an earlier form holding neither is read without error" `AND`.
- **Req 2 (drop 3–4):** "a number commitment with a number… still takes no tick" (L343) / "a note
  commitment with a note… " (L352) / **"a total commitment whose day is at its target…" (L360)** —
  one behaviour, keep the total (it adds the target dimension). "a tick is formed on the last day of
  a month too short" (L292) duplicates the `commitment` capability's month arithmetic; fold into
  **L273/L279**.
- **Req 3 (drop 4):** "a number commitment with a number recorded… was kept" (L480) is subsumed by
  **"every number a commitment accepts keeps its day" (L497)**; same for the note pair (L517 vs
  **L534**). "a commitment whose kind is not a tick was not kept" (L471) and "a commitment of the
  note kind and one of the total kind were not kept" (L506) overlap — keep **L471**, widened. "a
  total commitment is kept on one day and not on another" (L567) = **L550** plus day isolation.
- **Req 5 (drop 13 — the worst offender):**
  - Four "*X* added to a store is held by a second store opened at the same place while the first is
    still open" (**L688**, L768, L829, L897) — one durability behaviour, four record types.
  - Four "a store opened again holds exactly the ticks[, numbers][, notes][ and additions] added and
    not taken back" (L704, L806, L873, **L948**) — strictly cumulative; the last subsumes all three.
  - Four "an *X* that cannot be kept is refused and not held" (**L759**, L819, L887, L964) —
    identical assertions, four fixtures.
  - Three/four "*X* taken back is not held by a store opened afterwards" (**L695**, L777, L839,
    **L918**) — keep the tick and the addition (the addition one also tests order).
  - Two "*X* entered again is kept once… as the later" (**L787**, L848).
  - "a number is read back exactly as it was given" (**L796**) vs "an amount is read back exactly as
    it was given" (L938) — same digit-for-digit rule. Keep the note one (L857) separately: its
    normalisation assertion is distinct.
- **Req 7 (drop 2):** "a note commitment with a note… still takes no number" (L1222) and "a total
  commitment with additions… still takes no number" (L1230) fold into **L1157**.
- **Req 10 (drop 1):** "a total commitment with additions… still takes no note" (L1533) folds into
  **L1482**.
- **Reqs 8, 11, 14 (drop 1 each):** the "*X* on one date is not *X* on another date" / "*X* of one
  commitment is not another's" pairs (L1285+L1294, L1589+L1598, L1915+L1924) are two halves of one
  isolation rule; merge each into one scenario with two `AND`s.

**Total: 31 of 159 scenarios dropped or merged → 128.** Reqs 4, 6, 9, 12, 13 and 15 have no
duplication worth acting on; req 5 alone accounts for 13 of the 31.

## 4. Scenario prose

**Zero.** All 159 scenarios are pure `- **WHEN** / **THEN** / **AND**` bullets with indented
continuations; no paragraph or bare sentence appears inside a scenario body anywhere in the file.
The prose problem is entirely above the first scenario of each requirement. Bullets *are* dense —
many `WHEN`s run 4–7 wrapped lines and some `AND`s smuggle a second assertion plus its reason
("so the addition of 50 was the one the order named", L916) — but that is not the shape violation
the concise target names.

## 5. Totals

| | Now | After rewrite |
|---|---|---|
| Lines | 2,076 | ~1,400 |
| Words | 25,729 | ~16,200 |
| Requirement prose | 8,473 | ~2,230 (−74%) |
| Scenarios | 159 | 128 (−31) |

**Recommendation: rewrite the whole spec, requirement by requirement, and split two of them.** This
is not a trim job — nine of fifteen requirements need their rules re-extracted, because in this spec
the rule and its justification are routinely the same sentence (L34, L48, L645, L676, L1112, L1437,
L1758 are all "rationale-shaped clause carrying the only statement of a rule a test reads"). A pass
that deletes paragraphs by their rhetorical shape will pass CI — every scenario title survives, every
test still runs — while silently dropping the comparison-direction rule (L389), the
kind-is-persisted rule (L645), the sum-not-the-list surface rule (L1868) and the three take-back
prohibitions (L1992), none of which any scenario asserts, because they are all prohibitions or
absences. So: do the rewrite one requirement at a time, and treat § 1 above as the checklist each
rewritten requirement must still contain. Two requirements should not be squeezed into 150 words but
split instead — req 1 into *which forms are read* and *what each form means*, and req 5 into
*durability* and *what a store persists per record type* — which also breaks up the 29-scenario
block where more than a third of the file's duplication lives. Reqs 4, 9, 12 and 15 are close to the
target already and need only their ADR-1033 rationale removed; they are the cheapest place to start
and the best template for the rest.
