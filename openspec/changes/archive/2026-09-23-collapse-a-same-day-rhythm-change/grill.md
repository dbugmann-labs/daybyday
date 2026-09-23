# Grill — collapse-a-same-day-rhythm-change

*10 questions over 4 rounds, 2026-09-23, one fact agent (probes a–u, run in a scratch copy from
`git archive HEAD` at c443520; nothing in the repo touched). The Feature grill of 2026-09-21 settled
the premise — "a rhythm changed twice on one day leaves one era, because an era nobody kept a day on
is not one" (`docs/backlog.md` § Decided, B-058) — and it is not re-asked here.*

## What the facts showed before the first question that needed them

A second change on one day is never refused today: `Roster.put(era:on:keptUntil:under:)` stacks an
era kept from D until D−1 each time. A third change on the day (A→B→A→B), or a change back on the
day the commitment was defined (A→B→A, all on D), writes a roster `RosterDocument.formRoster()`
refuses on the next read as "the same era held twice" — the commitments screen lists nothing and
offers *Take out the files*, and every copy after it stops. The write path never checks the shape.
The same holds for a range or target changed back and forth, which run the same path. A restart
already reaches behind any era back to the commitment's kept-from day and leaves the old era
overlapping the new one; the CONTEXT.md 2026-09-14 bound is enforced nowhere since #303. A restored
copy is read through the same `formRoster()`/`folded()` as the store.

## Settled

1. **Scope: every era that ends up holding no day collapses**, whatever began it — rhythm, range,
   target or restart. *"An era nobody kept a day on is not one" holds whatever started it, and a
   range changed twice on one day has the same defect.*
2. **A change straight back (A→B→A on one day) leaves A unbroken**, kept from its original day, the
   roster exactly as it was before the first change. *Two identical eras side by side are a seam
   nobody can see.* The same holds for a commitment defined on D and changed on D: the change edits
   the one era in place and it stays kept from D.
3. **A record made that morning still refuses the change back.** Tue/Thu changed on Monday to Mon,
   Monday ticked, then changed back to Tue/Thu: refused, "Choose a day that leaves every recorded day
   due." *A same-day change is not special; the day was kept, and untick-then-change is the way out.*
4. **Rosters already on a phone are mended on read**: an era holding no day is dropped silently, and
   the eras either side of it join where they are alike. That makes a roster locked out by the
   duplicate shape readable again. *An empty era is invisible, so nothing a person can see is lost.*
   Because restore reads through the same reader, a restored copy is mended too.
5. **Mending rejoins alike neighbours** — A until Tuesday and A from Wednesday, left by an A→B→A made
   before this ships, become one A era. *One roster shape means one thing, whichever way it arose.*
6. **Mending cuts overlaps**: where two eras hold the same days, the older ends the day before the
   newer begins. *The roster then holds what every reader already shows (newest first).*
7. **A commitment kept from a future day and changed before it starts keeps its kept-from day.**
   Kept from Friday, rhythm changed Tuesday: the change edits the not-yet-started era, and it still
   starts Friday. *Changing the rhythm is not asking to start sooner.*
8. **A restart replaces every era that began after the picked day, and the era holding the picked
   day ends the day before it**, as far back as the day the commitment is kept from — behind a
   same-day change, a change made days ago, or an earlier restart alike. A record on any day the
   restarted count leaves not due still refuses it. *The owner chose "restart replaces the change"
   against the recommendation to refuse a restart behind the newest era, and then the one-rule
   reach over "only today's change". This reverses CONTEXT.md's 2026-09-14 Restarting amendment,
   which is amended in place; `spec-author` owns whether the ADR that holds the restart bound needs
   the same amendment.*
9. **A stop on the day of a change is #306's**, not this Story's. Changed to B on Wednesday and
   stopped Wednesday leaves B holding no day today, and it stays that way until #306's grill decides
   whether a stop is an era boundary. *Collapsing it here decides half of #306 early, and the empty
   era is harmless meanwhile — invisible and readable.* Mending on read must therefore not be what
   removes it either, or #306 is decided by the back door; that boundary is for the delta to draw.
10. **No walk and no layout round.** Nothing settled here changes what the shell draws: the restart
    picker keeps its bound (the earliest era's kept-from day), no refusal is added or reworded, and
    mending happens inside the reader. *The Story stays behind the seams
    `CommitmentsScreen.change(...)` and `restart(_:from:)` and the store's reader.* If the delta
    turns out to reach `src/DayByDay/` after all, that is a residual-round question.

## Terms landed in CONTEXT.md

- **Collapse** — what becomes of an era that would hold no day: not kept; alike neighbours rejoin; a
  roster already holding one, or two eras on the same days, is mended silently on read.
- **Restarting**, amended 2026-09-23 — a restart may reach behind any later era back to the
  kept-from day, replacing every era begun after the picked day.

## Found while grilling, for spec-author

- CONTEXT.md § *Superseding* still says "a record made that morning under the old rhythm is not
  drawn that day, though it stands". Since #303 that change is refused instead (probes f, g). Settled
  3 relies on the refusal; the sentence is stale.
- CONTEXT.md carries a second, older **Era** entry near the look-back terms (agreed 2026-09-15 at
  #272, amended 2026-09-16) describing eras by superseding and a resemblance chain with no link —
  superseded by #303's identity but not marked so.
- `CommitmentsScreen.swift:1051-1055`'s comment says `formRoster` guards "one identity kept from one
  day twice"; it guards the whole era shape.

## Left open

None. Every question the frontier raised was answered; the stop-day empty era is not open but
assigned to #306 by Settled 9.
