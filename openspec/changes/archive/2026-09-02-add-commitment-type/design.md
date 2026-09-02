## Context

`schedule` is finished for three of its four shapes and `DayByDayKit` exports one seam,
`Schedule.isDue(on:)`, taking a `CalendarDate` and returning a `Bool`. ADR-1004 fixed that shape and
its consequences — no clock, no time zone, no locale, a supported year range of 1583 through 9999 —
and this change inherits all of it without restating a word. Motivation is in `proposal.md`; the
behaviour contract is in `specs/commitment/spec.md` and is not repeated here.

What is new is that this is the first type in the engine that is not a *rule*. `CalendarDate`,
`Weekday`, `DayOfMonth`, `DayInterval` and `Schedule` are all things the calendar or the rule needs.
A commitment is a thing a person has, and the only reason it is in the rule engine at all is that
due-ness is asked of it. That makes the interesting question a modelling one — what may it hold —
which is why the grill's two questions were both about its contents.

**Both came back on 2026-09-02, and the first came back against the recommendation.** A commitment
carries a third thing: the day it is kept from, before which it is not due. The owner's reason was
the one the round was raised to surface — *"I don't want to have due ticks in the past I was never
able to fulfill because the commitment was not there yet."* § *Open Questions* records both answers
as settled, and this document and the delta are written on them rather than on what was recommended.
That answer is also why `docs/adr/1013-a-commitment-is-kept-from-a-day.md` exists: `proposal.md`
undertook to write one if the answer went this way.

**Measured on this machine on 2026-09-02, on Apple Swift 6.3.3 in language mode 6, rather than
recalled.** Three things needed checking before they were written down.

The blank-name rule rests on `Character.isWhitespace`, and the question was whether one guard covers
both an empty name and a name of only blanks:

| expression | result |
|---|---|
| `"".allSatisfy(\.isWhitespace)` | `true` — an empty collection satisfies `allSatisfy` vacuously |
| `" ".allSatisfy(\.isWhitespace)` | `true` |
| `" \t\n ".allSatisfy(\.isWhitespace)` | `true` |
| `"\u{00A0}"` (no-break space) | `true` |
| `"\u{3000}"` (ideographic space) | `true` |
| `"\u{200B}"` (zero-width space) | **`false`** |
| `"🏋️"` | not whitespace; `count` is `1`, one grapheme cluster |

So `guard !name.allSatisfy(\.isWhitespace)` is the whole rule and needs no separate emptiness check,
and the delta's "empty or made only of whitespace" is one condition rather than two. The zero-width
space is the honest limit of it and is in § *Risks*.

The second was **where the floor comparison comes from**, and it produced a finding that decides
where this type lives. `CalendarDate`'s `year`, `month` and `day` are *internal*, and the type is not
`Comparable`; a stand-in written in a second module could not ask whether one date precedes another
at all, and had to rebuild the comparison out of Foundation to get anywhere. Inside `DayByDayKit`
there is nothing to build: `days(until:)`, the internal helper #10 added and measured as signed,
answers it directly — `keptFrom.days(until: date) < 0` is exactly "before the floor". So the floor
costs **no new member on `CalendarDate`, public or otherwise**, and `Commitment` must live inside
`DayByDayKit` rather than beside it. ADR-1004 warned that a date type growing convenience API is the
signal something has leaked in from the edge; this change adds none.

The third was the whole reworked shape, compiled and run: `Commitment` inside a copy of the package,
driven from a second module importing it plainly, no `@testable`, which is how the real tests import
it. Every one of the delta's nineteen scenarios was exercised against it and answered as written —
including the five that are only interesting because of the floor:

| case | answer |
|---|---|
| Mon/Wed/Sat kept from Wed 2 Sep 2026, asked about Mon 31 Aug 2026 | not due — the floor beats the schedule |
| the same, asked about Wed 2 Sep 2026 | due |
| Mon/Wed/Sat kept from Tue 1 Sep 2026, asked about that Tuesday | not due — the floor is not a phase |
| the 25th of the month kept from 1 Sep 2026, swept across all of August 2026 | due on none of the 31 |
| every 3 days from 25 Aug 2026 kept from 1 Sep 2026 | 28 and 31 Aug not due, 3 Sep due |

