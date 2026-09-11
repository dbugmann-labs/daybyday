# Grill — condense-schedule-spec (#208)

Held 2026-09-11 by the conductor with the owner: one round of five questions, every one answered
with the recommendation. The frontier was indexed from `survey-schedule-cli.md` (schedule parts
only) into `grill-frontier.md` beside this file, and **every survey claim was checked against the
current spec, the scenarios and `docs/adr/` rather than carried**: 18 requirements, 78 scenarios,
3,448 words of requirement prose, matching the survey exactly.

**The survey undercounted in three places, and this grill is held on the frontier's figures.** It
names two pieces of rationale with no ADR home; there are five, because for three it homed the
rule to an ADR without checking the argument beside it (frontier § A.3–A.5). It names one rule with
no scenario; there are ten (§ B), plus two *Rules at risk* only partly asserted (§ C.3, § C.8). And
one *Rules at risk* sentence is asserted by a scenario filed under a different requirement (§ D).

## Settled

1. **The ten rules with no scenario each survive as a bare SHALL/MUST sentence in the requirement
   where they stand today, and this Story adds no scenario.** This covers req 13's *readable and not
   writable*, which the compiler enforces through `let`; the *MUST NOT consider the current time,
   the time zone or the locale* exclusion that each of reqs 1, 2, 5, 8 and 11 states for its own
   predicate, cut to one clause per requirement and **not** consolidated into one place; req 14's
   same words whatever day it is asked on; req 9's *either direction* for the two calendar-anchored
   shapes; req 11's rule that a surface stopping a quota once its week is complete decides that from
   tick records; and req 4's statement that month and day are bounded by req 3, not by req 4.
   Deleting one would be a behaviour change by omission and writing a test for one is a change this
   Story may not make (ADR-1047). `design.md` § Open Questions lists all twelve — the ten plus req
   6's thirtieth in a common February and req 14's *no leading zero* — as *knowingly untested*.

2. **The short-month clamp gets a new short ADR, 1051, and the read-back argument amends ADR-1004.**
   No ADR records why a day-of-month schedule on a day a month lacks is due on that month's last day
   rather than skipped; ADR-1006 cites it only as an example of a product decision an agent took.
   ADR-1051 records it, with the rejected alternative, and says why it does not contradict
   ADR-1004's refuse-rather-than-adjust: the calendar date the clamp lands on always exists, so
   nothing is formed and adjusted. ADR-1004 gains one paragraph: a formed calendar date gives its
   year, month and day back, which is the half of the edge conversion that needs them, and none of
   the three can be assigned, because a date changed one component at a time could pass through a
   combination that names no day. **The date-picker motivation in req 13 is history and is
   dropped.** 1048 is `day-screen`'s, 1049 `commitment`'s and 1050 held for `record`; verify 1051 is
   free in `docs/adr/` and on every branch before writing it.

3. **The three arguments the survey missed go into one amendment of ADR-1034**, the
   rhythm-in-words record: an every-N-days schedule does not say its start date because on every
   commitment a commitments screen makes it is the day the commitment is kept from (req 16); a
   quota of seven is not said as "Every day" because a person would read an obligation the schedule
   does not carry (req 18 — the wording B-017 and B-025 will reopen); and the empty weekday set has
   words because saying nothing reads as a rhythm missing rather than empty (req 15). The spec
   prose keeps the three rules and loses the three arguments.

   **Corrected 2026-09-11, after G4 and G7.** The quota-of-seven argument turned out false while
   the delta was written: `record` holds at most one tick per commitment a day, and req 12 says a
   quota of exactly seven means one completion on each day of the week, so a quota of seven asks
   for exactly what a weekday set of all seven does. ADR-1034 records the rule with the reason that
   actually holds, and says the former argument is not carried. This corrects a fact rather than a
   preference, so it was not raised as a residual round; the owner read it in `design.md` § Risks
   at G4 and in the G7 findings.

4. **No requirement splits, and the misfiled scenario stays where it is.** All 18 requirements go
   under `## MODIFIED Requirements`; the largest, req 13 at 351 words, is projected to 85. The
   scenario *an interval longer than the supported years is due only on its start date* sits under
   req 8 and tests req 10's no-upper-bound rule. Moving it would need req 8 REMOVED and re-ADDED —
   the archiver refuses a MODIFIED block that omits a current scenario — and would put req 8 at the
   end of the file inside an editorial diff. So req 10 states the rule in full, and req 8 refers to
   it in one clause, because its scenario depends on it; req 8 does not restate it. Placement is
   phase 3's to tidy, if anyone's.

5. **No scenario title changes and no scenario is dropped.** Every scenario block stays
   byte-identical under the heading it sits under now. The frontier found no false title in
   `schedule`, so ADR-1047 § decision 5 needs no amendment. The survey's nine duplicate-scenario
   candidates are phase 3 and not this Story.

What follows from the plan and needs no answer: `design.md` names no seam and says why; the
survey's *Rules at risk*, as corrected by frontier § C, are the checklist each rewritten requirement
is verified against and the reviewer's fidelity axis at G7; verifiers run before G4, as
`condense-commitment-spec` did.

**Read before writing this delta**: the three editorial Stories before this one each lost a rule
that every mechanical check passed — a second bound on a digit count, an offset's lower bound, and
a rule that survived only as a "so that" — and one garbled a sentence with a mid-sentence string
edit. Keep every bound and every condition; defer behaviour for behaviour and never name a count.

## Left open

None. Every frontier item is disposed of by one of the five settled answers. The wording of every
requirement, of ADR-1051 and of the two amendments is `spec-author`'s and the rewrite's work, with
the frontier giving line-level input. A question that only appears while the delta is written goes
to the owner as a residual round under `## Questions for you` in `design.md`, before G4 and as a
stop rather than a gate.

## Terms landed in CONTEXT.md

**None new.** *Editorial Story* and *Budget* were landed by `condense-day-screen-spec` (#201) and
are unchanged. Every domain term this grill touched — calendar date, schedule, weekday set, day of
the month, every N days (whose entry defines the interval), weekly quota, rhythm in words, kept
from — is already defined in `CONTEXT.md`, checked by entry. This Story
introduces no behaviour, so it introduces no product vocabulary.
