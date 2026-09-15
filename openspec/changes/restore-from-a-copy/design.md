## Context

See `proposal.md` § *Why*, and `grill.md`, whose sixteen settled answers this delta is written on.

- **Each store writes its own file `.atomic` and nothing spans all three.** `SaveInProgress` spans
  the record and the roster, records a carry rather than a snapshot, and is undone by
  `undoTornSave`, which every reader calls before opening a store. Only `RosterStore.replace(with:)`
  writes a whole value.
- **The copy decoder is partial.** `CopyDocument` (form 1) decodes the stores nested in it through
  `Codable` alone. The per-form shape checks and the later-form check live inside each store's
  `init(at:)`, reading `Data` from a place.
- **The shell makes a `CommitmentsScreen` on each tap of *Commitments*** and calls
  `DayScreen.returnedTo()` when it is popped. `returnedTo()` reads the record only where it keeps
  one, never reads the one-offs, and leaves `notice` and `nameRefusal` standing.
- **`RefusedChange` has nine cases.** Nothing in `src/` uses `fileImporter` or security-scoped
  access. `.daybyday` is exported as `com.dbugmann.daybyday.copy`, conforming to `public.json`.
- **ADR-1055 is taken** on `look-back-at-a-tick` (#272). That Story also edits
  `CommitmentsScreen.swift` and `CommitmentsView.swift`.

## Goals / Non-Goals

**Goals:** a restore that is whole or nothing across three files, across a stop too; four refusals
told apart in the kit; both screens showing the copy the moment the person leaves the sheet.

**Non-Goals:** the day screen's line that a copy can be restored, and taking out an unreadable store
(#270); the copy place and the last-copy line (#268, #269); any change to a store's form or to the
copy's form; merging a copy into what is there.

## Decisions

### The seam

- `@discardableResult public func askToRestore(from file: URL) -> Refusal?` — on `CommitmentsScreen`
- `public func cancelRestoring()` — on `CommitmentsScreen`
- `@discardableResult public func confirmRestoring() -> Refusal?` — on `CommitmentsScreen`
- `public private(set) var awaitingRestore: AwaitingRestore?` — on `CommitmentsScreen`
- `public private(set) var copyRestored: Moment?` — on `CommitmentsScreen`
- `private(set) var hasRestoredACopy: Bool` — on `CommitmentsScreen`, internal
- `public struct AwaitingRestore: Hashable, Sendable` — `moment: Moment`, `copy: Counts`, `phone: Counts`, `unreadable: [Copy.Store]`, nested in `CommitmentsScreen`
- `public struct Counts: Hashable, Sendable` — `kept: Int?`, `stopped: Int?`, `oneOffs: Int?`, nested in `CommitmentsScreen`
- `case notACopy, damagedCopy, copyFromALaterVersion` — added to `CommitmentsScreen.Refusal`
- `case restoring(Refusal)` — added to `CommitmentsScreen.RefusedChange`
- `public func returnedTo(from commitmentsScreen: CommitmentsScreen? = nil)` — `DayScreen.returnedTo()` gains the parameter
- `static func read(_ data: Data) -> Result<Copy, CommitmentsScreen.Refusal>` — on `CopyDocument`
- `struct RestoreInProgress` — `static func restore(_ copy: Copy, recordAt: URL, rosterAt: URL, oneOffsAt: URL, stoppingAfter writes: Int? = nil) throws`, `static func undoTornRestore(recordAt: URL, rosterAt: URL, oneOffsAt: URL) -> Bool`

### Whole or nothing, across a stop (ADR-1056)

Before it writes anything, a restore keeps a **restore in progress** beside the record place, in one
atomic file. It holds the bytes that stood at the three places and at the save-in-progress place, or
that nothing stood there. The restore then takes away the save in progress, writes the record, the
roster and the one-offs, and takes the file away. If a write fails, it puts the bytes back and takes
the file away, and if that fails too the file stays. Every reader calls `undoTornRestore` before
`undoTornSave`. A restore in progress that cannot be read or undone answers every store as
unreadable and writes nothing. It rolls back, as a torn save does (ADR-1049); `stoppingAfter` is the
test seam that stops it partway, as `SaveInProgress.keep` is for a torn save.

- Rejected: rolling forward (restores a copy told as refused); three staged renames (still three acts).

### Reading a copy: the envelope decides, and a later version outranks damage

`CopyDocument.read` reads an envelope of `version` and `moment` first. If the envelope does not read,
or its form is below 1, the file is not a copy; if its form is above the current one, the copy is
from a later version. Next come the envelopes of all three nested stores, and any later form makes
the copy one from a later version. Only then is each store read, through the form reading its
`init(at:)` runs, moved into an internal static that takes `Data`. Any failure there is a damaged
copy. A file that cannot be read at all is not a copy, by settled 14's own test.

- Rejected: damage before a later version — updating the app may make the copy read, and "damaged"
  invites deleting it, which is ADR-1021's worry.

### What is said first, read once

`askToRestore` reads the file once and `confirmRestoring` writes the held `Copy`. The phone is read as
`readStoresForCopy` reads it, every store read so each unreadable one is named. *Kept* and *stopped*
count the screen's two lists, a removed commitment in neither; *one-offs* counts all (settled 12).
Being shown again leaves it awaiting: a glance away must not dismiss the sheet.

### The day screen is told by the commitments screen it returns from

`returnedTo(from:)` reads `hasRestoredACopy`. It turns true when a restore lands and is never
cleared, so a change kept afterwards, which ends `copyRestored`, still sends the day screen through
all three places. The shell hands over the per-visit screen it holds and decides nothing (ADR-1019).

- Rejected: the shell swapping in a new `DayScreen` (untested, and the day jumps); `returnedTo()`
  always reading everything (falsifies shipped day-screen scenarios).

### Three capabilities, every block whole

`restore` ADDs five requirements. `commitment` MODIFIES two, counting ten kinds; `day-screen`
MODIFIES four by one clause each, where *exactly*, *at no other moment* or *nothing else* would
forbid settled 10. Over budget: the two `commitment` blocks and the row-notice block already were on
`main`; *returned to* and *one-off name field* sat at 150 and now pass it by their one clause.
Splitting any of them is an editorial Story. This merges after #261, and #262 follows it (settled 9).

### Migration

None — no store's form and no copy's form moves. A restore in progress stands only between a
restore's first write and its last.

### The shell (ADR-1019)

The copy section gains *Restore from a copy*, which presents `.fileImporter` for the exported type
and brackets `askToRestore` in security-scoped access. `awaitingRestore` presents a sheet with the
moment, a line of counts for each side (a store that cannot be read is said in place of its counts),
a destructive *Restore* and *Cancel*. The copy section draws a refusal through `refusalText`, and
draws `copyRestored` as *Restored the copy from* its moment. `ContentView` calls
`screen.returnedTo(from: commitmentsScreen)`.

## Risks / Trade-offs

- **The phone's old bytes are held twice while a restore runs.** Accepted: the file goes as soon as
  the restore is whole.
- **The walk may not be able to drive the system file picker.** If it cannot, that is a stop and a
  report under ADR-1053, not a dropped picture.
- **#272 edits the same kit and shell files.** A conflict in `src/` is ordinary rebasing; one in a
  spec is a rule-5 stop.
- **A phone holding only removed commitments reads 0 kept, 0 stopped** while its history goes.
  Accepted, as settled 12.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and the two things it left to this delta
— how a restore is made whole, and whether the walk drives the picker — are settled above, the second
bounded by a stop. The residual round is settled: a copy of nothing restored leaves a roster holding
nothing, and a day screen returned to takes on day one, with no special case (ADR-1054).
