# Grill — count-declined-days

*11 questions over 3 rounds, the last the layout round, 2026-10-16. One fact agent, on `origin/main` at
1fe57ee.*

## Settled before the grill, carried here

- A **declined** day is still owed and not kept (`CONTEXT.md` § Declined): it stays in a fraction's
  due days and out of its kept days, exactly as a look-back counts it today. This Story says how
  many there were; it does not change any fraction.
- A decline exists only on a due day, from the day kept from onwards, never on a day that has not
  arrived, and never on a weekly quota's day (`Decline.swift`, record spec). So a week line never
  holds one, including in a mixed chain.
- `decline-a-due-day` (#400) deferred the count here in its `proposal.md`, `design.md` Non-Goals and
  `grill.md`; ADR-1068 says a look-back counts a declined day as unkept "until a later Story counts
  it apart".

## Settled

1. **Every kind of look-back counts declines**: tick, number, total and note. *A declined day on a
   number, total or note commitment otherwise leaves no trace on its page at all: no point and no
   note.*
2. **On a tick look-back the count is said on each month line and for the whole page.** *"Which
   month did I decline a lot" is what the per-month count answers; the page count is their sum.*
3. **Count only, no reasons.** The look-back does not list declined days or their reasons; that list
   is captured as a want in `docs/backlog.md`. *The Story's intent is "how many", and the reason list
   is worth deciding on its own.*
4. **Nothing is said at zero.** A month with no declined day reads exactly as it does today, and
   neither does the page. *Most months will have none; a zero on every line is noise.*
5. **The page count is a "Declined" row of its own in the head card**, the same on every kind,
   e.g. `DECLINED   3`, present only above zero, and the card's last row: under "The whole" on a
   tick page, under "Kept from" (or "Kept until") on a number, total or note page. A tick's whole
   fraction reads as it does today. *One place on every page; on a tick it reads as the breakdown of
   the fraction above it. The row's place was settled in the layout round.*
6. **Graphs are not marked.** A number or total graph draws exactly what it draws today; only the
   head card says how many days were declined. *Marking the chart is a change in its own right.*
7. **The page count covers everything since the day kept from**, through the last day the look-back
   counts, the same reach as a tick's whole. It does not follow a graph's span picker. *One number
   that holds still, in the head card whose "Kept from" row names its range.*
8. **A month line says its count as "1 declined", "3 declined"**: number, then the word, which
   never takes a plural. *It matches the note count's "38 notes" pattern; where it sits on the line is
   the layout round's question.*
9. **The walk is three screens, with no `phone:` line.** (1) A tick look-back with declines in two
   months and none in a third: the month counts, the silent month, and the "Declined" row. (2) A
   number look-back with its "Declined" row over an unchanged graph. (3) A look-back with no declined
   day, showing no row and nothing changed. *Nothing here needs a gesture.*

## Terms landed in CONTEXT.md

None new. **Declined** is amended to say that a look-back now counts declined days apart, while its
fractions still count them owed and unkept.

## Left open

None. Every question the frontier raised was answered, the layout round included.

## Layout

Option A, the count as a caption under the month, chosen from three at
https://claude.ai/artifact/6zREdFBmhXsTChsytPzyXP. *The day screen already puts extra information
under a row's name as a small grey caption (a decline's reason, a total's "so far"), and a month
with no declined day keeps its single line exactly as today.* The "Declined" row is last in the
head card. The wireframe follows, verbatim from the designer; its figures are examples.

```
A · Under the month                          (recommended)
‹
Run                                         .largeTitle, nav bar
Mon, Wed, Sat                               .subheadline, secondary
┌──────────────────────────────────────┐
│ KEPT FROM             5 January 2026 │    head card; KEPT UNTIL under
│ ──────────────────────────────────── │    KEPT FROM where stopped
│ THE WHOLE                    105/122 │
│ ──────────────────────────────────── │
│ DECLINED                           6 │    only above zero; last row
└──────────────────────────────────────┘
  Months                                    .headline
  October 2026                     4/6      fraction on the month's
  1 declined                                first baseline; count is
  ────────────────────────────────────      .caption, secondary, under
  September 2026                  9/13      the name
  3 declined
  ────────────────────────────────────
  August 2026                    13/14      no decline: one line, as today
  ────────────────────────────────────
  July 2026                      10/13
  2 declined
  ────────────────────────────────────
  ... one line per month, newest first; a week line never holds a count

Number, total, note page: the same head card with no THE WHOLE row,
so DECLINED sits under KEPT FROM (or KEPT UNTIL). The graph, picker,
average card and notes are unchanged.
```
