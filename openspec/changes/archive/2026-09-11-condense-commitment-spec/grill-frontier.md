# Grill frontier — `condense-commitment-spec`

Sources: `survey-commitment-A.md` (original requirements 1–18), `survey-commitment-B.md` (19–36),
and the 2026-09-10 re-baseline `survey-2026-09-10-commitment-modified.md` (the 12 blocks the
re-baseline marks MODIFIED) and `survey-2026-09-10-commitment-added.md` (the 7 blocks it marks
ADDED), all under `docs/research/2026-09-09-concise-specs/`. Supersession was resolved by title,
not line number, per the brief: every heading the 2026-09-10 pair covers replaces A/B's entry for
that title; the 22 requirements neither pair touches (11 from A, 11 from B) are unchanged since the
surveyed base commit and A/B stand for them as written. Two headings A/B once covered no longer
exist and are confirmed removed in `survey-2026-09-10-commitment-added.md`'s appendix. Every
heading, word count and scenario count below was re-measured this session directly against
`openspec/specs/commitment/spec.md` on `main` (`git status` clean, nothing to rebase past) with a
script that walks all `### Requirement:` headings and counts words up to the first
`#### Scenario:`: **41 requirements, 406 scenarios, 26,522 prose words** — matching the brief's
figures exactly, and matching every individual count either survey cited for a still-current
heading. ADR numbers and titles were confirmed against `ls docs/adr/`; several "no ADR home" claims
were spot-checked with topic greps across `docs/adr/*.md` (seven/numbering, write order, aggregate,
case-folding, half-a-range, ignored, one-act, adjust, grouped, emptied, flat list) and none turned
up a closer match than the survey already named. Untested-rule claims were spot-checked against
`src/DayByDayKit/Tests/DayByDayKitTests/{RosterTests,RosterStoreTests,CommitmentsScreenTests,
CommitmentTests}.swift` for a sample spanning all three lists (see List B).

