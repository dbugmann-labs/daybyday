# 1037. A roster's order is the person's

- Status: accepted
- Date: 2026-09-07
- Deciders: Diego Bugmann

## Context

Until now a roster has answered its commitments in the order they were taken on, and every
requirement said so in those words: `commitment/spec.md`'s hold-order requirement, its
answer-on-a-date requirement, and the commitments-screen requirement listing what it keeps. That
order was never a decision — it fell out of `entries` being an array a person could only ever
append to. B-030's want — *"reorder the commitments list to match how a person actually thinks
about their day"* — asks for something the roster has never offered: a place a person puts a
commitment, on purpose, that stays put.

Two shapes were on the table once the want was real. Either the roster gains a verb — `move`,
taking a commitment and a place to put it, reordering `entries` in memory exactly as `add` already
does — or the arrangement lives one layer up, on the commitments screen, as a second sequence held
beside the roster's own. The second shape reads as the safer one at first: it changes nothing about
what a roster *is*, and it keeps the roster's existing order — taken-on order — as a fact history
still gets to keep.

It does not survive contact with what already reads that order. `day-screen/spec.md` already
requires *"A day view is in the order it was handed its commitments"* and forbids the day screen
reordering what the roster answers with — `DayScreen.swift` calls `roster.commitments(on:)` and
draws exactly that. A screen-held arrangement would need the day screen to read it and apply it too,
which is a second thing to keep in step and a place the two could disagree — a day view drawn in one
order while the commitments screen shows another, both reading the same person's roster. A roster
that carries its own order costs the day screen nothing at all: it already draws what it is handed,
in the order it is handed it, so the new order reaches every reader that already exists without one
of them changing a line.

## Decision

**A roster's order is the person's, and the roster is where it lives.**

- **`Roster.move(_:toOffset:)`** is the whole of it: a commitment and an insertion point, counted
  over the commitments the roster is keeping *before* the move — the same arithmetic
  `Array.move(fromOffsets:toOffset:)` and SwiftUI's `onMove(perform:)` already use, measured rather
  than assumed. `RosterStore` and `CommitmentsScreen` each gain the same call, in the same shape as
  `retire` and `remove` already have, and the shell's `.onMove` passes the gesture's own `Int`
  through unconverted.
- **The order runs over everything a roster holds — kept, stopped and removed alike** — because a
  roster already holds all three in one sequence, and a second, kept-only order would mean the
  roster holding two orders for one list. A stopped or removed commitment keeps the slot it has, and
  taking one up again returns it there.
- **Only the moved commitment moves.** A stopped or removed commitment lying between where a
  commitment starts and where it is dropped is passed, not pushed: it keeps its position relative to
  every other commitment that did not move.
- **Taken-on order survives as the starting value, not as a fact anything can get back to.** A
  roster that has never been moved answers exactly as it always has; a roster written before this
  change reads back with that order as the one it starts from. There is no way to ask a roster what
  order it would have been in before a move — the roster does not carry that.

## Consequences

- **A stopped commitment taken up again lands where the sequence now puts it, not beside the
  neighbour it used to have.** Nothing about the roster records who anything used to sit next to,
  and giving it one would be an order per state under another name. Settled at the grill as the
  known price of one order over three states.
- **The day screen inherits the new order for nothing** — the load-bearing claim of this decision,
  and `add-roster-order`'s `day-screen` delta turns it into a fact with one scenario rather than
  leaving it as a claim: *a day screen draws its rows in the order its roster was moved into*, which
  passes without a line changing in `DayScreen.swift` or `DayView.swift`.
- **The file gains no field and no form.** Order was always carried by array position alone, so a
  move rewrites the same fields in a different sequence at the same form; `ADR-1031` is not amended.
- **A drag is discoverable only behind `EditButton`,** which is the platform's own gesture and the
  price of not inventing a UI of the app's own for it. If it reads badly in the owner's own hand,
  that is a want for `docs/backlog.md`, not a reason to revisit this decision.

## Alternatives considered

**An arrangement held on the commitments screen**, separate from the roster's own append-only
order. Rejected on the mechanism above: the day screen already draws the roster's answer verbatim
and would need to learn to read and apply a second order, which is a thing to keep in sync and a
place the two could disagree — for no saving, since the roster gains nothing by staying append-only
that a person asked for.

**A final position rather than an insertion point** — "put it at index 2 afterwards." Rejected at
the seam, in `add-roster-order`'s `design.md`: it differs from an insertion point by one whenever a
commitment moves down the list, so whichever layer accepts it would carry a
`destination > sourceIndex ? destination - 1 : destination` — a line that can be wrong in a way a
test would catch, which the shell is not allowed to hold under ADR-1019.
