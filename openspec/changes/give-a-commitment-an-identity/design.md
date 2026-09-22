## Context

A commitment is its four parts today: `Commitment` is a `Hashable` value, `Roster.Entry` holds one,
`RecordedDay(commitment:date:)` keys every record by the whole value, and `LookBack` rebuilds a
chain by walking removed entries that resemble the one in front. A rename therefore makes a second
commitment and moves every record onto it; a rhythm, range or target change supersedes, leaving a
removed entry beside a kept one. `RosterDocument` is at form 4 and `RecordDocument` at form 5;
`CopyDocument` is at form 1 and carries the other three by reference, so it does not move.

This delta reaches three capabilities and no others. `day-screen` needs no requirement change: a
past day is still drawn from the era the roster answers that date with, and that era carries its own
rhythm and its own range. `restore` needs none either: a copy is whatever the three places hold.

## Goals / Non-Goals

- **Goals.** One commitment through a rename, a rhythm change and a kept-from move. One *Kept from*.
  Records that follow the commitment rather than its value. A roster on the phone folded once.
- **Non-Goals.** Delete and the retirement of the removed state (#304). A same-day rhythm change
  collapsing to one era (#305). Stop and resume as era boundaries (#306). Remove, stop and resume
  ship here exactly as they are; a commitment removed after this lands is unreachable until #304,
  which the grill accepted as the gap it is.

## Decisions

### The seam

```swift
public struct Commitment.Identity: Hashable, Sendable
public var Commitment.identity: Commitment.Identity { get }
public init?(name: String, schedule: Schedule, keptFrom: CalendarDate, kind: Kind = .tick)
public init?(era of: Commitment, schedule: Schedule, keptFrom: CalendarDate, kind: Kind)
public func Roster.eras(of commitment: Commitment) -> [Commitment]
public func Roster.keptFrom(of commitment: Commitment) -> CalendarDate?
public var Roster.stopped: [Commitment] { get }
public mutating func Roster.rename(_ commitment: Commitment, to name: String) -> Bool
public mutating func Roster.put(era: Commitment, on commitment: Commitment, keptUntil: CalendarDate, under category: String?) -> Bool
public mutating func Roster.change(_ era: Commitment, to changed: Commitment, under category: String?) -> Bool
struct RosterDocument.Fold { let roster: Roster; let identities: [CommitmentRecord: Commitment.Identity?] }
func RosterDocument.folded() -> Fold?
public var RosterStore.fold: [CommitmentRecord: Commitment.Identity?] { get }
public func RecordStore.settle(_ fold: [CommitmentRecord: Commitment.Identity?]) throws -> Bool
mutating func History.settle(_ fold: [CommitmentRecord: Commitment.Identity?]) -> Bool
public mutating func RosterStore.rename(_ commitment: Commitment, to name: String) throws -> Bool
public mutating func RosterStore.put(era: Commitment, on: Commitment, keptUntil: CalendarDate, under: String?) throws -> Bool
public enum CommitmentsScreen.Refusal { case nameAlreadyInUse(String) }
public var CommitmentsScreen.stoppedRefusal: SheetRefusal? { get }
```

`Roster.supersede(_:with:keptUntil:under:)`, `Roster.change(_:to:under:)`'s old meaning,
`RecordStore.carryOver(_:to:)` as a change's act, `Refusal.alreadyKept` and
`Refusal.recordsAlreadyKept` go. `History.carryOver(_:to:)` stays: the carry-back of an orphan is
its one remaining caller.

### Equality is the identity, and an era is an entry

`Commitment: Hashable` compares identities alone. Every lookup already written against a commitment
— the roster's `firstIndex`, `RecordedDay`, `Set<Tick>`, the day screen's rows — then keys on the
identity with no change of its own, which is why `record` and `day-screen` move so little. The
roster keeps holding one entry per era, in the order it already uses, the newest in front; what
makes an entry an earlier era is another entry of the same identity ahead of it, so no fourth field
is added and `Roster.commitments` and `Roster.commitments(on:)` stay exactly as they are.
`Roster.stopped` gains the one clause that keeps an earlier era off the stopped list.

The rejected alternative was a commitment owning its eras as a list. It moves the range and the
rhythm of a past day behind a lookup by date, which changes the day screen's rows, the number
entry's range and every test behind them — for a model the person never sees.

### The form on disk

`RosterDocument` goes to form 5 and `RecordDocument` to form 6, each with an `identity` key on the
commitment record, judged against its own `identityIntroducedInVersion` exactly as `removed` and
`category` are. An identity is a UUID written as its string; nothing derives it from the other
parts, because two commitments alike in every part must stay two.

### Migration

The fold is one act in two halves, because only one of them can be done alone. `RosterStore`, on
reading form 4, folds the roster and keeps the mapping from each stored commitment record to the
identity it was given, or to nothing where the entry was dropped. A screen, holding both places,
hands that mapping to `RecordStore`, which gives each record its identity, drops the records of a
dropped entry, and writes only if something moved. A record the mapping does not name is left
carrying no identity, which is precisely an orphan, and the shipped carry-back rule takes it from
there. Both places stay byte-for-byte untouched until something is written.

The three save-in-progress requirements stay untouched and are not dead: no change writes two places
any more, but a phone upgrading from this app's earlier forms may still hold a torn save written by
one, and reading the places must still undo it.

### What the shell draws

No layout round was held: `grill.md` § *Layout* records the designer's one line that the only shell
change is a caption in an idiom already shipped — the name-field refusal slot #261 gave the sheet,
and the stopped row's existing footer — so there was nothing to choose between, no mockup and no
wireframe to carry here. The one thing that section asks for: this is the first refusal caption
whose length is unbounded, because it carries a commitment name, so it wraps and is never truncated
(ADR-1022), and the seam hands the whole sentence over already said rather than the shell quoting a
name itself.

## Risks / Trade-offs

- **A wrong fold is unrecoverable on the phone.** It erases removed entries and their records, by
  the owner's decision, and the roster it wrote is what the next launch reads. The mitigation is
  that it is pure: `RosterDocument.folded()` takes a document and answers a roster and a mapping,
  so every case in the delta is driven without a file, and nothing is written until a change is.
- **A name refusal can strand a person behind a stopped commitment they cannot see the name of.**
  The refusal names it, which is why the caption carries the name rather than saying "already kept".
- **Four ADRs are reversed in place** — 1023, 1030, 1035 and 1055 — and a fifth is written for the
  identity. A reader of any of the four must reach the amendment, so each gets a dated line rather
  than a rewrite.
- **Nineteen requirements exceed the 150-word prose budget.** Fifteen are MODIFIED or replaced
  blocks carried verbatim from specs already over it, which the format requires. Of the four that
  are new prose, *A commitments screen changes a commitment by renaming it, moving the day it is
  kept from, or putting a new era on it* is the one that is far over, and it is one decision — which
  acts a change needs and in which order — so splitting it would state the ordering twice.
- **249 of this delta's 347 scenarios are carried verbatim**, and a handful of those carried inside
  MODIFIED blocks have edited bodies. `tasks.md` § 1.3 names all thirteen; a test touched that is not
  named there is the design being wrong rather than a test to fix.

## Open Questions

None. `grill.md` § *Left open* records none, and the two things it named as this document's rather
than open are settled above: the identity's form on disk and the stores' new forms under *The form
on disk*, and the in-place amendments to ADR-1023, 1030 and 1055 under *Risks*. The stale "nothing
reads a chain" sentence under `CONTEXT.md` § *Superseding*, and `docs/open-questions.md` line 200,
are corrected by boxes in `tasks.md` § 11.
