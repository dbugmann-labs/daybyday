## Context

See `proposal.md` § *Why*, and `grill.md`, whose ten settled answers this delta is written on. What
matters here is that the **bound and its reason are already landed** — `CONTEXT.md` § *Reach* and
§ *Day picker*, both written at this Story's grill — so nothing below argues about the product rule.
It decides where the rule lives in the code, and what it does not touch.

**Nine facts, read off this worktree on 2026-09-09, with the branch rebased onto `4e64641`.** The
first five decide the shape; the last four decide how big the change is and are the ones to re-check
before starting.

- **A commitment does not give out the day it is kept from.** `keptFrom` is declared without
  `public` (`Commitment.swift:4`), and the shipped requirement *A commitment is a name, a schedule,
  and the day it is kept from* says only that *the name it was given SHALL be readable back, and so
  SHALL the kind*. The omission is deliberate and this delta does not undo it — which is the whole
  reason the earliest kept-from day is answered by the roster and not worked out by the screen.
- **`Roster` already holds every commitment it ever held, and only its public answers narrow.**
  `entries` (`Roster.swift:15`) keeps a `keptUntil` and an `isRemoved` per commitment; `commitments`
  (`:36`) drops the stopped ones and `commitments(on:)` (`:374`) drops the ones stopped before a
  date. Nothing today reads back the full set. So counting the stopped and the removed costs a walk
  over `entries` and no new stored state, and ADR-1035 — *a roster never lets a commitment go* — is
  what makes that walk correct rather than a leak.
- **A day screen gives out neither of the two days `offersGoingBackToToday` turns on.** `today` and
  `shownDay` are both `private` (`DayScreen.swift:24` and `:25`), and `offersGoingBackToToday`
  (`:172`) exists because nothing outside can compare them. **This delta gives one of the two back**
  — the day being shown, as the day the picker opens on — and § *Giving back the day being shown* is
  where that is paid for.
- **A day screen that cannot read its roster holds an empty `Roster`, not an absent one.**
  `openRoster` returns `(.writtenByALaterVersion, Roster())` and `(.notKept, Roster())`
  (`DayScreen.swift:117` and `:119`), and day one is taken on only where the place holds a roster
  holding nothing (`:122`). So "there is nothing to take an earliest day from" is one code path for
  three situations — an unreadable roster, a later-form roster, and a screen handed no commitments
  at a place holding nothing — and the fallback needs no state to tell them apart.
- **The three existing moves share one shape**, and the pick is a fourth of it:
  `showPreviousDay()` (`:458`), `showNextDay()` (`:470`) and `showToday()` (`:481`) each guard,
  clear the notice where the day changes, set `shownDay` and call `dayViewOfShownDay()` (`:448`).
  None reads the record or the roster again.
- **`CalendarDate` cannot be formed outside 1583–9999** (`CalendarDate.swift:30`), so a picked day
  is a supported day by construction and the pick needs no validity rule of its own.
- **The app already draws a `DatePicker`, and already converts both ways at the edge.**
  `CommitmentsView.swift:283` is `DatePicker("Kept from", selection:, displayedComponents: [.date])`
  in its default style; `date(from:)` (`:35`) and `ContentView.today()` (`ContentView.swift:59`–
  `:62`) are the two halves of the ADR-1004 conversion. **Nothing new is needed at that edge**, and
  § *What the shell draws* reads the "not a calendar month grid" line against the control that is
  already shipped.
- **The day-title row is an `HStack` of chevron, title, chevron** (`ContentView.swift:109`–`:124`),
  with the *Today* button conditional beneath it (`:126`). That is where a control "beside the
  chevrons and the `Today` button" has to go, and it is the only part of `ContentView.swift` this
  Story touches.
