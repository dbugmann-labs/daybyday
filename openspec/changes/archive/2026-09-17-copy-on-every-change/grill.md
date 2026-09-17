# Grill — copy-on-every-change

*18 questions over 3 rounds, 2 fact agents and one designer, 2026-09-16. Every answer was the
recommendation except the layout, where the owner took A over B.*

The Feature grill of B-009 settled the shape — a folder picked once, a copy on every kept change,
one file overwritten whole, said on the commitments screen and nowhere else — and `CONTEXT.md`
§ *Copy place* holds it. What follows is this Story's edges.

## Settled

1. **The file at the copy place.** A fixed name, `DayByDay.daybyday`, overwritten whole. *One file
   in Files that never changes its name is what a mirror of now looks like; the moment it was made
   is inside it and on the commitments screen. A dated name plus a delete is two steps that can
   half-fail.*
2. **A copy the moment the folder is picked.** Written at once. *Picking is the one time the
   person is watching, and "last copy: just now" is the proof it works.*
3. **A folder that already holds `DayByDay.daybyday`.** Picking it asks to restore that copy
   first, through the notice #267 built — the copy's moment and the counts both sides — with three
   replies: *restore* puts it back and the place is set; *replace* keeps this phone's and writes it
   there now; cancel sets no place. *On a new phone the natural move is to pick the old phone's
   folder; this is the one reading that cannot lose the old phone's last copy to one tap, and it
   makes "carry my history to a new phone" one gesture.*
4. **What counts as a kept change.** Every write the app makes to any of the three stores for a
   change the person made, from either screen: a tick, a number, a note, a one-off added, removed
   or ticked, a commitment defined, changed, stopped, removed, taken up again, moved or restarted,
   and a restore confirmed. *The copy is at most one change behind or it is not a mirror; after a
   restore the copy place holds what was just put back.*
5. **A copy that cannot be made on a kept change.** The change is kept, always, and every later
   kept change tries again on its own. *The copy is a consequence of the change, never a condition
   of it.*
6. **What the line says when the last attempt failed.** The reason and since when, beside the last
   copy that succeeded — e.g. *Last copy Mon 31 Aug 14:32 · stopped since Tue 09:07: the folder
   cannot be reached*. Three reasons, told apart: the folder cannot be reached (gone, moved, access
   taken away), the folder cannot be written, a store that cannot be read, naming the store. *They
   ask different things of the person: pick again, wait or free space, #270's take-out.*
7. **Hand-made copies.** A copy made through the share sheet does not count as the last copy.
   *The app cannot tell a copy saved from one cancelled, so counting it would sometimes lie; the
   line is about the copy place and nothing else.* This closes what #266 settled 6 left open.
8. **Forgetting the copy place.** In scope, as a small action on the same row; afterwards there is
   no place and the line offers picking one, as on a fresh install. *Without it a folder gone for
   good is reported as stopped forever.*
9. **Picking a different folder.** The new place gets a copy at once (2); the file at the old
   place is left as it is. *Deleting from a folder the person owns is not the app's to do.*
10. **Writes the person did not make.** Undoing a torn save or a torn restore on open, carrying
    back orphaned records and the day-one take-on are not kept changes and write no copy. *A
    repair puts back what the copy already mirrors; a copy from one is a copy the person cannot
    account for.*
11. **A folder holding a copy that cannot be read** — damaged, from a later version, not a copy.
    The pick is refused with #267's reason and no place is set. *Overwriting a file the app cannot
    read destroys what might still be recoverable elsewhere; the person moves it in Files and
    picks again.*
12. **Naming the folder.** The line names the copy place by the folder's name. *"Stopped: Backups
    cannot be reached" tells the person which folder to look for.*
13. **Learning the place is gone.** Only an attempt — the pick, or a kept change — finds out; the
    commitments screen does not probe the folder when it is shown. *The line says exactly what
    happened and when, and the screen never reaches outside the phone just to be looked at.*
14. **On My iPhone.** Allowed beside iCloud Drive, and nothing is said. *No such place is the
    app's to name; a warning is a nag on every pick.*
15. **The walk.** Five simulator shots: the copy section with no place picked; the line just after
    a folder is picked; the line after a tick on the day screen; the restore-first notice when the
    picked folder holds a copy; the stopped line with a reason. Two `phone:` lines: pick an iCloud
    Drive folder, tick, see the file change on another device; delete the folder in Files, tick,
    see the stop, then forget the place. *#267's walk drove the system file picker in the
    simulator (its tasks 11.2 and 11.5), so the folder picker is expected to drive; if the stopped
    line cannot be driven, it is a seam test's to show.*

16. **The first copy fails at the pick.** The place is set, and the line carries only the stopped
    half — *Stopped since Tue 09:07: the folder cannot be written* — with no last copy to stand
    beside it. *The next kept change retries; refusing the pick would send the person back to the
    picker for a folder that may work in a minute.* Raised by the designer while drawing.
17. **Red for a stop.** The stopped half is drawn in the caption red the screen's refusals use.
    *A fault to act on, not a judgement of the record, so ADR-1045 does not reach it.*
18. **The layout.** Option A — see § *Layout* below.

Not asked, taken as the only reading: the last copy's moment and a stop last across the app being
closed, until the next attempt — a stop that vanished on relaunch could not say since when; the
moment is the clock at the kept change, to the minute, as #266's moment is; a restore replaces the
three places and the copy place is not one of them, so it survives a restore; the copy written
after a restore taken from the copy place's own file replaces the file it was read from; cancelling
the folder picker changes nothing and leaves no trace; the day screen says nothing about the copy
place (`CONTEXT.md` § *Copy place*).

