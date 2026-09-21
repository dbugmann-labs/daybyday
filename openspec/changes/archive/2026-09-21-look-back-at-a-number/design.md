## Context

See `proposal.md` § *Why*, and `grill.md` for what was settled. The facts this design turns on:

- `LookBack.form(for:keptUntil:entries:today:history:)` reads the chain, then returns early for
  every kind but a tick with no line and no whole. `LookBack.walkDays` walks the span a day at a
  time for a tick's tallies. `LookBack.chain` already resembles eras by `Kind.isOfTheSameSort(as:)`,
  so a number's chain runs across a range change and nothing here touches it (#262, merged).
- `History.number(for:on:)` answers the number a commitment holds on a date, keyed to the
  commitment by value — so a day's number must be read against the era holding that day.
- Every number in the app comes through `TypedNumber.read(_:)`, whose spelling drops leading and
  trailing zeros before `Decimal(string:)` sees it. Measured on this toolchain: `"\(decimal)"` says
  72.5, 0.08, -3, 100000 and a thirty-eight-digit whole plainly — no exponent, no thousands
  separator, no locale — and `NumberEntry.hint` and `TotalEntry.soFarOfTarget` already say so.
- `Commitment.Kind.number(range:)` carries a `lowest`/`highest` pair of `Decimal`s, and the newest
  era's is what the values axis wants. `LookBackWords` composes a month, a day, a week, a fraction.
- `LookBackView` reads `screen.lookBack(at:)` once per body pass, draws the head, the dates card
  and a `Grid` of lines, and says "Nothing is counted here yet." where a look-back says no line.
- Swift Charts is available to the app target (iOS 26; the kit is iOS 17 and stays SwiftUI-free);
  `chartScrollableAxes(_:)`, `chartXVisibleDomain(length:)`, `chartScrollTargetBehavior(_:)` and
  `chartScrollPosition(initialX:)` are all iOS 17 in the iOS 27.0 SDK's interface.

## Goals / Non-Goals

**Goals:** a number's page saying the shape its numbers have made; one graph across a chain, over a
span that does not move with the numbers; a seam handing the shell values to plot and every word it
draws, so no string is composed outside the kit.

