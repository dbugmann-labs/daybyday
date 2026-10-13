## Why

A total's entry offers *Take back last* and says nothing of what it will remove, so a person who
does not remember the last amount they added takes it back blind. This Story makes the take-back say
its amount before it is tapped — "Take back last (35)" — and changes nothing else on the sheet.
Listing a day's additions stays out (`grill.md` § *Settled* 1).

## What Changes

- A row that offers taking back its day's last addition says that addition's amount in the
  take-back's words, "Take back last (35)", and a row that offers no take-back says no such words.
- The amount is said as the day's sum is said, with no digit added or dropped, and never as a usual
  amount's name.
- A history may give out its day's last addition, and still no addition before it.
- What a total row is grows by its day's last addition: two rows whose days sum alike but end in
  different amounts are different rows.
- The total entry sheet's take-back button draws the row's words in place of its fixed label.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `record`: one MODIFIED.
- `day-screen`: one ADDED, two MODIFIED.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `History`, `DayView`.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new tests beside the carried ones, and the one carried
  test whose scenario this delta rewrites.
- `src/DayByDay/DayByDay/ContentView.swift` — the take-back button's label.
- `CONTEXT.md` — an amendment to *Row*.
