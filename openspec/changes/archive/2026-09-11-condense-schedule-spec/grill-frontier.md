# Grill frontier — schedule spec, from one survey

Index only, no added analysis. Ref is `survey-schedule-cli` (2026-09-09), schedule parts only —
`cli-version` is out of scope for this Story except the one-line note in D. Every quote below was
checked against `openspec/specs/schedule/spec.md` as it stands today and every ADR claim against
the file named, by direct grep/read, not taken on the survey's word.

## Measurement table

Prose = words outside `#### Scenario:` blocks and outside the `### Requirement:` heading itself,
counted by a script walking the file (each requirement's prose is every line from just after its
`### Requirement:` heading to just before its first `#### Scenario:`). File is 741 lines (survey
says 740 — one-line drift, immaterial, not investigated further). 18 requirements, 78 scenarios,
3,448 prose words — every one of these totals, and every per-requirement word/scenario count
below, matches the survey's own table exactly.

| # | Requirement | Lines | Prose w | Scen | Survey verdict | Before → target |
|---|---|---|---|---|---|---|
| 1 | A weekday-set schedule is due on the weekdays it lists | 11–47 | 104 | 5 | keep | 104→95 |
| 2 | The weekday of a calendar date follows the Gregorian calendar | 48–67 | 77 | 2 | trim | 77→60 |
| 3 | A calendar date names a day that exists | 68–119 | 146 | 7 | trim | 146→125 |
| 4 | A calendar date lies within the years the system supports | 120–167 | 282 | 5 | **rewrite** | 282→75 |
| 5 | A day-of-month schedule is due on that day of the month | 168–200 | 123 | 4 | trim | 123→110 |
| 6 | A month too short for the scheduled day is due on its last day | 201–246 | 232 | 5 | **rewrite** | 232→110 |
| 7 | A day of the month is a number from the first to the thirty-first | 247–270 | 100 | 3 | trim | 100→65 |
| 8 | An every-N-days schedule is due on its start date and every interval after it | 271–343 | 200 | 9 | trim | 200→150 |
| 9 | An every-N-days schedule is not due before its start date | 344–373 | 196 | 2 | **rewrite** | 196→75 |
| 10 | An interval is a whole number of days, at least one | 374–403 | 165 | 3 | trim | 165→110 |
| 11 | A weekly-quota schedule is due on every date | 404–459 | 284 | 6 | **rewrite** | 284→120 |
| 12 | A weekly quota is a number of times from one to seven | 460–495 | 174 | 4 | **rewrite** | 174→85 |
| 13 | A calendar date gives back the year, the month and the day it names | 496–550 | 351 | 4 | **rewrite** | 351→85 |
| 14 | A schedule says the rhythm it runs on in words | 551–594 | 338 | 3 | **rewrite** | 338→150 |
| 15 | A weekday-set schedule is said as its weekdays, in week order from Monday | 595–637 | 199 | 5 | trim | 199→110 |
| 16 | An every-N-days schedule is said as its interval, and never as its start date | 638–673 | 169 | 4 | trim | 169→90 |
| 17 | A day-of-month schedule is said as the ordinal of its day | 674–712 | 159 | 4 | trim | 159→95 |
| 18 | A weekly-quota schedule is said as a number of times a week | 713–740 | 149 | 3 | trim | 149→90 |

Verdict spread: 1 keep, 10 trim, 7 rewrite (matches survey).

## A. Rationale with no ADR home

