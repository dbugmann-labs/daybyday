## Context

See `proposal.md` § *Why*, and `grill.md`, whose fourteen settled answers this delta is written on.
What matters here is that the **product rule is already settled** — a neighbour is formed for its own
day, it is drawn and never acted on, and at the ends of the calendar there is none. Nothing below
argues about that. It decides where the answer lives in the kit, what it costs, and what it leaves
alone.

**Ten facts, read off this worktree on 2026-09-10, with the branch on `84dfa5c`.** The first six
decide the shape; the last four decide how big the change is and are the ones to re-check before
starting.

- **`DayScreen` gives out one day view and keeps everything it is formed from private.** `dayView` is
  `public private(set)` (`DayScreen.swift:161`); `today`, `shownDay`, `recordStore` and `roster` are
  all `private` (`:24`–`:27`). That is the whole of why ADR-1043's paging cannot be built on a chore
  branch, and it is what this delta changes and nothing else.
- **`dayView` is stored, and ten places form a day view for the day being shown.** Seven call
  `dayViewOfShownDay()` (`:464`) — `tick` (`:245`), `enter` (`:430`), `takeBackLast` (`:456`),
  `showPreviousDay` (`:480`), `showNextDay` (`:492`), `showToday` (`:502`) and `showDay` (`:517`) —
  and **three build a `DayView` inline**: `init` (`:75`), `shown(asOf:)` (`:539`) and `returnedTo()`
  (`:561`), the last two because each has just re-opened its stores and forms the day view from what
  it opened rather than from what the screen holds. Those three are the ones a stored pair of
  neighbours would be forgotten at.
- **`tick`, `enter(_:on:)` and `takeBackLast(on:)` each open with
  `guard dayView.rows.contains(row) else { return }`** (`:223`, `:341`, `:438`). The third
  requirement in this delta is therefore **already true of the shipped code**, and its four scenarios
  are fences rather than new behaviour — see § *Acting stays on the day being shown*.
- **A row of one day is never equal to a row of another.** `DayView.Row` is `Hashable` over stored
  properties that include `let commitment: Commitment` and `let date: CalendarDate`
  (`DayView.swift:37`–`:41`), both internal to the kit. So `dayView.rows.contains(row)` above tells a
  neighbour's row from the shown day's *by the date it carries*, and the guard is right rather than
  lucky.
- **`CalendarDate.adding(days:)` is internal, answers `nil` past either end, and is only safe at
  ±1.** Its own doc comment (`CalendarDate.swift:85`–`:91`) records that
  `Calendar.date(byAdding:to:)` saturates rather than failing on an extreme step, so
  `adding(days: Int.max)` reads back a plausible date instead of `nil`. This delta steps by exactly
  ±1, which is the case that holds, and adds no caller outside it.
- **`DayView.previousDay(of:in:)` and `nextDay(of:in:)` are public in both overloads**
  (`DayView.swift:235`–`:271`) and **this delta does not use them.** Each forms the neighbouring date
  from the commitments or groups it is *handed*, and the only groups a caller inside `DayScreen`
  would have to hand them are the shown day's — which is the one answer `grill.md` § *Settled* 5
  rules out. Getting the right groups means knowing the neighbouring date first, at which point the
  `DayView` initialiser is the shorter road. They stay what they are: the answer for a caller that
  holds its own commitments and history.
- **`Roster.groups(on:)` (`Roster.swift:58`) is the roster's own answer for a date**, in the roster's
  groups and order, dropping what it had stopped keeping on that date. Asking it for a neighbouring
  day is exactly what a move already does after stepping `shownDay`.
- **The shell's day list is one `List` holding everything**, and the day gesture is attached to it
  with `.simultaneousGesture(daySwipeGesture)` (`ContentView.swift`), which is what keeps the list's
  own vertical scrolling and its rows' own taps working underneath it. The day-title `HStack` — the
  two chevrons and the `DatePicker` — the conditional `Today` button and the two store messages are
  all **rows inside that same `List`**, above the `ForEach` over the day's groups. Paging the day's
  rows while the controls stay put means lifting those rows out of it, which is the whole of the
  shell work.
- **The day's rows are keyed by position**: `ForEach(Array(group.rows.enumerated()), id: \.offset)`.
  `docs/open-questions.md` § *The shell identifies rows by position* is the standing record, and
  ADR-1043 is explicit that a paged screen makes the temptation to diff two days worse rather than
  better, because the neighbour is now a real list beside a real list.
- **1015 tests pass**, measured with `swift test` in `src/DayByDayKit` on this branch, whose only
  commit is the grill.

## Goals / Non-Goals

**Goals:**

- One answer per neighbour, formed for that neighbour's own day, so that what a person sees arriving
  is what they get when it lands.
