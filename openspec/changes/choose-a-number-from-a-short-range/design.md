## Context

See `proposal.md` § *Why*, and `grill.md` for the ten settled answers this delta is written on. The
facts it turns on:

- `DayView.NumberEntry` gives out `number` and `hint` only; `Row.commitment` is internal, so no
  caller can read a range's bounds. `numberEntry(asOf:)` reads the range off the row's commitment.
- A row's commitment is the era `Roster.groups(on:)` answers for its date, so a row already carries
  the range of the era holding its day (settled 5) with no new lookup.
- `DayScreen.enter(_:on:)` takes text, reads it with `TypedNumber.read`, and writes on every number
  it keeps — a number equal to the day's own included.
- `Number.init` refuses a value outside its commitment's range and takes 5.5 on one to ten.
- Six carried scenarios read or type into a one-to-ten "Mood": five in `day-screen`, one in
  `restore`. Their tests carry the same titles, one in `DayViewTests.swift` and five in
  `DayScreenTests.swift`, the restore one among them.
- The shell opens every number entry in an `.alert` with a decimal-pad `TextField` whose
  placeholder is the hint. No view in `src/DayByDay/` presents a popover today.

## Goals / Non-Goals

- **Goals.** A short range chosen in two taps and never typed; the seam saying which entry is which
  and what its values are; the day's number still reachable only through the entry.
- **Non-Goals.** A starting number for a typed entry (#325). Any change to what `record` or a
  commitments screen takes. A sheet or keypad fallback where the popover cannot anchor (Open
  Questions). A value drawn anywhere on the row at rest. Condensing the three carried requirements
  already over the prose budget, an editorial Story's (ADR-1047).

## Decisions

### The seam

```swift
public let DayView.NumberEntry.values: [Decimal]?
public func DayScreen.choose(_ value: Decimal?, on row: DayView.Row) throws
```

`values` is `nil` on a typed entry and never empty on a chosen one; `hint` is `nil` on a chosen
entry. `choose(nil, on:)` is the clear. `enter(_:on:)` keeps its signature and returns early on a
chosen entry. Day-view scenarios drive `DayView.Row.numberEntry(asOf:)`, day-screen scenarios drive
`DayScreen` at its places, as the carried ones already do.

### A choice is a member of its own, and a typed commit on a chosen row is inert

A chosen value is already a number, so `choose` takes a `Decimal` and never round-trips it through
`TypedNumber`. It writes nothing where the value equals the day's number (settled 3) or the clear
meets an empty day, and nothing for a value outside `values`. `enter` going inert on a chosen row is
what makes "chosen and never typed" a rule a test can hold rather than a habit of the shell.
- *Reuse `enter` with the value's text:* rejected — the kit would still take 5.5 typed on a mood,
  and settled 3 would need a same-value exception inside the typed path, changing typed behaviour.
- *A separate `clear(on:)`:* rejected — a second member for the one case `nil` already names.

### A chosen entry says its values and no hint

The values are the range said in full, so a hint beside them says the range twice; the shell draws no
field on a chosen row to put one in. The values are `Decimal`s, drawn as the shell already draws
`number`, and the value marked is the one equal to `number`; none is marked where the day holds a
number outside them (settled 4), and the shell then says that number above them.
- *Values as strings:* rejected — the shell would compare text to find the marked value.

### The carried scenarios move to a typed "Sleep", zero to twenty-four

Each keeps its title and its rule; only the short-range fixture moves to a range of twenty-five
values, with "25" as the refused number where "0.5" or "11" was. The six are MODIFIED whole.
- *Keep "Mood" and assert the inert commit instead:* rejected — each scenario would stop testing the
  rule it is named for.

### The shell rides this Story

ADR-1019's three conditions hold: `ContentView` is the immediate consumer and adds no rule the kit
does not state. A chosen row keeps the chevron and opens, on a tap, a popover anchored to the row with
`.presentationCompactAdaptation(.popover)`: the values in one line in order, the value equal to
`number` a filled circle with the digit inverted, and a `xmark.circle` clear labelled "Clear" for
VoiceOver, drawn only where `number` is set. Where `number` is not among `values`, it is said above
them. A value tap calls `choose` and closes; the clear calls `choose(nil, on:)` and closes; a tap
elsewhere closes and calls nothing. One popover at a time; nothing is dimmed. A typed row keeps its
alert.

### Migration

None — no persisted type and no encoding changes.

### What the shell draws

**Option B**, an anchored popover, chosen at the grill's layout round from three at
https://claude.ai/artifact/5EkBz4JRm2Ztii6iKRSWst (version 2). The wireframe is `grill.md` § *Layout*,
verbatim.

```
B · Anchored popover                     (nothing dimmed)
 │ M̶o̶o̶d̶ - Every day                  ✓  › │
 ╭────────────────────^─────────────────────╮
 │ 1  2  3  4  5  6 (7) 8  9  10  │  ⊗      │
 ╰──────────────────────────────────────────╯
 ╭────────────────────^─────────────────────╮
 │ 5.5                                      │
 │ 1  2  3  4  5  6  7  8  9  10  │  ⊗      │
 ╰──────────────────────────────────────────╯
Empty: digits only. Closed by a tap anywhere else. Covers the row below it.
```

## Risks / Trade-offs

- Eleven values on a narrow phone may crowd a thumb. → The walk's `phone:` line asks it of the
  owner; a miss is a G7 finding fixed in the shell, without a delta.
- A popover anchored to a list cell inside a paged day may present from the wrong frame or not at all.
  → Open Questions; the implementer stops rather than switching presentation.
- A day's 5.5 is still there after a range narrows; nothing tidies it. → Settled 4: it is said, and
  the clear or a value replaces it.

## Open Questions

- **Whether a popover anchors to one row of the day screen's list** inside its paged day views, with
  `.presentationCompactAdaptation(.popover)`, is unverified (`grill.md` § *Left open*). It is a fact
  for the build, not a preference: the implementer checks it first in the shell, and if it cannot be
  anchored there, that is a rule-5 stop brought back to the owner — never a quiet switch to a sheet.
  Nothing in the delta turns on it. No residual round is outstanding.
