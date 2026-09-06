# 1031. A store reads the form written before it, and rewrites the file only when something is kept

- Status: accepted
- Date: 2026-09-06
- Deciders: Diego Bugmann

## Context

`add-commitment-kind` (#137) is the first change in this repo to move the shape of a file that
already exists on a real phone. Both stores write a `version` field — `RosterDocument` and
`RecordDocument` each carry `static let currentVersion = 1` — and both initializers today read a
`version`-only envelope and refuse anything that is not exactly that number:

```swift
guard envelope.version == RecordDocument.currentVersion else {
    if envelope.version > RecordDocument.currentVersion {
        throw RecordStoreError.laterForm(at: place, version: envelope.version)
    }
    throw RecordStoreError.notAStore(at: place)
}
```

The *later* half of that is required by `openspec/specs/record/spec.md` and
`openspec/specs/commitment/spec.md`, and it is right: a form a later build wrote is a shape this
build cannot know, so refusing it whole — rather than emptying over it — is what keeps a record
recoverable. **The *earlier* half is required by nothing.** No requirement in either spec mentions a
form below the current one; the code simply calls it "not a store".

Left alone, adding a fourth part to a commitment would make the owner's phone refuse to open its own
roster and its own record, and DayByDay would report that it keeps nothing and has recorded nothing.
That is the failure the product exists to remove, arriving by way of a version number.

## Decision

**A store reads the forms this app has written — the one it writes now and the one before it — and
refuses everything else. It writes nothing when it opens.**

- The version guard widens from `version == currentVersion` to the closed range
  `1...currentVersion`. Above it: still `.laterForm`, unchanged. Below it: still `.notAStore`.
- A document in the form written before a commitment carried a kind holds no kind on any commitment,
  and every commitment in it is read as being of the plain kind — which is what every one of them
  was.
- **There is no migration pass, no rewrite-on-open and no upgrade step.** A store writes when a
  change is kept and at no other moment, so a person who opens the app and changes nothing leaves
  the file byte-for-byte as it was, in the form it was already in. The first change kept there
  writes the whole document in the current form, which is what both stores already do on every
  change (ADR-1017).
- **A form number no build ever wrote is refused as content that is not a store**, not as an earlier
  form. Version 0 says nothing about the shape of what follows it.

## Alternatives considered

**Rewrite the file to the current form as soon as it is opened.** Rejected on the store's own
requirement: a store that reports a change is kept before it is kept is the one thing it must never
be, and *opening* is the one operation that has never written. It would also make "reading changes
nothing at its place" untestable, which is the property that lets a person recover a file this build
misread.

**Refuse an earlier form and ask the person to reinstall or start again.** Rejected outright. The
person is the owner, the file is the only copy, and the product's whole promise is that a record a
few days old is still there.

**A migration framework — a chain of per-version upgrade functions.** Rejected as premature by a wide
margin. There are two forms. One optional field separates them, so one document type reads both, and
a framework would be scaffolding around a single `if`.

**Read any version at or below the current one.** Rejected on a measured fact rather than taste:
`RecordStoreTests.swift` already carries a test writing `{"version": 0, "ticks": []}` and expecting
`.notAStore`, and a guard written that way turns it red. It is also wrong in principle — a version
number this app never wrote is not evidence about the bytes after it.

## Consequences

- **Upgrading is invisible and needs nothing from the person.** The day screen draws, the first tick
  or the first commitment taken on moves that one file forward, and the other file stays where it is
  until it is written to.
- **Downgrading a build on a phone that has kept something since the upgrade means that file will not
  open.** The build refuses it and leaves it alone, so nothing is lost and a forward build recovers
  it. There is no downgrade path and none is wanted: the way back is forward.
- **Two files move independently.** The roster and the record are at different places and are written
  by different acts, so a phone can sit with one at the new form and one at the old indefinitely.
  That is correct and is what the "changes nothing at its place" requirements say.
- **The reversal trigger is a third form.** One optional field is what makes one step back free. A
  form 3 that must read both form 1 and form 2 should say what each form means — a decode path per
  form, chosen off the version — rather than adding a second optional field and inferring. Adding
  optional fields indefinitely ends with a document whose shape nobody can state, which is the state
  this decision is meant to keep the file out of. Amend this ADR in place when that day comes
  (ADR-1020).
