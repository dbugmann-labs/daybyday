# Survey: `schedule` and `cli-version` specs

Measured, not estimated: line spans, prose words (heading → first scenario), scenario counts and
block words come from a script over the two files. The three percentages are my reading of how
those prose words divide; the post-rewrite figure is prose only (scenario bullets untouched).

## `openspec/specs/schedule/spec.md` — 740 lines, 7,593 words, 18 requirements, 78 scenarios

Prose words total **3,448**. Scenario headings + bullets ≈ **4,090**. Purpose ≈ 60.

| # | Title (short) | Lines | Prose w | Scen | (a) rules | (b) why | (c) xref/excl | Verdict | After |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Weekday-set is due on listed weekdays | 11–47 | 104 | 5 | 88% | 7% | 5% | keep | 95 |
| 2 | Weekday follows the Gregorian calendar | 48–67 | 77 | 2 | 75% | 20% | 5% | trim | 60 |
| 3 | A calendar date names a day that exists | 68–119 | 146 | 7 | 82% | 10% | 8% | trim | 125 |
| 4 | Supported year range 1583–9999 | 120–167 | 282 | 5 | 22% | 68% | 10% | **rewrite** | 75 |
| 5 | Day-of-month is due on that day | 168–200 | 123 | 4 | 82% | 6% | 12% | trim | 110 |
| 6 | Short month is due on its last day | 201–246 | 232 | 5 | 50% | 42% | 8% | **rewrite** | 110 |
| 7 | A day of the month is 1–31 | 247–270 | 100 | 3 | 62% | 8% | 30% | trim | 65 |
| 8 | Every-N-days due on start + intervals | 271–343 | 200 | 9 | 76% | 4% | 20% | trim | 150 |
| 9 | Every-N-days not due before start | 344–373 | 196 | 2 | 38% | 33% | 29% | **rewrite** | 75 |
| 10 | An interval is ≥ 1 whole day | 374–403 | 165 | 3 | 68% | 12% | 20% | trim | 110 |
| 11 | Weekly quota is due on every date | 404–459 | 284 | 6 | 52% | 33% | 15% | **rewrite** | 120 |
| 12 | A weekly quota is 1–7 times | 460–495 | 174 | 4 | 55% | 30% | 15% | **rewrite** | 85 |
| 13 | A calendar date gives back y/m/d | 496–550 | 351 | 4 | 33% | 42% | 25% | **rewrite** | 85 |
| 14 | A schedule says its rhythm in words | 551–594 | 338 | 3 | 55% | 25% | 20% | **rewrite** | 150 |
| 15 | Weekday set said as weekdays, Mon-first | 595–637 | 199 | 5 | 60% | 25% | 15% | trim | 110 |
| 16 | Interval said as interval, never start date | 638–673 | 169 | 4 | 55% | 35% | 10% | trim | 90 |
| 17 | Day-of-month said as an ordinal | 674–712 | 159 | 4 | 62% | 23% | 15% | trim | 95 |
| 18 | Weekly quota said as "Nx a week" | 713–741 | 149 | 3 | 57% | 30% | 13% | trim | 90 |

Verdict spread: **1 keep, 10 trim, 7 rewrite.** Prose 3,448 → **~1,835** (−47%).

## `openspec/specs/cli-version/spec.md` — 51 lines, 367 words, 2 requirements, 4 scenarios

| # | Title | Lines | Prose w | Scen | (a) rules | (b) why | (c) xref/excl | Verdict | After |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Version reporting | 10–31 | 64 | 2 | 85% | 15% | 0% | keep | 58 |
| 2 | Unrecognised invocations | 32–52 | 52 | 2 | 70% | 30% | 0% | keep | 45 |

Both are already the target shape: single paragraph, 52–64 words, no alternatives, no
cross-references, no bold, no exclusions. The only cuttable text is two purpose clauses —
"so that a caller can consume it without parsing" (l.15) and "so that a caller can distinguish a
refusal from a successful report by exit status alone" (ll.36–37). Both are arguably normative
intent rather than rationale; I would leave them. One structural nit, not a word count: the
scenario *version with extra arguments is rejected* (l.25) sits under Requirement 1 but is
governed by Requirement 2's rule; moving it would change nothing a test reads.

## 1. Rules at risk — sentences a naive trim would lose

Only where a test or a later requirement actually depends on it.

- **Req 3, l.76–78** — "SHALL also judge each of the three components as the number it was offered,
  and MUST NOT accept a date in which a component was treated as absent or unspecified because its
  value was extreme." This paragraph reads like defensive commentary and is the *only* statement of
  the rule behind three tests (`a month/year/day of the largest representable integer is not a
  calendar date`, `ScheduleTests.swift:201,210,217`). Must survive verbatim in substance.
- **Req 4, l.138–140** — "keeps the year inside a range the system judges for itself, so that no
  year large enough to be read back as unspecified reaches the calendar underneath — the month and
  the day are bounded by the requirement above, not by this one." The clause after the dash is the
  division of labour between Req 3 and Req 4; delete it and the year bound looks like it also
  bounds month and day. Keep as one normative sentence, drop the "so that".
