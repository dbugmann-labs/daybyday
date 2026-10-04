## Context

See `proposal.md` § *Why* and `grill.md` § *Settled*. Facts read off this worktree:

- **A copy is `Copy`, written as `CopyDocument` at form 2**, nesting the record, roster, one-off and
  birthday documents. `CopyDocument.read` checks the nested envelopes before the whole, so a later
  form outranks damage. `Copy.Store` is `record`, `roster`, `oneOffs`, `birthdayTicks`.
- **`CopyPlace.readStores` is the one reading** behind a refused copy, the take-out offer, the
  restore sheet's `unreadable` and the copy place's stop. It never opens the happening place.
- **`RestoreInProgress` snapshots four places and the save in progress**, the birthday bytes in an
  optional wrapper so an older snapshot is told apart; `stoppingAfter: 4` stops with four written.
- **The happening store writes `HappeningDocument` form 3** and reads 1 and 2; its validation lives
  in `HappeningStore.init(at:)`, with no `formed(from:)` as `BirthdayStore` has.
- **Both screens default the happening place to `happenings.json` beside the record**; `CopyPlace`
  takes none. `confirmRestoring` neither re-reads it nor clears a happening confirmation;
  `DayScreen.returnedTo` reads it before it undoes a torn restore.
- **None of the eight happening changes calls `keptAChange()`**, by #375's and #376's design.
- **Carried tests build `CommitmentsScreen.Counts` memberwise** (`RestoreTests`, `CopyPlaceTests`,
  `BirthdayCopyTests`), and `CopyTests` and `TakeOutTests` each switch exhaustively over `Copy.Store`.

## Goals / Non-Goals

**Goals:** the fifth store carried through the one reading every surface shares, so each surface
gains a case rather than a path; every carried test unedited but the seven places `tasks.md` § 9
names.

**Non-Goals:** no count of occurrences anywhere (grill 1); no change to the happening list, the day
view or the look-back; no ADR — every decision below is small, reversible and recorded here.

## Decisions

### The seam

```swift
public let happenings: Happenings                                                // Copy
public init(moment: Moment, history: History, roster: Roster, oneOffs: OneOffs, birthdayTicks: BirthdayTicks = BirthdayTicks(), happenings: Happenings = Happenings())   // Copy
public enum Store: Hashable, Sendable, CaseIterable { case record, roster, oneOffs, birthdayTicks, happenings }   // Copy
public let happenings: Int?                                                      // CommitmentsScreen.Counts
public let stoppedHappenings: Int?                                               // CommitmentsScreen.Counts
init(kept: Int?, stopped: Int?, oneOffs: Int?, happenings: Int? = 0, stoppedHappenings: Int? = 0)   // CommitmentsScreen.Counts, internal
public init(at place: URL = CopyPlace.place, keepingRecordAt recordPlace: URL = DayScreen.recordPlace, keepingRosterAt rosterPlace: URL = DayScreen.rosterPlace, keepingOneOffsAt oneOffPlace: URL = DayScreen.oneOffPlace, keepingBirthdayTicksAt birthdayPlace: URL? = nil, keepingHappeningsAt happeningPlace: URL? = nil, asking momentNow: @escaping @Sendable () -> Moment?)   // CopyPlace
static func formed(from document: HappeningDocument) -> Happenings?              // HappeningStore, internal
static func restore(_ copy: Copy, recordAt recordPlace: URL, rosterAt rosterPlace: URL, oneOffsAt oneOffPlace: URL, birthdayTicksAt birthdayPlace: URL, happeningsAt happeningPlace: URL? = nil, stoppingAfter writes: Int? = nil) throws   // RestoreInProgress, internal
static func undoTornRestore(recordAt recordPlace: URL, rosterAt rosterPlace: URL, oneOffsAt oneOffPlace: URL, birthdayTicksAt birthdayPlace: URL, happeningsAt happeningPlace: URL? = nil) -> Bool   // RestoreInProgress, internal
```

Acceptance tests attach at members that exist: `CommitmentsScreen`'s `makeACopy`, `askToRestore`,
`confirmRestoring`, `takeOut`, `storesNotRead` and its five happening changes; `DayScreen`'s `note`,
`change`, `takeBack` and `saysACopyCanBeRestored`; `CopyPlace`. `StopRecord` persists the new case
as `"happenings"`; `AwaitingRestore`, `StoreNotRead` and `CopyPlace.Stop` keep their shape.

### What the shell draws

Option A, "One more line", from https://claude.ai/artifact/LPikZVcC8Z6SePh7XQdVF4 (grill § *Layout*).

