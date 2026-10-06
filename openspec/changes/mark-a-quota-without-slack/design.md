## Context

See `proposal.md` § *Why*, and `grill.md`, whose three settled answers and six upstream decisions
this delta is written on. The facts the shape turns on, read off `origin/main` at e65783c:

- **A weekly-quota row stores its standing at formation** — `DayView.Row.WeekStanding`, the days
  kept from its week's Monday through its date and what the week owes, read by `WeekQuota` off the
  commitment's whole chain — and `rhythmInWords` says both. The row gives back four things and
  never the standing itself.
- **`DayScreen` holds its today privately**; only `init` and `shown(asOf:)` set it. The shell hands
  every `asOf:` member on a row the device clock (`ContentView.today()`), so a row member taking a
  today from the shell would follow the clock, which the grill's facts rule out.
- **Every day after today in today's week is held by the era today's row is on**, so the days left
  in the week are the row's date through its Sunday, with no gap to subtract.
- **A quota is 1 to 7 times a week**, so no week is lost on a Monday: it owes at most 7, and 7 days
  are left.
- **`commitmentLine` composes a row's name and rhythm as one `Text`** that wraps as one run; the
  trailing slot draws the green checkmark alone (ADR-1045 § *Decision 8*).
- **`Text.accessibilityLabel(_:)` returns `Text`** in this SDK's SwiftUI interface, so a labelled
  glyph can join the same run of text.

## Goals / Non-Goals

**Goals:** the mark of the delta, answered by the Kit in its own words and drawn by the shell
beside the count, every rule drivable through `DayScreen`.

**Non-Goals:** no change to what a row is, gives back or says; no colour in the trailing slot; no
mark on the look-back, the commitments screen or a past or later day; nothing counted across weeks.

## Decisions

### The seam

```swift
public func mark(on row: DayView.Row) -> String?  // on DayScreen
func hasNoSlack(on today: CalendarDate) -> Bool  // on DayView.Row, internal
```

### The screen answers the mark, not the row

`DayScreen.mark(on:)` compares the row's date with the screen's own today and asks the row the
rest. The today is then the screen's by construction, and a row's equality, its four answers and
both row requirements stay exactly as shipped.
- *Rejected:* `Row.mark(asOf:)` — the shell would hand it the clock, and a MODIFIED *A row gives
  back what a screen draws* would be owed.
- *Rejected:* the mark stored in the row at formation — changes row equality, and *A row is its
  commitment, its date and what that day holds* would be carried whole as MODIFIED.

### Slack is read off the row's own standing

`hasNoSlack(on:)` is true exactly when the row is on a weekly quota, its date is `today`, it is
not kept, and `owed - kept` equals the days from its date through its Sunday — `7 -
WeekQuota.monday(of: date).days(until: date)`. Equality, not "at least": a week owing more than is
left is a lost week and gets nothing. The numbers are the ones `rhythmInWords` says, so the mark
and the count can never disagree.
- *Rejected:* recounting through `WeekQuota.standing` at the ask — a second reading of one week.

### The words are the Kit's, the glyph is the shell's

The member returns "Needed today" or `nil`, never a `Bool`, so the shell composes no words
(ADR-1034's rule for rhythm words, applied to the mark). The shell draws a glyph and reads that
string aloud as its label.
- *Rejected:* a `Bool` and a literal in the shell — the words would live where no test reads them.

### The shell

`rowView` reads `screen.mark(on: row)` for every row on all three pages, so today's page marks
wherever it sits. `commitmentLine` takes `mark: String? = nil` and, where given, appends
`Text(Image(systemName:))` at `.caption`, in `Color.primary`, `.accessibilityLabel(mark)`, inside
the same composed `Text`; the commitments screen's calls are unchanged. The symbol starts as
`exclamationmark.circle`, the designer's placeholder, and is a build-time value the owner tunes on
the phone without a delta. The trailing slot, the strikethrough and the checkmark are untouched.

### What the shell draws

Option C, *Beside the count*, from https://claude.ai/artifact/DC6BnHvXLZxFXk8oXcbGe3.

```
C · Beside the count   (recommended)
┌─────────────────────────────────────┐
│                         [ ≡   ⚙ ]   │
│ Thursday                            │
│ Today, 8 October 2026               │
│ ‹  M  T  W (T) F  S  S  ›           │
│    5  6  7 (8) 9 10 11              │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ C̶r̶e̶a̶t̶i̶n̶e̶ - Every day          ✓ │ │
│ │ Magnesium - Every day           │ │
│ │ Run - Tue, Thu, Sun             │ │
│ │ Yuno - 1/5x a week (!)          │ │  1
│ │ Gym - 1/3x a week               │ │
│ │ Pages - 0/4x a week (!)       › │ │  2
│ │ Weight - Every day            › │ │
│ └─────────────────────────────────┘ │
│ ( New one-off                     ) │
└─────────────────────────────────────┘
mark: caption-size glyph after the row's words, in the same run of text, label colour;
it wraps with the words and the trailing slot is untouched
```

### Migration

None — nothing persisted changes.

## Risks / Trade-offs

- **The likeliest wrong implementation compares with the day shown, or with the clock.** → Two
  scenarios move the shown day off today, one each way, and one shows the screen again.
- **The next likeliest tests "owes at least the days left"**, marking a lost week. → A scenario of
  a lost week, and a seven-times week one day after a miss.
- **A partial total reads as "something done today".** → A scenario of a total short of target.
- **The walk runs on the simulator's own day.** → Its fixtures are shaped to that weekday, and it
  is not run on a Monday, when no week can be lost and yesterday is last week (`tasks.md`).

## Open Questions

None. `grill.md` § *Left open* is "None.", and writing the delta raised no question that is the
owner's: the seam, the equality reading of slack and the glyph's starting symbol are facts or
build-time values. No residual round is outstanding.