- An answer that cannot go stale: whatever moves the day being shown, the two answers follow it
  without any code being told to refresh them.
- The absence at either end of the calendar given as an absence, because that is what a drag at the
  end resists against.
- A paged `ContentView` on this branch, so that G7 is read on a screen that can actually be swiped.

**Non-Goals:**

- **No motion, easing, distance or threshold in the kit.** What a page looks like, how far a drag
  must travel to carry, and what a chevron plays are the shell's. The delta says what may be drawn
  and never how.
- **No run of days.** One either side, and no answer for the day after that.
- **No neighbour that can be acted on**, and no widening of what a row is to make one identifiable.
- **No change to `DayView`**, to `Roster`, to `RecordStore`, or to any existing member of
  `DayScreen`.
- **No bound of the day picker's kind.** The reach bounds the picker; the neighbours are bounded by
  the calendar and by nothing else, exactly as the chevrons are.

## Decisions

### The seam

**No new file, no new type and no changed signature.** One existing seam gains two members, and
every scenario in this delta is driven at it:

- **`DayScreen.previousDayView: DayView?`** — a computed property taking no argument: the day view of
  `shownDay.adding(days: -1)`, formed from `roster.groups(on:)` for *that* day and from the history
  the screen already holds; `nil` where the step gives none.
- **`DayScreen.nextDayView: DayView?`** — the same, one day the other way.
- **A private `dayView(on day: CalendarDate) -> DayView`**, which is `dayViewOfShownDay()` (`:464`)
  with the day as a parameter; `dayViewOfShownDay()` becomes a call to it and every one of its seven
  callers is untouched. The three inline constructions in `init`, `shown(asOf:)` and `returnedTo()`
  stay as they are — each forms from stores it has just opened, not from what the screen holds, and
  this delta has no reason to disturb them.

**Two answers rather than one value.** `DayScreen.Reach` folds two dates into one answer because
they are only meaningful together and a caller must not derive one from the other. Neither reason
carries here: a shell drawing a leftward drag needs the day before and does not need the day after,
and neither is derivable from the other in any case. `grill.md` § *Settled* 1 settles it, and the
gain is that no shipped requirement or scenario naming `dayView` has to move.

**The names sit beside the moves they belong to.** `previousDayView` and `nextDayView` read against
`showPreviousDay()` and `showNextDay()`, which are the two acts a shell calls when the page carries.

### Computed, not stored, and that is the load-bearing choice

The alternative is a stored pair re-formed everywhere `dayView` is. It was rejected on the count in
§ *Context*: **ten places form the shown day's day view, and three of them do not go through
`dayViewOfShownDay()`.** A stored pair means ten edits and one omission away from a screen drawing
yesterday beside today — a bug that would show as a page sliding in the wrong day, which is precisely
the failure ADR-1043 exists to stop. Computed, there is nothing to forget: the two answers are a
function of `shownDay`, `roster` and `recordStore`, and every one of those nine places already sets
whichever of them changed.

**What it costs is a `DayView` formed on each read**, which is a walk over the roster's entries
filtering by `isDue(on:)` plus a history lookup per row — no I/O, no clock, no store. A SwiftUI body
drawing three days therefore forms three day views per pass rather than reading one. Named as a risk
below rather than optimised for: the day view of a day is already formed on every move, and a roster
is the size of a person's list of commitments.

**Observation is the one wrinkle.** `DayScreen` is `@Observable`, and the two computed properties
read `shownDay`, `roster` and `recordStore`, all stored and so all tracked. `recordStore` is a
*reference*, though, and a tick mutates the history behind it without the reference changing — so a
view that read **only** the neighbours would not be told a tick had landed. In practice every such
view draws the shown day too, and `dayView` is re-assigned by every write; `tasks.md` § 4 says so
where the shell is written, so nobody discovers it as a redraw bug.

### The neighbour is formed for its own day, and the wrong answer is one line away

`grill.md` § *Settled* 5. `roster.groups(on: theNeighbourDay)`, never `roster.groups(on: shownDay)`
and never the groups already inside `dayView`. The two differ exactly where a commitment was stopped,
resumed or removed across the boundary, and the delta's scenario *a day screen says a day either side
drawn from the commitments its roster had not stopped keeping on that day* is the one that separates
them: an implementation that reused the shown day's groups passes every other scenario in this delta
and fails that one. `tasks.md` § 2.9 makes it a stop.

### Acting stays on the day being shown, and the shipped guard already does it

The third requirement is **true of the code as it stands**: `tick`, `enter(_:on:)` and
`takeBackLast(on:)` each return early on a row `dayView.rows` does not contain, and a neighbour's row
is never in `dayView.rows` because a `Row` carries its date. So the four scenarios under it cost no
implementation.