```
A · One more line
┌──────────────────────────────┐
│ (Cancel)          (Restore)  │
│ Restore this copy?           │
│ Made                         │
│ ┌──────────────────────────┐ │
│ │ 4 Oct 2026 at 9:07 AM    │ │
│ └──────────────────────────┘ │
│ The copy                     │
│ ┌──────────────────────────┐ │
│ │ Keeps 5, has stopped 1   │ │
│ │ 2 one-off(s)             │ │
│ │ <happening count>        │ │
│ └──────────────────────────┘ │
│ Your phone                   │
│ ┌──────────────────────────┐ │
│ │ Keeps 2, has stopped 0   │ │
│ │ 0 one-off(s)             │ │
│ │ <happening count>  or    │ │
│ │ Your happenings could    │ │
│ │ not be read.             │ │
│ └──────────────────────────┘ │
└──────────────────────────────┘
(In A, the count lines are caption size, as shipped. Where a store
can't be read, its line replaces the count, as now.)
```

### The shell's words

`SettingsView.swift` only. Each side's last line, after any birthday ticks' line, is *N
happening(s), has stopped M*, N those not stopped, or *Your happenings could not be read.* for either
cause. Wherever a store is named, after the birthday ticks': *Your happenings could not be read.*,
*Your happenings were written by a newer version of DayByDay.*, *The happenings could not be taken
out.*, and the stop's lower-case pair. `ContentView.swift` is unchanged.

### The copy's form moves to 3, and forms 1 and 2 hold no happenings

`CopyDocument` gains an optional `happenings`; `currentVersion` becomes 3. Below 3 it reads as none;
at 3 a missing or unformable one is damaged, and its envelope joins the later-version pre-check.
`HappeningStore.formed(from:)` is lifted out of `init(at:)` so the store and the copy refuse alike.
- *Rejected:* optional at form 2 — a current copy missing them would restore as a phone with none.

### The happenings are named last, and read beside the others, never behind an undo

`readStores` opens the happening place after the birthday ticks and names it last: the newest store
last, as the ticks were. A save or restore in progress that cannot be undone still names three, and
the happenings are read on their own merits — the birthday precedent, and the carried take-out
scenarios pin exactly three.

### A restore writes the happenings fifth, and its places default beside the record

The fifth write is the happenings; `stoppingAfter: 5` stops with all five written. The new
parameters default to `happenings.json` beside the record place, unlike #329's `birthdayTicksAt:`,
so the five carried `RestoreInProgress.restore` call sites compile unedited.
- *Rejected:* no default — five carried call sites edited for no behaviour.

### Counts gain two fields, defaulted for the carried tests

`Counts(kept:stopped:oneOffs:)` stays callable, the two new counts defaulting to 0 — what a fresh
temporary happening place holds — so its ten carried constructions pass unedited.
- *Rejected:* happening counts on `AwaitingRestore` — the shell reads one value per side.

### A confirmed restore re-reads the happenings and awaits nothing about one

`confirmRestoring` calls `readHappenings()` and clears `happeningAwaitingStop`,
`happeningAwaitingDeletion` and `happeningNameTypedBack`: what awaited may no longer exist. The
happening refusal it holds is left to its own rule, which a restore does not name.

### Three requirements are removed and added back, not modified

`openspec validate` refuses a MODIFIED block that drops a scenario title, and four "writes no copy"
titles are false now, so their three requirements are REMOVED and ADDED back under new names.

### Migration

A copy at form 1 or 2 restores as no happenings (grill 3). A restore in progress written before this
change has no happening entry; its undo leaves the happening place as it stands. The copy place's
state file may now name `happenings`.

## Risks / Trade-offs

- **`DayScreen.returnedTo` reads the happening place before undoing a torn restore** → the torn
  restore scenario's last-but-one AND returns to a screen opened before the tear.
- **A happening change calls `keptAChange()` before its guard or on a refusal** → the refused and
  no-change scenario covers each of the five and the day screen's two.
- **`Copy.Store.allCases` in an undo guard names five** → the carried take-out scenario for a save
  in progress asserts exactly three, and the offer scenario's last AND covers a restore in progress.
- **Defaulting `Counts`' new fields to 0 hides a forgotten count** → both counts scenarios assert
  non-zero values on each side.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and writing the delta raised no question
that is the owner's: the order the happenings are named in, the confirmations a restore clears and
the reading beside a failed undo follow the birthday precedent or are facts of the code, each named
above where it is made.
