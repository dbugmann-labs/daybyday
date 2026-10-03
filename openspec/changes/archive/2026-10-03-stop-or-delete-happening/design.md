## Context

See `proposal.md` § *Why*, and `grill.md`, whose thirteen settled answers this delta is written on.
The facts the shape turns on, read off this worktree at `origin/main` bcc0725:

- **`Happening` is an identity and a name**, equal by identity; `Happenings` holds `all` and
  `occurrences`, and its `==` compares both in order. Nothing anywhere holds a stop.
- **`HappeningDocument` writes form 2.** `formHappenings()` re-forms every happening through
  `Happenings.add` and then every occurrence through `Happenings.note`.
- **`CommitmentsScreen.happenings` is every happening held**, in order; `happeningRefusal` holds what
  the happening sheet tells. A commitment's stop and deletion are held in `awaitingConfirmation`,
  `awaitingDeletion` and `nameTypedBack`; each ask clears the other two, and `shown(asOf:)` clears
  the deletion and the name typed back, not the stop.
- **`DayScreen.happenings` is every happening held.** `offersNotingAHappening` and `note(...)` read
  it, and so does `occurrences(of:)`, which resolves a row's name against it.
- **The shell's Happenings card** gives a row a leading Edit swipe and nothing trailing, and has no
  footer; the day screen's bolt menu iterates `screen.happenings`.

## Goals / Non-Goals

**Goals:** stop, resume and delete a happening, every rule drivable through `Happenings`,
`HappeningStore`, `CommitmentsScreen` and `DayScreen`, and no change to how a commitment is stopped
or deleted beyond sharing the one confirmation slot.