- **Req 6, l.213–216** — "in a common February, schedules on the 28th, 29th, 30th and 31st all fall
  on the same date, which is the correct reading of 'the end of every month' and not a collision to
  be resolved." Sits inside the rationale paragraph but is the only place the spec says collisions
  are accepted rather than refused. Req 6's scenarios on the 31st and the 29th both landing on
  28 February 2027 are exactly this rule.
- **Req 9, l.357–360** — "The weekday-set and day-of-month shapes are anchored to the calendar
  rather than to a start, and remain due on every date they match in either direction; this
  requirement does not change them." An exclusion, but load-bearing: nothing in Reqs 1 or 5 says
  they match backwards without limit, and dropping this leaves the backward direction unstated for
  three of the four shapes.
- **Req 10, l.383–387** — "There is no upper bound: a number of days larger than the entire
  supported range of years names a schedule that comes due on its start date and never again ... the
  system MUST give that answer rather than refusing the interval or losing the arithmetic to
  overflow." This is the rule Req 8's scenario `an interval longer than the supported years is due
  only on its start date` tests, and it lives in a different requirement's second paragraph.
- **Req 11, l.418–422** — "the system SHALL keep it outside this capability: a surface that stops
  showing a weekly quota once its week is complete MUST decide that from tick records, not from this
  predicate." Normative, and it binds consumers (the day screen). It is inside the bold
  "MUST NOT be read as claiming" paragraph that the target shape bans, so it needs re-extracting,
  not deleting.
- **Req 13, l.503–508** — "The three SHALL be readable and SHALL NOT be writable." Normative, and
  the justification that follows (walking 31 January into February) is the *reason no test exists*:
  it is a compile-time property, so a trim guided by "does a test depend on it" would wrongly cut
  it. No `not writable` test exists in `src/DayByDayKit/Tests/DayByDayKitTests/`.
- **Req 14, l.566–568** — "Every number SHALL be said in digits, with no grouping separator and no
  leading zero." Buried at the end of the locale paragraph; it is the whole content of the scenario
  `a number is said in digits with no grouping separator`.
- **Req 14, l.571–572** — "Two schedules that name the same rhythm SHALL say the same words".
  Normative and cross-shape; the paragraph it opens is otherwise rationale about the quota case, so
  a paragraph-level cut takes the rule with it.

Not at risk, despite looking normative: Req 4's Gregorian-history paragraph (ll.128–137), Req 6's
"seven months of the year and pass five in silence" (ll.210–213), Req 9's "inventing a history"
paragraph (ll.351–355), Req 12's "Seven is the ceiling because…" (ll.468–472), Req 13's
ADR-1004-conversion paragraph (ll.510–517), Req 16's commitments-screen paragraph (ll.646–651).

## 2. Rationale needing a home

| Rationale | Lines | Already in an ADR? |
|---|---|---|
| 1583 lower bound, Julian hybrid, 78 over-refused days of 1582, upper bound guards `DateComponents` nil | 128–141 | **Yes — ADR-1004**, ll.44–56, near verbatim including the seventy-eight days and the year-comparison trade. Drop from the spec outright. |
| Foundation silently rolls 30 Feb → 2 March, so refuse rather than adjust | 70–75 (implied) | **Yes — ADR-1004** ll.38–43. |
| Not-due-before-start: a backwards rule manufactures misses that never happened | 351–355 | **Yes — ADR-1013** l.14, which quotes this reasoning and credits #10 with it. Drop. |
| Quota is due every day; completion is not a schedule question; the "unhelpful for the last four" consequence | 415–424 | **Yes — ADR-1015** (title, ll.31–46). Keep only the normative sentence flagged above. |
| Quota ceiling of seven: a day holds at most one record | 468–472 | **Yes — ADR-1015** ll.50–51. Drop. |
| Same extension as a weekday set of all seven is not a contradiction | 411–414 | **Yes — ADR-1015** ll.37–38. Drop. |
| Words are the capability's own English, no `Locale`, no formatter | 563–566 | **Yes — ADR-1034** l.51 and **ADR-1022**. Keep the MUST NOT, drop the "exactly as". |
| Rhythm says shape + number only: no start date, no clamp | 559–562, 646–651, 709–711 | **Yes — ADR-1034** ll.52–54, which states both. Spec states it three times; keep once as a rule. |
| Empty weekday set has words even though a screen refuses it | 604–609 | **Yes — ADR-1028** (referenced inline). Trim to the two SHALLs plus the ADR pointer. |
| **Clamp to the last day of a short month, and why not skip** | 208–216 | **No decision ADR.** `docs/adr/1006-the-question-round.md` ll.35–38 mentions the clamp only as an example of a grill question, and explicitly notes `design.md` labelled it "a product decision an agent is proposing". This is the one substantial rationale in the spec with no ADR home — it needs a new ADR before it can be cut, or the cut loses the reasoning entirely. |
| **Read-back is the half of ADR-1004's conversion that could not be performed; date-picker seeding motivation; immutability argument** | 503–521 | **Partly.** ADR-1004 records the edges-convert decision but not the read-back direction; grep finds "read-back" in ADR-1034 l.102 only, about a different subject. Needs a new ADR (or the originating change's `design.md` retained) for the immutability argument; the date-picker motivation can simply be dropped. |
| Eleventh/twelfth/thirteenth are where a last-digit rule gets English wrong | 679–681 | No ADR, and none needed — the suffix table above it is the rule; this is a comment. Drop. |

## 3. Scenario duplication

Nine candidates. Each drop deletes a named test, so these are proposals, not free wins.

- **Req 11, four of six scenarios assert the same unconditional `true`.** The predicate cannot
  distinguish them. Keep `a weekly quota is due on every date of a week` (fold the 1× fixture into
  it as an `AND`) and `a weekly quota is due on the first and last dates the system forms`.
  Candidates to drop: `a weekly quota of one is due on every date of a week`,
  `a weekly quota is due on the dates either side of a week boundary`,
  `a weekly quota is due on a leap day`, `a weekly quota is due across the turn of a year`.
- **Req 4:** `a date before the Gregorian calendar's adoption is not a calendar date` (year 1500) vs
  `the last day before the first full Gregorian year is not a calendar date` (31 Dec 1582). The
  second is strictly the tighter boundary. Keep the 1582 one; the 1500 one is a fixture change.
