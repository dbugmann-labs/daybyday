## Why

`Roster` shipped with `add-commitment-roster` (#101) and grew a kept-until day with
`add-roster-retirement` (#102), and **nothing in `src/` has ever constructed one.** The screen a
person actually looks at draws its eight commitments from a `private let dayOneCommitments` literal
in `src/DayByDay/ContentView.swift`, handed straight to `DayScreen(of:asOf:keeping:)`. So the
commitments you keep are not kept at all: they are a constant compiled into the app, they cannot be
added to, and the day a commitment was stopped — the thing #102 exists to hold — survives nothing,
because there is nothing to survive.

This is the last of the four Stories under `FEAT: commitment` (#26) and it is what makes the other
three real. It is also the only one that reaches the screen, which was settled at the grill against
this Story's own recommendation: an engine-only store would have had no caller until #104, and #103's
intent sentence — *find the commitments you defined still there after the app has been closed and
opened again* — would have been true only at the end of a Story that is not this one.

## What Changes

- **Adds a roster store to the `commitment` capability**: a roster kept at a place of its own,
  mirroring the roster's own two mutators — take a commitment on, stop keeping one — each kept at
  the place before the store reports it, with no separate save step, exactly as the record store
  works and for the same reason.
- **Keeps the roster at its own place, a file beside the record's**, not in one document with it.
  Two stores at different places are already required to be independent of each other; taking on a
  commitment must not rewrite a history, and merging them would need a delta on `record` as well.
- **Fixes that a roster store writes the order it was given.** Order is one of the things a roster
  *is* (`CONTEXT.md` § *Roster*), so unlike a record store — free to write ticks in whatever order
  makes its file stable, because a history is the same history whatever order its ticks arrived in —
  a roster store keeps the order it was handed and invents none.
- **Fixes that a roster store that cannot be read is refused rather than emptied**, in the same
  three cases the record store already has: content that is not a store, a store written in a later
  form than this app knows, and a store holding what could not be a roster.
- **Makes the day screen draw from a roster, per day it is showing.** It asks the roster what it had
  not stopped keeping on the day being shown, rather than holding a fixed list — otherwise the
  kept-until day this store exists to persist could not be observed at all, and a past day would show
  today's list. **This is what makes the Story touch `day-screen` as well as `commitment`.**
- **Makes the day screen open and re-read both stores.** A roster place sits beside
  `DayScreen.recordPlace`; both are read when the app is shown. Re-reading the roster costs nothing
  today because nothing else writes it — and #104 adds a screen that does, so a day screen holding a
  stale roster is the bug that would otherwise land there as a mystery.
- **Reports an unreadable roster separately from an unreadable record.** The distinction is real and
  a person can act on it: an unreadable record still leaves rows to draw unticked, while an
  unreadable roster leaves nothing to draw at all. Both keep ADR-1021's two reasons and no others.
- **Writes day one into a roster that holds nothing at all.** The app target owns the content — the
  owner's eight commitments, already in `ContentView.swift` — and the engine owns the moment, because
  a trigger that a test cannot reach is a trigger nobody checks. *Holds nothing at all* rather than
  *reads back no commitments*: retiring keeps the entry, so a roster emptied by stopping all eight is
  never equal to a fresh roster. Recorded as `docs/adr/1027-day-one-is-written-into-an-empty-roster.md`.
- **One hand-written coding of a commitment, shared.** `CommitmentRecord`, `DateRecord` and
  `ScheduleRecord` move out of `RecordDocument.swift` into a file of their own so both documents use
  them; each document keeps its own independent version number. ADR-1017 refuses synthesised
  `Codable` because nobody has read the compiler's shape — that argument is about the coding being
  written and signed once, not about it being written twice, and a fifth schedule shape stays one
  compile error in one exhaustive switch.
- **Not in this change:** any screen for adding, editing or stopping a commitment (#104 and B-013);
  reading a stopped commitment back out of a roster, or listing what you used to keep — #26's G1
  settled that stopped commitments are hidden and no want asks otherwise; carrying either store to a
  new phone (B-009); a commitment identity (B-014); migrating a store, since no roster store exists
  anywhere to migrate.

## Capabilities

### New Capabilities

None. A roster store is part of what a roster is, in exactly the way `add-record-store` (#56) argued
a record store is part of what a record is: `CONTEXT.md` § *Roster store* defines it as the store
that keeps a roster, and a `store` capability would put the thing and its durability in different
files for no reader's benefit. `day-screen` already exists too.

### Modified Capabilities

- `commitment`: two **ADDED** requirements — *A roster store keeps a roster at a place, across the
  app being closed and opened again* and *A roster store that cannot be read is refused rather than
  emptied* — with fifteen scenarios between them. **No existing requirement moves.** The roster is
  exactly what #101 and #102 made it, and the store persists that shape; in particular this change
  adds **no read-back of a stopped commitment or its kept-until day** to the roster's public surface.
  `archive/2026-09-03-add-roster-retirement/design.md` expected #103 to "reach it internally without
  a delta", and that is not true as written — `Roster.Entry` and `Roster.entries` are `private`, so
  nothing in the module can read them either. They are widened from `private` to module-internal,
  which is an access level and not a requirement. The alternative, a public read-back on the roster,
  grows a surface no screen has asked for and reopens a spec that has passed G4 twice.
- `day-screen`: four requirements **ADDED** — a day screen drawing the commitments its roster had not
  stopped keeping on the day it is showing, taking on the commitments it was handed when its roster
  holds nothing at all, keeping its roster at its own place beside its record, and drawing the day but
  no rows when it cannot read its roster — and four **MODIFIED**, every one of them because it was
  written when a day screen held a list handed to it once:
  - *A day screen holds the day view of the day it was handed…* — it is opened from **four** things
    now, and the commitments it was handed are what it takes on rather than what it draws.
  - *A day screen moves the day it is showing one calendar day either way* — a move is handed the
    commitments the roster answers with **on the day landed on**, and reads neither store again.
  - *A day screen goes straight back to the today it was handed* — the same, for the one move that
    always has somewhere to go.
  - *A day screen re-reads its day and its record when the app is shown again* — it reads the
    **roster** again too, and what it says about the roster is formed again rather than carried over.

Every requirement restated under MODIFIED keeps its scenarios verbatim, and **no test written for
one of them may be renamed or have an assertion changed**: those twenty-nine scenarios are the
evidence that this change moves where a day screen gets its commitments and not what it does with
them. Their construction lines do change — a day screen now takes a second place — and `tasks.md`
§ 1 fixes the exact mechanical form of that edit.

`record` and `schedule` are untouched. Nothing here asks a new question about a tick, a history or
due-ness, and the roster store reads `Commitment`'s and `CalendarDate`'s existing internal members
exactly as `RecordDocument` already does.

## Impact

- **`src/DayByDayKit`** — three new files, `Sources/DayByDayKit/RosterStore.swift` (public),
  `Sources/DayByDayKit/RosterDocument.swift` (internal) and
  `Sources/DayByDayKit/CommitmentCoding.swift` (internal, the three record types lifted verbatim out
  of `RecordDocument.swift`). Two existing files are edited: `RecordDocument.swift` loses those three
  types and keeps everything else, and `DayScreen.swift` gains a roster place, a roster state, a
  roster store and the per-day ask. `Roster.swift` changes access level only — `Entry` and `entries`
  from `private` to internal — and no behaviour. `Package.swift` is untouched: no `platforms:` line,
  no dependency.
- **`src/DayByDay`** — `ContentView.swift` hands `dayOneCommitments` to the new initializer and draws
  two more message rows for a roster it is not keeping. No branch of its own and no wording the kit
  does not already own, under ADR-1019; `tasks.md` § 4 closes it in the simulator, the only way this
  repo has while `docs/open-questions.md` § *No UI smoke layer* stands.
- **Tests** — thirty-seven new acceptance tests, one per new scenario: fifteen in a new
  `Tests/DayByDayKitTests/RosterStoreTests.swift` and twenty-two at the end of the existing
  `DayScreenTests.swift`. Measured on this machine on 2026-09-04, on Apple Swift 6.3.3
  (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`: `cd src/DayByDayKit && swift test` reports
  **263 tests passing** at `e5faaef`; this change takes it to 300. `openspec` is 1.10.0 and
  `node --version` is v24.19.0.
- **`openspec/specs/`** — `commitment/spec.md` and `day-screen/spec.md` are rewritten at archive time
  by `/opsx:archive` and nothing else. Two capabilities are claimed and both are edited, so CI check 2
  stays green.
- **ADR** — `docs/adr/1027-day-one-is-written-into-an-empty-roster.md`. 1027 is the lowest number no
  file and no branch has used: 1025 is taken on `chore/on-the-phone` and 1026 is on `main`, checked
  against every ref on 2026-09-04. `docs/adr/README.md` gains its row.
- **`CONTEXT.md`** — the grill already landed four terms in the working tree (**Store** amended,
  **Record store**, **Roster store**, **Day one**). This change adds one more the delta turned up,
  **Roster place**, and stamps a 2026-09-04 amendment on **Day screen**, which until now named only
  the record store it holds.
- **`docs/open-questions.md`** is not this change's to write (`AGENTS.md` § *Agent roles*). One entry
  is owed and `tasks.md` § 4 names it as a chore commit alongside the merge: under *Known gaps*, the
  entry saying the store must be opened under `Library/Application Support/` now has a second file
  under it, and the roster place is chosen here for the same reasons the record place was.
- **`docs/backlog.md`** — B-013 (*stop keeping a commitment*) and the wants behind #104 stay where
  they are; nothing here promotes one. This change does not edit that file.
- **No new dependency, no platform floor change and no CI change.**
