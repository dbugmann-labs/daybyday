## Context

See `proposal.md` § *Why*, and `grill.md`, whose twenty settled answers this delta is written on.

- **`OneOffs` adds, ticks, takes back and removes; it has no rename.** Entries are held in the order
  added, and `OneOffStore` mirrors each change, writing the whole document before it holds the change.
- **`DayView.init(of:oneOffs:asOf:on:in:)` holds `oneOffGroup == nil` where none stands**, and
  `DayScreen` hands it `oneOffStore?.oneOffs ?? OneOffs()`, so an empty place and an unreadable one
  both draw no group today.
- **`DayScreen.Notice` holds one row of either kind and `cause: String?`**; the shell shows
  `cause ?? "Not saved. Try again."`. `Blank.trimmed` and `Blank.saysNothing` are the kit's one
  whitespace test (ADR-1039).
- **Six shipped `day-screen` scenarios assert no One-offs group on a screen keeping one-offs**, or
  compare a day view handed no one-offs with one handed a one-off on another day; the MODIFIED blocks
  change exactly those.
- **`ContentView.swift` keys one-off rows by offset**, draws the group only where it is non-nil, and
  has no `+`, no focus state and no context menu on a one-off row.
- **With no commitments, a day picker's reach starts at today**, so fixtures reaching a past day
  either move back a day or hold a commitment kept from 1 January 2026.

## Goals / Non-Goals

**Goals:** a rename made in one write that keeps the order; the empty group standing for "adding is
offered"; what a refused add or rename tells, and when it ends, decided in the kit.

**Non-Goals:** re-dating a one-off (remove and add again); a row identity for commitment rows
(`docs/open-questions.md`, still open); undo; any change to the one-off store's form.

## Decisions

### The seam

- `public mutating func rename(_ oneOff: OneOff, to name: String) -> Bool` — on `OneOffs`
- `@discardableResult public func rename(_ oneOff: OneOff, to name: String) throws -> Bool` — on `OneOffStore`
- `public let oneOffGroup: DayView.OneOffGroup?` — on `DayView`, now `nil` only where handed no one-offs
- `public func addOneOff(named text: String) throws` — on `DayScreen`
- `public func rename(_ row: DayView.OneOffRow, to text: String) throws` — on `DayScreen`
- `public func remove(_ row: DayView.OneOffRow) throws` — on `DayScreen`
- `public func oneOffNameEdited()` — on `DayScreen`
- `public struct NameRefusal: Hashable, Sendable` with `public let row: DayView.OneOffRow?`, `public let text: String` and `public let cause: String?` — in `DayScreen`
- `public private(set) var nameRefusal: DayScreen.NameRefusal?` — on `DayScreen`

### A rename is one act in `one-off`, and keeps the one-off's place

Grill answer 17 keeps the date and the done day; keeping the place among one-offs owed that date is
the same reading, since a one-off renamed in Reminders does not jump to the bottom. One write means a
refused rename holds nothing changed.

- Rejected: remove then add at the screen — two writes that can half-fail, and the row moves last.
- Rejected: the screen checking for a duplicate itself — a second place the rule would live.

### The empty group is the offer

A day view handed one-offs always holds the group, and `DayScreen` hands none where it is not keeping
them, using `init(of:on:in:)`. So "the entry is drawn" is `oneOffGroup != nil`, and grill answer 5
needs no member of its own.

- Rejected: `offersOneOffEntry: Bool` — a second way to say what the group already says.

### A refusal under a name field is its own value, and there is one at a time

`NameRefusal` is not `Notice` (grill answer 11): `row == nil` is the entry, a row is a rename.
Only one name field has focus, and leaving it commits it, so two refusals could never both show
their text; one member, replaced by the next refusal, says that. `text` is what was committed,
untrimmed: the shell empties its field on every commit and shows `text` while the refusal stands,
so "keeps the typed text" and "the text goes with it" are both kit rules (ADR-1019).

- Rejected: a `Notice` case — grill answer 11 has the two told at once.
- Rejected: one refusal per field — state no screen can show.
- Rejected: the shell keeping the refused text itself — behaviour no test would see.

### The words, and where a removal is told

The cause is `"Already on this day"` for a duplicate and `nil` for a failed write, matching
`Notice` and the shell's fallback; `CommitmentsView` says `"Already being kept."` in the same
register. A removal has no field, so its failed write is told on the row by the shipped rule
(MODIFIED *tells on the one-off row*); a blank rename's is told under its field.

- Rejected: a removal told under the entry — it was not typed there.

### The shell (ADR-1019)

The entry is a `TextField` as the last line of the group on the shown page, and a disabled line on
each neighbour. The toolbar `+` shows where `oneOffGroup != nil` and focuses the entry. While any
one-off field is focused, a green checkmark shows in the toolbar; it commits and drops focus. Return
commits and refocuses a fresh entry. Losing focus commits. So do the chevrons, swipe, `Today`, the
picker and `scenePhase` leaving `.active`, each before the day moves. A long press opens a
`contextMenu` with *Rename* and a destructive *Remove*. One-off rows are keyed by value (grill
answer 19).

### Five requirements MODIFIED

*Group headed One-offs* and *is a value* each change a sentence. *Draws the one-offs at its place*
and *makes and takes back a one-off tick* change only the asserts that said no group. *Tells on the
one-off row* narrows "a one-off change" to a tick or removal, and gains one scenario. No title moves.
*Is a value* was over the prose budget on `main` and grows by a sentence; no ADR is written, as
every decision follows a settled answer or a shipped shape.

### Migration

None — the one-off store's form is unchanged; a rename rewrites the file in that same form.

## Risks / Trade-offs

- **The shell committing after the day moves** would add to the wrong day, and no kit test sees it.
  → Task 6.2 names the order, and G7 reads it.
- **A done toggle re-keys a row by value**, so a tick can animate as remove and insert. → Accepted
  at grill answer 19.
- **A blank rename removes with no confirmation.** → The owner's call, answers 14 and 16.
- **A refused text re-committed on tap-away** replaces the refusal with the same one. → Harmless.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason. Keeping a renamed one-off's place, one
name refusal at a time, and a failed removal told on its row follow from settled answers 11, 13 and
17. They are recorded above rather than asked, so there is no `## Questions for you` section.
