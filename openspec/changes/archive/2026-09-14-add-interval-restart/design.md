## Context

See `proposal.md` § *Why* and `grill.md`, whose five settled answers this delta is written on.
These facts, read off this worktree, decide the shape.

- **A rhythm change already supersedes** in `CommitmentsScreen.change`: the old commitment is kept
  until the day before the day the screen was handed, and the new one is kept from that day. A
  restart is the same act, except that the day is picked and the rhythm is the one already there.
- **`History.carryOver` moves every record of a commitment or none.** No member moves only the
  records on or after a day.
- **A tick is made only on a due day.** So with one interval, a record day on both the old grid and
  the new one makes the restart day a landing of the old grid, and that is refused as already due.
  Records are carried only where the restart day is before the start date on the old grid's backward
  count. The carry-over scenario is fixtured that way, and so no scenario can carry records and also
  keep some behind.
- **`dayToKeepFrom` is already the day the screen was handed**, and the change sheet already opens
  its kept-from field on it.
- **`RefusedChange` has seven cases.** A restart is the eighth kind of refused change.

## Goals / Non-Goals

**Goals:**

- Restart at the existing seam, `CommitmentsScreen`, with every rule observable there.

**Non-Goals:**

- **No combined save** (`grill.md` item 3), and no change to what `change` does.
- **No whole save across the two places** (#249, `save-change-whole`).
- **No reading of the two grids as one run** (B-007), and no change to `record`'s requirements.

## Decisions

### The seam

`CommitmentsScreen` is the seam, and every scenario is driven through `restart` or `whatItIsMadeOf`.
`dayToKeepFrom` is read unchanged as the day offered to restart from. The last two lines are
package-internal, not seams, and are listed so the diff is expected.

- `public func restart(_ commitment: Commitment, from day: CalendarDate) -> Refusal?` — on `CommitmentsScreen`
- `public let canRestart: Bool` — on `CommitmentsScreen.Change`
- `case restarting(Commitment, Refusal)` — on `CommitmentsScreen.RefusedChange`
- `case restartDayIsAfterToday`, `case restartDayIsBeforeKeptFrom`, `case alreadyDueOnRestartDay` — on `CommitmentsScreen.Refusal`
- `mutating func carryOver(_ commitment: Commitment, to changed: Commitment, onOrAfter day: CalendarDate) -> Bool` — internal, on `History`
- `func carryOver(_ commitment: Commitment, to changed: Commitment, onOrAfter day: CalendarDate) throws -> Bool` — internal, on `RecordStore`

### A restart is its own act, not a field on a change

`restart` takes a commitment and a day and nothing else, so a combined save has no way to be asked
for (`grill.md` item 3). Rejected: a restart day on `change`, which multiplies edges while #249
reworks that save.

### The restarted commitment is kept from the day it restarts from

Its schedule starts on the picked day, and it is kept from that day too, which is what a rhythm
change already does. `grill.md` item 5 reasons from it: after an earlier restart, the days before the
current kept-from day belong to the grid that was replaced. Rejected: keeping the original kept-from
day. The sheet would show a floor the grid does not start from, and the first kept-from correction
would rebuild the grid from that day and silently undo the restart.

### Carrying part of a history is package-internal

The dated carry-over is an internal member of `History` and `RecordStore`. Its rule is stated once,
in `commitment`, and tested through the screen, as #247 did with its internal `History` reads.
Rejected: an ADDED `record` requirement. That puts two capabilities in one Story for a member with
one caller.

### The order refusals are judged in

Cannot be restarted (nothing), after today, before kept from, already due, already held, a recorded
day left not due, records already kept, then the places. The three date checks need no store, so they
come first. The last four keep `change`'s order, including #247's not-due-first rule.
Rejected: one "not a day to restart from" case. The three need different words from the shell.

### The shell rides this Story

The change sheet gains a *Restart* section, drawn only where `canRestart` is true. It holds a date
picker bounded by the kept-from day and `dayToKeepFrom`, opening on `dayToKeepFrom`, and a button
that calls `restart`. `refusalText` gains the three new cases. Every rule is still the kit's refusal,
so the bounds are only a convenience. It meets ADR-1019's three conditions, so it takes a `tasks.md`
section of its own.

### No ADR

Every rule here is a spec sentence, and none reverses a recorded decision. The 2026-08-31 fixed
start date still stands: a restart forms a new commitment and moves no start date.

### Migration

None. No persisted type or encoding changes, and records on a phone read as before.

## Risks / Trade-offs

- **The implementer uses the whole-history `carryOver`.** → The first scenario's byte-for-byte
  record place fails, because the 10 August tick would move.
- **The implementer keeps the original kept-from day.** → The first and third scenarios' roster
  answers fail.
- **A kept-from correction moved earlier on a restarted commitment overlaps the superseded one**, and
  can draw two rows on those days. That is already true after any rhythm change, and this Story does
  not widen it.
- **A kill between the record write and the roster write** orphans carried records until #249 lands.

## Open Questions

None. `grill.md` § *Left open* is "None.". Writing the delta turned up two edges. One is the day a
restarted commitment is kept from, decided above on `grill.md` item 5's own reasoning. The other is
how far a carry-over can reach, which is a fact about ticks, recorded in Context. Neither needed the
owner, and no `## Questions for you` round is outstanding.
