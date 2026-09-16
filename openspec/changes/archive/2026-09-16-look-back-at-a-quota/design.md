## Context

See `proposal.md` § *Why*, and `grill.md` for what was settled. The facts this design turns on:

- `LookBack.form(for:keptUntil:entries:today:history:)` already walks every day from the earliest
  era's day kept from through the last day counted, one day at a time, tallying a month at a time
  and finding the era that holds each day. The week is another tally over the same walk.
- `History.standing(for:through:)` counts a commitment's kept days from the Monday of a date's week
  through that date. It knows nothing of an era, a day kept from or a day kept until.
- `WeeklyQuota.timesPerWeek` and `Schedule`'s cases are internal, so `LookBack` can read a quota's
  number in the same module without a public member and without a `commitment` delta.
- `CalendarDate.weekday`, `adding(days:)` and `days(until:)` are internal; `History` walks back to
  a Monday one day at a time, at the ±1 step `adding(days:)` documents as safe.
- `LookBackWords` holds the twelve full month names and composes a month, a day and a fraction.
- `LookBackView` draws a month and its fraction in two grid columns, composes the rhythm-change
  line itself, and fills both its cards with `.background` over `.systemGroupedBackground` — which
  resolve to the same black in the dark, so the cards are invisible there (walk W.2 on PR #289).

## Goals / Non-Goals

**Goals:** the week said on the page as the unit a quota is owed in; one order and one whole over
month lines and week lines alike, so a mixed chain reads downward as calendar time.

**Non-Goals:** a number's, a note's and a total's pages (#274, #276, #275); any change to `Roster`,
`Commitment`, `CalendarDate`, `History` or `Schedule`; anything the day screen says about a quota.

## Decisions

### The seam

```swift
case LookBack.Line.month(inWords: String, fraction: String)
case LookBack.Line.week(inWords: String, fraction: String)
```

Nothing else moves: `LookBack`'s six members and `CommitmentsScreen.lookBack(at:)` keep the
signatures they have. `.month`'s fraction stops being optional because the one case that answered
`nil` — a month a quota era touched — is what this change replaces, and an optional no rule can
produce is a state the shell must still draw something for. `LookBackWords` gains the twelve
three-letter names and the span, internal beside the full names it already holds.

### A week's kept days are the walk's, not `History.standing`

The walk counts a day against the era holding it and only inside the days a look-back counts, which
is what a part week at either end and a week two eras share both need. `standing` is asked of a
date, runs Monday-to-that-date whatever era holds those days, and reads records outside the window
— on the fixture where a stopped commitment holds a record after its day kept until, the two
disagree and the walk is right. Rejected: calling `standing` for each week's last counted day.

### Lines are in one order, by the last day each counts

A mixed chain says a month line and a week line whose spans overlap — March 2026 for the weekday
era beside the week of 2 March for the quota era behind it. Ordering by the last day a line counts
puts each line where the days it speaks for are, which is what reading downward as calendar time
means. Rejected: ordering by the span's own end, which floats a part week above a whole month it
ends inside; and blocking the lines era by era, which says the same thing only while no two eras
share a line.

### The change line sits above the lower of the two lines holding the day

The shipped rule — immediately above the line of the month the newer era is kept from — is silent
where both a month line and a week line hold that day, which is every mixed boundary. Taking the
lower of the two puts the line between the two eras' lines in both directions: below the newer
weekday era's month and above the older quota era's weeks, and below the newer quota era's weeks
and above the older weekday era's month. Rejected: the higher of the two, which in the first
direction puts the line above everything and leaves it describing lines it is above.

### A week two quota eras share is judged by the newer

`grill.md` 6. Two quotas do not sum, the week is one unit, and the newer rule is the one the week
ends on. The line is said once, its numerator every day of the week the look-back counts.

### The week's counting and the week's words are two requirements

One requirement carrying both is about 160 normative words against ADR-1047's 150, so it is split
rather than squeezed: what a week counts, and what a week is said in. The three span forms are
three rules and carry a scenario each.

### What the shell may compose

This closes `docs/open-questions.md` § *A look-back's line is two strings*. The seam keeps two
strings per line, since one string would make the shell split a week from its fraction to draw its
columns. **The shell may compose the rhythm-change line, and nothing else**: the rhythm, a space, a
middle dot, a space, the day. A month line's and a week line's two strings are drawn in two columns
and joined with nothing. The heading over the lines — "Weeks", "Months" or "Months and weeks" — and
the sentence where a look-back says no line are the shell's own words, read off which cases the
lines hold; a look-back says neither, and the shell draws no placeholder where one says nothing.

### Migration

None — additive. No persisted type and no encoding changes; a look-back only reads.

### The shell rides this Story

ADR-1019's three conditions hold: `LookBackView` draws the new case as the row it already draws a
month as, names the unit above them, and takes the secondary grouped background its cards need to
be visible in the dark. It is `tasks.md` § 8 and introduces no behaviour the kit does not specify.

### What the shell draws

**Option A**, one headed table whose heading names the unit, chosen at the grill's layout round
from three at https://claude.ai/artifact/5kXBn8onr2uAYd4jtNKZ8k. The wireframe is `grill.md`
§ *Layout*, verbatim:

```
Option A — one headed table, the heading names the unit

+------------------------------------------+
| <                                        |  nav bar: back only
|                                          |
| Gym                                      |  .largeTitle.bold      name
| 3x a week                                |  .subheadline, dimmed  rhythmInWords
|                                          |
| +--------------------------------------+ |
| | KEPT FROM           1 January 2026   | |  dates card, unchanged; a KEPT UNTIL
| +--------------------------------------+ |  row below it only where stopped
|                                          |
| +--------------------------------------+ |
| | THE WHOLE                            | |
| | 24/33                                | |  .title, monospaced digits   whole
| +--------------------------------------+ |
|                                          |
|  Weeks                                   |  .headline. "Weeks" where every line
|                                          |  is a week, "Months" where every line
|  9–15 Mar 2026                      2/3  |  is a month, "Months and weeks" where
|  --------------------------------------  |  the chain mixes
|  2–8 Mar 2026                       3/3  |
|  --------------------------------------  |
|  23 Feb – 1 Mar 2026                4/3  |  over quota is the same row
|  --------------------------------------  |
|  16–22 Feb 2026                     1/3  |
|  --------------------------------------  |
|  ... one row per week, newest first ...  |
|  --------------------------------------  |
|  29 Dec 2025 – 4 Jan 2026           1/3  |  the part week at the start
|  --------------------------------------  |
+------------------------------------------+

a mixed chain, the lines only:

|  Months and weeks                        |
|                                          |
|  March 2026                         3/5  |  the newer, weekday era
|  --------------------------------------  |
|  ======================================  |
|        Mon, Wed, Sat · 4 March 2026      |  .rhythmChanged, drawn as it is today
|  ======================================  |
|  2–8 Mar 2026                       1/3  |  the older, quota era
|  --------------------------------------  |
|  23 Feb – 1 Mar 2026                3/3  |
|  --------------------------------------  |
```

### The records

ADR-1045's 2026-09-15 amendment says a look-back says no whole where any era runs on a weekly
quota; this Story amends that record in place rather than writing a new one, because the whole is
unchanged in kind — counted by the rule its lines are counted by, never a percentage, never on the
day screen. `CONTEXT.md` amends **Look-back** and **Week**, and lands no new term.

## Risks / Trade-offs

- A quota page is long: a year is about fifty-two rows, and nothing on the page is pinned, so the
  whole scrolls out of sight where a tick's twelve rows kept it visible. → Accepted. No option the
  designer drew fixes it without duplicating a figure or hiding part of the record, and it is a
  later layout question rather than this Story's.
- A mixed chain draws a month line and a week line whose spans overlap, so one calendar day can be
  read on two rows and counted on neither twice. → The rhythm-change line between them says where
  the switch happened, and each line counts only its own era's days.
- The walk is now two tallies over the same days rather than one, and a week's tally has to be
  finished when a Monday arrives rather than when a month turns. → The walk is a day at a time over
  years, opened deliberately once on a phone, and nothing on the daily path calls it.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, every edge writing the delta turned up
was a consequence of a decision already settled there — each recorded above as a decision with the
rule it follows from — and no residual round is outstanding.
