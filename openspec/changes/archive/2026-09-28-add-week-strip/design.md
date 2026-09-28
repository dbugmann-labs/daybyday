## Context

See `proposal.md` § *Why*, and `grill.md`, whose nine settled answers this delta is written on. The
facts the shape turns on, read off this worktree:

- **`DayScreen.showDay(_:)` is already the tap.** It refuses a day earlier than
  `dayPickerReach.earliest`, changes nothing on the day being shown, clears what the screen is
  telling where the day changes, and reads neither place again.
- **The shell cannot find the seven dates.** `CalendarDate.weekday`, `adding(days:)` and
  `WeekQuota.monday(of:)` are internal to the Kit, and so are `DayScreen`'s `today` and `shownDay`.
  `monday(of:)` stops at 1 January 1583, a Saturday, rather than stepping below it.
- **The head is outside the pages.** `dayControls` sits above `pagedDayContent`, and the day swipe
  is attached to the paged lists alone, so a strip in the head takes taps without contesting it.
- **The chevrons are two buttons calling `playSettle(towards:)`**, which nothing else calls. The
  weekday title and the date row are formatted in the shell from `dayPickerReach.opensOn`.
- **The seeded roster is kept from Friday 4 September 2026**, so the week of 31 August has four days
  before the reach on a fresh install.

## Goals / Non-Goals

**Goals:** the whole strip under Kit test — its days, letters, marks and offers; one new member and
one new value on `DayScreen`, and the tap on the member that already exists.

**Non-Goals:** paging the strip to another week (#347); any mark of kept, missed or due; any change
to the date row's words, the day picker, the `Today` button or the swipe. No requirement is
MODIFIED: showing a strip day is showing a picked day, which the day picker's requirement already
states, and the day title's requirement is untouched by the strip.

## Decisions

### The seam

```swift
public struct WeekStripDay: Hashable, Sendable       // DayScreen
public let letter: String                            // DayScreen.WeekStripDay
public let date: CalendarDate?                       // DayScreen.WeekStripDay
public let isShown: Bool                             // DayScreen.WeekStripDay
public let isToday: Bool                             // DayScreen.WeekStripDay
public let isOffered: Bool                           // DayScreen.WeekStripDay
public var weekStrip: [WeekStripDay] { get }         // DayScreen — computed, always seven
public func showDay(_ day: CalendarDate)             // DayScreen — unchanged; a strip tap calls it
```

### Seven values, each saying everything the shell draws

`weekStrip` is computed from `shownDay`, `today` and `dayPickerReach` at each read, never stored, so
it follows every move, every `shown(asOf:)` and every roster read without a line in any of them. A
day carries its own marks and its own offer, so the shell branches on three booleans and computes
nothing (ADR-1019). The two marks are independent, which is what lets #347's paged week mark no day
as shown without a new shape.
- *Rejected:* `[CalendarDate]` plus the shell asking which is shown — the shell cannot tell a
  weekday, and would decide what is offered, which the delta states.
- *Rejected:* the letters in the shell — they are words the app owns, and a scenario states them.

### A strip tap is the day picker's act, with no member of its own

The shell calls `showDay(day.date!)` on an offered day, so the reach guards the strip exactly as it
guards the calendar, and a day is shown one way however it was reached.
- *Rejected:* `showDay(_ day: WeekStripDay)` — a second entry to one act, which an existing seam
  already carries.

### Past either end of the calendar: the letter, and no date

The week of 1 January 1583 begins on a Monday the calendar does not support, as the week of 31
December 9999 ends on a Sunday. Such a day keeps its slot and its letter, holds no date and is not
offered, so the strip is seven slots at every week and the shell never places a day by its weekday.
Not put to the owner: no person reaches those two weeks, and it moves nothing they would see.
- *Rejected:* a shorter strip — the shell would have to place five days by a weekday it cannot read.

### The shell (ADR-1019: no rule the Kit does not state)

`dayControls` loses both chevrons and `playSettle(towards:)`; the date row moves to the leading
edge, and the strip goes under it, seven equal columns of letter over `date.day`. `isShown` draws
the capsule, `isToday` the blue; a day neither shown nor offered takes ADR-1045 decision 5's opacity
and no tap, and a day with no date draws its letter alone. An offered day's tap commits a focused
one-off field for departure, then calls `showDay`, with no settle and no animation. Each day is a
button whose accessibility label is its date in full, so VoiceOver does not say "T". The strip
reads `screen.weekStrip` and nothing else, so it redraws when the day lands and never during a drag.

### What the shell draws

Option B, the named-day capsule, with option A's single letters, from
https://claude.ai/artifact/6HeCvdyn4XF91hycx5t2f3 (`grill.md` § *Layout*).

```
┌───────────────────────────────────┐
│ (Today)            (Commitments +)│  Today only when not on today
│ Tuesday                           │  large title
│ 29 September 2026                 │  date row: leading, blue, opens calendar
│  M  ┌───┐  W    T    F    S    S  │  single letter over the day of the month
│  28 │ T │  30   1    2    3    4  │  shown day: capsule round both lines,
│     │29 │                         │    text colour, inverted text
│     └───┘                         │  today (Thu 1): letter and digit blue;
│                                   │    on today the capsule is blue
├───────────────────────────────────┤
│ Creatine - Every day              │
│ Magnesium - Every day             │
│ Run - Tue, Thu, Sun               │
│ Yuno - 0/5x a week                │
│ Weight - Every day              > │
│ One-offs                          │
│ New one-off                       │
└───────────────────────────────────┘
```

### The records

ADR-1042 is amended: the strip, not the chevrons, depicts the swipe, and the swipe stays. ADR-1045
is amended: decision 5's fade reaches a strip day that offers nothing, beyond rows. `CONTEXT.md`
§ *Week strip*, § *Day navigation* and § *Offered* carry what this grill and delta settled.

### Migration

None — nothing persisted changes.

## Risks / Trade-offs

- **Offers read off the roster's floor rather than the reach.** → The scenario moved below the floor
  offers the days between; a floor-based answer refuses them.
- **A strip stored at `init` or at a move.** → The shown-again and returned-to scenarios both change
  the strip with no move on the screen.
- **A strip tap that slides.** → The shell decision forbids it; W.2 and the `phone:` step show it.
- **Two T's and two S's read alike.** → The owner took that cost at the layout round; the
  accessibility label says the date.
- **#347 pages this strip.** → Whichever shape it takes, the two marks here are already independent.

## Open Questions

None. `grill.md` § *Left open* is "None." and left the seam's shape and ADR-1042's words to this
change, which the decisions above and the amendment take. Writing the delta turned up one edge the
grill did not reach, the two weeks at the calendar's ends, decided above as a fact rather than a
preference, so no residual round is outstanding.
