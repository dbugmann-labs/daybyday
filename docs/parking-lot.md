# Parking lot

Product ideas captured during scaffolding, deliberately **not acted on**.

**Live as of 2026-08-24**, when the development system was signed off and product definition
began. This is now the holding pen between "someone said it" and "it is agreed": an idea lands
here in one line and the conversation moves on, rather than becoming code by momentum.

An entry leaves this file in exactly one direction — promoted into an Epic or Feature issue,
then deleted from here. Nothing is implemented from this file. An entry that has sat here
through two rounds of Epic intake is telling you something; either promote it or delete it.

## Entries

Surfaced 2026-08-28, in the first product-definition conversation.

The entries describing a day screen, its ticks and the schedule behind them were promoted into
`EPIC: Daily commitments` (#1) on 2026-08-28 and removed. What remains below is either out of
that Epic's scope or still an open question inside it. Nothing here is agreed.

### The seven things being tracked

- weight — a number entered once a day, looked at as a line over months
- protein — a number entered several times a day that accumulates rather than overwrites
- mood — a number set by a single tap, once a day
- journal — two or three sentences a day, deliberately not an essay
- supplements — a daily tick
- sport — a tick tied to a fixed day of the week ("Tuesday is Gym")
- a habit phrased as a negative, where ticking it records that the thing was *not* done

### Shape

- the day-one list, in the owner's words: gym Mon/Wed/Sat · run Tue/Thu/Sun · finances every 25th ·
  reading 3x a week · supplements and habits daily · journaling daily · contact lenses every 14 days ·
  water plants every 3rd day
- four rule shapes cover all of it: a set of weekdays, every N days, a day of the month, N times a week
- journaling appears on the day-one list as a tick, not as written text
- speculative and unclaimed by anything real: "once a month" unanchored, and a rule bounded to a
  stretch of weeks — invented while answering a question about rules, not drawn from the week
- reading — an obligation of three times a week, any nights, open until the week turns over
- unticked items stay visible into the evening rather than being silently missed
- a detail page per area, visited deliberately and rarely, to look rather than to enter
- a weight graph over months
- nothing congratulates you; no streaks, no gamification — rows just go quiet
- the five-percent principle: a thin version of seven things, not a deep version of one
- an iPhone app — every one of the five daily visits happens with a phone in hand, never a laptop
- carrying your history to a new phone; restore, not live sync between devices

### Open, unresolved on purpose

- the stack is decided and recorded — Swift and SwiftUI, native iPhone, `docs/adr/1001-swift-and-swiftui.md`.
  Of the two things it left open, test enumeration is now answered: check 4 reads `@Test("...")`
  display names out of Swift source, because no Swift tool reports them without going through
  unpublished internals. **Still open: SwiftData or GRDB**
- where the Swift package lives, and what the app target is called. CI discovers `Package.swift`
  rather than assuming, so the first Story can put it wherever it belongs
- week turnover is undefined: does an unfinished two-of-three vanish, or get recorded as a miss?
- how far back the past stays writable, and what happens to days before a thing existed
- "every N days" needs an anchor: N days from a fixed start, or N days from the last tick? the second
  makes a late tick shift everything after it, which is a different mechanism from the calendar rules
- whether "every day" is a set of seven weekdays or an interval of one — two rules can express it
- supplements and habits were named as one line; a habit phrased as a negative is not a supplement
- checked against what already exists on 2026-08-29. Nothing found does all four rule shapes without
  streak mechanics. Apple Reminders does weekdays, every N days and a day of the month — free and
  already installed — but has no weekly quota and keeps no history of what was ticked. The habit-tracker
  category (Streaks, HabitKit, Habitify, Do Habits) has the quota and is built on streaks, the thing the
  owner abandoned apps for; a specific calendar date is the shape it lacks, not the quota.
- a past tick is looked at again — answered 2026-08-29. This disqualifies Apple Reminders on its own
  terms: it nags and forgets, and the failure being solved is a gap a few days old that cannot be
  reconstructed. The tick record is therefore durable, not transient.
- still open: whether looking back means navigating to a past day, or a view that aggregates a
  commitment over time ("eleven gym sessions last month"). The first is already implied by ticking any
  day; the second is a surface nobody has agreed to build.
- surfaced 2026-08-31, at #9's review. A schedule's payload cannot be read back out: `DayOfMonth`
  and `Schedule.dayOfMonth(_)` are public but `DayOfMonth.day` is internal, so an app target can
  build a rule on the 25th and never recover the 25 to render "the 25th" in a row. `.weekdays(Set)`
  reads back fine, so the two shapes are asymmetric. Nothing needs it yet — no surface renders a
  rule — and the first Story that does will need a delta widening it, not a bug fix.
- surfaced 2026-08-31, at `day-screen`'s G1. A UI smoke layer, deliberately deferred. Acceptance
  tests for the first screen attach at a view-model seam inside `DayByDayKit`, so nothing
  automated proves SwiftUI actually draws — a row left blank by a misspelled binding passes CI.
  The answer is one or two XCUITest cases, and it is parked because it costs an ADR, an
  `xcodebuild` job against a simulator, and a change to CI check 4, which reads `@Test("...")`
  display names out of Swift source and cannot see an XCTest method name. Revisit when there is
  a second screen to regress against.
- surfaced 2026-08-31, same conversation. Playwright is ruled out on a fact rather than a
  preference, recorded here so it is not re-proposed: it drives browser engines only, ships no
  `_ios` counterpart to its experimental `_android`, and cannot launch Apple's Simulator. It is
  unreachable without reversing ADR-1001, which chose native Swift and SwiftUI partly by
  rejecting the browser-based option outright.
