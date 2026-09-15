## Why

The commitment sheet tells every refusal in one place at the foot of its first section, so a person
who typed a name of blank space reads the same red line as one whose roster could not be written,
and has to work out which field it is about. A new commitment's weekday chips also open with nothing
lit, which is exactly the state the screen refuses.

## What Changes

- A commitments screen says which field of its sheet a refusal it answers is about, beside the
  refused change it already holds.
- A refusal about the name, the rhythm, the range, the target or the restart day is about that
  field; one about the whole change — already kept, records already there, a place that could not be
  written — is about no field and is told at the foot of the form.
- A refusal about either the rhythm or the day kept from is about whichever of the two the ask
  differs in, and about the whole change where it differs in both.
- What the sheet tells ends when the field it is under is edited, when the next ask is made,
  when the sheet closes and when the app is shown again; another field being edited leaves it
  standing, and no edit at all ends one told at the foot.
- A commitments screen offers all seven weekdays for a rhythm's weekday chips, as it already
  offers a kind and a day to keep from.
- The sheet draws each refusal under the control it names, fills empty chips from the seven
  offered, and tells the screen when a field is edited and when it closes.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: four added requirements — which field of the sheet a refusal is about, the one
  ambiguous between the rhythm and the day kept from, how long what the sheet tells lasts, and the
  weekdays offered for empty chips. No existing requirement changes.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift` — the value the sheet reads, the
  two calls that end it, and the weekdays offered.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the sheet draws from that value instead of its own
  two copies, starts empty chips from the seven offered, and says when a field is edited.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — one acceptance test per scenario.
- `CONTEXT.md` — the word for what the sheet tells, beside the refused change.
