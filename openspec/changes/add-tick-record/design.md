## Context

`DayByDayKit` exports two seams, `Schedule.isDue(on:)` and `Commitment` — a name, a schedule and the
day it is kept from, answering `isDue(on:)` as a floor and then delegation (ADR-1013). Everything in
the package is a pure value over `CalendarDate`, with no clock, no time zone and no locale
(ADR-1004), and this change inherits all of that without restating a word. Motivation is in
`proposal.md`; the behaviour contract is in `specs/record/spec.md` and is not repeated here.

What is new is that this is the first thing in the engine that holds *state*. Every type so far is a
rule or a rule's argument; a history is what has been done, and it changes as days are ticked. That
makes the interesting questions two: how a tick is prevented from existing where it must not, and
how a history stays a value the rule engine can hold rather than becoming a store by stealth. The
grill's questions were about those, and about the one operation the Story's sentence does not name.

**Measured on this machine on 2026-09-02, on Apple Swift 6.3.3 in language mode 6, rather than
recalled.** The package's test run reports 64 tests passing today, which is the number the tasks
count up from. The weekdays every scenario pins were checked in Foundation's own `.gregorian`
calendar under UTC, the calendar `CalendarDate` uses, rather than trusted from any other source:
31 August 2026 is a Monday, 2 September a Wednesday, 5 September a Saturday; 28 February 2027 is a
Sunday; 3 January 1583 and 27 December 9999 are both Mondays. The last two matter because the
scenario that pins *no clock* stands on them, and the first supported year is the one place a
Gregorian and a Julian answer could have disagreed.

## Goals / Non-Goals

**Goals:**

- A tick that cannot be malformed: if you hold one, the commitment was due on that date. The
  invariant is in the type, not in a check every caller has to remember.
- A history that is a value — equatable, hashable, sendable, copied by assignment — with the
  smallest public surface that makes the delta's scenarios observable and not one member more.
- The clock kept out. No member here takes or asks for the present moment, so a past day answers
  tomorrow exactly as it does today, and a test gives the same answer in every time zone.

**Non-Goals:**

- Durability of any kind. Nothing here survives the process; that is #56, and the store it chooses
  wraps a `History` rather than replacing it.
- Reading ticks back out of a history, or a commitment or date back out of a tick. #56 needs both
  to persist anything and widens them in its own delta; see § *The seam*.
- Any record that is not a tick. A number, a sentence and a running total (B-001..B-004) are other
  kinds of record, and the type that holds them is not designed here — see § *Risks*.
- Counting, aggregating or ranking ticks. A history answers one date at a time on purpose
  (`CONTEXT.md` § *Nothing congratulates you*); the deliberate look-back is B-007's.
- Changing `Commitment`, `Schedule` or `CalendarDate`. A tick asks `Commitment.isDue(on:)` and
  takes the answer as given.
