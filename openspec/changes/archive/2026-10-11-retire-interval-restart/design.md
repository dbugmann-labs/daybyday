## Context

See `proposal.md` § *Why*, and `grill.md`, whose four settled answers this delta is written on.
The facts it turns on, read off `origin/main` at 74c46ac:

- **Restart's whole surface** is `CommitmentsScreen.restart(_:from:)`, `Change.canRestart`,
  `RefusedChange.restarting`, three `Refusal` cases, `SheetField.restartDay`, and the sheet's
  *Restart* section in `CommitmentsView`, with its three refusal words. Nothing else calls them.
- **A restart wrote an ordinary era** through `Roster.put(era:on:keptUntil:under:)`; nothing on disk
  or in the model marks one. The mend joins neighbours only where `Schedule` is equal, and an
  every-N-days `Schedule` carries its start date, so a restart's two counts read back as two.
- **The dated `carryOver(_:to:onOrAfter:)`** in `History` and `RecordStore` have no caller.
- **Sixteen tests carry a restart scenario's title** — fifteen in `CommitmentsScreenTests`, one in
  `DayScreenTests` — and exactly one other test uses a restart member: *what a commitments screen
  tells on its sheet stands when another field is edited*, which passes `.restartDay`.
- **`openspec validate` refuses a MODIFIED block that drops or renames a scenario.**
- **A refused take-out is already held as a refused change** (`restore` spec, `RefusedChange
  .takingOut`), but the requirement that counts the kinds lists ten without it.

## Goals / Non-Goals

**Goals:** the delta, drivable through § *The seam*; the restart code and its tests gone; the walk.

**Non-Goals:** any replacement for the three cases ADR-1067 accepts; any change to the shift;
removing *A change that carries records leaves a save in progress…*, which `docs/open-questions.md`
says is owed (below); editing archived change folders or older ADRs that mention a restart.

## Decisions

### The seam

No member is new. These are driven, unchanged:

```swift
public func CommitmentsScreen.define(name: String, on rhythm: Rhythm, keptFrom: CalendarDate, under category: String?, kind: KindChoice, lowest: String, highest: String, target: String, usualAmounts: [TypedUsualAmount]) -> Refusal?
public func CommitmentsScreen.change(_ commitment: Commitment, toName name: String, on rhythm: Rhythm, keptFrom: CalendarDate, under category: String?, lowest: String?, highest: String?, target: String?, usualAmounts: [TypedUsualAmount]?) -> Refusal?
public private(set) var CommitmentsScreen.sheetRefusal: SheetRefusal?
public func CommitmentsScreen.sheetFieldEdited(_ field: SheetField)
public RosterStore.init(at place: URL) throws
public DayScreen.init(startingFrom dayOne: [Commitment], asOf today: CalendarDate, keepingRecordAt recordPlace: URL, keepingRosterAt rosterPlace: URL, keepingOneOffsAt oneOffPlace: URL)
```

These are removed:

```swift
public func CommitmentsScreen.restart(_ commitment: Commitment, from day: CalendarDate) -> Refusal?
public let CommitmentsScreen.Change.canRestart: Bool
case CommitmentsScreen.RefusedChange.restarting(Commitment, Refusal)
case CommitmentsScreen.Refusal.restartDayIsAfterToday, restartDayIsBeforeKeptFrom, alreadyDueOnRestartDay
case CommitmentsScreen.SheetField.restartDay
mutating func History.carryOver(_ commitment: Commitment, to changed: Commitment, onOrAfter day: CalendarDate) -> Bool
func RecordStore.carryOver(_ commitment: Commitment, to changed: Commitment, onOrAfter day: CalendarDate) throws -> Bool
```

### How each requirement is cut

Three requirements are restart's alone and are REMOVED. Four keep rules of their own but lose a
restart scenario, or rename one, so each is REMOVED and ADDED again under a new heading, every other
sentence and scenario verbatim. Three lose words only and are MODIFIED, as is `restore`'s copy rule.
- *MODIFIED with the scenario dropped:* rejected — refused by `openspec validate`.
- *The torn-save scenario left titled for a restart:* rejected — it would keep the word in the spec.

### No rule loses its last scenario

The restart scenario was the only one asserting that a refused ask replaces a sheet refusal, so it
becomes one asked by a definition and then a change. The restart scenarios were the only guard that
a restart's two counts stay two, which the grill's "restarts already made stay as made" needs, so
the mend gains one scenario; its prose already says "alike in schedule", and a schedule of every N
days names the day it starts on. Both pass on arrival; a mutation each shows they can fail
(`tasks.md` § 3).

### Ten kinds of refused change

Restarting leaves the list and taking out the files, already held as one, joins it, so the count
stays ten and is true again. Writing nine would make a count the requirement says is the only one
wrong by the kind it omitted. The naming rule for a take-out stays in `restore`.

### The save-in-progress requirement is MODIFIED, not REMOVED

`docs/open-questions.md` says the next `commitment` delta removes it, since no change writes a save
in progress any more. Its second scenario is the only guard that a change writes nothing at the
record place, so removing it here would drop a live rule unasked; it loses its restart words only.

### Migration

None. No persisted type or encoding changes, and eras a restart made are ordinary eras.

### What the shell draws

No layout question, from `designer` (`grill.md` § *Layout*), so there is no option and no wireframe.
The sheet of an every-N-days commitment ends at *Kept from*, as every other commitment's already
does, and nothing else on it moves. The walk is read against that.

## Risks / Trade-offs

- [A carried test other than the one named above turns red or stops compiling] → a stop and a
  report, never an edit.
- [Doc comments cite the four renamed headings and the removed ones] → updated in the same diff;
  `tasks.md` 4.1's case-blind grep for the word over both targets prints nothing.
- [*A commitments screen holds the change it refused* is 403 words and `restore`'s copy rule 158,
  both over before this delta] → `check:budgets` warns on the two; splitting them is not this Story.
- [A phone holding a torn save a restart left] → undone as any torn save is; the renamed scenario
  is that case.

## Open Questions

None. `grill.md` § *Left open* is "None.", and writing the delta raised no preference of the owner's:
the cut, the two kept guards, the count of ten and the save-in-progress requirement each follow from
a settled answer or a fact, and are recorded above as decisions G4 can overturn.
