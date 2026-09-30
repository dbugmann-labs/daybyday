## Why

A total is added to several times a day, and most of those additions are the same few amounts: the
35 grams of protein in the morning's müesli, the 30 in a shake. Each is typed out again every time.
A total that declares its usual amounts offers each as one tap beside the typed field, so the common
addition costs a tap and an unusual one is still typed.

## What Changes

- A total commitment declares up to five usual amounts, each an amount above zero with a name or
  none; two that would read alike are refused, and they are always answered smallest first.
- A roster declares them on every era of a commitment, kept or stopped, and declaring puts no era on.
- The roster store keeps them in a new form, reads every earlier form as declaring none, and refuses
  stored usual amounts no total could declare.
- The commitments screen takes them as typed on its sheet, beside the rest of a define or a change,
  and refuses a bad amount, a repeat or a sixth under the row it is about; it offers no sixth row.
- The commitments screen says the usual amounts a commitment declares; a stopped one's can change.
- A total entry says the usual amounts beside the sum and the target, and a row differs by them.
- A day screen adds a tapped usual amount as it adds a typed one; *Take back last* undoes it.
- The shell draws the usual amounts in a card of their own on the commitment sheet, and the total
  entry becomes a half-height sheet listing them under the field, which opens with the keyboard up.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: ADDED — a usual amount, declaring them on a roster, the five-and-alike rule and the
  order, keeping them at the roster place, reading them off the sheet, offering no sixth row.
  MODIFIED — what a commitment is made of, a change (renamed), a define, and the forms a roster
  store reads.
- `day-screen`: ADDED — adding a tapped usual amount. MODIFIED — what a total entry says (renamed),
  and what a row is.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `Commitment`'s kinds, `Roster`, `RosterDocument` and
  `RosterStore`, `CommitmentsScreen`, `DayView` and `DayScreen`.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — the roster, roster store, commitments screen, day view
  and day screen tests.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — a usual amounts card on the commitment sheet.
- `src/DayByDay/DayByDay/ContentView.swift` — the total entry moves from an alert to a sheet.
- `CONTEXT.md` — § *Total entry*.
