## Context

See `proposal.md` § *Why*, and `grill.md`, whose settled answers this delta is written on, 12 to 18
where they replace earlier ones. The facts the shape turns on, read off this worktree:

- **`weekStrip` is computed from `shownDay`, `today` and `dayPickerReach` at each read**, and the
  neighbour strips are the same computation handed the day a page would land on. That computation
  marks the day it is handed as shown: the second filled capsule the owner saw mid-swipe.
- **The reach's earliest day is the earlier of the roster's floor and the day being shown.** So it
  follows the shown day below the floor, and it can lie after the today only while the shown day
  does.
- **`showDay(_:)` refuses a day earlier than that earliest day**, the today included; `showToday()`
  never refuses.
- **The strip's drag is recognised at 40 points**, and its offset is then set to the whole
  translation, so the strip jumps by that distance on its first sample: the hop.
- **The neighbour weeks are drawn beside the shown one, offset past its frame and clipped**, and
  their offered cells are `Button`s, as the shown week's are.
- **The strip sits in `dayControls`**, outside `pagedDayContent` and uncontested by the day swipe.

## Goals / Non-Goals

**Goals:** every landing rule under Kit test, the shell deciding nothing but whether a drag carried
and which chevron is faded.

**Non-Goals:** any change to the day swipe, the strip tap, the day picker or `Today`; the one-day
chevrons #346 removed, which stay gone; any mark of how a day went. No requirement is MODIFIED: a page
is a change of the day being shown, which every rule about such a change already speaks of without
naming the gesture.

## Decisions

### The seam

```swift
public func showPreviousWeek()                          // DayScreen
public func showNextWeek()                              // DayScreen
public var previousWeekStrip: [WeekStripDay]? { get }   // DayScreen — computed, never stored
public var nextWeekStrip: [WeekStripDay]? { get }       // DayScreen — computed, never stored
```

### One landing rule, read by the page and by the strip beside it

A private landing function answers the day a page would land on, or none: the same weekday; past the
calendar's last date, that date; below the reach as it stands, its earliest day where the week holds
it; none otherwise. `showPreviousWeek()` and `showNextWeek()` apply it as `showPreviousDay()` applies
its step, and the neighbour strips hand it to the strip computation, so page and preview agree.
- *Rejected:* landing through `showDay(_:)` — its guard is the pick's, and the neighbour strips need
  the landing without the move, so two computations could disagree.
- *Rejected:* the shell finding the neighbour weeks — it can read no weekday (ADR-1019).

### A neighbour strip marks no day as shown, and offers the day it would land on

`grill.md` 15, said by the Kit. Were the shell to ignore `isShown`, the landing day would still be
unoffered, so it would draw faded with no capsule, and the shell would have to decide its fade.
Offering it draws every day the page would reach at full strength and those below the reach faded.
- *Rejected:* a fourth mark, "would land here" — nothing draws it, and 15 asks for none.

### A neighbour strip is absent exactly where its page does nothing

The day neighbours are `nil` only at the calendar's ends; the reach refuses a page back far more
often, and the shell must neither slide the strip onto a week it cannot land in nor offer a chevron
there. So `nil` is a promise the shell stands the gesture down and fades the chevron on.
- *Rejected:* a separate `offersPreviousWeek: Bool` — the shell needs the dates under the finger
  anyway, and two answers could disagree.

### The today has no exception, against the reach included: decided from the settled answers

`grill.md` 13 drops the today's exception and marks 8 moot, and 14 lands a weekday below the reach on
its earliest day. So where every commitment is kept from after the today, a page back onto the
today's weekday lands on the reach's earliest day like any other, and no page reaches a week before
the reach's; `Today` is offered wherever the today is not shown.
- *Rejected:* keeping 8 for the one page whose weekday is the today — 13 says no exception.

### The shell (ADR-1019: no rule the Kit does not state)

A `chevron.left` and a `chevron.right`, borderless buttons labelled "Week before" and "Week after",
sit either side of the strip in its row and stay put; the three weeks slide between them, clipped
to the strip's own narrower width. A chevron is faded and takes no tap where its neighbour strip is
`nil` (ADR-1045). A tap commits a focused one-off field for departure, settles the strip a week over,
then calls the page, as ADR-1043 has a chevron play the settle a drag ends with.

A horizontal drag on the strip tracks the finger from the first sample it reports, with no jump at
recognition, resisting where the neighbour it would reveal is `nil`; left reveals the week after.
Past a third of the width it carries as a chevron tap does. Either way `pagedDayContent` does not
slide: its rows are replaced where they stand. Reduce Motion makes the settle instant. A drag begun
on an offered cell MUST take the touch from that cell's `Button`; a mostly vertical drag does
nothing.

Only the chevrons and the shown week's offered cells take a tap. The neighbour weeks MUST take none,
and a tap beside the strip, either screen edge included, MUST NOT page or move the day. The first
suspect for the left-edge defect is a neighbour's cell reaching past the clip; the implementer
confirms the cause before fixing it. The day swipe, the strip tap and the redraw-in-place under the
day swipe are untouched.

### What the shell draws

Option A, beside the strip, chosen at G7 from https://claude.ai/artifact/WDABFfjUCLnVw7tdomKRdR.

```
┌─────────────────────────────────────┐
│ (Today)            (Commitments  +) │
│ Wednesday                           │
│ 30 September 2026                   │
│ ‹  M   T   W   T   F   S   S  ›     │
│    28  29 (30)  1   2   3   4       │
├─────────────────────────────────────┤
│ rows …                              │
```

### The records

ADR-1042's 2026-09-28 page amendment, this change's own, is edited in place to bring the chevrons
back beside the strip as the week's, not the day's. `CONTEXT.md` § *Week strip* carries the grill's
G7 amendment; the delta turned up no further term.

### Migration

None — nothing persisted changes.

## Risks / Trade-offs

- **A page landed on the Monday or the today, as the first build did.** → The same-weekday
  scenarios, and the today-included reach scenario.
- **A neighbour strip still marking its landing day as shown.** → The marks-no-day scenario; the
  `phone:` step shows the week sliding in with no filled capsule.
- **A neighbour strip read off the current reach.** → The scenario that moves the day seven back
  below a later roster and reads the week after.
- **A neighbour week's cells, or the strip's drag and a cell's `Button`, both taking one touch.** →
  The shell decision forbids both; the `phone:` step checks them, since XCUITest's synthetic drags
  have not matched a thumb (B-041).
- **A narrower strip, an upright pill for a capsule, a `‹` on the left screen edge.** → The owner
  took all three at the layout round, over the designer's recommended pair on the date row.
- **Two horizontal swipes in one screen, a head's-width apart.** → The owner chose it at the grill;
  the strip's reads a week and the rows' a day, and both move the day the same way.

## Open Questions

None. `grill.md` § *Left open* is "None." and left the seam's shape to this change; it is unchanged
at the reopen, since only what the strips mark and where a page lands move. Writing the delta turned
up one edge, the today's weekday below a reach that starts after the today, which 13, 14 and 8's
being moot already decide, so no residual round is outstanding.