- Anything on screen, including how far back or forward a screen lets a person go (#27, B-016).

## Decisions

### The seam

**New: `Tick` and `History`, both exported from `DayByDayKit`.** They are one seam with two entry
points rather than two seams: there is no way to put anything into a `History` except through
`Tick`'s initializer, and no way to observe a `Tick` doing anything except through a `History` or
its own equality. `Commitment` and `Schedule` do not move, are not wrapped, and are not widened.

```swift
public struct Tick: Hashable, Sendable {
    public init?(_ commitment: Commitment, on date: CalendarDate)
}

public struct History: Hashable, Sendable {
    public init()

    public mutating func add(_ tick: Tick)
    public mutating func remove(_ tick: Tick)

    public func isKept(_ commitment: Commitment, on date: CalendarDate) -> Bool
}
```

As with `CalendarDate`, `DayOfMonth`, `DayInterval` and `Commitment` before it, **the failable
initializer is part of the seam rather than a second one**, because there is no way to obtain a
`Tick` without going through it. Seven scenarios in the delta observe that initializer's refusal or
acceptance, three observe tick equality, and thirteen observe `History` through `isKept(_:on:)` and
its own equality. No process is spawned and no global stream is captured.

Three smaller choices inside that shape:

**`Tick` does not expose its commitment or its date, and `History` does not enumerate its ticks.**
Nothing in this delta needs either back: the scenarios observe a tick through equality and a history
through a yes-or-no. This is the same stance `Commitment` took in #42 for its schedule and kept-from
day, and `docs/open-questions.md` § *Known gaps* records it for the payload types, and the answer is
the same: the Story that needs read-back widens the surface in a delta that says what shape it needs.
Here that Story is certain and next — #56 cannot persist a history it cannot read — and the widening
is still left to it, because *what* it needs depends on the store it chooses (a set of pairs to
encode, or rows to write) and choosing that store is #56's ADR. Exporting a guess now would be
exporting a shape nobody has signed.

**`add` and `remove` return nothing.** There is nothing to report: an `add` of a tick already held
and a `remove` of one not held both leave the history unchanged by requirement, and both are observable
through equality. A `Bool` saying "this changed something" would be the first member in the engine
whose value no scenario pins, and a screen has no use for it — it re-asks `isKept`.

**`History` is a `struct` with `mutating` members, not a class.** The engine is values, and a value
is what #56 can snapshot, encode and compare. Whoever needs shared, observed mutation — a view model,
eventually — owns a `History` and publishes it; the engine does not become that owner.

### A tick cannot be malformed

**Chosen: `Tick.init?` refuses a date the commitment is not due on, and there is no other way to make
one.** The refusal is one line — `guard commitment.isDue(on: date)` — and puts the invariant where
every other invariant in this engine lives: 30 February is not a date, an interval of no days is not
an interval, a blank name is not a commitment, and a tick of a commitment on a Tuesday it does not run
on is not a tick.

*Alternative — a `History.tick(_:on:)` that checks due-ness and returns whether it took.* One type
instead of two. Rejected because the invariant then lives in the collection rather than in the thing,
so a `Tick` handed around outside a history could be anything, and every future consumer — the store,
a view model — inherits a check instead of a guarantee. It would also give `History` a second
responsibility the requirement does not ask of it: a history holds and answers, it does not judge.

*Alternative — form the tick and let the screen decide what to offer.* Rejected before it was
considered: `CONTEXT.md` § *Tick* says a day on which the commitment is not due takes no tick, agreed
with the owner at the grooming pass on 2026-09-02. The engine refuses rather than adjusts everywhere
else, and refusing here is the same stance.

The floor from ADR-1013 is not re-implemented. A date before the day a commitment is kept from is
already *not due* by `Commitment.isDue(on:)`, so it takes no tick through the same guard, and the
scenario that pins it would fail only if this type reached past the commitment to ask the schedule
directly. That is the mistake the scenario exists to catch.

### A tick is keyed to a commitment value, not an identity

**Chosen: a tick holds the `Commitment` it is of, by value, and a history is keyed on that value and
the date.** A commitment has no identity of its own — `commitment`'s first requirement says two alike
in all three parts are the same commitment — so the only honest key is the value.

This has a consequence worth stating plainly rather than discovering at B-014: a commitment renamed,
or moved to Tuesdays, is a *different value*, and the ticks keyed to the old value do not follow it.
That is correct for a value type and would be wrong for the product, and the archived design of #42
already named where it gets fixed: *"exactly the seam at which the store's identity will attach."*
When #56 or B-014 brings an identifier, the history the store persists is keyed on it, and `History`
as defined here is what that store answers *from*, not what it is.

*Alternative — key a tick on the commitment's name.* Cheaper to look at and wrong: two commitments
with one name and different rhythms are different commitments by requirement, and a tick on the name
alone could not even ask whether it was due.

### The clock stays out, so the future is not this capability's to refuse

**Chosen: a tick on any due date is formed, whether that date is past, today or yet to come, and a
scenario pins the two ends of the supported range to say so.** ADR-1004 keeps the present moment out
of the engine, and "is this date in the future" is a question about the present moment. There is no
way to refuse a future tick here without either consulting a clock — which would make a past day's
answer change tomorrow — or taking "today" as a parameter, which would make a tick a function of
three things and hand every caller a way to lie.

The consequence is that *how far back the past stays writable*, open in `docs/open-questions.md`, is
answered here by two facts already signed rather than by a preference: a tick exists exactly where the
commitment is due, and ADR-1013 stops due-ness at the day the commitment is kept from. The record is
writable back to that day and no further, in either direction. Whether a screen offers all of it —
and whether it offers days that have not arrived, which B-016 leaves to #27's first Story — is the
screen's rule, applied with the day it asked the device for. `proposal.md` § *Impact* flags the entry
for the file's owner to move.

### Taking a tick back

**Chosen, settled by the owner on 2026-09-02: a history lets a tick be removed, and remembers
nothing of it.** The Story's sentence says *tick* and *read back*; it does not say *untick*, and the
reasoning for adding it is under § *Open Questions* rather than repeated here. The design point is
narrower:
untick is `Set.remove`, one line, and its whole contract is *as though it had never been added* —
which is why the last scenario of the delta compares a ticked-then-unticked history with an empty
one. An implementation that kept a tombstone, a count, or a "was unticked" flag would fail it, and
that is the one way this could go wrong.

*Alternative — a tick is permanent in this Story, and taking one back is a later want.* The smaller
delta, by one requirement and five scenarios, and the one the owner declined; § *Open Questions*
records what it would have cost.

### No ADR

None of the decisions above meets all three of the tests `docs/adr/README.md` sets. The refusal rule
is `CONTEXT.md`'s already and would surprise nobody who has read it; the value-not-class shape is what
every type in the engine is; the value-keyed identity is a consequence of `commitment`'s first
requirement, recorded here so B-014 does not rediscover it; and the one decision in this Feature that
*is* expensive to reverse — where the record is kept — belongs to #56 and is named there as the
storage ADR. Writing an ADR here would put a record in the register that says nothing the specs and
`CONTEXT.md` do not.

## Risks / Trade-offs

- **A commitment kept on the wrong day records nothing.** Going to the gym on a Tuesday leaves no
  tick, because Tuesday takes none on a Mon/Wed/Sat rhythm. → This is the rule the owner agreed at
  the grooming pass, not a gap; it is stated normatively so nobody softens it in code. If it turns
  out to be wrong in use, it is a want against `record`, and the fix is a requirement here rather
  than a screen quietly ticking the nearest due day.
- **Ticks keyed to a commitment value do not survive the commitment changing.** → Argued in § *A tick
  is keyed to a commitment value*; correct for this type, and named as the seam where #56's or
  B-014's identity attaches. Nothing edits a commitment yet, so nothing is blocked.
- **The engine will form a tick for a date that has not arrived.** → Deliberate and argued in § *The
  clock stays out*. The screen that knows what today is withholds days it does not want ticked; the
  engine cannot, and a rule that pretended to would break ADR-1004.
- **`Tick` is the plain kind of record, and a numeric or text record (B-001..B-004) is not designed
  here.** When one arrives, either `History` gains a second kind or `Tick` becomes one case of a
  `Record` enum, and `isKept` may need a sibling. → Accepted: designing the enum now would be
  designing for wants that have not been groomed into a Feature. What is fixed here — one record per
  commitment per day, keyed to a date, refused where not due — is what every kind will share, so the
  requirements survive the widening even if the type is renamed under them.
- **Twenty-three scenarios, thirteen of them on a type that is a `Set` wrapper, will mostly pin
  rather than drive.** → As on #42, where fourteen of nineteen ran green immediately. The ones that
  drive are the refusal, the first `isKept`, the first `remove`, and the three equality scenarios that
  would fail an implementation keeping any residue of an untick; `tasks.md` names them and asks the
  implementer to record which actually ran red.
- **#11's weekly quota may not be tickable through `Commitment.isDue(on:)` at all** — three nights a
  week on any days plausibly needs the history to answer due-ness, and this seam takes a history
  nowhere. → Unchanged by this Story and not made worse: `Tick` asks the commitment and takes its
  answer, so whatever #11 makes `isDue` say, a tick follows. If #11 needs due-ness to consult the
  history, that is a change to `commitment`'s seam and #11's delta to write.

## Migration Plan

None. Nothing is stored, no `History` exists outside a test, and the change adds two types without
touching one. `openspec/specs/record/spec.md` is created at archive time and no existing spec is
modified, so CI check 2 sees exactly one claimed capability.

## Open Questions

None. One question was a preference rather than a fact and went to the owner as a question round;
he answered it on 2026-09-02 and it is settled first below. Everything else the grill turned up was
a fact, and is closed here or in the delta:

- *Can a tick be taken back in this Story?* **Yes — settled by the owner on 2026-09-02, on the
  recommended answer.** The Story's sentence says *tick, and read back* and nothing about untick,
  and no want in `docs/backlog.md` asked for one; but a tick is one tap on a phone, and a tap that
  cannot be undone turns every mis-tap into a permanent false record in a product whose one promise
  is an honest one. So the third requirement, *A tick can be taken back*, and its five scenarios
  stay in the delta; `History.remove(_:)` stays in the seam; **Untick** stays in `CONTEXT.md`. The
  alternative — a tick permanent in this Story and untick a later want — would have dropped the
  delta to eighteen scenarios and cost #56 a second delta to both capabilities at the first mis-tap.
  § *Taking a tick back* has the design point.
- *Is a tick on a day the commitment is not due on refused, or recorded and flagged?* Refused. Agreed
  with the owner at the grooming pass on 2026-09-02 and written into `CONTEXT.md` § *Tick* then; the
  delta makes it a refusal at formation, § *A tick cannot be malformed*.
- *Does ticking before the day a commitment is kept from need a rule of its own?* No. Such a date is
  not due (ADR-1013), so it takes no tick under the same requirement. One scenario pins it.
- *How far back is the past writable?* Back to the day the commitment is kept from, as a consequence
  of two signed facts rather than a choice — § *The clock stays out*. The entry in
  `docs/open-questions.md` is flagged in `proposal.md` for its owner to move.
- *Can a date that has not arrived be ticked?* By the engine, yes, because it cannot tell
  (ADR-1004). Whether a screen offers it is #27's (B-016).
- *Does a tick carry when it was entered?* No. `CONTEXT.md` § *Record* keys it to the date and never
  to the time, and the first requirement says a tick is exactly two things.
- *Is a second tick on the same day an error, a second record, or nothing?* Nothing: at most one per
  commitment per day is `CONTEXT.md`'s already, and the delta makes it observable through equality.
- *Does a history need to know which commitments exist?* No. It is asked about a commitment and a
  date and answers from its ticks; a commitment it has never seen is simply not kept. A list of
  commitments is a different thing and no Story has it yet.
- *Does asking about a not-due day error?* No, it answers *not kept*, and a scenario says so. The
  asker distinguishes *not due* from *missed* with `Commitment.isDue(on:)` beside it — two questions,
  two answers, no third state invented here.
- *Does the seam move, or do `Commitment`, `Schedule` or `CalendarDate` change?* None of them. A tick
  asks `Commitment.isDue(on:)`, which is public, and needs nothing else from it.
- *Does #56 need anything from this delta beyond what it gives?* Yes — read-back of a history's ticks
  and of a tick's parts — and it is deliberately left to #56's delta, § *The seam*.
- *Does the weekly quota (#11) need anything here?* No. A tick follows whatever `isDue` says; if the
  quota needs due-ness to consult the history, that is `commitment`'s seam and #11's problem.
