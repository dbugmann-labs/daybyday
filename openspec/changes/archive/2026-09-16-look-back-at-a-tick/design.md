## Context

See `proposal.md` § *Why*, and `grill.md` for what was settled. The facts this design turns on:

- `CommitmentsScreen` already holds both stores — it is handed `asOf today` and opens a roster
  store and a record store at the two places a day screen keeps its at — and it re-reads both when
  the app is shown. Nothing else in the kit holds a roster, a history and a today together.
- `Roster.Entry` and `Roster.entries` are internal, and carry `keptUntil` and `isRemoved`. So a
  type in `DayByDayKit` can read a removed commitment's day kept until without a public member on
  `Roster` and without a `commitment` delta, which `grill.md` makes a stop at G4.
- `CalendarDate.daysInMonth`, `adding(days:)` and `days(until:)` are internal; the validating
  `init?(year:month:day:)` is public. Nothing on that type changes.
- `Commitment.isDue(on:)` already applies the kept-from floor and the schedule, kind never
  entering. `History.isKept(_:on:)` already answers what a kept day is for every kind.
- The kit has no month name anywhere. `DayTitle` holds weekday names and `ScheduleWords` holds a
  schedule's English; both are internal tables, and ADR-1022 fixes the pattern.

## Goals / Non-Goals

**Goals:** one value the shell draws, said entirely in the kit's own English, so that every rule a
page shows is a test; a chain of eras read by resemblance and nothing recorded.

**Non-Goals:** what any of it looks like; a weekly quota's weeks (#273) and a number's, a note's
and a total's pages (#274, #276), each of which fills a line this Story leaves empty; any change to
`Roster`, `Commitment`, `CalendarDate` or `History`.

## Decisions

### The seam

```swift
public struct LookBack: Hashable, Sendable
public let LookBack.name: String
public let LookBack.rhythmInWords: String
public let LookBack.keptFromInWords: String
public let LookBack.keptUntilInWords: String?
public let LookBack.whole: String?
public let LookBack.lines: [LookBack.Line]
public enum LookBack.Line: Hashable, Sendable
case LookBack.Line.month(inWords: String, fraction: String?)
case LookBack.Line.rhythmChanged(inWords: String, from: String)
public func CommitmentsScreen.lookBack(at commitment: Commitment) -> LookBack?
```

`LookBackWords`, internal and beside it, holds the twelve month names and composes a month, a day
and a fraction — the shape `DayTitle` and `ScheduleWords` already have, so no public member says
English that nothing else can be asked for.

### The screen answers it, rather than a second screen opening the same places

`CommitmentsScreen.lookBack(at:)` reuses the roster, the record and the today the screen was handed
and has already read. A `LookBackScreen` of its own would open both places a second time, hold a
second answer to "can this be read", and be handed a today the screen beside it might disagree
with. Rejected: a free function over a roster, a history and a date — the shell holds none of the
three, they are all private to the screen, and exposing them to reach a free function is a wider
surface than the one member. `grill.md` fixes today as the screen's; ADR-1004 forbids a clock here.

### A look-back says English, not numbers

Every field is a string the shell draws unaltered, as a rhythm in words and a day title already
are. A caller given `kept: Int, due: Int` could render a percentage; a caller given `"11/12"`
cannot, which is what ADR-1045's line needs to be testable. Rejected: giving both, which would put
the same fact in two places and let them disagree.

### A month with no due day says "0/0", and a month is one line whatever it holds

`grill.md` 2 requires the month be listed. "0/0" is what the counting rule already answers there,
so no second rule is needed and the list reads as calendar time throughout.

### A month any quota era touches says no fraction

`grill.md` 9 and 10 settle a quota era's months and the whole; a month straddling a boundary into a
quota era is the same question one level down, and the same answer: it says no fraction, and the
months either side of it say theirs. A part-month fraction counting only the non-quota days would
be a number no rule in the delta defines. This is the rule's shape applied, not a new decision.

### Two removed commitments that both answer: the nearest one wins

Changing a commitment twice in one day leaves two removed commitments of that name and kind both
kept until yesterday. `openspec/specs/commitment/spec.md` § *A roster supersedes…* guarantees the
superseded one sits immediately behind the one taking its place, so walking the roster's own order
outward from the era in front resolves them in the order they happened. Rejected: refusing to chain
where more than one answers, which would drop a real era for an edge the person cannot see.

### The change line sits above the month the newer era is kept from

Read downward, everything above the line is the newer era alone; the month directly below it is the
one the change happened inside, and the line says the day. Rejected: below that month's line, where
the marker names a rhythm that no month under it runs on.

### Migration

None — additive. No persisted type and no encoding changes; a look-back only reads.

### The shell rides this Story

ADR-1019's three conditions hold: `CommitmentsView`'s entry becomes a `NavigationLink` to a new
`LookBackView` on the stack it is already pushed onto, drawing `LookBack`'s fields and nothing it
decides; the swipes are untouched. It is `tasks.md` § 8, and introduces no behaviour the kit does
not specify.

### The records

ADR-1055, new: a look-back reads eras by resemblance rather than by a recorded link — the roster
holds no link, and adding one is a fifth roster form with a migration. ADR-1045 is amended for the
**whole**: the owner's call, asked twice against the recommendation and reaffirmed, so one fraction
across everything since kept-from stands beside the per-month one and is never a percentage.
`CONTEXT.md` lands **Era**, and amends **Look-back** and **Commitments screen**.

## Risks / Trade-offs

- A chain read by resemblance is wrong in two ways the person cannot see: a commitment removed and
  defined again the same day under the same name and kind reads as one chain, and a later
  correction of a kept-from day breaks one. → Accepted with the decision that chose inference
  (`grill.md` 7); ADR-1055 records the price and what buying it back would cost.
- A commitment kept from long ago walks every day between then and today to count its months. → A
  look-back is opened deliberately, once, on a phone; the walk is a day at a time over years, not
  decades, and nothing on the daily path calls it.
- The whole and the months are counted by one rule, so they cannot disagree — but a later Story
  that gives a quota its weeks must decide what the whole then says. → `grill.md` 10 leaves the
  whole saying nothing for a quota, which is the state #273 starts from rather than a rule it has
  to unpick.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, every question this delta raised was
either settled there or is a consequence of a decision already made — the two recorded above as
decisions, with the rule each follows from — and no residual round is outstanding.
