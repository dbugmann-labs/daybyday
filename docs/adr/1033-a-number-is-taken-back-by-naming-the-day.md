# 1033. A number is taken back by naming the commitment and the day

- Status: accepted
- Date: 2026-09-06
- Deciders: Diego Bugmann

## Context

`add-number-record` (#138) gives a number commitment's day a record, and every record in this product
can be **taken back** — `CONTEXT.md` § *Record* says so, because a tap that cannot be undone is a
permanent false record. The tick already has its shape:

```swift
public mutating func remove(_ tick: Tick)
```

A caller hands back the same value it added. That works for a tick because a tick is *nothing but* a
commitment and a calendar date: whoever wants to take one back already knows both, so re-forming the
tick costs nothing and the history's own storage — a `Set<Tick>` — takes exactly that.

A number has a third part. Copying the tick's shape would give
`removeNumber(_ number: Number)`, and a caller would have to build a `Number` carrying the value it
wants gone. That is the whole of the question this record answers, and it was put to the owner at the
Story grill on 2026-09-06 because it decides a public signature that #140's note and #141's total
will each copy or contradict.

## Decision

**A number is taken back by naming its commitment and its date, and never by naming the number.**

```swift
public mutating func removeNumber(for commitment: Commitment, on date: CalendarDate)
```

- A day holds **at most one number per commitment**, so the commitment and the date name the record
  exactly. There is nothing the third part could disambiguate.
- **A person who mistyped a number must be able to clear it without reading it back first.** Someone
  who meant 70.5 and entered 300 wants the day empty; requiring them to hand back 300 makes undoing a
  mistake depend on knowing what the mistake was. A screen would have to read the number, hold it,
  and hand it back — three steps where the day is already in front of them.
- **Taking back where nothing is there is nothing, not an error**, exactly as *Untick* already says.
  That covers a day nothing was entered on, a commitment whose kind is not a number, and a date the
  commitment is not due on.
- The name is `removeNumber`, not an overload of `remove`. An overload set where one member takes a
  value and another takes two coordinates reads as an oversight rather than a decision.

**The tick keeps its own shape.** It is not changed to match, and that asymmetry is the point rather
than a wart: a tick has no third part, so `remove(_ tick:)` already names a day and nothing is gained
by rewriting a signature that eleven scenarios and every existing test are written against.

## Alternatives considered

**`removeNumber(_ number: Number)` — symmetry with the tick.** Rejected on the mistyped-number
argument above. Symmetry of signature is worth less than a caller that can clear a day it can see,
and the symmetry is false anyway: the two types do not have the same number of parts.

**One `remove(_ record: Record)` over a shared record type, taking the whole record for every
kind.** Rejected as premature by the same reasoning that keeps this Story's reader number-shaped: two
of the four kinds do not exist, and a total's take-back is *removing its last addition* rather than
removing the record at all, so the general signature is not yet knowable. Fixing it now would fix it
around a record nobody has grilled.

**`History.clear(for:on:)`, taking back whatever the day holds of any kind.** Rejected: it would take
back a tick and a number through one call, and a commitment has one kind, so the call could only ever
reach one of them. It reads as more general than it is.

## Consequences

- **`History` carries two take-back shapes**, `remove(_ tick:)` and
  `removeNumber(for:on:)`, and will carry a third and a fourth as #140 and #141 land. That is the
  cost, and it is visible in one file.
- **#140 and #141 are expected to copy this shape**, not the tick's: a note is taken back by naming
  the day, and a total loses its last addition — which is `for:on:` again, with a different verb.
  When all four exist, the general shape they share is worth naming, and the tick will be the one
  that has to be brought into line.
- **A screen never has to read a record in order to remove it.** That is what #139's row needs, and
  it is what makes "take it back" one tap on a day rather than a read followed by a write.
- **The reversal trigger is the fourth kind.** When a note and a total are both recordable, a single
  take-back over a shared record type may be worth having, and the tick would move with it. Amend
  this record in place when that day comes (ADR-1020); do not add a fifth signature quietly.
