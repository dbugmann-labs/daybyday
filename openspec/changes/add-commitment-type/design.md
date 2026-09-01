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
rather than an arithmetic one, which is why this `design.md` is mostly boundaries and the
measurements are short.

**Measured on this machine on 2026-09-01, on Apple Swift 6.3.3 in language mode 6, rather than
recalled.** Two things needed checking before they were written down as decisions.

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

The second was the type's own shape, compiled and run **from outside the module** — a second package
depending on `DayByDayKit` by path with a plain `import`, no `@testable`, which is how the existing
tests import it. It confirmed that a `public struct` with one `public let` and one *internal* stored
property still gets a synthesised `Hashable` conformance usable across the module boundary
(`a == b` and `Set([a, b, c]).count == 2` both behaved from the importing module), and that the
delegation reaches all three existing shapes: gym Mon/Wed/Sat due 31 August 2026 and not 1 September;
a commitment on the 31st due 28 February 2027; every 14 days from 25 August 2026 due on the start
date and not the day before; an empty weekday set never due. That last set is the delta's scenarios
already answering correctly against a stand-in, which is expected — nothing here is hard, and knowing
it is not hard is what makes thirteen scenarios defensible rather than thirteen guesses.

## Goals / Non-Goals

**Goals:**

- One small immutable value that names a thing and carries the rule for it, with the smallest public
  surface that makes the delta's scenarios observable and not one member more.
- A boundary written down where a reader can see it: what a commitment holds is fixed *by
  requirement*, so the next field anyone wants costs a delta and a gate rather than a commit.
- Due-ness that stays a pure function of a calendar date, exactly as ADR-1004 fixed it.

**Non-Goals:**

- Changing `Schedule.isDue(on:)`, its signature, or anything else in the `schedule` capability. If
  this Story needs a schedule to change, that is a finding, not a refactor.
- A collection of commitments — a list, an order, uniqueness among names. Every one of those is a
  property of a *set* of commitments, and there is no type here that holds more than one.
- Editing, renaming, pausing, archiving or deleting a commitment. A value type has no such verbs;
  they are operations on whatever eventually stores commitments, and nothing stores one yet.
- Reading the schedule back out of a commitment. See § *The seam*.
- Anything that reads a tick, and anything on screen.

## Decisions

### The seam

**New: `Commitment`, exported from `DayByDayKit`.** It is the package's second seam and the
capability's first; `Schedule.isDue(on:)` does not move, is not wrapped, and is not widened. Every
acceptance test in this change attaches to `Commitment`:

```swift
public struct Commitment: Hashable, Sendable {
    public let name: String

    public init?(name: String, schedule: Schedule)

    public func isDue(on date: CalendarDate) -> Bool
}
```

A second seam rather than reuse of the first is unavoidable here and is not a widening of the rule:
`AGENTS.md` prefers an existing seam, and there is no honest way to observe *a commitment reads back
its name* through `Schedule.isDue(on:)`, which knows nothing about names. What the preference does
buy is that this is the only new seam — `isDue(on:)` on `Commitment` delegates rather than
reimplementing, so no scenario here can pass while the equivalent schedule scenario fails.

As with `CalendarDate` in #8, `DayOfMonth` in #9 and `DayInterval` in #10, **the failable
initializer is part of this seam rather than a second one**, because there is no way to obtain a
`Commitment` without going through it. `name` is part of it too, and for a reason the earlier types
did not have: without read-back, the name half of this Story has no observable behaviour at all and
no scenario could be written for it. Four scenarios in the delta observe the initializer's refusal,
three observe `name`, three observe value identity, and five observe the `Bool`. No process is
spawned and no global stream is captured.

Three smaller choices inside that shape:

**`schedule` is a stored property and stays internal.** A commitment is constructed *with* a
schedule and answers *from* it, and nothing yet needs to get one back — the day screen renders a name
and a tick box, not a rule. This is the same asymmetry `docs/parking-lot.md` recorded on 2026-08-31
for `DayOfMonth.day` and `DayInterval.days`, and the answer is the same: the first Story that draws a
rule on screen widens all of them in one delta, and until then nothing is exported on speculation.
The delta is careful not to require read-back of the schedule, so the internal property is a design
choice that satisfies it rather than a shortfall against it. Note the consequence, which the delta
*does* require: the only observable proof that a commitment carries the schedule it was given is that
two commitments differing only in schedule are different commitments, plus the delegation scenarios.

**`Hashable` rather than bare `Equatable`.** Equality is what the delta requires; hashing is what
makes the requirement usable by the collection that will eventually hold these, and Swift synthesises
both from the same stored properties at no cost. Conforming to only half of it would be a smaller
surface that buys nothing and would have to be widened by the next Story.

**`Sendable`, matching every other type in the package.** The engine is pure values; a type here that
could not cross an isolation boundary would be an oddity to explain later rather than a saving now.

