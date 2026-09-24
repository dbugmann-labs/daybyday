## Context

See `proposal.md` § *Why*, and `grill.md` for the five settled answers this delta is written on. The
facts it turns on:

- `History` keys every number by `RecordedDay`, whose commitment compares by identity alone, so a
  number held under any era of a commitment is already found under every other era of it.
  `History.numbers` is private and nothing answers "the latest number before a date".
- `DayView.Row` stores the day's `number` at formation and is `Hashable` over every stored field;
  `numberEntry(asOf:)` forms the entry from the row and its commitment, which is the era holding
  the row's date, so the range it reads is the one `Number.init` refuses against.
- Row equality is relied on in three places: `DayScreen`'s `dayView.rows.contains(row)` guard
  before every change, the shell's `notice?.row` and `choosingRow` checks, and the row tests. No
  shipped test or scenario compares or reuses a number row across a write to an earlier date, and
  the shell keys rows by offset and reads each entry off the row it is rendering at tap time.
- A range change puts a new era on the commitment from the commitments screen's today and moves no
  record; a number outside a range is refused, told "Must be between …", and writes nothing.
- The shell opens a typed entry in an `.alert` whose `TextField` takes the hint as its placeholder
  and opens holding `entry.number` as editable text, unselected, cursor at the end.

## Goals / Non-Goals

- **Goals.** A typed entry opens on its starting number, as the delta says, with the hint left in
  place for an emptied field; the seam saying it; the row's identity counting it.
- **Non-Goals.** A starting number for a note or a total entry, or anything pre-chosen in a chosen
  one. A line saying which day a starting number came from (settled 1). Any change to what `record`
  answers publicly, to `DayScreen`, or to what a commitments screen takes. Selecting the field's
  text on open (settled 3).

## Decisions

### The seam

```swift
public let DayView.NumberEntry.startingNumber: Decimal?
let DayView.Row.startingNumber: Decimal?
func History.latestNumber(for commitment: Commitment, before date: CalendarDate) -> Decimal?
```

Day-view scenarios drive `DayView.Row.numberEntry(asOf:)` from a `History`; day-screen scenarios
drive `DayScreen` at its places, the era ones through a `CommitmentsScreen` first, as the carried
era scenario already does. `DayScreen.enter(_:on:)` is unchanged: a starting number committed as it
is said is simply a number committed.

### The row works the starting number out at formation, and it is part of the row

`makeGroups` asks `History.latestNumber(for:before:)` for a number row whose day holds none, and keeps
the answer only where the row's own range is not short and holds it, bounds included; the row stores
the result and `numberEntry(asOf:)` hands it out. A row is a value formed from a history as it stood
(the carried *A day view is a value and nothing else*), so the row has to hold it, and two rows
saying different starting numbers are then different rows — the MODIFIED *A row is …* says so.
- *Custom equality leaving it out:* rejected — a row comparing equal to a stale one is how a list row
  has stayed undrawn after a save before; a restore would leave the old starting number in the tap.
- *Store the raw latest number and filter in `numberEntry`:* rejected — two rows saying the same
  entry would differ on a number neither says.

### The query stays package-internal, inside `day-screen`

`latestNumber(for:before:)` is internal to the kit and specified only through what the entry says.
It scans `numbers` once, keeping the latest date earlier than `date` whose key compares equal to
`commitment` — every era alike, by identity.
- *A public `History` member and a `record` requirement for it:* rejected — it would make this Story
  a second capability's for a question only the day screen asks.

### A refused latest number is none, never a reach further back

Settled 2. The range check is the same inclusive comparison `Number.init` makes, against the row's
own commitment, so the entry never offers what committing it would refuse.
- *Walk back to the latest number that fits:* rejected at the grill — it can surface a number months old.

### The hint is left alone

Settled 5. `hint` stays set beside a starting number; the shell's placeholder shows it only while the
field is empty, which is exactly "said for an empty field". Nothing in the kit clears it.

### The shell rides this Story

ADR-1019's three conditions hold: `ContentView` is the immediate consumer and adds no rule. A typed
row's tap opens its alert holding `entry.number`, or else `entry.startingNumber`, as the text it
already writes for a held number. Save and Cancel are unchanged, so cancelling records nothing.

### Migration

None — no persisted type and no encoding changes.

## Risks / Trade-offs

- The query walks every number the history holds, once per number row per day view formed, three
  day views per move. → A record of years is thousands of entries; if a phone shows it, an index by
  identity is a kit change with no delta.
- A starting number's text is the `Decimal`'s own description, as a held number's already is; one
  `TypedNumber` could not read back would be told "not a number". → The walk's `phone:` step saves one
  unchanged, and 4.3 commits one as it is said.

## Open Questions

None. `grill.md` § *Left open* is "None." and writing the delta raised no residual round: every
question it turned on was a fact, answered in § Context above.
