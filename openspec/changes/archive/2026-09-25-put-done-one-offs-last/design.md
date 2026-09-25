## Context

See `proposal.md` § *Why*, and `grill.md`, whose eleven settled answers this delta is written on.
The facts the shape turns on, read off this worktree:

- **The order is decided in one place**: `OneOffs.standing(on:asOf:)`, a stable sort by date owed
  over `entries`, which are in the order added. A day view only asks for it.
- **A tick records only a calendar day** (`OneOffs.Entry.doneOn`), and no store may hold a time of
  day (ADR-1054), so "newest" has to be an order the value keeps.
- **`OneOffDocument` is at form 1**: `version`, and `oneOffs` as `name`, `date`, optional `doneOn`,
  in the order added. `formOneOffs()` replays them through `OneOffs.add`.
- **A copy nests `OneOffDocument` as written** and reads it back through `OneOffStore.formed(from:)`,
  so a copy carries whatever the one-off store's own form carries (grill answer 9).
- **One-off rows are keyed by value in `ContentView`** (`ForEach(oneOffGroup.rows, id: \.self)`), so
  a tick re-keys the row and SwiftUI sees a removal and an insertion, not a move.
- **Only today mixes done and undone one-offs**; a past day holds only done, a future day only owed.
- Three carried tests name form 1 or form 2 literally: `OneOffStoreTests`' later-form and
  could-not-be-a-one-off tests, and `DayScreenTests`' "not keeping one-offs adds nothing" test.

## Goals / Non-Goals

**Goals:** the whole order under Kit test at `OneOffs` and `OneOffStore`, as it ships; one new public
member, on an existing type, for the shell's animation; a copy carrying the order with no copy code.

**Non-Goals:** commitment rows and birthday rows keep their order and do not animate (G2's scope);
no `restore` delta — see *A copy carries it with no delta of its own* below; no ADR, since the form
change follows ADR-1031 as written.

## Decisions

### The seam

```swift
public mutating func add(_ oneOff: OneOff, doneOn day: CalendarDate) -> Bool                  // OneOffs — unchanged; now the newest tick
public mutating func tick(_ oneOff: OneOff, on day: CalendarDate) -> Bool                     // OneOffs — unchanged; now the newest tick
public mutating func takeBack(_ oneOff: OneOff) -> Bool                                       // OneOffs — unchanged; leaves the tick order
public func standing(on day: CalendarDate, asOf today: CalendarDate) -> [OneOff]             // OneOffs — owed by date, then done newest first
public init(at place: URL) throws                                                             // OneOffStore — reads forms 1 and 2
public struct Key: Hashable, Sendable                                                         // DayView.OneOffRow — one-off and row date, both internal
public var key: Key { get }                                                                   // DayView.OneOffRow
```

`rename`, `remove` and `==` on `OneOffs` keep their signatures and meet the tick-order rules.

### The tick order is a list in the value, not a number on a tick

`OneOffs` holds the done one-offs as one list, oldest tick first, beside `entries` in the order
added: a tick or an add already done appends, a take-back or a removal drops, a rename replaces in
place. Equality is structural, so two holders differing only in tick order differ, and removing one
never leaves a hole another holder lacks (the equality scenario's third holder).
- *Rejected:* a counter stamped on each tick — equal orders compare unequal after a removal.
- *Rejected:* moving a ticked entry to the end of `entries` — a take-back loses its place added.

### The form on disk: form 2, a place on every done entry

`OneOffDocument.currentVersion` becomes 2 and `OneOffEntryRecord` gains `tick: Int?`, the entry's
place in the tick order, 1 the oldest. Form 2 writes it on every done entry and on no other;
`entries` stay in the order added. Reading form 2 requires `tick` exactly on the done entries and
the places to be 1 through their count, each once. Form 1 carrying `tick` is not a store, judged
against `tickOrderIntroducedInVersion = 2` as ADR-1031 judges every field.
- *Rejected:* a document-level array of indices — the same checks, and harder to read by eye.
- *Rejected:* an optional `tick` meaning "old" when absent at form 2 — ADR-1031's laundering case.

### Form 1 is read as a tick order derived once, never as a second state

Reading form 1 gives its done one-offs a tick order whose newest-first reading is the date owed,
earliest first, then the order added — so every past day draws as it does now (grill answer 6).
Nothing in the value remembers they were old, and the first change kept writes them at form 2.
- *Rejected:* `nil` places kept in the value — a third kind of one-off every rule must name.

### A copy carries it with no delta of its own

`restore` already requires a copy to hold the one-offs the place holds, written in the form the
one-off store writes now, and an earlier form read as the value it holds. The value and the form
now carry the order, so grill answer 9 needs no `restore` requirement and no copy code; task 4.3
proves the round trip. It also keeps this Story off the requirements #329 is rewriting.

### A one-off row's key, and the animation in the shell

The shell keys one-off rows by `\.key` — the one-off and the row's date, the same across a tick —
and wraps a one-off row's tick and take-back, alone, in `withAnimation`, so `List` moves the row
both ways (grill answers 3 and 5). A rename still re-keys, as before. The key is a Kit member because
the day-screen spec forbids a row to give back its one-off, and the shell sees nothing else unique.
- *Rejected:* keying by name — two one-offs of one name stand on today together.
- *Rejected:* keeping value keys — a fade out and in, which the eye cannot follow.

### Migration

A one-off store at form 1 is read in place and left byte-for-byte as it was; its first kept change
writes form 2, its old ticks placed as above. A copy made before this build nests form 1 and restores
the same way. A build before this one refuses a form-2 store or copy as a later version, whole.

## Risks / Trade-offs

- **The likeliest wrong implementation sorts the done by the date owed or by name.** → Every order
  scenario ticks the earlier-owed, earlier-named one-off first.
- **A take-back rejoining at the bottom of the owed, or a re-tick restoring the old place.** → One
  scenario catches both.
- **A stable key could carry view state across a tick** — focus, a notice. → Focus and the notice
  compare row values, which a tick still changes; W.2 and W.4 show the row after each change.
- **`List` may animate a move inside a `Section` as a fade.** → The `phone:` step is the proof; a
  fade there is a finding for G7, not a pass.
- **#329 reads `OneOffDocument.currentVersion` through the copy.** → Whichever merges second
  rebases; a conflict in this folder or `openspec/specs/` is a stop.

## Open Questions

None. `grill.md` § *Left open* is "None." and left two things to this design — how the order is
stored and how the move survives a re-keyed row — which the decisions above take. Writing the delta
raised nothing that is the owner's to answer, so no residual round is outstanding.
