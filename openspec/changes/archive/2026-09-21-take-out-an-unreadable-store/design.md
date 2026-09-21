## Context

The three places are files under Application Support: `record.json`, `roster.json` and
`one-offs.json` in a directory of the app's own, with `save-in-progress.json` and
`restore-in-progress.json` written beside them. The Files app cannot see that directory.

A copy is the three *values*, read fresh and written as one `.daybyday` file into the platform's
temporary directory, which the share sheet then takes (ADR-1054). `CopyPlace.readStores` opens the
three stores with a torn restore and then a torn save undone first, and answers which of the three
did not open — but only that, because it opens each with `try?`. Each store throws `.laterForm`
apart from every other refusal, which is how both screens already say *written by a later version*
of a store they open themselves.

`CommitmentsScreen.readPlaces` runs at three points — opening, being shown again, and a restore
confirmed — and today opens the roster and the record but never the one-off place. A copy refused
names the store and one of two causes: read, or written. The copy place's stop names the same two.

## Goals / Non-Goals

**Goals:** the files off the phone while a store cannot be read; the cause said once per store, the
same way wherever it is said; one line on the day screen pointing at the restore.

**Non-Goals:** reading, repairing, migrating or diagnosing any store — a take-out is bytes. No
archive format, no take-out on a working phone, no record of one afterwards, and no second cause for
a roster that could not be *written* (#91's work). Nothing here tells the locked-before-first-unlock
case apart from any other refusal to open.

## Decisions

### The seam

```
extension CommitmentsScreen
public struct StoreNotRead: Hashable, Sendable { public let store: Copy.Store; public let cause: Cause; public enum Cause: Hashable, Sendable { case couldNotBeRead, writtenByALaterVersion } }
public private(set) var storesNotRead: [StoreNotRead]
public var offersATakeOut: Bool { get }
public func takeOut(writingInto directory: URL = CommitmentsScreen.copyDirectory) -> Result<[URL], Refusal>
case takingOut(Copy.Store?, Refusal)            // RefusedChange
case storeWrittenByALaterVersion                // Refusal

extension CopyPlace
case storeWrittenByALaterVersion(Copy.Store)    // Stop
struct StoresRead { let record: RecordStore?; let roster: RosterStore?; let oneOffs: OneOffStore?; var notRead: [CommitmentsScreen.StoreNotRead] }
static func form(recordAt: URL, rosterAt: URL, oneOffsAt: URL, asOf moment: Moment) -> (result: Result<Copy, CommitmentsScreen.Refusal>, notRead: [CommitmentsScreen.StoreNotRead])

extension DayScreen
public var saysACopyCanBeRestored: Bool { get }
```

### One reading of the three places, carrying the cause

`readStores` opens each store in a `do`/`catch` that tells `.laterForm` apart, as both screens'
own openings already do, and answers `notRead` in the fixed order record, roster, one-offs.
`CommitmentsScreen.readPlaces` opens the one-off place too and keeps that list in `storesNotRead`,
so the offer, the refused copy's cause and the copy place's stop all read off one answer. A torn
save or restore that cannot be undone keeps its shipped reading — all three not read, as the record
— which is why that state offers a take-out. `AwaitingRestore.unreadable` stays `[Copy.Store]`,
mapped from the new list: the restore sheet says a count is missing, not why. Rejected: a second
read for the cause, which would undo a torn save twice.

### The take-out copies bytes into a directory of its own, and never reads a store

Each file that stands is copied byte-for-byte into a fresh directory under the one the screen is
given, named so two take-outs never collide, and the URLs are answered in place order. A take-out
therefore leaves the places untouched — no undo, no migration, no orphan carry-back — and the share
sheet takes several items as it already takes one. Rejected: sharing the place URLs directly, which
hands the live files to another app; and one archive file, which invents a format and hides which
store is broken.

### A refused take-out reuses the refused change, with a case of its own

`RefusedChange.takingOut` names the store, as `.makingACopy` does, and a save or restore in progress
is named as the record — the place it stands beside, which is how `readStores` already reads that
state. The delta's *store that could not be taken out* is `.storeCouldNotBeRead` held against
`.takingOut`, since the file could not be read; the directory it is to be written into is `.notKept`,
the shipped place-could-not-be-written refusal. No new cause is
invented for the locked-before-first-unlock case.

### The later-version cause is said wherever the store is named

One new `Refusal` and one new `CopyPlace.Stop` case, so a refused copy, a stopped copy and the
take-out's own caption all say *written by a later version* of the store the day screen already says
must not be deleted. This closes `docs/open-questions.md` § *A roster from a later version is given
two causes at once when a copy is asked for*, which that file leaves to this Story; retiring the
entry is the only edit this change makes outside the folder, `CONTEXT.md` and the sources.

### Migration

None — additive. A copy place written before this change never holds the new stop, and its stop is
written as a string tag whose unknown values already read as no stop. No record, roster, one-off or
copy changes form, and a take-out writes nothing at any place.

### What the shell draws

Option B, take-out under the refused copy, chosen at the grill's layout round from three at
https://claude.ai/artifact/EMBZufLbQ6PCKkq1dVWRVg. The day screen's line takes the secondary grey,
not the red the causes take; the take-out row carries a caption naming the cause, which the mockup
did not draw (settled 13).

```
OPTION B - take-out under the refused copy  (recommended)
+-----------------------------------+
| <                     up/dn    +  |
| Commitments                       |
+-----------------------------------+
|  STOPPED                          |
|  +-----------------------------+  |
|  | Nothing has been stopped.   |  |
|  +-----------------------------+  |
|                                   |
|  COPY                             |
|  +-----------------------------+  |
|  | Copy place   Pick a folder >|  |
|  | Make a copy                 |  |
|  | Your record could not be    |  |  <- red, after Make a copy
|  |   read.                     |  |
|  | Take out the files          |  |  <- drawn only while a store
|  | Restore from a copy         |  |     cannot be read or is from
|  +-----------------------------+  |     a newer version
|  Pick a folder to keep a copy      |
|  there.                           |
+-----------------------------------+
   take-out refused : a red caption row between Take out the files
                      and Restore from a copy
   day screen line  : secondary grey, one line under the causes


THE DAY SCREEN - with a record that cannot be read
+-----------------------------------+
|                  Commitments   +  |
|                                   |
|  <         Wed  16 Sep 2026    >  |
|  The record could not be read.    |  <- red, shipped
|  A copy can be restored from      |  <- secondary grey
|    Commitments                    |
|                                   |
|  +-----------------------------+  |
|  | Creatine  - Every day       |  |
|  | Magnesium - Every day       |  |
|  | Gym       - Mon, Wed, Sat   |  |
|  +-----------------------------+  |
+-----------------------------------+
   one line whatever the number of stores not kept; text, not a control
```

## Risks / Trade-offs

**Bytes a person cannot read.** What leaves is JSON under names only this app knows, and a broken
file stays broken in their hands. That is the point — ADR-1054 keeps the forms off the phone, and
this is the one door out — but nobody should expect a person to repair one.

**Five files at the share sheet.** Some destinations take several files badly. The alternative is an
archive format, which the grill rejected; a destination that takes one file at a time is the
person's to work around.

**The offer is as good as the last read.** A store broken while the screen sits open is not noticed
until the app is shown again, exactly as the roster already behaves. Reading on being drawn would
undo a torn save on every draw.

**A wider `readPlaces`.** Opening the one-off place at all three read points is new work on every
open and every show. It is one file read of the size the others already are.

## Open Questions

None. The grill left none open, and the one question `docs/open-questions.md` left to it is settled
as the later-version cause above. The residual round raised while this delta was written — whether
the copy the app makes on its own tells the same two causes apart in its stop, or keeps the one
cause it has — was answered on 2026-09-21: it tells them apart, so the stop carries the later-version
cause and `docs/open-questions.md`'s entry is closed on both the copy a person asks for and the copy
the app writes. The delta stands as written.