- **Req 15:** `a weekday-set schedule says its weekdays as three-letter names` ("Mon, Wed, Sat") is
  subsumed by `every weekday is said by its own three-letter name` *and* by Req 14's four-shapes
  scenario, which already asserts "Mon, Wed, Sat". Keep the exhaustive one.
- **Req 17:** `a day-of-month schedule says its day as an ordinal` ("The 25th") is subsumed twice
  over — by `every day of the month from the first to the thirty-first…` and by Req 14's four-shapes
  scenario. So is `the eleventh, twelfth and thirteenth are said with th…`, whose 11/12/13 and
  21/22/23 assertions are all inside the exhaustive 1–31 list. Keep the exhaustive one only.
- **Req 18:** `a weekly-quota schedule says its number of times a week` ("3x a week") is subsumed by
  `every number of times a week from one to seven is said in its own words`. Keep the exhaustive one.
- **Req 16:** `an every-N-days schedule says its interval in days` ("Every 14 days") duplicates
  Req 14's four-shapes scenario. Weaker candidate — Req 16 would then have no plain positive case.

Considered and rejected as duplicates: Req 3's three largest-representable-integer scenarios (one
per component, each a real `DateComponents` nil path); Req 8's month-end / leap-day / year-turn trio
(three distinct arithmetic boundaries); Req 6's 31st-in-February vs 29th-in-February (28 vs 29 is a
`>` / `>=` boundary the 31st case does not reach); Req 9's two scenarios (one adds four intervals
back); Req 1's every-weekday and no-weekday pair (opposite ends).

## 4. Scenario prose

**Zero** in both specs. All 78 schedule scenarios and all 4 cli-version scenarios consist of
`- **WHEN** / **THEN** / **AND**` bullets only, with wrapped continuation lines indented two
spaces. No paragraph or stray sentence appears inside any scenario body. Bold outside a bullet
occurs three times, all in requirement prose: ll.415–416 (the banned bold sentence in Req 11) and
l.553 (`**rhythm in words**`, a term definition — defensible).

## 5. Totals and recommendation

| | `schedule` | `cli-version` |
|---|---|---|
| Lines now | 740 | 51 |
| Words now | 7,593 | 367 |
| Prose words now | 3,448 | 116 |
| Prose words after rewrite | ~1,835 | ~103 |
| Words after rewrite (prose only) | ~5,980 | ~354 |
| Words after rewrite + 9 scenario drops | ~5,600 (≈545 lines) | 367 (no drops) |
| Verdict | **rewrite** (7 requirements), trim 10, keep 1 | **leave** |

**`cli-version` is the reference shape, not `schedule`.** Its two requirements are 64 and 52
words, one paragraph each, all SHALL/MUST, no ADR references, no exclusions, no bold — that is the
target as written. Leave it alone.

**`schedule` is not close to the target and should be rewritten requirement by requirement, not
trimmed in one pass.** Prose averages 192 words per requirement against a 40–150 target, and seven
requirements exceed 195 (Req 13 at 351, Req 14 at 338, Req 11 at 284, Req 4 at 282). The pattern is
consistent: paragraph one is the rule and is usually already concise; paragraphs two and later are
the change's `design.md` reasoning promoted into the spec, and in ten of thirteen cases an ADR
already records it (1004, 1013, 1015, 1022, 1028, 1034). Two do not — the short-month clamp and the
calendar-date read-back/immutability argument — and those need an ADR written before the prose is
cut, or the reasoning is simply lost. The risk in a naive trim is concentrated: nine sentences
(section 1) carry rules that a paragraph-level cut would take with them, three of them the sole
statement of a rule an existing test asserts, and one (`SHALL NOT be writable`) has no test at all
because it is a compile-time property. Do the rewrite with the scenario titles pinned and the nine
sentences extracted first; hold the nine scenario drops as a separate decision, since each one
deletes a passing test.
