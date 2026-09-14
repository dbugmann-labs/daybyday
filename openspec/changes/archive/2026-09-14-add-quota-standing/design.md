## Context

See `proposal.md` § *Why* and `grill.md`, whose nine settled answers this delta is written on. The
product rule is settled and nothing below re-argues it: the week is Monday to Sunday, the count is
of kept days through the date, it is never capped, and it is answered for any commitment.

Five facts, read off this worktree, decide the shape.

- **`History.isKept(_:on:)` is public and already answers kept for every kind** — a tick, a number,
  a note, and a total whose day's sum has reached its target. The new answer is a count of the days
  it says yes on, and it introduces no second opinion about what kept means.
- **`History`'s four readers take `(for commitment:, on date:)`** and answer about that one date.
  This is the first that answers about a span.
- **`CalendarDate.weekday`, `adding(days:)` and `days(until:)` are internal to the package**, so a
  week can be worked out inside it without widening anything.
- **`adding(days:)` is documented safe at ±1 and not in general**: `Calendar.date(byAdding:to:)`
  saturates rather than failing on an extreme step, so a large step reads back a plausible date
  instead of `nil`. A single-day walk is the case that holds.
- **`Weekday` carries no order and nothing in the package offers a week boundary.** ADR-1034
  refused a week order in the rule engine, and the week stays `record`'s.

## Goals / Non-Goals

**Goals:**

- One answer, one integer, driven at an existing seam, that `say-standing-in-quota-row` (#236) can
  read without being handed a week or a quota.
- A week that is the same on every phone, so a restored history reads the same wherever it lands.
- An answer that is a function of the records and the date alone, so no past day's answer moves.

**Non-Goals:**

- **No pairing with the quota.** The count alone; composing "1/3x a week" is #236's.
- **No week type, no week boundary API, and no order on `Weekday`.** Nothing outside this answer
  needs one, and ADR-1034 is why it does not go into `schedule`.
- **No change to what is stored**, to `isKept`, to any other reader, or to any screen.
- **No answer about whether a quota has been met.** That is a count against a number, and the
  number is the caller's.

## Decisions

### The seam

One existing seam, `History`, gains one public member. Every scenario is driven at it.

- `public func standing(for commitment: Commitment, through date: CalendarDate) -> Int`
- `private static func daysOfWeek(through date: CalendarDate) -> [CalendarDate]` — not a seam, and
  private for the reason under *The week stays inside this answer*.

### `through:` rather than `on:`, and `standing` rather than a longer name

The four readers `History` already has take `on date:` and answer about that one date. This one
answers about a span ending at the date, and the label is where a reader is told: `on:` would read
as "what does this day hold", which is exactly the wrong implementation. The inconsistency is
deliberate and it is the cheaper of the two mistakes.

`standing` is `CONTEXT.md`'s word, landed by the Feature grill before this Story opened.
`keptDaysThisWeek` was rejected: "this week" is the present moment, which nothing in this package
consults.

### The week stays inside this answer

The days of the week through a date are worked out by a private function in `History.swift`, and
neither `CalendarDate` nor `Weekday` gains a member. Two reasons, in order. ADR-1034 refused a week
order in the rule engine and `grill.md` § *Consequences* holds this delta to it: a schedule must not
be able to consult a week. And a `CalendarDate.weekStart` or a `Weekday.ordinal` would be a general
facility with exactly one caller, reachable from every rule shape in the package — the surface the
refusal was about, arriving through the back door.

It walks back one day at a time from the date, at most six steps, keeping each date it passes,
and stops at the Monday. That is the ±1 step `adding(days:)` documents as safe, rather than a
computed multi-day step whose saturation behaviour the same doc comment warns about.

### A week truncated by the calendar is the days that exist

1 January 1583 is a Saturday, so the first week the system can be asked about begins on a Monday
that does not exist. The walk stops where `adding(days:)` answers `nil`, which is the clamp: no
special case, no constant for the first supported date, and the count is of the days that are
there. The last supported date, Friday 31 December 9999, needs nothing — the count never steps
forward past the date it was asked of.

### Counting is `isKept` per day and nothing cleverer

At most seven calls to a function that is already the one answer about kept. The alternative —
walking the stored records and filtering by date range — would re-decide what kept means for four
kinds and would be wrong for a total the day it changed. No index, no cache: a `History` is one
person's records and the walk is bounded at seven.

### ADR-1050 is written and ADR-1015 is amended

ADR-1015 § *Consequences* deferred three things by name to "the first Story that counts ticks within
a week": where a week begins, what happens when one turns, and where "has this week been met?"
lives. This is that Story, and all three are hard to reverse — a different week start re-reads every
past week — so they go into one record, ADR-1050. `1050` is free: no file and no ref in this
repository has ever used it. ADR-1015 keeps its decision and is amended in place where it says the
question is still open, so that a reader is not left with two files disagreeing.

### Migration

None — additive. No persisted type, no document form and no encoding changes; nothing on a phone
reads differently, because the answer is derived from records already kept.

## Risks / Trade-offs

- **A caller reads the count as "kept out of the quota" and caps it.** → The requirement says the
  count is never capped and one scenario asserts a standing of four against a quota of three;
  `CONTEXT.md` § *Standing* says the same. #236 composes the pair.
- **`through:` breaks the shape of the other four readers.** → Taken knowingly above; the
  alternative label describes the wrong behaviour.
- **The most likely wrong implementation is a Sunday-first week**, which agrees with a Monday-first
  one on six days out of seven. → The scenario asked on a Sunday is what separates them, and
  `tasks.md` § 3.3 makes it a stop.
- **The second most likely is a count that runs the whole week rather than stopping at the date.**
  → Two scenarios assert a later day in the same week counting for nothing.
- **Seven `isKept` calls per row per draw**, and a day screen draws one row per commitment. → No
  I/O, no clock, and `isKept` is a set lookup plus a dictionary read. Not paid for in advance.

## Open Questions

**None outstanding, and none deferred.** `grill.md` § *Left open* is "None.", with its reason, and
writing the delta raised no question that needed the owner: every edge it turned up — the truncated
week at 1583, which commitments are answered for, what a kind that is short of its target counts
for — had an answer already on disk, in `grill.md` § *Settled*, in the shipped `record` spec, or in
the code cited in § *Context*. Finding those is this agent's job rather than the owner's.

**There is no `## Questions for you` section on this change**, and no residual round is outstanding:
the Story is at G4 and nothing else. Two judgements were taken rather than sent back, both about
where a settled rule lives rather than about a preference, and both are cheapest to overrule here:
the argument label `through:` (§ *`through:` rather than `on:`*), and keeping the week private to
`History` rather than putting it on `CalendarDate` (§ *The week stays inside this answer*).