**Non-Goals:** no stopped-from date (settled 6); no word about a stop in the look-back; no copy of
happenings (#380), so none of the three acts touches the copy place; no change to `ContentView`.

## Decisions

### The seam

```swift
public func isStopped(_ happening: Happening) -> Bool  // on Happenings
public mutating func stop(_ happening: Happening) -> Bool  // on Happenings
public mutating func resume(_ happening: Happening) -> Bool  // on Happenings
public mutating func delete(_ happening: Happening) -> Bool  // on Happenings
@discardableResult public func stop(_ happening: Happening) throws -> Bool  // on HappeningStore
@discardableResult public func resume(_ happening: Happening) throws -> Bool  // on HappeningStore
@discardableResult public func delete(_ happening: Happening) throws -> Bool  // on HappeningStore
public func isStopped(_ happening: Happening) -> Bool  // on CommitmentsScreen
public private(set) var happeningAwaitingStop: Happening?  // on CommitmentsScreen
public func askToStop(_ happening: Happening)  // on CommitmentsScreen
public func cancelStoppingHappening()  // on CommitmentsScreen
@discardableResult public func confirmStoppingHappening() -> Refusal?  // on CommitmentsScreen
@discardableResult public func resume(_ happening: Happening) -> Refusal?  // on CommitmentsScreen
public private(set) var happeningAwaitingDeletion: Happening?  // on CommitmentsScreen
public var happeningNameTypedBack: String  // on CommitmentsScreen
public var happeningNameTypedBackMatches: Bool { get }  // on CommitmentsScreen
public var happeningDeletionInWords: String? { get }  // on CommitmentsScreen
public func askToDelete(_ happening: Happening)  // on CommitmentsScreen
public func cancelDeletingHappening()  // on CommitmentsScreen
@discardableResult public func confirmDeletingHappening() -> Refusal?  // on CommitmentsScreen
```

`DayScreen` gains no member: `happenings` comes to mean the happenings not stopped, and
`occurrences(of:)` resolves a row against every happening held.

### A stop is held by `Happenings`, not by the happening

`Happenings` holds the identities stopped beside `all`, and `==` and `hash` take them in. A rename
keeps a stop because it keeps the identity, and the first requirement — a happening is a name and an
identity and nothing else — stands untouched.
- *Rejected:* a `stopped` field on `Happening` — it modifies that requirement and every site that
  forms one, for a fact only the collection acts on.

### A stopped happening takes no occurrence, so a stop is read last

`Happenings.note` refuses a stopped happening, so `formHappenings()` must apply the stops after the
occurrences, or a store holding a stopped happening's occurrences refuses to open. The store
scenario and the day screen's stopped-row scenario both round-trip exactly that.
- *Rejected:* refusing at the day screen alone — the store would then take what no screen offers.

### Migration

Form 3: a happening record gains `"stopped": true` where it is stopped, absent otherwise; deletion
needs nothing new. Forms 1 and 2 read as holding none stopped and are not rewritten on opening; the
first change writes form 3. A build that writes form 2 opening form 3 says the happenings were
written by a later version rather than dropping a stop. `currentVersion + 1` fixtures move with it.

### One confirmation awaits at a time, a happening's included

The four new members mirror the commitment's one for one, separately, so a commitment's
`nameTypedBackMatches` never reads a happening's name. Every ask of either kind clears the other
three slots and both names typed back; `shown(asOf:)` clears a happening's deletion and name typed
back, as it does a commitment's, and leaves a stop awaiting, as it does a commitment's.
- *Rejected:* one shared `nameTypedBack` — it modifies a shipped commitment requirement for no gain.

### A refused stop, resume or deletion is told in the Happenings card

It is held in `happeningRefusal`, whose lifetime the MODIFIED requirement extends; the shell draws it
as the card's footer while no happening sheet is open, in the sheet's own words for `.notKept`.
Only an unwritable place refuses, so `Refusal.notKept` is reused and nothing new is added.

### Words live where a commitment's do

`happeningDeletionInWords` is the Kit's, because it counts. The alert's title and buttons and the
row's "- Stopped" are the shell's, as a commitment's alert and "Stopped" heading are; the marker is
`commitmentLine(Text(name), rhythmInWords: "Stopped")`, the rhythm's slot and style.

### The shell

`CommitmentsView.swift` alone. A row not stopped swipes trailing to Stop (`stop.circle`, orange,
`askToStop`) and Delete (`trash`, red, `askToDelete`); a stopped one to Resume (`play.circle`,
accent, `resume`, no confirmation) and Delete; both keep the leading Edit and the tap to the
look-back. `.alert("Stop noting this happening?")` presents `happeningAwaitingStop` with a
destructive "Stop noting <name>" and "Cancel". The delete sheet copies the commitment's — title
"Delete <name>", header `Type "<name>" to delete it for good.`, a Name field bound to
`happeningNameTypedBack`, Delete disabled until it matches — with `happeningDeletionInWords` as its
footer and no copy line. Both rebuild the list on dismissal through `listRevision`.

### What the shell draws

Option B, *In place*, from https://claude.ai/artifact/1PukkaV1NRwFXQdzvnr95s.

```
B · In place
┌──────────────────────────────────┐
│ (<) Commitments        [⇅  +]    │
│  … kept groups, as on main …     │
│ Stopped                          │
│ │ Nothing has been stopped.    │ │
│ Happenings                       │
│ │ Augenmigräne               > │ │
│ │ Kopfweh - Stopped (ex)     > │ │
│ │ Schlecht geschlafen        > │ │
│ │ New happening                │ │
└──────────────────────────────────┘
 "- Stopped" sits in the rhythm's
 slot, caption size, secondary
 colour; resume removes the word.

Stop confirmation (.alert, as a commitment's)     Delete sheet (as a commitment's)
┌──────────────────────────────────┐              ┌──────────────────────────────────┐
│   <title> (ex)                   │              │ Cancel   Delete Kopfweh   Delete │  ← Delete disabled until
│   [ <stop button> (ex) ]  red    │              │ TYPE "KOPFWEH" TO DELETE IT FOR  │    the name matches
│   [ Cancel ]                     │              │ GOOD.                            │
└──────────────────────────────────┘              │ │ Name                         │ │
                                                  │ <occurrence count line> (ex)     │  ← footer: e.g. "Its 12
                                                  └──────────────────────────────────┘    occurrences go with it." /
                                                                                          none-case sentence
```

## Risks / Trade-offs

- **`formHappenings()` applies stops before occurrences**, and the phone's store stops opening the
  first time a stopped happening has an occurrence. → Two scenarios read exactly that back.
- **`occurrences(of:)` keeps resolving against the listed happenings**, and a stopped row opens
  nothing. → The stopped-row scenario asks the row for its occurrences.
- **A deletion filters occurrences by name rather than identity**, and a renamed happening's go
  astray. → Every kept deletion's scenario holds another happening's occurrence and asserts it
  survives.
- **Carried tests pinning form 2 as current.** → Measured: only `currentVersion + 1` fixtures and
  explicit form-1 and form-2 fixtures, all of which stay valid.

## Open Questions

None. `grill.md` § *Left open* is "None." for the owner, and how the store records a stop, which it
left to this delta, is § *Migration* above. Writing the delta raised nothing that needs the owner:
where a refused stop is told and how the confirmation slots share are the commitment's precedent
applied, not preferences. No residual round is outstanding.