**One survey claim did not hold up.** Survey B's write-up of *A roster puts a commitment under a
category* names no scenario for "two commitments are under one category when the words are the same
word, and under two when they are not," which reads as untested. A direct check found it partially
covered: the scenario titled *a category is held exactly as it was given, blank space at its ends
and all* (`RosterTests.swift`, category " Supplements " vs. "Supplements") asserts that two visually
close but byte-different category strings form two separate groups — the identity half of the rule.
It is not in List B below on that basis, though no scenario asserts the positive half ("same word ⇒
same group") independently of that whitespace case.

## A. Rationale with no ADR home

Eleven pieces, matching the count the brief expects. All eleven survive as rationale only in the
current spec prose; none is recorded in an ADR under a name close enough to call the same decision.

| Short name | Requirement heading | Claim | Nearest ADR | Verdict |
|---|---|---|---|---|
| no-numbering (seven refusal kinds) | *A commitments screen holds the change it refused and why, one at a time* (L2862) | The seven refusal kinds this requirement introduces are counted here and nowhere else; no other requirement may identify one by its position among them. | none — exists only in the archived `rework-commitment-row-actions` change folder | Load-bearing: it is a rule about how the rest of this spec must be written, and a length-driven rewrite already forced one other requirement's sentence to be reworded because of it. |
| record-place-before-roster-place | *A commitments screen changes a commitment on either of its lists* (L5348) | On a change that touches both places, the record place is written first, deliberately, so a record-place failure never leaves the roster looking committed to a change the record never took. | none in `docs/adr/` — lives only in the archived `add-commitment-editing` `design.md` | Load-bearing: an ordering guarantee with a real failure mode, and no scenario exercises it (List B). |
| aggregate earliest-day question | *A roster answers the earliest day anything it holds has been kept from* (L4903–4909) | The answer is the roster's, not any one commitment's, because a commitment hands out its name and kind and nothing else; this is the one way anything outside the capability learns where a person's history begins, and it is what bounds `day-screen`'s picker. | none — ADR-1048 records the picker consuming this answer, not why the question belongs to the roster | Load-bearing: explains an API-shape decision another capability depends on. |
| offering-and-case for categories | *A commitments screen offers the categories in use* (L5662–5673) | Offering already-used categories, rather than folding case when matching, is what stops "Supplements" and "supplements" silently becoming two groups — without the app guessing which spelling a person meant. | none — ADR-1038 covers a category being the roster's, not the offering-as-safety-mechanism argument | Load-bearing: explains why offering exists at all, not merely that it's convenient. |
| half-a-range | *A commitments screen refuses a range that is not a range, and a target that is not a target* (L5768–5774) | A half-written range (one end typed, one left blank) is its own refusal because there is no such value as "half a range" to hand the range type — it isn't completed and isn't the same as a wholly blank range. | none — ADR-1046 decides how the refusal is worded, not what an incomplete range *is* | Load-bearing. |
| ignore-rather-than-refuse | same heading (L2090–2096, restated at L5750–5758) | A range or target left in a field the chosen kind has no room for is silently ignored, not refused — choosing Note after typing a range isn't an error. | none — ADR-1046 covers refusal wording only | Load-bearing. |
| one-act-one-outcome | *What a commitments screen holds about a refused change lasts until the app is shown again or a change is kept* (L3084–3089) | A change reaching both the record and roster places ends what's held in one act, however many places it touched. | none as an ADR — the phrase exists only in two archived change folders | Load-bearing, and currently untested (also List B). |
| refuse-rather-than-adjust | *A range is a lowest and a highest…* (L212–214) and *A target is a number above zero* (L257–260) | An invalid range or target is refused outright rather than silently corrected (swapped ends, a substituted default target). | none exactly — ADR-1032 (decimals) and ADR-1040/1041 (sums, blank commits) are adjacent, none states this refuse-vs-adjust stance | Borderline: the SHALL/MUST NOT sentences survive with no rationale at all, so dropping this costs least of the eleven. |
| store-must-not-write-groups | *A roster store keeps a roster at a place…* (L1104–1105) | The store must never persist the category grouping to the file; groups are a reading of the roster's one order, re-derived on every read. | none exactly — ADR-1038 states the grouping rule exists once, not this storage corollary | Load-bearing, and currently untested (also List B). |
| refuse-rather-than-empty | *A roster store that cannot be read is refused rather than emptied* (heading itself, L1635) | An unreadable store is reported as an error rather than silently treated as a fresh, empty roster. | none exactly — ADR-1035 (a roster never lets a commitment go) and ADR-1027 (day one written into an empty roster) are adjacent, neither covers an unreadable store | Load-bearing: protects against silent data loss being indistinguishable from a first launch. |
| stopped-list-not-grouped | *A commitments screen lists what has been stopped, beside what it keeps* (L1890–1896) | The stopped list is deliberately one flat list, never grouped by category — it's the shorter-lived of the two lists and grouping "would double the structure of the screen for the list that needs it least." | none exactly — ADR-1038's "flat list" mention rejects a different design (per-screen-computed grouping vs. roster-computed) | Closest to a straw-man: the "would double the structure" claim is asserted, not measured, and the MUST NOT SHALL survives without it. |

## B. Rules with no scenario

Twenty-seven rules across the whole spec (not just the changed blocks), grouped by requirement.
Twelve are the ADDED survey's own consolidated list (§2 there, verbatim by line); the rest come
from the MODIFIED survey's "Rules at risk" section and from A/B's for the twenty-two unchanged
requirements, filtered to ones that read as behavioural rather than as a spec-writing convention.
"Untested" below means: no `#### Scenario:` anywhere in the current spec exercises it, verified for
a spread of these against the Swift suite (grep for `link`, `grouped`, `kindToOffer`, `200B` /
zero-width, `duplicate`, `timeZone`/`locale`, `shift`) and found no hit in every case checked.

| # | Requirement heading | Rule (one sentence) | Test? |
|---|---|---|---|
| 1 | A commitment is not due before the day it is kept from | The kept-from floor does not shift the schedule's own start date or phase — it's a floor, not a phase change. | Untested (verified: no `shift` anywhere in `CommitmentTests.swift`) |
| 2 | A roster holds the commitments a person keeps, in the order they were taken on | Being changed or superseded gives neither the old nor the new commitment a fifth part — the roster holds no link between them. | Untested (verified: zero `link` hits across the whole test suite) |
| 3 | A roster refuses a commitment it already holds | Refusing a duplicate compares the whole value for a target exactly as it does for a range. | Untested (target half only; the range half has a scenario) |
| 4 | A roster store keeps a roster at a place… | The store MUST NOT write commitments grouped by category to the file. | Untested (verified: no `grouped`/raw-byte inspection in `RosterStoreTests.swift`) |
| 5 | A roster store keeps a roster at a place… | A change of commitment reaches the record place too, and a roster store specifically is not what reaches it. | Untested in this block |
| 6 | A commitments screen defines a commitment… | A commitment the screen already holds offers no kind at all to a change — kind isn't one of the four change fields. | Untested (verified: only two `kindToOffer` assertions exist, both for a *new* commitment) |
| 7 | A commitments screen defines a commitment… | A range/target end holds no more than thirty-eight significant digits. | The scenario that exists doesn't reach that boundary |
| 8 | A commitments screen defines a commitment… | A zero-width-space-only end is refused as "not a number," not as "blank." | Untested (verified: no zero-width-space case in `CommitmentsScreenTests.swift`) |
| 9 | A commitments screen tells a commitment it already keeps apart from a roster it could not write | The already-holds-it refusal applies across all three states (kept, stopped, removed), not only "currently kept." | Untested within this requirement's own 4 scenarios; asserted only by a scenario in the ADDED *changes on either list* requirement |
| 10 | same | A change the screen could not keep is reported the same way whether the record place or the roster place refused it. | Untested within this requirement; same cross-requirement caveat |
| 11 | same | Changing another commitment's fields into a duplicate of this one is refused. | Untested (verified: `duplicate` appears only in a code comment, not a test) |
| 12 | A commitments screen holds the change it refused and why, one at a time | The seven refusal kinds are counted only here; no other requirement identifies one by position. | Untestable by construction — a rule about how requirements are written |
| 13 | What a commitments screen holds about a refused change lasts… | A change reaches the record place as well as the roster place; ending what's held is one act. | Untested (the record-place half) |
| 14 | same | A change asked about a commitment on neither of the screen's two lists is one of the enumerated no-op cases. | Untested — last of a four-item enumeration; the other three are tested |
| 15 | A roster answers the earliest day anything it holds has been kept from | Neither stopping nor removing raises the answer; taking a commitment up again does not lower it. | Untested |
| 16 | same | The answer MUST NOT consult the present moment, the device's time zone or the locale. | Untested (verified: no `timeZone`/`locale` near the earliest-day tests) |
| 17 | same | A commitment reads back only its name and kind — never the day it's kept from. | Untested |
| 18 | A roster changes a commitment it holds for another, in the place it holds it | A roster holds no records and carries none over on a change. | Untested, and the survey judges no scenario possible at this seam |
| 19 | A roster supersedes a commitment it is keeping with another, from a day | The supported range for a supersession includes the very first and very last supported dates. | Untested (only the earlier-than-kept-from edge is covered) |
| 20 | same | The roster holds no link between a superseded commitment and the one that replaces it. | Untested |
| 21 | A commitments screen says what a commitment it is asked to change is made of | Every control the form draws is present, and the ones that can't be changed refuse a touch. | Untested — also contradicted four lines later by a sentence the survey flags for resolution first |
| 22 | A commitments screen changes a commitment on either of its lists | The record place is written before the roster place. | Untested — no scenario makes the record place fail |
| 23 | same | Where nothing is carried over, nothing at all is written at the record place. | Untested |
| 24 | same | A place that could not be written covers the record place as well as the roster place. | Untested (only the roster-place half is covered). **Corrected after G7:** this entry first read "the already-holds-it-in-any-state refusal covers the record place", which misread the survey — the fifth of that requirement's five inherited refusals is *a place that could not be written*, not *a commitment the roster already holds*, which is the fourth. The delta always stated it correctly; `design.md` § Open Questions had inherited the misattribution from here and is corrected with it. |
| 25 | A commitments screen refuses a range that is not a range, and a target that is not a target | A number commitment with both range ends left blank is not this refusal at all — it's a number with no range. | Untested — no scenario defines a number commitment with both ends blank through the screen |
| 26 | same | This requirement changes nothing about the `commitment` capability's own range/target rules. | Untested (an exclusion clause) |
| 27 | A roster moves a group among the groups it is keeping | A group landing after the last commitment of the last category lands there whatever state that last commitment is in (kept, stopped, or removed). | No test found asserting the "whatever state" qualifier specifically — ADR-1044 already records this exact edge as previously mis-implemented |

## C. Structural moves

Word counts and scenario counts below are the fresh count for the current file (script over
`### Requirement:` → first `#### Scenario:`), not carried from either survey.

**A roster store keeps a roster at a place, across the app being closed and opened again** —
1,123 prose words, **35 scenarios** (confirmed; the single largest scenario count in the spec).
Survey A's earlier pass (as its #12) proposed splitting off the ~25%-restatement block that
re-enumerates every roster refusal already stated in *refuses one it already holds*, *stops
keeping* and the move requirements. The superseding 2026-09-10 survey does not repeat a specific
split shape — it estimates 330 words even after a full rewrite, still more than double the 150-word
ceiling, without naming which two halves it would become.

**A commitments screen changes a commitment on either of its lists** — 1,622 prose words,
**21 scenarios** (confirmed). The ADDED survey explicitly proposes a split, "most naturally into
*which act a change performs* and *what a change is refused for*," and still estimates 320 words
for the combined result — meaning even a two-way split likely needs to land under 150 on each side
rather than one side absorbing 320.

**A roster refuses a commitment it already holds** — 1,464 prose words, **17 scenarios**
(confirmed). No survey — old or superseding — proposes a specific split for this one; the modified
survey's own estimate-after (350 words) is the single largest post-rewrite estimate anywhere in the
spec, larger than either of the two requirements above it that do have a split proposal. Flagged as
a live gap: something has to give here and no one has said what.

**The two knowingly-false scenario titles**, both already named by ADR-1047 decision 5 and
unaffected by line drift because that decision cites them by title text, not location:

- Lines 1746–1753 (paragraph) under *A commitments screen lists the commitments its roster keeps,
  in the order they were taken on* (heading at L1704), covering the scenario at **L1793**,
  *two commitments alike in name and not in rhythm are two entries a person cannot tell apart*.
- Lines 2529–2534 (paragraph) under *A commitments screen asks you to confirm before it stops
  keeping a commitment* (heading at L2491), covering the scenario at **L2570**,
  *a commitment stopped through a commitments screen is kept until the day the screen was handed*.

Both paragraphs are pure bookkeeping (`openspec` 1.10.0 forbids a MODIFIED block dropping a
scenario) and drop cleanly; the fact they record needs no new home since ADR-1047 already carries it
by scenario title.

**Scale of the wider problem, for context, not as individual items to grill.** 29 of the 41
requirements exceed 400 raw prose words. Of those, the surveys' own post-rewrite estimates project
roughly 20 will still sit above the 150-word ceiling even after a full rewrite — *A roster moves a
group* (est. 480), *A roster moves a commitment* (450), *A commitments screen moves a commitment*
(420), *A roster puts a commitment under a category* (400), *A commitments screen removes a
commitment only when its name is typed back* (340), *A roster reads the commitments it is keeping
in groups* (340), *A roster holds the commitments…* (340), *A roster refuses a commitment it already
holds* (350, above), *A roster removes a commitment it holds, and never lets it go* (330),
*A commitments screen defines a commitment…* (330), *A roster store keeps a roster at a place*
(330, above), *A commitments screen moves a group…* (290), *A roster store reads a roster kept
before a commitment carried a kind* (230), *A commitments screen asks you to confirm before it
stops keeping a commitment* (230), *A commitments screen holds the change it refused and why*
(240), *A commitments screen lists the commitments its roster keeps* (250), *What a commitments
screen holds about a refused change lasts…* (200), *A roster answers which commitments it had not
stopped keeping…* (180), *A roster stops keeping a commitment…* (200), and *A commitments screen
refuses a range that is not a range…* (170). None of these twenty has a survey-proposed split
shape; day-screen's precedent left 17 of 48 requirements over budget with no further split and a
line in `design.md` naming the rule that keeps each one there. This spec has a comparable or larger
share (20 of 41, roughly half) doing the same, which is the single biggest number in this frontier
and the one most worth naming as its own decision below.

## Questions the conductor must ask

**1. The 27 no-scenario rules (List B) — keep as bare SHALL/MUST sentences, and write no new
test?** *Recommend yes.* This is exactly the policy `condense-day-screen-spec` (#201) settled for
its 19: a rule with no scenario stays a plain normative sentence and the editorial Story adds no
red/green cycle (rule 3 is moot for an editorial Story per ADR-1047). The one to flag rather than
wave through is `#12`, *the seven refusal kinds are numbered only here* — it constrains how every
other requirement in the spec may refer to them, and is unlike the other 26 in being untestable by
any scenario in principle, not merely untested today. Settles all 27 items in List B at once.

**2. The 11 rationale pieces with no ADR home (List A) — home the load-bearing ten in the nearest
existing ADR, drop the one straw-man?** *Recommend yes*, again matching the day-screen precedent
(11 pieces there, same move). Two of the ten — the no-numbering rule and the record-place-before-
roster-place order — have no ADR near enough to receive even a short added paragraph without
straining it; day-screen's equivalent gap (the day picker's floor) got its own new ADR-1048. The
recommendation is to write **one** new short ADR covering both of those two (they're both about
*this capability's write/refusal discipline*, not two separate concerns) rather than a second new
one, and to add a paragraph each to ADR-1048 (aggregate earliest-day), ADR-1038 (offering-and-case),
ADR-1046 (half-a-range, ignore-rather-than-refuse) and wherever one-act-one-outcome best fits. Drop
`stopped-list-not-grouped`'s unmeasured "would double the structure" argument outright — the SHALL
NOT survives it. `refuse-rather-than-adjust` is the one genuinely optional case: recommend dropping
it too rather than writing a tenth home for an argument two adjacent ADRs already gesture at.
Settles all 11 items in List A.

**3. The split question — split only where a survey names an actual two-way division, and accept
the rest as over budget with a documented reason?** *Recommend yes.* Only one requirement,
*A commitments screen changes a commitment on either of its lists*, has a named split (*which act* /
*what refusal*); recommend taking it, via REMOVED + ADDED as ADR-1047 decision 2 and the
`condense-day-screen-spec` precedent both establish works with the archiver. *A roster store keeps a
roster at a place* and *A roster refuses a commitment it already holds* have no proposed split
shape from any survey — recommend leaving both as single (over-budget) requirements rather than
inventing a division nobody has designed, and naming the rule that keeps each one there in
`design.md` § *Overruns the budget*, exactly as `condense-day-screen-spec` did for its 17. The
twenty further requirements estimated to land over 150 after rewrite (§C, last paragraph) get the
same treatment as a class rather than individual grill items: no further splitting, each named in
the same `design.md` section. This is the largest single decision in the frontier — it determines
whether this Story ships with roughly 3 split requirements and ~20 flagged over-budget ones (the
recommendation), or opens a much larger design question about restructuring the capability's
requirement boundaries that no survey has actually done the legwork for yet.