They are written anyway, and they are not ceremony. Until this delta there was no way for a caller to
*get* a row for another day out of a screen, so the guard was defending against a caller's own stale
row; from now on the screen hands out sixteen of them a day. A later refactor that widened the guard
to "any row this screen can draw" would look like a tidy-up and would silently let a person tick
tomorrow by dragging. The four scenarios are what turns that from a review catch into a red test.

**They will still be red first**, because they cannot compile before `previousDayView` and
`nextDayView` exist — so rule 3's cycle is intact and no box below asks anyone to write a test that
passes on arrival.

### Why this delta modifies a shipped requirement, and what it does not touch

*A move with nowhere to go leaves a day screen exactly as it was* says, in as many words, that **a
day screen SHALL NOT say whether it can move either way, at any date and in either direction**. Once
`previousDayView` is `nil` at 1 January 1583, a caller can see one end of that from the outside. The
honest options were to narrow the refusal or to argue that an absent day view is not an answer about
moving; the second is a lawyer's answer, and a spec that is technically defensible and practically
false is the thing this repository writes deltas to avoid.

So it is a `MODIFIED`, and the narrowing is one paragraph placed exactly where that requirement
already narrows itself once — for the way back to today, on the same distinction: *what bounds an
offer is what the screen holds the answer to*. The refusal stands; what is added is that an absent
neighbour says what there is to draw and never whether a move may be asked for, and that a caller
MUST NOT stand a move down on it. **Its three scenarios are restated word for word**, so the three
tests already carrying those names must survive untouched — `tasks.md` § 1.1 makes any edit to them a
stop.

`grill.md` § *Settled* 2 anticipated this ("deliberately narrows"). What is decided here is that the
narrowing is spent as a `MODIFIED` requirement rather than left implicit, and that is the judgement
most worth overruling in the G4 diff if the owner reads it differently.

### What the shell draws

`ContentView.swift` becomes a paged day screen, under ADR-1019's 2026-09-04 amendment, whose three
conditions hold: it is the immediate consumer of this Story and lands in the same PR; it introduces
no behaviour the kit does not specify; and it is `tasks.md` § 4, its own section.

- **The controls come out of the `List` and stay put.** The chevrons, the day picker and the `Today`
  button become a fixed row above the paged content, and the day's rows are what pages —
  `grill.md` § *Settled* 9, the home-screen model the owner named: the icons travel, the dock stays.
  The accepted cost, already accepted at the grill, is that mid-drag the weekday still names the day
  being left.
- **The two store messages stay with the controls**, outside the paged content. They are facts about
  the screen rather than about a day, and a store failure that slid away with the page would read as
  a property of the day the person had left.
- **Three lists in a row, offset by the drag.** An `HStack` of the previous, current and next day's
  lists, each the width of the container, translated by the drag's own `width` and settled on
  release. This keeps each day's rows in a plain `List` — no `List` nested inside another scroll
  view — and keeps the existing `.simultaneousGesture` shape, which is what lets vertical scrolling
  and row taps go on working underneath. The recognizer this branch starts from already ignores a
  drag whose vertical travel exceeds its horizontal, and that test is what keeps an ordinary scroll
  from paging the day.
- **A carry calls `showPreviousDay()` or `showNextDay()` and nothing else.** **Not `showDay(_:)`** —
  that one is bounded by the day picker's reach and refuses a day below it, while the chevrons and
  the swipe are deliberately unbounded (*A day screen moves the day it is showing one calendar day
  either way*). Paging back below the roster's earliest kept-from day must go on working, and
  `showDay(_:)` would silently refuse it.
- **Where the neighbour is absent the drag resists and settles back.** There is no page to reveal at
  either end of the calendar, and the kit says so.
- **A chevron plays the same settle, in the same direction** — leftwards onto the next day,
  rightwards onto the previous (`grill.md` § *Settled* 8). A tap has no "during", so the phone
  evidence that rejected released motion does not reach it; one move drawn two different ways
  depending on how it was asked for is the worse outcome.
- **The day picker replaces where it stands**, however near the day picked, and `Today` goes on
  replacing (`grill.md` § *Settled* 10, ADR-1043). A control that can jump any distance must not
  sometimes slide, or the drawing becomes a fact about the number of days rather than about the act.
- **Reduce Motion governs the played half only** (`grill.md` § *Settled* 11). The drag goes on
  tracking the finger — the HIG lists tracking directly with a gesture as a *way to reduce* motion,
  so direct manipulation is the mitigation and not the target — and the settle at release, and a
  chevron tap, become an instant change. That is `@Environment(\.accessibilityReduceMotion)` deciding
  whether the settle is animated, and it is the reason the pager is written by hand rather than taken
  from a container whose settle cannot be turned off.
