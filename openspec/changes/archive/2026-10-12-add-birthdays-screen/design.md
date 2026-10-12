## Context

See `proposal.md` § *Why*, and `grill.md`, whose six settled answers, three by precedent and layout
this delta is written on. The facts the shape turns on, read off this worktree at `origin/main`:

- **`BirthdayCalendar` already reads a span**, never yet more than three days; EventKit's
  `predicateForEvents` serves up to four years (`EKEventStore.h`), so a year is in range.
- **`ContentView` hands `makeBirthdayCalendar()` straight into the `DayScreen`**, keeping none of
  its own; its one `BirthdaySwitch` is shared, and `DayScreen.shown(asOf:)` shows it first.
- **`CommitmentsScreen` holds neither a calendar nor the switch.** `ContentView` builds one on each
  Commitments tap and another on each Settings tap.
- **The Kit already owns the words a birthday's day needs**: `DayTitle.weekdayNames` ("Sat") and
  `LookBackWords.monthNames` ("November"), both internal, and `DayTitle.shiftedDayInWords` says
  "Thu 27 Aug". The designer's flag that a verbatim seam puts month names back in the Kit is moot:
  they are there, under ADR-1022's rule that anything the Kit says is in its own words.
- **The day screen orders one day's birthdays by collation, then by contact.** A Birthdays screen
  line carries no contact, so two lines whose words collate alike are the same line.
