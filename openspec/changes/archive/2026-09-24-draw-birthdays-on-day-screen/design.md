## Context

See `proposal.md` § *Why*, and `grill.md`, whose eleven settled answers this delta is written on.
The facts the shape turns on, read off this worktree:

- **The Kit imports Foundation only.** `Birthday`, `BirthdayTicks` and `BirthdayStore` (#326) and
  `BirthdaySwitch` (#327) ship; nothing in the Kit reads a calendar, and no birthday place is named.
- **`DayScreen` opens its one-off place at `init` and `shown(asOf:)` only**; `returnedTo` reads the
  roster, and the record where kept. The day either side is formed from what the screen holds.
- **The one-off group is `DayView.oneOffGroup`, not a fifth `Group`**, and one `Notice` names a row
  of either kind. The shipped day-screen spec says the capability consults no locale.
- **The seeded roster starts on 4 September 2026**, so the day picker reaches no earlier; a chevron
  move is unbounded. On a future date every due commitment row is drawn, faded.
- **The simulator's sample contacts carry birthdays through EventKit** with no seeding (grill 10).
- **#329 `carry-birthdays-in-a-copy` is open**, with no change folder yet, and will touch `DayScreen`.

## Goals / Non-Goals

**Goals:** every rule drivable as a Kit test against a fake calendar and a fake phone, with no
EventKit; the existing `DayScreen` seam widened rather than a new one; nothing in the Kit ordering by
a locale it reads for itself.

**Non-Goals:** no copy and no restore of birthday ticks — `saysACopyCanBeRestored` and the
after-a-restore return are unchanged, and a birthday tick writes no copy, since `restore` scopes
copying to the three places (#329 owns all three); no look-back (settlement 4); no ADR — nothing
here is expensive to reverse.

## Decisions

### The seam

```swift
public struct BirthdayCalendar { public init(reading: @escaping @MainActor (_ first: CalendarDate, _ last: CalendarDate) throws -> [Birthday], collating: @escaping (_ words: String, _ before: String) -> Bool) }
public static var birthdayPlace: URL { get }                                  // DayScreen
public enum BirthdayState: Equatable, Sendable { case off, on, calendarUnreadable, ticksUnreadable, ticksWrittenByALaterVersion }   // DayScreen
public init(startingFrom dayOne: [Commitment], asOf today: CalendarDate, keepingRecordAt recordPlace: URL = DayScreen.recordPlace, keepingRosterAt rosterPlace: URL = DayScreen.rosterPlace, keepingOneOffsAt oneOffPlace: URL = DayScreen.oneOffPlace, keepingBirthdayTicksAt birthdayPlace: URL = DayScreen.birthdayPlace, readingBirthdaysFrom calendar: BirthdayCalendar? = nil, whileOn birthdaySwitch: BirthdaySwitch? = nil, copyingTo copyPlace: CopyPlace? = nil)
public private(set) var birthdayState: BirthdayState                            // DayScreen
public func tick(_ row: DayView.BirthdayRow) throws                             // DayScreen
public let birthdayRow: DayView.BirthdayRow?                                    // DayScreen.Notice
public struct BirthdayRow: Hashable, Sendable { public var words: String { get }; public let isTicked: Bool; public func offersTick(asOf today: CalendarDate) -> Bool }   // DayView
public struct BirthdayGroup: Hashable, Sendable { public let heading: String; public let rows: [BirthdayRow] }   // DayView
public let birthdayGroup: BirthdayGroup?                                        // DayView
```

### The calendar is handed in, and the Kit orders by the collation it is handed

The shell reads EventKit; the Kit is handed a reader and the phone's collation, as it is handed a
today, and sorts by words, then by contact with `<` (settlement 9). The sort is then under test.
- *Rejected:* the shell sorts — the order would sit untested, which is settlement 9's whole reason.
- *Rejected:* `localizedStandardCompare` in the Kit — reads the locale the shipped spec forbids.

### Asked once per forming of the shown day, for three days

The calendar cannot be held whole (1583 to 9999), and a picked day needs its own year's occurrence.
So each forming of the shown day asks for the day before through the day after, clamped at either
end, and the neighbours reuse that answer, which keeps saying either a read of nothing.
- *Rejected:* one ask per day view — saying either would ask. A window at opening — a picked day misses it.

### The switch at every forming, the birthday place at opening and showing

The switch is turned on elsewhere, so forming reads `isOn` and `returnedTo` follows it. The place is
opened as the one-off place is, whatever the switch says — ticks are not birthdays. `shown(asOf:)`
calls `birthdaySwitch.shown()` first (settlement 6's withdrawn access).
- *Rejected:* reopening the place on return — breaks "anything that lasts until shown stands".

### One state, the calendar first

One value, so the shell never picks a line: `off`, then `calendarUnreadable`, then the ticks.
Settlement 7 says unreadable ticks work as an unreadable record does, which tells a later version
apart, as `CONTEXT.md` § *Copy* (2026-09-21) wants of every file: a reading, one scenario to drop.

### A group of its own, mirroring the one-offs

`birthdayGroup` beside `oneOffGroup`, never a `Group`. "Before every commitment group" is the shell's
drawing, which no seam test sees; walk W.5 shows it on 22 June 2027, where commitment rows are drawn.

### Three requirements modified by one sentence each

A day view's equality, a notice's end, what being shown again carries. All three were over 150 words
before this delta and are carried whole; splitting them is an editorial Story's, not this one's.

### Migration

None — additive: the birthday place is a new file, `ApplicationSupport/DayByDay/birthday-ticks.json`,
in the form #326 already fixed.

### The shell

- The adapter, in `BirthdayCalendarAccess.swift`: throws unless access is full; reads the span's
  events on calendars of type `.birthday` as `birthdayContactIdentifier`, title and start day, skipping
  one with no identifier. No birthday calendar answers no birthdays — **a judgement**: an unreadable
  line would never clear. Collation: `localizedStandardCompare`.
- `ContentView` hands the switch and the adapter to the screen, and drops its own scene-phase
  `birthdaySwitch.shown()`. After the one-off lines, red caption: "Birthdays could not be read.", "The
  birthday ticks could not be read.", "The birthday ticks were written by a newer version of DayByDay
  and must not be deleted."
- The *Birthdays* section first in each day's list, headed like a category, its rows keyed by offset
  so two alike cannot collide. A row is `Text(verbatim:)` words, grey and struck through with the
  green check when ticked, faded to 0.5 where it offers no tick; a tap ticks; the notice line under
  it reads "Not saved. Try again."

### What the shell draws

Option A, *Like commitments*, chosen at the layout round from https://claude.ai/artifact/1hmUvWBxgCyCH3hsgcrQVy.

```
A · Like commitments
┌─────────────────────────────┐
│ (Today)     (Commitments +) │
│  <     Tue [20 Jan 2026]  > │
│                             │
│  Birthdays                  │
│ ┌─────────────────────────┐ │
│ │ K̶a̶t̶e̶ ̶B̶e̶l̶l̶’̶s̶ ̶4̶8̶t̶h̶ ̶B̶i̶r̶t̶h̶d̶a̶y̶  ✓ │ │
│ └─────────────────────────┘ │
│   (12 pt)                   │
│ ┌─────────────────────────┐ │
│ │ C̶r̶e̶a̶t̶i̶n̶e̶ - Every day    ✓ │ │
│ │ Magnesium - Every day   │ │
│ │ Run - Tue, Thu, Sun     │ │
│ └─────────────────────────┘ │
│  One-offs                   │
│ ┌─────────────────────────┐ │
│ │ New one-off             │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

## Risks / Trade-offs

- **The likeliest wrong implementation keeps the calendar's order.** → The order scenario hands the
  words out of order and asks again under the reverse collation.
- **The second asks before showing the switch, or asks to say a neighbour.** → Two scenarios count
  the calendar's asks.
- **An `EKEventStore` made before access was given may read nothing until reset.** → The adapter reads
  through a store made or reset after the grant; W.2 comes straight after turning birthdays on.
- **W.2's 20 January 2026 lies before the picker's reach.** → The walk pages back by chevron, over
  two hundred moves; slow, and drivable.
- **#329 widens the same `DayScreen`.** → Whichever merges second rebases; a conflict in this folder
  or `openspec/specs/` is a stop.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and it left the calendar's seam to this
design, which the decisions above take. Writing the delta raised nothing that needed the owner: the
later-version line is read from settlement 7, and the one judgement — no birthday calendar reads as
no birthdays — is named where it is made. No residual round is outstanding.
