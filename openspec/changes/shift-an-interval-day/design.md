## Context

See `proposal.md` § *Why*, and `grill.md`, whose seven settled answers and the upstream decisions
it carries this delta is written on. The facts it turns on, read off `origin/main` at c6b119d:

- **`Commitment.isDue(on:)` is the one dueness answer** (ADR-1066): an origin answers not due, a
  landing due, every other date its schedule. `.everyNDays(_, from:)` carries its own start date;
  `Roster.shift` refuses every N days; `Shift.couldBe` is the one-week rule, asked when a shift is
  made and when either store is read.
- **A change puts a new era on with `Rhythm.schedule(keptFrom:)`**, which starts an interval on the
  era's own first day, whatever changed. A day-kept-from move rebuilds the earliest era the same way.
- **The record store writes `shiftedFrom` beside a record on a landing day only**, and re-forms each
  record through `isDue`; a record that does not form refuses the whole store. `RecordStore`
  judges `shiftedFrom` against the declared form; record form 7, roster form 8.
- **`DayScreen.shiftDays(for:)` asks `Roster.shift` on a copy for each other day of the row's
  week**; it reads the history for the row's own day only. `History.datesRecorded(for:)` exists.
- **The shell composes no words**: `ContentView` draws `ShiftDay.words` and `rhythmInWords` as
  given, so nothing in this delta needs `src/DayByDay/` to change.

## Goals / Non-Goals

**Goals:** the delta, every rule drivable through the members in § *The seam*, and the walk.

**Non-Goals:** retiring restart (#394); changing #392's rules for a weekday set or a day of the
month, Settled 1 included; repairing eras a range or target change already re-anchored (settled 5);
any mark of a shift in a look-back.

## Decisions

### The seam

```swift
public func Commitment.isDue(on date: CalendarDate) -> Bool
public mutating func Roster.shift(_ commitment: Commitment, from day: CalendarDate, to other: CalendarDate) -> Bool
@discardableResult public func RosterStore.shift(_ commitment: Commitment, from day: CalendarDate, to other: CalendarDate) throws -> Bool
public func DayScreen.shiftDays(for row: DayView.Row) -> [DayScreen.ShiftDay]
public func DayScreen.shift(_ row: DayView.Row, to date: CalendarDate) throws
public var DayView.Row.rhythmInWords: String { get }
public func CommitmentsScreen.change(_ commitment: Commitment, toName name: String, on rhythm: Rhythm, keptFrom: CalendarDate, under category: String?, lowest: String?, highest: String?, target: String?, usualAmounts: [TypedUsualAmount]?) -> Refusal?
public RecordStore.init(at place: URL) throws
```

No member is new; each keeps its signature and answers more. Look-back scenarios drive
`CommitmentsScreen.lookBack(at:)` as they do today.

### A shift runs an interval's count on from where it landed — ADR-1066, amended

The shift map stays as it is; `isDue` reads it once more on an every-N-days schedule, counting from
the latest landing on or before the date whose origin is on or after the schedule's start date. The
origin bound keeps a shift made under an older count out of a new interval's count (N changed), and
lets it through a range change that carries the count. The record store writes beside a record on a
later day of that count both days of the shift it counts from, so the record re-forms alone.
- *A shift stored as an era begun where it landed:* rejected — the origin still needs the map to say
  where it went, each shift draws an era boundary, and it reads as a later change to the next shift.
- *The era's start date rewritten to the landing:* rejected — every due day before it moves under
  records already kept.

### Where each bound is judged

The roster judges the window, the era, the origins and landings of other shifts, and Settled 1's
later shift or later era: it holds all of them. A record on a later day is the day screen's, which
already refuses a row whose own day holds one, reading the history the roster does not have. A
stop is not a later change: the landing must be held by the era, so a stopped commitment's due day
moves only inside the days it ran, which undoes nothing.
- *A stop as a later change:* rejected — it refuses the harmless shift back before a stop and adds
  nothing the era bound does not give.

A landing is shifted inside the bounds of the day it came from, as #392's landing keeps its origin;
its own neighbours would let a due day creep a whole interval per reshift. Settled 1 is every N
days' alone: it was asked against restart's rule, which only every N days had, and a weekday shift
moves nothing after it, so #392's rules for the other two shapes are carried word for word.

### The count carries through a range or target change

`change` builds the new era on the current schedule, start date included, where the rhythm asked
is the interval the newest era already runs; any other rhythm still goes through
`Rhythm.schedule(keptFrom:)`. It is an ADDED requirement: the change requirement says nothing of a
new era's start date, so nothing in it is falsified, and carrying its 386 lines buys nothing. The
mend never joins the two eras, whose kinds differ; a change back is shipped behaviour.

### Shipped text the delta falsifies, and the words

`commitment`'s weekday-set shift requirement refuses every N days in a scenario, and a MODIFIED block
cannot drop a scenario (`openspec validate`), so it is REMOVED and ADDED again under a narrower name,
every other scenario verbatim. The roster-holds requirement cites its title, so it is MODIFIED for
that cross-reference alone. Every-N-days words are `DayTitle.weekdayNames`, the day and
`LookBackWords.shortMonthNames`, composed in the Kit by the shape of the era holding the row's day.

### What the shell draws

Option A, *In the rhythm's place*, #392's, from https://claude.ai/artifact/CXzkYmYUjNUXZGbiBRs3P8,
which `grill.md` § *Layout* names; this Story's words are settled 7's. The diff does not reach the
shell, but the walk does and is read against it.

```
A · In the rhythm's place            (recommended)
  Tuesday — landing day
  │ Gym  - from Mon                          │   unticked: no mark
  │ ~~Gym~~ - from Mon                     ✓ │   ticked: grey struck name, green check
  Monday — origin day, paged back
  │ Gym  - to Tue                            │   whole row faded (0.5), no tap

Shared · long press on Monday's Gym row (walk state 1)
  │ Gym  - Mon, Wed, Sat                     │  ← row lifted
  ┌──────────────────────┐
  │ Shift to           › │ → ┌──────────┐
  └──────────────────────┘   │ Tue      │   free days of this week only:
                             │ Thu      │   not Mon/Wed/Sat, not in a gap
                             │ Fri      │
                             │ Sun      │
                             └──────────┘
```

### Migration

The record form moves from 7 to 8: beside a record on a later day of a shifted count, the day the
shift put its due day on joins the day it took it from; a form-7 store reads as holding none. The
roster form moves from 8 to 9 with no change of shape, so an older app refuses an interval shift as
a later form rather than read it as a weekday one. Its week rule now spares a shift where an era
holding either day runs every N days, or no era holds either — the only reading no later change or
day-kept-from move can turn into a refused store. The copy's form stays 3.

## Risks / Trade-offs

- [A restart picked on or before a shift's origin carries the shift, and its count runs on from the
  landing] → accepted: restart is retired by #394, which this Story blocks.
- [A carried test that relied on a range change restarting the count turns red] → a stop and a
  report, never an edit: the grill found no scenario saying so.
- [A record written without the shift its count runs from refuses the whole record store] → the
  record scenario reads one back; the store's form-against-shape check covers the older form.
- [Identity equality hides a shift] → inherited from ADR-1066; no new comparison is added.
- [Carried requirements were already over the prose budget on `main`] → `check:budgets` warnings
  on them are expected.

## Open Questions

None. `grill.md` § *Left open* is "None.", and writing the delta raised no preference of the
owner's: the stop, the landing's bounds and Settled 1's scope above each follow from a settled
answer, and are recorded as decisions so G4 can overturn them.
