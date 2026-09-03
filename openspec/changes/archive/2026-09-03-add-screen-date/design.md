## Context

`DayByDayKit` exports seven seams today: `Schedule.isDue(on:)` (#8, #9, #10, #11), `Commitment`
(#42), `Tick`/`History` (#55), `RecordStore` (#56), `DayView` (#70, widened by #71's
`Row.tick(asOf:)` and #72's `previousDay`/`nextDay`) and `DayScreen` (#91). Motivation is in
`proposal.md`; the behaviour contract is in `specs/day-screen/spec.md` and is not repeated here.

Three facts about what is already there shape everything below, and each was read out of the shipped
sources rather than recalled:

- **`DayView` holds its date and keeps it to itself.** `DayView.swift` declares `let date:
  CalendarDate` with no access modifier, so it is internal to the package; `rows` and `Row.isKept`
  and `Row.name` are public and nothing else is.
- **`CalendarDate` keeps its parts to itself too**, and is `Hashable` but not `Comparable`.
  `year`, `month`, `day` and `weekday` are internal, which is the fifth face of the payload
  read-back gap in `docs/open-questions.md`. Internal is enough here: everything this change writes
  lives in the same module.
- **`DayScreen` is the only thing in the package that holds a today.** `private var today:
  CalendarDate`, replaced by `shown(asOf:)` and by nothing else. `DayView` holds none, and
  `Row.tick(asOf:)` takes one per call and keeps none.

**Measured on this machine on 2026-09-03 rather than recalled.** `cd src/DayByDayKit && swift test`
reports **192 tests passing** at `125da39`, on Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target
`arm64-apple-macosx26.0`; `openspec` is 1.10.0 and `node --version` is v24.19.0.

Every weekday this delta pins was checked twice — once in Python's proleptic Gregorian calendar and
once in Foundation's own `.gregorian` calendar under UTC, the calendar `CalendarDate` uses — and both
agree in every case: **Saturday 1 January 1583**, Sunday 2 January 1583, Monday 3 January 1583;
Thursday 1 January 2026; **Monday 31 August 2026**, Tuesday 1 September, Wednesday 2 September,
Thursday 3 September, Friday 4 September, Saturday 5 September, Sunday 6 September 2026; the
fifteenth of the twelve months of 2026 as Thursday, Sunday, Sunday, Wednesday, Friday, Monday,
Wednesday, Saturday, Tuesday, Thursday, Sunday and Tuesday; **Monday 28 February 2028** and
**Tuesday 29 February 2028**; Monday 27 December 9999 and **Friday 31 December 9999**.

**And one measurement that is the reason this change has an ADR.** The same `DateFormatter` with
`dateStyle = .full`, asked for 3 September 2026 under five locales on this machine:

```
en_US -> Thursday, September 3, 2026      de_CH -> Donnerstag, 3. September 2026
en_GB -> Thursday, 3 September 2026       fr_CH -> jeudi, 3 septembre 2026
                                          ja_JP -> 2026年9月3日 木曜日
Locale.current on this machine is en_CH -> Thursday, 3 September 2026
```

Five answers to one question, chosen by the device. A scenario cannot state what a day title is if
the device gets a vote.

## Goals / Non-Goals

**Goals:**

- A day view says its day in words, for every date the system supports, as a pure function of that
  date and the day it is asked as of.
- A day screen says the day it is showing, from the today it already holds and without reaching for
  a clock.
- The wording is fixed and testable: one string, one spelling, the same on every device.
- Nothing that already passes changes. All 192 existing tests stay green and untouched.

**Non-Goals:**

- **Localisation.** ADR-1022. The words are English and do not follow the device.
- **Relative words other than "Today".** No "Yesterday", no "Tomorrow", no "in three days". The
  Feature grill on 2026-09-03 settled the day-one form as a weekday and a date with "Today" only,
  and adding a second relative word means deciding what it does at the far end of a two-day gap.
- **Moving between days.** #93 (`add-screen-navigation`) is the Story that lets a person reach a day
  that is not today; this one only makes sure that when they do, the screen says where they are.
  Nothing here anticipates it beyond wording the requirement so #93 needs no MODIFIED.
- **Reading a `CalendarDate`'s parts out of the package.** § *Why this is one capability and not
  two*.
- **Anything about layout** — size, position, colour, one line or two. The shell draws the string it
  is handed.

## Decisions

### The seam

**Widened, not new: `DayView` gains one method and `DayScreen` gains one property.** An existing
seam beats a new one (`AGENTS.md` § *Vocabulary you need before Stage 4*), and there is nothing here
that is not already a question about a day view or about the screen holding one.

```swift
public struct DayView: Hashable, Sendable {
    /// What this day view says its day is: the weekday, the day of the month, the month and the
    /// year — "Monday 31 August 2026" — with "Today · " in front of it when `today` is this day
    /// view's own date. The words are this package's own and do not follow the device's locale;
    /// see ADR-1022.
    public func title(asOf today: CalendarDate) -> String
}

@MainActor @Observable public final class DayScreen {
    /// The day this screen is showing, said in words: its day view's title, asked as of the day
    /// the screen was handed. Reads no clock.
    public var title: String { get }
}
```

`DayView.title(asOf:)` takes its day the way `DayView.Row.tick(asOf:)` already does — per call, kept
by nothing — so the two members of this seam that need a today ask for it the same way. `DayScreen`
is `@Observable`, so a computed `title` over the stored `dayView` and `today` redraws when either
moves, without a second stored property that could disagree with them.

Both are drivable with no process, no global stream and no file: ten of the sixteen scenarios are a
`DayView` and two literal dates, and the six on `DayScreen` need a place only because opening a
screen does.

**Rejected: a `DayTitle` value with parts** — a struct carrying a weekday, a day, a month, a year
and an `isToday` flag, with the shell composing the sentence. That *is* the formatting rule, moved
into the one place `CONTEXT.md` § *App shell* says may hold no rule, and it would be untestable
where it lives. **Rejected: `title` on `DayScreen` alone** — every wording scenario would then need
a temporary directory and a store to assert a pure string, and the ten that are really about
January and about leading zeros would be file-system tests. **Rejected: `title` on `DayView`
alone**, with the shell supplying the today — the only today the shell could supply is a fresh clock
reading at every redraw, which is a second source of today competing with the one `shown(asOf:)`
exists to make authoritative.

### What a day title says, exactly

**Chosen: `"Monday 31 August 2026"`, and `"Today · Thursday 3 September 2026"` on the day it is
asked as of.** Weekday name, day of the month with no leading zero, month name, four-digit year,
single spaces; "Today", space, middle dot (U+00B7), space in front on the one day that qualifies.

The parts are the Feature grill's answer — "said as a weekday and a date" — and each earns its
place. The **weekday** is what a person actually navigates by: "is this the Saturday?" is the
question a due-ness app gets asked. The **day and month** are the date proper. The **year** is
always said, which was the owner's answer on this change's question round on 2026-09-03: one rule
instead of two, and the title then depends on the day it is asked as of for exactly one thing — the
word "Today" — rather than two. A date without a year is also the one thing here that could be
quietly wrong, for a person who has moved back through a January and cannot tell which January they
are in. Nothing is abbreviated: "Mon 31 Aug"
saves a screen nothing that a phone in one hand notices, and "31/08/2026" is the one form whose
meaning is different in two countries.

**The comma is deliberately absent, and that is a tiebreak rather than a taste.** Both "Thursday
3 September 2026" and "Thursday, 3 September 2026" read well, and the second is exactly what
`Locale.current` produces on this machine (`en_CH`, measured above). Choosing the form that is *not*
any locale's full style means an implementation that quietly reached for `DateFormatter` fails the
scenarios here, on this machine, in this language — rather than passing locally and failing on the
first phone whose region differs.

### Why the words are the app's own

**Chosen: twelve month names and seven weekday names, written out in the package.** The alternative
is Foundation, and Foundation's answer is the five strings measured in § *Context*. This is
`docs/adr/1022-the-day-is-said-in-the-apps-own-words.md`, written because the decision is
expensive to reverse — every scenario in this delta quotes the string it produces — and because a
reader who finds a hard-coded "September" will otherwise assume it was carelessness rather than the
point.

**Where the table lives: a new internal `DayTitle.swift`, not `Weekday`.** `Weekday` is
`schedule`'s type and answers a rule question; hanging display names off it would put a `day-screen`
requirement's implementation inside another capability's type, and the next person to read
`Weekday.swift` would reasonably conclude that naming days is `schedule`'s job. Nothing about the
table is public: no requirement asks for "the name of a weekday" on its own.

### Today, and only today

**Chosen: "Today" is added in front of the date, not put in place of it, separated by " · ".** Both
were live — the Feature grill's own record says "with 'Today' added only on today" in one place and
"with 'Today' only on today" in another — so this was put to the owner as this change's question
round rather than settled quietly, and **answered on 2026-09-03: in front, with " · " as the
separator.** The ground it was recommended on is the one that decided it: until #93 lands, a day
screen is always on today, so a title that replaced the date with "Today" would ship a screen that
never once says a date, which is the want this Story exists to satisfy. It also keeps one shape for
every day, so moving between days changes the words rather than the layout.

**"Today" is the only relative word**, settled at the Feature grill. It is also the only part of a
title that depends on the day the question is asked as of, which keeps the dependency to one
comparison: `date == today`. `CalendarDate` is `Hashable` and not `Comparable`, and equality is all
this needs — nothing here has to know whether a day is before or after another, so this change does
not make it `Comparable` either.

### Why this is one capability and not two

`docs/backlog.md` and `docs/open-questions.md` both predicted a delta against
`openspec/specs/schedule/spec.md` alongside this one, to make a `CalendarDate`'s year, month and day
readable from outside the package. **That prediction assumed the words would be assembled by the
caller**, and the caller is the shell, which may not assemble them (`CONTEXT.md` § *App shell*).

Once the assembling happens behind the seam, the parts have no reader. Publishing them anyway would
run into ADR-1004 head on: a calendar date there is "a struct of three integers with a validating
initializer, not a date library", and that ADR names convenience API growing on it as *the signal
that something belonging at the edge has leaked into the engine*. The engine is not what wants a
date's parts; a renderer is, and the renderer is inside the package with them already.

So `schedule` keeps its surface, the known gap stays open, and the entry gains a line saying which
Story met it and why it did not close it — the same disposition #91 gave the fourth
`RecordStoreError` case. What still owes the widening is a Story that needs a date's parts *outside*
`DayByDayKit`: rendering a rule in a row ("the 25th") is the standing candidate, and it is not this.

### How the shell draws it

One line, above the rows, in the `List` that is already there:

```swift
Text(screen.title)
```

No branch, no interpolation, no wording of its own — the only judgement left is where on the screen
it goes. `screen.title` re-reads nothing: it is computed from the day view and the today the screen
already holds, so a redraw provoked by a tick redraws the same title.

### Two requirements, sixteen scenarios

The split follows what can be wrong independently. The **first** requirement is the wording and is a
pure function of two dates: ten scenarios, of which four are the wording itself (the shape, "Today",
the day before, the day after), three are alphabets that a hard-coded table gets wrong one entry at
a time (every weekday, every month, no leading zero), and three are the edges (both ends of the
supported range, the leap day, a day view with no rows). The **second** is the screen's, and every
one of its six scenarios is about *which* day is said rather than *how*: the day it was handed and
not the clock, the same day its own day view says, the day it moves to when the app is shown again,
the day it says when it is keeping no record, and the day it still says after a tick.

## Risks / Trade-offs

- **One string forbids a two-line layout.** A design that wants "Today" large and "Thursday
  3 September 2026" small underneath cannot get it from one `String` → accepted, because the
  alternative is handing the shell parts to compose, which is the thing this design refuses.
  Nothing outside the package parses the string, so a later Story that wants two pieces adds a
  second member and changes no caller but the shell.
- **English on a German phone.** The owner is the only user and the app is English throughout →
  accepted, and recorded in ADR-1022's consequences rather than left to be discovered.
- **Every scenario quotes an exact string, so a wording change is a wide diff.** That is the
  requirement being the requirement → accepted. It also means the wording cannot drift silently,
  which is the trade being bought.
- **A typo in one of the nineteen names would ship.** Mitigated by the two alphabet scenarios: every
  weekday and every month is asserted by name, so a wrong "Feburary" fails a test rather than
  reaching a screen.
- **The middle dot is not ASCII.** U+00B7 is in every system font and in this repo's own prose
  already; the risk is an editor or a test file mangling the encoding → mitigated by the scenarios
  quoting it, which fail loudly if it is mangled.
- **The shell is still uncovered by any test.** `docs/open-questions.md` § *No UI smoke layer*,
  unchanged. This change adds one `Text` to it, which is the smallest possible addition to that
  exposure; `tasks.md` § 3 still requires a simulator run and a written record of what was seen.

## Open Questions

**None.** The two things that were preferences rather than facts went to the owner as this change's
question round and were **answered on 2026-09-03**; both are the first entries below. Everything else
the grill raised was a fact that was measured or read out of the shipped sources, or a decision made
above with its alternatives beside it.

- *Does "Today" replace the date, or go in front of it?* — **asked and settled by the owner on
  2026-09-03: in front of it, separated by " · ".** "Today · Thursday 3 September 2026", and the
  middle dot is the separator rather than a comma or a dash. The delta was written on that
  recommendation, so nothing moved when the answer came back: the same sixteen scenarios, the same
  seven quoted titles, the same requirement wording. § *Today, and only today*.
- *Does the year always appear?* — **asked and settled the same day: always.** "Thursday 3 September
  2026" whatever year the question is asked in, so the title depends on the day it is asked as of
  for exactly one thing, the word "Today". Again the recommendation, so again nothing moved; the
  alternative would have added a second rule about the year, a scenario for a day in another year,
  and " 2026" would have left ten expected strings. § *What a day title says, exactly*.

- *Does saying a date need `schedule` widened, as the backlog predicted?* — read out of
  `DayView.swift`, `CalendarDate.swift` and ADR-1004 rather than assumed: no. § *Why this is one
  capability and not two*.
- *Does it need `CalendarDate` to become `Comparable`, as the known gap says?* — no. The only
  comparison a day title makes is equality, which `Hashable` already gives.
- *Where does the word "Today" come from — the day view or the screen?* — settled by what each one
  holds: `DayView` holds no today and must be asked, `DayScreen` holds one and answers from it.
  § *The seam*.
- *Does a screen that cannot read its record say its day?* — read out of ADR-1021, which already
  answers the same question for the rows: it draws the day, because what a date asks of a person
  needs no record to answer. Stated in the second requirement and pinned by a scenario.
- *Does the title move when a tick is made?* — no, and #91's requirement already says the day does
  not; the scenario here pins that the *title* follows the held day rather than being re-derived
  from anything the tick touched.
- *Do "Yesterday" and "Tomorrow" join "Today"?* — settled at the Feature grill on 2026-09-03, before
  this Story existed: no. Recorded in § *Goals / Non-Goals* so the next reader does not reopen it.
- *Should the shell draw it as a navigation title instead of a row?* — a layout question with no
  requirement under it either way, so it is the shell's and it is `tasks.md` § 3's, not a spec's.
