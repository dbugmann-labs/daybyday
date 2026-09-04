## Context

`DayByDayKit` exports seven seams today: `Schedule.isDue(on:)` (#8, #9, #10, #11), `Commitment`
(#42), `Tick`/`History` (#55), `RecordStore` (#56), `DayView` (#70, widened by #71's
`Row.tick(asOf:)`, #72's `previousDay`/`nextDay` and #92's `title(asOf:)`) and `DayScreen` (#91,
widened by #92's `title`). Motivation is in `proposal.md`; the behaviour contract is in
`specs/day-screen/spec.md` and is not repeated here. The grill that settled the questions below is
`grill.md` in this folder — seven questions over two rounds on 2026-09-04, with `## Left open`
reading "None."

Four facts about what is already there shape everything, and each was read out of the shipped
sources on 2026-09-04 rather than recalled:

- **`DayScreen` holds one day and calls it `today`.** `DayScreen.swift` declares `private var today:
  CalendarDate`, assigned in `init` and reassigned only by `shown(asOf:)`. Three members read it:
  the `DayView` it forms, `title` (`dayView.title(asOf: today)`) and `tick(_:)`
  (`row.tick(asOf: today)`). The first is the day being displayed; the other two are the day the
  question is asked as of. That is the conflation this change undoes.
- **`DayView` already moves, and refuses at the ends.** `previousDay(of:in:)` and `nextDay(of:in:)`
  return `DayView?`, `nil` exactly when `CalendarDate.adding(days:)` returns `nil`, which is at
  1 January 1583 and 31 December 9999. Fourteen scenarios from #72 cover the arithmetic, the month
  and year ends, the leap day and both refusals. **Nothing in the app calls either.**
- **`RecordStore.history` is in memory and current.** It is `public private(set) var history:
  History`, built at `init` and updated by `add` and `remove` after the write succeeds. So "form the
  day view from the record the screen already holds" is `store.history`, and it costs no file read
  and cannot be stale with respect to anything this screen did.
- **`DayScreen` is `@MainActor @Observable`,** and `dayView` is `public private(set) var`. A move
  that assigns `dayView` therefore redraws the shell, and `title` — a computed property over
  `dayView` and `today` since #92 — redraws with it. No second stored property is needed for the
  title, and none is added.

**Measured on this machine on 2026-09-04 rather than recalled.** `cd src/DayByDayKit && swift test`
reports **238 tests passing** at `d22633a`, on Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target
`arm64-apple-macosx26.0`; `openspec` is 1.10.0 and `node --version` is v24.19.0.

Every weekday this delta pins was checked twice on 2026-09-04 — once in Python's proleptic Gregorian
calendar and once in Foundation's own `.gregorian` calendar under UTC, the calendar `CalendarDate`
uses — and both agree in every case: **Saturday 1 January 1583**, **Sunday 2 January 1583**, Monday
3 January 1583; **Wednesday 31 December 2025**; **Thursday 1 January 2026**; **Sunday 30 August
2026**, **Monday 31 August 2026**, **Tuesday 1 September 2026**, **Wednesday 2 September 2026**,
Thursday 3 September 2026, **Friday 4 September 2026**; Monday 27 December 9999, **Thursday
30 December 9999**, **Friday 31 December 9999**.

## Goals / Non-Goals

**Goals:**

- A day screen reaches every day the calendar holds, one step at a time, and comes home in one.
- The day being shown and the day questions are asked as of are two things, and no tap can confuse
  them.
- A day being filled in survives a glance at another app; a screen left on today still greets the
  morning with the morning.
- Nothing that already passes changes. All 238 existing tests stay green and **unedited** — the
  twenty-four scenarios restated under MODIFIED are exactly the evidence for that.

**Non-Goals:**

- **Reaching a day by naming it.** Settled at the grill: today only, because an arbitrary date needs
  something to pick one with and no such screen exists. A month grid is a Story of its own.
- **A bound on how far the screen goes.** Neither at today nor at the earliest kept-from day. The
  settled record question left "whether a screen offers all of it" here, and this is the answer.
- **Saying whether a move would do anything.** The screen answers no such question, so the shell
  cannot grey an arrow out. § *Why the ends are silent*.
- **Re-reading the record on a move.** Being shown stays the only moment the file is opened again.
- **Anything about layout** — arrows, swipes, a title that is itself a button, where the way home
  goes. `tasks.md` § 3, and the grill's `## Left open` says so in as many words.
- **Hiding the future.** A day that has not arrived is reachable and its rows are visible; they take
  no tick, which is #71's rule and not a new one.

## Decisions

### The seam

**Widened, not new: `DayScreen` gains three methods and one private stored property.** An existing
seam beats a new one (`AGENTS.md` § *Vocabulary you need before Stage 4*), and every scenario here is
a question about a day screen. `DayView` is not touched at all — #72 already gave it everything this
needs.

```swift
@MainActor @Observable public final class DayScreen {
    /// Shows the calendar day before the one being shown. Leaves the screen exactly as it is when
    /// it is showing 1 January 1583. Does not move the today, and does not read the record again.
    public func showPreviousDay()

    /// Shows the calendar day after the one being shown. Leaves the screen exactly as it is when
    /// it is showing 31 December 9999. Does not move the today, and does not read the record again.
    public func showNextDay()

    /// Shows the today this screen was last handed, from whatever day it is showing. Always has
    /// somewhere to go; does not read the record again.
    public func showToday()
}
```

Three methods returning nothing, and no fourth member telling a caller whether a move would do
anything — that absence is a requirement, not an omission (§ *Why the ends are silent*).

Behind them, `private var today: CalendarDate` gains a sibling, `private var shownDay:
CalendarDate`, set equal to `today` in `init`. Every existing read of `today` then splits cleanly and
**two of the three lines do not change at all**:

| Existing line | Becomes | Why |
|---|---|---|
| `DayView(of:on: today, in:)` in `init` | `on: shownDay` | the two are equal at `init`; renaming makes the intent legible |
| `dayView.title(asOf: today)` in `title` | **unchanged** | the title is asked as of the today, which is what "Today ·" means |
| `row.tick(asOf: today)` in `tick(_:)` | **unchanged** | the tick is asked as of the today, which is what stops a future tick |
| `DayView(of:on: today, in:)` in `tick(_:)` | `on: shownDay` | the day view is re-formed on the day being looked at |
| `shown(asOf:)` | `if shownDay == today { shownDay = day }`, then `today = day` | § *Being shown again* |

That the two `asOf:` call sites need no edit is the strongest evidence available that the split is
the right one: they were always asking as of a *today*, and the bug was that the field they read
would have started moving.

The moves themselves delegate rather than compute:

```swift
public func showPreviousDay() {
    guard let moved = dayView.previousDay(of: commitments, in: store?.history ?? History()) else { return }
    dayView = moved
    shownDay = /* the moved day view's date */
}
```

`DayView` keeps its `date` internal to the package, and `DayScreen` is in that package, so the
screen can read it back — the fifth face of the payload read-back gap in `docs/open-questions.md`
does not bite here for the same reason it did not bite #92. The `guard let` returning early **is** the
"leaves the screen exactly as it was" requirement: `dayView`, `shownDay`, `today` and `recordState`
are all untouched, so an `@Observable` screen does not even redraw.

Every one of the twenty-five new scenarios is drivable through `DayScreen` with no process and no
global stream. The five that need a place need one only because opening a screen does, and
`DayScreenTests.swift` already has the per-test temporary-directory helper for it.

**Rejected: moves that return the new day view** (`func showingPreviousDay() -> DayView?`). A day
screen is the one thing in the product that is not a value (`CONTEXT.md` § *Day screen*); a move that
handed a value back and left the screen where it was would need the caller to put it back, which is
the caller holding the day. **Rejected: `move(by days: Int)`.** Nothing asks for two days at once,
`± 1` is the whole requirement, and an integer invites a caller to invent a bound. **Rejected: a
public `shownDay`/`isShowingToday`** — § *Why the ends are silent* rejects the second, and the first
has no reader: what a screen says its day is is `title`, and it has said it since #92.

### Two days, and which questions ask which

The split is the change. The rule is one sentence: **the day view is formed on the day being shown;
everything asked *as of* a day is asked as of the today.**

| Question | Asked as of | Consequence |
|---|---|---|
| Which commitments have a row, and is each kept | *(not an as-of question)* — the day being shown | you see the day you moved to |
| Does this row offer a tick | the today | a day that has not arrived takes none, however you got there |
| Does the day title say "Today" | the today | the one day it does is the today, wherever the screen is |
| Which day does being shown again land on | the today, compared with the day being shown | § *Being shown again* |

`CONTEXT.md` § *Today* has warned about exactly this since 2026-09-03 — confusing the two is "what
would let a screen offer a tick for a day that has not happened" — and until this Story a day screen
had no way to be wrong about it, because there was nowhere else to be. That is why it was settled by
the grill without being asked: it is a fact about the shipped requirements, not a preference.

### How far a day screen goes

**Chosen: as far as the calendar goes, both ways, with no bound of the screen's own.**

Backward was the grill's second question and the only one with a prior on the record: the settled
entry in `docs/open-questions.md` for 2026-09-02 answers *how far back the past stays writable* —
"back to the day a commitment is kept from, and no further" — and explicitly leaves "whether a
screen offers all of it" to this capability. The 2026-09-02 grooming line had already said the
direction: "as far back as the calendar goes, bounded by navigation rather than by a rule." Any
other floor is a rule the screen invents and then has to restate whenever the roster changes: the
earliest kept-from day moves the moment a commitment is added or taken up again, so a screen bounded
by it would refuse to show a day it showed yesterday. A day before anything was kept from simply has
no rows, which is already an answer (`day-screen`'s first requirement says so in as many words).

Forward is the same argument with a stronger backstop: a row on a day that has not arrived already
offers nothing, asked as of the today, and that refusal is #71's and is covered by six scenarios in
the shipped spec. A bound at today would be a second rule stacked on a refusal that already protects
the record — and the one it would break is the person who wants to see what tomorrow asks of them,
which costs nothing to allow.

### Being shown again

**Chosen: the day being shown survives, except that a screen on today follows onto the new day.**
Asked at the grill and **answered against the recommendation on 2026-09-04**: "stay where you
navigated — ideally also with a button to bring you back to today with a click."

The recommendation was to reset to today on every showing, on the ground that being shown includes
every app-switch and a screen that silently stays three days back is a trap. The owner's answer names
the larger cost: an app-switch is what happens *while you are filling a day in* — checking a message,
answering a call — and coming back to a different day loses the work in progress. The way home,
which was the same round's other answer, is what makes the trap survivable: you can always see where
you are (#92 made sure of that) and get back in one tap.

The exception is not a second rule; it is what the existing shown-again requirement already exists
for. Put the phone down on Monday night, pick it up on Tuesday morning, land on Tuesday. And it needs
**no state of its own**: the screen already holds the two days, so "was I on today?" is
`shownDay == today` evaluated *before* `today` is replaced. Stepping back onto today, or being sent
back to it, re-arms it by construction — there is nothing to re-arm.

**This is `docs/adr/1026-a-day-screen-keeps-the-day-you-moved-to.md`,** because one comparison
producing two opposite behaviours reads as a bug on first encounter, and the natural "fix" — reset
always, or never — breaks one of the two cases each. Rejected alternatives are recorded there:
resetting on every showing (loses the day being filled in), never resetting (a screen that shows last
Tuesday for ever unless you notice), and a timer that resets after some interval (a rule about the
clock, in the one capability that reads none, with a number nobody can defend).

### Why the ends are silent

**Chosen: a move with nowhere to go changes nothing, and the screen answers no question about it.**
The grill settled both halves.

A day view *gives nothing* at the ends — `previousDay` returns `nil` — precisely so that a caller
holding a value can tell it has reached the end, since a day view equal to the one it asked with
would be indistinguishable from success. A screen is stateful, so the same information is already
there: it did not move, and a person looking at it can see that.

The second half is why there is no `canShowPreviousDay`. The ends are 1 January 1583 and
31 December 9999, so such a property would answer `true` on every day anyone will ever look at —
a permanently-true pair of answers, two more scenarios, and a shell branch that no test on a real
date could distinguish from a constant. What is drawn where a move does nothing is the shell's, and
today it draws the same arrow.

### How the shell draws it

Three controls in `ContentView.swift`, calling the three methods and doing nothing else:

```swift
Button("Previous day") { screen.showPreviousDay() }
Button("Today")        { screen.showToday() }
Button("Next day")     { screen.showNextDay() }
```

No branch, no arithmetic, no wording about days, and no disabled state — there is nothing to disable
against (§ *Why the ends are silent*). Whether they are arrows on either side of the title, a swipe,
or both, is the layout question the grill left to the shell, and it is `tasks.md` § 3's.

### Twenty-five new scenarios, and twenty-four restated

The three ADDED requirements split by what can be wrong independently: **moving** (eight scenarios —
each direction, the today staying put, both unbounded ends, no re-read, there-and-back, and a screen
with no record), **going home** (five — from each direction, from today itself, to the today last
handed rather than the one opened on, and no re-read), and **the ends** (three — each end, and that
each still moves the other way).

The four MODIFIED requirements are restated in full because OpenSpec's MODIFIED replaces, and their
twenty-four existing scenarios are copied **verbatim** — checked mechanically against
`openspec/specs/day-screen/spec.md` rather than by eye. Between them they gain nine: two on the tick
(a day moved back to keeps it, a day not yet arrived keeps nothing), five on being shown again (the
day survives, both ways of re-arming, the record still re-read, and the one where a future day
becomes the today), and two on the title (a moved screen says a bare date, a screen sent home says
"Today ·" again).

## Risks / Trade-offs

- **A screen left three days back looks broken.** The single largest risk, and it is the trade the
  owner chose knowingly → mitigated by #92, which lands a title on the screen the day before this
  Story, and by the way home being in this Story rather than a later one. A person can always read
  where they are and get back in one tap.
- **The split has one dangerous half-implementation:** moving `shownDay` but leaving `title` or
  `tick` reading it. That ships a screen that offers a tick for a day that has not arrived — the
  exact loss `CONTEXT.md` § *Today* names → mitigated by *ticking a row on a day a day screen has
  moved onto that has not arrived keeps nothing* and *moving a day screen does not change the today
  it was handed*, which fail loudly on it. The design's own note that those two call sites need **no
  edit** is the other half of the mitigation.
- **`shown(asOf:)` must compare before it assigns.** Assigning `today` first makes the comparison
  trivially true and resets the day every time → the requirement says "against the today the screen
  held before it was told", and *a day screen moved off today keeps the day it is showing when the
  app is shown again* is red on it.
- **A move must not read the record, and the obvious implementation does.** Reaching for
  `Self.open(at: place)` inside a move is a one-line mistake that makes navigation hit the disk on
  every tap and quietly changes `recordState` → two scenarios, one per direction of travel, plus the
  way home's own.
- **Four MODIFIED requirements is a wide diff for a change that alters no shipped behaviour but one.**
  Accepted, and it is the point: each of the four says something that is now false, and leaving any
  of them would put a contradiction in the archived spec. The verbatim restatement plus the
  unedited-tests rule is what keeps the diff readable as *wording moved, behaviour did not*.
- **The shell is still uncovered by any test.** `docs/open-questions.md` § *No UI smoke layer*,
  unchanged. This change adds three buttons to that exposure, which is the largest single addition to
  it so far; `tasks.md` § 3 requires a simulator run and a written record of what was seen, including
  a move in each direction and a way home.
- **`showToday()` is dead weight if the owner never moves off today.** Accepted — it was asked for by
  name in the same answer that made the day survive, and it is three lines.

## Open Questions

**None.** The grill's own `## Left open` reads "None." with its reason, and nothing writing this
delta turned up a question that would change it. The two that were preferences rather than facts were
put to the owner as that grill's rounds on 2026-09-04 and answered the same day; both are the first
entries below. Everything else was a fact read out of the shipped sources, the settled record or
`CONTEXT.md`.

- *Does being shown again keep the day you navigated to, or return to today?* — **asked and settled
  by the owner on 2026-09-04, against the recommendation: keep it**, with a screen on today still
  following onto the new day. Had it gone the other way, the shown-again requirement would have kept
  its "SHALL take that day as the day it holds" unchanged, five of its new scenarios would not exist,
  and there would be no ADR. § *Being shown again*.
- *Is a way straight back to today in this Story, and does it go to any day or only today?* —
  **asked and settled the same day: in this Story, today only.** Had it been deferred, the second
  ADDED requirement and its five scenarios would move to a later Story and the answer above would be
  much harder to live with. Had it been "any day", it would be a different Story again: something to
  pick a date with does not exist. § *Goals / Non-Goals*.
- *How far back and forward does the screen go?* — asked at the grill and answered from the record
  rather than from preference: the settled 2026-09-02 entry in `docs/open-questions.md` handed
  "whether a screen offers all of it" to this capability, and the 2026-09-02 grooming line had
  already given the direction. § *How far a day screen goes*.
- *Does the screen's day and its today become two things?* — not asked; it is a fact about the
  shipped requirements. `CONTEXT.md` § *Today* and #71's row refusal already require it the moment a
  screen can be anywhere but today. § *Two days, and which questions ask which*.
- *Does a move with nowhere to go say so?* — settled at the grill: no, and the reasoning that made a
  day view *give nothing* is the same reasoning that makes a screen *stay*. § *Why the ends are
  silent*.
- *Does a move read the record again?* — no, read out of the shipped requirements: the existing
  spec gives the re-read to being shown alone, and `RecordStore.history` is already current for
  everything this screen did. § *Context*.
- *Does the screen's move need `DayView` widened, or `CalendarDate` made `Comparable`?* — read out
  of `DayView.swift` and `CalendarDate.swift` rather than assumed: no. `previousDay`/`nextDay` are
  public and complete, `DayView.date` is internal and `DayScreen` is in the same module, and the only
  comparison anything here makes is equality, which `Hashable` gives. The payload read-back gap in
  `docs/open-questions.md` is untouched and still owed by the first Story that needs a date's parts
  *outside* `DayByDayKit`.
- *Do the arrows, the swipe or both draw the move?* — a layout question with no requirement under it
  either way, so it is the shell's and `tasks.md` § 3's, exactly as `add-screen-date` (#92) disposed
  of the same shape of question about its title. This is the grill's `## Left open` entry, recorded
  here rather than left open.
