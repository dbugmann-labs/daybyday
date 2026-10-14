## Context

See `proposal.md` § *Why* and `grill.md` § *Settled*. Facts read off this worktree:

- **A copy is `Copy`, written as `CopyDocument` at form 3**, nesting five store documents.
  `CopyDocument.read` checks the nested envelopes before the whole, so a later form outranks damage.
  `Copy.Store` is `record`, `roster`, `oneOffs`, `birthdayTicks`, `happenings`.
- **`CopyPlace.readStores` is the one reading** behind a refused copy, the take-out offer, the
  restore sheet and the copy place's stop, and never opens the present-idea place.
- **`RestoreInProgress` snapshots five places and the save in progress**, the newer two in an
  optional `PlaceSnapshot` so an older file is told apart; `stoppingAfter: 5` stops with five written.
- **The present-idea store writes `PresentIdeaDocument` form 2** at `present-ideas.json` and reads 1
  and 2; its validation lives in `PresentIdeaStore.init(at:)`, with no `formed(from:)`.
- **`BirthdaysScreen.presentIdeaPlace` is `present-ideas.json` beside `DayScreen.recordPlace`.**
  `ContentView` builds a fresh Birthdays screen on every way in, from a commitments screen, and
  hands it no copy place; it reads only its own place and never undoes a torn restore.
- **`BirthdaysScreen.markIdea` reports a mark already so as kept** though the store answers `false`;
  **`StopRecord` reads an unknown store name back as `record`.**
- **Carried tests build `CommitmentsScreen.Counts` memberwise**, and `CopyTests` and `TakeOutTests`
  each switch exhaustively over `Copy.Store` in a `laterFormBytes` helper.

## Goals / Non-Goals

**Goals:** the sixth store carried through the one reading every surface shares, so each surface
gains a case rather than a path; every carried test unedited but the two helpers `tasks.md` § 9 names.

**Non-Goals:** no given/not-given split in the count and no change to the day screen's restore line
(grill 1, 7); no restore line on a person's page (grill 8); no ADR — each decision below is small,
reversible and follows #329 and #380.

## Decisions

### The seam

```swift
public let presentIdeas: [String: [PresentIdea]]                                  // Copy
public init(moment: Moment, history: History, roster: Roster, oneOffs: OneOffs, birthdayTicks: BirthdayTicks = BirthdayTicks(), happenings: Happenings = Happenings(), presentIdeas: [String: [PresentIdea]] = [:])   // Copy
public enum Store: Hashable, Sendable, CaseIterable { case record, roster, oneOffs, birthdayTicks, happenings, presentIdeas }   // Copy
public let presentIdeas: Int?                                                     // CommitmentsScreen.Counts
init(kept: Int?, stopped: Int?, oneOffs: Int?, happenings: Int? = 0, stoppedHappenings: Int? = 0, presentIdeas: Int? = 0)   // CommitmentsScreen.Counts, internal
public init(asOf today: CalendarDate, keepingRosterAt place: URL = CommitmentsScreen.rosterPlace, keepingRecordAt recordPlace: URL = DayScreen.recordPlace, keepingOneOffsAt oneOffPlace: URL = DayScreen.oneOffPlace, keepingBirthdayTicksAt birthdayPlace: URL? = nil, keepingHappeningsAt happeningPlace: URL? = nil, keepingPresentIdeasAt presentIdeaPlace: URL? = nil, whileOn birthdaySwitch: BirthdaySwitch? = nil, copyingTo copyPlace: CopyPlace? = nil)   // CommitmentsScreen
public init(at place: URL = CopyPlace.place, keepingRecordAt recordPlace: URL = DayScreen.recordPlace, keepingRosterAt rosterPlace: URL = DayScreen.rosterPlace, keepingOneOffsAt oneOffPlace: URL = DayScreen.oneOffPlace, keepingBirthdayTicksAt birthdayPlace: URL? = nil, keepingHappeningsAt happeningPlace: URL? = nil, keepingPresentIdeasAt presentIdeaPlace: URL? = nil, asking momentNow: @escaping @Sendable () -> Moment?)   // CopyPlace
public init(asOf today: CalendarDate, readingBirthdaysFrom calendar: BirthdayCalendar, whileOn birthdaySwitch: BirthdaySwitch, keepingPresentIdeasAt ideaPlace: URL, copyingTo copyPlace: CopyPlace? = nil)   // BirthdaysScreen
public var saysACopyCanBeRestored: Bool                                           // BirthdaysScreen
nonisolated static func presentIdeaPlace(besideRecordAt recordPlace: URL) -> URL  // DayScreen, internal
static func formed(from document: PresentIdeaDocument) -> [String: [PresentIdea]]?   // PresentIdeaStore, internal
var all: [String: [PresentIdea]]                                                  // PresentIdeaStore, internal
static func restore(_ copy: Copy, recordAt recordPlace: URL, rosterAt rosterPlace: URL, oneOffsAt oneOffPlace: URL, birthdayTicksAt birthdayPlace: URL, happeningsAt happeningPlace: URL? = nil, presentIdeasAt presentIdeaPlace: URL? = nil, stoppingAfter writes: Int? = nil) throws   // RestoreInProgress, internal
static func undoTornRestore(recordAt recordPlace: URL, rosterAt rosterPlace: URL, oneOffsAt oneOffPlace: URL, birthdayTicksAt birthdayPlace: URL, happeningsAt happeningPlace: URL? = nil, presentIdeasAt presentIdeaPlace: URL? = nil) -> Bool   // RestoreInProgress, internal
```

