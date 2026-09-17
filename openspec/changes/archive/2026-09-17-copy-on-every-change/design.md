## Context

Nothing in the app persists a setting: no `UserDefaults`, no `@AppStorage`, no settings file. The
three places are statics on `DayScreen` under Application Support, and a copy holds their three
values and a moment — nothing else.

There is no single choke point a copy could hang off. Each store has one private writer, and
`SaveInProgress` and `RestoreInProgress` write raw bytes beside them. The entry points that end in
a write are seven on `DayScreen` — adding, renaming and removing a one-off, both ticks, entering,
and taking the last addition back — and thirteen on `CommitmentsScreen`, of which a change and a
restart write two places in one act and a confirmed restore writes three. On the commitments screen
those sites are already marked: `endedByAChangeOrByBeingShown` is called at each of them and at
being shown again, and nowhere else. The day screen has no such marker and no clock: the moment a
copy carries is formed at the shell's edge today, for the commitments screen alone.

Forming a copy is private to `CommitmentsScreen`: reading the three stores with a torn save and a
torn restore undone first, and writing one file. The day screen now needs both.

Apple documents folder picking through `UIDocumentPickerViewController(forOpeningContentTypes:)`,
which grants read and write to the folder and what is later added to it; whether `.fileImporter`
with `.folder` grants write is unconfirmed. Access across launches is a plain bookmark, since
`.withSecurityScope` is macOS-only.

## Goals / Non-Goals

**Goals:** one folder picked, kept across launches; a copy after every change the person keeps,
from either screen; one line on the commitments screen that says what the last attempt did.

**Non-Goals:** syncing, merging, or reading the folder to find out whether it is still there. No
second copy place, no history of copies, and no schedule — a copy follows a change and nothing
else. The day screen says nothing about any of this.

## Decisions

### The seam

```
public final class CopyPlace
public static var place: URL
public init(at place: URL = CopyPlace.place, keepingRecordAt: URL = DayScreen.recordPlace, keepingRosterAt: URL = DayScreen.rosterPlace, keepingOneOffsAt: URL = DayScreen.oneOffPlace, asking momentNow: @escaping @Sendable () -> Moment?)
public private(set) var folderName: String?
public private(set) var lastCopy: Moment?
public private(set) var stopped: Stopped?
public enum Stop: Hashable, Sendable { case folderCannotBeReached, folderCannotBeWritten, storeCouldNotBeRead(Copy.Store) }
public struct Stopped: Hashable, Sendable { public let stop: Stop; public let since: Moment }
public func forget()
func set(to folder: URL)
func keptAChange()
func copyHeldIn(_ folder: URL) -> Result<Copy, CommitmentsScreen.Refusal>?
static func form(recordAt: URL, rosterAt: URL, oneOffsAt: URL, asOf moment: Moment) -> Result<Copy, CommitmentsScreen.Refusal>

extension CommitmentsScreen
public init(asOf: CalendarDate, keepingRosterAt: URL, keepingRecordAt: URL, keepingOneOffsAt: URL, copyingTo copyPlace: CopyPlace? = nil)
@discardableResult public func givenAsCopyPlace(_ folder: URL) -> Refusal?
public func replaceTheCopyAtTheFolderGiven()
public func forgetTheCopyPlace()
public private(set) var refusedCopyPlace: Refusal?
public var copyPlace: CopyPlace? { get }

extension DayScreen
public init(startingFrom: [Commitment], asOf: CalendarDate, keepingRecordAt: URL, keepingRosterAt: URL, keepingOneOffsAt: URL, copyingTo copyPlace: CopyPlace? = nil)
```

### One copy place, handed to both screens

The copying hangs off one object both screens hold, called once per kept change from a private
`keptAChange()` each screen already has the sites for. A `nil` copy place is the whole of "no
copying": every existing call site compiles unchanged and writes nothing new, and the shell hands
the same instance to both screens so the line is current the moment the commitments screen is
drawn. Rejected: hanging it off the three stores' writers, which would copy an open-time repair and
copy twice for a change that writes two places; and calling it at each of the twenty entry points,
where the next entry point added would silently not copy.

### A folder refused is held beside a refused change, not in it

