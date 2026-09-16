## Context

See `proposal.md` § *Why*, and `grill.md` for what was settled.

`CommitmentsScreen` holds one `refusedChange`, which names the change asked for and why it was
refused and lasts until the app is shown again or a change reaches a place — exactly two end
conditions, and *What a commitments screen holds about a refused change lasts until the app is
shown again or a change is kept* says nothing else ends it. The two lists draw their refusals from
it. The sheet draws all thirteen refusals at the foot of its first section from a `@State` copy,
and a restart's from a second copy, so two can stand at once; a new sheet's weekday chips open with
nothing lit.

The day screen already has this shape twice over: a `notice` told on a row, and a `nameRefusal`
told under the one-off entry or a row's name field, carrying which field it is under and ending
when that field's text is edited. Nothing about that arrangement needed the row notice to change.

## Goals / Non-Goals

**Goals:** the screen answers which field of its sheet a refusal is about, and how long that
answer lasts; the sheet draws each refusal under the control it names.

**Non-Goals:** the sentences a person reads, which stay the shell's; the refusals told beside a row
on the two lists, which are untouched; a range or a target changed on the sheet, which is #262.

## Decisions

### The seam

```swift
public enum SheetField: Equatable, Sendable { case name, rhythm, keptFrom, range, target, restartDay }
public struct SheetRefusal: Equatable, Sendable { public let field: SheetField?; public let refusal: Refusal }
public private(set) var sheetRefusal: SheetRefusal?
public func sheetFieldEdited(_ field: SheetField)
public func sheetClosed()
public var weekdaysToOffer: Set<Weekday> { get }
```

### A second value, not a place on the refused change

`sheetRefusal` is held beside `refusedChange` rather than added to it. Giving `refusedChange` a
field and a third end condition would contradict the requirement the two lists still run on, and
would make a name typed on a sheet end a refusal told beside a row. The day screen's `notice` and
`nameRefusal` are the same division. Rejected: one value with a place, which costs a MODIFIED
requirement and every scenario under it.

### One rhythm field, and the foot is no field at all

`.rhythm` covers the chips, the wheel, the interval row and the quota stepper: they are one control
in one row, whichever rhythm is chosen, and the refusal carried beside the field already says which
of them is at fault. A refusal about the whole change carries `field: nil`, as `nameRefusal.row`
carries `nil` for the one-off entry — so `sheetFieldEdited(_:)` takes a non-optional field and no
edit can reach the foot. Rejected: a field per control, and a seventh `.foot` case whose
end-on-edit rule would have to be written out and then forbidden.

### The screen decides which field, not the sheet

Every refusal but two follows from the refusal alone. For a day already recorded on that a change
would leave not due, and a change a stopped commitment does not take, the screen compares the
rhythm and the day kept from it was handed against the ones the commitment is made of — it holds
both, so the sheet is not asked to work it out and the acceptance tests reach it. A change refused
for a day already recorded on has always moved the day kept from, so the rhythm-only branch of
that rule is exercised by the stopped-commitment refusal alone.

### The app being shown again ends it too

The grill settled three end conditions — the field edited, the next ask, the sheet closed. A fourth
follows the two things this app already tells: `refusedChange` and `nameRefusal` are both cleared
by `shown(asOf:)`, and a sheet still up when the app returns has had its places re-read underneath
it.

### The weekdays offered are their own requirement

*A commitments screen defines a commitment from a name, a rhythm and the day it is kept from* is
275 lines; the weekdays offered are a new rule standing beside the kind and the day it offers, so
they are ADDED rather than folded in, which would re-emit that block verbatim for one sentence.

### Migration

None — nothing persisted changes.

## Risks / Trade-offs

The sheet must tell the screen when a field is edited and when it closes, and a missed call leaves
a refusal standing a moment too long → the walk shows the four placements a person meets most, and
nothing is kept or lost by a stale line.

`.rhythm` names a control whose shape changes with the rhythm picker, so a refusal told there while
the picker is being changed can land under a different control than the one that earned it → the
next ask replaces it, and switching rhythm is an edit of that same field, which ends it.

## Open Questions

None. The grill left none, and its answers raised no question the delta could not settle — the
lifetime it asked about is answered under *A second value, not a place on the refused change*.

The one question writing the delta turned up was settled by the owner on 2026-09-15: a restart
refused for something other than the day picked — already being kept, records already kept under
the restarted commitment, or a day already recorded on that the restart would leave not due — is
told under the restart day picker, not at the foot. All three turn on the day picked there, and the
*Restart* section sits below the foot. The delta is written on that answer.
