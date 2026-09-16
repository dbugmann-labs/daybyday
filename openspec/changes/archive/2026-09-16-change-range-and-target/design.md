## Context

See `proposal.md` § *Why*. What the code holds today, and what the delta moves:

- `CommitmentsScreen.change(_:toName:on:keptFrom:under:)` builds every result with the old
  commitment's kind verbatim, and decides carry-over against supersede on the rhythm alone.
- The sheet already draws the range row and the target field on a change, prefilled from
  `whatItIsMadeOf` and disabled by `changing != nil`; the rhythm controls and the kept-from picker
  are disabled by `canChangeRhythmAndKeptFrom`, which is false for a stopped commitment.
- `rangeIsNotARange` and `targetIsNotATarget` are raised from `define` only, over a reading of the
  typed strings; `SheetField.range` and `.target` already exist and are placed by #261.
- `Roster.supersede` takes any two commitments and judges neither, so the roster needs no change.
- `LookBack.chain` matches an earlier era on `commitment.kind ==`, which a changed range or target
  would sever; `commitment` equality is on the whole kind, so a changed range is a commitment the
  roster does not hold and a supersession is well founded.

## Goals / Non-Goals

**Goals:** one act for a changed range or target, the one a changed rhythm already uses; the two
value refusals reaching the change path with the placement #261 gave them; a chain that follows a
commitment across such a change.

**Non-Goals:** what a number's or a total's look-back page draws across a boundary whose range or
target differs (#274, #275); the words the shell says beside a frozen control; any change to how a
range or a target is read from what a person typed.

## Decisions

### The seam

```swift
public func change(_ commitment: Commitment, toName name: String, on rhythm: Rhythm, keptFrom: CalendarDate, under category: String?, lowest: String? = nil, highest: String? = nil, target: String? = nil) -> Refusal?
public let CommitmentsScreen.Change.canChangeMoreThanNameAndCategory: Bool   // was canChangeRhythmAndKeptFrom
case CommitmentsScreen.Refusal.stoppedCommitmentDoesNotTakeThisChange        // was stoppedCommitmentCannotChangeRhythm
private static func CommitmentsScreen.changedKind(of commitment: Commitment, lowest: String?, highest: String?, target: String?) -> Reading<Commitment.Kind>
private static func CommitmentsScreen.ambiguousField(askedRhythm: Rhythm, askedKeptFrom: CalendarDate, askedKind: Commitment.Kind, from commitment: Commitment) -> SheetField?
func Commitment.Kind.isOfTheSameSort(as other: Commitment.Kind) -> Bool
```

### Three more strings, and `nil` is the value it already carries

The change takes the range and the target the way `define` does — exactly as a person typed them,
read only for the kind that has room for them — so one reading serves both paths and the two
refusals keep their present meaning. `nil` is the range or target the commitment already carries,
which is what the sheet prefills and hands straight back; it is a value the delta already allows and
never a fourth state. Rejected: no default, which would put three arguments on eighty-seven existing
call sites and bury the change in its own diff. Rejected: defaulting to `""`, which reads as *take
the range off* and would strip a range from every call that forgot it.

### Supersede is decided on the whole kind, carry-over keeps the old one

`changedKind` answers the kind the change names; the act is decided by the rhythm and that kind
together, so a different range, a different target, a range added and a range taken off all
supersede. The commitment carried over — the same-rhythm path, and the first half of a save that
does both — is built with `commitment.kind`, and only the commitment taken on in the supersession
carries the new kind. Rejected: superseding only on a narrowed range or a raised target, which the
grill settled against — the roster holds no link either way, so direction buys nothing back.

### The reading comes before the stopped guard

A stopped commitment asked through the seam for a range that is not a range is refused as *a range
that is not a range*: the ask cannot be compared with what the commitment is made of until it has
been read. The shell cannot reach it — those fields are disabled and prefilled — so no scenario
spends a test on it, and nothing else about the order of refusals moves.

### One comparison over four things, not two

`ambiguousField` gains the asked kind and answers the field of whichever of the rhythm, the day kept
from, the range and the target differs from what the commitment is made of, and `nil` where more
than one does. The two refusals that use it are unchanged in meaning. Rejected: a second helper for
the value fields, which would make the whole-change case turn on comparing two answers.

### Two members renamed

One flag gates the rhythm, the day kept from, the range and the target alike, because a stopped
commitment takes a change to its name and its category only; `canChangeRhythmAndKeptFrom` would name
half of what it answers, and `stoppedCommitmentCannotChangeRhythm` half of what it refuses. Both
renames are compiler-checked and reach twenty-seven call sites. Rejected: leaving the names, which
costs nothing to type and misleads every reader afterwards.

### Resemblance on the kind's sort

`chain` compares `isOfTheSameSort` rather than `==`, so an era whose range or target differs is
still an earlier era. Only the head of a number's or a total's page moves: those kinds say no month
line and no whole, so no boundary line can be drawn across the new kind of boundary and nothing else
on the page changes. A tick's chain is untouched. `CONTEXT.md` **Era** carries this.

### Migration

None. No persisted type or encoding changes: a superseded commitment is written in the form the
roster document already holds, and a range or target already round-trips.

### The three requirements over their word budget

The three `commitment` requirements this change edits were each over the 150 words on `main` — 222,
445 and 271 — and are carried at the length they have, a few sentences longer. Splitting any of them
is a spec Story of its own; the `look-back` requirement stays inside its budget.

### What the shell draws

Option A, *as it stands, only the flag moves*, chosen at the grill's layout round from three at
https://claude.ai/artifact/WQyWjWVKxi5D6PSEcT4oJ1, against the designer's recommendation of B.

```
Cancel                                 Save
Change Mood

+-----------------------------------------+
| Mood                                    |
| Kind                           Number v |
| 1                                    10 |
| That's not a range.                     |
| Category (optional)                   v |
+-----------------------------------------+

+-----------------------------------------+
| Rhythm                       Weekdays v |
| (Mon)(Tue)(Wed)(Thu)(Fri)(Sat)(Sun)     |
| Kept from                    1 Jun 2026 |
+-----------------------------------------+
```

The kind picker stays frozen on a change; the two fields under it take a thumb, so their
`.disabled(changing != nil)` becomes the flag above. A total draws one field where the pair sits. On
a stopped commitment the values grey, with nothing beside them to name.

## Risks / Trade-offs

- A number entered or additions made on the morning of the change stand against the old commitment
  and are not drawn that day → the price a rhythm change and a stop already pay, settled at the
  grill rather than bought back with a second boundary rule.
- A person who narrows a range to correct a typo gets an era boundary they did not ask for → the
  look-back head still says the day the commitment was first kept from, which is where they would
  look; the pages that draw the boundary are #274's and #275's to decide.
- `nil` for a range or target that no production caller passes → the shell always passes what the
  fields hold, and the delta's no-op scenario pins what an unchanged value must do.

## Open Questions

None. `grill.md` § *Left open* records none, and writing the delta raised no question that would
change it: where a stopped commitment's refusal is told when a range and a rhythm both differ is
#261's rule applied over four things rather than two, written out above and in the delta.