A folder whose copy cannot be read is refused into `refusedCopyPlace`, the way `sheetRefusal`
already sits beside `refusedChange` rather than inside it. Rejected: an eleventh kind of refused
change, which MODIFIES two `commitment` requirements — the ten a person can ask for, and what ends
one — for no behaviour, and serialises this Story against `FEAT: commitment` (#262). Nothing here
touches `commitment`: picking and copying reach the copy place, and `commitment` already says a
copy made ends no refused change because the file is not a place a change is kept at.

### The moment is a clock handed in, as ADR-1004 has it

`CopyPlace` is handed `momentNow`, and the copy of a kept change carries what it answers then. The
shell hands the same conversion `momentNow()` already does beside `today()`. A test hands a closure
answering a fixed minute, or a later minute each time, which is what makes "exactly one copy per
change" assertable at all. Rejected: a moment parameter on each of the twenty entry points.

### The folder is bookmark data beside its path, and every write is bracketed

The copy place file holds bookmark data, the folder's path and its name, with the last copy and any
stop. Resolving prefers the bookmark and falls back to the path; a bookmark that resolves stale or
not at all, or a folder that is gone, is `folderCannotBeReached` — settled 3 and 6 make that the
one reading for all of them, including access taken away in Settings. Every read and write brackets
`startAccessingSecurityScopedResource()`, stopping only where it answered true. The shell picks
with `UIDocumentPickerViewController(forOpeningContentTypes: [.folder])` wrapped as `ShareSheet`
already wraps `UIActivityViewController`, because Apple documents write access for it and not for
`.fileImporter`.

### A copy follows a kept change and never refuses one — ADR-1058

The change is kept first and answered exactly as it would be with no copy place; the copy is
attempted after, and its failure is held on the copy place and told on one line. Open-time repairs
write none.

### Migration

None — additive. The copy place is a new file of its own beside the three places; no record, roster,
one-off or copy changes form, and a copy holds nothing of it. A phone that has never picked a folder
has no copy place file, which reads as no folder, no last copy and no stop.

### What the shell draws

Option A, one more row in the *Copy* section, chosen at the grill from three at
https://claude.ai/artifact/7Pyf3AavpRHjkdw3RCpXak.

```
OPTION A - one more row in Copy
+-----------------------------------+
| < Back                     up/dn + |
| Commitments                        |
+-----------------------------------+
|  STOPPED                          |
|  +-----------------------------+  |
|  | Journaling - Every day    > |  |
|  +-----------------------------+  |
|                                   |
|  COPY                             |
|  +-----------------------------+  |
|  | Copy place        Backups > |  |   <- taps to the folder picker
|  | Make a copy                 |  |
|  | Restore from a copy         |  |
|  +-----------------------------+  |
|  Last copy Mon 31 Aug 14:32       |   <- section footer, caption
+-----------------------------------+
   no place  : value reads "Pick a folder"; footer offers one
   stopped   : footer becomes "Last copy ... - stopped since
               Tue 09:07: the folder cannot be reached" in red
   forget    : swipe the place row


ALL THREE - the folder that already holds a copy
+-----------------------------------+
| Cancel  Restore this copy? Restore |
+-----------------------------------+
|  MADE                             |
|  +-----------------------------+  |
|  | 31 Aug 2026 at 14:32        |  |
|  +-----------------------------+  |
|  THE COPY                         |
|  +-----------------------------+  |
|  | Keeps 2, has stopped 0      |  |
|  | 1 one-off(s)                |  |
|  +-----------------------------+  |
|  YOUR PHONE                       |
|  +-----------------------------+  |
|  | Keeps 4, has stopped 1      |  |
|  | 2 one-off(s)                |  |
|  +-----------------------------+  |
|  +-----------------------------+  |
|  | Replace it with this phone's|  |
|  +-----------------------------+  |
|  The copy in Backups is           |
|  overwritten now, and Backups     |
|  becomes the copy place.          |
+-----------------------------------+
```

The stopped half is drawn in the caption red the screen's refusals use; the moment takes the form
`momentText` already renders, not settled 6's example. The line names the folder by its last path
component.

## Risks / Trade-offs

**A bookmark that does not survive.** Apple states nothing about a bookmark surviving an app
update, a backup restored to a new phone, or device migration. Every such case reads as the folder
cannot be reached, and the person picks again — which settled 3 makes the natural move on a new
phone anyway.

**A write not visible in Files at once.** Apple states nothing about when a write through a
picker-granted URL appears. The walk's two `phone:` lines are where that is found out; nothing in
the delta asserts it.

**Twenty call sites, one of them missed.** The copy hangs off one call per screen, but each screen
must call it at every site. The delta names all twenty in one requirement and the tests drive each
kind, so a missed site is a failing scenario rather than a silent gap.

**The copy place folder is written on every tick.** One file overwritten whole, of the size a copy
already is. Nothing here batches or delays; a folder on iCloud Drive does its own syncing.

**One budget warning, not squeezable.** `day-screen`'s take-back requirement stood at 148 words and
reaches 152 with the four added. A MODIFIED block is carried verbatim but for the sentence that
changes, and this one rule will not split. ADR-1047, accepted as a warning.

## Open Questions

None. The grill left none open, and writing the delta raised none: where the copy place lives, how
the folder is held across launches, which picker the shell uses, and how the day screen reaches a
clock were all facts and design rather than preferences, and are decided above.