- **933 tests pass**, measured with `swift test` in `src/DayByDayKit` on this branch, whose only
  commit is the grill. That base includes `add-category-order` (#181) and
  `add-offered-today-control` (#174).

**`main` moved once while this was being written, and the branch is rebased onto it.** `4e64641` is
the base now: `chore(day-screen): mark an offered row and recede one that offers nothing` (#183),
which lands **ADR-1045** and touches `docs/adr/`, `docs/backlog.md` and `ContentView.swift` and
**nothing under `openspec/specs/`** and nothing in the kit — so `openspec validate --all --strict`
still passes against the specs as they stand, the 933 above is unchanged by it, and `tasks.md`
§ 1.3's stop has not fired. It reaches this Story in exactly one way: every `ContentView.swift`
line cited above still holds, because ADR-1045's work is entirely inside the row label and the
day-title row it edits is untouched. ADR-1045 is about how a row is marked and how one offering
nothing recedes; no row here takes anything the picker adds.

## Goals / Non-Goals

**Goals:**

- One aggregate question asked of the capability that owns the day, so that the day a commitment is
  kept from stays unreadable outside `commitment`.
- One answer per control, in the shape `add-offered-today-control` (#174) set: the screen says what
  its control does, and the caller draws it without computing anything.
- A pick that is a fourth member of the family the three moves already form, refusing in the way the
  calendar's two ends already refuse — silently, and without clamping.
- B-040 served on the phone in this branch, with the shell computing neither the bound nor the day.

**Non-Goals:**

- **No bound on navigation.** The chevrons, the swipe and the way back to today are untouched, and
  the shipped sentence that forbids a bound on them (*A day screen moves the day it is showing one
  calendar day either way*) is carried into this delta nowhere, because it does not move.
- **No calendar month grid pinned into the day screen**, and nothing that shows what was kept on a
  day other than the one being shown. That is B-007 and B-011, which Epic #1 excludes by name.
- **No "whether the picker is offered" answer**, for the reason #93 and #174 both give.
- **No new vocabulary.** **Day picker** and **reach** are landed; writing the delta coined nothing
  and `CONTEXT.md` is untouched by this branch.
- **Nothing about what the picker looks like** beyond its being a control of its own beside the
  others. Style is the shell's; the delta says only what may be picked and what happens when it is.

## Decisions

### The seam

**No new file and no changed signature.** Two existing seams gain members, and every scenario in
this delta is driven at one of them:

- **`Roster.earliestKeptFrom: CalendarDate?`** — a computed property over `entries`, taking no
  argument: the smallest `keptFrom` among every entry, `nil` where there are none. It walks
  `entries` directly rather than `commitments`, which is what makes the stopped and the removed
  count.
- **`DayScreen.dayPickerReach: DayScreen.Reach`** — a computed property, taking no argument, where
  `Reach` is a nested `Hashable, Sendable` value of two `CalendarDate`s, `opensOn` and `earliest`.
  `opensOn` is `shownDay`; `earliest` is the earlier of `roster.earliestKeptFrom ?? today` and
  `shownDay`. **`CalendarDate` is not `Comparable`** — it has only the internal `days(until:)`
  (`CalendarDate.swift:78`), which is how `Roster.groups(on:)` and `showPreviousDay()` already
  compare days — so every comparison here is written that way. Making the type `Comparable` would be
  public surface with no requirement behind it, and this Story does not add it.
- **`DayScreen.showDay(_ day: CalendarDate)`** — the fourth member of the move family, guarded by
  `day >= dayPickerReach.earliest` and otherwise shaped exactly like `showToday()` (`:481`): clear
  the notice where the day changes, set `shownDay`, re-form the day view, read neither place again.

`Reach` is one value rather than two properties because the two days are only meaningful together —
the whole of what the control may do — and because a screen answering `earliestPickableDay` and
`dayBeingShown` separately would be handing out two facts a caller could combine into decisions the
screen never sanctioned. `CONTEXT.md` § *Reach* says this in as many words: *as one answer rather
than as two dates anything outside could have worked out*.

### Why the roster answers, and not the screen

The floor is *the earliest day anything on the roster has been kept from*, and there are two places
that sentence could be computed.

The rejected one is inside `DayScreen`: it holds a `Roster`, `Roster.entries` is internal, and
`Commitment.keptFrom` is internal, so within `DayByDayKit` the screen could simply walk them. It is
cheaper by one requirement and one member.

It was rejected because it puts a `commitment` fact in a `day-screen` file. `commitment`'s own first
requirement makes only the name and the kind readable back; the day a commitment is kept from is a
part it is made of, not a part it hands out. A day screen that walked to it would be doing exactly
what the shipped day-view requirement forbids in the neighbouring case — *it MUST NOT reach past a
commitment to the schedule underneath it* — one part along, and it would be doing it in a file whose
capability has no requirement saying what the day means. Asking the roster keeps the day inside
`commitment` and hands out one aggregate, which is an answer rather than a getter: it says where a
person's history begins and nothing about whose history it is.

The cost is honest: `commitment` gains a requirement in a Story whose title is about a day-screen
control, and the G4 digest signs both deltas together. That is the same shape as `add-roster-order`
(#158), `add-roster-removal` (#155) and `add-commitment-category` (#167), each of which paired a
roster answer with the screen that consumes it.

### Giving back the day being shown, which #174 refused to give back

`add-offered-today-control` (#174) argued that a day screen gives out neither the today it was
handed nor the day it is showing, and that this is what forces the offered judgement to live on the
screen. `Reach.opensOn` **is** the day being shown, given out.

`grill.md` § *Settled* 8 settled that this is right, and the line it drew is the one to hold: a
picker must open on some day, and which day it opens on is a fact about the control rather than a
bare fact about the screen. What #174 protects is the **today**, and the today is still private and
still unobtainable — `offersGoingBackToToday` remains the only thing that compares the two, and this
delta says in as many words that it MUST NOT be inferred from the reach.

**The cost is real and is named here rather than discovered at review.** Once `opensOn` is public,
`ContentView.swift` could compare it against its own `today()` and draw a *Today* button off that
comparison, bypassing `offersGoingBackToToday` and reintroducing the skew the two clocks already
have. Nothing mechanical prevents it — `AGENTS.md` § *Agent roles* says everything finer than the
three guards is convention caught at review — so `tasks.md` § 5 makes it a stop and G7 is where it
would be caught.

### Why a pick below the floor is refused rather than clamped, and why that is not an *offered* violation

`grill.md` § *Settled* 7. Clamping shows a day nobody asked for; refusing silently is what
`showPreviousDay()` already does on 1 January 1583 and what *A move with nowhere to go leaves a day
screen exactly as it was* already requires.

The tension worth stating is with `CONTEXT.md` § *Offered*, which #174 read as *what is offered
governs what a person is given to tap, and not what this capability accepts* — `showToday()` stays
callable on a day that offers no way back. Here the seam **does** refuse. The two are consistent
because the reach is not a *whether it is offered* answer: the picker is always offered, and the
reach is the extent of one control that is always there. A day outside that extent is the same kind
of thing as a day outside the calendar — there is no answer to give — whereas the way back to today
always has an answer and merely stops being worth drawing. Put the other way: a bound the screen
would not honour is not a bound, and a caller who picks below it can only have got there by not
asking the reach.

### Why the floor clamps to the day being shown

`grill.md` § *Settled* 5 and 6, and the interaction between them is the part worth writing down. The
chevrons are unbounded, so a person can be standing on a day below the floor. A picker that opened
on a day it declared unreachable would be incoherent, and a picker that could not return them to
where they were would be a trap. Clamping the floor to the day being shown removes both, and it also
removes the case *A day screen says the reach of its day picker* would otherwise have to describe —
the earliest day rising above the day being shown — because the clamp makes that unrepresentable.
What is left of settled 6 is that the screen does not move, which is `returnedTo`'s business and is
the eighth scenario of the reach requirement.

**The consequence is asymmetric and is not a defect.** Someone who chevrons to 2019 can pick back to
2019 while they stand there; the moment they pick a later day, the floor rises behind them and the
chevrons are the way back down. That is the price of a floor that never traps and never lies, and it
is cheaper than the alternatives — a remembered low-water mark, which is state a screen would have
to keep across being shown, or no clamp at all, which is the trap.

### The fallback is the today, and it is one code path for three situations

`grill.md` § *Settled* 4. `roster.earliestKeptFrom` is `nil` for a screen that cannot read its
roster, for one whose roster was written by a later version, and for one handed no commitments at a
place holding nothing. All three are a screen with no history to reach back into, so all three floor
at the today it was handed — which then clamps to the day being shown like any other floor. The
screen goes on drawing its control rather than going dark, which is how it already behaves when it
cannot read a roster.

**A first launch is not one of those situations**, and the scenario that says so is *a day screen
that takes on the commitments it was handed reaches back to the earliest of those*: day one is
written into the empty roster before the screen answers anything (ADR-1027), so the reach is taken
from the commitments that were just taken on.

### What the shell draws

`ContentView.swift` gets a `DatePicker` in the day-title row, under ADR-1019's 2026-09-04 amendment,
whose three conditions hold: the shell is the immediate consumer and lands in the same PR; it
introduces no behaviour the kit does not specify; and it is `tasks.md` § 4, its own section.

- **The control is a `DatePicker` with `displayedComponents: [.date]`**, the same control
  `CommitmentsView.swift:283` already ships for the day a commitment is kept from. **This is what
  "deliberately not a calendar month grid" means and what it does not mean.** B-040's answer put the
  month grid with B-007 — a *look-back view*, a screen showing a month of history at once — and it
  cannot have meant "not a `DatePicker`", because the app's only other date control is one. The
  rejected style is `.graphical`, a month grid pinned permanently into the day screen; the
  platform's own transient picker that a date field opens is not that, and it is what a person
  reaching a day weeks back expects to tap.
- **Its range is `reach.earliest...`**, an open-ended `PartialRangeFrom` built from the one answer,
  and its selection is a `Binding` whose `get` is `reach.opensOn` and whose `set` calls
  `screen.showDay(_:)`. The shell computes neither end and holds no day of its own: the same shape
  as `if screen.offersGoingBackToToday` beneath it.
- **The `Date` ↔ `CalendarDate` conversion is the one already at this edge** — `date(from:)`'s
  counterpart, per ADR-1004. `ContentView.swift` has the forward half already and needs the reverse;
  it is four lines, and duplicating `CommitmentsView`'s private helper is cheaper than exporting one
  or than a third clock read.
- **The chevrons, the *Today* button and the swipe are not touched.** The picker sits beside them,
  which is what B-040 asked for and what `CONTEXT.md` § *Day picker* records.

### The smoke layer is not touched

ADR-1029: that layer proves the shell drew and says nothing about what. It already asserts the day
title and the *Today* button, neither of which moves. A `DatePicker` assertion would be a new claim
about a control's identity in a layer built to make none, and nothing in this Story makes an
existing assertion go red.

### No ADR is owed

`CONTEXT.md` § *Reach* and § *Day picker* carry the bound, the reason for it, the line between the
control and the screen, the always-drawn rule and the collision with the commitments screen's date
picker. An ADR would restate a durable record in a second place that can drift. **ADR-1019,
ADR-1027, ADR-1035 and ADR-1004 are used rather than amended**: the shell work is exactly the first's
exception, day one before the answer is the second, a roster never letting a commitment go is the
third and is what makes the walk over `entries` right, and the conversion at the edge is the fourth.

## Risks / Trade-offs

- **`Reach.opensOn` makes the day being shown public, which #174 relied on being private.** → The
  today stays private, so `offersGoingBackToToday` is still underivable outside; § *Giving back the
  day being shown* names the one bypass it does open, and `tasks.md` § 5.1 makes it a stop.
- **The floor rises behind a person who picks their way up from below it.** → Deliberate, argued in
  § *Why the floor clamps to the day being shown*, and the chevrons are still unbounded. If it turns
  out to bite, it is a new want and not a defect in this delta.
- **A `DatePicker` bound by `reach.earliest...` will not itself refuse a day**; SwiftUI's own bound
  is what stops the person, and `showDay` is what stops everything else. → The refusal is specified
  and tested at the seam, so the two agreeing is a convenience rather than a load-bearing fact; if
  the shell's bound is ever wrong, the screen still cannot be put below its floor.
- **The reach can change under an open picker** — the roster is re-read on being returned to, and a
  sheet is somewhere else in the app. → The floor only ever falls or clamps to the day being shown,
  and the clamp cannot invalidate a day already showing, so the worst case is a picker offering a
  slightly different range than when it opened. Nothing is left in an unreachable state.
- **No scenario can tell a floor computed on every reading from one stored once at `init`** — until
  the roster is re-read. → Scenario eight of the reach requirement is exactly that case and is the
  one that separates them; `tasks.md` § 2.8 says so.

## Open Questions

**None outstanding, and none deferred.** `grill.md` § *Left open* is "None.", and writing the delta
turned up no residual round: every question it raised had an answer on disk or in
`CONTEXT.md` § *Reach*, and the three judgements it did turn up are recorded above as decisions
rather than sent back, because each is a matter of where an already-settled rule lives rather than a
preference about the product.

Named here so a reader can find them and overrule any of them in the G4 diff, which is where a
judgement like this is cheapest to overrule:

1. **The roster answers the earliest kept-from day, so `commitment` gains a requirement in this
   Story.** § *Why the roster answers, and not the screen*. `grill.md` settled *that* the floor is
   the earliest kept-from day on the roster and never *which capability says so*; the shipped rule
   that a commitment does not hand out the day it is kept from is what decides it.
2. **`Reach` is one value carrying two days, and `opensOn` is the day being shown given out.**
   § *Giving back the day being shown*. `CONTEXT.md` § *Reach* and `grill.md` § *Settled* 8 settle
   the shape; what is decided here is the cost and where it is guarded.
3. **The shell's picker is a `DatePicker` in its default style.** § *What the shell draws*. This
   changes nothing in the delta — it is a shell line under ADR-1019 — and it is read against
   B-040's "deliberately not a calendar month grid" rather than left to look like a contradiction.
   It is confirmed on the phone at `tasks.md` § 4.3, which is where a look decision is actually
   judged.
