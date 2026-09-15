## Context

See `proposal.md` § *Why* and `grill.md`, whose sixteen settled answers this delta is written on.
These facts, read off this worktree, decide the shape.

- **Two acts write both places**: `CommitmentsScreen.change` on its same-rhythm and both-in-one-save
  paths, and `restart`. Every refusal runs before the first write; the record place goes first.
- **The in-save undo is `try? recordStore.carryOver(changed, to: commitment)`**, and its failure is
  dropped. For a restart the dated inverse refuses whenever the source still holds records.
- **`History.carryOver` refuses wherever the target holds any record at all**, so it cannot carry an
  orphan back onto a source that holds records on other days.
- **An interval schedule is not due before its start date.** So a restart that carries records keeps
  none behind, and undoing one never lands on a day the source already holds.
- **Both screens open both places**, each at `init` and `shown(asOf:)`, and a day screen also at
  `returnedTo()`, after it has taken on day one.
- **Record and roster sit in one directory on a phone.** Tests that refuse the roster place replace
  the roster's own directory with a file, so the record directory stays writable there.
- **Three shipped scenarios seed stray records with exactly one possible source**, which carrying back
  would now absorb. They are refixtured under MODIFIED so each still meets the refusal it names.

## Goals / Non-Goals

**Goals:**

- Every rule observable through the two screens that already open the places.
- One undo, run both when the places are read and when a roster write fails mid-save.

**Non-Goals:**

- **The stale-copy lost update** (`grill.md` item 15) is not guarded here.
- **No new words on the day screen**, and no change to what a refusal says.
- **No change to acts that write the roster alone**: define, stop, remove, move and a rhythm change.

## Decisions

### The seam

`DayScreen` and `CommitmentsScreen` stay the seam: every scenario drives `init`, `shown(asOf:)`,
`returnedTo()`, `change` or `restart`. One public member is new. The rest is package-internal, listed
so the diff is expected. A test writes a torn save through `SaveInProgress.keep(at:)`.

- `public private(set) var recordsBelongToNoCommitment: Bool` — on `CommitmentsScreen`
- `struct SaveInProgress: Equatable, Codable` — internal, new file `SaveInProgress.swift`
- `init(carriedFrom source: Commitment, to carried: Commitment)` — internal, on `SaveInProgress`
- `static func place(besideRecordAt recordPlace: URL) -> URL` — internal, on `SaveInProgress`
- `func keep(at place: URL) throws` — internal, on `SaveInProgress`
- `static func read(at place: URL) throws -> SaveInProgress?` — internal, on `SaveInProgress`
- `static func undoTornSave(recordAt recordPlace: URL, rosterAt rosterPlace: URL) -> Bool` — internal, on `SaveInProgress`
- `static func carryBackOrphanedRecords(in store: RecordStore, against roster: Roster) -> Bool` — internal, on `SaveInProgress`
- `mutating func carryBack(_ orphan: Commitment, to source: Commitment) -> Bool` — internal, on `History`
- `func commitmentsWithRecords() -> Set<Commitment>` — internal, on `History`
- `func carryBack(_ orphan: Commitment, to source: Commitment) throws -> Bool` — internal, on `RecordStore`

### The save in progress lives beside the record place, not at a place of its own

It is `save-in-progress.json` in the record place's directory, so no initializer gains a parameter.
A record place that cannot be written therefore refuses the save before anything moves, as it does
today. It is written only where records will be carried. Rejected: a third `keeping…At` parameter on
both screens, which moves every call site for a file no caller ever chooses.

### A save finished is told by the roster, not by the file

The save in progress names the commitment the records went to. If the roster holds it, in any state,
the roster write landed; `alreadyKept` refuses any change onto a commitment the roster holds, so
before the save it held none. Rejected: storing both places' prior bytes and restoring them, which
doubles every save and would write back over a roster a later version touched.

### A torn save that cannot be undone reuses two existing states

The day screen answers `.unreadable`, *without its record*. The commitments screen answers
`.notKept`, so the requirement on a roster it cannot read governs it. Rejected: a new state for
each, which needs new shell words the grill did not ask for.

### Carrying back refuses only on a shared day

`carryBack` refuses where a record would not form under the source or would land on a day the
source holds. It never refuses because the source holds records elsewhere, as `carryOver` does. The
in-save undo and the undo on reading the places both use it.

### Two orphans with one source move neither

Moving one first would decide which history keeps the shared source. `grill.md` item 8 already
refuses that judgement, so this follows it rather than asking again.

### The shell rides this Story

`CommitmentsView.swift` says, beside the roster messages, that some records belong to no commitment,
wherever `recordsBelongToNoCommitment` is true. It decides nothing, as ADR-1019 requires.

### ADR

ADR-1049 is amended in place, as ADR-1020 requires: its ask-again repair is retired, and it now
records the save in progress and the one-source rule.

### Migration

None — additive. A new file appears only mid-save. A phone with none reads as before. Records
already orphaned are carried back or said the first time the places are read.

## Risks / Trade-offs

- **The in-save undo failing has no scenario.** No test can let the record place accept the carry
  and then refuse the undo. → It is the same `undoTornSave` the three reading scenarios test.
- **The implementer checks `kept` for a finished save.** → The removed-commitment fixture fails.
- **The implementer reuses `carryOver` for carrying back.** → The removed-source scenario fails.
- **The day screen still says "The record could not be read."** while a torn save stands. That is
  honest enough for a condition that ends on the next successful read.
- **Unit tests outside the scenarios may seed orphans** and now see them carried back. A red one is
  a rule-5 stop, never a quiet refixture.

## Open Questions

None. `grill.md` § *Left open* is "None.", and its four design points are decided above: the form and
place of the save in progress, the matching rule, the order on reading, and the ADR. Item 15 is out of
scope here and belongs in `docs/open-questions.md`. No `## Questions for you` round is outstanding.
