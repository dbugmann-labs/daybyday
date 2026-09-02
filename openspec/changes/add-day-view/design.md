## Context

`DayByDayKit` exports three seams today: `Schedule.isDue(on:)` (#8, #9, #10, #11), `Commitment` (#42)
and the pair `Tick`/`History` (#55). Everything in it is a pure value over `CalendarDate`, with no
clock, no time zone and no locale (ADR-1004), and this change inherits all of that without restating
a word. Motivation is in `proposal.md`; the behaviour contract is in `specs/day-screen/spec.md` and is
not repeated here.

What is new is that this is the first thing in the package that is *for a reader* rather than for the
engine. Every type so far answers one question about one thing — is this due, was this kept. A day
view answers a screen's question, which is a different shape: several commitments at once, two
capabilities' answers side by side, and an order. That makes the interesting questions three: how it
composes the two existing answers without inventing a third, what it is allowed to decide about the
list it is given, and how it stays a value when the thing it reports on can change under it.

It is also the seam `docs/open-questions.md` § *Known gaps* predicted at #27's G1 — *"acceptance tests
for the first screen attach at a view-model seam inside `DayByDayKit`"* — so naming it well matters
beyond this Story: #71 taps it and #72 moves it.

**Measured on this machine on 2026-09-02, on Apple Swift 6.3.3 in language mode 6, rather than
recalled.** `cd src/DayByDayKit && swift test` reports 97 tests passing today, which is the number
`tasks.md` counts up from; `openspec` is 1.10.0. Every weekday this delta pins was checked in
Foundation's own `.gregorian` calendar under UTC, the calendar `CalendarDate` uses, rather than
trusted from any other source: in 2026, 31 August is a Monday, 1 September a Tuesday, 2 September a
Wednesday, 5 September a Saturday and 6 September a Sunday; 1 January 2026 is a Thursday, which is
deliberately not a day any of the delta's schedules is due on, since the day a commitment is kept from
need not be one (ADR-1013). 3 January 1583 and 27 December 9999 are both Mondays, which is what lets
one scenario pin the two ends of the supported range against the same weekday set.

Two arithmetic facts the delta stands on, checked against the shipped rules rather than assumed: a
schedule on the 25th of the month is not due on 31 August 2026, and an interval of 14 days starting
25 August 2026 next lands on 8 September, so neither is due on 31 August — which is what makes the
"none of the commitments is due" scenario an empty view rather than an accident.

## Goals / Non-Goals

**Goals:**

- One value that answers a whole day: given commitments, a date and a history, what is asked of you
  and what you have done about it. A screen renders it and decides nothing.
- Composition without a third opinion. Due-ness is `Commitment.isDue(on:)`'s answer and kept-ness is
  `History.isKept(_:on:)`'s; this type asks each once per commitment and reports what it is told.
- A value, not a view: equatable, hashable, sendable, copied by assignment, and stable once formed.
- The clock kept out, exactly as everywhere else in the package, so a day view of a past date answers
  the same way for ever and every test gives the same answer in every time zone.
- The smallest public surface that makes the delta's scenarios observable and not one member more.

**Non-Goals:**

- Anything drawn. No SwiftUI, no target that could hold one, no formatting of a date or a name for a
  reader. The app target is still unnamed (`docs/open-questions.md`).
- Ticking from a row, or refusing a row whose date is later than today. That is #71, and it is the
  Story that first needs to know what today is.
- Moving from one day to the next or the previous. That is #72.
- Holding, sourcing, ordering or persisting the list of commitments. Nothing in the system produces
  one yet (B-015, B-020); the day view is handed one, which is the whole of its ordering rule.
- Deciding whether a week's quota has been met, or hiding a quota commitment once it has. Argued
  under § *A weekly quota keeps its row* — ADR-1015's, and not this Story's.
- Counting, aggregating, streaking or ranking. `CONTEXT.md` § *Nothing congratulates you*; the
  deliberate look-back is B-007's.
- Saying what rhythm a commitment runs on, in words. B-021, and it would need the schedule read-back
  `docs/open-questions.md` § *Known gaps* records as missing. Nothing here needs it.
- Changing `Commitment`, `Schedule`, `CalendarDate`, `Tick` or `History`. Everything this needs from
  them is already public.

## Decisions

### The seam

**New: `DayView`, with its nested `Row`, exported from `DayByDayKit`.** It is one seam with one entry
point: a day view is formed by its initializer and read through `rows`, and a `Row` can be obtained no
other way. `Schedule`, `Commitment`, `Tick` and `History` do not move, are not wrapped and are not
widened.

```swift
public struct DayView: Hashable, Sendable {
    public struct Row: Hashable, Sendable {
        public var name: String { get }
        public let isKept: Bool
    }

    public let rows: [Row]

    public init(of commitments: [Commitment], on date: CalendarDate, in history: History)
}
```

`Row` stores the `Commitment` it is a row for, internally, and exposes only the name off it; `DayView`
stores the `CalendarDate` internally. Twenty-one scenarios in the delta observe that initializer and
`rows`, three of them additionally through day-view equality. No process is spawned and no global
stream is captured.

Four smaller choices inside that shape:

**The initializer is not failable.** Every other type in this package refuses something at
construction — 30 February is not a date, a blank name is not a commitment, a tick on a Tuesday is not
a tick — and this one refuses nothing, deliberately. Each argument is already a value that could not
be malformed, and there is no fourth thing a day view could reject: a date with nothing due is an
answer, not an error, and so is an empty list of commitments. Making it failable would hand every
caller an optional it could never see be `nil`.

**`Row` exposes the name and the kept-ness, and not the commitment.** This is #55's stance repeated,
for the same reason: the delta's scenarios read a row's name and its kept-ness and nothing else, so
exporting more would be exporting a shape nobody has signed. #71 is the Story that needs the
commitment back — it cannot form a `Tick` without one — and it widens `Row` in its own delta, which is
a one-line change because the commitment is already stored. Storing it now rather than storing just
the name is not speculation, it is what makes row equality honest: a row is *a commitment's* line, so
two commitments that render alike but are different commitments must be different rows, which is
exactly what the same-name scenario pins.

**`DayView` stores its date and does not expose it.** Stored because the date is part of what a day
view *is* — two dates whose rows coincide are two days, not one — and the delta pins that with an
equality scenario rather than with a getter. Not exposed because nothing here reads it back: a screen
holds the date it asked for. #72, which moves a view from one date to another, is the Story that will
want it, and it widens the surface then.

**`rows` is an `Array`, and the initializer takes one.** Not a `Set`, which would deduplicate and lose
the order that is half the requirement; not a generic `Sequence`, which buys nothing the delta
observes and makes the type's equality harder to state than it is worth.

### Composition, and why it asks the commitment rather than the schedule

**Chosen: for each commitment handed over, ask `Commitment.isDue(on: date)`; for each that says yes,
ask `History.isKept(commitment, on: date)` and make a row.** That is the whole rule, and both halves
are somebody else's answer taken as given.

The one thing that could go wrong here is asking the wrong object. `Commitment` holds a `Schedule`,
and this type is in the same module, so reaching past the commitment to `schedule.isDue(on:)` compiles
and passes almost every scenario — every one except the commitment kept from a later day, which is the
scenario that exists to catch it. ADR-1013's floor lives in `Commitment.isDue(on:)` and nowhere else,
so a day view that consults the schedule directly would list a commitment on days before the person
had taken it on, which is the fabricated history the whole floor exists to prevent.

*Alternative — the day view filters, and the caller supplies the kept-ness.* Rejected: it splits one
answer across two calls and lets a caller lie about the second, and the delta's scenarios would then
be pinning the caller rather than this type.

*Alternative — put the day view on `History`, as `history.dayView(of:on:)`.* An existing seam, which
`AGENTS.md` prefers. Rejected because it puts `day-screen`'s requirement on `record`'s type: a history
is asked about one commitment on one date and knows nothing of a list or an order (`CONTEXT.md`
§ *History*), and this would give it both. The seam preference is about not multiplying boundaries
acceptance tests attach at, and this is a genuinely new boundary — the first one that speaks for a
whole day.

### The order is the caller's, and so is the list

**Chosen: rows come back in the order the commitments were handed over, with the ones that are not due
removed, and nothing is deduplicated.** `CONTEXT.md` § *Day view* already says a day view orders
nothing of its own, and the reason is worth restating because it is not obvious: a commitment is a
name, a schedule and a kept-from day, and it carries no identifier and no day it was written down
(`commitment`'s first requirement). Every order a day view could invent would therefore be a rule
about one of those three, and a name is the owner's words rather than the system's — sorting by it
would mean "Bench" comes before "Gym" because of the alphabet, which is a decision nobody made.

Deduplication is the same argument one step further. Two commitments alike in all three parts are the
same commitment, so a caller that hands the same one over twice has handed over a list this type has no
grounds to correct: it does not know whether that was a mistake or two things a person deliberately
keeps apart, and the capability that will know — whatever brings identity with it, B-014's or the
store's — does not exist. Passing the list through is the choice that assumes least, and the scenario
that pins it is what stops a later implementation reaching for `Set` because it is tidier.

*Alternative — sort unticked commitments to the top, so what is left to do is at the top of the
screen.* This is B-006 — the want this Story carries — wearing a different hat, and it is genuinely
attractive on a phone. Rejected
here on two grounds: it is not what the Story or `CONTEXT.md` § *Day view* says, and it makes a row
move under a thumb the moment #71 lets that thumb tick it — which is the one interaction the product
exists for. If it turns out to be wanted, it is a want against `day-screen` and a requirement that
MODIFIES this one, not a quiet choice inside an implementation. The scenario pinning a kept row's
place is what makes that visible.

### A weekly quota keeps its row, and this Story does not fix it

**Chosen: a commitment on a weekly quota has a row on every day of its week, and one scenario says
so.** `Schedule.isDue(on:)` answers `true` on every date for a quota (ADR-1015), `Commitment` delegates
to it, and this type takes the commitment's answer as given — so "Reading, 3× a week" appears on all
seven days and, on the four you did not read, says it is not kept.

This is ADR-1015's stated cost, not a discovery: *"a consumer that draws every due commitment will show
a three-times-a-week commitment on all seven days of its week — correct for the first three, unhelpful
for the last four. This is the cost, it is stated in the spec rather than hidden, and it is the day
screen's to fix with ticks."* The repo owner signed that ADR on 2026-09-02, and #27's G2 the same day
cut three Stories — this one, #71 and #72 — and no fourth for the quota. So the fix is after these
three, and this Story's job is to make the cost visible in a requirement rather than let a future
reader find it on a screen.

It is worth saying plainly what fixing it here would have cost, because it is more than a scenario. A
day view that hid a met quota would have to count ticks within a week, which needs (a) a rule for where
a week begins, an open product question that ADR-1015 says nothing in the engine can settle, and (b) a
way to see more than one date's ticks at once, which `History` deliberately does not offer — it answers
one commitment on one date and enumerates nothing. That is a second capability's seam widened inside a
Story whose sentence is "list the commitments due on a date", which is the shape `AGENTS.md` rule 5
says to stop on rather than build. If the owner wants it sooner, the answer is a fourth Story, not a
bigger #70; the delta above does not change either way.

### A day view is a snapshot, and formed again rather than refreshed

**Chosen: kept-ness is read from the history at the moment the day view is formed, and the day view
never looks at that history again.** A `History` is a value; a `DayView` built from one is a value too,
and a tick added afterwards is a change to a different value. The delta pins it with a scenario,
because the alternative reading is easy to fall into and would fail it.

The consequence is #71's to carry and is named here so it is not a surprise there: a screen that ticks
a row owns a `History`, mutates it, and forms a new `DayView`. That is one line, it is what SwiftUI
does with observed state anyway, and it keeps the engine free of the only alternative — a day view
holding a reference to a live history, which would make its answers change under a reader and would
stop it being a value at all.

### Naming: `DayView` is the value, `DayScreen` will be the screen

**Chosen: the type is `DayView`, and the SwiftUI view that eventually draws one is not.** `CONTEXT.md`
§ *Day view* is explicit that a day view is deliberately not the screen that draws one, in the way a
history is not the store that keeps it — and the capability is called `day-screen`, which leaves
`DayScreen` free for the thing with pixels. This is worth writing down because the collision is the
obvious mistake: in a SwiftUI codebase, `DayView` is exactly the name a `View` would want, and taking
it for a value now is what stops someone naming the screen after the vocabulary's other word.

### No ADR

None of the decisions above meets all three tests in `docs/adr/README.md`. Composition-by-delegation is
what `commitment` already does to `schedule` and is the least surprising thing in the file; the
snapshot-value shape is what every type in this package is; the order rule is a consequence of
`commitment`'s first requirement, argued above so nobody rediscovers it; and the one decision here
that *is* expensive to reverse — what a weekly quota can mean to something that draws every due
commitment — is ADR-1015's, already accepted and signed. Writing an ADR now would put a record in the
register that says nothing `CONTEXT.md`, ADR-1015 and this delta do not.

## Risks / Trade-offs

- **A three-times-a-week commitment will read as four misses a week.** → Deliberate, argued in § *A
  weekly quota keeps its row*, signed as ADR-1015's cost, and made visible by a scenario rather than
  left to be discovered. The fix needs a week boundary nobody has decided and a widening of `record`'s
  seam; it is a Story, not a paragraph.
- **`Row` exposes a name and a boolean, and #71 needs the commitment back.** → The same trade #55 took
  with `Tick` and `History`, upheld at that Story's review. The commitment is already stored, so #71's
  widening is one line in a delta that says what shape it needs, rather than a guess exported now.
- **`DayView` does not expose its date, and #72 will want it.** → Same trade, same answer. The date is
  stored and pinned by an equality scenario, so the widening is additive.
- **Nothing here proves a screen draws anything.** A `DayView` correct in `swift test` is compatible
  with a SwiftUI row bound to the wrong property. → This is `docs/open-questions.md` § *Known gaps*,
  "No UI smoke layer", recorded at #27's G1 before this Story existed, and its trigger — a second
  screen to regress against — has not fired. Flagged in `proposal.md`; not closed here.
- **Twenty-one scenarios on a type whose body is a `filter` and a `map` will mostly pin rather than
  drive.** → As on #42 and #55. The ones expected to drive are the first row, the first kept-ness, the
  kept-from floor, the duplicate, and the two equality scenarios that depend on the date being stored;
  `tasks.md` names them and asks the implementer to record which actually ran red, because a prediction
  is not evidence.
- **The list of commitments has no source.** Nothing in the system can produce one, so every caller for
  now is a test. → Accepted and deliberate: B-015 defines a commitment from the phone and B-020 lists
  them, and neither is cut as a Story. A day view that waited for them would be a Feature waiting on a
  Feature; taking the list as an argument is what lets this one be finished and signed on its own.
- **A future record that is not a tick — a number, a sentence (B-001..B-004) — will not fit
  `isKept`.** When one arrives, a row's second field becomes richer than a boolean and this
  requirement is MODIFIED. → Accepted. What is fixed here — which commitments a date asks for, in what
  order, each with what it did about it — survives that widening; only the shape of "what it did"
  changes, and designing for it now would be designing for wants that have not been groomed into a
  Feature.

## Migration Plan

None. Nothing is stored, no `DayView` exists outside a test, and the change adds one type without
touching any other. `openspec/specs/day-screen/spec.md` is created at archive time and no existing
spec is modified, so CI check 2 sees exactly one claimed capability.

## Open Questions

**None.** Every question this grill raised was a fact rather than a preference, and each is closed
here or in the delta. No `## Questions for you` round was raised, because nothing left over would have
changed the delta and been the owner's to decide rather than the specs' to answer — the one candidate,
the weekly quota, is recorded below as settled twice over on 2026-09-02.

- *Does the day view hide a commitment on a weekly quota once the week's quota is met?* **No, and this
  Story is not where that is decided.** Settled by ADR-1015, which the owner signed, and by #27's G2 the
  same day, which cut three Stories and no fourth for it. § *A weekly quota keeps its row* has what
  fixing it would cost and why it is a Story rather than a paragraph; `proposal.md` § *Impact* records
  that `docs/open-questions.md` § *Week turnover* stays open and is not forced here.
- *Does a commitment leave the view once it is ticked?* No. `CONTEXT.md` § *Day view*, agreed with the
  owner at the second grooming pass: it stays in the view and goes quiet. Two scenarios pin it.
- *In what order do the rows come?* The order the commitments were handed over. `CONTEXT.md` § *Day
  view* again, and § *The order is the caller's* says why there is no other honest answer.
- *Does the day view sort unticked commitments to the top?* No — that is B-006, this Story's own
  want, read as a layout rule it never asked for; it is not what the Story says, and it would move a
  row under the thumb about to tick it. Argued as the
  rejected alternative in § *The order is the caller's*; a scenario pins a kept row's place, so a
  future want to change it has to MODIFY a requirement rather than slip in.
- *Does the day view deduplicate a commitment handed to it twice?* No. It has no grounds to: two
  commitments alike in all three parts are the same commitment, and nothing here knows whether that was
  a mistake. A scenario pins it.
- *Does the day view know what today is?* No, and it must not. ADR-1004 keeps the present moment out of
  the package, and `CONTEXT.md` § *Day view* says the question is asked of a date. #71 is the Story
  that needs today, and it asks the device itself.
- *Can a day view be formed for a date that has not arrived?* Yes — it cannot tell, for the reason
  above, and a scenario pins the last supported year. Whether a screen offers such a day, and whether
  its row refuses a tick, is #71's (`CONTEXT.md` § *Row*), and whether it is reachable at all is
  #72's — B-016 left the backlog against that Story on 2026-09-02.
- *Does the day view ask the commitment or the schedule?* The commitment, so ADR-1013's kept-from floor
  applies without being restated. One scenario exists solely to fail an implementation that reaches
  past it.
- *Does a row show the rhythm the commitment runs on, in words?* No. B-021, and it would need the
  schedule read-back `docs/open-questions.md` § *Known gaps* records as missing. Nothing in this delta
  asks for it, so the gap is not closed and not widened.
- *Does a row show anything of the commitment's history — a count, a recent trend?* No.
  `CONTEXT.md` § *Day view* says a day view counts nothing, and B-011 is explicitly parked behind
  B-007.
- *Does the day view hold the list of commitments, or find it?* It is handed one. Nothing in the system
  produces a list yet, and a day view that owned one would be answering B-020 without being asked.
- *Is the day view a live window onto a history?* No, a snapshot; § *A day view is a snapshot* has the
  reasoning and a scenario pins it. #71 forms a new one after a tick.
- *Is the date part of a day view's identity?* Yes. Two dates whose rows coincide are two days, and an
  equality scenario pins it — which is also what forces the date to be stored rather than merely used.
- *Does anything in `commitment`, `record`, `schedule` or `CalendarDate` have to change?* No. Every
  member this needs — `Commitment.isDue(on:)`, `Commitment.name`, `History.isKept(_:on:)` — is already
  public. Exactly one capability is claimed.
- *Is `day-screen` the right capability for a type with no pixels in it?* Yes. `CONTEXT.md` § *Day
  view* and § *Row* both assign the day view and the row to `day-screen` and keep `record` to what a
  tick is; and `docs/open-questions.md` § *Known gaps* already anticipated this capability's tests
  attaching at a view-model seam inside `DayByDayKit`.
- *Does this Story need an ADR?* No. § *No ADR* gives the reason against all three of
  `docs/adr/README.md`'s tests.
