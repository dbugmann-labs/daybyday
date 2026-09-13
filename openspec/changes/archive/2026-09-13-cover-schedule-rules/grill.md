# Grill — cover-schedule-rules

*15 questions over 3 rounds, 2026-09-13.*

Inherited from the seventh grooming pass and not re-asked: tests are accepted green on arrival
(B-048's three in #224 are the single mutation exception); rules nothing can prove stay in their
specs and are recorded; this Story writes its own bullet under `docs/open-questions.md`
§ *Known gaps*; ADR-1047 is amended in place, not superseded, and **this Story carries the
amendment** — the owner reaffirmed that on 2026-09-13, and #222–#224 unblock when it merges.

## Settled — the lane (what the ADR-1047 amendment records)

1. **A new test red on arrival.** The Story fixes `src/` here. *Against the recommendation, which
   was to stop and give the defect its own Story; the spec is what ships, so the code is brought to
   it.*
2. **What bounds that fix.** Only the code that makes a covering scenario that failed on arrival
   pass. That failing run is rule 3's red. The fix is named in `design.md` or the PR, and G7 checks
   that nothing else moved. The Story stays a covering Story. *Relabelling it a behaviour Story
   would pull in ADR-1047's owed budget review for an incidental fix.*
3. **Rewording a rule.** Allowed, as minimally as keeps the rule true. *Against the
   recommendation, which was byte-identical prose.*
4. **What rewording may touch.** Only a rule this Story covers, never an unprovable one, with each
   change's before and after in `design.md` and G7 checking that no rule was dropped or added.
   *The pruning Stories' failure was exactly a silent drop or addition.*
5. **Scenarios per rule.** Exactly one new scenario per uncovered rule, never one shared by two.
   *So the reverse-coverage check (B-047) can map one rule to one scenario.*
6. **What "covered" means.** Some scenario would fail were the rule broken. A scenario that
   only visits the case does not count, and no mutation is required.
7. **Pointer sentences.** A SHALL that only defers to another requirement ("as *X* says") is
   covered when its target is. It gets no scenario, and `design.md` names each one skipped.
8. **Where the amendment lands.** In this Story's PR, written by `spec-author` with the delta and
   read at G4 on the same draft PR.

## Settled — schedule's list

The candidates are `condense-schedule-spec/design.md` § *Open Questions*, re-derived against the
current spec. 11 of its 12 are still uncovered. *No leading zero* is already covered: the shipped
"The 1st", "1x a week" and "Every 2 days" would fail without it. About nine more candidates surfaced
that the hint had missed.

9. **Four rules get a scenario and a test each:**
   - short month: schedules on the 28th and 30th, like the 29th and 31st, land on the last day of a
     common February. Only the 29th and 31st were proven.
   - every N days: repeats forward without end and has no final occurrence, shown far forward near
     9999.
   - Gregorian weekday: holds for every accepted date, shown at 1 January 1583 and
     31 December 9999.
   - not due before start: weekday-set and day-of-month shapes stay due on dates they match in
     either direction.
10. **"Not a collision to be resolved"** restates the same-date rule rather than adding one. The
    28th–31st scenario would fail if any were moved off the date.
11. **"This requirement SHALL bound the year alone"** assigns scope between two requirements, as a
    pointer does. It is not a rule; see 7.
12. **Time, time zone, locale and week start are unprovable.** That is the exclusion clause in each
    of the five due requirements, read as five rules deliberately, plus rhythm-in-words "not taken
    from the device's language, region, locale". No seam accepts any of them, `CalendarDate` pins
    its own Gregorian UTC calendar, and a test mutating process-wide defaults is outside the seam
    definition and races Swift Testing's parallel runs.
13. **Unprovable, enforced by the compiler:**
    - the five "no schedule SHALL be built on / asked about" an out-of-range value
    - "MUST NOT form a date with a component missing" (non-optional `Int`)
    - a calendar date's numbers "not writable" and "only by forming a new one" (`let`)
    - rhythm in words "the same whatever day asked on / about" and day-of-month words "the same in
      every month of every year" (`inWords` takes no date)
14. **Unprovable, because they bind meaning or a consumer:** weekly quota "due MUST NOT mean still
    outstanding", "week complete MUST be decided from tick records", "seven SHALL mean one
    completion each day", and rhythm in words "whether or not any commitment carries it". *Proving
    them at a record or day-view seam would prove the consumer, not schedule.*
15. **An interval with no upper bound, at `Int.max`, is not taken.** The owner left it unticked.
    Today it is shown only at 4,000,000, so the overflow half is recorded rather than proven.

Everything in 12–15 goes into this Story's single *Known gaps* bullet.

## Terms landed in CONTEXT.md

- **Covering Story** — the third lane, with *covered* defined inside it (answers 1–7).

## Left open

None. Every question the frontier raised was answered. The seam, each scenario's wording and the
amendment's text are `spec-author`'s. One default was assumed rather than asked: the *Known gaps*
bullet is new, not appended to the existing schedule bullet about payload accessors
(`docs/open-questions.md`, "A schedule's payload cannot be read back out"), because that bullet
records a different gap.
