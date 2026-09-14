# Grill — add-quota-standing

*2 questions over 1 round, 2026-09-14 — on top of the 10 the Feature grill of B-025 settled the
same day, which are carried in here because this Story is the first to read them.*

Story #235, under `FEAT: record` (#53). Intent: a history answers, for a commitment on a weekly
quota, how many days of the Monday-to-Sunday week of a date it was kept, through that date.
Story #236 `say-standing-in-quota-row` (day-screen) is blocked on it and says the answer.

## Settled

**From the Feature grill of B-025 (10 questions, 2 rounds, same day).** Durable in `CONTEXT.md`
§ *Week*, § *Standing*, § *Weekly quota*, § *Day view*, § *Rhythm in words*; in `docs/backlog.md`
§ *Decided* (B-025); and in `docs/open-questions.md` § *Settled* (*Week turnover*).

1. **A week begins on Monday, for everyone.** Monday through Sunday, whatever the phone's calendar
   setting. *Weekdays are already said Monday-first, the engine's calendar is locale-independent,
   and a restored record must read the same on any phone.*
2. **Nothing happens when a week turns.** An unmet quota is neither recorded as a miss nor carried
   over; the next week starts at zero. *A miss is a record kind the product does not have, and a
   count of misses is a streak in reverse.* Carry-over was declared out of scope when the quota
   shape shipped, and B-017 was dropped today.
3. **The row shows the kept count, "1/3x a week", not what the week still asks.** The owner's call,
   against the recommendation and told it sits on the achieved side of *nothing congratulates
   you*. Decided; not to be re-argued in this Story's delta.
4. **Standing is counted as of the date it is asked of**, inclusive: the week's days through that
   date, by date and not by when the record was entered. Wednesday's standing does not move when
   Thursday is ticked; a tick entered later onto Tuesday counts. *The row says what that day
   asked.*
5. **The count is never capped.** A fourth kept day against a quota of three is a standing of
   four. *A cap is the app editing what happened.*
6. **The history answers; the day view says.** ADR-1015 left "has this week been met?" to a
   capability that can see ticks, and `day-screen`'s spec says a day view counts nothing and never
   enumerates the history. So the counting is `record`'s and this Story's; #236 only reads it.
7. **Day-screen row only**, inside the rhythm words; the commitments screen keeps "3x a week". A met
   quota's row stays, says 3/3, and still offers a tick. *These are #236's to write; listed so this
   Story's seam serves them and nothing more.*

**From this grill.**

8. **The history answers for any commitment**, not only one on a weekly quota: the count of days
   in the Monday-to-Sunday week of the date, through the date, on which the commitment was kept,
   whatever its schedule. *A fact about kept days, the schedule does not enter, and it mirrors the
   total reader, which answers zero for a non-total rather than refusing. The row decides what to
   show by shape.*
9. **The answer is the count alone** — one integer — not count and quota together. *The quota
   number is the commitment's, reachable where the row's words are composed, and pairing them is
   #236's job.*

**Consequences the facts settle, not asked because no preference is involved.**

- "Kept" is `History.isKept(_:on:)`'s answer, whatever the kind: a tick, any number, any note, a
  total whose day reaches its target. The count is of kept days, not of ticks.
- No record can exist before a commitment's kept-from day or on a date it is not due (the record
  types refuse to form), so the count over a week that starts before the kept-from day is simply
  the count of the days that hold a kept record. Records after a kept-until day stand and count;
  the history knows nothing of kept-until, and the row will not exist there anyway.
- A week truncated by the supported range — 1 January 1583 is a Saturday, 31 December 9999 a
  Friday — counts the days that exist. Nothing else is special about a year or month boundary.
- Nothing in the package orders `Weekday` or offers a week boundary today: `CalendarDate.weekday`,
  `adding(days:)` and `days(until:)` are internal and there is no weekday ordinal. ADR-1034 rejected
  putting a week order into the rule engine; the week is `record`'s to know, not `schedule`'s, and
  the delta must not make a schedule consult it.
- Standing follows the records through a carry-over, as every other history answer does.

**ADR.** Decisions 1, 2 and 6 are the ones ADR-1015 § Consequences deferred to "the first Story that
counts ticks within a week", and they are hard to reverse (a different week start re-reads every
past week) and surprising without context (why not the phone's setting; why the kept count against
the principle). Write one ADR for them. `docs/adr/README.md`'s rule is the lowest number no file
and no open branch has ever used: 1050 is absent from every ref's tree and 1051 is the highest
everywhere, so check `git log --all` for 1050 before taking it, and report rather than renumber if
it collides (the two 2026-09-07 ADR-1033 collisions are why).

## Terms landed in CONTEXT.md

- **week** — Monday through Sunday, the same on every phone; the span a weekly quota is counted
  over. Landed 2026-09-14 by the Feature grill (PR #237).
- **standing** — how many days of its week a commitment has been kept, counted through a date.
  Landed the same way.
- No new term from this grill.

## Left open

None. The two questions the frontier raised were answered, and every other edge the facts turned
up is a consequence of a decision already made rather than a preference. What is #236's — the
string, the met row, the surface — is listed under 7 so it is not silently re-decided here.
