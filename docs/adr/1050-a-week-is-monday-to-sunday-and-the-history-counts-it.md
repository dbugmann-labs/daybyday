# 1050. A week is Monday to Sunday, nothing happens when it turns, and the history counts it

- Status: accepted
- Date: 2026-09-14
- Deciders: Diego Bugmann
- Amended: 2026-09-14 — `say-standing-in-quota-row` (#236) put the pairing of count and quota into
  words in `schedule`, said given a count, rather than in the day screen, which reads those words
  onto a quota's row. Two sentences below are changed in place; the decision is untouched.

## Context

ADR-1015 decided that a weekly quota is due on every date and that whether a week's quota has been
met is not a question the `schedule` capability answers. It deferred three things by name to "the
first Story that counts ticks within a week": where a week begins, what happens when one turns, and
where the counting lives. `add-quota-standing` (#235) is that Story.

The behaviour that forces them is on the day screen. A commitment on "reading 3x a week" has a row
every night, and the row says the same thing on the seventh night as on the first, because nothing
it can see knows how much of the week is already behind you. The eighth grooming pass took that up
as B-025, and the Feature grill of 2026-09-14 settled the product side of it: a quota's row says its
**standing**, the count of days of its week it has been kept, through that row's own date.

Three questions had to be answered before a requirement could be written, and none of them can be
settled by a test in `schedule`, because no rule shape there ever consults a week.

## Decision

**A week is Monday through the following Sunday, on every phone, whatever the phone's calendar
setting says.** The seven days are a fixed span the engine works out for itself, not one Foundation
is asked for with a locale attached.

**Nothing happens when a week turns.** An unmet quota is neither recorded as a miss nor carried into
the next week. The next week starts at zero, and the week that turned stays readable by looking back
at its days, which is what the writable past already gives.

**The history answers, and the day view says.** The count is `record`'s: it is a fact about the
records held for a commitment, so the capability that holds them is the one that can answer it. It is
answered for every commitment, whatever its schedule, and it consults no schedule to answer. It is
the count of kept days and is never capped at the number a quota asks for. It is asked *of a date*
and counts that date's week through it, inclusive, by date and never by when a record was entered.

The answer is the count alone — one integer. Pairing it with the quota into words a person reads is
`schedule`'s, which says a weekly quota given a count, and a day-screen row on a weekly quota is
where those words are read — `say-standing-in-quota-row` (#236).

This ADR takes effect when the Story that carries it merges. The repo owner's G4 signature on that
change folder is its acceptance; if G4 declines, this file goes with the branch.

## Consequences

- **A restored history reads the same wherever it lands.** *Restore, not sync* promises that a
  history survives a move to a new phone; a week taken from the phone's locale would make the same
  records answer differently on the new one, which is the one thing that promise rules out.
- **No past day's answer moves.** The standing of a Wednesday counts Monday, Tuesday and Wednesday,
  so ticking Thursday does not change it, and a tick entered later onto Tuesday does. That is
  ADR-1013's writable past applied to a count rather than to a rule.
- **A met quota's row stays**, says its standing, and still offers a tick. A fourth kept day against
  a quota of three reads as four: the count is what happened, and an app that edited it down to look
  tidy would be keeping a false record.
- **There is still no such record as a miss**, and nothing anywhere counts weeks. A run of met weeks
  is exactly the streak *Nothing congratulates you* was written against, and this decision is what
  keeps the count inside one week where it cannot become one.
- **`schedule` knows no week and ADR-1034 holds.** The week is `record`'s to know; no rule shape
  consults it, and `Weekday` gains no order. `schedule` says a count it is handed and never counts. ADR-1015's deferral is discharged rather than reversed.
- **Reversing the week start is expensive**, which is why this is a record rather than a line in a
  design document: every past week would be re-read, and every standing a person has ever seen would
  change without a single record having moved.

## Alternatives considered

**Take the week from the phone's calendar setting**, so that a person whose week starts on Sunday
sees Sunday-first. Rejected on the restore promise above, and on two facts already on disk: the
product already says weekdays Monday-first everywhere it says them, and `CalendarDate` deliberately
answers on a fixed Gregorian calendar in UTC rather than the host's (ADR-1004), so a locale-derived
week would be the only locale-dependent answer in the engine.

**Carry an unmet quota over, or record the shortfall as a miss.** Rejected because a miss is a
record kind this product does not have: every record is something a person did, and a count of
misses is a streak in reverse. Carry-over was declared out of scope when the quota shape shipped,
and the want that asked for it, B-017, was dropped at the same grooming pass that raised this one.

**Say what the week still asks — "2 to go" — rather than what has been kept.** Recorded because it
was the recommendation and was overruled: the owner chose the kept count, told that it sits on the
achieved side of *Nothing congratulates you*. The decision is his and is not to be re-argued from
the principle; what the principle does rule out is counting anything above the week.

**Cap the count at the quota**, so a row can never read 4/3. Rejected: the cap is the app editing
what happened, and a caller that wants "met" compares the count with the number it already holds.

**Answer it in `schedule`, or give `Schedule` a week boundary.** Rejected by ADR-1015 and ADR-1034
before this Story opened — due-ness is a function of a date alone, and a week order inside the rule
engine is reachable by every rule shape that must not consult one.

**Count in the day view instead.** Rejected because `day-screen`'s spec says a day view counts
nothing and never enumerates the history: it is handed its commitments and reports one date. A
counting day view would be a second thing that knows what kept means.
