## Why

`commitment` (#26) can say, for any calendar date, whether the gym is due — and nothing can say
whether you went. That is the whole product missing: DayByDay exists because a record a few days
old that cannot be reconstructed is the failure the owner abandoned other apps over
(`docs/open-questions.md` § *Settled*, 2026-08-29), and today there is no record at all. `record`
(#53) is the capability that holds one, and this is its first Story: the tick itself, as a pure
value in the rule engine, and a history of ticks that answers *was it kept on that day*. Durability
— the record surviving the app being closed and opened again — is the second Story, #56, which is
blocked on this one because it needs a thing to keep.

It is the first type in `DayByDayKit` that holds *state* rather than a rule, which is exactly why it
is worth a Story of its own before any store or screen exists: what a tick is, what it refuses, and
what a history answers are fixed here by requirement, so that the store persists a shape somebody
signed rather than one it invented.

One question in it is a preference rather than a fact and goes to the owner as a **question round**
in `design.md` § *Questions for you*: whether a tick can be taken back in this Story. The change is
written on the recommended answer — yes — and the round says exactly what leaves the delta if he
says no.

## What Changes

- Creates the `record` capability with its first requirements: a **tick** is a commitment and the
  calendar date it was kept on, and nothing else; a **history** holds ticks and answers whether a
  commitment was kept on a date.
- **Makes a tick of a commitment on a day it is not due on unrepresentable.** `CONTEXT.md` § *Tick*
  already says a day on which the commitment is not due takes no tick; this delta makes that a
  refusal at the point the tick is formed, the same refusal that stops 30 February being a date. The
  floor from ADR-1013 comes for free: a date before the day a commitment is kept from is not due, so
  it takes no tick either.
- **Keeps the clock out**, as ADR-1004 requires of everything in the engine. A tick is keyed to a
  calendar date and never to the time it was entered; whether that date is past, today or still to
  come is not something this capability can tell and it does not try — the past is writable all the
  way back to the day the commitment is kept from, and what a screen *offers* is the screen's rule.
- **Fixes that there is at most one tick per commitment per day**, observably: ticking a day twice
  leaves one tick, and two ticks alike in commitment and date are the same tick.
- **Fixes that a history answers from its ticks and nothing else.** A history that has taken no tick
  has kept nothing; a tick of one commitment says nothing about another on the same date; a tick on
  one date says nothing about another date. Asking about a day the commitment is not due on is
  answered — *not kept* — rather than refused.
- **Lets a tick be taken back**, on the round's recommended answer: an untick leaves the history as
  if that tick had never been, every other tick standing, and nothing remembers it happened. Taking
  back a tick that was never there is a no-op rather than an error.
- Adds two public types to `DayByDayKit` beside `Commitment`. `Commitment` and `Schedule` do not
  change: due-ness is asked of the commitment exactly as #42 left it, and this capability adds
  nothing to that answer.
- **Not in this change:** durability, and the SwiftData/GRDB decision `docs/open-questions.md` holds
  open — both are #56; reading the ticks back *out* of a history, which #56 needs and will widen;
  any kind of record other than a tick — a number, a sentence, a running total (B-001..B-004); a
  count of ticks, a streak, or any aggregate over days (`CONTEXT.md` § *Nothing congratulates you*,
  B-007); the weekly quota (#11) and whatever a tick means against it; anything on screen, including
  how far back a screen lets you go (#27, B-016).

## Capabilities

### New Capabilities

- `record`: what a tick is to DayByDay — a commitment on a calendar date it was due on — and how a
  history of ticks answers whether a commitment was kept on a day.

### Modified Capabilities

None. `commitment`'s requirements are untouched: a tick asks the commitment whether it is due and
takes the answer as given, which is the relationship `commitment`'s Purpose already names when it
says a commitment is *"what a tick is eventually recorded against"*. `schedule` is untouched for
the same reason, one step further away. CI check 2 sees exactly one claimed capability.

## Impact

- **Code:** `src/DayByDayKit/Sources/DayByDayKit/` only. Two new files, `Tick.swift` and
  `History.swift`, one public struct each. No change to `Commitment`, `Schedule`, `CalendarDate` or
  the three payload types, no change to `Package.swift`, no new dependency in either language.
- **Specs:** creates `openspec/specs/record/spec.md` at archive time, and touches nothing else.
- **Tests:** twenty-three acceptance tests in a new `Tests/DayByDayKitTests/RecordTests.swift`, one
  per scenario, taken one at a time. The existing sixty-four are untouched and must stay green.
- **ADR:** none. Nothing here is hard to reverse or surprising with `CONTEXT.md` in hand: the refusal
  rule was agreed at the grooming pass, the value-not-store shape is what every type in the engine
  already is, and the storage decision is #56's to write up. `design.md` § *Decisions* says so per
  decision.
- **`docs/open-questions.md`:** two entries are affected, and neither is this change's to write
  (`spec-author` may not touch that file). Under *Open product questions*, **How far back the past
  stays writable** is answered as a consequence rather than a choice: a tick exists exactly where the
  commitment is due, and ADR-1013 already bounds that at the day it is kept from, so the record is
  writable back to that day and no further. Whether a screen offers all of it is #27's (B-016), not
  this capability's. Under *Known gaps*, **A schedule's payload cannot be read back out** grows a
  fourth case: a `History` gives back nothing but a yes or no, and a `Tick` gives back neither its
  commitment nor its date — #56 needs both to persist anything, and widens them in its own delta.
- **`CONTEXT.md`:** two terms added by this grill, **History** and **Untick**. The second stands or
  falls with question 1 of the round.
