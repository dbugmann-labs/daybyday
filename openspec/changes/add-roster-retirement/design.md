## Context

`DayByDayKit` exports seven seams today: `Schedule.isDue(on:)` (#8–#11), `Commitment` (#42),
`Tick`/`History` (#55), `RecordStore` (#56), `DayView` (#70, widened by #71 and #72), `DayScreen`
(#91) and `Roster` (#101, merged yesterday at `ab7ef41`). Motivation is in `proposal.md`; the
behaviour contract is `specs/commitment/spec.md` and is not repeated here.

This is the second of the four Stories #26's G2 accepted on 2026-09-03 — #101, then this one, then
`add-roster-store` (#103) and `add-commitments-screen` (#104) — serialised because all four target
the same capability.

**Measured on this machine on 2026-09-03 rather than recalled.** `cd src/DayByDayKit && swift test`
reports **205 tests passing at `ab7ef41`**, thirteen of them in `RosterTests.swift`, on Apple Swift
6.3.3 (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`; `openspec` is 1.10.0 and
`node --version` is v24.19.0. **No scenario in this delta asserts that anything is due**, so no
weekday is claimed anywhere in it and none needed measuring — the roster judges no schedule, which
is what § *The roster subtracts only what it knows* argues for. The two dates at the edge of the
supported range are `openspec/specs/schedule/spec.md`'s and are consumed rather than restated:
`CalendarDate.init?` guards `(1583...9999).contains(year)`, so 1 January 1583 and 31 December 9999
are the two ends this delta names.

Facts read out of the shipped sources rather than assumed:

- **`Roster` today is three members**: `init()`, `public private(set) var commitments: [Commitment]`
  and `mutating func add(_:) -> Bool`, over a plain `[Commitment]`. `Roster.swift` is twenty lines.
- **Nothing outside its tests calls it.** `grep -rn "Roster" src --include="*.swift"` names
  `Roster.swift` and `RosterTests.swift` and nothing else; `ContentView.swift` still builds
  `dayOneCommitments` by hand and hands it to `DayScreen`. So widening `Roster`'s surface breaks no
  caller, and there is nothing in the app that a mistake here could reach.
- **A tick embeds the whole commitment.** `Tick` holds a `Commitment` and a `CalendarDate`, and
  `History.isKept` re-forms a tick and tests set membership. Nothing a roster does is visible to a
  history, which is exactly what makes stopping cost nothing — and what would have been destroyed by
  putting a kept-until day on `Commitment`, whose `Hashable` is synthesised over all three parts.
- **`CalendarDate` is not `Comparable` and its parts are internal.** Ordering inside the module goes
  through `days(until:)`, as `Commitment.isDue(on:)` does. A roster living in the same module needs
  no widening for that, so this Story does not touch the known gap about a payload not reading back.
- **A property and a method may share a base name in Swift.** Verified by compiling a throwaway
  file with both `var commitments: [String]` and `func commitments(on:) -> [String]` on one struct:
  `swiftc` accepts it and both resolve. So `commitments` and `commitments(on:)` can sit side by side
  and the seam needs no invented second noun.
- **`1022` is taken.** `git ls-tree origin/story/92-add-screen-date docs/adr/` lists
  `1022-the-day-is-said-in-the-apps-own-words.md`, on a branch that has not merged. `docs/adr/README.md`
  says a number is never reused and that claiming one means checking the branches, so this Story
  takes **1023**.

## Goals / Non-Goals

**Goals:**

- Stopping costs the record nothing: every date before the day a commitment was kept until answers
  exactly as it did, and every tick already recorded stands.
- The roster's obvious member is the safe one. `commitments` answers "what do I keep", which is what
  a screen listing them wants and what `CONTEXT.md` § *Roster* already says it is.
- One new rule and no second copy of an old one. The roster judges retirement; the commitment goes
  on judging its own floor and its schedule.
- A report for every refusal, matching what #101 settled for adding.
- Nothing new made public that the delta does not observe, and no existing member widened beyond the
  two this delta adds.

**Non-Goals:**

- **Holding a span, or several of them.** A roster holds at most one kept-until day per commitment.
  Taking a commitment up again clears that day rather than opening a second window, so a roster
  cannot say "kept January to March and again from June". Nothing has asked for that, and it is a
  much larger model. See § *Offering a stopped commitment again takes it up where it left off*.
- **Changing a commitment's name or rhythm.** B-014, out of this Feature by #26's G1.
- **Keeping a roster across the app being closed.** #103. Nothing here is encoded or given a place,
  and no version number is written. #103 will need to read the kept-until day back out of a roster;
  it lives in the same module and can widen internal access without a delta, exactly as
  `RecordDocument` reads `Commitment`'s internal members today.
- **Any screen.** #104. What the list of what you keep looks like, where the "stop keeping this"
  control is, whether it confirms first, what date it passes, and what it says when an addition is
  refused are all the screen's.
- **Feeding `DayView` or `DayScreen` from a roster.** Both take `[Commitment]` and keep taking it.
  Changing either is a delta against `openspec/specs/day-screen/spec.md` — a second capability, so a
  second Story (rule 5) — and it is #104's.
- **Telling a person what they used to keep.** #26's G1 answered that a retired commitment is hidden
  from the list of what you keep. Nothing in this Story lists stopped commitments, and nothing asks
  for a screen that does.
- **Deciding anything about ticks.** A stopped commitment's ticks stand, untouched and unreachable
  from here.

## Decisions

### The seam

**The existing `Roster`, widened by two members.** `AGENTS.md` prefers an existing seam and this is
one: the type this Story changes is the type #101 shipped, and #26's G1 already decided that
stopping belongs to whatever holds the set.

```swift
public struct Roster: Hashable, Sendable {
    /// A roster holding no commitments.
    public init()

    /// The commitments this roster keeps, in the order they were taken on. A commitment it has
    /// stopped keeping is not among them.
    public var commitments: [Commitment] { get }

    /// Adds `commitment` after every commitment already held, and answers `true`. When this roster
    /// holds it stopped, takes it up again in the place it has — clearing the day it was kept
    /// until — and answers `true`. Answers `false` and changes nothing when this roster is already
    /// keeping it.
    public mutating func add(_ commitment: Commitment) -> Bool

    /// Stops keeping `commitment` as of `date`, the last day it was kept, and answers `true`.
    /// Answers `false` and changes nothing when this roster does not hold it, or has already
    /// stopped keeping it.
    public mutating func retire(_ commitment: Commitment, keptUntil date: CalendarDate) -> Bool

    /// The commitments this roster had not stopped keeping on `date`, in the order they were taken
    /// on. It applies no other rule: a commitment's own day it is kept from and its schedule are
    /// the commitment's answer, not the roster's.
    public func commitments(on date: CalendarDate) -> [Commitment]
}
```

Thirty scenarios observe those four members and roster equality; seventeen of them are new and
thirteen are #101's, restated by two MODIFIED requirements and expected to go on passing unedited.
No process is spawned and no global stream is captured. Nothing else in the package is touched and
nothing existing becomes public.

`commitments` stops being a stored property and becomes computed over storage that carries a
`CalendarDate?` beside each commitment. That is the smallest shape that satisfies the delta:
equality is synthesised over the storage, so it sees both the order and the kept-until days, which
is what two of the new scenarios pin. Neither the storage nor the kept-until day is public — no
scenario observes a retirement day directly, only through `commitments(on:)`, and a member no
scenario observes would be surface for its own sake.

`retire` reads better at the call site than the want's own words do — `roster.retire(gym, keptUntil:
day)` against `roster.stopKeeping(gym, keptUntil: day)` — and it is the word #26's G1 comment uses
throughout. The spec keeps saying "stops keeping", because that is what the person is doing.

### The day is held by the roster, never by the commitment

**Decided at #26's G1 and recorded here as ADR-1023**, because it is the decision the whole Story
rests on and ADR-1013 explicitly left it open: *"An end date is not implied and is not decided here.
A floor is not a window."*

The symmetric alternative — a `keptUntil` on `Commitment` beside `keptFrom` — is the one a reader
expects, which is exactly why it is worth writing down that it loses. `Tick` embeds the whole
`Commitment` value and `History.isKept` matches by value, so adding a fourth part changes the
identity of every commitment the moment it is stopped: every tick already recorded is keyed to the
old value, `isKept` answers `false` for all of them, and the person's history reads empty. That is
the record this product exists not to lose, destroyed by a field. Held by the roster instead,
stopping is invisible to a tick and every past day answers exactly as it did.

The cost is the asymmetry a reader trips over — one end of a commitment's life on the commitment,
the other on the roster — and it is what the ADR is for.

### The kept-until day is the last day it was kept

**Chosen: inclusive.** A commitment kept from A and kept until B is one the roster was keeping on
every date from A through B, B included, and on no date after B.

*Alternative — exclusive, "stopped from this day", so the day named is the first day it was not
kept.* It is the tidier mirror of `keptFrom` and it makes a half-open span, which is what most
interval code wants. It loses on what it does to a day already lived: a screen stopping a commitment
would pass today, and today's day view would lose that commitment's row — including when the person
had already ticked it that morning. A real tick would stop being visible on the day it was made,
which is precisely the failure `CONTEXT.md` § *Record* names. Inclusive cannot do that: the last day
kept is a day whose row and tick both stand, and only tomorrow is clear.

The cost of inclusive is a person who quits in the morning: today keeps an unticked row for a
commitment they have already stopped, and an unticked due day is what a miss looks like (ADR-1013).
That is a real miss on a day they had committed to, rather than a fabricated one, which is the
distinction ADR-1013 turns on — but it is a preference about their own record, so it was put to the
owner as question 1 of the round raised at this grill. **Answered on 2026-09-03: the last day kept, as
recommended.** Nothing in the delta moved; the boundary sentence, the parameter's name and the three
scenarios that name dates stand as written, and the owner accepts that quitting on a Monday morning
leaves Monday showing an unticked row.

Either answer would have been one word of arithmetic apart at the seam; nothing else in the design
would have moved.

### `commitments` answers "what do I keep", so a stopped commitment leaves it

**Chosen: `commitments` reads back only what the roster has not stopped keeping.**

`CONTEXT.md` § *Roster* already says a roster "is the answer to 'what do I keep'", and #26's G1
answered that a retired commitment is hidden from that list. The member with that name should
therefore be the hidden-from list, so that #104 reaching for the obvious member gets the right
answer and cannot show a stopped commitment by forgetting something.

*Alternative — `commitments` keeps meaning everything ever held, and a second member answers what is
still kept.* It costs one MODIFIED requirement instead of two, because the phrase "reads them back
in that order" would not move. Rejected on the shape of the mistake each makes possible: under this
design the wrong member is the one nobody would reach for, and under the alternative the wrong
member is the one everybody would. It would also need a second noun for "the commitments you keep",
and the two candidates both collide — `kept` is what `History.isKept` means (ticked), and `current`
says nothing.

A stopped commitment is still *held*: it keeps its position, it is in the answer for every date up
to the day it was kept until, and an addition equal to it is refused. That is what makes the word
"holds" carry two readings after this Story, and it is why the second MODIFIED requirement exists
rather than being left for a reader to work out.

### The roster subtracts only what it knows

**Chosen: `commitments(on:)` filters on the kept-until day and on nothing else.** A commitment kept
from a date later than the one asked about is still in the answer.

The alternative — apply the commitment's own kept-from floor here too, so the answer reads "what I
was keeping then" without qualification — is tempting and would make the member's name exactly true.
It is rejected because it puts ADR-1013's floor in a second place. Every consumer of this answer
hands it to a `DayView`, which asks each commitment `isDue(on:)` and gets the floor there; a roster
that also applied it would make "is this owed" a question two types answer, which is the split
ADR-1013's *Alternatives considered* rejected in as many words. One rule, one place, and the roster
adds nothing to a commitment's answer — the same discipline #42 set when a commitment delegated to
its schedule.

The requirement says this out loud rather than leaving the name to imply it, and a scenario pins it.

### A day once given does not move, and stopping refuses twice

**Chosen: `retire` refuses a commitment the roster does not hold, and one it has already stopped;
it refuses on no date at all.**

Refusing a second stop keeps every date's answer about a stopped commitment fixed for as long as it
stays stopped, which is ADR-1013's promise that a past day's answer does not change once given.
Letting the second stop overwrite the day would silently move a boundary a person cannot see, and no
screen in this Feature offers to pick a date anyway: #104 passes the day the person tapped on. The
one thing that clears a kept-until day is taking the commitment up again, which is the owner's
answer to question 2 — an act the person performs and is told about, not a day moving by itself.

Refusing on no date is #101's rule kept: *"it MUST NOT refuse on a date"*. It matters concretely
rather than for symmetry — a commitment kept from next month, stopped today, is a person changing
their mind before starting, and it must work. It leaves a commitment the roster was keeping on no
date at all, which is the honest answer and not an error.

Both refusals are reported, for the reason #101 already settled: doing nothing silently is
indistinguishable from having done the thing.

### Offering a stopped commitment again takes it up where it left off

**Chosen: `add` takes up a commitment the roster had stopped, in the place it already has, and
reports it as kept. Decided by the owner on 2026-09-03, against this Story's recommendation** —
question 2 of the round raised at this grill, and the reason this section is written the way round
it is. Both answers are recorded under § *Open Questions*.

Offering a commitment the roster holds stopped drops the kept-until day, so the commitment is back
among what the roster reads back, in the position it was taken on in, with the same history and no
second copy of it. Nothing new is added to the seam: `add` is the way, and its report keeps one
meaning — *the roster now keeps this commitment*.

The cost, which is real and was put to the owner as the reason to refuse instead: every date between
the stop and the taking-up goes back to answering that the commitment was being kept, because a
roster holds one kept-until day and no span. The delta says so out loud in both requirements rather
than leaving it to be discovered. What makes it acceptable is what does *not* change with it — every
tick already recorded stands, so what a person actually did on those days is exactly as it was, and
the gap shows up where a gap belongs, as days that were never ticked.

*Alternative — refuse, so that starting again is a commitment kept from the day you restart.* It
keeps every past date's answer fixed forever, which is the promise the rest of this Story is built
on. Rejected by the owner because it leaves a mis-tapped stop with no way back at all until a screen
offers one, and because the commitment that came back would be a different commitment: a new place
at the end of the order, and a fresh history beside the old one that nothing would ever join up.

*Alternative — hold a span per commitment, so a lapse is remembered.* It is the only shape that
answers both dates correctly. Rejected as much more model than any want asks for, and it is not
foreclosed: the days between are answerable from the ticks if a want ever appears.

### ADR-1023, and no second ADR

`docs/adr/README.md` asks for hard, expensive to reverse, or surprising. One candidate clears all
three: **the day a commitment is kept until is held by the roster and not by the commitment.** It is
expensive to reverse (moving it onto `Commitment` orphans every tick already recorded), surprising
(one end of a commitment's life sits on the commitment and the other does not), and a real
trade-off with a rejected symmetric alternative. It is also the half ADR-1013 explicitly left open,
so it is a new record rather than an amendment: nothing in ADR-1013 changes, and ADR-1023 says so.

The others fail a bar. *Inclusive kept-until* is one word of arithmetic to reverse. *`commitments`
hiding stopped commitments* follows from a sentence already in `CONTEXT.md`. *Refusing a second
stop* is derived from ADR-1013 rather than deciding anything new. *Taking a commitment up again by
offering it* is a consequence of the roster holding the day rather than a decision of its own, so it
is a bullet under ADR-1023's *Consequences* — amended when the owner answered question 2 — and not a
record of its own.

The vocabulary this Story settles lands in `CONTEXT.md` as **Kept until**, with § *Roster* amended.

## Risks / Trade-offs

- **Taking a commitment up again rewrites what the days between answer.** → Real, and the owner's
  decision on question 2 with the trade in front of them. A roster holds one kept-until day, so a
  commitment taken up again reads as kept throughout, including the days it was stopped for. It
  reaches no further than `commitments(on:)`: every tick stands, so a day inside that gap still
  shows exactly what was done on it, and an unticked due day still looks like the miss it was. Two
  requirements state it and two scenarios pin it, so no later reader meets it as a surprise.
- **A mis-tapped stop is undone by offering the commitment again, and only by that.** → Nothing on a
  screen says so until #104, and a person who has lost the row has nothing to tap. Mitigated where
  it belongs: #104 owns whether stopping confirms first and how something stopped is taken up again.
  What this Story guarantees is that the way back exists and costs the commitment neither its place
  in the order nor its history.
- **After this Story "holds" means two things.** → A roster *holds* a stopped commitment and does
  not *read it back*. Both MODIFIED requirements say which reading they carry, at the price of
  restating thirteen signed scenarios that do not change. Left implicit it would be a reviewer's
  finding on every later Story that touches the word.
- **Two MODIFIED requirements are read as a diff of a delta file, not of the spec.** → G4 sees the
  whole requirement as added text and has to compare it against `openspec/specs/commitment/spec.md`
  by hand. Mitigated by changing only what had to change, and measured rather than claimed:
  `git diff --no-index` between the two requirements as they stand in
  `openspec/specs/commitment/spec.md` and as they are restated here is **nine changed or added
  paragraphs and two new scenarios** across the pair, and all thirteen restated scenarios are
  byte-identical. Re-measured on 2026-09-03 after the owner's answers were folded in.
- **Thirteen existing tests must keep passing unedited.** → They are the evidence that this delta
  modifies wording and not behaviour. One of them going red is a rule-5 stop, not a test to fix, and
  `tasks.md` says so.
- **`commitments` becomes computed, so it is O(n) per read.** → A person keeps single-digit
  commitments; `dayOneCommitments` is eight. Not worth a cached copy that could disagree with the
  storage.
- **Nothing can reach a stop from the phone until #104.** → True and deliberate, exactly as #101's
  roster is reachable only from a test. #26's G2 serialised the four for this reason, and nothing
  built here becomes wrong when the screen lands.
- **A stopped commitment's ticks are unreachable but not gone.** → `History` still answers `isKept`
  for it, and a day view of a date inside its kept span still shows the row. After the day it was
  kept until there is no row and so no way back to those ticks from a screen. That is what stopping
  means, and B-007's "look at one commitment on its own" is where it would be looked at again.
- **This Story writes the second half of ADR-1013's window without ADR-1013 moving.** → Deliberate:
  ADR-1013 says the end date is not decided there, so nothing in it becomes wrong. A reader who
  finds only ADR-1013 finds a sentence pointing at the open half; ADR-1023 names ADR-1013 in return.

## Open Questions

**None.** Two questions in this grill were preferences whose answers change the delta, so they went
to the owner as a question round rather than being decided here. **Both were answered on 2026-09-03
and are folded into the delta**; the round itself is gone from this document, and the two answers
are the first two entries below. Every other question was a fact read out of the shipped sources,
measured on this machine, or a decision made in § *Decisions* with its alternatives written down.
The ones that were asked and answered:

- *Does the day you stop still count as a day you kept it?* — **yes, it is the last day kept.**
  Asked as question 1 and answered as recommended, so nothing in the delta moved. A roster answers
  with a commitment on the day it was kept until and with nothing from the next day on; a tick made
  that morning stays visible on the day it was made, which is what `CONTEXT.md` § *Record* is
  written against. The accepted cost is that quitting in the morning leaves that day showing an
  unticked row that will never be ticked.
- *Is a stopped commitment, offered again exactly as it was, refused or taken up again?* — **taken
  up again**, answered as question 2 **against this Story's recommendation**. `add` clears the
  kept-until day, the commitment returns in the place it was taken on in with its history intact,
  and the report says the roster now keeps it. The price the owner accepted is that the dates
  between the stop and the taking-up go back to answering that the commitment was kept, because a
  roster holds one kept-until day and no span — stated in both requirements, pinned by two new
  scenarios, and reaching no further than `commitments(on:)`, since every tick stands. What it buys
  is a way back from a mis-tapped stop that keeps the commitment's place in the order and its
  history rather than starting a second one beside it. § *Offering a stopped commitment again takes
  it up where it left off*, and ADR-1023's *Consequences*, both record it.

- *Is stopping a fourth part of a commitment or a thing the roster holds?* — the roster's, decided at
  #26's G1 and recorded here as ADR-1023. Read out of `Tick.swift` and `History.swift`: a tick
  embeds the whole commitment value and `isKept` matches by value, so a fourth part empties the
  history the moment anything is stopped.
- *Does stopping need a day at all, or is a flag enough?* — a day. Without one, "no longer listed"
  and "every past day answers exactly as it did" cannot both hold: a roster that forgot a stopped
  commitment would take its rows off every day it was ever kept on.
- *Is this a new seam?* — no. `Roster` shipped at `ab7ef41` and this Story widens it by two members.
  An existing seam beats a new one, and nothing outside `RosterTests.swift` calls it, so widening
  breaks nothing.
- *Can a Swift struct have both a `commitments` property and a `commitments(on:)` method?* — yes,
  verified by compiling one. So the seam needs no invented second noun.
- *Which requirements does this change, and which does it only add to?* — checked requirement by
  requirement against `openspec/specs/commitment/spec.md`. The four requirements about a single
  commitment (#42's) do not move at all: nothing about a commitment's identity, its name rule, its
  delegation to a schedule or its kept-from floor changes, and this delta must not touch them or it
  would be the very change ADR-1023 rejects. #101's two are both MODIFIED, for the reasons in
  § *`commitments` answers "what do I keep"*.
- *Do any of #101's thirteen scenarios change their answer?* — no. Each was re-read against the new
  behaviour: none of them stops a commitment, so each observes a roster in which nothing has been
  stopped, where every member behaves exactly as it did. They are restated byte-identically and
  their tests are expected to pass unedited.
- *Does `commitments(on:)` need the commitment's kept-from floor?* — no, and it must not have it.
  § *The roster subtracts only what it knows*.
- *What does the roster answer for a date before a commitment was added?* — the same as for any
  other date. A roster holds no record of the day a commitment was added — #101 forbids one — so
  there is nothing to answer differently with, and a commitment's own floor is what keeps it from
  being *due* then. A scenario pins it.
- *Does taking a commitment up again need a member of its own — an `unretire` or a `resume`?* — no.
  Offering the commitment is the act, and `add` already takes a commitment and answers whether the
  roster now keeps it. A second member would be a second way to say the same thing, and a screen
  that could reach only one of them would be able to get it wrong.
- *Should a stopped commitment be readable back — its day, or a list of what you used to keep?* — not
  in this Story. #26's G1 answered that retired commitments are hidden, no want asks to browse them,
  and a member no scenario observes is surface for its own sake. #103 needs the day to persist it and
  can reach it internally without a delta, as `RecordDocument` already reaches `Commitment`'s
  internal members.
- *Does stopping change what a history answers?* — no, and it must not. `History` never sees a
  roster. A scenario would have to reach across two capabilities to assert it, so the requirement
  states it and `day-screen` is where it becomes visible, in #104.
- *Does this Story touch a second capability?* — no. `DayView` and `DayScreen` keep taking
  `[Commitment]`, `src/DayByDay` is not edited, and the delta is one capability's.
- *Which ADR number is free?* — 1023. 1022 is claimed on `origin/story/92-add-screen-date`, which
  has not merged; `docs/adr/README.md` requires checking the branches and not just `main`.
- *Is "kept until" the right word?* — yes: it pairs with **Kept from**, which `CONTEXT.md` already
  defines and ADR-1013 named, and it says the inclusive thing the recommendation means. "Retired" is
  the verb #26's G1 uses and is the seam's method name; "stop keeping" is the owner's own phrase from
  B-013 and is what the spec says. Three words for one idea is one too many, so `CONTEXT.md` defines
  **Kept until** and says the other two are the verb for it.