Identity over all three components behaved too — five commitments differing pairwise in one field
each collapse to four distinct values — and a `public struct` with one `public let` and two
*internal* stored properties still gets a synthesised `Hashable` conformance usable from the
importing module.

## Goals / Non-Goals

**Goals:**

- One small immutable value that names a thing, carries the rule for it, and knows the day it starts
  being owed, with the smallest public surface that makes the delta's scenarios observable and not
  one member more.
- A boundary written down where a reader can see it: what a commitment holds is fixed *by
  requirement*, so the next field anyone wants costs a delta and a gate rather than a commit.
- Due-ness that stays a pure function of a calendar date, exactly as ADR-1004 fixed it. The floor
  does not weaken that — it is a value the commitment carries, not something the rule reaches
  outside itself for, which is the same property #10 established for the interval's start date.

**Non-Goals:**

- Changing `Schedule.isDue(on:)`, its signature, or anything else in the `schedule` capability. In
  particular the every-N-days start date is untouched: the floor does not replace it, subsume it or
  reinterpret it. See § *Two dates, and why neither is the other*.
- Adding any member to `CalendarDate`. The floor is answered by the internal `days(until:)` that
  already exists.
- A collection of commitments — a list, an order, uniqueness among names. Every one of those is a
  property of a *set* of commitments, and there is no type here that holds more than one.
- Editing, renaming, pausing, archiving or deleting a commitment. A value type has no such verbs;
  they are operations on whatever eventually stores commitments, and nothing stores one yet. An
  **end** date is the same: a floor is not a window, and nothing asks for the other side of one.
- Reading the schedule or the kept-from day back out of a commitment. See § *The seam*.
- Anything that reads a tick, and anything on screen.

## Decisions

### The seam

**New: `Commitment`, exported from `DayByDayKit`.** It is the package's second seam and the
capability's first; `Schedule.isDue(on:)` does not move, is not wrapped, and is not widened. Every
acceptance test in this change attaches to `Commitment`:

```swift
public struct Commitment: Hashable, Sendable {
    public let name: String

    public init?(name: String, schedule: Schedule, keptFrom: CalendarDate)

    public func isDue(on date: CalendarDate) -> Bool
}
```

A second seam rather than reuse of the first is unavoidable here and is not a widening of the rule:
`AGENTS.md` prefers an existing seam, and there is no honest way to observe *a commitment reads back
its name* through `Schedule.isDue(on:)`, which knows nothing about names. What the preference does
buy is that this is the only new seam — `isDue(on:)` on `Commitment` applies the floor and then
delegates rather than reimplementing, so no scenario here can pass while the equivalent schedule
scenario fails.

As with `CalendarDate` in #8, `DayOfMonth` in #9 and `DayInterval` in #10, **the failable
initializer is part of this seam rather than a second one**, because there is no way to obtain a
`Commitment` without going through it. `name` is part of it too, and for a reason the earlier types
did not have: without read-back, the name half of this Story has no observable behaviour at all and
no scenario could be written for it. Four scenarios in the delta observe the initializer's refusal,
three observe `name`, four observe value identity, and eight observe the `Bool`. No process is
spawned and no global stream is captured.

Four smaller choices inside that shape:

**`schedule` and `keptFrom` are stored properties and stay internal.** A commitment is constructed
*with* them and answers *from* them, and nothing yet needs either back — the day screen renders a
name and a tick box. This is the same asymmetry `docs/open-questions.md` § *Known gaps* records for
`DayOfMonth.day` and `DayInterval.days`, and the answer is the same: the first Story that draws a
rule on screen widens all of them in one delta, and until then nothing is exported on speculation.
The delta is careful not to require read-back of either, so the internal properties satisfy it rather
than falling short of it. Note what the delta *does* require in their place: two commitments
differing only in schedule, or only in the day they are kept from, are different commitments — which
is the observable proof that both are carried.

