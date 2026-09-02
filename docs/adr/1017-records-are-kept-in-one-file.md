# 1017. Records are kept in one file, written whole on every change

- Status: proposed — accepted by the G4 approval of `add-record-store` (#56) if its question round
  settles on this answer; rewritten before that gate, not superseded, if it does not
- Date: 2026-09-02
- Deciders: Diego Bugmann

## Context

ADR-1001 chose Swift and SwiftUI and deliberately left persistence open: "SwiftData looks adequate
for a data set this small and GRDB is the escape hatch if it is not. Nothing here commits to
either." It said the choice was cheaper to make with a real requirement in hand, and
`docs/open-questions.md` has carried it since as *SwiftData or GRDB*, to be decided by "the Story
that first persists a tick".

`add-record-store` (#56) is that Story, and the requirement in hand is narrower than the question
assumed. What has to be kept is a **history** as `add-tick-record` (#55) defined it: a set of ticks,
each a commitment by value and a calendar date, with at most one per commitment per day, equal to
any other history holding the same ticks. It is already a value type in `DayByDayKit`. It is small:
the owner's own week is eight commitments, and a decade of them is under thirty thousand ticks —
kilobytes for years, a few megabytes at the outside. Nothing queries it: every reader asks *was this
commitment kept on this date*, and the history answers from memory. Nothing shares it: one app, one
person, one writer. And the product's promise about it is unusually specific — a record a few days
old that cannot be reconstructed is the failure being solved, and `CONTEXT.md` § *Restore, not
sync* wants history to survive a new phone by restore, never by live synchronisation.

Two facts about the platform, verified on this machine on 2026-09-02: `SwiftData.ModelContainer` is
`@available(macOS 14, iOS 17, …)` in the installed SDK's own interface, and `Package.swift` declares
no `platforms:` at all today; GRDB 7.11.1 requires iOS 13 / macOS 10.15 and is a third-party
dependency where the package has none. Apple's *File System Programming Guide* says
`Library/Application Support/` is backed up by default and never purged by the system, while
`Library/Caches/` is not backed up and may be deleted under disk pressure.

## Decision

**The record is kept in one JSON file, at a place the app names, written whole and atomically on
every change.** Four things are part of the decision rather than incidental to it:

- **The file is a contract, not an encoding.** Its form is written by hand from the record's own
  vocabulary — a version number and a list of ticks, each its commitment (name, schedule as one of
  a named set of shapes, kept-from day) and its date, every date as three integers — and it is
  fixed in the change's `design.md`. It is not the compiler's synthesised `Codable` of the Swift
  types, which nobody has read and which changes whenever a case is renamed. The engine's types stay
  exactly what they are; an internal document type converts to and from them.
- **Every change is written before it is reported.** A tick added or taken back is on disk before
  the call returns, by an atomic rename over the previous file, so the app being killed at any
  instant loses at most the one change in flight and never the file. There is no save step for a
  screen to forget.
- **What cannot be read is refused whole, and left where it is.** A file that is not a store, a
  file in a later form than the app knows, or a file holding a tick that could not be formed,
  refuses to open and is not touched. The app being unable to open is a failure the product can
  survive; the record silently replaced by an empty one is the failure it exists to remove.
- **The version field is what makes every later change to the form safe** — a second kind of
  record, a commitment identity, a fifth schedule shape — and is why a text file rather than a
  database is the *more* future-proof choice at this size, not the less: the successor reads
  version 1 once and writes its own.

## Consequences

- **Nothing is added to `Package.swift`** — no platform floor, no dependency, no macro — and
  nothing is added to the owner's learning curve beyond `FileManager` and `JSONEncoder`. At four to
  eight hours a week, that is the largest saving on the table, and ADR-1001 already named the
  language itself as the whole price of the platform.
- **The whole file is rewritten on every tap.** Sub-millisecond at this size on device storage,
  and the design says so; **the trigger for reversing this decision is a tap that measurably stalls
  on the write**, which at the owner's scale is not expected in the app's lifetime. If it comes,
  the file is what the database imports from, and the seam — open at a place, `history`, `add`,
  `remove` — does not change shape.
- **Restore to a new phone (B-009) is one file in a backed-up directory.** The app target's first
  Story must open the store under `Library/Application Support/`; that obligation is recorded in
  `docs/open-questions.md` because the package cannot enforce the choice from where it sits. iCloud
  and Finder backups then carry the record whole, which is the entire mechanism *restore, not sync*
  asks for. Live sync stays out, by principle and by the absence of anything that could do it.
- **A person can read and repair the record with a text editor.** No tool in this repository can
  repair a torn SQLite page or a SwiftData store; the form is deliberately one a human can fix on
  the day it matters.
- **Any Story that changes what a commitment is due on owes a migration of stored ticks**, because
  a stored pair that no longer forms a tick makes the whole store unreadable by the third point
  above. The design says this in as many words so it is met in a review rather than on a phone.
- **A commitment is stored by value once per tick.** There is no identity to reference and no
  commitment store to reference into. When B-014 brings identity, the migration is a one-pass
  rewrite of a version-1 file, which the version field exists to make trivial.

## Alternatives considered

**SwiftData** — the answer ADR-1001 expected, and the one a Swift developer would reach for first.
Rejected on fit rather than maturity: it wants a `@Model` class per stored thing, which means a
mutable, identity-bearing mirror of `Commitment`, `Schedule` and `Tick` beside the value types the
engine is built from, with the payload enum stored as a transformable or flattened by hand — a
second model to keep in step with the first, for a record that is a set of pairs. It raises the
package floor to macOS 14 / iOS 17, puts a `ModelContainer` and a context between every test and
the seam, and its store is a SQLite file nobody can read or repair. Its strengths — partial
loading, queries, relationships, CloudKit sync — are things this record does not need and one of
which, sync, the product rules out. Remains the natural reversal if the file ever stalls a tap.

**GRDB** — SQLite done well, with value types and a `Codable` bridge that would have fit the engine
better than SwiftData. Rejected because it is a third-party dependency, the package's first, for
which the whole use would be one table of pairs written and read whole; SQL buys nothing over a
sorted list at this size, and a dependency is a maintenance line for the life of the app. The
escape hatch ADR-1001 named it as, and it still is.

**Core Data** — SwiftData's predecessor, with the same object-graph shape and more ceremony.
Rejected for every reason SwiftData was, plus Objective-C-era API in a Swift 6 package.

**`UserDefaults`** — one `Data` blob under a key, and it would have worked for years. Rejected
because it is not a place: it cannot be pointed at a directory for a test, it cannot be named as
one file a backup carries, and the record would live in a plist beside the app's settings, which is
where things get cleared by hand. The store needs a place the caller names; a file is that.

**Synthesised `Codable` on the engine types, written to a file** — the same decision with five
lines instead of one document type. Rejected because the file's form would then be an accident of
enum layout — `{"weekdays":{"_0":[...]}}` — unversioned and changed by any rename, and the whole
value of a file over a database is that its form is something a person signed and can read.

**Append-only log of ticks and unticks** — cheapest possible write. Rejected because it keeps a
record of unticks, which `record`'s third requirement forbids: an untick is not a record of its
own, and a log that remembers it is.