- **No simulator here gets calendar access** (`docs/open-questions.md`, since #328), so every walk
  step with birthdays on is a `phone:` line.

## Goals / Non-Goals

**Goals:** the Birthdays screen and its way in, every rule drivable through `BirthdaysScreen` and
`CommitmentsScreen.offersGoingToBirthdays`.

**Non-Goals:** present ideas (#405, from #408); any tick on this screen; any change to the day
screen's Birthdays group, to `BirthdaySwitch`, `BirthdayCalendar` or any store; notifications.

## Decisions

### The seam

```swift
@MainActor @Observable public final class BirthdaysScreen
public init(asOf today: CalendarDate, readingBirthdaysFrom calendar: BirthdayCalendar, whileOn birthdaySwitch: BirthdaySwitch)  // on BirthdaysScreen
public private(set) var lines: [Line]  // on BirthdaysScreen
public private(set) var birthdayState: BirthdayState  // on BirthdaysScreen
public func shown(asOf today: CalendarDate)  // on BirthdaysScreen
public struct Line: Hashable, Sendable { public let words: String; public let dayInWords: String }  // in BirthdaysScreen
public enum BirthdayState: Equatable, Sendable { case off, calendarUnreadable, on }  // in BirthdaysScreen
whileOn birthdaySwitch: BirthdaySwitch? = nil  // CommitmentsScreen.init, new, before copyingTo
public var offersGoingToBirthdays: Bool { get }  // on CommitmentsScreen
static func birthdayDayInWords(_ day: CalendarDate) -> String  // on DayTitle, internal
```

`CommitmentsScreen.shown(asOf:)` calls `birthdaySwitch?.shown()` first; nothing else in it moves.

### A screen of its own in the Kit, opened by the shell as the day screen is

`BirthdaysScreen` takes the calendar and the switch the day screen takes, and nothing else: no
place, so it reads no tick and writes nothing. Present ideas will hang their store on it.
- *Rejected:* a member on `CommitmentsScreen` — it holds no calendar, and is already the roster's.
- *Rejected:* widening `DayScreen`'s three-day ask — a second screen's span inside the first's.

### The span runs to the day before the same date a year on, not 365 days

From 1 March 2027 a 365-day span ends on 28 February 2028 and misses a 29 February birthday; a date
a year on lists every yearly birthday exactly once. From 29 February it ends on 28 February, and at
31 December 9999 it stops, as the day screen's ask does at either end.

### The way in is the commitments screen's, read live off the switch

`offersGoingToBirthdays` is `birthdaySwitch?.isOn ?? false`, so § *Offered* sits behind the seam and
the shell draws the symbol on it. Only the Commitments tap hands the switch in; Settings' does not.
- *Rejected:* the shell reading `birthdaySwitch.isOn` — a rule where no test reaches it.
- *Rejected:* a requirement in `commitment` — the rule is whether birthdays are on, and the switch's
  rules are `birthday`'s, where `turn-birthdays-on` put them while the switch was on that screen.

### The Birthdays screen reads the switch only when opened and shown

Settled 5: nothing moves under the person. A switch gone off empties it at the next showing, never
in place, and the shell navigates nowhere.

### A calendar that cannot be read is said, as on the day screen

The grill did not reach it; the day screen's answer has one reading, so it is not a residual one.

### The day is said in the Kit, "Today" included

`DayTitle.birthdayDayInWords` says "Sat 14 November" from the two tables above; the screen puts
"Today" in its place for its today. The shell composes no part of a line. No new ADR: ADR-1022.

### What the screen says when it lists nothing is the shell's sentence

As "Nothing noted yet." is on a happening's page: the Kit gives `birthdayState` and empty `lines`,
and the shell draws "Birthdays are off.", "Birthdays could not be read." (the day screen's words)
or, on with nothing listed, "No birthdays in the coming year."

### The shell

`ContentView` holds one `BirthdayCalendar` as `@State`, handed to the `DayScreen` and to every
`BirthdaysScreen`, so one `EKEventStore` backs both. It builds `CommitmentsScreen(asOf:whileOn:
copyingTo:)` on the Commitments tap, builds a `BirthdaysScreen` as of `today()` when the gift is
tapped and pushes it on the same stack, calls its `shown(asOf:)` when the app is shown, and drops
it on the way back. `CommitmentsView` draws `gift` as a `ToolbarItem` labelled "Birthdays", set off
from the ⇅ + capsule by a `ToolbarSpacer`, while `screen.offersGoingToBirthdays`; the push's
`navigationDestination` sits on the list, never on that item. A new `BirthdaysView` has the large
title "Birthdays" and one inset section: each line its words, leading and wrapping, beside
`dayInWords` trailing, secondary, `lineLimit(1)` and never compressed; no chevron, tick or 🎂.
With no lines, the section holds the one sentence above.

### What the shell draws

Option B, *Toolbar gift*, from https://claude.ai/artifact/62a5jdZUwJAJN9Trp63bzg.

```
B · Toolbar gift  (recommended)
┌──────────────────────────────┐   ┌──────────────────────────────┐
│ (<)            (🎁) [⇅  +]   │   │ (<)                          │
│ Commitments        ↑ (1)     │   │ Birthdays                    │
│ ┌ Creatine - Every day   > ┐ │   │ ┌──────────────────────────┐ │
│ │ …                        │ │   │ │ Anna Keller's 35th  Today│ │
│ Stopped                      │   │ │ Birthday                 │ │
│ ┌ Nothing has been stopped.┐ │   │ │ Kate Bell's 48th   Sat 14│ │
│ Happenings                   │   │ │ Birthday         November│ │
│ ┌ Kopfweh … New happening ─┐ │   │ │ …  (date right-aligned,  │ │
└──────────────────────────────┘   │ │     dimmed, never wraps) │ │
 (1) gift symbol in its own glass  │ └──────────────────────────┘ │
     circle, left of the ⇅ + capsule  └──────────────────────────────┘
```

## Risks / Trade-offs

- **A `navigationDestination` on the gift item pops the screen when the item vanishes**, which is
  the navigation settled 5 forbids. → § *The shell* puts it on the list; W.4 goes back first.
- **The likeliest wrong span is 365 days.** → The span scenario opens on 1 March 2027.
- **The likeliest wrong order lets collation outrank the day.** → The collation scenario hands a
  later day's birthday first, worded to collate first.
- **A year's ask reads the calendar synchronously on the main actor**, and only at opening and
  showing. A slow read would show at the tap; the `phone:` lines would show it.
- **#408 will add present ideas here**, so `BirthdaysScreen` will gain members. Nothing here
  forecloses them: a line is a value, and a contact can be added to it then.

## Open Questions

None. `grill.md` § *Left open* is "None." with the reason. Writing the delta reached three edges —
the span's end across a leap day, a calendar that cannot be read, and two lines alike on one day —
and each is decided above, since each has one answer that loses nothing. No residual round is
outstanding.