**`keptFrom:` is a required parameter with no default.** A defaulted one would have to be either
"today", which this capability may not ask for (ADR-1004 keeps the clock at the edge, and a rule that
consulted it would stop giving a past day the same answer tomorrow), or some fixed epoch, which is
the fabricated history the requirement exists to prevent, reintroduced for every caller who forgets
the argument. Required, and the delta says so normatively.

**`Hashable` rather than bare `Equatable`.** Equality over all three components is what the delta
requires; hashing is what makes it usable by the collection that will eventually hold these, and
Swift synthesises both from the same stored properties at no cost.

**`Sendable`, matching every other type in the package.** The engine is pure values; a type here that
could not cross an isolation boundary would be an oddity to explain later rather than a saving now.

### The day a commitment is kept from

**Chosen: every commitment carries a calendar date it is kept from, and is not due before it.** This
is the owner's answer to question 1, against the recommendation, and the reasoning is his: due days
in the past that were never possible to fulfil are exactly the false record this product exists to
replace. The recommendation's argument — that "when did this come into being" is a fact about the
record rather than the rule — turns out to be the weaker one once you notice that **the answer would
have to be consulted on every single row of every past day anyway**. Putting it anywhere else means
the day screen carries a due-ness rule of its own, which is precisely the split ADR-1004 exists to
prevent.

*Alternative — leave it out and answer "did not exist yet" in storage.* The recommendation, now
rejected. It kept the type at two fields and it deferred the question a third time, which is what
made it worth putting to a human rather than deciding: three Stories in `schedule` had already
written prose about commitments without one existing, and #10 explicitly left the general case open.

**The name.** It is *not* called a start date. `CONTEXT.md` already has **Start date** meaning the
day an every-N-days schedule counts from, and the two are different things that can hold different
values on the same commitment; reusing the word would make the one place they interact unreadable.
"Created on" was rejected for a stronger reason than tidiness: this date is not an audit stamp. A
person who has kept the gym since June and only now writes it down should be able to say June, and
the delta says so in as many words. **Kept from** is the product's own verb — you *keep* a
commitment — and it reads correctly in both directions: "Gym, Mon/Wed/Sat, kept from 1 September",
and "not due before the day it is kept from".

### Two dates, and why neither is the other

An every-N-days commitment now carries two calendar dates, and the obvious question is whether that
is one too many. It is not, and the delta states both jobs separately because they are separate:

- The interval's **start date** is a *phase*. It decides which dates the rhythm lands on — every
  third day counted from that one — and moving it changes the whole set of due dates forever.
- The commitment's **kept-from day** is a *floor*. It decides nothing about which dates the rhythm
  lands on; it only suppresses landings earlier than itself.

So a start date of 25 August with a floor of 1 September is a well-defined thing: the rhythm is
25, 28, 31 August, 3, 6 September and onward, and the first three are simply never owed. Measured
above, and it is the last scenario in the delta because it is the one an implementation that
conflated the two would get wrong. The reverse pairing needs no rule: a floor earlier than the start
date adds nothing, because the interval's own requirement already refuses dates before its start.

Collapsing the two — making the interval count from the floor — was considered and rejected in one
line: it would silently change the due dates of every interval commitment whose floor is not on the
rhythm, and #10's start date is a requirement that has passed G4.

### A commitment carries no identity of its own

**Chosen: a commitment is a value — its name, its schedule and the day it is kept from, with
equality over all three.** No `UUID`, no row id, no sequence number.

*Alternative — give it an identifier now, because storage will need one.* Rejected, and the reason is
about who gets to decide rather than about cost. An identifier is not a property of a commitment; it
is a property of a *store's* record of one, and `docs/open-questions.md` still has SwiftData versus
GRDB open. Minting an id here would pick a shape for a store nobody has chosen, and would put a field in
the engine that no rule reads and no scenario can pin except by reading it straight back. When
storage arrives it brings its own identity, and a commitment is what it wraps.

