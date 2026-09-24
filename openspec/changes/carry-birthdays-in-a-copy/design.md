## Context

See `proposal.md` § *Why*, and `grill.md`, whose eight settled answers this delta is written on.
The facts the shape turns on, read off this worktree:

- **A copy is `Copy`, written as `CopyDocument` at form 1**, nesting the record, roster and one-off
  documents. `CopyDocument.read` checks the envelopes of the nested stores before the whole, so a
  later form outranks damage. `Copy.Store` is `record`, `roster`, `oneOffs`.
- **One reading serves every surface**: `CopyPlace.readStores` answers what is not read, and why, for
  the refused copy, the take-out offer, the restore sheet's `unreadable` and the copy place's stop.
  Where a save or restore in progress cannot be undone it names `Copy.Store.allCases`.
- **`RestoreInProgress` snapshots three places and the save in progress**, writes record, roster,
  one-offs in that order, and `stoppingAfter:` is the test seam for a torn restore.
- **The birthday place is `birthday-ticks.json` beside the other three** (#328); `DayScreen` takes it
  as a `URL` defaulting to that real file. `CommitmentsScreen` and `CopyPlace` know no birthday place.
- **Every existing restore, copy and take-out test passes a fresh temporary directory for the three
  places and none for a fourth**; 31 of them confirm a restore.
- **`DayScreen.tick(_: DayView.BirthdayRow)` writes no copy** — #328's Non-Goal, handed to this Story.
- **Carried copy fixtures are hand-built at form 1** with no birthday ticks (`copyJSON` in
  `RestoreTests` and `CopyPlaceTests`).

## Goals / Non-Goals

**Goals:** the fourth store carried through the one reading every surface already shares, so each
surface gains a case rather than a path; every existing test carried unedited.

**Non-Goals:** no change to the birthday switch, which a copy holds nothing of; no count of birthday
ticks anywhere; no ADR — the one decision that outlives the Story (the default place) is small and
reversible, and recorded here.

## Decisions

### The seam

```swift
public let birthdayTicks: BirthdayTicks                                          // Copy
public init(moment: Moment, history: History, roster: Roster, oneOffs: OneOffs, birthdayTicks: BirthdayTicks = BirthdayTicks())   // Copy
public enum Store: Hashable, Sendable, CaseIterable { case record, roster, oneOffs, birthdayTicks }   // Copy
public init(asOf today: CalendarDate, keepingRosterAt place: URL = CommitmentsScreen.rosterPlace, keepingRecordAt recordPlace: URL = DayScreen.recordPlace, keepingOneOffsAt oneOffPlace: URL = DayScreen.oneOffPlace, keepingBirthdayTicksAt birthdayPlace: URL? = nil, copyingTo copyPlace: CopyPlace? = nil)   // CommitmentsScreen
public init(at place: URL = CopyPlace.place, keepingRecordAt recordPlace: URL = DayScreen.recordPlace, keepingRosterAt rosterPlace: URL = DayScreen.rosterPlace, keepingOneOffsAt oneOffPlace: URL = DayScreen.oneOffPlace, keepingBirthdayTicksAt birthdayPlace: URL? = nil, asking momentNow: @escaping @Sendable () -> Moment?)   // CopyPlace
public init(startingFrom dayOne: [Commitment], asOf today: CalendarDate, keepingRecordAt recordPlace: URL = DayScreen.recordPlace, keepingRosterAt rosterPlace: URL = DayScreen.rosterPlace, keepingOneOffsAt oneOffPlace: URL = DayScreen.oneOffPlace, keepingBirthdayTicksAt birthdayPlace: URL? = nil, readingBirthdaysFrom calendar: BirthdayCalendar? = nil, whileOn birthdaySwitch: BirthdaySwitch? = nil, copyingTo copyPlace: CopyPlace? = nil)   // DayScreen
static func birthdayPlace(besideRecordAt recordPlace: URL) -> URL                // DayScreen, internal
static func restore(_ copy: Copy, recordAt recordPlace: URL, rosterAt rosterPlace: URL, oneOffsAt oneOffPlace: URL, birthdayTicksAt birthdayPlace: URL, stoppingAfter writes: Int? = nil) throws   // RestoreInProgress, internal
```

`CommitmentsScreen.Counts`, `AwaitingRestore`, `StoreNotRead` and `CopyPlace.Stop` keep their shape;
each carries `.birthdayTicks` where a store is named. `StopRecord` persists it as `"birthdayTicks"`.

### A birthday place not given is the one beside the record place

Every screen given no birthday place keeps its ticks at `birthday-ticks.json` beside its record place,
which is `DayScreen.birthdayPlace` in the app. Defaulting the two new parameters to that real file
would have 31 carried tests confirm a restore into the developer's own Application Support, and every
carried copy read it; and a torn restore undone by a day screen at the real file while the commitments
screen snapshotted a temporary one would delete it. So `DayScreen`'s default moves too, with the
static unchanged; a passed URL still compiles as `URL?`.
- *Rejected:* default to `DayScreen.birthdayPlace` — the isolation failure above.
- *Rejected:* no parameter, always beside the record place — new tests need an unwritable ticks
  place beside a writable record.

### The copy's form moves to 2, and form 1 holds no ticks

`CopyDocument` gains `birthdayTicks` and `currentVersion` becomes 2. Reading a form-1 document
yields no ticks; a form-2 document without them is damaged; the ticks' own envelope joins the
later-version pre-check. A form-1 app reading a form-2 copy refuses it as from a later version.
- *Rejected:* an optional field at form 1 — a current copy missing its ticks would read as a phone
  with none, which grill 4 refuses ("whole or not at all").

### The birthday ticks are read beside the three, never behind an undo

`readStores` opens the birthday place after the one-offs, naming it last. A save or restore in
progress that cannot be undone names the three it names today and leaves the birthday place read on
its own merits: the ticks file is written atomically, and the carried take-out scenario pins exactly
three. `form` refuses on the first of four, so a record outranks the ticks.

### A restore writes the ticks last, and snapshots them

`RestoreInProgress` gains the birthday bytes; the fourth write is the ticks; `stoppingAfter: 4` stops
with all four written. Every restore undo a day screen runs passes its own birthday place.

### Migration

A copy written at form 1 restores as no ticks (grill 2). A restore in progress written before this
change has no birthday entry; its undo leaves the birthday place as it stands, so absent and "nothing
stood there" are told apart in decoding. The copy place's state file may now name `birthdayTicks`.

### The shell

`CommitmentsView.swift` gains one line wherever a store is named, after the one-offs': *Your birthday
ticks could not be read.* and *Your birthday ticks were written by a newer version of DayByDay.* on a
refused copy and the take-out's causes; *The birthday ticks could not be taken out.*; the restore
sheet's *Your phone* line *Your birthday ticks could not be read.*; the stop's *your birthday ticks
could not be read* and *your birthday ticks were written by a newer version of DayByDay*.
`ContentView.swift` is unchanged: its restore line reads `saysACopyCanBeRestored`.

### Renamed or added beside, never grown past 150

The take-out's definition is renamed to four places. The copy-on-every-change requirement is at 159
words, so a birthday tick's copy is a requirement of its own; the restore rules for the ticks are
ADDED beside the three-place ones rather than widening requirements already near 150.

## Risks / Trade-offs

- **`Copy.Store.allCases` in the torn-undo guard names four.** → The carried take-out scenario for
  a save in progress asserts exactly three, and a new one covers a restore in progress.
- **The birthday tick forgets `keptAChange()`, or calls it on a refused tick.** → Two scenarios.
- **Decoding a form-1 copy through a non-optional field fails it as damaged.** → The earlier-form
  scenario restores one.
- **A day screen returned to after a restore keeps its stale birthday store.** → A day-screen scenario.
- **#340 `put-done-one-offs-last` is open and moves the one-off store's form, which a copy nests.**
  → Whichever merges second rebases; a conflict in this folder or `openspec/specs/` is a stop.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason. Writing the delta raised no question that
is the owner's: the default place, the copy's form and the order after the one-offs are facts or
follow the designer's finding, and each is named above where it is made.
