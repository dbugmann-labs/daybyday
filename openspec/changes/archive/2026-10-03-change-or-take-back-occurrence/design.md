## Context

See `proposal.md` § *Why*, and `grill.md`, whose twelve settled answers this delta is written on.
The facts the shape turns on, read off this worktree at `origin/main` 2c050a9:

- **An occurrence has no identity.** `Occurrence` is four fields, `Hashable` over all four, and
  `Happenings.occurrences` holds two alike as two; nothing refers to one.
- **`HappeningStore` writes form 2** and changes through `Happenings` before one `write(_:)`, the
  shape `note(_:)` already takes.
- **`DayView.HappeningRow` is a name and `timesInWords`**, formed in `withHappenings(_:)`; six
  carried assertions in `DayScreenHappeningTests` compare rows with `.init(name:timesInWords:)`.
- **`DayScreen.note(...)` returns `OccurrenceRefusal?`**, ends `notice`, re-forms `dayView` and
  calls no `keptAChange()`: happenings are in no copy until #380.
- **The shell's happening row is a `Text` with no tap**; the chosen-values popover beside it is
  anchored to its row with `arrowEdge: .top` and `.presentationCompactAdaptation(.popover)`, and
  `NoteHappeningSheet` bounds its picker at now exactly where it was handed a starting time.

## Goals / Non-Goals

**Goals:** change and take back an occurrence from its row, every rule drivable through
`DayScreen`, `Happenings` and `HappeningStore`, with no change to the store's form.

**Non-Goals:** no move to another happening or day (settled 3); no noting from the list (settled
10); no look-back (#378); no stop or delete (#379); no copy of happenings (#380); no change to the
commitments screen.

## Decisions

### The seam

```swift
public var timeInWords: String { get }  // on Occurrence
public mutating func change(_ occurrence: Occurrence, to time: TimeOfDay?, saying note: String?) -> Bool  // on Happenings
public mutating func takeBack(_ occurrence: Occurrence) -> Bool  // on Happenings
@discardableResult public func change(_ occurrence: Occurrence, to time: TimeOfDay?, saying note: String?) throws -> Bool  // on HappeningStore
@discardableResult public func takeBack(_ occurrence: Occurrence) throws -> Bool  // on HappeningStore
public func occurrences(of row: DayView.HappeningRow) -> [Occurrence]  // on DayScreen
@discardableResult public func change(_ occurrence: Occurrence, to time: TimeOfDay?, saying note: String, asOf now: Moment) -> OccurrenceRefusal?  // on DayScreen
@discardableResult public func takeBack(_ occurrence: Occurrence) -> OccurrenceRefusal?  // on DayScreen
```

### An occurrence is found by likeness, the earliest noted first

Two alike are indistinguishable to a person and to every reader, so changing or taking back either
is one act (grill, facts). The earliest noted alike is the one acted on, which makes the result
determinate under `Happenings`' ordered equality.
- *Rejected:* an identity per occurrence — a third form and a migration to tell apart what nothing
  can tell apart.
- *Rejected:* an index into `occurrences` — stale the moment another screen writes the place.

### A change keeps its place in the order noted

The list breaks a tie between equal times by the order noted, so a change of note alone must not
reorder it; a rename keeps a happening's place on the same footing.
- *Rejected:* removed and noted again last — the list would move under a note edit.

### The row's occurrences are asked of the screen, not carried on the row

`occurrences(of:)` resolves the row's name against the happenings listed and reads the held store
for the day shown. A row's name is unique among those listed, so the lookup is exact.
- *Rejected:* an `occurrences` field on `HappeningRow` — it moves the row's equality and the six
  carried assertions that pin it.

### One rule for a change's bound, judged on the occurrence's own day

`change(...)` refuses as `notYetCome` on the rule `note(...)` uses, read against the occurrence's
`day` rather than the day shown; `takeBack(_:)` has no bound. Order: not kept where the screen holds
no store or no occurrence alike; then no change asked; then not yet come; then the write. A change
asking for none returns `nil` before any write, so Save on an untouched sheet at a place that cannot
be written does not say "Not saved", as a same-name rename asks for no change.

### Words live in the Kit

`Occurrence.timeInWords` is the row's per-time rule in one place, and `withHappenings(_:)` reads
it; the list draws it as given (ADR-1019). `OccurrenceRefusal` is reused unchanged.

### Migration

None — form 2 is written and read as it is; a change rewrites the whole document as `note` does.

### The shell

The happening row becomes a `Button`. With one occurrence on the day shown it opens the sheet
directly (settled 6); with several, a popover anchored to the row as the chosen-values one is,
listing `occurrences(of:)`: each entry `timeInWords`, its note beneath in secondary style, at most
three lines, and a chevron. A tap closes the popover and then opens the sheet; a tap outside closes
it. The sheet is `NoteHappeningSheet` filled in: titled with the row's name, the occurrence's time
or "No time", its note, opening with the keyboard down — `NoteEditorField` takes first responder on
appear today, so it gains a flag that withholds that here and only here; the picker is bounded at
now exactly where `startingTime(asOf:)` answers a time. *Take back*, red, at its foot opens
`.confirmationDialog("Take back this occurrence?")` with a destructive *Take back* and *Cancel*.
A kept Save or take-back closes the sheet onto the day (settled 11); a refused Save keeps it open
over the noting sheet's red lines, and a refused take-back over "Not taken back. Try again."
Cancel discards silently (settled 8).

### What the shell draws

Option B, *Row popover*, from https://claude.ai/artifact/B4ckFo2bkooA2SHKfqZGDC.

```
B · Row popover   (recommended)
              [☰ ⚙]
Friday
Today, 2 October 2026
‹ M28 T29 W30 T1 (F2) S3 S4 ›
┌ Creatine - Every day
│ …
└ Weight - Every day  ›
┌ Kopfweh · 09:10, 18:40        ← tapped
   ╭─▲──────────────────╮       popover under the row, the day stays
   │ 09:10            › │
   │ Hinter dem Auge    │
   │ links              │
   │ 18:40            › │
   ╰────────────────────╯       tap outside closes it
( New one-off              ) (⚡)
tap one → popover closes, noting sheet rises filled in:
[Cancel]   Kopfweh    [Save]
┌ Time          [09:10] ⓧ
┌ Hinter dem Auge
│ links
│
└ Take back                     red, at the sheet's foot
Take back → dialog rising at the foot:
┌ Take back this occurrence?
└ Take back                     red
┌ Cancel
```

## Risks / Trade-offs

- **The likeliest wrong implementation filters out every alike occurrence.** → Two scenarios hold
  two alike and assert one survives.
- **The second appends a changed occurrence last.** → A scenario asserts the order after a change.
- **The third copies `note`'s guard and judges the time against the day shown.** → A scenario
  changes an occurrence on a later day, shown there.
- **Opening a sheet while the popover is still closing can drop the sheet in SwiftUI.** → The sheet
  is set once the popover has dismissed; walk W.3 shows it opened.
- **A long note is cut at three lines in the popover.** → Accepted: the sheet shows it whole.

## Open Questions

None. `grill.md` § *Left open* is "None." for the owner, and its five items for the delta are
answered above: a changed occurrence keeps its place; the refusals reuse `OccurrenceRefusal`, with
"Not taken back. Try again." for a take-back; a listed occurrence with no note is its time alone, and
one with no time says "no time"; the confirmation's buttons are *Take back* and *Cancel*. Writing
the delta raised nothing that needs the owner; no residual round is outstanding.
