## Context

Removal is a third state on the roster's entry (`Roster.Entry.isRemoved`), written as `removed` on
every entry of `RosterDocument` form 5; `Roster.supersede` is its only other writer and nothing drives
it. Records key on a commitment's identity (`RecordDocument` form 6), so every record of a commitment
is findable from the roster by identity. `CopyDocument` (form 1) nests each store's own document, and
restore reads the nested roster through `RosterStore.formed(from:)`. `DayScreen` writes day one when
`store.roster == Roster()`. A deletion touches two places; ADR-1049 orders every such change record
place first, and the orphan carry-back moves any record whose identity the roster lacks onto a
look-alike commitment. See `proposal.md` for the why; ADR-1060 records the decision.

## Goals / Non-Goals

- **Goals.** One act that takes a commitment and its whole history off the phone, whole or nothing.
  An emptied roster that stays empty across a restart, an upgrade and a restore. No removed state
  left in memory, on disk after the next write, or in the spec.
- **Non-Goals.** Any undo, trash or grace period. Reaching copies made on request. Counting what is
  lost on the sheet (settled 6). Retiring the one-off's own removal, which is a different verb.

## Decisions

### The seam

```swift
public mutating func Roster.delete(_ commitment: Commitment) -> Bool
public func RosterStore.delete(_ commitment: Commitment) throws -> Bool
public private(set) var RosterStore.erased: Set<Commitment.Identity>
public func RecordStore.erase(_ identities: Set<Commitment.Identity>) throws -> Bool
public private(set) var CommitmentsScreen.awaitingDeletion: Commitment?
public func CommitmentsScreen.askToDelete(_ commitment: Commitment)
public func CommitmentsScreen.cancelDeleting()
@discardableResult public func CommitmentsScreen.confirmDeleting() -> Refusal?
public enum CommitmentsScreen.RefusedChange { case deleting(Commitment, Refusal) }
```

`nameTypedBack` and `nameTypedBackMatches` stay as they are, now read against `awaitingDeletion`.
Going: `Roster.remove`, `Roster.supersede`, `RosterStore.remove`, `RosterStore.supersede`,
`Roster.Entry.isRemoved`, `awaitingRemoval`, `askToRemove`, `cancelRemoving`, `confirmRemoving` and
`RefusedChange.removing`. The emptied mark is an internal stored property on `Roster`; nothing asks
for it but equality and the store, so it is not seam.

### Deletion writes the record place first and puts it back

`confirmDeleting` erases the commitment's identity at the record store (writing nothing where it
holds no record), then deletes at the roster store; a roster refusal writes back the record document
the screen read. Refusals are `.notKept`, as every place-could-not-be-written refusal is, and a screen
without a readable record refuses rather than deleting half. A kill between the writes leaves the
commitment listed with no records, which a second deletion finishes (ADR-1060).
- *Roster first:* rejected — records left under no identity are exactly what the carry-back moves.
- *A deletion-in-progress file carrying the erased records:* rejected — a third mechanism for a
  window the record-first order already makes harmless.

### Emptied is a mark on the roster, not the file's absence

`Roster` gains `emptied`, set by `delete` when the last entry goes and by a store read that erases
every entry, cleared by any `add`. Two rosters differ by it only while both hold nothing. `DayScreen`
is untouched: an emptied roster is not `Roster()`, so ADR-1027's letter stands and every requirement
reading "a roster holding nothing at all" stays true without being modified.
- *Day one only where no file exists:* rejected — it reverses those requirements and the scenario
  that writes an empty form-1 roster and expects day one.

### The form on disk

`RosterDocument` goes to form 6: entries no longer carry `removed`, and the document carries a
top-level `emptied` Boolean, true only with no entries. A `removalRetiredInVersion = 6` and an
`emptiedIntroducedInVersion = 6` join the shape check beside the existing introduced-at constants.
`RecordDocument` and `CopyDocument` do not move; a copy nests whatever roster form it was made with.

### Migration

Reading a roster at forms 3–5, `RosterStore` leaves out every era of each identity whose newest era is
held removed, and fills `erased` with those identities; a roster that held entries and ends with none
is emptied, the fold's output included. Both screens hand `erased` to `RecordStore.erase` right after
the fold's `settle` and before the orphan carry-back. If that write fails, the screens answer as they
do on a torn save they cannot undo. Nothing is written at the roster place until a change is kept.
Copies read through `formed(from:)` get the same erasure, and `CopyDocument` drops those identities'
records from the history it forms.

### Twenty-two headings change, and why

A scenario naming removal cannot be retitled or dropped under a kept heading, so each requirement
holding one is REMOVED and ADDED under a new heading; the `**Migration:**` of each names what goes and
arrives. Four keep their heading because every removal title stays true of a stored roster held
removed, which is the upgrade path: *a commitments screen lists a commitment its roster has removed
in neither of its lists*, *a roster store holding a commitment removed with no day it was kept until
is refused*, *a roster store holding a commitment again after holding it stopped or removed is
refused* and *a day screen opened on a roster whose commitments have all been removed takes nothing
on*. Their fixtures move to a form-5 roster. The typed-back rule is carried from the removal
requirement word for word; the grill settled it unchanged (settled 2).

### A copy made before this Story

Not asked at the grill and not a preference: settled 1 erases what the removed state holds at the
upgrade, and an old copy restored is the same roster read the same way. Refusing such a copy was the
alternative, and it would strand every copy made before this ships.

### What the shell draws

Option B, *Field alone*, chosen at https://claude.ai/artifact/YAQkQVSBLRLZfP6q6m3du5 against the
designer's A. The swipe and its label read *Delete*; the header reads `Type "<name>" to delete it
for good.`; the footer, shown only while a copy place is picked (settled 10), reads `The copy in
Files follows, so it will not hold <name> either.`

```
B · Field alone
┌────────────────────────────────┐
│ (Cancel)              (Delete)③│
│ Delete Gym                     │
│ ① Type "Gym" to delete it for  │  section header, secondary grey
│   good.                        │
│ ╭────────────────────────────╮ │
│ │  Gym|                      │ │
│ ╰────────────────────────────╯ │
│ ② The copy in Files follows,   │  section footer
│   so it will not hold Gym      │
│   either.                      │
│ [ keyboard ]                   │
└────────────────────────────────┘
```

## Risks / Trade-offs

- **Irreversible on the phone by design.** The typed name is the only guard; a copy on request made
  earlier is the only way back, and the sheet does not promise even that.
- **A kill between the two writes** leaves a listed commitment with no history. Accepted: it is
  visible, loses nothing the person did not ask to lose, and a second deletion completes it.
- **Test churn beyond the delta.** Hand-written roster fixtures that claim the form this app writes
  are at form 5 and move to form 6; ones naming an earlier form stay. `tasks.md` §1 draws the line.
- **Many requirements exceed the 150-word prose budget**, carried verbatim from specs already over
  it; the five new requirements are within it or close, and none is split.

## Open Questions

None. `grill.md` § *Left open* records none, and the two things it left to this document — how the
emptied mark is stored and how the two writes are made whole — are settled above. No residual round
is raised: the one question writing the delta turned up, an old copy holding removed commitments,
follows from settled 1 and is decided above rather than asked.
