## Context

See `proposal.md` § *Why*, and `grill.md`, whose eleven settled answers this delta is written on. The
facts the shape turns on, read off this worktree:

- **`weekStrip` is computed from `shownDay`, `today` and `dayPickerReach` at each read.** A strip for
  any other shown day is the same computation handed that day and the reach it would give.
- **The reach's earliest day is the earlier of the roster's floor and the day being shown.** So it
  follows the shown day below the floor, and it can lie after the today only while the shown day
  does.
- **`showDay(_:)` refuses a day earlier than that earliest day**, the today included; `showToday()`
  never refuses.
- **The day swipe resists on a `nil` neighbour.** `daySwipeGesture` reads `previousDayView` and
  `nextDayView` to decide whether the page tracks the finger, and calls the move only after
  `settle(to:then:)` has finished the slide.
- **The strip is a plain `HStack` of seven cells in `dayControls`**, each offered cell a `Button`,
  outside `pagedDayContent` and uncontested by the day swipe.

## Goals / Non-Goals

**Goals:** every landing rule under Kit test, the shell deciding nothing but whether a drag carried.

**Non-Goals:** any change to the day swipe, the strip tap, the day picker or `Today`; a VoiceOver
page action (the day picker reaches every week); any mark of how a day went. No requirement is
MODIFIED: a page is a change of the day being shown, which every rule about such a change already
speaks of without naming the gesture.

## Decisions

### The seam

```swift
public func showPreviousWeek()                          // DayScreen
public func showNextWeek()                              // DayScreen
public var previousWeekStrip: [WeekStripDay]? { get }   // DayScreen — computed, never stored
public var nextWeekStrip: [WeekStripDay]? { get }       // DayScreen — computed, never stored
```

### One landing rule, read by the page and by the strip beside it

A private landing function answers the day a page would land on, or none. `showPreviousWeek()` and
`showNextWeek()` apply it as `showPreviousDay()` applies its step — clearing what is told, forming
the day view — and the two neighbour strips hand it to the strip computation with the reach it
would give. The page and its preview therefore cannot disagree.
- *Rejected:* landing through `showDay(_:)` — it refuses the today below the reach, which the second
  requirement's today clause forbids, and its guard is the pick's rather than the page's.
- *Rejected:* the shell finding the neighbour weeks — it can read no weekday (ADR-1019).

### A neighbour strip is absent exactly where its page does nothing

The day neighbours are `nil` only at the calendar's ends; the reach refuses a page back far more
often, and the shell must not slide the strip onto a week it cannot land in. So `nil` here is a
promise the shell may stand the gesture down on, which the day neighbours' requirement forbids for
theirs.
- *Rejected:* a separate `offersPreviousWeek: Bool` — the shell needs the dates under the finger
  anyway, and two answers could disagree.

### The today more than a week before the reach: decided from the settled answers, not asked

Where every commitment is kept from more than a week after the today and the shown day is later
still, the week before the reach's week holds neither the today nor a reachable day. `grill.md` 2
bounds a page back at the reach's week and 8 widens it only for a page *into* the today's week, so
that page does nothing; `Today` stays on screen. `CONTEXT.md` § *Week strip* gains the clause.
- *Rejected:* jumping straight to the today's week — a page several weeks long, which 2 rules out.

### The shell (ADR-1019: no rule the Kit does not state)

`weekStrip` draws `previousWeekStrip`, `weekStrip` and `nextWeekStrip` side by side, clipped to the
strip's own width and offset by a translation of its own, as `pagedDayContent` does the rows. A
horizontal drag on the strip tracks the finger, resisting where the neighbour it would reveal is
`nil`; left reveals the week after. Past a third of the width it commits a focused one-off field for
departure, settles the strip, then calls the page, and `pagedDayContent` does not slide: its rows
are replaced where they stand. Reduce Motion makes the settle instant, as for the rows. A drag that
starts on an offered cell MUST take the touch from that cell's `Button` before it can fire, so a
swipe never taps the day it began on; a mostly vertical drag does nothing. The day swipe, the strip
tap and the redraw-in-place under the day swipe are untouched.

### The records

ADR-1042 is amended: the strip claims a horizontal swipe inside its own bounds, which that record's
*A control that owns its own bounds* consequence already allows, and no row gains one. `CONTEXT.md`
§ *Week strip* carries the grill's amendment and the clause above.

### Migration

None — nothing persisted changes.

## Risks / Trade-offs

- **The page landed through `showDay(_:)`.** → The today-however-late scenario lands below the
  reach, which `showDay(_:)` refuses.
- **A neighbour strip read off the current reach.** → The week-before strip scenario on a late
  roster offers days the current reach refuses.
- **The strip's drag and its cells' buttons both fire.** → The shell decision forbids it; the
  `phone:` step checks it, since XCUITest's synthetic drags have not matched a thumb (B-041).
- **Two horizontal swipes in one screen, a head's-width apart.** → The owner chose it at the grill;
  the strip's reads a week and the rows' a day, and both move the day the same way.

## Open Questions

None. `grill.md` § *Left open* is "None." and left the seam's shape to this change, taken above.
Writing the delta turned up one edge, the today more than a week before the reach, which the settled
answers already decide, so no residual round is outstanding.
