## Why

The rule engine can now answer both halves of a day and put neither of them together. `commitment`
(#26) says, for a calendar date, whether the gym is due; `record` (#55) says whether it was ticked.
Nothing asks those two questions of the same date at once, which is what a person actually looks at:
*here is what today asks of me, and here is what I have done about it.* `FEAT: day-screen` (#27) is
the capability that answers it, and this is the first of its three Stories — the day view itself,
before anything taps it (#71) and before anything moves between days (#72).

It matters that the value comes before the screen. `docs/open-questions.md` § *Known gaps* recorded,
at #27's G1, that acceptance tests for the first screen would have to attach at a view-model seam
inside `DayByDayKit`, because nothing automated proves SwiftUI draws. This Story creates exactly that
seam and nothing else: a pure value that takes commitments, a date and a history and answers in rows.
Everything a later screen renders is then a fact somebody signed rather than something a view built
on the way past.

It is also where ADR-1015's stated cost first becomes visible. A weekly quota is due on every
calendar date, so a commitment read three times a week has a row on all seven days of it. That is
the consequence the owner accepted when he signed ADR-1015 — *"it is the day screen's to fix with
ticks"* — and #27's G2, which cut three Stories and no fourth, put the fix after them rather than in
them. This delta states it rather than hiding it: one scenario shows the quota commitment on all
seven days, so the next person to read the spec learns it from the requirement instead of from the
screen.

## What Changes

- Creates the `day-screen` capability with its first requirements: a **day view** is the commitments
  due on a calendar date, each with whether the history holds it kept on that date, in the order the
  view was handed them.
- **Puts the two existing answers together without adding a third.** Due-ness is `commitment`'s
  answer and kept-ness is `record`'s; the day view asks each once per commitment and reports what it
  is told. It does not consult a schedule directly, so ADR-1013's kept-from floor comes free, and it
  does not consult the present moment, so a day view of any supported date answers the same way for
  ever (ADR-1004).
- **Fixes the order question by refusing to have one.** The rows come back in the order the
  commitments were handed over, with the ones that are not due dropped out of the middle. The view
  does not sort by name, by rhythm or by whether a thing is done, and it does not deduplicate — a
  commitment handed twice has two rows. `CONTEXT.md` § *Day view* already says it orders nothing of
  its own; this delta makes that observable.
- **Keeps a ticked commitment in the view.** The row says it is kept and stays where it was. Nothing
  counts, nothing is tallied and nothing leaves — `CONTEXT.md` § *Nothing congratulates you*.
- Sharpens `CONTEXT.md` § *Day view* with three things this grill settled: that the view is handed
  its commitments rather than holding a list of its own, that it is an answer given from a history as
  that history stood rather than a window onto one, and that a weekly-quota commitment therefore has
  a row every day.

Nothing is drawn on a screen, nothing is tapped, nothing is stored and no existing capability's
requirements move.

## Capabilities

### New Capabilities

- `day-screen`: what one calendar date asks of a person and what they did about it — the commitments
  due on that date, each with whether it is kept, in the order the day view was handed them.

### Modified Capabilities

None. `commitment`, `record` and `schedule` are read and not changed: the day view uses
`Commitment.isDue(on:)` and `History.isKept(_:on:)`, both already public, and needs nothing from
either capability that it does not already export.

## Impact

- **`src/DayByDayKit`** — one new source file, `Sources/DayByDayKit/DayView.swift`, and one new test
  file, `Tests/DayByDayKitTests/DayViewTests.swift`. Nothing existing is edited. The package reports
  97 tests passing today, measured on 2026-09-02; this change takes it to 118.
- **No new dependency, no `Package.swift` change, no CI change.** CI discovers `Package.swift` and
  reads `@Test("...")` display names out of the source, both of which this change leaves alone.
- **`openspec/specs/day-screen/spec.md`** is created at archive time, by `/opsx:archive` and nothing
  else. Exactly one capability is claimed, so CI check 2 stays green.
- **`docs/open-questions.md` § *Known gaps*, "No UI smoke layer"** — this is the Story that creates
  the view-model seam that entry predicted, and it does not close the gap: a `DayView` proved correct
  in `swift test` still says nothing about whether SwiftUI draws its rows. The entry's own trigger,
  *"revisit when there is a second screen to regress against"*, is unchanged. Flagged for the file's
  owner; this change does not edit it.
- **`docs/open-questions.md` § *Open product questions*, "Week turnover"** — not forced here and left
  standing, though the entry's trigger deserves reading carefully rather than glancing at. It says the
  question is *"forced by the first Story that renders a quota's state"*, and this is the first Story
  that puts a quota commitment in front of a reader at all. It still does not force it: what a day
  view renders is that commitment's **day** — was this one date ticked — and never its week. It counts
  nothing across a span, so no week boundary is consulted and none could be settled by any test in
  this delta. The Story that forces it is the one that first hides or marks a quota once its week is
  met, and #27's G2 did not cut one. This change does not edit the file.
- **`docs/backlog.md`** — B-006, *keep unticked commitments visible into the evening rather than
  silently missed*, left *Wants* against this Story on 2026-09-02 with the note that it needs no
  requirement of its own. This delta bears that out and does not add one: a row that is not ticked
  simply does not go quiet, and nothing removes it, which falls out of the first requirement. What
  "visible" looks like, and the nag that entry warned about, are the screen's. B-007, B-011 and B-021
  are untouched wants; B-016 and B-019 are already Decided, against #72 and #71. This change does not
  edit the file.
- **No ADR.** Argued in `design.md` § *No ADR*: the one decision here that is expensive to reverse —
  what a weekly quota means to a consumer that draws every due commitment — is ADR-1015's already,
  and this delta applies it rather than deciding it again.
