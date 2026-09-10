# Survey: the three changed `record` blocks, 2026-09-10

Scope: the one MODIFIED and two ADDED blocks listed under `## record` in
`rebaseline-2026-09-10-changed-blocks.md`, measured in the current `openspec/specs/record/spec.md`
(2,235 lines) — block 3 ends at **2235**, not 2236; the rebaseline's span runs one past EOF. All 40
scenario titles in scope appear verbatim in `RecordTests.swift` and `RecordStoreTests.swift`.

## 1. Per-block table

Split columns: (a) normative / (b) rationale, alternatives, "why" / (c) cross-references,
exclusions, restatements. Prose = words between the heading and the first `#### Scenario:`.

| # | Kind | Requirement (short) | Lines | Prose words | Scen. | (a) | (b) | (c) | Verdict | After |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | MODIFIED | A store keeps a history at a place | 625–977 | 958 | 29 | 66% | 22% | 12% | rewrite (split) | ~230 |
| 2 | ADDED | A history carries every record over | 2082–2179 | 440 | 7 | 63% | 34% | 3% | rewrite | ~150 |
| 3 | ADDED | A store carries every record over, at its place | 2180–2235 | 255 | 4 | 71% | 22% | 8% | trim | ~110 |

Block 1's prose changed by exactly one sentence since `4e64641` (+76 words, L640–644); its scenario
set is byte-identical. The earlier survey measured it at 882 words / 60-25-15; the re-split here is
finer, not a different reading of the same text — the one shift is L629–630, moved from (b) to (c).

## 2. Rules at risk

### Block 1 — a store keeps a history

- **L640–644 (new).** `"**Carrying every record of one commitment over to another SHALL be kept the
  same way too**, and it is the one change that touches every record a place holds at once: the
  store's own requirement for it is *A store carries…*"` 60 of its 76 words are a pointer to block
  3, but the bold head is the only place the **write-before-report** rule is extended to a
  carry-over. Block 3 restates durability in its own words, so CI would not catch the loss. Keep the
  bold clause, drop the rest.
- **L648–651.** `"keeping the kind changes what is written rather than what can be read back; it is
  kept all the same, because a store persists what a commitment *is*…"` The rule — the kind is
  persisted — exists nowhere else, and the earlier-form scenarios read a kind back. Unchanged.
- **L668–669.** `"and in the very form each character was given in rather than any other form of the
  same writing"` — the Unicode-normalisation prohibition, and the second `AND` of the L861 scenario.
  Reads as emphasis on "character for character". Unchanged.
- **L680–681.** `"because the order is what names the addition a take-back removes"` — the SHALL
  before it is safe; this clause is the only link from store order to *Last addition can be taken
  back*, and the L911 scenario's last `AND` tests that link. Unchanged.
- **L683–684.** `"A store MUST NOT persist the day's **sum**, which is derived from the additions and
  is not a record."` Normative, easily read as commentary, asserted by no scenario. Unchanged.

*New since the earlier report:* L640–644 only. *No longer applies:* none — the other four sentences
are byte-identical to their `4e64641` text and all four risks stand. The earlier report's Req-5
entries were quoted against L644/L662/L676/L679; add 4 lines to reach today's numbers.

### Block 2 — a history carries over

- **L2113–2114.** `"A history SHALL NOT consult the present moment… here either, and SHALL judge no
  date except by asking the second commitment whether it is due on it."` "here either" makes it look
  like a restatement of the clock prohibition elsewhere in `record`. The second half is not: it is
  the only statement that date judgement is delegated to the **second** commitment, which is what
  the L2139 refusal scenario turns on.
- **L2096.** `"**It SHALL carry all of them or none of them.**"` The target shape forbids bold
  sentences; this is the requirement's central rule written as one. De-bold it, do not delete it.

Checked and *not* at risk, so a trim may take them: L2091–2094 (the ADR-1023 paragraph, no rule in
it); L2100–2102 (all-or-none and both refusal causes are already normative at L2096–2099);
L2109–2111 (the refusal is normative at L2108–2109); L2105–2106.

### Block 3 — a store carries over, at its place

- **L2198–2200.** `"The **form on disk does not move** for a carry-over… adds no key, no field and
  no version to what a record is."` Reads as design commentary; it is a prohibition, and **no
  scenario asserts it**. ADR-1031's form contract depends on it — a carry-over that bumped the
  version would make the file unreadable to the build that wrote it.
- **L2190–2191.** `"and so SHALL one the history had nothing to carry for: a store keeps what a
  change made, and a change that made none has nothing to keep."` The colon tail is droppable; the
  clause before it is the only grounding for the L2220 scenario, whose `AND` asserts the file is
  byte-for-byte unchanged. A trim that cuts the sentence at the colon loses it.
- **L2193–2194.** `"and SHALL say so as it already does for every other change it could not keep"` —
  a cross-reference carrying the error-reporting rule the L2228 scenario asserts. Keep one clause of
  it; the L2194–2196 tail after the dash is pure rationale.

