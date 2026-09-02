## Context

`DayByDayKit` exports `Schedule.isDue(on:)`, `Commitment`, and — since `add-tick-record` (#55)
archived on 2026-09-02 — `Tick` and `History`: a tick is a commitment on a calendar date it is due
on and cannot be formed anywhere else, and a history is a value that holds ticks and answers
`isKept(_:on:)`. Every type in the package is a value over `CalendarDate` with no clock, no time
zone and no locale (ADR-1004), and nothing in the package survives the process. Motivation is in
`proposal.md`; the behaviour contract is in `specs/record/spec.md` and is not repeated here.

What is new is that this is the first thing in the repository that touches a disk. #55's design
left two things to this Story by name: choosing where the record is kept — the "SwiftData or GRDB"
decision ADR-1001 deliberately left open and `docs/open-questions.md` carries — and widening the
read-back that #55 declined to export because *what* a store needs depends on the store. The grill's
questions were about those two, about what "closed and opened again" has to survive, and about what
a store does with something it cannot read.

**Measured on this machine on 2026-09-02, rather than recalled.** The package's test run reports 97
tests passing on Apple Swift 6.3.3 in language mode 6 — 87 before `add-weekly-quota-schedule` (#11)
merged while this folder was being written, ten with it — which is the number `tasks.md` counts up
from. `Package.swift` declares no `platforms:`; the SDK on this machine is macOS 26.5, and
`SwiftData.ModelContainer` is declared `@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)` in
that SDK's own interface file, so adopting it would mean adding a `platforms:` line the package has
so far avoided. GRDB's README today names 7.11.1 and requires iOS 13 / macOS 10.15 / Swift 6.1 /
Xcode 16.3 — a third-party dependency where the package has none. Apple's *File System
Programming Guide* says `Documents/` and `Library/Application Support/` are backed up by default,
`Library/Caches/` is not and may be deleted when space is low, and `tmp/` is neither. The weekdays
the scenarios pin were checked in Foundation's `.gregorian` calendar under UTC — the calendar
`CalendarDate` uses — not trusted: 31 August 2026 is a Monday, 2 September a Wednesday, 5 September
a Saturday, 7 September a Monday, 25 September a Friday, 3 September a Thursday nine days after
25 August; 3 January 1583 and 27 December 9999 are both Mondays. ADR numbers 1015 and 1016 are
taken on `main` — Story #11's and the model-tier withdrawal — so the ADR this Story writes is 1017.

## Goals / Non-Goals

**Goals:**

- A history that survives the app being closed, backgrounded, killed by the system or crashing —
  not only a graceful quit. The store keeps every change as it is made, so there is no window in
  which a tick exists only in memory.
- One seam that a test drives with two store handles on a temporary location and no process, no
  global stream and no clock: what the app does at the second launch is what a second `RecordStore`
  opened at the same place does in a test.
- A form on disk that is a contract rather than an accident: versioned, human-readable, written by
  hand from the record's own vocabulary, and independent of how the Swift types happen to be laid
  out — so that the next kind of record, the next schedule shape and the eventual restore to a new
  phone (B-009) each have a place to start from.
- Honesty before availability. A store that cannot read what it finds says so and touches nothing.

**Non-Goals:**

- Choosing where the app puts the file. The store is opened *at* a place the caller names; the
  first app-target Story chooses `Library/Application Support/` (backed up, never purged) and this
  design says why, but no app target exists and this package does not know about containers.
- Carrying a store to a new phone. B-009 is a Story of its own; this design's only obligation to it
  is to leave one self-contained file that a backup carries whole, and it does.
- Storing commitments. Nothing lists commitments yet; the store persists ticks, and each tick
  carries its commitment by value because that is what a tick is. A commitment store, and the
  identity B-014 will need, are #26's Stories.
- Any kind of record other than a tick (B-001..B-004), any aggregate (B-007), anything on screen.
- Migrating an existing store. There is none: this is the first form, and version 1 is what it
  writes.
- Sharing one store between two writers at once. The app has one.

## Decisions

### The seam

**New: `RecordStore`, exported from `DayByDayKit` beside `History`.** One seam with four entry
points, all synchronous and all throwing where the disk can refuse:

```swift
public final class RecordStore {
    /// Opens the store kept at `place`, reading what is there. A place where nothing has been
    /// kept opens empty; a place holding something that cannot be read as a store throws.
    public init(at place: URL) throws

    /// Every tick added and not since taken back — exactly what is kept at `place`.
    public private(set) var history: History

    /// Kept at `place` before this returns; on failure throws and leaves `history` as it was.
    public func add(_ tick: Tick) throws
    public func remove(_ tick: Tick) throws
}

public enum RecordStoreError: Error, Equatable, Sendable {
    /// What is at `place` is not a store this app can read, or holds what could not be a tick.
    case notAStore(at: URL)
    /// A store in a form later than this app writes; `version` is the form found.
    case laterForm(at: URL, version: Int)
    /// The change could not be kept at `place`; nothing was held.
    case cannotWrite(at: URL)
}
```

Ten scenarios observe the store through `history` — its equality with a `History` built in the
test, and its `isKept(_:on:)` — and three observe the initializer's refusal plus the bytes at the
place, read back by the test with `Data(contentsOf:)`. A test's *place* is a fresh URL under
`FileManager.default.temporaryDirectory`, one per test, so tests are independent and need no
teardown to be correct. No process is spawned, no global stream is captured and no clock is read.

**`Tick`, `History`, `Commitment`, `Schedule` and `CalendarDate` do not move and are not widened.**
#55 expected this Story to export read-back of a tick's parts and a history's ticks; it does not
need to, because the store lives in the same module (below) and reads the `internal` members that
already exist. The public surface grows by exactly one type and one error. The read-back a *screen*
will need to render a rhythm is still `docs/open-questions.md` § *Known gaps* and still belongs to
the first Story that renders one.

**A class, not a struct.** Everything else in the engine is a value, and `History` stays one. A
store is the one thing here that is *not* a value: two handles on the same place are two views of
one file, and copying one would be a lie. It is not `Sendable` and does not try to be — whoever
owns it, a view model on the main actor eventually, owns it alone. `history` is a stored
`private(set)` value, replaced whole after each successful write, so a reader always sees a
history the disk agrees with.

**Synchronous and throwing.** The file is kilobytes; the write is one atomic call. An `async` seam
would cost every test a suspension point and every caller an actor hop to save a millisecond
nobody measures. If a screen ever stalls on it, that is the moment to measure, not now.

### Where the record is kept — a file, and an ADR

**Chosen: one JSON file at the place the store is opened at, written whole on every change.**
ADR-1017 carries the decision and the alternatives at length; the short form is that the record is
a set of pairs whose whole value fits in a few kilobytes for a decade of one person's days, that
`History` is already the value a file can hold, that a file needs nothing added to `Package.swift`
— no `platforms:` for SwiftData, no dependency for GRDB — and that a versioned text file is the
easiest possible thing to read, migrate, back up and debug. SwiftData and GRDB are both answers to
questions this Story does not ask: partial loads, queries, relationships, concurrency.

This is the one question in the grill that is a preference the owner holds — ADR-1001 named the
choice as his to make with a real requirement in hand — so it is also **question 1 under
`## Questions for you`**, and the whole folder is written on the recommended answer.

### The form on disk

**Chosen: a hand-written JSON document, versioned, in the record's own words.** Version 1 is:

```json
{
  "version": 1,
  "ticks": [
    {
      "commitment": {
        "name": "Gym",
        "keptFrom": { "year": 2026, "month": 1, "day": 1 },
        "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
      },
      "date": { "year": 2026, "month": 8, "day": 31 }
    }
  ]
}
```

A schedule is one of four objects, one per shape the engine has — all four exist since #11 merged on
2026-09-02: `{ "weekdays": [...] }` with the weekday names in the order of the week, Monday first,
so equal sets write equal text; `{ "dayOfMonth": 25 }`;
`{ "everyNDays": 3, "from": { "year": 2026, "month": 8, "day": 25 } }`; and
`{ "timesPerWeek": 3 }` for a weekly quota. The quota's number is stored and read back like any
other payload; that it does not enter `isDue(on:)` (ADR-1015) is the schedule's business, not the
store's.
A date is always the three integers, never a string, never an instant: there is nothing to parse
and no calendar or time zone on either side, which is how the store keeps ADR-1004 rather than
merely promising to. Ticks are written in a stable order — by commitment name, then kept-from day,
then date — so two equal histories produce byte-identical files, which makes a file diffable and a
backup comparable.

**Not synthesised `Codable` on the engine types.** Deriving `Codable` on `Schedule`, `Commitment`
and `Tick` would be five lines and would fix the file's shape to the Swift compiler's encoding of an
enum with payloads — `{"weekdays":{"_0":[...]}}` — which nobody has read, let alone signed, and
which changes the day a case is renamed. The document is an `internal` type of its own,
`RecordDocument`, that the store converts to and from; the engine types stay exactly what they are.
Decoding goes *through the failable initializers* — `CalendarDate.init?`, `DayOfMonth.init?`,
`DayInterval.init?`, `Commitment.init?`, `Tick.init?` — so every invariant the engine has applies to
what comes off the disk, and a stored pair that could not be a tick is refused for free rather than
by a second check.

**A fifth schedule shape, if one ever comes, is a compile error here, not a silent gap.** The
conversion is an exhaustive `switch` over `Schedule`, so a new case stops this file compiling until
the store can write and read it, which is the right failure. The scenario *ticks of commitments on
every schedule shape are read back as the same ticks* names one commitment per shape — four today —
and is the test that proves each payload round-trips, since no payload is public.

### Written whole, before the call returns

**Chosen: `add` and `remove` compute the next history, write the whole document with
`Data.write(to:options: .atomic)`, and only then replace `history`.** The atomic option writes to a
sibling temporary file and renames it over the old one, so the place holds either the previous
document or the next one at every instant, never a torn one; the system killing the app mid-write
loses the one change in flight and nothing before it. If the write throws, `history` is untouched
and the error is rethrown as `.cannotWrite(at:)` — the store never claims a tick the place does not
hold, which is what the scenario *a tick that cannot be kept is refused and not held* pins.

The first write creates the place's parent directory (`createDirectory(at:withIntermediate
Directories: true)`); a parent that cannot be created — the scenario's path beneath an ordinary
file — fails there and throws the same error. On opening, a place at which `fileExists(atPath:)`
is false is a store with nothing kept, whatever the reason the path does not resolve.

*Alternative — save on demand: a `save()` the app calls when it backgrounds.* Rejected on the
product's own promise. iOS gives an app no guarantee of a chance to save before it is killed, and a
crash gives none at all; a tick taken an hour ago that was never flushed is precisely "a record a
few days old that cannot be reconstructed". Writing a few kilobytes on every tap costs nothing a
person can notice and removes the whole class of failure.

*Alternative — append-only log of ticks and unticks.* Cheaper per write, and it would keep a
history of unticks, which `record`'s third requirement forbids: an untick is not a record of its
own. Rejected for that reason before performance came into it.

### What cannot be read is refused, and left where it is

**Chosen: opening a place that holds something the store cannot read throws and changes nothing.**
The alternative that every ORM and most apps take — open empty, and quietly overwrite on the next
change — would destroy the one copy of the record to keep the app usable, in a product whose only
reason to exist is that the record is kept. The store refuses the whole document rather than
skipping the bad rows for the same reason: a partial read followed by a write is the overwrite
wearing a smaller hat.

The version is read first, on its own, before the body is decoded: a document whose `version` is
above 1 is `.laterForm(at:version:)`, whatever else is in it, so a backup from a newer app onto an
older one is named for what it is rather than reported as garbage. Everything else that fails to
decode — not JSON, not this shape, a date that names no day, a commitment on a date it is not due
on — is `.notAStore(at:)`.

**Consequence for later Stories, stated so it is not discovered by a person locked out of the
app:** any change that alters what a commitment is due on — a rewrite of the short-month rule, a
change to the kept-from floor — can make ticks already on disk impossible to form and so make an
existing store unreadable. Such a Story owes a migration of stored ticks, in its own `design.md`,
and this is the line that tells it so.

### Inside `DayByDayKit`, not a second target

**Chosen: `RecordStore.swift` and `RecordDocument.swift` under `Sources/DayByDayKit/`.**
`CONTEXT.md` § *Rule engine* says the engine has no storage *under* it, and it still has none: the
store depends on the engine and nothing in the engine depends on the store. A second target
(`DayByDayStore`) would draw that line in the module graph too, at the price of exporting read-back
from `Tick`, `History`, `Commitment`, `DayOfMonth` and `DayInterval` now — a widening across the
`record` and `schedule` capabilities that #55 deliberately left unexported and that no screen has
asked for yet. One module and `internal` access is the smaller delta by a whole capability; if the
package ever splits, the store is the first thing to move and the widening comes with the Story
that needs it.

### A tick is stored by the value of its commitment

**Chosen: each stored tick carries its commitment whole — name, schedule, kept-from day.** A
commitment has no identity (`commitment`'s first requirement: alike in all three is the same), so
there is nothing else to key it on, and no store of commitments exists to reference. This means the
file repeats a commitment once per tick, which at a few hundred bytes a tick is the cost of nothing
invented; and it means what #55 already stated: a commitment renamed or re-rhythmed later is a
different value, and its old ticks stay with the old value. B-014 is where identity arrives, and the
migration from "commitment by value" to "commitment by id" is a one-pass rewrite of this file that
B-014's Story owes — this document's `version` field is what makes that pass safe to write.

## Risks / Trade-offs

- **The whole file is rewritten on every tap.** At one person's scale — eight commitments, a
  decade, under 30,000 ticks, a few megabytes at the outside and kilobytes for years — an atomic
  write is sub-millisecond on device storage. → Accepted, and named in ADR-1017 as the trigger for
  reversing it: if the write ever measurably stalls a tap, that is the day for a real database,
  and the versioned file is what it imports from.
- **A file can be edited by hand, or restored from a backup half-way.** → Refusal on anything
  unreadable, atomic writes, and a form that is readable enough to repair. A person with a text
  editor can fix a stored tick; nobody can fix a torn SQLite page.
- **Refusal locks the app out until someone acts.** A corrupt file means the app cannot open a
  store, and no screen exists yet to say so gracefully. → Deliberate, and the lesser harm; the app
  target's first Story decides what the screen shows. The alternative silently destroys the record.
- **A schedule-rule change can strand a store.** → Stated under § *What cannot be read is refused*
  as an obligation on that future Story, so it is found in a design review rather than on a phone.
- **`Package.swift` stays without `platforms:`**, and `CalendarDate` already notes that `.gmt` does
  not compile against the default deployment target. Everything this Story uses — `Data.write`,
  `FileManager`, `JSONEncoder`, `JSONDecoder`, `URL` — is older than that floor. → No change;
  the implementer confirms with `swift build` before the first test.
- **Tests write to the real filesystem.** → Under `temporaryDirectory` with a UUID per test, so
  they are independent, parallel-safe and leave nothing that matters behind; the macOS CI runner
  has the same directory.
- **Thirteen scenarios; most will pin.** The ones expected to drive are the first open, the first
  `add` (file appears), the first refusal on garbage, the version check, and the failed write
  leaving `history` untouched. → As on #42 and #55, `tasks.md` asks the implementer to record which
  ran red rather than trust the prediction.
- **#11 (`add-weekly-quota-schedule`) merged while this folder was being written.** The first
  draft of this design named it as a risk; the rebase onto `main` made it a fact, and the folder
  was updated before G4 rather than after: a fourth object form on disk, a fourth commitment in the
  every-shape scenario, ten more tests in the count. → Absorbed. It was never a spec collision —
  this delta claims `record` only, #11's claimed `schedule` only — and `docs/adr/README.md` was the
  one file both touched, resolved by keeping both rows.

## Migration Plan

None. No store exists anywhere, so version 1 is the first form and nothing is migrated to it. The
delta claims only `record`, which is ADDED requirements on an existing capability, so CI check 2
sees exactly one claimed capability and `openspec/specs/record/spec.md` grows two requirements at
archive time. `docs/open-questions.md` is not this change's to edit; `proposal.md` § *Impact* flags
the entries for its owner.

## Open Questions

None. One question is a preference rather than a fact and is put to the owner under
`## Questions for you`; the folder is written on its recommended answer, and it moves here, marked
settled, when the answer comes back. Everything else the grill turned up was a fact, and is closed
here or in the delta:

- *Where the record is kept — SwiftData, GRDB or a file?* Recommended a file; **question 1 below**,
  because ADR-1001 named it as the owner's to decide with a requirement in hand. ADR-1017 carries
  the argument.
- *Is a tick kept when it is added, or when the app is closed?* When it is added. iOS can kill the
  app without warning, and the product's promise is the record; the first requirement says so and
  the write-through is § *Written whole, before the call returns*.
- *What does "the same place" mean?* A location the caller names when it opens the store; the
  engine does not know about app containers. The app target's first Story must open it under
  `Library/Application Support/`, which Apple's guide says is backed up by default and never
  purged — not `Caches/`, not `tmp/`. § *Goals / Non-Goals*, and flagged for `docs/open-questions.md`.
- *What is persisted for a tick?* Its commitment by value — name, schedule with payload, kept-from
  day — and its date as three integers. Nothing else: no timestamp, no id, no order. The first
  requirement says it, § *The form on disk* fixes it.
- *Does this Story need a commitment identity?* No; a commitment has none by requirement and
  nothing stores commitments yet. § *A tick is stored by the value of its commitment*, and the
  consequence for B-014 is written there.
- *Unreadable store: refuse, or open empty?* Refuse, whole, and touch nothing. The second
  requirement and § *What cannot be read is refused*.
- *A stored tick that could not be formed — drop it, or refuse the store?* Refuse the store;
  dropping is a silent loss. One scenario pins it, and the obligation it puts on future rule
  changes is written down.
- *A store from a later version of the app?* Refused and named as such — a backup restored onto an
  older app is the case. One scenario.
- *Atomicity: can a kill mid-write lose what was already kept?* No: `.atomic` renames a complete
  file over the old one. Not a scenario, because a test cannot interrupt a write at the seam; a
  design decision the review checks for.
- *Does the store widen `Tick`, `History` or the schedule payloads?* No — same module, `internal`
  access. § *Inside `DayByDayKit`*. The screen's read-back stays the known gap it was.
- *Does the store need to enumerate ticks, or answer `isKept` itself?* Neither; it hands out a
  `History`, which already answers. Fewer members, one seam.
- *What about #11's fourth schedule shape?* It landed during the write and the folder absorbed it:
  a fourth object form and a fourth commitment in the every-shape scenario. § *Risks*. A fifth is a
  compile error in the exhaustive switch until the form has it.
- *Two stores at one place at once?* The app holds one; the second-handle scenarios open the second
  *after* the write. Last writer wins and nothing here pretends otherwise.
- *Does restore to a new phone (B-009) need anything now?* Only that the store is one file at one
  place, which it is. Everything else is B-009's.

## Questions for you

1. **Where the record is kept.** ADR-1001 left this to the first Story that persists a tick: it named
   SwiftData as "adequate for a data set this small" and GRDB as "the escape hatch". Having the
   requirement in hand, I recommend neither: **one JSON file, written whole and atomically on every
   tick, at a place the app names** — ADR-1017 has the full argument. The record is a set of
   (commitment, date) pairs that fits in kilobytes for years and is already a value (`History`);
   a file needs no `platforms:` line, no dependency, no macros, no schema tooling, and it is the
   form a person can read, repair and back up. SwiftData would add a class-based `@Model` mirror
   of every engine type and a macOS 14 / iOS 17 floor; GRDB would add a third-party package and
   SQL for a set of pairs. Both remain one import away if a write ever stalls a tap.
   - *Recommended:* a file, as written. The one real reason to say otherwise is if you want this
     Story to be where you learn SwiftData; that is a legitimate preference and it is yours.
   - *If you say SwiftData or GRDB:* the two requirements and ten of the thirteen scenarios stand
     as they are — they describe a store, not a file. The three refusal scenarios are rewritten to
     the chosen store's notion of "a later form" and "not a store" (a schema version and a
     corrupt database); `design.md` §§ *The form on disk*, *Written whole* and *Inside
     `DayByDayKit`* are replaced; `Package.swift` gains `platforms:` (SwiftData) or a dependency
     (GRDB); `tasks.md` is rewritten; ADR-1017 is rewritten before G4 rather than superseded, since
     it will not have been accepted. The seam's shape — `init(at:)`, `history`, `add`, `remove` —
     does not change.