- **The whole day moves and never its rows** (`grill.md` § *Settled* 14, ADR-1043). Nothing here
  changes the `ForEach` keying, and no code may hand two days' rows to one list to diff.

**The rule-5 stop that rides with it.** Apple documents nothing either way about a vertically
scrolling `List` inside a horizontally paged container, and the app targets iOS 26.0; only the phone
settles whether scrolling, row taps and the page gesture co-exist. If they cannot be had without
moving a line that could be wrong in a way a test would catch, that is **reported and stopped**, not
pushed through: ADR-1019's guard does not move, and a kit change discovered here needs a further G4.

### ADR-1043 is amended, and no new ADR is written

`grill.md` § *Settled* 12. ADR-1043 posed two of these questions by name — what a chevron tap draws,
and what Reduce Motion governs — named this Story as owing them, and still reads `proposed` against a
remedy now being specified. Four answers land there because they outlive this Story: the chevron
plays the same settle in the same direction; Reduce Motion governs the played half only; what pages
is the day's rows while the controls stay put; and the day picker always replaces. Answering them in
a new record would make a reader hold two files about one screen's motion.

### `CONTEXT.md` gains the term the grill declared

`grill.md` § *Terms landed in CONTEXT.md* lists **adjacent day view** and an amendment to
§ *Day navigation*, and **neither had reached the file** — `CONTEXT.md` on `main` holds no such term.
This Story lands both, in the grill's own words. That is a finding about the grill rather than a
decision taken here, and it is reported with the hand-back.

## Risks / Trade-offs

- **Three day views formed per SwiftUI pass instead of one.** → No I/O and no clock; a roster is the
  size of one person's list. If it ever shows, the fix is a cache keyed on the day being shown, which
  is a shell or kit change with no requirement behind it. Not paid for in advance.
- **A view reading only the neighbours would not be told a tick landed**, because `recordStore` is a
  reference `@Observable` cannot see through. → Every view that draws a neighbour draws the shown day
  too, and `dayView` is re-assigned by every write; `tasks.md` § 4 says so at the point it matters.
- **A neighbour formed from the shown day's roster passes almost every scenario.** → One scenario
  separates them and `tasks.md` § 2.9 makes it a stop; it is the single most likely wrong
  implementation of this delta.
- **The paged shell may not co-exist with the `List`'s own scrolling.** → Undocumented by Apple in
  both directions, so it is a rule-5 stop rather than an estimate; `tasks.md` § 4.5 carries it.
- **Lifting the controls out of the `List` changes the top of the screen**, which nobody asked for.
  Spacing there was measured twice already (#180 and ADR-1043's chore). → It is judged on the phone
  at `tasks.md` § 4.6, and any spacing change is reported rather than tuned quietly.
- **Two real lists side by side make row-diffing one line away.** → `docs/open-questions.md`
  § *The shell identifies rows by position* is the standing record, ADR-1043 binds this Story by
  name, and `tasks.md` § 4.4 makes handing two days' rows to one `ForEach` a stop.
- **The modified requirement costs a second reading of a shipped rule at G4.** → Deliberate; the
  alternative is a spec sentence that is false about the shipped screen.

## Open Questions

**None outstanding, and none deferred.** `grill.md` § *Left open* is "None.", with its reason, and
writing the delta raised no question that needed the owner: every one it did raise had an answer on
disk — in the shipped spec, in ADR-1043, or in the code cited in § *Context* — and finding those is
this agent's job rather than the owner's. **There is no `## Questions for you` section on this
change**, and no residual round is outstanding: the Story is at G4 and nothing else.

Three judgements were taken rather than sent back, because each is about where an already-settled
rule lives rather than about a preference. They are named so a reader can find and overrule any of
them in the G4 diff, which is where a judgement like this is cheapest to overrule:

1. **The delta modifies *A move with nowhere to go leaves a day screen exactly as it was*.**
   § *Why this delta modifies a shipped requirement*. `grill.md` § *Settled* 2 said the answer
   narrows it; what is decided here is that the narrowing is written down rather than assumed.
2. **The two answers are computed, not stored.** § *Computed, not stored*. Nothing in the grill
   touches this; it is decided on a count of ten call sites, three of which do not go through the
   helper.
3. **The controls are lifted out of the `List` and the store messages stay with them.**
   § *What the shell draws*. `grill.md` § *Settled* 9 settles that the header stays put and the
   commitments page; where the two store messages go was not asked, and they are facts about the
   screen rather than about a day. It is a shell line under ADR-1019 and changes nothing in the
   delta.
