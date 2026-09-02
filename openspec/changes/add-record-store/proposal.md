## Why

`record` (#53) can say, since `add-tick-record` (#55) archived on 2026-09-02, whether the gym was
kept on a day — and forgets the answer the moment the app is closed, because nothing in the
repository has yet touched a disk. That is the product's one promise still unkept: DayByDay exists
because a record a few days old that cannot be reconstructed is the failure the owner abandoned
other apps over (`docs/open-questions.md` § *Settled*, 2026-08-29), and `CONTEXT.md` § *Record*
says durability is a property of the record itself. This is the second and last Story of #53: the
store where a history survives, and the decision — left open by ADR-1001 on purpose and carried in
`docs/open-questions.md` since — of where the record is kept.

It is worth its own Story rather than a paragraph in the first screen's, because the store is the
one thing in this repository that will outlive every rewrite around it: the form it writes today is
what a restore to a new phone (B-009), a commitment identity (B-014) and a second kind of record
(B-001..B-004) will each have to read first.

One question in it is a preference rather than a fact and goes to the owner as a question round:
where the record is kept — a file, SwiftData or GRDB. The folder is written on the recommended
answer, a file, and `design.md` § *Questions for you* says exactly what changes if he answers
otherwise.

## What Changes

- **Adds a store to the `record` capability**: a history kept at a place, opened by the app each
  time it starts, holding every tick added and not since taken back.
- **Fixes that a tick is kept the moment it is added, not when the app is closed.** There is no
  save step. iOS can stop the app without warning, and a tick waiting to be saved would be exactly
  the record the product promises not to lose. A change the store cannot keep is refused and not
  held, so what the store reports is never ahead of what is on disk.
- **Fixes that the store persists exactly what a tick is** — its commitment by value (name,
  schedule with payload, kept-from day) and its calendar date as year, month and day — and nothing
  it invented: no timestamp, no identity, no order. A tick read back is the same tick, for every
  schedule shape, any name and any date the system supports, and ADR-1004 holds on the way through
  the disk: no instant, time zone or locale is consulted.
- **Fixes that a store that cannot be read is refused rather than emptied.** Content that is not a
  store, a store written in a later form than this app knows, and a store holding what could not
  be a tick each refuse to open and are left byte-for-byte as found. The alternative — open empty
  and overwrite on the next tap — destroys the only copy of the record to keep the app usable.
- **Decides where the record is kept**, in ADR-1017: one JSON file, versioned, written whole and
  atomically on every change, at a place the app names. SwiftData and GRDB are declined with
  reasons and named as the reversal path. This is the question round's one question.
- Adds one public type and one error to `DayByDayKit`, `RecordStore` and `RecordStoreError`, in
  the same module as the engine. `Tick`, `History`, `Commitment`, `Schedule` and `CalendarDate` do
  not change and are not widened: the store reads their `internal` members, so the read-back #55
  expected this Story to export turns out not to be needed.
- **Not in this change:** where the app puts the file — the first app-target Story opens the store
  under `Library/Application Support/`, and `design.md` says why that directory; carrying a store
  to a new phone (B-009); storing commitments, or giving one an identity (B-014); any kind of record
  other than a tick (B-001..B-004); any aggregate over days (B-007); anything on screen, including
  what a person sees when the store refuses to open (#27); migrating a store, since none exists.

## Capabilities

### New Capabilities

None. The store is part of what a record is — `openspec/specs/record/spec.md`'s Purpose already
names it as "the store that makes it survive the app being closed", and `CONTEXT.md` § *Record*
makes durability a property of the record rather than of a store behind it — so it is two more
requirements on `record`, not a capability of its own. A `store` capability would put the thing
and its durability in different files for no reader's benefit.

### Modified Capabilities

- `record`: two ADDED requirements — *A store keeps a history at a place, across the app being
  closed and opened again* and *A store that cannot be read is refused rather than emptied* — with
  thirteen scenarios between them. No existing requirement is modified or removed: a tick and a
  history are exactly what #55 made them, and the store persists that shape. `commitment` and
  `schedule` are untouched. CI check 2 sees exactly one claimed capability.

## Impact

- **Code:** `src/DayByDayKit/Sources/DayByDayKit/` only. Two new files, `RecordStore.swift`
  (public) and `RecordDocument.swift` (internal, the versioned form on disk). No change to any
  existing source file, no change to `Package.swift` — no `platforms:` line, no dependency — and
  nothing new in the Node tooling.
- **Specs:** `openspec/specs/record/spec.md` gains the two requirements at archive time; nothing
  else under `openspec/specs/` moves.
- **Tests:** thirteen acceptance tests in a new `Tests/DayByDayKitTests/RecordStoreTests.swift`,
  one per scenario, taken one at a time, each on a fresh URL under the temporary directory. The
  existing ninety-seven are untouched and must stay green. This is the first test file in the
  repository that touches a disk; the macOS CI job already runs `swift test` and needs nothing new.
- **ADR:** `docs/adr/1017-records-are-kept-in-one-file.md`, proposed with this folder and accepted
  by the same G4 if question 1 goes as recommended — rewritten before G4, not superseded, if not.
  Numbered 1017 because 1015 and 1016 were taken on `main` while this folder was being written.
  `docs/adr/README.md` gains its row.
- **`CONTEXT.md`:** one term added by this grill, **Store**.
- **`docs/open-questions.md`:** three entries are affected, and none is this change's to write
  (`spec-author` may not touch that file). Under *Open technical decisions*, **SwiftData or GRDB**
  is answered by ADR-1017 and moves to *Settled* — as "neither, a file", with the reversal trigger
  the ADR names. Under *Known gaps*, **A schedule's payload cannot be read back out** stays as it
  is: this Story was expected to widen it and did not need to, so the gap is still the screen's.
  And one new *Known gap* is owed by this design: **the store must be opened under
  `Library/Application Support/`** by whichever Story creates the app target — `Caches/` is purged
  and `tmp/` is not backed up, and the package cannot enforce the choice from where it sits.
