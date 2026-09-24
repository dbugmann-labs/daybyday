## Context

See `proposal.md` § *Why*, and `grill.md`, whose seven settled answers this delta is written on.
The facts the shape turns on, read off this worktree and the grill's fact agents:

- **The Kit imports Foundation only.** The day's birthdays reach it as values the shell hands over,
  as a day view is handed its commitments; reading the calendar is a later Story's shell work.
- **What the calendar hands, measured on the simulator:** an occurrence on the Birthdays calendar is
  all-day and yearly, titled with the age, and carries the contact's identifier; a contact with no
  birth year is unmeasured. That identifier is documented as unique on the current device only.
- **`OneOff` + `OneOffs` + `OneOffStore` is the shape a value kept in a store of its own already
  has**: a value with a failable initializer, a value holding several, and a class keeping that
  value at a place, whose five moves — version first, later form refused, decode through the
  value's own rules, whole document written `.atomic`, held value replaced only after — follow
  ADR-1031. `OneOffStore.formed(from:)` is the per-store reading a copy shares.
- **`Blank.saysNothing(_:)` is the package's one whitespace test** (ADR-1039); `CalendarDate` is
  `Hashable` and not `Comparable`.

## Goals / Non-Goals

**Goals:** everything but persistence drivable as a value test, with no calendar and no clock; one
key for a tick, so a rename keeps it and a deletion hides it without losing it; a store that is its
own file and holds nothing but ticks.

**Non-Goals:** no screen and no place — the day screen names the birthday place and draws the group
(#328); no switch and no permission (#327), so nothing here knows whether birthdays are on; no copy
and no restore (#329); no EventKit adapter; and no today, so whether a row offers a tick on a day not
yet arrived is #328's, as it is `DayView.Row.tick(asOf:)`'s for a commitment.

## Decisions

### The seam

Three new exported types and one error, mirroring the one-off's.

```swift
public struct Birthday: Hashable, Sendable {
    public let contact: String
    public let words: String
    public let day: CalendarDate
    public init?(contact: String, words: String, day: CalendarDate)
    public static func falling(on day: CalendarDate, among handed: [Birthday]) -> [Birthday]
}
public struct BirthdayTicks: Hashable, Sendable {
    public init()
    public func isTicked(_ birthday: Birthday) -> Bool
    public mutating func tick(_ birthday: Birthday) -> Bool
    public mutating func takeBack(_ birthday: Birthday) -> Bool
}
public final class BirthdayStore {
    public init(at place: URL) throws
    public private(set) var ticks: BirthdayTicks
    @discardableResult public func tick(_ birthday: Birthday) throws -> Bool
    @discardableResult public func takeBack(_ birthday: Birthday) throws -> Bool
}
public enum BirthdayStoreError: Error, Equatable, Sendable
```

### A birthday's equality is all of it; a tick's key is its contact and its day

`Birthday` is equal over all three fields, so a birthday handed under new words is a different
value from the one handed under the old. `BirthdayTicks` holds an internal key of contact and day, which is the
whole of decision 4 and ADR-1062.
- *Rejected:* equality over contact and day alone, ADR-1059's identity shape — a renamed birthday
  would compare equal to its old self, and anything diffing by equality would see no change.
- *Rejected:* the words in the key — a renamed contact would lose its tick, against the owner's G1
  call.

### The day is the occurrence as handed, and the Kit computes no birthday

No birth date, no age and no leap-year rule live here: a birthday falls on whatever day the calendar
put that year's occurrence on, and a tick is against that day. `falling(on:among:)` is a filter and
nothing more, so the shell may hand any span — three days, for the adjacent day views — and each
date's answer stays exact and in the calendar's order (decision 2).

### A blank contact is refused; blank words are kept

The contact is the app's key, so one that says nothing is refused through `Blank.saysNothing(_:)`:
every such birthday would share one tick. The words are the calendar's, and decision 3 says nothing
is composed, so even empty words are kept. **A judgement, not a settled answer** — the grill did not
reach it, and it is the cheapest thing here to overrule: one AND in one scenario.

### The form on disk, version 1

```json
{ "version": 1, "ticks": [ { "contact": "kate", "day": { "year": 2026, "month": 9, "day": 25 } } ] }
```

Hand-written in the capability's words and decoded through the same rules, so a blank contact, a
day that names no day and two ticks alike are refused off the disk. Ticks are a set, so they are
written in an order of the store's own — by contact, then by day — for a byte-stable file. No words
and no switch are ever written (decision 1).

### Migration

None — additive: a new store at version 1, no phone holds one, and no existing document, type or
encoding is touched.

### ADR-1062

The next free number on `origin/main`. Records the key and what it costs when a copy reaches a new
phone, where an identifier may match nothing; decision 5, a tick kept unseen, is its consequence.

## Risks / Trade-offs

- **The likeliest wrong implementation keys ticks on `Birthday` itself**, so the words join the key.
  → Two scenarios ask about a tick under changed words, one of them through a reopened store.
- **The second likeliest writes the words to disk** to make the file readable. → The store scenario
  asserts the file holds none of them.
- **A tick nobody sees is kept for ever** once its contact is gone. → Decision 5, accepted: a handful
  of bytes a year, and nothing here deletes a record but a deliberate act.
- **Story #324 may also take ADR-1062** while both are open. → Check `docs/adr/` on `origin/main`
  at each rebase; the second to merge renumbers before its G7.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and writing the delta raised nothing that
needed the owner: the edges it turned up — blank words, a birthday handed twice, a tick asked under
new words, a day not yet arrived — were answered from the settled answers, the shipped code and
#328's intent. The one judgement taken is named where it is made. No residual round is outstanding.
