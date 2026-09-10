# 1043. A day change pages under the finger

- Status: accepted — proposed 2026-09-09 as motion played on release, built on
  `chore/day-screen-motion`, put on a real phone the same day and **rejected there by the owner**.
  The diagnosis it was written on stands and is why this file is still here; the remedy it named
  does not, and is superseded by the one below — a day screen that pages under the finger, built
  and walked twice on a device by the Story `add-adjacent-day-views` (#184). The motion is
  reverted. **This chore ships the tightened gap and no motion at all.**
- Date: 2026-09-09
- Amended: 2026-09-09 — the released motion was built and tried on a device, and the device
  answered. Retitled with the remedy, because the old title said the old one.
- Amended: 2026-09-10 — **the remedy is now specified**, by the delta of `add-adjacent-day-views`
  (#184), and the two questions this record left open by name are answered. Four decisions that
  outlive that Story land in § *Amendment, 2026-09-10* below rather than in a new record, because
  this is the file that posed two of them.
- Amended: 2026-09-10 — **the remedy has now been built and walked twice on a paired iPhone**, and
  the risk the Amendment above carried as unsettled — whether scrolling, row taps and the page
  gesture co-exist on iOS 26 — is answered: they do. Status moves from proposed to accepted.
- Deciders: Diego Bugmann

## Context

A day screen can now be moved three ways. The `chevron.left` and `chevron.right` either side of the
title, the `Today` button under them, and — since `chore/swipe-the-day` (#177, ADR-1042) — a
horizontal swipe anywhere on the day list. All three call the same three public members of
`DayScreen`, and all three land the same way: the title changes and the rows are replaced, with
nothing in between.

**The swipe is what turned that into a problem.** A tapped chevron is a button, and a button that
was pressed says so on its own; a swipe has nothing that flashes. If the day it lands on happens to
look much like the day it left — and on this product it usually does, because a roster changes
rarely and most days draw most of the same commitments — an instant replacement is
indistinguishable from a gesture the screen did not recognise. The person's recovery from that is
to swipe again, and the second swipe *is* recognised, so they end up two days from where they meant
to be with no idea why. Something has to tell them the first one worked.

**Direction is the part worth drawing.** A chevron and a swipe each move a day screen one calendar
day, in one of two directions, and which one is the only thing about that move a person can get
wrong. They cannot mis-aim it — the day it lands on is fixed by where it started — so there is
nothing to show except *which way*, and a plain fade or a flash would show them everything except
that.

**What makes this more than a spacing choice is what the day list is made of.** Its rows are drawn
by `ForEach(Array(group.rows.enumerated()), id: \.offset)`, so a row on this screen is identified by
its position and by nothing else — not by its value, because `openspec/specs/day-screen/spec.md`
deliberately permits two rows to be equal, and not by an id, because `DayView.Row` exposes none.
`docs/open-questions.md` § *The shell identifies rows by position* has the whole of that, including
why the position was chosen and what it does not cover. A day change replaces the entire row set
with a different day's commitments, which under positional identity reads as a great many rows
changing in place at once — so the obvious way to animate this screen is the one way that cannot be
made to look right.

**All of that was true, and the remedy this record first drew from it was wrong.** The first
version of this file decided that a day change would be *drawn as motion played on release*: the
day being left slides off and the day arrived at slides in, once the finger is already up, with
nothing tracking the drag. It was built on this branch exactly as specified and put on the owner's
phone on 2026-09-09. Their words, which are the finding:

> during the drag itself, nothing happens, only when the finger is released, so it looks and feels
> very odd.. My goal is that it feels like I am moving from screen to screen, same as if I were to
> navigate on an ios homescreen

**What the phone showed is that an acknowledgement is not a thing you can pay late.** The Context
above is a complaint about a gesture that goes unanswered, and a motion that begins once the
gesture is over answers it after the moment it was needed. So the drag itself — the part where the
thumb is on the glass and the person is asking a question — reads as unresponsive, which is a
*worse* failure than the instant replacement it was built to improve on: the instant version at
least never made the screen look stuck. Released motion did not underperform the target. It missed
what the target was.

The rest of the first version came back accepted, unchanged and on the owner's own reading of it:
the direction was right, `Today` replacing without animating was right — "that's good" — and the
gap the same chore tightened was "perfect".

## Decision

**A day change is not drawn as motion played on release.** That remedy was specified, built,
measured on a device and rejected, and it is not to be reached for again on the reasoning in the
Context — the Context is what argues *against* it. Nothing on the chore lane replaces it: the day
change goes on replacing instantly, as every version so far has done, and this chore ships the
spacing alone.

**The answer is a day screen that pages under the finger.** The day being dragged toward is already
drawn and moves with the thumb, in step with it, the way an iOS home screen moves between pages;
letting go before the day has travelled far enough settles it back where it started, and letting go
past that carries it the rest of the way. The acknowledgement is then not something the screen
plays afterwards — it is the screen itself, moving while it is being asked to.

**That cannot be built on a `chore/` branch, and the blocker is the kit's public surface.** A screen
can only page if it can draw the neighbouring day *while the current one is still on screen*, and
`DayByDayKit` will not answer that today. `DayScreen` exposes exactly one `DayView` — `dayView`,
the day being shown — and keeps `roster`, `recordStore`, `shownDay` and `today` private;
`offersGoingBackToToday` says only *whether* the screen is off its today, never which side of it,
and `DayView.date` is internal. `DayView.previousDay(of:in:)` and `nextDay(of:in:)` are public in
both their overloads, but each needs a roster's commitments or groups *and* a `History` to build
from, and the shell holds neither: `ContentView.swift` opens no `RecordStore` and holds no
`Roster`, and its `dayOneCommitments` is a seed that `DayScreen.openRoster` ignores the moment the
kept roster holds anything at all — its own doc comment says so. Making the kit answer "the day
before and the day after, without moving" is a requirement about what a screen says, which is a
delta, a G4 and a Story. `chore/` may not take one (ADR-1019).

**So the remedy goes to the Story `add-adjacent-day-views` (#184), opened on the strength of this
record.** The delta is the kit's: a day screen answers the day view either side of the one it is
showing without moving onto it, and says nothing about how a shell draws them. The paged
`ContentView` is the immediate consumer of that Story and may ride its branch under ADR-1019's
2026-09-04 amendment — it meets the first two conditions outright, and owes the third, its own
named section in that change's `tasks.md`.

**Three things from the first version are kept, because the owner accepted them and the Story
inherits them.**

*Direction is a property of the move, not of what started it.* One calendar day forward is drawn
forward and one back is drawn backward, whichever control asked for it — leftwards onto the next
day, rightwards onto the previous, which is the direction ADR-1042's swipe already means and the
direction the chevrons already point. This fixes *which way*, not *how*: a chevron has no finger to
track, so what a chevron tap draws is a question the Story's grill owes an answer to (see the
consequences), and whatever it draws points the same way a swipe does.

*The `Today` button does not animate. It replaces*, for both of its reasons. It is a button, so it
acknowledges its own press and needs nothing borrowed from the day list to say it was heard — that
is this record's own Context read back. And it is a jump of arbitrary distance, thirty days back
being as ordinary as one, so a one-day slide would misstate how far the screen travelled. There is
no drawing of a single step that is honest about a jump. The kit could not tell the shell that
direction today in any case, for the reason given above.

*What moves is the whole day and never its rows.* The day's content is treated as one thing keyed
on the day being shown, so a day change is one object leaving and another arriving; nothing here
changes `ForEach`'s keying or asks the kit for a wider `Row`. **This binds the paging Story exactly
as it bound this chore.** Positional row identity does not become safe because the motion got
better — if anything a paged screen makes the temptation worse, since the neighbour is a real list
sitting next to a real list, and handing the two to a diff is one line away.

## Consequences

- **The price of paging is now a price this decision pays, not one it defers.** It was priced in
  the first version of this record as the reason to defer: the day list is a `List` with the day
  gesture attached by `.simultaneousGesture` (`ContentView.swift`) precisely so the list's own
  scrolling and its rows' own taps keep working underneath it, and content that follows a finger
  means restructuring that list into something paged — which puts that co-existence, currently had
  for free, back on the table. The pricing was right. What has changed is that it is worth paying,
  and the evidence for that is a real phone rather than an estimate.
- **The Story that pays it inherits a scoping trap.** Its delta is a kit question — what a day
  screen can say about its neighbours without moving — and its visible payoff is a shell question,
  how a `List` becomes something that pages while keeping vertical scrolling and row taps. Only
  the first has requirements and scenarios. The second is shell work riding the branch under
  ADR-1019, whose guard has not moved: it may contain no line that could be wrong in a way a test
  would catch.
- **What a chevron tap draws is open, and this record does not close it.** A tap has no finger, so
  the only drawing available to it is a motion played after the fact — the thing rejected above.
  But the evidence that rejected it was gathered on a *drag*, and the owner's complaint is about
  the drag specifically: nothing happens "during the drag itself". A tap has no during. So released
  motion on a chevron is neither condemned by this finding nor vindicated by it, and it is a
  question for the Story rather than something to be assumed either way here. **Answered
  2026-09-10** — a chevron plays the same settle a drag ends with, in the same direction. See
  § *Amendment, 2026-09-10*.
- **A day change still takes time, and the day landed on may not be argued with.** Moving several
  days quickly — three swipes in a row, or a chevron pressed repeatedly — must end on the day the
  last act asked for. Drawing may lag behind the moves; it may never change which day the screen is
  showing when they stop, and a move must never be refused because a drawing is still settling.
- **A move that changes nothing draws nothing.** At the ends of the calendar a day screen stays
  exactly as it is (`CONTEXT.md` § *Day navigation*), so there is nothing to page toward: the drag
  has to resist and settle back rather than reveal an empty page, and the kit's answer for the
  neighbour there is the same nothing `DayView.previousDay` and `nextDay` already give at
  1 January 1583 and 31 December 9999. `Today` needs no rule of its own, since `Today` never
  animates.
- **What someone has asked their phone about motion is a live question again, and a different
  one.** Under released motion it was easy: a person who asked for less motion got the instant
  replacement, which cost nothing to keep. Under paging, the part that follows the thumb is direct
  manipulation rather than motion, and only the settle at release is played. Which of those a
  reduced-motion setting should govern is the Story's to answer with the platform's own behaviour
  in hand, not to be assumed from this record. **Answered 2026-09-10** — the played half only. See
  § *Amendment, 2026-09-10*.
- **Nothing automated proves any of this, and this record is what that costs.** The smoke layer is
  one XCUITest asserting the day screen draws (ADR-1029), and it passed the released motion
  without comment, as it would pass anything that ends on the right day. The check is the owner
  looking at it on the phone, which is what the shell is for — and the loop that produced this
  file, specify, build, look, reject, is the one this repo has for a question no test can hold.
- **`CONTEXT.md` § *Day navigation* is rewritten with this, not merely pointed at it.** It had
  started telling readers that a chevron or a swipe draws motion, which the revert makes false. It
  now says a day change draws nothing today, names paging as what is owed, and keeps the two
  constraints that outlive this chore — the whole day rather than its rows, and `Today` not
  animating. No new term is landed; motion is an affordance, not domain vocabulary.
- **This record covers the day change only.** The gap between the day's title and the toolbar,
  tightened by the same chore and the only thing it now ships, is spacing under the precedent of
  #180 and needs nothing beyond the measured comment already in the code.

## Amendment, 2026-09-10: what the Story settled

The Story this record named, `add-adjacent-day-views` (#184), was grilled on 2026-09-10 and its delta
written. The kit's half is that a day screen says the day view either side of the one it is showing,
without moving onto it — exactly the blocker the Decision above named. That is a requirement, so it
lives in `openspec/specs/day-screen/spec.md` and not here. **Four answers do not live there, because
they are about drawing rather than about behaviour, and they outlive the Story.**

**A chevron plays the same settle a drag ends with, in the same direction** — leftwards onto the next
day, rightwards onto the previous. This closes the third Consequence above. A tap has no *during*, so
the device evidence that rejected released motion does not reach it; what decided it instead is that
one move drawn two different ways depending on which control asked for it is the worse outcome, and
the Consequence above already fixed the direction for both. The `Today` button is untouched and still
replaces, for the two reasons the Decision gives.

**Reduce Motion governs the played half only.** The drag goes on tracking the finger; the settle at
release, and a chevron tap, become an instant change rather than a slide. This closes the sixth
Consequence. Apple documents no automatic Reduce Motion behaviour for SwiftUI paging at all, and the
HIG lists tracking animations directly with people's gestures among the ways to *reduce* motion — so
direct manipulation is the mitigation here and not the target. The practical consequence is that the
pager is written by hand: a container whose settle cannot be turned off cannot honour this.

**What pages is the day's rows, and the controls stay put.** The chevrons, the weekday, the day
picker and the `Today` button are a fixed row above the day's commitments, and the commitments are
what travel — the home-screen model the owner named, where the icons move and the dock does not. The
accepted cost, taken with eyes open: mid-drag the weekday still names the day being left. The two
messages a screen draws about a record or a roster it could not read stay with the controls as well,
because they are facts about the screen rather than about a day.

**The day picker always replaces, never slides**, including when the day picked happens to be one day
away. Same reason `Today` never animates: a control that can jump any distance should not sometimes
slide, or the drawing becomes a fact about the number of days rather than about the act.

**One risk is carried rather than closed, and it is a platform fact rather than a decision.** Apple
documents nothing either way about nesting a vertically scrolling `List` inside a horizontally paging
container, and the app targets iOS 26.0; only the phone settles whether scrolling, row taps and the
page gesture co-exist. The Story carries it as a rule-5 stop: if the paging cannot be had without
moving a line that could be wrong in a way a test would catch, that is reported and stopped, not
pushed through. ADR-1019's guard does not move.

## Alternatives considered

**Motion played on release — the first version of this decision.** The day being left slides off
and the day arrived at slides in, driven from `onEnded` with nothing tracking the drag. It was
argued from the Context above, accepted, built here and put on a phone, which is why it is the
first entry rather than a footnote: this is the one alternative in the register whose rejection
cost a build and bought a fact. **Rejected on the device.** An acknowledgement that arrives after
the gesture is over does not answer a gesture that went unacknowledged during it, and the drag
reads as unresponsive in the meantime — worse than the instant replacement, which never looked
stuck. Its cheapness was real and was not the problem. What it did not have was the one property
the complaint was about: being *in* the gesture.

**Leave the day change instant, permanently.** Free, and it is what ships from this chore. Rejected
as an end state for the reason the Context gives — ADR-1042 landed a gesture with no visible
acknowledgement, and an unacknowledged gesture is one a person repeats, which hands back the very
effort the swipe was built to save. It is accepted as the interim only because the one remedy
available on this lane was built and felt worse.

**Motion with no direction — a fade, or the new day appearing in place.** Cheaper than either
slide, and it addresses acknowledgement on its own. Rejected because direction is the only
information a day change carries: a fade tells a person something happened and leaves them reading
the title to find out what, which is the small target the swipe was meant to get away from. It also
shares the fatal property above — it plays after the fact.

**Sample the neighbour by stepping the screen there and back on each drag frame.** The one
workaround that needs no kit change: call `showNextDay()`, read `dayView`, call `showPreviousDay()`
to put it back, and draw what was read. Rejected, and it is worth writing down because it looks
free. It clears the notice a person is owed — `showPreviousDay` and `showNextDay` both set
`notice = nil` unconditionally — so a refusal they have not read yet is wiped by them starting a
drag. It is not even a round trip at the ends of the calendar: from 31 December 9999 the forward
step returns without moving and the step back moves anyway, leaving the screen a day earlier than
the person left it. And it asks the shell to hold a fact about the domain it has no way to keep,
which `CONTEXT.md` § *App shell*'s test disqualifies outright — a thing that can be wrong in a way
a test would catch is behaviour, and behaviour owes a Story.

**Have the shell count its own moves, and read `Today`'s direction off the running total** — minus
one per previous day, plus one per next day, zero at today. It needs no kit change, which is the
whole of its appeal. Rejected because the shell cannot keep that count true: `shown(asOf:)` moves
the today underneath the screen when the app is reopened on a new day and the counter is not told,
and at the ends of the calendar a move that had nowhere to go is counted anyway. Same
`CONTEXT.md` § *App shell* disqualification as the entry above. It would still be rejected if it
could be made correct, for the distance reason in the Decision: a jump is not a step.

**Animate the rows: let the list diff the two days and move each row itself.** The one that looks
free, because the list is already a `ForEach` and SwiftUI will animate it without being asked
twice. Rejected because row identity on this screen is the position — the value cannot serve, since
`day-screen`'s spec permits two rows to be equal, and a stable id would have to come from a public
widening of `DayView.Row`. Diffing yesterday's commitments against today's under positional
identity asks the framework to find correspondences between two lists that have none, and it will
find them: rows crossfading into unrelated rows, some sliding and some not.
`docs/open-questions.md` § *The shell identifies rows by position* is the standing record of that
gap, and this constraint is what keeps a day change from being the thing that triggers it — under
paging as much as under motion.
