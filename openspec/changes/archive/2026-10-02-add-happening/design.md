## Context

See `proposal.md` § *Why*, and `grill.md`, whose eight settled answers this delta is written on.
The facts the shape turns on, read off this worktree:

- **`OneOff` + `OneOffs` + `OneOffStore` is the shape a value kept in a store of its own has**, and
  `BirthdayStore` repeats it: version first, a later form refused, decode through the value's own
  rules, the whole document written `.atomic` with `.sortedKeys`, the held value replaced only after.
- **`Commitment.Identity` is a private `UUID` with an internal `init?(_ uuidString:)`**, and
  ADR-1059 is what it cost to add one to a value already on phones.
- **Names are judged by `Blank.trimmed(_:).lowercased()`** in `Roster` and `CommitmentsScreen`; a
  blank name by `Blank.saysNothing(_:)` (ADR-1039).
- **`CommitmentsScreen` reads every place in `readPlaces` at `init` and `shown(asOf:)`**, holds one
  `refusedChange` and one `sheetRefusal`, and calls `copyPlace?.keptAChange()` after each kept change.
  A birthday place not given defaults to the file beside the record place, so no test touches the
  real Application Support directory.
- **`RosterState` is `.kept`, `.notKept` or `.writtenByALaterVersion`**, and `CommitmentsView` draws
  one line for each of the last two below the Stopped section.

## Goals / Non-Goals

**Goals:** a happening that keeps one identity across a rename, so #376 keys occurrences to it with no
change of form; one store, one place, one section; every rule drivable through `CommitmentsScreen`.

**Non-Goals:** no occurrence, no day-screen group (#376); no look-back, so a row's tap does nothing
(#378); no stop or delete, so no trailing swipe (#379); no reordering; no copy, take-out or restore of
happenings, so `Copy.Store`, `storesNotRead` and Settings are untouched (#380).

## Decisions

### The seam

```swift
public struct Happening: Hashable, Sendable {
    public struct Identity: Hashable, Sendable
    public let identity: Identity
    public let name: String
    public init?(name: String)
}
public struct Happenings: Hashable, Sendable {
    public init()
    public private(set) var all: [Happening]
    public func holding(name: String) -> Happening?
    public mutating func add(_ happening: Happening) -> Bool
    public mutating func rename(_ happening: Happening, to name: String) -> Bool
}
public final class HappeningStore {
    public init(at place: URL) throws
    public private(set) var happenings: Happenings
    @discardableResult public func add(_ happening: Happening) throws -> Bool
    @discardableResult public func rename(_ happening: Happening, to name: String) throws -> Bool
}
public enum HappeningStoreError: Error, Equatable, Sendable  // notAStore, laterForm, cannotWrite
public static var happeningPlace: URL  // on DayScreen, beside recordPlace
public init(asOf:keepingRosterAt:keepingRecordAt:keepingOneOffsAt:keepingBirthdayTicksAt:keepingHappeningsAt: URL? = nil, copyingTo:)
public private(set) var happenings: [Happening]
public private(set) var happeningState: RosterState
public private(set) var happeningRefusal: Refusal?
@discardableResult public func makeHappening(named name: String) -> Refusal?
@discardableResult public func rename(_ happening: Happening, to name: String) -> Refusal?
public func happeningNameEdited()
public func happeningSheetClosed()
```

### A happening carries an identity from its first form — ADR-1065

`Happening` compares and hashes its identity alone, as `Commitment` does; `Happenings` compares each
happening's identity and name in order, so a rename is a different `Happenings`. A rename is an act
on the identity, so the occurrences #376 adds survive it without a carry-over.
- *Rejected:* equality over the name, as `OneOff` has — #376 would re-key occurrences on every rename,
  or add the identity in a second form, which is ADR-1059's cost paid again.

### The refusals are the screen's existing `Refusal`, held in a third value

`.namesNothing`, `.nameAlreadyInUse(String)` naming the held happening as stored, and `.notKept`.
`happeningRefusal` is the happening sheet's own, beside `refusedChange` and `sheetRefusal`; the sheet
has one field, so every refusal is told under it. The screen trims with `Blank.trimmed` before
forming, as the one-off entry does, and a trimmed rename equal to the current name returns `nil`
without reaching the store.
- *Rejected:* a `RefusedChange` case — a happening asked about would end a refusal told beside a
  commitment's row, the coupling `place-sheet-refusals` split the sheet refusal off to avoid.
- *Rejected:* a `SheetField` case — one name typed would end a commitment sheet's refusal.

### No copy, and no other place

`CommitmentsScreen` is the existing seam, extended. A happening is in no copy until #380, so a kept
happening calls no `keptAChange()`: a fresh *Last copy* line would claim it was carried. `readPlaces`
stays the four stores; the happening place is opened beside it, at `init` and `shown(asOf:)`, and its
state never reaches `rosterState`.

### Migration

None — additive: a new file, `happenings.json` beside `record.json`, at version 1 —
`{ "version": 1, "happenings": [ { "identity": "<UUID>", "name": "Kopfweh" } ] }` in the held order,
read through the value's own rules, so what they refuse is `notAStore` off the disk too.

### The shell

A last `Section("Happenings")`: plain rows with no `NavigationLink` and no move, a leading pencil
swipe (accent, *Edit*) to *Rename \<name\>*, "No happenings yet." while there are none, and *New
happening* as an accent button row. Each sheet is one field with *Cancel* and *Add* or *Save*; a kept
ask dismisses, a refused one stays open over its red caption — "Give it a name.", `A happening called
"<name>" already exists.` or "The happenings could not be read or could not be written." Not kept, the
section says that last line, or "The happenings were written by a newer version of DayByDay and must
not be deleted.", and offers no button row and no swipe.

### What the shell draws

Option A, *Sheet, at foot*, from https://claude.ai/artifact/CJFdvVcUJUFJ33bodrYtqL.

```
A · Sheet, at foot
[<] Commitments      [⇅ +]
┌ … Yuno - 5x a week       >
│   Weight - Every day     >
└──────────────────────────
Stopped
┌ Nothing has been stopped.
└──────────────────────────
Happenings
┌ Augenmigräne
│ Kopfweh
│ New happening   (accent)
└──────────────────────────
Empty: "No happenings yet." row
       above New happening

Make:   sheet
[Cancel] New happening [Add]
┌ kopfweh|
│ A happening called "Kopfweh"
│ already exists.     (red caption)
└──────────────────────
[keyboard]

Rename: swipe right on the row
[✎]│ Kopfweh  → sheet
[Cancel] Rename Kopfweh [Save]
```

## Risks / Trade-offs

- **The likeliest wrong implementation copies `define`'s tail**, `keptAChange()` included. → A
  scenario asserts the last copy has not moved.
- **The second synthesises `Happening`'s equality over both fields.** → Two scenarios assert a
  renamed happening is the one it was, one through a reopened store.
- **An unreadable happening file offers no take-out and no restore until #380.** → Accepted: the file
  is left as it was and the section says so; the Stories land in order.
- **`CommitmentsScreen.swift` grows past 2,000 lines.** → Accepted: an existing seam beats a new one,
  and #378's look-back is answered here too.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and writing the delta raised nothing that
needs the owner: the words the grill left are set in § *The shell* from the wireframe and the screen's
idiom; the identity, the trim, the separate refusal and the absent copy are technical and named above.
No residual round is outstanding.