Not at risk: L2185–2186 (`"for the reason there is none for a tick"` — the SHALL is at L2182–2184).

## 3. Rationale needing a home

| Rationale | Home |
|---|---|
| B1 L635–636 — "the app can be stopped at any moment without warning" | **ADR-1017** § *Every change is written before it is reported* |
| B1 L650–651 — a store persists what a commitment *is*, not the parts that vary | **ADR-1030** |
| B1 L659–660 — what a person entered is what is kept, digit for digit | **ADR-1032** |
| B1 L670–672 — "a sentence rewritten on the way to disk… the false record this product exists to remove" | **none.** No ADR covers note fidelity or Unicode form; `CONTEXT.md` carries the false-record principle but not this application of it |
| B1 L681–684 — the day's sum is derived, not a record | **ADR-1040** ("derived and never stored") |
| B1 L641–644 — a carry-over touches every record at once | **ADR-1023**, amended 2026-09-09 |
| B2 L2091–2094 — no identity, records embed by value | **ADR-1023** (the spec already cites it; delete the paragraph) |
| B2 L2100–2102 — all-or-none, nothing silently dropped | **ADR-1023** L115–121 |
| B2 L2109–2111 — "Carrying over is not merging" | **none.** No ADR weighs merge-vs-refuse; needs an ADR-1023 amendment or a line in the change's `design.md` |
| B3 L2194–2196 — never ahead of the place; no half-written place | **ADR-1017** (written whole, atomic rename) |
| B3 L2198–2200 — the form on disk does not move | **ADR-1031** |

**ADR-1046 is not relevant here.** It decides that a range and a target reach a *commitments screen*
as text and the screen judges them; nothing in it touches `record`.

## 4. Scenario duplication

Block 1 carries five families that differ only by record type — 13 of its 29 scenarios are
droppable, the same 13 the earlier report found (titles unchanged, line numbers new). Keeper in bold.

- "*X* added to a store is held by a second store opened at the same place while the first is still
  open": **L692** (tick), L772, L833, L901 — drop 3.
- "a store opened again holds exactly the ticks[, numbers][, notes][ and additions]…": L708, L810,
  L877, **L952** — strictly cumulative, the last subsumes all — drop 3.
- "an *X* that cannot be kept is refused and not held": **L763**, L823, L891, L968 — identical
  assertions — drop 3.
- "*X* taken back is not held by a store opened afterwards": **L699** (tick), L781, L843, **L922**
  (addition — also tests order) — drop 2.
- "*X* entered/written again is kept once, as the later": **L791** (number), L852 — drop 1.
- "a number is read back exactly…" **L800** vs "an amount is read back exactly…" L942 — one
  digit-for-digit rule; L800 carries the wider fixture (negative, zero, 20 digits) — drop 1. The
  note one (L861) stays: its normalisation `AND` is a different rule.

Block 2: none. Its seven scenarios are seven distinct outcomes (carried, exact fidelity, two refusal
causes, empty, self, already-holds).

Block 3: **L2212** ("a carry-over a store's history refuses keeps nothing at its place") and
**L2220** ("a carry-over with nothing to carry keeps nothing at a store's place") have word-identical
`THEN`/`AND` pairs and differ only in the `WHEN` fixture. **Recommend keeping both** — they exercise
two different branches (a refusal returned by the history vs a no-op), and the prose at L2188–2191
states them as two rules. If one must go, keep L2212; it also proves the refusal is not turned into
an error.

## 5. Scenario prose

**Zero.** All 40 scenarios in scope are `- **WHEN** / **THEN** / **AND**` bullets with indented
continuation lines; no bare sentence or paragraph appears in any scenario body. Two `AND`s smuggle a
reason into the assertion (L919–920, L872–874), which the target shape does not forbid.

## 6. Totals

| | Now | After |
|---|---|---|
| Lines | 507 | ~300 |
| Words | 6,450 | ~3,650 |
| Requirement prose | 1,653 | ~490 (−70%) |
| Scenarios | 40 | 27 |

**Recommendation: rewrite blocks 1 and 2, trim block 3, and split block 1 in two.** Block 1 is two
requirements wearing one heading — durability (write before report, five kinds of change) and *what
a store persists per record type* — and at 958 prose words with 29 scenarios it will not reach 150
without losing a rule; splitting it also breaks up the file's worst duplication. Block 2 is a
genuine rewrite: a third of its prose is rationale ADR-1023 already holds and L2091–2094 can go
outright, but the clock-and-due-date sentence at L2113–2114 must survive the same pass. Block 3
needs no restructuring, four paragraphs each losing a tail, but holds the most losable rule in
scope — the form-on-disk prohibition at L2198–2200, which no test would miss. Two pieces of
rationale have no ADR home and must not simply be deleted: note fidelity (B1 L670–672) and
merge-vs-refuse (B2 L2109–2111).
