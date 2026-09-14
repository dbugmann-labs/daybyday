# Grill — say-standing-in-quota-row

*8 questions over 2 rounds, 2026-09-14. Two fact agents; no fact sent to the owner.*

Already settled upstream and not re-asked: the kept count rather than what the week still asks,
Monday weeks, counted as of the row's own date, the true count past the quota, the count inside the
rhythm words, the day-screen row only, and a met row staying and offering a tick — the 2026-09-14
grooming pass for B-025, recorded in `CONTEXT.md` § *Standing*. The history's side shipped in #235.

## Settled

1. **A week with nothing kept yet.** A row says "0/3x a week", not the plain words. *A zero is an
   answer, and the history already gives zero rather than nothing; one form on every day.*
2. **How a met quota says so.** The count is the whole of it — "3/3x a week", "4/3x a week" — and a
   row carries no separate met state. *A met flag is something for the shell to celebrate, and
   nothing here congratulates anyone.*
3. **Row identity.** The standing is a fourth thing a row is, on a weekly quota's row only. Two
   quota rows alike in commitment, date and what the day holds but saying different standings are
   different rows; a row on any other schedule holds no standing. *Rows a reader can tell apart are
   different rows, and non-quota rows must not differ by something nobody can see.*
4. **A day that has not arrived.** Its row still says its standing, counted through its own date,
   with no special case. *Every row always says its rhythm; a future row already refuses its tick,
   and a second rule about today would make the words depend on the present as well as the date.*
5. **Who composes "1/3x a week".** `schedule` does: a schedule can be said given a count, and
   `day-screen` goes on composing none of the words. *All the English stays in the one capability
   that owns it; the commitments screen and the form preview keep the plain words.*
6. **A count handed to a schedule that is not a quota.** A weekday set, an interval and a day of the
   month say their plain words and ignore it. *The count means nothing against them, and one answer
   for every schedule means nothing is refused.*
7. **A count no week can hold** (-1, 9). Said as given — "9/3x a week". *The words judge nothing, as
   a rhythm carries its number as given and a standing is never capped; the range is the history's
   to guarantee.*
8. **A quota row whose commitment is not a tick.** Number, note and total rows on a weekly quota say
   their standing too. *The words have nothing to do with kind, and the history already decides what
   keeps a day for each kind.* Fact: every kind may run on a weekly quota, and a total's day keeps
   only at its target (`record` spec 1863, `History.swift:48-49`).

## Facts found, for the delta

- A history can hold records dated after today (a record read from disk, `History.add`), so a
  future row's standing can exceed today's. Settled answer 4 covers it; no refusal is owed.
- Falsified by answer 1: `day-screen` scenario *a row says the rhythm its commitment runs on in
  words* ("3x a week" on a Monday with no ticks) and `DayViewTests.swift:970-972`.
- Requirements the delta must carry as MODIFIED: *A row is its commitment, its date and what that
  day holds* ("three things and no others"), and *A row gives back what a screen draws and what a
  tap makes* ("composes none", and "two rows alike in the three things say the same rhythm", which
  answer 3 makes false). `schedule` gains the counted words; its existing plain-words scenarios and
  the commitments screen's stand.
- No existing row- or day-view-sameness scenario or test uses a weekly quota
  (`day-screen` 2173-2257, 2929 on; `DayViewTests.swift:1382, 1401`; `DayScreenTests.swift`).
- Row equality is read by `DayScreen.swift:223, 255, 352` and the shell's notice match
  (`ContentView.swift:499`), so a tick on Monday makes Wednesday's quota row a different row. That
  follows from answer 3; the fact agent listed it as open and it is not.

## Terms landed in CONTEXT.md

No new term. Two entries amended: **Row** (a quota row says and is its standing; no met state) and
**Rhythm in words** (a schedule said given a count).

## Left open

None. Every question the frontier raised was answered, and the five the second fact agent flagged as
possibly open are each settled above or upstream: past the quota (upstream), future rows (4), rows on
later days changing (3), kind (8), and records before *kept from*, which `record` cannot hold since a
record is refused where its commitment is not due.