### A commitment carries no identity of its own

**Chosen: a commitment is a value — its name and its schedule, and equality over both.** No `UUID`,
no row id, no sequence number.

*Alternative — give it an identifier now, because storage will need one.* Rejected, and the reason is
about who gets to decide rather than about cost. An identifier is not a property of a commitment; it
is a property of a *store's* record of one, and `docs/parking-lot.md` still has SwiftData versus GRDB
open. Minting an id here would pick a shape for a store nobody has chosen, and would put a field in
the engine that no rule reads and no scenario can pin except by reading it straight back. When
storage arrives it brings its own identity, and a commitment is what it wraps.

The cost is real and worth stating: with equality over name and schedule, two commitments a person
deliberately created as separate — same name, same rhythm, kept apart on purpose — are one value to
this type. That is the correct behaviour for a value and the wrong behaviour for a stored record, and
it is exactly the seam at which the store's identity will attach.

### Due-ness is delegation, and the delta says so normatively

The obvious way to write the third requirement is "a commitment on a weekday-set schedule is due when
…", once per shape. That would be three requirements restating `schedule`'s, and a fourth arriving
with #11. The delta instead states delegation itself as the requirement — *exactly when the schedule
it carries is due, adding nothing and taking nothing away* — and uses one scenario per existing shape
as evidence that the delegation reaches through, choosing for each the case a shortcut would break:
the day-of-month scenario is a short-month clamp, not a plain hit, and the every-N-days scenario is
the start-date boundary.

Two scenarios in that requirement are about what does *not* enter the rule rather than what does:
identical answers from two commitments whose names differ, and a schedule due on no date answering
rather than erroring. Both are cheap to write and are the ones that would otherwise be discovered by
a screen.

### The blank-name refusal, and what it deliberately does not do

