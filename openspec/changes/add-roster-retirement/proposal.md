## Why

A roster holds what a person keeps (#101) and it only ever grows. Nothing in the product can stop
keeping a commitment, which is B-013 — *"stop keeping a commitment"* — and the second of the four
Stories `FEAT: commitment` (#26) accepted at G2.

Stopping has to be held somewhere, and #26's G1 already decided where: **on the roster, never on the
commitment.** A `Tick` embeds the whole `Commitment` value and `History.isKept` matches by value, so
a fourth part on `Commitment` would change its identity and orphan every tick already recorded — the
history would read empty the moment anything was retired. ADR-1013 left exactly this open: *"An end
date is not implied and is not decided here. A floor is not a window."* This is the Story that
decides the other side of the window, and ADR-1023 records it.

The thing that makes stopping cost nothing is that a roster remembers it rather than forgets it. A
roster that simply dropped a commitment would take every past day's rows with it: the gym you kept
for two years would vanish from every day you kept it. So the roster keeps the commitment and the
day it was last kept, hides it from what a person keeps, and answers for any date what it was
keeping then. That is what "no longer due and no longer listed, while every past day answers exactly
as it did" costs.

## What Changes

- A roster stops keeping a commitment it holds, from a calendar date it is told: the day the
  commitment was **kept until**. It reports whether it stopped, exactly as adding reports whether it
  added.
- A commitment the roster has stopped keeping leaves the commitments a person keeps. It is still
  held: the roster remembers it and the day it was kept until, and it keeps the position it was
  taken on in.
- A roster answers, for a calendar date, which commitments it had not yet stopped keeping on that
  date, in the order they were taken on — the requirement #101 deferred to this Story. A commitment
  kept until a day is in that answer on that day and on every day before it, and out of it from the
  next day onwards.
- The roster judges that date against a day it was told and against nothing else. It still never
  asks what day it is, and it still adds nothing to a commitment's own answer: whether a commitment
  is due, and the day it is kept from, stay the commitment's (ADR-1004, ADR-1013).
- Stopping refuses in exactly two cases and reports both: a commitment the roster does not hold, and
  a commitment it has already stopped — whose day, once given, does not move. It refuses on no date
  at all, so a commitment stopped on a day before the day it is kept from is accepted and is one the
  roster was never keeping on any date, which is what changing your mind before starting looks like.
- Adding a commitment equal to one the roster has stopped keeping is still refused, because the
  roster still holds it. Taking the same thing up again is a commitment kept from a different day,
  which is a different commitment, and it is added.
- **Not breaking, but not purely additive.** Two of #101's requirements are MODIFIED: what a roster
  reads back is now what it has not stopped keeping, and the word "holds" is made to say which of
  the two readings it carries. Every scenario signed at #101 is restated unchanged and none of them
  changes its answer.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: two MODIFIED requirements — *A roster holds the commitments a person keeps, in the
  order they were taken on* (it now also holds the day a stopped commitment was kept until, reads
  back only what it has not stopped keeping, and is asked about dates) and *A roster refuses a
  commitment it already holds* (a stopped commitment is still held, and what "refuses nothing else"
  covers is scoped to what it is offered to add). Two ADDED requirements — a roster stops keeping a
  commitment from the day it was kept until, and a roster answers which commitments it had not
  stopped keeping on a calendar date.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/Roster.swift` — widened. `commitments` becomes a computed
  property over storage that carries a kept-until day beside each commitment; two members are added,
  `retire(_:keptUntil:)` and `commitments(on:)`. No other file in the package changes and nothing
  existing becomes public: `Commitment.keptFrom` and `Commitment.schedule` stay internal, and the
  known gap about a schedule's payload not reading back is untouched.
- `src/DayByDayKit/Tests/DayByDayKitTests/RosterTests.swift` — widened. One acceptance test per new
  scenario, added to the 205 passing at `ab7ef41`. The thirteen tests #101 wrote are restated by two
  MODIFIED requirements and must go on passing unedited; one of them going red is a rule-5 stop.
- `src/DayByDay` — untouched. The shell still hands `DayScreen` a hand-written `dayOneCommitments`
  array and has never held a roster; `Roster` has no caller outside its tests. Feeding a day screen
  from a roster is #104's and is a `day-screen` delta, so a second Story (rule 5).
- `CONTEXT.md` — one new term, **Kept until**, and § *Roster* amended to say what it holds and what
  it now answers about a date.
- `docs/adr/1023-a-commitment-is-kept-until-a-day-the-roster-holds.md` — new. `1022` is already
  claimed on `origin/story/92-add-screen-date`, so this Story takes the next number that no file and
  no open branch has used.
- `docs/open-questions.md` — untouched. This Story opens no gap and closes none.