Acceptance tests attach at members that exist: `CommitmentsScreen`'s `makeACopy`, `askToRestore`,
`confirmRestoring`, `takeOut` and `storesNotRead`; `BirthdaysScreen`'s `addIdea`, `changeIdea`,
`markIdea`, `askToDeleteIdea`, `confirmDeletingIdea` and `shown`; `DayScreen`; `CopyPlace`.
`StopRecord` persists the new case as `"presentIdeas"`; `AwaitingRestore`, `StoreNotRead` and
`CopyPlace.Stop` keep their shape.

### What the shell draws

No layout question, from `designer` (`grill.md` § *Layout*): no option and no wireframe. Each
surface gains one line in a slot it already has, as § *Layout* describes; the walk is read against it.

### The shell's words

`SettingsView.swift`: each restore-sheet side's last line, after the happenings', is *N present
idea(s)*, or *Your present ideas could not be read.* for either cause. Wherever a store is named,
after the happenings': *Your present ideas could not be read.*, *Your present ideas were written by
a newer version of DayByDay.*, *The present ideas could not be taken out.*, and the stop's lower-case
pair. `BirthdaysView.swift`: *A copy can be restored from Settings*, caption and secondary grey,
under *The present ideas could not be read.*, which keeps its size. `PresentIdeasView.swift` is
unchanged; `ContentView.swift` only hands its one copy place to the Birthdays screen.

### The present ideas are the store's own shape, not a new type

`Copy` holds `[String: [PresentIdea]]`, the dictionary `PresentIdeaStore` already holds.
- *Rejected:* a `PresentIdeas` value — a second definition of the same thing, carrying no rule.

### The copy's form moves to 4, and forms 1 to 3 hold no present ideas

`CopyDocument` gains an optional `presentIdeas`; `currentVersion` becomes 4. Below 4 it reads as
none; at 4 a missing or unformable one is damaged, and its envelope joins the later-version
pre-check. `PresentIdeaStore.formed(from:)` is lifted out of `init(at:)`, so the store and the copy
refuse alike, a contact held twice included.

### The present ideas are named last, and read beside the others, never behind an undo

`readStores` opens the present-idea place after the happenings and names it last, the newest store
last; a save or restore in progress that cannot be undone still names three, and the present ideas
are read on their own merits — the birthday and happening precedent.

### A restore writes the present ideas sixth, and a day screen gains no place

`stoppingAfter: 6` stops with all six written. The new parameters default to `present-ideas.json`
beside the record place, so the six carried call sites compile unedited, and `DayScreen` undoes a
torn restore there without a parameter of its own: in the app that file is
`BirthdaysScreen.presentIdeaPlace`, and a day screen reads nothing else of present ideas.
- *Rejected:* a `keepingPresentIdeasAt:` on `DayScreen` — a place it would hold for the undo alone.

### The Birthdays screen writes a copy, and undoes nothing

It calls `copyPlace?.keptAChange()` only after a change the store answers `true` to. It undoes no
torn restore: it is reached only through a commitments screen, which opens the places first.
- *Rejected:* reading through `readStores` — five places a Birthdays screen has no other use for.

### Counts gain one field, defaulted to 0 for the carried tests' memberwise calls

One number, given and not given together (grill 1); 0 is what a fresh temporary place holds.

### Migration

A copy at form 1, 2 or 3 restores as no present ideas (grill 4). A restore in progress written before
this change has no present-idea entry; its undo leaves that place as it stands. The copy place's
state file may now name `presentIdeas`, which an older build reads back as the record's stop.

## Risks / Trade-offs

- **`markIdea` writes a copy on a mark already so** → the refused scenario marks one not given.
- **`Copy.Store.allCases` in an undo guard names six** → the take-out offer scenario's last AND pins
  three plus the present ideas only where they cannot be read.
- **Defaulting `Counts.presentIdeas` to 0 hides a forgotten count** → the counts scenario asserts
  three against four.
- **A present-idea place given to a commitments screen but not beside its record** is undone by a
  day screen at the place beside its record → in the app the two are one file; tests give none.
- **The count is gated on the switch** → two scenarios hand a commitments screen a switch that is off.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and writing the delta raised no question
that is the owner's: the order of naming, the place a day screen undoes at and what a mark already so
writes follow the #329 and #380 precedent or are facts of the code, each recorded above.
