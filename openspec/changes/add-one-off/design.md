## Context

See `proposal.md` § *Why*, and `grill.md`, whose five settled answers this delta is written on. The
product rule is settled and nothing below re-argues it: a one-off is a name and a date, it stands on
one day at a time and follows today until it is done, and it is removed outright. Four facts, read
off this worktree, decide the shape.

- **`Commitment` + `Roster` + `RosterStore` is the shape a capability of this kind already has**: a
  value with a failable initializer, a value holding several and answering about them, and a class
  keeping that value at a place. `History` + `RecordStore` is the same shape with one value.
- **`Blank.saysNothing(_:)` is the package's one whitespace test** (ADR-1039), and `Commitment.init?`
  refuses a name through it, untrimmed.
- **`CalendarDate` is not `Comparable` and `days(until:)` is `internal`** — the package's only
  spelling of a comparison. `CommitmentCoding.swift` holds an `internal DateRecord` of three integers.
- **Both stores are the same five moves**: read the version alone, refuse a later form, decode
  through the engine's failable initializers, write the whole document with `.atomic`, replace the
  held value only after that returns. ADR-1031 governs the version and its per-field constants.
  `DayScreen` opens `record.json` and `roster.json`; no screen is touched here, so nothing opens a
  third place yet.

## Goals / Non-Goals

**Goals:** one rule for the day a one-off stands on, answered from what is held plus a today, so no
past day's answer moves and no clock is read; a store that is its own file, so `record.json` goes on
holding only what a commitment's days take; and everything but persistence drivable as a value test.

**Non-Goals:** no screen — drawing the group is #243's, making and renaming from a row is #244's; no
rename and no re-dating, a one-off being never re-dated (`CONTEXT.md`); and no reader that lists
one-offs, so no order is decided here — #243 decides what a day draws and adds the reader for it.

## Decisions

### The seam

Three new exported types and one error, mirroring `Commitment` / `Roster` / `RosterStore`.

```swift
public struct OneOff: Hashable, Sendable {
    public let name: String
    public let date: CalendarDate
    public init?(name: String, date: CalendarDate)
}

public struct OneOffs: Hashable, Sendable {
    public init()
    public mutating func add(_ oneOff: OneOff) -> Bool
    public mutating func add(_ oneOff: OneOff, doneOn day: CalendarDate) -> Bool
    public mutating func tick(_ oneOff: OneOff, on day: CalendarDate) -> Bool
    public mutating func takeBack(_ oneOff: OneOff) -> Bool
    public mutating func remove(_ oneOff: OneOff) -> Bool
    public func standingDay(for oneOff: OneOff, asOf today: CalendarDate) -> CalendarDate?
}

public final class OneOffStore {
    public init(at place: URL) throws
    public private(set) var oneOffs: OneOffs
    @discardableResult public func add(_ oneOff: OneOff) throws -> Bool
    @discardableResult public func add(_ oneOff: OneOff, doneOn day: CalendarDate) throws -> Bool
    @discardableResult public func tick(_ oneOff: OneOff, on day: CalendarDate) throws -> Bool
    @discardableResult public func takeBack(_ oneOff: OneOff) throws -> Bool
    @discardableResult public func remove(_ oneOff: OneOff) throws -> Bool
}

public enum OneOffStoreError: Error, Equatable, Sendable {
    case notAStore(at: URL)
    case laterForm(at: URL, version: Int)
    case cannotWrite(at: URL)
}
```

`OneOffDocument` is `internal`, as `RosterDocument` is. Twenty scenarios are driven at `OneOff`
and `OneOffs`, the nine store scenarios at `OneOffStore` with a fresh URL under `temporaryDirectory`
per test. A store move refuses without writing exactly where `OneOffs` does, as `RosterStore.add`.

### Done is held against the one-off, never on it

A one-off is the same one-off ticked or not (`grill.md` § *Settled* 1), so the day it was done is a
field of the entry `OneOffs` holds, not a third part of the value: on `OneOff` it would mean either
equality ignoring a stored field — a bug factory — or two values for one thing. ADR-1038 argued this
about a category and reached the same answer.

### The standing day is the later of the date and today, or the day it was ticked

Not done: `max(date, today)`, the whole of *follows today until it is done* in one expression — no
special case for a today that is its date, and no clock, the today being the caller's argument.
Done: the stored day, which never moves again. Not held: `nil`, which gives removal an observation
and stops a caller being told a day for a one-off nobody holds. ADR-1052 records the rule itself: it
was the owner's call at the Feature grill, against the recommendation, and it decides what a person
sees on the day they missed something. `1052` is free — `1051` is the highest on `main`, and
`add-quota-standing` (#235) claims `1050`.

### A day done is never before the day owed

Ticking on a day before the one-off's date is refused, and so is adding already done on such a day.
A record of doing something before it was owed cannot be true, and it would put the standing day
*before* the date, which no reader expects. It mirrors `Tick`, which cannot be formed for a
commitment on a date it is not due on, and agrees with #243's settled row, which offers a tick only
where the day has arrived. A day after the date is taken: that is the late one-off the rule exists
for. **This is a judgement, not a settled answer** — the grill did not reach it — and the cheapest
thing here to overrule: one clause of the tick requirement and two scenarios.

### The form on disk, version 1

```json
{ "version": 1, "oneOffs": [ { "name": "Call mum",
  "date": { "year": 2026, "month": 9, "day": 25 },
  "doneOn": { "year": 2026, "month": 9, "day": 28 } } ] }
```

Hand-written in the capability's own words, decoded through `OneOff.init?` and the same held-by
rules, so everything the spec refuses is refused again off the disk. `doneOn` is absent where a
one-off is not done: it is optional **by meaning**, so there is no `doneOnIntroducedInVersion`
constant and its presence is never judged against the version — ADR-1031's constants begin at the
first field a later form adds. Entries keep the order they are held in; nothing sorts them, because
that order is what #243 will draw from.

### Migration

None — new store, version 1, no phone holds a one-off store, and no existing document, type or
encoding is touched, so nothing already kept reads back differently.

### Names: `OneOffs`, and `standingDay` rather than `standing`

`Roster` and `History` are words the product says; one-offs have no collective noun in `CONTEXT.md`,
so `OneOffs` is a type name and no term is invented. `standingDay(for:asOf:)` keeps its distance from
the `History.standing(for:through:)` #235 adds for a count of kept days, and says it answers a day.

## Risks / Trade-offs

- **The likeliest wrong implementation is a standing day that ignores today** and always answers the
  one-off's date. → Two scenarios ask about a date already passed, and `tasks.md` names the trap.
- **The second likeliest is a done one-off that goes on following today.** → The done scenarios ask
  as of a today well past both the date and the tick.
- **`OneOffs` equality carries most store scenarios**, so a wrong `Hashable` would let them agree
  wrongly. → Every store scenario also asserts a standing day, which comes off the entry rather than
  off equality.
- **Three exported types for one Story is a wide seam** where fewer is the rule. → It is the shape
  both shipped capabilities have, and the alternative — a store that is also the collection — puts a
  temporary file under all twenty-nine scenarios.

## Open Questions

**None outstanding, and none deferred.** `grill.md` § *Left open* is "None.", with its reason, and
writing the delta raised nothing that needed the owner: the edges it turned up — a tick on a day
before the date, what a one-off not held stands on, whether `doneOn` gets a form constant — were
answered from the shipped code, `CONTEXT.md` and #243's settled intent, which is this agent's job
rather than his. **There is no `## Questions for you` section and no residual round is outstanding.**
The one judgement taken rather than sent back is named where it is made: § *A day done is never
before the day owed*.