**Non-Goals:** a note's and a total's pages (#276, #275); a figure beside the graph; any change to
`Roster`, `Commitment`, `CalendarDate`, `History` or `Schedule`; anything the day screen says about
a number; how eras resemble each other, which #262 has already shipped.

## Decisions

### The seam

```swift
public let LookBack.graph: LookBack.Graph?
public struct LookBack.Graph: Hashable, Sendable
public let LookBack.Graph.days: [String]
public let LookBack.Graph.months: [Month]
public let LookBack.Graph.points: [Point]
public let LookBack.Graph.rules: [Rule]
public let LookBack.Graph.lowest: Decimal
public let LookBack.Graph.lowestInWords: String
public let LookBack.Graph.highest: Decimal
public let LookBack.Graph.highestInWords: String
public struct LookBack.Graph.Month: Hashable, Sendable
public let LookBack.Graph.Month.inWords: String
public let LookBack.Graph.Month.day: Int
public struct LookBack.Graph.Point: Hashable, Sendable
public let LookBack.Graph.Point.day: Int
public let LookBack.Graph.Point.value: Decimal
public let LookBack.Graph.Point.inWords: String
public struct LookBack.Graph.Rule: Hashable, Sendable
public let LookBack.Graph.Rule.day: Int
public let LookBack.Graph.Rule.rhythmInWords: String
public let LookBack.Graph.Rule.fromInWords: String
static func LookBackWords.number(_ decimal: Decimal) -> String
```

`LookBack`'s six shipped members and `CommitmentsScreen.lookBack(at:)` keep the signatures they
have; `graph` is a seventh, `nil` for every kind but a number and for a number holding none, and
`LookBackWords.number` is internal beside the rest of that table.

### A day is an index, and the kit says every day of the span

`day` on a point, a month and a rule is a place in `days`, which holds every calendar day of the
dates axis said in words. The x axis is then plain integers the shell can plot and scroll, and the
shell can label any position without composing a date — ADR-1022 keeps the words in the kit.
`months` carries the same index for each month's first day, so a long span labels a month without
the shell finding where one turns. Rejected: a date on each point and a label rule in the shell,
which puts a formatting decision behind no scenario (ADR-1019's guard).

### A number is said as `Decimal`'s own digits

The delta's rule describes what interpolation of a `Decimal` already produces for every value this
system can hold, which is what the range hint and a total's row say, so `LookBackWords.number` is
that interpolation named once. Rejected: a formatter, which brings back the locale ADR-1022 removed.

### The values axis says its two bounds and nothing between

A mark between them would be a number the kit must say, and nothing decides which: evenly spaced
marks land on values like 43.75, and rounding to readable ones is an algorithm with no requirement
behind it. The shell draws the two labels and may draw unlabelled gridlines; the wireframe's four
figures are its example ticks (`grill.md` § *Layout*).

### A second walk, not a wider `walkDays`

The graph needs the span said, the era holding each day and that day's number; it needs no month
tally, no week tally and no fraction. So it is a walk of its own over the same days, sharing a new
private `era(holding:in:)` with `walkDays` and changing nothing about how a look-back counts. So
`docs/open-questions.md` § *`LookBack.walkDays` does five jobs* does not land here — this Story does
not reach that function, and the split it wants stays owed by #275 or by a chore.

### The shell rides this Story

ADR-1019's three conditions hold: `LookBackView` is this Story's immediate consumer, it introduces
no behaviour the kit does not specify, and it is `tasks.md` § 9. It draws the graph with Swift
Charts — `chartXVisibleDomain(length:)` is the fixed scale of grill decision 6, the picker sets its
length, `chartScrollPosition(initialX:)` opens at the newest end, and the values axis is pinned for
free. The spans are 31, 92 and 366 days and the whole span, each the longest calendar month, quarter
and year, so "Month" covers a month whichever month it is; the trace takes the label colour, never
the accent (ADR-1045). A page whose look-back says no graph says "No number yet." in place of the
shell's sentence written for a page of fractions, which the tick and quota pages keep. An era's
label is left-aligned to its rule in one lane under the dates axis, and two boundaries a few days
apart overlap with the older winning the lane. None of it is a rule: the scale, the picker, the lane
and the scroll cross no seam.

### Migration

None — additive. No persisted type and no encoding changes; a look-back only reads.

### The records

ADR-1045 is amended for one sentence — a graph of numbers charts values and not a run of days, marks
no day kept or missed, joins across a gap rather than breaking at one, and is shown nowhere near the
day screen. `CONTEXT.md` lands **Graph** and amends **Look-back**; **Era** already carries #262's
amendment for the range, and ADR-1055 still says "the same kind" where the spec says "the same sort"
— a stale record #262 left, reported rather than edited here.

### What the shell draws

**Option A**, one graph card with the picker above it, chosen at the grill's layout round from
three at https://claude.ai/artifact/GiwXkKSq5686jPyfLcVr6b. The wireframe is `grill.md`
§ *Layout*, verbatim:

```
Option A — one graph card, the picker above it, an era label lane under the dates

+------------------------------------------+
| <            Weight                      |  nav bar: back, and the name
|                                          |
| Weight                                   |  .largeTitle.bold      name
| Mon, Wed, Sat                            |  .subheadline, dimmed  rhythmInWords
|                                          |
| +--------------------------------------+ |
| | KEPT FROM           1 January 2026   | |  dates card, unchanged; a KEPT UNTIL
| +--------------------------------------+ |  row below it only where stopped
|                                          |
| [ Month | 3 months |  Year  |   All   ]  |  segmented picker, full width, above the
|                                          |  card; "Month" selected on opening
| +--------------------------------------+ |
| | 150 |. . . . . . . . . . . . . . . . | |  graph card: the dates card's fill and
| |     |                :               | |  radius. Values axis pinned in a lane at
| | 120 |. . . . . . . . : . . . . . . . | |  the left; it does not scroll, and it is
| |     |                :               | |  the whole graph's axis, not the days in
| |  80 |-•-•-_          :               | |  view (grill 9)
| |     |      `•-•-_  • :               | |
| |     |            `•-•: •--•   •--•   | |  the trace: one point per day holding a
| |  40 |________________:_______________| |  number, joined across the days between
| |      24 August 2026  :  14 September | |
| |                      :        2026   | |  dates axis, scrolls with the plot
| |       Mon, Wed, Sat · 9 September 2026 | |
| +--------------------------------------+ |  era label lane, under the dates,
|                                          |  left-aligned to its rule, scrolling
+------------------------------------------+  with it

the plot scrolls sideways under the thumb; on opening it sits at the newest end, so
the trace runs off the left edge and stops flush at the right. No whole, no figure.
```

## Risks / Trade-offs

- `days` holds a string for every calendar day of the span — about seven hundred for two years. →
  Formed once when the page opens, off the daily path; the same trade-off the day-by-day walk takes,
  and the alternative puts a formatting rule in the shell.
- A graph joined across gaps reads a weekly weight and a daily one alike, so a wide gap looks like
  a trend rather than a silence. → Grill decision 2: nothing tells a missed due day from a day the
  rhythm never named, and a break at every gap is the mark ADR-1045 forbids.
- Swift Charts is the shell's first dependency and its scroll is what the walk cannot prove. →
  Behind no seam, replaceable by a hand-drawn plot without a delta; the scroll is a `phone:` line.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason; every edge writing the delta turned up was
a consequence of something settled there, and each is recorded above as a decision. No residual round is outstanding.
