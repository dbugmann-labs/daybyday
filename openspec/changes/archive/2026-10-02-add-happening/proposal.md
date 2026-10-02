## Why

A person has no way to name what comes to them rather than what they owe — an eye migraine, a bad
night. `FEAT: happening` answers that, and this is its first Story: a happening is made and renamed
in a section of its own on the commitments screen, and kept in a store of its own. Noting an
occurrence, the look-back, stopping and deleting, and the copy are each a later Story.

## What Changes

- A **happening** is a name and an identity given when it is made, and nothing else.
- A name that says nothing makes no happening; a name is kept exactly as given.
- Happenings are held in the order they were made, newest last.
- A second happening with one name — case and surrounding blank space aside — is refused.
- A rename keeps the happening's identity and its place; a rename onto another's name is refused.
- A happening store keeps happenings at a place of its own, and refuses one it cannot read.
- The commitments screen lists the happenings in a section below its two lists, and makes and
  renames them there, telling a refusal under the sheet's name field.
- A commitments screen that cannot read the happenings says so, makes and renames none, and leaves
  the file as it was; the commitments work as before.
- Making or renaming a happening writes no copy, and touches no other store.
- An ADR records that a happening carries an identity from its first form.

## Capabilities

### New Capabilities

- `happening`: what a happening is, how happenings are held, made and renamed, the store that keeps
  them, and the commitments screen's section where a person makes and renames them.

### Modified Capabilities

None.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — new files for the value, the happenings, the store and
  its form on disk; `CommitmentsScreen.swift` gains the section's members; `DayScreen.swift` names
  the happening place.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new test files for the value, the store and the
  screen's section.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the *Happenings* section and its two sheets.
- `docs/adr/` — a new record for the happening's identity, with its `README.md` row.
- `CONTEXT.md` — **Happening** and **Commitments screen** amended; **Happening store** and
  **Happening place** added.
