# Grill frontier — record spec, from two surveys

Index only, no added analysis. Refs are `survey-record` (2026-09-09, 15 requirements as they stood
then) and `survey-2026-09-10-record` (the re-baseline of the one MODIFIED and two ADDED blocks —
supersedes `survey-record` wherever they overlap, and its line numbers are the current ones).
Every quote below was checked against `openspec/specs/record/spec.md` as it stands today (2235
lines) and every ADR claim against the file named.

## Measurement table

Prose = words outside `#### Scenario:` blocks and outside the `### Requirement:` heading itself,
counted directly against the current spec file (not taken from either survey). Totals match both
surveys' own counts exactly: 9,244 prose words, 170 scenarios, 17 requirements.

| # | Requirement | Prose words | Scenarios |
|---|---|---|---|
| 1 | A store reads a history kept before a commitment carried a kind | 837 | 13 |
| 2 | A tick is of a commitment on a calendar date it is due on | 717 | 14 |
| 3 | A history answers whether a commitment was kept on a day from the ticks it holds | 714 | 20 |
| 4 | A tick can be taken back | 129 | 5 |
| 5 | A store keeps a history at a place, across the app being closed and opened again | 958 | 29 |
| 6 | A store that cannot be read is refused rather than emptied | 530 | 7 |
| 7 | A number is of a number commitment on a calendar date it is due on | 715 | 11 |
| 8 | A history answers what number a commitment has on a day from the numbers it holds | 404 | 9 |
| 9 | A number can be taken back | 276 | 5 |
| 10 | A note is of a note commitment on a calendar date it is due on | 766 | 8 |
| 11 | A history answers what note a commitment has on a day from the notes it holds | 417 | 9 |
| 12 | A note can be taken back | 294 | 5 |
| 13 | An addition is of a total commitment on a calendar date it is due on | 733 | 7 |
| 14 | A history answers what a commitment has added on a day from the additions it holds | 662 | 10 |
| 15 | The last addition a day holds can be taken back | 397 | 7 |
| 16 | A history carries every record of one commitment over to another | 440 | 7 |
| 17 | A store carries every record of one commitment over to another, at its place | 255 | 4 |

## A. Rationale with no ADR home