The cost is real and worth stating, though the kept-from day has just made it smaller: two
commitments a person deliberately created as separate — same name, same rhythm, kept from the same
day — are one value to this type. That is correct for a value and wrong for a stored record, and it
is exactly the seam at which the store's identity will attach.

### Due-ness is a floor and then delegation, and the delta says both normatively

The obvious way to write this is "a commitment on a weekday-set schedule is due when …", once per
shape. That would be three requirements restating `schedule`'s, and a fourth arriving with #11. The
delta instead states the two rules the commitment actually has — the floor, and delegation from the
floor onward — and uses one scenario per existing shape as evidence that the delegation reaches
through, choosing for each the case a shortcut would break: the day-of-month scenario is a
short-month clamp, not a plain hit, and the every-N-days scenario is the start-date boundary.

Two scenarios in the delegation requirement are about what does *not* enter the rule rather than what
does: identical answers from two commitments whose names differ, and a schedule due on no date
answering rather than erroring. Both are cheap and are the ones that would otherwise be discovered by
a screen.

### The blank-name refusal, and what it deliberately does not do

Refusing a name that is empty or all whitespace follows the engine's established stance — `30
February` is refused rather than adjusted, `0` is refused as a day of the month, `0` is refused as an
interval — and it is the same kind of refusal: a value that names nothing is not formed. It costs one
guard, measured above.

What it does not do is normalise, and that is the owner's answer to question 2, on the
recommendation: a name is stored exactly as typed, so `" Gym "` keeps both spaces and is a different
commitment from `"Gym"`. The engine refuses rather than adjusts everywhere else, ADR-1004 puts
normalising at the edges where the text field is, and a name is the owner's own words. A third
reading was considered and never put to him: *refuse a name with leading or trailing whitespace
outright*. It is the purest "refuse, never adjust" answer and it is user-hostile — a stray space
typed on a phone would reject the whole commitment — so it is recorded as rejected rather than
offered.

There is no upper bound on length, no script restriction and no reserved name. A bound would be a
number nobody can defend, and the place that can defend one is the text field that eventually accepts
the name.

## Risks / Trade-offs

- **Every caller must now supply a day, and there is no honest default the engine can pick.** →
  Accepted deliberately; it is the whole point of the answer. The edge that creates a commitment
  knows what today is and will pass it, and a person backdating one passes something earlier. The
  requirement says the parameter is required so that "we will add it later" cannot happen quietly.
- **The blank-name rule is Unicode whitespace, and a name of a single zero-width space (U+200B) is
  accepted** — measured above, it is a format character rather than a whitespace one. → Accepted
  deliberately. Chasing every codepoint that renders as nothing is unbounded and belongs to whatever
  eventually sanitises input, and no rule here misbehaves on such a name: it forms, it reads back
  unchanged, and it is due exactly when its schedule is from the floor onward. Recorded so a reviewer
  reads it as a chosen boundary and not as an oversight.
- **Two dates on one interval commitment is the thing a reader will trip over**, and an implementation
  that conflates them passes twelve of the nineteen scenarios. → Named as its own decision above,
  stated normatively in the fourth requirement, and pinned by the last scenario, which is chosen so
  that conflating them fails it.
- **Four scenarios pin value semantics that Swift synthesises, which can read as testing the
  compiler.** → They are not there for the compiler; they are the only observable statement that a
  commitment holds no hidden identity and that all three fields are carried, and they are what fails
  the day someone adds a `UUID` and `==` stops meaning "the same commitment".
- **#11's weekly quota may not fit `Schedule.isDue(on:)` at all** — a quota of three nights a week
  plausibly needs tick history, which this seam does not take. → Unchanged by this Story and not made
  worse by it: whatever `Schedule` can answer, a commitment answers identically from the floor
  onward, and whatever it cannot answer was already #11's problem. What this change adds is one more
  caller to fix if that seam ever moves, and it is a one-line one.
- **`Commitment` joins the read-back asymmetry, now with two internal fields rather than one.** →
  Deliberate, argued in § *The seam*, and flagged in `proposal.md` § *Impact* against the
  `docs/open-questions.md` entry, which `spec-author` may not write.
- **A commitment is immutable, so renaming one produces a new value that is not equal to the old.**
  → Correct for a value type and wrong for a record, which is the same trade-off as the identity
  decision and attaches at the same seam. Nothing edits a commitment yet, so nothing is blocked.

## Migration Plan

None. Nothing is stored, no `Commitment` exists outside a test, and the change adds a type without
touching one. `openspec/specs/commitment/spec.md` is created at archive time and no existing spec is
modified, so CI check 2 sees exactly one claimed capability.

## Open Questions

None. Two were never the agent's to close and went to the owner as a question round; he answered both
on 2026-09-02, and both answers are recorded here as settled:

1. **Does a commitment carry a date it begins to exist from?** — **yes**, *against* the
   recommendation. In his words: *"I don't want to have due ticks in the past I was never able to
   fulfill because the commitment was not there yet."* A commitment is therefore three things, not
   two; the delta gained a fourth requirement — *a commitment is not due before the day it is kept
   from* — with five scenarios, the first requirement was rewritten around the third field, the seam's
   initializer gained `keptFrom:`, and the decision is written up as **ADR-1013**, which
   `proposal.md` undertook to do if the answer came back this way. The recommendation's own argument
   is answered in § *The day a commitment is kept from* rather than quietly dropped.
2. **Is the name stored exactly as typed, or trimmed?** — **exactly as typed**, as recommended. The
   second requirement stands as written, `" Gym "` keeps both spaces, and it is a different
   commitment from `"Gym"`.

Everything else the grill turned up was a fact rather than a preference, and is closed here or in the
delta:

- *Does a commitment need an identifier of its own?* No — § *A commitment carries no identity of its
  own*. Identity belongs to a store, and which store is still open in `docs/open-questions.md`.
- *Must commitment names be unique?* Not a question this Story can even state. Uniqueness is a
  property of a collection, and no type here holds more than one commitment. It arrives, if it ever
  does, with the thing that holds a list.
- *Does the kept-from day need validity rules of its own?* No. It is a `CalendarDate`, so it already
  cannot be 30 February and already cannot fall outside 1583 through 9999; a commitment whose floor
  could not be formed cannot be built. The delta says so in as many words rather than leaving a
  reader to wonder whether the omission was an oversight — the same treatment #10 gave the interval's
  start date.
- *May the kept-from day be in the future?* Yes, and nothing special happens: the commitment is
  simply not due until it arrives, which falls out of the same requirement. No scenario is spent on
  it, because it is the identical comparison the other five already pin from the other side.
- *May a commitment carry a schedule that can never come due — an empty weekday set?* Yes, and the
  delta requires the answer rather than an error. `schedule` already decided this explicitly for the
  weekday-set shape, and refusing it here would contradict a requirement that has passed G4.
- *Is there an upper bound on a name's length, or a restriction on script or emoji?* No, on all three
  — § *The blank-name refusal*. The emoji case is a scenario because a single emoji is one grapheme
  cluster and is the shape a naive length or character-class check gets wrong.
- *Does the seam move, or does `Schedule` or `CalendarDate` change?* None of the three. `Commitment`
  is a new seam because a name cannot be observed through the old one; `Schedule` is untouched; and
  the floor is answered by `CalendarDate`'s existing internal `days(until:)`, so that type gains
  nothing either. This is why `proposal.md` claims one capability and no modified requirements.
- *Does the fourth rule shape (#11) need anything from this delta?* No. Delegation is stated in a
  form that holds for shapes that do not exist yet, so #11 adds a case to `Schedule` and nothing here
  changes.
