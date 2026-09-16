## Why

A number's range and a total's target are set when a commitment is defined and can never be
corrected: a range typed too narrow, or a target set before the person knew what it should be,
leaves the commitment wrong for as long as it is kept. The sheet already draws both fields on a
change, prefilled and disabled, so the only thing missing is the act behind them.

## What Changes

- A change is asked with the range or the target its kind has room for, beside the name, the
  rhythm, the day kept from and the category.
- A different range or a different target supersedes, exactly as a different rhythm does: the
  commitment is kept until the day before the day the screen was handed, and the one the change
  names is taken on from that day.
- A range added to a number commitment carrying none, and a range taken off, supersede too.
- A commitment carried over keeps the range or target it already has; only the commitment taken
  on in the supersession carries the new one.
- A range that is not a range, and a target that is not a target, are refused on a change on the
  same grounds they are refused on a define, each about its own field of the sheet.
- A stopped commitment takes neither: the refusal is the one it already makes for a rhythm, and
  it is told under the range or target field where that is the only thing differing.
- What a commitment is made of says whether the range or target can be changed, so the sheet
  greys both on a stopped commitment as it already greys the rhythm.
- A look-back chains eras by the name and the kind's sort, so a commitment whose range or target
  changed still says the day it was first kept from.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: MODIFIED — what a commitment to be changed is made of, which act a change needs,
  what a change is refused for; REMOVED and ADDED — which field of the sheet a refusal about the
  rhythm, the day kept from, the range or the target is about.
- `look-back`: MODIFIED — resemblance reads the kind's sort and not the range or target it
  carries.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift` — `change`, `whatItIsMadeOf`,
  the refusal placement, two renamed members.
- `src/DayByDayKit/Sources/DayByDayKit/LookBack.swift` — the chain's resemblance.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the range row and the target field take a thumb
  on a change, grey on a stopped commitment, and the save passes what they hold.
- `src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenTests.swift` and `LookBackTests.swift`.