1. Note/text fidelity is kept **in the exact Unicode form it was typed in**, not merely
   character-for-character by meaning: "in the very form each character was given in rather than
   any other form of the same writing… a sentence rewritten on the way to disk is a sentence the
   person did not write" (req 10, spec L668–672). Tested (the accent-mark scenario, L872–874), but
   the *why exact form and not just exact meaning* has no ADR — `grep -rn -i "unicode\|normali[sz]"
   docs/adr/` hits only ADR-1039's unrelated mention of Unicode's `White_Space` property. Rec: no
   ADR is near; amend ADR-1032 (the numeric-fidelity ADR) with a short paragraph extending "kept
   digit for digit" to "kept in the form given" for text, or write a new short ADR from the
   accent-mark measurement. [survey-record §2 row 4; survey-2026-09-10 §3 B1 row: "none. No ADR
   covers note fidelity or Unicode form; `CONTEXT.md` carries the false-record principle but not
   this application of it"]

2. Carrying over refuses on collision rather than merging: "Carrying over is not merging: two
   records for one day would have to become one, and which of them survived would be a choice
   about a person's history that nothing here is entitled to make" (req 16, spec L2108–2111).
   Checked ADR-1023 in full (the carry-over/kept-until-day ADR): it states "all of them or none"
   and the refusal rule, but never frames the choice as merge-vs-refuse, and `grep -n -i "merg"`
   against it returns nothing. Rec: no ADR is near; amend ADR-1023 with one paragraph stating the
   refuse-not-merge choice, or record it as this Story's own `design.md` sentence — ADR-1047 offers
   that as an alternative to a new ADR. [survey-2026-09-10 §3 B2 row: "none. No ADR weighs
   merge-vs-refuse; needs an ADR-1023 amendment or a line in the change's `design.md`"]

3. Which form a part belongs to is judged against **the form it was first written at**, never the
   newest: "Judging them against the newest would make each new form silently re-declare the shape
   of the ones before it, which is the reading this requirement exists to refuse" (req 1, spec
   L61–68). Checked ADR-1031 in full: it documents per-form strictness at length (three amendments,
   each adding a form) but never states the first-written-at-vs-newest framing anywhere in it. Rec:
   keep the SHALL sentence itself (it is normative, not droppable — it is what the two
   "form-mismatch" `AND`s in req 1's own refusal scenarios rest on), and add one paragraph to
   ADR-1031 recording why judging against the newest would be wrong; the "silently re-declare"
   argument is dropped from the spec either way. [survey-record §1 Req 1 row and §2 row 2: "Not in
   ADR-1031 (its amendments cover 'a fourth form', not per-part first-form)"]

4. A commitment's target is a floor a day must reach, never a ceiling on what may be added: "a
   target is what a day has to reach and never a ceiling on what may be added" (req 3, spec
   L387–388), restated at req 13 L1765–1767 ("A commitment's target is not a ceiling either").
   Checked ADR-1045 in full: it is about *marking* a target row on screen (blue vs grey, fade),
   never about this semantic meaning of a target. No other ADR mentions "ceiling" in this sense
   (`grep -rn -i ceiling docs/adr/` returns only ADR-1045, on-screen usage). Rec: no ADR is near;
   keep one normative sentence in the rewritten requirement ("additions past the target keep the
   day and change nothing else about it") and drop the restatement at req 13 — the two together are
   the clearest duplicate-rationale pair in the file. [survey-record §2 row 10: "No dedicated ADR;
   ADR-1045 is about marking a target on screen, not this"]

5. "A false record of the sort this product exists to remove" and its four close variants — req 2
   L236–237 (a tap standing in for a weight), req 7 L1107 (a sentence standing in for a tick), req
   10 L1430–1431 (a note recorded against the wrong kind), req 13 L1743–1744 (a weight accumulated
   like a total), and req 6's own "a record silently replaced by an empty one is the failure it
   exists to remove" (L984–985). No ADR carries this exact phrase (`grep -rn "false record"
   docs/adr/`); it is `CONTEXT.md` § Product principles material — confirmed at `CONTEXT.md`
   L443, L474, L486 and L574, each a close variant of the same sentence. Rec: not an ADR at all;
   cite `CONTEXT.md` § Product principles once if a reader needs the link, otherwise simply drop
   all five spec copies — none carries a rule beyond the refusal already stated in normative form
   beside it. [survey-record §2 row 8]

6. "It is here because a record nothing can read back is not a record" — req 8 L1249 and req 11
   L1552–1553, explaining why the number's and the note's readers give back a value rather than a
   yes/no like the tick's. No ADR states this design note (searched the full ADR set for "read
   back is not a record" and near variants — no hit). Rec: no ADR is near; this explains a reader's
   *shape* rather than asserting a rule a test enforces, so it is dropped outright rather than
   homed. [survey-record §2 row 9]

**A: 6 items, collapsing to one question** (each item is homed independently, but the mechanism —
amend the nearest ADR or `CONTEXT.md` with one paragraph, or drop outright where nothing is near
and no rule is at stake — is the same decision six times over, exactly as the day-screen frontier's
11 rationale items collapsed to one).

## B. Rules with no scenario

1. **The comparison-direction rule for Decimal NaN.** "The comparison SHALL be the sum against the
   target, in that order and never the target against the sum" (req 3, spec L389–391). Grounded in
   ADR-1032's documented fact that `Decimal`'s NaN comparisons are asymmetric. No scenario in req 3
   exercises the reversed direction. `grep -n -i "nan\b" src/DayByDayKit/Tests/DayByDayKitTests/*`
   finds NaN-refusal tests only in `CommitmentTests.swift` (range/target formation) and
   `RecordTests.swift` L566–567, L1574 (`Number`/`Addition` formation) — no test found in
   `RecordTests.swift` or `RecordStoreTests.swift` asserting the sum-vs-target ordering specifically
   (a sum can never actually be NaN today, since every non-number amount is refused at the addition
   formed at req 13, so this is pure defence in depth). No test found.

2. **Kind-as-persisted.** "keeping the kind changes what is written rather than what can be read
   back; it is kept all the same, because a store persists what a commitment *is*" (req 5, spec
   L648–650), whose rationale is already homed in ADR-1030 ("a kind is what a commitment *is*").
   No scenario directly tests that a *non-default* kind (number, note or total — not the plain-kind
   default an earlier-form read produces) round-trips through a store as itself; `grep -n -i "kind"
   src/DayByDayKit/Tests/DayByDayKitTests/RecordStoreTests.swift` shows `"kind": {...}` written into
   every JSON fixture, but no test is titled around a kind round-trip and it is exercised only
   incidentally through value-based scenarios. No dedicated test found.

3. **"MUST NOT persist the day's sum."** "A store MUST NOT persist the day's sum, which is derived
   from the additions and is not a record" (req 5, spec L683–684). `grep -n '"sum"'
   src/DayByDayKit/Tests/DayByDayKitTests/RecordStoreTests.swift src/DayByDayKit/Tests/DayByDayKitTests/RecordTests.swift`
   returns nothing — no JSON fixture or assertion in either file mentions a `sum` key. No test
   found.

4. **Sum-not-the-list.** "A history SHALL give out the sum and SHALL NOT give out the additions
   themselves" (req 14, spec L1872), already homed in ADR-1041 ("gives out the sum and never the
   additions", L100). None of req 14's ten scenarios test the *absence* of a list-returning method
   — that shape cannot be asserted in the spec's Given/When/Then form. No test found.

5. **The three take-back prohibitions.** "Only the last SHALL go, and there SHALL be no way to take
   back any other… MUST NOT offer taking back an addition by naming its amount… and MUST NOT offer
   clearing a day's additions in one act" (req 15, spec L1996–2002). The "one act erasing six
   records" rationale beside them is homed in ADR-1041's Alternatives (the grill's answer 7). None
   of req 15's seven scenarios test the absence of a by-amount or clear-all surface. No test found.

6. **"The form on disk does not move" for a carry-over.** "It writes different commitment values
   into records the store already keeps in exactly that shape, and adds no key, no field and no
   version to what a record is" (req 17, spec L2198–2200). Grounded in ADR-1031's form contract but
   not stated there for a carry-over specifically. None of req 17's four scenarios (spec
   L2202–2235) assert the file's version number or key set is unchanged after a carry-over — they
   assert behavioural outcomes (records read back under the new commitment, byte-for-byte-unchanged
   on refusal), not the shape of the write itself; confirmed against
   `RecordStoreTests.swift` L1854–1946. No test found — the survey calls this "the most losable rule
   in scope… no test would miss it," and that check confirms it.

7. An addition carries **no position of its own** among a day's additions: "no position of its own
   among the additions of its day" (req 13, spec L1730) — order is a property of how a store or
   history holds a day's additions, not of the addition value itself. No scenario tests this shape
   fact independently of the order round-trip tested at reqs 5 and 16. No test found.

**B: 7 items, collapsing to one question** (each survives as a bare SHALL/MUST sentence and this
Story adds no test for any of them — one mechanism, seven instances, exactly ADR-1047 decision 2's
"no test changes").

## C. Structural moves

1. **Req 1 — "A store reads a history kept before a commitment carried a kind"** (837 words, 13
   scenarios). Split into:
   - *A store reads every form it has written* — the reading mechanism itself: reads current and
     every earlier form, refuses a later or a never-written form, changes nothing at its place on
     open, and refuses where a store's shape and its declared form disagree. **5 scenarios:**
     "reading a history kept in an earlier form changes nothing at its place"; "a store written in
     a form this app has never written is refused"; "a store whose shape and declared form disagree
     about numbers is refused"; "…about notes is refused"; "…about additions is refused".
   - *Each earlier form is read as the record it always was* — what an earlier form means: no kind
     recorded reads as the plain kind, no number/note/addition recorded on any day reads as none,
     and writing forward over an earlier form lands whole in the current one. **8 scenarios:** "a
     history kept before a commitment carried a kind is read with every commitment of the plain
     kind"; "a tick added over a history kept in an earlier form is read back beside the ticks
     already there"; "a history kept before a day could hold a number is read, and no day in it
     holds a number"; "a number added over a history kept before a day could hold a number is read
     back beside the ticks already there"; the equivalent pair for a note; the equivalent pair for
     an addition.
   Rec: yes, split as suspected.

2. **Req 5 — "A store keeps a history at a place, across the app being closed and opened again"**
   (958 words, 29 scenarios). Split into:
   - *A store keeps what it is given before it reports it kept* — durability: write-before-report
     for every kind, survives the app closing and reopening, isolated by place, refused and not
     held on a write failure. **19 scenarios:** "a store opened where nothing has been kept holds an
     empty history"; the four "X added to a store is held by a second store opened at the same
     place while the first is still open" (tick/number/note/addition); the four "X taken back is
     not held by a store opened afterwards at the same place"; the four cumulative "a store opened
     again holds exactly the ticks[, numbers][, notes][and additions] added and not taken back";
     "adding a tick the store already holds leaves what is kept unchanged"; "stores at different
     places hold different histories"; the four "an X that cannot be kept is refused and not held".
   - *A store persists each kind of record as exactly what it is* — fidelity: every schedule shape,
     every commitment name, first/last supported year, digit-for-digit numbers and amounts,
     character-for-character notes, addition order, all read back exactly. **10 scenarios:** "ticks
     of commitments on every schedule shape are read back as the same ticks"; "a commitment name is
     read back exactly, whatever it contains"; "a tick in the first supported year and one in the
     last are read back unchanged"; "a number entered again is kept once by a store opened
     afterwards, as the later number"; "a number is read back exactly as it was given, whatever its
     digits"; "a note written again is kept once by a store opened afterwards, as the later note";
     "a note is read back exactly as it was written, whatever it contains"; "a day's additions are
     read back in the order they were made"; "two additions alike in every way on one day are both
     read back"; "an amount is read back exactly as it was given, whatever its digits".
   Rec: yes, split as suspected.

3. Reqs 3, 6 and 14 measure at 714, 530 and 662 prose words. `survey-record`'s own post-rewrite
   estimate for each (~170, ~170, ~160) still lands over the 150-word budget even after condensing,
   but the survey does not recommend splitting them — only reqs 1 and 5 are called out as
   requirements that "will not fit 150 words without losing something a test reads." **Note:**
   `survey-record` §5's summary prose also names req 15 in the same six-item list ("1, 3, 5, 6, 14
   and 15… each carry four record types' worth of genuine rules"), but req 15's own table row
   estimates ~140 words — under budget — and I could not reconcile the two; flagging the
   discrepancy rather than asserting req 15 belongs here. Rec: accept reqs 3, 6 and 14 as disclosed
   over-budget in `design.md`, per ADR-1047's own consequence ("A handful of requirements will
   exceed 150 words honestly… Split them, or say in `design.md` which are over and why") — do not
   force a third split.

**C: 3 entries, collapsing to two questions** — split req 1 and req 5 as proposed (one yes/no,
covering both since they share the same answer and the same mechanism), and separately, accept
reqs 3/6/14 as honestly over budget rather than split them further (a second yes/no, because it is
the opposite answer to the first).

## Overall

**16 entries across A, B and C, collapsing to four questions:**

1. Home the six un-ADR'd rationale items (A1–A6) by amending the nearest existing ADR or
   `CONTEXT.md` with one paragraph each, dropping the argument and keeping only the rule where one
   is load-bearing (A1 note fidelity → ADR-1032; A2 merge-vs-refuse → ADR-1023; A3
   first-written-at → ADR-1031, rule kept normative; A4 target-not-a-ceiling → no ADR, kept as one
   normative sentence; A5 "false record" → `CONTEXT.md`, dropped; A6 "nothing can read back" →
   dropped outright)?
2. Let the seven rules-with-no-scenario (B1–B7) survive as bare SHALL/MUST sentences with no new
   scenario and no new test, per ADR-1047 decision 2?
3. Split req 1 and req 5 into the two-and-two headings and scenario allocations proposed in C1–C2?
4. Accept reqs 3, 6 and 14 as honestly over the 150-word budget, disclosed in `design.md` rather
   than split further (C3)?

Every item above resolves under one of these four; nothing in A, B or C is left for `spec-author`
to originate rather than carry out — the exact wording of each requirement is still theirs, and the
surveys' *Rules at risk* sections remain the checklist each rewritten requirement is verified
against.
