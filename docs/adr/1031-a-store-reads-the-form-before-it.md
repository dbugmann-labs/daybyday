# 1031. A store reads every form it has written, and rewrites the file only when something is kept

- Status: accepted
- Date: 2026-09-06
- Amended: 2026-09-10 — which shape belongs to which form is judged against the form each part was
  first written at and never against the newest; `condense-record-spec` (#205) deletes the
  requirement prose that argued it.
- Amended: 2026-09-06 — this record's own reversal trigger fired at `add-number-record` (#138), one
  day later. A store reads **every** form it has written rather than one step back, and in exchange
  each form is read as the shape that form has rather than leniently. The title moved with the
  decision; § *Reading three forms* is the new part and the new trigger is at the end.
- Amended: 2026-09-08 — the trigger named below fired at `add-commitment-category` (#147), which
  gives the roster document a fourth form. The decision held; § *A fourth form, and a field that
  has to be written* records what the fourth form needed that the third did not, and the trigger is
  restated at the end of it.
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

**A store reads every form this app has written, reads each as the shape that form has, and refuses
everything else. It writes nothing when it opens.**

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

**Which shape belongs to which form is judged against the form each part was first written at, and
never against whichever form is newest.** A number's place in the record document arrived at the
third form, a note's at the fourth and an addition's at the fifth, and each of those answers stays
where it is whatever a sixth form adds: a store goes on expecting a number from the third form
onwards rather than from the newest one. Judging against the newest instead would let every new form
silently re-declare the shape of the forms before it, so the strictness above would say no more than
"this form holds whatever the current build writes" — the lenient reading this record exists to
refuse, arriving by the back door. It is why `numbersIntroducedInVersion`,
`notesIntroducedInVersion` and `additionsIntroducedInVersion` are constants of their own rather than
offsets from `currentVersion`, and the rule stays stated in `record`'s own requirement, where three
refusal scenarios rest on it.

## Reading three forms

Added 2026-09-06 at `add-number-record` (#138), which gives the record document a `numbers` field and
moves `RecordDocument.currentVersion` to `3`. The record file can now be in three forms and the
roster file in two, independently, and every one of them opens.

The range guard needed no change at all — `1...currentVersion` already covers a third form — so the
part of this decision that cost something is the strictness it was written to require:

**Each form is read as the shape that form has.** A store declares its form before anything else is
read, so what may be in it is known rather than inferred. `numbers` is present exactly at the form
that writes it: a document declaring form 1 or form 2 that carries one is refused as content that is
not a store, and so is one declaring form 3 that does not.

The cheap alternative was free and is rejected. JSON decoding ignores unknown keys, so an optional
`numbers` meaning *none when absent* would read all three forms with no guard written at all — which
is the "second optional field and infer" this record warned against when it named this trigger. It
would make the declared form decorative, since every form would then accept every other form's shape,
and the failure is silent: a file this app never wrote would be read as though it had, and the next
change kept there would launder it into a current-form file.

**One comparison, not three decode paths.** This record originally called for "a decode path per
form, chosen off the version". What it wanted was that each form's shape is stated and enforced;
three forms that differ from one another only by the presence of one array get exactly that from one
check against a version already in hand, and three decode functions would be scaffolding around it.

**The `kind` field's absence-means-tick rule is deliberately not tightened the same way.** It could
be — form 1 has no `kind`, forms 2 and 3 always write one — but `kind` lives in `CommitmentRecord`,
which the roster document shares and whose own form is not moving. Threading a version into the
shared coding would edit the roster's read path to guard against a hand-edited file nobody has seen.
The line is drawn here so the next person does not have to re-derive it.

## A fourth form, and a field that has to be written

Added 2026-09-08 at `add-commitment-category` (#147), which gives every roster entry a **category**
and moves `RosterDocument.currentVersion` to `4`. The trigger this record named for itself — *"a
fourth form, or a form that differs by more than a field"* — fires on the first half of that, so it
is answered here rather than passed over.

**The decision held and no decode path per form is owed.** Four forms differing from one another
only by a field being present or absent still read under one comparison against a version already in
hand: `category` is present exactly at forms at or after `categoryIntroducedInVersion = 4`,
`removed` exactly at forms at or after `removalIntroducedInVersion = 3`, and the guard that already
checked the second checks the first the same way. Four decode functions would be scaffolding around
two comparisons.

**What the fourth form needed that the third did not is one line of encoding.** `keptUntil` can be
absent to mean "not stopped", because there is no other thing an absent day could mean. A category
cannot: *under no category* is an ordinary state a commitment can be in, so an absent `category` key
would mean both "this commitment is under none" and "this form has no categories in it", and the
shape-against-form check would have nothing to read. So **form 4 writes `category` on every entry,
as an explicit `null` where the commitment is under none**, through a hand-written `encode(to:)`
rather than the synthesised one, which omits `nil`. Measured on this machine 2026-09-08:
`container.encode(optional, forKey:)` writes `{"category":null,…}`, and on the way back
`container.contains(.category)` answers `true` for an explicit `null` and `false` for an absent key.

That is worth writing down because it is the first time this record's strictness has cost anything
beyond a comparison, and because the cheap alternative is the same one this record has rejected
twice: an optional field meaning *none when absent* would read all four forms with no guard at all,
make the declared form decorative, and launder a file this app never wrote into a current-form one
the next time something was kept there.

**The trigger is unchanged and is restated so it is not read as spent**: a **fifth** form, or a form
that differs by more than a field. A form that renames a field, changes what one means, or splits one
into two still cannot be told from its predecessors by one comparison, and at that point the decode
path per form is owed for real. Amend this record in place when that day comes (ADR-1020); it has
now been amended twice, both times on a trigger it named itself.

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
- **The reversal trigger is now a fourth form, or a form that differs by more than a field.** Three
  forms differing from one another only by a field being present or absent is what lets one document
  type read all of them under one comparison. A form that renames a field, changes what one means, or
  splits one into two cannot be told from its predecessors that way, and at that point the decode
  path per form is owed for real. Amend this ADR in place when that day comes (ADR-1020); it has been
  amended once already, on the trigger it named itself.