1. **The short-month clamp (req 6).** "This is what keeps a monthly commitment monthly. A schedule
   on the 31st that were simply absent from February, April, June, September and November would
   come due in seven months of the year and pass five of them in silence, and a commitment that
   quietly never comes due is the failure this product exists to remove. The consequence is
   accepted rather than hidden: in a common February, schedules on the 28th, 29th, 30th and 31st
   all fall on the same date, which is the correct reading of 'the end of every month' and not a
   collision to be resolved." (spec L211–216)
   - `ADR-1004-the-rule-engine-speaks-calendar-dates.md`: touches calendar-date validity generally
     ("refuse rather than adjust" at L39–43, the 1583–9999 bound at L44–55) but **has zero hits**
     for "clamp" or "short month" — it never discusses a schedule landing on a month's last day.
     Records a different decision (refuse-not-adjust for *forming* a date), not this one.
   - `ADR-1006-the-question-round.md` L35–39: "On `add-day-of-month-schedule` (#9), what a short
     month does — clamp to the last day, or skip the month entirely — is a product decision with
     no technical answer. `spec-author` took it, argued it from `CONTEXT.md` and
     `docs/parking-lot.md`, wrote the rejected alternatives down, and labelled it honestly in
     `design.md`: 'The clamp is a product decision an agent is proposing, not a fact.'" —
     **mentions only, as a worked example inside a process ADR about how the grill should have
     run.** It does not argue or record the clamp-vs-skip decision itself; that argument lives in
     an archived `design.md`, not in any ADR.
   - Confirmed: no ADR records this decision. [survey §2 row "Clamp to the last day of a short
     month, and why not skip" — "No decision ADR"]

2. **The calendar-date read-back and immutability argument (req 13).** "The three SHALL be
   readable and SHALL NOT be writable. A calendar date whose components could be assigned one at a
   time could be walked, between two dates that both exist, through a combination that names none
   — 31 January with its month set to February — and the refusals above would then be a rule about
   how a date is first made rather than a rule about every calendar date that exists. The only way
   to have a different calendar date is to form a new one, which is judged the same way the first
   was. This is the half of ADR-1004's conversion that could not be performed. That decision put
   calendar dates in the rule engine and instants at the edge, and an edge converts in both
   directions: turning an instant into a calendar date is a matter of asking a calendar for its
   components, and turning a calendar date back into an instant is not possible at all unless those
   three numbers can be read. The first thing to need it is a screen seeding a date picker with the
   day it offers to keep a commitment from, which speaks instants and has no other way to be told
   which day that is." (spec L503–516)
   - `ADR-1004`: records the edges-convert decision (L56–58: "Conversion between an instant and a
     calendar date happens at the edges … The engine never performs it") — that is the fact req 13
     cites, but ADR-1004 never discusses reading a *formed* `CalendarDate`'s own components back
     out, and has zero hits for "immutab" anywhere in the whole ADR set (`grep -rl -i immutab
     docs/adr/` hits only 1020 and 1010, both unrelated). The walking-through-an-invalid-state
     argument is not in ADR-1004 or anywhere else.
   - `ADR-1034-a-schedule-says-its-rhythm-in-words.md`: `grep -n -i "read.back"` hits only L115,
     "the payload read-back again with an extra step" — inside the *rejected* "Words on `Rhythm`
     alone" alternative, about a schedule's numeric payload, a different subject from a
     `CalendarDate`'s own y/m/d read-back. Does not touch req 13's subject.
   - Confirmed: neither ADR records the decision; only ADR-1004 records adjacent, cited context.
     [survey §2 row "Read-back is the half of ADR-1004's conversion that could not be performed;
     date-picker seeding motivation; immutability argument" — "Partly … Needs a new ADR"]

3. **Not in survey — req 16, "would repeat a day the person already chose."** "This is the rule
   rather than an omission: on every commitment a commitments screen makes, the start date is the
   day the commitment is kept from, so a start date said beside a name would repeat a day the
   person already chose. A commitment formed some other way may carry a start date that disagrees
   with the day it is kept from, and its rhythm in words says neither — what the words say is the
   interval." (spec L645–650) The survey's own table homes this passage's *line range* (646–651)
   to "ADR-1034 ll.52–54, which states both" — but ADR-1034 L55–57 states only the **rule** ("An
   every-N-days schedule does not say its start date"), never the **argument** (a commitments
   screen keeps a commitment *from* a day, so repeating the start date would repeat a day already
   chosen). `grep -n -i "already chosen\|repeat a day" docs/adr/1034*.md docs/adr/1013*.md` — no
   hit in either file. `ADR-1013-a-commitment-is-kept-from-a-day.md` defines "kept from" but never
   ties it to what a schedule's words should or should not say. The survey conflated the rule's
   home with the argument's; the argument itself is un-homed.

4. **Not in survey — req 18, the "obligation the schedule does not carry" argument.** "Seven times
   a week is deliberately not said as 'Every day'. A quota of seven is due on every date, as a
   weekday set of all seven is (ADR-1015), but it asks for seven completions in a week on any days
   of it rather than for one on each day, and a person reading 'Every day' beside a name would read
   an obligation the schedule does not carry." (spec L720–723) The due-on-every-date *fact* is
   correctly cited to ADR-1015 inline. The *reading-comprehension argument* — why saying "Every
   day" for a 7x-a-week quota would mislead a person about the obligation — is not in ADR-1015
   (which never discusses wording at all) and not in ADR-1034 (`grep -n -i "every day"
   docs/adr/1034*.md` hits only two unrelated lines, L53 and L108, neither about the
   quota-vs-weekday-set wording distinction). No ADR argues this.

5. **Not in survey — req 15, "reads as though its rhythm were missing rather than empty."** "The
   empty set is a schedule the system forms and a roster can hold — it is due on no date, and this
   capability accepts it rather than treating it as an error — so it has words like every other
   schedule, even though a commitments screen refuses to define a commitment on one (ADR-1028).
   Saying nothing at all for it would leave an entry that reads as though its rhythm were missing
   rather than empty." (spec L604–608) `ADR-1028-a-screen-may-refuse-what-the-rule-engine-accepts`
   is correctly cited for the *screen's* refusal of the empty set, but that ADR is about where a
   refusal is made (screen vs. engine) and never discusses how the empty set's words should read;
   `grep -n -i "reads as though\|missing rather than" docs/adr/1028*.md docs/adr/1034*.md` — no
   hit. No ADR argues why "No day" beats saying nothing.

**A: 5 items** — 2 named by the survey (clamp, read-back/immutability), 3 found on my own sweep of
all 18 requirements and flagged "not in survey" (req 16 start-date-repeat, req 18
obligation-misread, req 15 rhythm-missing-vs-empty). All three additional items share the same
survey mistake: the survey's rationale table homed the *rule* to an ADR without checking whether
the *argument beside it* was also there.

## B. Rules with no scenario

1. **The readable/not-writable rule (req 13).** "The three SHALL be readable and SHALL NOT be
   writable." (spec L503) `grep -rn -i "writable\|readable" src/DayByDayKit/Tests/DayByDayKitTests/
   *.swift` finds hits only in `DayScreenTests.swift` (`recordState == .unreadable`, a
   file-writability test helper for a different capability) — no hit in `ScheduleTests.swift`,
   `DayOfMonthScheduleTests.swift`, `EveryNDaysScheduleTests.swift` or
   `WeeklyQuotaScheduleTests.swift`. No test found. The type itself,
   `src/DayByDayKit/Sources/DayByDayKit/CalendarDate.swift` L17–19: `public let year: Int`,
   `public let month: Int`, `public let day: Int` — all three are `let`, not `var`; there is no
   setter, no mutating method, and no way to assign one after `init?` returns. The doc comment
   above them (L13–16) says as much: "Read-only: the only way to change one is to form a new
   `CalendarDate`." So yes: the compiler enforces both halves — `public` makes them readable, `let`
   with no mutator makes them unwritable — which is exactly why no test exists for it; it is a
   compile-time property, not a runtime one. [survey §1 Req 13 row, verified]

2. **Req 1, the time/zone/locale/week-start exclusion.** "the system MUST NOT consider the current
   time, the device's time zone, the locale, or which day the user considers the week to begin on."
   (spec L15–16) None of req 1's five scenarios vary time zone, locale, "current time," or a
   week-start convention — every scenario is a fixed weekday-vs-date check. No scenario covers it.

3. **Req 2, time zone/locale invariance.** "The answer MUST NOT vary with the host's time zone or
   locale, which it cannot, because a calendar date carries neither." (spec L53–54) No scenario
   passes a time zone or locale as input (there is nowhere to pass one — `CalendarDate` carries
   neither, per ADR-1004's seam). Self-evidently true by the type signature rather than by test;
   same shape as item 1.

4. **Req 5, the weekday/time/zone/locale exclusion.** "the system MUST NOT consider the weekday the
   date falls on, the current time, the device's time zone or the locale." (spec L174–175) None of
   req 5's four scenarios vary any of these. No scenario covers it.

5. **Req 8, the same exclusion for every-N-days.** "the system MUST NOT vary the count by the
   length of the months the two dates fall in, by the weekday either falls on, by the turn of a
   year, by the current time, by the device's time zone or by the locale." (spec L279–281) Partly
   tested: "the interval counts across the end of a month" and "the interval counts across the turn
   of a year" scenarios do exercise month-length and year-turn independence. "the weekday either
   falls on," "the current time," "the device's time zone" and "the locale" are not exercised by
   any scenario.

6. **Req 11, the same exclusion for a weekly quota.** "the system MUST NOT consider the weekday the
   date falls on, which week the date belongs to, where a week begins, how many times the quota
   asks for, the current time, the device's time zone or the locale." (spec L408–410) Partly
   tested: the six scenarios span different weekdays, week boundaries and quota numbers (1 and 3),
   so "which week" and "how many times" get incidental coverage. "where a week begins," "the
   current time," "the device's time zone" and "the locale" are not exercised by any scenario.

7. **Req 14, invariance across the asking date and across whether a commitment carries the
   schedule.** "no calendar date is asked for and none is consulted, so a schedule says the same
   words whatever day it is asked on, whatever day it is asked about, and whether or not any
   commitment carries it." (spec L554–556) No scenario asks the same schedule's words on two
   different "todays," asks about two different target dates, or compares a schedule attached to a
   commitment against one that is not. No scenario covers it.

8. **Req 9, moved from C — the weekday-set/day-of-month "either direction" exclusion.** "The
   weekday-set and day-of-month shapes are anchored to the calendar rather than to a start, and
   remain due on every date they match in either direction; this requirement does not change them."
   (spec L357–359) Neither req 1's nor req 5's scenarios test a notion of "direction" at all — those
   shapes have no start date and no "before/after" concept in any scenario, so nothing in the spec
   actually exercises a weekday-set or day-of-month schedule matching "in either direction." Checked
   against C — no scenario asserts it; moved here per the survey's own "Rules at risk" flag on this
   sentence with no scenario named.

9. **Req 11, moved from C — the bold consumer-constraint paragraph.** "the system SHALL keep it
   outside this capability: a surface that stops showing a weekly quota once its week is complete
   MUST decide that from tick records, not from this predicate." (spec L419–420) This binds a
   *consumer* of `schedule` (the day screen), not anything `schedule`'s own scenarios can assert —
   no scenario in req 11 involves a tick record or a consuming screen. Untestable inside this
   capability by construction, the same shape as record-spec's "MUST NOT persist the sum" item.
   Moved here; no scenario asserts it.

10. **Req 4, moved from C — the req-3/req-4 division-of-labour clause.** "the year inside a range
    the system judges for itself, so that no year large enough to be read back as unspecified
    reaches the calendar underneath — the month and the day are bounded by the requirement above,
    not by this one." (spec L138–140) Req 3 has three scenarios for an extreme month, year and day
    respectively, each using an otherwise-valid year (2026). Req 4 has no scenario that combines an
    extreme month or day *with* an in-range year to show req 3 (not req 4) is what catches it, nor
    any scenario showing req 4 does *not* also bound month/day. The sentence states a scoping fact
    about which requirement owns which bound; no scenario in either requirement exercises the
    boundary between them directly.

**B: 10 items** — 1 named by the survey (req 13, verified with the source-level check the task
asked for), 6 found on my own sweep (items 2–7, the recurring time/zone/locale/weekday-independence
clause that appears near-verbatim in five different requirements and is never once exercised by a
scenario — all structurally guaranteed by ADR-1004's seam taking no clock, zone or locale argument
at all, the same "compile-time property" shape as item 1), and 3 moved out of section C after
checking scenario attribution there (items 8–10).

## C. The nine Rules at risk, attribution checked

All nine sentences below are unchanged from the survey's quotes — checked against the current
741-line file and found byte-identical at the same line numbers (740 vs 741 total is the only
drift anywhere in the file, and it falls after every quoted passage). No survey misquote found.

1. **Req 3, L76–78.** "SHALL also judge each of the three components as the number it was offered,
   and MUST NOT accept a date in which a component was treated as absent or unspecified because its
   value was extreme." Asserted by: "a month of the largest representable integer is not a calendar
   date" (L102–106), "a year of the largest representable integer is not a calendar date"
   (L108–112), "a day of the largest representable integer is not a calendar date" (L114–118) — all
   three sit correctly under req 3 and confirm the rule (`ScheduleTests.swift:201,210,217` per
   survey). Confirmed asserted.

2. **Req 4, L138–140.** The division-of-labour clause. **No scenario asserts it** — moved to B.10.

3. **Req 6, L213–216.** "in a common February, schedules on the 28th, 29th, 30th and 31st all fall
   on the same date." Asserted, partially: "a schedule on the thirty-first is due on the last day of
   a common February" (L224–228, 31st→28 Feb) and "a schedule on the twenty-ninth is due on the last
   day of a common February" (L236–239, 29th→28 Feb) both confirm the claim for two of the four
   named day-numbers. **No scenario schedules the 30th** in a common February, so a third of the
   claimed four-way collision is asserted only by the other two's pattern, not directly. (The 28th
   needs no clamp and is not really part of the claim.)

4. **Req 9, L357–360.** The "either direction" exclusion. **No scenario asserts it** — moved to
   B.8.

5. **Req 10, L383–387.** "no upper bound … comes due on its start date and never again … MUST give
   that answer rather than refusing the interval or losing the arithmetic to overflow." Asserted by
   "an interval longer than the supported years is due only on its start date" — **but this
   scenario is physically filed under Requirement 8** ("An every-N-days schedule is due on its
   start date and every interval after it," spec L335–342), not under Requirement 10 where the rule
   it tests is stated. The survey's own §1 entry says as much in passing ("it lives in a different
   requirement's second paragraph") without ever listing it as a structural move in §3 or §5. See D.

6. **Req 11, L418–422.** The bold consumer-constraint paragraph. **No scenario asserts it** — moved
   to B.9.

7. **Req 13, L503–508.** "SHALL be readable and SHALL NOT be writable … the refusals above would
   then be a rule about how a date is first made rather than a rule about every calendar date that
   exists." No scenario asserts it (no Given/When/Then can assert a compiler property) — already
   fully covered in B.1 with the source-level check.

8. **Req 14, L566–568.** "Every number SHALL be said in digits, with no grouping separator and no
   leading zero." Asserted, partially: "a number is said in digits with no grouping separator"
   (L590–593, "Every 1000 days" not "Every 1,000 days") tests the digits-and-no-comma half.
   **No scenario tests "no leading zero" independently** — every number in the four shapes'
   scenarios (day 1–31, quota 1–7, arbitrary interval counts) happens to be written without a
   leading zero in its expected string, but no scenario is built to catch one appearing.

9. **Req 14, L571–572.** "Two schedules that name the same rhythm SHALL say the same words."
   Asserted by "two schedules that name the same rhythm say the same words" (L584–588: a
   weekday-set of all seven and an interval of one day both say "Every day"). Title and prose match
   exactly; confirmed asserted, correctly homed under req 14.

**C: 9 sentences checked, 3 moved to B (items 4, 5→D not B — see below, 6), 1 fully resolved in B
already (7), 2 found only partially asserted rather than fully (3, 8), 3 confirmed cleanly asserted
(1, 9, and 5's underlying rule — asserted, but by a misplaced scenario, so it moves to D rather than
staying clean).**

## D. Structural moves

**One found, confirmed rather than the survey's implied "none."** The survey has no dedicated
structural-moves section for `schedule` (unlike its own `cli-version` structural nit, which is
noted separately), so "the survey lists none" holds only in the sense that nothing is filed under
that heading — but survey §1's own text on Req 10 (L73–77) already states the fact: "This is the
rule Req 8's scenario `an interval longer than the supported years is due only on its start date`
tests, and it lives in a different requirement's second paragraph." That scenario (spec L335–342)
sits under **Requirement 8** ("An every-N-days schedule is due on its start date and every interval
after it") but tests the no-upper-bound rule stated in **Requirement 10**'s prose ("An interval is a
whole number of days, at least one," L383–387: "There is no upper bound … the system MUST give that
answer rather than refusing the interval or losing the arithmetic to overflow"). One scenario, one
misfiling, noted by the survey in passing but never surfaced as a structural finding.

No other candidate found on a full pass of all 78 scenario placements against their own
requirement's stated rule.

**Note, no action: `cli-version`'s moved scenario is a different capability and out of scope.** The
survey's own line (l.46–47): "the scenario *version with extra arguments is rejected* (l.25) sits
under Requirement 1 but is governed by Requirement 2's rule; moving it would change nothing a test
reads" — this is `cli-version`, not `schedule`, and this Story does not touch it.

## E. Scenario titles known false or awkward

**None found.** All 78 scenario titles in `schedule` were read against their own WHEN/THEN/AND
bodies and against the requirement prose above them; none asserts something the test or the prose
contradicts. `docs/adr/1047-*.md` decision 5 names three scenario titles known to be false — two in
`openspec/specs/commitment/spec.md`, one in `openspec/specs/day-screen/spec.md` — and none in
`schedule`. Consistent with the survey, which raises no title-accuracy issue anywhere in its
`schedule` coverage.