## Facts found, carried to spec-author

- **No single choke point.** Each store has one private writer — `RecordStore.write`
  (`RecordStore.swift:317`), `RosterStore.write` (`:101`), `OneOffStore.write` (`:145`) — and
  `SaveInProgress` and `RestoreInProgress` write raw bytes beside them. The screen entry points
  that end in a write are, on `DayScreen`: `addOneOff`, `rename`, `remove`, both `tick`s, `enter`,
  `takeBackLast`; on `CommitmentsScreen`: `define`, `change`, `restart`, `confirmStopKeeping`,
  `confirmRemoving`, `keepAgain`, both `move`s, `confirmRestoring`. `change` and `restart` write
  record and roster in one change; `confirmRestoring` writes all three. The open-time writers
  (`undoTornRestore`, `undoTornSave`, `openRoster(takingOnIfEmpty:)`, `carryBackOrphanedRecords`)
  are the ones settled 10 excludes. The copy's moment comes from the shell, `momentNow()` at
  `CommitmentsView.swift:177`; the day screen's shell hands no moment today.
- **What lasts until shown again or a change is kept** is `refusedChange` and `copyRestored`,
  cleared by `endedByAChangeOrByBeingShown()` (`CommitmentsScreen.swift:138`). The last-copy line
  and a stop are not of that kind (settled 6, 13): they must outlive a relaunch, beside the place.
- **Nothing persists a setting today** — no `UserDefaults`, no `@AppStorage`, no settings file; the
  three places are statics on `DayScreen` under Application Support. The copy place and what the
  line says need a place of their own, which is not one of the three a copy holds or a restore
  writes. `docs/open-questions.md` notes the three places travel as a trio; this Story adds a
  fourth *file* but not a fourth store in the copy.
- **Folder access on iOS.** Apple documents folder picking through
  `UIDocumentPickerViewController(forOpeningContentTypes: [.folder])`, which grants read and write
  to the folder and everything later added to it; whether `.fileImporter` with `.folder` grants
  write is **not confirmed** (a DTS reply calls it read-only by intent). Access across launches is a
  plain bookmark — `bookmarkData(options: .minimalBookmark)` inside start/stopAccessing,
  `URL(resolvingBookmarkData:bookmarkDataIsStale:)` — since `.withSecurityScope` is macOS-only;
  Apple's sample treats a stale bookmark as a failure. The restore picker already uses
  `.fileImporter` with `startAccessingSecurityScopedResource` (`CommitmentsView.swift:622-632`); no
  bookmark exists anywhere. Apple says to use `NSFileCoordinator` for every picker-provided URL.
  **Not confirmed by any Apple statement:** whether a bookmark survives an app update, a backup
  restored to a new phone, or device-to-device migration; whether a deleted folder resolves stale or
  throws; whether a write is visible in Files at once. Settled 3 and 6 make the first moot: a new
  phone picks again, and a bookmark that will not resolve is *the folder cannot be reached*. The
  person can take access away in Settings › Privacy › Files and Folders; that reads the same way.
- **The moment's form is not settled and is `spec-author`'s.** Settled 6's example says
  `Mon 31 Aug 14:32`; the shell's `momentText` (`CommitmentsView.swift:155-166`) renders
  `31 Aug 2026 at 14:32`, locale-dependent, and the restore notice draws that today. ADR-1022
  reaches what the package says; which form the line takes is a string for the delta, and the
  example in settled 6 is not a requirement.
- **The walk.** No walk test exists in the tree; #267's implementer drove the restore file picker
  in the simulator and marked only the Files round trip `phone:`.
- **Info.plist** declares only the `.daybyday` type; no entitlements file, nothing iCloud.
- **§7.** #262 (`FEAT: commitment`, the commitments screen) has no branch. This delta touches the
  commitments screen's copy section and its refused change; if it MODIFIES a `commitment`
  requirement, `design.md` should say so, and whichever of the two reaches G4 second serialises.

## Terms landed in CONTEXT.md

No new term. Two amendments, both dated 2026-09-16 at this grill:

- **Copy place** — the fixed file name; a copy on picking; a folder already holding a copy asks
  to restore first, and one holding a copy that cannot be read is refused; the line names the
  folder and reports attempts only; forgetting; the old place left as it is; On My iPhone allowed.
- **Copy** — the one written on the app's own follows a change the person kept and never an
  open-time repair, is never refused a change, and a hand-made copy is not the last copy.

## Layout

Option A, one more row in the *Copy* section, chosen from three at
https://claude.ai/artifact/7Pyf3AavpRHjkdw3RCpXak — the owner's call against the designer's
recommendation of B, a section of its own. The copy place is a Settings-style row at the top of
the existing section, its value the folder's name or *Pick a folder*; the line is the section's
footer; forgetting is a swipe on the row. The restore-first notice for a folder that already holds
a copy is #267's notice with *replace* as a row in its body under a footer saying what it does.
The wireframe follows, verbatim from the designer.

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

The mockup is a decision aid and never a requirement (ADR-1057).

## Left open

None. Every question the frontier raised was answered. Whether `.fileImporter` can pick a writable
folder or the shell needs `UIDocumentPickerViewController`, where the copy place and the line's
state live, how the writes are coordinated, and how the day screen's kept changes reach a clock,
are facts and design for `spec-author`, not preferences of the owner's. No ADR was written at the
grill; restore-first on picking a folder that holds a copy (3) is the likely candidate, and
`spec-author` judges it at the delta.
