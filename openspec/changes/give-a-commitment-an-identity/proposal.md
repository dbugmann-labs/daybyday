## Why

A commitment is its four parts today, so a rename makes a second commitment and a rhythm change
leaves two — one on each side of a supersession, each with its own day kept from and its own
records. The look-back reassembles them by resemblance and the sheet cannot say when the whole
thing began. Giving a commitment an identity of its own is what makes a change leave one
commitment behind.

## What Changes

- A commitment carries an identity; two commitments are two however alike their parts.
- A roster holds each era of a commitment as an entry carrying that identity, newest first.
- Kept, stopped and removed become states of the commitment; an earlier era is on neither list.
- A rename reaches every era, and no record moves for one.
- A rhythm, a range, a target or an interval restart puts a new era on the same commitment.
- The day a commitment is kept from is its earliest era's; its rhythm is its newest era's.
- A roster refuses a name a commitment it keeps or has stopped already has, case and end
  spaces ignored, and no longer a value it already holds.
- The refusal is said under the name field and names the commitment; a resume says its own.
- Records key on a commitment's identity, so a change moves none of them.
- The refusal against records already kept under what a change would produce goes.
- A look-back reads a commitment's eras off its identity rather than by resemblance.
- A roster kept before identities is folded once: chained eras join the commitment in front,
  what nothing live resembles is erased with its records, the rest becomes stopped.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: requirements ADDED, MODIFIED and REMOVED; three replaced under new headings.
- `look-back`: one requirement REMOVED and ADDED under a new heading, one MODIFIED.
- `record`: requirements MODIFIED for the identity a record keys on and the form on disk.

## Impact

- `openspec/changes/give-a-commitment-an-identity/` — this folder.
- `openspec/specs/commitment/spec.md`, `openspec/specs/look-back/spec.md`,
  `openspec/specs/record/spec.md` — at archive.
- `src/DayByDayKit/Sources/DayByDayKit/` — `Commitment`, `Roster`, `RosterDocument`,
  `RecordDocument`, `CommitmentCoding`, `RosterStore`, `RecordStore`, `History`,
  `CommitmentsScreen`, `DayScreen`, `LookBack`.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — `CommitmentTests`, `RosterTests`,
  `RosterStoreTests`, `RecordTests`, `RecordStoreTests`, `CommitmentsScreenTests`,
  `LookBackTests`, `DayScreenTests`, `RestoreTests`.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the name refusal under the field, and the
  stopped row's footer.
- `docs/adr/1023`, `1030`, `1035`, `1055` — amended in place; one new ADR for the identity.
- `CONTEXT.md` — the terms the delta turns up.