Refusing a name that is empty or all whitespace follows the engine's established stance — `30
February` is refused rather than adjusted, `0` is refused as a day of the month, `0` is refused as an
interval — and it is the same kind of refusal: a value that names nothing is not formed. It costs one
guard, measured above.

What it does not do is normalise. That is question 2 of the round below, so the argument is there
rather than settled here. A third reading was considered and is not offered to the owner: *refuse a
name with leading or trailing whitespace outright*. It is the purest "refuse, never adjust" answer
and it is user-hostile — a stray space typed on a phone would reject the whole commitment — so it is
recorded as rejected rather than put to a vote.

There is no upper bound on length, no script restriction and no reserved name. A bound would be a
number nobody can defend, and the place that can defend one is the text field that eventually accepts
the name.

## Risks / Trade-offs

- **A weekday-set or day-of-month commitment created today is due on every matching date back to
  1583, and an unticked due day reads as a miss.** → This is question 1 of the round, raised rather
  than decided. The recommendation is that it stays out of this type and is answered where creation
  time is actually known; the delta is written that way, and the requirement prose says in as many
  words that a commitment has no start date of its own, so the omission is visible as a decision
  rather than as a gap. #10 answered the same question for the interval shape alone and explicitly
  left the general case open; this Story is where it stops being deferrable in silence.
- **The blank-name rule is Unicode whitespace, and a name of a single zero-width space (U+200B) is
  accepted** — measured above, it is a format character rather than a whitespace one. → Accepted
  deliberately. Chasing every codepoint that renders as nothing is unbounded and belongs to whatever
  eventually sanitises input, and no rule here misbehaves on such a name: it forms, it reads back
  unchanged, and it is due exactly when its schedule is. Recorded so a reviewer reads it as a chosen
  boundary and not as an oversight.
- **Three scenarios pin value semantics that Swift synthesises, which can read as testing the
  compiler.** → They are not there for the compiler; they are the only observable statement that a
  commitment holds no hidden identity, and they are what fails the day someone adds a `UUID` and
  `==` stops meaning "the same commitment". The requirement is the point; the synthesis is just how
  it happens to be satisfied.
- **#11's weekly quota may not fit `Schedule.isDue(on:)` at all** — a quota of three nights a week
  plausibly needs tick history, which this seam does not take. → Unchanged by this Story and not made
  worse by it: the third requirement is phrased as delegation, so whatever `Schedule` can answer, a
  commitment answers identically, and whatever it cannot answer was already #11's problem. What this
  change does add is one more caller to fix if that seam ever moves, and it is a one-line one.
- **`Commitment` joins the read-back asymmetry.** → Deliberate, argued in § *The seam*, and flagged
  in `proposal.md` § *Impact* for the parking-lot entry, which `spec-author` may not write.
- **A commitment is immutable, so renaming one produces a new value that is not equal to the old.**
  → Correct for a value type and wrong for a record, which is the same trade-off as the identity
  decision and attaches at the same seam. Nothing edits a commitment yet, so nothing is blocked.

## Migration Plan

None. Nothing is stored, no `Commitment` exists outside a test, and the change adds a type without
touching one. `openspec/specs/commitment/spec.md` is created at archive time and no existing spec is
modified, so CI check 2 sees exactly one claimed capability.

## Questions for you

Two, both preferences rather than facts, both of which change the delta. The change folder is written
on the recommended answers, so what is on the table is what a "yes" looks like.

1. **Does a commitment carry a date it begins to exist from?** A weekday-set or day-of-month schedule
   is anchored to the calendar and to nothing else, so a "Gym Mon/Wed/Sat" commitment created this
   afternoon answers *due* for every Monday, Wednesday and Saturday back to 1583. Since an unticked
   due day is what a miss looks like, the day screen would show a history of failures that never
   happened unless something stops it. The every-N-days shape solved this for itself with a start
   date (#10); the other two have no answer, and this is the Story that decides whether the answer
   lives on the commitment.
   - *Recommended:* **no** — a commitment stays a name and a schedule, exactly as #26 and #42 state
     it, and "this did not exist yet" is answered where the creation date is actually known: storage
     and the day screen (#27). Three reasons. It keeps due-ness a pure function of the schedule, as
     ADR-1004 has it. It avoids a second anchor that would sit awkwardly beside the every-N-days
     start date, where a commitment could be gated twice by two dates that disagree. And "when did
     this commitment come into being" is a fact about the record, not about the rule — putting it in
     the value would mean two commitments identical in every visible way are unequal because they
     were created on different days.
   - *If you say yes:* the commitment becomes three things, not two. The first requirement is
     rewritten, a fourth requirement is added — *a commitment is not due before the date it exists
     from* — with roughly four scenarios of its own, including the interaction with an every-N-days
     start date earlier than it, and the seam's initializer grows a third parameter. `CONTEXT.md`'s
     **Commitment** entry, which this grill has just written as *a name and the schedule it runs
     on*, gains the third thing. It is also then an ADR, not just a delta: a second anchor in the
     model is exactly the "surprising to a future reader" case, and `proposal.md` § *Impact* says so.

2. **Is the name stored exactly as typed, or trimmed of surrounding whitespace?** Both readings
   refuse `"   "`; they differ on `" Gym "`. Stored as typed, that is a commitment whose name has two
   spaces in it, and it is *not equal* to one named `"Gym"` — so a list could show what looks like
   the same commitment twice.
   - *Recommended:* **exactly as typed.** The engine's whole stance is to refuse rather than adjust,
     and trimming is an adjustment; ADR-1004 puts normalising at the edges, where the text field is;
     and a name is the owner's own words, which this layer has no business rewriting.
   - *If you say trim:* the second requirement's prose inverts — trim first, then refuse what is
     left empty, which also collapses the blank case into the empty one — the scenario *a name with
     a space at each end is kept as given* becomes *a name with a space at each end is trimmed*, and
     its "different commitment from one named Gym" clause flips to "the same commitment as one named
     Gym". `CONTEXT.md`'s **Commitment name** entry gains the trimming. Nothing else in the delta
     moves, and no other requirement is touched.

## Open Questions

None outstanding for the agent. Two are outstanding for the owner and are the round in
§ *Questions for you* above; when they come back, the answers are folded into the delta, recorded
here as settled, and that section is deleted.

Everything else the grill turned up was a fact rather than a preference, and is closed here or in the
delta:

- *Does a commitment need an identifier of its own?* No — § *A commitment carries no identity of its
  own*. Identity belongs to a store, and which store is still open in `docs/parking-lot.md`.
- *Must commitment names be unique?* Not a question this Story can even state. Uniqueness is a
  property of a collection, and no type here holds more than one commitment. It arrives, if it ever
  does, with the thing that holds a list.
- *May a commitment carry a schedule that can never come due — an empty weekday set?* Yes, and the
  delta requires the answer rather than an error. `schedule` already decided this explicitly for the
  weekday-set shape, and refusing it here would contradict a requirement that has passed G4.
- *Is there an upper bound on a name's length, or a restriction on script or emoji?* No, on all three
  — § *The blank-name refusal*. The emoji case is a scenario because a single emoji is one grapheme
  cluster and is the shape a naive length or character-class check gets wrong.
- *Is the schedule readable back out of a commitment?* Not in this change — § *The seam*, and the
  parking-lot entry of 2026-08-31 that already governs the two shapes with the same asymmetry.
- *Does the seam move, or does `Schedule` change?* Neither. `Commitment` is a new seam because a name
  cannot be observed through the old one, and `Schedule` is untouched — which is why `proposal.md`
  claims one capability and no modified requirements.
- *Does the fourth rule shape (#11) need anything from this delta?* No. Delegation is stated in a
  form that holds for shapes that do not exist yet, so #11 adds a case to `Schedule` and nothing
  here changes.
